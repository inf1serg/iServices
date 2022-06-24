     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRVH0: QUOM Versión 2                                       *
      *         Años de vehiculos.                                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *25-Mar-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fset209    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/wsltab_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0

     D peLani          ds                  likeds(vehanio_t) dim(99)
     D peLaniC         s             10i 0
     D x               s             10i 0

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       REST_writeHeader();
       REST_writeEncoding();

       WSLTAB_listaVehiculosAnios( peLani : peLaniC );

       REST_startArray( 'Anios' );

       for x = 1 to peLaniC;
        REST_startArray( 'peLani' );
         REST_writeXmlLine( 'Anio' : peLani(x).anio );
        REST_endArray( 'peLani' );
       endfor;

       REST_endArray( 'Anios' );

       return;

      /end-free
