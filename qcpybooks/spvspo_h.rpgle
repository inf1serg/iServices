      /if defined(SPVSPO_H)
      /eof
      /endif
      /define SPVSPO_H

      * SuperPoliza Inexistente...
     D SPVSPO_SPINE    c                   const(0001)
      * Suplemento Inhabilitado...
     D SPVSPO_SUINH    c                   const(0002)
      * Suplemento Inexistente...
     D SPVSPO_SUINE    c                   const(0003)
      * Estado de SuperPoliza Invalido...
     D SPVSPO_ESTIN    c                   const(0004)
      * SuperPoliza Estado Suspendida Especial...
     D SPVSPO_ESTSE    c                   const(0005)
      * No se Encontro el Premio...
     D SPVSPO_NEPRE    c                   const(0006)
      * SuperPoliza con Cupones Pendientes de Entrega...
     D SPVSPO_CPENT    c                   const(0007)
      * SuperPoliza con Cuotas en Preliquidacion...
     D SPVSPO_CPPRE    c                   const(0008)
      * SuperPoliza con Emision Pendiente en Speedway...
     D SPVSPO_SPPSP    c                   const(0009)
      * Poliza/Suplemente sin Saldo...
     D SPVSPO_PSSSP    c                   const(0010)
      * Suplementos Anteriores sin Saldo...
     D SPVSPO_SASSA    c                   const(0011)
      * El Suplemento Corresponde a Otro Asegurado...
     D SPVSPO_SNMUS    c                   const(0012)
      * Poliza con Cambio de Asegurado...
     D SPVSPO_ANCPS    c                   const(0013)
      * Poliza Anulada...
     D SPVSPO_POLAN    c                   const(0014)
      * Articulo Inexistente en SET990...
     D SPVSPO_ER990    c                   const(0015)
      * SuperPoliza en Proceso...
     D SPVSPO_SPOPR    c                   const(0016)
      * SuperPoliza No Vigente...
     D SPVSPO_SPONV    c                   const(0017)
      * SuperPoliza Emitida Fuera del Rango...
     D SPVSPO_SPOFR    c                   const(0018)
      * SuperPoliza Sin Saldo...
     D SPVSPO_SPOSS    c                   const(0019)
      * SuperPoliza Sin Siniestros Denunciados...
     D SPVSPO_SPOSD    c                   const(0020)
      * SuperPoliza Con Siniestros en Pendientes..
     D SPVSPO_SPOSP    c                   const(0021)
      * SuperPoliza Sin Pagos Dentro del Rango...
     D SPVSPO_SPOPS    c                   const(0022)
      * Articulo Inexistente...
     D SPVSPO_ARCDI    c                   const(0023)
      * Sin Parametros para la Web...
     D SPVSPO_SINPA    c                   const(0024)
      * SuperPoliza no viaja a la Web...
     D SPVSPO_NOWEB    c                   const(0025)
      * No se Encontro el Prima...
     D SPVSPO_NEPRI    c                   const(0026)
      * SuperPoliza ya Renovada...
     D SPVSPO_SPYRE    c                   const(0027)
      * SuperPoliza Suspendida...
     D SPVSPO_SPSUS    c                   const(0028)
      * SuperPoliza Abierta...
     D SPVSPO_SPABI    c                   const(0029)
      * Cuota Inexistente...
     D SPVSPO_CUOIN    c                   const(0030)

      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SPVSPO_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * --------------------------------------------------- *
      * Estrucutura de datos SETWEB
      * --------------------------------------------------- *
     D setweb_t        ds                  qualified template
     D  t@empr                        1
     D  t@sucu                        2
     D  t@arcd                        6  0
     D  t@fech                        8  0
     D  t@secu                        5  0
     D  t@uemi                        1
     D  t@cemi                        5  0
     D  t@sald                       15  2
     D  t@upas                        1
     D  t@cpas                        5  0
     D  t@udes                        1
     D  t@cdes                        5  0
     D  t@tvha                        3  0
     D  t@mar1                        1
     D  t@mar2                        1
     D  t@mar3                        1
     D  t@mar4                        1
     D  t@mar5                        1
     D  t@rams                        2  0
     D  t@arcc                        6  0
     D  t@ramc                        2  0
     D  t@user                       10
     D  t@date                        6s 0
     D  t@time                        6s 0
      * --------------------------------------------------- *
      * Estrucutura de datos PAHEC3
      * --------------------------------------------------- *
     D dsPahec3_t      ds                  qualified template
     D  c3empr                        1
     D  c3sucu                        2
     D  c3arcd                        6  0
     D  c3spol                        9  0
     D  c3sspo                        3  0
     D  c3cert                        9  0
     D  c3nrpp                        3  0
     D  c3xdia                        5  0
     D  c3ccuo                        2  0
     D  c3ci1c                        1  0
     D  c3fb1c                        1  0
     D  c3dv1c                        2  0
     D  c3cimc                        1  0
     D  c3immc                       15  2
     D  c3dfde                        2  0
     D  c3dfha                        2  0
     D  c3dFv1                        2  0
     D  c3dfm1                        2  0
     D  c3dfv2                        2  0
     D  c3dfm2                        2  0
     D  c3mar1                        1
     D  c3mar2                        1
     D  c3mar3                        1
     D  c3mar4                        1
     D  c3mar5                        1
     D  c3strg                        1
     D  c3user                       10
     D  c3time                        6
     D  c3date                        6
     D  c3bpip                        5  2
      * --------------------------------------------------- *
      * Estrucutura de datos PAHCD5
      * --------------------------------------------------- *
     D dsPahcd5_t      ds                  qualified template
     D  d5empr                        1a
     D  d5sucu                        2a
     D  d5arcd                        6p 0
     D  d5spol                        9p 0
     D  d5sspo                        3p 0
     D  d5rama                        2p 0
     D  d5arse                        2p 0
     D  d5oper                        7p 0
     D  d5suop                        3p 0
     D  d5nrcu                        2p 0
     D  d5nrsc                        2p 0
     D  d5fvca                        4p 0
     D  d5fvcm                        2p 0
     D  d5fvcd                        2p 0
     D  d5mone                        2a
     D  d5imcu                       15p 2
     D  d5ctcu                        3p 0
     D  d5nrct                        7p 0
     D  d5ivr2                        6p 0
     D  d5nrrt                        7p 0
     D  d5nrlo                        4p 0
     D  d5nrcc                        7p 0
     D  d5cbrn                        7p 0
     D  d5czco                        7p 0
     D  d5nrla                        7a
     D  d5nrln                        9p 0
     D  d5cert                        9p 0
     D  d5cfpg                        1p 0
     D  d5poli                        7p 0
     D  d5sttc                        1a
     D  d5marp                        1a
     D  d5mar2                        1a
     D  d5strg                        1a
     D  d5user                       10a
     D  d5time                        6p 0
     D  d5date                        6p 0
     D  d5ivbc                        3p 0
     D  d5ivsu                        3p 0
     D  d5tcta                        2p 0
     D  d5mar3                        1a
     D  d5mar4                        1a
     D  d5cn02                        2p 0
     D  d5imau                       15p 2

     * - Estructura de PAHEC0 ------------------------------------- *
     D dsPahec0_t      ds                  qualified template
     D  c0empr                        1
     D  c0sucu                        2
     D  c0arcd                        6p 0
     D  c0spol                        9p 0
     D  c0cert                        9p 0
     D  c0mone                        2
     D  c0fipa                        4p 0
     D  c0fipm                        2p 0
     D  c0fipd                        2p 0
     D  c0fema                        4p 0
     D  c0femm                        2p 0
     D  c0femd                        2p 0
     D  c0fioa                        4p 0
     D  c0fiom                        2p 0
     D  c0fiod                        2p 0
     D  c0fvoa                        4p 0
     D  c0fvom                        2p 0
     D  c0fvod                        2p 0
     D  c0dupe                        2p 0
     D  c0asen                        7p 0
     D  c0cfpg                        1p 0
     D  c0opag                        7p 0
     D  c0ctcu                        3p 0
     D  c0nrtc                       20p 0
     D  c0ivbc                        3p 0
     D  c0ivsu                        3p 0
     D  c0tcta                        2p 0
     D  c0ncta                       25
     D  c0nrct                        7p 0
     D  c0ivr2                        6p 0
     D  c0nrrt                        7p 0
     D  c0nrlo                        4p 0
     D  c0nrla                        7
     D  c0nrln                        9p 0
     D  c0cbrn                        7p 0
     D  c0czco                        7p 0
     D  c0cocp                        1
     D  c0econ                        1
     D  c0fboa                        4p 0
     D  c0fbom                        2p 0
     D  c0fbod                        2p 0
     D  c0nivt                        1p 0
     D  c0nivc                        5p 0
     D  c0wcoa                        1p 0
     D  c0suas                       13p 0
     D  c0saca                       13p 0
     D  c0sacr                       13p 0
     D  c0sast                       13p 0
     D  c0spoa                        9p 0
     D  c0spon                        9p 0
     D  c0sema                        1p 0
     D  c0xpro                        3p 0
     D  c0mar1                        1
     D  c0mar2                        1
     D  c0mar3                        1
     D  c0mar4                        1
     D  c0mar5                        1
     D  c0strg                        1
     D  c0user                       10
     D  c0time                        6p 0
     D  c0date                        6p 0
     D  c0fhfa                        4p 0
     D  c0fhfm                        2p 0
     D  c0fhfd                        2p 0
     D  h0nivt                        1p 0
     D  h0nivc                        5p 0
     D  c0ncre                       15p 0
     D  c0ffca                        4p 0
     D  c0ffcm                        2p 0
     D  c0ffcd                        2p 0
     D  c0ccuo                        2p 0

     D dsPahec1_t      ds                  qualified template
     D  c1empr                        1
     D  c1sucu                        2
     D  c1arcd                        6p 0
     D  c1spol                        9p 0
     D  c1sspo                        3p 0
     D  c1xpro                        3p 0
     D  c1cert                        9p 0
     D  c1tiou                        1p 0
     D  c1stou                        2p 0
     D  c1stos                        2p 0
     D  c1mone                        2
     D  c1come                       15p 6
     D  c1civa                        2p 0
     D  c1fema                        4p 0
     D  c1femm                        2p 0
     D  c1femd                        2p 0
     D  c1fioa                        4p 0
     D  c1fiom                        2p 0
     D  c1fiod                        2p 0
     D  c1fvoa                        4p 0
     D  c1fvom                        2p 0
     D  c1fvod                        2p 0
     D  c1dupe                        2p 0
     D  c1asen                        7p 0
     D  c1cfpg                        1p 0
     D  c1opag                        7p 0
     D  c1ctcu                        3p 0
     D  c1nrtc                       20p 0
     D  c1ivbc                        3p 0
     D  c1ivsu                        3p 0
     D  c1tcta                        2p 0
     D  c1ncta                       25
     D  c1nrct                        7p 0
     D  c1ivr2                        6p 0
     D  c1nrrt                        7p 0
     D  c1nrlo                        4p 0
     D  c1nrla                        7
     D  c1nrln                        9p 0
     D  c1cbrn                        7p 0
     D  c1czco                        7p 0
     D  c1xcco                        5p 2
     D  c1cocp                        1
     D  c1econ                        1
     D  c1fboa                        4p 0
     D  c1fbom                        2p 0
     D  c1fbod                        2p 0
     D  c1nivt                        1p 0
     D  c1nivc                        5p 0
     D  c1wcoa                        1p 0
     D  c1suas                       13p 0
     D  c1saca                       13p 0
     D  c1sacr                       13p 0
     D  c1sast                       13p 0
     D  c1prim                       15p 2
     D  c1bpri                       15p 2
     D  c1refi                       15p 2
     D  c1read                       15p 2
     D  c1dere                       15p 2
     D  c1seri                       15p 2
     D  c1seem                       15p 2
     D  c1impi                       15p 2
     D  c1sers                       15p 2
     D  c1tssn                       15p 2
     D  c1ipr1                       15p 2
     D  c1ipr3                       15p 2
     D  c1ipr4                       15p 2
     D  c1ipr2                       15p 2
     D  c1ipr5                       15p 2
     D  c1ipr6                       15p 2
     D  c1ipr7                       15p 2
     D  c1ipr8                       15p 2
     D  c1ipr9                       15p 2
     D  c1prem                       15p 2
     D  c1bpre                       15p 2
     D  c1prco                       15p 2
     D  c1depp                       15p 2
     D  c1conr                        7p 0
     D  c1niv1                        5p 0
     D  c1niv2                        5p 0
     D  c1niv3                        5p 0
     D  c1niv4                        5p 0
     D  c1niv5                        5p 0
     D  c1niv6                        5p 0
     D  c1niv7                        5p 0
     D  c1niv8                        5p 0
     D  c1niv9                        5p 0
     D  c1free                        1
     D  c1ivsi                        1
     D  c1mar1                        1
     D  c1mar2                        1
     D  c1mar3                        1
     D  c1mar4                        1
     D  c1mar5                        1
     D  c1strg                        1
     D  c1user                       10
     D  c1time                        6p 0
     D  c1date                        6p 0
     D  h1nivt                        1p 0
     D  h1nivc                        5p 0
     D  h1xopr                        5p 2
     D  h1copr                       15p 2
     D  c1ncre                       15p 0
     D  c1ffca                        4p 0
     D  c1ffcm                        2p 0
     D  c1ffcd                        2p 0
     D  c1ccuo                        2p 0
     D  c1ruta                       16p 0
     D  c1vacc                       15p 2

     * - Estructura de PAHEC2 ------------------------------------- *
     D dsPahec2_t      ds                  qualified template
     D  c2empr                        1
     D  c2sucu                        2
     D  c2arcd                        6p 0
     D  c2spol                        9p 0
     D  c2sspo                        3p 0
     D  c2cbrn                        7p 0
     D  c2czco                        7p 0
     D  c2mone                        2
     D  c2cert                        9p 0
     D  c2nrdf                        7p 0
     D  c2cplc                        3p 0
     D  c2xcco                        5p 2
     D  c2xfno                        5p 2
     D  c2xfnn                        5p 2
     D  c2imvi                       15p 2
     D  c2bloq                        1
     D  c2mar1                        1
     D  c2mar2                        1
     D  c2mar3                        1
     D  c2mar4                        1
     D  c2mar5                        1
     D  c2user                       10
     D  c2time                        6p 0
     D  c2date                        6p 0
     D
      * --------------------------------------------------- *
      * Estrucutura de datos PAHEC3 Version 2
      * --------------------------------------------------- *
     D dsPahec3V2_t    ds                  qualified template
     D  c3empr                        1
     D  c3sucu                        2
     D  c3arcd                        6P 0
     D  c3spol                        9P 0
     D  c3sspo                        3P 0
     D  c3cert                        9P 0
     D  c3nrpp                        3P 0
     D  c3xdia                        5P 0
     D  c3ccuo                        2P 0
     D  c3ci1c                        1P 0
     D  c3fb1c                        1P 0
     D  c3dv1c                        2P 0
     D  c3cimc                        1P 0
     D  c3immc                       15P 2
     D  c3dfde                        2P 0
     D  c3dfha                        2P 0
     D  c3dFv1                        2P 0
     D  c3dfm1                        2P 0
     D  c3dfv2                        2P 0
     D  c3dfm2                        2P 0
     D  c3mar1                        1
     D  c3mar2                        1
     D  c3mar3                        1
     D  c3mar4                        1
     D  c3mar5                        1
     D  c3strg                        1
     D  c3user                       10
     D  c3time                        6P 0
     D  c3date                        6P 0
     D  c3bpip                        5P 2
     * - Estructura de PAHEC4 ------------------------------------- *
     D dsPahec4_t      ds                  qualified template
     D  c4empr                        1
     D  c4sucu                        2
     D  c4arcd                        6p 0
     D  c4spol                        9p 0
     D  c4sspo                        3p 0
     D  c4cert                        9p 0
     D  c4cobn                        7p 0
     D  c4soln                        7p 0
     D  c4mar1                        1
     D  c4mar2                        1
     D  c4mar3                        1
     D  c4mar4                        1
     D  c4mar5                        1
     D  c4strg                        1
     D  c4user                       10
     D  c4time                        6p 0
     D  c4date                        6p 0
     D  c4ref1                       20p 0
     D  c4ref2                       20p 0
     D  c4ref3                       25
     D  c4ref4                       25
     D  c4sarc                        7p 0
     D  c4rn03                       20p 0
     D  c4rn04                       20p 0
     D  c4rn05                       20p 0
     D  c4rn06                       20p 0
     D  c4rn07                       20p 0
     D  c4rn08                       20p 0
     D  c4rn09                       20p 0
     D  c4rn10                       20p 0
     D  c4ra03                       25
     D  c4ra04                       25
     D  c4ra05                       25
     D  c4ra06                       25
     D  c4ra07                       25
     D  c4ra08                       25
     D  c4ra09                       25
     D  c4ra10                       25
     D  c4ra11                       25
     D  c4ra12                       25
     D  c4ra13                       25
     D  c4ra14                       25
     D  c4ra15                       25
     D  c4ra16                       25
     D  c4ra17                       25
     D  c4ra18                       25
     D  c4ra19                       25
     D  c4ra20                       25
     D
     * - Estructura de PAHEC5 ------------------------------------- *
     D dsPahec5_t      ds                  qualified template
     D  c5empr                        1
     D  c5sucu                        2
     D  c5arcd                        6p 0
     D  c5spol                        9p 0
     D  c5sspo                        3p 0
     D  c5nord                        6p 0
     D  c5cert                        9p 0
     D  c5asen                        7p 0
     D  c5mar1                        1
     D  c5mar2                        1
     D  c5mar3                        1
     D  c5mar4                        1
     D  c5mar5                        1
     D  c5strg                        1
     D  c5user                       10
     D  c5time                        6p 0
     D  c5date                        6p 0
     D
     * - Estructura de PAHEC6 ------------------------------------- *
     D dsPahec6_t      ds                  qualified template
     D   c6empr                       1
     D   c6sucu                       2
     D   c6arcd                       6p 0
     D   c6spol                       9p 0
     D   c6sspo                       3p 0
     D   c6mone                       2
     D   c6por1                       5p 2
     D   c6por2                       5p 2
     D   c6por3                       5p 2
     D   c6por4                       5p 2
     D   c6por5                       5p 2
     D   c6por6                       5p 2
     D   c6por7                       5p 2
     D   c6por8                       5p 2
     D   c6por9                       5p 2
     D   c6por0                       5p 2
     D   c6imp1                      13p 2
     D   c6imp2                      13p 2
     D   c6imp3                      13p 2
     D   c6imp4                      13p 2
     D   c6imp5                      13p 2
     D   c6imp6                      13p 2
     D   c6imp7                      13p 2
     D   c6imp8                      13p 2
     D   c6imp9                      13p 2
     D   c6imp0                      13p 2
     D
     * - Estructura de PAHEC8 ------------------------------------- *
     D dsPahec8_t      ds                  qualified template
     D   c8empr                       1
     D   c8sucu                       2
     D   c8arcd                       6p 0
     D   c8spol                       9p 0
     D   c8fipa                       4p 0
     D   c8fipm                       2p 0
     D   c8fipd                       2p 0
     D   c8soli                       7p 0
     D   c8smin                       7p 0
     D   c8cant                       5p 0
     D   c8ffca                       4p 0
     D   c8ffcm                       2p 0
     D   c8ffcd                       2p 0
     D   c8mar1                       1
     D   c8mar2                       1
     D   c8mar3                       1
     D   c8mar4                       1
     D   c8mar5                       1
     D   c8strg                       1
     D   c8user                      10
     D   c8time                       6p 0
     D   c8date                       6p 0
     D
     * - Estructura de PAHEC9 ------------------------------------- *
     D dsPahec9_t      ds                  qualified template
     D   c9empr                       1
     D   c9sucu                       2
     D   c9arcd                       6p 0
     D   c9spol                       9p 0
     D   c9ivse                       5p 0
     D   c9cert                       9p 0
     D   c9econ                       1
     D   c9fboa                       4p 0
     D   c9fbom                       2p 0
     D   c9fbod                       2p 0
     D   c9mar1                       1
     D   c9mar2                       1
     D   c9mar3                       1
     D   c9mar4                       1
     D   c9mar5                       1
     D   c9strg                       1
     D   c9user                      10
     D   c9time                       6p 0
     D   c9date                       6p 0

     * - Estructura de PAHEG3 ------------------------------------- *
     D dsPaheg3_t      ds                  qualified template
     D  g3empr                        1
     D  g3sucu                        2
     D  g3arcd                        6p 0
     D  g3spol                        9p 0
     D  g3sspo                        3p 0
     D  g3rama                        2p 0
     D  g3arse                        2p 0
     D  g3oper                        7p 0
     D  g3suop                        3p 0
     D  g3rpro                        2p 0
     D  g3cert                        9p 0
     D  g3poli                        7p 0
     D  g3mone                        2
     D  g3come                       15p 6
     D  g3suas                       13p 0
     D  g3saca                       13p 0
     D  g3sacr                       13p 0
     D  g3sast                       13p 0
     D  g3prim                       15p 2
     D  g3bpri                       15p 2
     D  g3refi                       15p 2
     D  g3read                       15p 2
     D  g3dere                       15p 2
     D  g3seri                       15p 2
     D  g3seem                       15p 2
     D  g3ipr6                       15p 2
     D  g3ipr7                       15p 2
     D  g3ipr8                       15p 2
     D  g3prem                       15p 2
     D  g3mar1                        1
     D  g3mar2                        1
     D  g3mar3                        1
     D  g3mar4                        1
     D  g3mar5                        1
     D  g3strg                        1
     D  g3user                       10
     D  g3time                        6p 0
     D  g3date                        6p 0
     D  g3ipr1                       15p 2
     D  g3ipr3                       15p 2
     D  g3ipr4                       15p 2
     D  g3sefr                       15p 2
     D  g3sefe                       15p 2

     * - Estructura de PAHEG3 ------------------------------------- *
     D dsPaheg3p_t     ds                  qualified template
     D  gp3empr                       1
     D  gp3sucu                       2
     D  gp3arcd                       6p 0
     D  gp3spol                       9p 0
     D  gp3sspo                       3p 0
     D  gp3rama                       2p 0
     D  gp3arse                       2p 0
     D  gp3oper                       7p 0
     D  gp3suop                       3p 0
     D  gp3rpro                       2p 0
     D  gp3cert                       9p 0
     D  gp3poli                       7p 0
     D  gp3mone                       2
     D  gp3come                      15p 6
     D  gp3suas                      13p 0
     D  gp3saca                      13p 0
     D  gp3sacr                      13p 0
     D  gp3sast                      13p 0
     D  gp3prim                      15p 2
     D  gp3bpri                      15p 2
     D  gp3refi                      15p 2
     D  gp3read                      15p 2
     D  gp3dere                      15p 2
     D  gp3seri                      15p 2
     D  gp3seem                      15p 2
     D  gp3ipr6                      15p 2
     D  gp3ipr7                      15p 2
     D  gp3ipr8                      15p 2
     D  gp3prem                      15p 2
     D  gp3mar1                       1
     D  gp3mar2                       1
     D  gp3mar3                       1
     D  gp3mar4                       1
     D  gp3mar5                       1
     D  gp3strg                       1
     D  gp3user                      10
     D  gp3time                       6p 0
     D  gp3date                       6p 0
     D  gp3ipr1                      15p 2
     D  gp3ipr3                      15p 2
     D  gp3ipr4                      15p 2
     D  gp3sefr                      15p 2
     D  gp3sefe                      15p 2

     * - Estructura de PAHEC7 ------------------------------------- *
     D dsPahec7_t      ds                  qualified template
     D  c7Empr                        1
     D  c7Sucu                        2
     D  c7Arcd                        6p 0
     D  c7Spol                        9p 0
     D  c7Sspo                        3p 0
     D  c7Xpro                        3p 0
     D  c7Nbpi                       40
     D  c7Rfxa                       40
     D  c7Ment                       40
     D  c7Mar1                        1
     D  c7Mar2                        1
     D  c7Mar3                        1
     D  c7Mar4                        1
     D  c7Mar5                        1
     D  c7Mar6                        1
     D  c7Mar7                        1
     D  c7Mar8                        1
     D  c7Mar9                        1
     D  c7User                       10
     D  c7Time                        6p 0
     D  c7Date                        8p 0
     D  c7Pcbr                        5p 2
     D  c7Icbr                       15p 2

     * - Estructura de PAHEC0C ------------------------------------- *
     D dsPahec0c_t     ds                  qualified template
     D  ccEmpr                        1
     D  ccSucu                        2
     D  ccArcd                        6p 0
     D  ccSpol                        9p 0
     D  ccArca                        6p 0
     D  ccSpoa                        9p 0
     D  ccArcn                        6p 0
     D  ccSpon                        9p 0
     D  ccMar1                        1
     D  ccMar2                        1
     D  ccMar3                        1
     D  ccMar4                        1
     D  ccMar5                        1
     D  ccuser                       10
     D  cctime                        6p 0
     D  ccdate                        6p 0

     * - Estructura de PAHCD6 -------------------------------------- *
     D dsPahcd6_t      ds                  qualified template
     D  d6empr                        1a
     D  d6sucu                        2a
     D  d6arcd                        6p 0
     D  d6spol                        9p 0
     D  d6sspo                        3p 0
     D  d6rama                        2p 0
     D  d6arse                        2p 0
     D  d6oper                        7p 0
     D  d6suop                        3p 0
     D  d6nrcu                        2p 0
     D  d6nrsc                        2p 0
     D  d6psec                        2p 0
     D  d6mone                        2a
     D  d6ivco                       15p 6
     D  d6prem                       15p 2
     D  d6depp                       15p 2
     D  d6coco                        1p 0
     D  d6fasa                        4p 0
     D  d6fasm                        2p 0
     D  d6fasd                        2p 0
     D  d6nras                        6p 0
     D  d6cert                        9p 0
     D  d6poli                        7p 0
     D  d6cfpg                        1p 0
     D  d6marp                        1a
     D  d6mar2                        1a
     D  d6c4se                        5p 0
     D  d6c4s3                        5p 0
     D  d6mar3                        1a
     D  d6ivnr                        6p 0
     D  d6mar4                        1a
     D  d6strg                        1a
     D  d6c4s2                        3p 0
     D  d6user                       10a
     D  d6time                        6p 0
     D  d6date                        6p 0
     D  d6rpaa                        4p 0
     D  d6rpmm                        2p 0
     D  d6rpdd                        2p 0
     D  d6mar5                        1a
     D  d6imau                       15p 2
     D  d6endo                        7p 0
     D  d6spo2                        9p 0

     * - Estructura de PAHCD7  ------------------------------------- *
     D dsPahcd7_t      ds                  qualified template
     D  d7empr                        1a
     D  d7sucu                        2a
     D  d7nras                        6s 0
     D  d7c4se                        5s 0
     D  d7mone                        2a
     D  d7fasa                        4s 0
     D  d7fasm                        2s 0
     D  d7fasd                        2s 0
     D  d7imco                       15s 6
     D  d7imme                       15s 2
     D  d7imau                       15s 2
     D  d7deha                        1s 0
     D  d7nrcm                       11s 0
     D  d7coma                        2a
     D  d7nrma                        7s 0
     D  d7esma                        1s 0
     D  d7copt                       25a
     D  d7nrrf                        9s 0
     D  d7fera                        4s 0
     D  d7ferm                        2s 0
     D  d7ferd                        2s 0
     D  d7marp                        1a
     D  d7mar2                        1a
     D  d7strg                        1a
     D  d7c4s2                        3s 0
     D  d7user                       10a
     D  d7time                        6s 0
     D  d7date                        6s 0
     D  d7gens                        3s 0
     D  d7core                        3a
     D  d7dup2                        2s 0
     D  d7cobr                       15s 2
     D  d7ribb                       15s 2
     D  d7ribi                       15s 2
     D  d7rsss                       15s 2
     D  d7rotr                       15s 2
     D  d7mar3                        1a
     D  d7mar4                        1a
     D  d7impo                       15s 2
     D  d7oper                        7s 0
     D  d7pecu                        3s 0
     D  d7ivnr                        6s 0
     D  d7ivn2                        6s 0
     D  d7ope2                        7s 0
     D  d7nrr2                        9s 0
     D  d7mar5                        1a
     D  d7mar6                        1a
     D  d7cor2                        3a
     D  d7rpaa                        4s 0
     D  d7rpmm                        2s 0
     D  d7rpdd                        2s 0

     * - Estructura de PAHCC2  ------------------------------------- *
     D dsPahcc2_t      ds                  qualified template
     D  c2empr                        1a
     D  c2sucu                        2a
     D  c2arcd                        6s 0
     D  c2spol                        9s 0
     D  c2sspo                        3s 0
     D  c2nrcu                        2s 0
     D  c2nrsc                        2s 0
     D  c2fvca                        4s 0
     D  c2fvcm                        2s 0
     D  c2fvcd                        2s 0
     D  c2mone                        2a
     D  c2imcu                       15s 2
     D  c2ctcu                        3s 0
     D  c2nrct                        7s 0
     D  c2ivr2                        6s 0
     D  c2nrrt                        7s 0
     D  c2nrlo                        4s 0
     D  c2nrcc                        7s 0
     D  c2cbrn                        7s 0
     D  c2czco                        7s 0
     D  c2nrla                        7a
     D  c2nrln                        9s 0
     D  c2cert                        9s 0
     D  c2cfpg                        1s 0
     D  c2sttc                        1a
     D  c2marp                        1a
     D  c2mar2                        1a
     D  c2strg                        1a
     D  c2user                       10a
     D  c2time                        6s 0
     D  c2date                        6s 0
     D  c2ivbc                        3s 0
     D  c2ivsu                        3s 0
     D  c2tcta                        2s 0
     D  c2mar3                        1a
     D  c2mar4                        1a
     D  c2cn02                        2s 0
     D  c2imau                       15s 2

     * - Estructura de PAHCC3  ------------------------------------- *
     D dsPahcc3_t      ds                  qualified template
     D  c3empr                        1a
     D  c3sucu                        2a
     D  c3arcd                        6s 0
     D  c3spol                        9s 0
     D  c3sspo                        3s 0
     D  c3nrcu                        2s 0
     D  c3nrsc                        2s 0
     D  c3psec                        2s 0
     D  c3mone                        2a
     D  c3ivco                       15s 6
     D  c3prem                       15s 2
     D  c3depp                       15s 2
     D  c3coco                        1s 0
     D  c3fasa                        4s 0
     D  c3fasm                        2s 0
     D  c3fasd                        2s 0
     D  c3nras                        6s 0
     D  c3cert                        9s 0
     D  c3cfpg                        1s 0
     D  c3marp                        1a
     D  c3mar2                        1a
     D  c3c4se                        5s 0
     D  c3mar3                        1a
     D  c3ivnr                        6s 0
     D  c3mar4                        1a
     D  c3strg                        1a
     D  c3c4s2                        3s 0
     D  c3user                       10a
     D  c3time                        6s 0
     D  c3date                        6s 0
     D  c3rpaa                        4s 0
     D  c3rpmm                        2s 0
     D  c3rpdd                        2s 0
     D  c3mar5                        1a
     D  c3imau                       15s 2
     D  c3endo                        7s 0
     D  c3spo2                        9s 0

     * - Estructura de SSNP04  ------------------------------------- *
     D dsSsnp04_t      ds                  qualified template
     D  p0empr                        1a
     D  p0sucu                        2a
     D  p0fech                        8s 0
     D  p0time                        6s 0
     D  p0user                       10a

     * - Estructura de Intermediario ------------------------------- *
     D intermediario   ds                  qualified
     D                                     based(template)
     D  ponivt                        1p 0
     D  ponivc                        5p 0

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

     D SPVSPO_chkSpol...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

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

     D SPVSPO_chkSspo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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

     D SPVSPO_getStatusIng...
     D                 pr             1
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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

     D SPVSPO_getSuspEsp...
     D                 pr             1
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_getSaldo(): Obtiene Saldo de Poliza                   *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Saldo                                               *
      * ------------------------------------------------------------ *

     D SPVSPO_getSaldo...
     D                 pr            15  2
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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

     D SPVSPO_getPremio...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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

     D SPVSPO_getCuotas...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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

     D SPVSPO_chkCuotasPend...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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

     D SPVSPO_chkCuotasPreli...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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

     D SPVSPO_chkPenSpwy...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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
     D SPVSPO_chkPenSpeedway...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_chkSaldo(): Chequea Tiene Saldo                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVSPO_chkSaldo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVSPO_inz      pr

      * ------------------------------------------------------------ *
      * SPVSPO_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVSPO_end      pr

      * ------------------------------------------------------------ *
      * SPVSPO_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SPVSPO_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

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

     D SPVSPO_chkSaldoSupAnt...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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

     D SPVSPO_chkAsen...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peAsen                       7  0 const

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

     D SPVSPO_chkAnulada...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_getHastaFac(): Obtiene el hasta facturado (AAAAMMDD)  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: Hasta Facturado (AAAAMMDD)                          *
      * ------------------------------------------------------------ *

     D SPVSPO_getHastaFac...
     D                 pr             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_getSpol(): Retorna Numero de Super Poliza             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peGrab   (input)   Marca de Actualizar Set990            *
      *                                                              *
      * Retorna: Nro de SuperPoliza                                  *
      * ------------------------------------------------------------ *

     D SPVSPO_getSpol...
     D                 pr             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peGrab                       1    options(*Nopass:*Omit)

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

     D SPVSPO_chkSpolEnProc...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

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

     D SPVSPO_getFdp...
     D                 pr             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

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

     D SPVSPO_getAsen...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVSPO_chkVig() Chequea vigencia de Poliza desde determinada *
      *                 fecha                                        *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peFech   (input)   Fecha busqueda                        *
      *     peFemi   (input)   Fecha emision                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVSPO_chkVig...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFech                       8  0 options(*nopass:*omit)
      *     peFech   (input)   Fecha busqueda                        *
     D   peFemi                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVSPO_getFecEmi() Obtiene Fecha de Emision                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVSPO_getFecEmi...
     D                 pr             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_chkWeb() Retorna si viaja a la Web                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peErro   (output)  Vector de erorres                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVSPO_chkWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                      80    dim(99)

      * ------------------------------------------------------------ *
      * SPVSPO_getParWeb Retorna Parametría Web                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRweb   (output)  Registro de SetWeb                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVSPO_getParWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRweb                            likeds(setweb_t)
     D                                     options( *omit : *nopass )

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

     D SPVSPO_getFecVig...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFecd                       8  0 options(*Omit:*Nopass)
     D   peFech                       8  0 options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SPVSPO_getProducto(): Retorna Codigo de Producto             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: Codigo de Producto                                  *
      * ------------------------------------------------------------ *

     D SPVSPO_getProducto...
     D                 pr             3  0
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
     D SPVSPO_getDiasFacturacionEndoso...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peFecd                       8  0 options(*Omit:*Nopass)
     D   peFech                       8  0 options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SPVSPO_getRama(): Retorna Rama                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento Poliza                     *
      *                                                              *
      * Retorna: Rama / -1                                           *
      * ------------------------------------------------------------ *

     D SPVSPO_getRama...
     D                 pr             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSSpo                       3  0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SPVSPO_getPoliza(): Retorna Poliza                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento Poliza                     *
      *                                                              *
      * Retorna: Poliza                                              *
      * ------------------------------------------------------------ *

     D SPVSPO_getPoliza...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSSpo                       3  0 options(*nopass:*omit)
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

     D SPVSPO_getProductor...
     D                 pr            40
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peNivt                       1  0 options( *nopass : *omit )
     D   peNivc                       5  0 options( *nopass : *omit )

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

     D SPVSPO_getMone...
     D                 pr             2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
      * ------------------------------------------------------------ *
      * SPVSPO_getSumaAsegurada(): Retorna moneda                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Suma / -1                                           *
      * ------------------------------------------------------------ *

     D SPVSPO_getSumaAsegurada...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )

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

     D SPVSPO_getSumaAseguradaEnPesos...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )

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

     D SPVSPO_getPolizaAnterior...
     D                 pr             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
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

     D SPVSPO_getPrima...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

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
     D SPVSPO_chkSpolRenovada...
     D                 pr             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_chkSpolSuspendida()Verifica si la Spol Suspendida     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVSPO_chkSpolSuspendida...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_getFormaDePago(): Retorna la Forma de Pago de un      *
      *                          Suplemento                          *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Forma de Pago / -1 Error                            *
      * ------------------------------------------------------------ *

     D SPVSPO_getFormaDePago...
     D                 pr             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

      * ------------------------------------------------------------- *
      * SPVSPO_getRecAdministrativo(): Retorna Recargo administrativo *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peArcd   (input)   Codigo de Articulo                     *
      *     peSpol   (input)   Numero de SuperPoliza                  *
      *     peRama   (input)   Rama                                   *
      *     peArse   (input)   Cantidad de Polizas                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SPVSPO_getRecAdministrativo...
     D                 pr             5  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   PeArse                       2  0 const
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

     D SPVSPO_getHastaFacturado...
     D                 pr             8  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ **
      * SPVSPO_getCodigoIva(): Retorna Codigo de IVA                 **
      *                                                              **
      *     peEmpr   (input)   Empresa                               **
      *     peSucu   (input)   Sucursal                              **
      *     peArcd   (input)   Codigo de Articulo                    **
      *     peSpol   (input)   Numero de SuperPoliza                 **
      *                                                              **
      * Retorna: Codigo de IVA                                       **
      * ------------------------------------------------------------ **
     D SPVSPO_getCodigoIva...
     D                 pr             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

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

     D SPVSPO_getTipoOperacion...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)
     D   peTiou                       1  0 options(*nopass:*omit)
     D   peStou                       2  0 options(*nopass:*omit)
     D   peStos                       2  0 options(*nopass:*omit)

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

     D SPVSPO_getPlanDePago...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peDec3                            likeds( dsPahec3_t )
     D                                     options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SPVSPO_getCodPlanDePago: Retorna Plan de Pago x Suplemento   *
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

     D SPVSPO_getCodPlanDePago...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )

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

     D SPVSPO_getPolizaAbierta...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_chkCuotasPendientes(): Chequea Cuotas Pendientes      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On = Pendientes / *Off = No hay pendientes         *
      * ------------------------------------------------------------ *

     D SPVSPO_chkCuotasPendientes...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peNrcu                       2  0 options( *nopass : *omit )
     D   peNrsc                       2  0 options( *nopass : *omit )

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
     D SPVSPO_getCuotasEmitidas...
     D                 pr              n
     D   peEmpr                       1    Const
     D   peSucu                       2    Const
     D   peArcd                       6  0 Const
     D   peSpol                       9  0 Const
     D   peSspo                       3  0 Options( *Nopass : *Omit ) Const
     D   peRama                       2  0 Options( *Nopass : *Omit ) Const
     D   PeArse                       2  0 Options( *Nopass : *Omit ) Const
     D   peOper                       7  0 Options( *Nopass : *Omit ) Const
     D   peSuop                       3  0 Options( *Nopass : *Omit ) Const
     D   peDsCD5                           Likeds( dsPahcd5_t )
     D                                     Options( *Nopass: *Omit ) Dim(99)
     D   peDsCD5                     10i 0 Options( *Nopass: *Omit )

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
     D SPVSPO_getCantidadCuotasEmitidas...
     D                 pr             2  0
     D   peEmpr                       1    Const
     D   peSucu                       2    Const
     D   peArcd                       6  0 Const
     D   peSpol                       9  0 Const
     D   peSspo                       3  0 Options( *Nopass : *Omit ) Const
     D   peRama                       2  0 Options( *Nopass : *Omit ) Const
     D   PeArse                       2  0 Options( *Nopass : *Omit ) Const
     D   peOper                       7  0 Options( *Nopass : *Omit ) Const
     D   peSuop                       3  0 Options( *Nopass : *Omit ) Const

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

     D SPVSPO_chkCuotaPaga...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const

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
     D SPVSPO_chkCuotaPermiteRecibo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const

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
     D SPVSPO_chkAnuladaV2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFech                       8  0 Options( *Nopass: *Omit )

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

     D SPVSPO_getCuotasImpagas...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 Options(*Nopass:*Omit) Const

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
     D SPVSPO_getCuotasImpagasMes...
     D                 pr             5  0
     D   peEmpr                       1    Const
     D   peSucu                       2    Const
     D   peArcd                       6  0 Const
     D   peSpol                       9  0 Const
     D   peFech                       8  0 Options( *Nopass : *Omit )

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
     D SPVSPO_chkSuspEsp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     * ------------------------------------------------------------ *
     * SPVSPO_getCabeceraSuplemento: Retorna Cabecera de Suplemento *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento de SuperPoliza (opcional) *
     *     peDsC1   ( output ) Esrtuctura de Cabecera Sup(opcional) *
     *     peDsC1C  ( output ) Cantidad de Cabecera Sup  (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SPVSPO_getCabeceraSuplemento...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )const
     D   peDsC1                            likeds ( dsPahec1_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsC1C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SPVSPO_chkBloqueo(): Verificar si Superpoliza esta bloqueada *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Codigo de Articulo                    *
     *     peSpol   (input)   Numero de SuperPoliza                 *
     *                                                              *
     * Retorna: *on = Bloqueada / *off = No Bloqueada               *
     * ------------------------------------------------------------ *
     D SPVSPO_chkBloqueo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     * ------------------------------------------------------------ *
     * SPVSPO_getNuevoSuplemento: Obtener nuevo numero de suplemento*
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Codigo de Articulo                    *
     *     peSpol   (input)   Numero de SuperPoliza                 *
     *                                                              *
     * Retorna: 0 = No se pudo obtener / <> 0 = nuevo numero        *
     * ------------------------------------------------------------ *
     D SPVSPO_getNuevoSuplemento...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     * ------------------------------------------------------------ *
     * SPVSPO_setCabeceraSuplemento: Graba Cabecera de Suplemento   *
     *                                                              *
     *     peDsC1  (  input  )  Estructura de Suplemento            *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D  SPVSPO_setCabeceraSuplemento...
     D                 pr              n
     D   peDsC1                            likeds( dsPahec1_t ) const

     * ------------------------------------------------------------ *
     * SPVSPO_chkCabecera: Valida Cabecera de SuperPoliza           *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_chkCabecera...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     * ------------------------------------------------------------ *
     * SPVSPO_getCabecera: Retorna Cabecera de SuperPoliza          *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *     peDsC0  (  output )  Estructura de Cabecera              *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_getCabecera...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peDsC0                            likeds( dsPahec0_t )

     * ------------------------------------------------------------ *
     * SPVSPO_setCabecera : Graba Cabecera de SuperPoliza           *
     *                                                              *
     *     peDsC0  (  input  )  Estructura de Cabecera              *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D  SPVSPO_setCabecera...
     D                 pr              n
     D   peDsC0                            likeds( dsPahec0_t ) const

     * ------------------------------------------------------------ *
     * SPVSPO_chkComisionCobranza: Valida Comision Cobranza         *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *     peSspo  (  input  )  Suplemento             ( opcional ) *
     *     peCbrn  (  input  )  Nivel de Intermediario ( opcional ) *
     *     peCzco  (  input  )  Zona de Cobranza       ( opcional ) *
     *     peMone  (  input  )  Código de moneda       ( opcional ) *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_chkComisionCobranza...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit) const
     D   peCbrn                       7  0 options(*nopass:*omit) const
     D   peCzco                       7  0 options(*nopass:*omit) const
     D   peMone                       2    options(*nopass:*omit) const

     * ------------------------------------------------------------ *
     * SPVSPO_getComisionCobranza: Retorna Comision de Cobranza     *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *     peSspo  (  input  )  Suplemento             ( opcional ) *
     *     peCbrn  (  input  )  Nivel de Intermediario ( opcional ) *
     *     peCzco  (  input  )  Zona de Cobranza       ( opcional ) *
     *     peMone  (  input  )  Código de moneda       ( opcional ) *
     *     peDsC2  (  output )  Estructura de Cobranza ( opcional ) *
     *     peDsC2C (  output )  Cantidad de Cobranza   ( opcional ) *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_getComisionCobranza...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit) const
     D   peCbrn                       7  0 options(*nopass:*omit) const
     D   peCzco                       7  0 options(*nopass:*omit) const
     D   peMone                       2    options(*nopass:*omit) const
     D   peDsC2                            likeds( dsPahec2_t )
     D                                     options(*nopass:*omit)dim(999)
     D   peDsC2C                     10i 0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SPVSPO_setComisionCobranza: Graba Comision Cobranza          *
     *                                                              *
     *     peDsC2  (  input  )  Estructura de Cobranza              *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D  SPVSPO_setComisionCobranza...
     D                 pr              n
     D   peDsC2                            likeds( dsPahec2_t ) const

     * ------------------------------------------------------------ *
     * SPVSPO_chkPlanDePago: Valida Plan de Pago                    *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *     peSspo  (  input  )  Suplemento          ( opcional )    *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_chkPlanDePago...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SPVSPO_setPlanDePago: Grabar Plan de Pago                    *
     *                                                              *
     *     peDsc3  (  output )  Est. Plan de Pago                   *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_setPlanDePago...
     D                 pr              n
     D   peDsC3                            const likeds( dsPahec3V2_t )

     * ------------------------------------------------------------ *
     * SPVSPO_chkReferencias: Valida Referencia                     *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *     peSspo  (  input  )  Suplemento          ( opcional )    *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_chkReferencias...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SPVSPO_setReferencias: Grabar Referencia                     *
     *                                                              *
     *     peDsc4  (  output ) Est. Referencias                     *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_setReferencias...
     D                 pr              n
     D   peDsC4                            const likeds( dsPahec4_t )

     * ------------------------------------------------------------ *
     * SPVSPO_getReferencias: Retorna Referencias                   *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *     peSspo  (  input  )  Suplemento           ( opcional )   *
     *     peDsC4  (  output )  Est. Referencias     ( opcional )   *
     *     peDsC4C (  output )  Cant.Referencias      ( opcional )  *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_getReferencias...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *nopass : *omit )
     D   peDsC4                            likeds( dsPahec4_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsC4C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SPVSPO_chkBeneficiario: Valida Beneficiaro                   *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *     peSspo  (  input  )  Suplemento          ( opcional )    *
     *     peNord  (  input  )  Nro de Orden        ( opcional )    *
     *     peAsen  (  input  )  Nro Asegurado       ( opcional )    *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_chkBeneficiario...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *nopass : *omit )
     D   peNord                       6  0 const options( *nopass : *omit )
     D   peAsen                       7  0 const options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SPVSPO_getBeneficiarios: Retorna Beneficiarios               *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *     peSspo  (  input  )  Suplemento          ( opcional )    *
     *     peNord  (  input  )  Nro de Orden        ( opcional )    *
     *     peAsen  (  input  )  Nro Asegurado       ( opcional )    *
     *     peDsC5  (  output )  Est. Beneficiarios  ( opcional )    *
     *     peDsC5C (  output )  Cant. de Benef.     ( opcional )    *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_getBeneficiarios...
     D                 pr              n
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

     * ------------------------------------------------------------ *
     * SPVSPO_setBeneficiarios : Graba Datos de Beneficiaros        *
     *                                                              *
     *     peDsC5  (  input  )  Estructura de Beneficiaros          *
     *     peDsC5C (  input  )  Cantidad de Beneficiaros            *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D  SPVSPO_setBeneficiarios...
     D                 pr              n
     D   peDsC5                            likeds( dsPahec5_t ) const

     * ------------------------------------------------------------ *
     * SPVSPO_chkAsegurado: Valida Asegurado                        *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peAsen  (  input  )  Nro Asegurado                       *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  Super Poliza                        *
     *     peSspo  (  input  )  Suplemento          ( opcional )    *
     *     peNord  (  input  )  Nro de Orden        ( opcional )    *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_chkAsegurado...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options( *nopass : *omit )
     D   peNord                       6  0 const options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SPVSPO_setPrimaxProvincia: Primas por Provincia              *
     *                                                              *
     *     peDsEg  (  input  )  Estructura de Primas x Prov         *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D  SPVSPO_setPrimaxProvincia...
     D                 pr              n
     D   peDsEg                            likeds( dsPaheg3_t ) const

     * ------------------------------------------------------------ *
     * SPVSPO_chkPrimaxProvincia: Primas por Provincia              *
     *                                                              *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  SuperPoliza                         *
     *     peSspo  (  input  )  Suplemento                          *
     *     peRama  (  input  )  Rama                                *
     *     peArse  (  input  )  Cant. Polizas                       *
     *     peOper  (  input  )  Operacion                           *
     *     peSuop  (  input  )  Suplemento Operacion                *
     *     peRpro  (  input  )  Provincia Inder                     *
     *                                                              *
     * Retorna: *on = Encontro / *off = No Encontro                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_chkPrimaxProvincia...
     D                 pr              n
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

     * ------------------------------------------------------------ *
     * SPVSPO_dltPrimaxProvincia: Elimina Primas por Provincia      *
     *                                                              *
     *     peDsEg  (  input  )  Estructura de Primas x Prov         *
     *                                                              *
     * Retorna: *on = Elimino ok / *off = No Eliminio               *
     * ------------------------------------------------------------ *
     D  SPVSPO_dltPrimaxProvincia...
     D                 pr              n
     D   peDsEg                            likeds( dsPaheg3_t ) const

     * ------------------------------------------------------------ *
     * SPVSPO_setPrimxProvRegSimp: Prima por Provincia Regimen      *
     *                             Simplificado                     *
     *                                                              *
     *     peDsEp  (  input  )  Estructura de Primas x Prov Reg Sim *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D  SPVSPO_setPrimxProvRegSimp...
     D                 pr              n
     D   peDsEp                            likeds( dsPaheg3p_t ) const

     * ------------------------------------------------------------ *
     * SPVSPO_chkPrimxProvRegSimp: Primas por Provincia Regimen     *
     *                             simplificado                     *
     *     peEmpr  (  input  )  Empresa                             *
     *     peSucu  (  input  )  Sucursal                            *
     *     peArcd  (  input  )  Articulo                            *
     *     peSpol  (  input  )  SuperPoliza                         *
     *     peSspo  (  input  )  Suplemento                          *
     *     peRama  (  input  )  Rama                                *
     *     peArse  (  input  )  Cant. Polizas                       *
     *     peOper  (  input  )  Operacion                           *
     *     peSuop  (  input  )  Suplemento Operacion                *
     *     peRpro  (  input  )  Provincia Inder                     *
     *                                                              *
     * Retorna: *on = Encontro / *off = No Encontro                 *
     * ------------------------------------------------------------ *
     D  SPVSPO_chkPrimxProvRegSimp...
     D                 pr              n
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

     * ------------------------------------------------------------ *
     * SPVSPO_dltPrimxProvRegSimp: Elimina Prima por Provincia      *
     *                             Regimen Simplificado             *
     *                                                              *
     *     peDsEp  (  input  )  Estructura de Primas x Prov Reg Sim *
     *                                                              *
     * Retorna: *on = Elimino ok / *off = No Elimino                *
     * ------------------------------------------------------------ *
     D  SPVSPO_dltPrimxProvRegSimp...
     D                 pr              n
     D   peDsEp                            likeds( dsPaheg3p_t ) const

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

     D SPVSPO_getPlanDePagoV2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peDec3                            likeds( dsPahec3V2_t )
     D                                     options( *nopass : *omit )

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
     D SPVSPO_getUltimoSuplemento...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

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
     D SPVSPO_getDatosProgramasInternacionales...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )
     D   peDec7                            likeds( dsPahec7_t )
     D                                     options( *nopass : *omit )

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
     D SPVSPO_isNominaExterna...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNomi                       7  0 options( *nopass : *omit )

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
     D SPVSPO_getCadenaComercial...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peCade                       5  0 dim(9)
     D   peSspo                       3  0 const options(*nopass:*omit)

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
     D  SPVSPO_getPahec0c...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peDs0C                            likeds( dsPahec0c_t )

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
     D SPVSPO_getSuperpolizaAnterior...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peArca                       6  0
     D   peSpoa                       9  0

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
     D SPVSPO_getSuperpolizaPosterior...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peArcn                       6  0
     D   peSpon                       9  0

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
     D SPVSPO_isNueva...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

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
     D SPVSPO_isRenovacion...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

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
     D SPVSPO_isWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

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
     D SPVSPO_getUltimoPeriodoCurso...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_updPlanDePago: Actualiza Plan de Pago                 *
     ?*                                                              *
     ?*     peDsc3  (  output )  Est. Plan de Pago                   *
     ?*                                                              *
     ?* Retorna: *on = Encontró / *off = No Encontró                 *
     ?* ------------------------------------------------------------ *
     D  SPVSPO_updPlanDePago...
     D                 pr              n
     D   peDsC3                            const likeds( dsPahec3V2_t )

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
     D SPVSPO_getPahcd6...
     D                 pr              n
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
     D SPVSPO_chkPahcd6...
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
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   pePsec                       2  0 const

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPahcd6: Graba Pagos de cuotas                      *
     ?*                                                              *
     ?*     peDsD6  (  input  )  Estructura de Pahcd6                *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     D  SPVSPO_setPahcd6...
     D                 pr              n
     D   peDsD6                            likeds( dsPahcd6_t ) const

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
     D  SPVSPO_getUltSecuncia...
     D                 pr             2  0
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

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getPahcc2: Retorna datos del PAHCC2                   *
     ?*                                                              *
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
     D SPVSPO_getPahcc2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )const
     D   peNrcu                       2  0 options( *nopass : *omit )const
     D   peDsC2                            likeds ( dsPahcc2_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsC2C                     10i 0 options( *nopass : *omit )

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
     D  SPVSPO_chkPahcc3...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   pePsec                       2  0 const

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPahcc3: Graba Pagos de cuotas                      *
     ?*                                                              *
     ?*     peDsC3  (  input  )  Estructura de Pahcd6                *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     D  SPVSPO_setPahcc3...
     D                 pr              n
     D   peDsC3                            likeds( dsPahcc3_t ) const

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
     D  SPVSPO_chkPahcd7...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNras                       6  0 const
     D   peC4se                       5  0 const

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_setPahcd7: Graba Gasto de Cobranza                    *
     ?*                                                              *
     ?*     peDsD7  (  input  )  Estructura de Pahcd7                *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     D  SPVSPO_setPahcd7...
     D                 pr              n
     D   peDsD7                            likeds( dsPahcd7_t ) const

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
     D  SPVSPO_UltSecCobPagoProc...
     D                 pr             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNras                       6  0 const

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
     D  SPVSPO_UltSecuenciaPagos...
     D                 pr             2  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit )const
     D   peNrcu                       2  0 options( *nopass : *omit )const
     D   peNrsc                       2  0 options( *nopass : *omit )const

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_UltSecCobranza: Retorna ultima Secuencia 1 de Cobranza*
     ?*                                                              *
     ?*     peEmpr  (  input  )  Empresa                             *
     ?*     peSucu  (  input  )  Sucursal                            *
     ?*     peNras  (  input  )  Nro. de Asiento                     *
     ?*                                                              *
     ?* Retorna: Secuencia                                           *
     ?* ------------------------------------------------------------ *
     D  SPVSPO_UltSecCobranza...
     D                 pr             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNras                       6  0 const

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
     D  SPVSPO_getDiferenciaGA...
     D                 pr            15  2
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
     D  SPVSPO_UltSecCobrProc...
     D                 pr             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNras                       6  0 const

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_updPahcd5: Actualiza Cuota Emitida                    *
     ?*                                                              *
     ?*     peDsD5  (  input  )  Estructura de Pahcd5                *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     D  SPVSPO_updPahcd5...
     D                 pr              n
     D   peDsD5                            likeds( dsPahcd5_t ) const

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_updPahcc2: Actualiza Cuotas                           *
     ?*                                                              *
     ?*     peDsC2  (  input  )  Estructura de Pahcc2                *
     ?*                                                              *
     ?* Retorna: *on = Actualizo / *off = No Actualizo               *
     ?* ------------------------------------------------------------ *
     D  SPVSPO_updPahcc2...
     D                 pr              n
     D   peDsC2                            likeds( dsPahcc2_t ) const

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
     D SPVSPO_getFechaAnualidad...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*Omit:*Nopass) const
     D   peFecd                       8  0 options(*Omit:*Nopass)
     D   peFech                       8  0 options(*Omit:*Nopass)

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
     D SPVSPO_getPahcc2V2...
     D                 pr              n
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
     D SPVSPO_anulaArrepEnProceso...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

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
     D SPVSPO_getNroExpediente...
     D                 pr            40
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVSPO_setSsnp04: Graba Log de ejecución SSN                 *
      *                                                              *
      *     peDsP4  (  input  )  Estructura de Ssnp04                *
      *                                                              *
      * Retorna: *on = Grabo ok / *off = No Grabo                    *
      * ------------------------------------------------------------ *
     D  SPVSPO_setSsnp04...
     D                 pr              n
     D   peDsP4                            likeds( dsSsnp04_t ) const

     ?* ------------------------------------------------------------ *
     ?* SPVSPO_getIntermediario: Retorna datos de Intermediario      *
     ?*                          de Pahpol.-                         *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peDsIn   ( output ) Esrtuctura de Intermediario          *
     ?*     peDsInC  ( output ) Cantidad de Intermediarios           *
     ?*                                                              *
     ?* Retorna: *on = Encuentra    / *off = No Encuentra            *
     ?* ------------------------------------------------------------ *
     D SPVSPO_getIntermediario...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peDsIn                            likeds ( intermediario ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsInC                     10i 0 options( *nopass : *omit )

