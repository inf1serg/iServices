     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSVEH: BPM                                                  *
      *         Lista de Vehículos                                   *
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
     D vhan            s              4a
     D cmar            s              9a
     D cgru            s              3a
     D pevhan          s              4s 0
     D peCmar          s              9s 0
     D peCgru          s              3s 0

     D x               s             10i 0

     D rc              s              1n
     D peDsVeC         s             10i 0
     D peDsVe          ds                  likeds(dsset280_t) dim(99999)

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
       pevhan = *zeros ;
       peCmar = *zeros ;
       peCgru = *zeros ;

         vhan = REST_getNextPart(url);
         cmar = REST_getNextPart(url);
         cgru = REST_getNextPart(url);

       monitor;
         pevhan = %dec(vhan:4:0) ;
         on-error;
         peVhan = 0;
       endmon;

       monitor;
         peCmar = %dec(cmar:9:0) ;
         on-error;
         peCmar = 0;
       endmon;

       monitor;
         peCgru = %dec(cgru:3:0) ;
         on-error;
         peCgru = 0;
       endmon;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'vehiculos' );
        if SVPTAB_ListaVehiculos( peDsVe
                                : peDsVeC
                                : peVhan
                                : peCmar
                                : peCgru);
         for x = 1 to peDsVeC;
           REST_startArray( 'vehiculo' );
            REST_startArray( 'aniovehiculos' );
             REST_startArray( 'aniovehiculo' );
              REST_writeXmlLine( 'anio'
                                 : %editc(peDsVe(x).t@vhan:'Z'));
             REST_startArray( 'marcasInfoauto' );
              REST_startArray( 'marcaInfoauto' );
               REST_writeXmlLine( 'codMarcaInfoauto'
                                  : %editc(peDsVe(x).t@cmar:'Z'));
                REST_startArray( 'gruposInfoauto' );
                 REST_startArray( 'grupoInfoauto' );
                  REST_writeXmlLine( 'codGrupoInfoauto'
                                     : %editc(peDsVe(x).t@cgru:'Z'));
                  REST_writeXmlLine( 'codModeloInfoauto'
                                     : %editc(peDsVe(x).t@cmod:'Z'));
                  REST_writeXmlLine( 'marcaDelVehiculo'
                                     : %trim(peDsVe(x).t@vhmc) );
                  REST_writeXmlLine( 'codigoModelo'
                                     : %trim(peDsVe(x).t@vhmo) );
                  REST_writeXmlLine( 'codigoSubmodeloGAUS'
                                     : %trim(peDsVe(x).t@vhcs) );
                  REST_writeXmlLine( 'codigoCarroceria'
                                     : %trim(peDsVe(x).t@vhcr) );
                 REST_endArray  ( 'grupoInfoauto' );
                REST_endArray  ( 'gruposInfoauto' );
              REST_endArray  ( 'marcaInfoauto' );
             REST_endArray  ( 'marcasInfoauto' );
             REST_endArray  ( 'aniovehiculo' );
            REST_endArray  ( 'aniovehiculos' );
           REST_endArray  ( 'vehiculo' );
         endfor;
        endif;
       REST_endArray  ( 'vehiculos');

       return;

