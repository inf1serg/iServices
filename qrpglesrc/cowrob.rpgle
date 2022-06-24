     H nomain debug(*YES)
      * ************************************************************ *
      * COWROB: Cotización Robo                                      *
      * ------------------------------------------------------------ *
      * Luis Roberto Gómez                   22-May-2019             *
      * ------------------------------------------------------------ *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *>           BNDDIR(HDIILE/HDIBDIR) -             <*           *
      *> TEXT('Prorama de Servicio: Cotización Robo') <*        *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWROB)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWROB)) <*         *
      *> IGN: DLTSPLF FILE(COWROB)                           <*     *
      * ************************************************************ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/cowrob_h.rpgle'

     D Initialized     s              1n
     D wrepl           s          65535a
     D ErrN            s             10i 0
     D ErrM            s             80a

     D WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * COWROB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWROB_inz      B                   export
     D COWROB_inz      pi

      /free

       if (initialized);
          return;
       endif;

       initialized = *ON;
       return;

      /end-free

     P COWROB_inz      E

      * ------------------------------------------------------------ *
      * COWROB_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWROB_End      B                   export
     D COWROB_End      pi

      /free

       //close *all;
       initialized = *OFF;

       return;

      /end-free

     P COWROB_End      E

      * ------------------------------------------------------------ *
      * COWROB_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P COWROB_Error    B                   export
     D COWROB_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P COWROB_Error    E

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
      * COWROB_cotizarWeb:  Cotiza un Bien Asegurado de una Rama de  *
      *                     <<<<<<<<<<<<< ROBO >>>>>>>>>>>>>>>>>>>>  *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        peCfpg (input)  Plan de Pago                          *
      *        peClie (input)  Estructura de Cliente                 *
      *        pePoco (in/ou)  Array de componentes                  *
      *        pePocoC(input)  Cantidad de entradas en pePoco        *
      *        peXrea (input)  Epv                                   *
      *        peImpu (output) Estructura de impuestos total         *
      *        peSuma (output) Suma Asegurada total                  *
      *        pePrim (output) Prima total                           *
      *        pePrem (output) Premio total                          *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWROB_cotizarWeb...
     P                 B                   export
     D COWROB_cotizarWeb...
     D                 pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0 const
     D  peClie                             likeds(ClienteCot_t) const
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0 const
     D  peXrea                        5  2 const
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      /free

       COWROB_inz();

       COWRGV_cotizarWeb2( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : peCfpg
                         : peClie
                         : pePoco
                         : pePocoC
                         : peXrea
                         : peImpu
                         : peSuma
                         : pePrim
                         : pePrem
                         : peCond
                         : peCon1
                         : peErro
                         : peMsgs );

       return;

      /end-free

     P COWROB_cotizarWeb...
     P                 E

      * ------------------------------------------------------------------ *
      * COWROB_chkRenovacion(): Valida campos antes de realizar renovación *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peArcd ( input  )  Código de Articulo                          *
      *     peSpol ( input  )  Número de SuperPoliza                       *
      *     peErro ( output )  Indicador                                   *
      *     peMsgs ( output )  Estructura de Error                         *
      *                                                                    *
      * ------------------------------------------------------------------ *
     P COWROB_chkRenovacion...
     P                 B                    export
     D COWROB_chkRenovacion...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

      /free

       COWROB_inz();

       COWRGV_chkRenovacion( peBase
                           : peArcd
                           : peSpol
                           : peError
                           : peMsgs );

       return;
      /end-free

     P COWROB_chkRenovacion...
     P                 E

