      /if defined(SVPMAIL_H)
      /eof
      /endif
      /define SVPMAIL_H

      * ---------------------------------------------------- *
      * Estructura de tabla de direcciones de mail
      * ---------------------------------------------------- *
     D MailAddr_t      ds                  qualified
     D                                     based(template)
     D   mail                        50a
     D   nomb                        40a
     D   tipo                         2  0

      * DAF inexistente...
     D SVPMAIL_DAFNF   c                   const(0001)
      * Intermediario inexistente...
     D SVPMAIL_INTNF   c                   const(0002)
      * Proveedor inexistente...
     D SVPMAIL_PRONF   c                   const(0003)

      * ------------------------------------------------------------ *
      * SVPMAIL_xNrDaf(): Busca Direcciones de Mail x NRDF.          *
      *                                                              *
      *     peNrdf   (input)   Nro de Dato Filiatorio                *
      *     peCtce   (input)   Tipo de Mail (opcional)               *
      *                        Si no llega, se cargan todos los mails*
      *     peMadd   (output)  DS con los mails (ver MailAddr_t en   *
      *                        el header)                            *
      *                                                              *
      * Retorna: 0 cuando no hay mails                               *
      *         -1 si hay error                                      *
      *         >0 Cantidad de direcciones cargadas                  *
      * ------------------------------------------------------------ *
     D SVPMAIL_xNrDaf...
     D                 pr            10i 0
     D   peNrdf                       7  0 const
     D   peMadd                            likeds(Mailaddr_t) dim(100)
     D   peCtce                       2  0 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPMAIL_xNivc(): Busca Direcciones de Mail x Nivt/Nivc.      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   nivel en la cadena                    *
      *     peNivc   (input)   Nro. del Productor/organiz./etc.      *
      *     peMadd   (output)  DS con los mails (ver MailAddr_t en   *
      *                        el header)                            *
      *     peCtce   (input)   Tipo de Mail (opcional)               *
      *                        Si no llega, se cargan todos los mails*
      *                                                              *
      * Retorna: 0 cuando no hay mails                               *
      *         -1 si hay error                                      *
      *         >0 Cantidad de direcciones cargadas                  *
      * ------------------------------------------------------------ *
     D SVPMAIL_xNivc...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peMadd                            likeds(MailAddr_t) dim(100)
     D   peCtce                       2  0 const options(*nopass:*omit)
      *                                                              *

      * ------------------------------------------------------------ *
      * SVPMAIL_xProv(): Busca Direcciones de Mail x Proveedor.      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peComa   (input)   Código de Mayor auxiliar              *
      *     peNrma   (input)   Número de Mayor Auxiliar              *
      *     peMadd   (output)  DS con los mails (ver MailAddr_t en   *
      *                        el header)                            *
      *     peCtce   (input)   Tipo de Mail (opcional)               *
      *                        Si no llega, se cargan todos los mails*
      *                                                              *
      * Retorna: 0 cuando no hay mails                               *
      *         -1 si hay error                                      *
      *         >0 Cantidad de direcciones cargadas                  *
      * ------------------------------------------------------------ *
     D SVPMAIL_xProv...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2a   const
     D   peNrma                       7  0 const
     D   peMadd                            likeds(MailAddr_t) dim(100)
     D   peCtce                       2  0 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPMAIL_Inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPMAIL_Inz     pr

      * ------------------------------------------------------------ *
      * SVPMAIL_End(): Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPMAIL_End     pr

      * ------------------------------------------------------------ *
      * SVPMAIL_Error():Retorna el último error del service program *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPMAIL_Error   pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

