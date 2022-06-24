     H nomain
      * ************************************************************ *
      * SPVBON: Programa de Servicio.                                *
      *         Validación de Bonificaciones                         *
      * ------------------------------------------------------------ *
      * Mónica Alonso                        25-Jul-2013             *
      * ************************************************************ *
     Fset250    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
     D/copy './qcpybooks/spvbon_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D ErrCode         s             10i 0
     D ErrText         s             80a

      *--- Initialized --------------------------------------------- *
     D Initialized     s              1N   inz(*OFF)

      *--- PR Externos --------------------------------------------- *
     D PAR310X3        pr                  extpgm('PAR310X3')
     D    Empr                        1    const
     D    @aÑo                        4  0
     D    @mes                        2  0
     D    @dia                        2  0

      *--- Definición de Procedimientos----------------------------- *

      * ------------------------------------------------------------ *
      * SPVbon_CheckBonCod(): Chequea Código de Bonificación          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peRama   (input)   Código Rama                           *
      *     peBonCod (input)   Código Bonificación                   *
      *     peBonPor (input)   Porcentaje de Bonificación            *
      *     peFecha  (input)   Fecha                                 *
      *     peMarc   (input)   Marca de Nivel                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVBON_CheckBonCod...
     P                 B                   export
     D SPVBON_CheckBonCod...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peBonCod                     3  0 const
     D   peBonPor                     5  2 const
     D   peFecha                      8  0 options(*nopass:*omit)
     D   peMarc                       1    options(*nopass:*omit)
      *                                                              *
     D k1s250          ds                  likerec(s1t250:*key)
      *
     D @aÑo            s              4  0
     D @mes            s              2  0
     D @dia            s              2  0
     D fecha           s              8  0
     D Marca           s              1

      /free

       SPVBON_Inz();

       if %parms >= 8 and %addr(peMarc) <> *null;
         Marca = peMarc;
       else;
         Marca = 'C';
       endif;

       //Valida que exista el código de Bonificación en tabla SET250
       if not SPVBON_CheckBon( peEmpr
                             : peSucu
                             : peArcd
                             : peRama
                             : peBonCod
                             : Marca );
         SetError( SPVBON_BCDNF
                 : 'Código Bonificacion Inexistente');
         Initialized = *OFF;
         return *off;
       endif;

       //Valida que vigencia bonificación este dentro de lo permitido
       if %parms >= 7 and %addr(peFecha) <> *null;
       //Valida que el porcentaje bonificación este dentro de lo permitido
         fecha = pefecha;
       else;
         PAR310X3( peEmpr
               : @aÑo
               : @mes
               : @dia );
         fecha = @aÑo * 10000 + @mes * 100 + @dia;
       endif;

       if not SPVBON_CheckVigPor( peEmpr
                                : peSucu
                                : peArcd
                                : peRama
                                : peBonCod
                                : fecha  );
         SetError( SPVBON_BFEIV
                 : 'Cod.Bonificacion fuera de Vigencia' );
         Initialized = *OFF;
         return *off;
       endif;

       //Valida que % bonificación este dentro de lo valores permitido
       if peBonPor <> Stpcbp and (peBonPor < STEPPD or peBonPor > STEPPH);
         SetError( SPVBON_BPRIV
                 : '% Bonificacion fuera de valores permitidos' );
         Initialized = *OFF;
         return *off;
       endif;

       // sin errores
       Initialized = *OFF;
       return *ON;

      /end-free

     P SPVBON_CheckBonCod...
     P                 E

      * ------------------------------------------------------------ *
      * SPVBON_CheckBon(): Chequea Codigo de Bonificación            **
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peRama   (input)   Código Rama                           *
      *     peBonCod (input)   Código Bonificación                   *
      *     peMarc   (input)   Marca de Nivel                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVBON_CheckBon...
     P                 B                   export
     D SPVBON_CheckBon...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peBonCod                     3  0 const
     D   peMarc                       1    options(*nopass:*omit)
      *                                                              *
     D k1s250          ds                  likerec(s1t250:*key)
      *                                                              *
     D Marca           s              1

      /free

       SPVBON_Inz();
       if %parms >= 6 and %addr(peMarc) <> *null;
         Marca = peMarc;
       else;
         Marca = 'C';
       endif;

       //Valida que exista el código de Bonificación en tabla SET250
       k1s250.stEmpr = peEmpr;
       k1s250.stSucu = peSucu;
       k1s250.stArcd = peArcd;
       k1s250.stRama = peRama;
       k1s250.stCcbp = peBonCod;
       k1s250.stMar1 = Marca;
       chain %kds(k1s250) set250;

       if not %found;
         SetError( SPVBON_BCDNF
                 : 'Código Bonificacion Inexistente');
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *ON;

      /end-free

     P SPVBON_CheckBon...
     P                 E

      * ------------------------------------------------------------ *
      * SPVBON_CheckVigPor():Chequea Vigencia de Bonificacion y %    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peRama   (input)   Código Rama                           *
      *     peBonCod (input)   Código Bonificación                   *
      *     peFecha  (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVBON_CheckVigPor...
     P                 B                   export
     D SPVBON_CheckVigPor...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peBonCod                     3  0 const
     D   peFecha                      8  0 options(*nopass:*omit)
      *                                                              *
     D k1s250          ds                  likerec(s1t250:*key)
      *
     D @aÑo            s              4  0
     D @mes            s              2  0
     D @dia            s              2  0
     D fecha           s              8  0

      /free

       SPVBON_Inz();

       //Valida que exista el código de Bonificación en tabla SET250
       if not SPVBON_CheckBon( peEmpr
                             : peSucu
                             : peArcd
                             : peRama
                             : peBonCod );
         SetError( SPVBON_BCDNF
                 : 'Código Bonificacion Inexistente');
         Initialized = *OFF;
         return *off;
       endif;

       //Valida que vigencia bonificación este dentro de lo permitido
       if %parms >= 6 and %addr(peFecha) <> *null;
       //Valida que el porcentaje bonificación este dentro de lo permitido
         fecha = pefecha;
       else;
         PAR310X3( peEmpr
               : @aÑo
               : @mes
               : @dia );
         fecha = @aÑo * 10000 + @mes * 100 + @dia;
       endif;

       if fecha < STFCBP or (STFFBP <> *zero and fecha > STFFBP);
         SetError( SPVBON_BFEIV
                 : 'Cod.Bonificacion fuera de Vigencia' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *ON;

      /end-free

     P SPVBON_CheckVigPor...
     P                 E

      * ------------------------------------------------------------ *
      * SPVBON_CheckPor():Chequea Porcentaje Dentro de lo Permitido  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peRama   (input)   Código Rama                           *
      *     peBonCod (input)   Código Bonificación                   *
      *     peBonPor (input)   Porcentaje de Bonificación            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SPVBON_CheckPor...
     P                 B                   export
     D SPVBON_CheckPor...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peBonCod                     3  0 const
     D   peBonPor                     5  2 const
      *                                                              *
     D k1s250          ds                  likerec(s1t250:*key)
      *

      /free

       SPVBON_Inz();

       //Valida que exista el código de Bonificación en tabla SET250
       if not SPVBON_CheckBon( peEmpr
                             : peSucu
                             : peArcd
                             : peRama
                             : peBonCod );
         SetError( SPVBON_BCDNF
                 : 'Código Bonificacion Inexistente');
         Initialized = *OFF;
         return *off;
       endif;

       //Valida que % bonificación este dentro de lo valores permitido
       if peBonPor <> Stpcbp and (peBonPor < STEPPD or peBonPor > STEPPH);
         SetError( SPVBON_BPRIV
                 : '% Bonificacion fuera de valores permitidos' );
         Initialized = *OFF;
         return *off;
       endif;

       Initialized = *OFF;
       return *ON;

      /end-free

     P SPVBON_CheckPor...
     P                 E

      * ------------------------------------------------------------ *
      * SPVBON_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVBON_inz      B                   export
     D SPVBON_inz      pi

      /free

       monitor;
         if (Initialized);
           return;
         endif;

         open set250;

         Initialized = *ON;
         return;
         on-error;
         Initialized = *OFF;
       endmon;

       /end-free

     P SPVBON_inz      E

      * ------------------------------------------------------------ *
      * SPVBON_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SPVBON_End      B                   export
     D SPVBON_End      pi

      /free

        close *all;

      /end-free

     P SPVBON_End      E

      * ------------------------------------------------------------ *
      * SPVBON_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SPVBON_Error    B                   export
     D SPVBON_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrCode;
       endif;

       return ErrText;

      /end-free

     P SPVBON_Error    E

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
