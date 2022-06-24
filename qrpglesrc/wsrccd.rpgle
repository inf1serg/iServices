      * ************************************************************ *
      * WSRCCD: Quom Version 2.                                      *
      *         REST: Cierre de comisiones - Detalle                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                       *18-May-2022          *
      * ************************************************************ *

        ctl-opt
               actgrp(*caller)
               bnddir('HDIILE/HDIBDIR')
               option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
               datfmt(*iso) timfmt(*iso);

        dcl-f pahccd disk usage(*input) keyed;
        dcl-f cntnau disk usage(*input) keyed;
        dcl-f pahec1 disk usage(*input) keyed;

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'

        dcl-s url      varchar(3000);
        dcl-s @@repl   char(65535);
        dcl-s uri      char(512);
        dcl-s nrma     char(7);
        dcl-s coma     char(2);
        dcl-s fema     char(4);
        dcl-s femm     char(2);
        dcl-s sucu     char(2);
        dcl-s empr     char(1);

        dcl-s @@vigd   char(7);

        dcl-s peNrma   packed(6:0);
        dcl-s peFema   packed(4:0);
        dcl-s peFemm   packed(2:0);

        dcl-ds k1hccd likerec(p1hccd:*key);
        dcl-ds k1tnau likerec(c1tnau:*key);
        dcl-ds k1hec1 likerec(p1hec1:*key);

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

        k1hccd.cdempr = empr;
        k1hccd.cdsucu = sucu;
        k1hccd.cdcoma = coma;
        k1hccd.cdnrma = peNrma;
        k1hccd.cdfema = peFema;
        k1hccd.cdfemm = peFemm;

        REST_writeHeader();
        REST_writeEncoding();

        REST_startArray( 'comisionesDetalle' );

        setll %kds(k1hccd:6) pahccd;
        reade %kds(k1hccd:6) pahccd;
        dow not %eof;
            REST_startArray( 'comisionDetalle' );
             REST_writeXmlLine( 'nit1'   : %char(cdnivt) );
             REST_writeXmlLine( 'niv1'   : %char(cdnivc) );
             REST_writeXmlLine( 'moneda' : cdmone        );
             REST_writeXmlLine( 'descripcionMoneda'
                              : SVPDES_moneda(cdmone)    );
             REST_writeXmlLine( 'rama'   : %char(cdrama) );
             REST_writeXmlLine( 'dia' : %char(cdfemd)    );
             REST_writeXmlLine( 'articulo': %char(cdarcd) );
             REST_writeXmlLine( 'superpoliza': %char(cdspol) );
             REST_writeXmlLine( 'suplemento': %editc(cdsspo:'X') );
             REST_writeXmlLine( 'endoso': %char(cdcert)     );
             REST_writeXmlLine( 'cuota': %char(cdnrcu)     );
             REST_writeXmlLine( 'subcuota': %char(cdnrsc)     );
             REST_writeXmlLine( 'plan'    : %char(cdplac)     );
             REST_writeXmlLine( 'asegurado' : %char(cdnoas)     );
             REST_writeXmlLine( 'provincia' : %char(cdibpb)     );
             REST_writeXmlLine( 'porcentaje'
                              : %editw(cdpib1: ' 0,  ')         );
             REST_writeXmlLine( 'primaProporcional'
                              : SVPREST_editImporte(cdprpr)     );
             REST_writeXmlLine( 'premio'
                              : SVPREST_editImporte(cdprem)     );
             REST_writeXmlLine( 'comisionProduccion'
                              : SVPREST_editImporte(cdcopr)     );
             REST_writeXmlLine( 'comisionCobranza'
                              : SVPREST_editImporte(cdccob)     );
             REST_writeXmlLine( 'comisionFomento'
                              : SVPREST_editImporte(cdcofo)     );
             REST_writeXmlLine( 'totalMonedaEmision'
                              : SVPREST_editImporte(cdtcod)     );
             REST_writeXmlLine( 'totalMonedaCorriente'
                              : SVPREST_editImporte(cdtcoc)     );
             @@vigd = %subst( %editc(cdvigd:'X') : 1 : 2)
                    + '/'
                    + %subst( %editc(cdvigd:'X') : 3 : 4);
             REST_writeXmlLine( 'vigenciaDesde' : @@vigd        );
             REST_writeXmlLine( 'especialMayor' : %char(cdesma) );
             select;
              when cddfpg = 'C';
                   REST_writeXmlLine( 'formaDePago' : 'Cheque'      );
              when cddfpg = 'D';
                   REST_writeXmlLine( 'formaDePago' : 'Débito Banc.');
              when cddfpg = 'T';
                   REST_writeXmlLine( 'formaDePago' : 'Tarjeta'     );
              other;
                   REST_writeXmlLine( 'formaDePago' : ' '           );
             endsl;
             k1hec1.c1empr = cdempr;
             k1hec1.c1sucu = cdsucu;
             k1hec1.c1arcd = cdarcd;
             k1hec1.c1spol = cdspol;
             k1hec1.c1sspo = cdsspo;
             chain %kds(k1hec1) pahec1;
             if %found;
                REST_writeXmlLine( 'nivt' : %char(c1nivt) );
                REST_writeXmlLine( 'nivc' : %char(c1nivc) );
                REST_writeXmlLine( 'productor'
                                 : SVPINT_getNombre( cdempr
                                                   : cdsucu
                                                   : c1nivt
                                                   : c1nivc ) );
             endif;
            REST_endArray  ( 'comisionDetalle' );
         reade %kds(k1hccd:6) pahccd;
        enddo;

        REST_endArray  ( 'comisionesDetalle' );
        return;

