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
     Fset282    if   e           k disk
     Fset209    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpiau_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D vhaÑ            s              4a
     D cmar            s              9a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@dmod          s             40a
     D peVhan          s              4  0
     D peCmar          s              9  0

     D k1t282          ds                  likerec(s1t282:*key)
     D k1t209          ds                  likerec(g1upos:*key)

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
       cmar = REST_getNextPart(url);

       monitor;
         peVhan = %dec(vhaÑ:4:0);
        on-error;
         peVhan = 0;
       endmon;

       monitor;
         peCmar = %dec(cmar:9:0);
        on-error;
         peCmar = 0;
       endmon;

       k1t282.t@vhan = peVhan;
       k1t282.t@cmar = peCmar;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'modelos' );

       setll %kds(k1t282:2 ) set282;
       reade %kds(k1t282:2 ) set282;
       dow not %eof;

           k1t209.g1cmar = t@cmar;
           k1t209.g1cgru = t@cgru;
           chain %kds(k1t209) set209;
           if %found;
              REST_startArray( 'modelo' );
               REST_writeXmlLine( 'codigoModelo' : %char(t@cgru) );
               REST_writeXmlLine( 'descripcionModelo' : gnomgr );
              REST_endArray( 'modelo' );
           endif;


        reade %kds(k1t282:2 ) set282;
       enddo;

       REST_endArray  ( 'modelos' );

       return;

