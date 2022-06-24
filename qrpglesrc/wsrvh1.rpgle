     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRVEH: QUOM Versión 2                                       *
      *         Marcas de Vehiculos por año.                         *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *20-Jun-2017            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fset281    if   e           k disk
     Fset20105  if   e           k disk    prefix(zz:2)

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpiau_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D vhaÑ            s              4a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D peVhan          s              4  0
     D @@dmar          s             15a
     D peVehi          ds                  likeds(iauto2_t)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       vhaÑ = REST_getNextPart(url);

       monitor;
         peVhan = %dec(vhaÑ:4:0);
        on-error;
         peVhan = 0;
       endmon;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'marcas' );

       setll peVhan set281;
       reade peVhan set281;
       dow not %eof;

           if SVPIAU_chkMarca( t@cmar );

              chain t@cmar set20105;
              if not %found;
                 zzorde = 0;
              endif;

              rc2 = SVPIAU_getMarca( t@cmar : @@dmar );
              REST_startArray( 'marca' );
               REST_writeXmlLine( 'orden' : %char(zzorde) );
               REST_writeXmlLine( 'codigoMarca' : %char(t@cmar) );
               REST_writeXmlLine( 'descripcionMarca' : @@dmar );
              REST_endArray( 'marca' );
           endif;

        reade peVhan set281;
       enddo;

       REST_endArray  ( 'marcas' );

       return;

