      /if defined(SVPSIN_H)
      /eof
      /endif
      /define SVPSIN_H

      /copy INF1DAVI/qcpybooks,sinest_h
      ////copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

      * Siniestro Inexistente...
     D SVPSIN_SINNE    c                   const(0011)
      * Beneficiario no Existe en Siniestro...
     D SVPSIN_BENES    c                   const(0012)
      * Beneficiario en Varias Coberturas...
     D SVPSIN_BEMCO    c                   const(0013)
      * Siniestro Terminado...
     D SVPSIN_SINTE    c                   const(0014)
      * Reclamo Inexistente...
     D SVPSIN_RECIN    c                   const(0015)
      * Hecho Generador Inexistente...
     D SVPSIN_HECIN    c                   const(0016)
      * Beneficiario en Juicio...
     D SVPSIN_BEJUI    c                   const(0017)
      * Se debe Informar Parentesco...
     D SVPSIN_PAREN    c                   const(0018)
      * Poliza con Siniestros...
     D SVPSIN_GETSI    c                   const(0019)
      * Rama Inexistente...
     D SVPSIN_RAMAI    c                   const(0020)
      * Poliza con Siniestro...
     D SVPSIN_POLSI    c                   const(0021)
      * Siniestro ya esta Terminado...
     D SVPSIN_NOTER    c                   const(0022)
      * Reclamo ya esta Terminado...
     D SVPSIN_RECTE    c                   const(0023)
      * Carátula no encontrada...
     D SVPSIN_CARNE    c                   const(0024)
      * SET402 no encontrado...
     D SVPSIN_402NE    c                   const(0025)
      * SET456 no encontrado...
     D SVPSIN_456NE    c                   const(0026)
      * Siniestro no modificable...
     D SVPSIN_SINNM    c                   const(0027)
      * Orden de Pago: Aprobaciones Inexistente...
     D SVPSIN_OPANE    c                   const(0028)
      * Percepciones s/Pagos-Ingresos Bruto Inexistente...
     D SVPSIN_PIINE    c                   const(0029)
      * Detalle Retencion Existente...
     D SVPSIN_DTREE    c                   const(0030)
      * Detalle Retencion Inexistente...
     D SVPSIN_DTREI    c                   const(0031)
      * Orden Pago Deveng. Inexistente...
     D SVPSIN_OPDNE    c                   const(0032)
      * Speedway Siniestro Factura Inexistente...
     D SVPSIN_SSFNE    c                   const(0033)
      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPSIN_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * --------------------------------------------------- *
      * Estrucutura de datos Pahshp01
      * --------------------------------------------------- *
     D DsPahshp01_t    ds                  qualified template
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
      * Estrucutura de datos Pahscd
      * --------------------------------------------------- *
     D DsPahscd_t      ds                  qualified template
     D  cdempr                        1
     D  cdsucu                        2
     D  cdrama                        2p 0
     D  cdsini                        7p 0
     D  cdnops                        7p 0
     D  cdnsag                        6p 0
     D  cdejco                        4p 0
     D  cdarcd                        6p 0
     D  cdspol                        9p 0
     D  cdsspo                        3p 0
     D  cdrame                        2p 0
     D  cdarse                        2p 0
     D  cdoper                        7p 0
     D  cdsuop                        3p 0
     D  cdmonr                        2
     D  cdmoeq                        2
     D  cdpoli                        7p 0
     D  cdcert                        9p 0
     D  cdendo                        7p 0
     D  cdotom                        7p 0
     D  cdasen                        7p 0
     D  cdsocn                        7p 0
     D  cdfsia                        4p 0
     D  cdfsim                        2p 0
     D  cdfsid                        2p 0
     D  cdfdea                        4p 0
     D  cdfdem                        2p 0
     D  cdfded                        2p 0
     D  cdcesi                        2p 0
     D  cdcese                        2
     D  cdterm                        1
     D  cdjuin                        6p 0
     D  cdcauc                        4p 0
     D  cdhsin                        4p 0
     D  cdcopo                        5p 0
     D  cdcops                        1p 0
     D  cdproc                        3
     D  cdrpro                        2p 0
     D  cdclos                        2
     D  cdnrdf                        7p 0
     D  cdncon                       40
     D  cdnrcv                        8p 0
     D  cdfrva                        4p 0
     D  cdfrvm                        2p 0
     D  cdfrvd                        2p 0
     D  cdrcop                       25
     D  cdcrcv                        4
     D  cdctco                        2
     D  cdedad                        2p 0
     D  cdsexo                        1p 0
     D  cdcgen                        1
     D  cdcesc                        1p 0
     D  cdtalc                        2
     D  cdcjrs                        2
     D  cdvhts                        2
     D  cdctle                        2
     D  cdludi                       55
     D  cdmar1                        1
     D  cdmar2                        1
     D  cdmar3                        1
     D  cdmar4                        1
     D  cdmar5                        1
     D  cduser                       10
     D  cdtime                        6p 0
     D  cdfera                        4p 0
     D  cdferm                        2p 0
     D  cdferd                        2p 0
     D  cdmp06                        1
     D  cdmp07                        1
     D  cdmp08                        1
     D  cdmp09                        1
     D  cdmp10                        1
     D  cdmp11                        1
     D  cdmp12                        1
     D  cdmp13                        1
     D  cdmp14                        1
     D  cdmp15                        1
     D  cdmp16                        1
     D  cdmp17                        1
     D  cdmp18                        1
     D  cdmp19                        1
     D  cdfnoa                        4p 0
     D  cdfnom                        2p 0
     D  cdfnod                        2p 0
     D  cdnhec                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsbe
      * --------------------------------------------------- *
     D DsPahsbe_t      ds                  qualified template
     D  beempr                        1
     D  besucu                        2
     D  berama                        2p 0
     D  besini                        7p 0
     D  benops                        7p 0
     D  bepoco                        6p 0
     D  bepaco                        3p 0
     D  beriec                        3
     D  bexcob                        3p 0
     D  benrdf                        7p 0
     D  besebe                        6p 0
     D  betido                        2p 0
     D  benrdo                        8p 0
     D  benomb                       40
     D  becuit                       11
     D  becuil                       11p 0
     D  benupe                        8p 0
     D  benroc                        7p 0
     D  becoma                        2
     D  benrma                        7p 0
     D  beesma                        1p 0
     D  bearcd                        6p 0
     D  bespol                        9p 0
     D  besspo                        3p 0
     D  bearse                        2p 0
     D  beoper                        7p 0
     D  besuop                        3p 0
     D  becert                        9p 0
     D  bepoli                        7p 0
     D  bepart                        5p 2
     D  bejuin                        6p 0
     D  beagec                        3p 0
     D  bemonr                        2
     D  beimmr                       15p 2
     D  bemoeq                        2
     D  beimco                       15p 6
     D  beimau                       15p 2
     D  bemar1                        1
     D  bemar2                        1
     D  bemar3                        1
     D  bemar4                        1
     D  bemar5                        1
     D  bestrg                        1
     D  beuser                       10
     D  betime                        6p 0
     D  befera                        4p 0
     D  beferm                        2p 0
     D  beferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsb1
      * --------------------------------------------------- *
     D DsPahsb1_t      ds                  qualified template
     D  b1empr                        1
     D  b1sucu                        2
     D  b1rama                        2p 0
     D  b1sini                        7p 0
     D  b1nops                        7p 0
     D  b1poco                        6p 0
     D  b1paco                        3p 0
     D  b1riec                        3
     D  b1xcob                        3p 0
     D  b1nrdf                        7p 0
     D  b1sebe                        6p 0
     D  b1fema                        4p 0
     D  b1femm                        2p 0
     D  b1femd                        2p 0
     D  b1cesi                        2p 0
     D  b1recl                        3p 0
     D  b1ctle                        2
     D  b1hecg                        1
     D  b1user                       10
     D  b1time                        6p 0
     D  b1fera                        4p 0
     D  b1ferm                        2p 0
     D  b1ferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsva
      * --------------------------------------------------- *
     D DsPahsva_t      ds                  qualified template
     D  vaempr                        1
     D  vasucu                        2
     D  varama                        2p 0
     D  vasini                        7p 0
     D  vanops                        7p 0
     D  vapoco                        6p 0
     D  vapaco                        3p 0
     D  vavhmc                        3
     D  vavhmo                        3
     D  vavhcs                        3
     D  vapsec                        2p 0
     D  vavhcr                        3
     D  vavhaÑ                        4p 0
     D  vavhni                        1
     D  vapatl                        1
     D  vapatn                        7p 0
     D  vapanl                        3
     D  vapann                        3p 0
     D  vamoto                       25
     D  vachas                       25
     D  vavhuv                        2p 0
     D  vavhct                        2p 0
     D  vavhvu                       15p 2
     D  vavh0k                       15p 2
     D  vahecg                        1
     D  vatalc                        2
     D  vacjrs                        2
     D  vavhts                        2
     D  vactle                        2
     D  vamar1                        1
     D  vamar2                        1
     D  vamar3                        1
     D  vamar4                        1
     D  vamar5                        1
     D  vauser                       10
     D  vatime                        6p 0
     D  vafera                        4p 0
     D  vaferm                        2p 0
     D  vaferd                        2p 0
     D  vatmat                        3
     D  vanmat                       25

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsb2
      * --------------------------------------------------- *
     D DsPahsb2_t      ds                  qualified template
     D  b2empr                        1
     D  b2sucu                        2
     D  b2rama                        2p 0
     D  b2sini                        7p 0
     D  b2nops                        7p 0
     D  b2poco                        6p 0
     D  b2paco                        3p 0
     D  b2riec                        3
     D  b2xcob                        3p 0
     D  b2nrdf                        7p 0
     D  b2sebe                        6p 0
     D  b2nrd1                        7p 0
     D  b2nomb                       40
     D  b2csex                        1p 0
     D  b2tido                        2p 0
     D  b2nrdo                        8p 0
     D  b2ntel                       20
     D  b2domi                       35
     D  b2copo                        5p 0
     D  b2cops                        1p 0
     D  b2pain                        5p 0
     D  b2cesc                        1p 0
     D  b2fena                        8p 0
     D  b2mar1                        1
     D  b2nrcv                        8p 0
     D  b2frcv                        8p 0
     D  b2mar2                        1
     D  b2mar3                        1
     D  b2mar4                        1
     D  b2mar5                        1
     D  b2rela                        2p 0
     D  b2ctro                       40
     D  b2user                       10
     D  b2date                        6p 0
     D  b2time                        6p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsb4
      * --------------------------------------------------- *
     D DsPahsb4_t      ds                  qualified template
     D  b4empr                        1
     D  b4sucu                        2
     D  b4rama                        2p 0
     D  b4sini                        7p 0
     D  b4nops                        7p 0
     D  b4poco                        6p 0
     D  b4paco                        3p 0
     D  b4riec                        3
     D  b4xcob                        3p 0
     D  b4nrdf                        7p 0
     D  b4sebe                        6p 0
     D  b4vhmc                        3
     D  b4vhmo                        3
     D  b4vhcs                        3
     D  b4vhaÑ                        4p 0
     D  b4vhcr                        3
     D  b4vhuv                        2p 0
     D  b4vhct                        2p 0
     D  b4vhni                        1
     D  b4patl                        1
     D  b4patn                        7p 0
     D  b4panl                        3
     D  b4pann                        3p 0
     D  b4moto                       25
     D  b4chas                       25
     D  b4mar1                        1
     D  b4mar2                        1
     D  b4mar3                        1
     D  b4mar4                        1
     D  b4mar5                        1
     D  b4user                       10
     D  b4date                        6p 0
     D  b4time                        6p 0
     D  b4ncoc                        5p 0
     D  b4npza                        7p 0
     D  b4npoc                        4p 0
     D  b4nend                        7p 0
     D  b4vght                        8p 0
     D  b4xcot                        3p 0
     D  b4colo                       15
     D  b4tmat                        3
     D  b4nmat                       25

      * --------------------------------------------------- *
      * Estrucutura de datos SET402
      * --------------------------------------------------- *
     D DsSet402_t      ds                  qualified template
     D   t@empr                       1
     D   t@sucu                       2
     D   t@rama                       2p 0
     D   t@cesi                       2p 0
     D   t@desi                      30
     D   t@cese                       2
     D   t@user                      10
     D   t@time                       6p 0
     D   t@date                       6p 0
     D   t@mar1                       1
     D   t@mar2                       1
     D   t@mar3                       1
     D   t@mar4                       1
     D   t@mar5                       1
     D
      * --------------------------------------------------- *
      * Estrucutura de datos SET456
      * --------------------------------------------------- *
     D DsSet456_t      ds                  qualified template
     D   t@empr                       1
     D   t@sucu                       2
     D   t@fema                       4p 0
     D   t@femm                       2p 0
     D   t@femd                       2p 0
     D   t@bloq                       1
     D   t@mar1                       1
     D   t@mar2                       1
     D   t@mar3                       1
     D   t@mar4                       1
     D   t@mar5                       1
     D   t@user                      10
     D   t@time                       6p 0
     D   t@date                       6p 0
     D

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsc1
      * --------------------------------------------------- *
     D dspahsc1_t      ds                  qualified template
     D  cd1empr                       1a
     D  cd1sucu                       2a
     D  cd1rama                       2p 0
     D  cd1sini                       7p 0
     D  cd1nops                       7p 0
     D  cd1mar1                       1a
     D  cd1cdes                       2p 0
     D  cd1pain                       5p 0
     D  cd1ruta                       3p 0
     D  cd1nrkm                       4p 0
     D  cd1mar2                       1a
     D  cd1rut2                       3p 0
     D  cd1mar3                       1a
     D  cd1mar4                       1a
     D  cd1mar5                       1a
     D  cd1mar6                       1a
     D  cd1esta                      15a
     D  cd1mar7                       1a
     D  cd1mar8                       1a
     D  cd1colo                       8a
     D  cd1tcal                      15a
     D  cd1ecal                      15a
     D  cd1paic                       5p 0
     D  cd1mar9                       1a
     D  cd1rela                       2p 0
     D  cd1cdcs                       2p 0
     D  cd1ctco                       2p 0
     D  cd1clug                       2p 0
     D  cd1user                      10a
     D  cd1date                       6p 0
     D  cd1time                       6p 0
     D  cd1colv                      20a
     D  cd1asme                       1a
     D  cd1denp                       1a
     D  cd1comi                      20a

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsd1
      * --------------------------------------------------- *
     D DsPahsd1_t      ds                  qualified template
     D  d1empr                        1
     D  d1sucu                        2
     D  d1rama                        2p 0
     D  d1sini                        7p 0
     D  d1nops                        7p 0
     D  d1nrre                        3p 0
     D  d1retx                       79
     D  d1mar1                        1
     D  d1mar2                        1
     D  d1mar3                        1
     D  d1mar4                        1
     D  d1mar5                        1
     D  d1user                       10
     D  d1date                        6p 0
     D  d1time                        6p 0
     D  d1fera                        4p 0
     D  d1ferm                        2p 0
     D  d1ferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahsd2
      * --------------------------------------------------- *
     D DsPahsd2_t      ds                  qualified template
     D  d2empr                        1
     D  d2sucu                        2
     D  d2rama                        2p 0
     D  d2sini                        7p 0
     D  d2nops                        7p 0
     D  d2poco                        6p 0
     D  d2paco                        3p 0
     D  d2nrre                        3p 0
     D  d2retx                       79
     D  d2mar1                        1
     D  d2mar2                        1
     D  d2mar3                        1
     D  d2mar4                        1
     D  d2mar5                        1
     D  d2user                       10
     D  d2date                        6p 0
     D  d2time                        6p 0
     D  d2fera                        4p 0
     D  d2ferm                        2p 0
     D  d2ferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Pahstc
      * --------------------------------------------------- *
     D DsPahstc_t      ds                  qualified template
     D  stempr                        1
     D  stsucu                        2
     D  strama                        2p 0
     D  stsini                        7p 0
     D  stnops                        7p 0
     D  stnrre                        3p 0
     D  stretx                       79
     D  stuser                       10
     D  stdate                        6p 0
     D  sttime                        6p 0
     D  stfera                        4p 0
     D  stferm                        2p 0
     D  stferd                        2p 0

      * --------------------------------------------------- *
      * Estrucutura de datos PAHSD0
      * --------------------------------------------------- *
     D dspahsd0_t      ds                  qualified template
     D  d0empr                        1a
     D  d0sucu                        2a
     D  d0rama                        2  0
     D  d0sini                        7  0
     D  d0nops                        7  0
     D  d0nrre                        3  0
     D  d0retx                       79a
     D  d0mar1                        1a
     D  d0mar2                        1a
     D  d0mar3                        1a
     D  d0mar4                        1a
     D  d0mar5                        1a
     D  d0user                       10a
     D  d0time                        6  0
     D  d0fera                        4  0
     D  d0ferm                        2  0
     D  d0ferd                        2  0

      * --------------------------------------------------- *
      * Estrucutura de datos Reclamos
      * --------------------------------------------------- *
     D DsReclamos_t    ds                  qualified template
     D  reempr                        1
     D  resucu                        2
     D  rerama                        2p 0
     D  resini                        7p 0
     D  renops                        7p 0
     D  repoco                        6p 0
     D  repaco                        3p 0
     D  reriec                        3
     D  rexcob                        3p 0
     D  renrdf                        7p 0
     D  resebe                        6p 0
     D  recesi                        2p 0
     D  rerecl                        3p 0
     D  rectle                        2
     D  rehecg                        1
      * --------------------------------------------------- *
      * Estrucutura de datos Orden de Pago Cnhop2
      * --------------------------------------------------- *
     D dsCnhop2_t      ds                  qualified template
     D  p2empr                        1
     D  p2sucu                        2
     D  p2artc                        2p 0
     D  p2pacp                        6p 0
     D  p2ivse                        5p 0
     D  p2stop                        1
     D  p2dara                        4p 0
     D  p2darm                        2p 0
     D  p2dard                        2p 0
     D  p2mar1                        1
     D  p2mar2                        1
     D  p2mar3                        1
     D  p2mar4                        1
     D  p2mar5                        1
     D  p2strg                        1
     D  p2user                       10
     D  p2date                        6p 0
     D  p2time                        6p 0

      * --------------------------------------------------- *
      * Estrucutura de datos Orden de Pago Cnhop3
      * --------------------------------------------------- *
     D dsCnhop3_t      ds                  qualified template
     D  p3empr                        1
     D  p3sucu                        2
     D  p3artc                        2p 0
     D  p3pacp                        6p 0
     D  p3ivcv                        2p 0
     D  p3ivcvu                       2p 0
     D  p3mdpa                        1
     D  p3mbaj                        1
     D  p3rama                        2p 0
     D  p3sini                        7p 0
     D  p3nops                        7p 0
     D  p3nrdf                        7p 0
     D  p3arcd                        6p 0
     D  p3spol                        9p 0
     D  p3sspo                        3p 0
     D  p3poli                        7p 0
     D  p3sebe                        6p 0
     D  p3user                       10
     D  p3date                         d
     D  p3time                         t
     D  p3jobn                       64

      * ---------------------------------------------------------- *
      * Estrucutura de datos de Percepciones s/Pagos-Ingresos Brutos
      * ---------------------------------------------------------- *
     D dsCnhpib_t      ds                  qualified template
     D  piempr                        1
     D  pisucu                        2
     D  pitiic                        3
     D  pifepa                        4p 0
     D  pifepm                        2p 0
     D  picoma                        2
     D  pinrma                        7p 0
     D  pirpro                        2p 0
     D  piivse                        5p 0
     D  pifepd                        2p 0
     D  pilibr                        1p 0
     D  pinras                        6p 0
     D  picomo                        2
     D  picome                       15p 6
     D  piiime                       15p 2
     D  piirme                       15p 2
     D  pimonp                        2
     D  picomp                       15p 6
     D  piiimp                       15p 2
     D  piirmp                       15p 2
     D  piiiau                       15p 2
     D  piirau                       15p 2
     D  pipoim                        5p 2
     D  pibmis                       15p 2
     D  pinrrf                        9p 0
     D  picoi2                        2p 0
     D  picoi1                        1p 0
     D  pimoas                        1
     D  pitico                        2p 0
     D  pitifa                        2p 0
     D  pisucp                        4p 0
     D  pifacn                        8p 0
     D  pifafa                        4p 0
     D  pifafm                        2p 0
     D  pifafd                        2p 0
     D  pipacp                        6p 0
     D  pimarp                        1
     D  pxnras                        6p 0
     D  pirbau                       15p 2
     D  pimar1                        1
     D  pimar2                        1

      /if not defined(SVPOPG_H)
      * --------------------------------------------------- *
      * Estrucutura de datos CNHRET
      * --------------------------------------------------- *
     D dscnhret_t      ds                  qualified template
     D  rtEmpr                        1a
     D  rtSucu                        2a
     D  rtTiic                        3a
     D  rtFepa                        4p 0
     D  rtFepm                        2p 0
     D  rtComa                        2a
     D  rtNrma                        7p 0
     D  rtRpro                        2p 0
     D  rtIvse                        5p 0
     D  rtFepd                        2p 0
     D  rtLibr                        1p 0
     D  rtNras                        6p 0
     D  rtComo                        2a
     D  rtCome                       15p 6
     D  rtIime                       15p 2
     D  rtIrme                       15p 2
     D  rtMonp                        2a
     D  rtComp                       15p 6
     D  rtIimp                       15p 2
     D  rtIrmp                       15p 2
     D  rtIiau                       15p 2
     D  rtIrau                       15p 2
     D  rtPoim                        5p 2
     D  rtBmis                       15p 2
     D  rtNrrf                        9p 0
     D  rtCoi2                        2p 0
     D  rtCoi1                        1p 0
     D  rtMoas                        1a
     D  rtTico                        2p 0
     D  rtSucp                        4p 0
     D  rtFacn                        8p 0
     D  rtFafa                        4p 0
     D  rtFafm                        2p 0
     D  rtFafd                        2p 0
     D  rtPacp                        6p 0
     D  rtMarp                        1a
     D  rxNras                        6p 0
     D  rtRbau                       15p 2
     D  r1Marp                        1a
     D  r2Marp                        1a
      /endif

      * --------------------------------------------------- *
      * Estrucutura de Ordenes de Pago
      * --------------------------------------------------- *
      /if not defined(SVPOPG_H)
     D DsCnhopa_t      ds                  qualified template
     D  paEmpr                        1
     D  paSucu                        2
     D  paArtc                        2p 0
     D  paPacp                        6p 0
     D  paMoas                        1a
     D  prComa                        2a
     D  prNrma                        7p 0
     D  prDvna                        1a
     D  prEsma                        1p 0
     D  paLibr                        1p 0
     D  paFasa                        4p 0
     D  paFasm                        2p 0
     D  paFasd                        2p 0
     D  paComo                        2a
     D  paTico                        2p 0
     D  paNras                        6p 0
     D  paImco                       15p 6
     D  paImme                       15p 2
     D  paImau                       15p 2
     D  paNrcm                       11p 0
     D  paDvcm                        1a
     D  paComa                        2a
     D  paNrma                        7p 0
     D  paDvna                        1a
     D  paEsma                        1p 0
     D  paFera                        4p 0
     D  paFerm                        2p 0
     D  paFerd                        2p 0
     D  paCopt                       25a
     D  pbBopt                       25a
     D  pcCopt                       25a
     D  pdCopt                       25a
     D  paCode                        3p 0
     D  pbNrcm                       11p 0
     D  pbDvcm                        1a
     D  pbComa                        2a
     D  pbNrma                        7p 0
     D  pbDvna                        1a
     D  pbEsma                        1p 0
     D  pbIvch                        6p 0
     D  pbLibr                        1p 0
     D  pbFasa                        4p 0
     D  pbFasm                        2p 0
     D  pbFasd                        2p 0
     D  pbComp                       15p 6
     D  pbTico                        2p 0
     D  pbNras                        6p 0
     D  pbimme                       15p 2
     D  pbimau                       15p 2
     D  pacfre                        1p 0
     D  pauser                       10a
     D  paafhc                       13p 0
     D  pastop                        1a
     D  parama                        2p 0
     D  paliqn                        7p 0
     D  pamovt                        1a
     D  pbmonp                        2a
     D  pbimco                       15p 6
     D  panomb                       40a
     D  paivcv                        2p 0
     D  painta                        1p 0
     D  painna                        5p 0
     D  pamarp                        1a
     D  pacofa                        2a
     D  panrve                        3p 0
     D  pamp01                        1a
     D  pamp02                        1a
     D  pamp03                        1a
     D  pamp04                        1a
     D  pamp05                        1a
     D  pamp06                        1a
     D  pamp07                        1a
     D  pamp08                        1a
     D  pamp09                        1a
     D  pbfera                        4p 0
     D  pbferm                        2p 0
     D  pbferd                        2p 0
     D
      /endif
      * --------------------------------------------------- *
      * Estructura de Asientos de Interfase
      * --------------------------------------------------- *
     D DsCnwnin_t      ds                  qualified template
     D  niEmpr                        1
     D  niFasa                        4p 0
     D  niFasm                        2p 0
     D  niFasd                        2p 0
     D  niLibr                        1p 0
     D  niNras                        6p 0
     D  niComo                        2a
     D  niSeas                        4p 0
     D  niScor                        4p 0
     D  niNrlo                        4p 0
     D  niFata                        4p 0
     D  niFatm                        2p 0
     D  niFatd                        2p 0
     D  niNrcm                       11p 0
     D  niDvcm                        1a
     D  niComa                        2a
     D  niNrma                        7p 0
     D  niDvna                        1a
     D  niEsma                        1p 0
     D  niCopt                       25a
     D  niNrrf                        9p 0
     D  niFera                        4p 0
     D  niFerm                        2p 0
     D  niFerd                        2p 0
     D  niImco                       15p 6
     D  niImme                       15p 2
     D  niImau                       15p 2
     D  niDeha                        1p 0
     D  niSuc2                        2a
     D  niTic2                        2p 0
     D  niStas                        1a
     D  niMoas                        1a
     D  niInad                        2p 0
     D  niCan1                       30p 0
     D  niCan2                       30p 0
     D  niCaa1                       30a
     D  niCaa2                       30a
     D  niUser                       10a
     D  niUaut                       10a
     D  niFaut                        6p 0
     D  niHaut                        6p 0
     D  niWaut                       10a
     D  niPaut                       10a
     D  niEaut                        1a
     D

      * --------------------------------------------------- *
      * Estructura de Parametros campos SP0047 - WWZRE01 a 13
      * --------------------------------------------------- *
     D DsSp0047_t      ds
     D  peTiic                        3
     D  peImre                       15  2
     D  pePoim                        5  2
     D  peSure                       15  2
     D  peBmis                       15  2
     D  peCoi1                        1  0
     D  peCoi2                        2  0
     D  peRete                        1
     D  peAcum                       15  2
     D  peCuib                        1  0
     D  peNrcm                       11  0
     D  peApoi                       13  2
     D  peApoc                        3

      * --------------------------------------------------- *
      * Estrucutura de Ordenes de Pago (Devengadas)
      * --------------------------------------------------- *
     D DsCnhmop_t      ds                  qualified template
     D  maEmpr                        1
     D  maSucu                        2
     D  maArtc                        2p 0
     D  maPacp                        6p 0

      * ----------------------------------------------------- *
      * Estrucutura de SPEEDWAY SINIESTROS: Facturas (cabecera)
      * ----------------------------------------------------- *
     D DsGti981s_t     ds                  qualified template
     D  G1SEMPR                       1
     D  G1SSUCU                       2
     D  G1SCOMA                       2
     D  G1SNRMA                       7p 0
     D  G1STIFA                       2p 0
     D  G1SSUFA                       4p 0
     D  G1SNRFA                       8p 0
     D  G1SFEFA                       8p 0
     D  G1SARTC                       2p 0
     D  G1SMP05                       6p 0
     D  G1SMP06                       1
     D  G1SMP07                       1
     D  G1SMP08                       1
     D  G1SMP09                       1
     D  G1SMP10                       1
     D  G1SSTRG                       1
     D  G1SUSER                      10
     D  G1SDATE                       6p 0
     D  G1STIME                       6p 0
     D  G1SIVCV                       2p 0
     D  G1SIVCH                       6p 0
     D  G1SFPAG                       8p 0
     D  G1SZAMI                      18p 0
     D  G1SZAMT                      18p 0
     D  G1SIVNR                       7p 0
     D  G1SFSTR                       8p 0
     D  G1SUAPR                      10
      * ----------------------------------------------------- *
      * Estrucutura de Cntopa
      * ----------------------------------------------------- *
     D DsCntopa_t      ds                  qualified template
     D  t@empr                        1
     D  t@sucu                        2
     D  t@artc                        2p 0
     D  t@artd                       20
     D  t@fasa                        4p 0
     D  t@fasm                        2p 0
     D  t@fasd                        2p 0
     D  t@pacp                        6p 0
     D  t@libr                        1p 0
     D  t@tico                        2p 0
     D  t@como                        2
     D  t@cfre                        1p 0
     D  t@xdia                        5p 0
     D  t@nrcm                       11p 0
     D  t@dvcm                        1
     D  t@coma                        2
     D  t@nrma                        7p 0
     D  t@dvna                        1
     D  t@esma                        1p 0
     D  t@kimp                        1
     D  tplibr                        1p 0
     D  tptico                        2p 0
     D  t@stop                        1
     D  t@inta                        1p 0
     D  t@inna                        5p 0
     D  tpinta                        1p 0

      * ----------------------------------------------------- *
      * Estrucutura de Gti960
      * ----------------------------------------------------- *
     D DsGti960_t      ds                  qualified template
     D  g0empr                        1
     D  g0sucu                        2
     D  g0rama                        2p 0
     D  g0nops                        7p 0
     D  g0user                       10
     D  g0date                        8p 0
     D  g0time                        6p 0

      * ----------------------------------------------------- *
      * Estrucutura de Gti965
      * ----------------------------------------------------- *
     D DsGti965_t      ds                  qualified template
     D  g5empr                        1
     D  g5sucu                        2
     D  g5rama                        2p 0
     D  g5sini                        7p 0
     D  g5nops                        7p 0
     D  g5artc                        2p 0
     D  g5pacp                        6p 0
     D  g5tipo                        1
     D  g5tip2                        1
     D  g5user                       10
     D  g5date                        8p 0
     D  g5time                        6p 0


      * ------------------------------------------------------------ *
      * SVPSIN_chkSini(): Valida si existe siniestro                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkSini...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_chkBeneficiario(): Valida si existe beneficiario en el*
      *                           siniestro                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkBeneficiario...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_chkBenefVariasCob(): Valida si existe beneficiario    *
      *                             en varias coberturas             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkBenefVariasCob...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_chkBenefJuicio(): Valida si beneficiario en juicio    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkBenefJuicio...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_chkFinSini(): Valida si siniestro terminado           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkFinSini...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const


      * ------------------------------------------------------------ *
      * SVPSIN_chkReclamo(): Valida reclamo - hecho generador        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peHecg   (input)   Hecho Generador                       *
      *     peRecl   (input)   Numero de Reclamo                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkReclamo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peHecg                       1    const
     D   peRecl                       3s 0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getSecShr(): Obtiene secuencia                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componente                            *
      *     pePaco   (input)   Parentesco                            *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peRiec   (input)   Riesgo                                *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Secuencia                                           *
      * ------------------------------------------------------------ *

     D SVPSIN_getSecShr...
     D                 pr             2  0
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
     D   peCobl                       3  0 const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_setPahshr(): Graba PAHSHR                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peImau   (input)   Importe                               *
      *     peUser   (input)   Usuario                               *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_setPahshr...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peImau                      15  2 const
     D   peUser                      10    const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_getSecSfr(): Obtiene secuencia                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componente                            *
      *     pePaco   (input)   Parentesco                            *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peRiec   (input)   Riesgo                                *
      *     peCobl   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Secuencia                                           *
      * ------------------------------------------------------------ *

     D SVPSIN_getSecSfr...
     D                 pr             2  0
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
     D   peCobl                       3  0 const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_setPahsfr(): Graba PAHSFR                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peImau   (input)   Importe                               *
      *     peUser   (input)   Usuario                               *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_setPahsfr...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peImau                      15  2 const
     D   peUser                      10    const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_updCtaCte(): Actualiza cuenta corriente               *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_updCtaCte...
     D                 pr              n
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getRva(): Retorna Rva Sola                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *     peRiec   ( input  ) Código de Riesgo        ( opcional ) *
      *     peXcob   ( input  ) Código de Cobertura     ( opcional ) *
      *                                                              *
      * Retorna: Rva                                                 *
      * ------------------------------------------------------------ *

     D SVPSIN_getRva...
     D                 pr            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const

      * ------------------------------------------------------------ *
      * SVPSIN_getFra(): Retorna Franquicia sola                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *     peRiec   ( input  ) Código de Riesgo        ( opcional ) *
      *     peXcob   ( input  ) Código de Cobertura     ( opcional ) *
      *                                                              *
      * Retorna: Franquicia                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_getFra...
     D                 pr            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const

      * ------------------------------------------------------------ *
      * SVPSIN_getPag(): Retorna Pagos solo                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *     peRiec   ( input  ) Código de Riesgo        ( opcional ) *
      *     peXcob   ( input  ) Código de Cobertura     ( opcional ) *
      *                                                              *
      * Retorna: Pagos                                               *
      * ------------------------------------------------------------ *

     D SVPSIN_getPag...
     D                 pr            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaAct(): Retorna Rva Actual                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *     peRiec   ( input  ) Código de Riesgo        ( opcional ) *
      *     peXcob   ( input  ) Código de Cobertura     ( opcional ) *
      *                                                              *
      * Retorna: Importe de Rva Actual                               *
      * ------------------------------------------------------------ *

     D SVPSIN_getRvaAct...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const

      * ------------------------------------------------------------ *
      * SVPSIN_getCantSin(): Retorna cantidad de sinistros           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Rva Actual                               *
      * ------------------------------------------------------------ *

     D SVPSIN_getCantSin...
     D                 pr             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPSIN_inz      pr

      * ------------------------------------------------------------ *
      * SVPSIN_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPSIN_end      pr

      * ------------------------------------------------------------ *
      * SVPSIN_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPSIN_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_getSumAsComp(): Retorna Suma Asegurada de Componente  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componente                            *
      *     pePaco   (input)   Parentesco                            *
      *                                                              *
      * Retorna: Suma Asegurada de Componente / -1 Error             *
      * ------------------------------------------------------------ *

     D SVPSIN_getSumAsComp...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 options(*Nopass:*Omit)

      * ------------------------------------------------------------ *
      * SVPSIN_getIndem(): Retorna Pagos de tipo indemnizaciones     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Indemnizaiones                                      *
      * ------------------------------------------------------------ *

     D SVPSIN_getIndem...
     D                 pr            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getEstSin(): Retorna Estado del Siniestro             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Estado del Siniestro                                *
      * ------------------------------------------------------------ *

     D SVPSIN_getEstSin...
     D                 pr             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getEstRec(): Retorna Estado del Reclamo               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Componenete                           *
      *     pePaco   (input)   Parentesco                            *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *     peNrdf   (input)   Numero de Beneficiario                *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Estado del Reclamo                                  *
      * ------------------------------------------------------------ *

     D SVPSIN_getEstRec...
     D                 pr             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSebe                       6  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getEstJui(): Retorna Estado del Juicio                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Numero de Beneficiario                *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *     peNrcj   (input)   Carpeta de Juicio                     *
      *     peJuin   (input)   Numero de Juicio                      *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Estado del Juicio                                   *
      * ------------------------------------------------------------ *

     D SVPSIN_getEstJui...
     D                 pr             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peNrcj                       6  0 const
     D   peJuin                       6  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniPend(): Retorna si siniestro esta pendiente    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkSiniPend...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniPag(): Retorna si siniestro tiene un pago en   *
      *                      los ultimos 6 meses                     *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha Desde                           *
      *     peFech   (input)   Fecha Hasta                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkSiniPag...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0 options (*omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_chkSiniDen(): Retorna si siniestro tiene denuncia e/  *
      *                      determiadas fechas                      *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Super Póliza                          *
      *     peFdes   (input)   Fecha Desde                           *
      *     peFhas   (input)   Fecha Hasta                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkSiniDen...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0 options (*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getSiniDen(): Retorna si tiene algun siniestro        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Super Póliza                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_getSini...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_chkWeb(): Devuelve si viaja a Web                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Nro de Operacion                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getPagosJui(): Retorna Pagos de Juicio                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Indemnizaciones                                     *
      * ------------------------------------------------------------ *

     D SVPSIN_getPagosJui...
     D                 pr            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getSpol(): Retorna  Superpoliza/Suplemento/Articulo   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peArcd   (output)  Articulo                              *
      *     peSpol   (output)  Super Poliza                          *
      *     peSspo   (output)  Suplemento                            *
      *                                                              *
      * Retorna: 0 / -1                                              *
      * ------------------------------------------------------------ *

     D SVPSIN_getSpol...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 options( *omit : *nopass )
     D   peArcd                       6  0 options( *omit : *nopass )
     D   peSpol                       9  0 options( *omit : *nopass )
     D   peSspo                       3  0 options( *omit : *nopass )

      * ------------------------------------------------------------ *
      * SVPSIN_getPol(): Retorna  Poliza                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: Poliza / -1                                         *
      * ------------------------------------------------------------ *

     D SVPSIN_getPol...
     D                 pr             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_chkCausaReno(): Verifica si tiene Siniestros con      *
      * causa: 5-Rono Unidad / 7-Incendio Total / 9-Destrucción Total*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *                                                              *
      * Retorna: 0 / -1                                              *
      * ------------------------------------------------------------ *

     D SVPSIN_chkCausaReno...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const


      * ------------------------------------------------------------ *
      * SVPSIN_getPagos:Retorna Pagos Historicos de una poliza por   *
      *                 Codigo de Area Tecnica y Nro de Comprobante  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Codigo Area Tecnica                  *
      *     pePacp   ( input  ) Nro. de Comprobante de Pago          *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsSi   ( output ) Estructura de Pagos                  *
      *     peDsSiC  ( output ) Cantidad de Pagos                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     D SVPSIN_getPagos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsSi                            likeds( DsPahshp01_t ) dim(999)
     D   peDsSiC                     10i 0
     D

      * ------------------------------------------------------------ *
      * SVPSIN_getFechaDelDia: Retorna fecha de día de hoy           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *                                                              *
      * Retorna: Fecha                                               *
      * ------------------------------------------------------------ *

     D SVPSIN_getFechaDelDia...
     D                 pr             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const

      * ------------------------------------------------------------ *
      * SVPSIN_getConfiguracionVoucherRuedasCristales: Retorna Con-  *
      *                                    fiuracion de Voucher de   *
      *                                    Ruedas y Cristales        *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peFech   ( input  ) Fecha                                *
      *     peQrev   ( output ) Cantidad de Ruedas por Evento        *
      *     peFrue   ( output ) Frecuencia de Ruedas                 *
      *     peFcri   ( output ) Frecuencia de Cristales              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_getConfiguracionVoucherRuedasCristales...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peQrev                       1  0
     D   peFrue                       3  0
     D   peFcri                       3  0
     D   peFech                       8  0 options( *omit : *nopass ) const

      * ------------------------------------------------------------ *
      * SVPSIN_getCantidadSiniestrosRuedasPorVehiculo: Retorna Can-  *
      *                                    tidad de Siniestros de    *
      *                                    Ruedas por Vehiculo       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNmat   ( input  ) Matricula/Patente                    *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Póliza                               *
      *                                                              *
      * Retorna: Cantidad de Siniestros                              *
      * ------------------------------------------------------------ *

     D SVPSIN_getCantidadSiniestrosRuedasPorVehiculo...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getCantidadSiniestrosCristalesPorVehiculo: Retorna    *
      *                                    Cantidad de Siniestros de *
      *                                    Ruedas por Vehiculo       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNmat   ( input  ) Matricula/Patente                    *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Póliza                               *
      *                                                              *
      * Retorna: Cantidad de Siniestros                              *
      * ------------------------------------------------------------ *

     D SVPSIN_getCantidadSiniestrosCristalesPorVehiculo...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getNumeroVoucher: Retorna Número de Voucher           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *                                                              *
      * Retorna: Número                                              *
      * ------------------------------------------------------------ *

     D SVPSIN_getNumeroVoucher...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const

      * ------------------------------------------------------------ *
      * SVPSIN_setNumeroVoucher: Retorna Número de Voucher           *
      *                                                              *
      *     peBase   ( input  ) Parametros Base                      *
      *     peNpds   ( input  ) Número de Pre-Denuncia               *
      *     peNore   ( input  ) Número de Voucher ó Orden Reposición *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_setNumeroVoucher...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peNore                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getCaratula(): Retorna Carátula de Denuncia de        *
      *                       Siniestro.-                            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     peDsCd   ( output ) Estructura de Carátula de Siniestro  *
      *     peDsCdC  ( output ) Cantidad de Carátula de Siniestro    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     D SVPSIN_getCaratula...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsCd                            likeds ( DsPahscd_t )

      * ------------------------------------------------------------ *
      * SVPSIN_getVehiculo(): Retorna Siniestro de Vehículo del      *
      *                       Asegurado.-                            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peNops   ( input  ) Nro de Operación Siniestro           *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peVhmc   ( input  ) Marca de Vehículo                    *
      *     peVhmo   ( input  ) Código de Modelo                     *
      *     peVhcs   ( input  ) Código de Submodelo                  *
      *     pePsec   ( input  ) Nro de Secuencia                     *
      *     peDsCd   ( output ) Estructura de Siniestro de Vehículo  *
      *     peDsCdC  ( output ) Cantidad de Siniestro de Vehículo    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     D SVPSIN_getVehiculo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peVhmc                       3    options(*nopass:*omit) const
     D   peVhmo                       3    options(*nopass:*omit) const
     D   peVhcs                       3    options(*nopass:*omit) const
     D   pePsec                       2  0 options(*nopass:*omit) const
     D   peDsVa                            likeds ( DsPahsva_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsVaC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_getBeneficiarios(): Retorna Beneficiarios del         *
      *                            Siniestro.-                       *
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

     D SVPSIN_getBeneficiarios...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsBe                            likeds ( DsPahsbe_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsBeC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_getSubsiniestros(): Retorna Subsiniestros del         *
      *                            Siniestro.-                       *
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
      *     peFema   ( input  ) Fecha de Emisión Año                 *
      *     peFemm   ( input  ) Fecha de Emisión Mes                 *
      *     peFemd   ( input  ) Fecha de Emisión Día                 *
      *     peDsBe   ( output ) Estructura de Subsiniestros de Sini. *
      *     peDsBeC  ( output ) Cantidad de Subsiniestro de Sini.    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     D SVPSIN_getSubsiniestros...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peFema                       4  0 options(*nopass:*omit) const
     D   peFemm                       2  0 options(*nopass:*omit) const
     D   peFemd                       2  0 options(*nopass:*omit) const
     D   peDsB1                            likeds ( DsPahsb1_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsB1C                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_getUltimoSubsiniestro(): Retorna Ultimo estado del    *
      *                                 Subsiniestro.-               *
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
      *     peDsb1   ( output ) Estructura de Subsiniestro           *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     D SVPSIN_getUltimoSubsiniestro...
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
     D   peDsb1                            likeds( DsPahsb1_t )

      * ------------------------------------------------------------ *
      * SVPSIN_getConductorTercero(): Retorna Datos del Conductor    *
      *                               Tercero del Siniestros.-       *
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
      *     peDsB2   ( output ) Estructura de Conductor Tercero      *
      *     peDsB2C  ( output ) Cantidad de Conductor Tercero        *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     D SVPSIN_getConductorTercero...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsB2                            likeds ( DsPahsb2_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsB2C                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_getVehiculoTercero(): Retorna Datos del Vehiculo del  *
      *                              Tercero del Siniestro.-         *
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
      *     peDsB4   ( output ) Estructura de Conductor Tercero      *
      *     peDsB4C  ( output ) Cantidad de Conductor Tercero        *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *

     D SVPSIN_getVehiculoTercero...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peDsB4                            likeds ( DsPahsb4_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsB4C                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_getUltFechaPago(): Retorna Ultima Fecha de Pago       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   ( input  ) Nro de Componente                    *
      *     pePaco   ( input  ) Código de Parentesco                 *
      *     peNrdf   ( input  ) Filiatorio de Beneficiario           *
      *     peSebe   ( input  ) Sec. Benef. Siniestros               *
      *     peRiec   ( input  ) Código de Riesgo                     *
      *     peXcob   ( input  ) Código de Cobertura                  *
      *     peFech   ( output ) Fecha de Pago                        *
      *     peMone   ( output ) Moneda                               *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_getUltFechaPago...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 options(*nopass:*omit) const
     D   pePaco                       3  0 options(*nopass:*omit) const
     D   peNrdf                       7  0 options(*nopass:*omit) const
     D   peSebe                       6  0 options(*nopass:*omit) const
     D   peRiec                       3    options(*nopass:*omit) const
     D   peXcob                       3  0 options(*nopass:*omit) const
     D   peFech                       8  0 options(*omit:*nopass)
     D   peMone                       2    options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_terminarSiniestro(): Finaliza Siniestro               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_terminarSiniestro...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_terminarReclamo(): Finaliza Reclamo                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_terminarReclamo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarRvaStro(): Nivelar Reserva                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_nivelarRvaStro...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_terminarCaratula(): Finaliza Carátula                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peCesi   (input)   Estado Siniestro                      *
      *     peCese   (input)   Estado Siniestro Equivalente          *
      *     peTerm   (input)   Codigo Terminado                      *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_terminarCaratula...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peCesi                       2  0 const
     D   peCese                       2    const
     D   peTerm                       1    const

      * ------------------------------------------------------------ *
      * SVPSIN_getSet402() : Obtiene Set402                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peCesi   (input)   Estado Siniestro                      *
      *     peDs402  (output)  Estructura SET402                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_getSet402...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peCesi                       2  0 const
     D   peDs402                           likeds ( DsSET402_t )

      * ------------------------------------------------------------ *
      * SVPSIN_getSet456() : Obtiene SET456                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peDs456  (output)  Estructura SET456                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_getSet456...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs456                           likeds ( DsSET456_t )

      * ------------------------------------------------------------ *
      * SVPSIN_wrtEstSin() : Grabo Estado Siniestro                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFema   (input)   Fecha Año Movimiento                  *
      *     peFemm   (input)   Fecha Mes Movimiento                  *
      *     peFemd   (input)   Fecha Día Movimiento                  *
      *     peCesi   (input)   Estado Siniestro                      *
      *     peCese   (input)   Estado Siniestro Equivalente          *
      *     peTerm   (input)   Codigo Terminado                      *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_wrtEstSin...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   peCesi                       2  0 const
     D   peCese                       2    const
     D   peTerm                       1    const

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaStro : Obtengo Reserva del Siniestro            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Reserva                                  *
      * ------------------------------------------------------------ *

     D SVPSIN_getRvaStro...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getFraStro : Obtengo Franquicia del Siniestro         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Franquicia                               *
      * ------------------------------------------------------------ *

     D SVPSIN_getFraStro...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getPagStro : Obtengo Pagos del Siniestro              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe de Pagos                                    *
      * ------------------------------------------------------------ *

     D SVPSIN_getPagStro...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaActStro : Obtengo Reserva Actual del Siniestro  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Importe Reserva Neta de Franquicias y Pagos.(SAP)   *
      * ------------------------------------------------------------ *

     D SVPSIN_getRvaActStro...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_chkStroEnJuicio : Chequeo si el Siniestro esta en     *
      *                          Juicio                              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_chkStroEnJuicio...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarRvaStroBenef() :  Nivelar las reservas de un   *
      *                                 Beneficiario.                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_nivelarRvaStroBenef...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_terminarReclamoStro(): Finaliza un Reclamo de         *
      *                               Siniestro                      *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     pePoco   (input)   Nro de Componente                     *
      *     pePaco   (input)   Código de Parentesco                  *
      *     periec   (input)   Código de Riesgo                      *
      *     pexcob   (input)   Código de Cobertura                   *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Sec. Benef. Siniestros                *
      *     peCesi   (input)   Estado del Siniestro                  *
      *     peRecl   (input)   Número de Reclamo                     *
      *     peCtle   (input)   Tipo de Lesiones                      *
      *     peHecg   (input)   Hecho Generador                       *
      *     peFema   (input)   Fecha Año Movimiento                  *
      *     peFemm   (input)   Fecha Mes Movimiento                  *
      *     peFemd   (input)   Fecha Día Movimiento                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_terminarReclamoStro...
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
     D   peCesi                       2  0 const
     D   peRecl                       3  0 const
     D   peCtle                       2    const
     D   peHecg                       1    const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarFraStro() : Nivelar las Franquicias de un      *
      *                           Siniestro.                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPSIN_nivelarFraStro...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFech                       8  0 const options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_nivelarFraStroBenef() :  Nivelar las Franquicias de   *
      *                                 un Beneficiario.             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *on / *off  *on = Nivelo Ok / *off = No nivelo      *
      * ------------------------------------------------------------ *

     D SVPSIN_nivelarFraStroBenef...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getCaratula2() Retorna Carátula de Denuncia de        *
      *                       Siniestro (sin NOPS).                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsCd   ( output ) Estructura de Carátula de Siniestro  *
      *     peDsCdC  ( output ) Cantidad de Carátula de Siniestro    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getCaratula2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsCd                            likeds ( DsPahscd_t )

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSc1():   Retorna registro PAHSC1.               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsC1   ( output ) Estructura de Carátula de Siniestro  *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getPahSc1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsC1                            likeds ( DsPahsc1_t )

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSd1():   Retorna registro de PAHSD1.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsD1   ( output ) Estructura de PAHSD1                 *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getPahSd1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsD1                            likeds ( DsPahsd1_t )

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSd2():   Retorna registro de PAHSD2.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsD2   ( output ) Estructura de PAHSD2                 *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getPahSd2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDsD2                            likeds ( DsPahsd2_t )

      * ------------------------------------------------------------ *
      * SVPSIN_getPahStc():   Retorna registro de PAHSTC.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDsTc   ( output ) Estructura de PAHSTC                 *
      *     peDsTcc  ( output ) Contador de PAHSTC                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getPahStc...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsTc                            likeds ( DsPahstc_t ) dim(999)
     D   peDsTcc                     10i 0

      * ------------------------------------------------------------ *
      * SVPSIN_getPahSd0():   Retorna registro de PAHSD0.            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Nro de Siniestro                     *
      *     peDss0   ( output ) Estructura de PAHSD0                 *
      *     peDsD0c  ( output ) Contador de PAHSD0                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getPahSd0...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsd0                            likeds ( DsPahsd0_t ) dim(999)
     D   peDsD0c                     10i 0

      * ------------------------------------------------------------ *
      * DOT 05/10/2021                                               *
      * SVPSIN_chkNroOperStro(): Valida existencia de nro.de opera_  *
      *                          cion de siniestro.                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On=Existe / *Off= No existe Operacion de Siniestro *
      * ------------------------------------------------------------ *
      * Defino como prototipo de llamada
     D SVPSIN_chkNroOperStro...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * DOT 05/10/2021                                               *
      * SVPSIN_getSiniestroDesdeNops(): Devuelve numero de Siniestro *
      *                                 de una operacion de siniestro*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peSini   (output)  Numero de Siniestro                   *
      *                                                              *
      * Retorna: Numero de Siniestro                                 *
      *          0=No Encontrado                                     *
      * ------------------------------------------------------------ *
      * Defino como prototipo de llamada
     D SVPSIN_getSiniestroDesdeNops...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * DOT 11/11/2021                                               *
      * SVPSIN_chkSinModificable(): Valida por operacion, que el si_ *
      *              niestro tenga un estado valido para ser modifi_ *
      *              cado (saca la logia del sar907).                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *On=Modificable / *Off= NO MODIFICABLE              *
      * ------------------------------------------------------------ *
      * Defino como prototipo de llamada
     D SVPSIN_chkSinModificable...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_terminarReclamoV1(): Finaliza los Reclamos de un      *
      *                             Siniestro  Version 1             *
      *                             Agregado de Reclamo.             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_terminarReclamoV1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaXReclamo(): Obtengo la Reserva por Reclamo      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo                     *
      *                                                              *
      * Retorna: Importe de Reserva x Reclamo / *zeros               *
      * ------------------------------------------------------------ *
     D SVPSIN_getRvaXReclamo...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getReclamosXStro() : Obtengo los Reclamos por         *
      *                             Siniestros                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Devuelve:Estructura con Reclamos x Siniestros                *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_getReclamosXStro...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peDsRe                            likeds ( DsReclamos_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsReC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_terminarBenefXReclamo : Termina el reclamo x          *
      *                                beneficiario y nivela las     *
      *                                reservas del mismo            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_terminarBenefXReclamo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_chgEstadoReclamo : Cambia Estados del Reclamo         *
      *                                                              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo                     *
      *     peHecg   (input)   Hecho Generador                       *
      *     peCtle   (input)   Tipo de Lesiones                      *
      *     peCesi   (input)   Estado del Reclamo                    *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_chgEstadosReclamo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const
     D   peCesi                       2  0 const
     D   peCtle                       2    const
     D   peHecg                       1    const

      * ------------------------------------------------------------ *
      * SVPSIN_chkEstadosReclamo : chequea Estados del Reclamo       *
      *                            Hecho Generador                   *
      *                            Tipo de Lesiones                  *
      *                            Estado del Reclamo                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peRecl   (input)   Número de Reclamo                     *
      *     peHecg   (input)   Hecho Generador                       *
      *     peCtle   (input)   Tipo de Lesiones                      *
      *     peCesi   (input)   Estado del Reclamo                    *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_chkEstadosReclamo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peRecl                       3  0 const
     D   peCesi                       2  0 const
     D   peCtle                       2    const
     D   peHecg                       1    const
     d   peIdms                       7a
     d   peIdm1                       7a
     d   peIdm2                       7a

      * ------------------------------------------------------------ *
      * SVPSIN_getSaldoActual(): Retorna el saldo actual de la       *
      *                          cuenta corriente del siniestro.     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: Saldo                                               *
      * ------------------------------------------------------------ *
     D SVPSIN_getSaldoActual...
     D                 pr            11  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_rehabilitarSiniestro(): Rehabilita el Siniestro       *
      *                                para poder modificarlo.       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_rehabilitarSiniestro...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getCnhop2(): Retorna datos de Ordenes de Pago:        *
      *                     Aprobaciones.-                           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de Pago                    *
      *     peIvse   ( input  ) Secuencia                            *
      *     peDsp2   ( output ) Estructura de Ordenes de Pago        *
      *     peDsp2C  ( output ) Cantidad de Ordenes de Pago          *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getCnhop2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvse                       5  0 const
     D   peDsp2                            likeds ( DsCnhop2_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsp2C                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhop2(): Valida si existe Ordenes de Pago         *
      *                     Aprobaciones.-                           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de Pago                    *
      *     peIvse   ( input  ) Secuencia                            *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_chkCnhop2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peIvse                       5  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhop2(): Graba datos en el archivo Cnhop2              *
      *                                                                   *
      *          peDsp2   ( input  ) Estrutura de Cnhop2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setCnhop2...
     D                 pr              n
     D   peDsp2                            likeds( dsCnhop2_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhop2(): Actualiza datos en el archivo Cnhop2          *
      *                                                                   *
      *          peDsp2   ( input  ) Estrutura de Cnhop2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updCnhop2...
     D                 pr              n
     D   peDsp2                            likeds( dsCnhop2_t ) const
      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhop2(): Elimina datos en el archivo Cnhop2            *
      *                                                                   *
      *          peDsp2   ( input  ) Estrutura de Cnhop2                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_dltCnhop2...
     D                 pr              n
     D   peDsp2                            likeds( dsCnhop2_t ) const

      * ------------------------------------------------------------ *
      * SVPSIN_getCnhop3(): Retorna datos de Ordenes de Pago:        *
      *                     Con forma de pago distinto al default.-  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de Pago                    *
      *     peDsp3   ( output ) Estructura de Ordenes de Pago        *
      *     peDsp3C  ( output ) Cantidad de Ordenes de Pago          *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getCnhop3...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsp3                            likeds ( DsCnhop3_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsp3C                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhop3(): Valida si existe Ordenes de Pago         *
      *                     Con forma de pago distinto al default.-  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de Pago                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_chkCnhop3...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhop3(): Graba datos en el archivo Cnhop3              *
      *                                                                   *
      *          peDsp3   ( input  ) Estrutura de Cnhop3                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setCnhop3...
     D                 pr              n
     D   peDsp3                            likeds( dsCnhop3_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhop3(): Actualiza datos en el archivo Cnhop3          *
      *                                                                   *
      *          peDsp3   ( input  ) Estrutura de Cnhop3                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updCnhop3...
     D                 pr              n
     D   peDsp3                            likeds( dsCnhop3_t ) const
      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhop3(): Elimina datos en el archivo Cnhop3            *
      *                                                                   *
      *          peDsp3   ( input  ) Estrutura de Cnhop3                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_dltCnhop3...
     D                 pr              n
     D   peDsp3                            likeds( dsCnhop3_t ) const

      * ------------------------------------------------------------ *
      * SVPSIN_getCnhpib(): Retorna datos de detalle de              *
      *                     Percepciones s/Pagos-Ingresos Brutos.-   *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peTiic   ( input  ) Tipo Impuesto                        *
      *     peFepa   ( input  ) Anio                                 *
      *     peFepm   ( input  ) Mes                                  *
      *     peComa   ( input  ) Cod may.                             *
      *     peNrma   ( input  ) Nro may.                             *
      *     peRrpo   ( input  ) Provincia                            *
      *     peIvse   ( input  ) Secuencia                            *
      *     peDsIb   ( output ) Estructura de Cnhpib                 *
      *     peDsIbC  ( output ) Cantidad de Cnhpib                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getCnhpib...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRrpo                       2  0 const
     D   peIvse                       5  0 const
     D   peDsIb                            likeds ( DsCnhpib_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsIbC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhpib(): Valida si existe datos de detalle de     *
      *                     Percepciones s/Pagos-Ingresos Brutos.-   *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peTiic   ( input  ) Tipo Impuesto                        *
      *     peFepa   ( input  ) Anio                                 *
      *     peFepm   ( input  ) Mes                                  *
      *     peComa   ( input  ) Cod may.                             *
      *     peNrma   ( input  ) Nro may.                             *
      *     peRrpo   ( input  ) Provincia                            *
      *     peIvse   ( input  ) Secuencia                            *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_chkCnhpib...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRrpo                       2  0 const
     D   peIvse                       5  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhpib(): Graba datos en el archivo Cnhpib              *
      *                                                                   *
      *          peDsIb   ( input  ) Estrutura de Cnhpib                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setCnhpib...
     D                 pr              n
     D   peDsIb                            likeds( dsCnhpib_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhpib(): Actualiza datos en el archivo Cnhpib          *
      *                                                                   *
      *          peDsIb   ( input  ) Estrutura de Cnhpib                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updCnhpib...
     D                 pr              n
     D   peDsIb                            likeds( dsCnhpib_t ) const
      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhpib(): Elimina datos en el archivo Cnhpib            *
      *                                                                   *
      *          peDsIb   ( input  ) Estrutura de Cnhpib                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_dltCnhpib...
     D                 pr              n
     D   peDsIb                            likeds( dsCnhpib_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_getCnhret(): Retorna datos Detalle de Retenciones          *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peTiic   ( input  ) Codigo de Tipo de Impuesto            *
      *         peFepa   ( input  ) Fecha de Pago Anio                    *
      *         peFepm   ( input  ) Fecha de Pago Mes                     *
      *         peComa   ( input  ) codigo de Mayor Auxiliar              *
      *         peNrma   ( input  ) Numero Mayor Auxiliar                 *
      *         peRpro   ( input  ) Codigo Pcia. del Inder                *
      *         peIvse   ( input  ) Secuencia                             *
      *         peLret   ( output ) Lista de Retenciones     ( opcional ) *
      *         peLretC  ( output ) Cantidad Retenciones     ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_getCnhret...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const
     D   peIvse                       5  0 const
     D   peLret                            likeds(dsCnhret_t) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peLretC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhret(): Valida si existe Detalle de Retenciones  *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peTiic   ( input  ) Codigo de Tipo de Impuesto       *
      *         peFepa   ( input  ) Fecha de Pago Anio               *
      *         peFepm   ( input  ) Fecha de Pago Mes                *
      *         peComa   ( input  ) codigo de Mayor Auxiliar         *
      *         peNrma   ( input  ) Numero Mayor Auxiliar            *
      *         peRpro   ( input  ) Codigo Pcia. del Inder           *
      *         peIvse   ( input  ) Secuencia                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_chkCnhret...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const
     D   peIvse                       5  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhret(): Graba datos en el archivo Cnhret              *
      *                                                                   *
      *          peDret   ( input  ) Estrutura de Cnhret                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setCnhret...
     D                 pr              n
     D   peDret                            likeds( dsCnhret_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhret(): Actualiza datos en el archivo Cnhret          *
      *                                                                   *
      *          peDret   ( input  ) Estrutura de Cnhret                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updCnhret...
     D                 pr              n
     D   peDret                            likeds( dsCnhret_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhret(): Elimina datos en el archivo Cnhret            *
      *                                                                   *
      *          peDret   ( input  ) Estrutura de Cnhret                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_dltCnhret...
     D                 pr              n
     D   peDret                            likeds( dsCnhret_t ) const

      * ------------------------------------------------------------ *
      * SVPSIN_getFechaDeReserva(): Retorna fecha de reserva.        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPSIN_getFechaDeReserva...
     D                 pr             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_setCnhopa() : Graba datos en el Archivo CNHOPA        *
      *                                                              *
      *                                                              *
      *     peDsop   ( input  ) Estrutura de CNHOPA                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_setCnhopa...
     D                 pr              n
     D   peDsop                            likeds( dsCnhopa_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_getCnhopa(): Retorna datos de Ordenes de Pago              *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peArtc   ( input  ) Area Técnica                          *
      *         pePacp   ( input  ) Número de Orden de Pago               *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_getCnhopa...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsOp                            likeds(dsCnhopa_t)
     D                                     options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhopa() : Cheque datos en el Archivo CNHOPA       *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peArtc   ( input  ) Area Técnica                     *
      *         pePacp   ( input  ) Número de Orden de Pago          *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_chkCnhopa...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_setCnwnin() : Graba datos en el Archivo CNWNIN        *
      *                                                              *
      *                                                              *
      *     peDsni   ( input  ) Estrutura de CNWNIN                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_setCnwnin...
     D                 pr              n
     D   peDsni                            likeds( dsCnwnin_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_getCnwnin(): Retorna datos de Ordenes de Pago              *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peFasa   ( input  ) Año de Asiento                        *
      *         peFasm   ( input  ) Mes de Asiento                        *
      *         peFasd   ( input  ) Día de Asiento                        *
      *         peLibr   ( input  ) Libro                                 *
      *         peTic2   ( input  ) Tipo de Comprobante                   *
      *         peNras   ( input  ) Número de Asiento                     *
      *         peComo   ( input  ) Moneda                                *
      *         peSeas   ( input  ) Secuencia de Asiento                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_getCnwnin...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFasa                       4  0 const
     D   peFasm                       2  0 const
     D   peFasd                       2  0 const
     D   peLibr                       1  0 const
     D   peTic2                       2  0 const
     D   peNras                       6  0 const
     D   peComo                       2    const
     D   peSeas                       4  0 const
     D   peDsNi                            likeds(dsCnwnin_t)
     D                                     options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnwnin() : Cheque datos en el Archivo CNWNIN       *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peFasa   ( input  ) Año de Asiento                   *
      *         peFasm   ( input  ) Mes de Asiento                   *
      *         peFasd   ( input  ) Día de Asiento                   *
      *         peLibr   ( input  ) Libro                            *
      *         peTic2   ( input  ) Tipo de Comprobante              *
      *         peNras   ( input  ) Número de Asiento                *
      *         peComo   ( input  ) Moneda                           *
      *         peSeas   ( input  ) Secuencia de Asiento             *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_chkCnwnin...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peFasa                       4  0 const
     D   peFasm                       2  0 const
     D   peFasd                       2  0 const
     D   peLibr                       1  0 const
     D   peTic2                       2  0 const
     D   peNras                       6  0 const
     D   peComo                       2    const
     D   peSeas                       4  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_GenerarOrdPagStroTotal(): Generar Orden De Pago de    *
      *                                  Siniestro Total.            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Estructura de Siniestro               *
      *     peCant   (input)   Cantidad   de Siniestros              *
      *     peMar1   (input)   Tipo de Beneficiario de Pago          *
      *     peComa   (input)   Código Mayor Auxiliar                 *
      *     peNrma   (input)   Número Mayor Auxiliar                 *
      *     peTipa   (input)   Tipo de Pago                          *
      *     peImpo   (input)   Importe de Pago                       *
      *     peMar2   (input)   Gastos/Indemnización                  *
      *     peFeop   (input)   Fecha Orden de Pago                   *
      *     peFvdv   (input)   Forma de Pago                         *
      *     peTifa   (input)   Tipo de Factura                       *
      *     peSufa   (input)   Sucursal de Factura                   *
      *     peNrfa   (input)   Número de Factura                     *
      *     peFfac   (input)   Fecha de Factura                      *
      *     peRpro   (input)   Provincia de Percepción               *
      *     peImpe   (input)   Importe de Percepción                 *
      *     peCopt   (input)   Concepto de Pago                      *
      *     peApol   (input)   Aplica a Póliza                       *
      *     peNomb   (input)   Cheque a la Orden de                  *
      *     peCore   (input)   Codigo de Recibo                      *
      *     peDeJu   (input)   Deposito Judicial                     *
      *     peUSer   (input)   Usuario                               *
      *     peValo   (output)  Valores calculados                    *
      *                                                              *
      * Retorna: Área Técnica y Número de Orden de Pago              *
      * ------------------------------------------------------------ *
     D SVPSIN_generarOrdPagStroTotal...
     D                 pr             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                            likeds ( siniestroNum_t ) const
     D                                     dim(999)
     D   peCant                      10  0 const
     D   peMar1                       1    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peTipa                       1    const
     D   peImpo                      15  2 const
     D   peMar2                       1    const
     D   peFeop                      10    const
     D   peFvdv                       2  0 const
     D   peTifa                       2  0 const
     D   peSufa                       4  0 const
     D   peNrfa                       8  0 const
     D   peFfac                      10    const
     D   peRpro                       2  0 const dim(25)
     D   peImpe                      15  2 const dim(25)
     D   peCopt                      75    const
     D   peApol                       1    const
     D   peNomb                      40    const
     D   peDeJu                       1    const
     D   peUser                      10    const
     D   peValo                            likeds(valoresOp_t)

      * ------------------------------------------------------------ *
      * SVPSIN_getIvaProveedor : Recupera Iva de los proveedores     *
      *                                                              *
      *         peEmpr   ( input  ) Empresa                          *
      *         peSucu   ( input  ) Sucursal                         *
      *         peComa   ( input  ) Código Mayor Auxiliar            *
      *         peNrma   ( input  ) Número Mayor Auxiliar            *
      *         peFasa   ( input  ) Fecha Año                        *
      *         peFasm   ( input  ) Fecha Mes                        *
      *         peFasd   ( input  ) Fecha Día                        *
      *         peTifa   ( input  ) Tipo de Factura                  *
      *         peCoi2   ( output ) Cod.Categ.Ret/Imp-COI2           *
      *         peCoi1   ( output ) Cod.Inscripción-COI1             *
      *         pePoim   ( output ) Porcentaje del Impuesto          *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_getIvaProveedor...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       6  0 const
     D   peFasa                       4  0 const
     D   peFasm                       2  0 const
     D   peFasd                       2  0 const
     D   peTifa                       2  0 const
     D   peCoi2                       2  0
     D   peCoi1                       1  0
     D   pePoim                       5  2

      * ------------------------------------------------------------ *
      * SVPSIN_getPerIbrProveedor : Recupera Percepción IBR          *
      *                             Proveedores.                     *
      *                                                              *
      *         peComa   ( input  ) Código Mayor Auxiliar            *
      *         peNrma   ( input  ) Número Mayor Auxiliar            *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPSIN_getPerIbrProveedor...
     D                 pr             1n
     D   peComa                       2    const
     D   peNrma                       6  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setPerporProv(): Graba Percepciones por Provincia          *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          pePacp   ( input  ) Nro Comprobante de Pago              *
      *          peCmga   ( input  ) Gen. Asi. May. Auxiliar              *
      *          peNrrf   ( input  ) Numero Referencia Reg. Asi.          *
      *          peTiic   ( input  ) Codigo de Tipo de Impuesto           *
      *          PeTifa   ( input  ) Tipo de Factura                      *
      *          PeSucp   ( input  ) Sucursal Proveedor                   *
      *          peFacn   ( input  ) Numero de Factura                    *
      *          peRpro   ( input  ) Codigo Pcia. del Inder               *
      *          peComo   ( input  ) Codigo Moneda                        *
      *          peImau   ( input  ) Importe Moneda Cte.                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setPerporProv...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peCmga                      11  0 const
     D   peNrrf                       9  0 const
     D   peTiic                       3    const
     D   peTifa                       2  0 const
     D   peSucp                       4  0 const
     D   peFacn                       8  0 const
     D   peRpro                       2  0 const
     D   peComo                       2    const
     D   peImau                      15  2 const
     D   peCan1                      30  0 const
     D   peCan2                      30  0 const
     D   peCaa1                      30    const
     D   peCaa2                      30    const
     D   peUser                      10a   const options(*nopass:*omit)

      * ----------------------------------------------------------------- *
      * SVPSIN_obtSecPib():     Obtiene secuencia del CIP.                *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peTiic   ( input  ) Codigo de Tipo de Impuesto           *
      *          peFepa   ( input  ) Fecha de Pago Anio                   *
      *          peFepm   ( input  ) Fecha de Pago Mes                    *
      *          peComa   ( input  ) codigo de Mayor Auxiliar             *
      *          peNrma   ( input  ) Numero Mayor Auxiliar                *
      *          peRpro   ( input  ) Codigo Pcia. del Inder               *
      *                                                                   *
      * Retorna: Secuencia                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_obtSecPib...
     D                 pr             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_obtSecRet():     Obtiene secuencia del CNHRET              *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peTiic   ( input  ) Codigo de Tipo de Impuesto           *
      *          peFepa   ( input  ) Fecha de Pago Anio                   *
      *          peFepm   ( input  ) Fecha de Pago Mes                    *
      *          peComa   ( input  ) codigo de Mayor Auxiliar             *
      *          peNrma   ( input  ) Numero Mayor Auxiliar                *
      *          peRpro   ( input  ) Codigo Pcia. del Inder               *
      *                                                                   *
      * Retorna: Secuencia                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_obtSecRet...
     D                 pr             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTiic                       3    const
     D   peFepa                       4  0 const
     D   peFepm                       2  0 const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peRpro                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_obtSecNin(): Obtiene secuencia del NIN.                    *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSuc2   ( input  ) Sucursal                             *
      *          pefasa   ( input  ) Codigo de Tipo de Impuesto           *
      *          pefasm   ( input  ) Fecha de Pago Anio                   *
      *          pefasd   ( input  ) Fecha de Pago Mes                    *
      *          peLibr   ( input  ) Codigo de Libro                      *
      *          petic2   ( input  ) Tipo CPTE. SEC.                      *
      *          penras   ( input  ) Numero Asiento                       *
      *          pecomo   ( input  ) Codigo Moneda                        *

      * Retorna: Secuencia Asiento                                        *
      * ----------------------------------------------------------------- *
     D SVPSIN_obtSecNin...
     D                 pr             4  0
     D   peEmpr                       1    const
     D   peSuc2                       2    const
     D   pefasa                       4  0 const
     D   pefasm                       2  0 const
     D   pefasd                       2  0 const
     D   peLibr                       1  0 const
     D   petic2                       2  0 const
     D   penras                       7  0 const
     D   pecomo                       2    const

      * ------------------------------------------------------------ *
      * SVPSIN_getRvaXCob(): Retorna Rva Sola por Cobertura          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peRiec   (input)   Código de Riesgo                      *
      *     peXcob   (input)   Código de Cobertura                   *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Rva                                                 *
      * ------------------------------------------------------------ *

     D SVPSIN_getRvaXCob...
     D                 pr            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getFraXCob(): Retorna Fra Sola por Cobertura          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peRiec   (input)   Código de Riesgo                      *
      *     peXcob   (input)   Código de Cobertura                   *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Fra                                                 *
      * ------------------------------------------------------------ *

     D SVPSIN_getFraXCob...
     D                 pr            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFech                       8  0 options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SVPSIN_getPagXCob(): Retorna Pag Solo por Cobertura          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peRiec   (input)   Código de Riesgo                      *
      *     peXcob   (input)   Código de Cobertura                   *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: Rva                                                 *
      * ------------------------------------------------------------ *

     D SVPSIN_getPagXCob...
     D                 pr            25  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFech                       8  0 options(*omit:*nopass)
      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhopa(): Actualiza datos en el archivo Cnhopa          *
      *                                                                   *
      *          peDspa   ( input  ) Estrutura de Cnhopa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updCnhopa...
     D                 pr              n
     D   peDspa                            likeds( dsCnhopa_t ) const
      * ------------------------------------------------------------ *
      * SVPSIN_getCnhmop(): Retorna datos de Ordenes de Pago:        *
      *                     Devengadas.-                             *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de Pago                    *
      *     peDsop   ( output ) Estructura de Ordenes de Pago        *
      *     peDsopC  ( output ) Cantidad de Ordenes de Pago          *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getCnhmop...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDsop                            likeds ( DsCnhmop_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsopC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_chkCnhmop(): Valida si existe Ordenes de Pago         *
      *                     Devengadas.-                             *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod Area Tecnica                     *
      *     pePacp   ( input  ) Num Cbate de Pago                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_chkCnhmop...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setCnhmop(): Graba datos en el archivo Cnhmop              *
      *                                                                   *
      *          peDsop   ( input  ) Estrutura de Cnhmop                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setCnhmop...
     D                 pr              n
     D   peDsop                            likeds( dsCnhmop_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_updCnhmop(): Actualiza datos en el archivo Cnhmop          *
      *                                                                   *
      *          peDsop   ( input  ) Estrutura de Cnhmop                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updCnhmop...
     D                 pr              n
     D   peDsop                            likeds( dsCnhmop_t ) const
      * ----------------------------------------------------------------- *
      * SVPSIN_dltCnhmop(): Elimina datos en el archivo Cnhmop            *
      *                                                                   *
      *          peDsop   ( input  ) Estrutura de Cnhmop                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_dltCnhmop...
     D                 pr              n
     D   peDsop                            likeds( dsCnhmop_t ) const

      * ------------------------------------------------------------ *
      * SVPSIN_getGti981s(): Retorna datos de SPEEDWAY SINIESTROS    *
      *                      Facturas.-                              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peComa   ( input  ) Cod. May. Auxiliar                   *
      *     peNrma   ( input  ) Nro. May. Auxiliar                   *
      *     peTifa   ( input  ) Tipo Factura                         *
      *     peSufa   ( input  ) Sucursal Factura                     *
      *     peNrfa   ( input  ) Nro. Factura                         *
      *     peDs1s   ( output ) Estructura de Speedway Siniestros    *
      *     peDs1sC  ( output ) Cantidad de Speedway Siniestros      *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getGti981s...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peTifa                       2  0 const
     D   peSufa                       4  0 const
     D   peNrfa                       8  0 const
     D   peDs1s                            likeds ( DsGti981s_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDs1sC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_chkGti981s(): Valida si existe Speedway Siniestros    *
      *                      Facturas.-                              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peComa   ( input  ) Cod. May. Auxiliar                   *
      *     peNrma   ( input  ) Nro. May. Auxiliar                   *
      *     peTifa   ( input  ) Tipo Factura                         *
      *     peSufa   ( input  ) Sucursal Factura                     *
      *     peNrfa   ( input  ) Nro. Factura                         *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_chkGti981s...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peTifa                       2  0 const
     D   peSufa                       4  0 const
     D   peNrfa                       8  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setGti981s(): Graba datos en el archivo Gti981s            *
      *                                                                   *
      *          peDs1s   ( input  ) Estrutura de Gti981s                 *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setGti981s...
     D                 pr              n
     D   peDs1s                            likeds( dsGti981s_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_updGti981s(): Actualiza datos en el archivo Gti981s        *
      *                                                                   *
      *          peDs1s   ( input  ) Estrutura de Gti981s                 *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updGti981s...
     D                 pr              n
     D   peDs1s                            likeds( dsGti981s_t ) const
      * ----------------------------------------------------------------- *
      * SVPSIN_dltGti981s(): Elimina datos en el archivo Gti981s          *
      *                                                                   *
      *          peDs1s   ( input  ) Estrutura de Gti981s                 *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_dltGti981s...
     D                 pr              n
     D   peDs1s                            likeds( dsGti981s_t ) const

      * ------------------------------------------------------------ *
      * SVPSIN_updIGAant(): Actualiza IGA del RET anterior.-         *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peMoas   ( input  ) Modulo que genera el asiento         *
      *     peNrrf   ( input  ) Nro.ref.acceso retenciones anteriores*
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_updIGAant...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peMoas                       1    const
     D   peNrrf                       9  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getImportMonRes(): Retorna Importe de moneda reserva  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Numero de Beneficiario                *
      *     peSebe   (input)   Secuencia de Beneficiario             *
      *                                                              *
      * Retorna: Immr                                                *
      * ------------------------------------------------------------ *
     D SVPSIN_getImportMonRes...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const

      * ------------------------------------------------------------ *
      * SVPSIN_getCntopa(): Retorna datos de Cntopa                  *
      *                                                              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *     peDsPa   ( output ) Estructura de                        *
      *     peDsPaC  ( output ) Cantidad de                          *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getCntopa...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   peDsCn                            likeds ( DsCntopa_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsCnC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_chkCntopa(): Valida si existe Cntopa                  *
      *                                                              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Cod. Area Tecnica                    *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_chkCntopa...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setCntopa(): Graba datos en el archivo Cntopa              *
      *                                                                   *
      *          peDsCn   ( input  ) Estrutura de Cntopa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setCntopa...
     D                 pr              n
     D   peDsCn                            likeds( dsCntopa_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_updCntopa(): Actualiza datos en el archivo Cntopa          *
      *                                                                   *
      *          peDsCn   ( input  ) Estrutura de Cntopa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updCntopa...
     D                 pr              n
     D   peDsCn                            likeds( dsCntopa_t ) const
      * ----------------------------------------------------------------- *
      * SVPSIN_dltCntopa(): Elimina datos en el archivo Cntopa            *
      *                                                                   *
      *          peDsCn   ( input  ) Estrutura de Cntopa                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_dltCntopa...
     D                 pr              n
     D   peDsCn                            likeds( dsCntopa_t ) const

      * ------------------------------------------------------------ *
      * SVPSIN_getGti960(): Retorna datos de Gti960                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peNops   ( input  ) Nro. Op. Siniestro                   *
      *     peDs60   ( output ) Estructura de Gti960                 *
      *     peDs60C  ( output ) Cantidad de Siniestros               *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getGti960...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const
     D   peDs60                            likeds ( DsGti960_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDs60C                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_chkGti960(): Valida si existe Gti960                  *
      *                                                              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peNops   ( input  ) Nro. Op. Siniestro                   *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_chkGti960...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peNops                       7  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setGti960(): Graba datos en el archivo Gti960              *
      *                                                                   *
      *          peDs60   ( input  ) Estrutura de Gti960                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setGti960...
     D                 pr              n
     D   peDs60                            likeds( dsGti960_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_updGti960(): Actualiza datos en el archivo Gti960          *
      *                                                                   *
      *          peDs60   ( input  ) Estrutura de Gti960                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updGti960...
     D                 pr              n
     D   peDs60                            likeds( dsGti960_t ) const
      * ----------------------------------------------------------------- *
      * SVPSIN_dltGti960(): Elimina datos en el archivo Gti960            *
      *                                                                   *
      *          peDs60   ( input  ) Estrutura de Gti960                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_dltGti960...
     D                 pr              n
     D   peDs60                            likeds( dsGti960_t ) const

      * ------------------------------------------------------------ *
      * SVPSIN_getGti965(): Retorna datos de Gti965                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Siniestro                            *
      *     peNops   ( input  ) Nro. Op. Siniestro                   *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     pePacp   ( input  ) Nro. Orden Pago                      *
      *     peDs65   ( output ) Estructura de Gti960                 *
      *     peDs65C  ( output ) Cantidad de Siniestros               *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getGti965...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peDs65                            likeds ( DsGti965_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDs65C                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSIN_chkGti965(): Valida si existe Gti965                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     peSini   ( input  ) Siniestro                            *
      *     peNops   ( input  ) Nro. Op. Siniestro                   *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     pePacp   ( input  ) Nro. Orden Pago                      *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_chkGti965...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

      * ----------------------------------------------------------------- *
      * SVPSIN_setGti965(): Graba datos en el archivo Gti965              *
      *                                                                   *
      *          peDs65   ( input  ) Estrutura de Gti965                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_setGti965...
     D                 pr              n
     D   peDs65                            likeds( dsGti965_t ) const

      * ----------------------------------------------------------------- *
      * SVPSIN_updGti965(): Actualiza datos en el archivo Gti965          *
      *                                                                   *
      *          peDs65   ( input  ) Estrutura de Gti965                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_updGti965...
     D                 pr              n
     D   peDs65                            likeds( dsGti965_t ) const
      * ----------------------------------------------------------------- *
      * SVPSIN_dltGti965(): Elimina datos en el archivo Gti965            *
      *                                                                   *
      *          peDs65   ( input  ) Estrutura de Gti965                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPSIN_dltGti965...
     D                 pr              n
     D   peDs65                            likeds( dsGti965_t ) const

      * ------------------------------------------------------------ *
      * SVPSIN_getSiniestroXFecha(): Retorna Siniestros por fecha de *
      *                              ocurrencia.                     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Póliza                               *
      *     peFocu   ( input  ) Fecha de Ocurrencia del Siniestro    *
      *     peDsCd   ( output ) Estructura de Caratula de siniestro  *
      *     peDsCdC  ( output ) Cantidad de Registros                *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPSIN_getSiniestroXFecha...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFocu                       8  0 const
     D   peDsCd                            likeds ( DsPahscd_t ) dim(999)
     D   peDsCdC                     10i 0

