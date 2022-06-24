     H option(*srcstmt:*noshowcpy:*nodebugio)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRAGD: Portal de Autogestión de Asegurados.                 *
      *         Detalle de póliza.                                   *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               * 31-Jul-2018 *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SGF 11/06/19: No controlar más el CRI para cuadernillo.      *
      * SGF 19/06/19: Proximo vencimiento agrupado por fecha.        *
      * LRG 19/09/20: Validaciones varias para pago electronico.     *
      *               valsys para desconectar todos los pagos        *
      *               electronicos                                   *
      * JSN 05/10/20: Se agrega validacion de Vigencia y Saldo para  *
      *               desconectar pagos electronicos                 *
      * SGF 31/10/20: Agregado en la subrutina $valPago.             *
      * SGF 12/11/20: Si tiene registro en PAHMPO01 quiere decir que *
      *               hay una imputacion pendiente. Inhabilito el    *
      *               pago en esos casos.                            *
      * SGF 30/11/20: Si es CUIT, no habilita pago.                  *
      * JSN 10/12/20: Se elimina filtro de fecha final por tipo de   *
      *               forma de pago para fecha final para calcular   *
      *               cuotas impagas.                                *
      * JSN 27/01/21: Se agrega en la rutina de $proxVto, el signo   *
      *               "=" para filtrar las fechas del mismo día de   *
      *               ejecución                                      *
      * JSN 23/02/21: Se agrega el tag <habilitaCambioFormaDePago>   *
      * SGF 16/11/21: _tipoAsistencia() trae cuadernillo.            *
      * ************************************************************ *
     Fgnhdaf05  if   e           k disk
     Fgnhdaf06  if   e           k disk
     Fgnttdo    if   e           k disk
     Fsehase    if   e           k disk
     Fpahed001  if   e           k disk
     Fpahec1    if   e           k disk
     Fpahec3    if   e           k disk
     Fset912    if   e           k disk
     Fset621    if   e           k disk
     Fgntmon    if   e           k disk
     Fgntfpg    if   e           k disk
     Fgnttc101  if   e           k disk
     Fgnhdtc    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fgnhda6    if   e           k disk
     Fgntloc02  if   e           k disk
     Fpahcd501  if   e           k disk
     Fpahed005  if   e           k disk    prefix(d005_)
     Fpahcc2    if   e           k disk
     Fpahmpo01  if   e           k disk
     Fsahint    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     d sp0052          pr                  EXTPGM('SP0052')
     d peMone                         2
     d peFech                         8  0
     D peCoti                        15  6
     D peTipc                         1

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D SPDETAON        pr                  extpgm('SPDETAON')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peEaon                        1n
     D  peEpgm                        3a   const
     D  peTpcd                        2a   options(*nopass)

     D SPDETASI        pr                  extpgm('SPDETASI')
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  perama                        2  0 const
     D  pearse                        2  0 const
     D  peoper                        7  0 const
     D  pepoco                        4  0 const
     D  peEcri                        1n
     D  peEpgm                        3a   const

     D SPDETEUR        pr                  extpgm('SPDETEUR')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peEeur                        1n
     D  peEpgm                        3a   const
     D  peTpcd                        2a   options(*nopass)

     * Vigencia de Póliza
     D spvig2          pr                  ExtPgm('SPVIG2')
     D  peArcd                             like(d0Arcd)
     D  peSpol                             like(d0Spol)
     D  peRama                             like(d0Rama)
     D  peArse                             like(d0Arse)
     D  peOper                             like(d0Oper)
     D  peFvig                        8  0
     D  peFemi                        8  0
     D  peVige                        1n
     D  peSspo                             like(d0Sspo)
     D  peSuop                             like(d0Suop)
     D  peEndp                        3a

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  job                          26a   overlay(PsDs:244)

     D lda             ds                  qualified dtaara(*lda)
     D  empr                          1a   overlay(lda:401)
     D  sucu                          2a   overlay(lda:*next)

     D k1hdaf          ds                  likerec(g1hdaf05:*key)
     D k2hdaf          ds                  likerec(g1hdaf06:*key)
     D k1hed0          ds                  likerec(p1hed001:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1t621          ds                  likerec(s1t621:*key)
     D k1hdtc          ds                  likerec(g1hdtc:*key)
     D k1tloc          ds                  likerec(g1tloc02:*key)
     D k1hcd5          ds                  likerec(p1hcd501:*key)
     D Kpahed005       ds                  likerec(p1hed005:*key)
     D k1hcc2          ds                  likerec(p1hcc2:*key)
     D k1hmpo          ds                  likerec(p1hmpo:*key)
     D k1yint          ds                  likerec(s2hint:*key)

     D uri             s            512a
     D url             s           3000a   varying

     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s             11a
     D arcd            s              6a
     D spol            s              9a
     D rama            s              2a
     D arse            s              2a
     D oper            s              7a
     D poli            s              7a

     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D peTdoc          s              2  0
     D peNdoc          s             11  0
     D peArcd          s              6  0
     D peSpol          s              9  0
     D peRama          s              2  0
     D peArse          s              2  0
     D peOper          s              7  0
     D pePoli          s              7  0
     D peCuit          s             11a
     D es_aseg         s              1n
     D @@repl          s          65535a
     D fhfa            s              8  0
     D frec            s             15a
     D cbun            s             22a
     D cbue            s             22a
     D ctcu            s              3a
     D nrtc            s             25a
     D nrte            s             25a
     D fvta            s              4a
     D fvtm            s              2a
     D etrc            s             40a
     D cuad            s            256a
     D nrcu            s              2a
     D x               s             10i 0
     D y               s             10i 0
     D @@nrdf          s              7  0
     D rc              s              1n
     D proxVto         s              8  0
     D hoy             s              8  0
     D peMail          s             50a
     D impo            s             15  2
     D peEaon          s              1n
     D peEeur          s              1n
     D peEcri          s              1n
     D p@EndP          s              3a                     inz(*blanks)
     D p@Fvig          s              8  0                   inz(*zeros)
     D p@Femi          s              8  0                   inz(*zeros)
     D p@Vige          s              1n                     inz(*off)
     D p@Sspo          s              3  0                   inz(*zeros)
     D p@Suop          s              3  0                   inz(*zeros)
     D peCval          s             10a
     D peVsys          s            512a
     D tasi            s             10a
     D peMsgs          ds                  likeds(paramMsgs)
     D peMadd          ds                  likeds(Mailaddr_t) dim(100)

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

     d @@mone          s              2
     d @@fech          s              8  0
     d @@coti          s             15  6
     d @@tipc          s              1
     D @@prem          s                   like(d5imcu) inz(*zeros)
     D @@DeudaTot      s                   like(d5imcu) inz(*zeros)
     D @@FechaAux      s              8  0
     D @@FecDate       s               d
     D @@Rc1           s               n
     D @@CuoPend       s               n
     D @@RqFi          s              8  0              inz(*zeros)
     D @@RqSg          s              1                 inz(*zeros)
     D @@RqQd          s              3  0              inz(*zeros)
     D @@RqFf          s              8  0              inz(*zeros)
     D @@Mail          s             50
     D habPago         s              1                 inz('S')
     D habCambioFDP    s              1                 inz('S')
     D @@cfpg          s              1  0

     D                 ds
     D  dsFamd                 1      8  0
     D  dsF1aa                 1      4  0
     D  dsF1mm                 5      6  0
     D  dsF1dd                 7      8  0

     D @@TdocCUIT      s              2  0 inz(98)

     D cuotas          ds                  qualified dim(256)
     D  fvto                          8  0
     D  imcu                         15  2

     D i               s             10i 0
     D z               s             10i 0
     D condic          s            256a

      /free

       *inlr = *on;

       if not REST_getUri( psds.this : uri );
          return;
       endif;
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       tdoc = REST_getNextPart(url);
       ndoc = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       arse = REST_getNextPart(url);
       oper = REST_getNextPart(url);
       poli = REST_getNextPart(url);

       in lda;
       lda.empr = empr;
       lda.sucu = sucu;
       out lda;

       if SVPREST_chkCliente( empr
                            : sucu
                            : tdoc
                            : ndoc
                            : peMsgs ) = *Off;
          REST_writeHeader( 204
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

       if SVPREST_chkPolizaCliente( empr
                                  : sucu
                                  : arcd
                                  : spol
                                  : rama
                                  : poli
                                  : tdoc
                                  : ndoc
                                  : peMsgs ) = *off;
          REST_writeHeader( 204
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

       peCuit = %editc(peNdoc:'X');

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
         peArse = %dec(arse:2:0);
        on-error;
         peArse = 0;
       endmon;

       monitor;
         peRama = %dec(rama:2:0);
        on-error;
         peRama = 0;
       endmon;

       monitor;
         peOper = %dec(oper:7:0);
        on-error;
         peOper = 0;
       endmon;

       monitor;
         pePoli = %dec(poli:7:0);
        on-error;
         pePoli = 0;
       endmon;

       rc = COWLOG_logConAutoGestion( empr
                                    : sucu
                                    : peTdoc
                                    : peNdoc
                                    : psds.this);

       // --------------------------------
       // Tipo de Documento debe existir
       // --------------------------------
       setll peTdoc gnttdo;
       if not %equal and peTdoc <> @@TdocCUIT;
          %subst(@@repl:1:2) = tdoc;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AAG0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       // --------------------------------
       // Debe ser cliente
       // --------------------------------
       es_aseg = *off;
       exsr $cliente;
       if (es_aseg = *off);
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : 'AAG0008'
                          : 40
                          : 'El Documento no es asegurado de HDI'
                          : 'El Documento no es asegurado de HDI' );
          REST_end();
          close *all;
          return;
       endif;

       PAR310X3( empr : peFema : peFemm: peFemd );
       hoy = (peFema * 10000) + (peFemm * 100) + peFemd;

       k1hed0.d0empr = empr;
       k1hed0.d0sucu = sucu;
       k1hed0.d0arcd = peArcd;
       k1hed0.d0spol = peSpol;
       k1hed0.d0rama = peRama;
       k1hed0.d0arse = peArse;
       k1hed0.d0oper = peOper;
       setgt  %kds(k1hed0:7) pahed001;
       readpe %kds(k1hed0:7) pahed001;

       fhfa = (d0fhfa * 10000) + (d0fhfm * 100) + d0fhfd;

       SPDETASI( peArcd
               : peSpol
               : peRama
               : peArse
               : peOper
               : 0
               : peEcri
               : *blanks  );

       SPDETAON( empr
               : sucu
               : peArcd
               : peSpol
               : peEaon
               : *blanks  );

       SPDETEUR( empr
               : sucu
               : peArcd
               : peSpol
               : peEeur
               : *blanks  );


       k1t621.t@arcd = peArcd;
       k1t621.t@rama = peRama;
       k1t621.t@arse = peArse;
       chain %kds(k1t621) set621;
       if not %found;
          t@dupe = 0;
       endif;

       select;
        when t@dupe = 1;
         frec = 'Mensual';
        when t@dupe = 2;
         frec = 'Bimensual';
        when t@dupe = 3;
         frec = 'Trimestral';
        when t@dupe = 4;
         frec = 'Cuatrimestral';
        when t@dupe = 6;
         frec = 'Semestral';
        when t@dupe = 12;
         frec = 'Anual';
        when t@dupe = 24;
         frec = 'Bianual';
       endsl;

       chain d0mone gntmon;
       if not %found;
          monmol = *blanks;
       endif;

       k1hec1.c1empr = empr;
       k1hec1.c1sucu = sucu;
       k1hec1.c1arcd = peArcd;
       k1hec1.c1spol = peSpol;
       setgt  %kds(k1hec1:4) pahec1;
       readpe %kds(k1hec1:4) pahec1;

       setgt  %kds(k1hec1:4) pahec3;
       readpe %kds(k1hec1:4) pahec3;
       @@cfpg = c1cfpg;

       chain c3nrpp set912;
       if not %found;
          t@dppg = *blanks;
       endif;

       cbun = *blanks;
       cbue = *blanks;
       ctcu = *blanks;
       nrtc = *blanks;
       nrte = *blanks;
       fvta = *blanks;
       fvtm = *blanks;
       etrc = *blanks;
       select;
        when c1cfpg = 1;
             ctcu = %char(c1ctcu);
             nrtc = %char(c1nrtc);
             nrte = %char(c1nrtc);
             chain c1ctcu gnttc101;
             if %found;
                etrc = dfnomb;
             endif;
             y = 0;
             for x = %len(nrte) downto 1;
                 if %subst(nrte:x:1) <> ' ';
                    y += 1;
                 endif;
                 if y > 4;
                    %subst(nrte:x:1) = '*';
                 endif;
             endfor;
             k1hdtc.dfnrdf = c1asen;
             k1hdtc.dfctcu = c1ctcu;
             k1hdtc.dfnrtc = c1nrtc;
             chain %kds(k1hdtc) gnhdtc;
             if %found;
                fvta = %editc(dfffta:'X');
                fvtm = %editc(dffftm:'X');
             endif;
        when c1cfpg = 2 or c1cfpg = 3;
             cbun = %trim(SPVCBU_getCbuEntero( c1ivbc
                                             : c1ivsu
                                             : c1tcta
                                             : c1ncta ) );
             cbue = cbun;
             %subst(cbue:19) = '****';
       endsl;

       chain c1cfpg gntfpg;
       if not %found;
          fpdefp = *blanks;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'poliza' );

        REST_writeXmlLine( 'hastaFacturado' : SVPREST_editFecha(fhfa) );
        REST_writeXmlLine( 'frecuenciaFact' : %trim(frec)             );

        cuad   = *blanks;
        tasi = SVPPOL_tipoAsistencia( d0empr
                                    : d0sucu
                                    : d0arcd
                                    : d0spol
                                    : d0rama
                                    : d0arse
                                    : d0oper
                                    : d0poli
                                    : cuad     );
        REST_writeXmlLine( 'tipoAsistencia' : tasi );
        REST_writeXmlLine( 'cuadernilloAsis': %trim(cuad)             );

        rc = SVPPOL_isSuscriptaPolizaElectronica( d0empr
                                                : d0sucu
                                                : d0arcd
                                                : d0spol
                                                : d0rama
                                                : d0arse
                                                : d0oper
                                                : d0poli
                                                : peMail );

        REST_startArray( 'polizaDigital' );
         if rc;
            @@mail = %xlate(may:min:peMail);
            REST_writeXmlLine( 'isSuscripta' : 'S'           );
            REST_writeXmlLine( 'mail'        : %trim(@@mail) );
          else;
            REST_writeXmlLine( 'isSuscripta' : 'N'           );
            REST_writeXmlLine( 'mail'        : ' '           );
         endif;
        REST_endArray  ( 'polizaDigital' );

        REST_startArray( 'moneda' );
         REST_writeXmlLine( 'codigo'      : %trim(d0mone) );
         REST_writeXmlLine( 'descripcion' : %trim(monmol) );
        REST_endArray  ( 'moneda' );

        REST_startArray( 'formaDePago' );
         REST_writeXmlLine( 'codigo'               : %char(c1cfpg) );
         REST_writeXmlLine( 'descripcion'          : %trim(fpdefp) );
         REST_writeXmlLine( 'nroPlanDePago'        : %char(c3nrpp) );
         REST_writeXmlLine( 'planDePago'           : %trim(t@dppg) );
         REST_writeXmlLine( 'codigoTarjetaCredito' : ctcu          );
         REST_writeXmlLine( 'tarjetaCredito'       : etrc          );
         REST_writeXmlLine( 'numeroTarjetaCredito' : nrtc          );
         REST_writeXmlLine( 'numeroTarjetaEditado' : nrte          );
         REST_writeXmlLine( 'anioVencimientoTarj'  : fvta          );
         REST_writeXmlLine( 'mesVencimientoTarj'   : fvtm          );
         REST_writeXmlLine( 'numeroCbu'            : cbun          );
         REST_writeXmlLine( 'numeroCbuEditado'     : cbue          );
        REST_endArray  ( 'formaDePago' );

        exsr $proxVto;

        exsr $cuotaPendiente;

        exsr $premioPoliza;

        @@nrdf = SVPINT_getNroDaf( c1empr
                                 : c1sucu
                                 : c1nivt
                                 : c1nivc );

        chain @@nrdf gnhdaf;
        chain @@nrdf gnhda6;
        if not %found;
           clear dftel2;
           clear dftel6;
        endif;

        k1tloc.locopo = dfcopo;
        k1tloc.locops = dfcops;
        chain %kds(k1tloc) gntloc02;

        REST_startArray( 'productor' );
         REST_writeXmlLine( 'codigo' : %char(c1nivc) );
         REST_writeXmlLine( 'nombre'
                          : %trim(SVPINT_getNombre( c1empr
                                                  : c1sucu
                                                  : c1nivt
                                                  : c1nivc ) ));
         REST_startArray( 'domicilio' );
          REST_writeXmlLine( 'direccion' : %trim(dfdomi) );
          REST_writeXmlLine( 'codigoPostal' : %char(dfcopo) );
          REST_writeXmlLine( 'sufijo'       : %char(dfcops) );
          REST_writeXmlLine( 'localidad'    : %trim(loloca) );
          REST_writeXmlLine( 'provincia'    : %trim(prprod) );
          REST_writeXmlLine( 'codigoProvincia' : %trim(loproc) );
          REST_writeXmlLine( 'provinciaInder' : %char(prrpro) );
         REST_endArray  ( 'domicilio' );

         exsr $contactoPas;

        REST_endArray  ( 'productor' );

        peVsys = *blanks;
        peCval = *blanks;
        condic = *blanks;
        select;
         when d0rama = 3;
              peCval = 'HCONGENAUT';
         when d0rama = 6;
              peCval = 'HCONGENRCA';
         when d0rama = 23;
              peCval = 'HCONGENAPE';
         when d0rama = 26;
              peCval = 'HCONGENCON';
         when d0rama = 27;
              peCval = 'HCONGENCFL';
         when d0rama = 28;
              peCval = 'HCONGENCOM';
         when d0rama = 80;
              peCval = 'HCONGENVCO';
        endsl;

        if peCval <> *blanks;
           if SVPVLS_getValSys( peCval: *omit : peVsys );
              condic = %trim(peVsys);
           endif;
        endif;

        REST_writeXmlLine( 'condicionesGenerales' : %trim(condic) );

        exsr $valPago;
        REST_writeXmlLine( 'habilitaPago' : habPago );
        exsr $valCambioFDP;
        REST_writeXmlLine( 'habilitaCambioFormaDePago' : habCambioFDP );

       REST_endArray( 'poliza' );

       return;

       begsr $cliente;
         if peTdoc = @@TdocCUIT;
            peCuit = %editc(peNdoc:'X');
            setll peCuit gnhdaf06;
            reade peCuit gnhdaf06;
            dow not %eof;
                exsr $chkAse;
                if es_aseg;
                   leave;
                endif;
             reade peCuit gnhdaf06;
            enddo;
          else;
            k1hdaf.dftido = peTdoc;
            k1hdaf.dfnrdo = peNdoc;
            setll %kds(k1hdaf:2) gnhdaf05;
            reade %kds(k1hdaf:2) gnhdaf05;
            dow not %eof;
                exsr $chkAse;
                if es_aseg;
                   leave;
                endif;
             reade %kds(k1hdaf:2) gnhdaf05;
            enddo;
         endif;
       endsr;

       begsr $chkAse;
         setll dfnrdf sehase;
         if %equal;
            es_aseg = *on;
         endif;
       endsr;

       begsr $cuotaPendiente;

        @@Rc1 = *Off;
        clear @@DeudaTot;
        k1hcd5.d5empr = d0empr;
        k1hcd5.d5sucu = d0sucu;
        k1hcd5.d5rama = d0rama;
        k1hcd5.d5poli = d0poli;
        setll %kds(k1hcd5:4) pahcd501;
        dou %eof(pahcd501);
          reade %kds(k1hcd5:4) pahcd501;
          if not %eof(pahcd501);
            if d5sttc <> '3';

              @@FechaAux = (d5fvca*10000) + (d5fvcm*100) + d5fvcd;

              // Primer Vencimiento Impago
              if not @@Rc1;

                @@FechaAux = (d5fvca*10000) + (d5fvcm*100) + d5fvcd;

                @@RqFi = @@FechaAux;
                @@CuoPend = *Off;
                if @@RqFi < hoy;
                  @@CuoPend = *On;
                endif;

                @@Rc1 = *On;

              endif;

              // Acumula deuda total
              if @@FechaAux < hoy;
                @@DeudaTot += d5imcu;
              endif;

            endif;
          endif;
        enddo;

        REST_startArray( 'cuotaPendiente' );
         if @@CuoPend;
           REST_writeXmlLine( 'tiene':'S' );
           REST_writeXmlLine( 'desde':%char(%date(@@RqFi:*iso)) );
         else;
           REST_writeXmlLine( 'tiene' : 'N' );
           REST_writeXmlLine( 'desde' : '' );
         endif;
         REST_writeXmlLine( 'importe'
                          : %trim(%editw(@@DeudaTot : '           0 .  ')) );
        REST_endArray  ( 'cuotaPendiente' );

       endsr;

       begsr $premioPoliza;

          clear @@prem;

          // Suma primas de todas las polizas
          Kpahed005.d005_d0empr = d0empr;
          Kpahed005.d005_d0sucu = d0sucu;
          Kpahed005.d005_d0arcd = d0arcd;
          Kpahed005.d005_d0spol = d0spol;
          setll %kds(Kpahed005:4) pahed005;
          dou %eof(pahed005);
            reade %kds(Kpahed005:4) pahed005;
            if not %eof(pahed005);

              @@mone = d005_d0mone;
              clear @@coti;
              if @@mone <> 'AU';
                @@fech = hoy;
                @@tipc = 'V';
                sp0052( @@mone : @@fech : @@coti : @@tipc );
                if @@coti = *zeros;
                  @@coti = 1;
                endif;
              else;
                @@coti = 1;
              endif;
              @@prem += (d005_d0prem * @@coti);

            endif;
          enddo;

          REST_writeXmlLine( 'premioPoliza'
                           : %trim(%editw(@@prem : '           0 .  ')) );

       endsr;

       begsr $proxVto;
        clear cuotas;
        proxVto = 0;
        nrcu    = *blanks;
        impo    = 0;
        k1hcd5.d5empr = d0empr;
        k1hcd5.d5sucu = d0sucu;
        k1hcd5.d5rama = d0rama;
        k1hcd5.d5poli = d0poli;
        setll %kds(k1hcd5:4) pahcd501;
        reade %kds(k1hcd5:4) pahcd501;
        dow not %eof;
            if d5sttc <> '3';
               proxVto = (d5fvca * 10000) + (d5fvcm * 100) + d5fvcd;
               if proxVto >= hoy;
                  i  = %lookup( proxVto : cuotas(*).fvto );
                  if i = 0;
                     i = %lookup( 0 : cuotas(*).fvto );
                  endif;
                  if i > 0;
                     cuotas(i).fvto  = proxVto;
                     cuotas(i).imcu += d5imcu;
                  endif;
               endif;
            endif;
         reade %kds(k1hcd5:4) pahcd501;
        enddo;
        sorta cuotas(*).fvto;
        for i = 1 to 256;
            if cuotas(i).imcu <> 0;
               proxVto = cuotas(i).fvto;
               nrcu    = '01';
               impo    = cuotas(i).imcu;
               leave;
            endif;
        endfor;
        REST_startArray( 'proximoVencimiento' );
         REST_writeXmlLine( 'fecha'  : SVPREST_editFecha(proxVto) );
         REST_writeXmlLine( 'cuota'  : nrcu                       );
         REST_writeXmlLine( 'importe': SVPREST_editImporte(impo)  );
        REST_endArray  ( 'proximoVencimiento' );
       endsr;

       begsr $contactoPas;
        if SVPINT_isMostrarTelefonos( c1empr
                                    : c1sucu
                                    : c1nivt
                                    : c1nivc );
          if %trim(dftel2) <> '' or %trim(dftel6) <> '';
            REST_startArray( 'telefonos' );
            if %trim(dftel2) <> '';
              REST_startArray( 'telefono' );
                REST_writeXmlLine( 'tipo'   : 'P' );
                REST_writeXmlLine( 'numero' : %trim(dftel2) );
               REST_endArray  ( 'telefono' );
            endif;
            if %trim(dftel6) <> '';
              REST_startArray( 'telefono' );
                REST_writeXmlLine( 'tipo'   : 'C' );
                REST_writeXmlLine( 'numero' : %trim(dftel6) );
              REST_endArray  ( 'telefono' );
            endif;
            REST_endArray  ( 'telefonos' );
          else;
            REST_writeXmlLine( 'telefonos' : '');
          endif;
        endif;

        if SVPINT_isMostrarMails( c1empr
                                : c1sucu
                                : c1nivt
                                : c1nivc );
           REST_startArray( 'correos' );
           x = SVPMAIL_xNivc( c1empr
                            : c1sucu
                            : c1nivt
                            : c1nivc
                            : peMadd
                            : *omit  );
            for y = 1 to x;
             REST_startArray( 'correo' );
              REST_writeXmlLine( 'tipo'       : ' ' );
              REST_writeXmlLine( 'codigoTipo' : %char(peMadd(y).tipo) );
              REST_writeXmlLine( 'direccion'  : peMadd(y).mail );
             REST_endArray  ( 'correo' );
            endfor;
           REST_endArray  ( 'correos' );
        endif;

       endsr;

       begsr $valPago;

         if peTdoc = 98;
            habPago = 'N';
            leaveSr;
         endif;

         if SVPVLS_getValSys( 'HABPAGOEAG': *omit : peVsys );
            if %trim(peVsys) = 'N';
                habPago = 'N';
                leaveSr;
            endif;
         endif;

         k1hcc2.c2empr = empr;
         k1hcc2.c2sucu = sucu;
         k1hcc2.c2arcd = peArcd;
         k1hcc2.c2spol = peSpol;
         setll %kds(k1hcc2:4) pahcc2;
         reade %kds(k1hcc2:4) pahcc2;
         dow not %eof;
           if c2sttc = '2' or
              c2sttc = '2' or
              c2sttc = 'C' or
              c2sttc = 'C' or
              c2imcu < 0;
              habPago = 'N';
              leaveSr;
           endif;
           reade %kds(k1hcc2:4) pahcc2;
         enddo;

         chain @@mone gntmon;
         if not %found;
            habPago = 'N';
            leaveSr;
         endif;
         if @@mone <> '00' and @@mone <> '01';
            habPago = 'N';
            leaveSr;
         endif;

         clear p@Endp;
         p@Vige = *off;
         p@Fvig = hoy;
         p@Femi = hoy;
         spvig2( d0Arcd
               : d0Spol
               : d0Rama
               : d0Arse
               : d0Oper
               : p@Fvig
               : p@Femi
               : p@Vige
               : p@Sspo
               : p@Suop
               : p@Endp );

         if @@DeudaTot + impo <= 0;
            habPago = 'N';
            leaveSr;
         endif;

         k1hmpo.mpempr = empr;
         k1hmpo.mpsucu = sucu;
         k1hmpo.mptdoc = peTdoc;
         k1hmpo.mpndoc = peNdoc;
         k1hmpo.mprama = peRama;
         k1hmpo.mppoli = pePoli;
         setll %kds(k1hmpo:6) pahmpo01;
         if %equal;
            habPago = 'N';
            leavesr;
         endif;

         habPago = 'S';

       endsr;

       begsr $valCambioFDP;

         habCambioFDP = 'S';

         if SVPVLS_getValSys( 'HABCFDPEAG': *omit : peVsys );
           if %trim(peVsys) = 'N';
             habCambioFDP = 'N';
             leaveSr;
           endif;
         endif;

         k1yint.inEmpr = empr;
         k1yint.inSucu = sucu;
         k1yint.inNivt = c1nivt;
         k1yint.inNivc = c1nivc;
         chain %kds( k1yint : 4 ) sahint;
         if %found( sahint );
           if inMabc = 'S';
             habCambioFDP = 'N';
           endif;
         endif;

       endsr;

      /end-free

