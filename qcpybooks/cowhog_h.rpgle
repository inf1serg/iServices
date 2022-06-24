      /if defined(COWHOG_H)
      /eof
      /endif
      /define COWHOG_H

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/svpren_h.rpgle'
      /copy './qcpybooks/svpavr_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/wsltab_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/svpdes_H.rpgle'
      /copy './qcpybooks/svpdrc_h.rpgle'
      /copy './qcpybooks/svpviv_h.rpgle'
      /copy './qcpybooks/svpdrv_h.rpgle'
      /copy './qcpybooks/svpbue_h.rpgle'
      /copy './qcpybooks/svpriv_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'

     D Caracbien       ds                  qualified based(template)
     D  ccba                          3  0
     D  dcba                         25
     D  ma01                          1
     D  ma02                          1
     D  ma01m                         1
     D  ma02m                         1
     D  cbae                          3

     D Bonific         ds                  qualified based(template)
     D  xcob                          3  0
     D  ccbp                          3  0
     D  dcbp                         25
     D  nive                          1  0
     D  pbon                          5  2
     D  prec                          5  2

     D UbicPoc_t       ds                  qualified based(template)
     D   Poco                         4  0
     D   Xpro                         3  0
     D   Tviv                         3  0
     D   Cara                              likeds(set160_t) dim(99)
     D   CaraC                       10i 0
     D   Copo                         5  0
     D   Cops                         1  0
     D   Scta                         1  0
     D   Bure                         1  0
     D   Cobe                              likeds(Cobprima)  dim(20)
     D   Impu                              likeds(Impuesto)  dim(99)
     D   Prem                        13p 2
     D   Suma                        13p 2
     D   Boni                              likeds(Bonific)   dim(200)
     D   Insp                         1a
     D   Psua                         2p 0

     D Condcome        ds                  qualified based(template)
     D   rama                         2  0
     D   xrea                         5  2

      * ------------------------------------------------------------ *
      * COWHOG_cotizarWeb: Cotiza un Bien Asegurado de una Rama de   *
      *                    Hogar.                                    *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        pePoco (input)  Nro. de Componente                    *
      *        peXpro (input)  Código de Plan(Producto)              *
      *        peTviv (input)  Tipo de Vivienda                      *
      *        peCara (input)  Características de Bien               *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo Código Postal                  *
      *        peScta (input)  Zona de Riesgo                        *
      *        peBure (input)  Código de Buen Resultado              *
      *        peNrrp (input)  Plan de Pago                          *
      *        peTipe (input)  Tipo de Forma de Pago                 *
      *        peCiva (input)  Condicion de IVA                      *
      *        peCobe (in/ou)  Coberturas (Primas)                   *
      *        peSuma (output) Suma Asegurada Total                  *
      *        peInsp (output) Requiere Inspección                   *
      *        peBoni (output) Bonificaciones por Coberturas         *
      *        peImpu (output) Impuestos                             *
      *        pePrem (output) Premio                                *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_cotizarWeb...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peBure                       1  0   const
     D   peNrrp                       3  0   const
     D   peTipe                       1      const
     D   peCiva                       2  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
     D   peSuma                      13  2
     D   peInsp                       1
     D   peBoni                            likeds(Bonific) dim(200)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrem                      13  2
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWHOG_chkcotizarWeb: Chequear datos ingresados en una solic-*
      *                        itud de Cotizacion de Hogar.          *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        pePoco (input)  Nro. de Componente                    *
      *        peXpro (input)  Código de Plan(Producto)              *
      *        peTviv (input)  Tipo de Vivienda                      *
      *        peCara (input)  Características de Bien               *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo Código Postal                  *
      *        peScta (input)  Zona de Riesgo                        *
      *        peBure (input)  Código de Buen Resultado              *
      *        peCfpg (input)  Código de Forma de pago               *
      *        peTipe (input)  Tipo de Forma de Pago                 *
      *        peCiva (input)  Condicion de IVA                      *
      *        peCobe (input)  Coberturas (Primas)                   *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_chkcotizarWeb...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peBure                       1  0   const
     D   peCfpg                       1  0   const
     D   peTipe                       1      const
     D   peCiva                       2  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWHOG_ReCotizarWeb: ReCotiza un Bien Asegurado de una Rama  *
      *                      de Hogar.                               *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        pePoco (input)  Nro. de Componente                    *
      *        peXpro (input)  Código de Plan(Producto)              *
      *        peTviv (input)  Tipo de Vivienda                      *
      *        peCara (input)  Características de Bien               *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo Código Postal                  *
      *        peScta (input)  Zona de Riesgo                        *
      *        peBure (input)  Código de Buen Resultado              *
      *        peNrrp (input)  Plan de Pago                          *
      *        peTipe (input)  Tipo de Forma de Pago                 *
      *        peCiva (input)  Condicion de IVA                      *
      *        peCobe (input)  Coberturas (Primas)                   *
      *        peSuma (output) Suma Asegurada Total                  *
      *        peInsp (output) Requiere Inspección                   *
      *        peBoni (output) Bonificaciones por Coberturas         *
      *        peImpu (output) Impuestos                             *
      *        pePrem (output) Premio                                *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_ReCotizarWeb...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peScta                       1  0   const
     D   peBure                       1  0   const
     D   peNrrp                       3  0   const
     D   peTipe                       1      const
     D   peCiva                       2  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
     D   peSuma                      13  2
     D   peInsp                       1
     D   peBoni                            likeds(Bonific)  dim(200)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrem                      13  2
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWHOG_saveCabeceraRV(): Cabecera Riesgos Varios             *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     peCopo   (input)   Código Postal                         *
      *     peCops   (input)   Sufijo del Codigo Postal              *
      *     peXpro   (input)   Código de Plan(Producto)              *
      *     peTviv   (input)   Tipo de Vivienda                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_saveCabeceraRV...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peXpro                       3  0   const
     D   peTviv                       3  0   const
      * ------------------------------------------------------------ *
      * COWHOG_saveCoberturasRv(): Graba Coberturas Riesgos Varios   *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWHOG_saveCoberturasRv...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peCobe                       3  0 const
     D   peSaco                      13  2 const
      * ------------------------------------------------------------ *
      * COWHOG_GetPormilajePrima(): Graba Coberturas Riesgos Varios  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peXpri   (output)  Pormilaje                             *
      *     pePrim   (output)  Prima                                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_GetPormilajePrima...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peCobe                       3  0 const
     D   peXpri                       9  6
     D   pePrim                      15  2
      * ------------------------------------------------------------ *
      * COWHOG_RecuperaTasaSumAseg...                                *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peRiec   (input)   Riesgo                                *
      *     peCobc   (input)   Cobertura                             *
      *     peMone   (input)   Moneda                                *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peXpri   (output)  Prima por milaje                      *
      *     pePtco   (output)  Prima                                 *
      *     peTpcd   (output)  Codigo de Texto Preseteado            *
      *     peCls    (output)  Clausula                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_RecuperaTasaSumAseg...
     D                 pr
     D   peRama                       3  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3a   const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peSaco                      15  2 const
     D   peXpri                       9  6
     D   pePtco                      15  2
     D   peTpcd                       2a
     D   peCls                        3a   dim(200)
      * ------------------------------------------------------------ *
      * COWHOG_DltCaracteristicas...                                 *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_DltCaracteristicas...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWHOG_SaveCaracteristicas...                                *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *     PeCara   (input)  Cod. Caracteristica                    *
      *     PeMa01   (input)  Tiene o no tiene                       *
      *     PeMa02   (input)  Aplica o no Bonif/Rec                  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWHOG_SaveCaracteristicas...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peCara                       3  0 const
     D   PeMa01                       1    const
     D   PeMa02                       1    const
      * ------------------------------------------------------------ *
      * COWHOG_GetSumaAsegCobertura...                               *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWHOG_GetSumaAsegCobertura...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWHOG_UpdCabeceraRV...                                      *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peNctw   (input)  Nro de Cotizacion                      *
      *     peRama   (input)  Rama                                   *
      *     peArse   (input)  Cant. de Articulos                     *
      *     pePoco   (input)  Componente                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_UpdCabeceraRV...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWHOG_GetBoniCobertura...                                   *
      *                                                              *
      *     peNctw   (input)  Parametros Base                        *
      *     peRama   (input)  Rama                                   *
      *     peArse   (input)  Cant Articulos                         *
      *     pePoco   (input)  Nro Componente                         *
      *     peBoni   (input)  Bonificiacion                          *
      *     peBonC   (input)  Cant. Bonificaciones                   *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWHOG_GetBoniCobertura...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peBoni                            likeds(Bonific) dim(200)
     D   peBoniC                     10i 0
      * ------------------------------------------------------------ *
      * COWHOG_GetPrima(): Obtener Prima Total                       *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWHOG_GetPrima...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWHOG_getPremio(): Obtener Premio                           *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWHOG_getPremio...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWHOG_getSumaSiniestrablePoco: Suma Siniestrable            *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *     pePoco (input)  Número de Bien asegurado                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_getSumaSiniestrablePoco...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const
      * ------------------------------------------------------------ *
      * COWHOG_GetRequiereInspeccion(): Devuelve si requiere Inspec- *
      *                                 cion.                        *
      *     peRama (input)  Rama                                     *
      *     peCobe (input)  Coberturas                               *
      *                                                              *
      * Retorna S/ N                                                 *
      * ------------------------------------------------------------ *
     D COWHOG_GetRequiereInspeccion...
     D                 pr             1
     D   peRama                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)const
      * ------------------------------------------------------------ *
      * COWHOG_setCondCarac() Valida valor de Caracteristicas que    *
      *                       dependen de alguna condición.          *
      *                                                              *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubFijo Postal                        *
      *     peAnio   (input)   Año de Buen Reasultado                *
      *     peCara   (input)   Código de característica              *
      *     peMa01   (input)   Marca tiene o no tiene                *
      *     peMa02   (input)   marca Aplica o no Aplica              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWHOG_setCondCarac...
     D                 pr              n
     D  peCopo                        5  0 const
     D  peCops                        1  0 const
     D  peAnio                        2  0 const
     D  peCara                        3  0 const
     D  peMa01                        1
     D  peMa02                        1
      * ------------------------------------------------------------ *
      * COWHOG_caracIsValid() Verifica que las Caracteristicas sean  *
      *                       validas.                               *
      *                                                              *
      * DEPRECATED: Usar COWHOG_caracIsValid2()                      *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        pePoco (input)  Nro. de Componente                    *
      *        peCara (input)  Características de Bien               *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWHOG_caracIsValid...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWHOG_caracIsValid2()Verifica que las Caracteristicas sean  *
      *                       validas.                               *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        pePoco (input)  Nro. de Componente                    *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo CP                             *
      *        peCara (input)  Características de Bien               *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWHOG_caracIsValid2...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWHOG_cobCombinado() Valida que tenga al menos tres cobertu *
      *                       ras y que al menos una sea de incendio *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peCobe   (input)   Coberturas  (Primas)                  *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWHOG_cobCombinado...
     D                 pr              n
     D   peRama                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20) const
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWHOG_validaCarac() : Valida caracteristicas ingresadas     *
      *                                                              *
      *     peBase   (input)   Rama                                  *
      *     peRama   (input)   Coberturas  (Primas)                  *
      *     peCara   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWHOG_validaCarac...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peCara                            likeds(Caracbien) dim(50) const
      * ------------------------------------------------------------ *
      * COWHOG_planesCerrados(): Calcula Planes Cerrados             *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *     pePoco (input)  Número de Bien asegurado                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_planesCerrados...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const
      * ------------------------------------------------------------ *
      * COWHOG_ValSelCaracPlan(): Valida Caracteristicas de un Plan  *
      *                           vs Caracteristicas Seleccionadas   *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peXpro (input)  Plan                                     *
      *     pePcara(input)  Caracteristicas                          *
      *     peError(output) Indicador                                *
      *     peMsgs (output) Estructura de Error                      *
      *                                                              *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWHOG_ValSelCaracPlan...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXpro                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWHOG_ValCaracPlan(): Busca Caracteristica dentro de la     *
      *                           lista seleccionada                 *
      *                                                              *
      *     peCarac(input)  Cod. Caracteristica                      *
      *     pePcara(input)  Caracteristicas Seleccionadas            *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWHOG_ValCaracPlan...
     D                 pr              n
     D   peCara                       3  0 const
     D   peVcar                       3  0 dim(50) const
      * ------------------------------------------------------------ *
      * COWHOG_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWHOG_inz      pr
      * ------------------------------------------------------------ *
      * COWHOG_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWHOG_end      pr
      * ------------------------------------------------------------ *
      * COWHOG_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D COWHOG_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * COWHOG_calculaCaracteristicas(): Este procedimiento calcula  *
      *                        qué características debe tener una    *
      *                        determinada ubicación, duplicando la  *
      *                        lógica de PAR314L.                    *
      *                                                              *
      *  Fue ideado para poder renderizar el "subfile" de caracterís-*
      *  ticas en el .xhtml de Hogar Abierto, pero puede usarse para *
      *  todas las ramas de RV.                                      *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Secuencia de Rama en Artículo         *
      *        peXpro (input)  Código de Producto                    *
      *        peCopo (input)  Código Postal de la ubicación         *
      *        peCops (input)  Sufijo Código Postal de la ubicación  *
      *        peRdes (input)  Ubicación del Riesgo *blanks en Nueva *
      *        peCara (output) Características de Bien               *
      *        peCaraC(output) Cantidad de entradas en peCara        *
      *        peErro (output) Indicador de Error                    *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * Retorna: Void                                                *
      * ------------------------------------------------------------ *
     D COWHOG_calculaCaracteristicas...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRdes                      40a   const
     D   peCara                            likeds(set160_t) dim(99)
     D   peCaraC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------------ *
      * COWHOG_setRequiereInspeccion(): Graba si cobertura requiere        *
      *                                 inspeccion.                        *
      *                                                                    *
      *     peBase ( input )  Parametros Base                              *
      *     peNctw ( input )  Nro. de Cotización                           *
      *     peRama ( input )  Rama                                         *
      *     peArse ( input )  Cantidad de Polizas por Rama                 *
      *     pePoco ( input )  Nro de Componente                            *
      *     peXpro ( input )  Producto                                     *
      *     peCobe ( input )  Coberturas                                   *
      *                                                                    *
      * Retorna *On = Operación Exitosa / *off = Operación Fallida         *
      * ------------------------------------------------------------------ *
     D COWHOG_setRequiereInspeccion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peXpro                       3  0 const
     D   peCobe                            likeds(Cobprima) dim(20)const

      * ------------------------------------------------------------------ *
      * COWHOG_getInspeccion(): Retoma Marca de Inspeccion de Cabecera     *
      *                                                                    *
      *     peBase ( input )  Parametros Base                              *
      *     peNctw ( input )  Nro. de Cotización                           *
      *     peRama ( input )  Rama                                         *
      *     peArse ( input )  Cantidad de Polizas por Rama                 *
      *     pePoco ( input )  Nro de Componente                            *
      *                                                                    *
      * Retorna S = Si / N = No                                            *
      * ------------------------------------------------------------------ *
     D COWHOG_getInspeccion...
     D                 pr             1
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------------ *
      * COWHOG_chkPlanesHabilWeb(): Chequea si hay planes habilitados para *
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
     D COWHOG_chkPlanesHabilWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 options(*nopass:*omit)
     D   peOper                       7  0 options(*nopass:*omit)
     D   pePoco                       4  0 options(*nopass:*omit)

      * ------------------------------------------------------------------ *
      * COWHOG_cantidadUbicacRies(): Retorna cantidad de ubicaciones de    *
      *                              riesgos activas.                      *
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
      * Retorna @@Cant                                                     *
      * ------------------------------------------------------------------ *
     D COWHOG_cantidadUbicacRies...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 options(*nopass:*omit)
     D   peOper                       7  0 options(*nopass:*omit)
     D   pePoco                       4  0 options(*nopass:*omit)

      * ------------------------------------------------------------------ *
      * COWHOG_chkRenovacion(): Valida campos antes de realizar renovación *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peArcd ( input  )  Código de Articulo                          *
      *     peSpol ( input  )  Número de SuperPoliza                       *
      *     peErro ( output )  Indicador                                   *
      *     peMsgs ( output )  Estructura de Error                         *
      *                                                                    *
      * ------------------------------------------------------------------ *
     D COWHOG_chkRenovacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------------ *
      * COWHOG_getInfoHogar(): Retorna datos para renovar hogar            *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peArcd ( input  )  Código de Articulo                          *
      *     peSpol ( input  )  Número de SuperPoliza                       *
      *     peNctw ( input  )  Número de Cotización                        *
      *     peRama ( output )  Código de Rama                              *
      *     peArse ( output )  Cantidad de Pólizas por Rama                *
      *     peCfpg ( output )  Plan de pago                                *
      *     peClie ( output )  Estructura de Cliente                       *
      *     pePoco ( output )  Estructura de Componente                    *
      *     peXrea ( output )  Epv                                         *
      *                                                                    *
      * ------------------------------------------------------------------ *
     D COWHOG_getInfoHogar...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNctw                       7  0 const
     D   peRama                       2  0
     D   peArse                       2  0
     D   peCfpg                       3  0
     D   peClie                            likeds(ClienteCot_t)
     D   pePoco                            likeds(UbicPoc_t) dim(10)
     D   peXrea                       5  2

      * ------------------------------------------------------------ *
      * COWHOG_cotizarWeb2:Cotiza un Bien Asegurado de una Rama de   *
      *                    Hogar.                                    *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        peCfpg (input)  Plan de Pago                          *
      *        peClie (input)  Estructura de Cliente                 *
      *        pePoco (in/ou)  Array de componentes                  *
      *        pePocoC(input)  Cantidad de entradas en pePoco        *
      *        peXrea (input)  Epv                                   *
      *        peImpu (output) Estructura de impuestos total         *
      *        peSuma (output) Suma Asegurada total                  *
      *        pePrim (output) Prima total                           *
      *        pePrem (output) Premio total                          *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWHOG_cotizarWeb2...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0 const
     D  peClie                             likeds(ClienteCot_t) const
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0 const
     D  peXrea                        5  2 const
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

