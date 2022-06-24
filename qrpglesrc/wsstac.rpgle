     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSTAC: BPM                                                  *
      *         Lista Tipo de accidentes.                            *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *27-Ago-2021            *
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
     D peDs29C         s             10i 0
     D peDs29          ds                  likeds(set429_t) dim(99)

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

       clear peDs29;
       clear peDs29C;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'accidentes' );
       if SVPTAB_listaTipoAccidente( empr : sucu : peDs29 : peDs29C : *omit );
         for x = 1 to peDs29C;
           REST_startArray( 'accidente' );
             REST_writeXmlLine( 'empresa' : peDs29(x).t@Empr );
             REST_writeXmlLine( 'sucursal' : peDs29(x).t@Sucu );
             REST_writeXmlLine( 'codigoAccidente' : %char(peDs29(x).t@Cdcs) );
             REST_writeXmlLine( 'descripcionAccidente' :
                                 %trim(peDs29(x).t@Ddcs) );
           REST_endArray  ( 'accidente' );
         endfor;
       endif;
       REST_endArray  ( 'accidentes');

       return;

