     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSCAR: BPM                                                  *
      *         Lista de Carrocerias                                 *
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
     D peDsCaC         s             10i 0
     D peDsCa          ds                  likeds(dsset205_t) dim(99)

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

       REST_startArray( 'carrocerias' );
        if SVPTAB_ListaCarrocerias( peDsCa : peDsCaC );
         for x = 1 to peDsCaC;
           REST_startArray( 'carroceria' );
             REST_writeXmlLine( 'codigoCarroceria'
                                : %trim(peDsCa(x).t@vhcr) );
             REST_writeXmlLine( 'descricionCarroceria'
                                : %trim(peDsCa(x).t@vhcd) );
           REST_endArray  ( 'carroceria' );
         endfor;
        endif;
       REST_endArray  ( 'carrocerias');

       return;

