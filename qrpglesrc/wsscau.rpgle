     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRCAU: BPM                                                  *
      *         Lista causa de siniestro.                            *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *25-Ago-2021            *
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
     D rama            s              2a

     D x               s             10i 0
     D peRama          s              2  0
     D RamaAnt         s              2  0

     D rc              s              1n
     D peDs01C         s             10i 0
     D peDs01          ds                  likeds(set401_t) dim(9999)

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
       peRama = 0;
       //if url <> *blanks;
         rama = REST_getNextPart(url);
         monitor;
           peRama = %dec(rama:2:0);
          on-error;
           peRama = 0;
         endmon;
       //endif;

       x = 0;
       clear peDs01;
       clear peDs01C;
       if peRama > 0;
         SVPTAB_getCausas( peDs01 : peDs01C : peRama : *omit );
       else;
         SVPTAB_getCausas( peDs01 : peDs01C : *omit : *omit );
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       clear RamaAnt;
       REST_startArray( 'ramas' );
       for x = 1 to peDs01C;
         if RamaAnt <> peDs01(x).t@Rama;
           RamaAnt = peDs01(x).t@Rama;
           if x > 1;
             REST_endArray  ( 'causas' );
             REST_endArray  ( 'rama' );
           endif;

           REST_startArray( 'rama' );
           REST_writeXmlLine( 'codigoRama' : %char(peDs01(x).t@Rama) );
           REST_startArray( 'causas' );
         endif;

           REST_startArray( 'causa' );
             REST_writeXmlLine( 'codigoCausa' : %char(peDs01(x).t@Cauc) );
             REST_writeXmlLine( 'descripcionCausa' : %trim(peDs01(x).t@Caud) );
             REST_writeXmlLine( 'reposicion' : %trim(peDs01(x).t@mar1) );
             REST_writeXmlLine( 'descripCausaPlanesMund' :
                                 %trim(peDs01(x).t@Dcpm) );
           REST_endArray  ( 'causa' );

         if x = peDs01C;
           REST_endArray  ( 'causas' );
           REST_endArray  ( 'rama' );
         endif;
       endfor;
       REST_endArray  ( 'ramas' );

       return;

