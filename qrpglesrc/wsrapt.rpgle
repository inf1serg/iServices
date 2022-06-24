     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRAGB: Portal de Autogestión de Asegurados.                 *
      *         Anular o Arrepentimiento.                            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *19-May-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  curusr                       10a   overlay(psds:358)

      /free

       *inlr = *on;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'planesApTransito' );

        REST_startArray( 'plan' );
         REST_writeXmlLine('codigo' : '620' );
         REST_writeXmlLine('nombre' : 'Opcion Clasica');
         REST_writeXmlLine('sumaAsegurada' : '200000.00');
         REST_writeXmlLine('importeCuota' : '39.36');
         REST_writeXmlLine('costoTotal' : '472.32');
         REST_writeXmlLine('cantidadCuotas' : '12');
        REST_endArray( 'plan' );

        REST_startArray( 'plan' );
         REST_writeXmlLine('codigo' : '621' );
         REST_writeXmlLine('nombre' : 'Opcion Plus');
         REST_writeXmlLine('sumaAsegurada' : '400000.00');
         REST_writeXmlLine('importeCuota' : '76.68');
         REST_writeXmlLine('costoTotal' : '920.16');
         REST_writeXmlLine('cantidadCuotas' : '12');
        REST_endArray( 'plan' );

        REST_startArray( 'plan' );
         REST_writeXmlLine('codigo' : '622' );
         REST_writeXmlLine('nombre' : 'Opcion Super Plus');
         REST_writeXmlLine('sumaAsegurada' : '600000.00');
         REST_writeXmlLine('importeCuota' : '114.00');
         REST_writeXmlLine('costoTotal' : '1368.00');
         REST_writeXmlLine('cantidadCuotas' : '12');
        REST_endArray( 'plan' );

       REST_endArray( 'planesApTransito' );

       return;

      /end-free
