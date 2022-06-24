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
     D aguja           s              9a
     D x               s             10i 0
     D i               s             10i 0
     D pajar           s              9a   dim(999)

     D CRLF            c                   x'0d25'

     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D k1hni2          ds                  likerec(s1hni201:*key)
     D k1husu          ds                  likerec(d1husu3:*key)

     D mayores         ds                  qualified dim(999)
     D  coma                          2a
     D  nrma                          7  0
     D  nomb                         40a
     D  cuit                         13a

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
       if rc = *off;
          return;
       endif;


       setll %kds(k1husu:2) pahusu302;
       reade %kds(k1husu:2) pahusu302;
       dow not %eof;

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

           aguja = %trim(n2coma) + %editc(n2nrma:'X');
           x     = %lookup( aguja : pajar );
           if x = 0;
              x = %lookup( *blanks : pajar );
           endif;

           pajar(x) = aguja;

           mayores(x).coma = n2coma;
           mayores(x).nrma = n2nrma;
           mayores(x).cuit = dfcuit;
           mayores(x).nomb = dfnomb;


        reade %kds(k1husu:2) pahusu302;
       enddo;

       c = 0;
       clear pajar;

       REST_writeXmlLine( 'mayores' : '*BEG' );
       for i = 1 to 999;
           if mayores(i).nomb <> *blanks;
              c += 1;
               REST_writeXmlLine( 'mayor' : '*BEG' );
                REST_writeXmlLine( 'cuitInter'       : %trim(mayores(i).cuit) );
                REST_writeXmlLine( 'nombreInter'     : %trim(mayores(i).nomb) );
                REST_writeXmlLine( 'codMayorAux'     : %trim(mayores(i).coma) );
                REST_writeXmlLine('nroMayorAux':%trim(%char(mayores(i).nrma)) );
                REST_writeXmlLine( 'mayor' : '*END' );
           endif;
       endfor;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'mayores' : '*END' );

       close *all;

       return;

