     H nomain
      * ************************************************************ *
      * REASEGU:  Service Program                                    *
      *           Tareas generales de reaseguro                      *
      * -----------------------------------------------------------  *
      * Sergio Fernandez                 *05-Dic-2014                *
      * ************************************************************ *
     Fset80405  if   e           k disk    usropn
     Fset831    if   e           k disk    usropn
     Fset832    if   e           k disk    usropn
     Fset14101  if   e           k disk    usropn

      /copy './qcpybooks/reasegu_h.rpgle'

     D Initialized     s              1N

      * ------------------------------------------------------------ *
      * REASEGU_Inz(): Incialización del módulo.                     *
      *                                                              *
      * retorna: void.                                               *
      * ------------------------------------------------------------ *
     P REASEGU_Inz     B                   EXPORT
     D REASEGU_Inz     pi

      /free

       if (Initialized);
         return;
       endif;

       if not %open(set80405);
          open set80405;
       endif;
       if not %open(set14101);
          open set14101;
       endif;
       if not %open(set831);
          open set831;
       endif;
       if not %open(set832);
          open set832;
       endif;

       Initialized = *ON;

      /end-free

     P REASEGU_Inz     E

      * ------------------------------------------------------------ *
      * getLstCont():  Obtiene contrato vigente a una fecha.         *
      *                                                              *
      * NOTA: Si bien la estructura de GAUS soporta contratos distin-*
      *       tos por Rama, en la práctica siempre se usa el mismo   *
      *       nro para todas las ramas.                              *
      *       En caso de querer el contrato por Rama, se debe usar   *
      *       el getLstConRam().                                     *
      *                                                              *
      *   peEmpr        (input)     Empresa                          *
      *   peSucu        (input)     Sucursal                         *
      *   peNrcr        (output)    Número de Contrato               *
      *   peFech (opc)  (input)     Fecha (*nopass = hoy) aaaammdd   *
      *   peNcor (opc)  (output)    Número de Cía Reaseguradora      *
      *   peFdes (opc)  (output)    Fecha Desde (*iso)               *
      *   peFhas (opc)  (output)    Fecha Hasta (*iso)               *
      *                                                              *
      * retorna: *on si encontró, *off si no.                        *
      * ------------------------------------------------------------ *
     P REASEGU_getLstCont...
     P                 B                   export
     D REASEGU_getLstCont...
     D                 pi             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNrcr                       5  0
     D   peFech                       8  0 options(*nopass:*omit) const
     D   peNcor                       5  0 options(*nopass:*omit)
     D   peFdes                      10d   options(*nopass:*omit)
     D   peFhas                      10d   options(*nopass:*omit)

     D @Fech           s              8  0
     D @Ncor           s              5  0
     D @Fdes           s             10d
     D @Fhas           s             10d
     D hay             s              1N
     D k1t804          ds                  likerec(s1t80405:*key)

      /free

       REASEGU_Inz();

       if %parms >= 4 and %addr(peFech) <> *NULL;
          @Fech = peFech;
        else;
          @Fech = (*year * 10000)
                + (*month * 100)
                +  *day;
       endif;

       hay = *OFF;
       k1t804.t@empr = peEmpr;
       k1t804.t@sucu = peSucu;
       setll %kds(k1t804:2) set80405;
       reade %kds(k1t804:2) set80405;
       dow not %eof;
        if t@ficf <= @Fech and t@fvcf >= @Fech;
           hay = *ON;
           leave;
        endif;
        reade %kds(k1t804:2) set80405;
       enddo;

       if not hay;
          return *OFF;
       endif;

       peNrcr = t@nrcr;

       if (%parms >= 5 and %addr(peNcor) <> *NULL);
          peNcor = t@ncor;
       endif;

       if (%parms >= 6 and %addr(peFdes) <> *NULL);
          monitor;
            peFdes = %date(t@ficf:*iso);
           on-error;
            return *OFF;
          endmon;
       endif;

       if (%parms >= 7 and %addr(peFhas) <> *NULL);
          monitor;
            peFhas = %date(t@fvcf:*iso);
           on-error;
            return *OFF;
          endmon;
       endif;

       return *ON;

      /end-free

     P                 E

      * ------------------------------------------------------------ *
      * getLstContRam(): Obtiene contrato vigente a una fecha por    *
      *                  Rama.                                       *
      *                                                              *
      *   peEmpr        (input)     Empresa                          *
      *   peSucu        (input)     Sucursal                         *
      *   peRama        (input)     Rama                             *
      *   peNrcr        (output)    Número de Contrato               *
      *   peFech (opc)  (input)     Fecha (aaaammdd) *nopass = HOY   *
      *   peNcor (opc)  (output)    Número de Cía Reaseguradora      *
      *   peFdes (opc)  (output)    Fecha Desde (*iso)               *
      *   peFhas (opc)  (output)    Fecha Hasta (*iso)               *
      *                                                              *
      * retorna: *on si encontró, *off si no.                        *
      * ------------------------------------------------------------ *
     P REASEGU_getLstContRam...
     P                 B                   export
     D REASEGU_getLstContRam...
     D                 pi             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peRama                       2  0 const
     D   peNrcr                       5  0
     D   peFech                       8  0 options(*nopass:*omit) const
     D   peNcor                       5  0 options(*nopass:*omit)
     D   peFdes                      10d   options(*nopass:*omit)
     D   peFhas                      10d   options(*nopass:*omit)

     D @Fech           s              8  0
     D @Ncor           s              5  0
     D @Fdes           s             10d
     D @Fhas           s             10d
     D hay             s              1N
     D k1t804          ds                  likerec(s1t80405:*key)

      /free

       REASEGU_Inz();

       if %parms >= 5 and %addr(peFech) <> *NULL;
          @Fech = peFech;
        else;
          @Fech = (*year * 10000)
                + (*month * 100)
                +  *day;
       endif;

       hay = *OFF;
       k1t804.t@empr = peEmpr;
       k1t804.t@sucu = peSucu;
       k1t804.t@rama = peRama;
       setll %kds(k1t804:3) set80405;
       reade %kds(k1t804:3) set80405;
       dow not %eof;
        if t@ficf <= @Fech and t@fvcf >= @Fech;
           hay = *ON;
           leave;
        endif;
        reade %kds(k1t804:3) set80405;
       enddo;

       if not hay;
          return *OFF;
       endif;

       peNrcr = t@nrcr;

       if (%parms >= 6 and %addr(peNcor) <> *NULL);
          peNcor = t@ncor;
       endif;

       if (%parms >= 7 and %addr(peFdes) <> *NULL);
          monitor;
            peFdes = %date(t@ficf:*iso);
           on-error;
            return *OFF;
          endmon;
       endif;

       if (%parms >= 8 and %addr(peFhas) <> *NULL);
          monitor;
            peFhas = %date(t@fvcf:*iso);
           on-error;
            return *OFF;
          endmon;
       endif;

       return *ON;

      /end-free

     P                 E

      * ------------------------------------------------------------ *
      * getCiaDesc(): Recupera descripción de compañía reaseguradora *
      *                                                              *
      *   peEmpr        (input)     Empresa                          *
      *   peSucu        (input)     Sucursal                         *
      *   peNcor        (input)     Compañia                         *
      *   peNcia        (output)    Decripción de Cía                *
      *   peNrdf (opc)  (output)    Número de DAF de la cía          *
      *                                                              *
      * retorna: *on si encontró, *off si no.                        *
      * ------------------------------------------------------------ *
     P REASEGU_getCiaDesc...
     P                 B                   EXPORT
     D REASEGU_getCiaDesc...
     D                 pi             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNcor                       5  0 const
     D   peNcia                      40a
     D   peNrdf                       7  0 options(*nopass:*omit)

     D k1t141          ds                  likerec(s1t14101:*key)

      /free

       REASEGU_Inz();

       k1t141.t@empr = peEmpr;
       k1t141.t@sucu = peSucu;
       k1t141.t@ncor = peNcor;
       chain %kds(k1t141:3) set14101;
       if not %found;
          return *OFF;
       endif;

       peNcia = dfnomb;
       if %parms >= 5 and %addr(peNrdf) <> *NULL;
          peNrdf = t@nrdf;
       endif;
       return *ON;

      /end-free

     P                 E

      * ------------------------------------------------------------ *
      * getDescClf(): Recupera descripción de Clasificación de riesgo*
      *                                                              *
      *   peEmpr        (input)     Empresa                          *
      *   peSucu        (input)     Sucursal                         *
      *   peClfr        (input)     Clasificación del Riesgo         *
      *   peDlfr        (output)    Descripción de Clasificación     *
      *                                                              *
      * retorna: *on si encontró, *off si no                         *
      * ------------------------------------------------------------ *
     P REASEGU_getDescClf...
     P                 B                   EXPORT
     D REASEGU_getDescClf...
     D                 pi             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peClfr                       4a   const
     D   peDlfr                      30a

     D k1t831          ds                  likerec(s1t831:*key)

      /free

       k1t831.t@empr = peEmpr;
       k1t831.t@sucu = peSucu;
       k1t831.t@clfr = peClfr;
       chain %kds(k1t831:3) set831;
       if not %found;
          return *OFF;
       endif;

       peDlfr = t@dlfr;
       return *ON;

      /end-free

     P                 E

      * ------------------------------------------------------------ *
      * getDescAgr(): Recupera descripción del Agravamiento          *
      *                                                              *
      *   peEmpr        (input)     Empresa                          *
      *   peSucu        (input)     Sucursal                         *
      *   peCagr        (input)     Agravamiento                     *
      *   peDagr        (output)    Descripción del Agravamiento     *
      *                                                              *
      * retorna: *on si encontró, *off si no                         *
      * ------------------------------------------------------------ *
     P REASEGU_getDescAgr...
     P                 B                   EXPORT
     D REASEGU_getDescAgr...
     D                 pi             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peCagr                       2  0 const
     D   peDagr                      30a

     D k1t832          ds                  likerec(s1t832:*key)

      /free

       k1t832.t@empr = peEmpr;
       k1t832.t@sucu = peSucu;
       k1t832.t@cagr = peCagr;
       chain %kds(k1t832:3) set832;
       if not %found;
          return *OFF;
       endif;

       peDagr = t@dagr;
       return *ON;

      /end-free

     P                 E

      * ------------------------------------------------------------ *
      * REASEGU_End(): Finaliza módulo.                              *
      *                                                              *
      * retorna: void.                                               *
      * ------------------------------------------------------------ *
     P REASEGU_End     B                   EXPORT
     D REASEGU_End     pr

      /free

       if %open(set80405);
          close set80405;
       endif;
       if %open(set14101);
          close set14101;
       endif;
       if %open(set831);
          close set831;
       endif;
       if %open(set832);
          close set832;
       endif;

       Initialized = *OFF;

      /end-free

     P REASEGU_End     E

