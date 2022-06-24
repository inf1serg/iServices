     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSEST: BPM                                                  *
      *         Lista estado de siniestro.                           *
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
     D rama            s              2a

     D x               s             10i 0
     D peRama          s              2  0
     D RamaAnt         s              2  0

     D rc              s              1n
     D peDs02C         s             10i 0
     D peDs02          ds                  likeds(set402_t) dim(9999)

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

       peRama = 0;

       rama = REST_getNextPart(url);
       monitor;
         peRama = %dec(rama:2:0);
        on-error;
         peRama = 0;
       endmon;

       x = 0;
       clear peDs02;
       clear peDs02C;
       if peRama > 0;
         SVPTAB_getEstados( empr : sucu : peDs02 : peDs02C : peRama : *omit );
       else;
         SVPTAB_getEstados( empr : sucu : peDs02 : peDs02C : *omit : *omit );
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       clear RamaAnt;
       REST_startArray( 'ramas' );
       for x = 1 to peDs02C;
         if RamaAnt <> peDs02(x).t@Rama;
           RamaAnt = peDs02(x).t@Rama;
           if x > 1;
             REST_endArray  ( 'estados' );
             REST_endArray  ( 'rama' );
           endif;

           REST_startArray( 'rama' );
           REST_writeXmlLine( 'empresa' : peDs02(x).t@Empr );
           REST_writeXmlLine( 'sucursal' : peDs02(x).t@Sucu );
           REST_writeXmlLine( 'codigoRama' : %char(peDs02(x).t@Rama) );
           REST_startArray( 'estados' );
         endif;

           REST_startArray( 'estado' );
             REST_writeXmlLine( 'codigoEstado' : %char(peDs02(x).t@Cesi) );
             REST_writeXmlLine( 'descripcionEstado' : %trim(peDs02(x).t@Desi));
             REST_writeXmlLine( 'codEstadoEquivalente' :
                                 %trim(peDs02(x).t@Cese) );
             REST_writeXmlLine( 'subCodEstadoEquivalente' :
                                 %trim(peDs02(x).t@Mar1) );
           REST_endArray  ( 'estado' );

         if x = peDs02C;
           REST_endArray  ( 'estados' );
           REST_endArray  ( 'rama' );
         endif;
       endfor;
       REST_endArray  ( 'ramas' );

       return;

