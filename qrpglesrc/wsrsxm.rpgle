     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRFXM: QUOM Versión 2                                       *
      *         Facturas pendientes por intermediario                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *31-May-2017            *
      * ************************************************************ *
     Fcntnau01  if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'

     D WSLSX1          pr                  ExtPgm('WSLSX1')
     D   peBase                            likeds(paramBase) const
     D   peComa                       2a   const
     D   peNrma                       7  0 const
     D   peFsal                       6  0
     D   peMone                       2a
     D   peNmol                      30a
     D   peNmoc                       5a
     D   peSald                      15  2
     D   peDeha                       1  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D coma            s              2a
     D nrma            s              7a
     D sald            s             30a
     D url             s           3000a   varying
     D @@repl          s          65535a
     D rc              s              1n
     D fecha           s             10d
     D c               s             10i 0
     D rc2             s             10i 0
     D peFsal          s              6  0
     D peMone          s              2a
     D peNmol          s             30a
     D peNmoc          s              5a
     D peSald          s             15  2
     D peDeha          s              1  0
     D @fsal           s              6a
     D @msal           s              2a
     D @asal           s              4a
     D saldo           s             30a
     D condicion       s             30a

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D k1tnau          ds                  likerec(c1tnau01:*key)
     D peErro          s             10i 0

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

       clear peBase;
       clear peMsgs;
       peErro = 0;
       peBase.peEmpr = empr;
       peBase.peSucu = sucu;

       WSLSX1( peBase
             : coma
             : %dec( nrma : 7 : 0 )
             : peFsal
             : peMone
             : peNmol
             : peNmoc
             : peSald
             : peDeha
             : peErro
             : peMsgs );

       if REST_writeHeader() = *off;
          return;
       endif;

       if peErro <> 0;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       rc = REST_write( '<?xml version="1.0" encoding="ISO-8859-1"?>');
       if REST_writeXmlLine( 'saldo' : '*BEG') = *off;
          return;
       endif;

       @fsal = %editc( peFsal : 'X' );
       @asal = %subst( @fsal : 3 : 4 );
       @msal = %subst( @fsal : 1 : 2 );

       if peSald < 0;
          peSald *= -1;
       endif;

       saldo = %editw( peSald : '                 .  -' );

       if peDeha = 1;
          condicion = 'DEUDOR';
        else;
          condicion = 'ACREEDOR';
       endif;

       REST_writeXmlLine( 'fechaSaldo' : @msal + '/' + @asal);
       REST_writeXmlLine( 'importeSaldo': %trim(saldo) );
       REST_writeXmlLine( 'condicionSaldo' : condicion);

       REST_writeXmlLine( 'saldo' : '*END' );

       close *all;

       return;

