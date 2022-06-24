     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRLCT: QUOM Versión 2                                       *
      *         Lista de tarjetas de credito.                        *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Feb-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/wsltab_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D url             s           3000a   varying
     D peLtac          ds                  likeds(gnttc1_t) dim(999)
     D peLtacC         s             10i 0
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

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);

       WSLTAB_listaTarjetasDeCredito(peLtac:peLtacC);

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'tarjetas' );

       for x = 1 to peLtacC;
        REST_startArray( 'tarjeta' );
         REST_writeXmlLine('codigo' : %trim(%char(peLtac(x).ctcu)) );
         REST_writeXmlLine('nombreTarjeta' : %trim(peLtac(x).nomb) );
         REST_writeXmlLine('codigoEq' : %trim(peLtac(x).ctce) );
         REST_writeXmlLine('cantidadDigitos': %trim(%char(peLtac(x).cdnt)));
        REST_endArray  ( 'tarjeta' );
       endfor;


       REST_endArray  ( 'tarjetas' );

       return;
