     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRTUR: BPM                                                  *
      *         Lista Momento del día.                               *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *30-Ago-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying

     D x               s             10i 0

     D rc              s              1n

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

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'turnos' );
         REST_startArray( 'turno' );
           REST_writeXmlLine( 'codigoTurno' : 'D' );
           REST_writeXmlLine( 'descripcionTurno' : 'Diurno' );
         REST_endArray  ( 'turno' );

         REST_startArray( 'turno' );
           REST_writeXmlLine( 'codigoTurno' : 'N' );
           REST_writeXmlLine( 'descripcionTurno' : 'Nocturno' );
         REST_endArray  ( 'turno' );
       REST_endArray  ( 'turnos' );

       return;

