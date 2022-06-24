     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRLOS: BPM                                                  *
      *         Lista Lugar de ocurrencia de siniestro (PRISMA).     *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *20-Ago-2021            *
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

     D x               s             10i 0

     D rc              s              1n
     D peDsLpC         s             10i 0
     D peDsLp          ds                  likeds(set405_t) dim(99)

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

       clear peDsLp;
       clear peDsLpC;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'lugares' );
       if SVPTAB_getLugarPRISMA( peDsLp : peDsLpC : *omit );
         for x = 1 to peDsLpC;
           REST_startArray( 'lugar' );
             REST_writeXmlLine( 'codigoLugar' : %trim(peDsLp(x).t@Clos) );
             REST_writeXmlLine( 'descripcionLugar' : %trim(peDsLp(x).t@Dlos) );
           REST_endArray  ( 'lugar' );
         endfor;
       endif;
       REST_endArray  ( 'lugares' );

       return;

