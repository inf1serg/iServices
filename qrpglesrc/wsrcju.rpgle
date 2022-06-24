     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRCJU: QUOM Versión 2                                       *
      *         Listado de Caratulas de Juicio                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *06-Jul-2020            *
      * ************************************************************ *
     Fset64401  if   e           k disk
     Fpahjcr    if   e           k disk
     Fpahscd    if   e           k disk
     Fpahjhp    if   e           k disk
     Fpahjc1    if   e           k disk
     Fset001    if   e           k disk
     Fgntloc    if   e           k disk
     Fmailusrs  if   e           k disk
     Fmailconf  if   e           k disk
     Fpahjdr    if   e           k disk
     Fpahsva    if   e           k disk
     Fpahsbs    if   e           k disk
     Fset204    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fcntnau01  if   e           k disk
     Fpahec0    if   e           k disk
     Fpahet9    if   e           k disk
     Fset14101  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D uri             s            512a
     D url             s           3000a   varying

     D @fe             s              8  0
     D @fp             s              8  0
     D @fd             s              8  0
     D @fn             s              8  0
     D @fs             s              8  0
     D @fi             s              8  0
     D @fv             s              8  0
     D @@nabo          s             40a
     D @@ncia          s             40a
     D @rcc            s              2a
     D @rcl            s              2a
     D @tra            s              2a
     D @ntr            s              2a
     D @cas            s              2a
     D @@vehi          s             80a
     D @ifra           s             15  2
     D @c              s             30a
     D rc              s              1n

     D k1t644          ds                  likerec(s1t644:*key)
     D k1hjcr          ds                  likerec(p1hjcr:*key)
     D k1hjc1          ds                  likerec(p1hjc1:*key)
     D k1hjdr          ds                  likerec(p1hjdr:*key)
     D k1hjhp          ds                  likerec(p1hjhp:*key)
     D k1hscd          ds                  likerec(p1hscd:*key)
     D k1hsbs          ds                  likerec(p1hsbs:*key)
     D k1hec0          ds                  likerec(p1hec0:*key)
     D k1het9          ds                  likerec(p1het9:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

     Is1t001
     I              t@date                      ttdate
     I              t@user                      ttuser

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

       read mailconf;

       k1t644.t@empr = empr;
       k1t644.t@sucu = sucu;

       REST_writeHeader();
       REST_writeEncoding();
       REST_startArray('caratulas' );

       setll %kds(k1t644:2) set64401;
       reade %kds(k1t644:2) set64401;
       dow not %eof;
           k1hscd.cdempr = t@empr;
           k1hscd.cdsucu = t@sucu;
           k1hscd.cdrama = t@rama;
           k1hscd.cdsini = t@sini;
           k1hscd.cdnops = t@nops;
           chain %kds(k1hscd:5) pahscd;
           @@vehi = *blanks;
           chain %kds(k1hscd:5) pahsva;
           if %found;
              chain (vavhmc:vavhmo:vavhcs) set204;
              if %found;
                 @@vehi = %trim(t@vhmd)
                        + ' '
                        + %trim(t@vhdm)
                        + ' '
                        + %trim(t@vhds)
                        + ' ('
                        + %trim(vanmat)
                        + ')';
              endif;
           endif;
           @ifra = 0;
           chain %kds(k1hscd:5) pahsbs;
           if %found;
              k1het9.t9empr = bsempr;
              k1het9.t9sucu = bssucu;
              k1het9.t9arcd = cdarcd;
              k1het9.t9spol = cdspol;
              k1het9.t9rama = cdrama;
              k1het9.t9arse = cdarse;
              k1het9.t9oper = cdoper;
              k1het9.t9poco = bspoco;
              chain %kds(k1het9) pahet9;
              if %found;
                 @ifra = t9ifra;
              endif;
           endif;
           k1hjcr.jcempr = t@empr;
           k1hjcr.jcsucu = t@sucu;
           k1hjcr.jcrama = t@rama;
           k1hjcr.jcsini = t@sini;
           k1hjcr.jcnops = t@nops;
           k1hjcr.jcnrdf = t@nrdf;
           k1hjcr.jcsebe = t@sebe;
           k1hjcr.jcnrcj = t@nrcj;
           k1hjcr.jcjuin = t@juin;
           chain %kds(k1hjcr:9) pahjcr;
           chain t@rama set001;
           @fd   = (jcfdma * 10000)
                 + (jcfdmm * 100)
                 +  jcfdmd;
           @fn   = (jcfrda * 10000)
                 + (jcfrdm * 100)
                 +  jcfrdd;
           @fs   = (cdfsia * 10000)
                 + (cdfsim * 100)
                 +  cdfsid;
           chain (jccopo:jccops) gntloc;
           if not %found;
               loloca = 'ERROR';
           endif;
           k1hjc1.j1empr = jcempr;
           k1hjc1.j1sucu = jcsucu;
           k1hjc1.j1rama = jcrama;
           k1hjc1.j1sini = jcsini;
           k1hjc1.j1nops = jcnops;
           k1hjc1.j1nrdf = jcnrdf;
           k1hjc1.j1sebe = jcsebe;
           k1hjc1.j1nrcj = jcnrcj;
           k1hjc1.j1juin = jcjuin;
           chain %kds(k1hjc1:9) pahjc1;
           if not %found;
              j1nraj = 0;
              j1hecg = ' ';
              j1ocja = ' ';
              j1tida = ' ';
           endif;
           @rcc = 'NO';
           @rcl = 'NO';
           @tra = 'NO';
           @ntr = 'NO';
           @cas = 'NO';
           select;
            when j1hecg = '1';
                 @tra = 'SI';
                 @rcl = 'SI';
            when j1hecg = '2';
                 @ntr = 'SI';
                 @rcl = 'SI';
            when j1hecg = '3';
                 @rcc = 'SI';
            when j1hecg = '4';
                 @cas = 'SI';
            when j1hecg = '5';
                 @cas = 'SI';
            when j1hecg = '6';
                 @cas = 'SI';
            when j1hecg = '7';
                 @cas = 'SI';
            when j1hecg = '8';
                 @cas = 'SI';
            when j1hecg = '9';
                 @cas = 'SI';
           endsl;
           chain t@user mailusrs;
           if not %found;
              dxccma = 'error';
              dxfuln = 'error';
           endif;
           k1hjdr.drempr = jcempr;
           k1hjdr.drsucu = jcsucu;
           k1hjdr.drrama = jcrama;
           k1hjdr.drsini = jcsini;
           k1hjdr.drnops = jcnops;
           k1hjdr.drnrcj = jcnrcj;
           k1hjdr.drjuin = jcjuin;
           k1hjdr.drnrdf = jcnrdf;
           k1hjdr.drsebe = jcsebe;
           @@nabo = *blanks;
           @@ncia = *blanks;
           setll %kds(k1hjdr:9) pahjdr;
           reade %kds(k1hjdr:9) pahjdr;
           dow not %eof;
               if drmar1 = 'D' and @@nabo = *blanks;
                  @@nabo = drnomb;
               endif;
               if drmar1 = 'A' and @@ncia = *blanks;
                  @@ncia = drnomb;
               endif;
            reade %kds(k1hjdr:9) pahjdr;
           enddo;
           k1hec0.c0empr = jcempr;
           k1hec0.c0sucu = jcsucu;
           k1hec0.c0arcd = cdarcd;
           k1hec0.c0spol = cdspol;
           chain %kds(k1hec0) pahec0;
           @fe   = (c0fema * 10000)
                 + (c0femm * 100)
                 +  c0femd;
           @fi   = (c0fioa * 10000)
                 + (c0fiom * 100)
                 +  c0fiod;
           @fv   = (c0fvoa * 10000)
                 + (c0fvom * 100)
                 +  c0fvod;
           REST_startArray( 'caratula'   );
            REST_writeXmlLine( 'nroDePeticion': %char(t@nres));
            REST_writeXmlLine( 'codigoRama':%char(t@rama));
            REST_writeXmlLine( 'numeroDeSiniestro':%char(t@sini));
            REST_writeXmlLine( 'numeroDeJuicio': %char(t@juin));
            REST_writeXmlLine( 'numeroDeCarpeta' : %char(t@nrcj));
            REST_writeXmlLine( 'numeroDeBeneficiario':%char(t@nrdf));
            REST_writeXmlLine( 'secuenciaBeneficiario':%char(t@sebe));
            REST_writeXmlLine( 'descripcionRama' : t@ramd);
            REST_writeXmlLine( 'caratulaDelJuicio':jccara);
            REST_writeXmlLine( 'numeroDeRaj': %char(j1nraj));
            REST_writeXmlLine( 'juzgado' : jcjuzg        );
            REST_writeXmlLine( 'jurisdiccion' : loloca   );
            REST_writeXmlLine( 'fechaDeDemanda' :SVPREST_editFecha(@fd));
            REST_writeXmlLine('fechaDeNotificacion':SVPREST_editFecha(@fn));
            REST_writeXmlLine('nroDePoliza': %char(cdpoli));
            REST_writeXmlLine('franquicia': SVPREST_editImporte(@ifra) );
            REST_writeXmlLine('monto': SVPREST_editImporte(jcidem) );
            REST_writeXmlLine('abogadoRequirente': @@nabo);
            REST_writeXmlLine('abogadoCia'       : @@ncia);
            REST_writeXmlLine('tipoDeReclamo': j1tida    );
            REST_writeXmlLine('reasegurador':             %trim(jcnrsg));
            REST_writeXmlLine('fechaDeSiniestro':SVPREST_editFecha(@fs));
            REST_writeXmlLine('polizaNro':   %char(cdpoli));
            REST_writeXmlLine('fechaDeEmision':SVPREST_editFecha(@fe));
            REST_writeXmlLine('vigenciaDesde':SVPREST_editFecha(@fi));
            REST_writeXmlLine('vigenciaHasta':SVPREST_editFecha(@fv));
            REST_writeXmlLine('vehiculoAsegurado': @@vehi            );
            REST_writeXmlLine('rcc': @rcc                            );
            REST_writeXmlLine('rcl': @rcl                            );
            REST_writeXmlLine('transp': @tra                         );
            REST_writeXmlLine('noTransp': @ntr                       );
            REST_writeXmlLine('casco':  @cas                         );
            REST_writeXmlLine('ley':  j1ocja                       );
            REST_writeXmlLine('codCivil': ' '                      );
            REST_startArray('destinatario');
            REST_writeXmlLine('nombre': dxfuln                     );
            REST_writeXmlLine('mail': %trim(dxccma) + '@' + %trim(nfdomi));
            REST_endArray('destinatario');
            REST_startArray('remitente');
            REST_writeXmlLine('nombre':                 %trim(nfsysn));
            REST_writeXmlLine('mail': %trim(nfsysm) + '@' + %trim(nfdomi));
            REST_endArray('remitente');
            exsr $pagos;
           REST_endArray( 'caratula' );

        reade %kds(k1t644:2) set64401;
       enddo;

       REST_endArray( 'caratulas' );

       REST_end();

       close *all;

       return;

       begsr $pagos;
        REST_startArray('pagos');
        k1hjhp.jpempr = jcempr;
        k1hjhp.jpsucu = jcsucu;
        k1hjhp.jprama = jcrama;
        k1hjhp.jpsini = jcsini;
        k1hjhp.jpnops = jcnops;
        k1hjhp.jpnrdf = jcnrdf;
        k1hjhp.jpsebe = jcsebe;
        k1hjhp.jpnrcj = jcnrcj;
        k1hjhp.jpjuin = jcjuin;
        setll %kds(K1hjhp:9) pahjhp;
        reade %kds(K1hjhp:9) pahjhp;
        dow not %eof;
            REST_startArray('pago');
            @fp = (jpfmoa * 10000)
                + (jpfmom * 100)
                +  jpfmod;
            select;
             when jpmar1 = 'I';
                  @c = 'INDEMNIZACION';
             when jpmar1 = 'G';
                  @c = 'GASTO';
            endsl;
            select;
             when jpcoma = '**';
                  chain jpnrma gnhdaf;
                  if not %found;
                     dfnomb = *blanks;
                  endif;
             other;
                 chain (jpempr:jpsucu:jpcoma:jpnrma) cntnau01;
                  if not %found;
                     dfnomb = *blanks;
                  endif;
            endsl;
            REST_writeXmlLine('fecha': SVPREST_editFecha(@fp) );
            REST_writeXmlLine('pagadoA':  dfnomb                 );
            REST_writeXmlLine('concepto': @c                     );
            REST_writeXmlLine('importe': SVPREST_editImporte(jpimmr) );
            REST_writeXmlLine('observaciones': ' '              );
            REST_endArray('pago');
         reade %kds(K1hjhp:9) pahjhp;
        enddo;
        REST_endArray('pagos');
       endsr;

      /end-free
