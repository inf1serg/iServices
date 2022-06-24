     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSETI: BPM                                                  *
      *         Lista estado del tiempo.                             *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *26-Ago-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D empr            s              1a
     D sucu            s              2a

     D x               s             10i 0

     D rc              s              1n
     D peDs45C         s             10i 0
     D peDs45          ds                  likeds(set445_t) dim(99)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
         REST_writeHeader( 204
                         : *omit
                         : *omit
                         : 'RPG0001'
                         : 40
                         : 'Error al parsear URL'
                         : 'Error al parsear URL' );
         REST_end();
         return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'estados' );
       if SVPTAB_getEstadoTiempo( Empr : Sucu : peDs45 : peDs45C : *omit );
         for x = 1 to peDs45C;
           REST_startArray( 'estado' );
             REST_writeXmlLine( 'empresa' : peDs45(x).t@Empr );
             REST_writeXmlLine( 'sucursal' : peDs45(x).t@Sucu );
             REST_writeXmlLine( 'codEstadoTiempo' : %char(peDs45(x).t@Cdes) );
             REST_writeXmlLine( 'descripEstadoTiempo' :
                                 %trim(peDs45(x).t@Ddes) );
           REST_endArray  ( 'estado' );
         endfor;
       endif;
       REST_endArray  ( 'estados' );

       return;

