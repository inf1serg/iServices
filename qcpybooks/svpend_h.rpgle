      /if defined(SVPEND_H)
      /eof
      /endif
      /define SVPEND_H

      * Superpoliza Suspendida...
     D SVPEND_SPOLS    c                   const(0001)
      * Endoso de As/Ca No existe...
     D SVPEND_EACNE    c                   const(0002)

      * Estructura de Informacion para calculo y actualizacion de prima...
     D DsPrim_t        ds                  qualified template
     D  poco                          6p 0
     D  riec                          3
     D  xcob                          3p 0
     D  mont                         15p 2
     D  suas                         15p 2
     D  ptco                         15p 2

      /copy './qcpybooks/svpart_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'

      * Mensajes de errores de endoso aumento de suma
     D dsPahea1_t      ds                  qualified template
     D  a1empr                        1a
     D  a1sucu                        2a
     D  a1arcd                        6p 0
     D  a1spol                        9p 0
     D  a1rama                        2p 0
     D  a1arse                        2p 0
     D  a1oper                        7p 0
     D  a1sspo                        3p 0
     D  a1poco                        4p 0
     D  a1nivt                        1p 0
     D  a1nivc                        5p 0
     D  a1secu                        3p 0
     D  a1mens                       80a
     D  a1user                       10a
     D  a1date                        8p 0
     D  a1time                        6p 0

      * Endosos de Aumento de Suma Autos Web
     D dsPaheas_t      ds                  qualified template
     D  asempr                        1a
     D  assucu                        2a
     D  asarcd                        6p 0
     D  asspol                        9p 0
     D  asrama                        2p 0
     D  aspoli                        7p 0
     D  asarse                        2p 0
     D  asoper                        7p 0
     D  assspo                        3p 0
     D  assuop                        3p 0
     D  asasen                        7p 0
     D  astiso                        2p 0
     D  asmone                        2a
     D  ascome                       15p 6
     D  asplac                        3p 0
     D  aspecu                        3p 0
     D  ascfpg                        1p 0
     D  asciva                        2p 0
     D  asnrpp                        3p 0
     D  asdup2                        2p 0
     D  aspoco                        4p 0
     D  asrpro                        2p 0
     D  asfdes                        8p 0
     D  asfhas                        8p 0
     D  asfhfa                        8p 0
     D  aslaps                        5p 0
     D  aslap1                        5p 0
     D  aslap2                        5p 0
     D  asnivt                        1p 0
     D  asnivc                        5p 0
     D  asvhaÑ                        4p 0
     D  asm0km                        1a
     D  asvhmc                        3a
     D  asvhmo                        3a
     D  asvhcs                        3a
     D  ascmar                        9p 0
     D  asdmar                       15a
     D  ascmod                        9p 0
     D  asdmod                       40a
     D  ascgru                        3p 0
     D  asvhcr                        3a
     D  ascobl                        2a
     D  asctrp                        5p 0
     D  asctre                        5p 0
     D  astarc                        2p 0
     D  astair                        2p 0
     D  asscta                        1p 0
     D  astmat                        3a
     D  asnmat                       25a
     D  asmoto                       25a
     D  aschas                       25a
     D  asvhca                        2p 0
     D  asvhv1                        1p 0
     D  asvhv2                        1p 0
     D  asmtdf                        1a
     D  asvhvu                       15p 2
     D  asvh0k                       15p 2
     D  asrgnc                        9p 2
     D  asvhvc                       15p 2
     D  asvhva                       15p 2
     D  asvhdi                       15p 2
     D  asvhdp                        5p 2
     D  asifra                       15p 2
     D  asmar4                        1a
     D  asvhuv                        2p 0
     D  asclaj                        3p 0
     D  asrebr                        1p 0
     D  ascfas                        1a
     D  asvhni                        1a
     D  asncoc                        5p 0
     D  asrcci                        1a
     D  asaici                        1a
     D  asvhct                        2p 0
     D  aspbon                        5p 2
     D  asprrc                       15p 2
     D  asprac                       15p 2
     D  asprin                       15p 2
     D  asprro                       15p 2
     D  asprsf                       15p 2
     D  aspacc                       15p 2
     D  asprce                       15p 2
     D  asprap                       15p 2
     D  aspraa                       15p 2
     D  asprim                       15p 2
     D  asrcle                       15p 2
     D  asrcco                       15p 2
     D  asrcac                       15p 2
     D  asbpip                        5p 2
     D  asbpri                       15p 2
     D  asxref                        5p 2
     D  asrefi                       15p 2
     D  asxrea                        5p 2
     D  asread                       15p 2
     D  aspimi                        5p 2
     D  aspssn                        5p 2
     D  aspsso                        5p 2
     D  aspivi                        5p 2
     D  aspivn                        5p 2
     D  aspivr                        5p 2
     D  asivam                       15p 2
     D  asdepp                       15p 2
     D  asdere                       15p 2
     D  astder                        1a
     D  asbpep                        5p 2
     D  asvacc                       15p 2
     D  asseri                       15p 2
     D  asseem                       15p 2
     D  asimau                       15p 2
     D  asprem                       15p 2
     D  asipr1                       15p 2
     D  asipr2                       15p 2
     D  asipr3                       15p 2
     D  asipr4                       15p 2
     D  asipr5                       15p 2
     D  asipr6                       15p 2
     D  asipr7                       15p 2
     D  asipr8                       15p 2
     D  assefr                       15p 2
     D  assefe                       15p 2
     D  asimpi                       15p 2
     D  astssn                       15p 2
     D  assers                       15p 2
     D  assiva                       15p 2
     D  asxopr                        5p 2
     D  ascopr                       15p 2
     D  asmar1                        1a
     D  asuser                       10a
     D  asdate                        8p 0
     D  astime                        6p 0

      * Endoso de Aumento de Suma de Ascensores/Calderas
     D dsPaheac_t      ds                  qualified template
     D  acempr                        1a
     D  acsucu                        2a
     D  acarcd                        6p 0
     D  acspol                        9p 0
     D  acrama                        2p 0
     D  acpoli                        7p 0
     D  acarse                        2p 0
     D  acoper                        7p 0
     D  acsspo                        3p 0
     D  acsuop                        3p 0
     D  acasen                        7p 0
     D  actiso                        2p 0
     D  acmone                        2a
     D  accome                       15p 6
     D  acplac                        3p 0
     D  acpecu                        3p 0
     D  accfpg                        1p 0
     D  acciva                        2p 0
     D  acnrpp                        3p 0
     D  acdup2                        2p 0
     D  acpoco                        4p 0
     D  acrpro                        2p 0
     D  acfdes                        8p 0
     D  acfhas                        8p 0
     D  acfhfa                        8p 0

     D  aclaps                        5p 0
     D  aclap1                        5p 0
     D  aclap2                        5p 0

     D  acnivt                        1p 0
     D  acnivc                        5p 0

     D  acmar1                        1a

     D  acsaca                       15p 2
     D  acxpra                        9p 6
     D  acpria                       15p 2
     D  acsnca                       15p 2

     D  acsacc                       15p 2
     D  acxprc                        9p 6
     D  acpric                       15p 2
     D  acsncc                       15p 2

     D  acxpro                        3p 0
     D  acrdes                       30a
     D  acnrdm                        5p 0
     D  accopo                        5p 0
     D  accops                        1p 0

     D  acprra                       15p 2
     D  acprrc                       15p 2
     D  acprim                       15p 2
     D  acbpip                        5p 2
     D  acbpri                       15p 2
     D
     D  acxref                        5p 2
     D  acrefi                       15p 2
     D  acxrea                        5p 2
     D  acread                       15p 2
     D  acpimi                        5p 2
     D  acpssn                        5p 2
     D  acpsso                        5p 2
     D  acpivi                        5p 2
     D  acpivn                        5p 2
     D  acpivr                        5p 2
     D  acivam                       15p 2
     D  acdepp                       15p 2
     D  acdere                       15p 2
     D  actder                        1a
     D  acbpep                        5p 2
     D  acvacc                       15p 2
     D  acseri                       15p 2
     D  acseem                       15p 2
     D  acimau                       15p 2
     D  acprem                       15p 2
     D  acipr1                       15p 2
     D  acipr2                       15p 2
     D  acipr3                       15p 2
     D  acipr4                       15p 2
     D  acipr5                       15p 2
     D  acipr6                       15p 2
     D  acipr7                       15p 2
     D  acipr8                       15p 2
     D  acsefr                       15p 2
     D  acsefe                       15p 2
     D  acimpi                       15p 2
     D  actssn                       15p 2
     D  acsers                       15p 2
     D  acsiva                       15p 2
     D  acxopr                        5p 2
     D  accopr                       15p 2

     D  acuser                       10a
     D  actime                        6p 0
     D  acdate                        8p 0

     * ------------------------------------------------------------ *
     * SVPEND_inz(): Inicializa módulo.                             *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPEND_inz      pr

     * ------------------------------------------------------------ *
     * SVPEND_End(): Finaliza módulo.                               *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPEND_End      pr

     * ------------------------------------------------------------ *
     * SVPEND_Error(): Retorna el último error del service program  *
     *                                                              *
     *     peEnbr   (output)  Número de error (opcional)            *
     *                                                              *
     * Retorna: Mensaje de error.                                   *
     * ------------------------------------------------------------ *

     D SVPEND_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPEND_chkEndoso: Validaciones Varias para endosar           *
     *                                                              *
     *     peEmpr   ( input  ) Empresa                              *
     *     peSucu   ( input  ) Sucusal                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peSpol   ( input  ) SuperPoliza                          *
     *     peTiou   ( input  ) Tipo de endoso                       *
     *     peStou   ( input  ) Subtipo de Endoso Usuario            *
     *     peStos   ( input  ) Subtipo de Endoso Sistema            *
     *                                                              *
     * Retorna: *on = Todo Ok / *off = Error                        *
     * ------------------------------------------------------------ *
     D SVPEND_chkEndoso...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const

      * ------------------------------------------------------------ *
      * SVPEND_pemitirEndoso: Actualiza si debe permitir endoso      *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Código Rama                          *
      *     peArse   ( input  ) Numero Polizas por Rama              *
      *     peOper   ( input  ) Numero Operacion                     *
      *     pePoco   ( input  ) Número de Componente                 *
      *     peMar1   ( input  ) Permitir Endoso                      *
      *                                                              *
      * Retorna: *on = Aplicó / *off = No aplicó                     *
      * ------------------------------------------------------------ *
     D SVPEND_permitirEndoso...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peMar1                       1    const

      * ------------------------------------------------------------ *
      * SVPEND_setPahea1: Grabar error de endoso                     *
      *                                                              *
      *     peDsA1   ( output ) Registro PAHEA1                      *
      *                                                              *
      * Retorna: *on = Grabo ok / *off = No grabo                    *
      * ------------------------------------------------------------ *
     D SVPEND_setPahea1...
     D                 pr
     D   peDsA1                            likeds( dsPahea1_t )
     D                                     options(*nopass:*omit) const

      * ------------------------------------------------------------ *
      * SVPEND_getPaheas: Retorna registros de endoso                *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Código Rama               (opcional) *
      *     peArse   ( input  ) Numero Polizas por Rama   (opcional) *
      *     peOper   ( input  ) Numero Operacion          (opcional) *
      *     pePoco   ( input  ) Número de Componente      (opcional) *
      *     peDsAs   ( output ) Ds de Paheas              (opcional) *
      *     peDsAsC  ( output ) Cantidad de Registro      (opcional) *
      *                                                              *
      * Retorna: *on = encontro / *off = no encontro                 *
      * ------------------------------------------------------------ *
     D SVPEND_getPaheas...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options(*nopass:*omit) const
     D   peArse                       2  0 options(*nopass:*omit) const
     D   peOper                       7  0 options(*nopass:*omit) const
     D   pePoco                       4  0 options(*nopass:*omit) const
     D   peDsAs                            likeds( dsPaheas_t ) dim( 9999 )
     D                                     options(*nopass:*omit)
     D   peDsAsC                     10i 0 options(*nopass:*omit)

      * ----------------------------------------------------------------- *
      * SVPEND_updPaheas(): Actualiza datos en el archivo Paheas          *
      *                                                                   *
      *          peDsAs   ( input  ) Estrutura de Paheas                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPEND_updPaheas...
     D                 pr              n
     D   peDsAs                            likeds( dsPaheas_t ) const

      * ------------------------------------------------------------ *
      * SVPEND_getPaheac(): Retorna datos de Paheac                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNivt   ( input  ) Nro. Intermediario                   *
      *     peNivc   ( input  ) Cod. Intermediario                   *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Rama                      (opcional) *
      *     peArse   ( input  ) Cantidad de polizas       (opcional) *
      *     peOper   ( input  ) Codigo de Operacion       (opcional) *
      *     pePoco   ( input  ) Nro. de Componente        (opcional) *
      *     peDsAc   ( output ) Est. de Componente        (opcional) *
      *     peDsAcC  ( output ) Cant. de Componentes      (opcional) *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPEND_getPaheac...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peDsAc                            likeds ( DsPaheac_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsAcC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPEND_chkPaheac(): Valida si existe Paheac                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNivt   ( input  ) Nro. Intermediario                   *
      *     peNivc   ( input  ) Cod. Intermediario                   *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Rama                      (opcional) *
      *     peArse   ( input  ) Cantidad de polizas       (opcional) *
      *     peOper   ( input  ) Codigo de Operacion       (opcional) *
      *     pePoco   ( input  ) Nro. de Componente        (opcional) *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPEND_chkPaheac...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const

      * ----------------------------------------------------------------- *
      * SVPEND_setPaheac(): Graba datos en el archivo Paheac              *
      *                                                                   *
      *          peDsAc   ( input  ) Estrutura de Paheac                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPEND_setPaheac...
     D                 pr              n
     D   peDsAc                            likeds( dsPaheac_t ) const

      * ----------------------------------------------------------------- *
      * SVPEND_updPaheac(): Actualiza datos en el archivo Paheac          *
      *                                                                   *
      *          peDsAc   ( input  ) Estrutura de Paheac                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPEND_updPaheac...
     D                 pr              n
     D   peDsAc                            likeds( dsPaheac_t ) const
      * ----------------------------------------------------------------- *
      * SVPEND_dltPaheac(): Elimina datos en el archivo Paheac            *
      *                                                                   *
      *          peDsAc   ( input  ) Estrutura de Paheac                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPEND_dltPaheac...
     D                 pr              n
     D   peDsAc                            likeds( dsPaheac_t ) const

      * ------------------------------------------------------------ *
      * SVPEND_getSet174(): Retorna Porcentajes para Aumento de      *
      *                     Endosos de Ascensores/Calderas           *
      *                                                              *
      *     peFech   ( input  ) Fecha                                *
      *     pePras   ( output ) % de Aumento Ascensores   (opcional) *
      *     pePrca   ( output ) % de Aumento Calderas     (opcional) *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     D SVPEND_getSet174...
     D                 pr              n
     D   peFech                       8  0 const
     D   pePras                       5  2 options( *nopass : *omit )
     D   pePrca                       5  2 options( *nopass : *omit )

      * ----------------------------------------------------------------- *
      * SVPEND_setPaheacXInt(): Graba datos en el archivo Paheac          *
      *                         por Intermediario.-                       *
      *                                                                   *
      *          peDsAc   ( input  ) Estrutura de Paheac                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPEND_setPaheacXInt...
     D                 pr              n
     D   peDsAc                            likeds( dsPaheac_t ) const


