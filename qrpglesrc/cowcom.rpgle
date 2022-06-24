     H nomain debug(*YES)
      * ************************************************************ *
      * COWCOM: Cotización Comercio                                  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                    *16-Abr-2020             *
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
      *> TEXT('Prorama de Servicio: Cotización Comercio') <*        *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWCOM)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWCOM)) <*         *
      *> IGN: DLTSPLF FILE(COWCOM)                           <*     *
      * ************************************************************ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/cowcom_h.rpgle'

     D Initialized     s              1n
     D wrepl           s          65535a
     D ErrN            s             10i 0
     D ErrM            s             80a

     D WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * COWCOM_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWCOM_inz      B                   export
     D COWCOM_inz      pi

      /free

       if (initialized);
          return;
       endif;

       initialized = *ON;
       return;

      /end-free

     P COWCOM_inz      E

      * ------------------------------------------------------------ *
      * COWCOM_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWCOM_End      B                   export
     D COWCOM_End      pi

      /free

       //close *all;
       initialized = *OFF;

       return;

      /end-free

     P COWCOM_End      E

      * ------------------------------------------------------------ *
      * COWCOM_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P COWCOM_Error    B                   export
     D COWCOM_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P COWCOM_Error    E

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
      * COWCOM_cotizarWeb:  Cotiza un Bien Asegurado de una Rama de  *
      *                     <<<<<<<<< COMERCIO >>>>>>>>>>>>>>>>>>>>  *
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
     P COWCOM_cotizarWeb...
     P                 B                   export
     D COWCOM_cotizarWeb...
     D                 pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0 const
     D  peClie                             likeds(ClienteCot_t) const
     D  pePoco                             likeds(UbicPoc2_t) dim(10)
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

     D  pxPoco         ds                  likeds(UbicPoc_t) dim(10)

     D @@arcd          s              6  0
     D x               s             10i 0
     D SVPVAL_errm     s             80a
     D peEnbr          s             10i 0
     D reaseg          s              1n
     D cuit            s             11a

      /free

       COWCOM_inz();

       if peClie.civa = 5;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0160'
                       : peMsgs    );
          peErro = -1;
          return;
       endif;

       cuit = peClie.cuit;
       for x = 1 to %len(cuit);
           if %subst(cuit:x:1) <> '0' and
              %subst(cuit:x:1) <> '1' and
              %subst(cuit:x:1) <> '2' and
              %subst(cuit:x:1) <> '3' and
              %subst(cuit:x:1) <> '4' and
              %subst(cuit:x:1) <> '5' and
              %subst(cuit:x:1) <> '6' and
              %subst(cuit:x:1) <> '7' and
              %subst(cuit:x:1) <> '8' and
              %subst(cuit:x:1) <> '9';
              %subst(cuit:x:1) = '0';
           endif;
       endfor;
       if cuit = *all'0';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0161'
                       : peMsgs    );
          peErro = -1;
          return;
       endif;

       for x = 1 to pePocoC;
           pePoco(x).cta1 = %scanrpl( '-' : ' ' : pePoco(x).cta1 );
           pePoco(x).cta2 = %scanrpl( '-' : ' ' : pePoco(x).cta2 );
       endfor;

       eval-corr pxPoco = pePoco;

       COWRGV_cotizarWeb2( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : peCfpg
                         : peClie
                         : pxPoco
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

       eval-corr pePoco = pxPoco;

       //
       // Si no hubo errores, entramos ahora a las validaciones
       // propias de Comercio
       //
       if peErro = 0;

          @@arcd = COWGRAI_getArticulo( peBase : peNctw );

          for x = 1 to pePocoC;

              //
              // Actividad existe en SET101
              //
              if not SVPVAL_chkCapituloTarifaWeb( peRama
                                                : pePoco(x).ctar
                                                : pePoco(x).cta1
                                                : pePoco(x).cta2 );
                 SVPVAL_errm = SVPVAL_error( peEnbr );
                 select;
                  when peEnbr = SVPVAL_CTANE;
                       SVPWS_getMsgs( '*LIBL'
                                    : 'WSVMSG'
                                    : 'COW0162'
                                    : peMsgs    );
                  when peEnbr = SVPVAL_CTANW;
                       SVPWS_getMsgs( '*LIBL'
                                    : 'WSVMSG'
                                    : 'COW0163'
                                    : peMsgs    );
                 endsl;
                 peErro = -1;
                 return;
              endif;

              //
              // Actividad está relacionada con el artículo
              //
              if not SVPVAL_chkCapituloTarifaArticulo( @@arcd
                                                     : peRama
                                                     : peArse
                                                     : pePoco(x).ctar
                                                     : pePoco(x).cta1
                                                     : pePoco(x).cta2 );
                 SVPWS_getMsgs( '*LIBL'
                              : 'WSVMSG'
                              : 'COW0164'
                              : peMsgs    );
                 peErro = -1;
                 return;
              endif;

              //
              // El plan debe estar asociado a la actividad
              //
              if not SVPVAL_chkCapituloTarifaPlan( peRama
                                                 : pePoco(x).ctar
                                                 : pePoco(x).cta1
                                                 : pePoco(x).cta2
                                                 : pePoco(x).xpro );
                 SVPWS_getMsgs( '*LIBL'
                              : 'WSVMSG'
                              : 'COW0165'
                              : peMsgs    );
                 peErro = -1;
                 return;
              endif;

              //
              // Actualizar Datos de reaseguro
              //
              reaseg = COWRGV_updDatosReaseguro( peBase
                                               : peNctw
                                               : peRama
                                               : peArse
                                               : pePoco(x).poco
                                               : pePoco(x).ctar
                                               : pePoco(x).cta1
                                               : pePoco(x).cta2
                                               : *omit
                                               : *omit          );

              //
              // Inspeccion
              //
              if COWRGV_setRequiereInspeccion2( peBase
                                              : peNctw
                                              : peRama
                                              : peArse
                                              : pePoco(x) );
                 pePoco(x).insp = 'S';
               else;
                 pePoco(x).insp = 'N';
              endif;

          endfor;

       endif;

       return;

      /end-free

     P COWCOM_cotizarWeb...
     P                 E

      * ------------------------------------------------------------------ *
      * COWCOM_chkRenovacion(): Valida campos antes de realizar renovación *
      *                                                                    *
      *     peBase ( input  )  Parametros Base                             *
      *     peArcd ( input  )  Código de Articulo                          *
      *     peSpol ( input  )  Número de SuperPoliza                       *
      *     peErro ( output )  Indicador                                   *
      *     peMsgs ( output )  Estructura de Error                         *
      *                                                                    *
      * ------------------------------------------------------------------ *
     P COWCOM_chkRenovacion...
     P                 B                    export
     D COWCOM_chkRenovacion...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peError                     10i 0
     D   peMsgs                            likeds(paramMsgs)

      /free

       COWCOM_inz();

       COWRGV_chkRenovacion( peBase
                           : peArcd
                           : peSpol
                           : peError
                           : peMsgs );

       return;
      /end-free

     P COWCOM_chkRenovacion...
     P                 E

