     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
     H datedit(*dmy/)
      * ***
      * WSPAOP : Servicio Siniestro - Anular Orden de Pago           *
      * ------------------------------------------------------------ *
      * Valeria Marquez                      10/01/2021              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *
     Fgnhdaf    if   e           k disk    usropn
     Fcnhop1    uf a e           k disk    usropn
     Fgntloc02  if   e           k disk    usropn
     Fcnhpib01  if   e           k disk    usropn
     Fcntnau01  if   e           k disk    usropn
     Fgnttge    if   e           k disk    usropn
     Fgntdim    if   e           k disk    usropn
     Fcnwnin    uf a e           k disk    usropn

      * -- Copy H --
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpopg_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/spvfac_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      *
      * ATENCION: el likeds dependerá del servicio.
      *           No es siempre la misma.
      *           La ds (en este caso wspaop_t) debe
      *           existir en el miembro SINEST_H
      *
      * Las variables que siguen aca, deben estar siempre
      * request, buffer, options y rc1
      *
     D k1yloc          ds                  likerec(g1tloc02:*key)
     D k1ynau          ds                  likerec(c1tnau01:*key)
     D k1ytge          ds                  likerec(g1ttge:*key)
     D k1ypib          ds                  likerec(c1hpib01:*key)
      * -- Variables de Arquitectura --
     D request         ds                  likeds(wspAop_t)
     D buffer          s           5000a
     D options         s            100a
     D rc1             s             10i 0
     D @@repl          s          65535a
     D path            s            256a   varying
     D pevalu          s           1024a
     D peMsgs          ds                  likeds(paramMsgs)
     D @@MsgF          s             10a
     D x               s             10i 0
     D y               s             10i 0
     D f               s             10i 0
     D @erro           s              1a
     D @@fecr          s              8  0
     D @@fech          s              8  0
     D @@fean          s              8  0
     D @@feca          s              4  0
     D @@fecm          s              2  0
     D @@fecd          s              2  0
     D @@cuit          s             11a
     D @@psec          s              2  0
     D pemoti          s            350
     D peMar1          s              1
     D peSeco          s              2  0
     D @@tfa2          s              2  0
     D @@nrdf          s              7  0
     D @@tifa          s              2  0
     D @@sufa          s              4  0
     D @@nrfa          s              8  0
     D @@fefa          s              8  0
     D @@tipo          s              3  0
      * ---------------- Variables de Nestor
     D @@coi2          s              2  0
     D @@coi1          s              1  0
     D @@poim          s              5  2
     D wwGens          s                    like(tggens)
     D wwGess          s                    like(tggess)
     D wwGecv          s                    like(tggecv)
     D xnrcmi          s             11  0
     D wwx309          s             30  9
     D wxsubt          s             15  2
     D wxnetc          s             15  2
     D  wzresn         s             13     inz('SSSSSSSSSSSSS')
     D  wwa003         s              3
     D  wwa100         s            100
     D  wzre01         s                    like(wwa100)
     D  wzre02         s                    like(wwa100)
     D  wzre03         s                    like(wwa100)
     D  wzre04         s                    like(wwa100)
     D  wzre05         s                    like(wwa100)
     D  wzre06         s                    like(wwa100)
     D  wzre07         s                    like(wwa100)
     D  wzre08         s                    like(wwa100)
     D  wzre09         s                    like(wwa100)
     D  wzre10         s                    like(wwa100)
     D  wzre11         s                    like(wwa100)
     D  wzre12         s                    like(wwa100)
     D  wzre13         s                    like(wwa100)
     D  wzretor        s                    like(wwa003)
     D  peDs047        ds                   likeds ( DsSp0047_t )
     D @@mact          s             25  2
     D @1mact          s             25  2
     D  x3fasa         s              4  0
     D  x3fasm         s              2  0
     D  x3fasd         s              2  0
     D  x3Poim         s              5  2
     D  peEmpr         s              1
     D  peSucu         s              2
     D  peArtc         s              2  0
     D  pePacp         s              6  0
     D  peComa         s              2
     D  peNrma         s              7  0
     D  peUser         s             10
     D  peMoas         s              1
     D  p1Tido         s              2  0
     D  p1Nrdo         s              8  0
     D  p1Copo         s              5  0
     D  p1Cops         s              1  0
     D  pePibr         s              1n
     D  wximiv         s             15  2
     D rc              s               n
     D  peIvse         s              5  0
     D  peRpro         s              2  0
     D  wwnrrf         s              9
     D  panomb         s             40
     D  @@irau         s             15  2

      *- Campo Retenciones. ------------------------------- *
     D  xnrcm1         s             11  0
     D  ximre1         s             10  2
     D  xnrcm2         s             11  0
     D  ximre2         s             10  2
     D  xnrcm3         s             11  0
     D  ximre3         s             10  2
     D  xacum3         s             15  2
     D  xnrcm4         s             11  0
     D  ximre4         s             10  2
     D  xnrcm5         s             11  0
     D  ximre5         s             10  2
     D  xnrcm6         s             11  0
     D  ximre6         s             10  2
     D  xnrcm7         s             11  0
     D  ximre7         s             10  2
     D  xnrcm8         s             11  0
     D  ximre8         s             10  2
     D  xnrcm9         s             11  0
     D  ximre9         s             10  2
     D  xnrcm0         s             11  0
     D  ximre0         s             10  2
      *- Area Local del Sistema. -------------------------- *
     D                sds
     D  ususer               254    263
     D  ususr2               358    367
     D  nompgm                 1     10
     D  nomjob               244    253
     D  nomusr               254    263

      *- Parametros para IGA. ------------------------------ *
     D                 ds                  inz
     D  $nrrfa                 1      9  0
     D  $artca                 2      3  0
     D  $pacpa                 4      9  0
     D*
     D                 ds                  inz
     D  $nrrfp                 1      9  0
     D  $artcp                 2      3  0
     D  $pacpp                 4      9  0
     D*
     D                 ds                  inz
     D  $afhc                  1     13  0
     D  $uaÑo                  1      2  0
     D  $umes                  3      4  0
     D  $udia                  5      6  0
     D  $hora                  7     12  0
     D  $abcv                 13     13  0
     D*
     D                 ds
     D  $can1                  1     30  0
     D  $piva                  6     10  2
     D  $ivas                 16     30  2
     D*
     D                 ds
     D  $caa1                  1     30
     D  $coma                  1      2
     D  $nrma                  3      9  0
     D  $esma                 10     10  0
     D  $ticp                 11     12  0
     D  $sucp                 13     16  0
     D  $facn                 17     24  0
     D  $fafd                 25     26  0
     D  $fafm                 27     28  0
     D  $fafa                 29     30  0

     D                 ds                  inz
     D  $gecv                  1     12
     D  $rama                  1      2  0
     D  $inga                  3      3

      * -- Variables de conversion
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
     D*
      *
      * Parametros de Orden de Pago.
     D @@Dspa          ds                  likeds ( dsCnhopa_t )
      *
      * Parametros de Orden de Pago Devengadas.
     D @@Dsop          ds                  likeds ( dsCnhmop_t )
      *
      * Parametros de Historico de Pagos
     D @@Dshp          ds                  likeds ( dsPahshp_t ) dim(9999)
     D @@DsHpC         s             10i 0
     D*
      * Parametros de Orden de Pago Devengados
     D @@DsCn          ds                  likeds ( dsCntopa_t ) dim(9999)
     D @@DsCnC         s             10i 0
      *
      * Parametros de Facturas
     D @@DsFa          ds                  likeds ( dsCnhfac_t ) dim(9999)
     D @@DsFaC         s             10i 0
     D*
      * Parametros de Percepciones
     D @@DsIb          ds                  likeds ( dsCnhpib_t ) dim(9999)
     D @@DsIbC         s             10i 0
     D*
      * Parametros de Da02
     D @@Libr          ds                  likeds ( dsProI_t ) dim(9999)
     D @@LibrC         s             10i 0
     D*
      * Parametros de Retenciones
     D @@DsEt          ds                  likeds ( dsCnhret_t ) dim(999)
     D @@DsEtC         s             10i 0
     D*
      * Parametros de Ordenes de Pago BPM
     D @@Ds65          ds                  likeds(dsGti965_t)
     D*
     D @@CodM          s              7    inz
     D @x              s             10i 0
     D @ok             s              1
      *
      * -- Agregar --
     D                 ds
     D  $dcopt                 1     25
     D  $dticp                 1      2  0
     D  $d1                    3      3    inz('-')
     D  $dsucp                 4      7  0
     D  $d2                    8      8    inz('-')
     D  $dfacn                 9     16  0
     D  $d3                   17     17    inz('-')
     D  $ddiaf                18     19  0
     D  $d4                   20     20    inz('/')
     D  $dmesf                21     22  0
     D  $d5                   23     23    inz('/')
     D  $daÑof                24     25  0
      *
     D                 ds                  inz
     D  $peffac                1     10
     D  $peffaa                1      4  0
     D  $peffa2                3      4  0
     D  $pegui1                5      5
     D  $peffam                6      7  0
     D  $pegui2                8      8
     D  $peffad                9     10  0
      *
     D                 ds                  inz
     D xxfpamd                 1      8  0
     D xxfppa                  1      4  0
     D xxfppm                  5      6  0
     D xxfppd                  7      8  0

     D                 ds
     D  $$cmga                 1     11
     D  $$cmgn                 1     11  0

     D SP0047          pr                  extpgm('SP0047')
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       6  0 const
     D   peMact                      15  2 const
     D   peImiv                      15  2 const
     D   peFasa                       4  0 const
     D   peFasm                       2  0 const
     D   peFasd                       2  0 const
     D   peRpro                       2  0 const
     D   peRpr1                       2  0 const
     D   peResn                      13    const
     D   peReto                       3
     D   peRe01                     100
     D   peRe02                     100
     D   peRe03                     100
     D   peRe04                     100
     D   peRe05                     100
     D   peRe06                     100
     D   peRe07                     100
     D   peRe08                     100
     D   peRe09                     100
     D   peRe10                     100
     D   peRe11                     100
     D   peRe12                     100
     D   peRe13                     100

     D spopfech        pr                  extpgm('SPOPFECH')
     D                                8  0 const
     D                                1a   const
     D                                1a   const
     D                                5  0 const
     D                                8  0
     D                                1a

     D nCompRet        pr                  extpgm('CXP572S')
     D                                1    const
     D                                2    const
     D                                1    const
     D                                9  0 const
       // -------------------------------------
       /free
       *inlr = *on;

         open gnhdaf;
         open cnhop1;
         open gntloc02;
         open cntnau01;
         open gnttge;
         open cnwnin;
         open gntdim;
         open cnhpib01;

       // -------------------------------------
       // Inicio
       // -------------------------------------


       options = 'path=anularOrdenPago +
                  allowmissing=yes allowextra=yes case=any';

       REST_getEnvVar('REQUEST_METHOD':peValu);

       //if %trim(peValu) <> 'POST';
       //   REST_writeHeader( 405
       //                   : *omit
       //                   : *omit
       //                   : *omit
       //                   : *omit
       //                   : *omit  );
       //   REST_end();
       //   SVPREST_end();
       //   return;
       //endif;

       // -------------------------------------
       // Lectura y Parseo
       // -------------------------------------

        if REST_getEnvVar('WSPAOP_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPAOP_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

       monitor;
          xml-into request %xml(buffer : options);
       on-error;
          @@repl = 'wspAop_t';
          rc1 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'RPG0001'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'RPG0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endmon;

       // -------------------------------------
       // Control sobre los parámetros enviados
       // -------------------------------------
       // *-----------------*
       // Valido parseo Fecha
       // *-----------------*
       if request.cbateAnulador.fecha <> *blanks;

          monitor;
             @@fean = %dec(%date(request.cbateAnulador.fecha) : *iso);
          on-error;
             @@MsgF = 'WSVMSG';
             @@CodM = 'FAC0010';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endmon;

       endif;

       // *--------------------*
       // Convierto a Mayusculas
       // *--------------------*

       request.empresa   = %xlate( min : may
                                 : request.empresa);
       request.sucursal  = %xlate( min : may
                                 : request.sucursal);
       request.usuario   = %xlate( min : may
                                 : request.usuario);

       // *-------------------------*
       // Valido Comprobante de Pago
       // *-------------------------*

          if request.nroCbatePago = *zeros;
             @@MsgF = 'WSVMSG';
             @@CodM = 'ODP0053';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *---------------------------*
       // La orden de Pago debe existir
       // *---------------------------*

          if SVPSIN_chkCnhopa( request.empresa
                             : request.sucursal
                             : request.areaTecnica
                             : request.nroCbatePago ) = *on;
             @@MsgF = 'WSVMSG';
             @@CodM = 'ODP0001';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *---------------------*
       // Obtengo Datos de Pahshp
       // *---------------------*

          SVPSI1_getPahshp01( request.empresa
                            : request.sucursal
                            : request.areaTecnica
                            : request.nroCbatePago
                            : @@Dshp
                            : @@DshpC );

       // OBTENER CUIT
          @@nrdf = @@Dshp(1).hpnrdf;
          chain @@nrdf gnhdaf;
          if %found(gnhdaf);
             @@cuit = dfcuit;
          endif;


       // *---------------------*
       // Obtengo Datos de Cnhopa
       // *---------------------*

          SVPSIN_getCnhopa( request.empresa
                          : request.sucursal
                          : request.areaTecnica
                          : request.nroCbatePago
                          : @@Dspa  );

       // *---------------------*
       // Valido el estado Cnhopa
       // *---------------------*

          if @@Dspa.pastop <> '0' and
             @@Dspa.pastop <> '9';
             @@MsgF = 'WSVMSG';
             @@CodM = 'ODP0054';
             FinErr ( @@repl
                    : @@CodM
                    : peMsgs
                    : @@MsgF);
             return;
          endif;

       // *-------------------------*
       // Valido Comprobante Anulador
       // *-------------------------*

          monitor;
            @@tifa = %int ( %subst ( @@DsPa.PDCOPT:1:2 ));
            @@sufa = %int ( %subst ( @@DsPa.PDCOPT:4:4 ));
            @@nrfa = %int ( %subst ( @@DsPa.PDCOPT:9:8 ));
           on-error;
            @@tifa = 0;
            @@sufa = 0;
            @@nrfa = 0;
          endmon;

          if @@tifa <> 39;
             if @@tifa <> 0 or
                @@sufa <> 0 or
                @@nrfa <> 0;
                if SPVFAC_getFac( @@cuit
                                : @@tifa
                                : @@sufa
                                : @@nrfa
                                : @@DsFa
                                : @@DsFaC ) = *off;
                   @@MsgF = 'WSVMSG';
                   @@CodM = 'FAC0001';
                   FinErr ( @@repl
                          : @@CodM
                          : peMsgs
                          : @@MsgF);
                   return;
                endif;
             endif;
          endif;

          @@tipo = request.cbateAnulador.tipo;
          if @@tipo <> *zeros;

             if @@tipo > 99;
                //@@tfa2 = %int ( %subst
                //              ( %char ( @@tipo ):2:2 ));
                @@tfa2 = %dec ( %subst(%editc(@@tipo:'X'):2:2):2:0);
             else;
                @@tfa2 = @@tipo;
             endif;

             if SPVFAC_getEstFac( @@cuit
                                : @@tfa2
                                : request.cbateAnulador.sucursal
                                : request.cbateAnulador.numero
                                : @@fean ) = *off;
                @@MsgF = 'WSVMSG';
                @@CodM = 'FAC0017';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;

             if SPVFAC_valRelAnulacion( @@DsFa(1).actifa
                                      : @@tfa2        ) = *off;
                @@MsgF = 'WSVMSG';
                @@CodM = 'FAC0018';
                FinErr ( @@repl
                       : @@CodM
                       : peMsgs
                       : @@MsgF);
                return;
             endif;

          endif;

       // *---------------------------------*
       // Obtengo y Actualizo Nro. Orden Pago
       // *---------------------------------*

          SVPSIN_getCntopa( request.empresa
                          : request.sucursal
                          : request.areaTecnica
                          : @@DsCn
                          : @@DsCnC );

          @@DsCn(1).t@pacp = @@DsCn(1).t@pacp + 1;

          SVPSIN_updCntopa(@@DsCn(1));

       // *--------------------*
       // Obtengo Fecha Probable
       // *--------------------*

          spopfech( @@fech
                  : '+'
                  : 'D'
                  : @@DsCn(1).t@xdia
                  : @@fecr
                  : @erro );

       // -------------------------------------
       // Ok - Cargo Estructuras
       // -------------------------------------

          @@fech =  %dec(%date():*iso);
          @@feca = %subdt(%timestamp():*y);
          @@fecm = %subdt(%timestamp():*m);
          @@fecd = %subdt(%timestamp():*d);

       for x = 1 to @@DshpC;

          @@Dshp(x).hpfmoa = @@feca;
          @@Dshp(x).hpfmom = @@fecm;
          @@Dshp(x).hpfmod = @@fecd;

       // *--------------------*
       // Obtengo Nro. Secuencia
       // *--------------------*

          for y = 1 to 99;

             if SVPSI1_chkPahshp( @@Dshp(x).hpEmpr
                                : @@Dshp(x).hpSucu
                                : @@Dshp(x).hpRama
                                : @@Dshp(x).hpSini
                                : @@Dshp(x).hpNops
                                : @@Dshp(x).hpPoco
                                : @@Dshp(x).hpPaco
                                : @@Dshp(x).hpNrdf
                                : @@Dshp(x).hpSebe
                                : @@Dshp(x).hpRiec
                                : @@Dshp(x).hpXcob
                                : @@Dshp(x).hpFmoa
                                : @@Dshp(x).hpFmom
                                : @@Dshp(x).hpFmod
                                : @@Dshp(x).hpPsec );
                @@Dshp(x).hpPsec += 1;
             else;
                leave;
             endif;
          endfor;

       // *--------------------*
       // Genero nuevo Pahshp
       // *--------------------*

       @@Dshp(x).hpimmr = @@Dshp(x).hpimmr * (-1);
       @@Dshp(x).hpimau = @@Dshp(x).hpimau * (-1);
       @@Dshp(x).hppacp = @@DsCn(1).t@pacp;
       //@@Dshp(x).hppsec = @@psec;
       @@Dshp(x).hpuser = request.usuario;
       @@Dshp(x).hptime = %dec(%time() : *iso);
       @@Dshp(x).hpfera = @@feca;
       @@Dshp(x).hpferm = @@fecm;
       @@Dshp(x).hpferd = @@fecd;

       if SVPSI1_setPahshp(@@Dshp(x)) = *off;
          @@MsgF = 'WSVMSG';
          @@CodM = 'ODP0055';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs
                 : @@MsgF);
       endif;

       // *--------------------*
       // Genero nuevo Gti965
       // *--------------------*

       @@Ds65.g5empr = peEmpr;
       @@Ds65.g5sucu = peSucu;
       @@Ds65.g5rama = @@Dshp(x).hprama;
       @@Ds65.g5sini = @@Dshp(x).hpsini;
       @@Ds65.g5nops = @@Dshp(x).hpnops;
       @@Ds65.g5artc = @@Dspa.paartc;
       @@Ds65.g5pacp = @@Dspa.papacp;
       @@Ds65.g5tipo = 'A';
       @@Ds65.g5tip2 = 'T';
       @@Ds65.g5user = @@DsPa.pauser;
       @@Ds65.g5date = %dec(%date() : *iso);
       @@Ds65.g5time = %dec(%time() : *iso);

       if SVPSIN_setGti965(@@Ds65) = *off;
          @@MsgF = 'WSVMSG';
          @@CodM = 'ODP0056';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs
                 : @@MsgF);
       endif;

       // Actualizo CtaCte a no Disponible

       SVPSIN_updCtaCte ( @@Dshp(x).hprama
                        : @@Dshp(x).hpsini
                        : @@Dshp(x).hpnops );

       endfor;

       // *--------------------*
       // Grabo Cnhmop
       // *--------------------*

       clear @@Dsop;
       @@Dsop.maempr = request.empresa;
       @@Dsop.masucu = request.sucursal;
       @@Dsop.maartc = request.areaTecnica;
       @@Dsop.mapacp = request.nroCbatePago;

       if SVPSIN_setCnhmop(@@Dsop) = *off;
          @@MsgF = 'WSVMSG';
          @@CodM = 'ODP0057';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs
                 : @@MsgF);
       endif;

       // *--------------------*
       // Actualizo Cnhopa
       // *--------------------*

       @@DsPa.pastop = '3';
       SVPSIN_updCnhopa(@@Dspa);

       // *--------------------*
       // Actualiza IGA
       // *--------------------*

       peEmpr = request.empresa;
       peSucu = request.sucursal;
       peArtc = request.areaTecnica;
       pePacp = request.nroCbatePago;
       peComa = @@Dspa.pacoma;
       peNrma = @@Dspa.prNrma;
       peUser = request.usuario;
       $artca = @@Dspa.paartc;
       $pacpa = @@Dspa.papacp;
       peMoas = @@Dspa.paMoas;

       SVPSIN_updIGAant( peEmpr
                       : peSucu
                       : peMoas
                       : $nrrfa );

       // *--------------------*
       // Genero nuevo Cnhopa
       // *--------------------*

       @@DsPa.papacp = @@DsCn(1).t@pacp;

       if @@DsPa.prcoma = '*1';
          @@DsPa.prnrma = @@DsPa.papacp;
       endif;

       if @@tipo <> *zeros;
          //agrego nueva factura
          $dticp = @@tfa2;
          $dsucp = request.cbateAnulador.sucursal;
          $dfacn = request.cbateAnulador.numero;
          $ddiaf = uday;
          $dmesf = umonth;
          $daÑof = uyear;
          @@DsPa.pdcopt =  $dcopt;
       endif;

       @@DsPa.panras = @@DsCn(1).t@pacp;
       @@DsPa.paimau = @@DsPa.paimau * (-1);
       @@DsPa.pauser = request.usuario;

       //Fecha total + Hora
       $udia = uday;
       $umes = umonth;
       $uaÑo = uyear;
       $hora = %dec(%time():*iso);
       $abcv = 1;
       @@DsPa.paafhc = $afhc;

       //Fecha Asiento
       @@DsPa.pafasa = @@feca;
       @@DsPa.pafasm = @@fecm;
       @@DsPa.pafasd = @@fecd;

       //Nuevo nro Referencia
       $artcp = @@Dspa.paartc;
       $pacpp = @@Dspa.papacp;

       if SVPSIN_setCnhopa(@@Dspa) = *off;
          @@MsgF = 'WSVMSG';
          @@CodM = 'ODP0056';
          FinErr ( @@repl
                 : @@CodM
                 : peMsgs
                 : @@MsgF);
       endif;

       // *----------------------------------------------------*
       // *--------------------*
       // Verifica Condicion IVA
       // *--------------------*

       if pecoma <> '**' and pecoma <> '*1';
          svpsin_getIvaProveedor( peEmpr
                                : peSucu
                                : peComa
                                : peNrma
                                : @@DsPa.paFasa
                                : @@DsPa.paFasm
                                : @@DsPa.paFasd
                                : @@DsFa(1).acTifa
                                : @@coi2
                                : @@coi1
                                : @@poim );

       //  Busco Percepcion Ingresos Brutos.

       pePibr = svpsin_getPerIbrProveedor( peComa
                                         : peNrma );

       //  Busco Cuenta de Iva.

       wwGens = 15;
       wwGess = 2;
       wwGecv = *blanks;
       xnrcmi = 0;

       k1ytge.tgempr = peEmpr;
       k1ytge.tgsuc2 = peSucu;
       k1ytge.tggens = wwGens;
       k1ytge.tggess = wwGess;
       k1ytge.tggecv = wwGecv;
       chain %kds(k1ytge) gnttge;
       if %found(gnttge);
          xnrcmi  = %dec(tggcmg:11:0) ;
       endif;

       @@mact = *zeros;
       // Importe total a pagar
       for x = 1 to @@DsHpC;
           @@mact += @@Dshp(x).hpimau;
       endfor;

       //  Calculo Iva y Subtotal
       wwx309 = @@mact * @@poim ;
       wximiv = wwx309 / 100    ;
       wxsubt = @@mact + wximiv ;


       //  Busco y cálculo Retenciones via SP0047.

       k1ynau.naEmpr = peEmpr;
       k1ynau.naSucu = peSucu;
       k1ynau.naComa = peComa;
       k1ynau.naNrma = peNrma;
       chain %kds(k1ynau) cntnau01;
       k1yloc.locopo = dfcopo;
       k1yloc.locops = dfcops;
       chain %kds(k1yloc) gntloc02;
             @1mact = @@mact ;

             sp0047 ( peEmpr
                    : peSucu
                    : peComa
                    : peNrma
                    : @1mact
                    : wximiv
                    : @@DsPa.paFasa
                    : @@DsPa.paFasm
                    : @@DsPa.paFasd
                    : prrpro
                    : prrpro
                    : wzresn
                    : wzretor
                    : wzre01
                    : wzre02
                    : wzre03
                    : wzre04
                    : wzre05
                    : wzre06
                    : wzre07
                    : wzre08
                    : wzre09
                    : wzre10
                    : wzre11
                    : wzre12
                    : wzre13 );

        SVPOPG_getRetencionesDeOrdenPago( peEmpr
                                        : peSucu
                                        : %editc(peArtc:'X')
                                        : pePacp
                                        : @@DsEt
                                        : @@DsEtC ) ;

         //  Si tengo retenciones cargo variables según retención

        if wzre01 <> *blanks ;
         peDs047 = wzre01        ;
         xnrcm1 = peDs047.peNrcm ;
         ximre1 = peDs047.peImre ;
        endif;

        if wzre02 <> *blanks ;
         peDs047 = wzre02        ;
         xnrcm2 = peDs047.peNrcm ;
         ximre2 = peDs047.peImre ;
        endif;

        if wzre03 <> *blanks ;
         peDs047 = wzre03        ;
         xnrcm3 = peDs047.peNrcm ;
         ximre3 = peDs047.peImre ;
         xacum3 = peDs047.peAcum ;
        endif;

        if wzre04 <> *blanks ;
         peDs047 = wzre04        ;
         xnrcm4 = peDs047.peNrcm ;
         ximre4 = peDs047.peImre ;
        endif;

        if wzre05 <> *blanks ;
         peDs047 = wzre05        ;
         xnrcm5 = peDs047.peNrcm ;
         ximre5 = peDs047.peImre ;
        endif;

        if wzre06 <> *blanks ;
         peDs047 = wzre06        ;
         xnrcm6 = peDs047.peNrcm ;
         ximre6 = peDs047.peImre ;
        endif;

        if wzre07 <> *blanks ;
         peDs047 = wzre07        ;
         xnrcm7 = peDs047.peNrcm ;
         ximre7 = peDs047.peImre ;
        endif;

        if wzre08 <> *blanks ;
         peDs047 = wzre08        ;
         xnrcm8 = peDs047.peNrcm ;
         ximre8 = peDs047.peImre ;
        endif;

        if wzre09 <> *blanks ;
         peDs047 = wzre09        ;
         xnrcm9 = peDs047.peNrcm ;
         ximre9 = peDs047.peImre ;
        endif;

        if wzre11 <> *blanks ;
         peDs047 = wzre11        ;
         xnrcm2 = peDs047.peNrcm ;
         ximre2 = peDs047.peImre ;
        endif;

        if wzre13 <> *blanks ;
         peDs047 = wzre13        ;
         xnrcm0 = peDs047.peNrcm ;
         ximre0 = peDs047.peImre ;
        endif;

        endif;
       // -----------------------------------------------------
       // Write del CNHOP1 ------------------------------------
       // -----------------------------------------------------
       // Historico de Pagos Variables.

           panomb = SVPDAF_getNombre( @@nrdf );
        if peComa = '*1';
           p1empr = peEmpr;
           p1sucu = peSucu;
           p1artc = peArtc;
           p1pacp = pePacp;
           p1nomb = paNomb;
           p1domi = SVPDAF_getDomicilio( peNrma
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit );
           rc = SVPDAF_getLocalidad( peNrma
                                   : p1Copo
                                   : p1Cops
                                   : *omit
                                   : *omit
                                   : *omit
                                   : *omit );
           rc = SVPDAF_getDocumento( peNrma
                                   : p1Tido
                                   : p1Nrdo
                                   : *omit
                                   : *omit
                                   : *omit );
           write c1hop1 ;
           unlock cnhop1;
        endif ;


        // -----------------------------------------------------
        // Write del CNWNIN ------------------------------------
        // -----------------------------------------------------
        // Datos comunes

        niempr = @@Dspa.paEmpr ;
        nifasa = @@Dspa.paFasa ;
        nifasm = @@Dspa.paFasm ;
        nifasd = @@Dspa.paFasd ;
        nilibr = @@Dspa.paLibr ;
        ninras = @@Dspa.paNras ;
        nicomo = @@Dspa.paComo ;
        niscor = *zeros ;
        ninrlo = *zeros ;
        nifata = *zeros ;
        nifatm = *zeros ;
        nifatd = *zeros ;
        ninrrf = $nrrfp;
        nifera = @@Dspa.pafera ;
        niferm = @@Dspa.paferm ;
        niferd = @@Dspa.paferd ;
        nisuc2 = @@Dspa.paSucu ;
        nitic2 = @@Dspa.patico ;
        nistas = *on    ;
        nimoas = @@Dspa.pamoas ;
        niuser = @@Dspa.pauser ;
        niuaut = @@Dspa.pauser ;
        nifaut = udate   ;
        nihaut = %dec(%time():*iso) ;
        niwaut = nomjob  ;
        nipaut = nompgm  ;
        nieaut = *blanks;

        // Primero se graba la cuenta del gasto.

        wwgens = 120;
        wwgess = 1;
        $rama = @@DsHp(1).hprama;
        if @@DsHp(1).hpmar1 = 'I';
           $inga = '1';
        else;
           $inga = '2';
        endif;

        wwgecv = $gecv   ;
        ninrcm = *zeros  ;
        nicopt = *blanks ;

        k1ytge.tgempr = peEmpr;
        k1ytge.tgsuc2 = peSucu;
        k1ytge.tggens = wwGens;
        k1ytge.tggess = wwGess;
        k1ytge.tggecv = wwGecv;

        chain %kds(k1ytge) gnttge;
        if %found(gnttge);
          ninrcm  = %dec(tggcmg:11:0);
        endif;

        nidvcm = '*'     ;
        nicoma = *blanks ;
        ninrma = *zeros  ;
        nidvna = '*'     ;
        niesma = *zeros  ;
        nicopt = @@Dspa.pacopt;
        niimau = @@mact  ;

        if niimau < *zeros;
           nideha = 2;
           niimme = niimme * (-1);
           niimau = niimau * (-1);
        else;
           nideha = 1;
        endif;

        // Colita del NIN

        niinad = 11;
        nican2 = *zeros;

        //propiv
        $piva = @@poim;

        $coma = peComa;
        $nrma = peNrma;
        $esma = @@Dspa.paesma;
        $ticp = @@DsFa(1).actifa;
        $sucp = @@DsFa(1).acsufa;
        $facn = @@DsFa(1).acnrfa;
        $fafd = uday;
        $fafm = umonth;
        $fafa = uyear;
        nicaa1 = $caa1;
        nicaa2 = *all'0';

        for x = 1 to @@DsHpC;
          niseas += 1;
          nicopt = 'Stro. Nro. : ' + %char( @@DsHp(x).hpsini );
          niimau = @@DsHp(x).hpimau * (-1);

          $ivas = @@DsHp(x).hpimau * ($piva / 100);
          nican1 = $can1;    //VER COMO DIFERENCIAR
          write c1wnin;
          unlock cnwnin;

        endfor;

        niinad = *zeros;
        nican1 = *zeros;
        nicaa1 = *blanks;
        nicaa2 = *blanks;

        // IVA en el NIN

        if wximiv <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcmi;
           niimau = wximiv;
           niimco = *zeros;
           niimme = *zeros;
           if niimau < *zeros;
              nideha = 2;
              niimau = niimau * (-1);
           else;
              nideha = 1;
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
        endif;

        // Retenciones
        // 1ra Linea de Retencion...RIV

        if ximre1 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm1;
           niimau = ximre1;
           nideha = 2;
           if ximre1 < *zeros;
              nideha = 1;
              niimau = niimau * (-1);
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           //  grania
        endif;

        if ximre2 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm2;
           niimau = ximre2;
           nideha = 2;
           if ximre2 < *zeros;
              nideha = 2;
              niimau = niimau * (-1);
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           // grania
        endif;

        if ximre3 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm3;
           niimau = ximre3;
           nideha = 2;
           if ximre3 < *zeros;
              nideha = 1;
              niimau = niimau * (-1);
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           // grania
        endif;

        if ximre4 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm4;
           niimau = ximre4;
           nideha = 2;
           if ximre4 < *zeros;
              nideha = 1;
              niimau = niimau * (-1);
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           // grania
        endif;

        if ximre5 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm5;
           niimau = ximre5;
           nideha = 2;
           if ximre5 < *zeros;
              nideha = 1;
              niimau = niimau * (-1);
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           // grania
        endif;

        if ximre6 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm6;
           niimau = ximre6;
           nideha = 2;
           if ximre6 < *zeros;
              nideha = 1;
              niimau = niimau * (-1);
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           // grania
        endif;

        if ximre7 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm7;
           niimau = ximre7;
           nideha = 2;
           if ximre7 < *zeros;
              nideha = 1;
              niimau = niimau * (-1);
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           // grania
        endif;

        if ximre8 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm8;
           niimau = ximre8;
           nideha = 2;
           if ximre8 < *zeros;
              nideha = 1;
              niimau = niimau * (-1);
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           // grania
        endif;

        if ximre9 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm9;
           niimau = ximre9;
           nideha = 2;
           if ximre9 < *zeros;
              nideha = 1;
              niimau = niimau * (-1);
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           // grania
        endif;

        if ximre0 <> *zeros;
           nicopt = paNomb;
           ninrcm = xnrcm0;
           niimau = ximre0;
           nideha = 2;
           if ximre0 < *zeros;
              nideha = 1;
           endif;
           niseas += 1;
           write c1wnin;
           unlock cnwnin;
           // grania
        endif;

       //Falta percepciones

       // A Proveedor... LISTO

       ninrcm = *zeros;
       nidvcm = '*';
       nicoma = @@Dspa.pacoma;
       ninrma = @@Dspa.panrma;
       nidvna = @@Dspa.padvna;
       niesma = @@Dspa.paesma;
       nicopt = @@Dspa.pacopt;
       niimco = @@Dspa.paimco;
       niimme = @@Dspa.paimme;
       niimau = @@Dspa.paimau;
       niseas += 1;
       if niimau < *zeros;
          nideha = 1;
          niimme = niimme * (-1);
          niimau = niimau * (-1);
       else;
          nideha = 2;
       endif;
       write c1wnin;
       unlock cnwnin;

        //*--------------------*
        //Obtiene Percepciones
        //*--------------------*

          k1ypib.piempr = peEmpr;
          k1ypib.pisucu = peSucu;
          k1ypib.pimoas = peMoas;
          k1ypib.pinrrf = $nrrfa;

          setll %kds(k1ypib:4) cnhpib01;
          reade %kds(k1ypib:4) cnhpib01;
          dow not %eof(cnhpib01);

              k1ytge.tgempr = peEmpr;
              k1ytge.tgsuc2 = peSucu;
              k1ytge.tggens = 107;
              k1ytge.tggess = 04;
              k1ytge.tggecv = *blanks;
              chain %kds(k1ytge) gnttge;
              if %found(gnttge);
                 $$Cmga = tggcmg ;
                 $$Cmga = %scanrpl( 'PP' : %editc(pirpro:'X') : $$Cmga );
              endif;

              @@irau = piirau * (-1);

       // *---------------------*
       // Graba Percepciones
       // *---------------------*

             SVPSIN_setPerporProv( peEmpr
                                 : peSucu
                                 : @@DsPa.paartc
                                 : @@DsPa.papacp
                                 : $$cmgn
                                 : $nrrfp
                                 : 'CIP'
                                 : @@tifa
                                 : @@sufa
                                 : @@nrfa
                                 : pirpro
                                 : @@Dspa.paComo
                                 : @@irau
                                 : $can1
                                 : *zeros
                                 : $caa1
                                 : *blanks );
          reade %kds(k1ypib:4) cnhpib01;
          enddo;


       // *---------------------*
       // Graba Cnhret
       // *---------------------*

       if @@DsEtC > 0;

          for @x = 1 to @@DsEtC;
              exsr srCargaCnhret;
              if SVPSIN_setCnhret(@@DsEt(@x)) = *off;
                 @@MsgF = 'WSVMSG';
                 @@CodM = 'RET0001';
                 FinErr ( @@repl
                        : @@CodM
                        : peMsgs
                        : @@MsgF);
              else;

              endif;
          endfor;
          //Graba Nro.de Comprobante de Retencion
          nCompRet(peEmpr:peSucu:peMoas:$nrrfa);

       endif;

         // *-----------------*
         // Cargo nueva Factura
         // *-----------------*

         if request.cbateAnulador.tipo <> *zeros;

            // Cargo Comprobante Anulador
            peMoti = '';
            peMar1 = 'N';
            peSeco = 1;
            SPVFAC_setFac( @@Cuit
                         : request.cbateAnulador.tipo
                         : request.cbateAnulador.sucursal
                         : request.cbateAnulador.numero
                         : @@fean
                         : request.empresa
                         : request.sucursal
                         : request.areaTecnica
                         : @@DsCn(1).t@pacp
                         : @@DsFa(1).accoma
                         : @@DsFa(1).acnrma
                         : peMoti
                         : request.usuario
                         : peMar1
                         : peSeco );

         else;

              // Marca en S la factura
              SPVFAC_updFac ( @@DsFa(1).accuit
                            : @@DsFa(1).actifa
                            : @@DsFa(1).acsufa
                            : @@DsFa(1).acnrfa
                            : request.usuario  );

         endif;

         REST_writeHeader( 201
                         : *omit
                         : *omit
                         : *omit
                         : *omit
                         : *omit
                         : *omit );

      // Armo Salida
         REST_writeEncoding();

         REST_startArray( 'anulacionOrdenPago' );
           REST_writeXmlLine( 'empresa'
                            : %char(request.empresa) );
           REST_writeXmlLine( 'sucursal'
                            : %char(request.sucursal) );
           REST_writeXmlLine( 'areaTecnica'
                            : %char(request.areaTecnica) );
           REST_writeXmlLine( 'nroCbatePago'
                            : %char(@@DsCn(1).t@pacp) );

           REST_startArray( 'valores' );

             REST_writeXmlLine( 'total' : SVPREST_editImporte(@@mact) );
             REST_writeXmlLine( 'valorIva' : SVPREST_editImporte(wximiv) );
             REST_writeXmlLine( 'subTotal' : SVPREST_editImporte(wxsubt) );
             REST_writeXmlLine( 'neto'     : SVPREST_editImporte(
                                                         @@DsPa.paimau ) );

             if @@DsEtC > 0;
             REST_startArray( 'retenciones');
               for @x = 1 to @@DsEtC;
                if @@DsEt(@x).rtirau <> 0;
                      //Obtiene descripcion
                      chain @@DsEt(@x).rttiic gntdim;

                      REST_startArray( 'retencion' );
                      REST_writeXmlLine( 'codigo' : @@DsEt(@x).rttiic );
                      REST_writeXmlLine( 'descripcion' : ditiid );
                      REST_writeXmlLine( 'provincia' :
                                          %char ( @@DsEt(@x).rtrpro ));
                      REST_writeXmlLine( 'porcentaje' : %editw(
                                          @@DsEt(@x).rtpoim : '  0,  ' ));
                      REST_writeXmlLine( 'base' : SVPREST_editImporte(
                                          @@DsEt(@x).rtiiau));
                      REST_writeXmlLine( 'importe' : SVPREST_editImporte(
                                          @@DsEt(@x).rtirau));
                      REST_writeXmlLine( 'numeroCertificado' :
                                          %char ( @@DsEt(@x).rtpacp ));
                      REST_endArray  ( 'retencion' );
                endif;
               endfor;
             REST_endArray  ( 'retenciones');
             endif;
           REST_endArray  ( 'valores' );
         REST_endArray  ( 'anulacionOrdenPago');

         REST_end();

       return;

       // *----------------------------------------------------*
       begsr srCargaCnhret;

           @@DsEt(@x).rtivse = SVPSIN_obtSecRet( @@DsEt(@x).rtempr
                                               : @@DsEt(@x).rtsucu
                                               : @@DsEt(@x).rttiic
                                               : @@DsEt(@x).rtfepa
                                               : @@DsEt(@x).rtfepm
                                               : @@DsEt(@x).rtcoma
                                               : @@DsEt(@x).rtnrma
                                               : @@DsEt(@x).rtrpro );
           @@DsEt(@x).rtnras  = @@Dspa.papacp;
           @@DsEt(@x).rtiime  = @@DsEt(@x).rtiime * (-1);
           @@DsEt(@x).rtirme  = @@DsEt(@x).rtirme * (-1);
           @@DsEt(@x).rtiimp  = @@DsEt(@x).rtiimp * (-1);
           @@DsEt(@x).rtirmp  = @@DsEt(@x).rtirmp * (-1);
           @@DsEt(@x).rtiiau  = @@DsEt(@x).rtiiau * (-1);
           @@DsEt(@x).rtirau  = @@DsEt(@x).rtirau * (-1);
           @@DsEt(@x).rtbmis  = @@DsEt(@x).rtbmis * (-1);
           @@DsEt(@x).rtnrrf  = $nrrfp;
           if @@tipo <> *zeros;
              @@DsEt(@x).rtsucp = request.cbateAnulador.sucursal;
              @@DsEt(@x).rtfacn = request.cbateAnulador.numero;
              @@DsEt(@x).rtfafa = SPVFEC_OBTAÑOFECHA8 ( @@Fecr );
              @@DsEt(@x).rtfafm = SPVFEC_ObtMesFecha8 ( @@Fecr );
              @@DsEt(@x).rtfafd = SPVFEC_ObtDiaFecha8 ( @@Fecr );
           endif;

           //Base Imponible
           if @@DsEt(@x).rttiic = 'RIV';
              @@DsEt(@x).rtrbau  = @@DsEt(@x).rtrbau * (-1);
           endif;

           if @@DsEt(@x).rttiic = 'IGA';
              @@DsEt(@x).rtrbau  = xacum3;
           endif;


          endsr;
      * ------------------------------------------------- *
      *  Funcion Error Salida
     PfinErr           b
      * Interfaz Procedimiento...
     Dfinerr           pi
     D p1repl                     65535a
     D p1CodM                         7
     D p1Msgs                              likeds(paramMsgs)
     D p1MsgF                        10a
      *
          //'WSVMSG'
          rc1 = SVPWS_getMsgs( '*LIBL'
                             : p1Msgf
                             : p1CodM
                             : peMsgs
                             : %trim(p1repl)
                             : %len(%trim(p1repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : p1CodM
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
     PfinErr           e

