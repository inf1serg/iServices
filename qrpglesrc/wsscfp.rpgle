     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSCFP: BPM                                                  *
      *         Lista de Formas de Pagos.                            *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *01-Sep-2021            *
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
     D empr            s              1a
     D sucu            s              2a

     D x               s             10i 0

     D rc              s              1n
     D peDsFpC         s             10i 0
     D peDsFp          ds                  likeds(dsCntcfp_t) dim(99)

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

       clear peDsFp;
       clear peDsFpC;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'formasDePagos' );
       if SVPTAB_listaFormasDePagos( empr : sucu : peDsFp : peDsFpC : *omit );
         for x = 1 to peDsFpC;
           REST_startArray( 'formaDePago' );
             REST_writeXmlLine( 'empresa' : peDsFp(x).fpEmpr );
             REST_writeXmlLine( 'sucursal' : peDsFp(x).fpSucu );
             REST_writeXmlLine( 'codFormaDePago' : %char(peDsFp(x).fpIvcv) );
             REST_writeXmlLine( 'descripFormaDePago' :
                                 %trim(peDsFp(x).fpIvdv) );
             REST_writeXmlLine( 'codigoEquivalente' : peDsFp(x).fpMar1 );
             REST_writeXmlLine( 'default' : peDsFp(x).fpMar2 );
             REST_writeXmlLine( 'negocioDePoliza' : peDsFp(x).fpMar3 );
             REST_writeXmlLine( 'permitePagarEmbargARBA' : peDsFp(x).fpMar4 );
             REST_writeXmlLine( 'puedePagarCuitPasEmb' : peDsFp(x).fpMar4 );
           REST_endArray  ( 'formaDePago' );
         endfor;
       endif;
       REST_endArray  ( 'formasDePagos');

       return;

