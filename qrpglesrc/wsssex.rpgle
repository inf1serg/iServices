     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSSEX: BPM                                                  *
      *         Lista de Sexos                                       *
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
     D peDsSeC         s             10i 0
     D peDsSe          ds                  likeds(dsgntsex_t) dim(99)

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

       REST_startArray( 'sexos' );
        if SVPTAB_ListaSexos( peDsSe : peDsSeC );
         for x = 1 to peDsSeC;
           REST_startArray( 'sexo' );
             REST_writeXmlLine( 'codigoSexo'
                                : %editc(peDsSe(x).secsex:'Z'));
             REST_writeXmlLine( 'descripcionSexo'
                                : %trim(peDsSe(x).sedsex) );
             REST_writeXmlLine( 'codigoSexoSSN'
                                : %trim(peDsSe(x).secgen) );
             REST_writeXmlLine( 'incluyeWeb'
                                : %trim(peDsSe(x).semweb) );
           REST_endArray  ( 'sexo' );
         endfor;
        endif;
       REST_endArray  ( 'sexos' );

       return;

