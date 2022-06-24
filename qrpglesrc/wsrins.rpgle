     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRINS: Inspectores por Zona                                 *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        *28-Sep-2018            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      * ************************************************************ *
     Fgntloc    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'

     D uri             s            512a
     D copo            s              5a
     D cops            s              1a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0

     D CRLF            c                   x'0d25'

     D x               s             10i 0
     D cNombres        s             10i 0
     D lNombres        s             40    Dim ( 99 )

     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0

     D k1yloc          ds                  likerec( g1tloc : *key )

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       copo = REST_getNextPart(url);
       cops = REST_getNextPart(url);

       if %check( '0123456789' : %trim(copo) ) <> 0;
          @@repl = copo;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'LOC0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'LOC0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(cops) ) <> 0;
          @@repl = cops;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'LOC0002'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'LOC0002'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       k1yloc.locopo = %dec( copo : 5 : 0 );
       k1yloc.locops = %dec( cops : 1 : 0 );

       setll %kds( k1yloc : 2 ) gntloc;
       if not %equal;
          %subst(@@repl:1:5) = copo;
          %subst(@@repl:6:1) = cops;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'LOC0003'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'LOC0003'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
        REST_end();
        close *all;
        return;
       endif;

       cNombres = SPVVEH_getInspectorWeb( %dec( copo : 5 : 0 )
                                        : %dec( cops : 5 : 0 )
                                        : lNombres );
       if ( cNombres = *Zeros );
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0172'
                             : peMsgs );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'COW0173'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       REST_writeHeader();
       REST_write( '<?xml version="1.0" encoding="ISO-8859-1"?>');

       REST_startArray( 'Inspectores' );
       for x = 1 to cNombres;
           REST_writeXmlLine( 'Inspector' : %trim( lNombres ( x ) ) );
       endfor;
       REST_endArray( 'Inspectores' );

       close *all;

       return;

