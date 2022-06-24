     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSCOL: BPM                                                  *
      *         Lista Colision con.                                  *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *31-Ago-2021            *
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
     D peDs42C         s             10i 0
     D peDs42          ds                  likeds(set442_t) dim(99)

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

       clear peDs42;
       clear peDs42C;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'colisiones' );
       if SVPTAB_listaTipoColision( empr : sucu : peDs42 : peDs42C : *omit );
         for x = 1 to peDs42C;
           REST_startArray( 'colision' );
             REST_writeXmlLine( 'empresa' : peDs42(x).t@Empr );
             REST_writeXmlLine( 'sucursal' : peDs42(x).t@Sucu );
             REST_writeXmlLine( 'codigoColision' : %char(peDs42(x).t@Ctco)  );
             REST_writeXmlLine( 'descripcionColision' :
                                 %trim(peDs42(x).t@Ctcd) );
           REST_endArray  ( 'colision' );
         endfor;
       endif;
       REST_endArray  ( 'colisiones');

       return;

