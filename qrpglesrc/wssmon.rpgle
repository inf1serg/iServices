     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSMON: BPM                                                  *
      *         Lista de Monedas                                     *
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
     D peDsMoC         s             10i 0
     D peDsMo          ds                  likeds(dsgntmon_t) dim(99)

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

       REST_startArray( 'monedas' );
        if SVPTAB_ListaMonedas( peDsMo : peDsMoC );
         for x = 1 to peDsMoC;
           REST_startArray( 'moneda' );
             REST_writeXmlLine( 'codigo'
                                : %trim(peDsMo(x).mocomo) );
             REST_writeXmlLine( 'nombreMoneda'
                                : %trim(peDsMo(x).monmol) );
             REST_writeXmlLine( 'nombreMonedaAbrev'
                                : %trim(peDsMo(x).monmoc) );
             REST_writeXmlLine( 'monedaEquivalente'
                                : %trim(peDsMo(x).momoeq) );
             REST_writeXmlLine( 'codigoDesplazCot'
                                : %editc(peDsMo(x).mocdco:'Z'));
             REST_writeXmlLine( 'tipoMoneda'
                                : %trim(peDsMo(x).motimo) );
             REST_writeXmlLine( 'codigoBloqueo'
                                : %trim(peDsMo(x).mobloq) );
             REST_writeXmlLine( 'codigoMonedaDGI'
                                : %editc(peDsMo(x).mocomn:'Z'));
             REST_writeXmlLine( 'codigoMonedaSSN'
                                : %trim(peDsMo(x).momssn) );
             REST_writeXmlLine( 'incluyeWeb'
                                : %trim(peDsMo(x).momweb) );
           REST_endArray  ( 'moneda' );
         endfor;
        endif;
       REST_endArray  ( 'monedas' );

       return;

