      /if defined(SVPDRS_H)
      /eof
      /endif
      /define SVPDRS_H

      * ------------------------------------------------------------ *
      * Estructura para Caracteristicas                              *
      * ------------------------------------------------------------ *
     D Caract_t        ds                  qualified template
     D   ccba                         3  0
     D   mar1                         1
     D   ma01                         1

      * Copy's ----------------------------------------------------- *
      /copy './qcpybooks/SVPDRV_H.rpgle'
      /copy './qcpybooks/SPVSPO_H.rpgle'

      * ------------------------------------------------------------ *
      * SVPDRS_getDescCob(): Retorna Descuentos de Cobertura         *
      * Retornar para la cobertura, todos los descuentos de cada     *
      * nivel segun las caracteristicas que fueron grabadas en la    *
      * emision de la superpoliza                                    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peXcob   (input)   Cobertura                             *
      *     peLdes   (output)  Lista de Descuentos                   *
      *     peLdesC  (output)  Cantidad en la Lista                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_getDescCob...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peXcob                       3  0 const
     D   peLdes                            likeds(cobCa_t) dim(99)
     D   peLdesC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDRS_setDesc(): Graba Descuentos. Segun caracteristicas del*
      *                   bien asegurado.                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_setDesc...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_dltDesc(): Elimina Descuentos                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_dltDesc...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_getFec(): Retorna Fecha de Inicio de emision para     *
      *                  suspendidas o fecha del dia para nuevas     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: Fecha                                               *
      * ------------------------------------------------------------ *
     D SVPDRS_getFec...
     D                 pr             8  0
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_updDesc(): Actualiza Tasa y Prima                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_updDesc...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_updNoDesc(): Actualiza Tasa y Prima cuando no hay     *
      *                     descuentos                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_updNoDesc...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_getLcob(): Retorna lista de Coberturas                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peLcob   (output)  Lista de Coberturas                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_getLcob...
     D                 pr            10i 0
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peLcob                            likeds(descCO_t) dim(20)

      * ------------------------------------------------------------ *
      * SVPDRS_chkCob(): Existe cobertrua en Er2                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peXcob   (input)   Cobertura                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_chkCob...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peXcob                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_updDescAnt(): Vuelve valores anteriores a PAHER2      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_updDescAnt...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_chkDesc(): Cheque si se realizaron Descuentos         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_chkDesc...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_chkImpactoDesc(): Cheque si se impactaron Descuentos  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_chkImpactoDesc...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDRS_inz      pr

      * ------------------------------------------------------------ *
      * SVPDRS_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDRS_end      pr

      * ------------------------------------------------------------ *
      * SVPDRS_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPDRS_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPDRS_getDescCobDiferencia():                               *
      * Retornar para la cobertura, todos los descuentos de cada     *
      * nivel segun las caracteristicas que fueron grabadas en la    *
      * emision de la superpoliza, compara con el suplemento anterior*
      * y solo trae los que fueron modificados                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peXcob   (input)   Cobertura                             *
      *     peLdes   (output)  Lista de Descuentos                   *
      *     peLdesC  (output)  Cantidad en la Lista                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_getDescCobDiferencia...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peXcob                       3  0 const
     D   peLdes                            likeds(cobCa_t) dim(99)
     D   peLdesC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDRS_getSumaAsegurada(): Retorna Suma Asegurada            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peXcob   (input)   Cobertura                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_getSumaAsegurada...
     D                 pr            15  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_getTasa(): Retorna Tasa                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *                                                              *
      * Retorna: Tasa                                                *
      * ------------------------------------------------------------ *
     D SVPDRS_getTasa...
     D                 pr             9  6
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_getCaract(): Retorna Lista de Caracteristicas de una  *
      *                     Poliza                                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peLcar   (input)   Lista de Carcteristicas               *
      *     peLcarC  (input)   Cantidad de Caracteristicas           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_getCaract...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peLcar                            likeds(Caract_t) dim(99)
     D   peLcarC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDRS_getPrima(): Retorna Prima                             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *     pePrim   (input)   Prima                                 *
      *                                                              *
      * Retorna: Prima                                               *
      * ------------------------------------------------------------ *
     D SVPDRS_getPrima...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   pePrim                      15  2

      * ------------------------------------------------------------ *
      * SVPDRS_chkCambioCaract(): Valida Cambio de Caracteristicas de*
      *                          de una Poliza                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_chkCambioCaract...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_chkCaract(): Valida si superpoliza contiene           *
      *                     Caracteristicas                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDRS_chkCaract...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDRS_getPrimaAnterior(): Retorna Prima Anterior            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     peOper   (input)   Operacion                             *
      *     pePoco   (input)   Componente                            *
      *     peSuop   (input)   Suplemento Operacion                  *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *     pePrim   (input)   Prima                                 *
      *                                                              *
      * Retorna: Prima                                               *
      * ------------------------------------------------------------ *
     D SVPDRS_getPrimaAnterior...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   pePrim                      15  2
