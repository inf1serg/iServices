     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRRUE: QUOM Versión 2                                       *
      *         Listado de tipos de Ruedas                           *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *01-Feb-2019            *
      * ************************************************************ *
     Fset27301  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@repl          s          65535a
     D tmpfec          s               d   datfmt(*iso) inz

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'tiposDeRueda' : '*BEG' );

       setll *loval set27301;
       read set27301;
       dow not %eof( set27301);

         REST_writeXmlLine( 'tipoDeRueda' : '*BEG' );
           REST_writeXmlLine('codigo' : %trim(%editc(t@Crue:'X')));
           REST_writeXmlLine('descripcion' : %trim(t@Drue));
           REST_writeXmlLine('orden' : %trim(%editc(t@Orde:'X')));
         REST_writeXmlLine( 'tipoDeRueda' : '*END' );

         read set27301;

       enddo;

       REST_writeXmlLine( 'tiposDeRueda' : '*END' );

       return;

      /end-free

