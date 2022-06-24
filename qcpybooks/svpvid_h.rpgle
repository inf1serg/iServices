      /if defined(SVPVID_H)
      /eof
      /endif
      /define SVPVID_H

      * Poliza Inexistente...
     D SVPVID_POLNE    c                   const(0001)

     * - Estructura de PAHEV0 ------------------------------------- *
     D dsPahev0_t      ds                  qualified template
     D   v0empr                       1
     D   v0sucu                       2
     D   v0arcd                       6p 0
     D   v0spol                       9p 0
     D   v0rama                       2p 0
     D   v0arse                       2p 0
     D   v0oper                       7p 0
     D   v0poco                       6p 0
     D   v0paco                       3p 0
     D   v0cert                       9p 0
     D   v0poli                       7p 0
     D   v0nrdf                       7p 0
     D   v0nomb                      40
     D   v0tido                       2p 0
     D   v0nrdo                       8p 0
     D   v0fnaa                       4p 0
     D   v0fnam                       2p 0
     D   v0fnad                       2p 0
     D   v0fiea                       4p 0
     D   v0fiem                       2p 0
     D   v0fied                       2p 0
     D   v0nrla                       7
     D   v0nrln                       9p 0
     D   v0sspo                       3p 0
     D   v0suin                       3p 0
     D   v0ainn                       4p 0
     D   v0minn                       2p 0
     D   v0dinn                       2p 0
     D   v0suen                       3p 0
     D   v0aegn                       4p 0
     D   v0megn                       2p 0
     D   v0degn                       2p 0
     D   v0mar1                       1
     D   v0mar2                       1
     D   v0mar3                       1
     D   v0mar4                       1
     D   v0mar5                       1
     D   v0strg                       1
     D   v0user                      10
     D   v0time                       6p 0
     D   v0date                       6p 0
     D   v0cer1                       9p 0
     D   v0sexo                       1p 0
     D   v0esci                       1p 0
     D   v01ncr                       5p 0
     D   v01nrc                       5p 0
     D   v02ncr                       5p 0
     D   v02nrc                       5p 0
     D   v03ncr                       5p 0
     D   v03nrc                       5p 0
     D   v04ncr                       5p 0
     D   v04nrc                       5p 0
     D   v05ncr                       5p 0
     D   v05nrc                       5p 0
     D   v0naci                      25
     D   v0acti                       5p 0
     D   v0cate                       2p 0

     * - Estructura de SET627 ------------------------------------- *
     D dsSet627_t      ds                  qualified template
     D   t@Arcd                       6p 0
     D   t@Rama                       2p 0
     D   t@Arse                       2p 0
     D   t@Xpro                       3p 0
     D   t@Edmi                       2p 0
     D   t@Edma                       2p 0
     D   t@Rpfr                       1
     D   t@Orca                       1
     D   t@Csmi                       5p 0
     D   t@Csma                       5p 0
     D   t@Rcfr                       1
     D   t@Fcal                      30
     D   t@User                      10
     D   t@Date                       6p 0
     D   t@1ma1                       1
     D   t@1ma2                       1
     D   t@1ma3                       1
     D   t@1ma4                       1
     D   t@1ma5                       1
     D   t@Cact                       5p 0

     * - Estructura de PAHEV1 ------------------------------------- *
     D dsPahev1_t      ds                  qualified template
     D   v1empr                       1
     D   v1sucu                       2
     D   v1arcd                       6p 0
     D   v1spol                       9p 0
     D   v1sspo                       3p 0
     D   v1rama                       2p 0
     D   v1arse                       2p 0
     D   v1oper                       7p 0
     D   v1poco                       6p 0
     D   v1paco                       3p 0
     D   v1suop                       3p 0
     D   v1cert                       9p 0
     D   v1poli                       7p 0
     D   v1sacm                      15p 2
     D   v1pcap                       5p 2
     D   v1suas                      13p 0
     D   v1samo                      13p 0
     D   v1xpro                       3p 0
     D   v1cant                       5p 0
     D   v1suel                      15p 2
     D   v1mar1                       1
     D   v1mar2                       1
     D   v1mar3                       1
     D   v1mar4                       1
     D   v1mar5                       1
     D   v1strg                       1
     D   v1user                      10
     D   v1time                       6p 0
     D   v1date                       6p 0
     D   v1naci                      25
     D   v1acti                       5p 0
     D   v1cate                       2p 0

     * - Estructura de PAHEV2 ------------------------------------- *
     D dsPahev2_t      ds                  qualified template
     D   v2empr                       1
     D   v2sucu                       2
     D   v2arcd                       6p 0
     D   v2spol                       9p 0
     D   v2sspo                       3p 0
     D   v2rama                       2p 0
     D   v2arse                       2p 0
     D   v2oper                       7p 0
     D   v2poco                       6p 0
     D   v2paco                       3p 0
     D   v2suop                       3p 0
     D   v2riec                       3
     D   v2xcob                       3p 0
     D   v2cert                       9p 0
     D   v2poli                       7p 0
     D   v2saco                      15p 2
     D   v2ptco                      15p 2
     D   v2xpri                       9p 6
     D   v2prsa                       5p 2
     D   v2ecob                       1
     D   v2mar1                       1
     D   v2mar2                       1
     D   v2mar3                       1
     D   v2mar4                       1
     D   v2mar5                       1
     D   v2strg                       1
     D   v2user                      10
     D   v2time                       6p 0
     D   v2date                       6p 0

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/svpart_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpemi_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'

     * ------------------------------------------------------------ *
     * SVPVID_inz(): Inicializa módulo.                             *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPVID_inz      pr

     * ------------------------------------------------------------ *
     * SVPVID_End(): Finaliza módulo.                               *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPVID_End      pr

     * ------------------------------------------------------------ *
     * SVPVID_Error(): Retorna el último error del service program  *
     *                                                              *
     *     peEnbr   (output)  Número de error (opcional)            *
     *                                                              *
     * Retorna: Mensaje de error.                                   *
     * ------------------------------------------------------------ *

     D SVPVID_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPVID_chkComponente : Validar Componentes.-                 *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cantidad de polizas       (opcional) *
     *     peOper   ( input  ) Codigo de Operacion       (opcional) *
     *     pePoco   ( input  ) Nro. de Componente        (opcional) *
     *                                                              *
     * Retorna: *on = Si existe / *off = No existe                  *
     * ------------------------------------------------------------ *
     D SVPVID_chkComponente...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       6  0 options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPVID_getComponentes: Retorna Componentes.-                 *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peRama   ( input  ) Rama                      (opcional) *
     *     peArse   ( input  ) Cantidad de polizas       (opcional) *
     *     peOper   ( input  ) Codigo de Operacion       (opcional) *
     *     pePoco   ( input  ) Nro. de Componente        (opcional) *
     *     peDsV0   ( output ) Est. de Componente        (opcional) *
     *     peDsV0C  ( output ) Cant. de Componentes      (opcional) *
     *                                                              *
     * Retorna: *on = Si existe / *off = No existe                  *
     * ------------------------------------------------------------ *
     D SVPVID_getComponentes...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       6  0 options( *nopass : *omit ) const
     D   peDsV0                            likeds( dsPahev0_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsV0C                     10i 0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getExtensionVida: Retorna datos de Extensión Vida     *
     ?*                                                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cantidad de polizas                  *
     ?*     peXpro   ( input  ) Código de Producto        (opcional) *
     ?*     peDs627  ( output ) Est. de Extensión Vida    (opcional) *
     ?*     peDs627C ( output ) Cant. de Extensión Vida   (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     D SVPVID_getExtensionVida...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       6  0 options( *nopass : *omit ) const
     D   peDs627                           likeds( dsSet627_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDs627C                    10i 0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getEdadMaximaDeVida: Retorna Edad Máxima de Vida.     *
     ?*                                                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cantidad de polizas                  *
     ?*     peXpro   ( input  ) Código de Producto                   *
     ?*     peEdma   ( output ) Edad Máxima                          *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     D SVPVID_getEdadMaximaDeVida...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       6  0 const
     D   peEdma                       2  0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getEdadMinimaDeVida: Retorna Edad Mínima de Vida.     *
     ?*                                                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cantidad de polizas                  *
     ?*     peXpro   ( input  ) Código de Producto                   *
     ?*     peEdmi   ( output ) Edad Mínima                          *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     D SVPVID_getEdadMinimaDeVida...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       6  0 const
     D   peEdmi                       2  0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getPahev1(): Retorna datos de detalle por suplemento  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     pePaco   ( input  ) Código de Parentesco      (opcional) *
     ?*     peSuop   ( input  ) Suplemento de la Operación(opcional) *
     ?*     peDsV1   ( output ) Est. de Componente        (opcional) *
     ?*     peDsV1C  ( output ) Cant. de Componentes      (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     D SVPVID_getPahev1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       6  0 options( *nopass : *omit ) const
     D   pePaco                       3  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsV1                            likeds( dsPahev1_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsV1C                     10i 0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getPahev2(): Retorna datos de detalle por suplemento  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     pePaco   ( input  ) Código de Parentesco      (opcional) *
     ?*     peSuop   ( input  ) Suplemento de la Operación(opcional) *
     ?*     peDsV1   ( output ) Est. de Componente        (opcional) *
     ?*     peDsV1C  ( output ) Cant. de Componentes      (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     D SVPVID_getPahev2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       6  0 options( *nopass : *omit ) const
     D   pePaco                       3  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsV2                            likeds( dsPahev2_t ) dim( 99999 )
     D                                     options( *nopass : *omit )
     D   peDsV2C                     10i 0 options( *nopass : *omit )

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getUltCompoVida() : Retorna Ultimo Componente de Vida.*
     ?*                                                              *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cantidad de polizas                  *
     ?*     peOper   ( input  ) Codigo de Operacion                  *
     ?*     pePoco   ( Output ) Componente                           *
     ?*     pePaco   ( Output ) Parentezco                           *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     D SVPVID_getUltCompoVida...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       6  0
     D   pePaco                       3  0

