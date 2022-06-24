     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRTXR: BPM                                                  *
      *         Lista texto de recibos                               *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *02-Ago-2021            *
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
     D rama            s              2a
     D tpcd            s              2a

     D x               s             10i 0
     D fecha           s             10a
     D peRama          s              2  0
     D RamaAnt         s              2  0

     D rc              s              1n
     D peDsTxC         s             10i 0
     D peDsTx          ds                  likeds(dsSet124_t) dim(99999)

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
       peRama = 0;
       rama = REST_getNextPart(url);
       tpcd = REST_getNextPart(url);
       monitor;
         peRama = %dec(rama:2:0);
        on-error;
         peRama = 0;
       endmon;

       x = 0;
       clear peDsTx;
       clear peDsTxC;
       select;
         when peRama > 0 and Tpcd <> *blanks;
           SVPTAB_listaTextoPreseteado( peDsTx : peDsTxC : peRama : Tpcd
                                      : *omit );
         when peRama > 0 and Tpcd = *blanks;
           SVPTAB_listaTextoPreseteado( peDsTx : peDsTxC : peRama : *omit
                                      : *omit );
         other;
           SVPTAB_listaTextoPreseteado( peDsTx : peDsTxC : *omit : *omit
                                      : *omit );
       endsl;

       REST_writeHeader();
       REST_writeEncoding();

       clear RamaAnt;
       REST_startArray( 'ramas' );
       for x = 1 to peDsTxC;
         if RamaAnt <> peDsTx(x).t@Rama;
           RamaAnt = peDsTx(x).t@Rama;
           if x > 1;
             REST_endArray  ( 'textoDeRecibos' );
             REST_endArray  ( 'rama' );
           endif;

           REST_startArray( 'rama' );
           REST_writeXmlLine( 'codigoRama' : %char(peDsTx(x).t@Rama) );
           REST_startArray( 'textoDeRecibos' );
         endif;

         if peDsTx(x).t@Rama = *zeros and x = 1;
           REST_startArray( 'rama' );
           REST_writeXmlLine( 'codigoRama' : %char(peDsTx(x).t@Rama) );
           REST_startArray( 'textoDeRecibos' );
         endif;

           Monitor;
             fecha = %char(%date( %char ( peDsTx(x).t@Fvmp ) : *iso0 ));
           on-error;
             fecha = '0001-01-01';
           endmon;

           REST_startArray( 'textoDeRecibo' );
             REST_writeXmlLine( 'textoPreseteado' : %trim(peDsTx(x).t@Tpcd) );
             REST_writeXmlLine( 'lineaDeTexto' : %char(peDsTx(x).t@Tpnl) );
             REST_writeXmlLine( 'reglonDeTexto' : %trim(peDsTx(x).t@Tpds)    );
             REST_writeXmlLine( 'imprimirDatosProd' : %trim(peDsTx(x).t@Mipp));
             REST_writeXmlLine( 'vigenciaDatosProd' : %trim( fecha ));
           REST_endArray  ( 'textoDeRecibo' );

         if x = peDsTxC;
           REST_endArray  ( 'textoDeRecibos' );
           REST_endArray  ( 'rama' );
         endif;
       endfor;
       REST_endArray  ( 'ramas' );

       return;

