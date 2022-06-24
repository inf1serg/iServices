      /if defined(PRWSND_H)
      /eof
      /endif
      /define PRWSND_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/qusec_h.rpgle'
      /copy './qcpybooks/dtaq_h.rpgle'
      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/svpweb_h.rpgle'
      /copy './qcpybooks/spvfec_h.rpgle'

      * ------------------------------------------------------------ *
      * PRWSND_sndPropuesta(): Envía (o recibe) propuesta web.       *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peFdes  (input)  Fecha Inicio de vigencia               *
      *      peFhas  (input)  Fecha Fin    de vigencia (AP)          *
      *      peErro  (output) Indicador de Error                     *
      *      peMsgs  (output) Estructura de mensajes de error        *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWSND_sndPropuesta...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PRWSND_calculaHasta(): Calcula fecha de vencimiento.         *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peFdes  (input)  Fecha de Inicio de Vigencia            *
      *      peFhas  (output) Fecha de Fin    de Vigencia            *
      *      peFhfa  (output) Fecha Hasta Facturado                  *
      *      peModi  (output) Permite modificar Hasta S/N            *
      *      peErro  (output) Indicador de Error                     *
      *      peMsgs  (output) Estructura de mensajes de error        *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWSND_calculaHasta...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peFhfa                       8  0
     D   peModi                       1a
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PRWSND_sndDtaQ(): Enviar propuesta a DTAQ.                   *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWSND_sndDtaQ  pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * PRWSND_getNroSolicitud(): Recupera número de propuesta para  *
      *                           cotización.                        *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peSoln  (output) Número de Solicitud                    *
      *      peErro  (output) Indicador de Error                     *
      *      peMsgs  (output) Estructura de mensajes de error        *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWSND_getNroSolicitud...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * PRWSND_inz(): Inicializa Módulo                              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWSND_inz      pr

      * ------------------------------------------------------------ *
      * PRWSND_end(): Finaliza  Módulo                               *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWSND_end      pr

      * ------------------------------------------------------------ *
      * PRWSND_error(): Retorna último error del módulo.             *
      *                                                              *
      *      peErrn  (input)  Número de error (opcional)             *
      *                                                              *
      * Retorna: mensaje de error                                    *
      * ------------------------------------------------------------ *
     D PRWSND_error    pr            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * PRWSND_sndMail(): Envia Mail.                                *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peSoln  (input)  Número de Solicitud                    *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWSND_sndMail  pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSoln                       7  0 const

      * ------------------------------------------------------------ *
      * PRWSND_sndPropuesta2(): Envía (o recibe) propuesta web, sin  *
      *                         ejecutar _sndDtaQ() y _sndMail() ya  *
      *                         que es una propuesta hija            *
      *                                                              *
      *      peBase  (input)  Parámetro Base                         *
      *      peNctw  (input)  Número de Cotización                   *
      *      peFdes  (input)  Fecha de Inicio de Vigencia            *
      *      peFhas  (input)  Fecha de Fin    de Vigencia (AP)       *
      *      peErro  (output) Indicador de Error                     *
      *      peMsgs  (output) Estructura de mensajes de error        *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     D PRWSND_sndPropuesta2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

