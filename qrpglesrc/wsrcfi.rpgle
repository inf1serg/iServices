     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRLLO: BPM                                                  *
      *         Lista de localidades                                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *02-Jul-2021            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D SPCOBFIN        pr                  extpgm('SPCOBFIN')
     D  p@empr                        1a
     D  p@sucu                        2a
     D  p@arcd                        6  0
     D  p@spol                        9  0
     D  p@fech                        8  0 const
     D  p@conv                        1
     D  p@cobf                         n
     D  p@fpgm                        3    const

     D uri             s            512a
     D url             s           3000a   varying
     D empr            s              1a
     D sucu            s              2a
     D arcd            s              6a
     D spol            s              9a
     D fech            s              8a
     D conv            s              1a

     D peArcd          s              6  0
     D peSpol          s              9  0
     D peFech          s              8  0
     D peCobf          s              1n
     D rc              s              1n
     D x               s             10i 0
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)

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
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);
       fech = REST_getNextPart(url);
       conv = REST_getNextPart(url);
       if conv <> 'P' and conv <> 'A';
          conv = 'A';
       endif;

       monitor;
          peArcd = %dec(arcd:6:0);
        on-error;
          peArcd = 0;
       endmon;

       monitor;
          peSpol = %dec(spol:9:0);
        on-error;
          peSpol = 0;
       endmon;

       monitor;
          peFech = %dec(fech:9:0);
        on-error;
          peFech = 0;
       endmon;

       if SPVSPO_chkSpol( empr
                        : sucu
                        : peArcd
                        : peSpol ) = *off;
          %subst(@@repl:1:6) = %trim(%char(peArcd));
          %subst(@@repl:7:9) = %trim(%char(peSpol));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPO0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'SPO0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          return;
       endif;

       SPCOBFIN( empr
               : sucu
               : peArcd
               : peSpol
               : peFech
               : conv
               : peCobf
               : *blanks   );

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'coberturaFinanciera' );
        if peCobf;
           REST_writeXmlLine( 'tiene' : 'true' );
         else;
           REST_writeXmlLine( 'tiene' : 'false' );
        endif;
       REST_endArray  ( 'coberturaFinanciera' );

       SPCOBFIN( empr
               : sucu
               : peArcd
               : peSpol
               : peFech
               : conv
               : peCobf
               : 'FIN'   );

       return;

