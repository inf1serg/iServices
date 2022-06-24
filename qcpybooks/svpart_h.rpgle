      /if defined(SVPART_H)
      /eof
      /endif
      /define SVPART_H

      // Estructura de SET620...
     D dsset620_t      ds                  qualified template
     D   t@arcd                       6p 0
     D   t@arno                      30
     D   t@free                       1
     D   t@dupe                       2p 0
     D   t@bloq                       1
     D   t@feda                       4p 0
     D   t@fedm                       2p 0
     D   t@fedd                       2p 0
     D   t@arcn                       6p 0
     D   t@opsn                       1
     D   t@dopu                       1
     D   t@dup1                       2p 0
     D   t@user                      10
     D   t@date                       6p 0
     D   t@mar1                       1
     D   t@mar2                       1
     D   t@mar3                       1
     D   t@mar4                       1
     D   t@mar5                       1
     D   t@arn1                      10
     D   t@arn2                      10
     D   t@arn3                      10

      // Estructura de SET630...
     D dsset630_t      ds                  qualified template
     D   t@arcd                       6p 0
     D   t@ippv                       1
     D   t@ippa                       1
     D   t@crca                       1
     D   t@ma01                       1
     D   t@ma02                       1
     D   t@ma03                       1
     D   t@ma04                       1
     D   t@ma05                       1
     D   t@ma06                       1
     D   t@ma07                       1
     D   t@ma08                       1
     D   t@ma09                       1
     D   t@ma10                       1
     D   t@user                      10
     D   t@date                       6p 0
     D   t@ma11                       1
     D   t@ma12                       1
     D   t@ma13                       1
     D   t@ma14                       1
     D   t@ma15                       1
     D   t@ma16                       1
     D   t@ma17                       1
     D   t@ma18                       1
     D   t@ma19                       1
     D   t@ma20                       1
     D   t@ma21                       1
     D   t@ma22                       1
     D   t@ma23                       1
     D   t@ma24                       1
     D   t@ma25                       1
     D   t@ma26                       1
     D   t@ma27                       1
     D   t@ma28                       1
     D   t@ma29                       1
     D   t@ma30                       1
     D   t@tpcd                       2
     D   t@ipgm                      10
     D   t@ma31                       1
     D   t@ma32                       1
     D   t@ma33                       1
     D   t@ma34                       1
     D   t@ma35                       1
     D   t@ma36                       1
     D   t@ma37                       1
     D   t@ma38                       1
     D   t@ma39                       1
     D   t@ma40                       1
     D   t@ma41                       1
     D   t@ma42                       1
     D   t@ma43                       1
     D   t@ma44                       1

      // Estructura de SET630W...
     D dsset630w_t     ds                  qualified template
     D   t@arcd                       6p 0
     D   t@fech                       8p 0
     D   t@secu                       3p 0
     D   t@mp01                       1
     D   t@user                      10
     D   t@date                       8p 0
     D   t@time                       6p 0

     D dsset630w2_t    ds                  qualified template
     D   t@arcd                       6p 0
     D   t@fech                       8p 0
     D   t@secu                       3p 0
     D   t@mp01                       1
     D   t@user                      10
     D   t@date                       8p 0
     D   t@time                       6p 0
     D   t@garc                       6p 0

      // Estructura de SET621...
     D dsset621_t      ds                  qualified template
     D   t@arcd                       6p 0
     D   t@rama                       2p 0
     D   t@arse                       2p 0
     D   t@ncoc                       5P 0
     D   t@dupe                       2P 0
     D   t@mone                       2
     D   t@plac                       3p 0
     D   t@psct                       1
     D   t@psca                       1
     D   t@rdpa                       1
     D   t@mar1                       1
     D   t@user                      10
     D   t@date                       6p 0
     D   t@mar2                       1
     D   t@mar3                       1
     D   t@mar4                       1
     D   t@mar5                       1
     D   t@orde                       2p 0
     D   t@mar6                       1
     D   t@mar7                       1
     D   t@mar8                       1
     D   t@mar9                       1

     D dsset639_t      ds                  qualified template
     D  t@garc                        6  0
     D  t@dgar                       30a
     D  t@mweb                        1a
     D  t@orde                        6  0
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
     D  t@date                        8  0
     D  t@time                        6  0
     D  t@user                       10a

     D dsset639_t1     ds                  qualified template
     D  t@garc                        6  0
     D  t@dgar                       30a
     D  t@mweb                        1a
     D  t@orde                        6  0
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
     D  t@date                        8  0
     D  t@time                        6  0
     D  t@user                       10a
     D  t@icon                       10a

     D dsset625_t      ds                  qualified template
     D  t@arcd                        6  0
     D  t@rama                        2  0
     D  t@arse                        2  0
     D  t@cobl                        2
     D  t@claa                        3  0
     D  t@tarc                        2  0
     D  t@tair                        2  0
     D  t@scta                        1  0
     D  t@cfas                        1
     D  tanio1                        4  0
     D  tanio2                        4  0
     D  t@prp1                        5  0
     D  t@prp2                        5  0
     D  t@prp3                        5  0
     D  t@user                       10
     D  t@date                        6  0
     D  t@mar1                        1
     D  t@mar2                        1
     D  t@mar3                        1
     D  t@mar4                        1
     D  t@mar5                        1

      *-- Copy's ----------------------------------------------------*

     * ------------------------------------------------------------ *
     * SVPART_inz(): Inicializa módulo.                             *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPART_inz      pr

     * ------------------------------------------------------------ *
     * SVPART_end():  Finaliza módulo.                              *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPART_end      pr

     * ------------------------------------------------------------ *
     * SVPART_Error(): Retorna el último error del service program  *
     *                                                              *
     *     peEnbr   (output)  Número de error (opcional)            *
     *                                                              *
     * Retorna: Mensaje de error.                                   *
     * ------------------------------------------------------------ *

     D SVPART_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPART_chkArticulo: Chequear si existe el Articulo.-         *
     *                                                              *
     *     peArcd   (input)   Articulo                              *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_chkArticulo...
     D                 pr              n
     D   peArcd                       6  0 const

     * ------------------------------------------------------------ *
     * SVPART_getArticulo: Retorna Informacion del Articulo.-       *
     *                                                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peDsAr   ( output ) Estructura de Articulo               *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_getArticulo...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peDsAr                            likeds( dsset620_t )

     * ------------------------------------------------------------ *
     * SVPART_setArticulo: Graba Informacion del Articulo.-         *
     *                                                              *
     *     peDsAr   ( input )  Estructura de Articulo               *
     *                                                              *
     * Retorna: *on = Grabo / *off = No Grabo                       *
     * ------------------------------------------------------------ *
     D SVPART_setArticulo...
     D                 pr              n
     D   peDsAr                            likeds( dsset620_t )

     * ------------------------------------------------------------ *
     * SVPART_updArticulo: Actualiza informacion del Articulo.-     *
     *                                                              *
     *     peDsAr   ( input )  Estructura de Articulo               *
     *                                                              *
     * Retorna: *on = Actualizó / *off = No Actualizó               *
     * ------------------------------------------------------------ *
     D SVPART_updArticulo...
     D                 pr              n
     D   peDsAr                            likeds( dsset620_t )

     * ------------------------------------------------------------ *
     * SVPART_delArticulo: eliminar un Articulo.-                   *
     *                                                              *
     *     peArcd   (input)   Articulo                              *
     *                                                              *
     * Retorna: *on = Si Eliminó / *off = No Eliminó                *
     * ------------------------------------------------------------ *
     D SVPART_delArticulo...
     D                 pr              n
     D   peArcd                       6  0 const

     * ------------------------------------------------------------ *
     * SVPART_chkParametria: Chequear si el Articulo tiene cargado  *
     *                       parametros.-                           *
     *                                                              *
     *     peArcd   (input)   Articulo                              *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_chkParametria...
     D                 pr              n
     D   peArcd                       6  0 const

     * ------------------------------------------------------------ *
     * SVPART_getParametria: Retorna Paramertia de Articulos        *
     *                                                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peDsPa   ( output ) Estructura de Parametria de Articulo *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_getParametria...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peDsPa                            likeds( dsset630_t )

     * ------------------------------------------------------------ *
     * SVPART_setParametria: Graba Parametria de Articulos.-        *
     *                                                              *
     *     peDsPa   ( input )  Estructura de Parametria de Articulos*
     *                                                              *
     * Retorna: *on = Grabó / *off = No Grabó                       *
     * ------------------------------------------------------------ *
     D SVPART_setParametria...
     D                 pr              n
     D   peDsPa                            likeds( dsset630_t )

     * ------------------------------------------------------------ *
     * SVPART_updParametria: Actualiza parametria de un Articulo    *
     *                                                              *
     *     peDsAr   ( input )  Estructura de Parametria de Articulo *
     *                                                              *
     * Retorna: *on = Actualizó / *off = No Actualizó               *
     * ------------------------------------------------------------ *
     D SVPART_updParametria...
     D                 pr              n
     D   peDsPa                            likeds( dsset630_t )

     * ------------------------------------------------------------ *
     * SVPART_delParametria: Eliminar parametria de un Articulo     *
     *                                                              *
     *     peArcd   (input)   Articulo                              *
     *                                                              *
     * Retorna: *on = Si Eliminó / *off = No Eliminó                *
     * ------------------------------------------------------------ *
     D SVPART_delParametria...
     D                 pr              n
     D   peArcd                       6  0 const

     * ------------------------------------------------------------ *
     * SVPART_chkParametriaWeb:chequear si el Articulo tiene cargado*
     *                       parametros WEB.-                       *
     *                                                              *
     *     peArcd   (input)   Articulo                              *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_chkParametriaWeb...
     D                 pr              n
     D   peArcd                       6  0 const

     * ------------------------------------------------------------ *
     * SVPART_getParametriaWeb: Retorna Paramertia de Articulos WEB *
     *                                                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peDsPw   ( output ) Estructura de Parametria de Articulo *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_getParametriaWeb...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peDsPw                            likeds( dsset630w_t )

     * ------------------------------------------------------------ *
     * SVPART_setParametriaWeb: Graba Parametria de Articulos.-     *
     *                                                              *
     *     peDsPw   ( input )  Estructura de Parametria de Articulos*
     *                                                              *
     * Retorna: *on = Grabó / *off = No Grabó                       *
     * ------------------------------------------------------------ *
     D SVPART_setParametriaWeb...
     D                 pr              n
     D   peDsPw                            likeds( dsset630w_t )

     * ------------------------------------------------------------ *
     * SVPART_updParametriaWeb: Actualiza parametria de un Articulo *
     *                          Web                                 *
     *     peDsPw   ( input )  Estructura de Parametria de Articulo *
     *                                                              *
     * Retorna: *on = Actualizó / *off = No Actualizó               *
     * ------------------------------------------------------------ *
     D SVPART_updParametriaWeb...
     D                 pr              n
     D   peDsPw                            likeds( dsset630w_t )

     * ------------------------------------------------------------ *
     * SVPART_delParametriaWeb: Eliminar parametria de un Articulo  *
     *                          Web                                 *
     *     peArcd   (input)   Articulo                              *
     *                                                              *
     * Retorna: *on = Si Eliminó / *off = No Eliminó                *
     * ------------------------------------------------------------ *
     D SVPART_delParametriaWeb...
     D                 pr              n
     D   peArcd                       6  0 const

     * ------------------------------------------------------------ *
     * SVPART_chkBloqueo: Verificar si el Articulo se encuentra     *
     *                    bloqueado.-                               *
     *                                                              *
     *     peArcd   (input)   Articulo                              *
     *                                                              *
     * Retorna: *on = Bloqueado / *off = No Bloqueado               *
     * ------------------------------------------------------------ *
     D SVPART_chkBloqueo...
     D                 pr              n
     D   peArcd                       6  0 const

      * ------------------------------------------------------------ *
      * SVPART_chkArticuloRama : Verifica si el Articulo existe.-    *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPART_chkArticuloRama...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const

      * ------------------------------------------------------------ *
      * SVPART_getArticuloRama: Retorna Informacion del Articulo.-   *
      *                         y sus ramas.                         *
      *     peArcd   ( input  ) Articulo                             *
      *     peDsAr   ( output ) Estructura de Articulo y ramas       *
      *     peDsArC  ( output ) Canidad de Articulos Ramas           *
      *     peRama   ( input  ) Rama   ( opcional )                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPART_getArticuloRama...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peDsAr                            likeds( dsset621_t ) dim( 2 )
     D   peDsArC                     10i 0
     D   peRama                       6  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPART_getArticulos: Retorna todos los Articulos             *
      *                                                              *
      *     peDsAr  ( output ) Estructura de Artículos               *
      *     peDsArC ( output ) Cantidad de Artículos                 *
      *     peArcd  ( input  ) Código de Articulo     ( opcional )   *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPART_getArticulos...
     D                 pr              n
     D   peDsAr                            likeds(dsset620_t) dim(9999)
     D   peDsArC                     10i 0
     D   peArcd                       6  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPART_getArticulosWeb: Retorna todos los Articulos          *
      *                                                              *
      *     peDsAr  ( output ) Estructura de Artículos               *
      *     peDsArC ( output ) Cantidad de Artículos                 *
      *     peArcd  ( input  ) Código de Articulo     ( opcional )   *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPART_getArticulosWeb...
     D                 pr              n
     D   peDsAr                            likeds(dsset620_t) dim(9999)
     D   peDsArC                     10i 0
     D   peArcd                       6  0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPART_chkScoring : Valida código Articulo maneja  Scoring.  *
      *                                                              *
      *     peArcd   (input)   Código de Articulo                    *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Cant. de Rama/Articulo                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPART_chkScoring...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     * ------------------------------------------------------------ *
     * SVPART_getGrupo: Retorna Información de Grupo de Artículos   *
     *                                                              *
     *     peGarc   ( input  ) Articulo                             *
     *     peDsAr   ( output ) Estructura de Grupo de Artículos     *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_getGrupo...
     D                 pr              n
     D   peGarc                       6  0 const
     D   peDsAr                            likeds( dsset639_t )

     * ------------------------------------------------------------ *
     * SVPART_getParametriaWeb2: Retorna Parametría de Artículos WEB*
     *                                                              *
     *     peArcd   ( input  ) Articulo                             *
     *     peDsPw   ( output ) Estructura de Parametría de Artículo *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_getParametriaWeb2...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peDsPw                            likeds( dsset630w2_t )

     * ------------------------------------------------------------ *
     * SVPART_getGrupoArticulos: Retorna los Aticulos de un         *
     *                           Grupo Determinado.                 *
     *                                                              *
     *     peGarc   ( input  ) Grupo                                *
     *     peDsPw   ( output ) Estructura de Parametría de Artículo *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_getGrupoArticulos...
     D                 pr              n
     D   peGarc                       6  0 const
     D   peDsPw                            likeds( dsset630w2_t ) dim(9999)
     D   peDsPwC                     10i 0

     * ------------------------------------------------------------ *
     * SVPART_getGrupo: Retorna Información de Grupo de Artículos   *
     *                                                              *
     *     peGarc   ( input  ) Articulo                             *
     *     peDsAr   ( output ) Estructura de Grupo de Artículos     *
     *                                                              *
     * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     * ------------------------------------------------------------ *
     D SVPART_getGrupo2...
     D                 pr              n
     D   peGarc                       6  0 const
     D   peDsAr                            likeds( dsset639_t1)

      * ------------------------------------------------------------ *
      * SVPART_getExt625 : Retorna información de extension de       *
      *                    un artículo. Archivo set625               *
      *                                                              *
      *     peArcd  ( input  ) Articulo                              *
      *     peRama  ( input  ) Rama                    ( opcional )  *
      *     peArse  ( input  ) Cant. Polizas           ( opcional )  *
      *     peDsAr  ( output ) Estructura de Artículos ( opcional )  *
      *     peDsArC ( output ) Cantidad de Artículos   ( opcional )  *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPART_getExt625...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peDs625                           likeds( dsset625_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDs625C                    10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPART_isMensual : Retorna si es mensual el artículo.        *
      *                                                              *
      *     peArcd  ( input  ) Articulo                              *
      *     peRama  ( input  ) Rama                                  *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPART_isMensual...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const

      * ------------------------------------------------------------ *
      * SVPART_getNumeroProveido : Retorna Numero Proveido           *
      *                                                              *
      *     peArcd  ( input  ) Articulo                              *
      *     peRama  ( input  ) Rama                                  *
      *     peArse  ( input  ) Cant. Polizas                         *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPART_getNumeroProveido...
     D                 pr             9  0
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

