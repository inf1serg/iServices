      /if defined(SVPREST_H)
      /eof
      /endif
      /define SVPREST_H

      /copy './qcpybooks/svpws_h.rpgle'

      * ------------------------------------------------------------ *
      * SVPREST_chkBase(): Valida parámetro base                     *
      *                                                              *
      *    peEmpr (input) Empresa tal como se recupera de la URL     *
      *    peSucu (input) Sucursal tal como se recupera de la URL    *
      *    peNivt (input) Tipo de intermediario de la URL            *
      *    peNivc (input) Cód. de intermediario de la URL            *
      *    peNit1 (input) Tipo de intermediario de la URL            *
      *    peNiv1 (input) Cód. de intermediario de la URL            *
      *    peMsgs (output) Mensaje de error                          *
      *                                                              *
      * Retorna: *on si OK, *off si no                               *
      * ------------------------------------------------------------ *
     D SVPREST_chkBase...
     D                 pr             1n
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1a   const
     D  peNivc                        5a   const
     D  peNit1                        1a   const
     D  peNiv1                        5a   const
     D  peMsgs                             likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * SVPREST_inz(): Inicializar módulo                            *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPREST_inz     pr

      * ------------------------------------------------------------ *
      * SVPREST_end(): Finalizar  módulo                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPREST_end     pr

      * ------------------------------------------------------------ *
      * SVPREST_error(): Retorna último error del módulo.            *
      *                                                              *
      *       peErrn (input) - Número de Error                       *
      *                                                              *
      * Retorna: Mensaje con el último error                         *
      * ------------------------------------------------------------ *
     D SVPREST_error   pr            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPREST_editFecha(): Retorna fecha ISO                       *
      *                                                              *
      *    peFech (input) Fecha AAAAMMDD                             *
      *                                                              *
      * Retorna: AAAA-MM-DD si Ok, 0001-01-01 si fecha invalida      *
      * ------------------------------------------------------------ *
     D SVPREST_editFecha...
     D                 pr            10
     D  peFech                        8  0 Const

      * ------------------------------------------------------------ *
      * SVPREST_editImporte(): Retorna importe en string de 30       *
      *                                                              *
      *    peImpo (input) Importe                                    *
      *                                                              *
      * Retorna: (S)EEEEEEEEEEEEEEEEEEEEEEEEEEE.DD (edicion Z)       *
      * ------------------------------------------------------------ *
     D SVPREST_editImporte...
     D                 pr            30
     D  peImpo                       15  2 Const

      * ------------------------------------------------------------ *
      * SVPREST_chkCliente(): Valida que un documento sea cliente    *
      *                                                              *
      *    peEmpr (input) Empresa tal como se recupera de la URL     *
      *    peSucu (input) Sucursal tal como se recupera de la URL    *
      *    peTdoc (input) Tipo de documento de la URL                *
      *    peNdoc (input) Número de documento de la URL              *
      *    peMsgs (output) Mensaje de error                          *
      *    peNrdf (output) -opc- Código de Daf encontrado.           *
      *                                                              *
      * Retorna: *on si OK, *off si no                               *
      * ------------------------------------------------------------ *
     D SVPREST_chkCliente...
     D                 pr             1n
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peTdoc                        2a   const
     D  peNdoc                       11a   const
     D  peMsgs                             likeds(paramMsgs)
     D  peNrdf                        7  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPREST_chkPolizaCliente(): Valida relación Póliza/Documento *
      *                                                              *
      *    peEmpr (input) Empresa tal como se recupera de la URL     *
      *    peSucu (input) Sucursal tal como se recupera de la URL    *
      *    peArcd (input) Artículo                                   *
      *    peSpol (input) Superpóliza                                *
      *    peRama (input) Rama                                       *
      *    pePoli (input) Póliza                                     *
      *    peTdoc (input) Tipo de documento de la URL                *
      *    peNdoc (input) Número de documento de la URL              *
      *    peMsgs (output) Mensaje de error                          *
      *                                                              *
      * Retorna: *on si OK, *off si no                               *
      * ------------------------------------------------------------ *
     D SVPREST_chkPolizaCliente...
     D                 pr             1n
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6a   const
     D  peSpol                        9a   const
     D  peRama                        2a   const
     D  pePoli                        7a   const
     D  peTdoc                        2a   const
     D  peNdoc                       11a   const
     D  peMsgs                             likeds(paramMsgs)

