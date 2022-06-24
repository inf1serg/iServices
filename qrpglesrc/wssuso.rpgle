     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSTVE: BPM                                                  *
      *         Lista Usos de Vehículos                              *
      * ------------------------------------------------------------ *
      * Nestor Nestor                        *31-Ago-2021            *
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
     D tipo            s              1a

     D x               s             10i 0

     D rc              s              1n
     D peDsUvC         s             10i 0
     D peDsUv          ds                  likeds(dsset211_t) dim(99)

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

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'usos' );
        clear peDsUv;
        if SVPTAB_ListaUsos( peDsUv : peDsUvC );
         for x = 1 to peDsUvC;
           REST_startArray( 'uso' );
             REST_writeXmlLine( 'codigoDeUsoVehiculo'
                                : %editc(peDsUv(x).t@vhuv:'Z'));
             REST_writeXmlLine( 'descripcionUsoVehiculo'
                                : %trim(peDsUv(x).t@vhdu) );
             REST_writeXmlLine( 'modoSeleccionLimite'
                                : %trim(peDsUv(x).t@tli1) );
             REST_writeXmlLine( 'usoVehiculoEquivalente'
                                : %trim(peDsUv(x).t@vhue) );
             REST_writeXmlLine( 'codigoUsoSSN'
                                : %trim(peDsUv(x).t@cusn) );
             REST_writeXmlLine( 'incluyeWeb'
                                : %trim(peDsUv(x).t@mweb) );
           REST_endArray  ( 'uso' );
         endfor;
        endif;
       REST_endArray  ( 'usos');

       return;

