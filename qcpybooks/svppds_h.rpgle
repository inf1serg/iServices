      /if defined(SVPPDS_H)
      /eof
      /endif
      /define SVPPDS_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'

      * Pre-Denuncia de Siniestro Inexistente...
     D SVPPDS_PDSNE    c                   const(0001)
     D SVPPDS_BASE     c                   const(0002)
     D SVPPDS_RAMPOL   c                   const(0003)
     D SVPPDS_CAUSA    c                   const(0004)
     D SVPPDS_FOCU     c                   const(0005)
     D SVPPDS_PATE     c                   const(0006)
     D SVPPDS_FOTO     c                   const(0007)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPPDS_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SVPPDS_chkPredenuSin(): Valida si existe Pre-Denuncia de     *
      *                         Siniestro                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivc   (input)   Código de Nivel de Intermediario      *
      *     peNpds   (input)   Nro. Pre-Denuncia de Siniestro        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPPDS_chkPredenuSin...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNpds                       7  0 const

      * ------------------------------------------------------------ *
      * SVPPDS_SetPreDenWeb(): Recibe Predenuncia Web                *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     pePate   (input)   Patente                               *
      *     peFocu   (input)   Fecha Ocurrencia                      *
      *     peHocu   (input)   Hora Ocurrencia                       *
      *     peCaus   (input)   Causa                                 *
      *     pePpdf   (input)   PathPDF                               *
      *     pePdff   (input)   PathPDF                               *
      *     pePdffc  (input)                                         *
      *                                                              *
      * Retorna: 0 OK, -1 Error.                                     *
      * ------------------------------------------------------------ *
     D SVPPDS_SetPreDenWeb...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   peCaus                       4  0 const
     D   peFpdf                    1028a   const
     D   pePdff                            likeds(pds001_t) dim(10)
     D   pePdffC                     10i 0
     D   peNpds                       7  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * SVPPDS_SetPreDen(): Graba PDS000                             *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     pePate   (input)   Patente                               *
      *     peFocu   (input)   Fecha Ocurrencia                      *
      *     peHocu   (input)   Hora Ocurrencia                       *
      *     peCaus   (input)   Causa                                 *
      *     pePpdf   (input)   PathPDF                               *
      *                                                              *
      * Retorna: Nro.Pre-Denuncia / -1 Error                         *
      * ------------------------------------------------------------ *

     D SVPPDS_SetPreDen...
     D                 pr             7  0
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   peCaus                       4  0 const
     D   peFpdf                    1028    const

      * ------------------------------------------------------------ *
      * SVPPDS_SetPreDen2(): Graba PDS000                            *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNpds   (input)   Numero de Predenuncia                 *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     pePate   (input)   Patente                               *
      *     peFocu   (input)   Fecha Ocurrencia                      *
      *     peHocu   (input)   Hora Ocurrencia                       *
      *     peCaus   (input)   Causa                                 *
      *     peErro   (input)   Error                                 *
      *     peMsgs   (input)   Mensajes                              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *

     D SVPPDS_SetPreDen2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   peCaus                       4  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * SVPPDS_updPreDen(): Actualiza PDS000                         *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNpds   (input)   Nro. de Pre-Denuncia de Siniestro     *
      *     peFocu   (input)   Fecha de ocurrencia                   *
      *     peHocu   (input)   Hora de ocurrencia                    *
      *     pePate   (input)   Patente                               *
      *     peSini   (input)   Siniestro                             *
      *     peFpdf   (input)   PDF                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPPDS_updPreDen...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   pePate                      25    const
     D   peSini                       7  0 options(*nopass:*omit)
     D   peFpdf                    1028    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPPDS_setFotoPDS(): Graba PDS001                            *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNpds   (input)   Nro. Pre-Denuncia de Siniestro        *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Nro. poliza                           *
      *     pePate   (input)   Patente                               *
      *     peFocu   (input)   Fecha Ocurrencia                      *
      *     peHocu   (input)   Hora Ocurrencia                       *
      *     pePdff   (input)   PathPDF                               *
      *     pePdffc  (input)                                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPPDS_setFotoPDS...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   pePdff                            likeds(pds001_t) dim(10)
     D   pePdffC                     10i 0

      * ------------------------------------------------------------ *
      * SVPPDS_chkFotoPDS(): Valida si existe fotos de Pre-Denuncia  *
      *                      de Siniestros                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivc   (input)   Código de Intermediario               *
      *     peNpds   (input)   Nro. Pre-Denuncia de Siniestro        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPPDS_chkFotoPDS...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNpds                       7  0 const

      * ------------------------------------------------------------ *
      * SVPPDS_dltFotoPDS(): Elimina PDS001                          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNpds   (input)   Nro. de Pre-Denuncia de Siniestro     *
      *                                                              *
      * ------------------------------------------------------------ *

     D SVPPDS_dltFotoPDS...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const

      * ------------------------------------------------------------ *
      * SVPPDS_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPPDS_inz      pr

      * ------------------------------------------------------------ *
      * SVPPDS_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPPDS_end      pr

      * ------------------------------------------------------------ *
      * SVPPDS_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPPDS_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPPDS_getNroPreDenuncia(): Obtener número de predenuncia    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *                                                              *
      * Retorna: Nro.Pre-Denuncia / -1 Error                         *
      * ------------------------------------------------------------ *
     D SVPPDS_getNroPreDenuncia...
     D                 pr             7  0
     D  peEmpr                        1a   const
     D  peSucu                        2a   const

      * ------------------------------------------------------------ *
      * SVPPDS_ChkPreDenuncia(): Valida existencia de Predenuncia    *
      *                                                              *
      *     peBase ( input  )   Parametros Base                      *
      *     peNpds ( input  )   Número de Predenuncia                *
      *     peNivt ( input  )   Tipo de Intermediario  ( opcional )  *
      *     peNivc ( input  )   Nivel de Intermediario ( opcional )  *
      *                                                              *
      * Retorna:  *on = Existe / *off = No Existe                    *
      * ------------------------------------------------------------ *
     D SVPPDS_ChkPreDenuncia...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNpds                       7  0 const
     D   peNivt                       1  0 options(*nopass:*omit)
     D   peNivc                       5  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPPDS_setTipoDeVoucher: Graba Tipo de Voucher en P0MAR1     *
      *                                                              *
      *     peBase ( input  )   Parametros Base                      *
      *     peNpds ( input  )   Número de Predenuncia                *
      *     peMar1 ( input  )   Tipo de Voucher                      *
      *     peErro ( output )   Error                                *
      *     peMsgs ( output )   Mensajes
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPPDS_setTipoDeVoucher...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peMar1                       1    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

