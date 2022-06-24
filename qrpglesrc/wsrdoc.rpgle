     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRDOC: QUOM Versión 2                                       *
      *         Tipos de Documento.                                  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Jul-2017            *
      * ------------------------------------------------------------ *
      * SGF 18/09/2018: Agrego tarjeta de circulacion.               *
      * SGF 04/07/2019: Agrego Chequera y Factura.                   *
      *                                                              *
      * ************************************************************ *
     fset089    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray  ( 'documentosPdf' );

       setll *loval set089;
       read set089;
       dow not %eof;
           REST_writeXmlLine( 'documentoPdf' : '*BEG' );
            REST_writeXmlLine( 'codigo' : %trim(t@codi) );
            REST_writeXmlLine( 'descripcion': %trim(t@desc) );
           REST_writeXmlLine( 'documentoPdf' : '*END' );
        read set089;
       enddo;

       REST_endArray    ( 'documentosPdf' );

       REST_end();

       return;

      /end-free
