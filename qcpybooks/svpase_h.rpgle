      /if defined(SVPASE_H)
      /eof
      /endif
      /define SVPASE_H

      * Asegurado Inexistente...
     D SVPASE_ASEIN    c                   const(0001)

      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/spvtcr_h.rpgle'

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPASE_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * --------------------------------------------------- *
      * Datos del asegurado
      * --------------------------------------------------- *
     D DsAsegurado_t   ds                  qualified template
     d   asasen                       7P 0
     d   asempr                       1
     d   assucu                       2
     d   asasrp                       5P 0
     d   ascpro                       5P 0
     d   ascorg                       5P 0
     d   ascpr1                       5P 0
     d   ascpr2                       5P 0
     d   asivrs                       1
     d   asciva                       2P 0
     d   ascaps                      15P 2
     d   ascapc                      15P 2
     d   asaccs                      15P 2
     d   asacci                      15P 2
     d   assocn                       7P 0
     d   asbloq                       1
     d   asnivt                       1P 0
     d   asnivc                       5P 0
     d   ascbrn                       7P 0
     d   asczco                       7P 0
     d   asainn                       4P 0
     d   asminn                       2P 0
     d   asdinn                       2P 0
     d   asaegn                       4P 0
     d   asmegn                       2P 0
     d   asdegn                       2P 0
     d   asrpro                       2P 0
     d   asczge                       4P 0
     d   asuser                      10
     d   astime                       6P 0
     d   asdate                       6P 0
     d   asruta                      16P 0
     d   asnaci                      25
     d   asfein                       8P 0
     d   asnrin                      13P 0
     d   asfeco                       8P 0
     d   asntel                      20

      * --------------------------------------------------- *
      * Datos del asegurado SEHASE01
      * --------------------------------------------------- *
     D DsSehase01_t    ds                  qualified template
     D  asasen                        7  0
     D  dfnomb                       40a
     D  dfdomi                       35a
     D  dfcopo                        5  0
     D  dfcops                        1  0
     D  loteld                        5a
     D  dfteln                        7  0
     D  dftido                        2  0
     D  dfnrdo                        8  0
     D  dfcuit                       11a
     D  asempr                        1a
     D  assucu                        2a
     D  asasrp                        5  0
     D  ascpro                        5  0
     D  ascorg                        5  0
     D  ascpr1                        5  0
     D  ascpr2                        5  0
     D  asivrs                        1a
     D  asciva                        2  0
     D  ascaps                       15  2
     D  ascapc                       15  2
     D  asaccs                       15  2
     D  asacci                       15  2
     D  assocn                        7  0
     D  dfnrdf                        7  0
     D  asbloq                        1a
     D  asnivt                        1  0
     D  asnivc                        5  0
     D  ascbrn                        7  0
     D  asczco                        7  0
     D  asainn                        4  0
     D  asminn                        2  0
     D  asdinn                        2  0
     D  asaegn                        4  0
     D  asmegn                        2  0
     D  asdegn                        2  0
     D  asrpro                        2  0
     D  asczge                        4  0
     D  asuser                       10a
     D  astime                        6  0
     D  asdate                        6  0
     D  asruta                       16  0
     D  asnaci                       25a
     D  asfein                        8  0
     D  asnrin                       13  0
     D  asfeco                        8  0
     D  asntel                       20a

      * ------------------------------------------------------------ *
      * SVPASE_chkAse(): Valida si existe asegurado                  *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPASE_chkAse...
     D                 pr              n
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SVPASE_getIva(): Retorna Codigo de IVA de Asegurado          *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Codigo de Iva                                       *
      * ------------------------------------------------------------ *

     D SVPASE_getIva...
     D                 pr             2  0
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SVPASE_getTipoSociedad(): Retorna Tipo de Sociedad Asegurado *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Tipo de Sociedad                                    *
      * ------------------------------------------------------------ *

     D SVPASE_getTipoSociedad...
     D                 pr             2  0
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SVPASE_getCodBloqueo(): Retorna Cod de Bloqueo Asegurado     *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Codigo de Bloqueo                                   *
      * ------------------------------------------------------------ *

     D SVPASE_getCodBloqueo...
     D                 pr             1
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SVPASE_getCuit(): Retorna CUIT de Asegurado                  *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: CUIT                                                *
      * ------------------------------------------------------------ *

     D SVPASE_getCuit...
     D                 pr            11
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SVPASE_getTipoDoc(): Retorna Tipo de Documento               *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Tipo de Documento                                   *
      * ------------------------------------------------------------ *

     D SVPASE_getTipoDoc...
     D                 pr             2  0
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SVPASE_getNroDoc(): Retorna Nro de Documento                 *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Nro de Documento                                    *
      * ------------------------------------------------------------ *

     D SVPASE_getNroDoc...
     D                 pr             8  0
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SVPASE_getFecNac(): Retorna Fecha de Nacimiento              *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Fecha de Nacimiento (AAAAMMDD)                      *
      * ------------------------------------------------------------ *

     D SVPASE_getFecNac...
     D                 pr             8  0
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SVPASE_getNombre(): Retorna Nombre de Asegurado              *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Nombre                                              *
      * ------------------------------------------------------------ *

     D SVPASE_getNombre...
     D                 pr            40
     D   peAsen                       7  0 const

      * ------------------------------------------------------------ *
      * SVPASE_getBloqueoActual: Retorna Codigo y Motivo de Bloqueo  *
      *                                   Actual                     *
      *     peAsen   (input)   Asegurado                             *
      *     peBloq   (output)  Código de Bloqueo Actual              *
      *     peMota   (output)  Motivo de Bloqueo Actual              *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     D SVPASE_getBloqueoActual...
     D                 pr              n
     D   peAsen                       7  0 const
     D   peBloq                       1
     D   peMota                      50

      * ------------------------------------------------------------ *
      * SVPASE_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPASE_inz      pr

      * ------------------------------------------------------------ *
      * SVPASE_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPASE_end      pr

      * ------------------------------------------------------------ *
      * SVPASE_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPASE_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SVPASE_getAsegurado: Obtiene la informacion del Asegurado    *
      *                      desde Nro Persona.-                     *
      *                                                              *
      *     peNrdf   (input)   Nro de persona                        *
      *     peDsAseg (output)  Estructura Asegurado                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPASE_getAsegurado...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peDsAseg                          likeds( DsAsegurado_t )
      * ------------------------------------------------------------ *
      * SVPASE_getProductorAsegurado: Obtiene la informacion del     *
      *          Productor asignado al asegurado desde Nro Persona.- *
      *                                                              *
      *     peNrdf   (input)   Nro de persona                        *
      *     peNivt   (output)  Tipo Nivel Intermediario              *
      *     peNivc   (output)  Codigo Nivel Intermediario            *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPASE_getProductorAsegurado...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNivt                       1  0
     D   peNivc                       5  0

      * ------------------------------------------------------------ *
      * SVPASE_isAseguradoHdi: Verificar si documento es o no de un  *
      *        asegurado de HDI. Opcionalmente retorna código de     *
      *        asegurado y/o el código de intermediario relacionado  *
      *                                                              *
      *     peTdoc   (input)   Tipo documento                        *
      *     peNdoc   (input)   Número documento                      *
      *     peNrdf   (output)  Nro de persona                        *
      *     peNivt   (output)  Tipo Nivel Intermediario              *
      *     peNivc   (output)  Codigo Nivel Intermediario            *
      *                                                              *
      * Retorna: *on = Si asegurado HDI / *off = Si no lo es         *
      * ------------------------------------------------------------ *
     D SVPASE_isAseguradoHdi...
     D                 pr              n
     D   peTdoc                       2  0 const
     D   peNdoc                      11  0 const
     D   peNrdf                       7  0 options(*nopass:*omit)
     D   peNivt                       1  0 options(*nopass:*omit)
     D   peNivc                       5  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPASE_getSehase01: Obtiene la informacion del Asegurado     *
      *                     desde Nro Persona.-                      *
      *                                                              *
      *     peNrdf   (input)   Nro de persona                        *
      *     peDsAs   (output)  Estructura Asegurado                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPASE_getSehase01...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peDsAs                            likeds( DsSehase01_t )

      * ------------------------------------------------------------ *
      * SVPASE_infoAsegurado(): Obtiene la informacion del Asegurado *
      *                         desde Nro Persona.-                  *
      *                                                              *
      *     peNrdf   (input)   Nro de persona                        *
      *     peClie   (output)  Estructura de Cliente                 *
      *     peDomi   (output)  Estructura (Domi, Copo, Cops)         *
      *     peDocu   (output)  Estructura (Tido,Nrdo,Cuit,Cuil)      *
      *     peNtel   (output)  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb) *
      *     peNaci   (output)  Estructura (Fnac,Lnac,Pain,Naci)      *
      *     peMail   (output)  Estructura (Ctce,Mail)                *
      *     peTarc   (output)  Estructura (Ctcu,Nrtc,Ffta,Fftm)      *
      *     peInsc   (output)  Estructura (Fein,Nrin,Feco)           *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPASE_infoAsegurado...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peTiso                       2  0
     D   peCprf                       3  0
     D   peSexo                       1  0
     D   peEsci                       1  0
     D   peRaae                       3  0
     D   peAgpe                       1a
     D   peNcbu                      22  0
     D   peCbus                      22  0
     D   peRuta                      16  0
     D   peClie                            likeds(ClienteCot_t)
     D   peDomi                            likeds(prwaseDomi_t)
     D   peDocu                            likeds(prwaseDocu_t)
     D   peNtel                            likeds(prwaseTele_t)
     D   peNaci                            likeds(prwaseNaco_t)
     D   peMail                            likeds(prwaseEmail_t)
     D   peTarc                            likeds(prwaseTarc_t)
     D   peInsc                            likeds(prwaseInsc_t)

      * ------------------------------------------------------------ *
      * SVPASE_isAseguradoBco: Verificar si el asegurado es de un    *
      *                        banco o directo.                      *
      *                                                              *
      *     peEmpr   (input)   Tipo documento                        *
      *     peSucu   (input)   Número documento                      *
      *     peNivt   (input)   Tipo Nivel Intermediario              *
      *     peNivc   (input)   Codigo Nivel Intermediario            *
      *                                                              *
      * Retorna: *on = Si asegurado Bco / *off = Si no lo es         *
      * ------------------------------------------------------------ *
     D SVPASE_isAseguradoBco...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

