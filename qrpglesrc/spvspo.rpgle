     H nomain
     H alwnull(*usrctl)
      * ************************************************************ *
      * SPVSPO: Programa de Servicio.                                *
      *         SuperoPoliza                                         *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     24-Ene-2013             *
      * ************************************************************ *
      * Modificaciones:                                              *
      * SFA 29/07/2014 - Agrego servicio chkAnulada y getHastaFac    *
      * SFA 20/08/2014 - Se corrige servicio SPVSPO_chkSaldo, no debe*
      *                  chequear saldo en suplementos anteriores.   *
      * SFA 05/05/2015 - Agrego servicio getFdp                      *
      *                  Agrego servicio getAsen                     *
      * LRG 10/06/2015 - Agrego servicio chkVig                      *
      *                  Agrego servicio getFecEmi                   *
      *                  Agrego servicio chkWeb                      *
      *                  Agrego servicio getParWeb                   *
      *                  Agrego servicio getFecVig                   *
      * SFA 27/08/2015 - Agrego servicio getProducto                 *
      * SFA 02/08/2016 - Agrego servicio getDiasFacturacionEndoso    *
      * LRG 24/05/2016 - Agrego servicio getRama                     *
      *                                  getPoliza                   *
      *                                  getProductor                *
      *                                  getPolizaAnterior           *
      *                                  getFormaDePago              *
      *                                  getRecAdministrativo        *
      * LRG 01/08/2016 - Agergo servicio getHastaFacturado           *
      * SFA 28/06/2016 - Agrego servicio getCodigoIva                *
      * LRG 20/09/2016 - Agrego servicio getTipoOperacion            *
      * LRG 22/12/2016 - Agrego servicio getPlanDePago               *
      *                                  getCodPlanDePago            *
      * NWN 28/08/2017 - Agrego servicio getPolizaAbierta            *
      * LRG 15/12/2017 - Se corrige procedimiento : SPVSPO_getSpol() *
      * GIO 15/12/2017 - Recompilacion por cambio de estructura en   *
      *                  el archivo SETWEB                           *
      * EXT 23/07/2018 - Agrego servicio getCuotasEmitidas           *
      *                                  getCantidadCuotasEmitidas   *
      *                                  chkCuotaPaga                *
      *                                  chkCuotaPermiteRecibo       *
      *                                  chkAnuladaV2                *
      * JSN 03/05/2018 - Agrego servicio _chkCuotasPendientes        *
      * EXT 16/10/2018 - Agrego servicio getCuotasImpagas            *
      * EXT 01/11/2018 - Agrego servicio getCuotasImpagasMes         *
      * LRG 04/03/2018 - Agrego servicio chkSuspEsp                  *
      *                                  getCabeceraSuplemento       *
      *                                  chkBloqueo                  *
      *                                  getNuevoSuplemento          *
      *                                  setCabeceraSuplemento       *
      *                                  chkCabecera                 *
      *                                  getCabecera                 *
      *                                  setCabecera                 *
      *                                  chkComisionCobranza         *
      *                                  getComisionCobranza         *
      *                                  setComisionCobranza         *
      *                                  chkPlanDePago               *
      *                                  setPlanDePago               *
      *                                  chkReferencias              *
      *                                  setReferencias              *
      *                                  getReferencias              *
      *                                  chkBeneficiario             *
      *                                  getBeneficiarios            *
      *                                  setBeneficiarios            *
      *                                  chkAsegurado                *
      *                                  setPrimaxProvincia          *
      *                                  chkPrimaxProvincia          *
      *                                  dltPrimaxProvincia          *
      *                                  setPrimxProvRegSimp         *
      *                                  chkPrimxProvRegSimp         *
      *                                  dltPrimxProvRegSimp         *
      * JSN 01/04/2019 - Agrego servicios: _getUltimoSuplemento      *
      *                  _getDatosProgramasInternacionales           *
      *                                                              *
      * GIO 30/05/2019 RM#5012 Las polizas de Vida y AP que          *
      *                cuenten con Iterfase no deben generar los     *
      *                PDF con certificados de incorporación.        *
      *                Asimismo discontinuar para todos los casos    *
      *                los certific. de cobertura tipo (pergamino).  *
      *                Se agrega el procedimiento:                   *
      *                - SPVSPO_isNominaExterna                      *
      * JSN 19/09/2019 - Se agrega los procedimientos:               *
      *                  _getPahec0c)                                *
      *                  _getSuperpolizaAnterior)                    *
      *                  _getSuperpolizaPosterior                    *
      * NWN 01/11/2019 Se recompila SPVSPO por agregado de Campos    *
      *                en getDatosProgramasInternacionales.          *
      * SGF 17/07/2020 Descuento decreciente.                        *
      * JSN 17/07/2020 Se agrega procedimiento: _updPlanDePago       *
      * LRG 03/09/2020 Nuevo procedimiento : _getPahcd6              *
      *                                      _chkPahcd6              *
      * JSN 18/09/2020 Se agregan los procedimientos:                *
      *                 _setPahcd6                                   *
      *                 _getUltSecuncia                              *
      *                 _getPahcc2                                   *
      *                 _chkPahcc3                                   *
      *                 _setPahcc3                                   *
      *                 _chkPahcd7                                   *
      *                 _setPahcd7                                   *
      *                 _UltSecCobPagoProc                           *
      *                 _UltSecuenciaPagos                           *
      *                 _UltSecCobranza                              *
      *                 _getDiferenciaGA                             *
      *                 _UltSecCobrProc                              *
      *                 _updPahcd5                                   *
      *                 _updPahcc2                                   *
      *                                                              *
      * JSN 06/01/2021 Se agrega el procedimiento _getFechaAnualidad *
      * JSN 11/01/2021 Se agrega el procedimiento _getPahcc2V2       *
      * SGF 20/07/2021 Se agrega el procedimiento _anulaArrepEnProceso
      * JSN 30/03/2022 Se agrega el procedimiento _getNroExpediente  *
      *                                           _setSsnp04         *
      * VCM 09/03/2022 Se agrega el procedimiento _getIntermediario  *
      *                                                              *
      * ************************************************************ *
     Fpahec0    uf a e           k disk    usropn
     Fpahed0    if   e           k disk    usropn
     Fpahed001  if   e           k disk    usropn
     Fpaher0    if   e           k disk    usropn
     Fpahec1    uf a e           k disk    usropn
     Fpahcc2    uf   e           k disk    usropn
     Fset320    if   e           k disk    usropn
     Fset621    if   e           k disk    usropn
     Fset630    if   e           k disk    usropn
     Fset990    uf a e           k disk    usropn
     FsetWeb    if   e           k disk    usropn
     Fpawpc0    uf a e           k disk    usropn
     Fpawpc001  if   e           k disk    usropn
     Fgti98001  if   e           k disk    usropn
     Fpahscd11  if   e           k disk    usropn
     Fsehni2    if   e           k disk    usropn
     Fpahec0c   if   e           k disk    usropn
     Fpahec3    uf a e           k disk    usropn
     Fpahed9    if   e           k disk    usropn
     Fpahcd5    uf   e           k disk    usropn
     Fpawkl1    if   e           k disk    usropn
     Fpahcd6    uf a e           k disk    usropn
     Fpahcd618  if   e           k disk    usropn prefix(ll:2)
     Fpahec2    uf a e           k disk    usropn
     Fpahec4    uf a e           k disk    usropn
     Fpahec5    uf a e           k disk    usropn
     Fpahec501  if   e           k disk    usropn
     Fpahec6    uf a e           k disk    usropn
     Fpahec8    uf a e           k disk    usropn
     Fpahec9    uf a e           k disk    usropn
     Fpaheg3    uf a e           k disk    usropn
     Fpaheg3p   uf a e           k disk    usropn
     Fpahec7    if   e           k disk    usropn
     Fpahnx002  if   e           k disk    usropn
     Fctw00018  if   e           k disk    usropn
     Fpahcd7    uf a e           k disk    usropn
     Fpahcc3    uf a e           k disk    usropn
     Fpahcc302  if   e           k disk    usropn
     Fgnttge    if   e           k disk    usropn
     Fpahcd602  if   e           k disk    usropn
     Fpahag404  if   e           k disk    usropn
     Fssnp01    if   e           k disk    usropn
     Fssnp04    Uf a e           k disk    usropn
     Fpahpol09  if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/spvspo_h.rpgle'
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N
     D Local           ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(Local:401)
     D  sucu                          2a   overlay(Local:402)

      *--- PR Internos --------------------------------------------- *
     D ultCuoSup       pr              n
     D   peEmpr                       1    Const
     D   peSucu                       2    Const
     D   peArcd                       6  0 Const
     D   peSpol                       9  0 Const
     D   peSspo                       3  0 Const
     D   peNrcu                       2  0 Const

      *--- PR Externos --------------------------------------------- *
     D SP00193         pr                  extpgm('SP00193')
     D    arcd                        6  0 const
     D    spol                        9  0 const
     D    sspo                        3  0 const
     D    ncta                       15  2
     D    fpgm                        3

     Dspvig2           pr                  extpgm('SPVIG2')
     D                                6  0
     D                                9  0
     D                                2  0
     D                                2  0
     D                                7  0
     D                                8  0
     D                                8  0
     D                                 n
     D                                3  0
     D                                3  0
     D                                3a
     Dspsald           pr                  extpgm('SPSALD')
     D                                6  0
     D                                9  0
     D                                2  0
     D                                4  0
     D                                2  0
     D                                2  0
     D                               15  2
     D                                2
     D                                3

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

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SPVSPO_chkSpol(): Valida Existencia de SuperPoliza           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkSpol...
     P                 B                   export
     D SPVSPO_chkSpol...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yec0          ds                  likerec(p1hec0:*key)

      /free

       SPVSPO_inz();

       k1yec0.c0empr = peEmpr;
       k1yec0.c0sucu = peSucu;
       k1yec0.c0arcd = peArcd;
       k1yec0.c0spol = peSpol;
       setll %kds(k1yec0:4) pahec0;

       if %equal;
         return *On;
       else;
         SetError( SPVSPO_SPINE
                 : 'SuperPoliza Inexistente' );
         return *Off;
       endif;

      /end-free

     P SPVSPO_chkSpol...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkSspo(): Valida Existencia de Suplemento            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkSspo...
     P                 B                   export
     D SPVSPO_chkSspo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       k1yec1.c1sspo = peSspo;
       setll %kds(k1yec1:5) pahec1;
       reade(n) %kds(k1yec1:5) pahec1;

       if not %eof;
         if c1mar1 <> '0';
           SetError( SPVSPO_SUINH
                   : 'Suplemento Inhabilitado' );
           return *Off;
         endif;
       else;
         SetError( SPVSPO_SUINE
                 : 'Suplemento Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SPVSPO_chkSspo...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getStatusIng(): Obtiene Status de Ingreso             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Obtiene Status de Ingreso / *blanks en caso de erro *
      * ------------------------------------------------------------ *

     P SPVSPO_getStatusIng...
     P                 B                   export
     D SPVSPO_getStatusIng...
     D                 pi             1
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       k1yec1.c1sspo = peSspo;
       setll %kds(k1yec1:5) pahec1;
       reade(n) %kds(k1yec1:5) pahec1;

       return c1ivsi;

      /end-free

     P SPVSPO_getStatusIng...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getSuspEsp(): Obtiene si es Suspendida Especial       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: Estado Suspendida Especial / *Blanks en caso de erro*
      * ------------------------------------------------------------ *

     P SPVSPO_getSuspEsp...
     P                 B                   export
     D SPVSPO_getSuspEsp...
     D                 pi             1
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yec0          ds                  likerec(p1hec0:*key)

      /free

       SPVSPO_inz();

       k1yec0.c0empr = peEmpr;
       k1yec0.c0sucu = peSucu;
       k1yec0.c0arcd = peArcd;
       k1yec0.c0spol = peSpol;
       setll %kds(k1yec0:4) pahec0;
       reade(n) %kds(k1yec0:4) pahec0;

       return c0mar2;

      /end-free

     P SPVSPO_getSuspEsp...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getSaldo(): Obtiene Saldo de Poliza                   *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Saldo                                               *
      * ------------------------------------------------------------ *

     P SPVSPO_getSaldo...
     P                 B                   export
     D SPVSPO_getSaldo...
     D                 pi            15  2
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D @@sald          s             15  2
     D @@fpgm          s              3    inz('   ')

      /free

       SPVSPO_inz();

       SP00193 ( peArcd
               : peSpol
               : peSspo
               : @@sald
               : @@fpgm );

       return @@sald;

      /end-free

     P SPVSPO_getSaldo...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getPremio(): Obtiene Premio                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Obtiene Premio / 999999999999999,99 en caso de erro *
      * ------------------------------------------------------------ *

     P SPVSPO_getPremio...
     P                 B                   export
     D SPVSPO_getPremio...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       k1yec1.c1sspo = peSspo;
       setll %kds(k1yec1:5) pahec1;
       reade(n) %kds(k1yec1:5) pahec1;

       if not %eof;
         return c1prem;
       else;
         SetError( SPVSPO_NEPRE
                 : 'No se Encontro el Premio' );
         return 999999999999999,99;
       endif;

      /end-free

     P SPVSPO_getPremio...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getCuotas(): Obtiene Cantidad de cuotas               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Cantidad de Cuotas                                  *
      * ------------------------------------------------------------ *

     P SPVSPO_getCuotas...
     P                 B                   export
     D SPVSPO_getCuotas...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D@@cont           s              3  0

     D k1ycc2          ds                  likerec(p1hcc2:*key)

      /free

       SPVSPO_inz();

       @@cont = 0;

       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;
       k1ycc2.c2sspo = peSspo;
       setll %kds(k1ycc2:5) pahcc2;
       reade %kds(k1ycc2:5) pahcc2;

       dow not %eof;
         @@cont = @@cont + 1;
         reade %kds(k1ycc2:5) pahcc2;
       enddo;

       return @@cont;

      /end-free

     P SPVSPO_getCuotas...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkCuotasPend(): Chequea sin Cuotas Pendientes        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkCuotasPend...
     P                 B                   export
     D SPVSPO_chkCuotasPend...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D k1y320          ds                  likerec(s1t320:*key)
     D k1ycc2          ds                  likerec(p1hcc2:*key)

      /free

       SPVSPO_inz();

       k1y320.t@empr = peEmpr;
       k1y320.t@sucu = peEmpr;
       chain %kds(k1y320) set320;

       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;
       k1ycc2.c2sspo = peSspo;
       setll %kds(k1ycc2:5) pahcc2;
       reade %kds(k1ycc2:5) pahcc2;

       dow not %eof;
         if c2nrcc <> *zeros and
            c2sttc <> '3'    and
            c2marp <> '1'    and
            t@ma29 = '1'     or
            c2nrcc <> *zeros and
            c2sttc <> '3'    and
            c2marp <> '1'    and
            t@ma29 = '3';
           return *On;
           SetError( SPVSPO_CPENT
                   : 'SuperPoliza con Cupones Pendientes de Entrega' );
         endif;
         reade %kds(k1ycc2:5) pahcc2;
       enddo;

       return *Off;

      /end-free

     P SPVSPO_chkCuotasPend...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkCuotasPreli(): Chequea sin Cuotas en Preliquidacion*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkCuotasPreli...
     P                 B                   export
     D SPVSPO_chkCuotasPreli...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D k1y320          ds                  likerec(s1t320:*key)
     D k1ycc2          ds                  likerec(p1hcc2:*key)

      /free

       SPVSPO_inz();

       k1y320.t@empr = peEmpr;
       k1y320.t@sucu = peEmpr;
       chain %kds(k1y320) set320;

       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;
       k1ycc2.c2sspo = peSspo;
       setll %kds(k1ycc2:5) pahcc2;
       reade %kds(k1ycc2:5) pahcc2;

       dow not %eof;
         if c2sttc = '2' or
            c2sttc = '2' or
            c2sttc = 'C' or
            c2sttc = 'C' ;
           SetError( SPVSPO_CPPRE
                   : 'SuperPoliza con Cuotas en Preliquidacion' );
           return *On;
         endif;
         reade %kds(k1ycc2:5) pahcc2;
       enddo;

       return *Off;

      /end-free

     P SPVSPO_chkCuotasPreli...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkPenSpwy(): Chequea si falta emision por Speedway   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkPenSpwy...
     P                 B                   export
     D SPVSPO_chkPenSpwy...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D k1y980          ds                  likerec(g1i98001:*key)

      /free

       SPVSPO_inz();

       chain peArcd set630;

       if t@ma44 = '1';
         k1y980.g0empr = peEmpr;
         k1y980.g0sucu = peSucu;
         k1y980.g0arcd = peArcd;
         k1y980.g0spol = peSpol;
         k1y980.g0sspo = peSspo;
         setgt %kds(k1y980:5) gti98001;
         readpe %kds(k1y980:5) gti98001;
         if not %eof and g0poli = 0;
           SetError( SPVSPO_SPPSP
                   : 'SuperPoliza con Emision Pendiente en Speedway' );
           return *On;
         endif;
       endif;

       return *Off;

      /end-free

     P SPVSPO_chkPenSpwy...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkPenSpeedway(): Chequea si falta emision por Speed  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkPenSpeedway...
     P                 B                   export
     D SPVSPO_chkPenSpeedway...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1y980          ds                  likerec(g1i98001:*key)

      /free

       SPVSPO_inz();

       chain peArcd set630;

       if t@ma44 = '1';
         k1y980.g0empr = peEmpr;
         k1y980.g0sucu = peSucu;
         k1y980.g0arcd = peArcd;
         k1y980.g0spol = peSpol;
         setgt %kds(k1y980:4) gti98001;
         readpe %kds(k1y980:4) gti98001;
         if not %eof and g0poli = 0;
           SetError( SPVSPO_SPPSP
                   : 'SuperPoliza con Emision Pendiente en Speedway' );
           return *On;
         endif;
       endif;

       return *Off;

      /end-free

     P SPVSPO_chkPenSpeedway...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkSaldo(): Chequea si Tiene Saldo                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkSaldo...
     P                 B                   export
     D SPVSPO_chkSaldo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D @@saldo         s             15  2
     D @@premi         s             15  2
     D @@marp2         s              1
     D @@cuota         s              3  0

      /free

       SPVSPO_inz();

       @@saldo = SPVSPO_getSaldo ( peArcd
                                 : peSpol
                                 : peSspo );

       @@premi = SPVSPO_getPremio ( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : peSspo );


       if @@premi = *Zeros or @@saldo = *Zeros;
         @@cuota = SPVSPO_getCuotas ( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : peSspo );

         @@marp2 = SPVSPO_getSuspEsp ( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol );
         if @@cuota > 0 and @@marp2 = '0';
           SetError( SPVSPO_PSSSP
                   : 'Poliza/Suplemente sin Saldo' );
           return *Off;
         endif;
       endif;

       return *On;

      /end-free

     P SPVSPO_chkSaldo...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVSPO_inz      B                   export
     D SPVSPO_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahec0);
         open pahec0;
       endif;

       if not %open(pahed0);
         open pahed0;
       endif;

       if not %open(pahed001);
         open pahed001;
       endif;

       if not %open(pahec1);
         open pahec1;
       endif;

       if not %open(pahcc2);
         open pahcc2;
       endif;

       if not %open(set320);
         open set320;
       endif;

       if not %open(set621);
         open set621;
       endif;

       if not %open(set630);
         open set630;
       endif;

       if not %open(setweb);
         open setweb;
       endif;

       if not %open(gti98001);
         open gti98001;
       endif;

       if not %open(set990);
         open set990;
       endif;

       if not %open(pawpc0);
         open pawpc0;
       endif;

       if not %open(pawpc001);
         open pawpc001;
       endif;

       if not %open(pahscd11);
         open pahscd11;
       endif;

       if not %open(paher0);
         open paher0;
       endif;

       if not %open(sehni2);
         open sehni2;
       endif;

       if not %open(pahec0c);
         open pahec0c;
       endif;

       if not %open(pahec3);
         open pahec3;
       endif;

       if not %open(pahed9);
         open pahed9;
       endif;

       if not %open(pahcd5);
         open pahcd5;
       endif;

       if not %open(pahcd6);
         open pahcd6;
       endif;

       if not %open(pahcd618);
         open pahcd618;
       endif;

       if not %open(pawkl1);
         open pawkl1;
       endif;

       if not %open(pahec2);
         open pahec2;
       endif;

       if not %open(pahec4);
         open pahec4;
       endif;

       if not %open(pahec5);
         open pahec5;
       endif;

       if not %open(pahec501);
         open pahec501;
       endif;

       if not %open(pahec6);
         open pahec6;
       endif;

       if not %open(pahec8);
         open pahec8;
       endif;

       if not %open(pahec9);
         open pahec9;
       endif;

       if not %open(paheg3);
         open paheg3;
       endif;

       if not %open(paheg3p);
         open paheg3p;
       endif;

       if not %open(pahec7);
         open pahec7;
       endif;

       if not %open(pahnx002);
         open pahnx002;
       endif;

       if not %open(ctw00018);
         open ctw00018;
       endif;

       if not %open(pahcc3);
         open pahcc3;
       endif;

       if not %open(pahcd7);
         open pahcd7;
       endif;

       if not %open(pahcc302);
         open pahcc302;
       endif;

       if not %open(gnttge);
         open gnttge;
       endif;

       if not %open(pahcd602);
         open pahcd602;
       endif;

       if not %open(pahag404);
         open pahag404;
       endif;

       if not %open(ssnp01);
         open ssnp01;
       endif;

       if not %open(ssnp04);
         open ssnp04;
       endif;

       if not %open(pahpol09);
         open pahpol09;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SPVSPO_inz      E

      * ------------------------------------------------------------ *
      * SPVSPO_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVSPO_End      B                   export
     D SPVSPO_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SPVSPO_End      E

      * ------------------------------------------------------------ *
      * SPVSPO_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SPVSPO_Error    B                   export
     D SPVSPO_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SPVSPO_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkSaldoSupAnt(): Chequea si los suplmentos anteriores*
      *        tienen saldo (para endosos sin movimiento de saldo)   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkSaldoSupAnt...
     P                 B                   export
     D SPVSPO_chkSaldoSupAnt...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D k1yed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       setll %kds(k1yed0:4) pahed0;
       reade %kds(k1yed0:4) pahed0;

       dow not %eof and d0sspo < peSSpo;
         if SPVSPO_chkSaldo ( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : d0sspo );
           return *On;
         endif;
       reade %kds(k1yed0:4) pahed0;
       enddo;

       SetError( SPVSPO_SASSA
               : 'Suplementos Anteriores sin Saldo' );
       return *Off;

      /end-free

     P SPVSPO_chkSaldoSupAnt...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkAsen(): Chequea Asegurado de Poliza/Suplemento     *
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

     P SPVSPO_chkAsen...
     P                 B                   export
     D SPVSPO_chkAsen...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peAsen                       7  0 const

     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       k1yec1.c1sspo = peSspo;
       chain(n) %kds(k1yec1) pahec1;

       if c1asen = peAsen;
         return *On;
       else;
         return *Off;
         SetError( SPVSPO_ANCPS
                 : 'Poliza con Cambio de Asegurado' );
       endif;

      /end-free

     P SPVSPO_chkAsen...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkAnulada(): Chequea si la Poliza esta anulada       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkAnulada...
     P                 B                   export
     D SPVSPO_chkAnulada...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       setgt %kds(k1yed0:4) pahed0;
       readpe %kds(k1yed0:4) pahed0;

       if d0tiou = 4;
         SetError( SPVSPO_POLAN
                 : 'Poliza Anulada' );
         return *On;
       else;
         return *Off;
       endif;

      /end-free

     P SPVSPO_chkAnulada...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getHastaFac(): Obtiene hasta facturado (AAAAMMDD)     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: Hasta Facturado (AAAAMMDD)                          *
      * ------------------------------------------------------------ *

     P SPVSPO_getHastaFac...
     P                 B                   export
     D SPVSPO_getHastaFac...
     D                 pi             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yec0          ds                  likerec(p1hec0:*key)

      /free

       SPVSPO_inz();

       k1yec0.c0empr = peEmpr;
       k1yec0.c0sucu = peSucu;
       k1yec0.c0arcd = peArcd;
       k1yec0.c0spol = peSpol;
       chain(n) %kds(k1yec0:4) pahec0;

       return c0fhfa*10000 + c0fhfm*100 + c0fhfd;

      /end-free

     P SPVSPO_getHastaFac...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getSpol(): Retorna Numero de SuperPoliza              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peGrab   (input)   Marca de Actualizar Set990            *
      *                                                              *
      * Retorna: Nro de SuperPoliza                                  *
      * ------------------------------------------------------------ *

     P SPVSPO_getSpol...
     P                 B                   export
     D SPVSPO_getSpol...
     D                 pi             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peGrab                       1    options(*Nopass:*Omit)

     D @@updt          s               n
     D @@spol          s              9  0

     D k1y990          ds                  likerec(s1t990:*key)

      /free

       SPVSPO_inz();

       @@updt = *Off;

       if %parms >= 4 and %addr(peGrab) <> *Null;
         if peGrab = 'S';
           @@updt = *On;
         endif;
       endif;

       k1y990.t@empr = peEmpr;
       k1y990.t@sucu = peSucu;
       k1y990.t@arcd = peArcd;
       chain %kds(k1y990) set990;

       if not %found(set990);
         t@empr = peEmpr;
         t@sucu = peSucu;
         t@arcd = peArcd;
         t@spol = 1;
         t@user = @PsDs.CurUsr;
         t@date = %dec(%date():*ymd);

         if @@updt;
           write s1t990;
         endif;
       else;
         t@spol += 1;
         if @@updt;
           update s1t990;
         endif;
       endif;

       @@spol = t@spol;
       return @@spol;

      /end-free

     P SPVSPO_getSpol...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkSpolEnProc(): Chequea si la SuperPoliza esta en    *
      *                         Proceso                              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkSpolEnProc...
     P                 B                   export
     D SPVSPO_chkSpolEnProc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1ypc0          ds                  likerec(p1wpc001:*key)

      /free

       SPVSPO_inz();

       k1ypc0.w0empr = peEmpr;
       k1ypc0.w0sucu = peSucu;
       k1ypc0.w0arcd = peArcd;
       k1ypc0.w0spo1 = peSpol;
       setll %kds(k1ypc0) pawpc001;

       if %equal(pawpc001);
         SetError( SPVSPO_SPOPR
                 : 'SuperPoliza en Proceso' );
         return *On;
       else;
         return *Off;
       endif;

      /end-free

     P SPVSPO_chkSpolEnProc...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getFdp(): Retorna la Forma de Pago de un Suplemento   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Forma de Pago / -1 Error                            *
      * ------------------------------------------------------------ *

     P SPVSPO_getFdp...
     P                 B                   export
     D SPVSPO_getFdp...
     D                 pi             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D   @@sspo        s              3  0 inz

      /free
       @@sspo = peSspo;
       return SPVSPO_getFormaDePago( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : @@sspo );

      /end-free

     P SPVSPO_getFdp...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getAsen(): Retorna Asegurado                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Asegurado / -1 Error                                *
      * ------------------------------------------------------------ *

     P SPVSPO_getAsen...
     P                 B                   export
     D SPVSPO_getAsen...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *Null;
         k1yec1.c1sspo = peSspo;
         chain(n) %kds( k1yec1 ) pahec1;
       else;
         setgt %kds( k1yec1 : 4 ) pahec1;
         readpe(n) %kds( k1yec1 : 4 ) pahec1;
       endif;

       if not %found ( pahec1 );
         return -1;
       else;
         return c1asen;
       endif;

      /end-free

     P SPVSPO_getAsen...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_chkVig() Chequea vigencia de Poliza                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peFech   (input)   Fecha busqueda                        *
      *     peFech   (input)   Fecha emision                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkVig...
     P                 B                   export
     D SPVSPO_chkVig...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFech                       8  0 options(*nopass:*omit)
     D   peFemi                       8  0 options(*nopass:*omit)

     D   fvig          s              8  0
     D   femi          s              8  0
     D   estado        s               n   inz('0')
     D   sspo          s              3  0
     D   suop          s              3  0
     D   fpgm          s              3

     D k1yed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();

       if %parms >= 5 and %addr(peFech) <> *Null;
         fvig = peFech;
       else;
         fvig = SPVFEC_FecDeHoy8 ('AMD');
       endif;

       if %parms >= 6 and %addr(peFemi) <> *Null;
         femi  = peFemi;
       else;
         femi  = 99999999;
       endif;

       in Local;
       Local.empr = peEmpr;
       Local.sucu = peSucu;
       if peEmpr = *blank;
          Local.empr = 'A';
       endif;
       if peSucu = *blank;
          Local.sucu = 'CA';
       endif;
       out Local;

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       setll %kds(k1yed0:4) pahed0;
       reade %kds(k1yed0:4) pahed0;

       spvig2  ( d0arcd
               : d0spol
               : d0rama
               : d0arse
               : d0oper
               : fvig
               : femi
               : estado
               : sspo
               : suop
               : fpgm);

       if not estado;
         SetError( SPVSPO_SPONV
                 : 'SuperPoliza No Vigente' );
       endif;

       return estado;

      /end-free

     P SPVSPO_chkVig...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getFecEmi() Devuelve Fecha de Emisión                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: Fecha de Emisión / -1                               *
      * ------------------------------------------------------------ *

     P SPVSPO_getFecEmi...
     P                 B                   export
     D SPVSPO_getFecEmi...
     D                 pi             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yec0          ds                  likerec(p1hec0:*key)

      /free

       SPVSPO_inz();

       k1yec0.c0empr = peEmpr;
       k1yec0.c0sucu = peSucu;
       k1yec0.c0arcd = peArcd;
       k1yec0.c0spol = peSpol;
       chain(n) %kds(k1yec0) pahec0;

       if %found;
          return (c0fema * 10000) + (c0femm * 100) + c0femd;
       endif;

       return -1;

     P SPVSPO_getFecEmi...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_ChkWeb() Devuelve si viaja a Web                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Número de SuperPóliza                 *
      *     peErro   (output)  Vector de erorres                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SPVSPO_ChkWeb...
     P                 B                   export
     D SPVSPO_ChkWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                      80    dim(99)

     D k1yd11          ds                  likerec(p1hscd11:*key)

     D enviaWeb        s               n

     D @@fdes          s              8  0
     D @@fhas          s              8  0

     D @@sald          s             15  2
     D @@pend          s             15  2
     D @@ano           s              4  0
     D @@mes           s              2  0
     D @@dia           s              2  0
     D @@fpgm          s              3
     D @@impr          s              2

     D @@arcd          s              6  0
     D @@spol          s              9  0

     D stroPen         s               n
     D stroPag         s               n

     D @@rweb          ds                  likeds(setweb_t)

      /free

       SPVSPO_inz();


       clear peErro;

       @@arcd = peArcd;
       @@spol = peSpol;
       enviaWeb = *Off;

       @@fhas = SPVFEC_fecDeHoy8 ('AMD');

       // Articulo debe existir
       setll peArcd set630;
       if not %equal;
         SetError( SPVSPO_ARCDI
                 : 'Articulo Inexistente' );
         return *Off;
       endif;

       // SuperPóliza debe existir
       if not SPVSPO_chkSpol ( peEmpr : peSucu : peArcd : peSpol);
         SetError( SPVSPO_SPINE
                 : 'SuperPoliza Inexistente' );
         return *Off;
       endif;

       // Traer Parametría
       if not SPVSPO_getParWeb ( peEmpr : peSucu : peArcd : @@rweb );
         SetError( SPVSPO_SINPA
                 : 'Sin Parametros Para Enviar a la Web' );
         return *Off;
       endif;

       // Valida vigencia
       if SPVSPO_chkVig  ( peEmpr : peSucu : peArcd : peSpol );
         peErro( 1 ) = '-1';
         enviaWeb = *On;
       else;
         peErro( 1 ) = 'SuperPóliza Fuera de Vigencia';
       endif;

       // Valido Saldo
       @@pend = 0;
       @@sald = 0;
       @@ano  = 2050;
       @@mes  = 12;
       @@dia  = 31;
       @@fpgm = ' ';
       @@impr = ' ';

       setll peArcd set621;
       reade peArcd set621;

       dow not %eof( set621 );

         spsald  ( @@arcd
                 : @@spol
                 : t@rama
                 : @@ano
                 : @@mes
                 : @@dia
                 : @@sald
                 : @@impr
                 : @@fpgm);

         @@pend += @@sald;

         reade pearcd set621;

       enddo;

       if @@pend > @@rweb.t@sald;
         peErro(2) = '-1';
         enviaWeb = *On;
       else;
         peErro(2) = 'La poliza no tiene Saldo Pendiente';
       endif;

       // Valido Fecha de Emisión
       @@fdes = SPVFEC_SumResFecha8 ( @@fhas : '-' : @@rweb.t@uemi :
                                      @@rweb.t@cemi );
       if @@fdes < spvspo_getFecEmi ( peEmpr : peSucu : peArcd : peSpol );
         peErro(3) = '-1';
         enviaWeb = *On;
       else;
         peErro(3) = 'SuperPóliza Fuera de Vigencia';
       endif;

       // Consulta siniestros tiene denuncias
       @@fdes = SPVFEC_SumResFecha8 ( @@fhas : '-' : @@rweb.t@udes :
                                      @@rweb.t@cdes);

       if SVPSIN_chkSiniDen ( peEmpr : peSucu : peArcd : peSpol :
                              @@fdes : @@fhas);
         enviaWeb = *On;
       else;
          peErro(4) = 'No Contiene Denuncias';
       endif;

       // Recorre Siniestros
       stroPen = *Off;
       stroPag = *Off;
       @@fdes = spvfec_SumResFecha8 ( @@fhas : '-' : @@rweb.t@upas :
                                      @@rweb.t@cpas);
       k1yd11.cdempr = peempr;
       k1yd11.cdsucu = pesucu;
       k1yd11.cdarcd = pearcd;
       k1yd11.cdspol = pespol;

       setll %kds( k1yd11 : 4 ) p1hscd11;
       reade %kds( k1yd11 : 4 ) p1hscd11;

       dow not %eof ( pahscd11 );

         // Consulta siniestros pendientes
         if SVPSIN_chkSiniPend ( peEmpr : peSucu : cdrama : cdsini : cdnops );
           stroPen = *On;
         endif;

         // Consulta siniestros tiene pagos
         if SVPSIN_chkSiniPag ( peEmpr : peSucu : cdrama : cdsini :
                                cdnops : @@fdes : @@fhas);
           stroPag = *on;
         endif;

         reade %kds( k1yd11 : 4 ) p1hscd11;

       enddo;

       if stroPen;
         peErro(5)= '-1';
         enviaWeb  = *on;
       else;
         peErro(5) = 'SuperPóliza no Contiene Siniestros Pendientes';
       endif;

       if stroPag;
         peErro(6)= '-1';
         enviaWeb  = *on;
       else;
         peErro(6) = 'SuperPóliza no Contiene pagos de Siniestros';
       endif;

       // envía a web?
       if not enviaWeb;
         SetError( SPVSPO_NOWEB
                 : 'SuperPoliza no Viaja a la Web' );
       endif;

       return enviaWeb;

     P SPVSPO_ChkWeb...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getParWeb Retorna Parametría Web                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peRweb   (output)  Registro de SetWeb                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_getParWeb...
     P                 B                   export
     D SPVSPO_getParWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRweb                            likeds(setweb_t)
     D                                     options(*nopass:*omit)

     D k1yweb          ds                  likerec(s1tweb:*key)
     D inWeb           ds                  likerec(s1tweb:*input)

      /free

       SPVSPO_inz();

       k1yweb.t@empr = peEmpr;
       k1yweb.t@sucu = peSucu;
       k1yweb.t@arcd = peArcd;
           setgt %kds(k1yweb : 3 ) setweb;
           readpe %kds(k1yweb : 3 ) setweb inWeb;
           if not %eof;
           if %parms >= 4 and %addr( peRweb ) <> *Null;
             eval-corr peRweb = inweb;
           endif;
              return *on;
           endif;
              return *off;

     P SPVSPO_getParWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getFecVig(): Obtiene Fechas de Vigencia Desde/Hasta   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peFecd   (output)  Fecha Desde                           *
      *     peFech   (output)  Fecha Hasta                           *
      *                                                              *
      * Retorna: Vig. Desde/Hasta (AAAAMMDD)                         *
      * ------------------------------------------------------------ *

     P SPVSPO_getFecVig...
     P                 B                   export
     D SPVSPO_getFecVig...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFecd                       8  0 options(*Omit:*Nopass)
     D   peFech                       8  0 options(*Omit:*Nopass)

     D k1yed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;

       setll %kds( k1yed0 : 4 ) pahed0;
       reade %kds( k1yed0 : 4 ) pahed0;

       if %eof ( pahed0 );

         if %parms >= 5 and %addr ( peFecd ) <> *Null;
           peFecd = *Zeros;
         endif;

         if %parms >= 6 and %addr ( peFech ) <> *Null;
           peFech = *Zeros;
         endif;

         return *Off;

       endif;

       if %parms >= 5 and %addr ( peFecd ) <> *Null;
         peFecd = d0fioa*10000 + d0fiom*100 + d0fiod;
       endif;

       if %parms >= 6 and %addr ( peFech ) <> *Null;
         peFech = d0fvoa*10000 + d0fvom*100 + d0fvod;
       endif;

       return *On;

      /end-free

     P SPVSPO_getFecVig...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getProducto(): Retorna Codigo de Producto             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: Codigo de Producto                                  *
      * ------------------------------------------------------------ *
     P SPVSPO_getProducto...
     P                 B                   export
     D SPVSPO_getProducto...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

     D k1yer0          ds                  likerec(p1her0:*key)

      /free

       SPVSPO_inz();

       k1yer0.r0empr = peEmpr;
       k1yer0.r0sucu = peSucu;
       k1yer0.r0arcd = peArcd;
       k1yer0.r0spol = peSpol;
       k1yer0.r0sspo = peSspo;
       k1yer0.r0rama = peRama;
       k1yer0.r0arse = peArse;
       k1yer0.r0oper = peOper;
       k1yer0.r0poco = pePoco;
       k1yer0.r0suop = peSuop;

       chain %kds( k1yer0 ) paher0;

       return r0xpro;

      /end-free

     P SPVSPO_getProducto...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getDiasFacturacionEndoso(): Dias Vigencia             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Numero de SuperPoliza                 *
      *     peFecd   (output)  Fecha Desde                           *
      *     peFech   (output)  Fecha Hasta                           *
      *                                                              *
      * Retorna: Cantidad de Dias                                    *
      * ------------------------------------------------------------ *
     P SPVSPO_getDiasFacturacionEndoso...
     P                 B                   export
     D SPVSPO_getDiasFacturacionEndoso...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peFecd                       8  0 options(*Omit:*Nopass)
     D   peFech                       8  0 options(*Omit:*Nopass)

     D k1yed0          ds                  likerec(p1hed0:*key)

     D @@fdes          s              8  0
     D @@fhas          s              8  0

       SPVSPO_inz();

       @@fdes = *Zeros;
       @@fhas = *Zeros;

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       k1yed0.d0sspo = peSspo;

       setll %kds( k1yed0 : 5 ) pahed0;
       reade %kds( k1yed0 : 5 ) pahed0;

       if %eof ( pahed0 );

         if %parms >= 6 and %addr ( peFecd ) <> *Null;
           peFecd = *Zeros;
         endif;

         if %parms >= 7 and %addr ( peFech ) <> *Null;
           peFech = *Zeros;
         endif;

         return *Zeros;

       endif;

       @@fdes = d0fioa*10000 + d0fiom*100 + d0fiod;
       @@fhas = d0fvoa*10000 + d0fvom*100 + d0fvod;

       if %parms >= 6 and %addr ( peFecd ) <> *Null;
         peFecd = @@fdes;
       endif;

       if %parms >= 7 and %addr ( peFech ) <> *Null;
         peFech = @@fhas;
       endif;

       return SPVFEC_DiasEntreFecha8 ( @@fdes : @@fhas );

     P SPVSPO_getDiasFacturacionEndoso...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getRama(): Retorna Rama                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna : Codigo de Rama  / -1                               *
      * ------------------------------------------------------------ *
     P SPVSPO_getRama...
     P                 B                   export
     D SPVSPO_getRama...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSSpo                       3  0 options(*nopass:*omit)

     D k1yed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       if %parms >= 5 and %addr( peSspo ) <> *Null;
         k1yed0.d0sspo = peSspo;
         chain %kds( k1yed0 : 5 ) pahed0;
         if not %found( pahed0 );
           return -1;
         endif;
       else;
         setll %kds( k1yed0 : 4 ) pahed0;
         reade %kds( k1yed0 : 4 ) pahed0;
         if %eof( pahed0 );
           return -1;
         endif;
       endif;

        return d0rama;

      /end-free

     P SPVSPO_getRama...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getPoliza(): Retorna Poliza                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna : Nro de Poliza / -1                                 *
      * ------------------------------------------------------------ *
     P SPVSPO_getPoliza...
     P                 B                   export
     D SPVSPO_getPoliza...
     D                 pi             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSSpo                       3  0 options(*nopass:*omit)

     D k1yed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       if %parms >= 5 and %addr( peSspo ) <> *Null;
         k1yed0.d0sspo = peSspo;
         chain %kds( k1yed0 : 5 ) pahed0;
         if not %found( pahed0 );
            return -1;
         endif;
       else;
         setll %kds( k1yed0 : 4 ) pahed0;
         reade %kds( k1yed0 : 4 ) pahed0;
         if %eof( pahed0 );
            return -1;
         endif;
       endif;

        return d0poli;

      /end-free

     P SPVSPO_getPoliza...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getProductor(): Retorna datos del Productor Nivt/Nivc *
      *                        Nombre.                               *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peNivt   (output)  Tipo Nivel Intermedio                 *
      *     peNivc   (output)  Cod. Nivel Intermedio                 *
      *                                                              *
      * Retorna: Nombre del Productor / -1                           *
      * ------------------------------------------------------------ *

     P SPVSPO_getProductor...
     P                 B                   export
     D SPVSPO_getProductor...
     D                 pi            40
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peNivt                       1  0 options( *nopass : *omit )
     D   peNivc                       5  0 options( *nopass : *omit )

     D k1yec1          ds                  likerec( p1hec1  : *key )
     D k1yseh          ds                  likerec( s1hni2  : *key )

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *Null;
         k1yec1.c1sspo = peSspo;
         chain(n) %kds( k1yec1 : 5 ) pahec1;
         if not %found ( pahec1 );
           return '-1';
         endif;
       else;
         setgt  %kds( k1yec1 : 4 ) pahec1;
         readpe(n) %kds( k1yec1 : 4 ) pahec1;
         if %eof ( pahec1 );
           return '-1';
         endif;
       endif;

       k1yseh.n2empr = peEmpr;
       k1yseh.n2sucu = peSucu;
       k1yseh.n2nivt = c1nivt;
       k1yseh.n2nivc = c1nivc;
       chain %kds( k1yseh : 4 ) sehni2;
         if not %found ( sehni2 );
            return '-1';
         endif;

       if %parms >= 6 and %addr( peNivt ) <> *Null;
         peNivt = c1nivt;
       endif;

       if %parms >= 7 and %addr( peNivc ) <> *Null;
         peNivc = c1nivc;
       endif;

       return  SVPDAF_getNombre( n2nrdf );

      /end-free

     P SPVSPO_getProductor...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getMone(): Retorna moneda                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Moneda / -1                                         *
      * ------------------------------------------------------------ *

     P SPVSPO_getMone...
     P                 B                   export
     D SPVSPO_getMone...
     D                 pi             2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )

     D k1yec1          ds                  likerec( p1hec1  : *key )

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *Null;

         k1yec1.c1sspo = peSspo;
         chain(n) %kds( k1yec1 : 5 ) pahec1;
         if not %found ( pahec1 );
           return '-1';
         endif;

       else;

         setgt  %kds( k1yec1 : 4 ) pahec1;
         readpe(n) %kds( k1yec1 : 4 ) pahec1;
         if %eof ( pahec1 );
           return '-1';
         endif;

       endif;

       return c1mone;

     P SPVSPO_getMone...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getSumaAsegurada(): Retorna Suma Asegurada            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Suma  / -1                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_getSumaAsegurada...
     P                 B                   export
     D SPVSPO_getSumaAsegurada...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )

     D k1yed0          ds                  likerec( p1hed0  : *key )

      /free

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *Null;

         k1yed0.d0sspo = peSspo;
         chain %kds( k1yed0 : 5 ) pahed0;
         if not %found ( pahed0 );
           return -1;
         endif;

       else;

         setll  %kds( k1yed0 : 4 ) pahed0;
         reade  %kds( k1yed0 : 4 ) pahed0;
         if %eof ( pahed0 );
           return -1;
         endif;

         return d0suas;

       endif;

     P SPVSPO_getSumaAsegurada...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getSumaAseguradaEnPesos(): Retorna Suma Asegurada en  *
      *                                   PESOS al tipo de cambio de *
      *                                   EMISION.                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Suma / -1                                           *
      * ------------------------------------------------------------ *

     P SPVSPO_getSumaAseguradaEnPesos...
     P                 B                   export
     D SPVSPO_getSumaAseguradaEnPesos...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )

     D k1yed0          ds                  likerec( p1hed0  : *key )

      /free

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *Null;

         k1yed0.d0sspo = peSspo;
         chain %kds( k1yed0 : 5 ) pahed0;
         if not %found ( pahed0 );
           return -1;
         endif;

       else;

         setll  %kds( k1yed0 : 4 ) pahed0;
         reade  %kds( k1yed0 : 4 ) pahed0;
         if %eof ( pahed0 );
           return -1;
         endif;

         if (d0come <= 0);
            d0come = 1;
         endif;

         d0suas *= d0come;

         return d0suas;

       endif;

     P SPVSPO_getSumaAseguradaEnPesos...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getPolizaAnterior(): Retorna Poliza Anterior          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: Poliza Anterior / -1                                *
      * ------------------------------------------------------------ *

     P SPVSPO_getPolizaAnterior...
     P                 B                   export
     D SPVSPO_getPolizaAnterior...
     D                 pi             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yec0          ds                  likerec( p1hec0   : *key )
     D k1yec0c         ds                  likerec( p1hec0c  : *key )
     D k1yed0          ds                  likerec( p1hed0   : *key )

      /free

       SPVSPO_inz();

       k1yec0.c0empr = peEmpr;
       k1yec0.c0sucu = peSucu;
       k1yec0.c0arcd = peArcd;
       k1yec0.c0spol = peSpol;
       chain %kds( k1yec0 : 4 ) pahec0;
       if %found( pahec0 );
         if c0spoa = *all'9';
           k1yec0c.ccempr = c0Empr;
           k1yec0c.ccsucu = c0Sucu;
           k1yec0c.ccarcd = c0Arcd;
           k1yec0c.ccspol = c0Spol;
           chain %kds ( k1yec0c : 4 ) pahec0c;
             if %found( pahec0c );

               return SPVSPO_getPoliza( ccempr
                                      : ccsucu
                                      : ccarca
                                      : ccspoa );
             else;
               return -1;
             endif;

         else;
           return SPVSPO_getPoliza( c0empr
                                   : c0sucu
                                   : c0arcd
                                   : c0spoa );
         endif;
       else;
         return -1;
       endif;

       /end-free

     P SPVSPO_getPolizaAnterior...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getPrima(): Obtiene Prima                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Obtiene Prima / 999999999999999,99 en caso de error *
      * ------------------------------------------------------------ *

     P SPVSPO_getPrima...
     P                 B                   export
     D SPVSPO_getPrima...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       k1yec1.c1sspo = peSspo;

       if %parms >= 5 and %addr( peSspo ) <> *Null;
         k1yec1.c1sspo = peSspo;
         chain(n) %kds( k1yec1 : 5) pahec1;
         if not %found ( pahec1 );
           SetError( SPVSPO_NEPRI
                   : 'No se Encontro la Prima' );
           return 999999999999999,99;
         endif;
       else;
         setgt  %kds( k1yec1 : 4 ) pahec1;
         readpe(n) %kds( k1yec1 : 4 ) pahec1;
         if %eof ( pahec1 );
           SetError( SPVSPO_NEPRI
                   : 'No se Encontro la Prima' );
           return 999999999999999,99;
         endif;
       endif;

         return c1prim;

      /end-free

     P SPVSPO_getPrima...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkSpolRenovada(): Verifica si la Spol fue Renovada   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: Poliza Renovada                                     *
      * ------------------------------------------------------------ *
     P SPVSPO_chkSpolRenovada...
     P                 B                   export
     D SPVSPO_chkSpolRenovada...
     D                 pi             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yec0          ds                  likerec(p1hec0:*key)

       SPVSPO_inz();

       k1yec0.c0empr = peEmpr;
       k1yec0.c0sucu = peSucu;
       k1yec0.c0arcd = peArcd;
       k1yec0.c0spol = peSpol;
       chain %kds( k1yec0 ) pahec0;

       if not %found ( pahec0 );
         return -1;
       else;
         return c0spon;
       endif;

     P SPVSPO_chkSpolRenovada...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkSpolSuspendida(): Verifica si la Spol Suspendida   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVSPO_chkSpolSuspendida...
     P                 B                   export
     D SPVSPO_chkSpolSuspendida...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1ypc0          ds                  likerec(p1wpc0:*key)

       SPVSPO_inz();

       k1ypc0.w0empr = peEmpr;
       k1ypc0.w0sucu = peSucu;
       k1ypc0.w0arcd = peArcd;
       k1ypc0.w0spo1 = peSpol;
       setll %kds( k1ypc0 : 4 ) pawpc0;

       return %equal;

     P SPVSPO_chkSpolSuspendida...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getFormaDePago(): Retorn la Forma de Pago de          *
      *                          Suplemento                          *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Forma de Pago / -1 Error                            *
      * ------------------------------------------------------------ *

     P SPVSPO_getFormaDePago...
     P                 B                   export
     D SPVSPO_getFormaDePago...
     D                 pi             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )

     D k1yec1          ds                  likerec(p1hec1:*key)

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *Null;
         k1yec1.c1sspo = peSspo;
         chain(n) %kds( k1yec1 : 5 ) pahec1;
         if not %found ( pahec1 );
           return -1;
         endif;
       else;
         setgt  %kds( k1yec1 : 4 ) pahec1;
         readpe(n) %kds( k1yec1 : 4 ) pahec1;
         if %eof ( pahec1 );
           return -1;
         endif;
       endif;

         return c1cfpg;

      /end-free

     P SPVSPO_getFormaDePago...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getRecAdministrativo(): Retorna Recargo administrativ *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cantidad de Polizas                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_getRecAdministrativo...
     P                 B                   export
     D SPVSPO_getRecAdministrativo...
     D                 pi             5  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D k1yed0          ds                  likerec(p1hed001:*key)

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       k1yed0.d0rama = peRama;
       k1yed0.d0Arse = peArse;
       setgt  %kds( k1yed0 : 6) pahed001;
       readpe %kds( k1yed0 : 6 ) pahed001;
       if %eof( pahed001  );
         return *zeros;
       endif;
       return d0xrea;

     P SPVSPO_getRecAdministrativo...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getHastaFacturado(): Obtiene el hasta facturado       *
      *                             (AAAAMMDD) desde PAHED0          *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: Hasta Facturado (AAAAMMDD)                          *
      * ------------------------------------------------------------ *

     P SPVSPO_getHastaFacturado...
     P                 B                   export
     D SPVSPO_getHastaFacturado...
     D                 pi             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       chain %kds(k1yed0:4) pahed0;

       return d0fhfa*10000 + d0fhfm*100 + d0fhfd;

      /end-free

     P SPVSPO_getHastaFacturado...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getCodigoIva(): Retorna Codigo de IVA                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: Codigo de IVA                                       *
      * ------------------------------------------------------------ *
     P SPVSPO_getCodigoIva...
     P                 B                   export
     D SPVSPO_getCodigoIva...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yec1          ds                  likerec(p1hec1:*key)

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;

       setgt %kds(k1yec1:4) pahec1;
       readpe(n) %kds(k1yec1:4) pahec1;

       return c1civa;

     P SPVSPO_getCodigoIva...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getTipoOperacion(): Retorna Tipo de Operacion         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peTiou   (output)  Tipo de Operacion                     *
      *     peStou   (output)  Sub Tipo de Operacion                 *
      *     peStos   (output)  Sub Tipo de Sistema                   *
      *                                                              *
      * Retorna: Tipo de Operacion                                   *
      * ------------------------------------------------------------ *

     P SPVSPO_getTipoOperacion...
     P                 B                   export
     D SPVSPO_getTipoOperacion...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)
     D   peTiou                       1  0 options(*nopass:*omit)
     D   peStou                       2  0 options(*nopass:*omit)
     D   peStos                       2  0 options(*nopass:*omit)

     D k1yed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();


       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       if %parms >= 5 and %addr(pesspo) <> *NULL;
         k1yed0.d0sspo = peSspo;
         chain(n) %kds(k1yed0:5) pahed0;
       else;
         chain(n) %kds(k1yed0:4) pahed0;
       endif;

       if %parms >= 6 and %addr(peTiou) <> *NULL;
         peTiou = d0tiou;
       endif;

       if %parms >= 7 and %addr(peStou) <> *NULL;
         peStou = d0stou;
       endif;

       if %parms >= 8 and %addr(peStos) <> *NULL;
         peStos = d0stos;
       endif;
       return *on;

      /end-free

     P SPVSPO_getTipoOperacion...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getPlanDePago: Retorna Plan de Pago x Suplemento      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDec3   (input)   Registro del archivo PAHEC3           *
      *                                                              *
      * Retorna: *off / *on                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_getPlanDePago...
     P                 B                   export
     D SPVSPO_getPlandePago...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peDec3                            likeds( dsPahec3_t )
     D                                     options( *nopass : *omit )

     D dsec3           ds                  likerec( p1hec3 : *input )
     D k1yec3          ds                  likerec( p1hec3 : *key )

      /free

       SPVSPO_inz();

       k1yec3.c3empr = peEmpr;
       k1yec3.c3sucu = peSucu;
       k1yec3.c3arcd = peArcd;
       k1yec3.c3spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *Null;
         k1yec3.c3sspo = peSspo;
         chain(n) %kds( k1yec3 : 5 ) pahec3 dsec3;
         if not %found ( pahec3 );
           return *off;
         endif;
       else;
         setgt  %kds( k1yec3 : 4 ) pahec3;
         readpe(n) %kds( k1yec3 : 4 ) pahec3 dsec3;
         if %eof ( pahec3 );
           return *off;
         endif;
       endif;

       if %parms >= 6 and %addr( peDec3 ) <> *null;
         eval-corr peDec3 = dsec3;
       endif;

       return *on;

      /end-free

     P SPVSPO_getPlanDePago...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getCodPlandePago: Retorna Plan de Pago x Suplemento   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDec3   (input)   Registro del archivo PAHEC3           *
      *                                                              *
      * Retorna: NRPP / *Zeros                                       *
      * ------------------------------------------------------------ *

     P SPVSPO_getCodPlanDePago...
     P                 B                   export
     D SPVSPO_getCodPlandePago...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )

     D @@dsec3         ds                  likeds( dsPahec3_t ) inz

      /free

       SPVSPO_inz();

       if %parms >= 5 and %addr( peSspo ) <> *Null;
         if not SPVSPO_getPlanDePago ( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : peSspo
                                     : @@dsec3 );
           return *zeros;
         endif;
       else;
         if not SPVSPO_getPlanDePago ( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : *omit
                                     : @@dsec3 );
           return *zeros;
         endif;
       endif;

       return @@dsec3.c3nrpp;

      /end-free

     P SPVSPO_getCodPlanDePago...
     P                 E
      * ------------------------------------------------------------ *
      * SPVSPO_getPólizaAbierta: Retorna Si es Póliza Abierta o No   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: *on / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_getPolizaAbierta...
     P                 B                   export
     D SPVSPO_getPolizaAbierta...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D @@fecd          s              8  0
     D @@fech          s              8  0

     D k1yed9          ds                  likerec(p1hed9:*key)

      /free

       SPVSPO_inz();

         Return *off;
         SPVSPO_getFecvig( peempr
                         : peSucu
                         : peArcd
                         : peSpol
                         : @@fecd
                         : @@fech);
        if @@fech = 99999999;
           Return *on;
        endif;

      /end-free

     P SPVSPO_getPolizaAbierta...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getCuotasEmitidas(): Cuotas emitidas por endoso       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento             ( opcional )   *
      *     peRama   (input)   Rama                   ( opcional )   *
      *     peArse   (input)   Cantidad de Polizas    ( opcional )   *
      *     peOper   (input)   Operacion              ( opcional )   *
      *     peSuop   (input)   Suplemento             ( opcional )   *
      *     peDsC2   (output)  Estructura de Cobranza ( opcional )   *
      *     peDsC2C  (output)  Cantidad de Cobranza   ( opcional )   *
      *                                                              *
      * Retorna: *On = Encontró / *Off = No Encontró                 *
      * ------------------------------------------------------------ *
     PSPVSPO_getCuotasEmitidas...
     P                 b                   export
     DSPVSPO_getCuotasEmitidas...
     D                 pi              n
     D peEmpr                         1    Const
     D peSucu                         2    Const
     D peArcd                         6  0 Const
     D peSpol                         9  0 Const
     D peSspo                         3  0 Options( *Nopass : *Omit ) Const
     D peRama                         2  0 Options( *Nopass : *Omit ) Const
     D PeArse                         2  0 Options( *Nopass : *Omit ) Const
     D peOper                         7  0 Options( *Nopass : *Omit ) Const
     D peSuop                         3  0 Options( *Nopass : *Omit ) Const
     D peDsCd5                             Likeds( dsPahcd5_t )
     D                                     Options( *Nopass: *Omit ) Dim(99)
     D peDsCd5C                      10i 0 Options( *Nopass: *Omit )

     D k1ycd5          ds                  Likerec( p1hcd5 : *Key   )
     D @@DsCd5i        ds                  Likerec( p1hcd5 : *Input )
     D @@DsCd5         ds                  Likeds ( dsPahcd5_t )dim( 99 )
     D @@DsCd5C        s             10i 0

      /free

       SPVSPO_inz();

       if %addr( peDsCd5  ) <> *Null and
          %addr( peDsCd5C ) <> *Null;
         clear peDsCd5;
         clear peDsCd5C;
       endif;

       k1ycd5.d5empr = peEmpr;
       k1ycd5.d5sucu = peSucu;
       k1ycd5.d5arcd = peArcd;
       k1ycd5.d5spol = peSpol;

       select;
         when %addr( peSspo ) <> *Null and
              %addr( peRama ) <> *Null and
              %addr( peArse ) <> *Null and
              %addr( peOper ) <> *Null and
              %addr( peSuop ) <> *Null;

              k1ycd5.d5sspo = peSspo;
              k1ycd5.d5rama = peRama;
              k1ycd5.d5arse = peArse;
              k1ycd5.d5oper = peOper;
              k1ycd5.d5suop = peSuop;
              setll %kds( k1ycd5 : 9 ) pahcd5;
              if not %equal( pahcd5 );
                return *Off;
              endif;

              reade(n) %kds( k1ycd5 : 9 ) pahcd5 @@DsCd5i;
              dow not %eof( pahcd5 );
                @@DsCd5c += 1;
                eval-corr @@DsCd5( @@DsCd5c ) = @@DsCd5i;
                reade(n) %kds( k1ycd5 : 9 ) pahcd5 @@DsCd5i;
              enddo;

         when %addr( peSspo ) <> *Null and
              %addr( peRama ) <> *Null and
              %addr( peArse ) <> *Null and
              %addr( peOper ) <> *Null and
              %addr( peSuop ) = *Null;

              k1ycd5.d5sspo = peSspo;
              k1ycd5.d5rama = peRama;
              k1ycd5.d5arse = peArse;
              k1ycd5.d5oper = peOper;
              setll %kds( k1ycd5 : 8 ) pahcd5;
              if not %equal( pahcd5 );
                return *Off;
              endif;

              reade(n) %kds( k1ycd5 : 8 ) pahcd5 @@DsCd5i;
              dow not %eof( pahcd5 );
                @@DsCd5c += 1;
                eval-corr @@DsCd5( @@DsCd5c ) = @@DsCd5i;
                reade(n) %kds( k1ycd5 : 8 ) pahcd5 @@DsCd5i;
              enddo;

         when %addr( peSspo ) <> *Null and
              %addr( peRama ) <> *Null and
              %addr( peArse ) <> *Null and
              %addr( peOper ) = *Null and
              %addr( peSuop ) = *Null;

              k1ycd5.d5sspo = peSspo;
              k1ycd5.d5rama = peRama;
              k1ycd5.d5arse = peArse;
              setll %kds( k1ycd5 : 7 ) pahcd5;
              if not %equal( pahcd5 );
                return *Off;
              endif;

              reade(n) %kds( k1ycd5 : 7 ) pahcd5 @@DsCd5i;
              dow not %eof( pahcd5 );
                @@DsCd5c += 1;
                eval-corr @@DsCd5( @@DsCd5c ) = @@DsCd5i;
                reade(n) %kds( k1ycd5 : 7 ) pahcd5 @@DsCd5i;
              enddo;

         when %addr( peSspo ) <> *Null and
              %addr( peRama ) <> *Null and
              %addr( peArse ) = *Null and
              %addr( peOper ) = *Null and
              %addr( peSuop ) = *Null;

              k1ycd5.d5sspo = peSspo;
              k1ycd5.d5rama = peRama;
              setll %kds( k1ycd5 : 6 ) pahcd5;
              if not %equal( pahcd5 );
                return *Off;
              endif;

              reade(n) %kds( k1ycd5 : 6 ) pahcd5 @@DsCd5i;
              dow not %eof( pahcd5 );
                @@DsCd5c += 1;
                eval-corr @@DsCd5( @@DsCd5c ) = @@DsCd5i;
                reade(n) %kds( k1ycd5 : 6 ) pahcd5 @@DsCd5i;
              enddo;

         when %addr( peSspo ) <> *Null and
              %addr( peRama ) = *Null and
              %addr( peArse ) = *Null and
              %addr( peOper ) = *Null and
              %addr( peSuop ) = *Null;

              k1ycd5.d5sspo = peSspo;
              setll %kds( k1ycd5 : 5 ) pahcd5;
              if not %equal( pahcd5 );
                return *Off;
              endif;

              reade(n) %kds( k1ycd5 : 5 ) pahcd5 @@DsCd5i;
              dow not %eof( pahcd5 );
                @@DsCd5c += 1;
                eval-corr @@DsCd5( @@DsCd5c ) = @@DsCd5i;
                reade(n) %kds( k1ycd5 : 5 ) pahcd5 @@DsCd5i;
              enddo;

           other;
              setll %kds( k1ycd5 : 4 ) pahcd5;
              if not %equal( pahcd5 );
                return *Off;
              endif;

              reade(n) %kds( k1ycd5 : 4 ) pahcd5 @@DsCd5i;
              dow not %eof( pahcd5 );
                @@DsCd5c += 1;
                eval-corr @@DsCd5( @@DsCd5c ) = @@DsCd5i;
                reade(n) %kds( k1ycd5 : 4 ) pahcd5 @@DsCd5i;
              enddo;
         endsl;

       if %addr( peDsCd5  ) <> *Null and
          %addr( peDsCd5C ) <> *Null;
         eval-corr peDsCd5 = @@DsCd5;
         peDsCd5C = @@DsCd5C;
       endif;

       return *On;

     PSPVSPO_getCuotasEmitidas...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_getCantidadCuotasEmitidas(): Cantidad cuotas emitidas *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento             ( opcional )   *
      *     peRama   (input)   Rama                   ( opcional )   *
      *     peArse   (input)   Cantidad de Polizas    ( opcional )   *
      *     peOper   (input)   Operacion              ( opcional )   *
      *     peSuop   (input)   Suplemento             ( opcional )   *
      *                                                              *
      * Retorna: Cantidad cuotas emitidas                            *
      * ------------------------------------------------------------ *
     PSPVSPO_getCantidadCuotasEmitidas...
     P                 b                   export
     DSPVSPO_getCantidadCuotasEmitidas...
     D                 pi             2  0
     D peEmpr                         1    Const
     D peSucu                         2    Const
     D peArcd                         6  0 Const
     D peSpol                         9  0 Const
     D peSspo                         3  0 Options( *Nopass : *Omit ) Const
     D peRama                         2  0 Options( *Nopass : *Omit ) Const
     D PeArse                         2  0 Options( *Nopass : *Omit ) Const
     D peOper                         7  0 Options( *Nopass : *Omit ) Const
     D peSuop                         3  0 Options( *Nopass : *Omit ) Const

     D @@DsCd5         ds                  Likeds ( dsPahcd5_t )dim( 99 )
     D @@DsCd5C        s             10i 0

      /free

       SPVSPO_inz();

       select;
         when %addr( peSspo ) <> *Null and
              %addr( peRama ) <> *Null and
              %addr( peArse ) <> *Null and
              %addr( peOper ) <> *Null and
              %addr( peSuop ) <> *Null;

              SPVSPO_getCuotasEmitidas ( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : peArse
                                       : peOper
                                       : peSuop
                                       : @@DsCd5
                                       : @@DsCd5C );

         when %addr( peSspo ) <> *Null and
              %addr( peRama ) <> *Null and
              %addr( peArse ) <> *Null and
              %addr( peOper ) <> *Null and
              %addr( peSuop ) = *Null;

              SPVSPO_getCuotasEmitidas ( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : peArse
                                       : peOper
                                       : *Omit
                                       : @@DsCd5
                                       : @@DsCd5C );

         when %addr( peSspo ) <> *Null and
              %addr( peRama ) <> *Null and
              %addr( peArse ) <> *Null and
              %addr( peOper ) = *Null and
              %addr( peSuop ) = *Null;

              SPVSPO_getCuotasEmitidas ( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : peArse
                                       : *Omit
                                       : *Omit
                                       : @@DsCd5
                                       : @@DsCd5C );

         when %addr( peSspo ) <> *Null and
              %addr( peRama ) <> *Null and
              %addr( peArse ) = *Null and
              %addr( peOper ) = *Null and
              %addr( peSuop ) = *Null;

              SPVSPO_getCuotasEmitidas ( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : *Omit
                                       : *Omit
                                       : *Omit
                                       : @@DsCd5
                                       : @@DsCd5C );


         when %addr( peSspo ) <> *Null and
              %addr( peRama ) = *Null and
              %addr( peArse ) = *Null and
              %addr( peOper ) = *Null and
              %addr( peSuop ) = *Null;

              SPVSPO_getCuotasEmitidas ( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : *Omit
                                       : *Omit
                                       : *Omit
                                       : *Omit
                                       : @@DsCd5
                                       : @@DsCd5C );

           other;
              SPVSPO_getCuotasEmitidas ( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : *Omit
                                       : *Omit
                                       : *Omit
                                       : *Omit
                                       : *Omit
                                       : @@DsCd5
                                       : @@DsCd5C );
         endsl;

       return @@DsCd5C;

     PSPVSPO_getCantidadCuotasEmitidas...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_chkCuotaPaga(): Chequea si Cuota esta paga            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peNrcu   (input)   Cuota                                 *
      *     peNrsc   (input)   SubCuota                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_chkCuotaPaga...
     P                 B                   export
     D SPVSPO_chkCuotaPaga...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const

     D k1ycc2          ds                  likerec(p1hcc2:*key)

      /free

       SPVSPO_inz();

       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;
       k1ycc2.c2sspo = peSspo;
       k1ycc2.c2nrcu = peNrcu;
       k1ycc2.c2nrsc = peNrsc;
       chain %kds( k1ycc2 : 7 ) pahcc2;

       if %found ( pahcc2 );
         if ( c2sttc = '3' );
           return *On;
         endif;
       else;
         SetError( SPVSPO_CUOIN
                 : 'Cuota Inexistente' );
       endif;

       return *Off;

      /end-free

     P SPVSPO_chkCuotaPaga...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkCuotaPermiteRecibo(): Retorna si permite Recibo    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peNrcu   (input)   Cuota                                 *
      *     peNrsc   (input)   SubCuota                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVSPO_chkCuotaPermiteRecibo...
     P                 B                   export
     D SPVSPO_chkCuotaPermiteRecibo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const

     D k1ycc2          ds                  likerec(p1hcc2:*key)

     D esAnulada       s               n

      /free

       SPVSPO_inz();

       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;
       k1ycc2.c2sspo = peSspo;
       k1ycc2.c2nrcu = peNrcu;
       k1ycc2.c2nrsc = peNrsc;
       chain %kds( k1ycc2 : 7 ) pahcc2;

       if %found ( pahcc2 );
         esAnulada = SPVSPO_chkAnuladaV2 ( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol );
         if ( c2sttc <> '3' ) or ( c2imcu < *Zeros ) or esAnulada;
           return *Off;
         endif;
       else;
         SetError( SPVSPO_CUOIN
                 : 'Cuota Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SPVSPO_chkCuotaPermiteRecibo...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkAnuladaV2(): Chequea si la Poliza esta anulada     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peFech   (input)   Fecha                 (Opcional)      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SPVSPO_chkAnuladaV2...
     P                 B                   export
     D SPVSPO_chkAnuladaV2...
     D                 pi              n
     D peEmpr                         1    const
     D peSucu                         2    const
     D peArcd                         6  0 const
     D peSpol                         9  0 const
     D peFech                         8  0 Options( *Nopass: *Omit )

     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0

     D @@anul          s              1
     D endpgm          s              3

      /free

       SPVSPO_inz();

       if %parms >= 5 and %addr( peFech ) <> *Null;
         @@d = SPVFEC_ObtDiaFecha8 ( peFech );
         @@m = SPVFEC_ObtMesFecha8 ( peFech );
         @@a = SPVFEC_ObtAÑoFecha8 ( peFech );
       else;
         PAR310X3 ( peEmpr : @@a : @@m : @@d );
       endif;

       callp DXP021( peEmpr
                   : peSucu
                   : peArcd
                   : peSpol
                   : @@a
                   : @@m
                   : @@d
                   : @@anul
                   : endpgm );

       return ( @@anul = 'A' );

      /end-free

     P SPVSPO_chkAnuladaV2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_chkCuotasPendientes(): Chequea Cuotas Pendientes      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código de Articulo                    *
      *     peSpol   (input)   Número de SuperPoliza                 *
      *     peSspo   (input)   Suplemento de superpoliza             *
      *     peNrcu   (input)   Número de Cuotas                      *
      *     peNrsc   (input)   Número de SubCuotas                   *
      *                                                              *
      * Retorna: *On = Pendientes / *Off = No hay pendientes         *
      * ------------------------------------------------------------ *

     P SPVSPO_chkCuotasPendientes...
     P                 B                   export
     D SPVSPO_chkCuotasPendientes...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peNrcu                       2  0 options( *nopass : *omit )
     D   peNrsc                       2  0 options( *nopass : *omit )

     D k1ycc2          ds                  likerec(p1hcc2:*key)

      /free

       SPVSPO_inz();

       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;

       select;

         when %parms >= 5 and %addr( peSspo ) <> *Null
                          and %addr( peNrcu ) =  *Null
                          and %addr( peNrsc ) =  *Null;

           k1ycc2.c2Sspo = peSspo;
           setll    %kds(k1ycc2:5) pahcc2;
           reade(n) %kds(k1ycc2:5) pahcc2;

         when %parms >= 6 and %addr( peSspo ) <> *Null
                          and %addr( peNrcu ) <> *Null
                          and %addr( peNrsc ) =  *Null;

           k1ycc2.c2Sspo = peSspo;
           k1ycc2.c2Nrcu = peNrcu;
           setll    %kds(k1ycc2:6) pahcc2;
           reade(n) %kds(k1ycc2:6) pahcc2;

         when %parms >= 7 and %addr( peSspo ) <> *Null
                          and %addr( peNrcu ) <> *Null
                          and %addr( peNrsc ) <> *Null;

           k1ycc2.c2Sspo = peSspo;
           k1ycc2.c2Nrcu = peNrcu;
           k1ycc2.c2Nrsc = peNrsc;
           setll    %kds(k1ycc2:7) pahcc2;
           reade(n) %kds(k1ycc2:7) pahcc2;

         other;

         setll    %kds(k1ycc2:4) pahcc2;
         reade(n) %kds(k1ycc2:4) pahcc2;

       endsl;

       dow not %eof( pahcc2 );
         if c2sttc <> '3';
           return *On;
         endif;

         select;

           when %parms >= 5 and %addr( peSspo ) <> *Null
                            and %addr( peNrcu ) =  *Null
                            and %addr( peNrsc ) =  *Null;

             reade(n) %kds(k1ycc2:5) pahcc2;

           when %parms >= 6 and %addr( peSspo ) <> *Null
                            and %addr( peNrcu ) <> *Null
                            and %addr( peNrsc ) =  *Null;

             reade(n) %kds(k1ycc2:6) pahcc2;

           when %parms >= 7 and %addr( peSspo ) <> *Null
                            and %addr( peNrcu ) <> *Null
                            and %addr( peNrsc ) <> *Null;

             reade(n) %kds(k1ycc2:7) pahcc2;

           other;

             reade(n) %kds(k1ycc2:4) pahcc2;

         endsl;

       enddo;

       return *Off;

      /end-free

     P SPVSPO_chkCuotasPendientes...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getCuotasImpagas(): Obtiene Cantidad de cuotas Impagas*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Cantidad de Cuotas Impagas                          *
      * ------------------------------------------------------------ *
     P SPVSPO_getCuotasImpagas...
     P                 B                   export
     D SPVSPO_getCuotasImpagas...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 Options(*Nopass:*Omit) Const

     D@@cont           s              3  0
     D@@sspo           s              3  0
     DhaySup           s               n

     D k1ycc2          ds                  likerec(p1hcc2:*key)

       SPVSPO_inz();

       @@cont = 0;
       haySup = *Off;

       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;
       if %parms >= 5 and %addr( peSspo ) <> *Null;
         haySup = *On;
         k1ycc2.c2sspo = peSspo;
         setll %kds(k1ycc2:5) pahcc2;
         reade %kds(k1ycc2:5) pahcc2;
       else;
         setll %kds(k1ycc2:4) pahcc2;
         reade %kds(k1ycc2:4) pahcc2;
       endif;

       dow not %eof;
         if ( c2sttc <> '3' );
           @@cont = @@cont + 1;
         endif;
         if haySup;
           reade %kds(k1ycc2:5) pahcc2;
         else;
           reade %kds(k1ycc2:4) pahcc2;
         endif;
       enddo;

       return @@cont;

     P SPVSPO_getCuotasImpagas...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getCuotasImpagasMes(): Retorna cuotas impagas.        *
      * Solo cuenta una cuopta por mes.                              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peFech   (input)   Fecha busqueda                        *
      *                                                              *
      * Retorna: Cantidad de Cuotas                                  *
      * ------------------------------------------------------------ *
     PSPVSPO_getCuotasImpagasMes...
     P                 B                   export
     DSPVSPO_getCuotasImpagasMes...
     D                 pi             5  0
     D   peEmpr                       1    Const
     D   peSucu                       2    Const
     D   peArcd                       6  0 Const
     D   peSpol                       9  0 Const
     D   peFech                       8  0 Options( *Nopass : *Omit )

     D fecHas          s              8  0
     D canCuo          s              5  0
     D FecCuo          s              8  0
     D FecCu6          s              6  0
     D FecPag          s              8  0
     D salCuo          s             15  2
     D*antSup          s              3  0
     D indMat          s              3  0
     D ultFec          s              6  0 dim(999)

     D k1ycd5          ds                  likerec(p1hcd5:*key)
     D k1ycd6          ds                  likerec(p1hcd6:*key)

       SPVSPO_inz();

        canCuo = *Zeros;
        indMat = 1;

        if %parms >= 5 and %addr(peFech) <> *Null;
          fecHas = peFech;
        else;
          fecHas = SPVFEC_FecDeHoy8 ('AMD');
        endif;

        k1ycd5.d5empr = peEmpr;
        k1ycd5.d5sucu = peSucu;
        k1ycd5.d5arcd = peArcd;
        k1ycd5.d5spol = peSpol;
        setll %kds(k1ycd5:4) pahcd5;
        reade %kds(k1ycd5:4) pahcd5;
        dow not %eof;
          fecCuo=d5fvca*10000+d5fvcm*100+d5fvcd;
          fecCu6=d5fvca*100+d5fvcm;
          salCuo = d5imcu;
          if fecCuo <= fecHas;
            k1ycd6.d6empr = d5empr;
            k1ycd6.d6sucu = d5sucu;
            k1ycd6.d6arcd = d5arcd;
            k1ycd6.d6spol = d5spol;
            k1ycd6.d6sspo = d5sspo;
            k1ycd6.d6rama = d5rama;
            k1ycd6.d6arse = d5arse;
            k1ycd6.d6oper = d5oper;
            k1ycd6.d6suop = d5suop;
            k1ycd6.d6nrcu = d5nrcu;
            k1ycd6.d6nrsc = d5nrsc;
            setll %kds(k1ycd6:11) pahcd6;
            reade %kds(k1ycd6:11) pahcd6;
            dow not %eof;
              fecPag=d6fasa*10000+d6fasm*100+d6fasd;
              if fecPag <= fecHas;
                salCuo = salCuo - d6prem;
              endif;
              reade %kds(k1ycd6:11) pahcd6;
            enddo;
            if salCuo > *Zeros;
              if ultCuoSup(d5empr:d5sucu:d5arcd:d5spol:d5sspo:d5nrcu);
                if %lookup(fecCu6:ultFec) = *Zeros;
                  canCuo +=1;
                  ultFec(indMat) = fecCu6;
                  indMat +=1;
                endif;
              else;
                return 99999;
              endif;
            endif;
          endif;
          reade %kds(k1ycd5:4) pahcd5;
        enddo;

        return canCuo;

     P SPVSPO_getCuotasImpagasMes...
     P                 E

     P ultCuoSup       B
     D ultCuoSup       PI              n
     D   peEmpr                       1    Const
     D   peSucu                       2    Const
     D   peArcd                       6  0 Const
     D   peSpol                       9  0 Const
     D   peSspo                       3  0 Const
     D   peNrcu                       2  0 Const

     D k1ycd618        ds                  likerec(p1hcd618:*key)

        k1ycd618.llempr = peEmpr;
        k1ycd618.llsucu = peSucu;
        k1ycd618.llarcd = peArcd;
        k1ycd618.llspol = peSpol;
        k1ycd618.llsspo = peSspo;
        k1ycd618.llnrcu = peNrcu + 1;
        setll %kds(k1ycd618:6) pahcd618;
        reade %kds(k1ycd618:6) pahcd618;

        if %eof;
          return *On;
        else;
          return *Off;
        endif;

     P ultCuoSup       E

      * ------------------------------------------------------------ *
      * SPVSPO_chkSuspEsp(): Chequear si la Poliza se encuentra      *
      *                      como suspendida Especial.-              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: *on = Suspendida Especial / *off = no Suspendia Esp.*
      * ------------------------------------------------------------ *
     P SPVSPO_chkSuspEsp...
     P                 B                   export
     D SPVSPO_chkSuspEsp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D   @@estado      s              1
      /free

       SPVSPO_inz();

       if SPVSPO_chkSuspEsp( peEmpr
                           : peSucu
                           : peArcd
                           : peSpol ) = '3';
         return *on;
       endif;

       return *off;

      /end-free

     P SPVSPO_chkSuspEsp...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getCabeceraSuplemento: Retorna Cabecera de Suplemento *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento de SuperPoliza (opcional) *
     ?*     peDsC1   ( output ) Esrtuctura de Cabecera Sup(opcional) *
     ?*     peDsC1C  ( output ) Cantidad de Cabecera Sup  (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SPVSPO_getCabeceraSuplemento...
     P                 B                   export
     D SPVSPO_getCabeceraSuplemento...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )const
     D   peDsC1                            likeds ( dsPaheC1_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsC1C                     10i 0 options( *nopass : *omit )

     D   k1yec1        ds                  likerec( p1hec1 : *key   )
     D   @@DsIC1       ds                  likerec( p1hec1 : *input )
     D   @@DsC1        ds                  likeds ( dsPaheC1_t ) dim( 999 )
     D   @@DsC1C       s             10i 0

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null;
              k1yec1.c1sspo = peSspo;
              setll %kds( k1yec1 : 5 ) pahec1;
              if not %equal( pahec1 );
                return *off;
              endif;
              reade(n) %kds( k1yec1 : 5 ) pahec1 @@DsIC1;
              dow not %eof( pahec1 );
                @@DsC1C += 1;
                eval-corr @@DsC1( @@DsC1C ) = @@DsIC1;
               reade(n) %kds( k1yec1 : 5 ) pahec1 @@DsIC1;
              enddo;
           other;
             setll %kds( k1yec1 : 4 ) pahec1;
             if not %equal( pahec1 );
               return *off;
             endif;
             reade(n) %kds( k1yec1 : 4 ) pahec1 @@DsIC1;
             dow not %eof( pahec1 );
               @@DsC1C += 1;
               eval-corr @@DsC1( @@DsC1C ) = @@DsIC1;
              reade(n) %kds( k1yec1 : 4 ) pahec1 @@DsIC1;
             enddo;
          endsl;
       else;
         setll %kds( k1yec1 : 4 ) pahec1;
         if not %equal( pahec1 );
           return *off;
         endif;
         reade(n) %kds( k1yec1 : 4 ) pahec1 @@DsIC1;
         dow not %eof( pahec1 );
           @@DsC1C += 1;
           eval-corr @@DsC1( @@DsC1C ) = @@DsIC1;
          reade(n) %kds( k1yec1 : 4 ) pahec1 @@DsIC1;
         enddo;
       endif;

       if %addr( peDsC1 ) <> *null;
         eval-corr peDsC1 = @@DsC1;
       endif;

       if %addr( peDsC1C ) <> *null;
         peDsC1C = @@DsC1C;
       endif;

       return *on;

      /end-free

     P SPVSPO_getCabeceraSuplemento...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkBloqueo(): Verificar si Superpoliza esta bloqueada *
     ?*                                                              *
     ?*     peEmpr   (input)   Empresa                               *
     ?*     peSucu   (input)   Sucursal                              *
     ?*     peArcd   (input)   Codigo de Articulo                    *
     ?*     peSpol   (input)   Numero de SuperPoliza                 *
     ?*                                                              *
     ?* Retorna: *on = Bloqueada / *off = No Bloqueada               *
     ?* ------------------------------------------------------------ *
     P SPVSPO_chkBloqueo...
     P                 B                   export
     D SPVSPO_chkBloqueo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D   k1ykl1        ds                  likerec( p1wkl1 : *key )

      /free

       SPVSPO_inz();

       k1ykl1.l1empr = peEmpr;
       k1ykl1.l1sucu = peSucu;
       k1ykl1.l1arcd = peArcd;
       k1ykl1.l1spol = peSpol;

       setll %kds( k1ykl1 : 4 ) pawkl1;

       return %eof;

      /end-free

     P SPVSPO_chkBloqueo...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getNuevoSuplemento: Obtener nuevo numero de suplemento*
     ?*                                                              *
     ?*     peEmpr   (input)   Empresa                               *
     ?*     peSucu   (input)   Sucursal                              *
     ?*     peArcd   (input)   Codigo de Articulo                    *
     ?*     peSpol   (input)   Numero de SuperPoliza                 *
     ?*                                                              *
     ?* Retorna: 0 = No se pudo obtener / <> 0 = nuevo numero        *
     ?* ------------------------------------------------------------ *
     P SPVSPO_getNuevoSuplemento...
     P                 B                   export
     D SPVSPO_getNuevoSuplemento...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D   k1yec1        ds                  likerec( p1hec1 : *key )

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;

       setgt     %kds( k1yec1 : 4 ) pahec1;
       readpe(n) %kds( k1yec1 : 4 ) pahec1;
       if %eof( pahec1 );
         return 0;
       endif;

       return c1sspo + 1;

      /end-free

     P SPVSPO_getNuevoSuplemento...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setCabeceraSuplemento: Graba Cabecera de Suplemento   *
     ?*                                                              *
     ?*     peDsC1  (  input  )  Estructura de Suplemento            *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setCabeceraSuplemento...
     P                 b                   export
     D  SPVSPO_setCabeceraSuplemento...
     D                 pi              n
     D   peDsC1                            likeds( dsPahec1_t ) const

     D   @@DsOC1       ds                  likerec( p1hec1 : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkSspo( peDsC1.c1empr
                        : peDsC1.c1sucu
                        : peDsC1.c1arcd
                        : peDsC1.c1spol
                        : peDsC1.c1sspo );
         return *off;
       endif;

       eval-corr @@DsOC1 = peDsC1;
       monitor;
         write p1hec1 @@DsOC1;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P  SPVSPO_setCabeceraSuplemento...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkCabecera: Valida Cabecera de SuperPoliza           *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkCabecera...
     P                 b                   export
     D  SPVSPO_chkCabecera...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D   k1yec0        ds                  likerec( p1hec0 : *key )

      /free

       SPVSPO_inz();

       k1yec0.c0empr = peEmpr;
       k1yec0.c0sucu = peSucu;
       k1yec0.c0arcd = peArcd;
       k1yec0.c0spol = peSpol;
       setll %kds( k1yec0 : 4 ) pahec0;
       return %equal;

      /end-free

     P  SPVSPO_chkCabecera...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getCabecera: Retorna Cabecera de SuperPoliza          *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peDsC0  (  output )  Estructura de Cabecera              *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_getCabecera...
     P                 b                   export
     D  SPVSPO_getCabecera...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peDsC0                            likeds( dsPahec0_t )

     D   k1yec0        ds                  likerec( p1hec0 : *key   )
     D   @@DsIC0       ds                  likerec( p1hec0 : *input )

      /free

       SPVSPO_inz();

       k1yec0.c0empr = peEmpr;
       k1yec0.c0sucu = peSucu;
       k1yec0.c0arcd = peArcd;
       k1yec0.c0spol = peSpol;
       chain(n) %kds( k1yec0 : 4 ) pahec0 @@DsIC0;
       if %found( pahec0 );
         eval-corr peDsC0 = @@DsIC0;
         return *on;
       endif;

       return *off;

      /end-free

     P  SPVSPO_getCabecera...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setCabecera : Graba Cabecera de SuperPoliza           *
     ?*                                                              *
     ?*     peDsC0  (  input  )  Estructura de Cabecera              *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setCabecera...
     P                 b                   export
     D  SPVSPO_setCabecera...
     D                 pi              n
     D   peDsC0                            likeds( dsPahec0_t ) const

     D   @@DsOC0       ds                  likerec( p1hec0 : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkcabecera( peDsC0.c0empr
                            : peDsC0.c0sucu
                            : peDsC0.c0arcd
                            : peDsC0.c0spol );
         return *off;
       endif;

       eval-corr @@DsOC0 = peDsC0;
       monitor;
         write p1hec0 @@DsOC0;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P  SPVSPO_setCabecera...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkComisionCobranza: Valida Comision Cobranza         *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peSspo  (  input  )  Suplemento             (opcional)   *
     ?*     peCbrn  (  input  )  Nivel de Intermediario (opcional)   *
     ?*     peCzco  (  input  )  Zona de Cobranza       (opcional)   *
     ?*     peMone  (  input  )  Código de moneda       (opcional)   *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkComisionCobranza...
     P                 b                   export
     D  SPVSPO_chkComisionCobranza...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit) const
     D   peCbrn                       7  0 options(*nopass:*omit) const
     D   peCzco                       7  0 options(*nopass:*omit) const
     D   peMone                       2    options(*nopass:*omit) const

     D   k1yec2        ds                  likerec( p1hec2 : *key )

      /free

       SPVSPO_inz();

       k1yec2.c2empr = peEmpr;
       k1yec2.c2sucu = peSucu;
       k1yec2.c2arcd = peArcd;
       k1yec2.c2spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peCbrn ) <> *null and
                %addr( peCzco ) <> *null and
                %addr( peMone ) <> *null      ;

                k1yec2.c2sspo = peSspo;
                k1yec2.c2cbrn = peCbrn;
                k1yec2.c2czco = peCzco;
                k1yec2.c2mone = peMone;
                setll %kds( k1yec2 : 8 ) pahec2;

           when %addr( peSspo ) <> *null and
                %addr( peCbrn ) <> *null and
                %addr( peCzco ) <> *null and
                %addr( peMone ) =  *null      ;

                k1yec2.c2sspo = peSspo;
                k1yec2.c2cbrn = peCbrn;
                k1yec2.c2czco = peCzco;
                setll %kds( k1yec2 : 7 ) pahec2;

           when %addr( peSspo ) <> *null and
                %addr( peCbrn ) <> *null and
                %addr( peCzco ) =  *null and
                %addr( peMone ) =  *null      ;

                k1yec2.c2sspo = peSspo;
                k1yec2.c2cbrn = peCbrn;
                setll %kds( k1yec2 : 6 ) pahec2;

           when %addr( peSspo ) <> *null and
                %addr( peCbrn ) =  *null and
                %addr( peCzco ) =  *null and
                %addr( peMone ) =  *null      ;

                k1yec2.c2sspo = peSspo;
                setll %kds( k1yec2 : 5 ) pahec2;
           other;
                setll %kds( k1yec2 : 4 ) pahec2;
         endsl;
       else;
         setll %kds( k1yec2 : 4 ) pahec2;
       endif;

       return %equal;

      /end-free

     P  SPVSPO_chkComisionCobranza...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getComisionCobranza: Retorna Comision de Cobranza     *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peSspo  (  input  )  Suplemento             (opcional)   *
     ?*     peCbrn  (  input  )  Nivel de Intermediario (opcional)   *
     ?*     peCzco  (  input  )  Zona de Cobranza       (opcional)   *
     ?*     peMone  (  input  )  Código de moneda       (opcional)   *
     ?*     peDsC2  (  output )  Estructura de Cobranza (opcional)   *
     ?*     peDsC2C (  output )  Cantidad de Cobranza   (opcional)   *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_getComisionCobranza...
     P                 b                   export
     D  SPVSPO_getComisionCobranza...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit) const
     D   peCbrn                       7  0 options(*nopass:*omit) const
     D   peCzco                       7  0 options(*nopass:*omit) const
     D   peMone                       2    options(*nopass:*omit) const
     D   peDsC2                            likeds ( dsPahec2_t )
     D                                     options(*nopass:*omit)dim( 999 )
     D   peDsC2C                     10i 0 options(*nopass:*omit)

     D   k1yec2        ds                  likerec( p1hec2 : *key   )
     D   @@DsIC2       ds                  likerec( p1hec2 : *input )
     D   @@DsC2C       s             10i 0
     D   @@DsC2        ds                  likeds ( dsPahec2_t )dim( 999 )

      /free

       SPVSPO_inz();

       k1yec2.c2empr = peEmpr;
       k1yec2.c2sucu = peSucu;
       k1yec2.c2arcd = peArcd;
       k1yec2.c2spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peCbrn ) <> *null and
                %addr( peCzco ) <> *null and
                %addr( peMone ) <> *null      ;

                k1yec2.c2sspo = peSspo;
                k1yec2.c2cbrn = peCbrn;
                k1yec2.c2czco = peCzco;
                k1yec2.c2mone = peMone;
                setll %kds( k1yec2 : 8 ) pahec2;
                if not %equal( pahec2 );
                  return *off;
                endif;
                reade(n) %kds( k1yec2 : 8 ) pahec2 @@DsIC2;
                dow not %eof( pahec2 );
                  @@DsC2C += 1;
                  eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
                 reade(n) %kds( k1yec2 : 8 ) pahec2 @@DsIC2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peCbrn ) <> *null and
                %addr( peCzco ) <> *null and
                %addr( peMone ) =  *null      ;

                k1yec2.c2sspo = peSspo;
                k1yec2.c2cbrn = peCbrn;
                k1yec2.c2czco = peCzco;
                setll %kds( k1yec2 : 7 ) pahec2;
                if not %equal( pahec2 );
                  return *off;
                endif;
                reade(n) %kds( k1yec2 : 7 ) pahec2 @@DsIC2;
                dow not %eof( pahec2 );
                  @@DsC2C += 1;
                  eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
                 reade(n) %kds( k1yec2 : 7 ) pahec2 @@DsIC2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peCbrn ) <> *null and
                %addr( peCzco ) =  *null and
                %addr( peMone ) =  *null      ;

                k1yec2.c2sspo = peSspo;
                k1yec2.c2cbrn = peCbrn;
                setll %kds( k1yec2 : 6 ) pahec2;
                if not %equal( pahec2 );
                  return *off;
                endif;
                reade(n) %kds( k1yec2 : 6 ) pahec2 @@DsIC2;
                dow not %eof( pahec2 );
                  @@DsC2C += 1;
                  eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
                 reade(n) %kds( k1yec2 : 6 ) pahec2 @@DsIC2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peCbrn ) =  *null and
                %addr( peCzco ) =  *null and
                %addr( peMone ) =  *null      ;

                k1yec2.c2sspo = peSspo;
                setll %kds( k1yec2 : 5 ) pahec2;
                if not %equal( pahec2 );
                  return *off;
                endif;
                reade %kds( k1yec2 : 5 ) pahec2 @@DsIC2;
                dow not %eof( pahec2 );
                  @@DsC2C += 1;
                  eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
                 reade(n) %kds( k1yec2 : 5 ) pahec2 @@DsIC2;
                enddo;
           other;
                setll %kds( k1yec2 : 4 ) pahec2;
                if not %equal( pahec2 );
                  return *off;
                endif;
                reade(n) %kds( k1yec2 : 4 ) pahec2 @@DsIC2;
                dow not %eof( pahec2 );
                  @@DsC2C += 1;
                  eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
                 reade(n) %kds( k1yec2 : 4 ) pahec2 @@DsIC2;
                enddo;
         endsl;
       else;
         setll %kds( k1yec2 : 4 ) pahec2;
         if not %equal( pahec2 );
           return *off;
         endif;
         reade(n) %kds( k1yec2 : 7 ) pahec2 @@DsIC2;
         dow not %eof( pahec2 );
          @@DsC2C += 1;
          eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
          reade(n) %kds( k1yec2 : 7 ) pahec2 @@DsIC2;
         enddo;
       endif;

       if %addr( peDsC2  ) <> *null and
          %addr( peDsC2C ) <> *null     ;
          clear peDsC2;
          clear peDsC2C;
          eval-corr peDsC2  = @@Dsc2;
          peDsC2C = @@DsC2C;
       endif;

       return *on;

     P  SPVSPO_getComisionCobranza...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setComisionCobranza: Graba Comision Cobranza          *
     ?*                                                              *
     ?*     peDsC2  (  input  )  Estructura de Cobranza              *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setComisionCobranza...
     P                 b                   export
     D  SPVSPO_setComisionCobranza...
     D                 pi              n
     D   peDsC2                            likeds( dsPahec2_t ) const

     D   @@DsOC2       ds                  likerec( p1hec2 : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkComisionCobranza( peDsC2.c2empr
                                    : peDsC2.c2sucu
                                    : peDsC2.c2arcd
                                    : peDsC2.c2spol
                                    : peDsC2.c2sspo
                                    : peDsC2.c2cbrn
                                    : peDsC2.c2czco
                                    : peDsC2.c2mone  );
         return *off;
       endif;

       eval-corr @@DsOC2 = peDsC2;
       monitor;
         write p1hec2 @@DsOC2;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P  SPVSPO_setComisionCobranza...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkPlanDePago: Valida Plan de Pago                    *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peSspo  (  input  )  Suplemento       ( opcional )       *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkPlanDePago...
     P                 b                   export
     D  SPVSPO_chkPlanDePago...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options(*nopass:*omit)

     D   k1yec3        ds                  likerec( p1hec3 : *key )

      /free

       SPVSPO_inz();

       k1yec3.c3empr = peEmpr;
       k1yec3.c3sucu = peSucu;
       k1yec3.c3arcd = peArcd;
       k1yec3.c3spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *null;
         k1yec3.c3sspo = peSspo;
         setll %kds( k1yec3 : 5 ) pahec3;
       else;
         setll %kds( k1yec3 : 4 ) pahec3;
       endif;

       return %equal;

      /end-free

     P  SPVSPO_chkPlanDePago...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPlanDePago: Grabar Plan de Pago                    *
     ?*                                                              *
     ?*     peDsc3  (  output )  Est. Plan de Pago                   *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setPlanDePago...
     P                 b                   export
     D  SPVSPO_setPlanDePago...
     D                 pi              n
     D   peDsC3                            const likeds( dsPahec3V2_t )

     D   @@DsOC3       ds                  likerec( p1hec3 : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkPlanDePago( peDsC3.c3empr
                              : peDsC3.c3sucu
                              : peDsC3.c3arcd
                              : peDsC3.c3spol
                              : peDsC3.c3sspo );
         return *off;
       endif;

       eval-corr @@DsOC3 = peDsC3;
       monitor;
         write p1hec3 @@DsOC3;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P  SPVSPO_setPlanDePago...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkReferencias: Valida Referencia                     *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peSspo  (  input  )  Suplemento       ( opcional )       *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkReferencias...
     P                 b                   export
     D  SPVSPO_chkReferencias...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *nopass : *omit )

     D   k1yec4        ds                  likerec( p1hec4 : *key )

      /free

       SPVSPO_inz();

       k1yec4.c4empr = peEmpr;
       k1yec4.c4sucu = peSucu;
       k1yec4.c4arcd = peArcd;
       k1yec4.c4spol = peSpol;
       if %parms >= 5 and %addr( peSspo ) <> *null;
         k1yec4.c4sspo = peSspo;
         setll %kds( k1yec4 : 5 ) pahec4;
       else;
         setll %kds( k1yec4 : 4 ) pahec4;
       endif;

       return %equal;

      /end-free

     P  SPVSPO_chkReferencias...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setReferencias: Grabar Referencias                    *
     ?*                                                              *
     ?*     peDsc4  (  output )  Est. Referencias                    *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setReferencias...
     P                 b                   export
     D  SPVSPO_setReferencias...
     D                 pi              n
     D   peDsC4                            const likeds( dsPahec4_t )

     D   @@DsOC4       ds                  likerec( p1hec4 : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkReferencias ( peDsC4.c4empr
                                : peDsC4.c4sucu
                                : peDsC4.c4arcd
                                : peDsC4.c4spol
                                : peDsC4.c4sspo );
         return *off;
       endif;

       eval-corr @@DsOC4 = peDsC4;
       monitor;
         write p1hec4 @@DsOC4;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P  SPVSPO_setReferencias...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getReferencias: Retorna Referencias                   *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peSspo  (  input  )  Suplemento            ( opcional )  *
     ?*     peDsC4  (  output )  Est. Referencias      ( opcional )  *
     ?*     peDsC4C (  output )  Cant.Referencias      ( opcional )  *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_getReferencias...
     P                 b                   export
     D  SPVSPO_getReferencias...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *nopass : *omit )
     D   peDsC4                            likeds( dsPahec4_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsC4C                     10i 0 options( *nopass : *omit )

     D   k1yec4        ds                  likerec( p1hec4 : *key   )
     D   @@DsIC4       ds                  likerec( p1hec4 : *input )
     D   @@DsC4        ds                  likeds( dsPahec4_t ) dim( 999 )
     D   @@DsC4C       s             10i 0

      /free

       SPVSPO_inz();

       clear @@DsC4;
       clear @@DsC4C;

       k1yec4.c4empr = peEmpr;
       k1yec4.c4sucu = peSucu;
       k1yec4.c4arcd = peArcd;
       k1yec4.c4spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null;
             k1yec4.c4sspo = peSspo;
             setll %kds( k1yeC4 : 5 ) paheC4;
             if not %equal( paheC4 );
               return *off;
             endif;
             reade(n) %kds( k1yec4 : 5 ) paheC4 @@DsIC4;
             dow not %eof( paheC4 );
               @@DsC4C += 1;
               eval-corr @@DsC4( @@DsC4C ) = @@DsIC4;
              reade(n) %kds( k1yeC4 : 5 ) pahec4 @@DsIC4;
             enddo;
           other;
             setll %kds( k1yec4 : 4 ) pahec4;
             if not %equal( pahec4 );
               return *off;
             endif;
             reade(n) %kds( k1yec4 : 4 ) pahec4 @@DsIC4;
             dow not %eof( pahec4 );
               @@DsC4C += 1;
               eval-corr @@DsC4( @@DsC4C ) = @@DsIC4;
              reade(n) %kds( k1yec4 : 4 ) paheC4 @@DsIC4;
             enddo;
         endsl;
       else;
         setll %kds( k1yec4 : 4 ) pahec4;
         if not %equal( pahec4 );
           return *off;
         endif;
         reade(n) %kds( k1yec4 : 4 ) pahec4 @@DsIc4;
         dow not %eof( pahec4 );
           @@DsC4C += 1;
           eval-corr @@DsC4( @@DsC4C ) = @@DsIC4;
          reade(n) %kds( k1yec4 : 4 ) pahec4 @@DsIC4;
         enddo;
       endif;

       if %addr( peDsC4  ) <> *null;
         eval-corr peDsC4 = @@DsC4;
       endif;

       if %addr( peDsC4C ) <> *null;
         peDsC4C = @@DsC4C;
       endif;

       return *on;

      /end-free

     P  SPVSPO_getReferencias...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkBeneficiario: Valida Beneficiaro                   *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peSspo  (  input  )  Suplemento          ( opcional )    *
     ?*     peNord  (  input  )  Nro de Orden        ( opcional )    *
     ?*     peAsen  (  input  )  Nro Asegurado       ( opcional )    *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkBeneficiario...
     P                 b                   export
     D  SPVSPO_chkBeneficiario...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *nopass : *omit )
     D   peNord                       6  0 const options( *nopass : *omit )
     D   peAsen                       7  0 const options( *nopass : *omit )

     D   k1yec5        ds                  likerec( p1hec5  : *key )

      /free

       SPVSPO_inz();

       k1yec5.c5empr = peEmpr;
       k1yec5.c5sucu = peSucu;
       k1yec5.c5arcd = peArcd;
       k1yec5.c5spol = peSpol;

       if %parms >= 5 and %addr( peAsen ) <> *null;

         Select;
            when %addr( peSspo ) <> *null and
                 %addr( peNord ) <> *null;

                 return SPVSPO_chkAsegurado( peEmpr
                                           : peSucu
                                           : peAsen
                                           : peArcd
                                           : peSpol
                                           : peSspo
                                           : peNord );
            when %addr( peSspo ) <> *null and
                 %addr( peNord ) =  *null;

                 return SPVSPO_chkAsegurado( peEmpr
                                           : peSucu
                                           : peAsen
                                           : peArcd
                                           : peSpol
                                           : peSspo
                                           : *omit  );
           other;
                 return SPVSPO_chkAsegurado( peEmpr
                                           : peSucu
                                           : peAsen
                                           : peArcd
                                           : peSpol
                                           : *omit
                                           : *omit  );
         endsl;
       endif;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peNord ) <> *null;

                k1yec5.c5sspo = peSspo;
                k1yec5.c5nord = penord;
                setll %kds( k1yec5 : 6 ) pahec5;

           when %addr( peSspo ) <> *null and
                %addr( peNord ) =  *null;

                k1yec5.c5sspo = peSspo;
                setll %kds( k1yec5 : 5 ) pahec5;

           other;
             setll %kds( k1yec5 : 4 ) pahec5;
         endsl;
       else;
         setll %kds( k1yec5 : 4 ) pahec5;
       endif;

       return %equal;

      /end-free

     P  SPVSPO_chkBeneficiario...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getBeneficiarios: Retorna Beneficiarios               *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peSspo  (  input  )  Suplemento          ( opcional )    *
     ?*     peNord  (  input  )  Nro de Orden        ( opcional )    *
     ?*     peAsen  (  input  )  Nro Asegurado       ( opcional )    *
     ?*     peDsC5  (  output )  Est. Beneficiarios  ( opcional )    *
     ?*     peDsC5C (  output )  Cant. de Benef.     ( opcional )    *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_getBeneficiarios...
     P                 b                   export
     D  SPVSPO_getBeneficiarios...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *nopass : *omit )
     D   peNord                       6  0 const options( *nopass : *omit )
     D   peAsen                       7  0 const options( *nopass : *omit )
     D   peDsC5                            likeds( dsPahec5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsC5C                     10i 0 options( *nopass : *omit )

     D   k1yec5        ds                  likerec( p1hec5 : *key   )
     D   @@DsIC5       ds                  likerec( p1hec5 : *input )
     D   @@DsC5        ds                  likeds ( dsPahec5_t ) dim( 999 )
     D   @@DsC5C       s             10i 0

      /free

       SPVSPO_inz();

       clear @@DsIC5;
       clear @@DsC5;
       clear @@DsC5C;

       k1yec5.c5empr = peEmpr;
       k1yec5.c5sucu = peSucu;
       k1yec5.c5arcd = peArcd;
       k1yec5.c5spol = peSpol;

       if %parms >= 5 ;
         if %addr( peAsen ) <> *null;
            Select;
               when %addr( peSspo ) <> *null and
                    %addr( peNord ) <> *null;

                    if not SPVSPO_chkAsegurado( peEmpr
                                              : peSucu
                                              : peAsen
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peNord  );

                    return *off;

                    endif;

               when %addr( peSspo ) <> *null and
                    %addr( peNord ) =  *null;

                    if not SPVSPO_chkAsegurado( peEmpr
                                              : peSucu
                                              : peAsen
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : *omit   );

                      return *off;
                    endif;
               other;
                    if not SPVSPO_chkAsegurado( peEmpr
                                              : peSucu
                                              : peAsen
                                              : peArcd
                                              : peSpol
                                              : *omit
                                              : *omit   );

                      return *off;
                    endif;
            endsl;
         else;
            Select;
              when %addr( peSspo ) <> *null and
                   %addr( peNord ) <> *null;

                   k1yec5.c5sspo = peSspo;
                   k1yec5.c5nord = peNord;
                   setll %kds( k1yec5 : 6 ) pahec5;
                   if not %equal( pahec5 );
                     return *off;
                   endif;
                   reade(n) %kds( k1yec5 : 6 ) pahec5 @@DsIC5;
                   dow not %eof( pahec5 );
                     @@DsC5C += 1;
                     eval-corr @@DsC5( @@DsC5C ) = @@DsIC5;
                    reade(n) %kds( k1yec5 : 6 ) pahec5 @@DsIC5;
                   enddo;

              when %addr( peSspo ) <> *null and
                   %addr( peNord ) =  *null    ;

                   k1yec5.c5sspo = peSspo;
                   setll %kds( k1yec5 : 5 ) pahec5;
                   if not %equal( pahec5 );
                     return *off;
                   endif;

                   reade(n) %kds( k1yec5 : 5 ) pahec5 @@DsIC5;
                   dow not %eof( pahec5 );
                     @@DsC5C += 1;
                     eval-corr @@DsC5( @@DsC5C ) = @@DsIC5;
                    reade(n) %kds( k1yec5 : 5 ) pahec5 @@DsIC5;
                   enddo;

              other;

                setll %kds( k1yec5 : 4 ) pahec5;
                if not %equal( pahec5 );
                  return *off;
                endif;

                reade(n) %kds( k1yec5 : 4 ) pahec5 @@DsIC5;
                dow not %eof( pahec5 );
                  @@DsC5C += 1;
                  eval-corr @@DsC5( @@DsC5C ) = @@DsIC5;
                 reade(n) %kds( k1yec5 : 4 ) pahec5 @@DsIC5;
                enddo;
            endsl;
         endif;
       else;

           setll %kds( k1yec5 : 4 ) pahec5;
           if not %equal( pahec5 );
             return *off;
           endif;

           reade(n) %kds( k1yec5 : 4 ) pahec5 @@DsIC5;
           dow not %eof( pahec5 );
             @@DsC5C += 1;
             eval-corr @@DsC5( @@DsC5C ) = @@DsIC5;
            reade(n) %kds( k1yec5 : 4 ) pahec5 @@DsIC5;
           enddo;

       endif;

       if %addr( peDsC5C ) <> *null;
         eval peDsC5C = @@DsC5C;
       endif;
       if %addr( peDsC5 ) <> *null;
         eval-corr peDsC5 = @@DsC5;
       endif;

       return *on;

     P SPVSPO_getBeneficiarios...
     P                 e
     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setBeneficiarios : Graba Datos de Beneficiaros        *
     ?*                                                              *
     ?*     peDsC5  (  input  )  Estructura de Beneficiaros          *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setBeneficiarios...
     P                 b                   export
     D  SPVSPO_setBeneficiarios...
     D                 pi              n
     D   peDsC5                            likeds( dsPahec5_t ) const

     D   @@DsOC5       ds                  likerec( p1hec5 : *output )
     D   x             s             10i 0

      /free

       SPVSPO_inz();

       if SPVSPO_chkBeneficiario( peDsC5.c5empr
                                : peDsC5.c5sucu
                                : peDsC5.c5arcd
                                : peDsC5.c5spol
                                : peDsC5.c5sspo
                                : peDsC5.c5nord  );
         return *off;
       endif;

       eval-corr @@DsOC5 = peDsC5;
       monitor;
         write p1hec5 @@DsOC5;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P  SPVSPO_setBeneficiarios...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkAsegurado: Valida Asegurado                        *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peAsen  (  input  )  Nro Asegurado                       *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peSspo  (  input  )  Suplemento          ( opcional )    *
     ?*     peNord  (  input  )  Nro de Orden        ( opcional )    *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkAsegurado...
     P                 b                   export
     D  SPVSPO_chkAsegurado...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *nopass : *omit )
     D   peNord                       6  0 const options( *nopass : *omit )

     D   k1yec5        ds                  likerec( p1hec501 : *key )

      /free

       SPVSPO_inz();

       k1yec5.c5empr = peEmpr;
       k1yec5.c5sucu = peSucu;
       k1yec5.c5asen = peAsen;
       k1yec5.c5arcd = peArcd;
       k1yec5.c5spol = peSpol;

        if %parms >= 6;
          Select;
            when  %addr( peSspo ) <> *null and
                  %addr( peNord ) <> *null     ;

                  k1yec5.c5sspo = peSspo;
                  k1yec5.c5nord = peNord;
                  setll %kds( k1yec5 : 7 ) pahec501;

            when  %addr( peSspo ) <> *null and
                  %addr( peNord ) =  *null     ;

                  k1yec5.c5sspo = peSspo;
                  setll %kds( k1yec5 : 6 ) pahec501;
            other;
                  setll %kds( k1yec5 : 5 ) pahec501;
          endsl;
        else;
          setll %kds( k1yec5 : 5 ) pahec501;
        endif;

        return %equal;

     P  SPVSPO_chkAsegurado...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPrimaxProvincia: Primas por Provincia              *
     ?*                                                              *
     ?*     peDsEg  (  input  )  Estructura de Primas x Prov         *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setPrimaxProvincia...
     P                 b                   export
     D  SPVSPO_setPrimaxProvincia...
     D                 pi              n
     D   peDsEg                            likeds( dsPaheg3_t ) const

     D   @@DsOEg       ds                  likerec( p1heg3 : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkPrimaxProvincia( peDsEg.g3empr
                                   : peDsEg.g3sucu
                                   : peDsEg.g3arcd
                                   : peDsEg.g3spol
                                   : peDsEg.g3sspo
                                   : peDsEg.g3rama
                                   : peDsEg.g3arse
                                   : peDsEg.g3oper
                                   : peDsEg.g3suop
                                   : peDsEg.g3rpro );

         return *off;
       endif;

       eval-corr @@DsOEg = peDsEg;
       monitor;
         write p1heg3 @@DsOEg;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P  SPVSPO_setPrimaxProvincia...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkPrimaxProvincia: Primas por Provincia              *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  SuperPoliza                         *
     ?*     peSspo  (  input  )  Suplemento                          *
     ?*     peRama  (  input  )  Rama                                *
     ?*     peArse  (  input  )  Cant. Polizas                       *
     ?*     peOper  (  input  )  Operacion                           *
     ?*     peSuop  (  input  )  Suplemento Operacion                *
     ?*     peRpro  (  input  )  Provincia Inder                     *
     ?*                                                              *
     ?* Retorna: *on = Encontro / *off = No Encontro                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkPrimaxProvincia...
     P                 b                   export
     D  SPVSPO_chkPrimaxProvincia...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       6  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peRpro                       2  0 const

     D   k1yeg3        ds                  likerec( p1heg3 : *key )

      /free

       SPVSPO_inz();

       k1yeg3.g3empr = peEmpr;
       k1yeg3.g3sucu = peSucu;
       k1yeg3.g3arcd = peArcd;
       k1yeg3.g3spol = peSpol;
       k1yeg3.g3sspo = peSspo;
       k1yeg3.g3rama = peRama;
       k1yeg3.g3arse = peArse;
       k1yeg3.g3oper = peOper;
       k1yeg3.g3suop = peSuop;
       k1yeg3.g3rpro = peRpro;
       setll %kds( k1yeg3 : 10 ) paheg3;
       return %equal;

      /end-free

     P  SPVSPO_chkPrimaxProvincia...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_dltPrimaxProvincia: Elimina Primas por Provincia      *
     ?*                                                              *
     ?*     peDsEg  (  input  )  Estructura de Primas x Prov         *
     ?*                                                              *
     ?* Retorna: *on = Elimino ok / *off = No Eliminio               *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_dltPrimaxProvincia...
     P                 b                   export
     D  SPVSPO_dltPrimaxProvincia...
     D                 pi              n
     D   peDsEg                            likeds( dsPaheg3_t ) const

     D   k1yeg3        ds                  likerec( p1heg3 : *key )

      /free

       SPVSPO_inz();

       k1yeg3.g3empr = peDsEg.g3empr;
       k1yeg3.g3sucu = peDsEg.g3sucu;
       k1yeg3.g3arcd = peDsEg.g3arcd;
       k1yeg3.g3spol = peDsEg.g3spol;
       k1yeg3.g3sspo = peDsEg.g3sspo;
       k1yeg3.g3rama = peDsEg.g3rama;
       k1yeg3.g3arse = peDsEg.g3arse;
       k1yeg3.g3oper = peDsEg.g3oper;
       k1yeg3.g3suop = peDsEg.g3suop;
       k1yeg3.g3rpro = peDsEg.g3rpro;
       chain %kds( k1yeg3 : 10 ) paheg3;
       if %found( paheg3 );
         delete p1heg3;
       else;
         return *off;
       endif;

       return *on;

      /end-free

     P  SPVSPO_dltPrimaxProvincia...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPrimxProvRegSimp: Prima por Provincia Regimen      *
     ?*                             Simplificado                     *
     ?*                                                              *
     ?*     peDsEp  (  input  )  Estructura de Primas x Prov Reg Sim *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setPrimxProvRegSimp...
     P                 b                   export
     D  SPVSPO_setPrimxProvRegSimp...
     D                 pi              n
     D   peDsEp                            likeds( dsPaheg3p_t ) const

     D   @@DsOEp       ds                  likerec( p1heg3p : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkPrimxProvRegSimp( peDsEp.gp3empr
                                    : peDsEp.gp3sucu
                                    : peDsEp.gp3arcd
                                    : peDsEp.gp3spol
                                    : peDsEp.gp3sspo
                                    : peDsEp.gp3rama
                                    : peDsEp.gp3arse
                                    : peDsEp.gp3oper
                                    : peDsEp.gp3suop
                                    : peDsEp.gp3rpro );

         return *off;
       endif;

       eval-corr @@DsOEp = peDsEp;
       monitor;
         write p1heg3p @@DsOEp;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P  SPVSPO_setPrimxProvRegSimp...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPrimxProvRegSimp: Primas por Provincia Regimen     *
     ?*                             simplificado                     *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  SuperPoliza                         *
     ?*     peSspo  (  input  )  Suplemento                          *
     ?*     peRama  (  input  )  Rama                                *
     ?*     peArse  (  input  )  Cant. Polizas                       *
     ?*     peOper  (  input  )  Operacion                           *
     ?*     peSuop  (  input  )  Suplemento Operacion                *
     ?*     peRpro  (  input  )  Provincia Inder                     *
     ?*                                                              *
     ?* Retorna: *on = Encontro / *off = No Encontro                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkPrimxProvRegSimp...
     P                 b                   export
     D  SPVSPO_chkPrimxProvRegSimp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       6  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peRpro                       2  0 const

     D   k1yeg3        ds                  likerec( p1heg3p : *key )

      /free

       SPVSPO_inz();

       k1yeg3.gp3empr = peEmpr;
       k1yeg3.gp3sucu = peSucu;
       k1yeg3.gp3arcd = peArcd;
       k1yeg3.gp3spol = peSpol;
       k1yeg3.gp3sspo = peSspo;
       k1yeg3.gp3rama = peRama;
       k1yeg3.gp3arse = peArse;
       k1yeg3.gp3oper = peOper;
       k1yeg3.gp3suop = peSuop;
       k1yeg3.gp3rpro = peRpro;
       setll %kds( k1yeg3 : 10 ) paheg3p;
       return %equal;

      /end-free

     P  SPVSPO_chkPrimxProvRegSimp...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_dltPrimxProvRegSimp: Elimina Prima por Provincia      *
     ?*                             Regimen Simplificado             *
     ?*                                                              *
     ?*     peDsEp  (  input  )  Estructura de Primas x Prov Reg Sim *
     ?*                                                              *
     ?* Retorna: *on = Elimino ok / *off = No Elimino                *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_dltPrimxProvRegSimp...
     P                 b                   export
     D  SPVSPO_dltPrimxProvRegSimp...
     D                 pi              n
     D   peDsEp                            likeds( dsPaheg3p_t ) const

     D   k1yeg3        ds                  likerec( p1heg3p : *key )

      /free

       SPVSPO_inz();

       k1yeg3.gp3empr = peDsEp.gp3empr;
       k1yeg3.gp3sucu = peDsEp.gp3sucu;
       k1yeg3.gp3arcd = peDsEp.gp3arcd;
       k1yeg3.gp3spol = peDsEp.gp3spol;
       k1yeg3.gp3sspo = peDsEp.gp3sspo;
       k1yeg3.gp3rama = peDsEp.gp3rama;
       k1yeg3.gp3arse = peDsEp.gp3arse;
       k1yeg3.gp3oper = peDsEp.gp3oper;
       k1yeg3.gp3suop = peDsEp.gp3suop;
       k1yeg3.gp3rpro = peDsEp.gp3rpro;
       chain %kds( k1yeg3 : 10 ) paheg3p;
       if %found( paheg3p );
         delete p1heg3p;
       else;
         return *off;
       endif;

       return *on;

      /end-free

     P  SPVSPO_dltPrimxProvRegSimp...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_getPlanDePagoV2: Retorna Plan de Pago x Suplemento    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDec3   (input)   Registro del archivo PAHEC3           *
      *                                                              *
      * Retorna: *off / *on                                          *
      * ------------------------------------------------------------ *

     P SPVSPO_getPlanDePagoV2...
     P                 B                   export
     D SPVSPO_getPlandePagoV2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peDec3                            likeds( dsPahec3V2_t )
     D                                     options( *nopass : *omit )

     D dsec3           ds                  likerec( p1hec3 : *input )
     D k1yec3          ds                  likerec( p1hec3 : *key )

      /free

       SPVSPO_inz();

       k1yec3.c3empr = peEmpr;
       k1yec3.c3sucu = peSucu;
       k1yec3.c3arcd = peArcd;
       k1yec3.c3spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *Null;
         k1yec3.c3sspo = peSspo;
         chain(n) %kds( k1yec3 : 5 ) pahec3 dsec3;
         if not %found ( pahec3 );
           return *off;
         endif;
       else;
         setgt  %kds( k1yec3 : 4 ) pahec3;
         readpe(n) %kds( k1yec3 : 4 ) pahec3 dsec3;
         if %eof ( pahec3 );
           return *off;
         endif;
       endif;

       if %parms >= 6 and %addr( peDec3 ) <> *null;
         eval-corr peDec3 = dsec3;
       endif;

       return *on;

      /end-free

     P SPVSPO_getPlanDePagoV2...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getUltimoSuplemento: Retorna último suplemento        *
     ?*                                                              *
     ?*     peEmpr   (input)   Empresa                               *
     ?*     peSucu   (input)   Sucursal                              *
     ?*     peArcd   (input)   Codigo de Articulo                    *
     ?*     peSpol   (input)   Numero de SuperPoliza                 *
     ?*                                                              *
     ?* Retorna: 0 = No se pudo obtener / <> 0 = último número       *
     ?* ------------------------------------------------------------ *
     P SPVSPO_getUltimoSuplemento...
     P                 B                   export
     D SPVSPO_getUltimoSuplemento...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D   k1yec1        ds                  likerec( p1hec1 : *key )

      /free

       SPVSPO_inz();

       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;

       setgt     %kds( k1yec1 : 4 ) pahec1;
       readpe(n) %kds( k1yec1 : 4 ) pahec1;
       if %eof( pahec1 );
         return 0;
       endif;

       return c1sspo;

      /end-free

     P SPVSPO_getUltimoSuplemento...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getDatosProgramasInternacionales: Retorna Datos de    *
      *                                          Programas Interna-  *
      *                                          cionales (pahec7).  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDec7   (input)   Registro del archivo PAHEC7           *
      *                                                              *
      * Retorna: *off / *on                                          *
      * ------------------------------------------------------------ *
     P SPVSPO_getDatosProgramasInternacionales...
     P                 B                   export
     D SPVSPO_getDatosProgramasInternacionales...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peDec7                            likeds( dsPahec7_t )
     D                                     options( *nopass : *omit )

     D @@Sspo          s              3  0
     D dsec7           ds                  likerec( p1hec7 : *input )
     D k1yec7          ds                  likerec( p1hec7 : *key )

      /free

       SPVSPO_inz();

       k1yec7.c7Empr = peEmpr;
       k1yec7.c7Sucu = peSucu;
       k1yec7.c7Arcd = peArcd;
       k1yec7.c7Spol = peSpol;

       if %parms >= 5 and %addr( peSspo ) <> *Null;
         k1yec7.c7Sspo = peSspo;
         chain(n) %kds( k1yec7 : 5 ) pahec7 dsec7;
         if not %found ( pahec7 );
           return *off;
         endif;
       else;
         @@Sspo = SPVSPO_getUltimoSuplemento( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol );

         if @@Sspo <> *zeros;
           k1yec7.c7Sspo = @@Sspo;
           chain(n) %kds( k1yec7 : 5 ) pahec7 dsec7;
           if not %found ( pahec7 );
             return *off;
           endif;
         else;
           setgt  %kds( k1yec7 : 4 ) pahec7;
           readpe(n) %kds( k1yec7 : 4 ) pahec7 dsec7;
           if %eof ( pahec7 );
             return *off;
           endif;
         endif;
       endif;

       if %parms >= 6 and %addr( peDec7 ) <> *null;
         eval-corr peDec7 = dsec7;
       endif;

       return *on;

      /end-free

     P SPVSPO_getDatosProgramasInternacionales...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_isNominaExterna: Retorna si es Nomina Externa y       *
      *                         opcionalmente, numero de nomina      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peNomi   (output)  Numero de Nomina                      *
      *                                                              *
      * Retorna: *off / *on                                          *
      * ------------------------------------------------------------ *
     P SPVSPO_isNominaExterna...
     P                 B                   export
     D SPVSPO_isNominaExterna...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNomi                       7  0 options( *nopass : *omit )

     D dsHnx002        ds                  likerec( p1hnx002 : *input )
     D k1Hnx002        ds                  likerec( p1hnx002 : *key )

      /free

       SPVSPO_inz();

       k1Hnx002.n0Empr = peEmpr;
       k1Hnx002.n0Sucu = peSucu;
       k1Hnx002.n0Arcd = peArcd;
       k1Hnx002.n0Spol = peSpol;

       chain(n) %kds( k1Hnx002 : 4 ) pahnx002 dsHnx002;
       if not %found ( pahnx002 );
         if %parms >= 5 and %addr( peNomi ) <> *Null;
           clear peNomi;
         endif;
         return *off;
       endif;

       if %parms >= 5 and %addr( peNomi ) <> *Null;
         peNomi = dsHnx002.n0nomi;
       endif;
       return *on;

      /end-free

     P SPVSPO_isNominaExterna...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getCadenaComercial: Retornar cadena comercial.        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peCade   (output)  Cadena Comercial                      *
      *     peSspo   (input)   Suplemento (opcional)                 *
      *                                                              *
      * Retorna: *on si OK y *OFF por error.                         *
      * ------------------------------------------------------------ *
     P SPVSPO_getCadenaComercial...
     P                 B                   export
     D SPVSPO_getCadenaComercial...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peCade                       5  0 dim(9)
     D   peSspo                       3  0 const options(*nopass:*omit)

     D @@DsC1          ds                  likeds(dsPaheC1_t) dim(999)
     D @@DsC1C         s             10i 0
     D rc              s              1n
     D @@cade          s              5  0 dim(9)

      /free

       SPVSPO_inz();

       if %parms >= 6 and %addr(pesspo) <> *null;
          rc = SPVSPO_getCabeceraSuplemento( peEmpr
                                           : peSucu
                                           : peArcd
                                           : peSpol
                                           : peSspo
                                           : @@DsC1
                                           : @@DsC1C );
        else;
          rc = SPVSPO_getCabeceraSuplemento( peEmpr
                                           : peSucu
                                           : peArcd
                                           : peSpol
                                           : *omit
                                           : @@DsC1
                                           : @@DsC1C );
       endif;
       if rc = *off;
          return *off;
       endif;

       peCade(1) = @@DsC1(@@DsC1C).c1niv1;
       peCade(2) = @@DsC1(@@DsC1C).c1niv2;
       peCade(3) = @@DsC1(@@DsC1C).c1niv3;
       peCade(4) = @@DsC1(@@DsC1C).c1niv4;
       peCade(5) = @@DsC1(@@DsC1C).c1niv5;
       peCade(6) = @@DsC1(@@DsC1C).c1niv6;
       peCade(7) = @@DsC1(@@DsC1C).c1niv7;
       peCade(8) = @@DsC1(@@DsC1C).c1niv8;
       peCade(9) = @@DsC1(@@DsC1C).c1niv9;

       rc = SVPINT_GetCadena( peEmpr
                            : peSucu
                            : @@DsC1(@@DsC1C).c1nivt
                            : @@DsC1(@@DsC1C).c1nivc
                            : @@cade                 );
       peCade(9) = @@cade(9);

       return *on;

      /end-free

     P SPVSPO_getCadenaComercial...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getPahec0c: Retorna Encadenamiento de Superpoliza.    *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Articulo                            *
     ?*     peSpol  (  input  )  Super Poliza                        *
     ?*     peDsC0  (  output )  Estructura de pahec0c               *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_getPahec0c...
     P                 b                   export
     D  SPVSPO_getPahec0c...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peDs0C                            likeds( dsPahec0c_t )

     D   k1yc0c        ds                  likerec( p1hec0c : *key   )
     D   @@DsI0C       ds                  likerec( p1hec0c : *input )

      /free

       SPVSPO_inz();

       k1yc0c.ccEmpr = peEmpr;
       k1yc0c.ccSucu = peSucu;
       k1yc0c.ccArcd = peArcd;
       k1yc0c.ccSpol = peSpol;
       chain(n) %kds( k1yc0c : 4 ) pahec0c @@DsI0C;
       if %found( pahec0c );
         eval-corr peDs0C = @@DsI0C;
         return *on;
       endif;

       return *off;

      /end-free

     P  SPVSPO_getPahec0c...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_getSuperpolizaAnterior: Retorna Superpoliza y Articu- *
      *                                lo anterior.                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Número de SuperPoliza                 *
      *     peArca   (output)  Código de Artículo Anterior           *
      *     peSpoa   (output)  Número de SuperPoliza anterior        *
      *                                                              *
      * Retorna: *off / *on                                          *
      * ------------------------------------------------------------ *
     P SPVSPO_getSuperpolizaAnterior...
     P                 B                   export
     D SPVSPO_getSuperpolizaAnterior...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peArca                       6  0
     D   peSpoa                       9  0

     D @@DsC0          ds                  likeds( dsPahec0_t )
     D @@Ds0C          ds                  likeds( dsPahec0c_t )

      /free

       SPVSPO_inz();

       clear @@DsC0;
       clear @@Ds0C;

       if SPVSPO_getCabecera( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : @@DsC0 );

         if @@DsC0.c0spoa = *all'9';
           if SPVSPO_getPahec0c( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : @@Ds0C );

             peArca = @@Ds0C.ccArca;
             peSpoa = @@Ds0C.ccSpoa;

             return *on;
            endif;

         else;
           peArca = @@DsC0.c0Arcd;
           peSpoa = @@DsC0.c0Spoa;

           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SPVSPO_getSuperpolizaAnterior...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getSuperpolizaPosterior: Retorna Superpoliza y Articu-*
      *                                 lo posterior.                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Número de SuperPoliza                 *
      *     peArcn   (output)  Código de Artículo Posterior          *
      *     peSpon   (output)  Número de SuperPoliza Posterior       *
      *                                                              *
      * Retorna: *off / *on                                          *
      * ------------------------------------------------------------ *
     P SPVSPO_getSuperpolizaPosterior...
     P                 B                   export
     D SPVSPO_getSuperpolizaPosterior...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peArcn                       6  0
     D   peSpon                       9  0

     D @@DsC0          ds                  likeds( dsPahec0_t )
     D @@Ds0C          ds                  likeds( dsPahec0c_t )

      /free

       SPVSPO_inz();

       clear @@DsC0;
       clear @@Ds0C;

       if SPVSPO_getCabecera( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : @@DsC0 );

         if @@DsC0.c0spon = *all'9';
           if SPVSPO_getPahec0c( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : @@Ds0C );

             peArcn = @@Ds0C.ccArcn;
             peSpon = @@Ds0C.ccSpon;

             return *on;
            endif;

         else;
           peArcn = @@DsC0.c0Arcd;
           peSpon = @@DsC0.c0Spon;

           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SPVSPO_getSuperpolizaPosterior...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_isNueva(): Determina si superpoliza es nueva          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Número de SuperPoliza                 *
      *                                                              *
      * Retorna: *On si endoso 0 es Nueva y *Off si no lo es         *
      * ------------------------------------------------------------ *
     P SPVSPO_isNueva...
     P                 b                   export
     D SPVSPO_isNueva...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1hec1          ds                  likerec(p1hec1:*key)

      /free

       SPVSPO_inz();

       k1hec1.c1empr = peEmpr;
       k1hec1.c1sucu = peSucu;
       k1hec1.c1arcd = peArcd;
       k1hec1.c1spol = peSpol;
       k1hec1.c1sspo = 0;
       chain(n) %kds(k1hec1:5) pahec1;
       if %found;
          if c1tiou = 1;
             return *on;
          endif;
       endif;

       return *off;

      /end-free

     P SPVSPO_isNueva...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_isRenovacion(): Determina si superpoliza es renovacion*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Número de SuperPoliza                 *
      *                                                              *
      * Retorna: *On si endoso 0 es Renovacion y *Off si no lo es    *
      * ------------------------------------------------------------ *
     P SPVSPO_isRenovacion...
     P                 b                   export
     D SPVSPO_isRenovacion...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1hec1          ds                  likerec(p1hec1:*key)

      /free

       SPVSPO_inz();

       k1hec1.c1empr = peEmpr;
       k1hec1.c1sucu = peSucu;
       k1hec1.c1arcd = peArcd;
       k1hec1.c1spol = peSpol;
       k1hec1.c1sspo = 0;
       chain(n) %kds(k1hec1:5) pahec1;
       if %found;
          if c1tiou = 2;
             return *on;
          endif;
       endif;

       return *off;

      /end-free

     P SPVSPO_isRenovacion...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_isWeb(): Determina si una superpoliza llego desde web.*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Número de SuperPoliza                 *
      *                                                              *
      * Retorna: *On si endoso 0 es Web y *Off si no                 *
      * ------------------------------------------------------------ *
     P SPVSPO_isWeb...
     P                 b                   export
     D SPVSPO_isWeb...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1w000          ds                  likerec(c1w000:*key)

      /free

       SPVSPO_inz();

       k1w000.w0empr = peEmpr;
       k1w000.w0sucu = peSucu;
       k1w000.w0arcd = peArcd;
       k1w000.w0spol = peSpol;
       k1w000.w0sspo = 0;
       setll %kds(k1w000:5) ctw00018;

       return %equal;

      /end-free

     P SPVSPO_isWeb...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_getUltimoPeriodoCurso(): Obtiene ultimo PECU de una   *
      *                                 superpoliza.                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peSpol   (input)   Número de SuperPoliza                 *
      *                                                              *
      * Retorna: periodo en curso (o cero si no encontro).           *
      * ------------------------------------------------------------ *
     P SPVSPO_getUltimoPeriodoCurso...
     P                 b                   export
     D SPVSPO_getUltimoPeriodoCurso...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1hed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();

       k1hed0.d0empr = peEmpr;
       k1hed0.d0sucu = peSucu;
       k1hed0.d0arcd = peArcd;
       k1hed0.d0spol = peSpol;
       setgt  %kds(k1hed0:4) pahed0;
       readpe %kds(k1hed0:4) pahed0;
       if not %eof;
          return d0pecu;
       endif;

       return *zeros;

      /end-free

     P SPVSPO_getUltimoPeriodoCurso...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_updPlanDePago: Actualiza Plan de Pago                 *
     ?*                                                              *
     ?*     peDsc3  (  output )  Est. Plan de Pago                   *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_updPlanDePago...
     P                 b                   export
     D  SPVSPO_updPlanDePago...
     D                 pi              n
     D   peDsC3                            const likeds( dsPahec3V2_t )

     D   k1yec3        ds                  likerec( p1hec3 : *key )
     D   @@DsOC3       ds                  likerec( p1hec3 : *output )

      /free

       SPVSPO_inz();

       k1yec3.c3empr = peDsC3.c3empr;
       k1yec3.c3sucu = peDsC3.c3sucu;
       k1yec3.c3arcd = peDsC3.c3arcd;
       k1yec3.c3spol = peDsC3.c3spol;
       k1yec3.c3sspo = peDsC3.c3sspo;
       chain %kds( k1yec3 : 5 ) pahec3;
       if not %found( pahec3 );
         return *off;
       endif;

       eval-corr @@DsOC3 = peDsC3;
       monitor;
         update p1hec3 @@DsOC3;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P  SPVSPO_updPlanDePago...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_getPahcd6(): Cuotas pagadas                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento             ( opcional )   *
      *     peRama   (input)   Rama                   ( opcional )   *
      *     peArse   (input)   Cantidad de Polizas    ( opcional )   *
      *     peOper   (input)   Operacion              ( opcional )   *
      *     peSuop   (input)   Suplemento             ( opcional )   *
      *     peNrcu   (input)   Numero de Cuota        ( opcional )   *
      *     peNrsc   (input)   Numero de SubCuota     ( opcional )   *
      *     pePsec   (input)   Secuencia de pago      ( opcional )   *
      *     peDsCd6  (output)  Estructura Cuotas      ( opcional )   *
      *     peDsCd6C (output)  Cantidad de Cuotas     ( opcional )   *
      *                                                              *
      * Retorna: *On = Encontró / *Off = No Encontró                 *
      * ------------------------------------------------------------ *
     P SPVSPO_getPahcd6...
     P                 b                   export
     D SPVSPO_getPahcd6...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *nopass : *omit )
     D   peRama                       2  0 const options( *nopass : *omit )
     D   peArse                       2  0 const options( *nopass : *omit )
     D   peOper                       7  0 const options( *nopass : *omit )
     D   peSuop                       3  0 const options( *nopass : *omit )
     D   peNrcu                       2  0 const options( *nopass : *omit )
     D   peNrsc                       2  0 const options( *nopass : *omit )
     D   pePsec                       2  0 const options( *nopass : *omit )
     D   peDsCd6                           likeds( dsPahcd6_t )
     D                                     options( *nopass: *omit ) dim(999)
     D   peDsCd6C                    10i 0 options( *nopass: *omit )

     D   k1ycd6        ds                  likerec( p1hcd6 : *key )
     D   @@DsCd6       ds                  likeds( dsPahcd6_t ) dim(999)
     D   @@DsCd6C      s             10i 0
     D   @@DsICd6      ds                  likerec( p1hcd6 : *input )

      /free

       SPVSPO_inz();

       k1ycd6.d6empr =  peEmpr;
       k1ycd6.d6sucu =  peSucu;
       k1ycd6.d6arcd =  peArcd;
       k1ycd6.d6spol =  peSpol;

       if %parms >= 5;
          Select;
            when  %addr( peSspo ) <> *null and
                  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peOper ) <> *null and
                  %addr( peSuop ) <> *null and
                  %addr( peNrcu ) <> *null and
                  %addr( peNrsc ) <> *null and
                  %addr( pePsec ) <> *null ;

                  k1ycd6.d6sspo = peSspo;
                  k1ycd6.d6rama = peRama;
                  k1ycd6.d6arse = peArse;
                  k1ycd6.d6oper = peOper;
                  k1ycd6.d6suop = peSuop;
                  k1ycd6.d6nrcu = peNrcu;
                  k1ycd6.d6nrsc = peNrsc;
                  k1ycd6.d6psec = pePsec;
                  setll %kds( k1ycd6 : 12 ) pahcd6;
                  reade %kds( k1ycd6 : 12 ) pahcd6 @@DsICd6;
                    dow not %eof( pahcd6 );
                      @@DsCd6C += 1;
                      eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
                    reade %kds( k1ycd6 : 12 ) pahcd6 @@DsICd6;
                   enddo;

            when  %addr( peSspo ) <> *null and
                  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peOper ) <> *null and
                  %addr( peSuop ) <> *null and
                  %addr( peNrcu ) <> *null and
                  %addr( peNrsc ) <> *null and
                  %addr( pePsec ) =  *null ;

                  k1ycd6.d6sspo = peSspo;
                  k1ycd6.d6rama = peRama;
                  k1ycd6.d6arse = peArse;
                  k1ycd6.d6oper = peOper;
                  k1ycd6.d6suop = peSuop;
                  k1ycd6.d6nrcu = peNrcu;
                  k1ycd6.d6nrsc = peNrsc;
                  setll %kds( k1ycd6 : 11 ) pahcd6;
                  reade %kds( k1ycd6 : 11 ) pahcd6 @@DsICd6;
                    dow not %eof( pahcd6 );
                      @@DsCd6C += 1;
                      eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
                    reade %kds( k1ycd6 : 11 ) pahcd6 @@DsICd6;
                   enddo;

            when  %addr( peSspo ) <> *null and
                  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peOper ) <> *null and
                  %addr( peSuop ) <> *null and
                  %addr( peNrcu ) <> *null and
                  %addr( peNrsc ) =  *null and
                  %addr( pePsec ) =  *null ;

                  k1ycd6.d6sspo = peSspo;
                  k1ycd6.d6rama = peRama;
                  k1ycd6.d6arse = peArse;
                  k1ycd6.d6oper = peOper;
                  k1ycd6.d6suop = peSuop;
                  k1ycd6.d6nrcu = peNrcu;
                  setll %kds( k1ycd6 : 10 ) pahcd6;
                  reade %kds( k1ycd6 : 10 ) pahcd6 @@DsICd6;
                    dow not %eof( pahcd6 );
                      @@DsCd6C += 1;
                      eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
                    reade %kds( k1ycd6 : 10 ) pahcd6 @@DsICd6;
                   enddo;

            when  %addr( peSspo ) <> *null and
                  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peOper ) <> *null and
                  %addr( peSuop ) <> *null and
                  %addr( peNrcu ) =  *null and
                  %addr( peNrsc ) =  *null and
                  %addr( pePsec ) =  *null ;

                  k1ycd6.d6sspo = peSspo;
                  k1ycd6.d6rama = peRama;
                  k1ycd6.d6arse = peArse;
                  k1ycd6.d6oper = peOper;
                  k1ycd6.d6suop = peSuop;
                  setll %kds( k1ycd6 : 9 ) pahcd6;
                  reade %kds( k1ycd6 : 9 ) pahcd6 @@DsICd6;
                    dow not %eof( pahcd6 );
                      @@DsCd6C += 1;
                      eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
                    reade %kds( k1ycd6 : 9 ) pahcd6 @@DsICd6;
                   enddo;

            when  %addr( peSspo ) <> *null and
                  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peOper ) <> *null and
                  %addr( peSuop ) =  *null and
                  %addr( peNrcu ) =  *null and
                  %addr( peNrsc ) =  *null and
                  %addr( pePsec ) =  *null ;

                  k1ycd6.d6sspo = peSspo;
                  k1ycd6.d6rama = peRama;
                  k1ycd6.d6arse = peArse;
                  k1ycd6.d6oper = peOper;
                  setll %kds( k1ycd6 : 8 ) pahcd6;
                  reade %kds( k1ycd6 : 8 ) pahcd6 @@DsICd6;
                    dow not %eof( pahcd6 );
                      @@DsCd6C += 1;
                      eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
                    reade %kds( k1ycd6 : 8 ) pahcd6 @@DsICd6;
                   enddo;

            when  %addr( peSspo ) <> *null and
                  %addr( peRama ) <> *null and
                  %addr( peArse ) <> *null and
                  %addr( peOper ) =  *null and
                  %addr( peSuop ) =  *null and
                  %addr( peNrcu ) =  *null and
                  %addr( peNrsc ) =  *null and
                  %addr( pePsec ) =  *null ;

                  k1ycd6.d6sspo = peSspo;
                  k1ycd6.d6rama = peRama;
                  k1ycd6.d6arse = peArse;
                  setll %kds( k1ycd6 : 7 ) pahcd6;
                  reade %kds( k1ycd6 : 7 ) pahcd6 @@DsICd6;
                    dow not %eof( pahcd6 );
                      @@DsCd6C += 1;
                      eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
                    reade %kds( k1ycd6 : 7 ) pahcd6 @@DsICd6;
                   enddo;

            when  %addr( peSspo ) <> *null and
                  %addr( peRama ) <> *null and
                  %addr( peArse ) =  *null and
                  %addr( peOper ) =  *null and
                  %addr( peSuop ) =  *null and
                  %addr( peNrcu ) =  *null and
                  %addr( peNrsc ) =  *null and
                  %addr( pePsec ) =  *null ;

                  k1ycd6.d6sspo = peSspo;
                  k1ycd6.d6rama = peRama;
                  setll %kds( k1ycd6 : 6 ) pahcd6;
                  reade %kds( k1ycd6 : 6 ) pahcd6 @@DsICd6;
                    dow not %eof( pahcd6 );
                      @@DsCd6C += 1;
                      eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
                    reade %kds( k1ycd6 : 6 ) pahcd6 @@DsICd6;
                   enddo;

            when  %addr( peSspo ) <> *null and
                  %addr( peRama ) =  *null and
                  %addr( peArse ) =  *null and
                  %addr( peOper ) =  *null and
                  %addr( peSuop ) =  *null and
                  %addr( peNrcu ) =  *null and
                  %addr( peNrsc ) =  *null and
                  %addr( pePsec ) =  *null ;

                  k1ycd6.d6sspo = peSspo;
                  setll %kds( k1ycd6 : 5 ) pahcd6;
                  reade %kds( k1ycd6 : 5 ) pahcd6 @@DsICd6;
                    dow not %eof( pahcd6 );
                      @@DsCd6C += 1;
                      eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
                    reade %kds( k1ycd6 : 5 ) pahcd6 @@DsICd6;
                   enddo;

            other;
               setll %kds( k1ycd6 : 4 ) pahcd6;
               reade %kds( k1ycd6 : 4 ) pahcd6 @@DsICd6;
               dow not %eof( pahcd6 );
                 @@DsCd6C += 1;
                 eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
                reade %kds( k1ycd6 : 4 ) pahcd6 @@DsICd6;
               enddo;
          endsl;
       else;
          setll %kds( k1ycd6 : 4 ) pahcd6;
          reade %kds( k1ycd6 : 4 ) pahcd6 @@DsICd6;
          dow not %eof( pahcd6 );
            @@DsCd6C += 1;
            eval-corr @@DsCd6( @@DsCd6C ) = @@DsICd6;
           reade %kds( k1ycd6 : 4 ) pahcd6 @@DsICd6;
          enddo;
       endif;

       if %addr( peDsCd6 ) <> *null;
          eval-corr peDsCd6 = @@DsCd6;
       endif;

       if %addr( peDsCd6C ) <> *null;
          peDsCd6C = @@DsCd6C;
       endif;

       if @@dsCd6C = 0;
          return *off;
       endif;

       return *on;
      /end-free

     P SPVSPO_getPahcd6...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_chkPahcd6(): Valida si cuota esta paga                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cantidad de Polizas                   *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento                            *
      *     peNrcu   (input)   Numero de Cuota                       *
      *     peNrsc   (input)   Numero de SubCuota                    *
      *     pePsec   (input)   Nro. de Secuencia                     *
      *                                                              *
      * Retorna: *On = Encontró / *Off = No Encontró                 *
      * ------------------------------------------------------------ *
     P SPVSPO_chkPahcd6...
     P                 b                   export
     D SPVSPO_chkPahcd6...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   pePsec                       2  0 const

     D   k1ycd6        ds                  likerec( p1hcd6 : *key )

      /free

       SPVSPO_inz();

       k1ycd6.d6empr = peEmpr;
       k1ycd6.d6sucu = peSucu;
       k1ycd6.d6arcd = peArcd;
       k1ycd6.d6spol = peSpol;
       k1ycd6.d6sspo = peSspo;
       k1ycd6.d6rama = peRama;
       k1ycd6.d6arse = peArse;
       k1ycd6.d6oper = peOper;
       k1ycd6.d6suop = peSuop;
       k1ycd6.d6nrcu = peNrcu;
       k1ycd6.d6nrsc = peNrsc;
       k1ycd6.d6Psec = pePsec;
       setll %kds( k1ycd6 : 12 ) pahcd6;
       return %equal( pahcd6 );

      /end-free

     P SPVSPO_chkPahcd6...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPahcd6: Graba Pagos de cuotas                      *
     ?*                                                              *
     ?*     peDsD6  (  input  )  Estructura de Pahcd6                *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setPahcd6...
     P                 b                   export
     D  SPVSPO_setPahcd6...
     D                 pi              n
     D   peDsD6                            likeds( dsPahcd6_t ) const

     D   @@DsOD6       ds                  likerec( p1hcd6 : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkPahcd6( peDsD6.d6Empr
                          : peDsD6.d6Sucu
                          : peDsD6.d6Arcd
                          : peDsD6.d6Spol
                          : peDsD6.d6Sspo
                          : peDsD6.d6Rama
                          : peDsD6.d6Arse
                          : peDsD6.d6Oper
                          : peDsD6.d6Suop
                          : peDsD6.d6Nrcu
                          : peDsD6.d6Nrsc
                          : peDsD6.d6Psec );
         return *off;
       endif;

       eval-corr @@DsOD6 = peDsD6;
       monitor;
         write p1hcd6 @@DsOD6;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P  SPVSPO_setPahcd6...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getUltSecuncia: Retorna ultima Secuencia de Pago      *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Artículo                            *
     ?*     peSpol  (  input  )  SuperPoliza                         *
     ?*     peSspo  (  input  )  Suplemento de la Superpoliza        *
     ?*     peRama  (  input  )  Código de Rama                      *
     ?*     peArse  (  input  )  Cant. Pólizas por Rama/Art          *
     ?*     peOper  (  input  )  Operación                           *
     ?*     peSuop  (  input  )  Suplemento de la Operación          *
     ?*     peNrcu  (  input  )  Número de Cuota                     *
     ?*                                                              *
     ?* Retorna: Secuencia                                           *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_getUltSecuncia...
     P                 b                   export
     D  SPVSPO_getUltSecuncia...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peNrcu                       2  0 const

     D   k1ycd6        ds                  likerec( p1hcd6 : *key )

      /free

       SPVSPO_inz();

       k1ycd6.d6Empr = peEmpr;
       k1ycd6.d6Sucu = peSucu;
       k1ycd6.d6Arcd = peArcd;
       k1ycd6.d6Spol = peSpol;
       k1ycd6.d6Sspo = peSspo;
       k1ycd6.d6Rama = peRama;
       k1ycd6.d6Arse = peArse;
       k1ycd6.d6Oper = peOper;
       k1ycd6.d6Suop = peSuop;
       k1ycd6.d6Nrcu = peNrcu;
       setgt     %kds( k1ycd6 : 10 ) pahcd6;
       readpe(n) %kds( k1ycd6 : 10 ) pahcd6;
       if %eof( pahcd6 );
         return *zeros;
       endif;

       return d6psec;

      /end-free

     P  SPVSPO_getUltSecuncia...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getPahcc2: Retorna datos del PAHCC2                   *
     ?* "DEPRECATED" Se debe utilizar SPVSPO_getPahcc2V2()           *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento de SuperPoliza (opcional) *
     ?*     peNrcu   ( input  ) Número de cuotas          (opcional) *
     ?*     peDsC2   ( output ) Esrtuctura de Cabecera Sup(opcional) *
     ?*     peDsC2C  ( output ) Cantidad de Cabecera Sup  (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SPVSPO_getPahcc2...
     P                 B                   export
     D SPVSPO_getPahcc2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )const
     D   peNrcu                       2  0 options( *nopass : *omit )const
     D   peDsC2                            likeds ( dsPahcc2_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsC2C                     10i 0 options( *nopass : *omit )

     D   k1yec2        ds                  likerec( p1hcc2 : *key   )
     D   @@DsIC2       ds                  likerec( p1hcc2 : *input )
     D   @@DsC2        ds                  likeds ( dsPahcc2_t ) dim( 999 )
     D   @@DsC2C       s             10i 0

      /free

       SPVSPO_inz();

       clear @@DsC2;
       @@DsC2C = 0;

       if not SPVSPO_getPahcc2V2( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol
                                : peSspo
                                : peNrcu
                                : *omit
                                : @@DsC2
                                : @@DsC2C );
         return *off;
       endif;

       if %addr( peDsC2 ) <> *null;
         eval-corr peDsC2 = @@DsC2;
       endif;

       if %addr( peDsC2C ) <> *null;
         peDsC2C = @@DsC2C;
       endif;

       return *on;

      /end-free

     P SPVSPO_getPahcc2...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkPahcc3: Valida si existe Pago                      *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Artículo                            *
     ?*     peSpol  (  input  )  SuperPoliza                         *
     ?*     peSspo  (  input  )  Suplemento de la Superpoliza        *
     ?*     peNrcu  (  input  )  Número de Cuota                     *
     ?*     peNrsc  (  input  )  Número de Subcuota                  *
     ?*     pePsec  (  input  )  Nro. de Secuencia                   *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkPahcc3...
     P                 b                   export
     D  SPVSPO_chkPahcc3...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   pePsec                       2  0 const

     D   k1ycc3        ds                  likerec( p1hcc3 : *key )

      /free

       SPVSPO_inz();

       k1ycc3.c3Empr = peEmpr;
       k1ycc3.c3Sucu = peSucu;
       k1ycc3.c3Arcd = peArcd;
       k1ycc3.c3Spol = peSpol;
       k1ycc3.c3Sspo = peSspo;
       k1ycc3.c3Nrcu = peNrcu;
       k1ycc3.c3Nrsc = peNrsc;
       k1ycc3.c3Psec = pePsec;
       setll %kds( k1ycc3 : 8 ) pahcc3;
       return %equal;

      /end-free

     P  SPVSPO_chkPahcc3...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPahcc3: Graba Pagos de cuotas                      *
     ?*                                                              *
     ?*     peDsC3  (  input  )  Estructura de Pahcd6                *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setPahcc3...
     P                 b                   export
     D  SPVSPO_setPahcc3...
     D                 pi              n
     D   peDsC3                            likeds( dsPahcc3_t ) const

     D   @@DsOC3       ds                  likerec( p1hcc3 : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkPahcc3( peDsC3.c3Empr
                          : peDsC3.c3Sucu
                          : peDsC3.c3Arcd
                          : peDsC3.c3Spol
                          : peDsC3.c3Sspo
                          : peDsC3.c3Nrcu
                          : peDsC3.c3Nrsc
                          : peDsC3.c3Psec );
         return *off;
       endif;

       eval-corr @@DsOC3 = peDsC3;
       monitor;
         write p1hcc3 @@DsOC3;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P  SPVSPO_setPahcc3...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_chkPahcd7: Valida si existe Gasto de Cobranza         *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peNras  (  input  )  Número de Asiento                   *
     ?*     peC4se  (  input  )  Secuencia 1 de Cobranza             *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_chkPahcd7...
     P                 b                   export
     D  SPVSPO_chkPahcd7...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNras                       6  0 const
     D   peC4se                       5  0 const

     D   k1ycd7        ds                  likerec( p1hcd7 : *key )

      /free

       SPVSPO_inz();

       k1ycd7.d7Empr = peEmpr;
       k1ycd7.d7Sucu = peSucu;
       k1ycd7.d7Nras = peNras;
       k1ycd7.d7C4se = peC4se;
       setll %kds( k1ycd7 : 4 ) pahcd7;
       return %equal;

      /end-free

     P  SPVSPO_chkPahcd7...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPahcd7: Graba Gasto de Cobranza                    *
     ?*                                                              *
     ?*     peDsD7  (  input  )  Estructura de Pahcd7                *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_setPahcd7...
     P                 b                   export
     D  SPVSPO_setPahcd7...
     D                 pi              n
     D   peDsD7                            likeds( dsPahcd7_t ) const

     D   @@DsOD7       ds                  likerec( p1hcd7 : *output )

      /free

       SPVSPO_inz();

       if SPVSPO_chkPahcd7( peDsD7.d7Empr
                          : peDsD7.d7Sucu
                          : peDsD7.d7Nras
                          : peDsD7.d7C4se );
         return *off;
       endif;

       eval-corr @@DsOD7 = peDsD7;
       monitor;
         write p1hcd7 @@DsOD7;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P  SPVSPO_setPahcd7...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_UltSecCobPagoProc: Retorna Ult Secuencia de Pago en   *
     ?*                           proceso                            *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peNras  (  input  )  Número de Asiento                   *
     ?*                                                              *
     ?* Retorna: Secuencia 1 de Cobranza                             *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_UltSecCobPagoProc...
     P                 b                   export
     D  SPVSPO_UltSecCobPagoProc...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNras                       6  0 const

     D   k1yc302       ds                  likerec( p1hcc302 : *key )

      /free

       SPVSPO_inz();

       k1yc302.c3Empr = peEmpr;
       k1yc302.c3Sucu = peSucu;
       k1yc302.c3Nras = peNras;

       setgt     %kds( k1yc302 : 3 ) pahcc302;
       readpe(n) %kds( k1yc302 : 3 ) pahcc302;
       if %eof( pahcc302 );
         return *zeros;
       endif;

       return c3c4se;

      /end-free

     P  SPVSPO_UltSecCobPagoProc...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_UltSecuenciaPagos: Retorna Ult Secuencia de Pago en   *
     ?*                           proceso                            *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Artículo                            *
     ?*     peSpol  (  input  )  Superpoliza                         *
     ?*     peSspo  (  input  )  Suplemento de la Superpoliza        *
     ?*     peNrcu  (  input  )  Número de Cuotas                    *
     ?*     peNrsc  (  input  )  Número de SubCuotas                 *
     ?*                                                              *
     ?* Retorna: Secuencia                                           *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_UltSecuenciaPagos...
     P                 b                   export
     D  SPVSPO_UltSecuenciaPagos...
     D                 pi             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )const
     D   peNrcu                       2  0 options( *nopass : *omit )const
     D   peNrsc                       2  0 options( *nopass : *omit )const

     D   k1ycc3        ds                  likerec( p1hcc3 : *key )

      /free

       SPVSPO_inz();

       k1ycc3.c3Empr = peEmpr;
       k1ycc3.c3Sucu = peSucu;
       k1ycc3.c3Arcd = peArcd;
       k1ycc3.c3Spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peNrcu ) <> *null and
                %addr( peNrsc ) <> *null;

              k1ycc3.c3Sspo = peSspo;
              k1ycc3.c3Nrcu = peNrcu;
              k1ycc3.c3Nrsc = peNrsc;
              setgt     %kds( k1ycc3 : 7 ) pahcc3;
              readpe(n) %kds( k1ycc3 : 7 ) pahcc3;
              if %eof( pahcc3 );
                return *zeros;
              endif;

              return c3psec;

           when %addr( peSspo ) <> *null and
                %addr( peNrcu ) <> *null and
                %addr( peNrsc ) =  *null;

              k1ycc3.c3Sspo = peSspo;
              k1ycc3.c3Nrcu = peNrcu;
              setgt     %kds( k1ycc3 : 6 ) pahcc3;
              readpe(n) %kds( k1ycc3 : 6 ) pahcc3;
              if %eof( pahcc3 );
                return *zeros;
              endif;

              return c3psec;

           when %addr( peSspo ) <> *null and
                %addr( peNrcu ) =  *null and
                %addr( peNrsc ) =  *null;

              k1ycc3.c3Sspo = peSspo;
              setgt     %kds( k1ycc3 : 5 ) pahcc3;
              readpe(n) %kds( k1ycc3 : 5 ) pahcc3;
              if %eof( pahcc3 );
                return *zeros;
              endif;

              return c3psec;

           other;
              setgt     %kds( k1ycc3 : 4 ) pahcc3;
              readpe(n) %kds( k1ycc3 : 4 ) pahcc3;
              if %eof( pahcc3 );
                return *zeros;
              endif;

              return c3psec;

         endsl;
       else;
         setgt     %kds( k1ycc3 : 4 ) pahcc3;
         readpe(n) %kds( k1ycc3 : 4 ) pahcc3;
         if %eof( pahcc3 );
           return *zeros;
         endif;

         return c3psec;
       endif;

       return *zeros;

      /end-free

     P  SPVSPO_UltSecuenciaPagos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_UltSecCobranza: Retorna ultima Secuencia 1 de Cobranza*
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peNras  (  input  )  Nro. de Asiento                     *
     ?*                                                              *
     ?* Retorna: Secuencia                                           *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_UltSecCobranza...
     P                 b                   export
     D  SPVSPO_UltSecCobranza...
     D                 pi             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNras                       6  0 const

     D   k1ycd7        ds                  likerec( p1hcd7 : *key )

      /free

       SPVSPO_inz();

       k1ycd7.d7Empr = peEmpr;
       k1ycd7.d7Sucu = peSucu;
       k1ycd7.d7Nras = peNras;
       setgt     %kds( k1ycd7 : 3 ) pahcd7;
       readpe(n) %kds( k1ycd7 : 3 ) pahcd7;
       if %eof( pahcd7 );
         return *zeros;
       endif;

       return d7C4se;

      /end-free

     P  SPVSPO_UltSecCobranza...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getDiferenciaGA : Retorna diferencia del genera       *
     ?*                          Asiento                             *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peGens  (  input  )  Gen.Asi.Nro de Sistema              *
     ?*     peGess  (  input  )  Gen.Asi.Secuencia                   *
     ?*     peDife  (  input  )  Diferencia                          *
     ?*     peDimp  (  input  )  Importe Min.Dife.Aplic.Web          *
     ?*     peGcmg  (  output )  Cob.WEB.Cta.Mayor          (Opc.)   *
     ?*     peComa  (  output )  Código de Mayor Auxiliar   (Opc.)   *
     ?*     peGcma  (  output )  Gen.Asi.Cta.Mayor Auxiliar (Opc.)   *
     ?*     peCopt  (  output )  Concepto de Asiento        (Opc.)   *
     ?*                                                              *
     ?* Retorna: diferencia                                          *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_getDiferenciaGA...
     P                 b                   export
     D  SPVSPO_getDiferenciaGA...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peGens                       3  0 const
     D   peGess                       2  0 const
     D   peDife                      15  2 const
     D   peDimp                      15  2 const
     D   peGcmg                      11    options( *nopass : *omit )
     D   peComa                       2    options( *nopass : *omit )
     D   peGcma                       7    options( *nopass : *omit )
     D   peCopt                      25    options( *nopass : *omit )

     D   k1ytge        ds                  likerec( g1ttge : *key )

     D @@Dife          s             15  2
     D @@Gcmg          s             11a
     D @@Coma          s              2a
     D @@Gcma          s              7a
     D @@Copt          s             25a
     D dsCopt          s             25a
     D es_nega         s               n

      /free

       SPVSPO_inz();

       @@Dife = *zeros;
       @@Gcmg = *zeros;
       @@Coma = *blanks;
       @@Gcma = *zeros;
       @@Copt = *blanks;
       dsCopt = *blanks;

       if peDife <> *zeros;
         if peDife < *zeros;
           @@Dife = @@Dife * -1;
           es_nega = *on;
         else;
           @@Dife = peDife;
         endif;

         k1ytge.tgEmpr = peEmpr;
         k1ytge.tgSuc2 = peSucu;
         k1ytge.tgGens = peGens;
         k1ytge.tgGess = peGess;

         select;
           when @@Dife  > 0 and @@Dife <= peDimp;
             k1ytge.tgGecv = '1';
             chain(n) %kds( k1ytge : 5 ) gnttge;
             if %found( gnttge );
               if tgGcmg <> *blanks;
                 @@Gcmg = tgGcmg;
               endif;
               if tgComa <> *blanks;
                 @@Coma = tgComa;
                 @@gcma = tgGcma;
               endif;
               @@Copt = tgCopt;
             endif;

           when @@Dife > peDimp;
             k1ytge.tgGecv = '2';
             chain(n) %kds( k1ytge : 5 ) gnttge;
             if %found(gnttge);
               if tgGcmg <> *blanks;
                 @@Gcmg = tgGcmg;
               endif;
               if tgComa <> *blanks;
                 @@Coma = tgComa;
                 @@Gcma = tgGcma;
               endif;
               @@Copt = dsCopt;
             endif;
         endsl;

         if es_nega = *on;
           @@Dife = @@Dife * -1;
         endif;
       endif;

       if %addr( peGcmg ) <> *null;
         peGcmg = @@Gcmg;
       endif;

       if %addr( peComa ) <> *null;
         peComa = @@Coma;
       endif;

       if %addr( peGcma ) <> *null;
         peGcma = @@Gcma;
       endif;

       if %addr( peCopt ) <> *null;
         peCopt = @@Copt;
       endif;

       return @@Dife;

      /end-free

     P  SPVSPO_getDiferenciaGA...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_UltSecCobrProc: Retorna ultima Secuencia 1 de Cobranza*
     ?*                        en proceso                            *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peNras  (  input  )  Nro. de Asiento                     *
     ?*                                                              *
     ?* Retorna: Secuencia                                           *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_UltSecCobrProc...
     P                 b                   export
     D  SPVSPO_UltSecCobrProc...
     D                 pi             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNras                       6  0 const

     D   k1ycd6        ds                  likerec( p1hcd602 : *key )

      /free

       SPVSPO_inz();

       k1ycd6.d6Empr = peEmpr;
       k1ycd6.d6Sucu = peSucu;
       k1ycd6.d6Nras = peNras;
       setgt     %kds( k1ycd6 : 3 ) pahcd602;
       readpe(n) %kds( k1ycd6 : 3 ) pahcd602;
       if %eof( pahcd602 );
         return *zeros;
       endif;

       return d6C4se;

      /end-free

     P  SPVSPO_UltSecCobrProc...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_updPahcd5: Actualiza Cuotas Emitidas                  *
     ?*                                                              *
     ?*     peDsD5  (  input  )  Estructura de Pahcd5                *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_updPahcd5...
     P                 b                   export
     D  SPVSPO_updPahcd5...
     D                 pi              n
     D   peDsD5                            likeds( dsPahcd5_t ) const

     D k1ycd5          ds                  likerec( p1hcd5 : *key )
     D @@DsOD5         ds                  likerec( p1hcd5 : *output )

      /free

       SPVSPO_inz();

       k1ycd5.d5Empr = peDsD5.d5Empr;
       k1ycd5.d5Sucu = peDsD5.d5Sucu;
       k1ycd5.d5Arcd = peDsD5.d5Arcd;
       k1ycd5.d5Spol = peDsD5.d5Spol;
       k1ycd5.d5Sspo = peDsD5.d5Sspo;
       k1ycd5.d5Rama = peDsD5.d5Rama;
       k1ycd5.d5Arse = peDsD5.d5Arse;
       k1ycd5.d5Oper = peDsD5.d5Oper;
       k1ycd5.d5Suop = peDsD5.d5Suop;
       k1ycd5.d5Nrcu = peDsD5.d5Nrcu;
       k1ycd5.d5Nrsc = peDsD5.d5Nrsc;
       chain %kds( k1ycd5 : 11 ) pahcd5;
       if %found( pahcd5 );
         eval-corr @@DsOD5 = peDsD5;
         update p1hcd5 @@DsOD5;
         return *on;
       endif;

       return *off;

      /end-free

     P  SPVSPO_updPahcd5...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_updPahcc2: Actualiza Cuotas                           *
     ?*                                                              *
     ?*     peDsC2  (  input  )  Estructura de Pahcc2                *
     ?*                                                              *
     ?* Retorna: *on = Actualizo / *off = No Actualizo               *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_updPahcc2...
     P                 b                   export
     D  SPVSPO_updPahcc2...
     D                 pi              n
     D   peDsC2                            likeds( dsPahcc2_t ) const

     D k1ycc2          ds                  likerec( p1hcc2 : *key )
     D @@DsOC2         ds                  likerec( p1hcc2 : *output )

      /free

       SPVSPO_inz();

       k1ycc2.c2Empr = peDsC2.c2Empr;
       k1ycc2.c2Sucu = peDsC2.c2Sucu;
       k1ycc2.c2Arcd = peDsC2.c2Arcd;
       k1ycc2.c2Spol = peDsC2.c2Spol;
       k1ycc2.c2Sspo = peDsC2.c2Sspo;
       k1ycc2.c2Nrcu = peDsC2.c2Nrcu;
       k1ycc2.c2Nrsc = peDsC2.c2Nrsc;
       chain %kds( k1ycc2 : 7 ) pahcc2;
       if %found( pahcc2 );
         eval-corr @@DsOC2 = peDsC2;
         update p1hcc2 @@DsOC2;
         return *on;
       endif;

       return *off;

      /end-free

     P  SPVSPO_updPahcc2...
     P                 e

      * ------------------------------------------------------------ *
      * SPVSPO_getFechaAnualidad(): Retorna fecha Anual Desde/Hasta  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento de la Superpoliza          *
      *     peFecd   (output)  Fecha Desde                           *
      *     peFech   (output)  Fecha Hasta                           *
      *                                                              *
      * Retorna: Fec. Desde/Hasta (AAAAMMDD)                         *
      * ------------------------------------------------------------ *
     P SPVSPO_getFechaAnualidad...
     P                 B                   export
     D SPVSPO_getFechaAnualidad...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*Omit:*Nopass) const
     D   peFecd                       8  0 options(*Omit:*Nopass)
     D   peFech                       8  0 options(*Omit:*Nopass)

     D k1yed0          ds                  likerec(p1hed0:*key)

      /free

       SPVSPO_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;

       if %parms >= 5 and %addr ( peSspo ) <> *Null;
         k1yed0.d0sspo = peSspo;
         setll %kds( k1yed0 : 5 ) pahed0;
         reade %kds( k1yed0 : 5 ) pahed0;
       else;
         setll %kds( k1yed0 : 4 ) pahed0;
         reade %kds( k1yed0 : 4 ) pahed0;
       endif;

       if %eof ( pahed0 );

         if %parms >= 6 and %addr ( peFecd ) <> *Null;
           peFecd = *Zeros;
         endif;

         if %parms >= 7 and %addr ( peFech ) <> *Null;
           peFech = *Zeros;
         endif;

         return *Off;

       endif;

       if %parms >= 5 and %addr ( peFecd ) <> *Null;
         peFecd = d0fioa * 10000 + d0fiom * 100 + d0fiod;
       endif;

       if %parms >= 6 and %addr ( peFech ) <> *Null;
         peFech = d0fvoa * 10000 + d0fvom * 100 + d0fvod;
         if peFech = 99999999;
           peFech = d0fvaa * 10000 + d0fvam * 100 + d0fvad;
         endif;
       endif;

       return *On;

      /end-free

     P SPVSPO_getFechaAnualidad...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getPahcc2V2: Retorna datos del PAHCC2                 *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento de SuperPoliza (opcional) *
     ?*     peNrcu   ( input  ) Número de cuotas          (opcional) *
     ?*     peNrsc   ( input  ) Número de subcuota        (opcional) *
     ?*     peDsC2   ( output ) Esrtuctura de Cabecera Sup(opcional) *
     ?*     peDsC2C  ( output ) Cantidad de Cabecera Sup  (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SPVSPO_getPahcc2V2...
     P                 B                   export
     D SPVSPO_getPahcc2V2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )const
     D   peNrcu                       2  0 options( *nopass : *omit )const
     D   peNrsc                       2  0 options( *nopass : *omit )const
     D   peDsC2                            likeds ( dsPahcc2_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsC2C                     10i 0 options( *nopass : *omit )

     D   k1yec2        ds                  likerec( p1hcc2 : *key   )
     D   @@DsIC2       ds                  likerec( p1hcc2 : *input )
     D   @@DsC2        ds                  likeds ( dsPahcc2_t ) dim( 999 )
     D   @@DsC2C       s             10i 0

      /free

       SPVSPO_inz();

       clear @@DsC2;
       @@DsC2C = 0;

       k1yec2.c2empr = peEmpr;
       k1yec2.c2sucu = peSucu;
       k1yec2.c2arcd = peArcd;
       k1yec2.c2spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peNrcu ) <> *null and
                %addr( peNrsc ) <> *null;

              k1yec2.c2Sspo = peSspo;
              k1yec2.c2Nrcu = peNrcu;
              k1yec2.c2Nrsc = peNrsc;
              setll %kds( k1yec2 : 7 ) pahcc2;
              if not %equal( pahcc2 );
                return *off;
              endif;
              reade(n) %kds( k1yec2 : 7 ) pahcc2 @@DsIC2;
              dow not %eof( pahcc2 );
                @@DsC2C += 1;
                eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
               reade(n) %kds( k1yec2 : 7 ) pahcc2 @@DsIC2;
              enddo;

           when %addr( peSspo ) <> *null and
                %addr( peNrcu ) <> *null and
                %addr( peNrsc ) =  *null;

              k1yec2.c2Sspo = peSspo;
              k1yec2.c2Nrcu = peNrcu;
              setll %kds( k1yec2 : 6 ) pahcc2;
              if not %equal( pahcc2 );
                return *off;
              endif;
              reade(n) %kds( k1yec2 : 6 ) pahcc2 @@DsIC2;
              dow not %eof( pahcc2 );
                @@DsC2C += 1;
                eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
               reade(n) %kds( k1yec2 : 6 ) pahcc2 @@DsIC2;
              enddo;

           when %addr( peSspo ) <> *null and
                %addr( peNrcu ) =  *null and
                %addr( peNrsc ) =  *null;

              k1yec2.c2Sspo = peSspo;
              setll %kds( k1yec2 : 5 ) pahcc2;
              if not %equal( pahcc2 );
                return *off;
              endif;
              reade(n) %kds( k1yec2 : 5 ) pahcc2 @@DsIC2;
              dow not %eof( pahcc2 );
                @@DsC2C += 1;
                eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
               reade(n) %kds( k1yec2 : 5 ) pahcc2 @@DsIC2;
              enddo;

           other;
             setll %kds( k1yec2 : 4 ) pahcc2;
             if not %equal( pahcc2 );
               return *off;
             endif;
             reade(n) %kds( k1yec2 : 4 ) pahcc2 @@DsIC2;
             dow not %eof( pahcc2 );
               @@DsC2C += 1;
               eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
              reade(n) %kds( k1yec2 : 4 ) pahcc2 @@DsIC2;
             enddo;
          endsl;
       else;
         setll %kds( k1yec2 : 4 ) pahcc2;
         if not %equal( pahcc2 );
           return *off;
         endif;
         reade(n) %kds( k1yec2 : 4 ) pahcc2 @@DsIC2;
         dow not %eof( pahcc2 );
           @@DsC2C += 1;
           eval-corr @@DsC2( @@DsC2C ) = @@DsIC2;
          reade(n) %kds( k1yec2 : 4 ) pahcc2 @@DsIC2;
         enddo;
       endif;

       if %addr( peDsC2 ) <> *null;
         eval-corr peDsC2 = @@DsC2;
       endif;

       if %addr( peDsC2C ) <> *null;
         peDsC2C = @@DsC2C;
       endif;

       return *on;

      /end-free

     P SPVSPO_getPahcc2V2...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_anulaArrepEnProceso: Verifica si tiene una anulación  *
      *                             o arrepentimiento en proceso.    *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *                                                              *
      * Retorna: *on = Si tiene / *off = No tiene                    *
      * ------------------------------------------------------------ *
     P SPVSPO_anulaArrepEnProceso...
     P                 B                   export
     D SPVSPO_anulaArrepEnProceso...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1hag4          ds                  likerec(p1hag4:*key)

      /free

       SPVSPO_inz();

       k1hag4.g4empr = peEmpr;
       k1hag4.g4sucu = peSucu;
       k1hag4.g4arcd = peArcd;
       k1hag4.g4spol = peSpol;
       chain(n) %kds(k1hag4:4) pahag404;
       if %found(pahag404);
         if g4mar5 <> '4' and g4Mar5 <> '9';
           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SPVSPO_anulaArrepEnProceso...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_getNroExpediente(): Retorna número de expediente.     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *                                                              *
      * Retorna: p0Expe                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     P SPVSPO_getNroExpediente...
     P                 B                   export
     D SPVSPO_getNroExpediente...
     D                 pi            40
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1yp01          ds                  likerec(s1np01:*key)

      /free

       SPVSPO_inz();

       k1yp01.p0Empr = peEmpr;
       k1yp01.p0Sucu = peSucu;
       k1yp01.p0Arcd = peArcd;
       k1yp01.p0Spol = peSpol;
       chain(n) %kds( k1yp01 : 4 ) ssnp01;
       if %found( ssnp01 );
         return p0Expe;
       endif;

       return *blanks;

      /end-free

     P SPVSPO_getNroExpediente...
     P                 E

      * ------------------------------------------------------------ *
      * SPVSPO_setSsnp04: Graba Log de ejecución SSN                 *
      *                                                              *
      *     peDsP4  (  input  )  Estructura de Ssnp04                *
      *                                                              *
      * Retorna: *on = Grabo ok / *off = No Grabo                    *
      * ------------------------------------------------------------ *
     P  SPVSPO_setSsnp04...
     P                 b                   export
     D  SPVSPO_setSsnp04...
     D                 pi              n
     D   peDsP4                            likeds( dsSsnp04_t ) const

     D   k1yp04        ds                  likerec( s1np04 : *key )
     D   @@DsOP4       ds                  likerec( s1np04 : *output )

      /free

       SPVSPO_inz();

       k1yp04.p0Empr = peDsP4.p0Empr;
       k1yp04.p0Sucu = peDsP4.p0Sucu;
       k1yp04.p0Fech = peDsP4.p0Fech;
       k1yp04.p0Time = peDsP4.p0Time;
       chain(n) %kds( k1yp04 ) ssnp04;
       if %found( ssnp04 );
         return *off;
       endif;

       eval-corr @@DsOP4 = peDsP4;
       monitor;
         write s1np04 @@DsOP4;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P  SPVSPO_setSsnp04...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getIntermediario: Retorna datos de Intermediario      *
     ?*                          de Pahpol.-                         *
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peArcd  (  input  )  Artículo                            *
     ?*     peSpol  (  input  )  SuperPoliza                         *
     ?*     peDsIn  ( output  )  Estructura de Intermediario         *
     ?*     peDsInC ( output  )  Cantidad de Intermediarios          *
     ?*                                                              *
     ?* Retorna: *on = Encuentra / *off = No Encuentra               *
     ?* ------------------------------------------------------------ *
     P  SPVSPO_getIntermediario...
     P                 b                   export
     D  SPVSPO_getIntermediario...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peDsIn                            likeds ( intermediario ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsInC                     10i 0 options( *nopass : *omit )

     D   k1ypol        ds                  likerec( p1hpol : *key )
     D   @@DsIn        ds                  likeds ( intermediario ) dim( 999 )
     D   @@DsInC       s             10i 0

      /free

       SPVSPO_inz();

       clear peDsIn;
       clear peDsInC;
       clear @@DsIn;
       clear @@DsInC;

       k1ypol.poEmpr = peEmpr;
       k1ypol.poSucu = peSucu;
       k1ypol.poArcd = peArcd;
       k1ypol.poSpol = peSpol;

       setll %kds( k1ypol : 4 ) pahpol09;
       if not %equal( pahpol09 );
         return *off;
       endif;

       reade(n) %kds( k1ypol : 4 ) pahpol09;
       dow not %eof( pahpol09 );
         @@DsInC += 1;
         @@DsIn( @@DsInC ).ponivt  = ponivt;
         @@DsIn( @@DsInC ).ponivc  = ponivc;
         reade(n) %kds( k1ypol : 4 ) pahpol09;
       enddo;

       if %addr( @@DsIn ) <> *null;
         eval-corr peDsIn = @@DsIn;
       endif;

       if %addr( @@DsInC ) <> *null;
         eval peDsInC = @@DsInC;
       endif;

       return *on;

      /end-free

     P  SPVSPO_getIntermediario...
     P                 e

