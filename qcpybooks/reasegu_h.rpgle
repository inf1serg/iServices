      /if defined(REASEGU_H)
      /eof
      /endif
      /define REASEGU_H

      * ------------------------------------------------------------ *
      * REASEGU_Inz(): Incialización del módulo.                     *
      *                                                              *
      * retorna: void.                                               *
      * ------------------------------------------------------------ *
     D REASEGU_Inz     pr

      * ------------------------------------------------------------ *
      * getLstCont():  Obtiene contrato vigente a hoy.               *
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
     D REASEGU_getLstCont...
     D                 pr             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNrcr                       5  0
     D   peFech                       8  0 options(*nopass:*omit) const
     D   peNcor                       5  0 options(*nopass:*omit)
     D   peFdes                      10d   options(*nopass:*omit)
     D   peFhas                      10d   options(*nopass:*omit)

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
     D REASEGU_getLstContRam...
     D                 pr             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peRama                       2  0 const
     D   peNrcr                       5  0
     D   peFech                       8  0 options(*nopass:*omit) const
     D   peNcor                       5  0 options(*nopass:*omit)
     D   peFdes                      10d   options(*nopass:*omit)
     D   peFhas                      10d   options(*nopass:*omit)

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
     D REASEGU_getCiaDesc...
     D                 pr             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNcor                       5  0 const
     D   peNcia                      40a
     D   peNrdf                       7  0 options(*nopass:*omit)

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
     D REASEGU_getDescClf...
     D                 pr             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peClfr                       4a   const
     D   peDlfr                      30a

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
     D REASEGU_getDescAgr...
     D                 pr             1N
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peCagr                       2  0 const
     D   peDagr                      30a

      * ------------------------------------------------------------ *
      * REASEGU_End(): Finaliza módulo.                              *
      *                                                              *
      * retorna: void.                                               *
      * ------------------------------------------------------------ *
     D REASEGU_End     pr

