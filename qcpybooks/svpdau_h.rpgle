      /if defined(SVPDAU_H)
      /eof
      /endif
      /define SVPDAU_H

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPDAU_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * Estructura DS set250                                         *
      * ------------------------------------------------------------ *
     D dsSet250_t      ds                  qualified template
     D   stempr                       1
     D   stsucu                       2
     D   starcd                       6p 0
     D   strama                       2p 0
     D   stccbp                       3p 0
     D   stmar1                       1
     D   stdcbp                      25
     D   stpcbp                       5p 2
     D   steppd                       5p 2
     D   stepph                       5p 2
     D   stmcbp                       1
     D   stmcer                       1
     D   stmar2                       1
     D   stccbe                       3
     D   stmar3                       1
     D   stmar4                       1
     D   stmar5                       1
     D   stmar6                       1
     D   stfcbp                       8p 0
     D   stffbp                       8p 0
     D   stuser                      10
     D   sttime                       6p 0
     D   stdate                       8p 0
     D   storde                       3p 0

      * ------------------------------------------------------------ *
      * Estructura DS set250                                         *
      * ------------------------------------------------------------ *
     D dsSet250_t2     ds                  qualified template
     D   stempr                       1
     D   stsucu                       2
     D   starcd                       6p 0
     D   strama                       2p 0
     D   stccbp                       3p 0
     D   stmar1                       1
     D   stdcbp                      25
     D   stpcbp                       5p 2
     D   steppd                       5p 2
     D   stepph                       5p 2
     D   stmcbp                       1
     D   stmcer                       1
     D   stmar2                       1
     D   stccbe                       3
     D   stmar3                       1
     D   stmar4                       1
     D   stmar5                       1
     D   stmar6                       1
     D   stfcbp                       8p 0
     D   stffbp                       8p 0
     D   stuser                      10
     D   sttime                       6p 0
     D   stdate                       8p 0
     D   storde                       3p 0
     D   stmar7                       1

     * ------------------------------------------------------------ *
     * SVPDAU_chkDescxEquivalente: Valida si Cod. de Descuento se   *
     *                             se encuentra asociado a un       *
     *                             determinado Cod. Equivalente.    *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbe   (input)   Cod. Descuento Equivalente            *
     *     peMar1   (input)   Poliza/Componente                     *
     *     peCcbp   (input)   Cod. Descuento                        *
     *                                                              *
     * Retorna: *on = Existe / *off = No Existe                     *
     * ------------------------------------------------------------ *
     D SVPDAU_chkDescxEquivalente...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbe                       3    const
     D   peMar1                       1    const
     D   peCcbp                       3  0 const

     * ------------------------------------------------------------ *
     * SVPDAU_getDescxEquivalente: Retorna datos de Descuento que   *
     *                             se encuentra asociado a un       *
     *                             determinado Cod. Equivalente.    *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbe   (input)   Cod. Descuento Equivalente            *
     *     peMar1   (input)   Poliza/Componente                     *
     *     peDesc   (output)  Estructura de Descuento( set250 )     *
     *                                                              *
     * Retorna: *on = Existe / *off = No Existe                     *
     * ------------------------------------------------------------ *
     D SVPDAU_getDescxEquivalente...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbe                       3    const
     D   peMar1                       1    const
     D   peDesc                            likeds( dsSet250_t )

      * ------------------------------------------------------------ *
      * SVPDAU_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDAU_inz      pr

      * ------------------------------------------------------------ *
      * SVPDAU_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDAU_end      pr

      * ------------------------------------------------------------ *
      * SVPDAU_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPDAU_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPDAU_isVigente(): Verifica si un descuento/recargo está    *
      *                     vigente a una determinada fecha.         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peRama   (input)   Rama                                  *
      *     peCcbp   (input)   Cod. Descuento                        *
      *     peMar1   (input)   Nivel (C=Componente/P=Poliza)         *
      *     peFech   (input)   Fecha a la cual chequear              *
      *                                                              *
      * Retorna: *on si está vigente, *off si no.                    *
      * ------------------------------------------------------------ *
     D SVPDAU_isVigente...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1a   const
     D   peFech                       8  0 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPDAU_getCodigoEquivalente(): Obtiene descuento equivalente *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peRama   (input)   Rama                                  *
      *     peCcbp   (input)   Cod. Descuento                        *
      *     peMar1   (input)   Nivel (C=Componente/P=Poliza)         *
      *                                                              *
      * Retorna: Código Equivalente                                  *
      * ------------------------------------------------------------ *
     D SVPDAU_getCodigoEquivalente...
     D                 pr             3a
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1a   const

     * ------------------------------------------------------------ *
     * SVPDAU_getXCodDescuento:  Retorna datos que se encuentre     *
     *                           asociado a un determinado Cod.     *
     *                           descuento.                         *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *     peDesc   (output)  Estructura de Descuento( set250 )     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPDAU_getXCodDescuento...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const
     D   peDesc                            likeds( dsset250_t )

     * ------------------------------------------------------------ *
     * SVPDAU_setDescuento(): Graba datos de componentes de         *
     *                        Bonificación de Prima.                *
     *                                                              *
     *     peDesc   ( input )  Estructura de Descuento( set250 )    *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPDAU_setDescuento...
     D                 pr              n
     D   peDesc                            likeds( dsset250_t ) const

     * ------------------------------------------------------------ *
     * SVPDAU_getPermiteCero():  Retorna si permite grabar en cero. *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPDAU_getPermiteCero...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const

     * ------------------------------------------------------------ *
     * SVPDAU_getPorcentajeBonif(): Retorna Porcentaje de Bonifica- *
     *                              ción.                           *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *                                                              *
     * Retorna: PCBP / *zeros                                       *
     * ------------------------------------------------------------ *
     D SVPDAU_getPorcentajeBonif...
     D                 pr             5  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const

     * ------------------------------------------------------------ *
     * SVPDAU_getPermiteCambioPorc(): Retorna si permite cambio de  *
     *                                porcentaje.                   *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPDAU_getPermiteCambioPorc...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const

     * ------------------------------------------------------------ *
     * SVPDAU_visualizarWeb(): Retorna si permite visualizar en la  *
     *                        consulta Web.                         *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPDAU_visualizarWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const

     * ------------------------------------------------------------ *
     * SVPDAU_getXCodDescuento2: Retorna datos que se encuentre     *
     *                           asociado a un determinado Cod.     *
     *                           descuento.                         *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Articulo                              *
     *     peRama   (input)   Rama                                  *
     *     peCcbp   (input)   Cod. Descuento                        *
     *     peMar1   (input)   Poliza/Componente                     *
     *     peDesc   (output)  Estructura de Descuento( set250 )     *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPDAU_getXCodDescuento2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D   peMar1                       1    const
     D   peDesc                            likeds( dsset250_t2 )

