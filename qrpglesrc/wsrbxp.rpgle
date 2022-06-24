     H*option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H option(*srcstmt:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRBXP: QUOM Versión 2                                       *
      *         Bienes por póliza.                                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *20-Jun-2017            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *   JSN 13/06/2018 - Se agrega los tags Sufijo, Código de Tipo *
      *                    de Vivienda, Código de Riesgo y Código de *
      *                    Cobertura.                                *
      *   SGF 20/06/2018 - Agrego suma de rc (rcac) y descripcion de *
      *                    Infoauto.                                 *
      *   JSN 28/06/2018 - Se agrega rsmar2 en caracteristicas.      *
      *   GIO 05/07/2018 - Proyecto: Suscripcion Poliza Electronica  *
      *                    #0315 Incluir beneficiarios retornados    *
      *                          por servicio WSLBAV                 *
      *   EXT 26/09/2018 - Recompilo por SVPVIV                      *
      *   NWN 25/10/2018 - Agrego Componente , Fecha de Ingreso a    *
      *                  - la nómina y Fecha de egreso a la nómina   *
      *   SGF 11/03/2019 - Separo RDES y NRDM.                       *
      *   JSN 29/01/2019 - Nuevos tag: <codigoDeTarifa>              *
      *                                <cantidadSiniestrosRuedas>    *
      *                                <cantidadSiniestrosCristales> *
      *                                <limiteMaximoRuedas>          *
      *                                <limiteMaximoCristales>       *
      *   JSN 04/06/2019 - Se corrige parametro en la llamada a los  *
      *                    procedimientos _getLimiteMaximoRuedas y   *
      *                    _getLimiteMaximoCristales, se reeplaza    *
      *                    peLveh(x).aucobd por peLveh(x).aucobl     *
      *   JSN 03/07/2019 - Se recompila por cambios en el SVPSIN     *
      *   SGF 21/08/2019 - Agrego fechas mercosur.                   *
      *   GIO 09/09/2019 - Scoring Agregar cuestionarios en la       *
      *                    respuesta                                 *
      *   JSN 04/11/2019 - Se edita importes de IFRA, VHVU y RCAC    *
      *   SGF 20/12/2019 - Aumento array para WSLVHP de 100 a 500.   *
      *   JSN 27/03/2020 - Se agrega array de Mascota                *
      *   SPV 24/09/2020 - Incorpora manejo nuevos campos (peNASV)   *
      *                    (Nacionalidad, Actividad y Categoria)     *
      *                  - Recuperacion de Actividad                 *
      *                    SVPDES_actividad(actividad)               *
      *   JSN 15/01/2021 - Se agregan nuevos tags:                   *
      *                    <isAscensores>                            *
      *                    <isCalderas>                              *
      *                    <resolucionAscensores>                    *
      *                    <resolucionCalderas>                      *
      *   JSN 19/03/2021 - Se agregan nuevos tags a las rutinas $auto*
      *                    $rgva y $vida:                            *
      *                    <fecEgreso>                               *
      *                    <endosoEgreso>                            *
      *   SGF 21/04/2021 - Mal el buffer de PAHRSVS. Solo recompilo. *
      *   SGF 22/04/2021 - Fechas de egreso 2050.                    *
      *   JSN 04/02/2022 - Se agrega condición para mostrar los tags *
      *                    de la rutina $boniVeh                     *
      * ************************************************************ *
     Fsehni2    if   e           k disk
     Fset001    if   e           k disk
     Fset124    if   e           k disk
     Fpahed004  if   e           k disk    rename(p1hed004:p1hed0)
     Fpaher995  if   e           k disk
     Fpaher0    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fset204    if   e           k disk
     Fset250    if   e           k disk

      /copy './qcpybooks/svpdau_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svpriv_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpviv_h.rpgle'
      /copy './qcpybooks/svpiau_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'


     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poli            s              7a
     D arcd            s              6a
     D spol            s              9a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@rama          s              2  0
     D @@repl          s          65535a
     D @@dviv          s             60a
     D @@nacr          s             40a
     D peErro          s             10i 0
     D @@Lben          ds                  likeds(beneficiarios_t) dim(100)
     D @@LbenC         s             10i 0
     D p               s             10i 0
     D q               s             10i 0
     D r               s             10i 0
     D s               s             10i 0
     D t               s             10i 0
     D u               s             10i 0
     D v               s             10i 0
     D w               s             10i 0
     D x               s             10i 0
     D y               s             10i 0
     D z               s             10i 0
     D i               s             10i 0
     D @@suas          s             15  2
     D @@cma1          s              9  0
     D @@cmo1          s              9  0
     D iaVehi          ds                  likeds(iauto2_t)
     D @@Csru          s             10i 0
     D @@Cscr          s             10i 0
     D @@Lmru          s             15  2
     D @@Lmcr          s             15  2

      * ------------------------------------------------------------ *
      * WSLVHP: Vehiculos de poliza
      * ------------------------------------------------------------ *
     D WSLVHP          pr                  ExtPgm('WSLVHP')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peLveh                            likeds(pahaut_t) dim(500)
     D   peLvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D peLveh          ds                  likeds(pahaut_t) dim(500)
     D peLvehC         s             10i 0
     D rcac            s             30a
     D ifra            s             30a
     D vhvu            s             30a
     D claj            s             10a
     D origen          s             10a
     D gnc             s              2a
     D porc            s             10a
     D vacc            s             30a
     D tacc            s              2a
     D expp            s             10a
     D fnacVida        s             10a
     D fingVida        s             10a
     D fegrVida        s             10a
     D fingAuto        s             10a
     D fegrAuto        s             10a
     D fegrRgva        s             10a
     D suasVida        s             30a
     D nrdoVida        s             20a
     D fecha           s              8  0
     D sumaCobVida     s             30a
     D emst            s             30a
     D emsc            s             30a
     D emsm            s             30a
     D eslo            s             10a
     D mang            s             10a
     D punt            s             10a
     D sumaCob         s             30a
     D tasaCob         s             30a
     D primCob         s             30a
     D arta            s             20a
     D obj             s             70a
     D osu             s             30a
     D vto             s             10a
     D fcu             s             10a
     D @@tipo          s             30a

      * ------------------------------------------------------------ *
      * WSLVHC: Cláusulas de vehículo
      * ------------------------------------------------------------ *
     D WSLVHC          pr                  ExtPgm('WSLVHC')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peCveh                            likeds(pahautc_t) dim(30)
     D   peCvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)
     D   peCveh        ds                  likeds(pahautc_t) dim(30)
     D   peCvehC       s             10i 0

      * ------------------------------------------------------------ *
      * WSLDCA: Descripción cobertura de autos
      * ------------------------------------------------------------ *
     D WSLDCA          pr                  ExtPgm('WSLDCA')
     D   peBase                            likeds(paramBase) const
     D   peCobl                       2    const
     D   peDcob                            likerec(s1t124) dim(999)
     D   peDcobC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)
     D   peDcob        ds                  likerec(s1t124) dim(999)
     D   peDcobC       s             10i 0

      * ------------------------------------------------------------ *
      * WSLVHB: Bonificaciones/Recargos Autos
      * ------------------------------------------------------------ *
     D WSLVHB          pr                  ExtPgm('WSLVHB')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peBveh                            likeds(pahaut1_t) dim(999)
     D   peBvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)
     D   peBveh        ds                  likeds(pahaut1_t) dim(999)
     D   peBvehC       s             10i 0

      * ------------------------------------------------------------ *
      * WSLVHA: Accesorios
      * ------------------------------------------------------------ *
     D WSLVHA          pr                  ExtPgm('WSLVHA')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peAveh                            likeds(pahaut4_t) dim(99)
     D   peAvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)
     D   peAveh        ds                  likeds(pahaut4_t) dim(99)
     D   peAvehC       s             10i 0

      * ------------------------------------------------------------ *
      * WSLVHR: Nomina de conductores
      * ------------------------------------------------------------ *
     D WSLVHR          pr                  ExtPgm('WSLVHR')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peCveh                            likeds(pahaut6_t) dim(100)
     D   peCvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)
     D   peNcon        ds                  likeds(pahaut6_t) dim(100)
     D   peNconC       s             10i 0

      * ------------------------------------------------------------ *
      * WSLVHN: Carta de daños
      * ------------------------------------------------------------ *
     D WSLVHN          pr                  ExtPgm('WSLVHN')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peNveh                            likeds(pahaut5_t) dim(100)
     D   peNvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)
     D   peNveh        ds                  likeds(pahaut5_t) dim(100)
     D   peNvehC       s             10i 0

      * ------------------------------------------------------------ *
      * WSLNAV: Nómina de Vida
      * ------------------------------------------------------------ *
     D WSLNAV          pr                  ExtPgm('WSLNAV')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keynav_t) const
     D   pePreg                            likeds(keynav_t)
     D   peUreg                            likeds(keynav_t)
     D   peNasv                            likeds(pahvid0_t) dim(99)
     D   peNasvC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D peRoll          s              1a
     D nasvPosi        ds                  likeds(keynav_t)
     D nasvPreg        ds                  likeds(keynav_t)
     D nasvUreg        ds                  likeds(keynav_t)
     D peNasv          ds                  likeds(pahvid0_t) dim(99)
     D peNasvC         s             10i 0
     D peMore          s              1n

      * ------------------------------------------------------------ *
      * WSLRCA: Riesgos y Coberturas de Vida
      * ------------------------------------------------------------ *
     D WSLRCA          pr                  ExtPgm('WSLRCA')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peLryc                            likeds(pahvid1_t) dim(30)
     D   peLrycC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D peLryc          ds                  likeds(pahvid1_t) dim(30)
     D peLrycC         s             10i 0

      * ------------------------------------------------------------ *
      * WSLUBP: Ubicaciones de RV
      * ------------------------------------------------------------ *
     D WSLUBP          pr                  extpgm('WSLUBP')
     D  peBase                             likeds(parambase) const
     D  peCant                       10i 0 const
     D  peRoll                        1    const
     D  pePosi                             likeds(keyubp_t) const
     D  pePreg                             likeds(keyubp_t)
     D  peUreg                             likeds(keyubp_t)
     D  peLubi                             likeds(pahrsvs_t) dim(99)
     D  peLubic                      10i 0
     D  peMore                         n
     D  peErro                             like(paramerro)
     D  peMsgs                             likeds(parammsgs)
     D  peLubi         ds                  likeds(pahrsvs_t) dim(99)
     D  peLubic        s             10i 0
     D  ubpPosi        ds                  likeds(keyubp_t)
     D  ubpPreg        ds                  likeds(keyubp_t)
     D  ubpUreg        ds                  likeds(keyubp_t)

      * ------------------------------------------------------------ *
      * WSLUBR: Riesgos y Coberturas RV
      * ------------------------------------------------------------ *
     D WSLUBR          pr                  ExtPgm('WSLUBR')
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peSpol                        9  0 const
     D  pePoco                        4  0 const
     D  peLryc                             likeds(pahrsvs1_t) dim(99)
     D  peLrycC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)
     D  ubrLryc        ds                  likeds(pahrsvs1_t) dim(99)
     D  ubrLrycC       s             10i 0

      * ------------------------------------------------------------ *
      * WSLUBC: Clasulas RV
      * ------------------------------------------------------------ *
     D WSLUBC          pr                  ExtPgm('WSLUBC')
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peSpol                        9  0 const
     D  pePoco                        4  0 const
     D  peCubi                             likeDs(pahrsvs4_t)  DIM(60)
     D  peCubic                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)
     D  peCubi         ds                  likeDs(pahrsvs4_t)  DIM(60)
     D  peCubic        s             10i 0

      * ------------------------------------------------------------ *
      * WSLUBT: Caracteristicas
      * ------------------------------------------------------------ *
     D WSLUBT          pr                  ExtPgm('WSLUBT')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keyubt_t) const
     D   pePreg                            likeds(keyubt_t)
     D   peUreg                            likeds(keyubt_t)
     D   peCubi                            likeds(pahrsvs6_t) dim(99)
     D   peCubiC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)
     D ubtPosi         ds                  likeds(keyubt_t)
     D ubtPreg         ds                  likeds(keyubt_t)
     D ubtUreg         ds                  likeds(keyubt_t)
     D ubtCubi         ds                  likeds(pahrsvs6_t) dim(99)
     D ubtCubic        s             10i 0

     D WSLUBO          pr                  ExtPgm('WSLUBO')
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peSpol                        9  0 const
     D  pePoco                        4  0 const
     D  peRiec                        3    const
     D  peXcob                        3  0 const
     D  peOaco                             likeds(pahrsvs2_t) dim(100)
     D  peOacoC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)
     D  peOaco         ds                  likeds(pahrsvs2_t) dim(100)
     D  peOacoC        s             10i 0

     D WSLUBM          pr                  ExtPgm('WSLUBM')
     D  peBase                             likeds(paramBase) const
     D  peCant                       10i 0 const
     D  peRoll                        1a   const
     D  pePosi                             likeds(keyubm_t) const
     D  pePreg                             likeds(keyubm_t)
     D  peUreg                             likeds(keyubm_t)
     D  peMubi                             likeds(pahrsvs5_t) dim(99)
     D  peMubiC                      10i 0
     D  peMore                         n
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)
     D  ubmPosi        ds                  likeds(keyubm_t)
     D  ubmPreg        ds                  likeds(keyubm_t)
     D  ubmUreg        ds                  likeds(keyubm_t)
     D  peMubi         ds                  likeds(pahrsvs5_t) dim(99)
     D  peMubiC        s             10i 0

     D WSLUBF          pr                  ExtPgm('WSLUBF')
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peSpol                        9  0 const
     D  pePoco                        4  0 const
     D  peRiec                        3    const
     D  peXcob                        3  0 const
     D  peFran                             likeds(rvfranq_t)
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)
     D  peFran         ds                  likeds(rvfranq_t)

      * ------------------------------------------------------------ *
      * WSLEMB: Barcos
      * ------------------------------------------------------------ *
     D WSLEMB          pr                  ExtPgm('WSLEMB')
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peSpol                        9  0 const
     D  pePoco                        4  0 const
     D  peDemb                             likeds(barcos_t)
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)
     D  peDemb         ds                  likeds(barcos_t)

      * ------------------------------------------------------------ *
      * WSLBAV: Beneficiarios asegurado vida
      * ------------------------------------------------------------ *
     D WSLBAV          pr                  ExtPgm('WSLBAV')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peLben                            likeds(beneficiarios_t) dim(100)
     D   peLbenC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * SPVIG3: Auto Vigente
      * ------------------------------------------------------------ *
     D SPVIG3          pr                  ExtPgm('SPVIG3')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peRama                        2  0
     D  peArse                        2  0
     D  peOper                        7  0
     D  pePoco                        4  0
     D  peFvig                        8  0 const
     D  peFemi                        8  0 const
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3    const
     D  peSpvig2                      1n   options(*nopass) const

      * ------------------------------------------------------------ *
      * SPVIG4: RV Vigente
      * ------------------------------------------------------------ *
     D SPVIG4          pr                  ExtPgm('SPVIG4')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peRama                        2  0
     D  peArse                        2  0
     D  peOper                        7  0
     D  pePoco                        4  0
     D  peFvig                        8  0 const
     D  peFemi                        8  0 const
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3    const

      * ------------------------------------------------------------ *
      * SPVIG5: Vida Vigente
      * ------------------------------------------------------------ *
     D SPVIG5          pr                  ExtPgm('SPVIG5')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peRama                        2  0
     D  peArse                        2  0
     D  peOper                        7  0
     D  pePoco                        6  0
     D  pePaco                        3  0
     D  peFvig                        8  0 const
     D  peFemi                        8  0 const
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3    const
     D  peSpvig2                      1n   options(*nopass) const
     D  peNomi                        1n   options(*nopass) const

      * ------------------------------------------------------------ *
      * PAR310X3: Fecha de Hoy
      * ------------------------------------------------------------ *
     D PAR310X3        pr                  ExtPgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D hoy             s              8  0
     D viStat          s              1n
     D viSspo          s              3  0
     D viSuop          s              3  0
     D @@poco          s              4  0
     D @2poco          s              6  0
     D @@paco          s              3  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D altaGama        s              1n
     D desdeMerc       s              8  0
     D hastaMerc       s              8  0
     D @@Dtma          s             40a
     D @@Draz          s             40a
     D @Msuas          s             30a
     D GrupoRama       s              1a
     D @@Vsys          s            512
     D Rasc            s             50a
     D Rcal            s             50a
     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D k1hni2          ds                  likerec(s1hni2:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1her9          ds                  likerec(p1her9:*key)
     D k1her0          ds                  likerec(p1her0:*key)
     D k1t204          ds                  likerec(s1t204:*key)
     D k1y250          ds                  likerec(s1t250:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

     D @@Dst3          ds                  likeds ( dspahet3_t ) dim( 999 )
     D @@Dst3C         s             10i 0
     D @@DsRa          ds                  likeds ( dspahera_t ) dim( 999 )
     D @@DsRaC         s             10i 0
     D @@Primer        s               n
     D @@HayCuest      s               n
     D peForm          s              1a   inz('S')

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
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);

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

       if %check( '0123456789' : %trim(rama) ) <> 0;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       @@rama = %dec( rama : 2 : 0 );
       chain @@rama set001;
       if not %found;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if %check( '0123456789' : %trim(poli) ) <> 0;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       PAR310X3( empr : peFema : peFemm : peFemd );
       hoy = (peFema * 10000) + (peFemm * 100) + peFemd;

       k1hed0.d0empr = empr;
       k1hed0.d0sucu = sucu;
       k1hed0.d0rama = %dec( rama : 2 : 0 );
       k1hed0.d0poli = %dec( poli : 7 : 0 );
       setgt  %kds(k1hed0:4) pahed004;
       readpe %kds(k1hed0:4) pahed004;
       if %eof;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRBXP':peBase);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'bienesPoliza' : '*BEG' );

       select;
        when t@rame = 4;
             REST_writeXmlLine( 'bienesAuto' : '*BEG' );
             exsr $auto;
             REST_writeXmlLine( 'bienesAuto' : '*END' );
             REST_writeXmlLine( 'bienesRgVa' : '*BEG' );
             REST_writeXmlLine( 'bienesRgVa' : '*END' );
             REST_writeXmlLine( 'bienesVida' : '*BEG' );
             REST_writeXmlLine( 'bienesVida' : '*END' );
             REST_writeXmlLine( 'bienesCasc' : '*BEG' );
             REST_writeXmlLine( 'bienesCasc' : '*END' );
        when t@rame = 18 or t@rame = 21;
             REST_writeXmlLine( 'bienesAuto' : '*BEG' );
             REST_writeXmlLine( 'bienesAuto' : '*END' );
             REST_writeXmlLine( 'bienesRgVa' : '*BEG' );
             REST_writeXmlLine( 'bienesRgVa' : '*END' );
             REST_writeXmlLine( 'bienesVida' : '*BEG' );
             exsr $vida;
             REST_writeXmlLine( 'bienesVida' : '*END' );
             REST_writeXmlLine( 'bienesCasc' : '*BEG' );
             REST_writeXmlLine( 'bienesCasc' : '*END' );
        when t@rama = 17;
             REST_writeXmlLine( 'bienesAuto' : '*BEG' );
             REST_writeXmlLine( 'bienesAuto' : '*END' );
             REST_writeXmlLine( 'bienesRgVa' : '*BEG' );
             REST_writeXmlLine( 'bienesRgVa' : '*END' );
             REST_writeXmlLine( 'bienesVida' : '*BEG' );
             REST_writeXmlLine( 'bienesVida' : '*END' );
             REST_writeXmlLine( 'bienesCasc' : '*BEG' );
             exsr $casc;
             REST_writeXmlLine( 'bienesCasc' : '*END' );
        other;
             REST_writeXmlLine( 'bienesAuto' : '*BEG' );
             REST_writeXmlLine( 'bienesAuto' : '*END' );
             REST_writeXmlLine( 'bienesRgVa' : '*BEG' );
             exsr $rgva;
             REST_writeXmlLine( 'bienesRgVa' : '*END' );
             REST_writeXmlLine( 'bienesVida' : '*BEG' );
             REST_writeXmlLine( 'bienesVida' : '*END' );
             REST_writeXmlLine( 'bienesCasc' : '*BEG' );
             REST_writeXmlLine( 'bienesCasc' : '*END' );
       endsl;

       REST_writeXmlLine( 'bienesPoliza' : '*END' );
       REST_end();

       SPVIG3( d0arcd
             : d0spol
             : d0rama
             : d0arse
             : d0oper
             : @@poco
             : hoy
             : hoy
             : viStat
             : viSspo
             : viSuop
             : 'FIN'
             : *off      );

       SPVIG4( d0arcd
             : d0spol
             : d0rama
             : d0arse
             : d0oper
             : @@poco
             : hoy
             : hoy
             : viStat
             : viSspo
             : viSuop
             : 'FIN'     );

       SPVIG5( d0arcd
             : d0spol
             : d0rama
             : d0arse
             : d0oper
             : @2poco
             : @@paco
             : hoy
             : hoy
             : viStat
             : viSspo
             : viSuop
             : 'FIN'
             : *on
             : *on      );

       close *all;

       return;

       begsr $auto;


        if SPVSPO_getFecVig( d0empr
                           : d0sucu
                           : d0arcd
                           : d0spol
                           : desdeMerc
                           : hastaMerc ) = *off;
           desdeMerc  = 00010101;
           hastaMerc  = 00010101;
        endif;

        clear peLveh;
        clear peMsgs;
        peLvehC = 0;

        WSLVHP( peBase
              : %dec(rama:2:0)
              : %dec(poli:7:0)
              : %dec(spol:9:0)
              : peLveh
              : peLvehC
              : peErro
              : peMsgs );

        if peErro = 0;
           for x = 1 to peLVehC;
            ifra = SVPREST_editImporte( peLveh(x).auifra );
            vhvu = SVPREST_editImporte( peLveh(x).auvhvu );
            claj = %editw(peLveh(x).auclaj: '   .  ');
            rcac = SVPREST_editImporte( peLveh(x).aurcac );
            origen = *blanks;
            if peLveh(x).auvhni = 'N';
               origen = 'NACIONAL';
            endif;
            if peLveh(x).auvhni = 'I';
               origen = 'IMPORTADO';
            endif;
            gnc = 'NO';
            if peLveh(x).auvhv2 = 5 or peLveh(x).auvhv2 = 6;
               gnc = 'SI';
            endif;
            REST_writeXmlLine( 'vehiculo' : '*BEG' );
            REST_writeXmlLine( 'anio':%char(peLveh(x).auvhan));
            REST_writeXmlLine( 'patente':peLveh(x).aupatente);
            REST_writeXmlLine( 'asisMec':peLveh(x).auamec );
            REST_writeXmlLine( 'marca' : peLveh(x).auvhmd );
            REST_writeXmlLine( 'chasis': peLveh(x).auchas );
            REST_writeXmlLine( 'asisTec':peLveh(x).auatec );
            REST_writeXmlLine( 'modelo':peLveh(x).auvhdm );
            REST_writeXmlLine( 'motor' : peLveh(x).aumoto );
            REST_writeXmlLine( 'franq' : %trim(ifra)     );
            REST_writeXmlLine( 'version':peLveh(x).auvhds );
            REST_writeXmlLine( 'uso'   : peLveh(x).auvhdu );
            REST_writeXmlLine( 'clauAju': %trim(claj)     );
            REST_writeXmlLine( 'zona'  : %char(peLveh(x).auscta));
            REST_writeXmlLine( 'cobertura': peLveh(x).aucobd );
            REST_writeXmlLine( 'tipo'  : peLveh(x).auvhdt );
            REST_writeXmlLine( 'sumaAsegurada'  : %trim(vhvu) );
            REST_writeXmlLine( 'origen': %trim(origen) );
            REST_writeXmlLine( 'Acreed': peLveh(x).aunomb );
            REST_writeXmlLine( 'gnc'   : gnc );
            REST_writeXmlLine( 'tarCir': peLveh(x).aunmer );
            REST_writeXmlLine('carroceria':peLveh(x).auvhcd );

            exsr $clauVeh;
            exsr $boniVeh;
            exsr $acceVeh;
            exsr $condVeh;
            exsr $daÑoVeh;

            @@poco = peLveh(x).aupoco;
            SPVIG3( d0arcd
                  : d0spol
                  : d0rama
                  : d0arse
                  : d0oper
                  : @@poco
                  : hoy
                  : hoy
                  : viStat
                  : viSspo
                  : viSuop
                  : *blanks
                  : *off      );
            if viStat;
               REST_writeXmlLine( 'estaVigente': 'S' );
             else;
               REST_writeXmlLine( 'estaVigente': 'N' );
            endif;

            k1t204.t@vhmc = peLveh(x).auvhmc;
            k1t204.t@vhmo = peLveh(x).auvhmo;
            k1t204.t@vhcs = peLveh(x).auvhcs;
            chain %kds(k1t204:3) set204;
            if %found;
               @@cma1 = t@cma1;
               @@cmo1 = t@cmo1;
             else;
               @@cma1 = 0;
               @@cmo1 = 0;
            endif;

            if SVPIAU_getVehicul2( @@cma1: @@cmo1: iaVehi ) = 0;
               REST_writeXmlLine('descInfoAuto'
                                : %trim(iaVehi.i@dmar)
                                + ' '
                                + %trim(iaVehi.i@dmod)  );
             else;
               REST_writeXmlLine('descInfoAuto'
                                : %trim(peLveh(x).auvhmd)
                                + ' '
                                + %trim(peLveh(x).auvhdm)
                                + ' '
                                + %trim(peLveh(x).auvhds) );
            endif;

            REST_writeXmlLine('sumaAseguradaRc':rcac);
            REST_writeXmlLine( 'nroComponente' : %char(@@poco) );
                fecha = (peLveh(x).auainn * 10000)
                      + (peLveh(x).auminn *   100)
                      +  peLveh(x).audinn;
                monitor;
                  fingAuto  = %char(%date(fecha:*iso):*iso);
                 on-error;
                  fingAuto = *blanks;
                endmon;
                if fingAuto = '0001-01-01';
                  fingAuto = *blanks;
                endif;
            REST_writeXmlLine( 'fecIngAuto' : fingAuto);
                fecha = (peLveh(x).auaegn * 10000)
                      + (peLveh(x).aumegn *   100)
                      +  peLveh(x).audegn;
                monitor;
                  fegrAuto  = %char(%date(fecha:*iso):*iso);
                 on-error;
                  fegrAuto = *blanks;
                endmon;
                if fegrAuto = '0001-01-01';
                  fegrAuto = *blanks;
                endif;
            REST_writeXmlLine( 'fecEgrAuto' : fegrAuto);

            REST_writeXmlLine( 'codigoDeTarifa' : %char(peLveh(x).aucTre) );

            clear @@Csru;
            @@Csru = SVPSIN_getCantidadSiniestrosRuedasPorVehiculo(
                     peBase.peEmpr
                   : peBase.peSucu
                   : peLveh(x).aupatente
                   : %dec(rama:2:0)
                   : %dec(poli:7:0)      );

            if @@Csru = *zeros;
              REST_writeXmlLine( 'cantidadSiniestrosRuedas' : '0' );
            else;
              REST_writeXmlLine( 'cantidadSiniestrosRuedas' :
                                  %char(@@Csru) );
            endif;

            clear @@Cscr;
            @@Cscr = SVPSIN_getCantidadSiniestrosCristalesPorVehiculo(
                     peBase.peEmpr
                   : peBase.peSucu
                   : peLveh(x).aupatente
                   : %dec(rama:2:0)
                   : %dec(poli:7:0)      );

            if @@Cscr = *zeros;
              REST_writeXmlLine( 'cantidadSiniestrosCristales' : '0' );
            else;
              REST_writeXmlLine( 'cantidadSiniestrosCristales' :
                                  %char(@@Cscr) );
            endif;

            clear @@Lmru;
            SPVVEH_getLimiteMaximoRuedas( peLveh(x).aucTre
                                        : peLveh(x).aucobl
                                        : @@Lmru           );

            if @@Lmru = *zeros;
              REST_writeXmlLine( 'limiteMaximoRuedas' : '0.00' );
            else;
              REST_writeXmlLine( 'limiteMaximoRuedas' :
                                  %editw(@@Lmru:'             .  ') );
            endif;

            clear @@Lmcr;
            SPVVEH_getLimiteMaximoCristales( peLveh(x).aucTre
                                           : peLveh(x).aucobl
                                           : @@Lmcr           );

            if altaGama;
              REST_writeXmlLine( 'limiteMaximoCristales' :
                                 '9999999999999.99' );
            else;
              if @@Lmcr = *zeros;
                REST_writeXmlLine( 'limiteMaximoCristales' : '0.00' );
              else;
                REST_writeXmlLine( 'limiteMaximoCristales' :
                                    %editw(@@Lmcr:'             .  ') );
              endif;
            endif;

            REST_writeXmlLine( 'desdeTarjeta'
                             : SVPREST_editFecha(desdeMerc) );
            REST_writeXmlLine( 'hastaTarjeta'
                             : SVPREST_editFecha(hastaMerc) );

            exsr $Cuestionarios;

            if fegrAuto = *blanks;
              REST_writeXmlLine( 'fecEgreso' : '2050-12-31');
            else;
              REST_writeXmlLine( 'fecEgreso' : fegrAuto);
            endif;
            REST_writeXmlLine( 'endosoEgreso' : %editc(peLveh(x).auSuen:'X'));

            REST_writeXmlLine( 'vehiculo' : '*END' );
           endfor;
         REST_writeXmlLine( 'cantidadVeh' : %char(peLvehC) );
        endif;

       endsr;

       begsr $clauVeh;

        clear peDcob;
        peDcobC = 0;

        WSLDCA( peBase
              : peLveh(x).aucobl
              : peDcob
              : peDcobC
              : peErro
              : peMsgs            );

        REST_writeXmlLine( 'descripcionCobAuto' : '*BEG' );
        for z = 1 to peDcobC;
            REST_write( ' ' + %trim(peDcob(z).t@tpds) );
        endfor;
        REST_writeXmlLine( 'descripcionCobAuto' : '*END' );

        REST_writeXmlLine( 'clausulas' : '*BEG' );

        WSLVHC( peBase
              : %dec(rama:2:0)
              : %dec(poli:7:0)
              : %dec(spol:9:0)
              : peLveh(x).aupoco
              : peCveh
              : peCvehC
              : peErro
              : peMsgs           );

        if peErro = 0;
           for y = 1 to peCvehC;
               REST_writeXmlLine( 'clausula' : peCveh(y).auclan);
           endfor;
        endif;

        REST_writeXmlLine( 'clausulas' : '*END' );

       endsr;

       begsr $boniVeh;

        clear peBveh;
        peBvehC = 0;
        altaGama = *off;

        WSLVHB( peBase
              : %dec(rama:2:0)
              : %dec(poli:7:0)
              : %dec(spol:9:0)
              : peLveh(x).aupoco
              : peBveh
              : peBvehC
              : peErro
              : peMsgs           );

        REST_writeXmlLine( 'bonificacionesAuto' : '*BEG' );
        if peErro = 0;
          for w = 1 to peBvehC;
           if SVPDAU_visualizarWeb( empr
                                  : sucu
                                  : %dec(arcd:6:0)
                                  : %dec(rama:2:0)
                                  : peBveh(w).auccbp
                                  : 'C'              );

            porc = %editw(peBveh(w).aupcbp:'   .  ');
            REST_writeXmlLine( 'bonificacionAuto' : '*BEG' );
            REST_writeXmlLine( 'bonificacionNombre' : peBveh(w).audcbp);
            REST_writeXmlLine( 'bonificacionPorcen' : %trim(porc) );
            REST_writeXmlLine( 'bonificacionAuto' : '*END' );

            k1y250.stEmpr = peBase.peEmpr;
            k1y250.stSucu = peBase.peSucu;
            k1y250.stArcd = %dec(arcd:6:0);
            k1y250.stRama = %dec(rama:2:0);
            k1y250.stCcbp = peBveh(w).auccbp;
            chain %kds( k1y250 : 5 ) set250;
            if %found( set250) and stCcbe = 'AG';
              altaGama = *on;
            endif;
           endif;
          endfor;
        endif;
        REST_writeXmlLine( 'bonificacionesAuto' : '*END' );

       endsr;

       begsr $acceVeh;

        clear peAveh;
        peAvehC = 0;

        WSLVHA( peBase
              : %dec(rama:2:0)
              : %dec(poli:7:0)
              : %dec(spol:9:0)
              : peLveh(x).aupoco
              : peAveh
              : peAvehC
              : peErro
              : peMsgs           );

        REST_writeXmlLine( 'accesoriosAuto' : '*BEG' );
        if peErro = 0;
           for v = 1 to peAvehC;
            vacc = %editw(peAveh(w).a4accv:'             .  ');
            if peAveh(w).a4acct = 'TARIFABLE';
               tacc = 'SI';
             else;
               tacc = 'NO';
            endif;
            REST_writeXmlLine( 'accesorioAuto': '*BEG' );
            REST_writeXmlLine( 'accesorioNombre'    : peAveh(v).a4accd);
            REST_writeXmlLine( 'accesorioValor'     : %trim(vacc) );
            REST_writeXmlLine( 'accesorioTipo'      : tacc        );
            REST_writeXmlLine( 'accesorioAuto'    : '*END' );
           endfor;
        endif;
        REST_writeXmlLine( 'accesoriosAuto' : '*END' );

       endsr;

       begsr $condVeh;

        clear peNcon;
        peNconC = 0;

        WSLVHR( peBase
              : %dec(rama:2:0)
              : %dec(poli:7:0)
              : %dec(spol:9:0)
              : peLveh(x).aupoco
              : peNcon
              : peNconC
              : peErro
              : peMsgs           );

        REST_writeXmlLine( 'conductoresAuto': '*BEG' );
        if peErro = 0;
           for u = 1 to peNconC;
            monitor;
              expp = %char(%date(peNcon(u).auexpp:*iso):*iso);
             on-error;
              expp = *blanks;
            endmon;
            if expp = '0001-01-01';
               expp = *blanks;
            endif;
            REST_writeXmlLine( 'conductorAuto': '*BEG' );
            REST_writeXmlLine( 'conductorNombre'    : peNcon(u).aunomb);
            REST_writeXmlLine( 'conductorApellido'  : peNcon(u).auapel);
            REST_writeXmlLine( 'conductorNroReg'    : peNcon(u).aunreg);
            REST_writeXmlLine( 'conductorRegVto'    : %trim(expp) );
            REST_writeXmlLine( 'conductorAuto'    : '*END' );
           endfor;
        endif;
        REST_writeXmlLine( 'conductoresAuto': '*END' );

       endsr;

       begsr $daÑoVeh;

        clear peNveh;
        peNvehC = 0;

        WSLVHN( peBase
              : %dec(rama:2:0)
              : %dec(poli:7:0)
              : %dec(spol:9:0)
              : peLveh(x).aupoco
              : peNveh
              : peNvehC
              : peErro
              : peMsgs           );

        REST_writeXmlLine( 'daniosAuto': '*BEG' );
        if peErro = 0;
           for t = 1 to peNvehC;
            REST_writeXmlLine( 'danioAuto': '*BEG' );
            REST_writeXmlLine( 'danioNombre'  : peNveh(t).auddan);
            REST_writeXmlLine( 'danioEstado'  : peNveh(t).auedda);
            REST_writeXmlLine( 'danioAuto'    : '*END' );
           endfor;
        endif;
        REST_writeXmlLine( 'daniosAuto': '*END' );

       endsr;

       begsr $Cuestionarios;

         clear @@Dst3;
         clear @@Dst3C;
         @@Primer = *off;
         @@HayCuest = *off;

         if SPVVEH_getPahet3( peBase.peEmpr
                            : peBase.peSucu
                            : d0arcd
                            : d0spol
                            : d0rama
                            : d0arse
                            : peLveh(x).aupoco
                            : viSspo
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : @@Dst3
                            : @@Dst3C
                            : peForm  );

           for p = 1 to @@Dst3C;

             if @@Dst3(p).t3taaj <> *zeros;

               @@HayCuest = *on;

               if not @@Primer;

                 @@Primer = *on;

                 REST_writeXmlLine( 'scoring': '*BEG' );

                 REST_writeXmlLine( 'codigoTabla'
                                  : %editc(@@Dst3(p).t3taaj:'X') );

                 REST_writeXmlLine( 'descripcionTabla'
                               : %trim(SVPDES_cuestionario(@@Dst3(p).t3taaj)) );

                 REST_writeXmlLine( 'tipoAjuste'
                                  : %trim(@@Dst3(p).t3tiaj) );

                 REST_writeXmlLine( 'formaAplicacion'
                                  : %trim(@@Dst3(p).t3tiac) );

                 REST_writeXmlLine( 'preguntas': '*BEG' );

               endif;

               REST_writeXmlLine( 'pregunta': '*BEG' );

               REST_writeXmlLine( 'codigoItem'
                                : %trim(@@Dst3(p).t3cosg) );

               REST_writeXmlLine( 'descripcionItem'
                                : %trim(SVPDES_pregunta( @@Dst3(p).t3taaj
                                                       : @@Dst3(p).t3cosg) ));

               REST_writeXmlLine( 'respuesta'
                                : %trim(@@Dst3(p).t3vefa) );

               REST_writeXmlLine( 'ajusteRc'
                                : %trim(%editw(@@Dst3(p).t3corc:'  0.    ')) );

               REST_writeXmlLine( 'ajusteCasco'
                                : %trim(%editw(@@Dst3(p).t3coca:'  0.    ')) );

               REST_writeXmlLine( 'cantidad'
                                : %editc(@@Dst3(p).t3Cant:'X') );

               REST_writeXmlLine( 'pregunta': '*END' );

             endif;

           endfor;

         endif;

         if not @@HayCuest;

           REST_writeXmlLine( 'scoring' : '*BEG' );
           REST_writeXmlLine( 'scoring' : '*END' );

         else;

           REST_writeXmlLine( 'preguntas' : '*END' );
           REST_writeXmlLine( 'scoring' : '*END' );

         endif;

       endsr;

       begsr $rgva;

        clear peLubi;
        clear peMsgs;
        clear ubpPosi;
        clear ubpPreg;
        clear ubpUreg;
        clear ubrLryc;
        clear peCubi;

        ubpPosi.r9rama = d0rama;
        ubpPosi.r9poli = d0poli;
        ubpPosi.r9spol = d0spol;
        ubpPosi.r9arcd = d0arcd;
        ubpPosi.r9oper = d0oper;

        WSLUBP( peBase
              : 99
              : 'I'
              : ubpPosi
              : ubpPreg
              : ubpUreg
              : peLubi
              : peLubiC
              : peMore
              : peErro
              : peMsgs );

       if peErro = 0;

        for x = 1 to peLubiC;

         @@dviv = *blanks;

         k1her9.r9empr = d0empr;
         k1her9.r9sucu = d0sucu;
         k1her9.r9rama = d0rama;
         k1her9.r9poli = d0poli;
         k1her9.r9spol = d0spol;
         k1her9.r9poco = peLubi(x).rspoco;
         k1her9.r9arcd = d0arcd;
         k1her9.r9spol = d0spol;
         k1her9.r9arse = d0arse;
         k1her9.r9oper = d0oper;
         chain %kds(k1her9) paher995;
         if %found;
            k1her0.r0empr = r9empr;
            k1her0.r0sucu = r9sucu;
            k1her0.r0arcd = r9arcd;
            k1her0.r0spol = r9spol;
            k1her0.r0sspo = r9sspo;
            k1her0.r0rama = r9rama;
            k1her0.r0arse = r9arse;
            k1her0.r0oper = r9oper;
            k1her0.r0poco = r9poco;
            k1her0.r0suop = r9sspo;
            chain %kds(k1her0) paher0;
            if %found;
               @@dviv = SVPVIV_getDescViv(r0cviv);
            endif;
         endif;

         suasVida = %editw(peLubi(x).rssuas:'             ');
         arta = %trim(%char(peLubi(x).rsctar))
              + '-'
              + peLubi(x).rscta1
              + '-'
              + peLubi(x).rscta2;
         REST_writeXmlLine( 'ubicacion' : '*BEG' );
         REST_writeXmlLine( 'riesgo'    : peLubi(x).rsctds );
         REST_writeXmlLine( 'producto'  : peLubi(x).rsprds );
         REST_writeXmlLine( 'artTarifa' : arta             );
         REST_writeXmlLine( 'sumaTotal' : suasVida         );
         REST_writeXmlLine( 'zona'      : %char(peLubi(x).rszrrv) );
         REST_writeXmlLine( 'direccion' : peLubi(x).rsubic );
         REST_writeXmlLine( 'provincia' : peLubi(x).rsprod );
         REST_writeXmlLine( 'localidad' : peLubi(x).rsloca );
         REST_writeXmlLine( 'codPostal' : %char(peLubi(x).rsCopo) );
         REST_writeXmlLine( 'sufijo'    : %editc(pelubi(x).rsCops:'X') );
         REST_writeXmlLine( 'ocupacion' : peLubi(x).rsctds );
         REST_writeXmlLine( 'codTipoViv': %editc(peLubi(x).rsTviv:'X') );
         REST_writeXmlLine('tipoVivienda':%trim(@@dviv));
         @@nacr = *blanks;
         chain peLubi(x).rsacrc gnhdaf;
         if %found;
            @@nacr = dfnomb;
         endif;
         REST_writeXmlLine('acreedor':@@nacr);

         clear ubtPosi;
         clear ubtPreg;
         clear ubtUreg;
         clear ubtCubi;
         ubtPosi.r6arcd = d0arcd;
         ubtPosi.r6spol = d0spol;
         ubtPosi.r6sspo = 0;
         ubtPosi.r6rama = d0rama;
         ubtPosi.r6poli = d0poli;
         ubtPosi.r6arse = d0arse;
         ubtPosi.r6oper = d0oper;
         ubtPosi.r6poco = peLubi(x).rspoco;
         ubtPosi.r6suop = 0;
         WSLUBT( peBase
               : 99
               : 'I'
               : ubtPosi
               : ubtPreg
               : ubtUreg
               : ubtCubi
               : ubtCubiC
               : peMore
               : peErro
               : peMsgs    );
         REST_writeXmlLine( 'caracteristicas' : '*BEG' );
         if peErro = 0;
          for r = 1 to ubtCubiC;
           REST_writeXmlLine( 'caracteristica' : '*BEG' );
           REST_writeXmlLine( 'detalle'  : ubtCubi(r).rsdcba );
           REST_writeXmlLine( 'contiene' : ubtCubi(r).rsmar1 );
           REST_writeXmlLine( 'aplica'   : ubtCubi(r).rsmar2 );
           REST_writeXmlLine( 'caracteristica' : '*END' );
          endfor;
         endif;
         REST_writeXmlLine( 'caracteristicas' : '*END' );

         clear ubmPosi;
         clear ubmPreg;
         clear ubmUreg;
         ubmPosi.r5rama = d0rama;
         ubmPosi.r5poli = d0poli;
         ubmPosi.r5spol = d0spol;
         ubmPosi.r5poco = peLubi(x).rspoco;
         REST_writeXmlLine( 'mejoras' : '*BEG' );
         WSLUBM( peBase
               : 99
               : 'I'
               : ubmPosi
               : ubmPreg
               : ubmUreg
               : peMubi
               : peMubiC
               : peMore
               : peErro
               : peMsgs  );
         for z = 1 to peMubiC;
          vto = %char(peMubi(x).rsfvto5:*iso);
          fcu = %char(peMubi(x).rsfcum5:*iso);
          if vto = '0001-01-01';
             vto = *blanks;
          endif;
          if fcu = '0001-01-01';
             fcu = *blanks;
          endif;
          REST_writeXmlLine( 'mejora' : '*BEG' );
          REST_writeXmlLine('descripcion':peMubi(z).rsmejd5);
          REST_writeXmlLine('vencimiento':vto);
          REST_writeXmlLine('estado'     :peMubi(z).rsemed5);
          REST_writeXmlLine('cumplimiento':fcu);
          REST_writeXmlLine( 'mejora' : '*END' );
         endfor;
         REST_writeXmlLine( 'mejoras' : '*END' );

         REST_writeXmlLine( 'coberturas': '*BEG');

         WSLUBR( peBase
               : d0rama
               : d0poli
               : d0spol
               : peLubi(x).rspoco
               : ubrLryc
               : ubrLrycC
               : peErro
               : peMsgs    );
         if peErro = 0;
            clear Rasc;
            clear Rcal;
            clear GrupoRama;
            GrupoRama = SVPWS_getGrupoRama( d0rama );

            if SVPVLS_getValSys( 'HCONRESASC' : *omit : @@Vsys );
              Rasc = %trim(@@Vsys);
            endif;
            if SVPVLS_getValSys( 'HCONRESCAL' : *omit : @@Vsys );
              Rcal = %trim(@@Vsys);
            endif;

            for z = 1 to ubrLrycC;
             sumaCob = %editw(ubrLryc(z).rssaco:'             .  ');
             if ubrLryc(z).rssaco = 0;
                sumaCob = '.00';
             endif;
             tasaCob = %editw(ubrLryc(z).rsxpri:' 0 .      ');
             primCob = %editw(ubrLryc(z).rsptco:'             .  ');
             if ubrLryc(z).rsptco = 0;
                primCob = '.00';
             endif;
             REST_writeXmlLine('cobertura':'*BEG');
             REST_writeXmlLine('nombreCob':ubrLryc(z).rscobl);
             REST_writeXmlLine('sumaCob':sumaCob);
             REST_writeXmlLine('tasaCob':tasaCob);
             REST_writeXmlLine('primCob':primCob);
             REST_writeXmlLine('codRiesgo':ubrLryc(z).rsRiec);
             REST_writeXmlLine('codCobert':%editc(ubrLryc(z).rsXcob:'X'));
             REST_writeXmlLine('objetos':'*BEG');
             clear peOaco;
             WSLUBO( peBase
                   : d0rama
                   : d0poli
                   : d0spol
                   : peLubi(x).rspoco
                   : ubrLryc(z).rsriec
                   : ubrLryc(z).rsxcob
                   : peOaco
                   : peOacoC
                   : peErro
                   : peMsgs            );
             if peErro = 0;
              for v = 1 to peOacoC;
               obj = %trim(peOaco(v).rsobje)
                   + ' '
                   + %trim(peOaco(v).rsmarc)
                   + ' '
                   + %trim(peOaco(v).rsmode);
               osu = %editw(peOaco(v).rssuas:'           0 .  ');
               REST_writeXmlLine('objeto':'*BEG');
               REST_writeXmlLine('detalle': obj );
               REST_writeXmlLine('sumaAse': osu );
               REST_writeXmlLine('objeto':'*END');
              endfor;
             endif;
             REST_writeXmlLine('objetos':'*END');

             // --------------------------------------
             // Mascotas
             // --------------------------------------
             exsr $mascotas;

             clear peFran;
             WSLUBF( peBase
                   : d0rama
                   : d0poli
                   : d0spol
                   : peLubi(x).rspoco
                   : ubrLryc(z).rsriec
                   : ubrLryc(z).rsxcob
                   : peFran
                   : peErro
                   : peMsgs );

             REST_writeXmlLine('franquicia':%trim(peFran.r8leye));

             if GrupoRama <> 'C';
                 REST_writeXmlLine('isAscensores':'N');
                 REST_writeXmlLine('isCalderas':'N');
                 REST_writeXmlLine('resolucionAscensores':*blanks);
                 REST_writeXmlLine('resolucionCalderas':*blanks);
             else;
               if %trim(peLubi(x).rsloca) = 'CAPITAL FEDERAL';
                 select;
                   when ubrLryc(z).rsXcob = 908;
                     REST_writeXmlLine('isAscensores':'S');
                     REST_writeXmlLine('isCalderas':'N');
                     REST_writeXmlLine('resolucionAscensores': %trim(Rasc));
                     REST_writeXmlLine('resolucionCalderas':*blanks);
                   when ubrLryc(z).rsXcob = 909;
                     REST_writeXmlLine('isAscensores':'N');
                     REST_writeXmlLine('isCalderas':'S');
                     REST_writeXmlLine('resolucionAscensores':*blanks);
                     REST_writeXmlLine('resolucionCalderas': %trim(Rcal));
                   other;
                     REST_writeXmlLine('isAscensores':'N');
                     REST_writeXmlLine('isCalderas':'N');
                     REST_writeXmlLine('resolucionAscensores':*blanks);
                     REST_writeXmlLine('resolucionCalderas':*blanks);
                 endsl;
               else;
                 REST_writeXmlLine('isAscensores':'N');
                 REST_writeXmlLine('isCalderas':'N');
                 REST_writeXmlLine('resolucionAscensores':*blanks);
                 REST_writeXmlLine('resolucionCalderas':*blanks);
               endif;
             endif;

             REST_writeXmlLine('cobertura':'*END');
            endfor;
         endif;

         REST_writeXmlLine( 'coberturas': '*END');

         REST_writeXmlLine( 'clausulas' : '*BEG' );
         WSLUBC( peBase
               : d0rama
               : d0poli
               : d0spol
               : peLubi(x).rspoco
               : peCubi
               : peCubiC
               : peErro
               : peMsgs          );
         for v = 1 to peCubiC;
             REST_writeXmlLine( 'clausula' : peCubi(v).clau );
         endfor;

              REST_writeXmlLine( 'clausulas' : '*END' );

              @@poco = peLubi(x).rspoco;
              SPVIG4( d0arcd
                    : d0spol
                    : d0rama
                    : d0arse
                    : d0oper
                    : @@poco
                    : hoy
                    : hoy
                    : viStat
                    : viSspo
                    : viSuop
                    : *blanks   );
              if viStat;
                 REST_writeXmlLine( 'estaVigente': 'S' );
               else;
                 REST_writeXmlLine( 'estaVigente': 'N' );
              endif;

              REST_writeXmlLine('nroComponente':%char(peLubi(x).rspoco));

              REST_writeXmlLine('calle':%trim(peLubi(x).rsrdes));
              REST_writeXmlLine('nroPuerta':%trim(%char(peLubi(x).rsnrdm)));

           fecha = (peLubi(x).rsaegn * 10000)
                 + (peLubi(x).rsmegn *   100)
                 +  peLubi(x).rsdegn;
           monitor;
             fegrRgva  = %char(%date(fecha:*iso):*iso);
            on-error;
             fegrRgva = '2050-12-31';
           endmon;

           REST_writeXmlLine( 'fecEgreso' : fegrRgva );
           REST_writeXmlLine( 'endosoEgreso' : %editc(peLubi(x).rsSuen:'X') );

         REST_writeXmlLine( 'ubicacion' : '*END' );
        endfor;

       endif;

       endsr;

       begsr $vida;

        clear nasvPosi;
        clear nasvPreg;
        clear nasvUreg;
        clear peNasv;
        peNasvC = 0;

        peRoll = 'I';
        nasvPosi.v0rama = %dec(rama:2:0);
        nasvPosi.v0poli = %dec(poli:7:0);
        nasvPosi.v0spol = %dec(spol:9:0);

        dou peMore = *off;

            WSLNAV( peBase
                  : 99
                  : peRoll
                  : nasvPosi
                  : nasvPreg
                  : nasvUreg
                  : peNasv
                  : peNasvC
                  : peMore
                  : peErro
                  : peMsgs   );

            if peErro = 0;
               for s = 1 to peNasvC;
                   clear peLryc;
                   peLrycC = 0;
                   WSLRCA( peBase
                         : %dec(rama:2:0)
                         : %dec(poli:7:0)
                         : %dec(spol:9:0)
                         : peNasv(s).vdpoco
                         : peNasv(s).vdpaco
                         : peLryc
                         : peLrycC
                         : peErro
                         : peMsgs     );
                   for r = 1 to peLrycC;
                       if peLryc(r).vdxcob = 28;
                          peNasv(s).vdsuas = peLryc(r).vdsaco;
                       endif;
                   endfor;
                @@suas = peNasv(s).vdsuas;
                nrdoVida = %trim(%char(peNasv(s).vdnrdo));
                fnacVida = %char(peNasv(s).vdfnac:*iso);
                suasVida = %editw(@@suas:'             .  ');
                fecha = (peNasv(s).vdainn * 10000)
                      + (peNasv(s).vdminn *   100)
                      +  peNasv(s).vddinn;
                monitor;
                  fingVida  = %char(%date(fecha:*iso):*iso);
                 on-error;
                  fingVida = *blanks;
                endmon;
                if fingVida = '0001-01-01';
                  fingVida = *blanks;
                endif;
                fecha = (peNasv(s).vdaegn * 10000)
                      + (peNasv(s).vdmegn *   100)
                      +  peNasv(s).vddegn;
                monitor;
                  fegrVida  = %char(%date(fecha:*iso):*iso);
                 on-error;
                  fegrVida = *blanks;
                endmon;
                if fegrVida = '0001-01-01';
                  fegrVida = *blanks;
                endif;
                REST_writeXmlLine( 'bienVida' : '*BEG' );
                REST_writeXmlLine( 'integrVida' : peNasv(s).vdnomb);
                REST_writeXmlLine( 'tipDocVida' : peNasv(s).vddatd);
                REST_writeXmlLine( 'nroDocVida' : nrdoVida);
                REST_writeXmlLine( 'sumAseVida' : suasVida);
                REST_writeXmlLine( 'fecNacVida' : fnacVida);
                REST_writeXmlLine( 'fecIngVida' : fingVida);
                REST_writeXmlLine( 'fecEgrVida' : fegrVida);
                REST_writeXmlLine( 'producVida' : peNasv(s).vdprds);
                exsr $rycVida;
                @2poco = peNasv(s).vdpoco;
                @@paco = peNasv(s).vdpaco;
                SPVIG5( d0arcd
                      : d0spol
                      : d0rama
                      : d0arse
                      : d0oper
                      : @2poco
                      : @@paco
                      : hoy
                      : hoy
                      : viStat
                      : viSspo
                      : viSuop
                      : *blanks
                      : *on
                      : *on      );
                if viStat;
                   REST_writeXmlLine( 'estaVigente' : 'S' );
                 else;
                   REST_writeXmlLine( 'estaVigente' : 'N' );
                endif;

                clear @@Lben;
                clear @@LbenC;
                clear peErro;
                clear peMsgs;
                WSLBAV( peBase
                      : d0Rama
                      : d0Poli
                      : d0Spol
                      : @2poco
                      : @@paco
                      : @@Lben
                      : @@LbenC
                      : peErro
                      : peMsgs  );

                REST_writeXmlLine( 'beneficiarios' : '*BEG' );
                if peErro = 0;
                 for q = 1 to @@LbenC;

                  REST_writeXmlLine( 'beneficiario' : '*BEG' );

                   REST_writeXmlLine(
                                'nroOrden' : %editc( @@Lben(q).v9nord : 'X' ) );

                   REST_writeXmlLine(
                                  'nroDaf' : %editc( @@Lben(q).v9nrdf : 'X' ) );

                   REST_writeXmlLine( 'nombre' : %trim(@@Lben(q).v9nomb) );

                   REST_writeXmlLine(
                           'tipoDocumento' : %editc( @@Lben(q).v9tido : 'X' ) );

                   REST_writeXmlLine(
                                    'descDocumento' : %trim(@@Lben(q).v9datd) );

                   REST_writeXmlLine(
                            'nroDocumento' : %editc( @@Lben(q).v9nrdo : 'X' ) );

                   REST_writeXmlLine(
                       'porcParticipacion' : %editc( @@Lben(q).v9part : 'X' ) );

                   REST_writeXmlLine(
                       'suplementoIngreso' : %editc( @@Lben(q).v9suin : 'X' ) );

                   REST_writeXmlLine(
                                'fechaIngreso' : %char(@@Lben(q).v9finn:*iso) );

                   REST_writeXmlLine(
                        'suplementoEgreso' : %editc( @@Lben(q).v9suen : 'X' ) );

                   REST_writeXmlLine(
                                 'fechaEgreso' : %char(@@Lben(q).v9fegn:*iso) );

                   REST_writeXmlLine( 'status' : %trim(@@Lben(q).v9stat) );

                   REST_writeXmlLine(
                                 'tipoBeneficiario' : %trim(@@Lben(q).v9tibe) );

                   REST_writeXmlLine(
                             'descTipoBeneficiario' : %trim(@@Lben(q).v9tibd) );

                   REST_writeXmlLine(
                        'codigoParentesco' : %editc( @@Lben(q).v9pabe : 'X' ) );

                   REST_writeXmlLine(
                                   'descParentesco' : %trim(@@Lben(q).v9pade) );

                   REST_writeXmlLine(
                              'codigoSexo' : %editc( @@Lben(q).v9sexo : 'X' ) );

                   REST_writeXmlLine( 'descSexo' : %trim(@@Lben(q).v9dsex) );

                   REST_writeXmlLine(
                       'codigoEstadoCivil' : %editc( @@Lben(q).v9esci : 'X' ) );

                   REST_writeXmlLine(
                                  'descEstadoCivil' : %trim(@@Lben(q).v9desc) );

                   REST_writeXmlLine(
                             'fechaNacimiento' : %char(@@Lben(q).v9fnac:*iso) );

                   REST_writeXmlLine( 'texto' : %trim(@@Lben(q).v9rgln) );

                  REST_writeXmlLine( 'beneficiario' : '*END' );

                 endfor;
                endif;
                REST_writeXmlLine( 'beneficiarios' : '*END' );
                REST_writeXmlLine( 'nroComponente' : %char(@2poco) );
                REST_writeXmlLine( 'nacionalidad'
                                 : %Trim(peNasv(s).vdnaci) );
                REST_writeXmlLine( 'actividad'
                                 : %Trim(%char(peNasv(s).vdacti)) );
                REST_writeXmlLine( 'categoria'
                                 : %Trim(%char(peNasv(s).vdcate)) );
                REST_writeXmlLine( 'descripcionActividad'
               : %trim(REST_XmlEscape(svpdes_actividad(peNasv(s).vdacti))));
               if fegrVida = *blanks;
                 REST_writeXmlLine( 'fecEgreso' : '2050-12-31' );
               else;
                 REST_writeXmlLine( 'fecEgreso' : fegrVida );
               endif;
               REST_writeXmlLine( 'endosoEgreso' : %editc( peNasv(s).vdsuen :
                                  'X' ) );
                REST_writeXmlLine( 'bienVida' : '*END' );

               endfor;
            endif;

            peRoll = 'F';
            nasvPosi = nasvUreg;

            if peMore = *off;
               leave;
            endif;

        enddo;

       endsr;

       begsr $rycVida;

        clear peLryc;
        peLrycC = 0;

        WSLRCA( peBase
              : %dec(rama:2:0)
              : %dec(poli:7:0)
              : %dec(spol:9:0)
              : peNasv(s).vdpoco
              : peNasv(s).vdpaco
              : peLryc
              : peLrycC
              : peErro
              : peMsgs     );

        if peErro = 0;
           REST_writeXmlLine( 'coberturas' : '*BEG' );
           @@tipo = ' ';
           for r = 1 to peLrycC;
            sumaCobVida = %editw(peLryc(r).vdsaco:'             .  ');
            REST_writeXmlLine( 'cobertura'  : '*BEG' );
            REST_writeXmlLine( 'nombreCob'  : peLryc(r).vdcobd );
            REST_writeXmlLine( 'sumaCob'    : sumaCobVida      );
            REST_writeXmlLine( 'codRiesgo'  : peLryc(r).vdRiec );
            REST_writeXmlLine( 'codCobert'  : %editc(peLryc(r).vdXcob:'X'));

            if %dec(rama:2:0) = 23;
               if peLryc(r).vdxcob = 28;
                  @@tipo = 'Muerte';
               endif;
               if peLryc(r).vdxcob = 29;
                  @@tipo = 'Invalidez';
               endif;
               if peLryc(r).vdxcob = 30;
                  @@tipo = 'Fractura';
               endif;
               if peLryc(r).vdxcob = 16 or peLryc(r).vdxcob = 17;
                  @@tipo = 'Asistencia';
               endif;
            endif;
            REST_writeXmlLine( 'tipoCob'    : %trim(@@tipo)    );

            REST_writeXmlLine( 'cobertura'  : '*END' );
           endfor;
           REST_writeXmlLine( 'coberturas' : '*END' );
        endif;

       endsr;

       begsr $casc;

        clear peLubi;
        clear peMsgs;
        clear ubpPosi;
        clear ubpPreg;
        clear ubpUreg;
        clear ubrLryc;
        clear peDemb;
        clear peCubi;

        ubpPosi.r9rama = d0rama;
        ubpPosi.r9poli = d0poli;
        ubpPosi.r9spol = d0spol;
        ubpPosi.r9arcd = d0arcd;
        ubpPosi.r9oper = d0oper;

        WSLUBP( peBase
              : 99
              : 'I'
              : ubpPosi
              : ubpPreg
              : ubpUreg
              : peLubi
              : peLubiC
              : peMore
              : peErro
              : peMsgs );

       if peErro = 0;
        for x = 1 to peLubiC;
             WSLEMB( peBase
                   : d0rama
                   : d0poli
                   : d0spol
                   : peLubi(x).rspoco
                   : peDemb
                   : peErro
                   : peMsgs    );
             if peErro = 0;
              emst = %editw(peDemb.rsemst:'             .  ');
              if peDemb.rsemst = 0;
                 emst = '.00';
              endif;
              emsc = %editw(peDemb.rsemsc:'             .  ');
              if peDemb.rsemsc = 0;
                 emsc = '.00';
              endif;
              emsm = %editw(peDemb.rsemsm:'             .  ');
              if peDemb.rsemsm = 0;
                 emsm = '.00';
              endif;
              eslo = %editw(peDemb.rseslo: '   .  ');
              mang = %editw(peDemb.rsmang: '   .  ');
              punt = %editw(peDemb.rspunt: '   .  ');
              if peDemb.rseslo = 0;
                 eslo = '.00';
              endif;
              if peDemb.rsmang = 0;
                 mang = '.00';
              endif;
              if peDemb.rspunt = 0;
                 punt = '.00';
              endif;
              REST_writeXmlLine( 'embarcacion' : '*BEG' );
              REST_writeXmlLine( 'tipo'   : peDemb.rsemcd );
              REST_writeXmlLine( 'nombre' : peDemb.rsemcn );
              REST_writeXmlLine( 'astillero': peDemb.rsemcf );
              if peDemb.rsemcj <> *blanks;
                 REST_writeXmlLine( 'matricula': peDemb.rsemcj );
               else;
                 REST_writeXmlLine( 'matricula': peDemb.rsemcr );
              endif;
              REST_writeXmlLine( 'modelo': peDemb.rsemcm );
              REST_writeXmlLine( 'anio'  : %char(peDemb.rsemca) );
              REST_writeXmlLine( 'material': peDemb.rsemci );
              REST_writeXmlLine( 'avaluado' : emst          );
              REST_writeXmlLine( 'sumaCasco': emsc          );
              REST_writeXmlLine( 'sumaMotor': emsm          );
              REST_writeXmlLine( 'sumaTotal': emst          );
              REST_writeXmlLine( 'eslora'   : eslo          );
              REST_writeXmlLine( 'manga'    : mang          );
              REST_writeXmlLine( 'puntal'   : punt          );
              REST_writeXmlLine( 'motores' : '*BEG' );
              if peDemb.rsemmm <> *blanks;
                 REST_writeXmlLine( 'motor' : '*BEG' );
                 REST_writeXmlLine( 'fabrica': peDemb.rsemmm );
                 REST_writeXmlLine( 'modelo' : peDemb.rsemmo );
                 REST_writeXmlLine( 'numero' : peDemb.rsemmn );
                 REST_writeXmlLine( 'anio'   : %char(peDemb.rsemma) );
                 REST_writeXmlLine( 'tipo'   : peDemb.rsemmt );
                 REST_writeXmlLine( 'motor' : '*END' );
              endif;
              if peDemb.rse2mm <> *blanks;
                 REST_writeXmlLine( 'motor' : '*BEG' );
                 REST_writeXmlLine( 'fabrica': peDemb.rse2mm );
                 REST_writeXmlLine( 'modelo' : peDemb.rse2mo );
                 REST_writeXmlLine( 'numero' : peDemb.rse2mn );
                 REST_writeXmlLine( 'anio'   : %char(peDemb.rse2ma) );
                 REST_writeXmlLine( 'tipo'   : peDemb.rse2mt );
                 REST_writeXmlLine( 'motor' : '*END' );
              endif;
              REST_writeXmlLine( 'motores' : '*END' );

              REST_writeXmlLine( 'producto': peLubi(x).rsprds);
              REST_writeXmlLine( 'coberturas': '*BEG');

              WSLUBR( peBase
                    : d0rama
                    : d0poli
                    : d0spol
                    : peLubi(x).rspoco
                    : ubrLryc
                    : ubrLrycC
                    : peErro
                    : peMsgs    );
              if peErro = 0;
                 for z = 1 to ubrLrycC;
                  sumaCob = %editw(ubrLryc(z).rssaco:'             .  ');
                  tasaCob = %editw(ubrLryc(z).rsxpri:'   .      ');
                  primCob = %editw(ubrLryc(z).rsptco:'             .  ');
                  REST_writeXmlLine('cobertura':'*BEG');
                  REST_writeXmlLine('nombreCob':ubrLryc(z).rscobl);
                  REST_writeXmlLine('codRiesgo':ubrLryc(z).rsRiec);
                  REST_writeXmlLine('codCobert':%editc(ubrLryc(z).rsXcob:'X'));
                  REST_writeXmlLine('sumaCob':sumaCob);
                  REST_writeXmlLine('tasaCob':tasaCob);
                  REST_writeXmlLine('primCob':primCob);
                  REST_writeXmlLine('objetos':'*BEG');
                  REST_writeXmlLine('objetos':'*END');
                  REST_writeXmlLine('franquicia':'*BEG');
                  REST_writeXmlLine('franquicia':'*END');
                  REST_writeXmlLine('cobertura':'*END');
                 endfor;
              endif;

              REST_writeXmlLine( 'coberturas': '*END');

              REST_writeXmlLine( 'clausulas' : '*BEG' );
              WSLUBC( peBase
                    : d0rama
                    : d0poli
                    : d0spol
                    : peLubi(x).rspoco
                    : peCubi
                    : peCubiC
                    : peErro
                    : peMsgs          );
              for v = 1 to peCubiC;
                  REST_writeXmlLine( 'clausula' : peCubi(v).clau );
              endfor;

              REST_writeXmlLine( 'clausulas' : '*END' );

              @@poco = peLubi(x).rspoco;
              SPVIG4( d0arcd
                    : d0spol
                    : d0rama
                    : d0arse
                    : d0oper
                    : @@poco
                    : hoy
                    : hoy
                    : viStat
                    : viSspo
                    : viSuop
                    : *blanks   );
              if viStat;
                 REST_writeXmlLine( 'estaVigente': 'S' );
               else;
                 REST_writeXmlLine( 'estaVigente': 'N' );
              endif;

                 REST_writeXmlLine( 'nroComponente': %char(@@poco) ) ;
                fecha = (peLubi(x).rsaegn * 10000)
                      + (peLubi(x).rsmegn *   100)
                      +  peLubi(x).rsdegn;
                monitor;
                  fegrRgva  = %char(%date(fecha:*iso):*iso);
                 on-error;
                  fegrRgva = '2050-12-31';
                endmon;

                REST_writeXmlLine( 'fecEgreso' : fegrRgva );
            REST_writeXmlLine( 'endosoEgreso' : %editc(peLubi(x).rsSuen:'X'));

              REST_writeXmlLine( 'embarcacion' : '*END' );
             endif;
        endfor;
       endif;

       endsr;

       begsr $mascotas;

       @@DsRaC = 0;
       clear @@DsRa;

       if SVPRIV_getMascotas( empr
                            : sucu
                            : d0Arcd
                            : d0Spol
                            : r0Sspo
                            : d0Rama
                            : d0Arse
                            : d0Oper
                            : peLubi(x).rspoco
                            : r0Suop
                            : ubrLryc(z).rsriec
                            : ubrLryc(z).rsxcob
                            : @@DsRa
                            : @@DsRaC           );

         REST_startArray( 'mascotas' );

         for i = 1 to @@DsRaC;

           REST_startArray( 'mascota' );

             clear @@Dtma;
             clear @@Draz;
             clear @Msuas;

             @@Dtma = SVPDES_tipoDeMascota( @@DsRa(i).raCtma );
             @@Draz = SVPDES_razaDeMascota( @@DsRa(i).raCraz );
             @Msuas = SVPREST_editImporte( @@DsRa(i).raSuas );

             REST_writeXmlLine( 'codTipoMascota': %char(@@DsRa(i).raCtma) );
             REST_writeXmlLine( 'desTipoMascota': %trim(@@Dtma) );
             REST_writeXmlLine( 'codRazaMascota': %char(@@DsRa(i).raCraz) );
             REST_writeXmlLine( 'desRazaMascota': %trim(@@Draz) );
             REST_writeXmlLine( 'anioNacimiento': %char(@@DsRa(i).raFnaa) );

             if @@DsRa(i).raPvac = '1';
               REST_writeXmlLine( 'planVacunacion': 'S' );
             else;
               REST_writeXmlLine( 'planVacunacion': 'N' );
             endif;

             if @@DsRa(i).raCria = '1';
               REST_writeXmlLine( 'ampliacionCria': 'S' );
             else;
               REST_writeXmlLine( 'ampliacionCria': 'N' );
             endif;

             if @@DsRa(i).raExpo = '1';
               REST_writeXmlLine( 'mascotaParaExpo': 'S' );
             else;
               REST_writeXmlLine( 'mascotaParaExpo': 'N' );
             endif;

             REST_writeXmlLine( 'sumaAsegurada' : %trim( @Msuas) );

           REST_endArray  ( 'mascota' );

         endfor;
         REST_endArray  ( 'mascotas' );
       endif;

       endsr;

      /end-free
