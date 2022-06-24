     H nomain
     H datedit(*DMY/)
     H alwnull(*usrctl)
     H option(*nodebugio : *srcstmt : *noshowcpy : *nounref)
      * ************************************************************ *
      * SVPVLS: Valores del Sistema GAUS                             *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        15-May-2017             *
      *------------------------------------------------------------- *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                           <*   *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                           <*   *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                           <*   *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -             <*   *
      *>           DBGVIEW(&DV)                                 <*   *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                             <*   *
      *>           MODULE(QTEMP/&N) -                           <*   *
      *>           EXPORT(*SRCFILE) -                           <*   *
      *>           SRCFILE(HDIILE/QSRVSRC) -                    <*   *
      *>           BNDDIR(HDIILE/HDIBDIR) -                     <*   *
      *> TEXT('Programa de Servicio: Valores del Sistema GAUS') <*   *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                           <*   *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPVLS))   <*   *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPVLS))        <*   *
      *> IGN: DLTSPLF FILE(SVPVLS)                              <*   *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      *                                                              *
      *                                                              *
      * ************************************************************ *
     Fvalsys    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpvls_h.rpgle'
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SVPVLSC         pr                  ExtPgm( 'SVPVLSC')
     D   peNsys                     312    const
     D   peNivc                    3000    const

     D   @@msgs        ds                  likeds ( paramMsgs )

     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n

     D @PsDs          sds                  qualified
     D  CurUsr                       10a   overlay(@PsDs:358)

     D wrepl           s          65535a

      *--- Definicion de Procedimiento ----------------------------- *

      * -------------------------------------------------------------*
      * SVPVLS_getValSys: Retorna Valor y descripcion del Sistema    *
      *                   GAUS solicitado.                           *
      *                                                              *
      *          peCval   ( input  ) Codigo de Valor                 *
      *          peDval   ( output ) Descripcion de Valor (opcional) *
      *          peVsys   ( output ) Valor del Sistema    (opcional) *
      *                                                              *
      * Retorna *on = Encontro / *off = No encontro                  *
      * -------------------------------------------------------------*
     P SVPVLS_getValSys...
     P                 b                   export
     D SVPVLS_getValSys...
     D                 pi              n
     D   peCval                      10    const
     D   peDval                     512    options(*nopass:*omit)
     D   peVsys                     512    options(*nopass:*omit)

      /free

       SVPVLS_INZ();

       chain(n) peCval valsys;
       if %found( valsys );
         if %parms >= 2 and %addr( peDval ) <> *NULL;
           peDval = v0dval;
         endif;
         if %parms >= 3 and %addr( peVsys ) <> *NULL;
           if %trim(v0vsys) = *blanks;
             return *off;
           endif;
           peVsys = v0vsys;
         endif;

         return *on;
       endif;

       return *off;
      /end-free
     P SVPVLS_getValSys...
     P                 e

      * -------------------------------------------------------------*
      * SVPVLS_chkValSys: Valida existencia de codigo de Valor del   *
      *                   sistema GAUS.                              *
      *                                                              *
      *          peCval   ( input  ) Codigo de Valor                 *
      *                                                              *
      * Retorna *on = Encontro / *off = No encontro                  *
      * -------------------------------------------------------------*
     P SVPVLS_chkValSys...
     P                 b                   export
     D SVPVLS_chkValSys...
     D                 pi              n
     D   peCval                      10    const

      /free

       SVPVLS_INZ();

       return SVPVLS_getValSys( peCval );

      /end-free
     P SVPVLS_chkValSys...
     P                 e

      * -------------------------------------------------------------*
      * SVPVLS_updValSys: Actualiza valores del Sistema GAUS.        *
      *                                                              *
      *          peCval   ( input ) Codigo de Valor                  *
      *          peDval   ( input ) Descripcion de Valor             *
      *          peVsys   ( input ) Valor del Sistema                *
      *                                                              *
      * Retorna *on = Actualizo / *off = No Actualizo.               *
      * -------------------------------------------------------------*
     P SVPVLS_updValSys...
     P                 b                   export
     D SVPVLS_updValSys...
     D                 pi              n
     D   peCval                      10    const
     D   peDval                     512
     D   peVsys                     512

     D   @@dvalA       s            512
     D   @@vsysA       s            512

      /free

       SVPVLS_INZ();

       clear  @@dvalA;
       clear  @@vsysA;
       clear  @@msgs;

       chain peCval valsys;
       if %found( valsys );
         if v0dval <> peDval or
            v0vsys <> peVsys;
          //guarda en variables anteriores...
            @@dvalA = peDval;
            @@vsysA = v0vsys;

          //mueve nuevo...
            v0dval = peDval;
            v0vsys = peVsys;

            update v1lsys;

          //Audita cambios...
            %subst(wrepl:  1  : 10)  = %trim(peCval);
            %subst(wrepl: 11  : 15)  = %trim(@@vsysA);
            %subst(wrepl: 26  : 15)  = %trim(pevsys);
            %subst(wrepl: 41  : 10)  = %trim(@PsDs.CurUsr) ;

            SVPWS_getMsgs( '*LIBL'
                         : 'VALMSG'
                         : 'VLS0002'
                         : @@msgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );
             SVPVLSC( @@msgs.peMsg1
                    : @@msgs.peMsg2 );
         endif;
         return *on;
       endif;

       return *off;

      /end-free
     P SVPVLS_updValSys...
     P                 e
      * -------------------------------------------------------------*
      * SVPVLS_setValSys: Graba nuevo valor del Sistema GAUS.        *
      *                                                              *
      *          peCval   ( input ) Codigo de Valor                  *
      *          peDval   ( input ) Descripcion de Valor             *
      *          peVsys   ( input ) Valor del Sistema                *
      *                                                              *
      * Retorna *on = Grabo OK / *off = No Grabo.                    *
      * -------------------------------------------------------------*
     P SVPVLS_setValSys...
     P                 b                   export
     D SVPVLS_setValSys...
     D                 pi              n
     D   peCval                      10    const
     D   peDval                     512    const
     D   peVsys                     512    const
      /free

       SVPVLS_INZ();
       clear  @@msgs;

       chain peCval valsys;
       if not %found( valsys );
         v0cval = peCval;
         v0dval = peDval;
         v0vsys = peVsys;

         write v1lsys;

        //Audita cambios...
          %subst(wrepl:  1  : 10)  = %trim(v0cval);
          %subst(wrepl: 11  : 30)  = %trim(v0dval);
          %subst(wrepl: 41  : 15)  = %trim(v0vsys);
          %subst(wrepl: 56  : 10)  = %trim(@PsDs.CurUsr) ;

          SVPWS_getMsgs( '*LIBL'
                       : 'VALMSG'
                       : 'VLS0001'
                       : @@msgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
           SVPVLSC( @@msgs.peMsg1
                  : @@msgs.peMsg2 );
         return *on;
       endif;

       return *off;

      /end-free
     P SVPVLS_setValSys...
     P                 e
      * -------------------------------------------------------------*
      * SVPVLS_dltValSys: Elimina valores del Sistema GAUS.          *
      *                                                              *
      *          peCval   ( input ) Codigo de Valor                  *
      *                                                              *
      * Retorna *on = Elimino / *off = No Elimino.                   *
      * -------------------------------------------------------------*
     P SVPVLS_dltValSys...
     P                 b                   export
     D SVPVLS_dltValSys...
     D                 pi              n
     D   peCval                      10    const
      /free

       SVPVLS_INZ();

       clear @@msgs;
       chain peCval valsys;
       if %found( valsys );
        //Audita cambios...
          %subst(wrepl:  1  : 10)  = %trim(v0cval);
          %subst(wrepl: 11  : 30)  = %trim(v0dval);
          %subst(wrepl: 41  : 15)  = %trim(v0vsys);
          %subst(wrepl: 56  : 10)  = %trim(@PsDs.CurUsr) ;

          SVPWS_getMsgs( '*LIBL'
                       : 'VALMSG'
                       : 'VLS0003'
                       : @@msgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
           SVPVLSC( @@msgs.peMsg1
                  : @@msgs.peMsg2 );
         delete v1lsys;
         return *on;
       endif;

       return *off;

      /end-free
     P SVPVLS_dltValSys...
     P                 e
      * ------------------------------------------------------------ *
      * SVPVLS_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPVLS_inz      B
     D SVPVLS_inz      pi

      /free

       if not %open(valsys);
         open valsys;
       endif;

       if (initialized);
          return;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPVLS_inz      E

      * ------------------------------------------------------------ *
      * SVPVLS_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPVLS_End      B                   export
     D SVPVLS_End      pi

      /free

       close(E) *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPVLS_End      E

      * ------------------------------------------------------------ *
      * SVPVLS_Error(): Retorna el último error del servicio.        *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPVLS_Error    B
     D SVPVLS_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPVLS_Error    E

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

