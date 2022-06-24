     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCRI: QUOM Versión 2                                       *
      *         Listado de tipos de Cristales                        *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *01-Feb-2019            *
      * ************************************************************ *
     Fset27201  if   e           k disk

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
       REST_writeXmlLine( 'tiposDeCristal' : '*BEG' );

       setll *loval set27201;
       read set27201;
       dow not %eof( set27201);

         REST_writeXmlLine( 'tipoDeCristal' : '*BEG' );
           REST_writeXmlLine('codigo' : %trim(%editc(t@Ccri:'X')));
           REST_writeXmlLine('descripcion' : %trim(t@Dcri));
           REST_writeXmlLine('orden' : %trim(%editc(t@Orde:'X')));
         REST_writeXmlLine( 'tipoDeCristal' : '*END' );

         read set27201;

       enddo;

       REST_writeXmlLine( 'tiposDeCristal' : '*END' );

       return;

      /end-free

