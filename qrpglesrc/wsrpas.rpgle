     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPAS: QUOM Versión 2                                       *
      *         Pagos de un siniestro.                               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *19-Jun-2017            *
      *                                                              *
      * Ruben Castillo: Aviso de Orden de Pago para aplicar a pago de*
      *                 poliza que se vea en Zamba y en la pagina a  *
      *                 que acceden los productores para ver los     *
      *                 pasos.                                       *
      * SGF 30/07/21: Agrego Recibo Indemnizacion.                   *
      *                                                              *
      * ************************************************************ *
     Fsehni2    if   e           k disk
     Fset001    if   e           k disk
     Fpahscd    if   e           k disk

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

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

     D   pePosi        ds                  likeds(keypas_t)
     D   pePreg        ds                  likeds(keypas_t)
     D   peUreg        ds                  likeds(keypas_t)
     D   pePasi        ds                  likeds(pahstro1_t) dim(99)
     D   pePasiC       s             10i 0
     D   peMore        s              1n
     D   peRoll        s              1a

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D sini            s              7a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@repl          s          65535a
     D fliq            s             10a
     D fpag            s             10a
     D imp             s             30a
     D peErro          s             10i 0
     D x               s             10i 0
     D z               s             10i 0
     D c               s             10i 0
     D @@rama          s              2  0

     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)

     D k1hni2          ds                  likerec(s1hni2:*key)
     D k1hscd          ds                  likerec(p1hscd:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

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
       sini = REST_getNextPart(url);

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
       setll @@rama set001;
       if not %equal;
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

       if %check( '0123456789' : %trim(sini) ) <> 0;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = sini;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SIN0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       k1hscd.cdempr = empr;
       k1hscd.cdsucu = sucu;
       k1hscd.cdrama = %dec( rama : 2 : 0 );
       k1hscd.cdsini = %dec( sini : 7 : 0 );
       chain  %kds(k1hscd:4) pahscd;
       if not %found;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = sini;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SIN0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       clear peBase;
       clear pePasi;
       clear peMsgs;
       clear pePosi;
       clear pePreg;
       clear peUreg;

       pePasiC = 0;
       peErro  = 0;
       peRoll  = 'I';

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec( nivt : 1 : 0 );
       peBase.peNivc = %dec( nivc : 5 : 0 );
       peBase.peNit1 = %dec( nit1 : 1 : 0 );
       peBase.peNiv1 = %dec( niv1 : 5 : 0 );

       COWLOG_logcon('WSRPAS':peBase);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'pagosSiniestros' : '*BEG' );


       c = 0;

       exsr pagos;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'pagosSiniestros' : '*END' );
       REST_end();

       close *all;

       return;

       begsr pagos;

        pePosi.hprama = %dec(rama:2:0);
        pePosi.hpsini = cdsini;
        pePosi.hpnops = cdnops;

        dou peMore = *off;

            WSLPAS( peBase
                  : 99
                  : peRoll
                  : pePosi
                  : pePreg
                  : peUreg
                  : pePasi
                  : pePasiC
                  : peMore
                  : peErro
                  : peMsgs );

            if pePasiC <= 0;
               leave;
            endif;

            peRoll = 'F';
            pePosi = peUreg;

            for z = 1 to pePasiC;

             c += 1;

             fliq = %char(pePasi(z).stfodp:*iso);
             if fliq = '0001-01-01';
                fliq = *blanks;
             endif;

             fpag = %char(pePasi(z).stfcob:*iso);
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
             REST_writeXmlLine( 'beneficiario' : pePasi(z).stnomb);
             REST_writeXmlLine( 'tipoPago': pePasi(z).stdpag );
             REST_writeXmlLine( 'cobertura': pePasi(z).stcobl );
             REST_writeXmlLine( 'fechaPago'   : fpag );
             REST_writeXmlLine( 'nroOdp'   : %char(pePasi(z).stpacp) );
             REST_writeXmlLine( 'nroRecibo'   : %char(pePasi(z).stivnr) );
             REST_writeXmlLine( 'pago' : '*END' );

            endfor;

            if peMore = *off;
               leave;
            endif;

        enddo;

       endsr;

      /end-free
