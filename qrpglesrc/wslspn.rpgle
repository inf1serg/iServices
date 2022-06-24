     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLSPN : WebService                                          *
      *          R torna Inspecciones SpeedWay.                      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                              *15/12/2015    *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahspwi   if   e           k disk
     Fpahsp2    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSPN          pr                  ExtPgm('WSLSPN')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keyspi_t) const
     D   pePreg                            likeds(keyspi_t)
     D   peUreg                            likeds(keyspi_t)
     D   peLins                            likeds(pahspwi_t) dim(99)
     D   peLinsC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSPN          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keyspi_t) const
     D   pePreg                            likeds(keyspi_t)
     D   peUreg                            likeds(keyspi_t)
     D   peLins                            likeds(pahspwi_t) dim(99)
     D   peLinsC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@more          s               n

     D k1hsp2          ds                  likerec(p1hsp2:*key)
     D k1hspwi         ds                  likerec(p1hspwi:*key)

     D finArc          pr              n

     D @@cant          s             10i 0

       *inLr = *On;

       clear peLins;
       clear peLinsC;
       clear peErro;
       clear peMsgs;

       @@more = *On;

      *- Valido Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      * Valido Solicitud
        k1hsp2.swempr = peBase.peEmpr;
        k1hsp2.swsucu = peBase.peSucu;
        k1hsp2.swnivt = peBase.peNivt;
        k1hsp2.swnivc = peBase.peNivc;
        k1hsp2.swrama = pePosi.rama;
        k1hsp2.swsoln = pePosi.soln;
        setll %kds(k1hsp2) pahsp2;
        if not %equal;
           %subst(@@repl:1:7) = %trim(%char(pePosi.soln));
           %subst(@@repl:8:1) = %char(peBase.peNivt);
           %subst(@@repl:9:5) = %trim(%char(peBase.peNivc));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'SPW0001'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           peErro = -1;
           return;
        endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       if ( not finArc );
         exsr priReg;
       endif;

       dow ( ( not finArc ) and ( peLinsC < @@cant ) );

         peLinsC += 1;

         peLins(peLinsC).sirama = sirama;
         peLins(peLinsC).siramd = siramd;
         peLins(peLinsC).sisoln = sisoln;
         peLins(peLinsC).sipoli = sipoli;
         peLins(peLinsC).siinsp = siinsp;
         peLins(peLinsC).sinivd = sinivd;
         peLins(peLinsC).siased = siased;
         peLins(peLinsC).sidomi = sidomi;
         peLins(peLinsC).siresp = siresp;
         peLins(peLinsC).sireal = sireal;
         peLins(peLinsC).simoti = simoti;
         peLins(peLinsC).simar1 = simar1;
         peLins(peLinsC).simar2 = simar2;
         peLins(peLinsC).simar3 = simar3;
         peLins(peLinsC).simar4 = simar4;
         peLins(peLinsC).simar5 = simar5;
         peLins(peLinsC).simar6 = simar6;
         peLins(peLinsC).simar7 = simar7;
         peLins(peLinsC).simar8 = simar8;
         peLins(peLinsC).simar9 = simar9;
         peLins(peLinsC).sinins = sinins;
         peLins(peLinsC).sifins = sifins;
         peLins(peLinsC).siesta = siesta;
         peLins(peLinsC).sicoba = sicoba;
         peLins(peLinsC).sicobs = sicobs;
         peLins(peLinsC).sinmat = sinmat;
         peLins(peLinsC).sipoco = sipoco;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahspwi );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

         k1hspwi.siempr = peBase.peEmpr;
         k1hspwi.sisucu = peBase.peSucu;
         k1hspwi.sinivt = peBase.peNivt;
         k1hspwi.sinivc = peBase.peNivc;
         k1hspwi.sirama = pePosi.rama;
         k1hspwi.sisoln = pePosi.soln;
         k1hspwi.siinsp = pePosi.insp;

         if ( peRoll = 'F' );
            setgt %kds ( k1hspwi ) pahspwi;
         else;
            setll %kds ( k1hspwi ) pahspwi;
         endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         reade %kds(k1hspwi:6) pahspwi;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

         readpe %kds(k1hspwi:6) pahspwi;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

         setll %kds(k1hspwi:6) pahspwi;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

       if ( peRoll = 'R' );
         exsr retArc;
         dow ( ( not finArc ) and ( @@cant > 0 ) );
           @@cant -= 1;
           exsr retArc;
         enddo;
         if finArc;
           @@more = *Off;
           exsr priArc;
         endif;
         @@cant = peCant;
         if (@@cant <= 0 or @@cant > 99);
            @@cant = 99;
         endif;
       endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;

         pePreg.insp = siinsp;
         pePreg.rama = sirama;
         pePreg.soln = sisoln;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.insp = siinsp;
         peUreg.rama = sirama;
         peUreg.soln = sisoln;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( pahspwi );

     P finArc          E
