      /if defined(REST_H)
      /eof
      /endif

      /define REST_H

      /define rdstin_ptr
      /copy './qcpybooks/cgi_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D REST_maxLen     c                   const(16766704)

      * ************************************************************ *
      * REST_getEnvVar(): Recupera una variable de entorno.          *
      *                                                              *
      *       peEvar (input) - Variable de entorno.                  *
      *                                                              *
      * Retorna: *on si ok, *off si hubo algún error.                *
      * ************************************************************ *
     D REST_getEnvVar  pr             1n
     D  peEvar                      512a   const
     D  peValu                     1024a

      * ************************************************************ *
      * REST_getUri(): Recupera URI.                                 *
      *                                                              *
      *       peApi  (input) - Nombre del API                        *
      *                                                              *
      * Retorna: *on si ok, *off si hubo algún error.                *
      * ************************************************************ *
     D REST_getUri     pr             1n
     D  peApi                        10a   const
     D  peUri                       512a
     D  peRoot                       20a   const options(*nopass:*omit)

      * ************************************************************ *
      * REST_getMethod(): Recuera Metodo.                            *
      *                                                              *
      * Retorna: Nombre del método (asume GET)                       *
      * ************************************************************ *
     D REST_getMethod...
     D                 pr           128a

      * ************************************************************ *
      * REST_write(): Graba línea a la stream.                       *
      *                                                              *
      *       peData (input) - Datos a grabar                        *
      *                                                              *
      * Retorna: *on si ok, *off si hubo algún error.                *
      * ************************************************************ *
     D REST_write      pr             1n
     D  peData                      512a   const

      * ************************************************************ *
      * REST_writeHeader(): Graba encabezado respuesta HTTP.         *
      *                                                              *
      *       peStat (input) - Status HTTP                           *
      *       peCtyp (input) - Content Type                          *
      *       peEnco (input) - Encoding                              *
      *                                                              *
      * Retorna: *on si ok, *off si hubo algún error.                *
      * ************************************************************ *
     D REST_writeHeader...
     D                 pr             1n
     D  peStat                        4  0 const options(*nopass:*omit)
     D  peCtyp                      128a   const options(*nopass:*omit)
     D  peEnco                      128a   const options(*nopass:*omit)
     D  peMsid                        7a   const options(*nopass:*omit)
     D  peMsev                       10i 0 const options(*nopass:*omit)
     D  peMsg1                      132a   const options(*nopass:*omit)
     D  peMsg2                     3000a   const options(*nopass:*omit)

      * ************************************************************ *
      * REST_writeXmlLine(): Grabar un tag XML en la stream HTTP.    *
      *                                                              *
      *       peTagn (input) - Nombre del tag                        *
      *       peValu (input) - Valor                                 *
      *                                                              *
      * Retorna: *on si ok, *off si hubo error.                      *
      * ************************************************************ *
     D REST_writeXmlLine...
     D                 pr             1n
     D  peTagn                       30a   const
     D  peValu                      256a   const

      * ************************************************************ *
      * REST_writeEncoding(): Grabar Encoding del XML                *
      *                                                              *
      * Retorna: *on si ok, *off si hubo algún error.                *
      * ************************************************************ *
     D REST_writeEncoding...
     D                 pr             1n

      * ************************************************************ *
      * REST_getNextPart(): Recuperar siguiente parámetro de la URL. *
      *                                                              *
      *       peUri  (input/output) - URL                            *
      *       peFsp  (input) - Separador de campos de parametros     *
      *                                                              *
      * Retorna: *on si ok, *off si hubo error.                      *
      * ************************************************************ *
     D REST_getNextPart...
     D                 pr          3000a   varying
     D  peUri                      3000a   varying
     D  peFsp                         1a   const options(*nopass:*omit)

      * ************************************************************ *
      * REST_xmlEscape(): Escapa carácteres XML especiales.          *
      *                                                              *
      *       peData (input) - Línea XML                             *
      *                                                              *
      * Retorna: la string "escapada".                               *
      * ************************************************************ *
     D REST_xmlEscape...
     D                 pr           512a
     D  peData                      512a   const

      * ************************************************************ *
      * REST_readStdInput(): Lee la standard input.                  *
      *                                                              *
      *       pePvar (input) - Puntero a la variable para recibir la *
      *                        lectura.                              *
      *       pePlen (input) - Longitud máxima de la variable apunta-*
      *                        da por pePvar.                        *
      *                                                              *
      * Retorna: Longitud leía.                                      *
      *          ATENCION: Si el valor de retorno es MAYOR que pePlen*
      *          quiere decir que hay más datos que los permitidos.  *
      * ************************************************************ *
     D REST_readStdInput...
     D                 pr            10i 0
     D  pePvar                         *   value
     D  pePlen                       10i 0 const

      * ************************************************************ *
      * REST_inz():  Inicializar Módulo                              *
      *                                                              *
      * ************************************************************ *
     D REST_inz        pr

      * ************************************************************ *
      * REST_end():  Finalizar Módulo                                *
      *                                                              *
      * ************************************************************ *
     D REST_end        pr

      * ************************************************************ *
      * REST_error(): Retorna último error del módulo.               *
      *                                                              *
      *       peErrn (input) - Número de Error                       *
      *                                                              *
      * Retorna: Mensaje con el último error                         *
      * ************************************************************ *
     D REST_error      pr            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      * ************************************************************ *
      * REST_startArray(): Comienza Array XML                        *
      *                                                              *
      *       peTagn (input) - Nombre del tag                        *
      *                                                              *
      * Retorna: *On si ok / *Off si error.                          *
      * ************************************************************ *
     D REST_startArray...
     D                 pr              n
     D  peTagn                       30a   const

      * ************************************************************ *
      * REST_endArray(): Finaliza Array XML                          *
      *                                                              *
      *       peTagn (input) - Nombre del tag                        *
      *                                                              *
      * Retorna: *On si ok / *Off si error.                          *
      * ************************************************************ *
     D REST_endArray...
     D                 pr              n
     D  peTagn                       30a   const

     D Qp0zDltEnv      pr            10i 0 extproc('Qp0zDltEnv')
     D  peEvar                         *   value options(*string)


