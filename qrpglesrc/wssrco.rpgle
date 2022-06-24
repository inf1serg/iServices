     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSRCO: BPM                                                  *
      *         Lista Relacion Coberturas Hecho Generador            *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        *03-Set-2021            *
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
     D Cobl            s              2a

     D x               s             10i 0
     D peCobl          s              2a
     D peCoblAnt       s              2a   inz('  ')

     D rc              s              1n
     D peDsChC         s             10i 0
     D peDsCh          ds                  likeds(dsset412_t) dim(999)

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
       peCobl = *blanks;


         cobl = REST_getNextPart(url);
         peCobl = cobl ;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'relaciones' );
          if peCobl > '  ';
            SVPTAB_relacionCoberturaYHechoGen( peDsCh : peDsChC : peCobl );
             Else;
            SVPTAB_relacionCoberturaYHechoGen( peDsCh : peDsChC : *omit );
          endif;
       // Lee relaciones obtenidas
           for x = 1 to peDsChC;
       // Pregunta si la relacion es igual a al anterior
            if peCoblAnt<>peDsCh(x).t@Cobl;
       // Pregunta si no es el primero pero cambio, cierra tag relacion y coberturas dentro del for
              if peCoblAnt<>*blanks;
                REST_endArray  ( 'coberturas' );
                REST_endArray  ( 'relacion' );
              endif;

              REST_startArray( 'relacion');
              REST_writeXmlLine( 'codigoCoberturaLetra'
                                 : %trim(peDsCh(x).t@Cobl) );
            REST_startArray( 'coberturas');
              eval peCoblAnt=peDsCh(x).t@Cobl;
            endif;

            REST_startArray( 'cobertura');
            REST_writeXmlLine( 'codigoCoberturas'
                               : %editc(peDsCh(x).t@Xcob:'Z'));
            REST_writeXmlLine( 'hechoGenerador'
                               : %trim(peDsCh(x).t@Hecg) );
            REST_endArray  ( 'cobertura' );
           endfor;
           REST_endArray  ( 'coberturas' );
           REST_endArray  ( 'relacion' );
       REST_endArray  ( 'relaciones' );

       return;

