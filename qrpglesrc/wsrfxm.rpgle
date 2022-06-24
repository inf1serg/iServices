     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRFXM: QUOM Versión 2                                       *
      *         Facturas pendientes por intermediario                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *31-May-2017            *
      * ------------------------------------------------------------ *
      * SGF 14/01/2020: Agrego C4S2.                                 *
      * JSN 01/09/2020: Se agrega contenido a los tag:               *
      *                   - permiteIngresar                          *
      *                   - estadoPresentacion                       *
      * ************************************************************ *
     Fcntnau01  if   e           k disk
     Fpahiva03  if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svpfac_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D coma            s              2a
     D nrma            s              7a
     D url             s           3000a   varying
     D @@repl          s          65535a
     D rc              s              1n
     D fecha           s              8  0
     D c               s             10i 0
     D rc2             s             10i 0
     D @@Dest          s             40a

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D k1hiva          ds                  likerec(p1hiva03:*key)
     D k1tnau          ds                  likerec(c1tnau01:*key)
     D @@DsVw          ds                  likeds(dsPahivw_t) dim(9999)
     D @@DsVwC         s             10i 0

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

       rc = REST_writeHeader();
       if rc = *off;
          return;
       endif;

       rc = REST_write( '<?xml version="1.0" encoding="ISO-8859-1"?>');
       rc = REST_writeXmlLine( 'facturas' : '*BEG');
       if rc = *off;
          return;
       endif;

       c = 0;

       k1hiva.ivempr = empr;
       k1hiva.ivsucu = sucu;
       k1hiva.ivcoma = coma;
       k1hiva.ivnrma = %dec( nrma : 7 : 0 );

       setll %kds(k1hiva:4) pahiva03;
       reade %kds(k1hiva:4) pahiva03;
       dow not %eof;

           c += 1;

           fecha = (ivfe1a * 10000)
                 + (ivfe1m *   100)
                 +  ivfe1d;

           REST_writeXmlLine( 'factura' : '*BEG' );
            REST_writeXmlLine('comision':SVPREST_editImporte(ivigra));
            REST_writeXmlLine('iva':SVPREST_editImporte(iviiva));
            REST_writeXmlLine('totalFactura':SVPREST_editImporte(ivitot));
            REST_writeXmlLine( 'retIva':SVPREST_editImporte(iviret));
            REST_writeXmlLine('fechaFactura':SVPREST_editFecha(fecha));
            REST_writeXmlLine('secuencia':%trim(%char(ivc4s2)));

            if SVPFAC_getPahivw( ivEmpr
                               : ivSucu
                               : ivComa
                               : ivNrma
                               : ivFe1a
                               : ivFe1m
                               : ivFe1d
                               : ivC4s2
                               : @@DsVw
                               : @@DsVwC );

              clear @@Dest;
              @@Dest = SVPDES_estadoDeFactura( @@DsVw(@@DsVwC).pwEsta );

              REST_writeXmlLine('permiteIngresar': 'N');
              REST_writeXmlLine('estadoPresentacion': %trim( @@Dest ));
            else;
              REST_writeXmlLine('permiteIngresar': 'S');
              REST_writeXmlLine('estadoPresentacion': 'Pendiente');
            endif;
           REST_writeXmlLine( 'factura' : '*END' );

        reade %kds(k1hiva:4) pahiva03;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'facturas' : '*END' );

       close *all;

       return;

