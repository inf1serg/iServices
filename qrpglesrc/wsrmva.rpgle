     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRMVA: Portal de Autogestión de Asegurados.                 *
      *         Motivos de Arrepentimiento.                          *
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

       REST_startArray( 'motivosArrepentimiento' );

       REST_startArray( 'motivoArrepentimiento' );
        REST_writeXmlLine( 'codigo'       : '01' );
        REST_writeXmlLine( 'descripcion'  : 'No solicité este seguro' );
       REST_endArray  ( 'motivoArrepentimiento' );

       REST_startArray( 'motivoArrepentimiento' );
        REST_writeXmlLine( 'codigo'       : '02' );
        REST_writeXmlLine( 'descripcion'  : 'Costos' );
       REST_endArray  ( 'motivoArrepentimiento' );

       REST_startArray( 'motivoArrepentimiento' );
        REST_writeXmlLine( 'codigo'       : '03' );
        REST_writeXmlLine( 'descripcion'
                         : 'Estoy disconforme con el servicio' );
       REST_endArray  ( 'motivoArrepentimiento' );

       REST_startArray( 'motivoArrepentimiento' );
        REST_writeXmlLine( 'codigo'       : '04' );
        REST_writeXmlLine( 'descripcion'  : 'Seguro duplicado' );
       REST_endArray  ( 'motivoArrepentimiento' );

       REST_startArray( 'motivoArrepentimiento' );
        REST_writeXmlLine( 'codigo'       : '99' );
        REST_writeXmlLine( 'descripcion'  : 'Otros' );
       REST_endArray  ( 'motivoArrepentimiento' );

       REST_endArray  ( 'motivosArrepentimiento' );

       return;

      /end-free
