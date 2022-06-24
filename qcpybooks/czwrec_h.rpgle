      /if defined(CZWREC_H)
      /eof
      /endif
      /define CZWREC_H

      * ------------------------------------------------------------ *
      * INZ():       Incializar Módulo                               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D CZWREC_Inz      pr

      * ------------------------------------------------------------ *
      * End():       Finalizar Módulo                                *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D CZWREC_End      pr

      * ------------------------------------------------------------ *
      * Error():     Retorna último error                            *
      *                                                              *
      *       peErrn    (input)   Número del error                   *
      *                                                              *
      * retorna: Mensaje del último error                            *
      * ------------------------------------------------------------ *
     D CZWREC_Error    pr            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * recFinanciero():    Obtiene % Recargo Financiero             *
      *                                                              *
      *     peArcd    (input)    Artículo                            *
      *     peRama    (input)    Rama                                *
      *     peDupe    (input)    Duración del período                *
      *     peCfpg    (input)    Forma de Pago                       *
      *     peFech    (input)    Fecha                               *
      *                                                              *
      *                                                              *
      * retorna: % de Recargo Financiero                             *
      * ------------------------------------------------------------ *
     D CZWREC_recFinanciero...
     D                 pr             5  2
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peDupe                       2  0 const
     D   peCfpg                       1  0 const
     D   peFech                       8  0 const options(*nopass)

      * ------------------------------------------------------------ *
      * recFinancieroProductor(): % Recargo Financiero por Productor *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peNivt    (input)    Nivel de Intermediario              *
      *     peNivc    (input)    Código de Intermediario             *
      *     peArcd    (input)    Artículo                            *
      *     peRama    (input)    Rama                                *
      *     peDupe    (input)    Duración del período                *
      *     peCfpg    (input)    Forma de Pago                       *
      *                                                              *
      *                                                              *
      * retorna: % de Recargo Financiero                             *
      * ------------------------------------------------------------ *
     D CZWREC_recFinancieroProductor...
     D                 pr             5  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peDupe                       2  0 const
     D   peCfpg                       1  0 const

      * ------------------------------------------------------------ *
      * recFinancieroFormPago(): % Recargo Financiero Forma de Pago  *
      *                                                              *
      *     peArcd    (input)    Artículo                            *
      *     peRama    (input)    Rama                                *
      *     peDupe    (input)    Duración del período                *
      *     peCfpg    (input)    Forma de Pago                       *
      *     peXref    (output)   % Recargo Financiero                *
      *                                                              *
      * retorna: % de Recargo Financiero                             *
      * ------------------------------------------------------------ *
     D CZWREC_recFinancieroFormPago...
     D                 pr             1N
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peDupe                       2  0 const
     D   peCfpg                       1  0 const
     D   peXref                       5  2

      * ------------------------------------------------------------ *
      * extraPaFija():    Importe de Extra Prima Fija                *
      *                                                              *
      *     peRama    (input)    Rama                                *
      *     peArcd    (input)    Artículo                            *
      *     peMone    (input)    Moneda                              *
      *     peTiou    (input)    Tipo de Operación                   *
      *     peStou    (input)    Subtipo de Operación                *
      *     peScta    (input)    Zona                                *
      *                                                              *
      * retorna: importe de Extra Prima Fija                         *
      * ------------------------------------------------------------ *
     D CZWREC_extraPaFija...
     D                 pr            15  2
     D   peRama                       2  0 const
     D   peArcd                       6  0 const
     D   peMone                       2a   const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peScta                       1  0 const

      * ------------------------------------------------------------ *
      * extraPaFijaProductor(): Extra Prima Fija por Productor       *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peNivt    (input)    Nivel de Intermediario              *
      *     peNivc    (input)    Código de Intermediario             *
      *     peRama    (input)    Rama                                *
      *     peArcd    (input)    Artículo                            *
      *     peMone    (input)    Moneda                              *
      *     peTiou    (input)    Tipo de Operación                   *
      *     peStou    (input)    Subtipo de Operación                *
      *     peScta    (input)    Zona                                *
      *     peFemi    (input)    Fecha de Emisión                    *
      *                                                              *
      * retorna: importe de Extra Prima Fija por productor           *
      * ------------------------------------------------------------ *
     D CZWREC_extraPaFijaProductor...
     D                 pr            15  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peRama                       2  0 const
     D   peArcd                       6  0 const
     D   peMone                       2a   const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peScta                       1  0 const
     D   peFemi                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * extraPrimaVariable():  Cálculo Extra Prima Variable          *
      *                                                              *
      *     peComi    (output)   Porcentaje de Comisión              *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: % de Extra prima variable y comisión (en peComi)    *
      * ------------------------------------------------------------ *
     D CZWREC_extraPrimaVariable...
     D                 pr             5  2
     D  peComi                        5  2
     D  peFech                        8  0 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * extraPrimaVariableProd(): Cálculo Extra Prima Variable Prod. *
      *                                                              *
      *     peEmpr    (input)    Empresa                             *
      *     peSucu    (input)    Sucursal                            *
      *     peNivt    (input)    Nivel de Intermediario              *
      *     peNivc    (input)    Código de Intermediario             *
      *     peRama    (input)    Rama                                *
      *     peComi    (output)   % de Comisión                       *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: % de Extra prima variable y comisión (en peComi)    *
      * ------------------------------------------------------------ *
     D CZWREC_extraPrimaVariableProd...
     D                 pr             5  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peRama                        2  0 const
     D  peComi                        5  2
     D  peFech                        8  0 const options(*nopass:*omit)

