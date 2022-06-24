      * ************************************************************ *
      * WSRCCR: Quom Version 2.                                      *
      *         REST: Cierre de comisiones - Retenciones             *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                       *18-May-2022          *
      * ************************************************************ *

        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f pahccr disk usage(*input) keyed;
        dcl-f cntnau disk usage(*input) keyed;

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

        dcl-s url      varchar(3000);
        dcl-s @@repl   char(65535);
        dcl-s uri      char(512);
        dcl-s @@rete   char(20);
        dcl-s nrma     char(7);
        dcl-s coma     char(2);
        dcl-s fema     char(4);
        dcl-s femm     char(2);
        dcl-s sucu     char(2);
        dcl-s empr     char(1);

        dcl-s peNrma   packed(6:0);
        dcl-s peFema   packed(4:0);
        dcl-s peFemm   packed(2:0);

        dcl-ds k1hccr likerec(p1hccr:*key);
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

        k1hccr.crempr = empr;
        k1hccr.crsucu = sucu;
        k1hccr.crcoma = coma;
        k1hccr.crnrma = peNrma;
        k1hccr.crfema = peFema;
        k1hccr.crfemm = peFemm;

        REST_writeHeader();
        REST_writeEncoding();

        REST_startArray( 'comisionesRetenciones' );

        setll %kds(k1hccr:6) pahccr;
        reade %kds(k1hccr:6) pahccr;
        dow not %eof;
            REST_startArray( 'comisionRetenciones' );
             select;
              when crrete = 1;
                   @@rete = 'Ret.Jubilación';
              when crrete = 2;
                   @@rete = 'Ret.Serv.Sociales';
              when crrete = 3;
                   @@rete = 'Ret.Ganancias';
              when crrete = 4;
                   @@rete = 'Ret.Otras 1';
              when crrete = 5;
                   @@rete = 'Ret.SUSS Emplead';
              when crrete = 6;
                   @@rete = 'Ret.Ingr.Brutos';
             endsl;
             REST_writeXmlLine( 'retencion'       : @@rete             );
             REST_writeXmlLine( 'codigoProvinciaInder' : %char(crnupv) );
             REST_writeXmlLine( 'codigoProvinciaGaus'  : crnopv        );
             REST_writeXmlLine( 'descripcionProvincia'
                              : SVPDES_provinciainder(crnupv)          );
             REST_writeXmlLine( 'porcentajeBien'
                              : %editw(crporr:' 0 ,  ')                );
             REST_writeXmlLine( 'porcentajeInterm'
                              : %editw(crporz:' 0 ,  ')                );
             REST_writeXmlLine( 'importe'
                              : SVPREST_editImporte(crimre) );
            REST_endArray  ( 'comisionRetenciones' );
         reade %kds(k1hccr:6) pahccr;
        enddo;

        REST_endArray  ( 'comisionesRetenciones' );
        return;

