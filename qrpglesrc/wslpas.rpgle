     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLPAS  : Tareas generales.                                  *
      *           WebService - Retorna los Pagos de un Siniestro     *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda                             *28-Abr-2015  *
      * ------------------------------------------------------------ *
      * SGF 28/05/2015: Nueva versión. Paginado y acceso directo a   *
      *                 GAUS.                                        *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * SGF 03/08/2016: Cambio PAHSHP por PAHSHP04 ya que Brienza pi-*
      *                 de que los pagos se listen por fecha de la   *
      *                 liquidación.                                 *
      * SGF 13/08/2016: De acuerdo a lo solicitado por Pablo Alvarez *
      *                 y Giroldi (ver mail de Brienza 12/08/2016 a  *
      *                 las 18:13) no se deben mostrar pagos a provee*
      *                 dores por indemnización.                     *
      *                                                              *
      * ERC 25/11/2020: Si el campo HPMA1='I'y HPMAR2 <> 3, se debe  *
      *                 cambiar el texto el campo pePasi.stdpag.     *
      * SGF 30/07/2021: Recibo de indemnización.                     *
      *                                                              *
      * ************************************************************ *
     Fpahshp04  if   e           k disk
     Fpahscd    if   e           k disk
     Fgnttbe    if   e           k disk
     Fcnhopa    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fgntmon    if   e           k disk
     Fset107    if   e           k disk
     Fcnhric    if   e           k disk

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D WSLPAS          pr                  ExtPgm('WSLPAS')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keypas_t)  const
     D   pePreg                            likeds(keypas_t)
     D   peUreg                            likeds(keypas_t)
     D   pePasi                            likeds(pahstro1_t) dim(99)
     D   pePasiC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPAS          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keypas_t)  const
     D   pePreg                            likeds(keypas_t)
     D   peUreg                            likeds(keypas_t)
     D   pePasi                            likeds(pahstro1_t) dim(99)
     D   pePasiC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SPWLIBLC        pr                  ExtPgm('TAATOOL/SPWLIBLC')
     D   peEnto                       1a   const

     D SPFEDIH         pr                  ExtPgm('SPFEDIH')
     D  peFasa                        4  0
     D  peFasm                        2  0
     D  peFasd                        2  0
     D  peDias                        3  0
     D  pePart                        1a   const
     D  peFasa2                       4  0
     D  peFasm2                       2  0
     D  peFasd2                       2  0
     D  peLaps                        5  0

     D finArc          pr             1N

     D k1hscd          ds                  likerec(p1hscd : *key)
     D k1hshp          ds                  likerec(p1hshp04 : *key)
     D k1ttbe          ds                  likerec(g1ttbe : *key)
     D k1t107          ds                  likerec(s1t107 : *key)
     D k1hopa          ds                  likerec(c1hopa : *key)
     D k1hric          ds                  likerec(c1hric : *key)

     D @@repl          s          65535a
     D fecha           s              8  0
     D @@cant          s             10i 0
     D @@laps          s              5  0
     D x@fasa          s              4  0
     D x@fasm          s              2  0
     D x@fasd          s              2  0
     D @@more          s               n

      /free

       *inlr = *On;
       @@more = *On;

       pePasiC = 0;
       peErro  = 0;

       clear pePasi;
       clear peMsgs;

       SPWLIBLC('P');

       // ------------------------------
       // Valida parámetro base
       // ------------------------------
       if not SVPWS_chkParmBase( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------
       // Valida forma de paginado
       // ------------------------------
       if not SVPWS_chkRoll( peRoll : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------
       // Valida si el siniestro existe
       // ------------------------------
       k1hscd.cdempr = peBase.peEmpr;
       k1hscd.cdsucu = peBase.peSucu;
       k1hscd.cdrama = pePosi.hprama;
       k1hscd.cdsini = pePosi.hpsini;
       k1hscd.cdnops = pePosi.hpnops;
       setll %kds(k1hscd:4) pahscd;
       if not %equal;
          %subst(@@repl:1:2) = %editc(pePosi.hprama:'X');
          %subst(@@repl:3:7) = %trim(%char(pePosi.hpsini));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       // ------------------------------
       // Cantidad de líneas a retornar
       // ------------------------------
       @@cant = peCant;
       if @@Cant <= 0 or @@Cant > 99;
          @@cant = 99;
       endif;

       // ------------------------------
       // Posiciona archivo
       // ------------------------------
       exsr posArc;

       // ------------------------------
       // Retrocede
       // ------------------------------
       exsr retPag;

       exsr leeArc;
       exsr priReg;

       dow not finArc and pePasiC < @@cant;

        if hpmar1 = 'I';
         if hpmar2 <> '3';
           pePasiC += 1;

           k1hopa.paempr = hpempr;
           k1hopa.pasucu = hpsucu;
           k1hopa.paartc = hpartc;
           k1hopa.papacp = hppacp;
           chain %kds(k1hopa:4) cnhopa;
           if %found;
              fecha = (pbfasa * 10000) + (pbfasm * 100) + pbfasd;
              test(de) *iso fecha;
              if %error;
                 pePasi(pePasiC).stfpag  = d'0001-01-01';
               else;
                 pePasi(pePasiC).stfpag  = %date(fecha:*iso);
              endif;
              fecha = (pbfera * 10000) + (pbferm * 100) + pbferd;
              test(de) *iso fecha;
              if %error;
                 pePasi(pePasiC).stfpxs  = d'0001-01-01';
               else;
                 pePasi(pePasiC).stfpxs  = %date(fecha:*iso);
              endif;
              if pastop = '3' and %found(gnttbe);
                 SPFEDIH( pbfasa
                        : pbfasm
                        : pbfasd
                        : g1dia1
                        : 'A'
                        : x@fasa
                        : x@fasm
                        : x@fasd
                        : @@laps );
                 fecha = (x@fasa*10000)+(x@fasm*100)+x@fasd;
                 test(de) *iso fecha;
                 if %error;
                    pePasi(pePasiC).stfcob  = d'0001-01-01';
                  else;
                    pePasi(pePasiC).stfcob  = %date(fecha:*iso);
                 endif;
               else;
                 pePasi(pePasiC).stfcob  = d'0001-01-01';
              endif;
            else;
              pePasi(pePasiC).stfpag  = d'0001-01-01';
              pePasi(pePasiC).stfpxs  = d'0001-01-01';
              pePasi(pePasiC).stfcob  = d'0001-01-01';
           endif;

           pePasi(pePasiC).stmone1 = hpmonr;
           pePasi(pePasiC).stimmr1 = hpimmr;
           if (hpmar1 = 'I');
              pePasi(pePasiC).stimmin = hpimmr;
              pePasi(pePasiC).stimmga = 0;
              pePasi(pePasiC).stdpag  = 'INDEMNIZACION';
            else;
              pePasi(pePasiC).stimmin = 0;
              pePasi(pePasiC).stimmga = hpimmr;
              pePasi(pePasiC).stdpag  = 'GASTOS';
           endif;

           if (pamp01 = 'S');
              pePasi(pePasiC).stdpag  = 'CANCELACION DE SALDOS DE POLIZA';
           endif;

           pePasi(pePasiC).stnrdf  = hpnrdf;
           pePasi(pePasiC).startc  = hpartc;
           pePasi(pePasiC).stpacp  = hppacp;
           pePasi(pePasiC).sttben  = hpmar2;
           pePasi(pePasiC).sttpag  = hpmar1;
           fecha = (hpfmoa * 10000) + (hpfmom * 100) + hpfmod;
           test(de) *iso fecha;
           if %error;
              pePasi(pePasiC).stfodp  = d'0001-01-01';
            else;
              pePasi(pePasiC).stfodp  = %date(fecha:*iso);
           endif;

           k1t107.t@rama = hprama;
           k1t107.t@cobc = hpxcob;
           chain %kds(k1t107:2) set107;
           if %found;
              pePasi(pePasiC).stcobd  = t@cobd;
              pePasi(pePasiC).stcobl  = t@cobl;
            else;
              pePasi(pePasiC).stcobd  = *blanks;
              pePasi(pePasiC).stcobl  = *blanks;
           endif;

           chain hpnrdf gnhdaf;
           if %found;
              pePasi(pePasiC).stnomb  = dfnomb;
            else;
              pePasi(pePasiC).stnomb  = *blanks;
           endif;

           chain hpmonr gntmon;
           if %found;
              pePasi(pePasiC).stnmoc1 = monmoc;
            else;
              pePasi(pePasiC).stnmoc1 = *blanks;
           endif;

           k1ttbe.g1empr = hpempr;
           k1ttbe.g1sucu = hpsucu;
           k1ttbe.g1tben = hpmar2;
           chain %kds(k1ttbe) gnttbe;
           if %found;
              pePasi(pePasiC).stdben  = g1dben;
            else;
              pePasi(pePasiC).stdben  = *blanks;
           endif;

           k1hric.icempr = hpempr;
           k1hric.icsucu = hpsucu;
           k1hric.icartc = hpartc;
           k1hric.icpacp = hppacp;
           chain %kds(k1hric:4) cnhric;
           if %found;
              pePasi(pePasiC).stivnr  = icivnr;
            else;
              pePasi(pePasiC).stivnr  = 0;
           endif;

           exsr ultReg;
         endif;
        endif;

        exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof(pahshp04);
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

       // ------------------------------------------------- *
       // Posiciona archivo
       // ------------------------------------------------- *
       begsr posArc;
             k1hshp.hpempr = peBase.peEmpr;
             k1hshp.hpsucu = peBase.peSucu;
             k1hshp.hprama = pePosi.hprama;
             k1hshp.hpsini = pePosi.hpsini;
             k1hshp.hpnops = pePosi.hpnops;
             k1hshp.hppoco = pePosi.hppoco;
             k1hshp.hppaco = pePosi.hppaco;
             k1hshp.hpnrdf = pePosi.hpnrdf;
             k1hshp.hpsebe = pePosi.hpsebe;
             k1hshp.hpriec = pePosi.hpriec;
             k1hshp.hpxcob = pePosi.hpxcob;
             k1hshp.hpfmoa = pePosi.hpfmoa;
             k1hshp.hpfmom = pePosi.hpfmom;
             k1hshp.hpfmod = pePosi.hpfmod;
             k1hshp.hppsec = pePosi.hppsec;
             if ( peRoll = 'F' );
                setgt %kds(k1hshp:15) pahshp04;
              else;
                setll %kds(k1hshp:15) pahshp04;
             endif;
       endsr;

       // ------------------------------------------------- *
       // Lectura hacia adelante
       // ------------------------------------------------- *
       begsr leeArc;
             reade %kds(k1hshp : 4 ) pahshp04;
       endsr;

       // ------------------------------------------------- *
       // Lectura hacia atrás
       // ------------------------------------------------- *
       begsr retArc;
             readpe %kds(k1hshp : 4 ) pahshp04;
       endsr;

       // ------------------------------------------------- *
       // Posicionamiento en comienzo
       // ------------------------------------------------- *
       begsr priArc;
             setll  %kds(k1hshp : 4 ) pahshp04;
       endsr;

       // ------------------------------------------------- *
       //  ?
       // ------------------------------------------------- *
       begsr retPag;
             if ( peRoll = 'R' );
                exsr retArc;
                dow not finArc and @@cant > 0;
                    @@cant -= 1;
                    exsr retArc;
                enddo;
                if finArc;
                   @@more = *Off;
                   exsr priArc;
                endif;
                @@cant = peCant;
                if @@cant <= 0 or @@cant > 99;
                   @@cant = 99;
                endif;
             endif;
       endsr;

       // ------------------------------------------------- *
       // Primer registro
       // ------------------------------------------------- *
       begsr priReg;
             pePreg.hprama = hprama;
             pePreg.hpsini = hpsini;
             pePreg.hpnops = hpnops;
             pePreg.hppoco = hppoco;
             pePreg.hppaco = hppaco;
             pePreg.hpnrdf = hpnrdf;
             pePreg.hpsebe = hpsebe;
             pePreg.hpriec = hpriec;
             pePreg.hpxcob = hpxcob;
             pePreg.hpfmoa = hpfmoa;
             pePreg.hpfmom = hpfmom;
             pePreg.hpfmod = hpfmod;
             pePreg.hppsec = hppsec;
       endsr;

       // ------------------------------------------------- *
       // Último registro
       // ------------------------------------------------- *
       begsr ultReg;
             peUreg.hprama = hprama;
             peUreg.hpsini = hpsini;
             peUreg.hpnops = hpnops;
             peUreg.hppoco = hppoco;
             peUreg.hppaco = hppaco;
             peUreg.hpnrdf = hpnrdf;
             peUreg.hpsebe = hpsebe;
             peUreg.hpriec = hpriec;
             peUreg.hpxcob = hpxcob;
             peUreg.hpfmoa = hpfmoa;
             peUreg.hpfmom = hpfmom;
             peUreg.hpfmod = hpfmod;
             peUreg.hppsec = hppsec;
       endsr;

      /end-free

      * ------------------------------------------------------------ *
      * finArc(): Determina fin de archivo                           *
      *                                                              *
      * ------------------------------------------------------------ *
     P finArc          B
     D finArc          pi              n

      /free

       return %eof(pahshp04);

      /end-free

     P finArc          E
