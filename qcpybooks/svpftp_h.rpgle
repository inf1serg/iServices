      /if defined(SVPFTP_H)
      /eof
      /endif
      /define SVPFTP_H
      * ------------------------------------------------------------ *
      * SVPFTP_getParametros(): Retorna parametros FTP.              *
      *                                                              *
      *     peCprc   (input)   ID de Procedimiento                   *
      *     peDprc   (output)  Descripción                           *
      *     peHost   (output)  Host                                  *
      *     peUser   (output)  ID de Usuario                         *
      *     pePass   (output)  Password                              *
      *     pePort   (output)  Puerto                                *
      *     peTimo   (output)  TimeOut                               *
      *     peAcct   (output)  Cuenta                                *
      *     peLflr   (output)  Carpeta Local                         *
      *     peRflr   (output)  Carpeta Remota                        *
      *                                                              *
      *  Retorna: *on=ok/*off=error.
      * ------------------------------------------------------------ *

     D SVPFTP_getParametros...
     D                 pr              n
     D peCprc                        20    const
     D peDprc                        40
     D peHost                        20
     D peUser                        20
     D pePass                        20
     D pePort                         5  0
     D peTimo                         5  0
     D peAcct                        20
     D peLflr                        50
     D peRflr                        50

      * ------------------------------------------------------------ *
      * SVPFTP_inz(): Inicializa módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPFTP_inz      pr

      * ------------------------------------------------------------ *
      * SVPFTP_end(): Finaliza módulo.                                *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPFTP_end      pr

