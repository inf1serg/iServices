      /if defined(SVPDES_H)
      /eof
      /endif
      /define SVPDES_H

      /copy './qcpybooks/svptab_h.rpgle'

      * ------------------------------------------------------------ *
      * SVPDES_articulo():   Retorna descripción del Articulo        *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peArcd  -  Articulo                           *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_articulo...
     D                 pr            30
     D   peArcd                       6  0   const
      * ------------------------------------------------------------ *
      * SVPDES_moneda():   Retorna descripcion de la moneda.         *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peComo  -  Código de Moneda                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_moneda...
     D                 pr            30
     D   peComo                       2      const
      * ------------------------------------------------------------ *
      * SVPDES_tipoDeOperacion(): Retorna la descripción del tipo de *
      *                           operación                          *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peTiou  -  Tipo Operación                     *
      *                peStou  -  SubTipo Operación                  *
      *                peStos  -  Operación Moneda                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_tipoDeOperacion...
     D                 pr            20
     D   peTiou                       1  0   const
     D   peStou                       2  0   const
     D   peStos                       2  0   const
      * ------------------------------------------------------------ *
      * SVPDES_estadoCot():  Retorna la descripcion de estado de     *
      *                      cotización.                             *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCest  -  Codigo de Estado                   *
      *                peCses  -  Codigo de SubEstado                *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_estadoCot...
     D                 pr            20
     D   peCest                       1  0   const
     D   peCses                       2  0   const
      * ------------------------------------------------------------ *
      * SVPDES_codigoIva():  Retorna Nombre Código IVA.              *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCiva  -  Codigo de IVA                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_codigoIva...
     D                 pr            30
     D   peCiva                       1  0   const
      * ------------------------------------------------------------ *
      * SVPDES_localidad():  Retorna Descripción de localidad        *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCopo  -  Código Postal                      *
      *                peCops  -  SubFijo Postal                     *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_localidad...
     D                 pr            25
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
      * ------------------------------------------------------------ *
      * SVPDES_formaPago():  Retorna Descripción de localidad        *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCfpg  -  Código Forma de Pago               *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_formaPago...
     D                 pr            20
     D   peCfpg                       1  0   const
      * ------------------------------------------------------------ *
      * SVPDES_codRiesgo(): Devuelve la descripción del Riesgo       *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peRama - Rama                                  *
      *                peRiec - Código del Riesgo                     *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_codRiesgo...
     D                 pr            25
     D   peRama                       2  0 const
     D   peRiec                       3    const
      * ------------------------------------------------------------ *
      * SVPDES_cobCorto():  Devuelve la descripción de la Cobertura  *
      *                     (descripción corta)                      *
      *        Input :                                               *
      *                                                              *
      *                peRama - Rama                                 *
      *                peCobc - Código de Cobertura                  *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_cobCorto...
     D                 pr            20
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
      * ------------------------------------------------------------ *
      * SVPDES_cobLargo():  Devuelve la descripción de la Cobertura  *
      *                     (descripción larga)                      *
      *        Input :                                               *
      *                                                              *
      *                peRama - Rama                                 *
      *                peCobc - Código de Cobertura                  *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_cobLargo...
     D                 pr            40
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
      * ------------------------------------------------------------ *
      * SVPDES_codCaracteristica(): Descripción de la característica *
      *                             del bien.                        *
      *        Input :                                               *
      *                                                              *
      *                peEmpr - Código de Empresa                    *
      *                peSucu - Código de Sucursal                   *
      *                peRama - Rama                                 *
      *                peCcba - Cod.Caracteristica del Bien          *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_codCaracteristica...
     D                 pr            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peCcba                       3  0 const
      * -------------------------------------------------------------- *
      * SVPDES_codBonificacion():   Descripción de la bonificacion     *
      *                             del vehículo.                      *
      *        Input :                                                 *
      *                                                                *
      *                peEmpr - Código de Empresa                      *
      *                peSucu - Código de Sucursal                     *
      *                peArcd - Código de Articulo                     *
      *                peRama - Rama                                   *
      *                peCcbp - Código de Componente Bonifi            *
      *                                                                *
      * -------------------------------------------------------------- *
     D SVPDES_codBonificacion...
     D                 pr            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
      * -------------------------------------------------------------- *
      * SVPDES_codBonificacionRV():   Descripción de la bonificacion   *
      *                             de vivienda.                       *
      *                                                                *
      *     peEmpr   (input)   Código de Empresa                       *
      *     peSucu   (input)   Código de Sucursal                      *
      *     peCcbp   (input)   Código de Componente Bonifi             *
      *                                                                *
      * -------------------------------------------------------------- *
     D SVPDES_codBonificacionRV...
     D                 pr            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCcbp                       3  0 const
      * ------------------------------------------------------------ *
      * SVPDES_nacionalidad() Retorna nacionalidad                   *
      *                                                              *
      *     peCnac  (input)  - Codigo de Nacionalidad                *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_nacionalidad...
     D                 pr            30
     D   peCnac                       3  0   const
      * ------------------------------------------------------------ *
      * SVPDES_paisDeNac(): Retorna Pais de Naciomiento              *
      *                                                              *
      *     pePain  (input)  - Pais de Nacimiento                    *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_paisDeNac...
     D                 pr            30
     D   pePain                       5  0   const
      * ------------------------------------------------------------ *
      * SVPDES_profesion(): Retorna Profesion                        *
      *                                                              *
      *     peCprf  (input)  - Codigo de Profesion                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_profesion...
     D                 pr            25
     D   peCprf                       3  0   const
      * ------------------------------------------------------------ *
      * SVPDES_tipoDocumento(): Retorna tipo de Documento            *
      *                                                              *
      *     peTido  (input)  - Codigo de Docuemnto                   *
      *     peDatd  (input)  - A Docuento                            *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_tipoDocumento...
     D                 pr            20
     D   peTido                       2  0   const
     D   peDatd                       3      options(*omit:*nopass)
      * ------------------------------------------------------------ *
      * SVPDES_tipoSociedad():  Retorna tipo de Sociedad             *
      *                                                              *
      *     peTiso  (input)  - Codigo de Sociedad                    *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_tipoSociedad...
     D                 pr            25
     D   peTiso                       2  0   const
      * ------------------------------------------------------------ *
      * SVPDES_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDES_inz      pr
      * ------------------------------------------------------------ *
      * SVPDES_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDES_end      pr
      * --------------------------------------------------------------*
      * SVPDES_provinciaInder(): Descripcion                          *
      *                                                               *
      *     peProc   (input)   Provincia                              *
      *                                                               *
      * Retorna: Descripcion                                          *
      * ------------------------------------------------------------- *
     D SVPDES_provinciaInder...
     D                 pr            20
     D   peProc                       2  0 const
      * --------------------------------------------------------------*
      * SVPDES_producto(): Descripcion de Producto                    *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peXpro   (input)   Producto                               *
      *                                                               *
      * Retorna: Descripcion de Producto                              *
      * ------------------------------------------------------------- *
     D SVPDES_producto...
     D                 pr            20
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
      * --------------------------------------------------------------*
      * SVPDES_clasificacionRiesgo(): Clasificacion de Riesgo         *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peClfr   (input)   Clacificacion                          *
      *                                                               *
      * Retorna: Descripcion de Clasificacion de Riesgo               *
      * ------------------------------------------------------------- *
     D SVPDES_clasificacionRiesgo...
     D                 pr            30
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peClfr                       4    const
      * --------------------------------------------------------------*
      * SVPDES_agravioRiesgo(): Agravio de Riesgo                     *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peCagr   (input)   Agravio                                *
      *                                                               *
      * Retorna: Agravio de Riesgo                                    *
      * ------------------------------------------------------------- *
     D SVPDES_agravioRiesgo...
     D                 pr            30
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCagr                       2  0 const
      * --------------------------------------------------------------*
      * SVPDES_tarifaRv() Tarifa RV                                   *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peCtar   (input)   Cap Tarifa                             *
      *     peCta1   (input)   Cap Tarifa 1                           *
      *     peCta2   (input)   Cap Tarifa 2                           *
      *                                                               *
      * Retorna: Tarifa RV                                            *
      * ------------------------------------------------------------- *
     D SVPDES_tarifaRv...
     D                 pr            20
     D   peRama                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2    const
     D   peCta2                       2    const
      * --------------------------------------------------------------*
      * SVPDES_actividad(): Actividad                                 *
      *                                                               *
      *     peActi   (input)   Actividad                              *
      *                                                               *
      * Retorna: Avtividad                                            *
      * ------------------------------------------------------------- *
     D SVPDES_actividad...
     D                 pr            50
     D   peActi                       5  0 const
      * --------------------------------------------------------------*
      * SVPDES_estadoCivil (): Descripcion Estado Civil               *
      *                                                               *
      *     peEsci   (input)   Código de estado Civil                 *
      *                                                               *
      * Retorna: Descripcion                                          *
      * ------------------------------------------------------------- *
     D SVPDES_estadoCivil...
     D                 pr            20
     D   peEsci                       1  0 const
      * --------------------------------------------------------------*
      * SVPDES_sexo() Descripcion                                     *
      *                                                               *
      *     peSexo   (input)   Código de Sexo                         *
      *                                                               *
      * Retorna: Descripcion                                          *
      * ------------------------------------------------------------- *
     D SVPDES_sexo...
     D                 pr            20
     D   peSexo                       1  0 const

      * --------------------------------------------------------------*
      * SVPDES_getTipoDeVehiculo(): Retorna Descripcion de Tipo de    *
      *                             Vehiculo                          *
      *                                                               *
      *     peTipo   (input)   Código de tipo de Vehiculo             *
      *                                                               *
      * Retorna: Descripcion / Blancos                                *
      * ------------------------------------------------------------- *
     D SVPDES_getTipoDeVehiculo...
     D                 pr            15
     D   peTipo                       2  0 const

      * ------------------------------------------------------------ *
      * SVPDES_coberturaVehiculo() Descripción de Cobertura de       *
      *                            Vehiculo.                         *
      *                                                              *
      *     peCobl   (input)   Código de Cobertura                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_coberturaVehiculo...
     D                 pr            20
     D   peCobl                       2    const

      * ------------------------------------------------------------ *
      * SVPDES_TipoDeTelefono() Descripción de Tipo de Telefono      *
      *                                                              *
      *     peCobl   (input)   Código de Cobertura                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_TipoDeTelefono...
     D                 pr            20
     D   peTipt                       2    const

      * --------------------------------------------------------------*
      * SVPDES_getMail():Retorna Descripcion de Correo Electronico    *
      *                                                               *
      *     peTipt   (input)   Código de tipo de Correo               *
      *                                                               *
      * Retorna: Descripcion si existe                                *
      *          Blancos No existe                                    *
      * ------------------------------------------------------------- *
     D SVPDES_getMail...
     D                 pr            40
     D   peTipt                       2  0 const

      * ------------------------------------------------------------ *
      * SVPDES_monedaAbreviada: Retorna Abreviatura de moneda.       *
      *                                                              *
      *     peComo   (input)   Moneda                                *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_monedaAbreviada...
     D                 pr             5
     D   peComo                       2      const

      * ------------------------------------------------------------ *
      * SVPDES_banco: Retorna Banco                                  *
      *                                                              *
      *     peIvbc   (input)   Codigo de Banco                       *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_banco...
     D                 pr            40
     D   peIvbc                       3  0   const

      * ------------------------------------------------------------ *
      * SVPDES_sucursalBanco: Retorna sucursal de Banco              *
      *                                                              *
      *     peIvbc   (input)   Codigo de Banco                       *
      *     peIvsu   (input)   Codigo de Sucursal                    *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_sucursalBanco...
     D                 pr            40
     D   peIvbc                       3  0   const
     D   peIvsu                       3  0   const

      * ------------------------------------------------------------ *
      * SVPDES_planDePago(): Retorna la descripción de plan de Pago. *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peNrpp  -  Código Plan de Pago                *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPDES_planDePago...
     D                 pr            30
     D   peNrpp                       3  0   const

      * ------------------------------------------------------------ *
      * SVPDES_cuestionario() : Retorna descripción de cuestiondio.  *
      *                                                              *
      *  peTaaj ( input ) Código de cuestionario                     *
      *                                                              *
      * Retorna : Descripcion de un cuestionario                     *
      * ------------------------------------------------------------ *
     D SVPDES_cuestionario...
     D                 pr            30
     D   peTaaj                       2  0   const

      * ------------------------------------------------------------ *
      * SVPDES_pregunta(): Retorna descripción de una pregunta       *
      *                                                              *
      *  peTaaj ( input ) Código de cuestionario                     *
      *  pecosg ( input ) Código de pregunta                         *
      *                                                              *
      * Retorna : Descripcion de un cuestionario                     *
      * ------------------------------------------------------------ *
     D SVPDES_pregunta...
     D                 pr            79
     D   peTaaj                       2  0   const
     D   peCosg                       4      const

      * --------------------------------------------------------------*
      * SVPDES_rama(): Retorna nombre de Rama                         *
      *                                                               *
      *     peRama   (input)   Código de Rama                         *
      *                                                               *
      * Retorna: Descripcion de la Rama si encuentra                  *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_rama...
     D                 pr            20
     D   peRama                       2  0 const

      * --------------------------------------------------------------*
      * SVPDES_marca: Retorna Descripción de Marca de Vehículo.       *
      *                                                               *
      *     peVhmc   (input)   Código de Marca                        *
      *                                                               *
      * Retorna: Descripción de la Marca si encuentra                 *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_marca...
     D                 pr            15
     D   peVhmc                       3    const

      * --------------------------------------------------------------*
      * SVPDES_modelo: Retorna Descripción de Modelo de Vehículo.     *
      *                                                               *
      *     peVhmo   (input)   Código de Modelo                       *
      *                                                               *
      * Retorna: Descripción del Modelo si encuentra                 *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_modelo...
     D                 pr            15
     D   peVhmo                       3    const

      * --------------------------------------------------------------*
      * SVPDES_tipoDeMascota: Descripcion del tipo de mascota.        *
      *                                                               *
      *     peCtma   (input)   Código de Tipo de Mascota              *
      *                                                               *
      * Retorna: Descripción del tipo de mascota si encuentra         *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_tipoDeMascota...
     D                 pr            40
     D   peCtma                       2  0 const

      * --------------------------------------------------------------*
      * SVPDES_razaDeMascota: Descripcion de la raza de mascota.      *
      *                                                               *
      *     peCraz   (input)   Código de raza de mascota              *
      *                                                               *
      * Retorna: Descripción de la raza de la mascota si encuentra    *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_razaDeMascota...
     D                 pr            40
     D   peCraz                       4  0 const

      * --------------------------------------------------------------*
      * SVPDES_estadoDeFactura: Descripcion de estado de factura Web  *
      *                                                               *
      *     peEsta   (input)   Código de Estado de Factura            *
      *                                                               *
      * Retorna: Descripción de Estado de la Factura Web /            *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_estadoDeFactura...
     D                 pr            40
     D   peEsta                       1    const

      * --------------------------------------------------------------*
      * SVPDES_estadoOrdenDePago : Descripción de estado de orden de  *
      *                            pago                               *
      *                                                               *
      *     peEsta   (input)   Código de Estado                       *
      *                                                               *
      * Retorna: Descripción de Estado de Orden de Pago /             *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_estadoOrdenDePago...
     D                 pr            40
     D   peEsta                       1    const

      * --------------------------------------------------------------*
      * SVPDES_tipoDePersona: Descripcion del tipo de persona.        *
      *                                                               *
      *     petipe   (input)   Código de Tipo de Persona              *
      *                                                               *
      * Retorna: Descripción del tipo de persona si encuentra         *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_tipoDePersona...
     D                 pr            15
     D   peTipe                       1    const

      * --------------------------------------------------------------*
      * SVPDES_estadoDelTiempo: Descripcion de estado del Tiempo      *
      *                                                               *
      *     peEmpr   (input)   Código de Empresa                       *
      *     peSucu   (input)   Código de Sucursal                      *
      *     peCdes   (input)   Código de Estado del Tiempo            *
      *                                                               *
      * Retorna: Descripción de Estado del Tiempo  /                  *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_estadoDelTiempo...
     D                 pr            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCdes                       2  0 const

      * --------------------------------------------------------------*
      * SVPDES_getProvinciaPorLocalidad() Devuelve el codigo de       *
      *                                   Provincia.                  *
      *     peCopo   (input)   Código Postal                          *
      *     peCops   (input)   Sufijo Codigo Postal                   *
      *                                                               *
      * Retorna: Codigo de Provincia /                                *
      *          Zeros No Encuentra                                   *
      * ------------------------------------------------------------- *
     D SVPDES_getProvinciaPorLocalidad...
     D                 pr             2  0
     D   peCopo                       5  0 const
     D   peCops                       1  0 const

      * --------------------------------------------------------------*
      * SVPDES_relacionConAsegurado: Descripción de Relación con      *
      *                              el Asegurado                     *
      *     peEmpr   (input)   Código de Empresa                      *
      *     peSucu   (input)   Código de Sucursal                     *
      *     peRela   (input)   Código de Relación                     *
      *                                                               *
      * Retorna: Descripción de Relacion con Asegurado /              *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_relacionConAsegurado...
     D                 pr            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRela                       2  0 const

      * --------------------------------------------------------------*
      * SVPDES_usoDelVehiculo: Descripcion Uso del Vehiculo           *
      *                                                               *
      *     peVhuv   (input)   Código de Uso del Vehículo             *
      *                                                               *
      * Retorna: Descripción de Uso del Vehículo /                    *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_usoDelVehiculo...
     D                 pr            25
     D   peVhuv                       2  0 const

      * --------------------------------------------------------------*
      * SVPDES_nombCortoEmpTdc(): Nombre Corto de la Empresa Tarjeta  *
      *                           de Credito.                         *
      *                                                               *
      *     peCtcu   (input)   Código de Empresa TDC                  *
      *                                                               *
      * Retorna: Nombre de Empresa /                                  *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     D SVPDES_nombCortoEmpTdc...
     D                 pr            10
     D   peCtcu                       3  0 const

      * --------------------------------------------------------------*
      * SVPDES_capituloVariante(): Descripcion de capitulo/variantes  *
      *                                                               *
      *     peVhca   (input)   Capitulo                               *
      *     peVhv1   (input)   Variante RC                            *
      *     peVhv2   (input)   Variante AIR                           *
      *                                                               *
      * Retorna: Descripcion o *blanks                                *
      * ------------------------------------------------------------- *
     D SVPDES_capituloVariante...
     D                 pr            20a
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const

      * --------------------------------------------------------------*
      * SVPDES_tarifaDiferencial(): Descripcion de marca de tarifa dif*
      *                                                               *
      *     peMtdf   (input)   Marca de Tarifa Diferencial            *
      *                                                               *
      * Retorna: Descripcion o *blanks                                *
      * ------------------------------------------------------------- *
     D SVPDES_tarifaDiferencial...
     D                 pr            20a
     D   peMtdf                       1a   const

