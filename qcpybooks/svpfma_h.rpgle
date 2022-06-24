      /if defined(SVPFMA_H)
      /eof
      /endif
      /define SVPFMA_H

      /copy './qcpybooks/svpvls_h.rpgle'
      /copy './qcpybooks/czwutl_h.rpgle'

     D FMA_ANTIGUEDAD  c                   const(0001)
     D FMA_MARCAMODELO...
     D                 c                   const(0002)

      * ------------------------------------------------------------ *
      * Estructura de primas                                         *
      * ------------------------------------------------------------ *
     D primasAutos_t   ds                  qualified template
     D  prrc                         15  2
     D  prac                         15  2
     D  prin                         15  2
     D  prro                         15  2
     D  pacc                         15  2
     D  praa                         15  2
     D  prsf                         15  2
     D  prce                         15  2
     D  prap                         15  2

      * ------------------------------------------------------------ *
      * SVPFMA_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPFMA_inz      pr

      * ------------------------------------------------------------ *
      * SVPFMA_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPFMA_End      pr

      * ------------------------------------------------------------ *
      * SVPFMA_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPFMA_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPFMA_antiguedad(): Aplica factor por antigüedad            *
      *                                                              *
      *     peCtre   (input)   Tarifa                                *
      *     peVhan   (input)   Año del Vehiculo                      *
      *     peFema   (input)   Año actual                            *
      *     peCobl   (input)   Cobertura                             *
      *     peScta   (input)   Zona                                  *
      *     peM0km   (input)   Marca de 0 KM PRIMER AÑO              *
      *     peM0k2   (input)   Marca de 0 KM SEGUNDO AÑO             *
      *     peVhca   (input)   Capítulo                              *
      *     peVhv1   (input)   Variante RC                           *
      *     peVhv2   (input)   Variante AIR                          *
      *     peMtdf   (input)   Marca de Tarifa Diferencial           *
      *     pePrii   (input)   Primas Base                           *
      *     pePrio   (output)  Primas Salida                         *
      *     peCoef   (output)  Coeficiente Aplicado                  *
      *     peMar2   (output)  Sobre qué aplicó el coeficiente:      *
      *                        '0' RC                                *
      *                        '1' Casco                             *
      *                        '2' Ambos                             *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPFMA_antiguedad...
     D                 pr
     D  peCtre                        5  0 const
     D  peVhan                        4  0 const
     D  peFema                        4  0 const
     D  peCobl                        2a   const
     D  peScta                        1  0 const
     D  peM0km                        1a   const
     D  peM0k2                        1a   const
     D  peVhca                        2  0 const
     D  peVhv1                        1  0 const
     D  peVhv2                        1  0 const
     D  peMtdf                        1a   const
     D  pePrii                             likeds(primasAutos_t) const
     D  pePrio                             likeds(primasAutos_t)
     D  peCoef                        7  4
     D  peMar2                        1a

      * ------------------------------------------------------------ *
      * SVPFMA_marcaModelo(): Aplica factor por marca/modelo         *
      *                                                              *
      *     peCtre   (input)   Tarifa                                *
      *     peVhmc   (input)   Marca                                 *
      *     peVhmo   (input)   Modelo                                *
      *     peVhcs   (input)   Submodelo                             *
      *     pePrii   (input)   Primas Base                           *
      *     pePrio   (output)  Primas Salida                         *
      *     peCoef   (output)  Coeficiente Aplicado                  *
      *     peMar2   (output)  Sobre qué aplicó el coeficiente:      *
      *                        '0' RC                                *
      *                        '1' Casco                             *
      *                        '2' Ambos                             *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPFMA_marcaModelo...
     D                 pr
     D  peCtre                        5  0 const
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  pePrii                             likeds(primasAutos_t) const
     D  pePrio                             likeds(primasAutos_t)
     D  peCoef                        7  4
     D  peMar2                        1a

      * ------------------------------------------------------------ *
      * SVPFMA_getDescripcion(): Obtiene descripcion                 *
      *                                                              *
      *     peCcoe   (input)   Codigo de Coeficiente                 *
      *                                                              *
      * Retorna: Descripcion o blanco                                *
      * ------------------------------------------------------------ *
     D SVPFMA_getDescripcion...
     D                 pr            25a
     D  peCcoe                        3  0 const

      * ------------------------------------------------------------ *
      * SVPFMA_getEquivalente(): Obtiene codigo equivalente          *
      *                                                              *
      *     peCcoe   (input)   Codigo de Coeficiente                 *
      *                                                              *
      * Retorna: Equivalente o blanco                                *
      * ------------------------------------------------------------ *
     D SVPFMA_getEquivalente...
     D                 pr             3a
     D  peCcoe                        3  0 const

      * ------------------------------------------------------------ *
      * SVPFMA_tarifaDesdeAntig(): Obtiene tarifa a partir de la     *
      *                            cual arranca antigüedad.          *
      *                                                              *
      * Retorna: Tarifa desde antigüedad                             *
      * ------------------------------------------------------------ *
     D SVPFMA_tarifaDesdeAntig...
     D                 pr             5  0

      * ------------------------------------------------------------ *
      * SVPFMA_tarifaDesdeMarMo(): Obtiene tarifa a partir de la     *
      *                            cual arranca marca/modelo.        *
      *                                                              *
      * Retorna: Tarifa desde marca/modelo                           *
      * ------------------------------------------------------------ *
     D SVPFMA_tarifaDesdeMarMo...
     D                 pr             5  0

      * ------------------------------------------------------------ *
      * SVPFMA_getAplicadA(): Obtiene a qué componente de prima se   *
      *                       aplicó.                                *
      *                                                              *
      *     peMar2   (input)   Codigo de Aplicacion                  *
      *                                                              *
      * Retorna: Descripcion o blanco                                *
      * ------------------------------------------------------------ *
     D SVPFMA_getAplicadoA...
     D                 pr             5a
     D  peMar2                        1a   const

      * ------------------------------------------------------------ *
      * SVPFMA_visualizarWeb(): Recupera si se visualiza o no en la  *
      *                         web.                                 *
      *                                                              *
      *     peCcoe   (input)   Codigo de Factor                      *
      *                                                              *
      * Retorna: *on se visualiza/*off no se visualiza               *
      * ------------------------------------------------------------ *
     D SVPFMA_visualizarWeb...
     D                 pr             1n
     D  peCcoe                        3  0 const

