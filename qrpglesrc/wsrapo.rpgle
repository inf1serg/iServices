     H option(*srcstmt:*noshowcpy:*nodebugio)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRAPO: Portal de Autogestión de Asegurados.                 *
      *         Datos de Pop Up.                                     *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *10-Jun-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D @vsys           s            512a
     D show            s              1a
     D file            s            512a
     D anch            s             10a
     D alto            s             10a
     D text            s            512a
     D clas            s            512a

      /free

       *inlr = *on;

       show = 'N';
       file = *blanks;
       anch = *blanks;
       alto = *blanks;
       text = *blanks;
       clas = *blanks;

       if SVPVLS_getValSys( 'HAGPUPSHOW' : *omit : @vsys );
          show = %trim(@vsys);
       endif;

       if SVPVLS_getValSys( 'HAGPUPFILE' : *omit : @vsys );
          file = %trim(@vsys);
       endif;

       if SVPVLS_getValSys( 'HAGPUPANCH' : *omit : @vsys );
          anch = %trim(@vsys);
       endif;

       if SVPVLS_getValSys( 'HAGPUPALTO' : *omit : @vsys );
          alto = %trim(@vsys);
       endif;

       if SVPVLS_getValSys( 'HAGPUPTEXT' : *omit : @vsys );
          text = %trim(@vsys);
       endif;

       if SVPVLS_getValSys( 'HAGPUPCLAS' : *omit : @vsys );
          clas = %trim(@vsys);
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'popUp' );

        REST_writeXmlLine( 'show'  : show );
        REST_writeXmlLine( 'file'  : file );
        REST_writeXmlLine( 'ancho' : anch );
        REST_writeXmlLine( 'alto'  : alto );
        REST_writeXmlLine( 'text'  : text );
        REST_writeXmlLine( 'clas'  : clas );

       REST_endArray( 'popUp' );

       return;

      /end-free

