     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSESC: BPM                                                  *
      *         Lista Estado Civil                                   *
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
     D peDsEsC         s             10i 0
     D peDsEs          ds                  likeds(dsgntesc_t) dim(99)

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

       REST_startArray( 'estadosCiviles' );
        if SVPTAB_ListaEstadoCivil( peDsEs : peDsEsC );
         for x = 1 to peDsEsC;
           REST_startArray( 'estadoCivil' );
             REST_writeXmlLine( 'codigoEstadoCivil'
                                : %editc(peDsEs(x).escesc:'Z'));
             REST_writeXmlLine( 'descripcionEstadoCivil'
                                : %trim(peDsEs(x).esdesc) );
             REST_writeXmlLine( 'estadoCivilSSN'
                                : %trim(peDsEs(x).escece) );
             REST_writeXmlLine( 'incluyeWeb'
                                : %trim(peDsEs(x).esmweb) );
           REST_endArray  ( 'estadoCivil' );
         endfor;
        endif;
       REST_endArray  ( 'estadosCiviles' );

       return;

