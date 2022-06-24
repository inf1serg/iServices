     H nomain
      * ************************************************************ *
      * SVPSSN: Programa de Servicio.                                *
      *         Tablas SSN                                           *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                  ** 10-Dic-2019 **          *
      * ************************************************************ *
      *                                                              *
      * ************************************************************ *
     Fssnf13    if   e           k disk    usropn
     Fssnf15    if   e           k disk    usropn
     Fgntpro    if   e           k disk    usropn
     Fsupmon    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpssn_h.rpgle'

      * ------------------------------------------------------------ *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D ErrCode         s             10i 0
     D ErrText         s             80a

     D Initialized     s              1N

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)


      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPSSN_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPSSN_inz      B                   export
     D SVPSSN_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(ssnf13);
         open ssnf13;
       endif;

       if not %open(ssnf15);
         open ssnf15;
       endif;

       if not %open(gntpro);
         open gntpro;
       endif;

       if not %open(supmon);
         open supmon;
       endif;

       initialized = *ON;

       return;

      /end-free

     P SVPSSN_inz      E

      * ------------------------------------------------------------ *
      * SVPSSN_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPSSN_End      B                   export
     D SVPSSN_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPSSN_End      E

      * ------------------------------------------------------------ *
      * SVPSSN_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPSSN_Error    B                   export
     D SVPSSN_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPSSN_Error    E

      * ------------------------------------------------------------- *
      * SVPSSN_getRamo(): Retorna Ramo.                               *
      *                                                               *
      *     peRama   ( input  ) Código de Rama                        *
      *                                                               *
      * Retorna: Ramo / *blanks                                       *
      * ------------------------------------------------------------- *
     P SVPSSN_getRamo...
     P                 b                   export
     D SVPSSN_getRamo...
     D                 pi             4
     D   peRama                       2  0 const

      /free

       SVPSSN_inz();

       chain(n) peRama ssnf13;
       if %found( ssnf13 );
          return s1Ramo;
       endif;

       return *blanks;

      /end-free

     P SVPSSN_getRamo...
     P                 e

      * ------------------------------------------------------------- *
      * SVPSSN_getSubramo(): Retorna Subramo.                         *
      *                                                               *
      *     peRama   ( input  ) Código de Rama                        *
      *                                                               *
      * Retorna: Subramo / *blanks                                    *
      * ------------------------------------------------------------- *
     P SVPSSN_getSubramo...
     P                 b                   export
     D SVPSSN_getSubramo...
     D                 pi             6
     D   peRama                       2  0 const

      /free

       SVPSSN_inz();

       chain(n) peRama ssnf13;
       if %found( ssnf13 );
          return s1Subr;
       endif;

       return *blanks;

      /end-free

     P SVPSSN_getSubramo...
     P                 e

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

     P SetError...
     P                 E

      * ------------------------------------------------------------- *
      * SVPSSN_getProvincia(): Retorna Codigo de Provincia SSN        *
      *                                                               *
      *     peProc   ( input  ) Código de Provincia.                  *
      *                                                               *
      * Retorna: Provincia SSN / *zeros                               *
      * ------------------------------------------------------------- *
     P SVPSSN_getProvincia...
     P                 b                   export
     D SVPSSN_getProvincia...
     D                 pi             2  0
     D   peProc                       3    const

      /free

       SVPSSN_inz();

       chain(n) peProc gntpro;
       if %found( gntpro );
          return prRpr1;
       endif;

       return *zeros;

      /end-free

     P SVPSSN_getProvincia...
     P                 e

      * ------------------------------------------------------------- *
      * SVPSSN_getMoneda(): Retorna Moneda.                           *
      *                                                               *
      *     peMone   ( input  ) Código de Moneda                      *
      *                                                               *
      * Retorna: Moneda SSN / *blanks                                 *
      * ------------------------------------------------------------- *
     P SVPSSN_getMoneda...
     P                 b                   export
     D SVPSSN_getMoneda...
     D                 pi             2
     D   peMone                       2    const

      /free

       SVPSSN_inz();

       chain(n) peMone supmon;
       if %found( supmon );
         return suCosu;
       endif;

       return *blanks;

      /end-free

     P SVPSSN_getMoneda...
     P                 e

