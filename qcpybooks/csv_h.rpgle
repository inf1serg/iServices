      /if defined(CSV_H_DEFINED)
      /eof
      /endif
      /define CSV_H_DEFINED

      * -------------------------------------------- *
      * Puntero de memoria para archivos
      * -------------------------------------------- *
     D CSV_HANDLE      S               *   based(TEMPLATE)

      * --------------------------------------------------------- *
      * CSV_open(): Abrir archivo delimitado
      *
      *    peFilename = (input) Path IFS del archivo a abrir
      *      peStrDel = (input/omit) Delimitador de strings
      *                  si *OMIT, se usa comilla doble
      *      peFldDel = (input/omit) Delimitador de Coma
      *                  si *OMIT, se usa coma
      *
      * retorna un HANDLER usado para seguir al archivo abierto
      *        o manda un *ESCAPE si hay error
      * --------------------------------------------------------- *
     D CSV_open        PR                  like(CSV_HANDLE)
     D   peFilename                5000A   varying const options(*varsize)
     D   peStrDel1                    1A   const options(*omit:*nopass)
     D   peStrDel2                    1A   const options(*omit:*nopass)
     D   peFldDel                     1A   const options(*omit:*nopass)


      * --------------------------------------------------------- *
      * CSV_loadrec(): Carga un registro del archivo
      *
      *     peHandle = (i/o) el handler devuelto por CSV_open()
      *
      * Returns *ON if successful, *OFF upon failure or EOF
      * --------------------------------------------------------- *
     D CSV_loadrec     PR             1N   extproc(*CL:'CSV_LOADREC')
     D   peHandle                          like(CSV_HANDLE) value


      * --------------------------------------------------------- *
      * CSV_rewindfile():  Posiciona cursor de archivo al comienzo
      *                    (para re leerlo)
      *
      *   peHandle = (i/o) el handler devuelto por CSV_open()
      *
      * Retorna *ON si ok, *OFF si no ok.
      * --------------------------------------------------------- *
     D CSV_rewindfile  PR             1N   extproc(*CL:'CSV_REWINDFILE')
     D   peHandle                          like(CSV_HANDLE) value


      * --------------------------------------------------------- *
      * CSV_rewindrec():  Posiciona cursor al comienzo del registro
      *                  (para releer registro)
      *
      *   peHandle = (i/o) el handler devuelto por CSV_open
      *
      * Retorna *ON si ok, *OFF si no ok.
      * --------------------------------------------------------- *
     D CSV_rewindrec   PR             1N   extproc(*CL:'CSV_REWINDREC')
     D   peHandle                          like(CSV_HANDLE) value


      * --------------------------------------------------------- *
      * CSV_getfld(): Siguiente campo del archivo
      *
      *  peHandle = (i/o)  el handler devuelto por CSV_open()
      * peFldData = (output) Dato leido
      * peVarSize = (input) tamaño en bytes de peFldData
      *                     (incluye los 2 bytes de long)
      *
      * Retorna *ON si leyó, *OFF si no.
      * --------------------------------------------------------- *
     D CSV_getfld      PR             1N   extproc(*CL:'CSV_GETFLD')
     D   peHandle                          like(CSV_HANDLE) value
     D   peFldData                65502A   varying options(*varsize)
     D   peVarSize                   10I 0 value

      * --------------------------------------------------------- *
      * CSV_close(): Cierra archivo
      *
      *  peHandle = (i/o) handler devuelto por CSV_open()
      *                   se setea a *NULL si el archivo se cierra
      *                   correctamente.
      *
      * Retorna un *ESCAPE si falla
      *         si no, nada
      * --------------------------------------------------------- *
     D CSV_close       PR
     D   peHandle                          like(CSV_HANDLE)

