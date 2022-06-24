     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSPAI: BPM                                                  *
      *         Lista de Paises                                      *
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
     D peDsPaC         s             10i 0
     D peDsPa          ds                  likeds(dsgntpai_t) dim(999)

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

       REST_startArray( 'paises' );
        if SVPTAB_ListaPaises( peDsPa : peDsPaC );
         for x = 1 to peDsPaC;
           REST_startArray( 'pais' );
             REST_writeXmlLine( 'codigoPais'
                                : %editc(peDsPa(x).papain:'Z'));
             REST_writeXmlLine( 'descripcionPais'
                                : %trim(peDsPa(x).papaid) );
             REST_writeXmlLine( 'codigoPaisSistema'
                                : %editc(peDsPa(x).papaiq:'Z'));
             REST_writeXmlLine( 'nroOrden'
                                : %editc(peDsPa(x).papaor:'Z'));
             REST_writeXmlLine( 'paisEquivalente'
                                : %editc(peDsPa(x).papais:'Z'));
           REST_endArray  ( 'pais' );
         endfor;
        endif;
       REST_endArray  ( 'paises' );

       return;

