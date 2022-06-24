     H nomain
      * *************************************************** *
      * RTVUSR:  Programa de Servicio.                      *
      *          Recupera algunos datos de USRPRF.          *
      *                                                     *
      * ATENCION: Este programa fue pensado para recuperar  *
      * varios datos del perfil de usuario. Pero finalmente *
      * sólo quedó para validar la existencia del mismo.    *
      * Para recuperar datos debe compilarse con *OWNER y   *
      * al momento de instalarse debe cambiarse el propieta-*
      * rio por un usuario que tenga autorización sobre los *
      * perfiles.                                           *
      *                                                     *
      *  Script de compilación (para INF1SERG/BUILD)        *
      *                                                     *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*  *
      *> IGN: DLTSRVPGM SRVPGM(*LIBL/&N)                <*  *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*  *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*  *
      *>           DBGVIEW(&DV)                         <*  *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*  *
      *>           MODULE(QTEMP/&N) -                   <*  *
      *>           EXPORT(*SRCFILE) -                   <*  *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*  *
      *> TEXT('Programa de Servicio: Recupera Perfil')  <*  *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*  *
      *                                                     *
      * --------------------------------------------------- *
      * Sergio Fernandez                  *12-Jun-2012      *
      * *************************************************** *

     D/copy HDIILE/QCPYBOOKS,RTVUSR_H

     D Initialized     s              1N   inz(*OFF)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D ErrorData       ds                  likeds(RTVUSR_ERDS_T)

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D   Errno                        4s 0 const
     D   peMsg                       80a   const

      * --------------------------------------------------- *
      * Area de sistema
      * --------------------------------------------------- *
     D @PsDs          sds                  qualified
     D  JobName                      10a   overlay(@PsDs:244)
     D  UsrName                      10a   overlay(@PsDs:*next)
     D  JobNbr                        6  0 overlay(@PsDs:*next)

      * --------------------------------------------------- *
      * RTVUSR_Inz(): Inicializa módulo.                    *
      *                                                     *
      * Este procedimiento será llamado por todos los demás *
      * procedimiento exportados.                           *
      *                                                     *
      * --------------------------------------------------- *
     P RTVUSR_Inz      B                   export
     D RTVUSR_Inz      pi            10i 0

      /free

       Initialized = *ON;
       return *zeros;

      /end-free

     P                 E

      * --------------------------------------------------- *
      * RTVUSR_Chk(): Chequea existencia de usuario.        *
      *                                                     *
      *   peUser (input) = Perfil de Usuario a chequear.    *
      *                    *CURRENT = Usuario del Trabajo.  *
      *                                                     *
      * Retorna USR_EXIST o USR_NOTEXIST                    *
      * --------------------------------------------------- *
     P RTVUSR_Chk      B                   export
     D RTVUSR_Chk      pi             1N
     D  peUser                       10a   const

      * -----------------------------------
      * QSYRUSRI
      * -----------------------------------
     D RtvUsrPrf       pr                  extpgm('QSYRUSRI')
     D  Receiver                  32766a   options(*varsize)
     D  ReceiverLen                  10i 0 const
     D  FormatName                    8a   const
     D  UserProfile                  10a   const
     D  Usec                               likeds(QUsec_t)

     D @User           s             10a
     D Receiver        s             30a
     D QUsec           ds                  likeds(QUsec_t)

      /free

       if peUser = '*CURRENT';
          @User  = @PsDs.UsrName;
        else;
          @User  = peUser;
       endif;

       RtvUsrPrf( Receiver
                : %len(Receiver)
                : 'USRI0100'
                : @User
                : QUsec );
       if QUsec.MessageID <> 'CPF9801';
          return USR_EXIST;
       endif;

       select;
         when QUsec.MessageID = 'CPF9801';
          SetError( 9801
                  : 'Usuario no existe') ;
       endsl;

       return USR_NOTEXIST;

      /end-free

     P                 E

      * --------------------------------------------------- *
      * SetError(): Setea un número y texto de error.       *
      *                                                     *
      *   peErno = Número de error.                         *
      *   peText = Texto del error.                         *
      *                                                     *
      * Retorna *NONE                                       *
      * --------------------------------------------------- *
     P SetError        b
     D SetError        pi
     D   peErno                       4s 0 const
     D   peMsg                       80a   const

      /free

       ErrorData.Errno = peErno;
       ErrorData.Msg   = peMsg;

       return;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * RTVUSR_Error():Retorna la descripción del último    *
      *                  error del programa.                *
      *                                                     *
      * Retorna útlimo error.                               *
      * --------------------------------------------------- *
     P RTVUSR_Error    b                   export
     D RTVUSR_Error    pi                  likeds(RTVUSR_ERDS_T)
      /free

       return ErrorData;

      /end-free
     P                 e

