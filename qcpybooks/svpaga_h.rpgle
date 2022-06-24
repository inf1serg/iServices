      /if defined(SVPAGA_H)
      /eof
      /endif
      /define SVPAGA_H

      /copy './qcpybooks/spvspo_h.rpgle'

      * Estructura...

     D dsPahag5_t      ds                  qualified based(template)
     D  g5empr                        1a
     D  g5sucu                        2a
     D  g5arcd                        6p 0
     D  g5spol                        9p 0
     D  g5rama                        2p 0
     D  g5arse                        2p 0
     D  g5oper                        7p 0
     D  g5poli                        7p 0
     D  g5mar1                        1a
     D  g5usr1                       10a
     D  g5fec1                        8p 0
     D  g5tim1                        6p 0
     D  g5mar2                        1a
     D  g5erm2                       80a
     D  g5ema2                       50a
     D  g5usr2                       10a
     D  g5fec2                        8p 0
     D  g5tim2                        6p 0
     D  g5mar3                        1a
     D  g5erm3                       80a
     D  g5ema3                       50a
     D  g5usr3                       10a
     D  g5fec3                        8p 0
     D  g5tim3                        6p 0
     D  g5mar4                        1a
     D  g5erm4                       80a
     D  g5ema4                       50a
     D  g5usr4                       10a
     D  g5fec4                        8p 0
     D  g5tim4                        6p 0
     D  g5mar5                        1a
     D  g5mar6                        1a
     D  g5mar7                        1a
     D  g5mar8                        1a
     D  g5mar9                        1a
     D  g5mar0                        1a
     D  g5obse                      300a
     D  g5arch                      300a

     D dsPahag4_t      ds                  qualified based(template)
     D  g4empr                        1a
     D  g4sucu                        2a
     D  g4arcd                        6p 0
     D  g4spol                        9p 0
     D  g4rama                        2p 0
     D  g4arse                        2p 0
     D  g4oper                        7p 0
     D  g4poli                        7p 0
     D  g4endo                        7p 0
     D  g4mar1                        1a
     D  g4nres                       30a
     D  g4usr1                       10a
     D  g4fec1                        8p 0
     D  g4tim1                        6p 0
     D  g4mar2                        1a
     D  g4erm2                       80a
     D  g4ema2                       50a
     D  g4usr2                       10a
     D  g4fec2                        8p 0
     D  g4tim2                        6p 0
     D  g4mar3                        1a
     D  g4erm3                       80a
     D  g4ema3                       50a
     D  g4usr3                       10a
     D  g4fec3                        8p 0
     D  g4tim3                        6p 0
     D  g4mar4                        1a
     D  g4erm4                       80a
     D  g4ema4                       50a
     D  g4usr4                       10a
     D  g4fec4                        8p 0
     D  g4tim4                        6p 0
     D  g4mar5                        1a
     D  g4mar6                        1a
     D  g4mar7                        1a
     D  g4mar8                        1a
     D  g4mar9                        1a
     D  g4mar0                        1a
     D  g4cmot                        2p 0
     D  g4ntel                       20a

     D dsPahtan_t      ds                  qualified template
     D  anempr                        1a
     D  ansucu                        2a
     D  annivt                        1p 0
     D  annivc                        5p 0
     D  anarcd                        6p 0
     D  anspol                        9p 0
     D  anrama                        2p 0
     D  anarse                        2p 0
     D  anoper                        7p 0
     D  anpoli                        7p 0
     D  anendo                        7p 0
     D  annres                       30a
     D  anmar1                        1a
     D  anmar2                        1a
     D  anmar3                        1a
     D  anmar4                        1a
     D  anmar5                        1a
     D  anmar6                        1a
     D  anmar7                        1a
     D  anmar8                        1a
     D  anmar9                        1a
     D  anmar0                        1a
     D  anobse                      300a
     D  anarch                      300a
     D  anusr1                       10a
     D  anfec1                        8p 0
     D  antim1                        6p 0
      * ----------------------------------------------------------------- *
      * SVPAGA_getListaArrepentimiento(): Retorna Lista de arrepentimiento*
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peNivt   ( input  ) Tipo Nivel Intermediario              *
      *         peNivc   ( input  ) Codigo Nivel Intermediario
      *         peArcd   ( input  ) Código de Artículo       ( opcional ) *
      *         peSpol   ( input  ) Número de SuperPoliza    ( opcional ) *
      *         peRama   ( input  ) Rama                     ( opcional ) *
      *         peArse   ( input  ) Cant. Pólizas por Rama   ( opcional ) *
      *         peOper   ( input  ) Operación                ( opcional ) *
      *         pePoli   ( input  ) Póliza                   ( opcional ) *
      *         peLArr   ( output ) Lista de Arrepentimiento ( opcional ) *
      *         peLArrC  ( output ) Cantidad                 ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPAGA_getListaArrepentimiento...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 options( *Nopass : *Omit ) const
     D   peSpol                       9  0 options( *Nopass : *Omit ) const
     D   peRama                       2  0 options( *Nopass : *Omit ) const
     D   peArse                       2  0 options( *Nopass : *Omit ) const
     D   peOper                       7  0 options( *Nopass : *Omit ) const
     D   pePoli                       7  0 options( *Nopass : *Omit ) const
     D   peEndo                       7  0 options( *Nopass : *Omit ) const
     D   peLArr                            likeds(dsPahtan_t) dim(999)
     D                                     options( *Nopass : *Omit )
     D   peLArrC                     10i 0 options( *Nopass : *Omit )

      * ------------------------------------------------------------ *
      * SVPAGA_inz(): Inicializa módulo.                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPAGA_inz      pr

      * ------------------------------------------------------------ *
      * SVPAGA_End(): Finaliza módulo.                               *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPAGA_End      pr

      * ----------------------------------------------------------------- *
      * SVPAGA_getListaArrep72hrsXProd(): Retorna Lista de arrepentimiento*
      *                                   dentro de las 72 horas por pro- *
      *                                   ductor                          *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peNivt   ( input  ) Tipo Nivel Intermediario             *
      *          peNivc   ( input  ) Codigo Nivel Intermediario           *
      *          peLa72   ( output ) Lista de Arrepentimiento             *
      *          peLa72C  ( output ) Cantidad                             *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPAGA_getListaArrep72hrsXProd...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peLa72                            likeds(dsPahtan_t) dim(999)
     D   peLa72C                     10i 0

      * ----------------------------------------------------------------- *
      * SVPAGA_getPahag4(): Retorna datos del archivo PAHAG4.             *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peArcd   ( input  ) Código de Artículo                    *
      *         peSpol   ( input  ) Número de SuperPoliza                 *
      *         peRama   ( input  ) Rama                     ( opcional ) *
      *         peArse   ( input  ) Cant. Pólizas por Rama   ( opcional ) *
      *         peOper   ( input  ) Operación                ( opcional ) *
      *         pePoli   ( input  ) Póliza                   ( opcional ) *
      *         peEndo   ( input  ) Número de Endoso         ( opcional ) *
      *         peDsAg   ( output ) Lista de Arrepentimiento ( opcional ) *
      *         peDsAgC  ( output ) Cantidad                 ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPAGA_getPahag4...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *Nopass : *Omit ) const
     D   peArse                       2  0 options( *Nopass : *Omit ) const
     D   peOper                       7  0 options( *Nopass : *Omit ) const
     D   pePoli                       7  0 options( *Nopass : *Omit ) const
     D   peEndo                       7  0 options( *Nopass : *Omit ) const
     D   peDsAg                            likeds(dsPahag4_t) dim(999)
     D                                     options( *Nopass : *Omit )
     D   peDsAgC                     10i 0 options( *Nopass : *Omit )

      * ----------------------------------------------------------------- *
      * SVPAGA_getListaArrepXProductor(): Retorna Lista de arrepentimiento*
      *                                   por productor.                  *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peNivt   ( input  ) Tipo Nivel Intermediario             *
      *          peNivc   ( input  ) Codigo Nivel Intermediario           *
      *          peLaPr   ( output ) Lista de Arrepentimiento             *
      *          peLaPrC  ( output ) Cantidad                             *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPAGA_getListaArrepXProductor...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peLaPr                            likeds(dsPahtan_t) dim(999)
     D   peLaPrC                     10i 0

      * ----------------------------------------------------------------- *
      * SVPAGA_chkSolicitudXNres(): Chequea y retorna datos de solicitud  *
      *                             de arrepentimiento.                   *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peNres   ( input  ) ID Trámite                           *
      *          peArcd   ( output ) Código de Artículo      ( opcional ) *
      *          peSpol   ( output ) Número de SuperPoliza   ( opcional ) *
      *          peRama   ( output ) Rama                    ( opcional ) *
      *          peArse   ( output ) Cant. Pólizas por Rama  ( opcional ) *
      *          peOper   ( output ) Operación               ( opcional ) *
      *          pePoli   ( output ) Póliza                  ( opcional ) *
      *          peEndo   ( output ) Número de Endoso        ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPAGA_chkSolicitudXNres...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNres                      30    const
     D   peArcd                       6  0 options( *Nopass : *Omit )
     D   peSpol                       9  0 options( *Nopass : *Omit )
     D   peRama                       2  0 options( *Nopass : *Omit )
     D   peArse                       2  0 options( *Nopass : *Omit )
     D   peOper                       7  0 options( *Nopass : *Omit )
     D   pePoli                       7  0 options( *Nopass : *Omit )
     D   peEndo                       7  0 options( *Nopass : *Omit )

      * ----------------------------------------------------------------- *
      * SVPAGA_updEstatusPahag4(): Actualiza estatus del archivo PAHAG4   *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peArcd   ( input  ) Código de Artículo                   *
      *          peSpol   ( input  ) Número de SuperPoliza                *
      *          peRama   ( input  ) Rama                                 *
      *          peArse   ( input  ) Cant. Pólizas por Rama               *
      *          peOper   ( input  ) Operación                            *
      *          pePoli   ( input  ) Póliza                               *
      *          peEndo   ( input  ) Número de Endoso                     *
      *          peEsta   ( input  ) Estatus                              *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPAGA_updEstatusPahag4...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peEndo                       7  0 const
     D   peEsta                       1    const

      * ----------------------------------------------------------------- *
      * SVPAGA_updPahtan(): Actualiza datos en el archivo pahtan          *
      *                                                                   *
      *          peDsGt   ( input  ) Estrutura de pahtan                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPAGA_updPahtan...
     D                 pr              n
     D   peDsG5                            likeds( dsPahtan_t ) const
