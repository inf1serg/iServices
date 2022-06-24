      /if defined(SVPWEB_H)
      /eof
      /endif
      /define SVPWEB_H

      * Codigo de Articulo Inexistente...
     D SVPWEB_ARTIN    c                   const(0001)

      * --------------------------------------------------- *
      * Estructura de datos con el último error
      * --------------------------------------------------- *
     D SVPWEB_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * --------------------------------------------------- *
      * Estructura de datos Registro Parametros WEB
      * --------------------------------------------------- *
     D dsParamWeb_t    ds                  qualified template
     D   t@empr                       1
     D   t@sucu                       2
     D   t@arcd                       6p 0
     D   t@fech                       8p 0
     D   t@secu                       5p 0
     D   t@uemi                       1
     D   t@cemi                       5p 0
     D   t@sald                      15p 2
     D   t@upas                       1
     D   t@cpas                       5p 0
     D   t@udes                       1
     D   t@cdes                       5p 0
     D   t@tvha                       3p 0
     D   t@mar1                       1
     D   t@mar2                       1
     D   t@mar3                       1
     D   t@mar4                       1
     D   t@mar5                       1
     D   t@rams                       2p 0
     D   t@arcc                       6p 0
     D   t@ramc                       2p 0
     D   t@user                      10
     D   t@date                       6p 0
     D   t@time                       6p 0
     D   t@shco                       1
     D   t@paco                      50
     D   t@lico                     150
     D   t@shem                       1
     D   t@paem                      50
     D   t@liem                     150

      * ------------------------------------------------------------ *
      * SVPWEB_chkArt(): Chequea Codigo de Articulo                  *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPWEB_chkArt...
     D                 pr              n
     D   peArcd                       6  0 const

      * ------------------------------------------------------------ *
      * SVPWEB_getDescArt(): Retorna Descripcion de Articulo         *
      *                                                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *                                                              *
      * Retorna: Blanco en caso de error                             *
      * ------------------------------------------------------------ *

     D SVPWEB_getDescArt...
     D                 pr            30
     D   peArcd                       6  0 const

      * ------------------------------------------------------------ *
      * SVPWEB_setPar(): Graba Parametros                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peFech   (input)   Fecha                                 *
      *     peSecu   (input)   Secuencia                             *
      *     peUemi   (input)   Unidad para Fecha Emision             *
      *     peCemi   (input)   Cantidad para Fecha Emision           *
      *     peSald   (input)   Saldo Maximo                          *
      *     peUpas   (input)   Unidad para Pago Siniestros           *
      *     peCpas   (input)   Cantidad Pago Siniestros              *
      *     peUdes   (input)   Unidad Denuncia Siniestros            *
      *     peCdes   (input)   Cantidad Denuncia Siniestros          *
      *     peTvha   (input)   Tope Vigencia Hasta                   *
      *     peMar1   (input)   Marca Proceso 1                       *
      *     peMar2   (input)   Marca Proceso 2                       *
      *     peMar3   (input)   Marca Proceso 3                       *
      *     peMar4   (input)   Marca Proceso 4                       *
      *     peMar5   (input)   Marca Proceso 5                       *
      *     peRams   (input)   Convertir desde Rama                  *
      *     peArcc   (input)   Convertir hacia Articulo              *
      *     peRamc   (input)   Convertir hacia Rama                  *
      *     peUser   (input)   Usuario Proceso                       *
      *     peDate   (input)   Fecha  Proceso                        *
      *     peTime   (input)   Hora Proceso                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPWEB_setPar...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peFech                       8  0 const
     D   peUemi                       1    const
     D   peCemi                       5  0 const
     D   peSald                      15  2 const
     D   peUpas                       1    const
     D   pecpas                       5  0 const
     D   peUdes                       1    const
     D   peCdes                       5  0 const
     D   peTvha                       3  0 const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peMar5                       1    const
     D   peRams                       2  0 const
     D   peArcc                       6  0 const
     D   peRamc                       2  0 const
     D   peUser                      10    const
     D   peDate                       6  0 const
     D   peTime                       6  0 const

      * ------------------------------------------------------------ *
      * SVPWEB_getPar(): Recupera  Parametros                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPWEB_getPar...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peFech                       8  0
     D   pSecu                        5  0
     D   pUemi                        1
     D   pCemi                        5  0
     D   pSald                       15  2
     D   pUpas                        1
     D   pcpas                        5  0
     D   pUdes                        1
     D   pCdes                        5  0
     D   pTvha                        3  0
     D   pMar1                        1
     D   pMar2                        1
     D   pMar3                        1
     D   pMar4                        1
     D   pMar5                        1
     D   pRams                        2  0
     D   pArcc                        6  0
     D   pRamc                        2  0
     D   pUser                       10
     D   pDate                        6  0
     D   pTime                        6  0

      * ------------------------------------------------------------ *
      * SVPWEB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPWEB_inz      pr

      * ------------------------------------------------------------ *
      * SVPWEB_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPWEB_end      pr

      * ------------------------------------------------------------ *
      * SVPWEB_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPWEB_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SVPWEB_getParametrosWeb: Obtiene informacion para el proceso *
      *                          Web del tipo de Articulo.-          *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *     peDsPweb (output)  Estructura Parametros Web             *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPWEB_getParametrosWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peDsPweb                          likeds( dsParamWeb_t )
      * ------------------------------------------------------------ *
      * SVPWEB_getCalculoFechaHasta: Obtiene la forma de calculo     *
      *          de la Fecha Hasta para el tipo de Articulo.-        *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *                                                              *
      * Retorna: *on = Si calculo automatico / *off = Si no autom.   *
      * ------------------------------------------------------------ *
     D SVPWEB_getCalculoFechaHasta...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
      * ------------------------------------------------------------ *
      * SVPWEB_getTopeVigenciaHasta: Obtiene la cantidad de dias     *
      *                         del tope de vigencia en la emision.- *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *     peTvha   (output)  Tope Vigencia Hasta                   *
      *                                                              *
      * Retorna: *on = Si obtiene valor / *off = Si error            *
      * ------------------------------------------------------------ *
     D SVPWEB_getTopeVigenciaHasta...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peTvha                       3  0
      * ------------------------------------------------------------ *
      * SVPWEB_getConvertirArticuloRamaEmision: Obtiene combinacion  *
      * Articulo-Rama (T@ARCC-T@RAMC) si Marca habilitada (T@MAR3).- *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *     peRams   (output)  Convertir desde Rama                  *
      *     peArcc   (output)  Convertir a Articulo                  *
      *     peRamc   (output)  Convertir a Rama                      *
      *                                                              *
      * Retorna: *on = Si obtiene valores / *off = Si error          *
      * ------------------------------------------------------------ *
     D SVPWEB_getConvertirArticuloRamaEmision...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRams                       2  0
     D   peArcc                       6  0
     D   peRamc                       2  0
      * ------------------------------------------------------------ *
      * SVPWEB_okWeb  : Verifica web                                 *
      *                                                              *
      *      peRama   (input)    Código de Rama.                     *
      *      peXpro   (input)    Código de Producto.                 *
      *                                                              *
      * retorna: *ON si está habilitado para web, *OFF si no         *
      * ------------------------------------------------------------ *
     D SVPWEB_okWeb    pr             1N
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
      * ------------------------------------------------------------ *
      * SVPWEB_chkPar(): Chequea  Parametros                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPWEB_chkPar...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const

      * ------------------------------------------------------------ *
      * SVPWEB_setParametrosWeb(): Graba datos para la web de los    *
      *                            articulos.                        *
      *                                                              *
      *     peDsWb   ( input  ) Estructura de SETWEB                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPWEB_setParametrosWeb...
     D                 pr              n
     D   peDsWb                            likeds( dsParamWeb_t )
     D                                     options( *nopass : *omit ) const

      * ------------------------------------------------------------ *
      * SVPWEB_getParametrosWeb2: Obtiene informacion para el proceso*
      *                          Web del tipo de Articulo.-          *
      *                                                              *
      *     peEmpr   (input)   Cod Empresa                           *
      *     peSucu   (input)   Cod Sucursal                          *
      *     peArcd   (input)   Cod Articulo                          *
      *     peFech   (input)   Fecha                                 *
      *     peDsWb   (output)  Estructura Parametros Web             *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPWEB_getParametrosWeb2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peFech                       8  0 options( *nopass : *omit ) const
     D   peDsWb                            likeds( dsParamWeb_t )
     D                                     options( *nopass : *omit )
