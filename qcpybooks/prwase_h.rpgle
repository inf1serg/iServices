      /if defined(PRWASE_H)
      /eof
      /endif
      /define PRWASE_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/regex_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'

     D prwaseEmail_t   ds                  qualified based(template)
     D   ctce                         2  0
     D   mail                        50

      *
      * Estructura Domicilio
      *
     D prwaseDomi_t    ds                  qualified template
     D  domi                         35a
     D  copo                          5  0
     D  cops                          5  0

      *
      * Estructura Documento
      *
     D prwaseDocu_t    ds                  qualified template
     D  tido                          2  0
     D  nrdo                          8  0
     D  cuit                         11  0
     D  cuil                         11  0

      *
      * Estructura Teléfonos y Página Web
      *
     D prwaseTele_t    ds                  qualified template
     D  nte1                         20a
     D  nte2                         20a
     D  nte3                         20a
     D  nte4                         20a
     D  pweb                         50a

      *
      * Estructura Fecha y Lugar de Nacimiento
      *
     D prwaseNaci_t    ds                  qualified template
     D  fnac                          8  0
     D  lnac                         30a
     D  pain                          5  0
     D  naci                         25a

     D prwaseNaco_t    ds                  qualified template
     D  fnac                          8  0
     D  lnac                         30a
     D  pain                          5  0
     D  cnac                          3  0

      *
      * Estructura Datos de Inscripción de Sociedades
      *
     D prwaseInsc_t    ds                  qualified template
     D  fein                          8  0
     D  nrin                         13  0
     D  feco                          8  0

      *
      * Estructura Tarjetas de Crédito
      *
     D prwaseTarc_t    ds                  qualified template
     D  ctcu                          3  0
     D  nrtc                         20  0
     D  ffta                          4  0
     D  fftm                          2  0

      *
      * Estructura Configuración Datos Asegurados.
      *
     D prwaseCase_t    ds                  qualified template
      * fisicos
     D  cmafi                         1
     D  ctefi                         1
     D  cnaci                         1
     D  csexo                         1
     D  cesci                         1
     D  ccprf                         1
     D  craae                         1
      * Juridicos
     D  cmaju                         1
     D  cteju                         1
     D  cfein                         1
     D  cnrin                         1
     D  cfeco                         1
     D  craaej                        1
     D
     D
     D
      * ---------------------------------------------------------------- *
      * PRWASE_isValid(): Valida los datos del asegurado que se está     *
      *                   cargando.                                      *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peCbus  -  CBU para pagos de siniestros           *
      *                peRuta  -  número de RUTA                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *                                                                  *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D PRWASE_isValid...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaco_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t)  const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t)  const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * PRWASE_insertAseguradoTomador():permite insertar asegurado toma- *
      *                                 dor, si ya hubiera uno, el mismo *
      *                                 es reemplazado por el enviado    *
      *                                 aquí.                            *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D PRWASE_insertAseguradoTomador...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaci_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t) const
     D   peAgpe                       1a   const
     D   peTarc                            likeds(prwaseTarc_t) const
     D   peNcbu                      22  0   const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * PRWASE_insertAseguradoTomador2():permite insertar asegurado toma-*
      *                                 dor, si ya hubiera uno, el mismo *
      *                                 es reemplazado por el enviado    *
      *                                 aquí.                            *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peNomb  -  Nombre de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D PRWASE_insertAseguradoTomador2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNomb                      40a     const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaco_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t) const
     D   peAgpe                       1a   const
     D   peTarc                            likeds(prwaseTarc_t) const
     D   peNcbu                      22  0   const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * PRWASE_deleteAseguradoTomador(): permite eliminar el asegurado   *
      *                                  tomador.                        *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D PRWASE_deleteAseguradoTomador...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const

      * ---------------------------------------------------------------- *
      * PRWASE_insertAseguradoAdicional():permite insertar asegurado adi-*
      *                                   cional.                        *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peNase  -  Número de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D PRWASE_insertAseguradoAdicional...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNase                       6  0   const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaci_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t) const
     D   peAgpe                       1a   const
     D   peTarc                            likeds(prwaseTarc_t) const
     D   peNcbu                      22  0   const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * PRWASE_insertAseguradoAdicional2():permite insertar asegurado adi*
      *                                   cional.                        *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peNase  -  Número de Asegurado                    *
      *                peNomb  -  Nombre de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D PRWASE_insertAseguradoAdicional2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNase                       6  0   const
     D   peNomb                      40a     const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaco_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t) const
     D   peAgpe                       1a   const
     D   peTarc                            likeds(prwaseTarc_t) const
     D   peNcbu                      22  0   const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * PRWASE_deleteAseguradoAdicional():permite eliminar asegurado adi-*
      *                                   cional.                        *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peNase  -  Número de Asegurado                    *
      *                                                                  *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D PRWASE_deleteAseguradoAdicional...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNase                       6  0   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * PRWASE_ConfiguracionAsegurados ():permite traer la configuración *
      *                                   de los parametros que son y que*
      *                                   no son obligatorios.           *
      *        Input :                                                   *
      *                                                                  *
      *                peFech  -  Fecha                                  *
      *                                                                  *
      *        Output:                                                   *
      *                peCase  -  Ds configuracion                       *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D PRWASE_ConfiguracionAsegurados...
     D                 pr
     D   peFech                       8  0 const
     D   peCase                            likeds(prwaseCase_t)
      * ------------------------------------------------------------ *
      * PRWASE_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D PRWASE_inz      pr

      * ------------------------------------------------------------ *
      * PRWASE_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D PRWASE_end      pr

      * ------------------------------------------------------------ *
      * PRWASE_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D PRWASE_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * -----------------------------------------------------------------*
      * PRWASE_insertBeneficiarioV():Inserta beneficiarios de poliza    *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia Persona                       *
      *         peNomb (input)   Nombre                                  *
      *         peApel (input)   Apellido                                *
      *         peCuit (input)   Cuit/Cuil                               *
      *         peCnre (input)   Marca de Clausula de no Repeticion      *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWASE_insertBeneficiarioV...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peNomb                      20    const
     D   peApel                      20    const
     D   peCuil                      11    const
     D   peCnre                       1    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * PRWASE_insertBeneficiarioV2(): Inserta beneficiarios de poliza   *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia Persona                       *
      *         peNomb (input)   Nombre                                  *
      *         peTido (input)   Tipo de Documento                       *
      *         peNrdo (input)   Nro  de Documento                       *
      *         peCuit (input)   Cuit/Cuil                               *
      *         peCnre (input)   Marca de Clausula de no Repeticion      *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWASE_insertBeneficiarioV2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peCuil                      11a   const
     D   peCnre                       1    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * PRWASE_dltBeneficiarioV():Elimina beneficiarios de poliza       *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia Persona                       *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWASE_dltBeneficiarioV...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWASE_insertClausulaV():Inserta Clausula de No Repeticion       *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia Persona                       *
      *         peNomb (input)   Nombre / Razon Social                   *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWASE_insertClausulaV...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peNomb                      20    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -----------------------------------------------------------------*
      * PRWASE_deleteClausulaV():Elimina Clausula de No Repeticion       *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     D PRWASE_deleteClausulaV...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * PRWASE_isValid2(): Valida los datos del asegurado que se está    *
      *                    cargando.                                     *
      *                                                                  *
      *         peBase ( input  ) Base                                   *
      *         peAsen ( input  ) Código de Asegurado                    *
      *         peDomi ( input  ) Estructura (Domi, Copo, Cops)          *
      *         peDocu ( input  ) Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *         peNtel ( input  ) Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *         peTiso ( input  ) Código Tipo de Persona                 *
      *         peNaci ( input  ) Estructura (Fnac,Lnac,Pain,Naci)       *
      *         peCprf ( input  ) Código de profesión                    *
      *         peSexo ( input  ) Código de Sexo                         *
      *         peEsci ( input  ) Código de Estado Civil                 *
      *         peRaae ( input  ) Código Rama Actividad Económica        *
      *         peMail ( input  ) Estructura (Ctce,Mail)                 *
      *         peCbus ( input  ) CBU para pagos de siniestros           *
      *         peRuta ( input  ) número de RUTA                         *
      *         peCiva ( input  ) Código Inscripción de IVA              *
      *         peInsc ( input  ) Estructura (Fein,Nrin,Feco)            *
      *         peErro ( output ) Indicador de Error                     *
      *         peMsgs ( output ) Estructura de Error                    *
      *         peNctw ( input  ) Número de Cotización   ( opcional )    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     D PRWASE_isValid2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0   const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaco_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t)  const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t)  const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D   peNctw                       7  0   const options(*nopass:*omit)

      * ---------------------------------------------------------------- *
      * PRWASE_getAseguradoTomador(): Retorna asegurado tomador          *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *        Output:                                                   *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D PRWASE_getAseguradoTomador...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNomb                      40
     D   peDomi                            likeds(prwaseDomi_t)
     D   peDocu                            likeds(prwaseDocu_t)
     D   peNtel                            likeds(prwaseTele_t)
     D   peTiso                       2  0
     D   peNaci                            likeds(prwaseNaco_t)
     D   peCprf                       3  0
     D   peSexo                       1  0
     D   peEsci                       1  0
     D   peRaae                       3  0
     D   peMail                            likeds(prwaseEmail_t)
     D   peAgpe                       1a
     D   peTarc                            likeds(prwaseTarc_t)
     D   peNcbu                      22  0
     D   peCbus                      22  0
     D   peRuta                      16  0
     D   peCiva                       2  0
     D   peInsc                            likeds(prwaseInsc_t)

