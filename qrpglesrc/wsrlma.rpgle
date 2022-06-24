     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRLMA: QUOM Versión 2                                       *
      *         Lista de tipos de mascota.                           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *17-Mar-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D x               s             10i 0
     D rc              s              1n

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

     D cReg            s             10i 0
     D @@DsTm          ds                  likeds( dsSet136_t ) dim(99)

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

       // Busca datos de Tipo de Mascotas...

       SVPTAB_getTipoMascotasWeb( @@DsTm : cReg );

       if cReg = 0;
         REST_writeHeader( 204
                    : *omit
                    : *omit
                    : 'TAB0001'
                    : 40
                    : 'No se encontraron datos para informar'
                    : 'Verifique la informacion solicitada ') ;

         REST_end();
         return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'mascotas' );
         for x = 1 to cReg;
           REST_startArray( 'mascota' );
             REST_writeXmlLine( 'codigo' : %char( @@DsTm(x).t@Ctma ) );
             REST_writeXmlLine( 'descripcion' : @@DsTm(x).t@Dtma );
           REST_endArray  ( 'mascota' );
         endfor;
       REST_endArray  ( 'mascotas' );

       return;
      /end-free

