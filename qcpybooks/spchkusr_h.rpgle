      /if defined(SPCHKUSR_H)
      /eof
      /endif
      /define SPCHKUSR_H

      * ------------------------------------------------------------ *
      * SPCHKUSR_HaveMsg(): Verifica si un usuario tiene mensajes.   *
      *                                                              *
      *    peMsgq    (input)    Cola de mensajes a chequear.         *
      *                                                              *
      * retorna: -1 por error, 0 si no tiene mensajes o un número    *
      *          mayor a cero indicando la cantidad de mensajes.     *
      * ------------------------------------------------------------ *
     D SPCHKUSR_HaveMsg...
     D                 pr            10i 0
     D   peMsgq                      20a   const

      * ------------------------------------------------------------ *
      * SPCHKUSR_AlwAct(): Controla si permite o no la actividad en  *
      *                    WebFacing.                                *
      *                                                              *
      * retorna: *ON si permite, *OFF si no permite                  *
      * ------------------------------------------------------------ *
     D SPCHKUSR_AlwAct...
     D                 pr             1N

      * ------------------------------------------------------------ *
      * SPCHKUSR_HaveJobs(): Verifica si un usuario tiene trabajos   *
      *                      activos.                                *
      *                                                              *
      *    peUser    (input)    Usuario.                             *
      *    peSbs     (input)    Subsistema (opcional).               *
      *    peType    (input)    Tipo de Trabajo (opcional).          *
      *                                                              *
      * retorna: -1 por error, 0 si no tiene trabajos activos o un   *
      *          nro mayor a cero indicando la cantidad de trabajos. *
      * ------------------------------------------------------------ *
     D SPCHKUSR_HaveJobs...
     D                 pr            10i 0
     D   peUser                      10a   const
     D   peSbs                       10a   const options(*nopass:*omit)
     D   peType                       1a   const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPCHKUSR_Error(): Retorna el último error del service program*
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SPCHKUSR_Error  pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

