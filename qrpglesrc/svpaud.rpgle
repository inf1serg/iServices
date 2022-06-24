     h nomain
      * ************************************************************ *
      * SVPAUD  :Programa de Servicio.                               *
      *          Validación y Grabación Archivo PAHMSG Auditoría     *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        02-Jul-2015             *
      * ************************************************************ *

     fpahmsg    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpaud_h.rpgle'

      *--- Variables de Trabajo...---------------------------------- *
     D @@finpgm        s              3a
     D @RETORNO        s              1n
     D @@FItm          s              8  0
     D @error          s              1n
     D @@rtex          s            132                                         ||
     D @@ivse          s              5  0                                      ||
     D @@PGMN          s             10                                         ||

      * --------------------------------------------------- *
      * Setea procedimientos globales
      * --------------------------------------------------- *

     D SVPAUD_write    pr            10i 0
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peMstx                      198    const
     D  peUser                       10    const

      * --------------------------------------------------- *

     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D  Errn           s             10i 0
     D  Errm           s             80a
     D  Initialized    s              1N   inz(*OFF)

      * ---- claves
     D k1hmsg          ds                  likerec(p1hmsg:*key)

      *--- Initialized --------------------------------------------- *


      * ************************************************************ *
     D GetCaller       PR                  Extpgm('QWVRCSTK')
     D                             2000
     D                               10I 0
     D                                8    CONST
     D                               56
     D                                8    CONST
     D                               15

     D Var             DS          2000
     D  BytAvl                       10I 0
     D  BytRtn                       10I 0
     D  Entries                      10I 0
     D  Offset                       10I 0
     D  EntryCount                   10I 0

     D VarLen          S             10I 0 Inz(%size(Var))
     D ApiErr          S             15

     D JobIdInf        DS
     D  JIDQName                     26    Inz('*')
     D  JIDIntID                     16
     D  JIDRes3                       2    Inz(*loval)
     D  JIDThreadInd                 10I 0 Inz(1)
     D  JIDThread                     8    Inz(*loval)

     D Entry           DS           256
     D  EntryLen                     10I 0
     D  PgmNam                       10    Overlay(Entry:25)
     D  PgmLib                       10    Overlay(Entry:35)

     D Return_Stack    S             10    DIM(99)
     D Return_Stackli  S             10    DIM(99)
     D Stack           S             10    DIM(99) INZ
     D Stacklib        S             10    DIM(99) INZ
     D count           S              7S 0
      * --------------------------------------------------- *
      * Estructuras Varias...
      * --------------------------------------------------- *

      *=============================================
      *   QCLRPGMI  API to Retrieve program info
      *=============================================
      *
      * Standard API error data structure
      *
     d APIERR1         DS                  INZ
     d  AEBYPR                 1      4B 0
     d  AEBYAV                 5      8B 0
     d  AEEXID                 9     15
     d  AEEXDT                16    116
      *
      * Standard parameters for QCLRPGMI API
      * (Retrieve Program Information) API
      *
      *
     d RP_PARM         DS                  INZ
     d  RP_RCV                 1    416
     d   RP_PGMNAME            9     18
     d   RP_PGMLIB            19     28
     d   RP_PGMATTR           39     48
     d   RP_TEXT             111    160
     d   RP_MODULES          413    416B 0
     d  RP_RCV_LEN           417    420B 0
     d  RP_FORMAT            421    428
     d  RP_PGM_LIB           429    448
     d   RP_PGM              429    438
     d   RP_LIB              439    448

     D*- AREA DE DATOS DEL PROGRAMA...
     d                SDS
     d  @PGM                 001    010
     d  @PARMS               037    039  0
     d  @JOB                 244    253
     d  @USER                254    263
     d  @JOB@                264    269  0

      *--- Definición de Procedimientos----------------------------- *
      * ------------------------------------------------------------ *
      * SVPAUD_logCambioTcr...                                       *
      * Este Procedimiento es para grabar la auditoría del cambio de *
      * Formas de Pago.                                              *
      *                                                              *
      *   peEmpr      (input)    Empresa                             *
      *   peSucu      (input)    Sucursal                            *
      *   peArcd      (input)    Artículo                            *
      *   peSpol      (input)    SuperPóliza                         *
      *   peSspo      (input)    Suplemento de SuperPóliza           *
      *   peMstx      (input)    Descripción del Mensaje.            *
      *   peUser      (input)    Usuario                             *
      *                                                              *
      * Retorna: 0 / -1                                              *
      * ------------------------------------------------------------ *

     P SVPAUD_logCambioTcr...
     P                 B                   export
     D SVPAUD_logCambioTcr...
     D                 pi            10i 0
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peMstx                      198    const
     D  peUser                       10    const

      /free

       SVPAUD_Inz();

       SVPAUD_write( peEmpr:
                     peSucu:
                     peArcd:
                     peSpol:
                     peSspo:
                     peMstx:
                     peUser);
          return 0;
      /end-free

     P SVPAUD_logCambioTcr...
     P                 E

      * ------------------------------------------------------------ *
      * SVPAUD_Write...
      *                                                              *
      *   peEmpr      (input)    Empresa                             *
      *   peSucu      (input)    Sucursal                            *
      *   peArcd      (input)    Artículo                            *
      *   peSpol      (input)    SuperPóliza                         *
      *   peSspo      (input)    Suplemento de SuperPóliza           *
      *   peMstx      (input)    Mensage a grabar en archivo PAHMSG  *
      *   peUser      (input)    Usuario                             *
      *                                                              *
      * Retorna: 0 / -1                                              *
      *                                                              *
      * ------------------------------------------------------------ *

     P SVPAUD_Write    B
     P
     D SVPAUD_Write...
     D                 pi            10i 0
     D   peEmpr                       1     const
     D   peSucu                       2     const
     D   peArcd                       6  0  const
     D   peSpol                       9  0  const
     D   peSspo                       3  0  const
     D   peMstx                     198     const
     D   peUser                      10     const

      /free

       SVPAUD_Inz();

       k1hmsg.msEmpr = peEmpr;
       k1hmsg.msSucu = peSucu;
       k1hmsg.msArcd = peArcd;
       k1hmsg.msSpol = peSpol;
       k1hmsg.msSspo = peSspo;
       setgt  %kds(k1hmsg:4) pahmsg;
       readpe %kds(k1hmsg:4) pahmsg;
