     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSREA: BPM                                                  *
      *         Lista relacion con asegurado.                        *
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
     D peDs44C         s             10i 0
     D peDs44          ds                  likeds(set444_t) dim(99)

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

       clear peDs44;
       clear peDs44C;

       REST_writeHeader();
       REST_writeEncoding();
       REST_startArray( 'relaciones' );
       if SVPTAB_getRelacionAseg( Empr : Sucu : peDs44 : peDs44C : *omit );
         for x = 1 to peDs44C;
           REST_startArray( 'relacion' );
             REST_writeXmlLine( 'empresa' : peDs44(x).t@Empr );
             REST_writeXmlLine( 'sucursal' : peDs44(x).t@Sucu );
             REST_writeXmlLine( 'codigoRelacion' : %char(peDs44(x).t@Rela)  );
             REST_writeXmlLine( 'descripcionRelacion' :
                                 %trim(peDs44(x).t@Reld) );
           REST_endArray  ( 'relacion' );
         endfor;
       endif;
       REST_endArray  ( 'relaciones' );

       return;

