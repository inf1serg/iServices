     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRIXI: QUOM Versión 2                                       *
      *         Lista de intermediarios por intermediario            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *12-Jun-2017            *
      * ************************************************************ *
     Fpahusu302 if   e           k disk
     Fsehni201  if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D c               s             10i 0
     D rc2             s             10i 0

     D CRLF            c                   x'0d25'

     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D k1hni2          ds                  likerec(s1hni201:*key)
     D k1husu          ds                  likerec(d1husu3:*key)

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
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);

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

       if %check( '0123456789' : %trim(nivt) ) <> 0 or
          %check( '0123456789' : %trim(nivc) ) <> 0;
          %subst(@@repl:1:1) = nivt;
          %subst(@@repl:2:5) = nivc;
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

       k1hni2.n2empr = empr;
       k1hni2.n2sucu = sucu;
       k1hni2.n2nivt = %dec( nivt : 1 : 0 );
       k1hni2.n2nivc = %dec( nivc : 5 : 0 );
       setll %kds(k1hni2) sehni201;
       if not %equal;
          %subst(@@repl:1:1) = nivt;
          %subst(@@repl:2:5) = nivc;
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

       k1husu.u3nivt = %dec( nivt : 1 : 0 );
       k1husu.u3nivc = %dec( nivc : 5 : 0 );

       rc = REST_writeHeader();
       if rc = *off;
          return;
       endif;

       rc = REST_write( '<?xml version="1.0" encoding="ISO-8859-1"?>');
       rc = REST_writeXmlLine( 'intermediarios' : '*BEG');
       if rc = *off;
          return;
       endif;

       c = 0;

       setll %kds(k1husu:2) pahusu302;
       reade %kds(k1husu:2) pahusu302;
       dow not %eof;

           c += 1;

           k1hni2.n2empr = empr;
           k1hni2.n2sucu = sucu;
           k1hni2.n2nivt = u3nit1;
           k1hni2.n2nivc = u3niv1;
           chain %kds(k1hni2:4) sehni201;
           if not %found;
              dfnomb = *blanks;
              dfcuit = *all'0';
              n2coma = *blanks;
              n2nrma = 0;
           endif;

           REST_writeXmlLine( 'intermediario' : '*BEG' );
            REST_writeXmlLine( 'cuitInter'       : %trim(dfcuit) );
            REST_writeXmlLine( 'nivelInter'      : %trim(%char(u3nit1)) );
            REST_writeXmlLine( 'codigoInter'     : %trim(%char(u3niv1)) );
            REST_writeXmlLine( 'nombreInter'     : %trim(dfnomb)        );
            REST_writeXmlLine( 'codMayorAux'     : %trim(n2coma)        );
            REST_writeXmlLine( 'nroMayorAux'     : %trim(%char(n2nrma)) );
           REST_writeXmlLine( 'intermediario' : '*END' );

        reade %kds(k1husu:2) pahusu302;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'intermediarios' : '*END' );

       close *all;

       return;

