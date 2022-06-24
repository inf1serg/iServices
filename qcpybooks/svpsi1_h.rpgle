      /if defined(SVPSI1_H)
      /eof
      /endif
      /define SVPSI1_H

      /copy './qcpybooks/svpsin_h.rpgle'

      * Siniestro Inexistente...
     D SVPSI1_SINNE    c                   const(0011)
      * Beneficiario Inexistente...
     D SVPSI1_BENNE    c                   const(0012)
      * Objeto Inexistente...
     D SVPSI1_OBJNE    c                   const(0013)
      * Reasegurado Inexistente...
     D SVPSI1_REANE    c                   const(0014)
      * Bienes Inexistente...
     D SVPSI1_BIENE    c                   const(0015)
      * Beneficiario / Reclamo Inexistente...
     D SVPSI1_BNRNE    c                   const(0016)
      * Beneficiario Adicional Conductores Inexistente...
     D SVPSI1_BACNE    c                   const(0017)
      * Beneficiario Adicional Vehiculo del Tercero Inexistente...
     D SVPSI1_BAVNE    c                   const(0018)
      * Cuenta Corriente Inexistente...
     D SVPSI1_CCRNE    c                   const(0019)
      * Extensión Autos Inexistente...
     D SVPSI1_EXANE    c                   const(0020)
      * Transporte Inexistente...
     D SVPSI1_TRANE    c                   const(0021)
      * Importe Franquicia Inexistente...
     D SVPSI1_IMFNE    c                   const(0022)
      * Historia del Estado de Siniestro Inexistente...
     D SVPSI1_HESNE    c                   const(0023)
      * Pagos Históricos Inexistente...
     D SVPSI1_PGHNE    c                   const(0024)
      * Reservas Históricas Inexistente...
     D SVPSI1_RHINE    c                   const(0025)
      * Detalle de Ocurrencia Inexistente...
     D SVPSI1_DFONE    c                   const(0026)
      * Detalle del Daño Inexistente...
     D SVPSI1_DTDNE    c                   const(0027)
      * Detalle del Daño Vehiculo Terceros Inexistente...
     D SVPSI1_DVTNE    c                   const(0028)
      * Estado de Póliza del Siniestro Inexistente...
     D SVPSI1_SEPNE    c                   const(0029)
      * Fallecido Inexistente...
     D SVPSI1_FALNE    c                   const(0030)
      * Usuario/Rama Inexistente...
     D SVPSI1_USENE    c                   const(0031)
      * Siniestro Suspendido Inexistente...
     D SVPSI1_SSPNE    c                   const(0032)
      * Limite autorizado Inexistente...
     D SVPSI1_LAUNE    c                   const(0033)
      * Recibo de Indemnizacion Inexistente...
     D SVPSI1_REINE    c                   const(0034)

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsus
      * --------------------------------------------------- *
     D dsPahsus_t      ds                  qualified template
     D  usempr                        1a
     D  ussucu                        2a
     D  ususer                       10a
     D  usrama                        2p 0
     D  usmar1                        1a
     D  usmar2                        1a
     D  usmar3                        1a
     D  usmar4                        1a
     D  usmar5                        1a
     D  ususmo                       10a
     D  ustime                        6p 0
     D  usdate                        6p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsbo
      * --------------------------------------------------- *
     D DsPahsbo_t      ds                  qualified template
     D  boempr                        1
     D  bosucu                        2
     D  borama                        2p 0
     D  bosini                        7p 0
     D  bonops                        7p 0
     D  bopoco                        6p 0
     D  bopaco                        3p 0
     D  boriec                        3
     D  boxcob                        3p 0
     D  boosec                        9p 0
     D  boobje                       74
     D  bomarc                       45
     D  bomode                       45
     D  bonser                       45
     D  bosuas                       15p 2
     D  bodet1                       74
     D  bodet2                       74
     D  bodet3                       74
     D  bodet4                       74
     D  bodet5                       74
     D  bodet6                       74
     D  bomar1                        1
     D  bomar2                        1
     D  bomar3                        1
     D  bomar4                        1
     D  bomar5                        1
     D  bomar6                        1
     D  bomar7                        1
     D  bomar8                        1
     D  bomar9                        1
     D  bomar0                        1
     D  bostrg                        1
     D  bouser                       10
     D  botime                        6p 0
     D  bofera                        4p 0
     D  boferm                        2p 0
     D  boferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsbr
      * --------------------------------------------------- *
     D DsPahsbr_t      ds                  qualified template
     D  brempr                        1
     D  brsucu                        2
     D  brrama                        2p 0
     D  brsini                        7p 0
     D  brnops                        7p 0
     D  brpoco                        6p 0
     D  brpaco                        3p 0
     D  brnrdf                        7p 0
     D  brsebe                        6p 0
     D  brfmoa                        4p 0
     D  brfmom                        2p 0
     D  brfmod                        2p 0
     D  brpsec                        2p 0
     D  brriec                        3
     D  brxcob                        3p 0
     D  brnomb                       40
     D  brncor                        5p 0
     D  brnrcr                        5p 0
     D  brpoli                        7p 0
     D  brtcor                        2p 0
     D  brnrcj                        6p 0
     D  brjuin                        6p 0
     D  brmonr                        2
     D  brmoeq                        2
     D  brimco                       15p 0
     D  brsuas                       13p 0
     D  brimmr                       15p 0
     D  brimrr                       15p 0
     D  bcmonr                        2
     D  bcmoeq                        2
     D  bcimco                       15p 6
     D  bcsuas                       13p 0
     D  bcimmr                       15p 2
     D  bcimrr                       15p 2
     D  b$monr                        2
     D  b$moeq                        2
     D  b$suas                       13p 0
     D  b$immr                       15p 2
     D  b$imrr                       15p 2
     D  brmar1                        1
     D  brmar2                        1
     D  brmar3                        1
     D  brmar4                        1
     D  brmar5                        1
     D  bruser                       10
     D  brtime                        6p 0
     D  brdate                        6p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsbs
      * --------------------------------------------------- *
     D DsPahsbs_t      ds                  qualified template
     D  bsempr                        1
     D  bssucu                        2
     D  bsrama                        2p 0
     D  bssini                        7p 0
     D  bsnops                        7p 0
     D  bspoco                        6p 0
     D  bspaco                        3p 0
     D  bsriec                        3
     D  bsxcob                        3p 0
     D  bsctle                        2
     D  bsasen                        7p 0
     D  bssocn                        7p 0
     D  bsarcd                        6p 0
     D  bsspol                        9p 0
     D  bssspo                        3p 0
     D  bsarse                        2p 0
     D  bsoper                        7p 0
     D  bssuop                        3p 0
     D  bscert                        9p 0
     D  bspoli                        7p 0
     D  bsagec                        3p 0
     D  bsnsag                        6p 0
     D  bsnrdf                        7p 0
     D  bsnomb                       40
     D  bstido                        2p 0
     D  bsnrdo                        8p 0
     D  bscuil                       11p 0
     D  bspinc                        5p 0
     D  bsjuin                        6p 0
     D  bsmar1                        1
     D  bsmar2                        1
     D  bsmar3                        1
     D  bsmar4                        1
     D  bsmar5                        1
     D  bsstrg                        1
     D  bsuser                       10
     D  bstime                        6p 0
     D  bsfera                        4p 0
     D  bsferm                        2p 0
     D  bsferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahscc
      * --------------------------------------------------- *
     D DsPahscc_t      ds                  qualified template
     D  ccempr                        1
     D  ccsucu                        2
     D  ccrama                        2p 0
     D  ccsini                        7p 0
     D  ccnops                        7p 0
     D  cccmov                        3p 0
     D  ccfmoa                        4p 0
     D  ccfmom                        2p 0
     D  ccfmod                        2p 0
     D  ccpsec                        2p 0
     D  ccmonr                        2
     D  ccimmr                       15p 2
     D  ccmoeq                        2
     D  ccimco                       15p 6
     D  ccimau                       15p 2
     D  ccdeha                        1p 0
     D  ccartc                        2p 0
     D  ccpacp                        6p 0
     D  ccmar1                        1
     D  ccmar2                        1
     D  ccmar3                        1
     D  ccmar4                        1
     D  ccmar5                        1
     D  ccuser                       10
     D  cctime                        6p 0
     D  ccfera                        4p 0
     D  ccferm                        2p 0
     D  ccferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsdt
      * --------------------------------------------------- *
     D DsPahsdt_t      ds                  qualified template
     D  dtempr                        1
     D  dtsucu                        2
     D  dtrama                        2p 0
     D  dtsini                        7p 0
     D  dtnops                        7p 0
     D  dtcarr                       30
     D  dtmtra                        1
     D  dtmar1                        1
     D  dtmar2                        1
     D  dtmar3                        1
     D  dtmar4                        1
     D  dtmar5                        1
     D  dtmar6                        1
     D  dtmar7                        1
     D  dtmar8                        1
     D  dtmar9                        1
     D  dtuser                       10
     D  dttime                        6p 0
     D  dtdate                        8p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsfr
      * --------------------------------------------------- *
     D DsPahsfr_t      ds                  qualified template
     D  frempr                        1
     D  frsucu                        2
     D  frrama                        2p 0
     D  frsini                        7p 0
     D  frnops                        7p 0
     D  frpoco                        6p 0
     D  frpaco                        3p 0
     D  frnrdf                        7p 0
     D  frsebe                        6p 0
     D  frriec                        3
     D  frxcob                        3p 0
     D  frfmoa                        4p 0
     D  frfmom                        2p 0
     D  frfmod                        2p 0
     D  frpsec                        2p 0
     D  frnupe                        8p 0
     D  frnroc                        7p 0
     D  frcoma                        2
     D  frnrma                        7p 0
     D  fresma                        1p 0
     D  frmonr                        2
     D  frimmr                       15p 2
     D  frimnr                       15p 2
     D  frmoeq                        2
     D  frimco                       15p 6
     D  frimau                       15p 2
     D  frimna                       15p 2
     D  frmar1                        1
     D  frmar2                        1
     D  frmar3                        1
     D  frmar4                        1
     D  frmar5                        1
     D  fruser                       10
     D  frtime                        6p 0
     D  frfera                        4p 0
     D  frferm                        2p 0
     D  frferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahshe
      * --------------------------------------------------- *
     D DsPahshe_t      ds                  qualified template
     D  heempr                        1
     D  hesucu                        2
     D  herama                        2p 0
     D  hesini                        7p 0
     D  henops                        7p 0
     D  hefema                        4p 0
     D  hefemm                        2p 0
     D  hefemd                        2p 0
     D  hepsec                        2p 0
     D  hecesi                        2p 0
     D  hecese                        2
     D  heterm                        1
     D  hemar1                        1
     D  hemar2                        1
     D  hemar3                        1
     D  hemar4                        1
     D  hemar5                        1
     D  heuser                       10
     D  hetime                        6p 0
     D  hefera                        4p 0
     D  heferm                        2p 0
     D  heferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahshp
      * --------------------------------------------------- *
     D DsPahshp_t      ds                  qualified template
     D  hpempr                        1
     D  hpsucu                        2
     D  hprama                        2p 0
     D  hpsini                        7p 0
     D  hpnops                        7p 0
     D  hppoco                        6p 0
     D  hppaco                        3p 0
     D  hpriec                        3
     D  hpxcob                        3p 0
     D  hpnrdf                        7p 0
     D  hpsebe                        6p 0
     D  hpfmoa                        4p 0
     D  hpfmom                        2p 0
     D  hpfmod                        2p 0
     D  hppsec                        2p 0
     D  hpfasa                        4p 0
     D  hpfasm                        2p 0
     D  hpfasd                        2p 0
     D  hpmonr                        2
     D  hpimmr                       15p 2
     D  hpmoeq                        2
     D  hpimco                       15p 6
     D  hpimau                       15p 2
     D  hpartc                        2p 0
     D  hppacp                        6p 0
     D  hpmar1                        1
     D  hpmar2                        1
     D  hpmar3                        1
     D  hpmar4                        1
     D  hpmar5                        1
     D  hpuser                       10
     D  hptime                        6p 0
     D  hpfera                        4p 0
     D  hpferm                        2p 0
     D  hpferd                        2p 0
     D  hpmar6                        1
     D  hpmar7                        1
     D  hpmar8                        1
     D  hpmar9                        1
     D  hpfifa                        4p 0
     D  hpfifm                        2p 0
     D  hpfifd                        2p 0
     D  hpfeca                        4p 0
     D  hpfecm                        2p 0
     D  hpfecd                        2p 0
     D  hpusr1                       10

      * --------------------------------------------------- *
      * Estrucutura de datos Pahshr
      * --------------------------------------------------- *
     D DsPahshr_t      ds                  qualified template
     D  hrempr                        1
     D  hrsucu                        2
     D  hrrama                        2p 0
     D  hrsini                        7p 0
     D  hrnops                        7p 0
     D  hrpoco                        6p 0
     D  hrpaco                        3p 0
     D  hrnrdf                        7p 0
     D  hrsebe                        6p 0
     D  hrriec                        3
     D  hrxcob                        3p 0
     D  hrfmoa                        4p 0
     D  hrfmom                        2p 0
     D  hrfmod                        2p 0
     D  hrpsec                        2p 0
     D  hrnupe                        8p 0
     D  hrnroc                        7p 0
     D  hrcoma                        2
     D  hrnrma                        7p 0
     D  hresma                        1p 0
     D  hrmonr                        2
     D  hrimmr                       15p 2
     D  hrimnr                       15p 2
     D  hrmoeq                        2
     D  hrimco                       15p 6
     D  hrimau                       15p 2
     D  hrimna                       15p 2
     D  hrmar1                        1
     D  hrmar2                        1
     D  hrmar3                        1
     D  hrmar4                        1
     D  hrmar5                        1
     D  hruser                       10
     D  hrtime                        6p 0
     D  hrfera                        4p 0
     D  hrferm                        2p 0
     D  hrferd                        2p 0
     D  hrtifa                        2p 0
     D  hrnrsf                        4p 0
     D  hrnrfa                        8p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsfa
      * --------------------------------------------------- *
     D DsPahsfa_t      ds                  qualified template
     D  faempr                        1
     D  fasucu                        2
     D  farama                        2p 0
     D  fasini                        4p 0
     D  fanops                        4p 0
     D  fapoco                        4p 0
     D  fapaco                        2p 0
     D  fariec                        3
     D  faxcob                        2p 0
     D  faarcd                        4p 0
     D  faspol                        5p 0
     D  fasspo                        2p 0
     D  faarse                        2p 0
     D  faoper                        4p 0
     D  fasuop                        2p 0
     D  faccrt                        5p 0
     D  fapoli                        4p 0
     D  fanrdf                        4p 0
     D  fanomb                       40
     D  fatido                        2p 0
     D  fanrdo                        5p 0
     D  facuil                        6p 0
     D  famar1                        1
     D  famar2                        1
     D  famar3                        1
     D  famar4                        1
     D  famar5                        1
     D  fastrg                        1
     D  fauser                       10
     D  fatime                        6p 0
     D  fafera                        4p 0
     D  faferm                        2p 0
     D  faferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahslk
      * --------------------------------------------------- *
     D DsPahslk_t      ds                  qualified template
     D lkempr                         1
     D lksucu                         2
     D lkrama                         2p 0
     D lksini                         4p 0
     D lknops                         4p 0
     D lkmar1                         1
     D lkmar2                         1
     D lkmar3                         1
     D lkmar4                         1
     D lkmar5                         1
     D lkwdis                        10
     D lkuser                        10
     D lktime                         6p 0
     D lkfera                         4p 0
     D lkferm                         2p 0
     D lkferd                         2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahspe
      * --------------------------------------------------- *
     D DsPahsep_t      ds                  qualified template
     D  epempr                        1
     D  epsucu                        2
     D  eprama                        2p 0
     D  epsini                        4p 0
     D  epnops                        4p 0
     D  epscbp                        3p 0
     D  epmar1                        1
     D  epmar2                        1
     D  epmar3                        1
     D  epmar4                        1
     D  epmar5                        1
     D  epuser                       10
     D  eptime                        6p 0
     D  epfera                        4p 0
     D  epferm                        2p 0
     D  epferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahssp
      * --------------------------------------------------- *
     D DsPahssp_t      ds                  qualified template
     D  spempr                        1a
     D  spsucu                        2a
     D  sprama                        2  0
     D  spsini                        7  0
     D  spnops                        7  0
     D  spnoma                       40a
     D  spnomt                       40a
     D  spap01                        1  0
     D  spap02                        1  0
     D  spap03                        1  0
     D  spap04                        1  0
     D  spap05                        1  0
     D  spap06                        1  0
     D  spap07                        1  0
     D  spap08                        1  0
     D  spap09                        1  0
     D  spap10                        1  0
     D  spap11                        1  0
     D  spap12                        1  0
     D  spap13                        1  0
     D  spap14                        1  0
     D  spap15                        1  0
     D  spmar1                        1a
     D  spmar2                        1a
     D  spmar3                        1a
     D  spmar4                        1a
     D  spmar5                        1a
     D  spuser                       10a
     D  sptime                        6  0
     D  spfera                        4  0
     D  spferm                        2  0
     D  spferd                        2  0
      * --------------------------------------------------- *
      * Estrucutura de datos Pawsbe
      * --------------------------------------------------- *
     D DsPawsbe_t      ds                  qualified template
     D  bwempr                        1
     D  bwsucu                        2
     D  bwrama                        2p 0
     D  bwsini                        7p 0
     D  bwnops                        7p 0
     D  bwnrdf                        7p 0
     D  bwsebe                        6p 0
     D  bwnomb                       40
     D  bwmar1                        1
     D  bwmar2                        1
     D  bwmar3                        1
     D  bwmar4                        1
     D  bwmar5                        1
     D  bwuser                       10
     D  bwtime                        6p 0
     D  bwdate                        6p 0
     D  bwfera                        4p 0
     D  bwferm                        2p 0
     D  bwferd                        2p 0
     D  bwmonr                        2
     D  bwcoma                        2
     D  bwnrma                        7p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahslp
      * --------------------------------------------------- *
     D DsPahslp_t      ds                  qualified template
     D  lpempr                        1
     D  lpsucu                        2
     D  lpfmoa                        4p 0
     D  lpfmom                        2p 0
     D  lpfmod                        2p 0
     D  lpartc                        2p 0
     D  lpcomo                        2
     D  lppsec                        6p 0
     D  lplmap                       15p 2
     D  lpicma                       15p 2
     D  lpmar1                        1
     D  lpmar2                        1
     D  lpmar3                        1
     D  lpmar4                        1
     D  lpmar5                        1
     D  lpusua                       10
     D  lptime                        6p 0
     D  lpdate                        6p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Cnhric
      * --------------------------------------------------- *
     D DsCnhric_t      ds                  qualified template
     D  icempr                        1
     D  icsucu                        2
     D  icartc                        2p 0
     D  icpacp                        6p 0
     D  icivnr                        7p 0
     D  ictire                        2p 0
     D  icmar1                        1
     D  icmar2                        1
     D  icmar3                        1
     D  icmar4                        1
     D  icmar5                        1
     D  icmar6                        1
     D  icmar7                        1
     D  icmar8                        1
     D  icmar9                        1
     D  icmar0                        1
     D  icdate                        8p 0
     D  ictime                        6p 0
     D  icuser                       10

      * --------------------------------------------------- *
      * Estrucutura de datos Cnhrid
      * --------------------------------------------------- *
     D DsCnhrid_t      ds                  qualified template
     D  idempr                        1
     D  idsucu                        2
     D  idartc                        2p 0
     D  idpacp                        6p 0
     D  idivnr                        7p 0
     D  idtpnl                        3p 0
     D  idtpds                       79
     D  iddate                        8p 0
     D  idtime                        6p 0
     D  iduser                       10

      * ------------------------------------------------------------ *
      * SVPSI1_inz(): Inicializa módulo.                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPSI1_inz      pr

      * ------------------------------------------------------------ *
      * SVPSI1_End(): Finaliza módulo.                               *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPSI1_End      pr

      * ------------------------------------------------------------ *
      * SVPSI1_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPSI1_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahscd(): Retorna datos de Pahscd                       *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                ( opcional ) *
      *         peNops   ( input  ) Operación de Siniestro   ( opcional ) *
      *         peLscd   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLscdC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahscd...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 options( *Nopass : *Omit ) const
     D   peNops                       7  0 options( *Nopass : *Omit ) const
     D   peLscd                            likeds(dsPahscd_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLscdC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahscd(): Valida si existe siniestro               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahscd...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahscd(): Graba datos en el archivo pahscd              *
      *                                                                   *
      *          peDsCd   ( input  ) Estrutura de pahscd                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahscd...
     D                 pr              n
     D   peDsCd                            likeds( dsPahscd_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahscd(): Actualiza datos en el archivo pahscd          *
      *                                                                   *
      *          peDsCd   ( input  ) Estrutura de pahscd                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahscd...
     D                 pr              n
     D   peDsCd                            likeds( dsPahscd_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahscd(): Elimina datos en el archivo pahscd            *
      *                                                                   *
      *          peDsCd   ( input  ) Estrutura de pahscd                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahscd...
     D                 pr              n
     D   peDsCd                            likeds( dsPahscd_t ) const

      * ------------------------------------------------------------ *
      * SVPSI1_getPahsbe(): Retorna datos de Beneficiario del sini-  *
      *                     estro.-                                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsBe   ( output ) Estructura de Beneficiarios de Sini. *
      *     peDsBeC  ( output ) Cantidad de Beneficiario de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_getPahsbe...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 options(*nopass:*omit) const
     D   peNops                       7  0 options(*nopass:*omit) const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsBe                            likeds ( DsPahsbe_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsBeC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsbe(): Valida si existe Beneficiario del sini-  *
      *                     estro.-                                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsbe...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsbe(): Graba datos en el archivo pahsbe              *
      *                                                                   *
      *          peDsBe   ( input  ) Estrutura de pahsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsbe...
     D                 pr              n
     D   peDsBe                            likeds( dsPahsbe_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsbe(): Actualiza datos en el archivo pahsbe          *
      *                                                                   *
      *          peDsBe   ( input  ) Estrutura de pahscd                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsbe...
     D                 pr              n
     D   peDsBe                            likeds( dsPahsbe_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsbe(): Elimina datos en el archivo pahsbe            *
      *                                                                   *
      *          peDsBe   ( input  ) Estrutura de pahsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsbe...
     D                 pr              n
     D   peDsBe                            likeds( dsPahsbe_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsbo(): Retorna datos de Pahsbo                       *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peOsec   ( input  ) Secuencia de Objeto                   *
      *         peLsbo   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsboC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsbo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const
     D   peLsbo                            likeds(dsPahsbo_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsboC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsbo(): Valida si existe siniestro               *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peOsec   ( input  ) Secuencia de Objeto              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsbo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsbo(): Graba datos en el archivo pahsbo              *
      *                                                                   *
      *          peDsbo   ( input  ) Estrutura de pahsbo                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsbo...
     D                 pr              n
     D   peDsbo                            likeds( dsPahsbo_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsbo(): Actualiza datos en el archivo pahsbo          *
      *                                                                   *
      *          peDsbo   ( input  ) Estrutura de pahsbo                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsbo...
     D                 pr              n
     D   peDsbo                            likeds( dsPahsbo_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsbo(): Elimina datos en el archivo pahsbo            *
      *                                                                   *
      *          peDsbo   ( input  ) Estrutura de pahsbo                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsbo...
     D                 pr              n
     D   peDsbo                            likeds( dsPahsbo_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsbr(): Retorna datos de Reasegurado                  *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peFmoa   ( input  ) Anio del Movimiento                   *
      *         peFmom   ( input  ) Mes  del Movimiento                   *
      *         peFmod   ( input  ) Dia  del Movimiento                   *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLsbr   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsbrC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsbr...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLsbr                            likeds(dsPahsbr_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsbrC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsbr(): Valida si existe reasegurado             *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peNrdf   ( input  ) Num Persona                      *
      *         peSebe   ( input  ) Sec. Benef. Siniestros           *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peFmoa   ( input  ) Anio del Movimiento              *
      *         peFmom   ( input  ) Mes  del Movimiento              *
      *         peFmod   ( input  ) Dia  del Movimiento              *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsbr...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsbr(): Graba datos en el archivo pahsbr              *
      *                                                                   *
      *          peDsbr   ( input  ) Estrutura de pahsbr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsbr...
     D                 pr              n
     D   peDsbr                            likeds( dsPahsbr_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsbr(): Actualiza datos en el archivo pahsbr          *
      *                                                                   *
      *          peDsbr   ( input  ) Estrutura de pahsbr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsbr...
     D                 pr              n
     D   peDsbr                            likeds( dsPahsbr_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsbr(): Elimina datos en el archivo pahsbr            *
      *                                                                   *
      *          peDsbr   ( input  ) Estrutura de pahsbr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsbr...
     D                 pr              n
     D   peDsbr                            likeds( dsPahsbr_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsbs(): Retorna datos de Bienes Siniestrado           *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                ( opcional ) *
      *         peNops   ( input  ) Operación de Siniestro   ( opcional ) *
      *         pePoco   ( input  ) Nro Componente           ( opcional ) *
      *         pePaco   ( input  ) Cod Parentesco           ( opcional ) *
      *         peRiec   ( input  ) Cod Riesgo               ( opcional ) *
      *         peXcob   ( input  ) Cod Cobertura            ( opcional ) *
      *         peLsbs   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsbsC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsbs...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 options(*nopass:*omit) const
     D   peNops                       7  0 options(*nopass:*omit) const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peLsbs                            likeds(dsPahsbs_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsbsC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsbs(): Valida si existe bienes siniestrados     *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsbs...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsbs(): Graba datos en el archivo pahsbs              *
      *                                                                   *
      *          peDsbs   ( input  ) Estrutura de pahsbs                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsbs...
     D                 pr              n
     D   peDsbs                            likeds( dsPahsbs_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsbs(): Actualiza datos en el archivo pahsbs          *
      *                                                                   *
      *          peDsbs   ( input  ) Estrutura de pahsbs                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsbs...
     D                 pr              n
     D   peDsbs                            likeds( dsPahsbs_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsbs(): Elimina datos en el archivo pahsbs            *
      *                                                                   *
      *          peDsbs   ( input  ) Estrutura de pahsbs                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsbs...
     D                 pr              n
     D   peDsbs                            likeds( dsPahsbs_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsb1(): Retorna datos de Beneficiario / Reclamo       *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peFema   ( input  ) Anio de emision                       *
      *         peFemm   ( input  ) Mes  de emision                       *
      *         peFemd   ( input  ) Dia  de emision                       *
      *         peLsb1   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsb1C  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsb1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   peLsb1                            likeds(dsPahsb1_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsb1C                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsb1(): Valida si existe beneficiario / reclamo  *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peNrdf   ( input  ) Num Persona                      *
      *         peSebe   ( input  ) Sec. Benef. Siniestros           *
      *         peFema   ( input  ) Anio de emision                  *
      *         peFemm   ( input  ) Mes  de emision                  *
      *         peFemd   ( input  ) Dia  de emision                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsb1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsb1(): Graba datos en el archivo pahsb1              *
      *                                                                   *
      *          peDsb1   ( input  ) Estrutura de pahsb1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsb1...
     D                 pr              n
     D   peDsb1                            likeds( dsPahsb1_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsb1(): Actualiza datos en el archivo pahsb1          *
      *                                                                   *
      *          peDsb1   ( input  ) Estrutura de pahsb1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsb1...
     D                 pr              n
     D   peDsb1                            likeds( dsPahsb1_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsb1(): Elimina datos en el archivo pahsb1            *
      *                                                                   *
      *          peDsb1   ( input  ) Estrutura de pahsb1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsb1...
     D                 pr              n
     D   peDsb1                            likeds( dsPahsb1_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsb2(): Retorna datos de Beneficiario Adicional       *
      *                     Conductores                                   *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peLsb2   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsb2C  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsb2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peLsb2                            likeds(dsPahsb2_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsb2C                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsb2(): Valida si existe beneficiario adicional  *
      *                     conductores                              *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peNrdf   ( input  ) Num Persona                      *
      *         PeSebe   ( input  ) Sec. Benef. Siniestros           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsb2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsb2(): Graba datos en el archivo pahsb2              *
      *                                                                   *
      *          peDsb2   ( input  ) Estrutura de pahsb2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsb2...
     D                 pr              n
     D   peDsb2                            likeds( dsPahsb2_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsb2(): Actualiza datos en el archivo pahsb2          *
      *                                                                   *
      *          peDsb2   ( input  ) Estrutura de pahsb2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsb2...
     D                 pr              n
     D   peDsb2                            likeds( dsPahsb2_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsb2(): Elimina datos en el archivo pahsb2            *
      *                                                                   *
      *          peDsb2   ( input  ) Estrutura de pahsb2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsb2...
     D                 pr              n
     D   peDsb2                            likeds( dsPahsb2_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsb4(): Retorna datos de Beneficiario Adiconal        *
      *                     Vehiculo del Tercero                          *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peLsb4   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsb4C  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsb4...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peLsb4                            likeds(dsPahsb4_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsb4C                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsb4(): Valida si existe beneficiario adicional  *
      *                     vehiculo del tercero                     *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peNrdf   ( input  ) Num Persona                      *
      *         peSebe   ( input  ) Sec. Benef. Siniestros           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsb4...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsb4(): Graba datos en el archivo pahsb4              *
      *                                                                   *
      *          peDsb4   ( input  ) Estrutura de pahsb4                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsb4...
     D                 pr              n
     D   peDsb4                            likeds( dsPahsb4_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsb4(): Actualiza datos en el archivo pahsb4          *
      *                                                                   *
      *          peDsb4   ( input  ) Estrutura de pahsb4                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsb4...
     D                 pr              n
     D   peDsb4                            likeds( dsPahsb4_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsb4(): Elimina datos en el archivo pahsb4            *
      *                                                                   *
      *          peDsb4   ( input  ) Estrutura de pahsb4                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsb4...
     D                 pr              n
     D   peDsb4                            likeds( dsPahsb4_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahscc(): Retorna datos de Cuenta Corriente             *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peCmov   ( input  ) Cod Movimiento                        *
      *         peFmoa   ( input  ) Anio del Movimiento                   *
      *         peFmom   ( input  ) Mes  del Movimiento                   *
      *         peFmod   ( input  ) Dia  del Movimiento                   *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLscc   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsccC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahscc...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peCmov                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLscc                            likeds(dsPahscc_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsccC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahscc(): Valida si existe cuenta corriente        *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         peCmov   ( input  ) Cod Movimiento                   *
      *         peFmoa   ( input  ) Anio del Movimiento              *
      *         peFmom   ( input  ) Mes  del Movimiento              *
      *         peFmod   ( input  ) Dia  del Movimiento              *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahscc...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peCmov                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahscc(): Graba datos en el archivo pahscc              *
      *                                                                   *
      *          peDscc   ( input  ) Estrutura de pahscc                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahscc...
     D                 pr              n
     D   peDscc                            likeds( dsPahscc_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahscc(): Actualiza datos en el archivo pahscc          *
      *                                                                   *
      *          peDscc   ( input  ) Estrutura de pahscc                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahscc...
     D                 pr              n
     D   peDscc                            likeds( dsPahscc_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahscc(): Elimina datos en el archivo pahscc            *
      *                                                                   *
      *          peDscc   ( input  ) Estrutura de pahscc                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahscc...
     D                 pr              n
     D   peDscc                            likeds( dsPahscc_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsc1(): Retorna datos de Extensión Autos              *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLsc1   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsc1C  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsc1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peLsc1                            likeds(dsPahsc1_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsc1C                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsc1(): Valida si existe extensión autos         *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsc1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsc1(): Graba datos en el archivo pahsc1              *
      *                                                                   *
      *          peDsc1   ( input  ) Estrutura de pahsc1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsc1...
     D                 pr              n
     D   peDsc1                            likeds( dsPahsc1_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsc1(): Actualiza datos en el archivo pahsc1          *
      *                                                                   *
      *          peDsc1   ( input  ) Estrutura de pahsc1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsc1...
     D                 pr              n
     D   peDsc1                            likeds( dsPahsc1_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsc1(): Elimina datos en el archivo pahsc1            *
      *                                                                   *
      *          peDsc1   ( input  ) Estrutura de pahsc1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsc1...
     D                 pr              n
     D   peDsc1                            likeds( dsPahsc1_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsdt(): Retorna datos de Transporte                   *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLsdt   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsdtC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsdt...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peLsdt                            likeds(dsPahsdt_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsdtC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsdt(): Valida si existe transporte              *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsdt...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsdt(): Graba datos en el archivo pahsdt              *
      *                                                                   *
      *          peDsdt   ( input  ) Estrutura de pahsdt                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsdt...
     D                 pr              n
     D   peDsdt                            likeds( dsPahsdt_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsdt(): Actualiza datos en el archivo pahsdt          *
      *                                                                   *
      *          peDsdt   ( input  ) Estrutura de pahsdt                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsdt...
     D                 pr              n
     D   peDsdt                            likeds( dsPahsdt_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsdt(): Elimina datos en el archivo pahsdt            *
      *                                                                   *
      *          peDsdt   ( input  ) Estrutura de pahsdt                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsdt...
     D                 pr              n
     D   peDsdt                            likeds( dsPahsdt_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsfr(): Retorna datos de Importe Franquicia           *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peFmoa   ( input  ) Anio Movimiento                       *
      *         peFmom   ( input  ) Mes Movimiento                        *
      *         peFmod   ( input  ) Dia Movimiento                        *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLsfr   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsfrC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsfr...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       1    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLsfr                            likeds(dsPahsfr_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsfrC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsfr(): Valida si existe importe franquicia      *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peNrdf   ( input  ) Num Persona                      *
      *         peSebe   ( input  ) Sec. Benef. Siniestros           *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peFmoa   ( input  ) Anio Movimiento                  *
      *         peFmom   ( input  ) Mes Movimiento                   *
      *         peFmod   ( input  ) Dia Movimiento                   *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsfr...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       1    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsfr(): Graba datos en el archivo pahsfr              *
      *                                                                   *
      *          peDsfr   ( input  ) Estrutura de pahsfr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsfr...
     D                 pr              n
     D   peDsfr                            likeds( dsPahsfr_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsfr(): Actualiza datos en el archivo pahsfr          *
      *                                                                   *
      *          peDsfr   ( input  ) Estrutura de pahsfr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsfr...
     D                 pr              n
     D   peDsfr                            likeds( dsPahsfr_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsfr(): Elimina datos en el archivo pahsfr            *
      *                                                                   *
      *          peDsfr   ( input  ) Estrutura de pahsfr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsfr...
     D                 pr              n
     D   peDsfr                            likeds( dsPahsfr_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahshe(): Retorna datos de Historia del Estado de Sini- *
      *                     estro                                         *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peFema   ( input  ) Fecha Emision Anio                    *
      *         peFemm   ( input  ) Fecha Emision Mes                     *
      *         peFemd   ( input  ) Fecha Emision Dia                     *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peCesi   ( input  ) Cod Estadp Siniestro                  *
      *         peLshe   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsheC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahshe...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   pePsec                       2  0 const
     D   peCesi                       2  0 const
     D   peLshe                            likeds(dsPahshe_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsheC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahshe(): Valida si existe historia del estado de  *
      *                     siniestro                                *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         peFema   ( input  ) Fecha Emision Anio               *
      *         peFemm   ( input  ) Fecha Emision Mes                *
      *         peFemd   ( input  ) Fecha Emision Dia                *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *         peCesi   ( input  ) Cod Estadp Siniestro             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahshe...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   pePsec                       2  0 const
     D   peCesi                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahshe(): Graba datos en el archivo pahshe              *
      *                                                                   *
      *          peDshe   ( input  ) Estrutura de pahshe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahshe...
     D                 pr              n
     D   peDshe                            likeds( dsPahshe_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahshe(): Actualiza datos en el archivo pahshe          *
      *                                                                   *
      *          peDshe   ( input  ) Estrutura de pahshe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahshe...
     D                 pr              n
     D   peDshe                            likeds( dsPahshe_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahshe(): Elimina datos en el archivo pahshe            *
      *                                                                   *
      *          peDshe   ( input  ) Estrutura de pahshe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahshe...
     D                 pr              n
     D   peDshe                            likeds( dsPahshe_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahshp(): Retorna datos de Pagos Históricos             *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peNrdf   ( input  ) Num Persona                           *
      *         PeSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peFmoa   ( input  ) Anio Movimiento                       *
      *         peFmom   ( input  ) Mes Movimiento                        *
      *         peFmod   ( input  ) Dia Movimiento                        *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLshp   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLshpC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahshp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLshp                            likeds(dsPahshp_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLshpC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahshp(): Valida si existe pagos históricos        *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peNrdf   ( input  ) Num Persona                      *
      *         PESebe   ( input  ) Sec. Benef. Siniestros           *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peFmoa   ( input  ) Anio Movimiento                  *
      *         peFmom   ( input  ) Mes Movimiento                   *
      *         peFmod   ( input  ) Dia Movimiento                   *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahshp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahshp(): Graba datos en el archivo pahshp              *
      *                                                                   *
      *          peDshp   ( input  ) Estrutura de pahshp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahshp...
     D                 pr              n
     D   peDshp                            likeds( dsPahshp_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahshp(): Actualiza datos en el archivo pahshp          *
      *                                                                   *
      *          peDshp   ( input  ) Estrutura de pahshp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahshp...
     D                 pr              n
     D   peDshp                            likeds( dsPahshp_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahshp(): Elimina datos en el archivo pahshp            *
      *                                                                   *
      *          peDshp   ( input  ) Estrutura de pahshp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahshp...
     D                 pr              n
     D   peDshp                            likeds( dsPahshp_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahshr(): Retorna datos de Reservas Históricas          *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         pePoco   ( input  ) Nro Componente                        *
      *         pePaco   ( input  ) Cod Parentesco                        *
      *         peNrdf   ( input  ) Num Persona                           *
      *         peSebe   ( input  ) Sec. Benef. Siniestros                *
      *         peRiec   ( input  ) Cod Riesgo                            *
      *         peXcob   ( input  ) Cod Cobertura                         *
      *         peFmoa   ( input  ) Anio Movimiento                       *
      *         peFmom   ( input  ) Mes Movimiento                        *
      *         peFmod   ( input  ) Dia Movimiento                        *
      *         pePsec   ( input  ) Nro Secuencia                         *
      *         peLshr   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLshrC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahshr...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       1    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const
     D   peLshr                            likeds(dsPahshr_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLshrC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahshr(): Valida si existe reservas históricas     *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peRama   ( input  ) Rama                             *
      *         peSini   ( input  ) Siniestro                        *
      *         peNops   ( input  ) Operación de Siniestro           *
      *         pePoco   ( input  ) Nro Componente                   *
      *         pePaco   ( input  ) Cod Parentesco                   *
      *         peNrdf   ( input  ) Num Persona                      *
      *         peSebe   ( input  ) Sec. Benef. Siniestros           *
      *         peRiec   ( input  ) Cod Riesgo                       *
      *         peXcob   ( input  ) Cod Cobertura                    *
      *         peFmoa   ( input  ) Anio Movimiento                  *
      *         peFmom   ( input  ) Mes Movimiento                   *
      *         peFmod   ( input  ) Dia Movimiento                   *
      *         pePsec   ( input  ) Nro Secuencia                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahshr...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       1    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahshr(): Graba datos en el archivo pahshr              *
      *                                                                   *
      *          peDshr   ( input  ) Estrutura de pahshr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahshr...
     D                 pr              n
     D   peDshr                            likeds( dsPahshr_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahshr(): Actualiza datos en el archivo pahshr          *
      *                                                                   *
      *          peDshr   ( input  ) Estrutura de pahshr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahshr...
     D                 pr              n
     D   peDshr                            likeds( dsPahshr_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahshr(): Elimina datos en el archivo pahshr            *
      *                                                                   *
      *          peDshr   ( input  ) Estrutura de pahshr                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahshr...
     D                 pr              n
     D   peDshr                            likeds( dsPahshr_t ) const

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsd0(): Valida si existe detalle de forma que    *
      *                     ocurre el siniestro                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsd0...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsd0(): Graba datos en el archivo Pahsd0              *
      *                                                                   *
      *          peDSD0   ( input  ) Estrutura de Pahsd0                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsd0...
     D                 pr              n
     D   peDSD0                            likeds( dsPahsd0_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsd0(): Actualiza datos en el archivo Pahsd0          *
      *                                                                   *
      *          peDSD0   ( input  ) Estrutura de Pahsd0                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsd0...
     D                 pr              n
     D   peDSD0                            likeds( dsPahsd0_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsd0(): Elimina datos en el archivo Pahsd0            *
      *                                                                   *
      *          peDSD0   ( input  ) Estrutura de Pahsd0                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsd0...
     D                 pr              n
     D   peDSD0                            likeds( dsPahsd0_t ) const

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsd1(): Valida si existe detalle del daño        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrre   (input)   Nro Linea Texto                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsd1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   penrre                       3  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsd1(): Graba datos en el archivo pahsd1              *
      *                                                                   *
      *          peDsd1   ( input  ) Estrutura de pahsd1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsd1...
     D                 pr              n
     D   peDsd1                            likeds( dsPahsd1_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsd1(): Actualiza datos en el archivo pahsd1          *
      *                                                                   *
      *          peDsd1   ( input  ) Estrutura de pahsd1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsd1...
     D                 pr              n
     D   peDsd1                            likeds( dsPahsd1_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsd1(): Elimina datos en el archivo pahsd1            *
      *                                                                   *
      *          peDsd1   ( input  ) Estrutura de pahsd1                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsd1...
     D                 pr              n
     D   peDsd1                            likeds( dsPahsd1_t ) const

      * ------------------------------------------------------------ *
      * SVPSI1_chkpahsd2(): Valida si existe detalle del daño - Vehi-*
      *                     culo Terceros                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkpahsd2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setpahsd2(): Graba datos en el archivo pahsd2              *
      *                                                                   *
      *          peDSD2   ( input  ) Estrutura de pahsd2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setpahsd2...
     D                 pr              n
     D   peDSD2                            likeds( dspahsd2_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updpahsd2(): Actualiza datos en el archivo pahsd2          *
      *                                                                   *
      *          peDSD2   ( input  ) Estrutura de pahsd2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updpahsd2...
     D                 pr              n
     D   peDSD2                            likeds( dspahsd2_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltpahsd2(): Elimina datos en el archivo pahsd2            *
      *                                                                   *
      *          peDSD2   ( input  ) Estrutura de pahsd2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltpahsd2...
     D                 pr              n
     D   peDSD2                            likeds( dspahsd2_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsep(): Retorna datos de estado de póliza de siniestro*
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLsep   ( output ) Lista de Siniestros                   *
      *         peLsepC  ( output ) Cantidad Siniestros                   *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsep...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peLsep                            likeds(dsPahsep_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsepC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsep(): Valida si existe estado de póliza del    *
      *                     siniestro                                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsep...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsep(): Graba datos en el archivo pahsep              *
      *                                                                   *
      *          peDsep   ( input  ) Estrutura de pahsep                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsep...
     D                 pr              n
     D   peDsep                            likeds( dsPahsep_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsep(): Actualiza datos en el archivo pahsep          *
      *                                                                   *
      *          peDsep   ( input  ) Estrutura de pahsep                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsep...
     D                 pr              n
     D   peDsep                            likeds( dsPahsep_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsep(): Elimina datos en el archivo pahsep            *
      *                                                                   *
      *          peDsep   ( input  ) Estrutura de pahsep                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsep...
     D                 pr              n
     D   peDsep                            likeds( dsPahsep_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsfa(): Retorna datos de Fallecimiento                *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLsfa   ( output ) Lista de Siniestros                   *
      *         peLsfaC  ( output ) Cantidad Siniestros                   *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsfa...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peLsfa                            likeds(dsPahsfa_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsfaC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsfa(): Valida si existe fallecimiento           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsfa...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsfa(): Graba datos en el archivo pahsfa              *
      *                                                                   *
      *          peDsfa   ( input  ) Estrutura de pahsfa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsfa...
     D                 pr              n
     D   peDsfa                            likeds( dsPahsfa_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsfa(): Actualiza datos en el archivo pahsfa          *
      *                                                                   *
      *          peDsfa   ( input  ) Estrutura de pahsfa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsfa...
     D                 pr              n
     D   peDsfa                            likeds( dsPahsfa_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsfa(): Elimina datos en el archivo pahsfa            *
      *                                                                   *
      *          peDsfa   ( input  ) Estrutura de pahsfa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsfa...
     D                 pr              n
     D   peDsfa                            likeds( dsPahsfa_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahslk(): Retorna datos de Siniestro en Proceso         *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *         peLslk   ( output ) Lista de Siniestros                   *
      *         peLslkC  ( output ) Cantidad Siniestros                   *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahslk...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peLslk                            likeds(dsPahslk_t) dim(9999)
     D   peLslkC                     10i 0

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahslk(): Valida si existe siniestro en proceso    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahslk...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahslk(): Graba datos en el archivo pahslk              *
      *                                                                   *
      *          peDslk   ( input  ) Estrutura de pahslk                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahslk...
     D                 pr              n
     D   peDslk                            likeds( dsPahslk_t ) const


      * ----------------------------------------------------------------- *
      * SVPSI1_updPahslk(): Actualiza datos en el archivo pahslk          *
      *                                                                   *
      *          peDslk   ( input  ) Estrutura de pahslk                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahslk...
     D                 pr              n
     D   peDslk                            likeds( dsPahslk_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahslk(): Elimina datos en el archivo pahslk            *
      *                                                                   *
      *          peDslk   ( input  ) Estrutura de pahslk                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahslk...
     D                 pr              n
     D   peDslk                            likeds( dsPahslk_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahsus(): Retorna datos de Usuario                      *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peUser   ( input  ) Usuario                               *
      *         peRama   ( input  ) Rama                                  *
      *         peLsus   ( output ) Lista de Usuario                      *
      *         peLsusC  ( output ) Cantidad de Usuarios                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahsus...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peUser                      10    const
     D   peRama                       2  0 const
     D   peLsus                            likeds(dsPahsus_t) dim(9999)
     D   peLsusC                     10i 0

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahsus(): Valida si existe usuario                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peUser   (input)   Usuario                               *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahsus...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peUser                      10    const
     D   peRama                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahsus(): Graba datos en el archivo pahsus              *
      *                                                                   *
      *          peDsus   ( input  ) Estrutura de pahsus                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahsus...
     D                 pr              n
     D   peDsus                            likeds( dsPahsus_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahsus(): Actualiza datos en el archivo pahsus          *
      *                                                                   *
      *          peDsus   ( input  ) Estrutura de pahsus                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahsus...
     D                 pr              n
     D   peDsus                            likeds( dsPahsus_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahsus(): Elimina datos en el archivo pahsus            *
      *                                                                   *
      *          peDsus   ( input  ) Estrutura de pahsus                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahsus...
     D                 pr              n
     D   peDsus                            likeds( dsPahsus_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_numeraAltaSiniestro : Númera en alta de Siniestro          *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *                                                                   *
      * retorna numero de Siniestro                                       *
      * ----------------------------------------------------------------- *
     D SVPSI1_numeraAltaSiniestro...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_numeraSet904 : Númera y actualiza SET904                   *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (output)  Siniestro                                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_numeraSet904...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_envioMailAltaSiniestralidad: Envio de Mail en caso de Alta *
      *                                     Siniestralidad.               *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_envioMailAltaSiniestralidad...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_saldoConsolidadoSiniestroPesos :  Saldo Consolidado de un  *
      *                                          Siniestro en Pesos.      *
      * Sumo Reservas a una determinada fecha y le resto las Franquicias. *
      * Sumo los pagos a una determinada fecha.                           *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *     peFmoa   (input)   Fecha Movimiento Año                       *
      *     peFmom   (input)   Fecha Movimiento Mes                       *
      *     peFmod   (input)   Fecha Movimiento Día                       *
      *     peRese   (output)  Importe de Reserva                         *
      *     pePaga   (output)  Importe de Pagos                           *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_saldoConsolidadoSiniestroPesos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   peRese                      15  2
     D   pePaga                      15  2

      * ----------------------------------------------------------------- *
      * SVPSI1_guarSinPDS : Guarda Siniestero en Pre-Denuncia de Siniestro*
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_guarSinPDS...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_cantidadSiniestrosEnAlta:Cantidad de Siniestros en Alta de *
      *                                 Siniestros.                       *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Número de Operación Siniestro              *
      *                                                                   *
      * retorna Cantidad                                                  *
      * ----------------------------------------------------------------- *
     D SVPSI1_cantidadSiniestrosEnAlta...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_chkPasoDeTrabajo : Cheque Pasos de Trabajo del Siniestro   *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_chkPasoDeTrabajo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_getNumReclamo : Recupera ultimo numero de reclamo para la  *
      *                        Caratula                                   *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *                                                                   *
      * retorna: Numero de Reclamo / -1 Error                             *
      * ----------------------------------------------------------------- *
     D SVPSI1_getNumReclamo...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_chkNumReclamo: Valida numero del Reclamo                   *
      *                                                                   *
      *     peEmpr   (input)   Empresa                                    *
      *     peSucu   (input)   Sucursal                                   *
      *     peRama   (input)   Rama                                       *
      *     peSini   (input)   Siniestro                                  *
      *     peNops   (input)   Numero de Operacion Siniestro              *
      *     peRecl   (input)   Numero del Reclamo                         *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_chkNumReclamo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_getPahssp(): Retorna datos de siniestro suspendido         *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                ( opcional ) *
      *         peNops   ( input  ) Operación de Siniestro   ( opcional ) *
      *         peLssp   ( output ) Lista de Siniestros      ( opcional ) *
      *         peLsspC  ( output ) Cantidad Siniestros      ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_getPahssp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 options( *Nopass : *Omit ) const
     D   peNops                       7  0 options( *Nopass : *Omit ) const
     D   peLssp                            likeds(dsPahssp_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLsspC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahssp(): Valida si existe siniestro suspendido    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahssp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahssp(): Graba datos en el archivo pahssp              *
      *                                                                   *
      *          peDsSp   ( input  ) Estrutura de pahssp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahssp...
     D                 pr              n
     D   peDsSp                            likeds( dsPahssp_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahssp(): Actualiza datos en el archivo pahssp          *
      *                                                                   *
      *          peDsSp   ( input  ) Estrutura de pahssp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahssp...
     D                 pr              n
     D   peDsSp                            likeds( dsPahssp_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahssp(): Elimina datos en el archivo pahssp            *
      *                                                                   *
      *          peDsSp   ( input  ) Estrutura de pahssp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahssp...
     D                 pr              n
     D   peDsSp                            likeds( dsPahssp_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_RecalBenef: Recalcula Importe del Beneficiario             *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peRama   ( input  ) Rama                                  *
      *         peSini   ( input  ) Siniestro                             *
      *         peNops   ( input  ) Operación de Siniestro                *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_RecalBenef...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSI1_getPahsd1(): Retorna datos de Pahsd1                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peDsd1   ( output ) Lista de detalle de daños (opcional) *
      *     peDsd1C  ( output ) Cant. detalle de daños    (opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_getPahsd1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsd1                            likeds( dsPahsd1_t ) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peDsd1C                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSI1_updMarca03(): Graba paso 03 de Pahssp                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSI1_updMarca03...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
      * ------------------------------------------------------------ *
      * SVPSI1_getPawsbe(): Retorna datos de Beneficiario del sini-  *
      *                     estro.-                                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peDsBw   ( output ) Estructura de Beneficiarios de Sini. *
      *     peDsBwC  ( output ) Cantidad de Beneficiario de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_getPawsbe...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsBw                            likeds ( DsPawsbe_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsBwC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSI1_chkPawsbe(): Valida si existe Beneficiario del sini-  *
      *                     estro.-                                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     peNrdf   ( input  ) Número de Persona                    *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPawsbe...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPawsbe(): Graba datos en el archivo pahsbe              *
      *                                                                   *
      *          peDsBw   ( input  ) Estrutura de pawsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPawsbe...
     D                 pr              n
     D   peDsBw                            likeds( dsPawsbe_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPawsbe(): Actualiza datos en el archivo pawsbe          *
      *                                                                   *
      *          peDsBw   ( input  ) Estrutura de pawsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPawsbe...
     D                 pr              n
     D   peDsBw                            likeds( dsPawsbe_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_dltPawsbe(): Elimina datos en el archivo pawsbe            *
      *                                                                   *
      *          peDsBw   ( input  ) Estrutura de pawsbe                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPawsbe...
     D                 pr              n
     D   peDsBw                            likeds( dsPawsbe_t ) const

      * ------------------------------------------------------------ *
      * SVPSI1_getPahslp(): Retorna datos de Limite Autorizado Pago  *
      *                     por dia.-                                *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peFmoa   ( input  ) Anio del Movimiento                  *
      *     peFmom   ( input  ) Mes del Movimiento                   *
      *     peFmod   ( input  ) Dia del Movimiento                   *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     peComo   ( input  ) Moneda                               *
      *     pePsec   ( input  ) Nro. de Secuencia                    *
      *     peDsLp   ( output ) Estructura de Limite Autorizado      *
      *     peDsLpC  ( output ) Cantidad de Limite Autorizado        *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_getPahslp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   peArtc                       2  0 const
     D   peComo                       2    const
     D   pePsec                       6  0 const
     D   peDsLp                            likeds ( DsPahslp_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsLpC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSI1_chkPahslp(): Valida si existe Limite Autorizado Pago  *
      *                     por dia.-                                *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peFmoa   ( input  ) Anio del Movimiento                  *
      *     peFmom   ( input  ) Mes del Movimiento                   *
      *     peFmod   ( input  ) Dia del Movimiento                   *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     peComo   ( input  ) Moneda                               *
      *     pePsec   ( input  ) Nro. de Secuencia                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahslp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   peArtc                       2  0 const
     D   peComo                       2    const
     D   pePsec                       6  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setPahslp(): Graba datos en el archivo pahslp              *
      *                                                                   *
      *          peDsLp   ( input  ) Estrutura de pahslp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setPahslp...
     D                 pr              n
     D   peDsLp                            likeds( dsPahslp_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updPahslp(): Actualiza datos en el archivo pahslp          *
      *                                                                   *
      *          peDsLp   ( input  ) Estrutura de pahslp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updPahslp...
     D                 pr              n
     D   peDsLp                            likeds( dsPahslp_t ) const
      * ----------------------------------------------------------------- *
      * SVPSI1_dltPahslp(): Elimina datos en el archivo pahslp            *
      *                                                                   *
      *          peDsLp   ( input  ) Estrutura de pahslp                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltPahslp...
     D                 pr              n
     D   peDsLp                            likeds( dsPahslp_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_montoMaximo(): Retorna monto máximo                        *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peIvcv   ( input  ) Código del valor                     *
      *                                                                   *
      * retorna: Monto                                                    *
      * ----------------------------------------------------------------- *
     D SVPSI1_montoMaximo...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvcv                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_chkPahshp01(): Valida si existe Pagos Historicos.-    *
      *                                                              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_chkPahshp01...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

      * ------------------------------------------------------------ *
      * SVPSI1_getCnhric(): Retorna datos de Recibo de Indemnizacion *
      *                     Cabecera.-                               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peIvnr   ( input  ) Nro. Recibo                          *
      *     peDsIc   ( output ) Estructura de Recibo Indemnizacion C *
      *     peDsIcC  ( output ) Cantidad de Recibo Indeminizacion C  *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_getCnhric...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvnr                       7  0 const
     D   peDsIc                            likeds ( DsCnhric_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsIcC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSI1_chkCnhric(): Valida si existe Recibo de Indemnizacion *
      *                     Cabecera.-                               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peIvnr   ( input  ) Nro. Recibo                          *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_chkCnhric...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvnr                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setCnhric(): Graba datos en el archivo Cnhric              *
      *                                                                   *
      *          peDsIc   ( input  ) Estrutura de Cnhric                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setCnhric...
     D                 pr              n
     D   peDsIc                            likeds( dsCnhric_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updCnhric(): Actualiza datos en el archivo Cnhric          *
      *                                                                   *
      *          peDsIc   ( input  ) Estrutura de Cnhric                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updCnhric...
     D                 pr              n
     D   peDsIc                            likeds( dsCnhric_t ) const
      * ----------------------------------------------------------------- *
      * SVPSI1_dltCnhric(): Elimina datos en el archivo Cnhric            *
      *                                                                   *
      *          peDsIc   ( input  ) Estrutura de Cnhric                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltCnhric...
     D                 pr              n
     D   peDsIc                            likeds( dsCnhric_t ) const

      * ------------------------------------------------------------ *
      * SVPSI1_getCnhrid(): Retorna datos de Recibo de Indemnizacion *
      *                     Detalle .-                               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peIvnr   ( input  ) Nro. Recibo                          *
      *     peTpnl   ( input  ) Nro. Linea Texto                     *
      *     peDsId   ( output ) Estructura de Recibo Indemnizacion D *
      *     peDsIdC  ( output ) Cantidad de Recibo Indeminizacion D  *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_getCnhrid...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvnr                       7  0 const
     D   peTpnl                       3  0 const
     D   peDsId                            likeds ( DsCnhrid_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsIdC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSI1_chkCnhrid(): Valida si existe Recibo de Indemnizacion *
      *                     Detalle .-                               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peIvnr   ( input  ) Nro. Recibo                          *
      *     peTpnl   ( input  ) Nro. Linea Texto                     *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_chkCnhrid...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvnr                       7  0 const
     D   peTpnl                       3  0 const

      * ----------------------------------------------------------------- *
      * SVPSI1_setCnhrid(): Graba datos en el archivo Cnhrid              *
      *                                                                   *
      *          peDsId   ( input  ) Estrutura de Cnhrid                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_setCnhrid...
     D                 pr              n
     D   peDsId                            likeds( dsCnhrid_t ) const

      * ----------------------------------------------------------------- *
      * SVPSI1_updCnhrid(): Actualiza datos en el archivo Cnhrid          *
      *                                                                   *
      *          peDsId   ( input  ) Estrutura de Cnhrid                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_updCnhrid...
     D                 pr              n
     D   peDsId                            likeds( dsCnhrid_t ) const
      * ----------------------------------------------------------------- *
      * SVPSI1_dltCnhrid(): Elimina datos en el archivo Cnhrid            *
      *                                                                   *
      *          peDsId   ( input  ) Estrutura de Cnhrid                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSI1_dltCnhrid...
     D                 pr              n
     D   peDsId                            likeds( dsCnhrid_t ) const

      * ------------------------------------------------------------ *
      * SVPSI1_getVoucher():  Recupera ultimo numero de Recibo.-     *
      *                                                              *
      * Retorna: Numero de Recibo / -1 Error                         *
      * ------------------------------------------------------------ *
     D SVPSI1_getVoucher...
     D                 pr             7  0

      * ------------------------------------------------------------ *
      * SVPSI1_getPahshp01(): Retorna datos de Pagos Historicos.-    *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     pePacp   ( input  ) Nro. Cbate. Pago                     *
      *     peDsHp   ( output ) Estructura de Pagos Historicos       *
      *     peDsHpC  ( output ) Cantidad de Pagos Historicos         *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSI1_getPahshp01...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsHp                            likeds ( DsPahshp_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsHpC                     10i 0 options(*nopass:*omit)



