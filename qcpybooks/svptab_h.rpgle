      /if defined(SVPTAB_H)
      /eof
      /endif
      /define SVPTAB_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'

      * Cuestionario no Encontrado...
     D SVPTAB_VTAAJ    c                   const(0001)

      * ------------------------------------------------------------ *
      * DS Tabla SET136
      * ------------------------------------------------------------ *
     D dsSet136_t      ds                  qualified template
     D  t@Ctma                        2  0
     D  t@Dtma                       40a
     D  t@Mweb                        1a
     D  t@Mar1                        1a
     D  t@Mar2                        1a
     D  t@Mar3                        1a
     D  t@Mar4                        1a
     D  t@Mar5                        1a
     D  t@Mar6                        1a
     D  t@Mar7                        1a
     D  t@Mar8                        1a
     D  t@Mar9                        1a
     D  t@Mar0                        1a
     D  t@User                       10a
     D  t@Date                        8  0
     D  t@Time                        6  0

      * ------------------------------------------------------------ *
      * DS Tabla SET137
      * ------------------------------------------------------------ *
     D dsSet137_t      ds                  qualified template
     D  t@Craz                        4  0
     D  t@Draz                       40a
     D  t@Mar1                        1a
     D  t@Mar2                        1a
     D  t@Mar3                        1a
     D  t@Mar4                        1a
     D  t@Mar5                        1a
     D  t@Mar6                        1a
     D  t@Mar7                        1a
     D  t@Mar8                        1a
     D  t@Mar9                        1a
     D  t@Mar0                        1a
     D  t@User                       10a
     D  t@Date                        8  0
     D  t@Time                        6  0

      * ------------------------------------------------------------ *
      * DS Tabla SET138
      * ------------------------------------------------------------ *
     D dsSet138_t      ds                  qualified template
     D  t@Ctma                        2  0
     D  t@Craz                        4  0
     D  t@Mweb                        1a
     D  t@Mar1                        1a
     D  t@Mar2                        1a
     D  t@Mar3                        1a
     D  t@Mar4                        1a
     D  t@Mar5                        1a
     D  t@Mar6                        1a
     D  t@Mar7                        1a
     D  t@Mar8                        1a
     D  t@Mar9                        1a
     D  t@Mar0                        1a
     D  t@User                       10a
     D  t@Date                        8  0
     D  t@Time                        6  0

     D set069_t        ds                  qualified template
     D  t@paco                        3  0
     D  t@pade                       30a
     D  t@user                       10a
     D  t@date                        6  0
     D  t@mweb                        1a

     D dsGntfpg_t      ds                  qualified template
     D  fpcfpg                        1p 0
     D  fpdefp                       20
     D  fpmar1                        1
     D  fpmar2                        1
     D  fpmar3                        1
     D  fpmar4                        1
     D  fpmar5                        1
     D  fpuser                       10
     D  fpdate                        8p 0
     D  fptime                        6p 0

     D dsSet919_t      ds                  qualified template
     D  t@cfpg                        1p 0
     D  t@cfp1                        1p 0
     D  t@mar1                        1
     D  t@mar2                        1
     D  t@mar3                        1
     D  t@mar4                        1
     D  t@mar5                        1
     D  t@user                       10
     D  t@time                        6p 0
     D  t@date                        8p 0

     * - Estructura de CNTRBA  ------------------------------------- *
     D dsCntrba_t      ds                  qualified template
     D  rbempr                        1a
     D  rbsucu                        2a
     D  rbcoma                        2a
     D  rbnrma                        7s 0
     D  rbnrcm                       11s 0
     D  rbdvcm                        1a
     D  rbcomo                        2a
     D  rbtior                        1a
     D  rbcafi                        2s 0
     D  rbaude                       15s 2
     D  rbnrdf                        7s 0
     D  rbimau                       15s 2
     D  rbpoim                        5s 2
     D  rbstrg                        1a
     D  rbivbc                        3s 0
     D  rbivsu                        3s 0
     D  rbcomd                        2a
     D  rbnrmd                        7s 0
     D  rbncta                       25a
     D  rbtcta                        2s 0
     D  rbdv1c                        2s 0
     D  rbdfv1                        2s 0
     D  rbdfm1                        2s 0
     D  rbcpgm                       10a
     D  rbmarp                        1a
     D  rbccuo                        2s 0
     D  rbmar1                        1a
     D  rbmar2                        1a
     D  rbmar3                        1a
     D  rbmar4                        1a
     D  rbmar5                        1a

     D dsCntcfp_t      ds                  qualified template
     D  fpempr                        1a
     D  fpsucu                        2a
     D  fpivcv                        2s 0
     D  fpivdv                       50a
     D  fpmar1                        1a
     D  fpmar2                        1a
     D  fpmar3                        1a
     D  fpmar4                        1a
     D  fpmar5                        1a
     D  fpuser                       10a
     D  fptime                        6s 0
     D  fpdate                        6s 0

     D dsCntnau_t      ds                  qualified template
     D  naempr                        1a
     D  nasucu                        2a
     D  nacoma                        2a
     D  nanrma                        7s 0
     D  nadvna                        1a
     D  nanrdf                        7s 0
     D  naccva                        1a
     D  naeres                        1a
     D  nacofa                        2a
     D  nanrve                        3s 0
     D  nanrco                        3s 0
     D  nanrzo                        3s 0
     D  naconc                        1a
     D  nabloq                        1a
     D  naabcv                        1a
     D  naafhc                       13s 0
     D  nauser                       10a
     D  namaza                        1a
     D  nampte                        1a
     D  namweb                        1a
     D  naconf                        1a
     D  namar1                        1a
     D  namar2                        1a
     D  namar3                        1a
     D  namar4                        1a
     D  namar5                        1a

     D set6202_t       ds                  qualified template
     D  t@arcd                        6s 0
     D  t@tipe                        1a
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a
     D  t@mar6                        1a
     D  t@mar7                        1a
     D  t@mar8                        1a
     D  t@mar9                        1a
     D  t@mar0                        1a
     D  t@user                       10a
     D  t@date                        8s 0
     D  t@time                        6s 0

      * --------------------------------------------------- *
      * Estrucutura de datos Set001
      * --------------------------------------------------- *
     D DsSet001_t      ds                  qualified template
     D  t@rama                        2p 0
     D  t@rame                        2p 0
     D  t@ramd                       20
     D  t@ramb                        5
     D  t@posi                        1
     D  t@pert                        1
     D  t@osut                        1
     D  t@artc                        2p 0
     D  t@rcsn                        1
     D  t@pisn                        1
     D  t@mar1                        1
     D  t@casa                        5p 0
     D  t@mar2                        1
     D  t@mar3                        1
     D  t@mar4                        1
     D  t@mar5                        1
     D  t@mar6                        1
     D  t@mar7                        1
     D  t@mar8                        1
     D  t@mar9                        1
     D  t@user                       10
     D  t@date                        6p 0
     D  t@time                        6p 0
     D  t@rasu                        2p 0
     D  t@mweb                        1
     D  t@mvto                        1
     D  t@canb                        6p 0
     D  t@rssn                        2p 0
     D  t@drpm                       30

     D set405_t        ds                  qualified template
     D  t@clos                        2a
     D  t@dlos                       20a
     D  t@user                       10a
     D  t@time                        6p 0
     D  t@date                        6p 0

     D set401_t        ds                  qualified template
     D  t@rama                        2p 0
     D  t@cauc                        4p 0
     D  t@caud                       30a
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a
     D  t@dcpm                       40a

     D set402_t        ds                  qualified template
     D  t@empr                        1a
     D  t@sucu                        2a
     D  t@rama                        2p 0
     D  t@cesi                        2p 0
     D  t@desi                       30a
     D  t@cese                        2a
     D  t@user                       10a
     D  t@time                        6p 0
     D  t@date                        6p 0
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a

     D set445_t        ds                  qualified template
     D  t@empr                        1a
     D  t@sucu                        2a
     D  t@cdes                        2p 0
     D  t@ddes                       25a
     D  t@user                       10a
     D  t@date                        6p 0
     D  t@time                        6p 0

     D set444_t        ds                  qualified template
     D  t@empr                        1a
     D  t@sucu                        2a
     D  t@rela                        2p 0
     D  t@reld                       25a
     D  t@user                       10a
     D  t@date                        6p 0
     D  t@time                        6p 0

     D dsGntsex_t      ds                  qualified template
     D  secsex                        1p 0
     D  sedsex                       20a
     D  secgen                        1a
     D  semar1                        1a
     D  semar2                        1a
     D  semar3                        1a
     D  semar4                        1a
     D  semar5                        1a
     D  semweb                        1a
     D  seuser                       10a
     D  sedate                        8p 0
     D  setime                        6p 0

     D dsGntesc_t      ds                  qualified template
     D  escesc                        1p 0
     D  esdesc                       20a
     D  escece                        1a
     D  esmar1                        1a
     D  esmar2                        1a
     D  esmar3                        1a
     D  esmar4                        1a
     D  esmar5                        1a
     D  esmweb                        1a
     D  esuser                       10a
     D  esdate                        8p 0
     D  estime                        6p 0

     D dsGntpai_t      ds                  qualified template
     D  papain                        5p 0
     D  papaid                       30a
     D  papaiq                        5p 0
     D  papaor                        5p 0
     D  papais                        9p 0

     D dsSet204_t      ds                  qualified template
     D  t@vhmc                        3a
     D  t@vhmo                        3a
     D  t@vhcs                        3a
     D  t@vhmd                       15a
     D  t@vhdm                       15a
     D  t@vhds                       10a
     D  t@vhca                        2p 0
     D  t@vhv1                        1p 0
     D  t@vhv2                        1p 0
     D  t@vhct                        2p 0
     D  t@vhcr                        3a
     D  t@vhni                        1a
     D  t@vhma                        3a
     D  t@vhml                        3a
     D  t@vhms                        3a
     D  t@cmar                        3p 0
     D  t@cmod                        3p 0
     D  t@vhcb                        2a
     D  t@vhff                        1a
     D  t@vhpe                        6p 0
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a
     D  t@cgru                        3p 0
     D  t@cma1                        9p 0
     D  t@cmo1                        9p 0

     D dsSet205_t      ds                  qualified template
     D  t@vhcr                        3a
     D  t@vhcd                       15a

     D dsSet280_t      ds                  qualified template
     D  t@vhan                        4p 0
     D  t@cmar                        9p 0
     D  t@cgru                        3p 0
     D  t@cmod                        9p 0
     D  t@vhmc                        3a
     D  t@vhmo                        3a
     D  t@vhcs                        3a
     D  t@vhcr                        3a

     D dsSet210_t      ds                  qualified template
     D  t@vhct                        2p 0
     D  t@vhdt                       15a
     D  t@tlim                        1a
     D  t@vhte                        2a
     D  t@ctvh                        2p 0
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a
     D  t@mweb                        1a
     D  t@user                       10a
     D  t@date                        8p 0
     D  t@time                        6p 0

     D dsSet211_t      ds                  qualified template
     D  t@vhuv                        2p 0
     D  t@vhdu                       15a
     D  t@tli1                        1a
     D  t@vhue                        2a
     D  t@cusn                        2a
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a
     D  t@mweb                        1a
     D  t@user                       10a
     D  t@date                        8p 0
     D  t@time                        6p 0

     D set429_t        ds                  qualified template
     D  t@empr                        1a
     D  t@sucu                        2a
     D  t@cdcs                        2p 0
     D  t@ddcs                       25a
     D  t@user                       10a
     D  t@date                        6p 0
     D  t@time                        6p 0

     D dsset120_t      ds                  qualified template
     D  t@ncoc                        5p 0
     D  t@nadf                        7p 0
     D  t@nacc                        5a
     D  t@nrcm                       11p 0
     D  t@coma                        2a
     D  t@nrma                        7p 0
     D  t@esma                        1p 0
     D  t@empr                        1a
     D  t@sucu                        2a
     D  T@ciap                        1a
     D  t@cibr                        3p 0
     D  t@ciga                        3p 0
     D  t@cot1                        3p 0
     D  t@cot2                        3p 0
     D  t@m001                        1a
     D  t@m002                        1a
     D  t@m003                        1a
     D  t@m004                        1a
     D  t@m005                        1a
     D  t@civa                        2p 0
     D  t@pgal                       10a
     D  t@ndal                       12a
     D  t@nsal                       12a
     D  t@pga2                       10a
     D  t@nda2                       12a
     D  t@nsa2                       12a
     D  t@nom3                        3a
     D  t@ope1                        7p 0
     D  t@ope2                        7p 0
     D  t@nier                        4p 0
     D  t@clea                        1a

     D dscntcge_t      ds                  qualified template
     D  cgempr                        1a
     D  cgsucu                        2a
     D  cgnrcm                       11p 0
     D  cgdvcm                        1a
     D  cgncmc                       30a
     D  cgticm                        1p 0
     D  cgindi                        2a
     D  cgmind                        1a
     D  cglmat                        1a
     D  cgasma                        3a
     D  cgbloq                        1a
     D  cgcbss                       11p 0
     D  cgabcv                        1a
     D  cgafhc                       13p 0
     D  cguser                       10a
     D  cgcrfi                        1a

     D dsgntmon_t      ds                  qualified template
     D  mocomo                        2a
     D  monmol                       30a
     D  monmoc                        5a
     D  momoeq                        2a
     D  mocdco                        2p 0
     D  motimo                        2a
     D  mobloq                        1a
     D  momon0                        1a
     D  momon1                        1a
     D  momon2                        1a
     D  momon3                        1a
     D  momon4                        1a
     D  momon5                        1a
     D  momon6                        1a
     D  momon7                        1a
     D  momon8                        1a
     D  momon9                        1a
     D  mocomn                        2p 0
     D  momssn                        1a
     D  momweb                        1a
     D  mouser                       10a
     D  modate                        8p 0
     D  motime                        6p 0

     D dsset407_t      ds                  qualified template
     D  t@hecg                        1a
     D  t@hecd                       50a
     D  t@user                       10a
     D  t@date                        8p 0
     D  t@time                        6p 0

     D dsset409_t      ds                  qualified template
     D  t@xcob                        3p 0
     D  t@cobd                       20a
     D  t@user                       10a
     D  t@date                        8p 0
     D  t@time                        6p 0

     D dsset412_t      ds                  qualified template
     D  t@cobl                        2a
     D  t@xcob                        3p 0
     D  t@hecg                        1a
     D  t@user                       10a
     D  t@date                        8p 0
     D  t@time                        6p 0

     D dsgntdim_t      ds                  qualified template
     D  ditiic                        3a
     D  ditiid                       30a
     D  dibloq                        1a
     D  dimar1                        1a
     D  dimar2                        1a
     D  dimar3                        1a
     D  dimar4                        1a
     D  dimar5                        1a
     D  ditii1                        3a
     D  dipath                      100a
     D  dicreg                        3p 0

     D dsprovee_t      ds                  qualified template
     D  pvempr                        1a
     D  pvsucu                        2a
     D  pvcoma                        2a
     D  pvnrma                        6p 0
     D  pvcuit                       11a
     D  pvcrcr                        7p 0
     D  pvnomb                       50a
     D  pvtipo                        3a

     D domiprov_t      ds                  qualified template
     D  pvdomi                       35a
     D  pvcopo                        5s 0
     D  pvcops                        1s 0
     D  pvloca                       25a
     D  pvprod                       20a

     D ctcprov_t       ds                  qualified template
     D  pvtele                       50a
     D  pvemai                      150a
     D  pvhora                       50a
     D  pvnomb                       50a

     D dscntnap_t      ds                  qualified template
     D  nanres                        7p 0
     D  namonb                       50a
     D  nadomi                       50a
     D  nacopo                        5p 0
     D  nacops                        1p 0
     D  nantel                       50a
     D  nacont                       50a
     D  namail                      150a
     D  namarc                       40a
     D  naaten                       40a
     D  namar1                        1a
     D  namar2                        1a
     D  namar3                        1a
     D  namar4                        1a
     D  namar5                        1a
     D  namar6                        1a
     D  namar7                        1a
     D  namar8                        1a
     D  namar9                        1a
     D  namar0                        1a
     D  nauser                       10a
     D  nadate                        8p 0
     D  natime                        6p 0
     D  nacoma                        2a
     D  nanrma                        7s 0

     D dsgntpro_t      ds                  qualified template
     D  prproc                        3a
     D  prprod                       20a
     D  prrpro                        2p 0
     D  prexii                        1p 0
     D  prrpr1                        2p 0
     D  prmar1                        1a
     D  prmar2                        1a
     D  prmar3                        1a
     D  prmar4                        1a
     D  prmar5                        1a
     D  prrpr2                        2p 0
     D  prcpsn                        2p 0
     D  prrpr3                        2p 0
     D  prmar6                        1a
     D  prmar7                        1a
     D  prmar8                        1a
     D  prmar9                        1a
     D  prmar0                        1a

     D dscntcau_t      ds                  qualified template
     D  caempr                        1a
     D  cacoma                        2a
     D  cancal                       30a
     D  cancac                        5a
     D  caanal                        1s 0
     D  cadepu                        1s 0
     D  caesti                        1a
     D  caeres                        1a
     D  canlct                        1a
     D  camodi                        1a
     D  cabloq                        1a
     D  camar1                        1a
     D  camar2                        1a
     D  camar3                        1a
     D  camar4                        1a
     D  camar5                        1a
     D  camar6                        1a
     D  camar7                        1a
     D  camar8                        1a
     D  camar9                        1a
     D  caivcv                        2p 0
     D  campte                        1a
     D  camsca                        1a
     D  cacate                        2p 0
     D  camchr                        1a
     D  cama01                        1a
     D  cama02                        1a
     D  cama03                        1a
     D  cama04                        1a
     D  cama05                        1a
     D  cama06                        1a
     D  cama07                        1a
     D  cama08                        1a
     D  cama09                        1a
     D  cama10                        1a

     D dsgntloc_t      ds                  qualified template
     D  locopo                        5p 0
     D  locops                        1p 0
     D  loloca                       25a
     D  loproc                        3a
     D  loteld                        5a
     D  loscta                        1p 0
     D  lozrrv                        1p 0
     D  lomar1                        1a
     D  lomar2                        1a
     D  lomar3                        1a
     D  lomar4                        1a
     D  lomar5                        1a
     D  lomweb                        1a
     D  louser                       10a
     D  lodate                        8p 0
     D  lotime                        6p 0

     D dsgntlo1_t      ds                  qualified template
     D  l1Copo                        5p 0
     D  l1Cops                        1p 0
     D  l1Psec                        5p 0
     D  l1Malo                       25
     D  l1Nrd1                        5p 0
     D  l1Nrd2                        5p 0
     D

     D set442_t        ds                  qualified template
     D  t@empr                        1a
     D  t@sucu                        2a
     D  t@ctco                        2p 0
     D  t@ctcd                       25a
     D  t@user                       10a
     D  t@date                        6p 0
     D  t@time                        6p 0

     D set443_t        ds                  qualified template
     D  t@empr                        1a
     D  t@sucu                        2a
     D  t@clug                        2p 0
     D  t@dlug                       25a
     D  t@user                       10a
     D  t@date                        6p 0
     D  t@time                        6p 0

     D dsSet4021_t     ds                  qualified template
     D  t@empr                        1a
     D  t@sucu                        2a
     D  t@rama                        2p 0
     D  t@cesi                        2p 0
     D  t@desi                       30a
     D  t@cese                        2a
     D  t@user                       10a
     D  t@time                        6p 0
     D  t@date                        6p 0

     D dsGnttbe_t      ds                  qualified template
     D  g1Empr                        1a
     D  g1sucu                        2a
     D  g1Tben                        1a
     D  g1Dben                       40a
     D  g1Dia1                        3p 0
     D  g1Dia2                        3p 0
     D  g1Dia3                        3p 0
     D  g1Mar1                        1a
     D  g1Mar2                        1a
     D  g1Mar3                        1a
     D  g1Mar4                        1a
     D  g1Mar5                        1a
     D  g1User                       10a
     D  g1Date                        6p 0
     D  g1Time                        6p 0

     D dsSet426_t      ds                  qualified template
     D  t@rama                        2p 0
     D  t@tire                        2p 0
     D  t@cotx                        2a
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a
     D  t@dire                       40a

     D dsSet124_t      ds                  qualified template
     D  t@rama                        2p 0
     D  t@tpcd                        2a
     D  t@tpnl                        3p 0
     D  t@tpds                       79a
     D  t@mipp                        1a
     D  t@fvmp                        8p 0

     D dsGntTfc_t      ds                  qualified template
     D  gntifa                        2p 0
     D  gndifa                       25a
     D  gndeha                        1a
     D  gntife                        2p 0

     * ------------------------------------------------------------ *
     * SVPTAB_inz(): Inicializa módulo.                             *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPTAB_inz      pr

     * ------------------------------------------------------------ *
     * SVPTAB_End(): Finaliza módulo.                               *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPTAB_End      pr

     * ------------------------------------------------------------ *
     * SVPTAB_Error(): Retorna el último error del service program  *
     *                                                              *
     *     peEnbr   (output)  Número de error (opcional)            *
     *                                                              *
     * Retorna: Mensaje de error.                                   *
     * ------------------------------------------------------------ *

     D SVPTAB_Error    pr            80a
     D   peEnbr                      10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------- *
      * SVPTAB_getCuestionarios(): Retorna Cuestionario               *
      *                                                               *
      *     peDsCu   ( output ) Estructura de cuestionario            *
      *     peDsCuC  ( output ) cantidad de cuestionario              *
      *     peTaaj   ( input  ) codigo de cuestionario    ( opcional )*
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getCuestionarios...
     D                 pr
     D   peDsCu                            likeds( set2370_t ) dim( 99 )
     D   peDsCuc                     10i 0
     D   peTaaj                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------- *
      * SVPTAB_getPreguntas(): Retorna Cuestionario                   *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peDsPr   ( output ) Estructura de pregunta                *
      *     peDsPrC  ( output ) cantidad de preguntas                 *
      *     peCosg   ( input  ) codigo de pregunta     ( opcional )   *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getPreguntas...
     D                 pr
     D   peTaaj                       2  0 const
     D   peDsPr                            likeds( set2371_t ) dim( 200 )
     D   peDsPrc                     10i 0
     D   peCosg                       4    options( *nopass : *omit )

      * ------------------------------------------------------------- *
      * SVPTAB_getCuestionario(): Retorna Cuestionario                *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peDsCu   ( output ) Estructura de cuestionario            *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getCuestionario...
     D                 pr              n
     D   peTaaj                       2  0 const
     D   peDsCu                            likeds( set2370_t )

      * ------------------------------------------------------------- *
      * SVPTAB_getPregunta(): Retorna Pregunta                        *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peCosg   ( input  ) codigo de pregunta                    *
      *     peDsPr   ( output ) Estructura de pregunta                *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getPregunta...
     D                 pr              n
     D   peTaaj                       2  0 const
     D   peCosg                       4    const
     D   peDsPr                            likeds( set2371_t )

      * ------------------------------------------------------------- *
      * SVPTAB_chkCuestionario(): Retorna Cuestionario                *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_chkCuestionario...
     D                 pr              n
     D   peTaaj                       2  0 const

      * ------------------------------------------------------------- *
      * SVPTAB_getPreguntaExcluyente(): Retorna Código Excluyente por *
      *                                 pregunta                      *
      *                                                               *
      *     peTaaj   ( input  ) Código de Cuestionario                *
      *     peCosg   ( input  ) Código de Pregunta                    *
      *                                                               *
      * Retorna: Código Excluyente / *blanks                          *
      * ------------------------------------------------------------- *
     D SVPTAB_getPreguntaExcluyente...
     D                 pr             4
     D   peTaaj                       2  0 const
     D   peCosg                       4    const

      * ------------------------------------------------------------- *
      * SVPTAB_getItemsExcluyentes(): Retorna Items Excluyentes.      *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peCoex   ( output ) Vector de Código de Exclusión         *
      *     peCosg   ( output ) Vector de Código de Pregunta          *
      *                                                               *
      * ------------------------------------------------------------- *
     D SVPTAB_getItemsExcluyentes...
     D                 pr
     D   peTaaj                       2  0 const
     D   peCoex                       4    dim(200)
     D   peCosg                       4    dim(200)

      * ------------------------------------------------------------- *
      * SVPTAB_getItemsObligatorio(): Retorna Items Obligatorio       *
      *                                                               *
      *     peTaaj   ( input  ) Código de Cuestionario                *
      *     peCosg   ( output ) Vector de Código de Pregunta          *
      *                                                               *
      * ------------------------------------------------------------- *
     D SVPTAB_getItemsObligatorio...
     D                 pr
     D   peTaaj                       2  0 const
     D   peCosg                       4    dim(200)

      * ------------------------------------------------------------ *
      * SVPTAB_cotizaMoneda(): Retorna cotización de la moneda.      *
      *                                                              *
      *     peComo ( input  ) Código de Moneda                       *
      *     peFcot ( input  ) Fecha de Cotización (aaaammdd)         *
      * Retorna : Cotizacion de Moneda / 0 = no tiene                *
      * ------------------------------------------------------------ *
     D SVPTAB_cotizaMoneda...
     D                 pr            15  6
     D   peComo                       2      const
     D   peFcot                       8  0   const

      * ------------------------------------------------------------- *
      * SVPTAB_getTipoMascotas(): Retorna Tipo de Mascotas            *
      *                                                               *
      *     peDstm   ( output ) Estructura de Tipo de Mascotas        *
      *     peDstmC  ( output ) Cantidad de Tipo de Mascotas          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getTipoMascotas...
     D                 pr
     D   peDsTm                            likeds( dsSet136_t ) dim(99)
     D   peDsTmC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_getRazaMascotas(): Retorna Raza de Mascotas            *
      *                                                               *
      *     peDsRm   ( output ) Estructura de Raza de Mascotas        *
      *     peDsRmC  ( output ) Cantidad de Raza de Mascotas          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getRazaMascotas...
     D                 pr
     D   peDsRm                            likeds( dsSet137_t ) dim(9999)
     D   peDsRmC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_getRelaMascotas(): Retorna Relación Tipo de Mascota y  *
      *                           Raza de Mascota                     *
      *                                                               *
      *     peCtma   ( input  ) Código Tipo de Mascotas
      *     peDsRm   ( output ) Estructura de Relación de Mascota     *
      *     peDsRmC  ( output ) Cantidad de Relación de Mascota       *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getRelaMascotas...
     D                 pr              n
     D   peCtma                       2  0 const
     D   peDsRm                            likeds( dsSet138_t ) dim(9999)
     D   peDsRmC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_getTipoMascotasWeb(): Retorna Tipo de Mascotas         *
      *                              habilitado en la WEB             *
      *                                                               *
      *     peDstm   ( output ) Estructura de Tipo de Mascotas        *
      *     peDstmC  ( output ) Cantidad de Tipo de Mascotas          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getTipoMascotasWeb...
     D                 pr
     D   peDsTm                            likeds( dsSet136_t ) dim(99)
     D   peDsTmC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_getRelaMascotasWeb(): Retorna Relación Tipo de Mascota *
      *                              y Raza de Mascota habilitado en  *
      *                              la WEB                           *
      *                                                               *
      *     peCtma   ( input  ) Código Tipo de Mascotas               *
      *     peDsRm   ( output ) Estructura de Relación de Mascota     *
      *     peDsRmC  ( output ) Cantidad de Relación de Mascota       *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getRelaMascotasWeb...
     D                 pr              n
     D   peCtma                       2  0 const
     D   peDsRm                            likeds( dsSet138_t ) dim(9999)
     D   peDsRmC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_getParentescoVida():  Retorna tabla de parentescos     *
      *                                                               *
      *     peDsRm   ( output ) Estructura de Parentescos             *
      *     peDsRmC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getParentescoVida...
     D                 pr              n
     D   peT069                            likeds(set069_t) dim(999)
     D   peT069C                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_getFormasDePago(): Retorna lista con todas las formas  *
      *                           de pago                             *
      *                                                               *
      *     peTipo   ( input  ) Tipo de forma de pago                 *
      *     peDsFpg  ( output ) Estructura de Tipo de formas de pago  *
      *     peDsFpgC ( output ) Cantidad                              *
      *     peCfpg   ( input  ) Código de Forma de pago               *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getFormasDePago...
     D                 pr              n
     D   peTipo                       1    const
     D   peDsFpg                           likeds( dsGntfpg_t ) dim(99)
     D   peDsFpgC                    10i 0
     D   peCfpg                       1  0 const options(*nopass:*omit)

      * ------------------------------------------------------------- *
      * SVPTAB_getCombinacionFormaDePago(): Retorna combianciones de  *
      *                                     formas de pagos por       *
      *                                     articulo                  *
      *     peArcd   ( input  ) Codigo de Articulo                    *
      *     peCfpg   ( input  ) Tipo de forma de pago                 *
      *     peCfp1   ( input  ) Relacion de forma de pago             *
      *     peDsCf   ( output ) Estructura de Combinaciones           *
      *     peDsCfC  ( output ) Cantidad de Combinaciones             *
      *     peTipo   ( input  ) Tipo de Solicitud                     *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getCombinacionFormaDePago...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const options(*nopass:*omit)
     D   peCfp1                       1  0 const options(*nopass:*omit)
     D   peDsCf                            likeds( dsSet919_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsCfC                     10i 0 options(*nopass:*omit)
     D   peTipo                       1    options(*nopass:*omit)

     ?* ------------------------------------------------------------ *
     ?* SVPTAB_getResBcoXCodCobW: Retorna Datos de Resolución de     *
     ?*                           Banco por Código de Cobranza WEB   *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peIvbc   ( input  ) Código del Banco                     *
     ?*     peIvsu   ( input  ) Sucursal del Banco        (opcional) *
     ?*     peComa   ( input  ) Código de Mayor Auxiliar  (opcional) *
     ?*     peNrma   ( input  ) Número de Mayor Auxiliar  (opcional) *
     ?*     peDsBa   ( output ) Estruct. Resolución Bco.  (opcional) *
     ?*     peDsBaC  ( output ) Cant. Reg. Resolución Bco.(opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     D SVPTAB_getResBcoXCodCobW...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 options( *nopass : *omit )const
     D   peComa                       2    options( *nopass : *omit )const
     D   peNrma                       7  0 options( *nopass : *omit )const
     D   peDsBa                            likeds ( dsCntrba_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsBaC                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------- *
      * SVPTAB_getCntcfp(): Retorna datos de Forma de Pago.           *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peIvcv   ( input  ) Código del valor                      *
      *     peDsFp   ( output ) Estructura de Cntcfp                  *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getCntcfp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvcv                       2  0 const
     D   peDsFp                            likeds( dsCntcfp_t )

      * ------------------------------------------------------------- *
      * SVPTAB_getCntnau(): Retorna datos de Mayor Auxiliar.          *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar              *
      *     peNrma   ( input  ) Número de Mayor Auxiliar              *
      *     peDsNa   ( output ) Estructura de Cntnau                  *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getCntnau...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peDsNa                            likeds( dsCntnau_t )

      * ------------------------------------------------------------ *
      * SVPTAB_chkAgente(): Chequea si existe Agente en el archivo   *
      *                     SEHINT.-                                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peInta   (input)   Tipo de Agente                        *
      *     peInna   (input)   Nro de Agente                         *
      *                                                              *
      * Retorna: *on Encontro / *off No encontro                     *
      * ------------------------------------------------------------ *
     D SVPTAB_chkAgente...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peInta                       1  0 const
     D   peInna                       5  0 const

      * ------------------------------------------------------------- *
      * SVPTAB_chkCntcfp02(): chequea datos de Forma de Pago.         *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peMar1   ( input  ) Código Equivalente                    *
      *     peIvcv   ( input  ) Código del valor                      *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_chkCntcfp02...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peMar1                       1    const
     D   peIvcv                       2  0 const

     ?* ------------------------------------------------------------ *
     ?* SVPTAB_getTipoDePersona(): Retorna datos de Tipo de Persona  *
     ?*                                                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peTipe   ( input  ) Código Tipo de Persona    (opcional) *
     ?*     peDs02   ( output ) Estruct. set6202          (opcional) *
     ?*     peDs02C  ( output ) Cant. Reg. set6202        (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     D SVPTAB_getTipoDePersona...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peTipe                       1    options( *nopass : *omit )const
     D   peDs02                            likeds ( set6202_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDs02C                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_getPremioProd(): Retorna premio del archivo set100    *
      *                                                              *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Producto                              *
      *     peMone   (input)   Moneda                                *
      *                                                              *
      * Retorna: t@prem                                              *
      * ------------------------------------------------------------ *
     D SVPTAB_getPremioProd...
     D                 pr            15  2
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peMone                       2    const

      * ------------------------------------------------------------- *
      * SVPTAB_getRequiereAPRC(): Retorna si la Rama y el Producto    *
      *                           requiere AP y RC                    *
      *                                                               *
      *     peRama   ( input  ) Rama                                  *
      *     peXpro   ( input  ) Producto                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getRequiereAPRC...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peReAP                       1
     D   peReRC                       1

      * ------------------------------------------------------------- *
      * SVPTAB_getProvincia(): Retorna provincia                      *
      *                                                               *
      *     peRpro   ( input  ) Provincia Index                       *
      *                                                               *
      * Retorna: PRPROC                                               *
      * ------------------------------------------------------------- *
     D SVPTAB_getProvincia...
     D                 pr             3
     D   peRpro                       2  0 const

      * ------------------------------------------------------------ *
      * SVPTAB_getSet001() : Obtiene SET001                          *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peDs001  (output)  Estructura SET001                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPTAB_getSet001...
     D                 pr              n
     D   peRama                       2  0 const
     D   peDs001                           likeds ( DsSET001_t )

      * ------------------------------------------------------------ *
      * SVPTAB_getLugarPRISMA(): Retorna Datos de Lugar (PRISMA).    *
      *                                                              *
      *     peDsLp   ( output ) Estruct. set405                      *
      *     peDsLpC  ( output ) Cant. Reg. set405                    *
      *     peClos   ( input  ) Cód. Lugar de Ocurrencia Stro. (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_getLugarPRISMA...
     D                 pr              n
     D   peDsLp                            likeds ( set405_t ) dim( 99 )
     D   peDsLpC                     10i 0
     D   peClos                       2    options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_getCausas(): Retorna Datos de Causas.                 *
      *                                                              *
      *     peDs01   ( output ) Estruct. set401                      *
      *     peDs01C  ( output ) Cant. Reg. set401                    *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peCauc   ( input  ) Codigo de Causa       (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_getCausas...
     D                 pr              n
     D   peDs01                            likeds ( set401_t ) dim( 9999 )
     D   peDs01C                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peCauc                       4  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_getEstados(): Retorna Datos del estado de Siniestro   *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peDs02   ( output ) Estruct. set402                      *
      *     peDs02C  ( output ) Cant. Reg. set402                    *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peCesi   ( input  ) Codigo de Siniestro   (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_getEstados...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs02                            likeds ( set402_t ) dim( 9999 )
     D   peDs02C                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peCesi                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_getEstadoTiempo(): Retorna Datos de estado del tiempo *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs45   ( output ) Estruct. set445                      *
      *     peDs45C  ( output ) Cant. Reg. set445                    *
      *     peCdes   ( input  ) Cód. Estado del Tiempo.        (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_getEstadoTiempo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs45                            likeds ( set445_t ) dim( 99 )
     D   peDs45C                     10i 0
     D   peCdes                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_getRelacionAseg(): Retorna Datos de relacion con      *
      *                           asegurado.                         *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs44   ( output ) Estruct. set444                      *
      *     peDs44C  ( output ) Cant. Reg. set444                    *
      *     peRela   ( input  ) Cód. relacion                  (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_getRelacionAseg...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs44                            likeds ( set444_t ) dim( 99 )
     D   peDs44C                     10i 0
     D   peRela                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------- *
      * SVPTAB_ListaRamas(): Retorna Todas las Ramas                  *
      *                                                               *
      *     peDsRa   ( output ) Estructura de Ramas                   *
      *     peDsRaC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaRamas...
     D                 pr              n
     D   peRama                            likeds(DsSET001_t) dim(99)
     D   peRamaC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaSexos(): Retorna Todos los Sexos                  *
      *                                                               *
      *     peDsSe   ( output ) Estructura de Sexos                   *
      *     peDsSeC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaSexos...
     D                 pr              n
     D   peDsSe                            likeds(DsGNTSEX_t) dim(99)
     D   peDsSeC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaEstadoCivil : Retorna Todos los Estados Civiles   *
      *                                                               *
      *     peDsEs   ( output ) Estructura de Estado Civil            *
      *     peDsEsC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaEstadoCivil...
     D                 pr              n
     D   peDsEs                            likeds(DsGNTESC_t) dim(99)
     D   peDsEsC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaPaises : Retorna Todos los Paises.                *
      *                                                               *
      *     peDsPa   ( output ) Estructura de Paises                  *
      *     peDsPaC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaPaises...
     D                 pr              n
     D   peDsPa                            likeds(DsGNTPAI_t) dim(999)
     D   peDsPaC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaVehiculos :  Retorna Todos los Vehículos.         *
      *                                                               *
      *     peDsVe   ( output ) Estructura de Vehículos               *
      *     peDsVeC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaVehiculos...
     D                 pr              n
     D   peDsVe                            likeds(DsSet280_t) dim(99999)
     D   peDsVeC                     10i 0
     D   peVhan                       4  0 const options( *nopass : *omit )
     D   peCmar                       9  0 const options( *nopass : *omit )
     D   peCgru                       3  0 const options( *nopass : *omit )

      * ------------------------------------------------------------- *
      * SVPTAB_ListaCarrocerias :  Retorna todas las Carrocerias.     *
      *                                                               *
      *     peDsCa   ( output ) Estructura de Carrocerias.            *
      *     peDsCaC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaCarrocerias...
     D                 pr              n
     D   peDsCa                            likeds(DsSet205_t) dim(99)
     D   peDsCaC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaTipoDeVehiculos :  Retorna todos los tipos de     *
      *                                Vehículos.                     *
      *                                                               *
      *     peDsTv   ( output ) Estructura de Tipos de Vehículos      *
      *     peDsTvC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaTipoDeVehiculos...
     D                 pr              n
     D   peDsTv                            likeds(DsSet210_t) dim(99)
     D   peDsTvC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaUsos : Retorna todos los Usos de Vehículos        *
      *                                                               *
      *     peDsUv   ( output ) Estructura de Usos de Vehículos       *
      *     peDsUvC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaUsos...
     D                 pr              n
     D   peDsUv                            likeds(DsSet211_t) dim(99)
     D   peDsUvC                     10i 0

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoAccidente() Retorna datos de tipo de         *
      *                             Accidente.                       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs29   ( output ) Estruct. set429                      *
      *     peDs29C  ( output ) Cant. Reg. set429                    *
      *     peCdcs   ( input  ) Cód. Tipo de Accidente         (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_listaTipoAccidente...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs29                            likeds ( set429_t ) dim( 99 )
     D   peDs29C                     10i 0
     D   peCdcs                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------- *
      * SVPTAB_ListaCompanias :  Retorna Compañias Coaseguradoras     *
      *                                                               *
      *     peDsCm   ( output ) Estructura de Compañias Coaseguradoras*
      *     peDsCmC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaCompanias...
     D                 pr              n
     D   peDsCm                            likeds(dsSet120_t) dim(999)
     D   peDsCmC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaMonedas : Retorna Monedas                         *
      *                                                               *
      *     peDsMo   ( output ) Estructura de Monedas                 *
      *     peDsMoC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaMonedas...
     D                 pr              n
     D   peDsMo                            likeds(dsgntmon_t) dim(99)
     D   peDsMoC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaCuentasContables : Lista Cuentas Contables        *
      *                                                               *
      *     peDsCg   ( output ) Estructura de Cuentas Contables       *
      *     peDsCgC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaCuentasContables...
     D                 pr              n
     D   peDsCg                            likeds(dscntcge_t) dim(99999)
     D   peDsCgC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaImpuesetos : Lista de Impuestos                   *
      *                                                               *
      *     peDsDm   ( output ) Estructura de Impuestos               *
      *     peDsDmC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaImpuestos...
     D                 pr              n
     D   peDsDm                            likeds(dsgntdim_t) dim(99)
     D   peDsDmC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaCoberturas : Lista de Coberturas                  *
      *                                                               *
      *     peDsCo   ( output ) Estructura de Coberturas              *
      *     peDsCoC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaCoberturas...
     D                 pr              n
     D   peDsCo                            likeds(dsset409_t) dim(99)
     D   peDsCoC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_ListaHechosGeneradores :  Lista de Hechos Generadores  *
      *                                                               *
      *     peDsHg   ( output ) Estructura de Hechos Generadores      *
      *     peDsHgC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_ListaHechosGeneradores...
     D                 pr              n
     D   peDsHg                            likeds(dsset407_t) dim(99)
     D   peDsHgC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_relacionCoberturaYHechoGen : Relacion entre Coberturas *
      *                                   y Hechos Generadores        *
      *     peDsHg   ( output ) Estructura de Relación                *
      *     peDsHgC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_relacionCoberturaYHechoGen...
     D                 pr              n
     D   peDsCh                            likeds(dsset412_t) dim(999)
     D   peDsChC                     10i 0
     D   peCobl                       2a   options(*nopass:*omit)

      * ------------------------------------------------------------- *
      * SVPTAB_listaProveedores : Lista Proveedores                   *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peTipo   ( input  ) Tipo de Proveedor                     *
      *     peDsPv   ( output ) Estructura de Relación                *
      *     peDsPvC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_listaProveedores...
     D                 pr              n
     D   peEmpr                       1a   Const
     D   peSucu                       2a   Const
     D   peTipo                       3a   Const
     D   peDsPv                            likeds(dsprovee_t) dim(50000)
     D   peDsDm                            likeds(domiprov_t) dim(50000)
     D   peDsDc                            likeds(ctcprov_t) dim(50000)
     D   peDsPvC                     10i 0

      * ------------------------------------------------------------- *
      * SVPTAB_getCntnap : Recupero Proveedores de CNTNAP             *
      *                                                               *
      *     peDsNp   ( output ) Estructura de Relación                *
      *     peDsNpC  ( output ) Cantidad                              *
      *     pecoma   ( input  ) Código Mayor Auxiliar                 *
      *     peNrma   ( input  ) Número Mayor Auxiliar                 *
      *     peTipo   ( input  ) Tipo de Proveedor                     *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getCntnap...
     D                 pr              n
     D   peDsNp                            likeds(dscntnap_t) dim(9999)
     D   peDsNpC                     10i 0
     D   peComa                       2a   options(*nopass:*omit)
     D   peNrma                       7  0 options(*nopass:*omit)
     D   peTipo                       1a   options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPTAB_getGntpro() : Retorna Datos de Provincias             *
      *                                                              *
      *     peDsGp   ( output ) Estruct. GNTPRO                      *
      *     peDsGpC  ( output ) Cant. Reg. GNTPRO                    *
      *     peProc   ( input  ) Cód. de Provincia              (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_getGntpro...
     D                 pr              n
     D   peDsGp                            likeds ( dsgntpro_t ) dim( 99 )
     D   peDsGpC                     10i 0
     D   peProc                       3a   options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_getGntloc() : Retorna Datos de Localidades            *
      *                                                              *
      *     peDsLc   ( output ) Estruct. GNTLOC                      *
      *     peDsLcC  ( output ) Cant. Reg. GNTLOC                    *
      *     peCopo   ( input  ) Cód. Postal.                   (Opc) *
      *     peCops   ( input  ) Sufijo Cód. Postal.            (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     D SVPTAB_getGntloc...
     D                 pr              n
     D   peDsLc                            likeds ( dsgntloc_t ) dim(99999)
     D   peDsLcC                     10i 0
     D   peCopo                       5s 0 options( *nopass : *omit )
     D   peCops                       1s 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_chkSet001() : Chequea SET001                          *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPTAB_chkSet001...
     D                 pr              n
     D   peRama                       2  0 const

      * ------------------------------------------------------------- *
      * SVPTAB_getGntmon: Retorna registro completo Tabla de Moneda   *
      *                   Gntmon                                      *
      *                   Si recibe peComo da pioridad, si no recibe  *
      *                   verifica si tiene peMoeq obtiene y devuelve *
      *                   fila solicitada sino devuelve error.        *
      *                                                          DOT  *
      *     peComo   ( input  ) Codigo de Moneda     *omit            *
      *     peMoeq   ( input  ) Moneda equivalencia  *omit            *
      *     peDsMo   ( output ) Estructura de Monedas  *omit          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_getGntmon...
     D                 pr              n
     D   peDsMo                            likeds(dsgntmon_t)
     D   peComo                       2a   const options(*nopass:*omit)
     D   peMoeq                       2a   const options(*nopass:*omit)

      * ------------------------------------------------------------- *
     D SVPTAB_getGntlo1...
     D                 pr              n
     D   peDsL1                            likeds ( dsgntlo1_t ) dim(9999)
     D   peDsL1C                     10i 0
     D   peCopo                       5  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoColision(): Retorna datos de tipo de colision*
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs42   ( output ) Estruct. set442                      *
      *     peDs42C  ( output ) Cant. Reg. set442                    *
      *     peCtco   ( input  ) Cód. Tipo de Colision          (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_listaTipoColision...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs42                            likeds ( set442_t ) dim( 99 )
     D   peDs42C                     10i 0
     D   peCtco                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_listaLugarNoPRISMA(): Retorna datos de Lugar no PRISMA*
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs43   ( output ) Estruct. set443                      *
      *     peDs43C  ( output ) Cant. Reg. set443                    *
      *     peClug   ( input  ) Cód. de Lugar                  (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_listaLugarNoPRISMA...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs43                            likeds ( set443_t ) dim( 99 )
     D   peDs43C                     10i 0
     D   peClug                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoBeneficiario(): Retorna datos de tipo de     *
      *                                 beneficiario                 *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDsBe   ( output ) Estruct. gnttbe                      *
      *     peDsBeC  ( output ) Cant. Reg. gnttbe                    *
      *     peTben   ( input  ) Cód. Tipo de beneficiario      (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_listaTipoBeneficiario...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDsBe                            likeds ( dsGnttbe_t ) dim( 99 )
     D   peDsBeC                     10i 0
     D   peTben                       1    options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_listaEdoReclamo(): Retorna datos de estado de reclamo *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Surcusal                             *
      *     peDsEr   ( output ) Estruct. set4021                     *
      *     peDsErC  ( output ) Cant. Reg. set4021                   *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peCesi   ( input  ) Codigo de estado      (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_listaEdoReclamo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDsEr                            likeds( dsSet4021_t ) dim( 9999 )
     D   peDsErC                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peCesi                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoDeRecibo(): Retorna datos de tipo de recibo  *
      *                                                              *
      *     peDs26   ( output ) Estruct. set426                      *
      *     peDs26C  ( output ) Cant. Reg. set426                    *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peTire   ( input  ) Cod. Tipo de Recibo   (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_listaTipoDeRecibo...
     D                 pr              n
     D   peDs26                            likeds ( dsSet426_t ) dim( 9999 )
     D   peDs26C                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peTire                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_listaTextoPreseteado(): Retorna datos de texto prese- *
      *                                teado.                        *
      *                                                              *
      *     peDsTx   ( output ) Estruct. set124                      *
      *     peDsTxC  ( output ) Cant. Reg. set124                    *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peTpcd   ( input  ) Cod. Texto Preseteado (Opcional)     *
      *     peTpnl   ( input  ) Nro. Línea texto      (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_listaTextoPreseteado...
     D                 pr              n
     D   peDsTx                            likeds ( dsSet124_t ) dim( 99999 )
     D   peDsTxC                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peTpcd                       2    options( *nopass : *omit )
     D   peTpnl                       3  0 options( *nopass : *omit )

      * ------------------------------------------------------------- *
      * SVPTAB_chkSet426(): Valida si existe codigo de recibo.-       *
      *                                                               *
      *     peRama   (input)   Rama                                  *
      *     peTire   (input)   Tipo Recibo                           *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     D SVPTAB_chkSet426...
     D                 pr              n
     D   peRama                       2  0 const
     D   peTire                       2  0 const

      * ------------------------------------------------------------- *
      * SVPTAB_getNumeradorGenerico(): Retorna Numero segun Tipo.-    *
      *                                                               *
      *     peTnum   ( input ) Tipo de Numerador                      *
      *     peNres   ( output ) Numero                                *
      *                                                               *
      * Retorna: Nro. Recibo = Encuentra / -1 = No encuentra        *
      * ------------------------------------------------------------- *
     D SVPTAB_getNumeradorGenerico...
     D                 pr              n
     D   peTnum                       1    const
     D   peNres                       7  0

      * ------------------------------------------------------------ *
      * SVPTAB_listaFormasDePagos(): Retorna datos de Formas de Pagos*
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDsFp   ( output ) Estruct. cntcfp                      *
      *     peDsFpC  ( output ) Cant. Reg. cntcfp                    *
      *     peIvcv   ( input  ) Cód. Forma de Pago             (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPTAB_listaFormasDePagos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDsFp                            likeds ( dsCntcfp_t ) dim( 99 )
     D   peDsFpC                     10i 0
     D   peIvcv                       2  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPTAB_chkTipoProveedor(): Chequea si existe el tipo Prov.   *
      *                                                              *
      *     peTipp   ( input  ) Tipo de Proveedor                    *
      *     peTprv   ( input  ) Provee (opcional)                    *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     D SVPTAB_chkTipoProveedor...
     D                 pr              n
     D   peTipp                       3    const
     D   peTprv                       1    const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPTAB_getTiposComprobanteAfip(): Tipos de Comprobante AFIP. *
      *                                                              *
      *     peTtfc   ( output ) Registro de GNTTFC                   *
      *     peTtfcC  ( output ) Cantidad de registros                *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPTAB_getTiposComprobanteAfip...
     D                 pr
     D   peTtfc                            likeds(dsGntTfc_t) dim(999)
     D   peTtfcC                     10i 0

