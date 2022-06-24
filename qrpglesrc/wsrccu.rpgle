      * ************************************************************ *
      * WSRCCU: Quom Version 2.                                      *
      *         REST: Cierre de comisiones - Resumen                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                       *18-May-2022          *
      * ************************************************************ *

        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f pahccu disk usage(*input) keyed;
        dcl-f cntnau disk usage(*input) keyed;

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

        dcl-s url      varchar(3000);
        dcl-s @@repl   char(65535);
        dcl-s uri      char(512);
        dcl-s nrma     char(7);
        dcl-s coma     char(2);
        dcl-s fema     char(4);
        dcl-s femm     char(2);
        dcl-s sucu     char(2);
        dcl-s empr     char(1);

        dcl-s peNrma   packed(6:0);
        dcl-s peFema   packed(4:0);
        dcl-s peFemm   packed(2:0);

        dcl-ds k1hccu likerec(p1hccu:*key);
        dcl-ds k1tnau likerec(c1tnau:*key);

        dcl-ds peMsgs  likeds (paramMsgs);

        dcl-ds @PsDs psds qualified;
               this  char(10) pos(1);
        end-ds;

        *inlr = *on;

        if not REST_getUri( @psds.this : uri );
           return;
        endif;
        url = %trim(uri);

        empr = REST_getNextPart(url);
        sucu = REST_getNextPart(url);
        coma = REST_getNextPart(url);
        nrma = REST_getNextPart(url);
        fema = REST_getNextPart(url);
        femm = REST_getNextPart(url);

        monitor;
          peNrma = %dec(nrma:7:0);
         on-error;
          peNrma = 0;
        endmon;

        monitor;
          peFema = %dec(fema:4:0);
         on-error;
          peFema = 0;
        endmon;

        monitor;
          peFemm = %dec(femm:2:0);
         on-error;
          peFemm = 0;
        endmon;

        k1tnau.naempr = empr;
        k1tnau.nasucu = sucu;
        k1tnau.nacoma = coma;
        k1tnau.nanrma = peNrma;
        setll %kds(k1tnau) cntnau;
        if not %equal;
           %subst(@@repl:1:2) = coma;
           %subst(@@repl:3:7) = nrma;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'MAY0001'
                        : peMsgs
                        : @@repl
                        : %len(%trim(@@repl)) );
           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           SVPREST_end();
           return;
        endif;

        k1hccu.cuempr = empr;
        k1hccu.cusucu = sucu;
        k1hccu.cucoma = coma;
        k1hccu.cunrma = peNrma;
        k1hccu.cufema = peFema;
        k1hccu.cufemm = peFemm;

        REST_writeHeader();
        REST_writeEncoding();

        REST_startArray( 'comisionesResumen' );

        setll %kds(k1hccu:6) pahccu;
        reade %kds(k1hccu:6) pahccu;
        dow not %eof;
            REST_startArray( 'comisionResumen' );
             REST_writeXmlLine( 'rama' : %char(curama)      );
             REST_writeXmlLine( 'descripcionRama'
                              : SVPDES_rama(curama)         );
             REST_writeXmlLine( 'moneda' : cumon6           );
             REST_writeXmlLine( 'descripcionMoneda'
                              : SVPDES_moneda(cumon6)       );
             REST_writeXmlLine( 'prima'
                              : SVPREST_editImporte(cupri6) );
             REST_writeXmlLine( 'productorNivel1'
                              : SVPREST_editImporte(cucp16) );
             REST_writeXmlLine( 'productorNivel2' : '.00'   );
             REST_writeXmlLine( 'organizador'
                              : SVPREST_editImporte(cucp36) );
             REST_writeXmlLine( 'productorNivel4' : '.00'   );
             REST_writeXmlLine( 'productorNivel5'
                              : SVPREST_editImporte(cucp56) );
             REST_writeXmlLine( 'productorNivel6'
                              : SVPREST_editImporte(cucp66) );
             REST_writeXmlLine( 'productorNivel7' : '.00'   );
             REST_writeXmlLine( 'productorNivel8' : '.00'   );
             REST_writeXmlLine( 'productorNivel9' : '.00'   );
             REST_writeXmlLine( 'cobranza'
                              : SVPREST_editImporte(cucco6) );
            REST_endArray  ( 'comisionResumen' );
         reade %kds(k1hccu:6) pahccu;
        enddo;

        REST_endArray  ( 'comisionesResumen' );
        return;

