      /if defined(COWRTV_H)
      /eof
      /endif
      /define COWRTV_H

      /copy './qcpybooks/svpdrv_h.rpgle'
      /copy './qcpybooks/svpbue_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/cowhog_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/cowrgv_h.rpgle'
      /copy './qcpybooks/cowsep_h.rpgle'
      /copy './qcpybooks/cowape_h.rpgle'

     D
     D Infvehi         ds                  qualified based(template)
     D   Rama                         2  0
     D   Poco                         4  0
     D   Arse                         2  0
     D   Vhmc                         3
     D   Vhmo                         3
     D   Vhcs                         3
     D   Vhcr                         3
     D   Vhan                         4  0
     D   Vhni                         1
     D   Moto                        25
     D   Chas                        25
     D   Vhct                         2  0
     D   Vhuv                         2  0
     D   M0km                         1
     D   Proc                         3a
     D   Rpro                         2  0
     D   Copo                         5  0
     D   Cops                         1  0
     D   Scta                         1  0
     D   Mgnc                         1
     D   Rgnc                         7  2
     D   Nmat                        25
     D   Ctre                         5  0
     D   Rebr                         1  0
     D   Nmer                        40
     D   Aver                         1
     D   Iris                         1
     D   Cesv                         1
     D   Vhvu                        15  2
     D   Cobe                              likeds(cobVehi) dim (20)
     D   Boni                              likeds(bonVeh) dim (99)
     D   Acce                              likeds(AccVeh_t) dim(100)

     D cobVehi         ds                  qualified based(template)
     D   cobl                         2    overlay(cobVehi:1)
     D   cobd                        40    overlay(cobVehi:*next)
     D   rast                         1    overlay(cobVehi:*next)
     D   cras                         3  0 overlay(cobVehi:*next)
     D   insp                         1    overlay(cobVehi:*next)
     D   sele                         1    overlay(cobVehi:*next)
     D   prim                        15p 2 overlay(cobVehi:*next)
     D   prem                        15p 2 overlay(cobVehi:*next)
     D   ifra                        15p 2 overlay(cobVehi:*next)
     D   xopr                        15p 2 overlay(cobVehi:*next)
     D
     D AccVeh_t        ds                  qualified based(template)
     D  secu                          2  0
     D  accd                         20a
     D  accv                         15  2
     D  mar1                          1a
     D
     D InfUbic         ds                  qualified based(template)
     D   Rama                         2  0
     D   Poco                         4  0
     D   Arse                         2  0
     D   Xpro                         3  0
     D   Rpro                         2  0
     D   Proc                         3a
     D   Rdes                        30
     D   Copo                         5  0
     D   Cops                         1  0
     D   Tviv                         3  0
     D   Insp                         1a
     D   Suma                        13  2
     D   Cobe                              likeds(cobUbic) dim (20)
     D   Cara                              likeds(carUbic) dim (20)
     D
     D cobUbic         ds                  qualified based(template)
     D   riec                         3
     D   xcob                         3  0
     D   ried                        25
     D   cobd                        20
     D   cobl                        40
     D   baop                         1
     D   saco                        15p 2
     D   smax                        15p 2
     D   smin                        15p 2
     D   prsa                         5p 2
     D   orie                         3
     D   ocob                         3p 0
     D   sac1                        15p 2
     D   xpri                         9p 6
     D   prim                        15p 2
     D   cfac                         2p 0
     D   dfac                        40a
     D   bonu                              likeds(bonUbic) dim (10)
     D
     D bonUbic         ds                  qualified based(template)
     D   nive                         1  0
     D   ccbp                         3  0
     D   reca                         5  2
     D   boni                         5  2
     D
     D carUbic         ds                  qualified based(template)
     D   ccba                         3  0
     D   dcba                        25
     D   ma01                         1
     D   ma02                         1
     D   ma01m                        1
     D   ma02m                        1
     D   ma03                         1
     D
     D ImpCoti         ds                  qualified based(template)
     D   rama                         2  0
     D   dere                        15  2
     D   xref                         5  2
     D   pimi                         5  2
     D   psso                         5  2
     D   pssn                         5  2
     D   pivi                         5  2
     D   pivr                         5  2
     D   pivn                         5  2
     D
     D primPrem        ds                  qualified based(template)
     D   rama                         2  0
     D   arse                         2  0
     D   prim                        15  2
     D   xref                         5  2
     D   refi                        15  2
     D   dere                        15  2
     D   subt                        15  2
     D   seri                        15  2
     D   seem                        15  2
     D   pimi                         5  2
     D   impi                        15  2
     D   psso                         5  2
     D   sers                        15  2
     D   pssn                         5  2
     D   tssn                        15  2
     D   pivi                         5  2
     D   ipr1                        15  2
     D   pivn                         5  2
     D   ipr4                        15  2
     D   pivr                         5  2
     D   ipr3                        15  2
     D   ipr5                        15  2
     D   ipr6                        15  2
     D   ipr7                        15  2
     D   ipr8                        15  2
     D   ipr9                        15  2
     D   prem                        15  2
     D
     D CompVida        ds                  qualified based(template)
     D   Rama                         2  0
     D   Arse                         2  0
     D   Poco                         6  0
     D   Paco                         3  0
     D   Acti                         5  0
     D   Secu                         2  0
     D   Xpro                         3  0
     D   Nomb                        40
     D   Tido                         2  0
     D   Nrdo                         8  0
     D   Fnac                         8  0
     D   Naci                        25
     D   Cate                         2  0
     D   Cobe                              likeds(CobeVida) dim (10)
     D   prem                        15  2

     D CompVid2        ds                  qualified based(template)
     D   Rama                         2  0
     D   Arse                         2  0
     D   Poco                         6  0
     D   Paco                         3  0
     D   Acti                         5  0
     D   Secu                         2  0
     D   Xpro                         3  0
     D   Nomb                        40
     D   Tido                         2  0
     D   Nrdo                         8  0
     D   Fnac                         8  0
     D   Naci                        25
     D   Cate                         2  0
     D   Cobe                              likeds(CobeVida) dim (10)
     D   prem                        15  2
     D   Cant                         2  0
     D   Raed                         2  0

     D CobeVida        ds                  qualified based(template)
     D   secu                         2  0
     D   riec                         3
     D   xcob                         3  0
     D   saco                        15  2
     D   ptco                        15  2
     D   xpri                         9  6
     D   prsa                         5  2
     D   ecob                         1

     D CabeceraCot_t   ds                  qualified template
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1  0
     D  nivc                          5  0
     D  nctw                          7  0
     D  nit1                          1  0
     D  niv1                          5  0
     D  fctw                          8  0
     D  nomb                         40a
     D  soln                          7  0
     D  fpro                          8  0
     D  mone                          2a
     D  noml                         30a
     D  come                         15  6
     D  copo                          5  0
     D  cops                          1  0
     D  loca                         25a
     D  arcd                          6  0
     D  arno                         30a
     D  spol                          9  0
     D  sspo                          3  0
     D  tipe                          1a
     D  civa                          2  0
     D  ncil                         30a
     D  tiou                          1  0
     D  stou                          2  0
     D  stos                          2  0
     D  dsop                         20a
     D  spo1                          9  0
     D  cest                          1  0
     D  cses                          2  0
     D  dest                         20a
     D  vdes                          8  0
     D  vhas                          8  0
     D  cfpg                          1  0
     D  defp                         20a
     D  ncbu                         22  0
     D  ctcu                          3  0
     D  nrtc                         20  0
     D  fvtc                          6  0
     D  mp01                          1a
     D  mp02                          1a
     D  mp03                          1a
     D  mp04                          1a
     D  mp05                          1a
     D  mp06                          1a
     D  mp07                          1a
     D  mp08                          1a
     D  mp09                          1a
     D  mp10                          1a
     D  nrpp                          3  0
     D  asen                          7  0

      * ---------------------------------------------------------------- *
     D Infvehi2        ds                  qualified based(template)
     D   Rama                         2  0
     D   Poco                         4  0
     D   Arse                         2  0
     D   Vhmc                         3
     D   Vhmo                         3
     D   Vhcs                         3
     D   Vhcr                         3
     D   Vhan                         4  0
     D   Vhni                         1
     D   Moto                        25
     D   Chas                        25
     D   Vhct                         2  0
     D   Vhuv                         2  0
     D   M0km                         1
     D   Proc                         3a
     D   Rpro                         2  0
     D   Copo                         5  0
     D   Cops                         1  0
     D   Scta                         1  0
     D   Mgnc                         1
     D   Rgnc                         7  2
     D   Nmat                        25
     D   Ctre                         5  0
     D   Rebr                         1  0
     D   Nmer                        40
     D   Aver                         1
     D   Iris                         1
     D   Cesv                         1
     D   Vhvu                        15  2
     D   Cobe                              likeds(cobVehi2) dim(20)
     D   Boni                              likeds(bonVeh)   dim(99)
     D   Impu                              likeds(Impuesto) dim(99)
     D   Acce                              likeds(AccVeh_t) dim(100)
     D   dWeb                         1
     D   pWeb                         5  2

     D cobVehi2        ds                  qualified based(template)
     D   cobl                         2    overlay(cobVehi2:1)
     D   cobd                        40    overlay(cobVehi2:*next)
     D   rast                         1    overlay(cobVehi2:*next)
     D   cras                         3  0 overlay(cobVehi2:*next)
     D   insp                         1    overlay(cobVehi2:*next)
     D   sele                         1    overlay(cobVehi2:*next)
     D   prim                        15p 2 overlay(cobVehi2:*next)
     D   prem                        15p 2 overlay(cobVehi2:*next)
     D   ifra                        15p 2 overlay(cobVehi2:*next)
     D   xopr                        15p 2 overlay(cobVehi2:*next)
     D   claj                         3  0 overlay(cobVehi2:*next)
     D   prrc                        15p 2 overlay(cobVehi2:*next)
     D   prac                        15p 2 overlay(cobVehi2:*next)
     D   prin                        15p 2 overlay(cobVehi2:*next)
     D   prro                        15p 2 overlay(cobVehi2:*next)
     D   pacc                        15p 2 overlay(cobVehi2:*next)
     D   praa                        15p 2 overlay(cobVehi2:*next)
     D   prsf                        15p 2 overlay(cobVehi2:*next)
     D   prce                        15p 2 overlay(cobVehi2:*next)
     D   prap                        15p 2 overlay(cobVehi2:*next)
     D   rcle                        15p 2 overlay(cobVehi2:*next)
     D   rcco                        15p 2 overlay(cobVehi2:*next)
     D   rcac                        15p 2 overlay(cobVehi2:*next)
     D   lrce                        15p 2 overlay(cobVehi2:*next)
      * -----------------------------------------------------------------*
     D Asegurado_t     ds                  qualified based(template)
     D w3empr                         1
     D w3sucu                         2
     D w3nivt                         1p 0
     D w3nivc                         5p 0
     D w3nctw                         7p 0
     D w3nase                         7p 0
     D w3asen                         7p 0
     D w3tiso                         2p 0
     D w3nomb                        40
     D w3fnac                         8p 0
     D w3csex                         1  0
     D w3cesc                         1  0
     D w3tido                         2p 0
     D w3nrdo                         8p 0
     D w3cuit                        11
     D w3njub                        11p 0
     D w3domi                        35
     D w3copo                         5p 0
     D w3cops                         1p 0
     D w3rpro                         2p 0
     D w3agre                         1
     D w3civa                         2p 0
     D w3telp                        20
     D w3telc                        20
     D w3telt                        20
     D w3naco                        25
     D w3fein                         8p 0
     D w3nrin                        13p 0
     D w3feco                         8p 0
     D w3raae                         3p 0
     D w3cprf                         3p 0
     D w3ctcu                         3p 0
     D w3nrtc                        20p 0
     D w3ffta                         4p 0
     D w3fftm                         2p 0
     D w3ncbu                        22p 0
     D w3cbus                        22p 0
     D w3ruta                        16p 0
     D w3pain                         5p 0
     D w3cnac                         3p 0

      * ------------------------------------------------------------ *
      * Detalle de Scoring                                           *
      * ------------------------------------------------------------ *
     D scorveh_t       ds                  qualified template
     D  cosg                          4
     D  cosd                         79
     D  vefa                          1
     D  cant                          2  0

      * ---------------------------------------------------------------- *
     D infvehi3_t      ds                  qualified based(template)
     D   Rama                         2  0
     D   Poco                         4  0
     D   Arse                         2  0
     D   Vhmc                         3
     D   Vhmo                         3
     D   Vhcs                         3
     D   Vhcr                         3
     D   Vhan                         4  0
     D   Vhni                         1
     D   Moto                        25
     D   Chas                        25
     D   Vhct                         2  0
     D   Vhuv                         2  0
     D   M0km                         1
     D   Proc                         3a
     D   Rpro                         2  0
     D   Copo                         5  0
     D   Cops                         1  0
     D   Scta                         1  0
     D   Mgnc                         1
     D   Rgnc                         7  2
     D   Nmat                        25
     D   Ctre                         5  0
     D   Rebr                         1  0
     D   Nmer                        40
     D   Aver                         1
     D   Iris                         1
     D   Cesv                         1
     D   Vhvu                        15  2
     D   Cobe                              likeds(cobVehi2) dim(20)
     D   Boni                              likeds(bonVeh)   dim(99)
     D   Impu                              likeds(Impuesto) dim(99)
     D   Acce                              likeds(AccVeh_t) dim(100)
     D   Dweb                         1
     D   Pweb                         5  2
     D   Taaj                         2  0
     D   Scor                              likeds(scorveh_t) Dim(200)

      * ---------------------------------------------------------------- *
     D infvehi4_t      ds                  qualified based(template)
     D   Rama                         2  0
     D   Poco                         4  0
     D   Arse                         2  0
     D   Vhmc                         3
     D   Vhmo                         3
     D   Vhcs                         3
     D   Vhcr                         3
     D   Vhan                         4  0
     D   Vhni                         1
     D   Moto                        25
     D   Chas                        25
     D   Vhct                         2  0
     D   Vhuv                         2  0
     D   M0km                         1
     D   Proc                         3a
     D   Rpro                         2  0
     D   Copo                         5  0
     D   Cops                         1  0
     D   Scta                         1  0
     D   Mgnc                         1
     D   Rgnc                         7  2
     D   Nmat                        25
     D   Ctre                         5  0
     D   Rebr                         1  0
     D   Nmer                        40
     D   Aver                         1
     D   Iris                         1
     D   Cesv                         1
     D   Vhvu                        15  2
     D   Cobe                              likeds(cobVehi2) dim(20)
     D   Boni                              likeds(bonVeh)   dim(99)
     D   Impu                              likeds(Impuesto) dim(99)
     D   Acce                              likeds(AccVeh_t) dim(100)
     D   Dweb                         1
     D   Pweb                         5  2
     D   Taaj                         2  0
     D   Scor                              likeds(scorveh_t) Dim(200)
     D   fact                              likeds(factores_t) Dim(999)

      * -----------------------------------------------------------------*
      * COWRTV_getCabecera(): Recupera la cabecera de la Cotización      *
      *                       Salvada.                                   *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *        Output:                                                   *
      *                peFctw  -  Fecha de Creación  (aaaammdd)          *
      *                peAsen  -  Cóidigo del cliente (0 si es nuevo)    *
      *                peNomb  -  Nombre Asegurado                       *
      *                peMone  -  Código de Moneda                       *
      *                peNmol  -  Descripción de Moneda                  *
      *                peCome  -  Cotización de Moneda                   *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peLoca  -  Localidad                              *
      *                peArcd  -  Código Artículo                        *
      *                peArno  -  Nombre de Artículo                     *
      *                peSpol  -  SuperPóliza                            *
      *                peSspo  -  Suplemento SuperPóliza                 *
      *                peTipe  -  Tipo de Persona                        *
      *                peCiva  -  Código de IVA                          *
      *                peNcil  -  Descripción IVA                        *
      *                peTiou  -  Tipo de Operación                      *
      *                peStou  -  Subtipo Operación Usuario              *
      *                peStos  -  Subtipo Operación Sistema              *
      *                peSpo1  -  SuperPóliza Relacionada                *
      *                peCfpg  -  Código Forma de Pago                   *
      *                peDefp  -  Descripción Forma de Pago              *
      *                peNcbu  -  Número de CBU                          *
      *                peCtcu  -  Empresa Tarjeta de Crédito             *
      *                peNrtc  -  Descripción Empresa Tarj de Crédito    *
      *                peFvct  -  FechaVencimiento Tarj Crédito(aaaammdd)*
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getCabecera...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peFctw                       8  0
     D   peAsen                       7  0
     D   peNomb                      40
     D   peMone                       2
     D   peNmol                      30
     D   peCome                       9  6
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peLoca                      25
     D   peArcd                       6  0
     D   peArno                      30
     D   peSpol                       9  0
     D   peSspo                       3  0
     D   peTipe                       1
     D   peCiva                       2  0
     D   peNcil                      30
     D   peTiou                       1  0
     D   peStou                       2  0
     D   peStos                       2  0
     D   peSpo1                       9  0
     D   peCfpg                       3  0
     D   peDefp                      20
     D   peNcbu                      22  0
     D   peCtcu                       3  0
     D   peNrtc                      20  0
     D   peFvct                       6  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D
      * -----------------------------------------------------------------*
      * COWRTV_getVehiculos(): Recupera los bienes asegurados(Vehículos) *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *        Output:                                                   *
      *                peInfV  -  Información del Vehículo               *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getVehiculos...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peInfV                            likeds(Infvehi) Dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * COWRTV_getVehiculo(): Recupera los bienes asegurados , para una  *
      *                       rama y componente.                         *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                pePoco  -  Número de Componente                   *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *        Output:                                                   *
      *                peInfV  -  Información del Vehículo               *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getVehiculo...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peArse                       2  0   const
     D   peInfV                            likeds(Infvehi)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D
      * -----------------------------------------------------------------*
      * COWRTV_getUbicaciones(): Recupera los Bienes asegurados(Hogar)   *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *        Output:                                                   *
      *                peInfu  -  Información de los Bienes              *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getUbicaciones...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peInfU                            likeds(InfUbic) Dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * COWRTV_getUbicacion(): Recupera info Bien Asegurado.             *
      *                                                                  *
      *        Input :                                                   *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                pePoco  -  Número de Componente                   *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *        Output:                                                   *
      *                peInfU  -  Información del Bien                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getUbicacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peArse                       2  0   const
     D   peInfU                            likeds(InfUbic)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * COWRTV_getCobVehiculo(): Recupera las coberturas asociadas       *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *                pePoco  -  Número de Componente                   *
      *        Output:                                                   *
      *                peCobV  -  Coberturas                             *
      *                peBonV  -  Bonificaciones                         *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getCobVehiculo...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peCobV                            likeds(cobVehi) Dim(20)
     D   peBonV                            likeds(bonVeh) Dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D
      * -----------------------------------------------------------------*
      * COWRTV_getCobUbicacion(): Recupera las coberturas asociadas      *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *                pePoco  -  Número de Componente                   *
      *                peXpro  -  Código de Producto                     *
      *        Output:                                                   *
      *                peCobU  -  Coberturas del bien                    *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getCobUbicacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
     D   peCobU                            likeds(cobUbic) Dim(20)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * COWRTV_getCarUbicacion(): Recupera las caracteristicas           *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *                pePoco  -  Número de Componente                   *
      *        Output:                                                   *
      *                peCarU  -  Caracteristicas del bien               *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getCarUbicacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peCarU                            likeds(carUbic) Dim(20)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * COWRTV_getBonUbicacion():Recupera las coberturas asociadas       *
      *                                                                  *
      *        Input :                                                   *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *                pePoco  -  Número de Componente                   *
      *                peXcob  -  Código de Cobertura                    *
      *        Output:                                                   *
      *                peBonu  -  Datos Bonificacion/Recargo             *
      *                peErro  -  Error                                  *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWRTV_getBonUbicacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXcob                       3  0   const
     D   peBonu                            likeds(bonUbic) dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ---------------------------------------------------------------- *
      * COWRTV_getBonVehiculo(): Recupera las bonificaciones de las      *
      *                          coberturas.                             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *                pePoco  -  Número de Componente                   *
      *        Output:                                                   *
      *                peBonv  -  Datos Bonificacion/Recargo             *
      *                peErro  -  Error                                  *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWRTV_getBonVehiculo...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peBonv                            likeds(bonVeh) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ---------------------------------------------------------------- *
      * COWRTV_getDatCobFijos():Recupera datos de las coberturas que son *
      *                         fijos asociados al codigo y riesgo       *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                peXpro  -  Código Producto                        *
      *                peRiec  -  Código de Riesgo                       *
      *                peCobc  -  Código de Cobertura                    *
      *                                                                  *
      *        Output:                                                   *
      *                pebaop  -  Básica u Optativa                      *
      *                pesmax  -  Suma Asegurada Máxima                  *
      *                pesmin  -  Suma Asegurada Mínima                  *
      *                peorie  -  Código de Riesgo                       *
      *                peocob  -  Código de Cobertura                    *
      *                pesaco  -  Suma Asegurada Default                 *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getDatCobFijos...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXpro                       3  0   const
     D   peRiec                       3      const
     D   peCobc                       3  0   const
     D   peBaop                       1
     D   peSmax                      15  2
     D   peSmin                      15  2
     D   peOrie                       3
     D   peOcob                       3  0
     D   peSaco                      15  2
      * ---------------------------------------------------------------- *
      * COWRTV_getDatCarFijos():Recupera datos de caracteristicas que son*
      *                         fijas asociadas a la rama y codigo de    *
      *                         caracteristicas.                         *
      *        Input :                                                   *
      *                                                                  *
      *                peEmpr - Código de Empresa                        *
      *                peSucu - Código de Sucursal                       *
      *                peRama - Rama                                     *
      *                peCcba - Cod.Caracteristica del Bien              *
      *        Output:                                                   *
      *                peMa01  -  VALOR POR DEFECTO                      *
      *                peMa02  -  APLICA POR DEFECTO                     *
      *                peMa03  -  Permite modificas Tiene/no Tiene (Opc) *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWRTV_getDatcarFijos...
     D                 pr
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peCcba                       3  0 const
     D   peMa01                       1
     D   peMa02                       1
     D   peMa03                       1    options(*nopass:*omit)
      * ---------------------------------------------------------------- *
      * COWRTV_getBonFijos():Recupera los campos de bonificacion que son *
      *                      fijos de automovil                          *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peEmpr  -  Código de Empresa                      *
      *                peSucu  -  Código de Sucursal                     *
      *                peArcd  -  Código de Artículo                     *
      *                peRama  -  Rama                                   *
      *                peCcbp  -  Código de Componente Bonifi            *
      *                                                                  *
      *        Output:                                                   *
      *                                                                  *
      *                peEppd  -  Rango Desde Compo.Bonif.               *
      *                peEpph  -  Rango Hasta Compo.Bonif.               *
      *                peMcbp  -  S/N Permite o no cambiar %             *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWRTV_getBonFijos...
     D                 pr
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peEppd                       5  2
     D   peEpph                       5  2
     D   peMcbp                       1
      * ---------------------------------------------------------------- *
      * COWRTV_getPrimaTot():Recupera la prima total de la cobertura     *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *                pePoco  -  Número de Componente                   *
      *                peCobl  -  Cobertura                              *
      *                pePrim  -  Prima                                  *
      *                                                                  *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWRTV_getPrimaTot...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peCobl                       2      const
     D   pePrim                      15  2
      * ------------------------------------------------------------ *
      * COWRTV_getOperacion(): Devuelve tipo y subtipo de operacion. *
      *                                                              *
      *        Input :                                               *
      *                peBase - Base                                 *
      *                peNctw - Número de Cotización                 *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peTiou  -  Tipo operacion usuario             *
      *                peStou  -  Subtipo operacion usuario          *
      *                peStos  -  Subtipo operacion sistema          *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRTV_getOperacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTiou                       1  0
     D   peStou                       2  0
     D   peStos                       2  0
      * ------------------------------------------------------------ *
      * COWRTV_getImpuestos(): Devuelve los impuestos de una cotiza- *
      *                        cion.                                 *
      *        Input :                                               *
      *                peBase - Base                                 *
      *                peNctw - Número de Cotización                 *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peImpu  -  Impuestos                          *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRTV_getImpuestos...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peImpu                            likeds(primPrem) dim(99)
      * ------------------------------------------------------------ *
      * COWRTV_getCondComerciales() Retorna condiciones comerciales  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peCond  -  Condiciones Comerciales            *
      *                peErro  -  Error                              *
      *                peMsgs  -  Estructura de Error                *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRTV_getCondComerciales...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCond                            likeds(condComer_t) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWRTV_getComponenteVida() Retorna todos componentes de Vida *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peCond  -  Condiciones Comerciales            *
      *                                                              *
      * ------------------------------------------------------------ *

     D COWRTV_getComponenteVida...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peComp                            likeds(CompVida)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWRTV_getComponentesVida() Retorna todos componentes de Vida*
      *                                                              *
      *  ****** DEPRECATED ****** Usar _getComponentesVid2()         *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peCond  -  Condiciones Comerciales            *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRTV_getComponentesVida...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peComp                            likeds(CompVida) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWRTV_getComponentesVid2() Retorna todos componentes de Vida*
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peCond  -  Condiciones Comerciales            *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRTV_getComponentesVid2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peComp                            likeds(CompVid2) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWRTV_getCoberturasVida() Retorna Coberturas del componente *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Polizas por Rama                   *
      *                pePoco  -  Número de Componente               *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peComp  -  Retorna datos del componente       *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRTV_getCoberturasVida...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCobe                            likeds(CobeVida) dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWRTV_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWRTV_inz      pr
      * ------------------------------------------------------------ *
      * COWRTV_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWRTV_end      pr

      * ---------------------------------------------------------------- *
      * COWRTV_getCabeceraCotizacion: Recupera registro de CTW000        *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *                                                                  *
      * Retorna *on si encontró / *off si no encuentra                   *
      * ---------------------------------------------------------------- *
     D COWRTV_getCabeceraCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCcot                            likeds(CabeceraCot_t)
      * -----------------------------------------------------------------*
      * COWRTV_getVehiculos2(): Recupera los bienes asegurados(Vehículos)*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *        Output:                                                   *
      *                peInfV  -  Información del Vehículo               *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getVehiculos2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peInfV                            likeds(Infvehi2) Dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * COWRTV_getVehiculo2(): Recupera los bienes asegurados , para una *
      *                       rama y componente.                         *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                pePoco  -  Número de Componente                   *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *        Output:                                                   *
      *                peInfV  -  Información del Vehículo               *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getVehiculo2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peArse                       2  0   const
     D   peInfV                            likeds(Infvehi2)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D
      * -----------------------------------------------------------------*
      * COWRTV_getCobVehiculo2(): Recupera las coberturas asociadas      *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Código de Rama                         *
      *                peArse  -  Cantidad Polizas por Rama/Articulo     *
      *                pePoco  -  Número de Componente                   *
      *                peVhvu  -  Suma Asegurada                         *
      *        Output:                                                   *
      *                peCobV  -  Coberturas                             *
      *                peBonV  -  Bonificaciones                         *
      *                peImpu  -  Impuestos                              *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * -----------------------------------------------------------------*
     D COWRTV_getCobVehiculo2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peVhvu                      15  2   const
     D   peCobV                            likeds(cobVehi2) Dim(20)
     D   peBonV                            likeds(bonVeh)   Dim(99)
     D   peImpu                            likeds(Impuesto) Dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D
      * ---------------------------------------------------------------- *
      * COWRTV_getComponentesVid3() Retorna todos componentes de Vida    *
      *                                                                  *
      *       peBase ( input  ) -  Base                                  *
      *       peNctw ( input  ) -  Nro de Cotizacion                     *
      *       peRama ( output ) -  Rama                                  *
      *       peArse ( output ) -  Cant. de Polizas de Rama              *
      *       peNrpp ( output ) -  Plan de Pagos                         *
      *       peVdes ( output ) -  Vigencia Desde                        *
      *       peVhas ( output ) -  Vigencia Hasta                        *
      *       peXpro ( output ) -  Producto                              *
      *       peClie ( output ) -  Cliente                               *
      *       peActi ( output ) -  Estructura de Actividades             *
      *       peActiC( output ) -  Cant. de Actividad                    *
      *       peImpu ( output ) -  Impuestos                             *
      *       pePrim ( output ) -  Prima Total                           *
      *       pePrem ( output ) -  Premio Total                          *
      *       peErro ( output ) -  Marca de Error                        *
      *       peMsgs ( output ) -  Estructura de Errores                 *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWRTV_getComponentesVid3...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0
     D   peArse                       2  0
     D   peNrpp                       3  0
     D   peVdes                       8  0
     D   peVhas                       8  0
     D   peXpro                       3  0
     D   peClie                            likeds(ClienteCot_t)
     D   peActi                            likeds(Activ_t)  dim(99)
     D   peActiC                     10i 0
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * COWRTV_getCoberturasVida2(): Retoma Coberturas de una actividad  *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *       peCobe ( output ) - Estructura de Cobertura                *
      *       peCobeC( output ) - Cantidad de Coberturas                 *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *

     D COWRTV_getCoberturasVida2...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peCobeC                     10i 0

      * ---------------------------------------------------------------- *
      * COWRTV_getAsegurado(): Retorna Asegurado de una Cotizacion       *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peAseg ( output ) - Estructura de Asegurados               *
      *       peAsegC( output ) - Cantidad de Asegurados                 *
      *       peNase ( input  ) - Tipo Asegurado          ( opcional )   *
      *                                                                  *
      * Retorna *ON = Asegurados  / *off = No encontro                   *
      * ---------------------------------------------------------------- *
     D COWRTV_getAsegurado...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peAseg                            likeds(Asegurado_t) dim(999)
     D   peAsegC                     10i 0
     D   peNase                       7  0 options( *nopass : *omit )

      * ---------------------------------------------------------------- *
      * COWRTV_getComponentesHogar(): Retorna cotización de hogar guarda-*
      *                               da.                                *
      *                                                                  *
      *    peBase    (input)   Parámetro Base                            *
      *    peNctw    (input)   Número de Cotización                      *
      *    peRama    (input)   Rama                                      *
      *    peArse    (input)   Secuencia artículo/rama                   *
      *    peCfpg    (output)  Forma de Pago                             *
      *    peClie    (output)  Estructura de cliente                     *
      *    pePoco    (output)  Estructura de componentes                 *
      *    pePocoC   (output)  Cantidad de componentes                   *
      *    peXrea    (output)  % de Extra Prima Variable                 *
      *    peImpu    (output)  Detalle de Prima a Premio                 *
      *    peSuma    (output)  Suma Asegurada Total                      *
      *    pePrim    (output)  Prima Total                               *
      *    pePrem    (output)  Premio Total                              *
      *    peCond    (output)  Condiciones Comerciales                   *
      *    peCon1    (output)  Condiciones Comerciales                   *
      *    peErro    (output)  Señal de Error                            *
      *    peMsgs    (output)  Mensajes de Error                         *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWRTV_getComponentesHogar...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0
     D  peClie                             likeds(ClienteCot_t)
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0
     D  peXrea                        5  2
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWRTV_getVehiculos3(): Recupera los bienes asegurados       *
      *                         (Vehículos).                         *
      *        Input :                                               *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *        Output:                                               *
      *                peInfV  -  Información del Vehículo           *
      *                peErro  -  Indicador de Error                 *
      *                peMsgs  -  Estructura de Error                *
      * ------------------------------------------------------------ *
     D COWRTV_getVehiculos3...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peInfV                            likeds(Infvehi3_t) Dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWRTV_getVehiculo3(): Recupera los bienes asegurados        *
      *                        (Vehículos).                          *
      *        Input :                                               *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                peRama  -  Código de Rama                     *
      *                pePoco  -  Número de Componente               *
      *                peArse  -  Cant.Polizas por Rama/Art          *
      *        Output:                                               *
      *                peInfV  -  Información del Vehículo           *
      *                peErro  -  Indicador de Error                 *
      *                peMsgs  -  Estructura de Error                *
      * ------------------------------------------------------------ *
     D COWRTV_getVehiculo3...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peArse                       2  0   const
     D   peInfV                            likeds(Infvehi3_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWRTV_getScoring(): Recupera Datos del Scoring.             *
      *                                                              *
      *        Input :                                               *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *                peRama  -  Código de Rama                     *
      *                pePoco  -  Número de Componente               *
      *                peArse  -  Cant.Polizas por Rama/Art          *
      *        Output:                                               *
      *                peTaaj  -  Código de Cuestionario             *
      *                peItem  -  Items de Scoring                   *
      *                                                              *
      * Retorna: *ON = Si encontró / *OFF = No encontró              *
      * ------------------------------------------------------------ *
     D COWRTV_getScoring...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   pePoco                       4  0 const
     D   peArse                       2  0 const
     D   peTaaj                       2  0
     D   peItem                            likeds(items_t) dim(200)

      * ---------------------------------------------------------------- *
      * COWRTV_getComponentesRGV : Retorna cotización de hogar guardada  *
      *                                                                  *
      * >>>>> DEPRECATED <<<<<< Usar getComponentesRGV2                  *
      *                                                                  *
      *    peBase    (input)   Parámetro Base                            *
      *    peNctw    (input)   Número de Cotización                      *
      *    peRama    (input)   Rama                                      *
      *    peArse    (input)   Secuencia artículo/rama                   *
      *    peCfpg    (output)  Forma de Pago                             *
      *    peClie    (output)  Estructura de cliente                     *
      *    pePoco    (output)  Estructura de componentes                 *
      *    pePocoC   (output)  Cantidad de componentes                   *
      *    peXrea    (output)  % de Extra Prima Variable                 *
      *    peImpu    (output)  Detalle de Prima a Premio                 *
      *    peSuma    (output)  Suma Asegurada Total                      *
      *    pePrim    (output)  Prima Total                               *
      *    pePrem    (output)  Premio Total                              *
      *    peCond    (output)  Condiciones Comerciales                   *
      *    peCon1    (output)  Condiciones Comerciales                   *
      *    peErro    (output)  Señal de Error                            *
      *    peMsgs    (output)  Mensajes de Error                         *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWRTV_getComponentesRGV...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0
     D  peClie                             likeds(ClienteCot_t)
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0
     D  peXrea                        5  2
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWRTV_getComponentesSepelio(): Retorna cotizacion de Sepelio*
      *                                 guardada.                    *
      *                                                              *
      *    peBase    (input)   Parámetro Base                        *
      *    peNctw    (input)   Número de Cotización                  *
      *    peRama    (input)   Rama                                  *
      *    peArse    (input)   Secuencia artículo/rama               *
      *    peNrpp    (output)  Forma de Pago                         *
      *    peClie    (output)  Estructura de cliente                 *
      *    peCsep    (output)  Componente de Cotizacion de Sepelio   *
      *    peXrea    (output)  % de Extra Prima Variable             *
      *    peImpu    (output)  Detalle de Prima a Premio             *
      *    peSuma    (output)  Suma Asegurada Total                  *
      *    pePrim    (output)  Prima Total                           *
      *    pePrem    (output)  Premio Total                          *
      *    peCond    (output)  Condiciones Comerciales               *
      *    peCon1    (output)  Condiciones Comerciales               *
      *    peErro    (output)  Señal de Error                        *
      *    peMsgs    (output)  Mensajes de Error                     *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRTV_getComponentesSepelio...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peNrpp                        3  0
     D  peVdes                        8  0
     D  peXpro                        3  0
     D  peClie                             likeds(ClienteCot_t)
     D  peCsep                             likeds(CompSepelio_t)
     D  peImpu                             likeds(Impuesto)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWRTV_getClienteCotizacion(): Retorna estructura peClie     *
      *                                                              *
      *    peBase    (input)   Parámetro Base                        *
      *    peNctw    (input)   Número de Cotización                  *
      *    peClie    (output)  Estructura de Cliente de Cotizacion   *
      *    peErro    (output)  Señal de Error                        *
      *    peMsgs    (output)  Mensajes de Error                     *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRTV_getClienteCotizacion...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peClie                             likeds(ClienteCot_t)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * COWRTV_getComponentesRGV2: Retorna cotización de hogar guardada  *
      *                                                                  *
      *    peBase    (input)   Parámetro Base                            *
      *    peNctw    (input)   Número de Cotización                      *
      *    peRama    (input)   Rama                                      *
      *    peArse    (input)   Secuencia artículo/rama                   *
      *    peCfpg    (output)  Forma de Pago                             *
      *    peClie    (output)  Estructura de cliente                     *
      *    pePoco    (output)  Estructura de componentes                 *
      *    pePocoC   (output)  Cantidad de componentes                   *
      *    peXrea    (output)  % de Extra Prima Variable                 *
      *    peImpu    (output)  Detalle de Prima a Premio                 *
      *    peSuma    (output)  Suma Asegurada Total                      *
      *    pePrim    (output)  Prima Total                               *
      *    pePrem    (output)  Premio Total                              *
      *    peCond    (output)  Condiciones Comerciales                   *
      *    peCon1    (output)  Condiciones Comerciales                   *
      *    peErro    (output)  Señal de Error                            *
      *    peMsgs    (output)  Mensajes de Error                         *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWRTV_getComponentesRGV2...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0
     D  peClie                             likeds(ClienteCot_t)
     D  pePoco                             likeds(UbicPoc2_t) dim(10)
     D  pePocoC                      10i 0
     D  peXrea                        5  2
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWRTV_getVehiculos4(): Recupera los bienes asegurados       *
      *                         (Vehículos).                         *
      *        Input :                                               *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de Cotización               *
      *        Output:                                               *
      *                peInfV  -  Información del Vehículo           *
      *                peErro  -  Indicador de Error                 *
      *                peMsgs  -  Estructura de Error                *
      * ------------------------------------------------------------ *
     D COWRTV_getVehiculos4...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peInfV                            likeds(Infvehi4_t) Dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

