      /if defined(CZWUTL_H)
      /eof
      /endif
      /define CZWUTL_H

      * ------------------------------------------------------------ *
      * Constantes de Error
      * ------------------------------------------------------------ *

      * Código Postal Argentino erróneo......
     D CZWUTL_ERROR_CPA...
     D                 c                   50000
      * Código Postal GAUS inexistente.....
     D CZWUTL_ERROR_NOCP...
     D                 c                   50001
      * No puede determinarse duración del período....
     D CZWUTL_ERROR_DUPE...
     D                 c                   50003
      * No se ha encontrado tarifa....
     D CZWUTL_ERROR_TARIFA...
     D                 c                   50004
      * Tarifa D equivalente no establecida.....
     D CZWUTL_ERROR_COBERTD...
     D                 c                   50005
      * Vehiculo INFOAUTO inexistente....
     D CZWUTL_ERROR_VHINFOAUTO...
     D                 c                   50006
      * Vehiculo GAUS inexistente....
     D CZWUTL_ERROR_VHGAUS...
     D                 c                   50007
      * Suma Asegurada supera maximo...
     D CZWUTL_ERROR_SUMMAX...
     D                 c                   50008
      * No existe provincia.....
     D CZWUTL_ERROR_PROVINCIA...
     D                 c                   50009
      * No existe código de Iva...
     D CZWUTL_ERROR_CODIVA...
     D                 c                   50010
      * No existe forma de pago...
     D CZWUTL_ERROR_FORPAG...
     D                 c                   50011
      * Tipo de persona...
     D CZWUTL_ERROR_TIPPER...
     D                 c                   50012
      * Suma Asegurada cero/negativa...
     D CZWUTL_ERROR_SUMACERO...
     D                 c                   50013
      * Intermediario inválido...
     D CZWUTL_ERROR_INTERM...
     D                 c                   50014
      * Año menor al mínimo permitido...
     D CZWUTL_ERROR_ANOMINIMO...
     D                 c                   50015

      * ------------------------------------------------------------ *
      * INZ():       Incializar Módulo                               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D CZWUTL_Inz      pr

      * ------------------------------------------------------------ *
      * End():       Finalizar Módulo                                *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D CZWUTL_End      pr

      * ------------------------------------------------------------ *
      * Error():     Retorna último error                            *
      *                                                              *
      *       peErrn    (input)   Número del error                   *
      *                                                              *
      * retorna: Mensaje del último error                            *
      * ------------------------------------------------------------ *
     D CZWUTL_Error    pr            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * getArticulo(): Obtiene Artículo usado para emitir            *
      *                                                              *
      *     peArcd    (output)   Artículo                            *
      *     peRama    (output)   Rama                                *
      *     peArse    (output)   Pólizas por Artículo/Rama           *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Artículo o -1 si error                              *
      * ------------------------------------------------------------ *
     D CZWUTL_getArticulo...
     D                 pr            10i 0
     D   peArcd                       6  0
     D   peRama                       2  0
     D   peArse                       2  0
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * getOldCp():   Extraer Código Postal viejo desde el CPA       *
      *                                                              *
      *     peCpar    (input)    Código Postal Argentino (A9999AAA)  *
      *                                                              *
      * retorna: CP viejo, -1 si error o -2 si inexistente           *
      *                                                              *
      * Errores: CZWUTL_ERROR_CPA                                    *
      *          CZWUTL_ERROR_NOCP                                   *
      * ------------------------------------------------------------ *
     D CZWUTL_getOldCp...
     D                 pr            10i 0
     D  peCpar                        8a   const
     D  peCopo                        5  0

      * ------------------------------------------------------------ *
      * getZona():    Obtiene Zona de Riesgo                         *
      *                                                              *
      *     peCopo    (input)    Código Postal (viejo)               *
      *     peTipo    (input)    AUT = Autos                         *
      *                          RSV = Riesgos Varios                *
      *                                                              *
      * retorna: Zona,  -1 si error                                  *
      * ------------------------------------------------------------ *
     D CZWUTL_getZona  pr            10i 0
     D  peCopo                        5  0 const
     D  peTipo                        3a   const
     D  peScta                        1  0

      * ------------------------------------------------------------ *
      * getFemi():    Obtiene Fecha de Emisión                       *
      *                                                              *
      *                                                              *
      * retorna: Fecha de Emisión                                    *
      * ------------------------------------------------------------ *
     D CZWUTL_getFemi  pr             8  0

      * ------------------------------------------------------------ *
      * getDupe():   Obtiene duración del período                    *
      *                                                              *
      *     peArcd    (input)    Artículo                            *
      *     peRama    (input)    Rama                                *
      *     peArse    (input)    Pólizas por Artículo/Rama           *
      *                                                              *
      * retorna: Duración del período, o -1 si error                 *
      *                                                              *
      * Errores: CZWUTL_ERROR_DUPE                                   *
      * ------------------------------------------------------------ *
     D CZWUTL_getDupe  pr            10i 0
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peDupe                        2  0

      * ------------------------------------------------------------ *
      * getTarifa(): Obtiene tarifa vigente a una fecha              *
      *                                                              *
      *     peFemi    (input)    Fecha a la cual obtener tarifa.     *
      *                          Si no se envía, toma hoy            *
      *                                                              *
      * retorna: Código de tarifa o -1 si error                      *
      *                                                              *
      * Errores: CZWUTL_ERROR_TARIFA                                 *
      * ------------------------------------------------------------ *
     D CZWUTL_getTarifa...
     D                 pr            10i 0
     D  peCtre                        5  0
     D  peFemi                        8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * esAltaGama():   Determina si un vehículo es Alta Gama        *
      *                                                              *
      *     ATENCION: No se determina aquí si hay o no que aplicar   *
      *               descuento (ver getDescAltaGama() ).            *
      *                                                              *
      *     peVhvu    (input)    Suma Asegurada                      *
      *     peFech    (input)    Fecha a la cual verificar           *
      *                                                              *
      * retorna: *ON si es alta gama, *off si no.                    *
      * ------------------------------------------------------------ *
     D CZWUTL_esAltaGama...
     D                 pr             1N
     D  peVhvu                       15  2 const
     D  peFech                        8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * getPorcAltaGama(): Retorna porcentaje de Alta Gama           *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peArcd    (input)    Artículo                            *
      *     peRama    (input)    Rama                                *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Porcentaje de Alta Gama                             *
      * ------------------------------------------------------------ *
     D CZWUTL_getPorcAltaGama...
     D                 pr             5  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peFech                        8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * getPorcPromo0Km(): Retorna porcentaje de Promo 0 KM          *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peArcd    (input)    Artículo                            *
      *     peRama    (input)    Rama                                *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Porcentaje de Promo 0 Km                            *
      * ------------------------------------------------------------ *
     D CZWUTL_getPorcPromo0Km...
     D                 pr             5  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peFech                        8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * getSumaMaxima():  Obtiene Suma Asegurada Máxima              *
      *                                                              *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Suma Asegurada Máxima                               *
      * ------------------------------------------------------------ *
     D CZWUTL_getSumaMaxima...
     D                 pr            15  2
     D  peFech                        8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * getSumaMinima():  Obtiene Suma Asegurada Mínima              *
      *                                                              *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Suma Asegurada Mínima                               *
      * ------------------------------------------------------------ *
     D CZWUTL_getSumaMinima...
     D                 pr            15  2
     D  peFech                        8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * getCobertD():  Obtiene Cobertura D a utilizar                *
      *                                                              *
      *     peVhca    (input)    Capítulo                            *
      *     peVhv1    (input)    Variante 1                          *
      *     peVhv2    (input)    Variante 2                          *
      *     peMtdf    (input)    Marca de Tarifa Diferencial         *
      *     peScta    (input)    Zona                                *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_COBERTD                                *
      * ------------------------------------------------------------ *
     D CZWUTL_getCobertD...
     D                 pr            10i 0
     D  peVhca                        2  0 const
     D  peVhv1                        1  0 const
     D  peVhv2                        1  0 const
     D  peMtdf                        1a   const
     D  peScta                        1  0 const
     D  peCobd                        2a
     D  peFech                        8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * getDescMarcaModelo():  Obtiene Desc/Recargo Marca/Modelo     *
      *                                                              *
      *     peVhmc    (input)    Marca                               *
      *     peVhmo    (input)    Modelo                              *
      *     peVhcs    (input)    SubModelo                           *
      *     peCcbp    (output)   Codigo de Descuento                 *
      *                                                              *
      * retorna: porcentaje a aplicar.                               *
      * ------------------------------------------------------------ *
     D CZWUTL_getDescMarcaModelo...
     D                 pr             5  2
     D  peVhmc                        3a
     D  peVhmo                        3a
     D  peVhcs                        3a
     D  peCcbp                        3  0 options (*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * getVehiculoGAUS():  Obtener vehículo GAUS con INFOAUTO       *
      * "DEPRECATED" se debe utilizar getVehiculoGAU1                *
      *     ATENCION: Es posible que exista más de un Vehículo       *
      *               GAUS para uno INFOAUTO.                        *
      *               Se retorna el primero.                         *
      *                                                              *
      *     peCmar    (input)    Código marca INFOAUTO               *
      *     peCmod    (input)    Código Modelo INFOAUTO              *
      *     peVhmc    (output)   Código Marca GAUS                   *
      *     peVhmo    (output)   Código Modelo GAUS                  *
      *     peVhcs    (output)   Código SubModelo GAUS               *
      *                                                              *
      * retorna: 0 si OK, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_VHINFOAUTO                             *
      * ------------------------------------------------------------ *
     D CZWUTL_getVehiculoGAUS...
     D                 pr            10i 0
     D  peCmar                        3  0 const
     D  peCmod                        3  0 const
     D  peVhmc                        3a
     D  peVhmo                        3a
     D  peVhcs                        3a

      * ------------------------------------------------------------ *
      * getVehiculoGAU1():  Obtener vehículo GAUS con INFOAUTO       *
      *                                                              *
      *     ATENCION: Es posible que exista más de un Vehículo       *
      *               GAUS para uno INFOAUTO.                        *
      *               Se retorna el primero.                         *
      *                                                              *
      *     peCmar    (input)    Código marca INFOAUTO               *
      *     peCmod    (input)    Código Modelo INFOAUTO              *
      *     peVhmc    (output)   Código Marca GAUS                   *
      *     peVhmo    (output)   Código Modelo GAUS                  *
      *     peVhcs    (output)   Código SubModelo GAUS               *
      *                                                              *
      * retorna: 0 si OK, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_VHINFOAUTO                             *
      * ------------------------------------------------------------ *
     D CZWUTL_getVehiculoGAU1...
     D                 pr            10i 0
     D  peCmar                        9  0 const
     D  peCmod                        9  0 const
     D  peVhmc                        3a
     D  peVhmo                        3a
     D  peVhcs                        3a

      * ------------------------------------------------------------ *
      * getVehiculoINFO():  Obtener vehículo INFOAUTO con GAUS       *
      * "DEPRECATED" se debe utilizar getVehiculoINF1                *
      *     peVhmc    (input)    Código Marca GAUS                   *
      *     peVhmo    (input)    Código Modelo GAUS                  *
      *     peVhcs    (input)    Código SubModelo GAUS               *
      *     peCmar    (output)   Código marca INFOAUTO               *
      *     peCmod    (output)   Código Modelo INFOAUTO              *
      *                                                              *
      * retorna: 0 si OK, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_VHGAUS                                 *
      * ------------------------------------------------------------ *
     D CZWUTL_getVehiculoINFO...
     D                 pr            10i 0
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  peCmar                        3  0
     D  peCmod                        3  0

      * ------------------------------------------------------------ *
      * getVehiculoINF1():  Obtener vehículo INFOAUTO con GAUS       *
      *                                                              *
      *     peVhmc    (input)    Código Marca GAUS                   *
      *     peVhmo    (input)    Código Modelo GAUS                  *
      *     peVhcs    (input)    Código SubModelo GAUS               *
      *     peCmar    (output)   Código marca INFOAUTO               *
      *     peCmod    (output)   Código Modelo INFOAUTO              *
      *                                                              *
      * retorna: 0 si OK, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_VHGAUS                                 *
      * ------------------------------------------------------------ *
     D CZWUTL_getVehiculoINF1...
     D                 pr            10i 0
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  peCmar                        9  0
     D  peCmod                        9  0

      * ------------------------------------------------------------ *
      * sumaAsegMayor():   Valida que la suma asegurada sea valida   *
      *                                                              *
      *     peVhvu    (input)    Valor a asegurar                    *
      *     peFech    (input)    Fecha para controlar                *
      *                                                              *
      * retorna: *on si ok, *OFF si no.                              *
      *                                                              *
      * Errores: CZWUTL_ERROR_SUMMAX                                 *
      * ------------------------------------------------------------ *
     D CZWUTL_sumaAsegMayor...
     D                 pr             1N
     D  peVhvu                       15  2 const
     D  peFech                        8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * getProvincia():  Obtener la provincia                        *
      *                                                              *
      *     peCopo    (input)    Código Postal                       *
      *     peCops    (input)    Sufijo Código Postal                *
      *     peProc    (output)   Código de Provincia GAUS            *
      *     peRpro    (output)   Código de Provincia INDER           *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_NOCP                                   *
      *          CZWUTL_ERROR_PROVINCIA                              *
      * ------------------------------------------------------------ *
     D CZWUTL_getProvincia...
     D                 pr            10i 0
     D  peCopo                        5  0 const
     D  peCops                        1  0 const
     D  peProc                        3a
     D  peRpro                        2  0

      * ------------------------------------------------------------ *
      * getDatosCotizVeh():  Obtiene datos necesarios para cotizar   *
      *                                                              *
      *     peVhmc    (input)    Código de Marca del Vehículo        *
      *     peVhmo    (input)    Código de Modelo del Vehículo       *
      *     peVhcs    (input)    Código de SubModelo del Vehículo    *
      *     peVhca    (output)   Capítulo                            *
      *     peVhv1    (output)   Variante 1                          *
      *     peVhv2    (output)   Variante 2                          *
      *     peMtdf    (output)   Marca de Tarifa Diferencial         *
      *     peVhni    (output)   Origen                              *
      *     peVhct    (output)   Tipo                                *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_VHGAUS                                 *
      * ------------------------------------------------------------ *
     D CZWUTL_getDatosCotizVeh...
     D                 pr            10i 0
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  peVhca                        2  0
     D  peVhv1                        1  0
     D  peVhv2                        1  0
     D  peMtdf                        1a
     D  peVhni                        1a   options(*nopass:*omit)
     D  peVhct                        2  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * chkCodigoIva():   Valida código de IVA                       *
      *                                                              *
      *     peCiva    (input)    Código de IVA                       *
      *     peDiva    (output)   Descripción                         *
      *     peNcic    (output)   Descripción corta                   *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_CODIVA                                 *
      * ------------------------------------------------------------ *
     D CZWUTL_chkCodigoIva...
     D                 pr            10i 0
     D  peCiva                        2  0 const
     D  peDiva                       30a   options(*nopass:*omit)
     D  peNcic                        3a   options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * chkFormaDePago(): Valida Forma de Pago                       *
      *                                                              *
      *     peCfpg    (input)    Código de Forma de Pago             *
      *     peDfpg    (output)   Descripción                         *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_FORPAG                                 *
      * ------------------------------------------------------------ *
     D CZWUTL_chkFormaDePago...
     D                 pr            10i 0
     D  peCfpg                        1  0 const
     D  peDfpg                       30a   options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * chkTipoPersona(): Valida Tipo de Persona                     *
      *                                                              *
      *     peTipp    (input)    Tipo de Persona                     *
      *     peDipp    (output)   Descripción                         *
      *                                                              *
      * retorna: 0 si ok, -1 si error.                               *
      *                                                              *
      * Errores: CZWUTL_ERROR_TIPPER                                 *
      * ------------------------------------------------------------ *
     D CZWUTL_chkTipoPersona...
     D                 pr            10i 0
     D  peTipp                        1a   const
     D  peDipp                       30a   options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * chkSumaAsegurada(): Valida Suma Asegurada cero/negativa.     *
      *                                                              *
      *     peVhvu    (input)    Suma Asegurada                      *
      *                                                              *
      * retorna: *on si ok, *off si no.                              *
      *                                                              *
      * Errores: CZWUTL_ERROR_SUMACERO                               *
      * ------------------------------------------------------------ *
     D CZWUTL_chkSumaAsegurada...
     D                 pr             1N
     D  peVhvu                       15  2 const

      * ------------------------------------------------------------ *
      * getValorGnc():   Recupera importe de GNC                     *
      *                                                              *
      *     peArcd    (input)    Artículo                            *
      *                                                              *
      * retorna: importe de GNC                                      *
      * ------------------------------------------------------------ *
     D CZWUTL_getValorGnc...
     D                 pr             9  2
     D  peArcd                        6  0 const

      * ------------------------------------------------------------ *
      * chkIntermediario(): Validar Intermediario                    *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peNivt    (input)    Tipo de Intermediario               *
      *     peNivc    (input)    Código de Intermediario             *
      *                                                              *
      * retorna: *on ok, *off no ok                                  *
      * ------------------------------------------------------------ *
     D CZWUTL_chkIntermediario...
     D                 pr             1N
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const

      * ------------------------------------------------------------ *
      * getZonaReal():     Obtiene la Zona de cotizacion.            *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peNivt    (input)    Tipo de Intermediario               *
      *     peNivc    (input)    Código de Intermediario             *
      *     peScta    (input)    Zona                                *
      *                                                              *
      * retorna: Zona para usar, o la misma que peScta               *
      * ------------------------------------------------------------ *
     D CZWUTL_getZonaReal...
     D                 pr             1  0
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peScta                        1  0 const

      * ------------------------------------------------------------ *
      * chkAÑoMinimo():    Valida menor año posible de cotizar.      *
      *                                                              *
      *     peAÑo     (input)    Año del vehículo que se cotiza      *
      *                                                              *
      * retorna: *ON OK, *OFF No OK.                                 *
      * ------------------------------------------------------------ *
     D CZWUTL_chkAÑoMinimo...
     D                 pr             1n
     D  peAÑo                         4  0 const

      * ------------------------------------------------------------ *
      * chkDescAltaGama(): Retorna Descuento de Alta Gama            *
      *                                                              *
      *     DEPRECATED: Usar chkDescAltaGama2()                      *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peCobl    (input)    Cobertura                           *
      *     peVhca    (input)    Capítulo                            *
      *     peVhv1    (input)    Variante 1                          *
      *     peVhv2    (input)    Variante 2                          *
      *     peMtdf    (input)    Marca de Tarifa Diferencial         *
      *     peSuma    (input)    Suma Asegurada                      *
      *     peCcbp    (output)   Codigo de Descuento                 *
      *     pePcbp    (output)   % de Descuento                      *
      *                                                              *
      * retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D CZWUTL_chkDescAltaGama...
     D                 pr              n
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peCobl                        2    const
     D  peVhca                        2  0 const
     D  peVhv1                        1  0 const
     D  peVhv2                        1  0 const
     D  peMtdf                        1    const
     D  peSuma                       15  2 const
     D  peCcbp                        3  0 options (*Omit:*Nopass)
     D  pePcbp                        5  2 options (*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * chkDescAltaGama2(): Retorna Descuento de Alta Gama           *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peCobl    (input)    Cobertura                           *
      *     peVhca    (input)    Capítulo                            *
      *     peVhv1    (input)    Variante 1                          *
      *     peVhv2    (input)    Variante 2                          *
      *     peMtdf    (input)    Marca de Tarifa Diferencial         *
      *     peSuma    (input)    Suma Asegurada                      *
      *     peCond    (input)    Condición del auto                  *
      *                          '1' = 0 KM primer año               *
      *                          '2' = 0 KM segundo año              *
      *                          '0' = No 0 KM                       *
      *     peCcbp    (output)   Codigo de Descuento                 *
      *     pePcbp    (output)   % de Descuento                      *
      *                                                              *
      * retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D CZWUTL_chkDescAltaGama2...
     D                 pr              n
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peCobl                        2    const
     D  peVhca                        2  0 const
     D  peVhv1                        1  0 const
     D  peVhv2                        1  0 const
     D  peMtdf                        1    const
     D  peSuma                       15  2 const
     D  peCond                        1a   const
     D  peCcbp                        3  0 options (*Omit:*Nopass)
     D  pePcbp                        5  2 options (*Omit:*Nopass)

