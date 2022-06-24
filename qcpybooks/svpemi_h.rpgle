      /if defined(SVPEMI_H)
      /eof
      /endif
      /define SVPEMI_H

      * Poliza Inexistente...
     D SVPEMI_POLNE    c                   const(0001)

     * - Copy's --------------------------------------------------- *
      /copy './qcpybooks/svpart_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'

     * - Estructura de PAWPC0 ------------------------------------- *
     D dsPawpc0_t      ds                  qualified template
     D   w0empr                       1
     D   w0sucu                       2
     D   w0arcd                       6p 0
     D   w0spo1                       9p 0
     D   w0spol                       9p 0
     D   w0sspo                       3p 0
     D   w0tiou                       1p 0
     D   w0stou                       2p 0
     D   w0stos                       2p 0
     D   w0wp01                       1p 0
     D   w0wp02                       1p 0
     D   w0wp03                       1p 0
     D   w0wp04                       1p 0
     D   w0wp05                       1p 0
     D   w0wp06                       1p 0
     D   w0wp07                       1p 0
     D   w0wp08                       1p 0
     D   w0wp09                       1p 0
     D   w0wp10                       1p 0
     D   w0wp11                       1p 0
     D   w0wp12                       1p 0
     D   w0wp13                       1p 0
     D   w0wp14                       1p 0
     D   w0wp15                       1p 0
     D   w0wipa                       4p 0
     D   w0wipm                       2p 0
     D   w0wipd                       2p 0
     D   w0marp                       1
     D   w0user                      10
     D   w0time                       6p 0
     D   w0date                       6p 0
     D   w0npro                       4p 0
     D   w0soln                       7p 0

     * - Estructura de Importes del Paheg3 ------------------------ *
     D dsImpEg3_t      ds                  qualified template
     D   pro                          2p 0
     D   pri                         15p 2
     D   bon                         15p 2
     D   ref                         15p 2
     D   rea                         15p 2
     D   der                         15p 2
     D   sel                         15p 2
     D   see                         15p 2
     D   per                         15p 2
     D   ib1                         15p 2
     D   ib2                         15p 2
     D   pre                         15p 2
     D   ipr1                        15p 2
     D   ipr3                        15p 2
     D   ipr4                        15p 2
     D   sefr                        15p 2
     D   sefe                        15p 2

     * - Estructura de Importes Totales --------------------------- *
     D dsImpTotales_t  ds                  qualified template
     D   prim                        15p 2
     D   bpri                        15p 2
     D   refi                        15p 2
     D   read                        15p 2
     D   dere                        15p 2
     D   seri                        15p 2
     D   seem                        15p 2
     D   imau                        15p 2
     D   prem                        15p 2
     D   ipr1                        15p 2
     D   ipr2                        15p 2
     D   ipr3                        15p 2
     D   ipr4                        15p 2
     D   ipr5                        15p 2
     D   ipr6                        15p 2
     D   ipr7                        15p 2
     D   ipr8                        15p 2
     D   sefr                        15p 2
     D   sefe                        15p 2
     D   impi                        15p 2
     D   tssn                        15p 2
     D   sers                        15p 2
     D   siva                        15p 2

     * - Estructura de Porcentajes Importes Totales --------------- *
     D dsPorcImp_t     ds                  qualified template
     D   bpip                         5  2
     D   xref                         5  2
     D   xrea                         5  2
     D   pimi                         5  2
     D   pssn                         5  2
     D   psso                         5  2
     D   pivi                         5  2
     D   pivn                         5  2
     D   pivr                         5  2
     D   ivam                        15  2
     D   depp                         5  2
     D   dere                        15  2
     D   tder                         1
     D   bpep                         5  2
     D   vacc                        15  2

     D PAR314E         pr                  extpgm('PAR314E')
     D  empr                          1
     D  sucu                          2
     D  arcd                          6  0
     D  spol                          9  0
     D  sspo                          3  0
     D  rama                          2  0
     D  arse                          2  0
     D  oper                          7  0
     D  suop                          3  0
     D  poco                          4  0
     D  riec                          3
     D  xcob                          3  0
     D  ptco                         15  2
     D  end                           3

     * ------------------------------------------------------------ *
     * SVPEMI_inz(): Inicializa módulo.                             *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPEMI_inz      pr

     * ------------------------------------------------------------ *
     * SVPEMI_End(): Finaliza módulo.                               *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPEMI_End      pr

     * ------------------------------------------------------------ *
     * SVPEMI_Error(): Retorna el último error del service program  *
     *                                                              *
     *     peEnbr   (output)  Número de error (opcional)            *
     *                                                              *
     * Retorna: Mensaje de error.                                   *
     * ------------------------------------------------------------ *

     D SVPEMI_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPEMI_setSuspendida: Suspender Superpoliza.-                *
     *                                                              *
     *     peDsSp   ( input )  Estructura de suspendida             *
     *                                                              *
     * Retorna: *on = Se suspendio / *off = No se suspendio         *
     * ------------------------------------------------------------ *
     D SVPEMI_setSuspendida...
     D                 pr              n
     D   peDsSp                            likeds( dsPawpc0_t ) const

     * ------------------------------------------------------------ *
     * SVPEMI_calcPrima : Calcula prima.-                           *
     *                                                              *
     *     peEmpr  ( input  )  Empresa                              *
     *     peSucu  ( input  )  Sucursal                             *
     *     peArcd  ( input  )  Articulo                             *
     *     peSpol  ( input  )  SuperPoliza                          *
     *     peSspo  ( input  )  Suplemento                           *
     *     peRama  ( input  )  Rama                                 *
     *     peArse  ( input  )  Cant. de polizas                     *
     *     peOper  ( input  )  Código de operación                  *
     *     peSuop  ( input  )  Suplemento de Operacion              *
     *     pePoco  ( input  )  Número de Componente                 *
     *     peRiec  ( input  )  Código de Riesgo                     *
     *     peXcob  ( input  )  Código de Cobertura                  *
     *     peMont  ( input  )  monto de Prima Inicial               *
     *                                                              *
     * Retorna: Devuelve valor de Prima                             *
     * ------------------------------------------------------------ *
     D  SVPEMI_calcPrima...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peMont                      15  2 const

     * ------------------------------------------------------------ *
     * SVPEMI_setCabeceraEndosoSuperpoliza: Graba Cabecera de Endoso*
     *                                      de Superpoliza          *
     *                                                              *
     *     peDsC1  (  input  )  Estructura de Detalle               *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D  SVPEMI_setCabeceraEndosoSuperpoliza...
     D                 pr              n
     D   peDsC1                            likeds( dsPahec1_t ) const

     * ------------------------------------------------------------ *
     * SVPEMI_calcPrimaDelPeriodo: Cálculo de Prima del Período     *
     *                                                              *
     *     peEmpr  ( input  )  Empresa                              *
     *     peSucu  ( input  )  Sucursal                             *
     *     peArcd  ( input  )  Articulo                             *
     *     peSpol  ( input  )  SuperPoliza                          *
     *     peSspo  ( input  )  Suplemento                           *
     *     peRama  ( input  )  Rama                                 *
     *     peArse  ( input  )  Cant. de polizas                     *
     *     peOper  ( input  )  Código de operación                  *
     *     peSuop  ( input  )  Suplemento de Operacion              *
     *     pePrrc  ( output )  Prima Rc                             *
     *     pePrac  ( output )  Prima de Accidente                   *
     *     pePrin  ( output )  Prima Incendio                       *
     *     pePrro  ( output )  Prima Robo                           *
     *     pePacc  ( output )  Prima Accesorio                      *
     *     pePraa  ( output )  Prima Ajuste Automatico              *
     *     pePrsf  ( output )  Prima Sin Franquicia                 *
     *     pePrce  ( output )  Prima Rc Exterior                    *
     *     pePrap  ( output )  Prima Accidentes Personales          *
     *     peCdin  ( input  )  Codigo interfaz  ( opcional )        *
     *     peLote  ( input  )  Nro. de Lote     ( opcional )        *
     *     pePoli  ( input  )  Poliza           ( opcional )        *
     *     peEndo  ( input  )  Endoso           ( opcional )        *
     *                                                              *
     * Retorna: Devuelve valor de Prima                             *
     * ------------------------------------------------------------ *
     D SVPEMI_calcPrimaDelPeriodo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePrrc                      15  2
     D   pePrac                      15  2
     D   pePrin                      15  2
     D   pePrro                      15  2
     D   pePacc                      15  2
     D   pePraa                      15  2
     D   pePrsf                      15  2
     D   pePrce                      15  2
     D   pePrap                      15  2
     D   peCdin                      10    options(*nopass) const
     D   peLote                       3  0 options(*nopass) const
     D   pePoli                       7  0 options(*nopass) const
     D   peEndo                       7  0 options(*nopass) const

     * -------------------------------------------------------------*
     * SVPEMI_getImpuetosPorc: Retorna Porcentajes de Impuestos     *
     *                                                              *
     *     peEmpr  ( input  )  Empresa                              *
     *     peSucu  ( input  )  Sucursal                             *
     *     peArcd  ( input  )  Articulo                             *
     *     peSpol  ( input  )  SuperPoliza                          *
     *     peSspo  ( input  )  Suplemento                           *
     *     pePrim  ( input  )  Prima                                *
     *     peDsPi  ( output )  Estructura % Impuestos               *
     *                                                              *
     * Retorna : *on = encontro / *off = No encontro                *
     * -------------------------------------------------------------*
     D SVPEMI_getImpuetosPorc...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePrim                      15  2 const
     D   peDsPi                            likeds( dsPorcImp_t )

     * -----------------------------------------------------------------*
     * SVPEMI_CalcPercepcion(): Retorna Importe de Percepcion           *
     *                           ( Calcula Perecpcion - IPR6 )          *
     *                                                                  *
     *      peRpro (input)  Provincia IDER                              *
     *      peRama (input)  Rama                                        *
     *      peMone (input)  Código de Moneda de Emision                 *
     *      peCome (input)  Cotizacion Moneda Emision                   *
     *      peNeto (input)  Prima Neta ( Prima - Bonificaciones ) x Porc*
     *      peSuas (input)  Suma Asegurada                              *
     *      peCiva (input)  Condicion de IVA                            *
     *      peIpr1 (input)  Impuesto Valor Agregado ( IVA )             *
     *      peIpr3 (input)  IVA-Importe Percepcion                      *
     *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
     *      peCuit (input)  Cuit                           ( opcional ) *
     *      peAsen (input)  Asegurado                      ( opcional ) *
     *      pePorc (input)  Porcentaje de Componente       ( opcional ) *
     *      pePpr1 (output) Impuesto Valor Agregado x Porc ( opcional ) *
     *      pePpr3 (output) IVA-Importe Percepcion x Porc  ( opcional ) *
     *      pePpr4 (output) IVA-Resp.No Inscripto x Porc   ( opcional ) *
     *                                                                  *
     * Retorna Importe de Percepcion / -1 = No calculo.                 *
     * ---------------------------------------------------------------- *
     D SVPEMI_CalcPercepcion...
     D                 pr            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   peNeto                      15  2 const
     D   peSuas                      15  2 const
     D   peCiva                       2  0 const
     D   peIpr1                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peCuit                      11    options( *omit : *nopass )
     D   peAsen                       7  0 options( *omit : *nopass )
     D   pePorc                       9  6 options( *omit : *nopass )
     D   pePpr1                      15  2 options( *omit : *nopass )
     D   pePpr3                      15  2 options( *omit : *nopass )
     D   pePpr4                      15  2 options( *omit : *nopass )

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcAlicuotaPercepcion(): Retorna Importe de Alicuota de  *
      *                                  Percepcion                      *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peIpr1 (input)  Impuesto Valor Agregado ( IVA )             *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peSubt (input)  Prima Neta ( Prima - Bonificaciones ) Total *
      *      peAsen (input)  Código de Asegurado                         *
      *      peCiva (input)  Código de IVA                               *
      *                                                                  *
      * Retorna Importe Alicuota de Percepcion / 0  = No Tiene           *
      * ---------------------------------------------------------------- *
     D SVPEMI_CalcAlicuotaPercepcion...
     D                 pr            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peIpr1                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peSubt                      15  2 const
     D   peAsen                       7  0 const
     D   peCiva                       2  0 const

     * -----------------------------------------------------------------*
     * SVPEMI_CalcSelladosProvinciales():Retorna Importe de Sellados    *
     *                                   de Riesgos - Provinciales      *
     *                                   ( Calcula Sellado )            *
     *                                                                  *
     *      peRpro (input)  Provincia INDER                             *
     *      peRama (input)  Rama                                        *
     *      peMone (input)  Codigo de Moneda de Emision                 *
     *      peCome (input)  Cotizacion Moneda Emision                   *
     *      pePrim (input)  Prima x Porc                                *
     *      peBpri (input)  Bonificaciones x Porc                       *
     *      peRead (input)  Recargo Administrativo x Porc               *
     *      peRefi (input)  Recargo Financiero     x Porc               *
     *      peDere (input)  Derecho de Emision     x Porc               *
     *      peSubt (input)  Subtotal               x Porc               *
     *      peSuas (input)  Suma Asegurada                              *
     *      peImpi (input)  Impuestos Internos    ( Totales  )          *
     *      peSers (input)  Servicios Sociales    ( Totales  )          *
     *      peTssn (input)  Tasa SSN              ( Totales  )          *
     *      peIpr1 (input)  IVA                   ( Totales  )          *
     *      peIpr2 (input)  Acciones              ( Totales  )          *
     *      peIpr3 (input)  IVA-Importe Percepcion( Totales  )          *
     *      peIpr4 (input)  IVA-Resp.No Inscripto ( Totales  )          *
     *      peIpr5 (input)  Recargo de Capital    ( Totales  )          *
     *      peIpr6 (input)  Percepcion            ( Totales  )          *
     *      peIpr7 (input)  Ing.Brutos Riesgo     ( Totales  )          *
     *      peIpr8 (input)  Ing.Brutos Empresa    ( Totales  )          *
     *      pePrit (input)  Prima                 ( Totales  )          *
     *      peTiso (input)  Tipo de Sociedad                            *
     *      pePorc (input)  Porcentaje            ( Opcional )          *
     *      pePor1 (input)  Porcentaje 1          ( Opcional )          *
     *      peImfo (input)  Importe Folio         ( Opcional )          *
     *                                                                  *
     * Retorna Importe Sellado / -1 = No calculo                        *
     * ---------------------------------------------------------------- *
     D SVPEMI_CalcSelladosProvinciales...
     D                 pr            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   pePrim                      15  2 const
     D   peBpri                      15  2 const
     D   peRead                      15  2 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peSubt                      15  2 const
     D   peSuas                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   pePrit                      15  2 const
     D   peTiso                       2  0 const
     D   pePorc                       9  6 options( *nopass : *omit )
     D   pePor1                       9  6 options( *nopass : *omit )
     D   peImfo                      15  2 options( *nopass : *omit )

     * -----------------------------------------------------------------*
     * SVPEMI_CalcSelladoDeLaEmpresa(): Retorna Sellado de Empresa      *
     *                                                                  *
     *      peRpro (input)  Provincia IDER                              *
     *      peRama (input)  Rama                                        *
     *      peMone (input)  Codigo de Moneda de Emision                 *
     *      peCome (input)  Cotizacion Moneda Emision                   *
     *      pePrim (input)  Prima                                       *
     *      peBpri (input)  Bonificaciones                              *
     *      peRead (input)  Recargo Administrativo                      *
     *      peRefi (input)  Recargo Financiero                          *
     *      peDere (input)  Derecho de Emision                          *
     *      peSubt (input)  Subtotal x Porcentaje                       *
     *      peSuas (input)  Suma Asegurada                              *
     *      peImpi (input)  Impuestos Internos     ( Totales  )         *
     *      peSers (input)  Servicios Sociales     ( Totales  )         *
     *      peTssn (input)  Tasa SSN               ( Totales  )         *
     *      peIpr1 (input)  IVA                    ( Totales  )         *
     *      peIpr2 (input)  Acciones               ( Totales  )         *
     *      peIpr3 (input)  IVA-Importe Percepcion ( Totales  )         *
     *      peIpr4 (input)  IVA-Resp.No Inscripto  ( Totales  )         *
     *      peIpr5 (input)  Recargo de Capital     ( Totales  )         *
     *      peIpr6 (input)  Percepcion             ( Totales  )         *
     *      peIpr7 (input)  Ing.Brutos Riesgo      ( Totales  )         *
     *      peIpr8 (input)  Ing.Brutos Empresa     ( Totales  )         *
     *      pePrit (input)  Prima                  ( Totales  )         *
     *      peTiso (input)  Tipo de Sociedad                            *
     *      pePorc (input)  Porcentaje             ( Opcional )         *
     *      pePor1 (input)  Porcentaje 1           ( Opcional )         *
     *      peTiso (input)  Tipo de Sociedad       ( Opcional )         *
     *                                                                  *
     * Retorna Importe Sellado / -1 = No calculo                        *
     * ---------------------------------------------------------------- *
     D SVPEMI_CalcSelladoDeLaEmpresa...
     D                 pr            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   pePrim                      15  2 const
     D   peBpri                      15  2 const
     D   peRead                      15  2 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peSubt                      15  2 const
     D   peSuas                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   pePrit                      15  2 const
     D   peTiso                       2  0 const
     D   pePorc                       9  6 options( *nopass : *omit )
     D   pePor1                       9  6 options( *nopass : *omit )
     D   peimfo                      15  2 options( *nopass : *omit )

     * -----------------------------------------------------------------*
     * SVPEMI_CalcIngresosBrutos:   Retorna Importe de Inrgesos Brutos  *
     *                              ( Calcula IIb )                     *
     *                                                                  *
     *      peRpro (input)  Provincia IDER                              *
     *      peRama (input)  Rama                                        *
     *      peTipo (input)  Tipo de Impuesto  ( 'R' o 'E' )             *
     *      peNeto (input)  Prima Neta ( Prima - Bonificaciones )       *
     *      peRead (input)  Recargo Administrativo                      *
     *      peRefi (input)  Recargo Financiero                          *
     *      peDere (input)  Derecho de Emision                          *
     *                                                                  *
     * Retorna Importe IIB / -1 = No calculó                            *
     * ---------------------------------------------------------------- *
     D SVPEMI_CalcIngresosBrutos...
     D                 pr            15  2
     D peRpro                         2  0 const
     D peRama                         2  0 const
     D peTipo                         1    const
     D peNeto                        15  2 const
     D peRead                        15  2 const
     D peRefi                        15  2 const
     D peDere                        15  2 const

     * -----------------------------------------------------------------*
     * SVPEMI_CalcIVA():  Retorna Importe Impuesto Valor agregado (IVA) *
     *                    ( Calcula IVA )                               *
     *                                                                  *
     *      peCome (input)  Cotizacion de Moneda                        *
     *      peCiva (input)  Condicion de IVA                            *
     *      peSubt (input)  Subtotal(neto+refi+read+dere+ipr7+ipr8)     *
     *      pePivi (input)  % IVA Inscripto                             *
     *      pePivn (input)  % IVA No Inscripto                          *
     *      pePivr (input)  % Res.3125                                  *
     *      peIvam (input)  Mínimo Res.3125                             *
     *      peAsen (input)  Nro. de Asegurado ( opcional )              *
     *                                                                  *
     * Retorna Importe IVA / -1 = No Calculó                            *
     * ---------------------------------------------------------------- *
     D SVPEMI_CalcIVA...
     D                 pr            15  2
     D   peCome                      15  6   const
     D   peCiva                       2  0   const
     D   peSubt                      15  2   const
     D   pePivi                       5  2   const
     D   pePivn                       5  2   const
     D   pePivr                       5  2
     D   peIvam                      15  2   const
     D   peAsen                       7  0   options( *nopass :*omit )

     * -----------------------------------------------------------------*
     * SVPEMI_CalcIVATotal():  Retorna Importe Impuesto Valor agregado  *
     *                         ( Calcula Suma IVA TOTAL )               *
     *                                                                  *
     *      peCome ( input  ) Cotizacion de Moneda                      *
     *      peCiva ( input  ) Condicion de IVA                          *
     *      peSubt ( input  ) Subtotal(neto+refi+read+dere+ipr7+ipr8)   *
     *      pePivi ( input  ) % IVA Inscripto                           *
     *      pePivn ( input  ) % IVA No Inscripto                        *
     *      pePivr ( input  ) % Res.3125                                *
     *      peIvam ( input  ) Mínimo Res.3125                           *
     *      peAsen ( input  ) Nro. de Asegurado            ( opcional ) *
     *      peIpr1 ( output ) Imp.IVA                      ( opcional ) *
     *      peIpr3 ( output ) Imp.Percepcion               ( opcional ) *
     *      peIpr4 ( output ) Imp.Responsable No Inscripto ( opcional ) *
     *                                                                  *
     * Retorna Importe IVA / -1 = No Calculó                            *
     * ---------------------------------------------------------------- *
     D SVPEMI_CalcIVATotal...
     D                 pr            15  2
     D   peCome                      15  6   const
     D   peCiva                       2  0   const
     D   peSubt                      15  2   const
     D   pePivi                       5  2   const
     D   pePivn                       5  2   const
     D   pePivr                       5  2
     D   peIvam                      15  2   const
     D   peAsen                       7  0   options( *nopass :*omit )
     D   peIpr1                      15  2   options( *nopass :*omit )
     D   peIpr3                      15  2   options( *nopass :*omit )
     D   peIpr4                      15  2   options( *nopass :*omit )

     * -----------------------------------------------------------------*
     * SVPEMI_CalcIVANoInscripto(): Retorna Importe de IVA-Responsable  *
     *                           no inscripto ( Calcula Importe )       *
     *                                                                  *
     *      peCome (input)  Cotizacion de Moneda                        *
     *      peCiva (input)  Condicion de IVA                            *
     *      peSubt (input)  Subtotal(neto+refi+read+dere+ipr7+ipr8)     *
     *      pePivi (input)  % IVA Inscripto                             *
     *      pePivn (input)  % IVA No Inscripto                          *
     *      pePivr (input)  % Res.3125                                  *
     *      peIvam (input)  Mínimo Res.3125                             *
     *      peAsen (input)  Nro. de Asegurado ( opcional )              *
     *                                                                  *
     * Retorna Importe Res. No Insc. / -1 = No Calculó                  *
     * ---------------------------------------------------------------- *
     D SVPEMI_CalcIVANoInscripto...
     D                 pr            15  2
     D   peCome                      15  6   const
     D   peCiva                       2  0   const
     D   peSubt                      15  2   const
     D   pePivi                       5  2   const
     D   pePivn                       5  2   const
     D   pePivr                       5  2
     D   peIvam                      15  2   const
     D   peAsen                       7  0   options( *nopass :*omit )

     * ---------------------------------------------------------------- *
     * SVPEMI_CalcIVAPercepcion():  Retorna Importe de IVA-Percepcion   *
     *                                                                  *
     *      peCome (input)  Cotizacion de Moneda                        *
     *      peCiva (input)  Condicion de IVA                            *
     *      peSubt (input)  Subtotal(neto+refi+read+dere+ipr7+ipr8)     *
     *      pePivi (input)  % IVA Inscripto                             *
     *      pePivn (input)  % IVA No Inscripto                          *
     *      pePivr (input)  % Res.3125                                  *
     *      peIvam (input)  Mínimo Res.3125                             *
     *      peAsen (input)  Nro. de Asegurado ( opcional )              *
     *                                                                  *
     * Retorna Importe IVA Percepcion/ -1 = No Calculó                  *
     * ---------------------------------------------------------------- *
     D SVPEMI_CalcIVAPercepcion...
     D                 pr            15  2
     D   peCome                      15  6   const
     D   peCiva                       2  0   const
     D   peSubt                      15  2   const
     D   pePivi                       5  2   const
     D   pePivn                       5  2   const
     D   pePivr                       5  2
     D   peIvam                      15  2   const
     D   peAsen                       7  0   options( *nopass :*omit )

      * ------------------------------------------------------------ *
      *  SVPEMI_setAjustaImportes(): Se ajusta Importes según tabla  *
      *                                                              *
      *     peArcd    ( input )  Articulo                            *
      *     peRama    ( input )  Rama                                *
      *     peArse    ( input )  Cant. Pólizas por Rama              *
      *     pePrim    ( input )  Prima                   ( Totales ) *
      *     peBpri    ( input )  Bonificacion sobre Prima( Totales ) *
      *     pePrem    ( input )  Premio                  ( Totales ) *
      *     peRead    ( input )  Recargo Administrativo  ( Totales ) *
      *     peRefi    ( input )  Recargo Financiero      ( Totales ) *
      *     peDere    ( input )  Derecho de Emision      ( Totales ) *
      *     peImpi    ( input )  Impuestos Internos      ( Totales ) *
      *     peSers    ( input )  Servicios Sociales      ( Totales ) *
      *     peTssn    ( input )  Tasa SSN                ( Totales ) *
      *     prRpro    ( input )  Codigo de Provincia     ( x Prov  ) *
      *     pePri1    ( input )  Prima                   ( x Prov  ) *
      *     pePre1    ( input )  Premio                  ( x Prov  ) *
      *     peBpr1    ( input )  Bonificacion            ( x Prov  ) *
      *     peDer1    ( input )  Derecho de Emision      ( x Prov  ) *
      *     peRef1    ( input )  Recargo Financiero      ( x Prov  ) *
      *     peRea1    ( input )  Recargo Administrativo  ( x Prov  ) *
      *                                                              *
      * Retorna *on = Ajusto Ok / *off = No ajusto.                  *
      * -------------------------------------------------------------*
     D SVPEMI_setAjustaImportes...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePrim                      15  2
     D   peBpri                      15  2
     D   pePrem                      15  2
     D   peRead                      15  2
     D   peRefi                      15  2
     D   peDere                      15  2
     D   peImpi                      15  2
     D   peSers                      15  2
     D   peTssn                      15  2
     D   peRpro                       2  0 dim( 30 )
     D   pePri1                      15  2 dim( 30 )
     D   pePre1                      15  2 dim( 30 )
     D   peBpr1                      15  2 dim( 30 )
     D   peDer1                      15  2 dim( 30 )
     D   peRef1                      15  2 dim( 30 )
     D   peRea1                      15  2 dim( 30 )

      * ---------------------------------------------------------------- *
      * SVPEMI_setCuotaxCalculo(): Graba cuotas calculadas.-             *
      *                                                                  *
      *      peEmpr ( input )  Empresa                                   *
      *      peSucu ( input )  Sucursal                                  *
      *      peArcd ( input )  Articulo                                  *
      *      peSpol ( input )  Super Poliza                              *
      *      peSspo ( input )  Suplemento Super Poliza                   *
      *                                                                  *
      * Retorna *on = Calcula Cuota / *off = No Calculó                  *
      * ---------------------------------------------------------------- *
     D SVPEMI_setCuotaxCalculo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

      * ---------------------------------------------------------------- *
      * SVPEMI_setComisionxCalculo(): Graba Comisiones calculadas.-      *
      *                                                                  *
      *      peEmpr ( input )  Empresa                                   *
      *      peSucu ( input )  Sucursal                                  *
      *      peArcd ( input )  Articulo                                  *
      *      peSpol ( input )  Super Poliza                              *
      *      peSspo ( input )  Suplemento Super Poliza                   *
      *                                                                  *
      * Retorna *on = Calculo Comision / *off = No Calculó               *
      * ---------------------------------------------------------------- *
     D SVPEMI_setComisionxCalculo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

      * ---------------------------------------------------------------- *
      * SVPEMI_setCuotasUnificadasxCalculo: Graba cuotas Unificadas      *
      *                                     Calculo.-                    *
      *      peEmpr ( input )  Empresa                                   *
      *      peSucu ( input )  Sucursal                                  *
      *      peArcd ( input )  Articulo                                  *
      *      peSpol ( input )  Super Poliza                              *
      *      peSspo ( input )  Suplemento Super Poliza                   *
      *                                                                  *
      * Retorna *on = Calculo Comision / *off = No Calculó               *
      * ---------------------------------------------------------------- *
     D SVPEMI_setCuotasUnificadasxCalculo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
      *

      * ------------------------------------------------------------ *
      * SVPEMI_CalculaPrimas : Calcula primas.-                      *
      *                                                              *
      *     peEmpr  ( input        ) Empresa                         *
      *     peSucu  ( input        ) Sucursal                        *
      *     peArcd  ( input        ) Articulo                        *
      *     peSpol  ( input        ) SuperPoliza                     *
      *     peSspo  ( input        ) Suplemento                      *
      *     peRama  ( input        ) Rama                            *
      *     peArse  ( input        ) Cant. de polizas                *
      *     peOper  ( input        ) Código de operación             *
      *     peSuop  ( input        ) Suplemento de Operacion         *
      *     pePoco  ( input        ) Número de Componente            *
      *     peVhvu  ( input/output ) Suma Asegurada                  *
      *                                                              *
      * Retorna: Devuelve valor de Prima                             *
      * ------------------------------------------------------------ *
     D SVPEMI_CalculaPrimas...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePoco                       4  0 const
     D   peTiou                       2  0 const
     D   peStos                       1  0 const
     D   peStou                       1  0 const
     D   peVhvu                      15  2

      * -------------------------------------------------------------*
      * SVPEMI_calcImpuestosPorc. Calcula Porcentajes de Impuestos   *
      *                                                              *
      *     peEmpr  ( input  )  Empresa                              *
      *     peSucu  ( input  )  Sucursal                             *
      *     peArcd  ( input  )  Articulo                             *
      *     peRama  ( input  )  Rama                                 *
      *     pePrim  ( input  )  Prima                                *
      *     peNrpp  ( input  )  Plan de Pago                         *
      *     peDup2  ( input  )  Duracion de Período en meses         *
      *     pePecu  ( input  )  Periodo en curso                     *
      *     pePlac  ( input  )  Plan Comrcial                        *
      *     peDsPi  ( output )  Estructura % Impuestos ( opcional )  *
      *     peFemi  ( input  )  Fecha de emision       ( opcional )  *
      *     peBpip  ( input  )  % Bonificacion Prima   ( opcional )  *
      *     peBpep  ( input  )  % Derecho de Emision   ( opcional )  *
      *     peDere  ( input  )  $ Derecho de Emision   ( opcional )  *
      *     peTiou  ( input  )  Tipo de operacion      ( opcional )  *
      *     peStou  ( input  )  Subtipo Usuario        ( opcional )  *
      *     peStos  ( input  )  subtipo Sistema        ( opcional )  *
      *     penivt  ( input  )  Tipo intermediario     ( opcional )  *
      *     penivc  ( input  )  Nivel intermediario    ( opcional )  *
      *     peXrea  ( input  )  Recargo financiro      ( opcional )  *
      *     peXref  ( input  )  Recargo Administrativo ( opcional )  *
      *                                                              *
      *                                                              *
      * Retorna : *on = Calculó / *off = No Calculó                  *
      * -------------------------------------------------------------*
     D SVPEMI_calcImpuestosPorc...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   pePrim                      15  2 const
     D   peNrpp                       3  0 const
     D   peDup2                       2  0 const
     D   pePecu                       3  0 const
     D   pePlac                       3  0 const
     D   peMone                       2    const
     D   peDsPi                            likeds( dsPorcImp_t )
     D   peFemi                       8  0 const options(*nopass:*omit)
     D   peBpip                       5  2 const options(*nopass:*omit)
     D   peBpep                       5  2 const options(*nopass:*omit)
     D   peDere                      15  2 const options(*nopass:*omit)
     D   peTiou                       1  0 const options(*nopass:*omit)
     D   peStou                       2  0 const options(*nopass:*omit)
     D   peStos                       2  0 const options(*nopass:*omit)
     D   peCome                      15  6 const options(*nopass:*omit)
     D   peNivt                       1  0 const options(*nopass:*omit)
     D   peNivc                       5  0 const options(*nopass:*omit)
     D   peXrea                       5  2 const options(*nopass:*omit)
     D   peXref                       5  2 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPEMI_calcPremio(): Calcular Premio                         *
      *                                                              *
      *     peEmpr  ( input  )  Empresa                              *
      *     peSucu  ( input  )  Sucursal                             *
      *     peArcd  ( input  )  Codigo de Articulo                   *
      *     peRama  ( input  )  Rama                                 *
      *     peRpro  ( input  )  Provincia Inder                      *
      *     peNrpp  ( input  )  Plan de Pago                         *
      *     peCfpg  ( input  )  Forma de Pago                        *
      *     pePrim  ( input  )  Prima                                *
      *     peDup2  ( input  )  Duracion de Período en meses         *
      *     pePecu  ( input  )  Periodo en curso                     *
      *     pePlac  ( input  )  Plan Comrcial                        *
      *     peMone  ( input  )  Moneda                               *
      *     peCiva  ( input  )  Condicion de Iva                     *
      *     peSuas  ( input  )  Suma Asegurada                       *
      *     peFemi  ( input  )  Fecha de emision       ( opcional )  *
      *     peBpip  ( input  )  % Bonificacion Prima   ( opcional )  *
      *     peBpep  ( input  )  % Derecho de Emision   ( opcional )  *
      *     peDere  ( input  )  $ Derecho de Emision   ( opcional )  *
      *     peTiou  ( input  )  Tipo de operacion      ( opcional )  *
      *     peStou  ( input  )  Subtipo Usuario        ( opcional )  *
      *     peStos  ( input  )  subtipo Sistema        ( opcional )  *
      *     peNivt  ( input  )  Tipo intermediario     ( opcional )  *
      *     peNivc  ( input  )  Nivel intermediario    ( opcional )  *
      *     peXrea  ( input  )  Recargo financiro      ( opcional )  *
      *     peXref  ( input  )  Recargo Administrativo ( opcional )  *
      *     peArse  ( input  )  Cantidad de polizas    ( opcional )  *
      *     peCcom  ( input  )  Cantidad de componentes( opcional )  *
      *     peDsPi  ( output )  Estructura % Impuestos ( opcional )  *
      *     peDsTi  ( output )  Totales calculados     ( opcional )  *
      *     peDsIp  ( output )  Totales x Prov         ( opcional )  *
      *                                                              *
      * Retorna: Premio                                              *
      * -------------------------------------------------------------*
     D SVPEMI_calcPremio...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peRpro                       2  0 const
     D   pePrim                      15  2 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0 const
     D   peTiso                       2  0 const
     D   peAsen                       7  0 const
     D   peDup2                       2  0 const
     D   pePecu                       3  0 const
     D   pePlac                       3  0 const
     D   peMone                       2    const
     D   peCiva                       2  0 const
     D   peSuas                      15  2 const
     D   peFemi                       8  0 const options(*nopass:*omit)
     D   peBpip                       5  2 const options(*nopass:*omit)
     D   peBpep                       5  2 const options(*nopass:*omit)
     D   peDere                      15  2 const options(*nopass:*omit)
     D   peTiou                       1  0 const options(*nopass:*omit)
     D   peStou                       2  0 const options(*nopass:*omit)
     D   peStos                       2  0 const options(*nopass:*omit)
     D   peCome                      15  6 const options(*nopass:*omit)
     D   peNivt                       1  0 const options(*nopass:*omit)
     D   peNivc                       5  0 const options(*nopass:*omit)
     D   peXrea                       5  2 const options(*nopass:*omit)
     D   peXref                       5  2 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peCcom                      10i 0 const options(*nopass:*omit)
     D   peDsPi                            likeds(dsPorcImp_t    )
     D                                           options(*nopass:*omit)
     D   peDsIt                            likeds(dsImpTotales_t )
     D                                           options(*nopass:*omit)
     D   peDsIp                            likeds(dsImpEg3_t     ) dim(30)
     D                                           options(*nopass:*omit)


