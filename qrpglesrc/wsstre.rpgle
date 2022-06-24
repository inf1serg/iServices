     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRTRE: BPM                                                  *
      *         Lista tipo de recibo.                                *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *02-Ago-2021            *
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
     D peDs26C         s             10i 0
     D peDs26          ds                  likeds(dsSet426_t) dim(9999)

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
       clear peDs26;
       clear peDs26C;
       if peRama > 0;
         SVPTAB_listaTipoDeRecibo( peDs26 : peDs26C : peRama : *omit );
       else;
         SVPTAB_listaTipoDeRecibo( peDs26 : peDs26C : *omit : *omit );
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       clear RamaAnt;
       REST_startArray( 'ramas' );
       for x = 1 to peDs26C;
         if RamaAnt <> peDs26(x).t@Rama;
           RamaAnt = peDs26(x).t@Rama;
           if x > 1;
             REST_endArray  ( 'recibos' );
             REST_endArray  ( 'rama' );
           endif;

           REST_startArray( 'rama' );
           REST_writeXmlLine( 'codigoRama' : %char(peDs26(x).t@Rama) );
           REST_startArray( 'recibos' );
         endif;

           REST_startArray( 'recibo' );
             REST_writeXmlLine( 'tipoDeRecibo' : %char(peDs26(x).t@Tire) );
             REST_writeXmlLine( 'codigoDeTexto' : %trim(peDs26(x).t@Cotx) );
             REST_writeXmlLine( 'permiteModificar' : %trim(peDs26(x).t@mar1) );
             REST_writeXmlLine( 'bloqueado' : %trim(peDs26(x).t@Mar2) );
             REST_writeXmlLine( 'descripcion' : %trim(peDs26(x).t@Dire) );
           REST_endArray  ( 'recibo' );

         if x = peDs26C;
           REST_endArray  ( 'recibos' );
           REST_endArray  ( 'rama' );
         endif;
       endfor;
       REST_endArray  ( 'ramas' );

       return;

