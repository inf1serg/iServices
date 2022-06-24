     H nomain
      * ************************************************************ *
      * SVPIND: Programa de Servicio.                                *
      *         Indices                                              *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        19-Jun-2019             *
      * ************************************************************ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fgntind    if   e           k disk    usropn
     Fgnhvin    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpind_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D setError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a
      * --------------------------------------------------- *
     D Initialized     s              1N

      *--- PR Externos --------------------------------------------- *

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPIND_chkIndice():  Valida Codigo de Indice                 *
      *                                                              *
      *     peIndi   (input)   Codigo de Indice                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPIND_chkIndice...
     P                 B                   export
     D SVPIND_chkIndice...
     D                 pi              n
     D   peIndi                       2    const

      /free

       SVPIND_inz();

       chain peIndi gnhvin;

       if not %found;
         setError( SVPIND_ININE
                 : 'Codigo de Indice Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPIND_chkIndice...
     P                 E

      * ------------------------------------------------------------ *
      * SVPIND_getIndice()     : Obtiene Indice - Descripcion y      *
      *                          Marcas.                             *
      *                                                              *
      *     peIndi   (input)   Codigo de Indice                      *
      *     peNinl   (output)  Descripción Indice                    *
      *     peNinc   (output)  Descripción Indice Abreviado          *
      *     peBloq   (output)  Código de Bloqueo                     *
      *     peMar1   (output)  Obliqatorio para Reserva              *
      *                                                              *
      * Retorna: Cantidad de Digitos / 0 En caso de Error            *
      * ------------------------------------------------------------ *

     P SVPIND_getIndice...
     P                 B                   export
     D SVPIND_getIndice...
     D                 pi              n
     D   peIndi                       2    const
     D   peNinl                      30
     D   peNinc                       5
     D   peBloq                       1
     D   peMar1                       1

      /free

       SVPIND_inz();

       chain peIndi gntind;
       if not %found;
         setError( SVPIND_ININE
                 : 'Codigo de Indice Inexistente' );
           return *off ;
       endif;

         peNinl =  inninl ;
         peNinc =  inninc ;
         peBloq =  inbloq ;
         peMar1 =  inmar1 ;

           return *on;

      /end-free

     P SVPIND_getIndice...
     P                 E

      * ------------------------------------------------------------ *
      * SVPIND_getCoefIndice(): Obtiene Coeficiente de Indice        *
      *                                                              *
      *                                                              *
      *     peIndi   (input)   Codigo de Indice                      *
      *     peFina   (input)   Fecha Año Indice                      *
      *     peFinm   (input)   Fecha Mes Indice                      *
      *     peVain   (output)  Valor Coeficiente Indice              *
      *                                                              *
      * Retorna:  / 0 En caso de Error                               *
      * ------------------------------------------------------------ *

     P SVPIND_getCoefIndice...
     P                 B                   export
     D SVPIND_getCoefIndice...
     D                 pi              n
     D   peIndi                       2    Const
     D   peFina                       4  0 Const
     D   peFinm                       2  0 Const
     D   peVain                      15  6

     D k1yvin          ds                  likerec(g1hvin:*key)

      /free

       SVPIND_inz();

       k1yvin.viindi = peIndi;
       k1yvin.vifina = peFina;
       k1yvin.vifinm = peFinm;
       chain %kds(k1yvin) gnhvin;
       if %found;
         peVain = vivain;
           return *on;
       endif;

         peVain = 1;
         return *off;

      /end-free

     P SVPIND_getCoefIndice...
     P                 E

      * ------------------------------------------------------------ *
      * SVPIND_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPIND_inz      B                   export
     D SVPIND_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(gntind);
         open gntind;
       endif;

       if not %open(gnhvin);
         open gnhvin;
       endif;



       initialized = *ON;

       return;
      /end-free

     P SVPIND_inz      E

      * ------------------------------------------------------------ *
      * SVPIND_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPIND_end      B                   export
     D SVPIND_end      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPIND_end      E

      * ------------------------------------------------------------ *
      * SVPIND_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPIND_error    B                   export
     D SVPIND_error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPIND_error    E

      * ------------------------------------------------------------ *
      * setError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P setError        B
     D setError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P setError...
     P                 E

