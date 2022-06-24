      /if defined(SVPVIV_H)
      /eof
      /endif
      /define SVPVIV_H

      * Tipo de Vivienda Inexistente...
     D SVPVIV_VIVIN    c                   const(0001)
      * Tipo de Vivienda Bloqueada...
     D SVPVIV_VIVBL    c                   const(0002)
      * Tipo de Vivienda Utilizado en Poliza...
     D SVPVIV_VIVUT    c                   const(0003)
      * Tipo de Vivienda No Relacionada con Producto...
     D SVPVIV_VIVNR    c                   const(0004)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPVIV_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SVPVIV_chkViv(): Chequea Tipo de Vivienda                    *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVIV_chkViv...
     D                 pr              n
     D   peCviv                       3  0 const

      * ------------------------------------------------------------ *
      * SVPVIV_getDescViv(): Retorna Descripcion Tipo de Vivienda    *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: Blanco en caso de error                             *
      * ------------------------------------------------------------ *

     D SVPVIV_getDescViv...
     D                 pr            60
     D   peCviv                       3  0 const

      * ------------------------------------------------------------ *
      * SVPVIV_chkBloqViv(): Chequea Tipo de Vivienda Bloqueada      *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVIV_chkBloqViv...
     D                 pr              n
     D   peCviv                       3  0 const

      * ------------------------------------------------------------ *
      * SVPVIV_chkWebViv(): Chequea Tipo de Vivienda Inc/Exc Web     *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVIV_chkWebViv...
     D                 pr              n
     D   peCviv                       3  0 const

      * ------------------------------------------------------------ *
      * SVPVIV_setViv(): Graba Tipo de Vivienda                      *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *     peDviv   (input)   Descripcion de Tipo de Vivienda       *
      *     peUser   (input)   Usuario                               *
      *     peBloq   (input)   Marca de Bloqueo                      *
      *     peMweb   (input)   Incluye/Excluye Web                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVIV_setViv...
     D                 pr              n
     D   peCviv                       3  0 const
     D   peDviv                      60    const
     D   peUser                      10    const
     D   peBloq                       1    options(*nopass:*omit)
     D   peMweb                       1    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPVIV_updViv(): Bloquea/Desbloquea Tipo de Vivienda         *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVIV_updViv...
     D                 pr              n
     D   peCviv                       3  0 const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SVPVIV_webViv(): Incluye/Excluye en Web Tipo de Vivienda     *
      *                                                              *
      *     peMweb   (input)   Codigo de Tipo de Vivienda            *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVIV_webViv...
     D                 pr              n
     D   peCviv                       3  0 const
     D   peUser                      10    const
      * ------------------------------------------------------------ *
      * SVPVIV_dltViv(): Elimina Tipo de Vivienda                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVIV_dltViv...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCviv                       3  0 const

      * ------------------------------------------------------------ *
      * SVPVIV_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPVIV_inz      pr

      * ------------------------------------------------------------ *
      * SVPVIV_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPVIV_end      pr

      * ------------------------------------------------------------ *
      * SVPVIV_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPVIV_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPVIV_chkVivProducto(): Retorna si el Codigo de Vivienda    *
      *                          esta relacionado al Producto        *
      *                                                              *
      *     peCviv   (input)   Codigo de Tipo de Vivienda            *
      *     peRama   (input)   Codigo de Rama                        *
      *     peXpro   (input)   Codigo de Producto                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVIV_chkVivProducto...
     D                 pr              n
     D   peCviv                       3  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const

      * ------------------------------------------------------------ *
      * SVPVIV_getVivProducto(): Retorna Codigo de Vivienda por      *
      *                          defecto relacionado al Producto     *
      *                                                              *
      *     peRama   (input)   Codigo de Rama                        *
      *     peXpro   (input)   Codigo de Producto                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVIV_getVivProducto...
     D                 pr             3  0
     D   peRama                       2  0 const
     D   peXpro                       3  0 const

