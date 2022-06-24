     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSTVE: BPM                                                  *
      *         Lista Tipos de Vehículos                             *
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
     D peDsTvC         s             10i 0
     D peDsTv          ds                  likeds(dsset210_t) dim(99)

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

       REST_startArray( 'tiposDeVehiculos' );
        if SVPTAB_ListaTipoDeVehiculos( peDsTv : peDsTvC );
         for x = 1 to peDsTvC;
           REST_startArray( 'tipoDeVehiculo' );
             REST_writeXmlLine( 'tipoVehiculo'
                                : %editc(peDsTv(x).t@vhct:'Z'));
             REST_writeXmlLine( 'descripcionTipoVehiculo'
                                : %trim(peDsTv(x).t@vhdt) );
             REST_writeXmlLine( 'modoSeleccionLimite'
                                : %trim(peDsTv(x).t@tlim) );
             REST_writeXmlLine( 'tipoVehiculoEquivalente'
                                : %trim(peDsTv(x).t@vhte) );
             REST_writeXmlLine( 'tipoVehiculoEquivSSN'
                                : %editc(peDsTv(x).t@ctvh:'Z'));
             REST_writeXmlLine( 'incluyeWeb'
                                : %trim(peDsTv(x).t@mweb) );
           REST_endArray  ( 'tipoDeVehiculo' );
         endfor;
        endif;
       REST_endArray  ( 'tiposDeVehiculos');

       return;

