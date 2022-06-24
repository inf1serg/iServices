     H nomain
      * ************************************************************ *
      * SPVFDP: Programa de Servicio.                                *
      *         Cambios de Forma de Pago.                            *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     23-Ene-2014             *
      * ************************************************************ *
      * Modificaciones:                                              *
      * SFA 27/04/2015 - Agrego procedimiento chkIntFdpWeb ()        *
      * SFA 30/04/2015 - Agrego procedimiento para utilizar Web      *
      * NWN 03/07/2015 - Agrego procedimiento para grabar PAHMSG     *
      * JSN 03/05/2019 - Agrego procedimiento chkPlanDePago()        *
      * JSN 06/07/2020 - Agrego procedimientos chkPoliCbioV3()       *
      *                                        getPlanDePago()       *
      *                                        getPlanDePagoWeb()    *
      * JSN 04/08/2020 - Se agrega en los procedimientos             *
      *                  _setCbioDebitBco y _setCbioTarjCred llamar  *
      *                  a SVPVLS_getValSys para saber si se encuen- *
      *                  tra habilitado la eliminación               *
      * JSN 28/08/2020 - Se agrega validacion de chequear saldo en   *
      *                  el procedimiento _chkPoliCbioV3             *
      * JSN 02/09/2020 - Vuelve a su forma original el procedimiento *
      *                  _chkPoliCbioV3                              *
      *                                                              *
      * ERC 11/11/2020 - Se controla que no ingrese el CBU de HDI.   *
      *                                                              *
      * ERC1 26/07/2021- Se controla que no ingrese el CBU del Banco *
      *                  Brubank.(Cod.143)                           *
      *                                                              *
      * ERC2 21/12/2021- Se controla que no ingrese el CBU del Banco *
      *                  Del sol.(Cod.310)                           *
      *                                                              *
      * ERC3 10/02/2022- Se habilita que pueda ingresar el CBU del   *
      *                  Banco Brubank.(Cod.143)                     *
      *                                                              *
      * ************************************************************ *
      * Compilacion: Debe tener enlazado los SRVPGM - SPVSPO         *
      *                                             - SPVTCR         *
      *                                             - SPVCBU         *
      * CRTSRVPGM SRVPGM(SPVFDP) MODULE(SPVFDP) SRCFILE(QSRVSRC)     *
      * MBR(SPVFDP) BNDSRVPGM(SPVSPO SPVTCR SPVCBU SVPAUD)           *
      *--- Archivos ------------------------------------------------ *
     Fpahec0    uf a e           k disk    usropn
     Fpahec1    uf a e           k disk    usropn
     Fpahcc2    uf a e           k disk    usropn
     Fpahcd5    uf a e           k disk    usropn
     Fpahcfp    uf a e           k disk    usropn
     Fgti981    uf a e           k disk    usropn
     Fgti98001  uf a e           k disk    usropn
     Fset630    if   e           k disk    usropn
     Fsehnip    if   e           k disk    usropn
     Fsehnipp   if   e           k disk    usropn
     Fgntfpg02  if   e           k disk    usropn
     Fset608    if   e           k disk    usropn
     Fgnttc1    if   e           k disk    usropn prefix(tc:2)
     Fgnttc9    if   e           k disk    usropn
     Fset60801  if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/spvfdp_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/spvtcr_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/svpaud_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D setError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a
     D Initialized     s              1N

      * --------------------------------------------------- *
      * Programa Externo PAR151
      * --------------------------------------------------- *
     D  PAR151         pr                  extpgm('PAR151')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peSspo                        3  0
     D  peArno                       30a
     D  peAsen                        7  0
     D  peNoas                       40a
     D  peMone                        2a
     D  peNmoc                        5a
     D  peCfpg                        1  0
     D  peNofp                       40a
     D  peMent                       25a
     D  peFeem                        8  0
     D  peFeio                        8  0
     D  peFevo                        8  0
     D  peNivt                        1  0
     D  peNivc                        5  0
     D  peNoin                       40a
     D  peTiou                        1  0
     D  peNiou                       12a
     D  peStou                        2  0
     D  peNtou                       12a
     D  peStos                        2  0
     D  peNtos                       12a
      * --------------------------------------------------- *
      * Setea Ds Variables de Forma de Pago
      * --------------------------------------------------- *
     D setDsFdp        pr
     D  recfdp                             likeds(SPVFDP_PDS_T)

      * --------------------------------------------------- *
      * Esta estructura se basa en el programa PAR350.
      * Asi se graba la Auditoría del cambio de forma de pago.
      *
      * $cfpg  = Codigo Forma Pago Anterior
      * $nofp  = Descripcion forma de Pago Anterior
      * $cfpgn = Codigo Forma Pago Actual
      * $nofpn = Descripcion Forma de Pago Actual
      * --------------------------------------------------- *

     D                 ds                                                       PAR350
     D  $txmg                  1    198                                         PAR350
     D  $tx01                  1     20    inz('CAMBIO FORMA DE PAGO')          PAR350
     D  $tx02                 21     31    inz('. Anterior:')                   PAR350
     D  $aCfpg                33     33  0 inz                                  PAR350
     D  $aNofp                35     74    inz                                  PAR350
     D  $aMent                76    100    inz                                  PAR350
     D  $tx03                102    108    inz('Actual:')                       PAR350
     D  $nCfpg               110    110  0 inz                                  PAR350
     D  $nNofp               112    151    inz                                  PAR350
     D  $nMent               153    177    inz                                  PAR350

      *--- PR Externos --------------------------------------------- *

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SPVFDP_chkPoliCbio(): Chequea Poliza en Condiciones de       *
      *                         Realizar Cambio                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_chkPoliCbio...
     P                 B                   export
     D SPVFDP_chkPoliCbio...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peAsen                       7  0 options(*nopass:*omit)

      /free

       SPVFDP_inz();

       if %parms >= 6 and %addr(peAsen) <> *NULL;
         if not SPVSPO_chkAsen ( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : peSSpo
                               : peAsen );
           return *Off;
         endif;
       endif;

       if not SPVSPO_chkSspo ( peEmpr
                             : peSucu
                             : peArcd
                             : peSpol
                             : peSSpo );
         return *Off;
       endif;

       if not SPVSPO_chkSaldo ( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : peSSpo );
         return *Off;
       endif;

       if SPVSPO_chkCuotasPend ( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : peSspo );
         return *Off;
       endif;

       if SPVSPO_chkCuotasPreli ( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol
                                : peSspo );
         return *Off;
       endif;

       if SPVSPO_chkPenSpwy ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSspo );
         return *Off;
       endif;

       return *On;

      /end-free

     P SPVFDP_chkPoliCbio...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioTarjCred(): Cambia a Tarjeta de Credito        *
      *                           cfpg = 1                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peCfpa   (input)   Codigo de Forma de Pago Anterior      *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setCbioTarjCred...
     P                 B                   export
     D SPVFDP_setCbioTarjCred...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peCfpa                       1  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peUser                      10    const

     D recfdp          ds                  likeds(SPVFDP_PDS_T)
     D @@Vsys          s            512

      /free

       SPVFDP_inz();

       if (peCfpa = 4 or peCfpa = 5 or peCfpa = 6);
         SVPVLS_getValSys( 'HHABDLTTDC'  :*omit :@@Vsys );
         if %trim( @@Vsys ) = 'S';
           if not SPVFDP_deleteCc2 ( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : peSSpo );
             return *Off;
           endif;
         endif;
       endif;

       setDsFdp (recFdp);

       recfdp.wcfpgx = 1;
       recfdp.wctcux = peCtcu;
       recfdp.wnrtcx = peNrtc;

       if not SPVFDP_setFdp ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSSpo
                            : peUser
                            : recFdp );
         return *Off;
       endif;

       return *On;

      /end-free

     P SPVFDP_setCbioTarjCred...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioDebitBco(): Cambia a Debito Bancario           *
      *                           cfpg = 2 o 3                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peCfpa   (input)   Codigo de Forma de Pago Anterior      *
      *     peNcbu   (input)   CBU                                   *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setCbioDebitBco...
     P                 B                   export
     D SPVFDP_setCbioDebitBco...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peCfpa                       1  0 const
     D   peNcbu                      25    const
     D   peUser                      10    const

     D recfdp          ds                  likeds(SPVFDP_PDS_T)

     D@@Ivbc           s              3  0
     D@@Ivsu           s              3  0
     D@@Tcta           s              2  0
     D@@Ncta           s             25
     D @@Vsys          s            512

      /free

       SPVFDP_inz();

       if (peCfpa = 4 or peCfpa = 5 or peCfpa = 6);
         SVPVLS_getValSys( 'HHABDLTCBU'  :*omit :@@Vsys );
         if %trim( @@Vsys ) = 'S';
           if not SPVFDP_deleteCc2 ( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol
                                 : peSSpo );
             return *Off;
           endif;
         endif;
       endif;

       if     peNcbu = '0150931502000004416050   ' or
              peNcbu = '0070999020000051878944   ' or
              peNcbu = '0270100010000490110013   ' or
              peNcbu = '2850000330000800745601   ' or
              peNcbu = '0720420720000000000240   ';
              return *Off;
       endif;

   ****if %subst(peNcbu:1:3) = '143';
   ****       return *Off;
   ****endif;

       if %subst(peNcbu:1:3) = '310';
              return *Off;
       endif;

       setDsFdp (recFdp);

       if not SPVCBU_GetCBUSeparado ( peNcbu
                                    : @@ivbc
                                    : @@ivsu
                                    : @@tcta
                                    : @@ncta );
         return *Off;
       endif;

       recfdp.wcfpgx = 2;
       recfdp.wivbcx = @@ivbc;
       recfdp.wivsux = @@ivsu;
       recfdp.wtctax = @@tcta;
       recfdp.wnctax = @@ncta;

       if not SPVFDP_setFdp ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSSpo
                            : peUser
                            : recFdp );
         return *Off;
       endif;

       return *On;

      /end-free

     P SPVFDP_setCbioDebitBco...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioDebitBcoSe(): Cambia a Debito Bancario         *
      *                             cfpg = 2 o 3 (con CBU separado)  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peCfpa   (input)   Codigo de Forma de Pago Anterior      *
      *     peIvbc   (input)   Codigo de Banco                       *
      *     peIvsu   (input)   Codigo de Sucursal                    *
      *     peTcta   (input)   Tipo de Cuenta                        *
      *     peNcta   (input)   Numero de CBU                         *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setCbioDebitBcoSe...
     P                 B                   export
     D SPVFDP_setCbioDebitBcoSe...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peCfpa                       1  0 const
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 const
     D   peTcta                       2  0 const
     D   peNcta                      25    const
     D   peUser                      10    const

     D recfdp          ds                  likeds(SPVFDP_PDS_T)

      /free

       SPVFDP_inz();

       if (peCfpa = 4 or peCfpa = 5 or peCfpa = 6);
         if not SPVFDP_deleteCc2 ( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol
                                 : peSSpo );
           return *Off;
         endif;
       endif;

       setDsFdp (recFdp);

       recfdp.wcfpgx = 2;
       recfdp.wivbcx = peIvbc;
       recfdp.wivsux = peIvsu;
       recfdp.wtctax = peTcta;
       recfdp.wnctax = peNcta;

       if not SPVFDP_setFdp ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSSpo
                            : peUser
                            : recFdp );
         return *Off;
       endif;

       return *On;

      /end-free

     P SPVFDP_setCbioDebitBcoSe...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioCobrador(): Cambia a Debito Bancario           *
      *                           cfpg >= 4                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peCobr   (input)   Cobrador                              *
      *     peZona   (input)   Zona                                  *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setCbioCobrador...
     P                 B                   export
     D SPVFDP_setCbioCobrador...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peCobr                       7  0 const
     D   peZona                       7p 0 const
     D   peUser                      10    const

     D recfdp          ds                  likeds(SPVFDP_PDS_T)

      /free

       SPVFDP_inz();

       setDsFdp (recFdp);

       recfdp.wcbrnx = peCobr;
       recfdp.wczcox = peZona;
       recfdp.wcfpgx = 4;
       recfdp.wmar4x = '1';
       recfdp.wsttcx = *off;

       if not SPVFDP_setFdp ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSSpo
                            : peUser
                            : recFdp );
         return *Off;
       endif;

       return *On;

      /end-free

     P SPVFDP_setCbioCobrador...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_updEc0(): Actualiza Pahec0                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_updEc0...
     P                 B                   export
     D SPVFDP_updEc0...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

     D k1yec0          ds                  likerec(p1hec0:*key)
     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVFDP_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       setgt %kds(k1yec1:4) pahec1;
       readpe(n) %kds(k1yec1:4) pahec1;

       k1yec0.c0empr = peEmpr;
       k1yec0.c0sucu = peSucu;
       k1yec0.c0arcd = peArcd;
       k1yec0.c0spol = peSpol;
       chain %kds(k1yec0) pahec0;

       if c1sspo = peSspo;
         c0cfpg = peDfdp.wcfpgx;
         c0ctcu = peDfdp.wctcux;
         c0nrtc = peDfdp.wnrtcx;
         c0ivbc = peDfdp.wivbcx;
         c0ivsu = peDfdp.wivsux;
         c0tcta = peDfdp.wtctax;
         c0ncta = peDfdp.wnctax;
         c0nrct = peDfdp.wnrctx;
         c0ivr2 = peDfdp.wivr2x;
         c0nrrt = peDfdp.wnrrtx;
         c0nrlo = peDfdp.wnrlox;
         c0nrla = peDfdp.wnrlax;
         c0nrln = peDfdp.wnrlnx;
         c0cbrn = peDfdp.wcbrnx;
         c0czco = peDfdp.wczcox;
         c0mar4 = peDfdp.wmar4x;
         c0cocp = peDfdp.wcocpx;
         update p1hec0;
       else;
         if peDfdp.wcfpgx = 4;
           c0mar4 = peDfdp.wmar4x;
           update p1hec0;
         endif;
       endif;

       return *On;

      /end-free

     P SPVFDP_updEc0...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_updCc2(): Actualizo Pahcc2                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_updCc2...
     P                 B                   export
     D SPVFDP_updCc2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

     D k1ycc2          ds                  likerec(p1hcc2:*key)

      /free

       SPVFDP_inz();

       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;
       k1ycc2.c2sspo = peSspo;
       setll %kds(k1ycc2:5) pahcc2;
       reade %kds(k1ycc2:5) pahcc2;

       dow not %eof;
         if c2sttc = '0' or c2sttc = '1' or c2sttc = '6' or
            c2sttc = '7' or c2sttc = '4' or c2sttc = 'E';
           c2cfpg = 1;
           c2sttc = peDfdp.wsttcx;
           c2ctcu = peDfdp.wctcux;
           c2nrct = peDfdp.wnrctx;
           c2ivr2 = peDfdp.wivr2x;
           c2nrrt = peDfdp.wnrrtx;
           c2nrlo = peDfdp.wnrlox;
           c2nrla = peDfdp.wnrlax;
           c2nrln = peDfdp.wnrlnx;
           c2cbrn = peDfdp.wcbrnx;
           c2czco = peDfdp.wczcox;
           c2nrcc = *zeros;
           c2ivbc = peDfdp.wivbcx;
           c2ivsu = peDfdp.wivsux;
           c2tcta = peDfdp.wtctax;
           update p1hcc2;
         endif;
         reade %kds(k1ycc2:5) pahcc2;
       enddo;

       return *On;

      /end-free

     P SPVFDP_updCc2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_updCd5(): Actualizo Pahcd5                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_updCd5...
     P                 B                   export
     D SPVFDP_updCd5...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

     D k1ycd5          ds                  likerec(p1hcd5:*key)

      /free

       SPVFDP_inz();

       k1ycd5.d5empr = peEmpr;
       k1ycd5.d5sucu = peSucu;
       k1ycd5.d5arcd = peArcd;
       k1ycd5.d5spol = peSpol;
       k1ycd5.d5sspo = peSspo;
       setll %kds(k1ycd5:5) pahcd5;
       reade %kds(k1ycd5:5) pahcd5;

       dow not %eof;
         if d5sttc = '0' or d5sttc = '1' or d5sttc = '6' or
            d5sttc = '7' or d5sttc = '4' or d5sttc = 'E';
           d5cfpg = 1;
           d5sttc = peDfdp.wsttcx;
           d5ctcu = peDfdp.wctcux;
           d5nrct = peDfdp.wnrctx;
           d5ivr2 = peDfdp.wivr2x;
           d5nrrt = peDfdp.wnrrtx;
           d5nrlo = peDfdp.wnrlox;
           d5nrla = peDfdp.wnrlax;
           d5nrln = peDfdp.wnrlnx;
           d5cbrn = peDfdp.wcbrnx;
           d5czco = peDfdp.wczcox;
           d5nrcc = *zeros;
           d5ivbc = peDfdp.wivbcx;
           d5ivsu = peDfdp.wivsux;
           d5tcta = peDfdp.wtctax;
           update p1hcd5;
         endif;
         reade %kds(k1ycd5:5) pahcd5;
       enddo;

       return *On;

      /end-free

     P SPVFDP_updCd5...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_updCfp(): Actualiza Pahcfp                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peUser   (input)   Usuario                               *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_updCfp...
     P                 B                   export
     D SPVFDP_updCfp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peUser                      10    const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

     D k1yec1          ds                  likerec(p1hec1:*key)
     D k1ycfp          ds                  likerec(p1hcfp:*key)

      /free

       SPVFDP_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       k1yec1.c1sspo = peSspo;
       chain %kds(k1yec1) pahec1;

       k1ycfp.cfempr = peEmpr;
       k1ycfp.cfsucu = peSucu;
       k1ycfp.cfarcd = peArcd;
       k1ycfp.cfspol = peSpol;
       k1ycfp.cfsspo = peSspo;
       setgt %kds(k1ycfp:5) pahcfp;
       readpe(n) %kds(k1ycfp:5) pahcfp;

       if not %eof;
         cfivse = cfivse + 1;
       else;
         cfivse = 1;
       endif;

       cfsuse = *zeros;
       cacfpg = c1cfpg;
       cactcu = c1ctcu;
       canrtc = c1nrtc;
       caivbc = c1ivbc;
       caivsu = c1ivsu;
       catcta = c1tcta;
       cancta = c1ncta;
       canrct = c1nrct;
       caivr2 = c1ivr2;
       canrrt = c1nrrt;
       canrlo = c1nrlo;
       canrla = c1nrla;
       canrln = c1nrln;
       cacbrn = c1cbrn;
       caczco = c1czco;
       cacocp = c1cocp;
       caconr = c1conr;
       castrg = c1strg;

       cfcfpg = peDfdp.wcfpgx;
       cfctcu = peDfdp.wctcux;
       cfnrtc = peDfdp.wnrtcx;
       cfivbc = peDfdp.wivbcx;
       cfivsu = peDfdp.wivsux;
       cftcta = peDfdp.wtctax;
       cfncta = peDfdp.wnctax;
       cfnrct = peDfdp.wnrctx;
       cfivr2 = peDfdp.wivr2x;
       cfnrrt = peDfdp.wnrrtx;
       cfnrlo = peDfdp.wnrlox;
       cfnrla = peDfdp.wnrlax;
       cfnrln = peDfdp.wnrlnx;
       cfcbrn = peDfdp.wcbrnx;
       cfczco = peDfdp.wczcox;
       cfcocp = peDfdp.wcocpx;
       cfconr = peDfdp.wconrx;
       cfstrg = peDfdp.wstrgx;

       cfempr = peEmpr;
       cfsucu = peSucu;
       cfarcd = peArcd;
       cfspol = peSpol;
       cfsspo = peSspo;
       cfuser = peUser;
       cftime = 111111;
       cfdate = (uyear * 10000) + (umonth * 100) + uday;
       cfcpgm = 'BATCH';
       cfmar1 = *off;
       cfmar2 = *off;
       cfmar3 = *off;
       cfmar4 = *off;
       cfmar5 = *off;
       cfope2 = *zeros;
       cfprem = *zeros;
       cfcpg2 = *blanks;
       write p1hcfp;

       return *On;

      /end-free

     P SPVFDP_updCfp...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_updEc1(): Actualiza Pahec1                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_updEc1...
     P                 B                   export
     D SPVFDP_updEc1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVFDP_inz();

       c1cfpg = peDfdp.wcfpgx;
       c1ctcu = peDfdp.wctcux;
       c1nrtc = peDfdp.wnrtcx;
       c1ivbc = peDfdp.wivbcx;
       c1ivsu = peDfdp.wivsux;
       c1tcta = peDfdp.wtctax;
       c1ncta = peDfdp.wnctax;
       c1nrct = peDfdp.wnrctx;
       c1ivr2 = peDfdp.wivr2x;
       c1nrrt = peDfdp.wnrrtx;
       c1nrlo = peDfdp.wnrlox;
       c1nrla = peDfdp.wnrlax;
       c1nrln = peDfdp.wnrlnx;
       c1cbrn = peDfdp.wcbrnx;
       c1czco = peDfdp.wczcox;
       c1cocp = peDfdp.wcocpx;
       c1conr = peDfdp.wconrx;
       c1strg = peDfdp.wstrgx;
       c1mar1 = *off;
       update p1hec1;

       return *On;

      /end-free

     P SPVFDP_updEc1...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setSpy(): Graba Gti980                                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peUser   (input)   Usuario                               *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setSpy...
     P                 B                   export
     D SPVFDP_setSpy...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peUser                      10    const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

     D k1y980          ds                  likerec(g1i98001:*key)
     D k1y981          ds                  likerec(g1i981:*key)

      /free

       SPVFDP_inz();

       chain peArcd set630;
       if t@ma44 = '1';
         k1y980.g0empr = peEmpr;
         k1y980.g0sucu = peSucu;
         k1y980.g0arcd = peArcd;
         k1y980.g0spol = peSpol;
         setgt %kds(k1y980:4) gti98001;
         readpe %kds(k1y980:4) gti98001;

         if not %eof;
           k1y981.g1arcd = g0arcd;
           k1y981.g1rama = g0rama;
           k1y981.g1pol1 = g0poli;
           k1y981.g1suo1 = g0suo1;
           k1y981.g1soln = g0soln;
           setgt %kds(k1y981:4) gti981;
           readpe %kds(k1y981:4) gti981;

           if not %eof;
             g1sere = g1sere + 1;
           else;
             g1sere = 1;
           endif;

           g1arcd = g0arcd;
           g1rama = g0rama;
           g1pol1 = g0poli;
           g1suo1 = g0suo1;
           g1soln = g0soln;
           g1cfpg = peDfdp.wcfpgx;
           g1ctcu = peDfdp.wctcux;
           g1nrtc = peDfdp.wnrtcx;
           g1ivbc = peDfdp.wivbcx;
           g1ivsu = peDfdp.wivsux;
           g1tcta = peDfdp.wtctax;
           g1ncta = peDfdp.wnctax;
           g1mar1 = '0';
           g1mar2 = '0';
           g1mar3 = '0';
           g1mar4 = '0';
           g1mar5 = '0';
           g1user = peUser;
           g1time = 111111;
           g1date = (uyear * 10000) + (umonth * 100) + uday;
           write g1i981;
         endif;
       endif;

       return *On;

      /end-free

     P SPVFDP_setSpy...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setFdp(): Actualiza Pahcd5                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peUser   (input)   Usuario                               *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setFdp...
     P                 B                   export
     D SPVFDP_setFdp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peUser                      10    const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

     D  @@Arcd         s              6  0
     D  @@Spol         s              9  0
     D  @@Sspo         s              3  0
     D  @@Arno         s             30a
     D  @@Asen         s              7  0
     D  @@Noas         s             40a
     D  @@Mone         s              2a
     D  @@Nmoc         s              5a
     D  @@Cfpg         s              1  0
     D  @@Nofp         s             40a
     D  @@Ment         s             25a
     D  @@Feem         s              8  0
     D  @@Feio         s              8  0
     D  @@Fevo         s              8  0
     D  @@Nivt         s              1  0
     D  @@Nivc         s              5  0
     D  @@Noin         s             40a
     D  @@Tiou         s              1  0
     D  @@Niou         s             12a
     D  @@Stou         s              2  0
     D  @@Ntou         s             12a
     D  @@Stos         s              2  0
     D  @@Ntos         s             12a
     D  @@MSTX         s            198a

     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVFDP_inz();

       if not SPVFDP_chkPoliCbio ( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol
                                 : peSspo );
         return *Off;
       endif;

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       k1yec1.c1sspo = peSspo;
       chain %kds(k1yec1:5) pahec1;
       if %found(pahec1);
       else;
       endif;

      * ------------------------------------------------------------ *
      * Llamar al PAR151 con la vieja forma de pago...
      * ------------------------------------------------------------ *
      *     peDfdp.wcfpgx = Código Forma de Pago Actual                    *
      * ------------------------------------------------------------ *
       eval @@Cfpg=c1cfpg;
       eval @@Arcd=c1arcd;
       eval @@Spol=c1spol;
       eval @@Sspo=c1sspo;

        PAR151 ( @@Arcd
                :@@Spol
                :@@Sspo
                :@@Arno
                :@@Asen
                :@@Noas
                :@@Mone
                :@@Nmoc
                :@@Cfpg
                :@@Nofp
                :@@Ment
                :@@Feem
                :@@Feio
                :@@Fevo
                :@@Nivt
                :@@Nivc
                :@@Noin
                :@@Tiou
                :@@Niou
                :@@Stou
                :@@Ntou
                :@@Stos
                :@@Ntos);

       $aCfpg = c1cfpg;
       $aNofp = @@Nofp;
       $aMent = @@Ment;

       if not SPVFDP_updEc0 ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSspo
                            : peDfdp );
         return *Off;
       endif;

       if not SPVFDP_updCc2 ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSspo
                            : peDfdp );
         return *Off;
       endif;

       if not SPVFDP_updCd5 ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSspo
                            : peDfdp );
         return *Off;
       endif;

       if not SPVFDP_updCfp ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSspo
                            : peUser
                            : peDfdp );
         return *Off;
       endif;

       if not SPVFDP_updEc1 ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSspo
                            : peDfdp );
         return *Off;
       endif;

       if not SPVFDP_setSpy ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSspo
                            : peUser
                            : peDfdp );
         return *Off;
       endif;

      * ------------------------------------------------------------ *
      * Llamar al PAR151 con la nueva forma de pago...
      * ------------------------------------------------------------ *
       eval @@Cfpg=peDfdp.wcfpgx;

        PAR151 ( @@Arcd
                :@@Spol
                :@@Sspo
                :@@Arno
                :@@Asen
                :@@Noas
                :@@Mone
                :@@Nmoc
                :@@Cfpg
                :@@Nofp
                :@@Ment
                :@@Feem
                :@@Feio
                :@@Fevo
                :@@Nivt
                :@@Nivc
                :@@Noin
                :@@Tiou
                :@@Niou
                :@@Stou
                :@@Ntou
                :@@Stos
                :@@Ntos);

       $nCfpg = peDfdp.wcfpgx;
       $nNofp = @@Nofp;
       $nMent = @@Ment;

      * ------------------------------------------------------------ *
      * Llamar al SPVAUD para grabar archivo de Auditoría...
      * ------------------------------------------------------------ *
       @@Mstx = $txmg ;

        SVPAUD_logCambioTcr ( peEmpr
                             :peSucu
                             :peArcd
                             :peSpol
                             :peSspo
                             :@@Mstx
                             :peUser);

       return *On;

      /end-free

     P SPVFDP_setFdp...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_deleteCc2(): Elimina Pahcc2                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_deleteCc2...
     P                 B                   export
     D SPVFDP_deleteCc2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D k1ycc2          ds                  likerec(p1hcc2:*key)

      /free

       SPVFDP_inz();

       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;
       k1ycc2.c2sspo = peSspo;
       setll %kds(k1ycc2:5) pahcc2;
       reade %kds(k1ycc2:5) pahcc2;

       dow not %eof;
         delete p1hcc2;
         reade %kds(k1ycc2:5) pahcc2;
       enddo;

       return *On;

      /end-free

     P SPVFDP_deleteCc2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVFDP_inz      B                   export
     D SPVFDP_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahec0);
         open pahec0;
       endif;

       if not %open(pahec1);
         open pahec1;
       endif;

       if not %open(pahcc2);
         open pahcc2;
       endif;

       if not %open(pahcd5);
         open pahcd5;
       endif;

       if not %open(pahcfp);
         open pahcfp;
       endif;

       if not %open(set630);
         open set630;
       endif;

       if not %open(gti981);
         open gti981;
       endif;

       if not %open(gti98001);
         open gti98001;
       endif;

       if not %open(sehnip);
         open sehnip;
       endif;

       if not %open(sehnipp);
         open sehnipp;
       endif;

       if not %open(gntfpg02);
         open gntfpg02;
       endif;

       if not %open(set608);
         open set608;
       endif;

       if not %open(gnttc1);
         open gnttc1;
       endif;

       if not %open(gnttc9);
         open gnttc9;
       endif;

       if not %open(set60801);
         open set60801;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SPVFDP_inz      E

      * ------------------------------------------------------------ *
      * SPVFDP_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVFDP_end      B                   export
     D SPVFDP_end      pi

      /free

       close *all;

       initialized = *OFF;

       return;

      /end-free

     P SPVFDP_end      E

      * ------------------------------------------------------------ *
      * SPVFDP_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SPVFDP_error    B                   export
     D SPVFDP_error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SPVFDP_error    E

      * ------------------------------------------------------------ *
      * setError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P setError        B
     D setError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P setError...
     P                 E

      * ------------------------------------------------------------ *
      * setDsFdp(): Inicia Ds Variable Forma de Pago                 *
      *                                                              *
      *     peDfdp   (input)   DS Variable Forma de Pago.            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P setDsFdp        B
     D setDsFdp        pi
     D  peDfdp                             likeds(SPVFDP_PDS_T)

      /free

       peDfdp.wcfpgx = *zeros;
       peDfdp.wctcux = *zeros;
       peDfdp.wnrtcx = *zeros;
       peDfdp.wivbcx = *zeros;
       peDfdp.wivsux = *zeros;
       peDfdp.wtctax = *zeros;
       peDfdp.wnctax = *blanks;
       peDfdp.wivr2x = *zeros;
       peDfdp.wnrrtx = *zeros;
       peDfdp.wnrlox = *zeros;
       peDfdp.wnrlax = *blanks;
       peDfdp.wnrlnx = *zeros;
       peDfdp.wcbrnx = *zeros;
       peDfdp.wczcox = *zeros;
       peDfdp.wmar4x = *off;
       peDfdp.wcocpx = *off;
       peDfdp.wconrx = *zeros;
       peDfdp.wstrgx = 'N';
       peDfdp.wsttcx = *on;
       peDfdp.wnrctx = *zeros;

      /end-free

     P setDsFdp...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_chkIntFdpWeb(): Chequea si el intermediario esta      *
      *                     esta habilitado para cambiar la forma de *
      *                     pago desde la web                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivc   (input)   Codigo de Intermediario               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_chkIntFdpWeb...
     P                 B                   export
     D SPVFDP_chkIntFdpWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

     D k1ynip          ds                  likerec(s1hnip:*key)

      /free

       SPVFDP_inz();

       k1ynip.p1empr = peEmpr;
       k1ynip.p1sucu = peSucu;
       k1ynip.p1nivt = peNivt;
       k1ynip.p1nivc = peNivc;
       setgt %kds( k1ynip : 4 ) sehnip;
       readpe %kds( k1ynip : 4 ) sehnip;

       if not %eof ( sehnip );
         if p1mar1 = 'S';
           return *On;
         else;
           return *Off;
         endif;
       else;
         setll *Start sehnipp;
         read sehnipp;
         if ppmar1 = 'S';
           return *On;
         else;
           return *Off;
         endif;
       endif;

       return *On;

      /end-free

     P SPVFDP_chkIntFdpWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_chkNuevaFDP(): Chequea la forma de pago es valida para*
      *                       la web                                 *
      *                                                              *
      *     peNfdp   (input)   Codigo de Forma de Pago               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_chkNuevaFDP...
     P                 B                   export
     D SPVFDP_chkNuevaFDP...
     D                 pi              n
     D   peNfdp                       1  0 const

      /free

       SPVFDP_inz();

       setll peNfdp gntfpg02;

       if %equal ( gntfpg02 );
         return *On;
       else;
         return *Off;
       endif;

      /end-free

     P SPVFDP_chkNuevaFDP...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setDsTcr(): Parsea parametros para cambio a tarjeta   *
      *                                                              *
      *     peInfo   (input)   Informacion                           *
      *     peDsTc   (output)  Ds Tarjeta de Credito                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setDsTcr...
     P                 B                   export
     D SPVFDP_setDsTcr...
     D                 pi              n
     D   peInfo                     256a   const
     D   peDsTc                            likeds ( DSFMTTCR )

      /free

       SPVFDP_inz();

       monitor;
         peDsTc.tcCtcu = %dec( %subst ( peInfo : 1 : 3 ) : 3 : 0 );
         peDsTc.tcNrtc = %dec( %subst ( peInfo : 4 : 20 ) : 20 : 0 );
         return *On;
       on-error;
         peDsTc.tcCtcu = *Zeros;
         peDsTc.tcNrtc = *Zeros;
         SetError( SPVFDP_ERRPA
                 : 'Error en Parseo de Ds' );
         return *Off;
       endmon;

      /end-free

     P SPVFDP_setDsTcr...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setDsDeb(): Parsea parametros para cambio a debito    *
      *                                                              *
      *     peInfo   (input)   Informacion                           *
      *     peDsDe   (output)  Ds Debito                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setDsDeb...
     P                 B                   export
     D SPVFDP_setDsDeb...
     D                 pi              n
     D   peInfo                     256a   const
     D   peDsDe                            likeds ( DSFMTDEB )

      /free

       SPVFDP_inz();

       monitor;
         peDsDe.deNcbu = %subst ( peInfo : 1 : 22 );
         return *On;
       on-error;
         peDsDe.deNcbu = *Blanks;
         SetError( SPVFDP_ERRPA
                 : 'Error en Parseo de Ds' );
         return *Off;
       endmon;

      /end-free

     P SPVFDP_setDsDeb...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setDsCob(): Parsea parametros para cambio a efectivo  *
      *                                                              *
      *     peInfo   (input)   Informacion                           *
      *     peDsEf   (output)  Ds Efectivo                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setDsCob...
     P                 B                   export
     D SPVFDP_setDsCob...
     D                 pi              n
     D   peInfo                     256a   const
     D   peDsEf                            likeds ( DSFMTCOB )

      /free

       SPVFDP_inz();

       monitor;
         peDsEf.coCobr = %dec( %subst ( peInfo : 1 : 7 ) : 7 : 0 );
         peDsEf.coZona = %dec( %subst ( peInfo : 8 : 7 ) : 7 : 0 );
         return *On;
       on-error;
         peDsEf.coCobr = *Zeros;
         peDsEf.coZona = *Zeros;
         SetError( SPVFDP_ERRPA
                 : 'Error en Parseo de Ds' );
         return *Off;
       endmon;
       return *On;

      /end-free

     P SPVFDP_setDsCob...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioTarjCredV2(): Cambia a Tarjeta de Credito      *
      *                             cfpg = 1                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setCbioTarjCredV2...
     P                 B                   export
     D SPVFDP_setCbioTarjCredV2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peUser                      10    const

     D @@ok            s               n
     D @@sspo          s              3  0
     D @@asen          s              7  0
     D @@cfpa          s              1  0
     D recfdp          ds                  likeds(SPVFDP_PDS_T)

      /free

       SPVFDP_inz();

       @@ok = *Off;

       @@sspo = *Zeros;

       @@asen = SPVSPO_getAsen ( peEmpr : peSucu : peArcd : peSpol );
       @@cfpa = SPVSPO_getFdp ( peEmpr : peSucu : peArcd : peSpol : @@sspo );

       dow SPVSPO_chkSspo ( peEmpr : peSucu : peArcd : peSpol : @@sspo) and
       SPVSPO_chkAsen ( peEmpr : peSucu : peArcd : peSpol : @@sspo : @@asen);

         if SPVFDP_setCbioTarjCred ( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : @@sspo
                                   : @@cfpa
                                   : peCtcu
                                   : peNrtc
                                   : peUser );
           @@ok = *On;
         endif;

         @@sspo += 1;

       enddo;

       return @@ok;

      /end-free

     P SPVFDP_setCbioTarjCredV2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioDebitBcoV2(): Cambia a Debito Bancario         *
      *                             cfpg = 2 o 3                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peNcbu   (input)   CBU                                   *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setCbioDebitBcoV2...
     P                 B                   export
     D SPVFDP_setCbioDebitBcoV2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNcbu                      25    const
     D   peUser                      10    const

     D recfdp          ds                  likeds(SPVFDP_PDS_T)

     D @@ok            s               n
     D @@Ivbc          s              3  0
     D @@Ivsu          s              3  0
     D @@Tcta          s              2  0
     D @@Ncta          s             25

     D @@cfpa          s              1  0
     D @@sspo          s              3  0
     D @@asen          s              7  0

      /free

       SPVFDP_inz();

       @@ok = *Off;

       @@sspo = *Zeros;

       @@asen = SPVSPO_getAsen ( peEmpr : peSucu : peArcd : peSpol );
       @@cfpa = SPVSPO_getFdp ( peEmpr : peSucu : peArcd : peSpol : @@sspo );

       dow SPVSPO_chkSspo ( peEmpr : peSucu : peArcd : peSpol : @@sspo) and
       SPVSPO_chkAsen ( peEmpr : peSucu : peArcd : peSpol : @@sspo : @@asen);

         if SPVFDP_setCbioDebitBco ( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : @@sspo
                                   : @@cfpa
                                   : peNcbu
                                   : peUser );
           @@ok = *On;
         endif;

         @@sspo += 1;

       enddo;

       return @@ok;

      /end-free

     P SPVFDP_setCbioDebitBcoV2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioCobradorV2(): Cambia a Efectivo                *
      *                             cfpg = 4 o 5 o 6                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peCobr   (input)   Cobrador                              *
      *     peZona   (input)   Zona                                  *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_setCbioCobradorV2...
     P                 B                   export
     D SPVFDP_setCbioCobradorV2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peCobr                       7  0 const
     D   peZona                       7p 0 const
     D   peUser                      10    const

     D @@ok            s               n
     D @@sspo          s              3  0
     D @@asen          s              7  0
     D recfdp          ds                  likeds(SPVFDP_PDS_T)

      /free

       SPVFDP_inz();

       @@ok = *Off;

       @@sspo = *Zeros;

       @@asen = SPVSPO_getAsen ( peEmpr : peSucu : peArcd : peSpol );

       dow SPVSPO_chkSspo ( peEmpr : peSucu : peArcd : peSpol : @@sspo) and
       SPVSPO_chkAsen ( peEmpr : peSucu : peArcd : peSpol : @@sspo : @@asen);

         if SPVFDP_setCbioCobrador ( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : @@sspo
                                   : peCobr
                                   : peZona
                                   : peUser );
           @@ok = *On;
         endif;

         @@sspo += 1;

       enddo;

       return @@ok;

      /end-free

     P SPVFDP_setCbioCobradorV2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_chkPoliCbioV2(): Chequea Poliza en Condiciones de     *
      *                         Realizar Cambio                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (output)  Suplemento con error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_chkPoliCbioV2...
     P                 B                   export
     D SPVFDP_chkPoliCbioV2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

     D @@retu          s               n
     D @@sspo          s              3  0

     D ErrCode         s             10i 0
     D ErrText         s             80a

      /free

       SPVFDP_inz();

       if ( ( %parms >= 5 ) and ( %addr ( peSspo ) <> *Null ) );
         peSspo = 999;
       endif;

       @@retu = *Off;

       @@sspo = *Zeros;

       dow SPVSPO_chkSspo ( peEmpr : peSucu : peArcd : peSpol : @@sspo);

         if not SPVFDP_chkPoliCbio ( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : @@Sspo );

           ErrText = SPVSPO_Error(ErrCode);

           if ErrCode = SPVSPO_CPENT or ErrCode = SPVSPO_CPPRE or
              ErrCode = SPVSPO_SPPSP;
             if ( ( %parms >= 5 ) and ( %addr ( peSspo ) <> *Null ) );
               peSspo = @@sspo;
             endif;
             return *Off;
           endif;

         else;

           @@retu = *On;

         endif;

         @@sspo += 1;

       enddo;

       return @@retu;

      /end-free

     P SPVFDP_chkPoliCbioV2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_chkPlanDePago(): Chequea que existe Plan de Pago aso- *
      *                         ciado al Artículo y Forma de Pago    *
      *                                                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peCfpg   (input)   Código de Forma de Pago               *
      *     peNrpp   (input)   Número de Plan de Pago                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_chkPlanDePago...
     P                 B                   export
     D SPVFDP_chkPlanDePago...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const
     D   peNrpp                       3  0 const

     D k1y608          ds                  likerec(s1t608:*key)

      /free

       SPVFDP_inz();

       k1y608.t@Arcd = peArcd;
       k1y608.t@Cfpg = peCfpg;
       k1y608.t@Nrpp = peNrpp;
       chain %kds( k1y608 : 3 ) set608;

       if %found ( set608 );
         return *On;
       else;
         return *Off;
       endif;

      /end-free

     P SPVFDP_chkPlanDePago...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_chkPoliCbioV3(): Chequea Poliza en Condiciones de     *
      *                         Realizar Cambio                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (output)  Suplemento con error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVFDP_chkPoliCbioV3...
     P                 B                   export
     D SPVFDP_chkPoliCbioV3...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

     D @@sspo          s              3  0

     D ErrCode         s             10i 0
     D ErrText         s             80a

      /free

       SPVFDP_inz();

       if ( ( %parms >= 5 ) and ( %addr ( peSspo ) <> *Null ) );
         peSspo = 999;
       endif;

       @@sspo = *Zeros;

       dow SPVSPO_chkSspo ( peEmpr : peSucu : peArcd : peSpol : @@sspo);

         if SPVSPO_chkCuotasPend( peEmpr : peSucu : peArcd :
                                  peSpol : @@Sspo );
           return *off;
         endif;

         if SPVSPO_chkCuotasPreli( peEmpr : peSucu : peArcd :
                                   peSpol : @@Sspo );
           return *off;
         endif;

         if SPVSPO_chkPenSpwy( peEmpr : peSucu : peArcd :
                               peSpol : @@Sspo );
           return *off;
         endif;

         @@sspo += 1;

       enddo;

       return *on;

      /end-free

     P SPVFDP_chkPoliCbioV3...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_getPlanDePago(): Retorna el Plan de Pago asociado al  *
      *                         Artículo y Forma de Pago.            *
      *                                                              *
      *     peArcd  ( input  )  Código de Artículo                   *
      *     peCfpg  ( input  )  Código de Forma de Pago              *
      *                                                              *
      * Retorna: NRPP                                                *
      * ------------------------------------------------------------ *

     P SPVFDP_getPlanDePago...
     P                 B                   export
     D SPVFDP_getPlanDePago...
     D                 pi             3  0
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const

     D k1y608          ds                  likerec(s1t608:*key)

      /free

       SPVFDP_inz();

       k1y608.t@Arcd = peArcd;
       k1y608.t@Cfpg = peCfpg;
       setll %kds( k1y608 : 2 ) set608;
       reade %kds( k1y608 : 2 ) set608;
       dow not %eof( set608 );
         if t@Mar1 = 'S';
           return t@Nrpp;
         endif;
         reade %kds( k1y608 : 2 ) set608;
       enddo;

       k1y608.t@Arcd = peArcd;
       k1y608.t@Cfpg = peCfpg;
       chain %kds( k1y608 : 2 ) set608;
       if %found( set608 );
         return t@Nrpp;
       endif;

       return *zeros;

      /end-free

     P SPVFDP_getPlanDePago...
     P                 E

      * ------------------------------------------------------------ *
      * SPVFDP_getPlanDePagoWeb(): Retorna el Plan de Pago asociado  *
      *                            al Artículo y la Forma de Pago,   *
      *                            habilitado para la web.           *
      *                                                              *
      *     peArcd  ( input  )  Código de Artículo                   *
      *     peCfpg  ( input  )  Código de Forma de Pago              *
      *                                                              *
      * Retorna: NRPP                                                *
      * ------------------------------------------------------------ *

     P SPVFDP_getPlanDePagoWeb...
     P                 B                   export
     D SPVFDP_getPlanDePagoWeb...
     D                 pi             3  0
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const

     D k1y60801        ds                  likerec(s1t60801:*key)

      /free

       SPVFDP_inz();

       k1y60801.t@Arcd = peArcd;
       k1y60801.t@Cfpg = peCfpg;
       setll %kds( k1y60801 : 2 ) set60801;
       reade %kds( k1y60801 : 2 ) set60801;
       dow not %eof( set60801 );
         if t@Mar1 = 'S';
           return t@Nrpp;
         endif;
         reade %kds( k1y60801 : 2 ) set60801;
       enddo;

       k1y60801.t@Arcd = peArcd;
       k1y60801.t@Cfpg = peCfpg;
       chain %kds( k1y60801 : 2 ) set60801;
       if %found( set60801 );
         return t@Nrpp;
       endif;

       return *zeros;

      /end-free

     P SPVFDP_getPlanDePagoWeb...
     P                 E

