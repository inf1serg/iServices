      /if defined(SVPVAL_H)
      /eof
      /endif
      /define SVPVAL_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/regex_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/svpbue_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svpvid_h.rpgle'
      * Se agrega svpriv, para obtener info de paher0 y 9
      /copy './qcpybooks/svpriv_h.rpgle'

      * Articulo Inexistente...
     D SVPVAL_ARTNE    c                   const(0001)
      * Articulo Bloqueado...
     D SVPVAL_ARTBL    c                   const(0002)
      * Articulo Valido para Web...
     D SVPVAL_ARTNW    c                   const(0003)
      * Moneda Inexistente...
     D SVPVAL_MONNE    c                   const(0004)
      * Moneda Bloqueada...
     D SVPVAL_MONBL    c                   const(0005)
      * Moneda No Valida para Web...
     D SVPVAL_MONNW    c                   const(0006)
      * Tipo de Operación Inexistente...
     D SVPVAL_TOPNE    c                   const(0007)
      * Tipo de Operación Web Inexistente...
     D SVPVAL_TOPNW    c                   const(0008)
      * Codigo de Iva Inexistente...
     D SVPVAL_IVANE    c                   const(0009)
      * Codigo de Iva Bloqueado...
     D SVPVAL_IVABL    c                   const(0010)
      * IVA no valido para la Web...
     D SVPVAL_IVANW    c                   const(0011)
      * Nombre en blanco...
     D SVPVAL_NOMBL    c                   const(0012)
      * Código Postal Inexistente...
     D SVPVAL_COPNE    c                   const(0013)
      * Código Postal No Valido para la Web...
     D SVPVAL_COPNW    c                   const(0014)
      * Tipo de Persona debe ser F/J...
     D SVPVAL_TPENV    c                   const(0015)
      * Super poliza en Cero...
     D SVPVAL_SPOCE    c                   const(0016)
      * Super poliza Inexistente...
     D SVPVAL_SPONE    c                   const(0017)
      * No se puede Eliminar Bien Asegurado de Cotización...
     D SVPVAL_CTWNT    c                   const(0018)
      * Rama no existe...
     D SVPVAL_RAMNE    c                   const(0019)
      * Rama No Para Web...
     D SVPVAL_RAMNW    c                   const(0020)
      * Suma Asegurada Fuera de Valor...
     D SVPVAL_SUMFV    c                   const(0021)
      * Suma GNC Fuera de Valor...
     D SVPVAL_GNCFV    c                   const(0022)
      * Zona de Riesgo Fuera de Valor...
     D SVPVAL_ZONFV    c                   const(0023)
      * Cliente Fuera de Valor...
     D SVPVAL_CLIFV    c                   const(0024)
      * Forma de Pago no Existe...
     D SVPVAL_FDPNE    c                   const(0025)
      * Forma de Pago no Valida Para Web...
     D SVPVAL_FDPNW    c                   const(0026)
      * Tarifa no Valida...
     D SVPVAL_TARIV    c                   const(0027)
      * Estado de Cotización No Valido...
     D SVPVAL_CTWNC    c                   const(0028)
      * Cobertura no Valido Para Web...
     D SVPVAL_COBNW    c                   const(0029)
      * Detalle de prima no generado...
     D SVPVAL_CTWNR    c                   const(0030)
      * Tipo de Documento no Existe...
     D SVPVAL_TDONE    c                   const(0031)
      * Número de Asegurado Bloqueado...
     D SVPVAL_ASBLK    c                   const(0031)
      * Código de Riesgo No Valido Para Rama...
     D SVPVAL_RIENV    c                   const(0032)
      * Cobertura no Valida para Para Rama...
     D SVPVAL_COBNV    c                   const(0032)
      * Riesgo y Cobertura No Validos Para Rama...
     D SVPVAL_RCRNV    c                   const(0033)
      * Marca de GNC No Válida...
     D SVPVAL_GNCNV    c                   const(0034)
      * Estado Civil no Valido...
     D SVPVAL_ESCNV    c                   const(0035)
      * Estado Civil no Valido para Web...
     D SVPVAL_ESCNW    c                   const(0036)
      * Código de País no Válido...
     D SVPVAL_PAINV    c                   const(0037)
      * Profesión no Valida...
     D SVPVAL_PRFNV    c                   const(0090)
      * Profesión no Valida para Web...
     D SVPVAL_PRFNW    c                   const(0038)
      * Cod.Rama Actividad Económica No Válida...
     D SVPVAL_RAENV    c                   const(0039)
      * Cod.Rama Actividad Económica No Válida para Web...
     D SVPVAL_RAENW    c                   const(0040)
      * Sexo No Valido...
     D SVPVAL_SEXNV    c                   const(0041)
      * Sexo No Valido para Web...
     D SVPVAL_SEXNW    c                   const(0042)
      * Número de Asegurado Ya Existe...
     D SVPVAL_ASENV    c                   const(0043)
      * Tipo de Persona no Válido...
     D SVPVAL_TIPNV    c                   const(0044)
      * Tiene Bajo Riesgo debe ser "S"
     D SVPVAL_BRIES    c                   const(0045)
      * Tiene Bajo Riesgo debe ser "N"
     D SVPVAL_BRIEN    c                   const(0046)
      * Aplica 996 Bajo Riesgo debe ser "N"
     D SVPVAL_RIEBN    c                   const(0047)
      * Tiene Buen Res.debe ser "S"
     D SVPVAL_BRESS    c                   const(0048)
      * Tiene Buen Res.debe ser "N"
     D SVPVAL_BRESN    c                   const(0049)
      * Aplica Buen Res. debe ser "N"
     D SVPVAL_ABRES    c                   const(0050)
      * No tiene mínimo de Coberturas
     D SVPVAL_MICOB    c                   const(0051)
      * No tiene Cobertura de Incendio
     D SVPVAL_INCOB    c                   const(0052)
      * Faltan Coberturas Adicionales
     D SVPVAL_OTCOB    c                   const(0053)
      * Provincia inexistente
     D SVPVAL_NPROV    c                   const(0054)
      * Domicilio en blanco...
     D SVPVAL_DOMBL    c                   const(0055)
      * Nro Domicilio en cero...
     D SVPVAL_NDOCE    c                   const(0056)
      * Nro Documento en cero...
     D SVPVAL_NROBL    c                   const(0057)
      * Tipo de Mail Inexistente...
     D SVPVAL_TMINE    c                   const(0058)
      * Nacionalidad Inexistente...
     D SVPVAL_NAINE    c                   const(0059)
      * Articulo no Valido Para Renovacion Automatica...
     D SVPVAL_ARNOR    c                   const(0060)
      * Productor no Valido Para Renovacion Automatica...
     D SVPVAL_PRNOR    c                   const(0061)
      * Productor Cba o Mza...
     D SVPVAL_PCBMZ    c                   const(0062)
      * Productor Bloqueado para Operacion
     D SVPVAL_PRBLO    c                   const(0063)
      * Asegurado Cba o Mza...
     D SVPVAL_ACBMZ    c                   const(0064)
      * Codigo InfoAuto no se encuentra asociado a un Vehiculo Gaus...
     D SVPVAL_IANOE    c                   const(0065)
      * Codigo de Infoauto no se encuentra Hailitado para la WEB...
     D SVPVAL_IANWB    c                   const(0066)
      * Infoauto WEB duplicado en Gaus...
     D SVPVAL_IADWB    c                   const(0067)
      * Productor no asociado al asegurado...
     D SVPVAL_PNASA    c                   const(0068)
      * Rango de edad no permitida...
     D SVPVAL_EDNOP    c                   const(0069)
      * Mayor Auxiliar no existe
     D SVPVAL_MAYAX    c                   const(0070)
      * Moneda Local, No Tiene Cotización
     D SVPVAL_MONLC    c                   const(0071)
      * Capitulo de tarifa inexistente
     D SVPVAL_CTANE    c                   const(0072)
      * Capitulo de tarifa no relacionado al articulo
     D SVPVAL_CTAAR    c                   const(0073)
      * Capitulo de tarifa no relacionado al plan/producto
     D SVPVAL_CTAPR    c                   const(0074)
      * Capitulo de tarifa no es web
     D SVPVAL_CTANW    c                   const(0075)
      * Generador no existe
     D SVPVAL_HGNEX    c                   const(0076)
      * Tipo de Lesiones no existe
     D SVPVAL_TLNEX    c                   const(0077)
      * tipo de cambio no existe
     D SVPVAL_TVNEX    c                   const(0078)
      * Siniestro no existe
     D SVPVAL_CSNEX    c                   const(0079)
      * Lugar prisma no existe
     D SVPVAL_LPNEX    c                   const(0080)
      * Estado del tiempo no existe
     D SVPVAL_ETNEX    c                   const(0081)
      * Tipo de accidente no existe
     D SVPVAL_TANEX    c                   const(0082)
      * Tipo de Colision no existe
     D SVPVAL_TCNEX    c                   const(0083)
      * El lugar NO prisma no existe
     D SVPVAL_LSNEX    c                   const(0084)
      * Relación de asegurado no existe
     D SVPVAL_RLNEX    c                   const(0085)
      * Hecho Generador no es valido para la cobertura
     D SVPVAL_HGNCB    c                   const(0086)
      * Codigo de estado no valido o no corresponde informarlo
     D SVPVAL_ESSIN    c                   const(0087)
      * Compania Coasegurado no existe
     D SVPVAL_CCNEX    c                   const(0088)
      * Cobertura Afectada no existe
     D SVPVAL_CANEX    c                   const(0089)
      * Capitulo Variante no existe
     D SVPVAL_CVANE    c                   const(0090)
      * Marca Tarifa diferencial no existe
     D SVPVAL_MTDNE    c                   const(0091)
      * Producto Web Inexistente
     D SVPVAL_PRONW    c                   const(0092)

      * ------------------------------------------------------------ *
      * SVPVAL_articulo():   Validar Articulo.                       *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peArcd  -  Articulo                           *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_articulo...
     D                 pr              n
     D   peArcd                       6  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_articuloWeb():  Validar Articulo.                     *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peArcd  -  Código de Artículo                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_articuloWeb...
     D                 pr              n
     D   peArcd                       6  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_moneda(): Validar Moneda                              *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peComo  -  Código de moneda                   *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_moneda...
     D                 pr              n
     D   peComo                       2    const
      * ------------------------------------------------------------ *
      * SVPVAL_monedaWeb(): Validar Moneda Web.                      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peComo  -  Código de moneda                   *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_monedaWeb...
     D                 pr              n
     D   peComo                       2    const
      * ------------------------------------------------------------ *
      * SVPVAL_tipoDeOperacion(): Valida tipo de operacion.          *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peTiou  -  Tipo de Operación                  *
      *                peStou  -  Subtipo de Operación               *
      *                peStos  -  Subtipo de Sitema                  *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_tipoDeOperacion...
     D                 pr              n
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_tipoDeOperacionWeb()                                  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peTiou  -  Tipo de Operación                  *
      *                peStou  -  Subtipo de Operación               *
      *                peStos  -  Subtipo de Sitema                  *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_tipoDeOperacionWeb...
     D                 pr              n
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_nombreCliente()                                       *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peNomb  -  Nombre de Cliente                  *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_nombreCliente...
     D                 pr              n
     D   peNomb                      40    const
      * ------------------------------------------------------------ *
      * SVPVAL_domiCliente()                                         *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peDomi  -  Domicilio                          *
      *                peNrdm  -  Nro Domicilio                      *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_domiCliente...
     D                 pr              n
     D   peDomi                      35    const
     D   peNrdm                       5  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_iva(): Valida el IVA.                                 *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCiva  -  Código de Iva                      *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_iva...
     D                 pr              n
     D   peCiva                       2  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_ivaWeb(): Valida el IVA para la web.                  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCiva  -  Código de Iva                      *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_ivaWeb...
     D                 pr              n
     D   peCiva                       2  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_codigoPostal(): Valida código postal.                 *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCopo  -  Código postal                      *
      *                peCops  -  Sufijo postal                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_codigoPostal...
     D                 pr              n
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_codigoPostalWeb(): Valida código postal para la web.  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCopo  -  Código postal                      *
      *                peCops  -  Sufijo postal                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_codigoPostalWeb...
     D                 pr              n
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_tipoPersona(): Valida el tipo de persona.             *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peTipe  -  Tipo de Persona                    *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_tipoPersona...
     D                 pr              n
     D   peTipe                       1    const
      * ------------------------------------------------------------- *
      * SVPVAL_chkDeleteBienAsegurado(): Ver si se puede o no eliminar*
      *                                  el bien asegurado            *
      *        Input :                                                *
      *                                                               *
      *                peBase - Parametro Base                        *
      *                peNctw - Número de Cotización                  *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_chkDeleteBienAsegurado...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_spolRenovacion(): Validar Poliza de renvación.         *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peEmpr - Empresa                               *
      *                peSucu - Sucursal                              *
      *                peArcd - Artículo                              *
      *                peSpol - SuperPóliza                           *
      *                peTiou - Tipo Operación                        *
      *                peStou - SubTipo Operación                     *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_spolRenovacion...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       7  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_rama(): Valida el código de la rama.                  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peRama  -  Código de Rama                     *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_rama     pr              n
     D   peRama                       2  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_ramaWeb(): Valida el código de la rama para Web       *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peRama  -  Código de Rama                     *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPVAL_ramaWeb  pr              n
     D   peRama                       2  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_sumaAsegurada(): Validar suma asegurada.               *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peVhmc - Marca                                 *
      *                peVhmo - Modelo                                *
      *                peVhcs - SubModelo                             *
      *                peAnio - Año                                   *
      *                peMone - Moneda                                *
      *                peSuma - Suma Asegurada                        *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_sumaAsegurada...
     D                 pr              n
     D   peVhmc                       3    const
     D   peVhmo                       3    const
     D   peVhcs                       3    const
     D   peAnio                       4  0 const
     D   peMone                       2    const
     D   peSuma                      13  2 const
      * ------------------------------------------------------------- *
      * SVPVAL_marcaGNC():Valida la marca GNC.                        *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peMgnc - Marca de GNC.                         *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_marcaGNC...
     D                 pr              n
     D   peMgnc                       1    const
      * ------------------------------------------------------------- *
      * SVPVAL_sumaGnc(): Validar suma Gas.                           *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peSuma - Suma Asegurada                        *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_sumaGnc...
     D                 pr              n
     D   peSuma                      13  2 const
      * ------------------------------------------------------------- *
      * SVPVAL_sumaGncWeb(): Validar suma Gas en Web.                 *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peSuma - Suma Asegurada                        *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_sumaGncWeb...
     D                 pr              n
     D   peSuma                      13  2 const
      * ------------------------------------------------------------- *
      * SVPVAL_zonaDeRiego(): Validar zona de Riesgo.                 *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peScta - Zona de Riesgo                        *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_zonaDeRiego...
     D                 pr              n
     D   peScta                       1  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_clienteIntegral(): Cliente integral.                   *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peClin - Cliente integral.                     *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_clienteIntegral...
     D                 pr              n
     D   peClin                       1    const
      * ------------------------------------------------------------- *
      * SVPVAL_formaDePago(): Validar forma de pago.                  *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peCfpg - Forma de Pago                         *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_formaDePago...
     D                 pr              n
     D   peCfpg                       1  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_formaDePagoWeb(): Validar forma de pago.               *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peCfpg - Forma de Pago                         *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_formaDePagoWeb...
     D                 pr              n
     D   peCfpg                       1  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_tarifa(): Validar tarifa.        e pago.               *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peFech - Fecha                                 *
      *                peCtre - Código de Tarifa                      *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_tarifa...
     D                 pr              n
     D   peFech                       8  0 const
     D   peCtre                       5  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_coberturaWeb(): Valido cobertura Web.                  *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peCobl - Cobertura                             *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_coberturaWeb...
     D                 pr              n
     D   peCobl                       2    const
      * ------------------------------------------------------------- *
      * SVPVAL_estadoCotizacion(): Valida el estado de la cotización  *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peBase - Parametro Base                        *
      *                peNctw - Número de Cotización                  *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_estadoCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_chkReCotizacion(): Valida el estado de la cotización   *
      *                                                               *
      *        Input :                                                *
      *                                                               *
      *                peBase - Parametro Base                        *
      *                peNctw - Número de Cotización                  *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_chkReCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_tipoDeDocumento():    Valida que sea un tipo de docu-  *
      *                              mento valido.                    *
      *        Input :                                                *
      *                                                               *
      *                peTido - Tipo de Documento.                    *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_tipoDeDocumento...
     D                 pr              n
     D   peTido                       2  0 const
      * --------------------------------------------------------------*
      * SVPVAL_nroDeDocumento(): Nro de Documento                     *
      *                                                               *
      *     peNrdo   (input)   Nro. de Documento                      *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_nroDeDocumento...
     D                 pr              n
     D   peNrdo                       8  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_chkBlkDocumento():Valida si el asegurado esta bloqueado*
      *                          por número de documento.             *
      *        Input :                                                *
      *                peBase - Base                                  *
      *                peNctw - Número de Cotización                  *
      *                peTido - Tipo de Documento.                    *
      *                peNrdo - Número de Documento                   *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_chkBlkDocumento...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTido                       2  0 const
     D   peNrdo                       9  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_chkBlkCuit():Valida si el asegurado esta bloqueado por *
      *                     numero de CUIT y CUIL.                    *
      *        Input :                                                *
      *                peBase - Base                                  *
      *                peNctw - Número de Cotización                  *
      *                peCuit - Numero Cuit/Cuil.                     *
      *                                                               *
      * ------------------------------------------------------------  *
     D SVPVAL_chkBlkCuit...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCuit                      11  0 const
      *------------------------------------------------------------- *
      * SVPVAL_ramaRiesgo():Valida si el riesgo corresponde a la rama *
      *                     ingresada.                                *
      *                                                               *
      *        Input :                                                *
      *                peRama - Rama                                  *
      *                peRiec - Código del Riesgo                     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_ramaRiesgo...
     D                 pr              n
     D   peRama                       2  0 const
     D   peRiec                       3    const
      *------------------------------------------------------------- *
      * SVPVAL_ramaCobertura(): Valida si la cobertura corresponde a  *
      *                         la rama.                              *
      *                                                               *
      *        Input :                                                *
      *                peRama - Rama                                  *
      *                peCobc - Código de Cobertura                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_ramaCobertura...
     D                 pr              n
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
      *------------------------------------------------------------- *
      * SVPVAL_ramaRiesgoCob(): Valida Rama  Riesgo y Cobertura       *
      *                                                               *
      *        Input :                                                *
      *                peRama - Rama                                  *
      *                peRiec - Código del Riesgo                     *
      *                peCobc - Código de Cobertura                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_ramaRiesgoCob...
     D                 pr              n
     D   peRama                       2  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_chkRamaPlan(): Valida Rama Plan                       *
      *     peRama   (input)   Rama                                  *
      *     pePlan   (input)   Plan                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPVAL_chkRamaPlan...
     D                 pr              n
     D  peRama                        2  0 const
     D  pePro                         3  0 const
      * --------------------------------------------------------------*
      * SVPVAL_CuitCuil(): Valida el numero de cuil y cuit            *
      *                                                               *
      *     peCuit   (input)   Numero de Cuil o Cuit                  *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_CuitCuil...
     D                 pr              n
     D   peCuit                      14    const
     D
      * ------------------------------------------------------------ *
      * SVPVAL_chkCaracBien() Valida Característica del Bien         *
      *     peBase   (input)   Parametros Base                       *
      *     peRama   (input)   Rama                                  *
      *     peCara   (input)   Características                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPVAL_chkCaracBien...
     D                 pr              n
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  peCcba                        3  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_chkCondCarac() Valida valor de Caracteristicas que    *
      *                       dependen de alguna condición.          *
      *                                                              *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubFijo Postal                        *
      *     peCara   (input)   Código de característica              *
      *     peMa01   (input)   Marca tiene o no tiene                *
      *     peMa02   (input)   marca Aplica o no Aplica              *
      *     peAnio   (input)   Año de Buen Reasultado                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPVAL_chkCondCarac...
     D                 pr              n
     D  peCopo                        5  0 const
     D  peCops                        1  0 const
     D  peCara                        3  0 const
     D  peMa01                        1    const
     D  peMa02                        1    const
     D  peAnio                        2  0 const
     D  peEmpr                        1a   const options(*nopass:*omit)
     D  peSucu                        2a   const options(*nopass:*omit)
     D  peNivt                        1  0 const options(*nopass:*omit)
     D  peNivc                        5  0 const options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SVPVAL_chkCobPrima()= Valida Coberturas de Primas            *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peRiec   (input)   Riesgo                                *
      *     peCobc   (input)   Cobertura(Prima)                      *
      *     peMone   (input)   Moneda                                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPVAL_chkCobPrima...
     D                 pr              n
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peRiec                        3    const
     D  peCobc                        3  0 const
     D  peMone                        2    const
      * ------------------------------------------------------------ *
      * SVPVAL_chkCodBuenR(): Valida Código de Buen Resultado.       *
      *     peBure   (input)   Código de Buen Resultado              *
      *                                                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPVAL_chkCodBuenR...
     D                 pr             1N
     D   peBure                       1  0   const
      * ------------------------------------------------------------- *
      * COWGRAI_CHKCobSumMaxMin(): Valida Suma Asegurada por Cobertura*
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peXpro   (input)   Plan                                   *
      *     peRiec   (input)   Cod. Riesgo                            *
      *     peCobc   (input)   Cod. Cobertura                         *
      *     peMone   (input)   Moneda                                 *
      *     peSaco   (input)   Suma asegurada                         *
      *     peLcob   (input)   Lista de Coberturas                    *
      *                                                               *
      * Return *on / *off                                             *
      * ------------------------------------------------------------- *
     D SVPVAL_CHKCobSumMaxMin...
     D                 pr              n
     D   peRama                       2  0   const
     D   peXpro                       3  0   const
     D   peRiec                       3      const
     D   peCobc                       3  0   const
     D   peMone                       2      const
     D   peSaco                      15  2   const
     D   peLcob                              likeds(cobPrima) dim(20) const
      * --------------------------------------------------------------*
      * SVPVAL_chkProfesion(): Valida el código de profesión          *
      *                                                               *
      *     peCprf   (input)   Código de profesión                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkProfesion...
     D                 pr              n
     D   peCprf                       3  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkProfesionWeb(): Valida el código de profesión       *
      *                                                               *
      *     peCprf   (input)   Código de profesión                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkProfesionWeb...
     D                 pr              n
     D   peCprf                       3  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkSexo     (): Valida el código de sexo               *
      *                                                               *
      *     peSexo   (input)   Código de Sexo                         *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkSexo...
     D                 pr              n
     D   peSexo                       1  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkSexoWeb(): Valida el código de sexo                 *
      *                                                               *
      *     peSexo   (input)   Código de Sexo                         *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkSexoWeb...
     D                 pr              n
     D   peSexo                       1  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkEdoCivil (): Valida el código de estado civil       *
      *                                                               *
      *     peEsci   (input)   Código de estado Civil                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkEdoCivil...
     D                 pr              n
     D   peEsci                       1  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkEdoCivilWeb(): Valida el código de estado civil     *
      *                                                               *
      *     peEsci   (input)   Código de estado Civil                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkEdoCivilWeb...
     D                 pr              n
     D   peEsci                       1  0 const
      * --------------------------------------------------------------*
      * SVPVAL_CodRamaActE (): Valida el código de Rama de Actividad  *
      *                        económica.                             *
      *                                                               *
      *     peRaae   (input)   Código de Rama Actividad Económica     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkRamaActE...
     D                 pr              n
     D   peRaae                       3  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkRamaActEWeb(): Valida el código de Rama de Actividad*
      *                        económica para web.                    *
      *                                                               *
      *     peRaae   (input)   Código de Rama Actividad Económica     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkRamaActEWeb...
     D                 pr              n
     D   peRaae                       3  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkPaisNac(): Valida el código del pais de nacimiento  *
      *                                                               *
      *     pePain   (input)   Código de Rama Actividad Económica     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkPaisNac...
     D                 pr              n
     D   pePain                       5  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkAsegurado (): Valida que no exista ya el asegurado  *
      *                         titular.                              *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peNase   (input)   Número de Asegurado                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkAsegurado...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNase                       6  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkTipoPersona(): Valida que sea un tipo de persona    *
      *                          valida.                              *
      *                                                               *
      *     peTiso   (input)   Código de Rama Actividad Económica     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkTipoPersona...
     D                 pr              n
     D   peTiso                       2  0 const
      * --------------------------------------------------------------*
      * SVPVAL_chkNroDeRuta(): Verifico si algun vehículo tiene numero*
      *                        de ruta.                               *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkNroDeRuta...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * --------------------------------------------------------------*
      * SVPVAL_urlIsValid  (): Valido que sea una página web Valida   *
      *                                                               *
      *     url      (input)   Dirección                              *
      *     len      (input)   tamaño                                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_urlIsValid...
     D                 pr              n
     D   url                      65535    const options(*varsize)
     D   len                         10i 0 const
      * --------------------------------------------------------------*
      * SVPVAL_nivelProductor():Verifico el nivel del productor, si   *
      *                         no es nivel 1 no debe permitir emitir *
      *                         cotización.                           *
      *                                                               *
      *     peNivt   (input)   Nivel Productor                        *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_nivelProductor...
     D                 pr              n
     D   peNivt                       1  0 const
      * --------------------------------------------------------------*
      * SVPVAL_arcdRamaArse():Verifico que exista                     *
      *                                                               *
      *     peArcd   (input)   Articulo                               *
      *     peRama   (input)   Rama                                   *
      *     peArse   (input)   Arse                                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_arcdRamaArse...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

      * --------------------------------------------------------------*
      * SVPVAL_empresa():Verifico que exista empresa                  *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_empresa...
     D                 pr              n
     D   peEmpr                       1    const

      * --------------------------------------------------------------*
      * SVPVAL_sucursal():Verifico que exista sucursal                *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_sucursal...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
      * --------------------------------------------------------------*
      * SVPVAL_chkProvinciaInder():Verifica Prov Inder                *
      *                                                               *
      *     peProc   (input)   Provincia                              *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkProvinciaInder...
     D                 pr              n
     D   peProc                       2  0 const
      * --------------------------------------------------------------*
      * SVPVAL_tipoMail(): Verifica tipo de mail                      *
      *                                                               *
      *     peCtce   (input)   Tipo de mail                           *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_tipoMail...
     D                 pr              n
     D   peCtce                       2  0 const
      * --------------------------------------------------------------*
      * SVPVAL_nacionalidad(): Verifica tipo de mail                  *
      *                                                               *
      *     peCnac   (input)   Nacionalidad                           *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_nacionalidad...
     D                 pr              n
     D   peCtce                       3  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPVAL_inz      pr
      * ------------------------------------------------------------ *
      * SVPVAL_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPVAL_end      pr
      * ------------------------------------------------------------ *
      * SVPVAL_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPVAL_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * --------------------------------------------------------------*
      * SVPVAL_articuloRenovacion(): Articulo Valido para Reno Autom  *
      *                                                               *
      *     peArcd   (input)   Articulo                               *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_articuloRenovacion...
     D                 pr              n
     D   peArcd                       6  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_productorRenoAutomatica() Productor Habilitado         *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNivt   (input)   Nivel                                  *
      *     peNivc   (input)   Productor                              *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_productorRenoAutomatica...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

      * ------------------------------------------------------------- *
      * SVPVAL_productorCbaMza(): Productor Cba o Mza                 *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNivt   (input)   Nivel                                  *
      *     peNivc   (input)   Productor                              *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_productorCbaMza...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_aseguradoCbaMza(): Asegurado Cba o Mza                 *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNrdf   (input)   Asegurado                              *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_aseguradoCbaMza...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNrdf                       7  0 const
      * ------------------------------------------------------------- *
      * SVPVAL_productorBloqueado(): Productor bloqueado para Operacion
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNivt   (input)   Nivel                                  *
      *     peNivc   (input)   Productor                              *
      *     peTiou   (input)   Tipo de Operacion                      *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_productorBloqueado...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peTiou                       1  0 const

      * --------------------------------------------------------------*
      * SVPVAL_codigoDeAjuste(): Codigo de Ajuste Articulo            *
      *                                                               *
      *     peArcd   (input)   Articulo                               *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_codigoDeAjuste...
     D                 pr              n
     D   peArcd                       6  0 const

      * --------------------------------------------------------------*
      * SVPVAL_chkPlanCerrado(): Verifica si Plan es Cerrado          *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peXpro   (input)   Plan                                   *
      *     peMone   (input)   Moneda                                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkPlanCerrado...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peMone                       2    const

      * --------------------------------------------------------------*
      * SVPVAL_chkInfoAutoWeb(): Verifica si Marca/Modelo es WEB      *
      *                                                               *
      *     peCmar   (input)   Marca Infoauto                         *
      *     peCmod   (input)   Modelo infoauto                        *
      *                                                               *
      * Retorna: *On = Web / *off = No WEB                            *
      * ------------------------------------------------------------- *
     D SVPVAL_chkInfoAutoWeb...
     D                 pr              n
     D   peCmar                       9  0 const
     D   peCmod                       9  0 const

      * --------------------------------------------------------------*
      * SVPVAL_chkClienteIntegral(): Valia si el Cliente es Integral  *
      *                                                               *
      *     peCodi   (input)   Codigo                                 *
      *     peAsen   (input)   Nro de Asegurado                       *
      *     peFech   (input)   Fecha de Vigencia                      *
      *     peFpgm   (input)   Fin de PGM                             *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     D SVPVAL_chkClienteIntegral...
     D                 pr              n
     D   peCodi                       3
     D   peAsen                       7  0
     D   peFech                       8  0
     D   peFpgm                       3    options( *omit : *nopass )

      * ------------------------------------------------------------ *
      * SVPVAL_chkProductorAsegurado: Verifica que el productor se   *
      *             encuentre habilitado a operar con el asegurado.- *
      *                                                              *
      *     peNivt   (input)   Tipo Nivel Intermediario              *
      *     peNivc   (input)   Codigo Nivel Intermediario            *
      *     peTido   (input)   Tipo de Documento ( opcional )        *
      *     peNrdo   (input)   Nro de Documento  ( opcional )        *
      *     peCuit   (input)   Nro CUIT          ( opcional )        *
      *                                                              *
      * Retorna: *on = Si habilitado / *off = Si no esta habilitado  *
      * ------------------------------------------------------------ *
     D SVPVAL_chkProductorAsegurado...
     D                 pr              n
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peTido                       2  0 options(*nopass:*omit)
     D   peNrdo                       8  0 options(*nopass:*omit)
     D   peCuit                      11    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPVAL_chkAseguradoProdAs1: Verifica que el asegurado se     *
      *           encuentre relacionado con el productor leer Pahas1 *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Codigo de Sucursal                    *
      *     peNivt   (input)   Tipo Nivel Intermediario              *
      *     peNivc   (input)   Código Nivel Intermediario            *
      *     peAsen   (input)   Número de Asegurado                   *
      *                                                              *
      * Retorna: *on = Relacionado   / *off = No esta relacionado    *
      * ------------------------------------------------------------ *
     D SVPVAL_chkAseguradoProdAs1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peAsen                       7  0 const

      * ------------------------------------------------------------------ *
      * SVPVAL_chkTipoDocHabWeb(): Chequea que el tipo de documento este   *
      *                            habilitado para la web                  *
      *                                                                    *
      *     peTido ( input )  Tipo de Documento                            *
      *                                                                    *
      * Retorna *on = Habilitado / *off = No habilitado                    *
      * ------------------------------------------------------------------ *
     D SVPVAL_chkTipoDocHabWeb...
     D                 pr              n
     D   peTido                       2  0 const

      * ------------------------------------------------------------------ *
      * SVPVAL_chkCodIvaHabWeb(): Chequea que el Código de Iva este habi-  *
      *                           litado para la Web                       *
      *                                                                    *
      *     peCiva ( input )  Nro. de Superpoliza                          *
      *                                                                    *
      * Retorna *on = Habilitado / *off = No habilitado                    *
      * ------------------------------------------------------------------ *
     D SVPVAL_chkCodIvaHabWeb...
     D                 pr              n
     D   peCiva                       2  0 const

      * ------------------------------------------------------------------ *
      * SVPVAL_chkEdadVida(): Chequea Edad Minima y Maxima de Vida.        *
      *                                                                    *
      *     peArcd ( input  ) Código de Articulo                           *
      *     peRama ( input  ) Código de Rama                               *
      *     peArse ( input  ) Cant. Pólizas por Rama/Art                   *
      *     peXpro ( input  ) Código de Producto                           *
      *     peEdad ( input  ) Edad del Asegurado                           *
      *                                                                    *
      * Retorna *on = Permitida  / *off = No Permitida                     *
      * ------------------------------------------------------------------ *
     D SVPVAL_chkEdadVida...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       3  0 const
     D   peEdad                       2  0 const

      * ------------------------------------------------------------------ *
      * SVPVAL_chkPlanesHabilWeb(): Chequea si hay planes habilitados para *
      *                             la web (en todas sus ubicaciones de    *
      *                             riesgo).                               *
      *                                                                    *
      *     peEmpr ( input )  Código de Empresa                            *
      *     peSucu ( input )  Código de Sucursal                           *
      *     peArcd ( input )  Código de Articulo                           *
      *     peSpol ( input )  Nro. de Superpoliza                          *
      *     peRama ( input )  Código de Rama                               *
      *     peArse ( input )  Cantidad de Polizas por Rama                 *
      *     peOper ( input )  Nro. Operación                               *
      *     pePoco ( input )  Nro. de Componente                           *
      *                                                                    *
      * Retorna *On = Habilitado / *off = No habilitado                    *
      * ------------------------------------------------------------------ *
     D SVPVAL_chkPlanesHabilWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 options(*nopass:*omit)
     D   peOper                       7  0 options(*nopass:*omit)
     D   pePoco                       4  0 options(*nopass:*omit)

      * ------------------------------------------------------------- *
      * SVPVAL_productorRenoAutomatica2() Productor Habilitado         *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peNivt   (input)   Nivel                                  *
      *     peNivc   (input)   Productor                              *
      *     peRama   (input)   Rama                                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_productorRenoAutomatica2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peRama                       2  0 const

      * ------------------------------------------------------------- *
      * SVPVAL_chkMayorAuxiliar(): Chequea Mayor Auxiliar             *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peComa   (input)   Cod. Mayor Auxiliar                    *
      *     peNrma   (input)   Nro. Mayor Auxiliar                    *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_chkMayorAuxiliar...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const

      * ------------------------------------------------------------ *
      * SVPVAL_monedaV2(): Validar Moneda.                           *
      *                                                              *
      *     peComo   (input)   Código de Moneda                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVAL_monedaV2...
     D                 pr              n
     D   peComo                       2    const

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloTarifa(): Chequea Capitulo de Tarifa        *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peCtar   (input)   Capitulo de Tarifa                     *
      *     peCta1   (input)   Capitulo de Tarifa Inciso 1            *
      *     peCta2   (input)   Capitulo de Tarifa Inciso 2            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_chkCapituloTarifa...
     D                 pr              n
     D   peRama                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2a   const
     D   peCta2                       2a   const

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloTarifaArticulo(): Chequea Relacion entre    *
      *                    Capitulo de Tarifa y Articulo              *
      *                                                               *
      *     peArcd   (input)   Articulo                               *
      *     peRama   (input)   Rama                                   *
      *     peArse   (input)   Secuencia de Rama en articulo          *
      *     peCtar   (input)   Capitulo de Tarifa                     *
      *     peCta1   (input)   Capitulo de Tarifa Inciso 1            *
      *     peCta2   (input)   Capitulo de Tarifa Inciso 2            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_chkCapituloTarifaArticulo...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2a   const
     D   peCta2                       2a   const

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloTarifaPlan(): Chequea relacion entre Capitu-*
      *                    lo de Tarifa y Plan.                       *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peCtar   (input)   Capitulo de Tarifa                     *
      *     peCta1   (input)   Capitulo de Tarifa Inciso 1            *
      *     peCta2   (input)   Capitulo de Tarifa Inciso 2            *
      *     peXpro   (input)   Codigo de Plan/Producto                *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_chkCapituloTarifaPlan...
     D                 pr              n
     D   peRama                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2a   const
     D   peCta2                       2a   const
     D   peXpro                       3  0 const

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloTarifaWeb(): Chequea Capitulo de Tarifa web *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peCtar   (input)   Capitulo de Tarifa                     *
      *     peCta1   (input)   Capitulo de Tarifa Inciso 1            *
      *     peCta2   (input)   Capitulo de Tarifa Inciso 2            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_chkCapituloTarifaWeb...
     D                 pr              n
     D   peRama                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2a   const
     D   peCta2                       2a   const

      * ------------------------------------------------------------- *
      * SVPVAL_chkCapituloVariante(): Chequea Capitulo/Variante de    *
      *                               autos.                          *
      *                                                               *
      *     peVhca   (input)   Capitulo                               *
      *     peVhv1   (input)   Variante RC                            *
      *     peVhv2   (input)   Variante AIR                           *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_chkCapituloVariante...
     D                 pr              n
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const

      * ------------------------------------------------------------- *
      * SVPVAL_chkTarifaDiferencial():Chequea marca de tarifa diferen-*
      *                               cial de autos.                  *
      *                                                               *
      *     peMtdf   (input)   Marca de Tarifa Diferencial            *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_chkTarifaDiferencial...
     D                 pr              n
     D   peMtdf                       1a   const

      * ------------------------------------------------------------- *
      * SVPVAL_productoWeb(): Valida el Producto Web                  *
      *                                                               *
      *     peRama   (input)   Codigo Rama                            *
      *     peXpro   (input)   Codigo Producto                        *
      *     peFech   (input)   Fecha                                  *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_productoWeb...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------- *
      * SVPVAL_planDePagoWeb(): Valida el Plan de Pago Web            *
      *                                                               *
      *     peArcd   (input)   Codigo Articulo                        *
      *     peCfpg   (input)   Codigo Forma de Pago                   *
      *     peNrpp   (input)   Numero de Plan de Pago                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_planDePagoWeb...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const
     D   peNrpp                       3  0 const

      * ------------------------------------------------------------- *
      * SVPVAL_hechoGenerador(): Valida Hecho Generador               *
      *                                                               *
      *     peHecg   (input)   hecho generador                        *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_hechoGenerador...
     D                 pr              n
     D   peHecg                       2a   const

      * ------------------------------------------------------------- *
      * SVPVAL_tipoDeLesiones(): Valida los Tipos De Lesiones         *
      *                                                               *
      *     peCtle   (input)   código de Lesiones                     *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_tipoDeLesiones...
     D                 pr              n
     D   peCtle                       1a   const

      * ------------------------------------------------------------- *
      * SVPVAL_tipoDeCambio(): Valida el Tipo de Cambio               *
      *                                                               *
      *     peTipv   (input)   Tipo de Cambio                         *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_tipoDeCambio...
     D                 pr              n
     D   peTipv                       1a   const

      * ------------------------------------------------------------- *
      * SVPVAL_causaSiniestro(): Validación Causa                     *
      *                                                               *
      *     peRama   (input)   Código Rama                            *
      *     peCauc   (input)   Código Causa                           *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_causaSiniestro...
     D                 pr              n
     D   peRama                       2  0 const
     D   peCauc                       4  0 const

      * ------------------------------------------------------------- *
      * SVPVAL_lugarPrisma():    Validación Causa                     *
      *                                                               *
      *     peClos   (input)   Lugar Ocurrencia Stro.                 *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_lugarPrisma...
     D                 pr              n
     D   peClos                       2a   const

      * ------------------------------------------------------------- *
      * SVPVAL_estadoDelTiempo(): Estado del Tiempo                   *
      *                                                               *
      *     peEmpr   (input)   Codigo Empresa                         *
      *     peSucu   (input)   Codigo Sucursal                        *
      *     peCdes   (input)   Codigo Estado                          *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_estadoDelTiempo...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peCdes                       2  0 const

      * ------------------------------------------------------------- *
      *  SVPVAL_tipoDeAccidente(): Tipo de Accidente                  *
      *                                                               *
      *     peEmpr   (input)   Codigo Empresa                         *
      *     peSucu   (input)   Codigo Sucursal                        *
      *     peCdcs   (input)   Codigo Caracteristica Siniestro        *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_tipoDeAccidente...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peCdcs                       2  0 const

      * ------------------------------------------------------------- *
      *  SVPVAL_colisionCon(): Colision Con                           *
      *                                                               *
      *     peEmpr   (input)   Codigo Empresa                         *
      *     peSucu   (input)   Codigo Sucursal                        *
      *     peCtco   (input)   Codigo Tipo Colision                   *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_colisionCon...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peCtco                       2  0 const

      * ------------------------------------------------------------- *
      *  SVPVAL_lugarNoPrisma(): Lugar **NO** Prisma                  *
      *                                                               *
      *     peEmpr   (input)   Codigo Empresa                         *
      *     peSucu   (input)   Codigo Sucursal                        *
      *     peClug   (input)   Codigo de Lugar                        *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------  *
     D SVPVAL_lugarNoPrisma...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peClug                       2  0 const

      * ------------------------------------------------------------ *
      * SVPVAL_relacionAsegurado(): Valida relación de asegurado.    *
      *                                                              *
      *     peEmpr   (input)   Codigo Empresa                        *
      *     peSucu   (input)   Codigo Sucursal                       *
      *     peRela   (input)   Codigo de Relación                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPVAL_relacionAsegurado...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peRela                       2  0 const

      * ------------------------------------------------------------ *
      * SVPVAL_HechoGenCob(): Validacion Hecho Generador valido para *
      *                       Cobertura                              *
      *     peCobl   (input)  Codigo de Cobertura (Letra)            *
      *     peXcob   (input)  Codigo de Cobertura                    *
      *     peHecg   (input)  Hecho Generador                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPVAL_HechoGenCob...
     D                 pr              n
     D   peCobl                       2a   const
     D   peXcob                       3  0 const
     D   peHecg                       1a   const

      * ------------------------------------------------------------ *
      * SVPVAL_EstadoSin():   Validacion Codigo Estado del Siniestro *
      *     peEmpr   (input)  Empresa                                *
      *     peSucu   (input)  Sucursal                               *
      *     peRama   (input)  Rama                                   *
      *     peCesi   (input)  Codigo Estado Siniestro                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPVAL_EstadoSin...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peRama                       2  0 const
     D   peCesi                       2  0 const
      * ------------------------------------------------------------ *
      * SVPVAL_chkCiaCoaseg() Valida Compania Coaseguradora          *
      *                                                              *
      *     peNcoc   (input)  Codigo Cia Coaseguradora               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPVAL_chkCiaCoaseg...
     D                 pr              n
     D   peNcoc                       5  0 const

      * ------------------------------------------------------------ *
      * SVPVAL_chkCobAfec() Valida Cobertura Afectada                *
      *                                                              *
      *     peXcob   (input)  Codigo Cob Afectada                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPVAL_chkCobAfec...
     D                 pr              n
     D   peXcob                       3  0 const


