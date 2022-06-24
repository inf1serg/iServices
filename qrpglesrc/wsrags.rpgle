     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRAGS: Portal de Autogestión de Asegurados.                 *
      *         Lista siniestros de póliza.                          *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *27-Jul-2018            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *
     Fpahscd03  if   e           k disk
     Fpahshe    if   e           k disk
     Fpahshp    if   e           k disk
     Fset402    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

      * ------------------------------------------------------------ *
      * URL y URI
      * ------------------------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying

      * ------------------------------------------------------------ *
      * Parámetros de URL
      * ------------------------------------------------------------ *
     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s             11a
     D rama            s              2a
     D poli            s              7a
     D arcd            s              6a
     D spol            s              9a

     D x               s             10i 0
     D peTdoc          s              2  0
     D peNdoc          s             11  0
     D @@repl          s          65535a
     D peRama          s              2  0
     D pePoli          s              7  0
     D peArcd          s              6  0
     D peSpol          s              9  0
     D rc              s              1n
     D peNrdf          s              7  0
     D desi            s             30a
     D imin            s             15  2
     D peMsgs          ds                  likeds(paramMsgs)

     D k1hscd          ds                  likerec(p1hscd03:*key)
     D k1t402          ds                  likerec(s1t402:*key)
     D k1hshe          ds                  likerec(p1hshe:*key)
     D k1hshp          ds                  likerec(p1hshp:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

     d lda             ds                  qualified dtaara(*lda)
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

      /free

       *inlr = *on;

       REST_getUri( psds.this : uri );
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       tdoc = REST_getNextPart(url);
       ndoc = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);

       in lda;
       lda.empr = empr;
       lda.sucu = sucu;
       out lda;

       if SVPREST_chkCliente( empr
                            : sucu
                            : tdoc
                            : ndoc
                            : peMsgs
                            : peNrdf ) = *off;
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2   );
          REST_end();
          close *all;
          return;
       endif;

       if SVPREST_chkPolizaCliente( empr
                                  : sucu
                                  : arcd
                                  : spol
                                  : rama
                                  : poli
                                  : tdoc
                                  : ndoc
                                  : peMsgs  ) = *off;
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2   );
          REST_end();
          close *all;
          return;
       endif;

       monitor;
         peRama = %dec(rama:2:0);
        on-error;
         peRama = 0;
       endmon;

       monitor;
         pePoli = %dec(poli:7:0);
        on-error;
         pePoli = 0;
       endmon;

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
         peTdoc = %dec(tdoc:2:0);
        on-error;
         peTdoc = 0;
       endmon;

       monitor;
         peNdoc = %dec(ndoc:11:0);
        on-error;
         peNdoc = 0;
       endmon;

       rc = COWLOG_logConAutoGestion( empr
                                    : sucu
                                    : peTdoc
                                    : peNdoc
                                    : psds.this);

       k1hscd.cdempr = empr;
       k1hscd.cdsucu = sucu;
       k1hscd.cdrama = peRama;
       k1hscd.cdpoli = pePoli;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'siniestros' );

       setll %kds(k1hscd:4) pahscd03;
       reade %kds(k1hscd:4) pahscd03;
       dow not %eof;

        if cdsini <> 0;

           exsr $estado;
           exsr $pagos;

           REST_startArray('siniestro');
            REST_writeXmlLine('numeroSiniestro': %trim(%char(cdsini)) );
            REST_writeXmlLine('estado'         : %trim(desi)          );
            REST_writeXmlLine('importePagado'  : SVPREST_editImporte(imin));
           REST_endArray('siniestro');

        endif;

        reade %kds(k1hscd:4) pahscd03;
       enddo;

       REST_endArray( 'siniestros' );

       return;

       begsr $estado;
        desi = *blanks;
        k1hshe.heempr = cdempr;
        k1hshe.hesucu = cdsucu;
        k1hshe.herama = cdrama;
        k1hshe.hesini = cdsini;
        k1hshe.henops = cdnops;
        setgt  %kds(k1hshe:5) pahshe;
        readpe %kds(k1hshe:5) pahshe;
        if not %eof;
           k1t402.t@empr = heempr;
           k1t402.t@sucu = hesucu;
           k1t402.t@rama = herama;
           k1t402.t@cesi = hecesi;
           chain %kds(k1t402) set402;
           if %found;
              desi = t@desi;
           endif;
        endif;
       endsr;

       begsr $pagos;
        imin = 0;
        k1hshp.hpempr = cdempr;
        k1hshp.hpsucu = cdsucu;
        k1hshp.hprama = cdrama;
        k1hshp.hpsini = cdsini;
        k1hshp.hpnops = cdnops;
        setll %kds(k1hshp:5) pahshp;
        reade %kds(k1hshp:5) pahshp;
        dow not %eof;
            if hpmar1 = 'I';
               imin += hpimau;
            endif;
         reade %kds(k1hshp:5) pahshp;
        enddo;
       endsr;

      /end-free

