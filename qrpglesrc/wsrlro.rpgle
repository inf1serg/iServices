     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRLRO: QUOM Versión 2                                       *
      *         Libros Rubricados - Quincenas.                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Jul-2017            *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'

     D WSLLRO          pr                  ExtPgm('WSLLRO')
     D   peLqui                            likeds(setlro_t) dim(24)
     D   peLquiC                     10i 0

     D x               s             10i 0
     D peLqui          ds                  likeds(setlro_t) dim(24)
     D peLquiC         s             10i 0

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       WSLLRO( peLqui: peLquiC );

       REST_writeHeader();
       REST_write('<?xml version="1.0" encoding="ISO-8859-1"?>');
       REST_writeXmlLine( 'librosRubricados' : '*BEG');

       for x = 1 to peLquiC;
           REST_writeXmlLine( 'registro' : '*BEG' );
           REST_writeXmlLine( 'quincena' : %editc(peLqui(x).quin:'X') );
           REST_writeXmlLine( 'anio'     : %editc(peLqui(x).fema:'X') );
           REST_writeXmlLine( 'mes'      : %editc(peLqui(x).femm:'X') );
           REST_writeXmlLine( 'descripcion': %trim(peLqui(x).desc) );
           REST_writeXmlLine( 'registro' : '*END' );
       endfor;

       REST_writeXmlLine( 'librosRubricados' : '*END');

       REST_end();

       return;

      /end-free
