      /if defined(SVPAUD_H)
      /eof
      /endif
      /define SVPAUD_H

      * ------------------------------------------------------------ *
      * Constantes de Error
      * ------------------------------------------------------------ *

      * ------------------------------------------------------------ *
      * INZ():       Incializar Módulo                               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *

      * ------------------------------------------------------------ *
      * End():       Finalizar Módulo                                *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *

      * ------------------------------------------------------------ *
      * Error():     Retorna último error                            *
      *                                                              *
      *       peErrn    (input)   Número del error                   *
      *                                                              *
      * retorna: Mensaje del último error                            *
      * ------------------------------------------------------------ *

      * ------------------------------------------------------------ *
      * logCambioTcr(): Loguea cambio de Tarjeta de Crédito.         *
      *                                                              *
      *   peEmpr      (input)    Empresa                             *
      *   peSucu      (input)    Sucursal                            *
      *   peArcd      (input)    Artículo                            *
      *   peSpol      (input)    SuperPóliza                         *
      *   peSspo      (input)    Suplemento de SuperPóliza           *
      *   peMstx      (input)    Mensaje de Texto.                   *
      *   peUser      (input)    Usuario                             *
      *                                                              *
      * retorna: 0 si ok, -1 si error                                *
      * ------------------------------------------------------------ *
     D SVPAUD_logCambioTcr...
     D                 pr            10i 0
     D  peEmpr                        1a    const
     D  peSucu                        2a    const
     D  peArcd                        6  0  const
     D  peSpol                        9  0  const
     D  peSspo                        3  0  const
     D  peMstx                      198     const
     D  peUser                       10     const

