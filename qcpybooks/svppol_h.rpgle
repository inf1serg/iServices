      /if defined(SVPPOL_H)
      /eof
      /endif
      /define SVPPOL_H

      * Poliza Inexistente...
     D SVPPOL_POLNE    c                   const(0001)

      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     * ------------------------------------------------------------ *
     * Estrucutura de datos PAHED0                                  *
     * -------------------------------------------------------------*
     DdsPahed0_t       ds                  qualified template
     D  d0empr                        1
     D  d0sucu                        2
     D  d0arcd                        6p 0
     D  d0spol                        9p 0
     D  d0sspo                        3p 0
     D  d0rama                        2p 0
     D  d0arse                        2p 0
     D  d0oper                        7p 0
     D  d0suop                        3p 0
     D  d0cert                        9p 0
     D  d0poli                        7p 0
     D  d0endo                        7p 0
     D  d0tiou                        1p 0
     D  d0stou                        2p 0
     D  d0stos                        2p 0
     D  d0mone                        2
     D  d0come                       15p 6
     D  d0plac                        3p 0
     D  d0fioa                        4p 0
     D  d0fiom                        2p 0
     D  d0fiod                        2p 0
     D  d0fvoa                        4p 0
     D  d0fvom                        2p 0
     D  d0fvod                        2p 0
     D  d0fhfa                        4p 0
     D  d0fhfm                        2p 0
     D  d0fhfd                        2p 0
     D  d0fvaa                        4p 0
     D  d0fvam                        2p 0
     D  d0fvad                        2p 0
     D  d0ncoc                        5p 0
     D  d0ciap                        1
     D  d0part                        5p 2
     D  d0cpar                        1
     D  d0copc                        1
     D  d0copg                        5p 3
     D  d0gpil                       15p 2
     D  d0dup1                        2p 0
     D  d0dup2                        2p 0
     D  d0pecu                        3p 0
     D  d0suas                       13p 0
     D  d0saca                       13p 0
     D  d0sacr                       13p 0
     D  d0sast                       13p 0
     D  d0prim                       15p 2
     D  d0bpri                       15p 2
     D  d0refi                       15p 2
     D  d0read                       15p 2
     D  d0dere                       15p 2
     D  d0seri                       15p 2
     D  d0seem                       15p 2
     D  d0impi                       15p 2
     D  d0sers                       15p 2
     D  d0tssn                       15p 2
     D  d0ipr1                       15p 2
     D  d0ipr3                       15p 2
     D  d0ipr4                       15p 2
     D  d0ipr2                       15p 2
     D  d0ipr5                       15p 2
     D  d0ipr6                       15p 2
     D  d0ipr7                       15p 2
     D  d0ipr8                       15p 2
     D  d0ipr9                       15p 2
     D  d0prem                       15p 2
     D  d0bpre                       15p 2
     D  d0prco                       15p 2
     D  d0depp                       15p 2
     D  d0conr                        7p 0
     D  d0bpip                        5p 2
     D  d0xref                        5p 2
     D  d0xrea                        5p 2
     D  d0pimi                        5p 2
     D  d0psso                        5p 2
     D  d0pssn                        5p 2
     D  d0pivi                        5p 2
     D  d0pivn                        5p 2
     D  d0pivr                        5p 2
     D  d0bpep                        5p 2
     D  d0poan                        7p 0
     D  d0ponu                        7p 0
     D  d0mar1                        1
     D  d0mar2                        1
     D  d0mar3                        1
     D  d0mar4                        1
     D  d0mar5                        1
     D  d0strg                        1
     D  d0user                       10
     D  d0time                        6p 0
     D  d0date                        6p 0
     D  d0siva                       15p 2
     D  d0vacc                       15p 2
     D  d0cuic                       54

     * ------------------------------------------------------------ *
     * Estrucutura de datos PAHED1                                  *
     * -------------------------------------------------------------*
     DdsPahed1_t       ds                  qualified template
     D  d1empr                        1
     D  d1sucu                        2
     D  d1arcd                        6p 0
     D  d1spol                        9p 0
     D  d1sspo                        3p 0
     D  d1rama                        2p 0
     D  d1arse                        2p 0
     D  d1oper                        7p 0
     D  d1suop                        3p 0
     D  d1plac                        3p 0
     D  d1xmes                        5p 0
     D  d1cert                        9p 0
     D  d1poli                        7p 0
     D  d1endo                        7p 0
     D  d1mone                        2
     D  d1come                       15p 6
     D  d1xopr                        5p 2
     D  d1xcco                        5p 2
     D  d1xfno                        5p 2
     D  d1xfnn                        5p 2
     D  d1copr                       15p 2
     D  d1ccob                       15p 2
     D  d1cfno                       15p 2
     D  d1cfnn                       15p 2
     D  d1fac1                        1
     D  d1fac2                        1
     D  d1nmd1                        2p 0
     D  d1nmd2                        2p 0
     D  d1nmc1                        2p 0
     D  d1nmc2                        2p 0
     D  d1pdn1                        5p 2
     D  d1pdn2                        5p 2
     D  d1pdn3                        5p 2
     D  d1pdn4                        5p 2
     D  d1pdn5                        5p 2
     D  d1pdn6                        5p 2
     D  d1pdn7                        5p 2
     D  d1pdn8                        5p 2
     D  d1pdn9                        5p 2
     D  d1mar1                        1
     D  d1mar2                        1
     D  d1mar3                        1
     D  d1mar4                        1
     D  d1mar5                        1
     D  d1strg                        1
     D  d1user                       10
     D  d1time                        6p 0
     D  d1date                        6p 0
     D  d1bas1                        1
     D  d1bas2                        1
     D  d1bas3                        1
     D  d1bas4                        1
     D  d1pdc1                        5p 2
     D  d1pdc2                        5p 2
     D  d1pdc3                        5p 2
     D  d1pdc4                        5p 2
     D  d1pdc5                        5p 2
     D  d1pdc6                        5p 2
     D  d1pdc7                        5p 2
     D  d1pdc8                        5p 2
     D  d1pdc9                        5p 2
     D  d1pdf1                        5p 2
     D  d1pdf2                        5p 2
     D  d1pdf3                        5p 2
     D  d1pdf4                        5p 2
     D  d1pdf5                        5p 2
     D  d1pdf6                        5p 2
     D  d1pdf7                        5p 2
     D  d1pdf8                        5p 2
     D  d1pdf9                        5p 2
     D  d1pdg1                        5p 2
     D  d1pdg2                        5p 2
     D  d1pdg3                        5p 2
     D  d1pdg4                        5p 2
     D  d1pdg5                        5p 2
     D  d1pdg6                        5p 2
     D  d1pdg7                        5p 2
     D  d1pdg8                        5p 2
     D  d1pdg9                        5p 2
     D  d1ndc1                        1p 0
     D  d1ndc2                        1p 0
     D  d1ndc3                        1p 0
     D  d1ndc4                        1p 0
     D  d1ndc5                        1p 0
     D  d1ndc6                        1p 0
     D  d1ndc7                        1p 0
     D  d1ndc8                        1p 0
     D  d1ndc9                        1p 0
     D  d1tarc                        2p 0
     D  d1tair                        2p 0
     D  d1scta                        1p 0
     D  d1prec                        5p 2
     D  d1fac3                        1
     D  d1fac4                        1
     D  d1fac5                        1
     D  d1fac6                        1
     D  d1fac7                        1
     D  d1fac8                        1
     D  d1fac9                        1
     D  d1xbrk                        5p 2
     D  d1bbrk                        1
     D  d1cbrk                       15p 2

     * ------------------------------------------------------------ *
     * Estrucutura de datos PAHED2                                  *
     * -------------------------------------------------------------*
     DdsPahed2_t       ds                  qualified template
     D  d2empr                        1
     D  d2sucu                        2
     D  d2arcd                        6p 0
     D  d2spol                        9p 0
     D  d2sspo                        3p 0
     D  d2rama                        2p 0
     D  d2arse                        2p 0
     D  d2oper                        7p 0
     D  d2suop                        3p 0
     D  d2nrre                        3p 0
     D  d2retx                       79
     D  d2cert                        9p 0
     D  d2poli                        7p 0
     D  d2marp                        1
     D  d2strg                        1
     D  d2user                       10
     D  d2time                        6p 0
     D  d2date                        6p 0

     * ------------------------------------------------------------ *
     * Estrucutura de datos PAHED3                                  *
     * -------------------------------------------------------------*
     DdsPahed3_t       ds                  qualified template
     D  d3empr                        1
     D  d3sucu                        2
     D  d3arcd                        6p 0
     D  d3spol                        9p 0
     D  d3sspo                        3p 0
     D  d3rama                        2p 0
     D  d3arse                        2p 0
     D  d3oper                        7p 0
     D  d3suop                        3p 0
     D  d3nivt                        1p 0
     D  d3nivc                        5p 0
     D  d3rpro                        2p 0
     D  d3cert                        9p 0
     D  d3poli                        7p 0
     D  d3plac                        3p 0
     D  d3mone                        2
     D  d3inta                        1p 0
     D  d3inna                        5p 0
     D  d3secu                        2p 0
     D  d3copc                        1
     D  d3ncoc                        5p 0
     D  d3facc                        1
     D  d3xopr                        5p 2
     D  d3xcco                        5p 2
     D  d3xfno                        5p 2
     D  d3xfnn                        5p 2
     D  d3copr                       15p 2
     D  d3ccob                       15p 2
     D  d3cfno                       15p 2
     D  d3cfnn                       15p 2
     D  d3mar1                        1
     D  d3mar2                        1
     D  d3mar3                        1
     D  d3mar4                        1
     D  d3mar5                        1
     D  d3strg                        1
     D  d3user                       10
     D  d3time                        6p 0
     D  d3date                        6p 0

     * ------------------------------------------------------------ *
     * Estrucutura de datos PAHED4                                  *
     * -------------------------------------------------------------*
     DdsPahed4_t       ds                  qualified template
     D  d4empr                        1
     D  d4sucu                        2
     D  d4arcd                        6p 0
     D  d4spol                        9p 0
     D  d4sspo                        3p 0
     D  d4rama                        2p 0
     D  d4arse                        2p 0
     D  d4oper                        7p 0
     D  d4suop                        3p 0
     D  d4cert                        9p 0
     D  d4poli                        7p 0
     D  d4ca01                        3
     D  d4ca02                        3
     D  d4ca03                        3
     D  d4ca04                        3
     D  d4ca05                        3
     D  d4ca06                        3
     D  d4ca07                        3
     D  d4ca08                        3
     D  d4ca09                        3
     D  d4ca10                        3
     D  d4ca11                        3
     D  d4ca12                        3
     D  d4ca13                        3
     D  d4ca14                        3
     D  d4ca15                        3
     D  d4ca16                        3
     D  d4ca17                        3
     D  d4ca18                        3
     D  d4ca19                        3
     D  d4ca20                        3
     D  d4ca21                        3
     D  d4ca22                        3
     D  d4ca23                        3
     D  d4ca24                        3
     D  d4ca25                        3
     D  d4ca26                        3
     D  d4ca27                        3
     D  d4ca28                        3
     D  d4ca29                        3
     D  d4ca30                        3
     D  d4marp                        1
     D  d4strg                        1
     D  d4user                       10
     D  d4time                        6p 0
     D  d4date                        6p 0

     * ------------------------------------------------------------ *
     * Estrucutura de datos PAHED5                                  *
     * -------------------------------------------------------------*
     DdsPahed5_t       ds                  qualified template
     D  d5empr                        1
     D  d5sucu                        2
     D  d5arcd                        6p 0
     D  d5spol                        9p 0
     D  d5sspo                        3p 0
     D  d5rama                        2p 0
     D  d5arse                        2p 0
     D  d5oper                        7p 0
     D  d5suop                        3p 0
     D  d5cert                        9p 0
     D  d5poli                        7p 0
     D  d5an01                        1
     D  d5an02                        1
     D  d5an03                        1
     D  d5an04                        1
     D  d5an05                        1
     D  d5an06                        1
     D  d5an07                        1
     D  d5an08                        1
     D  d5an09                        1
     D  d5an10                        1
     D  d5an11                        1
     D  d5an12                        1
     D  d5an13                        1
     D  d5an14                        1
     D  d5an15                        1
     D  d5an16                        1
     D  d5an17                        1
     D  d5an18                        1
     D  d5an19                        1
     D  d5an20                        1
     D  d5an21                        1
     D  d5an22                        1
     D  d5an23                        1
     D  d5an24                        1
     D  d5an25                        1
     D  d5an26                        1
     D  d5an27                        1
     D  d5an28                        1
     D  d5an29                        1
     D  d5an30                        1
     D  d5marp                        1
     D  d5strg                        1
     D  d5user                       10
     D  d5time                        6p 0
     D  d5date                        6p 0

     * ------------------------------------------------------------ *
     * SVPPOL_inz(): Inicializa módulo.                             *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPPOL_inz      pr

     * ------------------------------------------------------------ *
     * SVPPOL_End(): Finaliza módulo.                               *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPPOL_End      pr

     * ------------------------------------------------------------ *
     * SVPPOL_Error(): Retorna el último error del service program  *
     *                                                              *
     *     peEnbr   (output)  Número de error (opcional)            *
     *                                                              *
     * Retorna: Mensaje de error.                                   *
     * ------------------------------------------------------------ *

     D SVPPOL_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPPOL_getPoliza: Retorna informacion de Poliza.-            *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peRama   ( input  ) Rama                                 *
     *     pePoli   ( input  ) Poliza                               *
     *     peSuop   ( input  ) SubOperacion              (opcional) *
     *     peArcd   ( input  ) Articulo                  (opcional) *
     *     peSpol   ( input  ) SuperPoliza               (opcional) *
     *     peSspo   ( input  ) Suplemento de SuperPoliza (opcional) *
     *     peArse   ( input  ) Cant.Polizas por Rama/Art (opcional) *
     *     peOper   ( input  ) Numero de Operacion       (opcional) *
     *     peDsD0   ( output ) Estructura Poliza         (opcional) *
     *     peDsD0C  ( output ) Cant Suplementos          (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_getPoliza...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peArcd                       6  0 options( *nopass : *omit ) const
     D   peSpol                       9  0 options( *nopass : *omit ) const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peDsD0                            likeds( dsPahed0_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD0c                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPPOL_setSuscripcionPolizaElectronica: Graba suscripción de *
     *                                         póliza Electrónica   *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peRama   ( input  ) Rama                                 *
     *     peArse   ( input  ) Cant de Polizas                      *
     *     peOper   ( input  ) Numero de Operacion                  *
     *     pePoli   ( input  ) Poliza                               *
     *     peSusc   ( input  ) Suscripta "S" o "N"                  *
     *     peMail   ( input  ) Mail                                 *
     *                                                              *
     * Retorna: *On / *Off                                          *
     * ------------------------------------------------------------ *
     D SVPPOL_setSuscripcionPolizaElectronica...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSusc                       1    const
     D   peMail                      50    const

     * ------------------------------------------------------------ *
     * SVPPOL_isSuscriptaPolizaElectronica: Retorna suscripción de  *
     *                                      póliza Electrónica      *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peRama   ( input  ) Rama                                 *
     *     peArse   ( input  ) Cant de Polizas                      *
     *     peOper   ( input  ) Numero de Operacion                  *
     *     pePoli   ( input  ) Poliza                               *
     *     peMail   ( input  ) Mail (Opcional)                      *
     *                                                              *
     * Retorna: *On / *Off                                          *
     * ------------------------------------------------------------ *
     D SVPPOL_isSuscriptaPolizaElectronica...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peMail                      50    options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPPOL_setPoliza: Actualizar Poliza.-                        *
     *                                                              *
     *     peDsD0   ( input  ) Estructura Poliza                    *
     *                                                              *
     * Retorna: *on = Si actualizo / *off = No actualizo            *
     * ------------------------------------------------------------ *
     D SVPPOL_updPoliza...
     D                 pr              n
     D   peDsD0                            likeds( dsPahed0_t )
     D                                     options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPPOL_updPoliza: Grabar Poliza.-                            *
     *                                                              *
     *     peDsD0   ( input  ) Estructura Poliza                    *
     *                                                              *
     * Retorna: *on = Si existe /  *off = No existe                 *
     * ------------------------------------------------------------ *
     D SVPPOL_setPoliza...
     D                 pr              n
     D   peDsD0                            likeds( dsPahed0_t )
     D                                     options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPPOL_getSuperPoliza: Rertorna Nro de SupePoliza de una     *
     *                        Poliza                                *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peRama   ( input  ) Rama                                 *
     *     pePoli   ( input  ) Poliza                               *
     *     peSuop   ( input  ) SubOperacion              (opcional) *
     *                                                              *
     * Retorna: Nro de SuperPoliza / -1 = No encontró               *
     * ------------------------------------------------------------ *
     D SVPPOL_getSuperPoliza...
     D                 pr             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPPOL_getArticulo: Rertorna Código de Articlo               *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peRama   ( input  ) Rama                                 *
     *     pePoli   ( input  ) Poliza                               *
     *     peSuop   ( input  ) SubOperacion              (opcional) *
     *                                                              *
     * Retorna: Código de Articulo / -1 = No encontró               *
     * ------------------------------------------------------------ *
     D SVPPOL_getArticulo...
     D                 pr             6  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPPOL_getPolizadesdeSuperPoliza: Retorna informacion        *
     *                                   de Poliza.-                *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *     peDsD0   ( output ) Estructura Poliza         (opcional) *
     *     peDsD0C  ( output ) Cantidad de Polizas       (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_getPolizadesdeSuperPoliza...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsD0                            likeds( dsPahed0_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD0C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPPOL_chkCondicionesComerciales: Valida condiciones         *
     *                                   Comerciales.-              *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_chkCondicionesComerciales...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPPOL_getCondicionesComerciales: Retorna condiciones        *
     *                                   Comerciales.-              *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *     peDsD1   ( output ) Est. Condic. Comerciales  (opcional) *
     *     peDsD1C  ( output ) Cant. Cond. Comerciales   (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_getCondicionesComerciales...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsD1                            likeds( dsPahed1_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD1C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPPOL_setCondicionesComerciales: Graba ondiciones           *
     *                                   Comerciales.-              *
     *                                                              *
     *     peDsD1  (  input  )  Est. Cond. Comerciale               *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D SVPPOL_setCondicionesComerciales...
     D                 pr              n
     D   peDsD1                            likeds( dsPahed1_t ) const


     * ------------------------------------------------------------ *
     * SVPPOL_delCondicionesComerciales: Eliminar Condiciones       *
     *                                   Comerciales.-              *
     *                                                              *
     *     peDsD1  (  input  )  Est. Cond. Comerciales              *
     *                                                              *
     * Retorna: *on = Elimino ok / *off = No Elimino                *
     * ------------------------------------------------------------ *
     D SVPPOL_delCondicionesComerciales...
     D                 pr              n
     D   peDsD1                            likeds( dsPahed1_t ) const

     * ------------------------------------------------------------ *
     * SVPPOL_chkTexto:  Validar si la poliza contiene textos       *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *     peNrre   ( input  ) Nro. de linea de Texto    (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_chkTexto...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peNrre                       3  0 options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPPOL_getTextos: Retorna Textos .-                          *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *     peNrre   ( input  ) Nro. de linea de Texto    (opcional) *
     *     peDsD2   ( output ) Est. Textos               (opcional) *
     *     peDsD2C  ( output ) Cant. Textos              (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_getTextos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peNrre                       3  0 options( *nopass : *omit ) const
     D   peDsD2                            likeds( dsPahed2_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD2C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPPOL_setTextos_ Graba Textos                               *
     *                                                              *
     *     peDsD2  (  input  )  Est. Textos                         *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D SVPPOL_setTextos...
     D                 pr              n
     D   peDsD2                            likeds( dsPahed2_t ) const

     * ------------------------------------------------------------ *
     * SVPPOL_chkComisionesxInt: Validar Comisiones por             *
     *                           Intermediarios                     *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *     peNivt   ( input  ) Nivel de Intermediario    (opcional) *
     *     peNivc   ( input  ) Código de Intermediario   (opcional) *
     *     peRpro   ( input  ) Provincia Inder           (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_chkComisionesxInt...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peNivt                       1  0 options( *nopass : *omit ) const
     D   peNivc                       5  0 options( *nopass : *omit ) const
     D   peRpro                       2  0 options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPPOL_getComisionesxInt : Retorna Comisiones.-              *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *     peNivt   ( input  ) Nivel de Intermediario    (opcional) *
     *     peNivc   ( input  ) Código de Intermediario   (opcional) *
     *     peRpro   ( input  ) Provincia Inder           (opcional) *
     *     peDsD3   ( output ) Est. Comisiones           (opcional) *
     *     peDsD3C  ( output ) Cant. Comisiones          (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_getComisionesxInt...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peNivt                       1  0 options( *nopass : *omit ) const
     D   peNivc                       5  0 options( *nopass : *omit ) const
     D   peRpro                       2  0 options( *nopass : *omit ) const
     D   peDsD3                            likeds( dsPahed3_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD3C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPPOL_setComisionesxInt: Graba Comisiones.-                 *
     *                                                              *
     *     peDsD3  (  input  )  Est. Comisiones                     *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D SVPPOL_setComisionesxInt...
     D                 pr              n
     D   peDsD3                            likeds( dsPahed3_t ) const

     * ------------------------------------------------------------ *
     * SVPPOL_updComisionesxInt: Actualiza Comisiones.-             *
     *                                                              *
     *     peDsD3  (  input  )  Est. Comisiones                     *
     *                                                              *
     * Retorna: *on = Actualizo ok / *off = No Actualizo            *
     * ------------------------------------------------------------ *
     D SVPPOL_updComisionesxInt...
     D                 pr              n
     D   peDsD3                            likeds( dsPahed3_t ) const

     * ------------------------------------------------------------ *
     * SVPPOL_delComisionesxInt: Elimina Comisiones.-               *
     *                                                              *
     *     peDsD3  (  input  )  Est. Comisiones                     *
     *     peDsD3C (  input  )  Cant. Est. Comisiones               *
     *                                                              *
     * Retorna: *on = elimino ok / *off = no elimino                *
     * ------------------------------------------------------------ *
     D SVPPOL_delComisionesxInt...
     D                 pr              n
     D   peDsD3                            likeds( dsPahed3_t ) dim( 999 ) const
     D   peDsD3C                     10i 0

     * ------------------------------------------------------------ *
     * SVPPOL_chkClausula:Validar si la poliza contiene clausulas   *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_chkClausula...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPPOL_getClausulas: Retorna Clauslas.-                      *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *     peDsD4   ( output ) Est. Clausulas            (opcional) *
     *     peDsD4C  ( output ) Cant. Clausulas           (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_getClausulas...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsD4                            likeds( dsPahed4_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD4C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPPOL_setClausulas: Graba Clausulas                         *
     *                                                              *
     *     peDsD4  (  input  )  Est. Clausulas                      *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D SVPPOL_setClausulas...
     D                 pr              n
     D   peDsD4                            likeds( dsPahed4_t ) const

     * ------------------------------------------------------------ *
     * SVPPOL_chkAnexos: Validar si la poliza contiene Anexos.-     *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_chkAnexo...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPPOL_getAnexos: Retorna Anexos.-                           *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peSspo   ( input  ) Suplemento                (opcional) *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     *     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     *     peDsD5   ( output ) Est. Clausulas            (opcional) *
     *     peDsD5C  ( output ) Cant. Clausulas           (opcional) *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPPOL_getAnexos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsD5                            likeds( dsPahed5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD5C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPPOL_setAnexos: Graba Anexos                               *
     *                                                              *
     *     peDsD5  (  input  )  Est. Anexos                         *
     *                                                              *
     * Retorna: *on = Grabo ok / *off = No Grabo                    *
     * ------------------------------------------------------------ *
     D SVPPOL_setAnexos...
     D                 pr              n
     D   peDsD5                            likeds( dsPahed5_t ) const



     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getVariacionDeComision                                *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     *     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*                                                              *
     ?* Retorna: 3/0                                                 *
     ?* ------------------------------------------------------------ *
     D SVPPOL_getVariacionDeComision...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const

      * ------------------------------------------------------------ *
      * SVPPOL_isNominaExterna: Retorna si es Nomina Externa y       *
      *                         opcionalmente, numero de nomina      *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peNomi   ( output ) Numero de Nomina                     *
      *                                                              *
      * Retorna: *off / *on                                          *
      * ------------------------------------------------------------ *
     D SVPPOL_isNominaExterna...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peNomi                       7  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPPOL_tipoAsistencia: Retorna el tipo de asistencia que de  *
      *                        la póliza.                            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia Artículo/Rama              *
      *     peOper   ( input  ) Operación                            *
      *     pePoli   ( input  ) Poliza                               *
      *     peCuad   ( output ) Nombre del cuadernillo de asistencia *
      *                                                              *
      * Retorna: IKE = IKE Asistencia                                *
      *          EUR = Europ Assist                                  *
      *          AON = Aon Assist                                    *
      *       Blanco = Sin asistencia                                *
      * ------------------------------------------------------------ *
     D SVPPOL_tipoAsistencia...
     D                 pr             3a
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peCuad                     256a   options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPPOL_getPremioAcumulado: Retorna premio acumulado          *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peSspo   ( input  ) Suplemento              ( opcional ) *
      *     peRama   ( input  ) Rama                    ( opcional ) *
      *     peArse   ( input  ) Secuencia Artículo/Rama ( opcional ) *
      *     peOper   ( input  ) Operación               ( opcional ) *
      *     peSuop   ( input  ) Suplemento de Operacion ( opcional ) *
      *     peRead   ( output ) Recargo Administrativo  ( opcional ) *
      *     peRefi   ( output ) Recargo Financiero      ( opcional ) *
      *     peDere   ( output ) Derecho de Emision      ( opcional ) *
      *                                                              *
      * Retorna: Premio Acumulado                                    *
      * ------------------------------------------------------------ *
     D SVPPOL_getPremioAcumulado...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options(*nopass:*omit)
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peOper                       7  0 const options(*nopass:*omit)
     D   peSuop                       3  0 const options(*nopass:*omit)
     D   peRead                      15  2 options(*nopass:*omit)
     D   peRefi                      15  2 options(*nopass:*omit)
     D   peDere                      15  2 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPPOL_getPrimaAcumulada: Retorna prima acumilada            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peSspo   ( input  ) Suplemento              ( opcional ) *
      *     peRama   ( input  ) Rama                    ( opcional ) *
      *     peArse   ( input  ) Secuencia Artículo/Rama ( opcional ) *
      *     peOper   ( input  ) Operación               ( opcional ) *
      *     peSuop   ( input  ) Suplemento de Operacion ( opcional ) *
      *                                                              *
      * Retorna: Prima Acumulada                                     *
      * ------------------------------------------------------------ *
     D SVPPOL_getPrimaAcumulada...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options(*nopass:*omit)
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peOper                       7  0 const options(*nopass:*omit)
     D   peSuop                       3  0 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPPOL_getUltimoSuopFacturacion: Retorna ultimo endoso de    *
      *                                  Facturacion.                *
      *                                                              *
      * Ultima facturacion es Poliza Nueva/Refacturacion/Renovacion  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peSspo   ( output ) Suplemento Superpoliza  ( opcional ) *
      *                                                              *
      * Retorna: Suop con ultima facturacion                         *
      * ------------------------------------------------------------ *
     D SVPPOL_getUltimoSuopFacturacion...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_chkPoliza: Validar Poliza.-                           *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Poliza                               *
     ?*     peSuop   ( input  ) SubOperacion              (opcional) *
     ?*     peArcd   ( input  ) Articulo                  (opcional) *
     ?*     peSpol   ( input  ) SuperPoliza               (opcional) *
     ?*     peSspo   ( input  ) Suplemento de SuperPoliza (opcional) *
     ?*     peArse   ( input  ) Cant.Polizas por Rama/Art (opcional) *
     ?*     peOper   ( input  ) Numero de Operacion       (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe /  *off = No existe                 *
     ?* ------------------------------------------------------------ *
     D SVPPOL_chkPoliza...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peArcd                       6  0 options( *nopass : *omit ) const
     D   peSpol                       9  0 options( *nopass : *omit ) const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const

      * ------------------------------------------------------------ *
      * SVPPOL_getDeuda: Retorna deuda acumulada                     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peDsCd   ( output ) Est. Cuotas               (opcional) *
      *     peDsCdC  ( output ) Cant. Cuotas              (opcional) *
      *                                                              *
      * Retorna: Importe                                             *
      * ------------------------------------------------------------ *
     D SVPPOL_getDeuda...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peDsCd                            likeds( dsPahcd5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsCdC                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPPOL_getProximaCuotaAVencer: Retorna proxima cuota a       *
      *                                vencer                        *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peDsCd   ( output ) Est. Cuotas               (opcional) *
      *     peDsCdC  ( output ) Cant. Cuotas              (opcional) *
      *                                                              *
      * Retorna: Importe de cuota a vencer                           *
      * ------------------------------------------------------------ *
     D SVPPOL_getProximaCuotaAVencer...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peDsCd                            likeds( dsPahcd5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsCdC                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPPOL_permiteAnular: Retorna si una poliza permite anularse *
      *                       desde Autogestion.                     *
      *                                                              *
      *  Se permitirá anular aquellas pólizas que hayan sido contrata*
      *  das a través del portal de autogestion.                     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia Artículo/Rama              *
      *     peOper   ( input  ) Operación                            *
      *     pePoli   ( input  ) Poliza                               *
      *                                                              *
      * Retorna: *ON = Se permite                                    *
      *          *OFF = No se permite                                *
      * ------------------------------------------------------------ *
     D SVPPOL_permiteAnular...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const

      * ------------------------------------------------------------ *
      * SVPPOL_permiteArrepentir: Retorna si una poliza permite el   *
      *                           botón de arrepentimiento.          *
      *                                                              *
      *  Se permitirá arrepentir sobre aquellas polizas que hayan si-*
      *  do contratadas a través del portal de autogestion.          *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia Artículo/Rama              *
      *     peOper   ( input  ) Operación                            *
      *     pePoli   ( input  ) Poliza                               *
      *                                                              *
      * Retorna: *ON = Se permite                                    *
      *          *OFF = No se permite                                *
      * ------------------------------------------------------------ *
     D SVPPOL_permiteArrepentir...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const

      * ------------------------------------------------------------ *
      * SVPPOL_permiteanulacionEnProceso: Retorna si una póliza esta *
      *                  en proceso de anulación.                    *
      *                                                              *
      *  Como, por el momento, aquellas pólizas que se arrepientan o *
      *  anulen desde el portal de autogestion no van a impactar en  *
      *  GAUS si no que se enviará un mail, este procedimiento le    *
      *  dice al portal que todavía no se anuló.                     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia Artículo/Rama              *
      *     peOper   ( input  ) Operación                            *
      *     pePoli   ( input  ) Poliza                               *
      *                                                              *
      * Retorna: *ON = Está en proceso                               *
      *          *OFF = Ya está anulada                              *
      * ------------------------------------------------------------ *
     D SVPPOL_anulacionEnProceso...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const

