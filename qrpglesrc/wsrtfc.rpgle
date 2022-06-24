      * ************************************************************ *
      * WSRTFC: Servicio REST                                        *
      *         Retorna tipos de comprobante AFIP                    *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                       *10-Feb-2022          *
      * ------------------------------------------------------------ *
      * SGF 04/04/2022: Sort del array por descripcion.              *
      *                                                              *
      * ************************************************************ *

        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'

        dcl-ds peTtfc  likeds(dsGntTfc_t) dim(999);
        dcl-s  peTtfcC int(10);
        dcl-s  x       int(10);
        dcl-s  z       int(10);

        *inlr = *on;

        SVPTAB_getTiposComprobanteAfip( peTtfc : peTtfcC );

        sorta peTtfc(*).gndifa;

        if peTtfcC <= 0;
           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit  );
           REST_writeEncoding();
           REST_end();
           return;
        endif;

        REST_writeHeader();
        REST_writeEncoding();

        REST_startArray( 'tiposComprobante' );

        z = 999 - peTtfcC + 1;

        for x = z to 999;
         if peTtfc(x).gntifa <> 0;
         REST_startArray( 'tipoComprobante' );
          REST_writeXmlLine( 'codigo'     :%trim(%char(peTtfc(x).gntifa)));
          REST_writeXmlLine( 'descripcion':%trim(peTtfc(x).gndifa) );
         REST_endArray( 'tipoComprobante' );
         endif;
        endfor;

        REST_endArray( 'tiposComprobante' );

        REST_end();

        return;

