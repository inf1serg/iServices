     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPOL: QUOM Versión 2                                       *
      *         Lista de pólizas por intermediario                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *26-May-2017            *
      * ------------------------------------------------------------ *
      * Modificiones:                                                *
      * LRG 02-01-18 - Obtener Fechas de vigencia desde PAR310X3     *
      * EXT 18-07-18 - Nuevo tag <isAnulada>                         *
      * NWN 31-08-18 - Nuevo tag <saldoPendiente>                    *
      * SGF 06-07-20 - Agrego <codigoFormaDePago> y $datos_pago.     *
      * SGF 03-08-20 - Luego de SPSALD, no elimino los decimales.    *
      * SGF 25-11-20 - Agrego tag de suscripcion a poliza digital.   *
      * JSN 23-03-21 - Se agrega condición de tipo de persona 'C'    *
      * ************************************************************ *
     Fpahpol12  if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fset901    if   e           k disk
     Fpahed004  if   e           k disk
     Fsehase01  if   e           k disk
     Fgntmon    if   e           k disk
     Fsehni201  if   e           k disk    prefix(n2:2)
     Fgnhdaf    if   e           k disk
     Fgnttdo    if   e           k disk
     Fctw00003  if   e           k disk
     Fset001    if   e           k disk    prefix(tz:2)
     Fpahet9    if   e           k disk
     Fgti98001  if   e           k disk
     Fgnttc101  if   e           k disk

     Fpahec1    if   e           k disk
     Fgnhdcb    if   e           k disk
     Fgnhdtc    if   e           k disk
     Fgntfpg    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'

     D GSWEB037        pr                  ExtPgm('GSWEB037')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peTiou                        1  0 const
     D  peStou                        2  0 const
     D  peDsop                       20a

     D SPLSTDAY        pr                  ExtPgm('SPLSTDAY')
     D  peFemm                        2  0 const
     D  peFema                        4  0 const
     D  peFemd                        2  0

     D WSPCSP          pr                  ExtPgm('WSPCSP')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFech                        d   const
     D   peCast                      10i 0
     D   peCasp                      10i 0
     D   peCass                      10i 0
     D   peCasi                      10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLBVP          pr                  ExtPgm('WSLBVP')
     D  peBase                             likeds(paramBase) const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peLben                             likeds(pahev91_t) dim(99)
     D  peLbenC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D SPCOBFIN        pr                  extpgm('SPCOBFIN')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peFech                        8  0 const
     D  peConv                        1a   const
     D  peCobf                        1n
     D  peFpgm                        3a   const

     Dspsald           pr                  extpgm('SPSALD')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peRama                        2  0
     D  @@aÑo                         4  0
     D  @@mes                         2  0
     D  @@dia                         2  0
     D  @@sald                       15  2
     D  @@impr                        2
     D  @@fpgm                        3    const

     D SPVIG2          pr                  extpgm('SPVIG2')
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peFech                        8  0 const
     D  peFemi                        8  0 const
     D  peVige                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3a   const

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

     DDXP021           pr                  extpgm('DXP021')
     D                                1    Const
     D                                2    Const
     D                                6  0 Const
     D                                9  0 Const
     D                                4  0 Const
     D                                2  0 Const
     D                                2  0 Const
     D                                1
     D                                3

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D prim            s             30a
     D prem            s             30a
     D @@datd          s             20a
     D @@repl          s          65535a
     D @@dsop          s             20a
     D desd            s              8a
     D desde           s             10a
     D hasta           s             10a
     D hast            s              8a
     D url             s           3000a   varying
     D @@cobf          s              2a
     D @@vige          s              2a
     D rc              s              1n
     D isVige          s              1n
     D peCobf          s              1n
     D @@nrdo          s             11  0
     D @@tiou          s              1  0
     D @@stou          s              2  0
     D desdn           s              8  0
     D hastn           s              8  0
     D vigeSspo        s              3  0
     D vigeSuop        s              3  0
     D c               s             10i 0
     D peCast          s             10i 0
     D peCasp          s             10i 0
     D peCass          s             10i 0
     D peCasi          s             10i 0
     D rc2             s             10i 0
     D xx              s             10i 0
     D femid           s             10d
     D femih           s             10d
     D @@tipe          s              1a
     D priPat          s              1n
     D @@d             s              2  0
     D @@m             s              2  0
     D @@a             s              4  0
     D @@fech          s              8  0
     D @@Soln          s              7  0

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D k1hpol          ds                  likerec(p1hpol:*key)
     D k1het9          ds                  likerec(p1het9:*key)
     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)
     D k1w000          ds                  likerec(c1w000:*key)
     D k1ygti          ds                  likerec(g1i98001:*key)
     D  peLben         ds                  likeds(pahev91_t) dim(99)
     D  peLbenC        s             10i 0

     D @@anul          s              1
     D endpgm          s              3
     D anulada         s              1
     D @@fpgm          s              3    inz('   ')
     D @@ano           s              4  0
     D @@mes           s              2  0
     D @@dia           s              2  0
     D @@impr          s              2
     D @1sald          s             15  2
     D @@cbu           s             25a
     D @fvt            s              4  0
     D fvaa            s              2  0

     D lda             ds                  qualified dtaara(*lda)
     D  empr                          1a   overlay(lda:401)
     D  sucu                          2a   overlay(lda:402)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

     D                 ds                  inz
     D  @@sald                01     15  2
     D  @@ente                01     13  0
     D  @@deci                14     15  0

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
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       desde= REST_getNextPart(url);
       hasta= REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
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

       lda.empr = empr;
       lda.sucu = sucu;
       out lda;

       desd = %subst(desde:1:4)
            + %subst(desde:6:2)
            + %subst(desde:9:2);

       hast = %subst(hasta:1:4)
            + %subst(hasta:6:2)
            + %subst(hasta:9:2);

       desdn = %dec(desd:8:0);
       hastn = %dec(hast:8:0);

       femid = %date(desdn:*iso);
       femih = %date(hastn:*iso);

       k1hpol.poempr = empr;
       k1hpol.posucu = sucu;
       k1hpol.ponivt = %dec( nivt : 1 : 0 );
       k1hpol.ponivc = %dec( nivc : 5 : 0 );
       k1hpol.pofemi = femih;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRPOL':peBase);

       rc = REST_writeHeader();
       if rc = *off;
          return;
       endif;

       rc = REST_writeEncoding();
       rc = REST_writeXmlLine( 'polizas' : '*BEG');
       if rc = *off;
          return;
       endif;

       c = 0;

       setll %kds(k1hpol:5) pahpol12;
       reade %kds(k1hpol:4) pahpol12;
       dow not %eof;

           if pofemi < femid;
              leave;
           endif;

           k1hed0.d0empr = poempr;
           k1hed0.d0sucu = posucu;
           k1hed0.d0rama = porama;
           k1hed0.d0poli = popoli;
           setgt %kds(k1hed0:4) pahed004;
           readpe %kds(k1hed0:4) pahed004;
           if %eof;
              @@tiou = potiou;
              @@stou = postou;
            else;
              @@tiou = d0tiou;
              @@stou = d0stou;
           endif;
           GSWEB037( poempr
                   : posucu
                   : porama
                   : @@tiou
                   : @@stou
                   : @@dsop );

           chain pomone gntmon;
           if not %found;
              monmoc = *blanks;
           endif;

           chain poasen gnhdaf;
           if not %found;
              dfnomb = *blanks;
              dftido = 0;
              dfnrdo = 0;
              dfcuit = *all'0';
              dfnjub = 0;
              dftiso = 0;
           endif;

           @@tipe = ' ';
           @@datd = *blanks;
           @@nrdo = 0;
           select;
            when dftiso = 98;
                 @@tipe = 'F';
                 chain dftido gnttdo;
                 if not %found;
                    gndatd = *blanks;
                 endif;
                 @@datd = gndatd;
                 if dfnrdo > 0;
                    @@nrdo = dfnrdo;
                  else;
                    if dfcuit <> *all'0' and dfcuit <> *blanks;
                       monitor;
                         @@nrdo = %dec(dfcuit:11:0);
                        on-error;
                         @@nrdo = 0;
                         @@datd = *blanks;
                       endmon;
                     else;
                       @@nrdo = dfnjub;
                    endif;
                 endif;
            when dftiso = 80 or dftiso = 81;
                 @@tipe = 'C';
                 chain dftido gnttdo;
                 if not %found;
                    gndatd = *blanks;
                 endif;
                 @@datd = gndatd;
                 if dfnrdo > 0;
                    @@nrdo = dfnrdo;
                  else;
                    if dfcuit <> *all'0' and dfcuit <> *blanks;
                       monitor;
                         @@nrdo = %dec(dfcuit:11:0);
                        on-error;
                         @@nrdo = 0;
                         @@datd = *blanks;
                       endmon;
                     else;
                       @@nrdo = dfnjub;
                    endif;
                 endif;
            other;
                 @@tipe = 'J';
                 if dfcuit <> *all'0' and dfcuit <> *blanks;
                    @@datd = 'CUIT';
                    monitor;
                      @@nrdo = %dec(dfcuit:11:0);
                     on-error;
                      @@datd = *blanks;
                      @@nrdo = *zeros;
                    endmon;
                 endif;
           endsl;

           k1hni2.n2empr = poempr;
           k1hni2.n2sucu = posucu;
           k1hni2.n2nivt = 1;
           k1hni2.n2nivc = ponivc1;
           chain %kds(k1hni2:4) sehni201;
           if not %found;
              n2nomb = *blanks;
           endif;

           WSPCSP( peBase
                 : porama
                 : popoli
                 : %date
                 : peCast
                 : peCasp
                 : peCass
                 : peCasi
                 : peErro
                 : peMsgs );

           prim = %editw( poprim : '                 .  -' );
           prem = %editw( poprem : '                 .  -' );

           c += 1;

           if poprim = 0;
              prim = '.00';
           endif;

           if poprem = 0;
              prem = '.00';
           endif;

           w0nctw = 0;
           @@Soln = *zeros;
           k1w000.w0empr = poempr;
           k1w000.w0sucu = posucu;
           k1w000.w0arcd = poarcd;
           k1w000.w0spol = pospol;
           k1w000.w0nivt = ponivt;
           k1w000.w0nivc = ponivc;
           chain %kds(k1w000:6) ctw00003;
           if %found;
              @@soln = w0soln;
           else;
             k1ygti.g0Empr = poEmpr;
             k1ygti.g0Sucu = poSucu;
             k1ygti.g0Arcd = poArcd;
             k1ygti.g0Spol = poSpol;
             k1ygti.g0Sspo = 0;
             chain %kds( k1ygti : 5 ) gti98001;
             if %found( gti98001 );
               @@Soln = g0soln;
             endif;
           endif;

           REST_writeXmlLine( 'poliza ' : '*BEG' );
            REST_writeXmlLine( 'articulo'           : %trim(%char(poarcd)) );
            REST_writeXmlLine( 'superpoliza'        : %trim(%char(pospol)) );
            REST_writeXmlLine( 'rama'               : %trim(%char(porama)) );
            REST_writeXmlLine( 'nroPoliza'          : %trim(%char(popoli)) );
            REST_writeXmlLine( 'arse'               : %trim(%char(poarse)) );
            REST_writeXmlLine( 'operacion'          : %trim(%char(pooper)) );
            REST_writeXmlLine( 'certificado'        : %trim(%char(pocert)) );
            REST_writeXmlLine( 'tipoOperacion'      : %trim(@@dsop)        );
            REST_writeXmlLine( 'codigoAsegurado'    : %trim(%char(poasen)) );
            REST_writeXmlLine( 'nombreAsegurado'    : %trim(dfnomb)        );
            REST_writeXmlLine( 'tipoDocAsegurado'   : %trim(@@datd)        );
            REST_writeXmlLine( 'numeroDocAsegurado' : %trim(%char(@@nrdo)) );
            REST_writeXmlLine( 'codigoProductor' : %trim(%char(ponivc1))     );
            REST_writeXmlLine( 'nombreProductor' : %trim(n2nomb)             );
            REST_writeXmlLine( 'fechaEmision'    : %trim(%char(pofemi:*iso)) );
            REST_writeXmlLine( 'fechaVigDesd'    : %trim(%char(pofdes:*iso)) );
            REST_writeXmlLine( 'fechaVigHast'    : %trim(%char(pofhas:*iso)) );
            REST_writeXmlLine( 'moneda'                 : %trim(monmoc)      );
            REST_writeXmlLine( 'prima'                  : %trim(prim)        );
            REST_writeXmlLine( 'premio'                 : %trim(prem)        );
            //REST_writeXmlLine('patente':%trim(popatente));
            exsr $patentes;
            REST_writeXmlLine( 'cantidadSiniestros'   : %trim(%char(peCasi)) );
            REST_writeXmlLine( 'embarcacion'            : %trim(poemcn)      );
            REST_writeXmlLine( 'cotizacionWeb' : %trim(%char(w0nctw)) );
            if @@Soln <> *zeros;
              REST_writeXmlLine('solicitudWeb' : %char(@@Soln));
            else;
              REST_writeXmlLine('solicitudWeb' : '0');
            endif;
            REST_writeXmlLine( 'tipoPersona' : %trim(@@tipe) );

            exsr $signals;
            REST_writeXmlLine( 'estaVigente' : @@vige );
            REST_writeXmlLine( 'tieneCoberturaFinanciera' : @@cobf );

            REST_writeXmlLine( 'beneficiariosPoliza' : '*BEG');
            chain porama set001;
            if tzrame = 18 or tzrame = 21;
               peErro = 0;
               peLbenC = 0;
               clear peLben;
               WSLBVP( peBase
                     : poarcd
                     : pospol
                     : porama
                     : popoli
                     : peLben
                     : peLbenC
                     : peErro
                     : peMsgs    );
             if peErro = 0;
              for xx = 1 to peLbenC;
              REST_writeXmlLine('beneficiarioPoliza':'*BEG');
               REST_writeXmlLine('nombre': peLben(xx).v9nomb);
               REST_writeXmlLine('cuil':%char(peLben(xx).v9cuil));
               REST_writeXmlLine('clausulaNoRep':peLben(xx).v9mar1);
              REST_writeXmlLine('beneficiarioPoliza':'*END');
              endfor;
             endif;
            endif;
            REST_writeXmlLine( 'beneficiariosPoliza' : '*END');

            anulada = 'N';
            callp DXP021( empr
                        : sucu
                        : poarcd
                        : pospol
                        : @@a
                        : @@m
                        : @@d
                        : @@anul
                        : endpgm );
            if ( @@anul = 'A' );
              anulada = 'S';
            endif;
            REST_writeXmlLine( 'isAnulada' : anulada );
            REST_writeXmlLine( 'saldoPendiente'
                             : svprest_editImporte(@@sald) );

            REST_writeXmlLine( 'descripcionRama' : %trim(tzramd) );

            exsr $datos_pago;

            if SVPPOL_isSuscriptaPolizaElectronica( poempr
                                                  : posucu
                                                  : poarcd
                                                  : pospol
                                                  : porama
                                                  : poarse
                                                  : pooper
                                                  : popoli
                                                  : *Omit  );
               REST_writeXmlLine( 'suscriptaPolizaElectronica' : 'S' );
             else;
               REST_writeXmlLine( 'suscriptaPolizaElectronica' : 'N' );
            endif;

           REST_writeXmlLine( 'poliza ' : '*END' );

        reade %kds(k1hpol:4) pahpol12;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'polizas' : '*END' );

       close *all;

       return;

       begsr $patentes;

        REST_write( '<patente>' );
        priPat = *off;

        k1het9.t9empr = poempr;
        k1het9.t9sucu = posucu;
        k1het9.t9arcd = poarcd;
        k1het9.t9spol = pospol;
        setll %kds(k1het9:4) pahet9;
        reade %kds(k1het9:4) pahet9;
        dow not %eof;

          if t9poli > 0;
            if not priPat;
               REST_write(%trim(t9nmat));
               priPat = *on;
             else;
               REST_write(';' + %trim(t9nmat));
            endif;
          endif;

         reade %kds(k1het9:4) pahet9;
        enddo;

        REST_write( '</patente>' );

       endsr;

       begsr $signals;

        @@vige = 'N';
        @@cobf = 'N';

        clear @@fech;
        PAR310X3 ( empr : @@a : @@m : @@d );
        @@fech = (@@a * 10000) + (@@m * 100) + @@d;

        SPVIG2( poarcd
              : pospol
              : porama
              : poarse
              : pooper
              : @@fech
              : @@fech
              : isVige
              : vigeSspo
              : vigeSuop
              : *blanks            );
        if isVige;
           @@vige = 'S';
        endif;

        SPCOBFIN( poempr
                : posucu
                : poarcd
                : pospol
                : @@fech
                : 'P'
                : peCobf
                : *blanks           );
        if peCobf;
           @@cobf = 'S';
        endif;

         @@sald = 0 ;
         @1sald = 0 ;
         @@impr = ' ';

         spsald  ( poarcd
                 : pospol
                 : porama
                 : @@a
                 : @@m
                 : @@d
                 : @1sald
                 : @@impr
                 : *blanks);

         @@sald = @1sald;

        //////if @@deci <> 0;
        //////   @@deci = 0;
        //////endif;

       endsr;

       begsr $datos_pago;
        REST_startArray( 'formaDePago' );
        REST_startArray( 'tipoDePago' );
        REST_writeXmlLine( 'codigo' : %editc(pocfpg:'X') );
        chain pocfpg gntfpg;
        if %found;
           REST_writeXmlLine( 'descripcion':%trim(fpdefp) );
        endif;
        select;
         when pocfpg = 1;
              REST_writeXmlLine( 'efectivo' : 'N');
              REST_writeXmlLine( 'debito'   : 'N');
              REST_writeXmlLine( 'credito'  : 'S');
         when pocfpg = 4;
              REST_writeXmlLine( 'efectivo' : 'S');
              REST_writeXmlLine( 'debito'   : 'N');
              REST_writeXmlLine( 'credito'  : 'N');
         other;
              REST_writeXmlLine( 'efectivo' : 'N');
              REST_writeXmlLine( 'debito'   : 'S');
              REST_writeXmlLine( 'credito'  : 'N');
        endsl;
        REST_endArray( 'tipoDePago' );
        setgt  (poempr:posucu:poarcd:pospol) pahec1;
        readpe (poempr:posucu:poarcd:pospol) pahec1;
        if not %eof;
           select;
            when pocfpg = 1;
                 REST_startArray( 'tarjeta' );
                 REST_writeXmlLine( 'codigo' : %char(c1ctcu) );
                 chain c1ctcu gnttc101;
                 if %found;
                     REST_writeXmlLine( 'nombreTarjeta' : dfnomb  );
                     REST_writeXmlLine( 'cantidadDigitos': %char(t1cdnt));
                  else;
                     REST_writeXmlLine( 'nombreTarjeta' : *blanks);
                     REST_writeXmlLine( 'cantidadDigitos': '0'   );
                 endif;
                 REST_endArray( 'tarjeta' );
                 REST_writeXmlLine( 'numeroTarjetaDeCredito'
                                  : %char(c1nrtc) );
                 REST_writeXmlLine( 'numeroDeCbu' : *blanks );
                 chain (c1asen:c1ctcu:c1nrtc) gnhdtc;
                 if %found;
                    if (dfffta <= 0 or dffftm <= 0 or dffftm > 12);
                        dfffta = 2050;
                        dffftm = 12;
                    endif;
                  else;
                        dfffta = 2050;
                        dffftm = 12;
                 endif;
                 SPLSTDAY( dffftm : dfffta : @@d );
                  fvaa = dfffta - 2000;
                  @fvt = (dffftm * 100)
                       + ( fvaa );
                 REST_writeXmlLine( 'fechaVencimientoTarjetaDeCredito'
                                  : %editc(@fvt:'X') );
                 REST_writeXmlLine( 'numeroDeCbu'
                                  : '0000000000000000000000');
            when pocfpg = 2 or pocfpg = 3;
                 REST_startArray( 'tarjeta' );
                 REST_writeXmlLine( 'codigo' : '000'         );
                 REST_writeXmlLine( 'nombreTarjeta' : *blanks );
                 REST_endArray( 'tarjeta' );
                 REST_writeXmlLine( 'cantidadDigitos': '0'   );
                 REST_writeXmlLine( 'numeroTarjetaDeCredito'
                                  : '0000000000000000000000000');
                 REST_writeXmlLine( 'fechaVencimientoTarjetaDeCredito'
                                  : '0000'       );
                 @@cbu = SPVCBU_getCBUEntero( c1ivbc
                                            : c1ivsu
                                            : c1tcta
                                            : c1ncta );
                 chain (c1asen:c1ivbc:c1ivsu:c1tcta:c1ncta) gnhdcb;
                 if %found;
                    REST_writeXmlLine( 'numeroDeCbu'
                                     : @@cbu                   );
                  else;
                    REST_writeXmlLine( 'numeroDeCbu'
                                     : '0000000000000000000000');
                 endif;
            when pocfpg = 4;
                 REST_writeXmlLine( 'numeroDeCbu'
                                  : '0000000000000000000000');
                 REST_startArray( 'tarjeta' );
                 REST_writeXmlLine( 'codigo' : '000'         );
                 REST_writeXmlLine( 'nombreTarjeta' : *blanks );
                 REST_writeXmlLine( 'cantidadDigitos': '0'   );
                 REST_endArray( 'tarjeta' );
                 REST_writeXmlLine( 'numeroTarjetaDeCredito'
                                  : '0000000000000000000000000');
                 REST_writeXmlLine( 'fechaVencimientoTarjetaDeCredito'
                                  : '0000'       );
           endsl;
        endif;
        REST_endArray( 'formaDePago' );
       endsr;

      /end-free