1b     if not %found;
          eval @@ivse = 1 ;
          else;
          eval @@ivse = msivse + 1;
1e     endif;
          eval msempr = peempr ;
          eval mssucu = pesucu ;
          eval msarcd = pearcd ;
          eval msspol = pespol ;
          eval mssspo = pesspo ;
          eval msivse = @@ivse ;
          eval mssuse = *zeros ;
          eval mscpgm = @@pgmn;
          eval msmarp = '1';
          eval msmar1 = '1';
          eval msmar2 = '0';
          eval msmar3 = '0';
          eval msmar4 = '0';
          eval msmar5 = '0';
          eval msstrg = '0';
          eval mstxmg = *blanks;
          eval mstxmg = peMstx;
          eval msuser = peUser;
          eval msdate = udate;
          eval mstime = %dec(%time);
          write p1hmsg;
          return 0;


      /end-free

     P SVPAUD_write    E
     P
      * ------------------------------------------------------------ *
      * SVPAUD_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPAUD_inz      B                   export
     D SVPAUD_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahmsg);
         open pahmsg;
       endif;

       initialized = *ON;

      /end-free

      * Primer Api que recupera Programa/Biblioteca
     C                   MOVE      *BLANKS       @@PGMN
     C                   CallP     GetCaller(Var:VarLen:'CSTK0100':JobIdInf
     C                             :'JIDF0100':ApiErr)

     C                   Do        EntryCount
     C                   Eval      Entry = %subst(Var:Offset + 1)
     C                   Eval      Offset = Offset + EntryLen
     C                   Eval      Count = Count + 1
     C                   Eval      Stack(Count) = PgmNam
     C                   Eval      Stacklib(Count) = PgmLib
     C                   Enddo

     C                   if        %parms <> 0
     C                   movea     Stack         Return_Stack
     C                   movea     Stacklib      Return_Stackli
     C                   endif

      * Segundo Api que recupera Variables de Programa/Biblioteca

     C                   eval      Count = 0
     C                   do        EntryCount
     C                   Eval      Count = Count + 1
     c                   clear                   RP_parm
     c                   eval      RP_RCV_LEN = 416
     c                   eval      RP_FORMAT  = 'PGMI0100'
     c                   eval      RP_PGM     = Stack(count)
     C                   if        RP_PGM <> @PGM
     c                   eval      RP_LIB     = Stacklib(count)
     c                   clear                   APIERR1
     c                   eval      AEBYPR     = 116

      *

     c                   call      'QCLRPGMI'
     c                   parm                    RP_RCV
     c                   parm                    RP_RCV_LEN
     c                   parm                    RP_FORMAT
     c                   parm                    RP_PGM_LIB
     c                   parm                    APIERR1

      * Acá veo si no tiene error , asi determino y me salgo del Loop para
      * quedarme con el primer programa que llamo al SRVPGM.
     C                   IF        AEEXID = *BLANKS
     C                   EVAL      @@PGMN = RP_PGM
     C                   LEAVE
     C                   ENDIF

     C                   EndIF
     C                   Enddo
     C                   RETURN
     P SVPAUD_inz      E
      * ------------------------------------------------------------ *
      * SVPAUD_end(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPAUD_end      B                   export
     D SVPAUD_end      pi

      /free

       close *all;
       initialized = *off;
       return;

      /end-free

     P SVPAUD_end      E
      *==============================================================*
