     H option(*srcstmt) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRPS1: QUOM Versión 2                                       *
      *         Predenuncia Siniestros Web - Roba Número             *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Ene-2018            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svppds_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@npds          s              7  0

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

       REST_writeHeader();
       REST_writeEncoding();

       @@npds = SVPPDS_getNroPreDenuncia( empr : sucu );

       REST_writeXmlLine( 'predenuncia' : '*BEG' );
       REST_writeXmlLine( 'nroPreDenuncia' : %trim(%char(@@npds)) );
       REST_writeXmlLine( 'predenuncia' : '*END' );

       REST_end();
       return;

      /end-free

