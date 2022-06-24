     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSSHGN: BPM                                                  *
      *         Lista de Hechos Generadores                          *
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
     D peDsHgC         s             10i 0
     D peDsHg          ds                  likeds(dsset407_t) dim(99)

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

       REST_startArray( 'hechosGeneradores' );
        if SVPTAB_ListaHechosGeneradores( peDsHg : peDsHGC );
         for x = 1 to peDsHgC;
           REST_startArray( 'hechoGenerador' );
             REST_writeXmlLine( 'codHechoGenerador'
                                : %trim(peDsHg(x).t@Hecg) );
             REST_writeXmlLine( 'decripHechoGenerador'
                                : %trim(peDsHg(x).t@Hecd) );
           REST_endArray  ( 'hechoGenerador' );
         endfor;
        endif;
       REST_endArray  ( 'hechosGeneradores' );

       return;

