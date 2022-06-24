     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRTPS: QUOM Versión 2                                       *
      *         Lista de Tipos de Personas                           *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *18-Mar-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

     D uri             s            512a
     D arcd            s              6a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@Arcd          s              6  0
     D @@Desc          s             15a

     D CRLF            c                   x'0d25'

     D @@Ds02          ds                  likeds(set6202_t) dim(999)
     D @@Ds02C         s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D x               s             10i 0

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
       arcd = REST_getNextPart(url);

       monitor;
          @@Arcd = %dec(arcd:6:0);
        on-error;
          @@Arcd = 0;
       endmon;

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine( 'tiposDePersona' : '*BEG' );

       clear @@Ds02;
       @@Ds02C = 0;

       if SVPTAB_getTipoDePersona( @@Arcd
                                 : *omit
                                 : @@Ds02
                                 : @@Ds02C );

         for x = 1 to @@Ds02C;

           clear @@Desc;
           @@Desc = SVPDES_tipoDePersona( @@Ds02(x).t@tipe );

           REST_writeXmlLine('tipoDePersona':'*BEG');
             REST_writeXmlLine('codigo': @@Ds02(x).t@tipe );
              REST_writeXmlLine('nombre': %trim(@@Desc));
              REST_writeXmlLine('exigeDocumento': @@Ds02(x).t@Mar1);
              REST_writeXmlLine('exigeCuit': @@Ds02(x).t@Mar2);
           REST_writeXmlLine('tipoDePersona':'*END');

         endfor;
       endif;

       REST_writeXmlLine( 'tiposDePersona' : '*END' );

       return;

