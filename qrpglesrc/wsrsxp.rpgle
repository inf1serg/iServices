     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCIP: QUOM Versión 2                                       *
      *         Cuotas Impagas de una póliza.                        *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *06-Jun-2017            *
      *                                                              *
      * Ruben Castillo: Aviso de Orden de Pago para aplicar a pago de*
      *                 poliza que se vea en Zamba y en la pagina a  *
      *                 que acceden los productores para ver los     *
      *                 pasos.                                       *
      *                                                              *
      * SGF 13/04/2021: Agrego tag para ramas no vida que indica si  *
      *                 se puede o no obtener un PDF con la denuncia.*
      * SGF 30/07/21: Agrego Recibo Indemnizacion.                   *
      *                                                              *
      * ************************************************************ *
     Fsehni2    if   e           k disk
     Fset001    if   e           k disk
     Fpahec1    if   e           k disk
     Fpahstr1   if   e           k disk
     Fpahed004  if   e           k disk    rename(p1hed004:p1hed0)

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D WSLSXP          pr                  ExtPgm('WSLSXP')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keysxp_t) const
     D   pePreg                            likeds(keysxp_t)
     D   peUreg                            likeds(keysxp_t)
     D   peLsin                            likeds(pahstro_t) dim(99)
     D   peLsinC                     10i 0
     D   peMore                       1n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D   pePosi        ds                  likeds(keysxp_t)
     D   pePreg        ds                  likeds(keysxp_t)
     D   peUreg        ds                  likeds(keysxp_t)
     D   peLsin        ds                  likeds(pahstro_t) dim(99)
     D   peLsinC       s             10i 0
     D   peMore        s              1n
     D   peRoll        s              1a

     D WSLPAS          pr                  ExtPgm('WSLPAS')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keypas_t) const
     D   pePreg                            likeds(keypas_t)
     D   peUreg                            likeds(keypas_t)
     D   pePasi                            likeds(pahstro1_t) dim(99)
     D   pePasiC                     10i 0
     D   peMore                       1n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D   pePos1        ds                  likeds(keypas_t)
     D   pePre1        ds                  likeds(keypas_t)
     D   peUre1        ds                  likeds(keypas_t)
     D   pePasi        ds                  likeds(pahstro1_t) dim(99)
     D   pePasiC       s             10i 0
     D   peErr1        s             10i 0
     D   peMor1        s              1n
     D   peRol1        s              1a

     D WSLZI1          pr                  ExtPgm('WSLZI1')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   pePosi                            likeds(keyzi1_t) const
     D   pePreg                            likeds(keyzi1_t)
     D   peUreg                            likeds(keyzi1_t)
     D   peLins                            likeds(pahzin_t) dim(99)
     D   peLinsC                     10i 0
     D   peMore                       1n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D   pePos2        ds                  likeds(keyzi1_t)
     D   pePre2        ds                  likeds(keyzi1_t)
     D   peUre2        ds                  likeds(keyzi1_t)
     D   peLins        ds                  likeds(pahzin_t) dim(99)
     D   peLinsC       s             10i 0
     D   peMor2        s              1n
     D   peErr2        s             10i 0
     D   peRol2        s              1a

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poli            s              7a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@repl          s          65535a
     D fliq            s             10a
     D fpag            s             10a
     D fins            s             10a
     D imp             s             30a
     D peErro          s             10i 0
     D x               s             10i 0
     D z               s             10i 0
     D @@rama          s              2  0
     D @@vsys          s            512a

     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)

     D k1hni2          ds                  likerec(s1hni2:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1hstr          ds                  likerec(p1hstr1:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       if SVPVLS_getValSys( 'HPDFDENHAB' : *omit : @@vsys) = *off;
          @@vsys = 'S';
       endif;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(rama) ) <> 0;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       @@rama = %dec( rama : 2 : 0 );
       chain @@rama set001;
       if not %found;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(poli) ) <> 0;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'POL0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       k1hed0.d0empr = empr;
       k1hed0.d0sucu = sucu;
       k1hed0.d0rama = %dec( rama : 2 : 0 );
       k1hed0.d0poli = %dec( poli : 7 : 0 );
       setgt  %kds(k1hed0:4) pahed004;
       readpe %kds(k1hed0:4) pahed004;
       if %eof;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'POL0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       clear peBase;
       clear peLsin;
       clear peMsgs;
       clear pePosi;
       clear pePreg;
       clear peUreg;

       peLsinC = 0;
       peErro  = 0;
       peRoll  = 'I';

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec( nivt : 1 : 0 );
       peBase.peNivc = %dec( nivc : 5 : 0 );
       peBase.peNit1 = %dec( nit1 : 1 : 0 );
       peBase.peNiv1 = %dec( niv1 : 5 : 0 );

       COWLOG_logcon('WSRSXP':peBase);

       pePosi.cdrama = %dec( rama : 2 : 0 );
       pePosi.cdpoli = %dec( poli : 7 : 0 );
       pePosi.cdsini = 0;
       pePosi.cdnops = 0;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'siniestros' : '*BEG' );

       dou peMore = *off;
           WSLSXP( peBase
                 : 99
                 : peRoll
                 : pePosi
                 : pePreg
                 : peUreg
                 : peLsin
                 : peLsinC
                 : peMore
                 : peErro
                 : peMsgs );

           if peLsinC <= 0;
              leave;
           endif;

           peRoll = 'F';
           pePosi = peUreg;

           for x = 1 to peLsinC;
            REST_writeXmlLine( 'siniestro' : '*BEG' );

            REST_writeXmlLine( 'rama' : %char(peLsin(x).strama));
            REST_writeXmlLine( 'poliza' : %char(peLsin(x).stpoli));
            REST_writeXmlLine( 'nroSiniestro' : %char(peLsin(x).stsini));
            REST_writeXmlLine( 'asegurado' : peLsin(x).stasno);
            REST_writeXmlLine( 'fechaDenuncia'
                             : %trim(%char(peLsin(x).stfden:*iso)) );
            REST_writeXmlLine( 'fechaSiniestro'
                             : %trim(%char(peLsin(x).stfsin:*iso)) );
            REST_writeXmlLine( 'causa'  : %trim(peLsin(x).stcaud) );
            REST_writeXmlLine( 'estado' : %trim(peLsin(x).stdesi) );
            REST_writeXmlLine( 'juicio' : peLsin(x).stjuic);

            if @@vsys = 'S';
               if t@rame <> 18 and t@rame <> 21;
                   REST_writeXmlLine('denunciaPdf' : 'S' );
                else;
                   REST_writeXmlLine('denunciaPdf' : 'N' );
               endif;
             else;
               REST_writeXmlLine('denunciaPdf' : 'N' );
            endif;

            exsr pagos;

            //exsr inspe;

            REST_writeXmlLine( 'siniestro' : '*END');

           endfor;

           if peMore = *off;
              leave;
           endif;

       enddo;

       REST_writeXmlLine( 'siniestros' : '*END' );
       REST_end();

       close *all;

       return;

       begsr pagos;

        clear peRol1;
        clear pePos1;
        clear pePre1;
        clear peUre1;
        clear pePasi;

        peRol1 = 'I';
        pePasiC = 0;
        peErr1 = 0;

        pePos1.hprama = peLsin(x).strama;
        pePos1.hpsini = peLsin(x).stsini;
        pePos1.hpnops = peLsin(x).stnops;

        REST_writeXmlLine( 'pagos' : '*BEG' );

        dou peMor1 = *off;

            WSLPAS( peBase
                  : 99
                  : peRol1
                  : pePos1
                  : pePre1
                  : peUre1
                  : pePasi
                  : pePasiC
                  : peMor1
                  : peErr1
                  : peMsgs );

            if pePasiC <= 0;
               leave;
            endif;

            peRol1 = 'F';
            pePos1 = peUre1;

            for z = 1 to pePasiC;

             fliq = %char(pePasi(z).stfodp:*iso);
             if fliq = '0001-01-01';
                fliq = *blanks;
             endif;

             fpag = %char(pePasi(z).stfpag:*iso);
             if fpag = '0001-01-01';
                fpag = *blanks;
             endif;

             imp = *blanks;

             if pePasi(z).sttpag = 'I';
                imp = %editw( pePasi(z).stimmin : '             .  ' );
             endif;
             if pePasi(z).sttpag = 'G';
                imp = %editw( pePasi(z).stimmga : '             .  ' );
             endif;

             REST_writeXmlLine( 'pago' : '*BEG' );
             REST_writeXmlLine( 'fechaLiq'   : fliq );
             REST_writeXmlLine( 'importePago': imp );
             REST_writeXmlLine( 'tipoBen': pePasi(z).stdben );
             REST_writeXmlLine( 'tipoPago': pePasi(z).stdpag );
             REST_writeXmlLine( 'cobertura': pePasi(z).stcobl );
             REST_writeXmlLine( 'fechaPago'   : fpag );
             REST_writeXmlLine( 'nroOdp'   : %char(pePasi(x).stpacp) );
             REST_writeXmlLine( 'nroRecibo'   : %char(pePasi(x).stivnr) );
             REST_writeXmlLine( 'pago' : '*END' );

            endfor;

            if peMor2 = *off;
               leave;
            endif;

        enddo;

        REST_writeXmlLine( 'pagos' : '*END' );

       endsr;

       begsr inspe;

        clear peRol2;
        clear pePos2;
        clear pePre2;
        clear peUre2;
        clear peLins;

        peRol2 = 'I';
        peLinsC = 0;
        peErr2 = 0;

        pePos2.rama = peLsin(x).strama;
        pePos2.sini = peLsin(x).stsini;

        REST_writeXmlLine( 'inspecciones' : '*BEG' );

            WSLZI1( peBase
                  : 99
                  : peRol2
                  : peLsin(x).strama
                  : peLsin(x).stsini
                  : pePos2
                  : pePre2
                  : peUre2
                  : peLins
                  : peLinsC
                  : peMor2
                  : peErr2
                  : peMsgs );

         if peLinsC > 0;

            peRol2 = 'F';
            pePos2 = peUre2;

            for z = 1 to peLinsC;

             fins = %char(%date(peLins(z).infins:*iso));
             if fins = '0001-01-01';
                fins = *blanks;
             endif;

             REST_writeXmlLine( 'inspeccion' : '*BEG' );
             REST_writeXmlLine( 'fechaIns'   : fins );
             REST_writeXmlLine( 'nroReclamo': %char(peLins(z).inidre) );
             REST_writeXmlLine( 'responsable': peLins(z).ininsd );
             REST_writeXmlLine( 'estado': peLins(z).instin );
             REST_writeXmlLine( 'tipoDoc': peLins(z).intdoc );
             REST_writeXmlLine( 'inspeccion' : '*END' );

            endfor;

         endif;

        REST_writeXmlLine( 'inspecciones' : '*END' );

       endsr;

      /end-free
