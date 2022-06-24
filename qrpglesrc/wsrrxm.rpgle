     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRRXM: QUOM Versión 2                                       *
      *         Detalle de renteciones por mayor auxiliar            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *31-May-2017            *
      * ------------------------------------------------------------ *
      * SGF 09/11/2018: Editar importes.                             *
      *                                                              *
      * ************************************************************ *
     Fcntnau01  if   e           k disk
     Fcnhret97  if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fgntdim    if   e           k disk
     Fgntpro01  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D coma            s              2a
     D nrma            s              7a
     D desd            s              8a
     D hast            s              8a
     D desde           s             10a
     D hasta           s             10a
     D bimp            s             30a
     D pret            s             30a
     D iret            s             30a
     D icono           s            100a
     D url             s           3000a   varying
     D @@repl          s          65535a
     D rc              s              1n
     D fecha           s             10d
     D c               s             10i 0
     D rc2             s             10i 0
     D desdn           s              8  0
     D hastn           s              8  0
     D fret            s              8  0

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D k1hret          ds                  likerec(c1hret:*key)
     D k1tnau          ds                  likerec(c1tnau01:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

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
       coma = REST_getNextPart(url);
       nrma = REST_getNextPart(url);
       desde= REST_getNextPart(url);
       hasta= REST_getNextPart(url);

       desd = %subst(desde:1:4)
            + %subst(desde:6:2)
            + %subst(desde:9:2);

       hast = %subst(hasta:1:4)
            + %subst(hasta:6:2)
            + %subst(hasta:9:2);

       if %scan( ' ' : empr ) > 1;
          %subst(@@repl:1:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0113'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %scan( ' ' : sucu ) > 2;
          %subst(@@repl:1:2) = sucu;
          %subst(@@repl:2:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0114'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0114'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       setll empr gntemp;
       if not %equal;
          %subst(@@repl:1:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0113'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0113'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       setll (empr : sucu) gntsuc;
       if not %equal;
          %subst(@@repl:1:2) = sucu;
          %subst(@@repl:3:1) = empr;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0114'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0114'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(nrma) ) <> 0;
          %subst(@@repl:1:1) = coma;
          %subst(@@repl:2:5) = nrma;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'PRD0001'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'PRD0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       k1tnau.naempr = empr;
       k1tnau.nasucu = sucu;
       k1tnau.nacoma = coma;
       k1tnau.nanrma = %dec( nrma : 7 : 0 );
       chain %kds(k1tnau) cntnau01;
       if not %found;
          %subst(@@repl:1:2) = coma;
          %subst(@@repl:2:7) = nrma;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'MAY0001'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'MAY0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(desd) ) <> 0;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'GEN0001'
                             : peMsgs    );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'GEN0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       desdn = %dec(desd:8:0);
       monitor;
          fecha = %date( desdn : *iso);
        on-error;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'GEN0001'
                             : peMsgs    );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'GEN0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endmon;

       if %check( '0123456789' : %trim(hast) ) <> 0;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'GEN0002'
                             : peMsgs   );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'GEN0002'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       hastn = %dec(hast:8:0);
       monitor;
          fecha = %date( hastn : *iso);
        on-error;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'GEN0002'
                             : peMsgs    );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'GEN0002'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endmon;

       if hastn < desdn;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'GEN0003'
                             : peMsgs    );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'GEN0003'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       rc = REST_writeHeader();
       if rc = *off;
          return;
       endif;

       rc = REST_write( '<?xml version="1.0" encoding="ISO-8859-1"?>');
       rc = REST_writeXmlLine( 'retenciones' : '*BEG');
       if rc = *off;
          return;
       endif;

       c = 0;

       k1hret.rtempr = empr;
       k1hret.rtsucu = sucu;
       k1hret.rtcoma = coma;
       k1hret.rtnrma = %dec( nrma : 7 : 0 );
       k1hret.rtfepa = %dec(%subst( desd : 1 : 4 ):4:0);
       k1hret.rtfepm = %dec(%subst( desd : 5 : 2 ):2:0);
       k1hret.rtfepd = %dec(%subst( desd : 7 : 2 ):2:0);

       setll %kds(k1hret:7) cnhret97;
       reade %kds(k1hret:4) cnhret97;
       dow not %eof;

           fret = (rtfepa * 10000)
                + (rtfepm *   100)
                +  rtfepd;

           if rtiiau > 0 and rtirau > 0 and
              fret >= desdn and fret <= hastn;

              c += 1;

              fecha = %date( fret : *iso );

              chain rttiic gntdim;
              if not %found;
                 ditiid = *blanks;
                 dipath = *blanks;
              endif;

              if rtpacp <= 0;
                 icono = '#Aun no disponible';
              endif;

              if dipath = *blanks;
                 icono = '#No Existe Comprobante para este concepto';
              endif;

              if dipath <> *blanks and rtpacp > 0;
                 icono = 'Certificado_'
                       + %trim(rttiic)
                       + '_'
                       + %trim(rtempr)
                       + '_'
                       + %trim(rtsucu)
                       + '_'
                       + %trim(rtcoma)
                       + '_'
                       + %trim(%editc(rtnrma:'X'))
                       + '_'
                       + %trim(%editc(rtrpro:'X'))
                       + '_'
                       + %trim(%editc(rttico:'X'))
                       + '_'
                       + %trim(%editc(rtnras:'X'))
                       + '_'
                       + %trim(%editc(rtpacp:'X'))
                       + '_'
                       + %trim(%editc(rtfepa:'X'))
                       + '_'
                       + %trim(%editc(rtfepm:'X'))
                       + '_'
                       + %trim(%editc(rtfepd:'X'))
                       + '_'
                       + %trim(%editc(rtnrrf:'X'))
                       + '.pdf' ;
              endif;

              chain rtrpro gntpro01;
              if not %found;
                 prprod = *blanks;
              endif;

              bimp = %editw( rtiiau : '                 .  -' );
              pret = %editw( rtpoim : '   .  ' );
              iret = %editw( rtirau : '                 .  -' );
              pret = SVPREST_editImporte( rtpoim );
              iret = SVPREST_editImporte( rtirau );

              REST_writeXmlLine( 'retencion' : '*BEG' );
               REST_writeXmlLine( 'tipoImpuesto' : %trim(ditiid) );
               REST_writeXmlLine( 'provincia'    : %trim(prprod)        );
               REST_writeXmlLine( 'mes'       : %trim(%char(rtfepm)));
               REST_writeXmlLine( 'anio'       : %trim(%char(rtfepa)));
               REST_writeXmlLine( 'baseImponible' : %trim(bimp)    );
               REST_writeXmlLine( 'porcRetencion' :  %trim(pret)    );
               REST_writeXmlLine( 'importeRetencion' : %trim(iret)    );
               REST_writeXmlLine( 'nroCertificado'  : %trim(%char(rtpacp)) );
               REST_writeXmlLine( 'fechaRetencion': %trim(%char(fecha:*iso)));
               REST_writeXmlLine( 'iconoCertificado': %trim(icono) );
              REST_writeXmlLine( 'retencion' : '*END' );

           endif;

        reade %kds(k1hret:4) cnhret97;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'retenciones' : '*END' );

       close *all;

       return;

