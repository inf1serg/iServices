      /if defined(COWRGV_H)
      /eof
      /endif
      /define COWRGV_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      * Obtener svpriv_h para dsPaher9_t
      /copy './qcpybooks/svpriv_h.rpgle'
      * obtener PrimPrem
      /copy './qcpybooks/cowrtv_h.rpgle'
      * llamada a servicios
      /copy './qcpybooks/svpavr_h.rpgle'
      * llamada a servicios
      /copy './qcpybooks/svpren_h.rpgle'
      * llamada a servicios
      /copy './qcpybooks/svpdrc_h.rpgle'
      * Obtener WSLTAB para set160_t
      /copy './qcpybooks/wsltab_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpviv_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D DsCtwer0_t      ds                  qualified based(template)
     D   r0empr                       1
     D   r0sucu                       2
     D   r0nivt                       1p 0
     D   r0nivc                       5p 0
     D   r0nctw                       7p 0
     D   r0rama                       2p 0
     D   r0arse                       2p 0
     D   r0poco                       4p 0
     D   r0xpro                       3p 0
     D   r0rpro                       2p 0
     D   r0rdep                       2p 0
     D   r0rloc                       2
     D   r0blck                      10
     D   r0rdes                      30p 0
     D   r0nrdm                       5p 0
     D   r0copo                       5p 0
     D   r0cops                       1p 0
     D   r0suas                      13p 0
     D   r0samo                      13p 0
     D   r0cviv                       3
     D   r0clfr                       4p 0
     D   r0cagr                       2p 0
     D   r0psmp                       5p 2
     D   r0crea                       2
     D   r0ctar                       4
     D   r0cta1                       2
     D   r0cta2                       2
     D   r0ma01                       1
     D   r0ma02                       1
     D   r0ma03                       1
     D   r0ma04                       1
     D   r0ma05                       1
     D   r0prim                      15p 2
     D   r0prem                      15p 2
     D   r0sast                      13
     D   r0acrc                       7
     D   r0acrn                       1

     D UbicPoc2_t      ds                  qualified based(template)
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
     D   Ctar                         4p 0
     D   Cta1                         2a
     D   Cta2                         2a
     D   Clfr                         4a
     D   Cagr                         2  0

      * ------------------------------------------------------------ *
      * COWRGV_cotizarWeb: Cotiza un Bien Asegurado de una Rama      *
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
     D COWRGV_cotizarWeb...
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
      * COWRGV_chkcotizarWeb: Chequear datos ingresados en una solic-*
      *                        itud de Cotizacion.                   *
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
     D COWRGV_chkcotizarWeb...
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
      * COWRGV_saveCabeceraRV(): Cabecera Riesgos Varios             *
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
     D COWRGV_saveCabeceraRV...
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
      * COWRGV_saveCoberturasRv(): Graba Coberturas Riesgos Varios   *
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
     D COWRGV_saveCoberturasRv...
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
      * COWRGV_GetPormilajePrima(): Graba Coberturas Riesgos Varios  *
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
     D COWRGV_GetPormilajePrima...
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
      * COWRGV_RecuperaTasaSumAseg...                                *
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
     D COWRGV_RecuperaTasaSumAseg...
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
      * COWRGV_DltCaracteristicas...                                 *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRGV_DltCaracteristicas...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWRGV_SaveCaracteristicas...                                *
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
     D COWRGV_SaveCaracteristicas...
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
      * COWRGV_GetSumaAsegCobertura...                               *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWRGV_GetSumaAsegCobertura...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWRGV_UpdCabeceraRV...                                      *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peNctw   (input)  Nro de Cotizacion                      *
      *     peRama   (input)  Rama                                   *
      *     peArse   (input)  Cant. de Articulos                     *
      *     pePoco   (input)  Componente                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRGV_UpdCabeceraRV...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWRGV_GetBoniCobertura...                                   *
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
     D COWRGV_GetBoniCobertura...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peBoni                            likeds(Bonific) dim(200)
     D   peBoniC                     10i 0
      * ------------------------------------------------------------ *
      * COWRGV_GetPrima(): Obtener Prima Total                       *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWRGV_GetPrima...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWRGV_getPremio(): Obtener Premio                           *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWRGV_getPremio...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWRGV_getSumaSiniestrablePoco: Suma Siniestrable            *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *     pePoco (input)  Número de Bien asegurado                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRGV_getSumaSiniestrablePoco...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const
      * ------------------------------------------------------------ *
      * COWRGV_GetRequiereInspeccion(): Devuelve si requiere Inspec- *
      *                                 cion.                        *
      *     peRama (input)  Rama                                     *
      *     peCobe (input)  Coberturas                               *
      *                                                              *
      * Retorna S/ N                                                 *
      * ------------------------------------------------------------ *
     D COWRGV_GetRequiereInspeccion...
     D                 pr             1
     D   peRama                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)const
      * ------------------------------------------------------------ *
      * COWRGV_setCondCarac() Valida valor de Caracteristicas que    *
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
     D COWRGV_setCondCarac...
     D                 pr              n
     D  peCopo                        5  0 const
     D  peCops                        1  0 const
     D  peAnio                        2  0 const
     D  peCara                        3  0 const
     D  peMa01                        1
     D  peMa02                        1
      * ------------------------------------------------------------ *
      * COWRGV_caracIsValid() Verifica que las Caracteristicas sean  *
      *                       validas.                               *
      *                                                              *
      * DEPRECATED: Usar COWRGV_caracIsValid2()                      *
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
     D COWRGV_caracIsValid...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWRGV_caracIsValid2()Verifica que las Caracteristicas sean  *
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
     D COWRGV_caracIsValid2...
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
      * COWRGV_cobCombinado() Valida que tenga al menos tres cobertu *
      *                       ras y que al menos una sea de incendio *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peCobe   (input)   Coberturas  (Primas)                  *
      *     peMsgs   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWRGV_cobCombinado...
     D                 pr              n
     D   peRama                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20) const
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWRGV_validaCarac() : Valida caracteristicas ingresadas     *
      *                                                              *
      *     peBase   (input)   Rama                                  *
      *     peRama   (input)   Coberturas  (Primas)                  *
      *     peCara   (output)  Mensaje de Error                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D COWRGV_validaCarac...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peCara                            likeds(Caracbien) dim(50) const
      * ------------------------------------------------------------ *
      * COWRGV_planesCerrados(): Calcula Planes Cerrados             *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *     pePoco (input)  Número de Bien asegurado                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWRGV_planesCerrados...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const
      * ------------------------------------------------------------ *
      * COWRGV_ValSelCaracPlan(): Valida Caracteristicas de un Plan  *
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
     D COWRGV_ValSelCaracPlan...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXpro                       3  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWRGV_ValCaracPlan(): Busca Caracteristica dentro de la     *
      *                           lista seleccionada                 *
      *                                                              *
      *     peCarac(input)  Cod. Caracteristica                      *
      *     pePcara(input)  Caracteristicas Seleccionadas            *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWRGV_ValCaracPlan...
     D                 pr              n
     D   peCara                       3  0 const
     D   peVcar                       3  0 dim(50) const
      * ------------------------------------------------------------ *
      * COWRGV_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWRGV_inz      pr
      * ------------------------------------------------------------ *
      * COWRGV_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWRGV_end      pr
      * ------------------------------------------------------------ *
      * COWRGV_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D COWRGV_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * COWRGV_calculaCaracteristicas(): Este procedimiento calcula  *
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
     D COWRGV_calculaCaracteristicas...
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
      * COWRGV_setRequiereInspeccion(): Graba si cobertura requiere        *
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
     D COWRGV_setRequiereInspeccion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peXpro                       3  0 const
     D   peCobe                            likeds(Cobprima) dim(20)const
     D   peCopo                       5  0 options(*nopass:*omit)  const
     D   peCops                       1  0 options(*nopass:*omit)  const

      * ------------------------------------------------------------------ *
      * COWRGV_getInspeccion(): Retoma Marca de Inspeccion de Cabecera     *
      *                                                                    *
      *     peBase ( input )  Parametros Base                              *
      *     peNctw ( input )  Nro. de Cotización                           *
      *     peRama ( input )  Rama                                         *
      *     peArse ( input )  Cantidad de Polizas por Rama                 *
      *     pePoco ( input )  Nro de Componente                            *
      *                                                                    *
      * Retorna S = Si / N = No                                            *
      * ------------------------------------------------------------------ *
     D COWRGV_getInspeccion...
     D                 pr             1
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------------ *
      * COWRGV_chkRenovacion(): Valida campos antes de realizar renovación *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peArcd ( input  )  Código de Articulo                          *
      *     peSpol ( input  )  Número de SuperPoliza                       *
      *     peErro ( output )  Indicador                                   *
      *     peMsgs ( output )  Estructura de Error                         *
      *                                                                    *
      * ------------------------------------------------------------------ *
     D COWRGV_chkRenovacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------------ *
      * COWRGV_getInfo(): Retorna datos para renovar                       *
      *                                                                    *
      *  >>>>> DEPRECATED <<<<< Usar getInfo2                              *
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
     D COWRGV_getInfo...
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
      * COWRGV_cotizarWeb2:Cotiza un Bien Asegurado de una Rama      *
      *                                                              *
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
     D COWRGV_cotizarWeb2...
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

      * ------------------------------------------------------------ *
      * COWRGV_chkComponente: Validar existencia de Componente       *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        pePoco (input)  Nro. de Componente                    *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * Retorna *on = Existe / *off = No existe                      *
      * ------------------------------------------------------------ *
     D COWRGV_chkComponente...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWRGV_GetReqInspeccionConsorcio(): Devuelve si requiere     *
      *                                     Inspección consorcio     *
      *     peCopo (input)  Código Postal                            *
      *     peCops (input)  Sufijo Código Postal                     *
      *                                                              *
      * Retorna S/ N                                                 *
      * ------------------------------------------------------------ *
     D COWRGV_GetReqInspeccionConsorcio...
     D                 pr             1
     D   peCopo                       5  0 const
     D   peCops                       1  0 const

      * ------------------------------------------------------------ *
      * COWRGV_updDatosReaseguro(): Actualiza datos de reaseguro de  *
      *                             un componente.                   *
      *                                                              *
      *     peBase (input)  Parámetro Base                           *
      *     peNctw (input)  Numero de Cotizacion                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Secuencia de Rama dentro del articulo    *
      *     pePoco (input)  Numero de componente                     *
      *     peCtar (input)  Capitulo de Tarifa                       *
      *     peCta1 (input)  Capitulo de Tarifa Inciso 1              *
      *     peCta2 (input)  Capitulo de Tarifa Inciso 2              *
      *     peClfr (input)  Clasificacion del riesgo (opc)           *
      *     peCagr (input)  Agravamiento (opc)                       *
      *                                                              *
      * Retorna *on si actualizó y *off si no.                       *
      * ------------------------------------------------------------ *
     D COWRGV_updDatosReaseguro...
     D                 pr              n
     D peBase                              likeds(paramBase) const
     D peNctw                         7  0 const
     D peRama                         2  0 const
     D peArse                         2  0 const
     D pePoco                         4  0 const
     D peCtar                         4  0 const
     D peCta1                         2a   const
     D peCta2                         2a   const
     D peClfr                         4a   const options(*nopass:*omit)
     D peCagr                         2  0 const options(*nopass:*omit)

      * ------------------------------------------------------------------ *
      * COWRGV_getInfo2(): Retorna datos para renovar                      *
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
     D COWRGV_getInfo2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNctw                       7  0 const
     D   peRama                       2  0
     D   peArse                       2  0
     D   peCfpg                       3  0
     D   peClie                            likeds(ClienteCot_t)
     D   pePoco                            likeds(UbicPoc2_t) dim(10)
     D   peXrea                       5  2

      * ------------------------------------------------------------------ *
      * COWRGV_setRequiereInspeccion2(): Determina si un bien de RGV requie*
      *                                  re inspeccion.                    *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peNctw ( input  )  Número de Cotización                        *
      *     peRama ( input  )  Rama                                        *
      *     peArse ( input  )  Secuencia de Rama dentro del articulo       *
      *     pePoco ( input  )  Componente de Riesgos Varios                *
      *                                                                    *
      * Retorna *on si requiere y *off si no requiere.                     *
      * ------------------------------------------------------------------ *
     D COWRGV_setRequiereInspeccion2...
     D                 pr             1n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                            likeds(UbicPoc2_t) const

      * ------------------------------------------------------------------ *
      * COWRGV_getRequiereInspeccion2(): Determina si un bien de RGV requie*
      *                                  re inspeccion.                    *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peNctw ( input  )  Número de Cotización                        *
      *     peRama ( input  )  Rama                                        *
      *     peArse ( input  )  Secuencia de Rama dentro del articulo       *
      *     pePoco ( input  )  Componente de Riesgos Varios                *
      *                                                                    *
      * Retorna *on si requiere y *off si no requiere.                     *
      * ------------------------------------------------------------------ *
     D COWRGV_getRequiereInspeccion2...
     D                 pr             1n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                            likeds(UbicPoc2_t) const

      * ------------------------------------------------------------ *
      * COWRGV_getInspComercioXTarifa(): Retorna si la rama comercio *
      *                                  por tarifa requiere insp.   *
      *                                                              *
      *     peRama (input)  Rama                                     *
      *     pePoco (input)  Componente de Riesgos Varios             *
      *                                                              *
      * Retorna *on = Requiere / *off = no requiere                  *
      * ------------------------------------------------------------ *
     D COWRGV_getInspComercioXTarifa...
     D                 pr              n
     D   peRama                       2  0 const
     D   pePoco                            likeds(UbicPoc2_t) const

      * ------------------------------------------------------------ *
      * COWRGV_getComponentes() Retorna componentes de una cotización*
      *                                                              *
      *     peBase  (input)  Base                                    *
      *     peNctw  (input)  Número de Cotización                    *
      *     peRama  (input)  Rama                                    *
      *     pePoco  (output) Componente de Riesgos Varios            *
      *     PePocoC (output) Cantidad de Componentes                 *
      *                                                              *
      * Retorna *on = Requiere / *off = No requiere                  *
      * ------------------------------------------------------------ *
     D COWRGV_getComponentes...
     D                 pr              n
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0

      * ------------------------------------------------------------ *
      * COWRGV_ubicacionDelRiesgo(): Retorna Ubicación del Riesgo    *
      *                                                              *
      *     peBase  (input)  Base                                    *
      *     peNctw  (input)  Número de Cotización                    *
      *     peRama  (input)  Rama                                    *
      *     pePoco  (input)  Componente de Riesgos Varios            *
      *                                                              *
      * Retorna R0RDES                                               *
      * ------------------------------------------------------------ *
     D COWRGV_ubicacionDelRiesgo...
     D                 pr            30
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  pePoco                        4  0 const
     D  peArse                        2  0 const

