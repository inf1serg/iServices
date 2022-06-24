     H nomain
      * ************************************************************ *
      * SPCHKUSR: Tareas generales.                                  *
      *           Tareas a nivel de usuario.                         *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                   *17-Jun-2013              *
      * ************************************************************ *

      /copy './qcpybooks/qusec_h.rpgle'
      /copy './qcpybooks/spchkusr_h.rpgle'

     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D ErrCode         s             10i 0
     D ErrText         s             80a

     D dtaact          ds                  dtaara(dtaspdwy2s)
     D                                     qualified
     D  permit                        1a   overlay(dtaact:1)

      * ------------------------------------------------------------ *
      * SPCHKUSR_HaveMsg(): Verifica si un usuario tiene mensajes.   *
      *                                                              *
      *    peMsgq    (input)    Cola de mensajes a chequear.         *
      *                                                              *
      * retorna: -1 por error, 0 si no tiene mensajes o un número    *
      *          mayor a cero indicando la cantidad de mensajes.     *
      * ------------------------------------------------------------ *
     P SPCHKUSR_HaveMsg...
     P                 B                   export
     D SPCHKUSR_HaveMsg...
     D                 pi            10i 0
     D   peMsgq                      20a   const

      * -----------------------------------
      * QSYRUSRI
      * -----------------------------------
     D RtvObjD         pr                  extpgm('QUSROBJD')
     D  Receiver                  32766a   options(*varsize)
     D  ReceiverLen                  10i 0 const
     D  FormatName                    8a   const
     D  Object                       20a   const
     D  ObjectType                   10a   const
     D  Usec                               likeds(QUsec_t)

      * -----------------------------------
      * QMHRCVM
      * -----------------------------------
     D RcvMsg          pr                  extpgm('QMHRCVM')
     D  MessageInfo                 560
     D  LenMsgInfo                   10i 0 const
     D  FormatName                    8    const
     D  QualMsgQName                 20    const
     D  MessageType                  10    const
     D  MessageKey                    4    const
     D  WaitTime                     10i 0 const
     D  MessageAction                10    const
     D  QUsec                              likeds(QUsec_t)

     D QUsec           ds                  likeds(QUsec_t)

     D OBJD0100        ds                  qualified
     D  BytesRet                     10i 0
     D  BytesAva                     10i 0
     D  ObjName                      10a
     D  ObjLib                       10a
     D  ObjType                      10a
     D  RtnLib                       10a
     D  AuxAsp                       10i 0
     D  ObjOwner                     10a
     D  ObjDom                        2a
     D  CrtDate                      13a
     D  ObjChgDat                    13a

     D RCVM0100        ds                  qualified
     D  BytesRet                     10i 0
     D  BytesAva                     10i 0
     D  MessageSev                   10i 0
     D  MessageId                     7a
     D  MessageType                   2a
     D  MessageKey                    4a
     D  Reserved                      7a
     D  CCSIDConvStatusInd...
     D                               10i 0
     D  CCSIDOfMessageData...
     D                               10i 0
     D  LenRplDataReturned...
     D                               10i 0
     D  LenRplDataAvailable...
     D                               10i 0
     D  ReplacementData...
     D                              512a

     D MsgInfo         s            560
     D MsgKey          s              4
     D MsgType         s             10
     D MsgActi         s             10
     D Inq             s             10i 0
     D BytesAva        s             10i 0

      /free

       QUsec.BytesProvided = %len(QUsec);

       RtvObjD( OBJD0100
              : 108
              : 'OBJD0100'
              : peMsgq
              : '*MSGQ'
              : QUsec );

       if (QUsec.MessageID <> *blanks);
           SetError( 1
                   : 'Error en Cola de Mensajes: ' + QUsec.MessageID);
           return -1;
       endif;

       QUsec.BytesAvailables = *zeros;
       QUsec.BytesProvided = %len(QUsec);

       inq = 0;

       MsgType = '*FIRST';
       MsgActi = '*SAME';
        MsgKey = *blanks;

       RcvMsg( RCVM0100
             : %len(RCVM0100)
             : 'RCVM0100'
             : peMsgq
             : MsgType
             : MsgKey
             : 0
             : MsgActi
             : QUsec  );
       BytesAva = RCVM0100.BytesAva;
       if (QUsec.MessageId <> *blanks );
           SetError( 1
                   : 'Error en Cola de Mensajes: ' + QUsec.MessageID);
           return -1;
       endif;

       dow BytesAva <> *zeros;
           if RCVM0100.MessageType <> '05' and
              RCVM0100.MessageType <> '21';
                 MsgActi = '*REMOVE';
                 RcvMsg( RCVM0100
                       : %len(RCVM0100)
                       : 'RCVM0100'
                       : peMsgq
                       : MsgType
                       : MsgKey
                       : 0
                       : MsgActi
                       : QUsec  );
            if (QUsec.MessageId <> *blanks );
                SetError( 1
                        : 'Error en Cola de Mensajes: ' + QUsec.MessageID);
                return -1;
            endif;
            else;
                 inq += 1;
                 MsgKey  = RCVM0100.MessageKey;
                 MsgType = '*NEXT';
           endif;

             MsgActi = '*SAME';
             RcvMsg( RCVM0100
                   : %len(RCVM0100)
                   : 'RCVM0100'
                   : peMsgq
                   : MsgType
                   : MsgKey
                   : 0
                   : MsgActi
                   : QUsec );
             if (QUsec.MessageId <> *blanks );
                 SetError( 1
                         : 'Error en Cola de Mensajes: ' + QUsec.MessageID);
                 return -1;
             endif;

             BytesAva = RCVM0100.BytesAva;

         enddo;

       return Inq;

      /end-free

     P SPCHKUSR_HaveMsg...
     P                 E

      * ------------------------------------------------------------ *
      * SPCHKUSR_AlwAct(): Controla si permite o no la actividad en  *
      *                    WebFacing.                                *
      *                                                              *
      * retorna: *ON si permite, *OFF si no permite                  *
      * ------------------------------------------------------------ *
     P SPCHKUSR_AlwAct...
     P                 B                   export
     D SPCHKUSR_AlwAct...
     D                 pi             1N


      /free

       in dtaact;
       unlock dtaact;

       if (dtaact.permit = 'S');
          return *ON;
       endif;

       return *OFF;

      /end-free

     P SPCHKUSR_AlwAct...
     P                 E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peEnum   (input)   Número de error a setear.             *
      *     peEtxt   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SetError        B
     D SetError        pi
     D  peEnum                       10i 0 const
     D  peEtxt                       80a   const

      /free

       ErrCode = peEnum;
       ErrText = peEtxt;

      /end-free

     P SetError        E

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
     P SPCHKUSR_HaveJobs...
     P                 B                   export
     D SPCHKUSR_HaveJobs...
     D                 pi            10i 0
     D   peUser                      10a   const
     D   peSbs                       10a   const options(*nopass:*omit)
     D   peType                       1a   const options(*nopass:*omit)

      * ----------------------------------------------
      * QUSCRTUS - Crear User Space
      * ----------------------------------------------
     D QUSCRTUS        pr                  extpgm('QUSCRTUS')
     D  QualUsrSpc                   20a   const
     D  ExtendAttr                   10a   const
     D  InitialSize                  10i 0 const
     D  InitialValue                  1a   const
     D  PublicAuth                   10a   const
     D  TextDescrip                  50a   const
     D  Replace                      10a   const options(*nopass)
     D  QUsec                              likeds(QUsec_t)
     D                                     options(*nopass)

      * ----------------------------------------------
      * QUSPTRUS - Recuperar puntero a User Space
      * ----------------------------------------------
     D QUSPTRUS        pr                  extpgm('QUSPTRUS')
     D  QualUsrSpc                   20a   const
     D  Pointer                        *

      * ----------------------------------------------
      * QUSDLTUS - Eliminar User Space
      * ----------------------------------------------
     D QUSDLTUS        pr                  extpgm('QUSDLTUS')
     D  QualUsrSpc                   20a   const
     D  QUsec                              likeds(QUsec_t)

      * ----------------------------------------------
      * QUSLJOB - Lista trabajos activos
      * ----------------------------------------------
     D QUSLJOB         pr                  extpgm('QUSLJOB')
     D  QualUsrSpc                   20a   const
     D  FormatName                    8a   const
     D  QualJobName                  26a   const
     D  Status                       10a   const
     D  QUsec                              likeds(QUsec_t)

      * ----------------------------------------------
      * QUSRJOBI - Recupera atributos de trabajo
      * ----------------------------------------------
     D QUSRJOBI        PR                  ExtPgm('QUSRJOBI')
     D   rcvvar                   65535A   options(*varsize)
     D   rcvvarlen                   10i 0 const
     D   format                       8a   const
     D   qualJob                     26a   const
     D   intjobid                    16a   const
     D   QUsec                             likeds(QUsec_t)

      * ----------------------------------------------
      * Header genérico User Space
      * ----------------------------------------------
     D UsrSpcHdr_t     ds                  qualified
     D                                     based(template)
     D   OfsHdr                      10i 0 overlay(UsrSpcHdr_t: 117)
     D   OfsLst                      10i 0 overlay(UsrSpcHdr_t: 125)
     D   NumLstEnt                   10i 0 overlay(UsrSpcHdr_t: 133)
     D   SizLstEnt                   10i 0 overlay(UsrSpcHdr_t: 137)

     D UsrSpcHdr       ds                  likeds(UsrSpcHdr_t)
     D                                     based(p_UsrSpc)

      * ----------------------------------------------
      * Header API
      * ----------------------------------------------
     D ApiHdrInf_t     ds                  qualified
     D                                     based(template)
     D   UsrSpcU                     10a
     D   UsrLibU                     10a
     D   ObjNamU                     10a
     D   ObjLibU                     10a
     D   ObjTypR                     10a
     D   ObjExtAtr                   10a
     D   ShrFilNam                   10a
     D   ShrFilLib                   10a
     D   OfsPthNamU                  10i 0
     D   LenPthNamU                  10i 0
     D   OfsNamAspU                  10a
     D   OfsLibAspU                  10a

     D ApiHdrInf       ds                  likeds(ApiHdrInf_t)
     D                                     based(p_HdrInf)

     D JOBL0100        ds                  qualified
     D                                     based(p_LstEnt)
     D   JobName                     10a
     D   JobUser                     10a
     D   JobNbr                       6a
     D   IntJobId                    16a
     D   Status                      10a
     D   Type                         1a
     D   SubType                      1a

     D JOBI0600        ds                  qualified
     D   BytesRet                    10i 0
     D   BytesAva                    10i 0
     D   JobName                     10a
     D   JobUser                     10a
     D   JobNbr                       6a
     D   IntJobId                    16a
     D   Status                      10a
     D   Type                         1a
     D   SubType                      1a
     D   Switches                     8a
     D   EndStatus                    1a
     D   Subsystem                   10a
     D   SbsLibrary                  10a
     D   CurUser                     10a

      * ----------------------------------------------
      * Nombre de trabajo calificado
      * ----------------------------------------------
     D QualJob         ds                  qualified
     D  Job                          10a   overlay(QualJob:1)
     D  User                         10a   overlay(QualJob:*next)
     D  Nbr                           6a   overlay(QualJob:*next)

      * ----------------------------------------------
      * Constantes
      * ----------------------------------------------
     D USRSPC          c                   'JOBLIST   QTEMP     '
     D EXATT_NONE      c                   '*NONE'
     D PUBAUT_ALL      c                   '*ALL'
     D REPLACE_YES     c                   '*YES'
     D USER_CURRENT    c                   '*CURRENT'
     D OUTQ_ALL        c                   '*ALL'
     D FRMTYPE_ALL     c                   '*ALL'
     D USRDTA_ALL      c                   '*ALL'

      * ----------------------------------------------
      * Punteros User Space
      * ----------------------------------------------
     D p_UsrSpc        s               *
     D p_HdrInf        s               *
     D p_LstEnt        s               *

     D x               s             10i 0
     D offset          s             10i 0
     D @Sbs            s             10a   inz('*ALL')
     D @Type           s             10a   inz('*')
     D @Cnt            s             10i 0
     D QUsec           ds                  likeds(QUsec_t)

      /free

       if %parms >= 2 and %addr(peSbs) <> *NULL;
          @Sbs = peSbs;
       endif;

       if %parms >= 3 and %addr(peType) <> *NULL;
          @Type = peType;
       endif;

       // ---------------------------------
       // Crear User Space
       // ---------------------------------
       QUSCRTUS( USRSPC
               : ' '
               : 1024 * 1024
               : x'00'
               : PUBAUT_ALL
               : 'Lista de trabajos'
               : REPLACE_YES
               : QUsec );

       // ---------------------------------
       // Llenar User Space
       // ---------------------------------
       QUSLJOB( USRSPC
              : 'JOBL0100'
              : '*ALL      *ALL      *ALL  '
              : '*ACTIVE'
              : QUsec );

       // ---------------------------------
       // Obtener puntero a User Space
       // ---------------------------------
       QUSPTRUS ( USRSPC
                : p_UsrSpc );

       // ---------------------------------
       // Procesar la lista
       // ---------------------------------
       for x = 1 to UsrSpcHdr.NumLstEnt;
           offset = UsrSpcHdr.OfsLst + (x -1) * UsrSpcHdr.SizLstEnt;
           p_LstEnt = p_UsrSpc + offset;
               QUsec.BytesProvided = %size(Qusec);
               QUsec.BytesAvailables =  *zeros;
                QualJob.Job = JOBL0100.JobName;
               QualJob.User = JOBL0100.JobUser;
                QualJob.Nbr = JOBL0100.JobNbr;
               QUSRJOBI( JOBI0600
                       : %len(JOBI0600)
                       : 'JOBI0600'
                       : QualJob
                       : *blanks
                       : QUsec );
               if JOBL0100.JobUser = peUser or
                  JOBI0600.CurUser = peUser;

                  if (JOBI0600.Subsystem = @Sbs or
                     @Sbs = '*ALL') and
                     (JOBI0600.Type = @Type or
                     @Type = '*');
                      @Cnt += 1;
                  endif;

               endif;
       endfor;

       return @Cnt;

      /end-free

     P SPCHKUSR_HaveJobs...
     P                 E

      * ------------------------------------------------------------ *
      * SPCHKUSR_Error(): Retorna el último error del service program*
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     P SPCHKUSR_Error  B                   export
     D SPCHKUSR_Error  pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

     D @Enbr           s             10i 0

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          @Enbr = ErrCode;
       endif;

       return ErrText;

      /end-free

     P SPCHKUSR_Error  E

