     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRCJU: QUOM Versión 2                                       *
      *         Marcar Caratulas como ya listadas.                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *06-Jul-2020            *
      * ************************************************************ *
     Fset644    uf   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D nres            s              7a
     D @@nres          s              7  0
     D rc              s              1n
     D uri             s            512a
     D url             s           3000a   varying

     D k1t644          ds                  likerec(s1t644:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  user                         10a   overlay(psds:358)

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
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nres = REST_getNextPart(url);

       monitor;
          @@nres = %dec(nres:7:0);
        on-error;
          @@nres = 0;
       endmon;

       k1t644.t@empr = empr;
       k1t644.t@sucu = sucu;
       k1t644.t@nres = @@nres;

       chain %kds(k1t644:3) set644;
       if %found;
          t@mar1 = '1';
           t@use1 = psds.user;
           t@dat1 = %dec(%date():*iso);
           t@tim1 = %dec(%time():*iso);
          update s1t644;
       endif;

       REST_writeHeader();
       REST_writeEncoding();
       REST_startArray( 'caratula' );
        REST_writeXmlLine( 'actualizada' : 'OK');
       REST_endArray( 'caratula' );
       REST_end();

       close *all;

       return;

      /end-free
