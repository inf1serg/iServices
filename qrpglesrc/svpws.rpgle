     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPWS: Programa de Servicio.                                 *
      *        Proyecto QUOM.                                        *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     13-Abr-2015             *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * SFA 21/04/2015 - Agrego procedimiento SVPWS_chkParmBase()    *
      *                                       SVPWS_chkRoll()        *
      *                                       SVPWS_chkOrde()        *
      * SFA 20/05/2015 - Modifico procedimiento SVPWS_chkRoll()      *
      *                                         SVPWS_getMsgs()      *
      * NGF 06/07/2015 - Agrego procedimiento SVPWS_getCant()        *
      *                                       SVPWS_getGrupoRama()   *
      * LRG 05/08/2015 - Modifico procedimiento SVPWS_getGrupoRama() *
      * LRG 08/06/2016 - Agrego procedimiento SVPWS_getGrupoRamaArch *
      * JSN 03/04/2020 - Se Modifica el procedimiento _getGrupoRama()*
      *                                                              *
      * ************************************************************ *

     Fsehni2    if   e           k disk    usropn
     Fgntwsp    if   e           k disk    usropn
     Fgntwsf    if   e           k disk    usropn
     Fset001    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/qusec_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- PR Externos --------------------------------------------- *

     D RetMsg          pr                  extpgm('QMHRTVM')
     D  MsgInfo                   10000a
     D  LenMsgInfo                   10i 0 const
     D  FormatName                    8a   const
     D  MsgId                         7a   const
     D  QualMsgFile                  20a   const
     D  RplData                      10a   const
     D  LenRplData                   10i 0 const
     D  LenSubVars                   10a   const
     D  FmtCtlChars                  10a   const
     D  QUsec                              likeds(QUsec_t)

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * SVPWS_parseParmBase(): Retorna los parametros de la DS Base  *
      *                                                              *
      *     peBase   (input)   DS de Parametros Base                 *
      *     peEmpr   (output)  Empresa                               *
      *     peSucu   (output)  Sucursal                              *
      *     peNivt   (output)  Tipo  de Intermediario                *
      *     peNivc   (output)  Codigo de Intermediario               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPWS_parseParmBase...
     P                 B                   export
     D SVPWS_parseParmBase...
     D                 pi              n
     D   peBase                            const likeds ( paramBase )
     D   peEmpr                       1    options(*nopass:*omit)
     D   peSucu                       2    options(*nopass:*omit)
     D   peNivt                       1  0 options(*nopass:*omit)
     D   peNivc                       5  0 options(*nopass:*omit)

      /free

       if ( ( %parms >= 2 ) and ( %addr ( peEmpr ) <> *Null ) );
         peEmpr = peBase.peEmpr;
       endif;

       if ( ( %parms >= 3 ) and ( %addr ( peSucu ) <> *Null ) );
         peSucu = peBase.peSucu;
       endif;

       if ( ( %parms >= 4 ) and ( %addr ( peNivt ) <> *Null ) );
         peNivt = peBase.peNivt;
       endif;

       if ( ( %parms >= 5 ) and ( %addr ( peNivc ) <> *Null ) );
         peNivc = peBase.peNivc;
       endif;

       return *On;

      /end-free

     P SVPWS_parseParmBase...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWS_getMsgs(): Retorna Mensaje de Error                    *
      *                                                              *
      *     peLibl   (input)   Biblioteca                            *
      *     peMsgF   (input)   Archivo de Mensajes                   *
      *     peMsgI   (input)   Id. de Mensaje                        *
      *     peMsgs   (output)  DS de Errores                         *
      *     peRepl   (input)   Variables de Reemplazo                *
      *     peLeng   (input)   Longitud de Campo peRepl              *
      *                                                              *
      * Retorna: Severidad de Error / -1 Error                       *
      * ------------------------------------------------------------ *

     P SVPWS_getMsgs...
     P                 B                   export
     D SVPWS_getMsgs...
     D                 pi            10i 0
     D   peLibl                      10    const
     D   peMsgF                      10    const
     D   peMsgI                       7    const
     D   peMsgs                            likeds ( paramMsgs )
     D   peRepl                   65535a   const
     D                                     options(*nopass:*omit:*varsize)
     D   peLeng                      10i 0 const options(*nopass:*omit)

     D @retMsg         s          10000
     D @msID           s              7a   varying
     D @msgFile        s             20
     D @ReplDta        s            286a
     D @ReplLen        s             10i 0
     D @Replace        s              4a
     D QUsec           ds                  likeds(QUsec_t)

     D pMsg1           s               *
     D pMsg2           s               *
     D @Msg1           s            132a   based(pMsg1)
     D @Msg2           s           3000a   based(pMsg2)

     D RTVM0300        ds                  likeds(DSRTVM0300)

      /free

       @ReplDta = *Blanks;
       @Replace = '*NO';
       @ReplLen = *Zeros;
       @msgFile = peMsgf + peLibl;
       QUsec.BytesProvided = %size ( QUsec );

       if ( ( %parms >= 5 ) and ( %addr ( peRepl ) <> *Null ) );
         if ( ( %parms >= 6 ) and ( %addr ( peLeng ) <> *Null ) );
           @ReplDta = %subst(peRepl:1:peLeng);
           @Replace = '*YES';
           @ReplLen = peLeng;
         else;
           peMsgs.peMsg1 = 'No se ha enviado la longitud del campo peRepl';
           return -1;
         endif;
       endif;

       RetMsg ( @retMsg
              : 10000
              : 'RTVM0300'
              : peMsgI
              : @msgFile
              : @ReplDta
              : @ReplLen
              : @Replace
              : '*NO'
              : QUsec );

       if ( QUsec.messageid <> *Blanks );

         QUsec.BytesProvided = %size ( QUsec );

         RetMsg ( @retMsg
                : 10000
                : 'RTVM0300'
                : QUsec.messageid
                : 'QCPFMSG   *LIBL     '
                : QUsec.ApiEcExDt
                : 127
                : '*YES'
                : '*NO'
                : QUsec );

       endif;

       RTVM0300 = @RetMsg;

       pMsg1 = %addr ( @RetMsg ) + RTVM0300.MsgOffSet;
       pMsg2 = %addr ( @RetMsg ) + RTVM0300.MsgHlpOffSet;

       peMsgs.peMsg1 = %subst ( @Msg1 : 1 : RTVM0300.LenMsgRet );
       peMsgs.peMsg2 = %subst ( @Msg2 : 1 : RTVM0300.LenMsgHlpRet );

       peMsgs.peMsid = peMsgI;

       peMsgs.peMsev = RTVM0300.MsgSeverity;

       return -1;

      /end-free

     P SVPWS_getMsgs...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWS_inz(): Inicializa módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SVPWS_inz       B                   export
     D SVPWS_inz       pi

      /free

      /end-free

     P SVPWS_inz       E

      * ------------------------------------------------------------ *
      * SVPWS_End(): Finaliza módulo.                                *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SVPWS_End       B                   export
     D SVPWS_End       pi

      /free

       initialized = *OFF;

       close *All;

       return;

      /end-free

     P SVPWS_End       E

      * ------------------------------------------------------------ *
      * SVPWS_Error(): Retorna el último error del service program   *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPWS_Error     B                   export
     D SVPWS_Error     pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if ( ( %parms >= 1 ) and ( %addr ( peEnbr ) <> *Null ) );
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPWS_Error     E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWS_chkParmBase(): Valida los parametros Base              *
      *                                                              *
      *     peBase   (input)   DS de Parametros Base                 *
      *     peMsgs   (output)  DS de Errores                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPWS_chkParmBase...
     P                 B                   export
     D SVPWS_chkParmBase...
     D                 pi              n
     D   peBase                            const likeds ( paramBase )
     D   peMsgs                            likeds ( paramMsgs )

     D k1yni2          ds                  likerec ( s1hni2 : *Key )

     D @@empr          s              1
     D @@sucu          s              2
     D @@nivt          s              1  0
     D @@nivc          s              5  0

     D @@repl          s          65535a
     D @@leng          s             10i 0

      /free

       if not %open(sehni2);
         open sehni2;
       endif;

       clear peMsgs;

       SVPWS_parseParmBase ( peBase : @@empr : @@sucu : @@nivt : @@nivc );

       k1yni2.n2empr = @@empr;
       k1yni2.n2sucu = @@sucu;
       k1yni2.n2nivt = @@nivt;
       k1yni2.n2nivc = @@nivc;

       setll %kds( k1yni2 ) sehni2;

       if not %equal ( sehni2 );
         @@repl = @@empr + @@sucu + %char ( @@nivt ) + %char ( @@nivc );
         @@leng = %len ( %trim ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PRD0002' :
                          peMsgs : @@repl  : @@leng );
         close sehni2;
         return *Off;
       endif;

       close sehni2;

       return *On;

      /end-free

     P SVPWS_chkParmBase...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWS_chkRoll(): Valida el parametro de Roll                 *
      *                                                              *
      *     peRoll   (input)   Parametro de Roll                     *
      *     peMsgs   (output)  DS de Errores                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPWS_chkRoll...
     P                 B                   export
     D SVPWS_chkRoll...
     D                 pi              n
     D   peRoll                       1    const
     D   peMsgs                            likeds ( paramMsgs )

      /free

       clear peMsgs;

       if ( ( peRoll <> 'F' ) and ( peRoll <> 'R' ) and ( peRoll <> 'I' ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'GEN0011' : peMsgs );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPWS_chkRoll...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWS_chkOrde(): Valida ordenamiento de WS                   *
      *                                                              *
      *     pePgWs   (input)   WebServices                           *
      *     peFilt   (input)   Filtro WebServices                    *
      *     peMsgs   (output)  DS de Errores                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPWS_chkOrde...
     P                 B                   export
     D SVPWS_chkOrde...
     D                 pi              n
     D   pePgWs                      10    const
     D   peFilt                      10    const
     D   peMsgs                            likeds ( paramMsgs )

     D k1yfil          ds                  likerec ( g1twsf : *Key )

     D @@repl          s          65535a
     D @@leng          s             10i 0

      /free

       clear peMsgs;

       if not %open( gntwsp );
         open gntwsp;
       endif;

       setll pePgWs gntwsp;
       if not %equal ( gntwsp );
         @@repl = %trim ( pePgWs );
         @@leng = %len ( %trim ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'GEN0013' :
                          peMsgs : @@repl  : @@leng );
         close gntwsp;
         return *Off;
       endif;

       if not %open( gntwsf );
         open gntwsf;
       endif;

       k1yfil.sfpgws = pePgWs;
       k1yfil.sffilt = peFilt;
       setll %kds( k1yfil ) gntwsf;
       if not %equal ( gntwsf );
         @@repl = %trim ( peFilt );
         @@leng = %len ( %trim ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'GEN0012' :
                          peMsgs : @@repl  : @@leng );
         close gntwsp;
         close gntwsf;
         return *Off;
       endif;

       close gntwsp;
       close gntwsf;
       return *On;

      /end-free

     P SVPWS_chkOrde...
     P                 E


      * ------------------------------------------------------------ *
      * SVPWS_getCant(): Retorna cantidad                            *
      *                                                              *
      *     peCant   (input/output) Cantidad                         *
      * ------------------------------------------------------------ *

     P SVPWS_getCant...
     P                 B                   export
     D SVPWS_getCant...
     D                 pi             2  0
     D peCant                        10i 0 const

       if (( peCant <= *Zeros ) or ( peCant > 99 ));
          return 99;
       else;
          return peCant;
       endif;

     P SVPWS_getCant...
     P                 E
      * ------------------------------------------------------------ *
      * SVPWS_getGrupoRama(): Retorna Grupo para una Rama dada.      *
      *                                                              *
      *     peRama   (input) Rama                                    *
      *                                                              *
      * Retorna Grupo                                                *
      * ------------------------------------------------------------ *

     P SVPWS_getGrupoRama...
     P                 B                   export
     D SVPWS_getGrupoRama...
     D                 pi             1
     D peRama                         2  0 const

       if not %open( set001 );
         open set001;
       endif;

       chain (peRama) set001;

       if not %found(set001);     /// Rama Invalida ///
          return *Blanks;
       else;

          select;

             when t@rama = 17;    /// Embarcaciones ///
                return 'T';

             when t@rama = 18;    /// Mercaderias ///
                return 'M';

             when t@rama = 26;    /// Consorcio ///
                return 'C';

             when t@rama = 27;    /// Combinado Familiar - Hogar ///
                return 'H';

             when t@rama = 28;    /// Comercio ///
                return 'R';

             when t@rame = 4;     /// Automoviles ///
                return 'A';

             when t@rame = 18     /// Vida ///
              or  t@rame = 21;

               if t@Rama = 85;
                 return 'S';      /// Sepelio ///
               else;
                 return 'V';
               endif;

             when t@rame = 8;     /// RC ///
                return 'W';

             when t@rame = 9;     /// Robo //
                return 'X';

             when t@rame = 16;    /// Seguro Técnico //
                return 'Y';

             when t@rame = 15;    /// Riesgos Varios //
                return 'Z';

             other;               /// Restos de Riesgos Varios ///
                return 'O';

          endsl;

       endif;

     P SVPWS_getGrupoRama...
     P                 E

      * ------------------------------------------------------------ *
      * SVPWS_getGrupoRamaArch(): Retorna Grupo de Archivo por Rama  *
      *                                                              *
      *     peRama   (input) Rama                                    *
      *                                                              *
      * Retorna "V"= Vida / "A"= Automovil / "R" = Riesgos Varios /  *
      *         " " = Blanco                                         *
      * ------------------------------------------------------------ *
     P SVPWS_getGrupoRamaArch...
     P                 B                   export
     D SVPWS_getGrupoRamaArch...
     D                 pi             1
     D peRama                         2  0 const

     D Vida            c                   const('V')
     D Transporte      c                   const('A')
     D Riesgos         c                   const('R')

       /free

       Select;
         when SVPWS_getGrupoRama( peRama ) = 'A';
              return Transporte;
         when SVPWS_getGrupoRama( peRama ) = 'V';
              return Vida;
         when SVPWS_getGrupoRama( peRama ) = *blanks;
              return *blanks;
         other;
               return Riesgos;
         endsl;
       /end-free

     P SVPWS_getGrupoRamaArch...
     P                 E
