      /if defined(SPVANUL_H)
      /eof
      /endif
      /define SPVANUL_H

      * Poliza ya Anulada...
     D SPVANUL_YAANU   c                   const(0101)
      * No puede Rehabilit Póliza no anulada
     D SPVANUL_Noreha  c                   const(0102)
      * Poliza en proceso...
     D SPVANUL_ENPR    c                   const(0103)
      * Póliza bloqueada
     D SPVANUL_SPDWYP  c                   const(0104)
      * Póliza Pndte. Speedway
     D SPVANUL_PBLQ    c                   const(0105)
      * Pol.Bloqueada renovandose por otro Artic...
     D SPVANUL_PEMI    c                   const(0106)
      * Póliza en estado "crítico"...Registro Bloqueado x Cobranza...
     D SPVANUL_POCR    c                   const(0107)
      * Póliza con Siniestros...
     D SPVANUL_PSIN    c                   const(0108)
      * Siniestros Posteriores a Fecha de Anulación
     D SPVANUL_SIPAN   c                   const(0109)
     * cuotas en proceso de cobranza...
     D SPVANUL_CUPR    c                   const(0110)
     * póliza sin saldo pendiente...
     D SPVANUL_POSS    c                   const(0111)
     * fecha anulación fuera de la vigencia de la poliza...                               ||
     D SPVANUL_FEFV    c                   const(0112)
     * Cabecera de Póliza indica Póliza Anulada...                                        ||
     D SPVANUL_POANU   c                   const(0113)
     * Póliza sin Cabecera de póliza...                                                   ||
     D SPVANUL_SCAB    c                   const(0114)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SPVANUL_ERDS_T  ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SPVANUL_EstadOK():Chequea Estado Póliza a Anular             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *     peFema   (input)   Año                                   *
      *     peFemm   (input)   Mes                                   *
      *     peFemd   (input)   Día                                   *
      *     petiou   (input)   Tipo operación (opcional)             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_EstadOK...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peFemd                       2  0 const
     D   petiou                       1  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVANUL_PolenPro(): Chequea si la póliza se esta procesando  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_PolenPro...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVANUL_Polspdwy(): Chequea si la póliza se esta procesando  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Código Artículo                       *
      *     pePoli   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_Polspdwy...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

      * ------------------------------------------------------------ *
      * SPVANUL_PolBlq():Chequea bloqueo de Póliza a Anular          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_PolBlq...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVANUL_PLEMI():Chequea bloqueo de Póliza en pawemi01.       *
      *                 Bloqueo renovandose x otro articulo          *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_PLEMI...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVANUL_POCRI():Chequea si Póliza esta en "Estado Crítico"   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_POCRI...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVANUL_POSIN():Chequea si Póliza con siniestros abiertos    *
      *                 depende de pahscd11                          *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *     peFeEmi  (input)   Fecha Emisión Informada               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_POSIN...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFeEmi                      8  0 const

      * ------------------------------------------------------------ *
      * SPVANUL_POANUL(): Chequea si Cabecera de pòliza con Indicati-*
      *                   vo de Anulación                            *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_POANUL...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVANUL_FVIG (): Chequea si Póliza está Vigente              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *     peFAnu   (input)   Fecha de Anulación (si no se pasa     *
      *                         se toma con PAR310X3                 *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_FVIG...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peFAnu                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVANUL_SSALD(): Chequea si tiene saldo la póliza             *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_SSALD...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
      *                                                              *
      * ------------------------------------------------------------ *
      * SPVANUL_cuopr(): Chequea si tiene cuotas en proceso           *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peSpol   (input)   Superpóliza                           *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVANUL_cuopr...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SPVANUL_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVANUL_inz     pr

      * ------------------------------------------------------------ *
      * SPVANUL_End(): Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVANUL_End     pr

      * ------------------------------------------------------------ *
      * SPVANUL_Error(): Retorna el último error del service program *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SPVANUL_Error   pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

