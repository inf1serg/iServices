     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRRAZ: QUOM Versión 2                                       *
      *         Lista de razas por mascota.                          *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *17-Mar-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D ctma            s              2a
     D peCtma          s              2  0
     D rc              s              1n

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

     D i               s             10i 0
     D x               s             10i 0
     D cReg            s             10i 0
     D @@Desc          s             40a
     D @@DsRm          ds                  likeds( dsSet138_t ) dim(9999)

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
       ctma = REST_getNextPart(url);
       monitor;
         peCtma = %dec(ctma:2:0);
        on-error;
         peCtma = 0;
       endmon;

       if peCtma = 0;
         REST_writeHeader( 204
                    : *omit
                    : *omit
                    : 'TAB0001'
                    : 40
                    : 'No se encontraron datos del Tipo de Mascota'
                    : 'Verifique la informacion solicitada ') ;

         REST_end();
         return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'razas' );

         cReg = 0;
         clear @@DsRm;

         if SVPTAB_getRelaMascotasWeb( peCtma : @@DsRm : cReg );

           for i = 1 to cReg;
             clear @@Desc;
             @@Desc = SVPDES_razaDeMascota( @@DsRm(i).t@Craz );

             REST_startArray( 'raza' );
               REST_writeXmlLine('codigo' : %char(@@DsRm(i).t@Craz));
               REST_writeXmlLine('descripcion' : %trim(@@Desc));
             REST_endArray( 'raza' );
           endfor;

         else;
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

       REST_endArray  ( 'razas' );

       return;

      /end-free
