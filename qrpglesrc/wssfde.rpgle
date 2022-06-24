        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'

       *inlr = *ON;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'fechaDeProceso' );
        REST_writeXmlLine( 'fechaDeDenuncia'
                         : SVPREST_editFecha(
                           SVPSIN_getFechaDelDia( 'A' : 'CA') ) );
       REST_endArray( 'fechaDeProceso' );

       return;

