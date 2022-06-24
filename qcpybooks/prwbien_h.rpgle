      /if defined(PRWBIEN_H)
      /eof
      /endif
      /define PRWBIEN_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'
      /copy './qcpybooks/regex_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowsep_h.rpgle'

      * ------------------------------------------------------------ *
      * Estructura Datos de Inspeccion
      * ------------------------------------------------------------ *
     D prwbienInsp_t   ds                  qualified template
     D  tipo                         40a
     D  nomb                         40a
     D  domi                         35a
     D  ntel                         20a
     D  nte1                         20a
     D  mail                         50a
     D  hdes                          6  0
     D  hhas                          6  0
     D  nrin                         25a
     D  ctro                         50a
     D  come                        512a

      * ------------------------------------------------------------ *
      * Estructura Datos de Inspeccion
      * ------------------------------------------------------------ *
     D prwbienInsp_t2  ds                  qualified template
     D  tipo                         40a
     D  nomb                         40a
     D  domi                         35a
     D  ntel                         20a
     D  nte1                         20a
     D  mail                         50a
     D  hdes                          6  0
     D  hhas                          6  0
     D  nrin                         25a
     D  ctro                         50a
     D  come                        512a
     D  fins                          8  0

      * ------------------------------------------------------------ *
      * Estructura Datos de Rastreadores
      * ------------------------------------------------------------ *
     D prwbienRast_t   ds                  qualified template
     D  have                          1a
     D  rast                          3  0
     D  dras                         40a
     D  nomb                         40a
     D  domi                         35a
     D  ntel                         20a
     D  nte1                         20a
     D  mail                         50a
     D  hdes                          6  0
     D  hhas                          6  0

      * ------------------------------------------------------------ *
      * Estructura Datos Nomina Sepelio
      * ------------------------------------------------------------ *
     D prwbienSepe_t   ds                  qualified template
     D  poco                          6  0
     D  paco                          3  0
     D  nomb                         20a
     D  apel                         20a
     D  fnac                          8  0
     D  tido                          2  0
     D  nrdo                          8  0
     D  cnac                          3  0
     D  cuit                         11  0

      * -----------------------------------------------------------------*
      * PRWBIEN_setVehiculo(): Graba datos de Vehivulo                   *
      *                                                                  *
      *  ****** DEPRECATED ****** Usar PRWBIEN_setVehiculo2()            *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         pePate (input)   Patente                                 *
      *         peChas (input)   Chasis                                  *
      *         peMoto (input)   Motor                                   *
      *         peAver (input)   Averías (S/N)                           *
      *         peNmer (input)   Nombre Tarjeta Circulación              *
      *         peAcrc (input)   Código de Acreedor Prendario            *
      *         peRuta (input)   Número de R.U.T.A.                      *
      *         peCesv (input)   OK CESVI (S/N)                          *
      *         peIris (input)   OK IRIS (S/N)                           *
      *         peVhuv (input)   Uso del Vehículo                        *
      *         peInsp (input)   Datos de Inspección                     *
      *         peRast (input)   Datos de Rastreador                     *
      *         peAcce (input)   Accesorios                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_setVehiculo...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePate                      25    const
     D   peChas                      25    const
     D   peMoto                      25    const
     D   peAver                       1    const
     D   peNmer                      40    const
     D   peAcrc                       7  0 const
     D   peRuta                      16  0 const
     D   peCesv                       1    const
     D   peIris                       1    const
     D   peVhuv                       2  0 const
     D   peInsp                            likeds(prwbienInsp_t) const
     D   peRast                            likeds(prwbienRast_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_setVehiculo2(): Graba datos de Vehivulo                  *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         pePate (input)   Patente                                 *
      *         peChas (input)   Chasis                                  *
      *         peMoto (input)   Motor                                   *
      *         peAver (input)   Averías (S/N)                           *
      *         peNmer (input)   Nombre Tarjeta Circulación              *
      *         peAcrc (input)   Código de Acreedor Prendario            *
      *         peRuta (input)   Número de R.U.T.A.                      *
      *         peCesv (input)   OK CESVI (S/N)                          *
      *         peIris (input)   OK IRIS (S/N)                           *
      *         peVhuv (input)   Uso del Vehículo                        *
      *         peInsp (input)   Datos de Inspección                     *
      *         peRast (input)   Datos de Rastreador                     *
      *         peAcce (input)   Accesorios                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_setVehiculo2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePate                      25    const
     D   peChas                      25    const
     D   peMoto                      25    const
     D   peAver                       1    const
     D   peNmer                      40    const
     D   peAcrc                       7  0 const
     D   peRuta                      16  0 const
     D   peCesv                       1    const
     D   peIris                       1    const
     D   peVhuv                       2  0 const
     D   peInsp                            likeds(prwbienInsp_t2) const
     D   peRast                            likeds(prwbienRast_t ) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_clearInspección(): Elimina Datos de Inspección           *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_clearInspeccion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_clearRastreador(): Elimina datos de Rastreadores         *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_clearRastreador...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_setUbicacion(): Graba datos de Ubicacion                 *
      *                                                                  *
      *  ****** DEPRECATED ****** Usar PRWBIEN_setUbicacion2()           *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRdes (input)   Ubicación del Riesgo                    *
      *         peInsp (input)   Datos de Inspección                     *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_setUbicacion...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peInsp                            const likeds(prwbienInsp_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_setUbicacion2(): Graba datos de Ubicacion                *
      *                                                                  *
      *  ****** DEPRECATED ****** Usar PRWBIEN_setUbicacion3()           *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRdes (input)   Ubicación del Riesgo                    *
      *         peInsp (input)   Datos de Inspección                     *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_setUbicacion2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peInsp                            const likeds(prwbienInsp_t2)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_setAccesorioNoTar(): Graba Acccesorios No Tarifables     *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peSecu (input)   Secuencia                               *
      *         peAccd (input)   Descripción de Accesorio                *
      *         peAccv (input)   Valor del Accesorio                     *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_setAccesorioNoTar...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSecu                       2  0 const
     D   peAccd                      20    const
     D   peAccv                      15  2 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_dltAccesorioNoTar(): Eliminar Acccesorio No Tarifable    *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peSecu (input)   Accesorios                              *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_dltAccesorioNoTar...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_setObjetoAsegurado(): Graba Objeto Asegurad              *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peOsec (input)   Secuencia                               *
      *         peObje (input)   Descripción Objeto                      *
      *         peMarc (input)   Marca del Objeto                        *
      *         peMode (input)   Modelo del Objeto                       *
      *         peNser (input)   Número de Serie                         *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_setObjetoAsegurado...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const
     D   peObje                      74    const
     D   peSuas                      15  2 const
     D   peMarc                      45    const
     D   peMode                      45    const
     D   peNser                      45    const
     D   peDeta                     400a   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_dltObjetoAsegurado(): Borra Objeto Asegurad              *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peOsec (input)   Secuencia                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_dltObjetoAsegurado...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * PRWBIEN_insertAsegurado(): Insertar asegurado                    *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peSecu (input)   Secuencia                               *
      *         peNomb (input)   Nombre                                  *
      *         peNomb (input)   Apellido                                *
      *         peTido (input)   tipo de documento                       *
      *         peNrdo (input)   Numero de Documento                     *
      *         peFnac (input)   Fecha de Nacimiento                     *
      *         peSuas (input)   Suma Asegurada                          *
      *         peSmue (input)   Suma Asegurada Muerte                   *
      *         peSinv (input)   Suma Asegurada Invalidez                *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_insertAsegurado...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peNomb                      20    const
     D   peApel                      20    const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peSuas                      13  0 const
     D   peSmue                      13  0 const
     D   peSinv                      13  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_insertBeneficiario(): Inserta beneficiarios del asegurado*
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peSecu (input)   Secuencia                               *
      *         peNomb (input)   Nombre                                  *
      *         peApel (input)   Apellido                                *
      *         peTido (input)   Tipo de Documento                       *
      *         peNrdo (input)   Numero de Documento                     *
      *         peFnac (input)   Fecha de Nacimiento                     *
      *         peSuas (input)   Suma Asegurada                          *
      *         peSmue (input)   Suma Asegurada Muerte                   *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_insertBeneficiario...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peSebe                       2  0 const
     D   peNomb                      20    const
     D   peApel                      20    const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * PRWBIEN_dltAsegurado(): Elimina Asegurado                        *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peSecu (input)   Secuencia                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_dltAsegurado...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * PRWBIEN_dltBeneficiario (): Elimina Beneficiario                 *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Código de Cobertura                     *
      *         peSecu (input)   Secuencia                               *
      *         peSebe (input)   Secuencia                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_dltBeneficiario...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peSebe                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * PRWBIEN_insertAseguradoV(): Insertar asegurado Vida              *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         pePaco (input)   Código de Riesgo                        *
      *         peNomb (input)   Nombre                                  *
      *         peApel (input)   Apellido                                *
      *         peTido (input)   Tipo de Documento                       *
      *         peNrdo (input)   Numero de Documento                     *
      *         peFnac (input)   Fecha de Nacimiento                     *
      *         peNaci (input)   Nacionalidad                            *
      *         peActi (input)   Actividad                               *
      *         peCate (input)   Categoria                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_insertAseguradoV...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peNaci                      25    const
     D   peActi                       5  0 const
     D   peCate                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_dlttAseguradoV(): Elimina asegurado Vida                 *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         pePaco (input)   Código de Riesgo                        *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_dltAseguradoV...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_setUbicacion3(): Graba datos de Ubicacion                *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRdes (input)   Ubicación del Riesgo                    *
      *         peNrdm (input)   Número de puerta                        *
      *         peInsp (input)   Datos de Inspección                     *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_setUbicacion3...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peNrdm                       5  0 const
     D   peInsp                            const likeds(prwbienInsp_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_setMascotaAsegurada(): Graba Mascota Asegurada           *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Cobertura                               *
      *         peMsec (input)   Secuencia de Mascota                    *
      *         peCtma (input)   Tipo de Mascota (tabla SET136)          *
      *         peCraz (input)   Raza de Mascota (tabla SET137)          *
      *         peFnaa (input)   Año de Nacimiento de la mascota         *
      *         pePvac (input)   Plan de Vacunacion? S=Si/N=No           *
      *         peCria (input)   Se usa para exposicion? S=Si/N=No       *
      *         peExpo (input)   Extender cobertura a la cria? S=Si/N=No *
      *         peSuas (input)   Suma Asegurada de la Mascota            *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_setMascotaAsegurada...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const
     D   peMsec                       9  0 const
     D   peCtma                       2  0 const
     D   peCraz                       4  0 const
     D   peFnaa                       4  0 const
     D   pePvac                       1a   const
     D   peExpo                       1a   const
     D   peCria                       1a   const
     D   peSuas                      15  2 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_dltMascotaAsegurada(): Elimina Mascota Asegurada         *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         pePoco (input)   Componente                              *
      *         peRiec (input)   Código de Riesgo                        *
      *         peXcob (input)   Cobertura                               *
      *         peMsec (input)   Secuencia de Mascota                    *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWBIEN_dltMascotaAsegurada...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const
     D   peMsec                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWBIEN_copiaPoliza(): Retorna Tipo de Inspección                *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peTipo (input)   Inspección / Rastreo                    *
      *                                                                  *
      * Retorna: *on = Existe / *off = no Existe                         *
      * ---------------------------------------------------------------- *
     D PRWBIEN_copiaPoliza...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTipo                       1a   const

      * ------------------------------------------------------------ *
      * PRWBIEN_insertaAseguradoSepelio(): Insertar asegurado de nomi*
      *                                    na de Sepelio.            *
      *                                                              *
      *         peBase (input)   Paramametro Base                    *
      *         peNctw (input)   Numero de Cotizacion                *
      *         peBsep (input)   Bien de Sepeliostreo                *
      *         peBsepC(input)   Cantidad de Bienes                  *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWBIEN_insertaAseguradoSepelio...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peBsep                            likeds(prwBienSepe_t) dim(10)
     D   peBsepC                     10i 0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

