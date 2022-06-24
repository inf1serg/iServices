     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRFEF: QUOM Versión 2                                       *
      *         Verifica Fecha Feriado.                              *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        *15-Ene-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D fech            s             10a
     D url             s           3000a   varying
     D rc              s              1n
     D @@aÑo           s              4  0
     D @@mes           s              2  0
     D @@dia           s              2  0
     D fecha           s              8  0
     D es_habil        s              1n

     D CRLF            c                   x'0d25'

     D lda             ds                  qualified dtaara(*lda)
     D  empr                          1a   overlay(lda:401)
     D  sucu                          2a   overlay(lda:*next)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

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
       fech = REST_getNextPart(url);

       in lda;
       lda.empr = empr;
       lda.sucu = sucu;
       out lda;

       REST_writeHeader();
       rc = REST_writeEncoding();
       if rc = *off;
          return;
       endif;

       monitor;
          @@aÑo = %dec(%subst(fech:1:4):4:0);
        on-error;
          @@aÑo = 0;
       endmon;

       monitor;
          @@mes = %dec(%subst(fech:6:2):2:0);
        on-error;
          @@mes = 0;
       endmon;

       monitor;
          @@dia = %dec(%subst(fech:9:2):2:0);
        on-error;
          @@dia = 0;
       endmon;

       fecha = (@@aÑo * 10000)
             + (@@mes *   100)
             +  @@dia;

       es_habil = SPVFEC_FechaHabil8( fecha : *omit );


       REST_startArray( 'fechaHabil' );
        if es_habil;
           REST_writeXmlLine( 'esFeriado' : '0' );
         else;
           REST_writeXmlLine( 'esFeriado' : '1' );
        endif;
       REST_endArray( 'fechaHabil' );

       return;

      /end-free

