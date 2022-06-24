     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSTIC: BPM                                                  *
      *         Lista de Impuestos                                   *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        *03-Set-2021            *
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
     D peDsDmC         s             10i 0
     D peDsDm          ds                  likeds(dsgntdim_t) dim(99)

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

       REST_startArray( 'impuestos' );
        if SVPTAB_ListaImpuestos( peDsDm : peDsDmC );
         for x = 1 to peDsDmC;
           REST_startArray( 'impuesto' );
             REST_writeXmlLine( 'codTipoImpuesto'
                                : %trim(peDsDm(x).diTiic) );
             REST_writeXmlLine( 'descripTipoImpuesto'
                                : %trim(peDsDm(x).diTiid) );
             REST_writeXmlLine( 'codigoBloqueo'
                                : %trim(peDsDm(x).diBloq) );
             REST_writeXmlLine( 'obligatorio'
                                : %trim(peDsDm(x).diMar1) );
             REST_writeXmlLine( 'relacionadoConAporte'
                                : %trim(peDsDm(x).diTii1) );
             REST_writeXmlLine( 'rutaNombre'
                                : %trim(peDsDm(x).diPath) );
             REST_writeXmlLine( 'codigoRegimen'
                                : %editc(peDsDm(x).diCreg:'Z'));
           REST_endArray  ( 'impuesto' );
         endfor;
        endif;
       REST_endArray  ( 'impuestos' );

       return;

