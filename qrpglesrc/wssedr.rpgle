     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSEDR: BPM                                                  *
      *         Lista estado de reclamo.                             *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *01-Sep-2021            *
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
     D peDsErC         s             10i 0
     D peDsEr          ds                  likeds(dsSet4021_t) dim(9999)

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
       clear peDsEr;
       clear peDsErC;
       if peRama > 0;
         SVPTAB_listaEdoReclamo( empr
                               : sucu
                               : peDsEr
                               : peDsErC
                               : peRama
                               : *omit   );
       else;
         SVPTAB_listaEdoReclamo( empr
                               : sucu
                               : peDsEr
                               : peDsErC
                               : *omit
                               : *omit   );
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       clear RamaAnt;
       REST_startArray( 'ramas' );
       for x = 1 to peDsErC;
         if RamaAnt <> peDsEr(x).t@Rama;
           RamaAnt = peDsEr(x).t@Rama;
           if x > 1;
             REST_endArray  ( 'estados' );
             REST_endArray  ( 'rama' );
           endif;

           REST_startArray( 'rama' );
           REST_writeXmlLine( 'empresa' : peDsEr(x).t@Empr );
           REST_writeXmlLine( 'sucursal' : peDsEr(x).t@Sucu );
           REST_writeXmlLine( 'codigoRama' : %char(peDsEr(x).t@Rama) );
           REST_startArray( 'estados' );
         endif;

           REST_startArray( 'estado' );
             REST_writeXmlLine( 'codigoEstado' : %char(peDsEr(x).t@Cesi) );
             REST_writeXmlLine( 'descripcionEstado' : %trim(peDsEr(x).t@Desi));
             REST_writeXmlLine( 'codEstadoEquivalente' :
                                 %trim(peDsEr(x).t@Cese) );
           REST_endArray  ( 'estado' );

         if x = peDsErC;
           REST_endArray  ( 'estados' );
           REST_endArray  ( 'rama' );
         endif;
       endfor;
       REST_endArray  ( 'ramas' );

       return;

