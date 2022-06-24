     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRMEP: QUOM Versión 2                                       *
      *         Lista movimientos emitidos por productor.            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *08-Jun-2018            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahsra02  if   e           k disk
     Fpahed3    if   e           k disk
     Fpahed0    if   e           k disk
     Fpahet0    if   e           k disk
     Fset001    if   e           k disk
     Fset901    if   e           k disk    prefix(t9:2)
     Fsehase01  if   e           k disk    prefix(as:2)
     Fsehni201  if   e           k disk    prefix(n2:2)
     Fgti98001  if   e           k disk
     Fctw00018  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D url             s           3000a   varying
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D asen            s              7a

     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D peFemi          s              8  0
     D p2Fema          s              4  0
     D p2Femm          s              2  0
     D p2Femd          s              2  0
     D p2Femi          s              8  0

     D @@repl          s          65535a
     D rc              s              1n
     D femi            s              8  0
     D vdes            s              8  0
     D vhas            s              8  0
     D copr            s             15  2 dim(9)
     D x               s             10i 0
     D priPat          s              1n
     D xxedit          s             30a
     D @@Soln          s              7  0

     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D peBase          ds                  likeds(paramBase)
     D k1hsra          ds                  likerec(p1hsra:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)
     D k1hed3          ds                  likerec(p1hed3:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1ygti          ds                  likerec(g1i98001:*key)
     D k1w000          ds                  likerec(c1w000:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       if REST_getUri( psds.this : uri ) = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       asen = REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       k1hsra.raempr = empr;
       k1hsra.rasucu = sucu;
       k1hsra.ranivt = %dec( nivt : 1 : 0 );
       k1hsra.ranivc = %dec( nivc : 5 : 0 );
       k1hsra.raasen = %dec( asen : 7 : 0 );

       COWLOG_logcon('WSRME1':peBase);

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray('movimientos' );

       setll %kds(k1hsra:5) pahsra02;
       reade %kds(k1hsra:5) pahsra02;
       dow not %eof;

           k1hed0.d0empr = raempr;
           k1hed0.d0sucu = rasucu;
           k1hed0.d0arcd = raarcd;
           k1hed0.d0spol = raspol;
           k1hed0.d0sspo = rasspo;
           k1hed0.d0rama = rarama;
           k1hed0.d0arse = raarse;
           k1hed0.d0oper = raoper;
           k1hed0.d0suop = rasuop;
           chain %kds(k1hed0:9) pahed0;
           if not %found;
              d0come = 1;
           endif;

           if d0come <= 0;
              d0come = 1;
           endif;

           peFemi = (rafema * 10000) + (rafemm * 100) + rafemd;

           femi = (rafema * 10000) + (rafemm * 100) + rafemd;
           vdes = (rafioa * 10000) + (rafiom * 100) + rafiod;
           vhas = (rafvoa * 10000) + (rafvom * 100) + rafvod;

           chain rarama set001;
           if not %found;
              t@ramd = *blanks;
           endif;

           chain (d0tiou:d0stou) set901;
           if not %found;
              t9dsop = *blanks;
           endif;

           chain raasen sehase01;
           if not %found;
              asnomb = *blanks;
           endif;

           k1hni2.n2empr = raempr;
           k1hni2.n2sucu = rasucu;
           k1hni2.n2nivt = 1;
           k1hni2.n2nivc = raniv1;
           chain %kds(k1hni2:4) sehni201;
           if not %found;
              n2nomb = *blanks;
           endif;

           @@Soln = *zeros;

           k1w000.w0Empr = raEmpr;
           k1w000.w0Sucu = raSucu;
           k1w000.w0Arcd = raArcd;
           k1w000.w0Spol = raSpol;
           k1w000.w0Sspo = raSspo;
           chain %kds(k1w000:5) ctw00018;
           if %found(ctw00018);
             @@Soln = w0Soln;
           else;
             k1ygti.g0Empr = raEmpr;
             k1ygti.g0Sucu = raSucu;
             k1ygti.g0Arcd = raArcd;
             k1ygti.g0Spol = raSpol;
             k1ygti.g0Sspo = raSspo;
             chain %kds( k1ygti : 5 ) gti98001;
             if %found( gti98001 );
               @@Soln = g0soln;
             endif;
           endif;

           REST_startArray('movimiento');

            REST_writeXmlLine('rama'  :  %trim(%char(rarama)) );
            REST_writeXmlLine('ramaDescripcion':%trim(t@ramd) );
            REST_writeXmlLine('poliza'  :%trim(%char(rapoli)) );
            REST_writeXmlLine('suplemento':%editc(rasuop:'X') );
            REST_writeXmlLine('tipoDeOperacion':%trim(t9dsop) );
            REST_writeXmlLine('nombreAsegurado':%trim(asnomb) );
            REST_writeXmlLine('codigoProductor':%char(raniv1) );
            REST_writeXmlLine('nombreProductor':%trim(n2nomb) );
            REST_writeXmlLine('fechaEmision':SVPREST_editFecha(femi));
            REST_writeXmlLine('vigenciaDesde':SVPREST_editFecha(vdes));
            REST_writeXmlLine('vigenciaHasta':SVPREST_editFecha(vhas));

            exsr $patentes;

            xxedit = SVPREST_editImporte(raprim-rabpri);

            REST_writeXmlLine('prima' : SVPREST_editImporte(raprim-rabpri));
            REST_writeXmlLine('premio': SVPREST_editImporte(raprem));

            exsr $comision;

            if @@Soln <> *zeros;
              REST_writeXmlLine('solicitudWeb' : %char(@@Soln));
            else;
              REST_writeXmlLine('solicitudWeb' : '0');
            endif;

           REST_endArray('movimiento');

        reade %kds(k1hsra:5) pahsra02;
       enddo;

       REST_endArray( 'movimientos');

       close *all;

       return;

       begsr $patentes;
        REST_write( '<patente>' );
        priPat = *off;
        setll %kds(k1hed0:9) pahet0;
        reade %kds(k1hed0:9) pahet0;
        dow not %eof;
            if t0poli > 0;
               if not priPat;
                  REST_write(%trim(t0nmat));
                  priPat = *on;
                else;
                  REST_write(';' + %trim(t0nmat));
               endif;
            endif;
         reade %kds(k1hed0:9) pahet0;
        enddo;
        REST_write( '</patente>' );
       endsr;

       begsr $comision;

        copr(*) = 0;

        k1hed3.d3empr = raempr;
        k1hed3.d3sucu = rasucu;
        k1hed3.d3arcd = raarcd;
        k1hed3.d3spol = raspol;
        k1hed3.d3sspo = rasspo;
        k1hed3.d3rama = rarama;
        k1hed3.d3arse = raarse;
        k1hed3.d3oper = raoper;
        k1hed3.d3suop = rasuop;
        setll %kds(k1hed3:9) pahed3;
        reade %kds(k1hed3:9) pahed3;
        dow not %eof;
            d3copr *= d0come;
            d3ccob *= d0come;
            d3cfno *= d0come;
            d3cfnn *= d0come;
            copr(d3nivt) += d3copr + d3ccob + d3cfno + d3cfnn;
         reade %kds(k1hed3:9) pahed3;
        enddo;

        select;
         when peBase.peNit1 = 1;
          copr(3) = 0;
          copr(5) = 0;
          copr(6) = 0;
         when peBase.peNit1 = 3;
          copr(5) = 0;
          copr(6) = 0;
         when peBase.peNit1 = 5;
          copr(6) = 0;
        endsl;

        REST_writeXmlLine( 'comisionProductor'
                         : SVPREST_editImporte(copr(1)) );
        xxedit = SVPREST_editImporte(copr(1));

        REST_writeXmlLine( 'comisionOrganizador'
                         : SVPREST_editImporte(copr(3)));
        xxedit = SVPREST_editImporte(copr(3));

        REST_writeXmlLine( 'comisionProductorDos'
                         : SVPREST_editImporte(copr(5)) );
        xxedit = SVPREST_editImporte(copr(5));

        REST_writeXmlLine( 'comisionProductorTres'
                         : SVPREST_editImporte(copr(6)) );
        xxedit = SVPREST_editImporte(copr(6));

       endsr;

      /end-free
