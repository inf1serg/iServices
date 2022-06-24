     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPFTP: Programa de Servicio.                                *
      *        Parámetros FTP.                                       *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                  28-Oct-2015             *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * ************************************************************ *

     Fgntpr1    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpftp_h.rpgle'

     D Initialized     s               n

      *--- PR Externos --------------------------------------------- *
      *--- Definicion de Procedimiento ----------------------------- *

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

     P SVPFTP_getParametros...
     P                 B                   export
     D SVPFTP_getParametros...
     D                 pi              n
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

       SVPFTP_inz();

       chain (peCprc) gntpr1;
       if %found(gntpr1);
          peDprc = r1dprc;
          peHost = r1host;
          peUser = r1user;
          pePass = r1pass;
          pePort = r1port;
          peTimo = r1timo;
          peAcct = r1acct;
          peLflr = r1lflr;
          peRflr = r1rflr;
          return *On;
       else;
          return *Off;
       endif;

     P SVPFTP_getParametros...
     P                 E

      * ------------------------------------------------------------ *
      * SVPFTP_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SVPFTP_inz      B                   export
     D SVPFTP_inz      pi

       if not %open(gntpr1);
          open gntpr1;
       endif;

       initialized = *On;

       return;

     P SVPFTP_inz      E

      * ------------------------------------------------------------ *
      * SVPFTP_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SVPFTP_End      B                   export
     D SVPFTP_End      pi


       initialized = *Off;

       close *all;

       return;

     P SVPFTP_End      E

