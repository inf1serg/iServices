     H option(*nodebugio:*srcstmt)
     H nomain
      * ************************************************************ *
      * CZWREC: Cotización Standard                                  *
      *         Programa de Servicio - Cálculo de Recargos           *
      *                                                              *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                          <*    *
      *> IGN: DLTSRVPGM SRVPGM(*LIBL/&N)                       <*    *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                          <*    *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -            <*    *
      *>           DBGVIEW(&DV)                                <*    *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                            <*    *
      *>           MODULE(QTEMP/&N) -                          <*    *
      *>           EXPORT(*SRCFILE) -                          <*    *
      *>           SRCFILE(HDIILE/QSRVSRC) -                   <*    *
      *>           BNDSRVPGM(CZWUTL) -                         <*    *
      *> TEXT('Cotización Standard: Cálculo de Recargos')      <*    *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                          <*    *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *01-Oct-2013        *
      * ------------------------------------------------------------ *
      * SGF 04/12/13: Corrijo recargo financiero por default.        *
      *               % Extra prima fija para zonas especiales es    *
      *               60,52.                                         *
      * NWN 09/05/2019: Agregado de Derecho de emisión en SPEXCODE.  *
      *                                                              *
      * ************************************************************ *
     Fset6118   if   e           k disk    usropn
     Fset699    if   e           k disk    usropn prefix(t9:2)
     Fset1221   if   e           k disk    usropn
     Fset122    if   e           k disk    usropn
     Fset638    if   e           k disk    usropn

      /copy './qcpybooks/czwrec_h.rpgle'
      /copy './qcpybooks/czwutl_h.rpgle'

      * Establecer ultimo error
     D SetError        pr
     D   peErrn                      10i 0 const
     D   peErrm                      80a   const

     D initialized     s              1n
     D ErrorNumb       s             10i 0
     D ErrorText       s             80a

     Is1t6118
     I              t@date                      txdate
     Is1t638
     I              t@date                      tzdate

      * ------------------------------------------------------------ *
      * INZ():       Incializar Módulo                               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P CZWREC_Inz      B                   export
     D CZWREC_Inz      pi

      /free

       if initialized;
          return;
       endif;

       if not %open(set6118);
          open set6118;
       endif;
       if not %open(set699);
          open set699;
       endif;
       if not %open(set1221);
          open set1221;
       endif;
       if not %open(set122);
          open set122;
       endif;
       if not %open(set638);
          open set638;
       endif;

       initialized = *on;

      /end-free

     P CZWREC_Inz      E

      * ------------------------------------------------------------ *
      * End():       Finalizar Módulo                                *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P CZWREC_End      B                   export
     D CZWREC_End      pi

      /free

       close *all;
       Initialized = *OFF;

       /end-free

     P CZWREC_End      E

      * ------------------------------------------------------------ *
      * Error():     Retorna último error                            *
      *                                                              *
      *       peErrn    (input)   Número del error                   *
      *                                                              *
      * retorna: Mensaje del último error                            *
      * ------------------------------------------------------------ *
     P CZWREC_Error    B                   export
     D CZWREC_Error    pi            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peErrn) <> *NULL;
          peErrn = ErrorNumb;
       endif;

       return ErrorText;

      /end-free

     P CZWREC_Error    E

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
     P CZWREC_recFinanciero...
     P                 B                   export
     D CZWREC_recFinanciero...
     D                 pi             5  2
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peDupe                       2  0 const
     D   peCfpg                       1  0 const
     D   peFech                       8  0 const options(*nopass)

     D @fech           s              8  0
     D @xref           s              5  2
     D pexref          s              5  2
     D @cfpg           s              1  0
     D rc              s              1n

      /free

       CZWREC_Inz();

       if %parms >= 5 and %addr(peFech) <> *null;
          @fech = peFech;
        else;
          @fech = CZWUTL_getFemi();
       endif;

       if peCfpg <> 2;
          @xref = 6;
       endif;

       rc = CZWREC_recFinancieroFormPago( peArcd
                                        : peRama
                                        : peDupe
                                        : peCfpg
                                        : peXref );
       if (rc = *ON);
          @xref = peXref;
       endif;

       return @xref;

      /end-free

     P CZWREC_recFinanciero...
     P                 E

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
     P CZWREC_recFinancieroProductor...
     P                 B                   export
     D CZWREC_recFinancieroProductor...
     D                 pi             5  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peDupe                       2  0 const
     D   peCfpg                       1  0 const

     D k1t6118         ds                  likerec(s1t6118:*key)
     D @xref           s              5  2
     D peXref          s              5  2
     D rc              s              1N

      /free

       CZWREC_Inz();

       k1t6118.t@empr = peEmpr;
       k1t6118.t@sucu = peSucu;
       k1t6118.t@nivt = peNivt;
       k1t6118.t@nivc = peNivc;
       k1t6118.t@rama = peRama;
       chain %kds(k1t6118:5) set6118;
       if %found;

          @xref = t@xref;

          rc = CZWREC_recFinancieroFormPago( peArcd
                                           : peRama
                                           : peDupe
                                           : peCfpg
                                           : peXref );
          if (rc = *ON);
             @xref = peXref;
          endif;

       endif;

       return @xref;

      /end-free

     P CZWREC_recFinancieroProductor...
     P                 E

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
     P CZWREC_recFinancieroFormPago...
     P                 B                   export
     D CZWREC_recFinancieroFormPago...
     D                 pi             1N
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peDupe                       2  0 const
     D   peCfpg                       1  0 const
     D   peXref                       5  2

     D k1t699          ds                  likerec(s1t699:*key)

      /free

       CZWREC_Inz();

       k1t699.t9cfpg = peCfpg;
       k1t699.t9arcd = peArcd;
       k1t699.t9rama = peRama;
       k1t699.t9dupe = 0;
       chain %kds(k1t699:4) set699;
       if %found;
          peXref = t9prfi;
          return *on;
       endif;

       k1t699.t9cfpg = peCfpg;
       k1t699.t9arcd = peArcd;
       k1t699.t9rama = peRama;
       k1t699.t9dupe = peDupe;
       chain %kds(k1t699:4) set699;
       if %found;
          peXref = t9prfi;
          return *on;
       endif;

       peXref = *zeros;
       return *OFF;

      /end-free

     P CZWREC_recFinancieroFormPago...
     P                 E

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
     P CZWREC_extraPaFija...
     P                 B                   export
     D CZWREC_extraPaFija...
     D                 pi            15  2
     D   peRama                       2  0 const
     D   peArcd                       6  0 const
     D   peMone                       2a   const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peScta                       1  0 const

     D @tiou           s              1  0
     D @dere           s             15  2
     D @aux            s             29  9
     D @femi           s              8  0
     D k1t1221         ds                  likerec(s1t1221:*key)
     D k1t122          ds                  likerec(s1t122:*key)

      /free

       CZWREC_Inz();

       @tiou = peTiou;

       k1t1221.t@tiou = @tiou;
       k1t1221.t@stou = peStou;
       chain %kds(k1t1221:2) set1221;
       if %found;
          @tiou = t1tiou;
       endif;

       k1t122.t@rama = peRama;
       k1t122.t@arcd = peArcd;
       k1t122.t@mone = peMone;
       k1t122.t@tiou = @tiou;
       chain %kds(k1t122:4) set122;
       if %found;
          @dere = t@dem1;
       endif;

       // ------------------------------------------------------
       // Hay que tabular esto, pasa que está por productor...
       // ------------------------------------------------------
       if (peScta = 3 or peScta = 4 or peScta = 7 or peScta = 8);
           @femi = CZWUTL_getFemi();
           if (@femi >= 20131216);
                @aux = (@dere * 60,52) / 100;
               eval(h) @dere = @aux;
            else;
               @dere = (@dere * 40) / 100;
           endif;
       endif;

       return @dere;

      /end-free

     P CZWREC_extraPaFija...
     P                 E

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
      *                                                              *
      * retorna: importe de Extra Prima Fija por productor           *
      * ------------------------------------------------------------ *
     P CZWREC_extraPaFijaProductor...
     P                 B                   export
     D CZWREC_extraPaFijaProductor...
     D                 pi            15  2
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

     D spcadcom        pr                  extpgm('SPCADCOM')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peCade                        5  0 dim(9)
     D  peErro                         n
     D  peEpgm                        3a   const

     D spexcode        pr                  extpgm('SPEXCODE')
     D peEmpr                         1a   const
     D peSucu                         2a   const
     D peNivt                         1  0 const
     D peNivc                         5  0 const
     D peRama                         2  0 const
     D peTiou                         1  0 const
     D peStou                         2  0 const
     D peFemi                         8  0 const
     D peFpgm                         3a   const
     D peTiene                        1N
     D peValor                       15  2 options(*nopass)
     D p@tipo_valor                   1a   options(*nopass)
     D p@forma_acred                  1a   options(*nopass)
     D p@dias_dife                    5  0 options(*nopass)
     D p@adere                       15  2 options(*nopass)

     D k1t6118         ds                  likerec(s1t6118:*key)
     D k1t1221         ds                  likerec(s1t1221:*key)
     D k1t122          ds                  likerec(s1t122:*key)
     D @dere           s             15  2
     D @tiou           s              1  0
     D @femi           s              8  0
     D @mar1           s              1a
     D peCade          s              5  0 dim(9)
     D peErro          s              1n
     D peTiene         s              1N
     D peValor         s             15  2
     D peTipoVal       s              1a
     D peFormAcr       s              1a
     D peDiasDif       s              5  0
     D peAdere         s             15  2

      /free

       CZWREC_Inz();

       if %parms >= 11 and %addr(peFemi) <> *null;
          @femi = peFemi;
        else;
          @femi = CZWUTL_getFemi();
       endif;

       // ------------------------------
       // Por omisión
       // ------------------------------
       k1t6118.t@empr = peEmpr;
       k1t6118.t@sucu = peSucu;
       k1t6118.t@nivt = peNivt;
       k1t6118.t@nivc = peNivc;
       k1t6118.t@rama = peRama;
       chain %kds(k1t6118) set6118;
       if %found;
          @dere = t@dere;
          @mar1 = t@mar1;
       endif;

       // ------------------------------
       // Si hay que buscar en tablas
       // ------------------------------
       if (t@marp = 'T');
          @tiou = peTiou;
          k1t1221.t@tiou = peTiou;
          k1t1221.t@stou = peStou;
          chain %kds(k1t1221:2) set1221;
          if %found;
             @tiou = t1tiou;
          endif;
          k1t122.t@rama = peRama;
          k1t122.t@arcd = peArcd;
          k1t122.t@mone = peMone;
          k1t122.t@tiou = @tiou;
          chain %kds(k1t122:4) set122;
          if %found;
             @dere = t@dem1;
          endif;
       endif;

       // ------------------------------
       // Condicion especial por zona
       // ------------------------------
       if (@mar1 <> ' ');
           setll @mar1 set638;
           reade @mar1 set638;
           dow not %eof;
               if t@scta = peScta;
                  @dere += (@dere * t@dere) / 100;
                  leave;
               endif;
            reade @mar1 set638;
           enddo;
       endif;

       // ------------------------------
       // Extra prima (nivel 6)
       // ------------------------------
       SPCADCOM( peEmpr
               : peSucu
               : peNivt
               : peNivc
               : peCade
               : peErro
               : *blanks );

       SPEXCODE( peEmpr
               : peSucu
               : 6
               : peCade(6)
               : peRama
               : peTiou
               : peStou
               : @femi
               : *blanks
               : peTiene
               : peValor
               : peTipoVal
               : peFormAcr
               : peDiasDif
               : peAdere   );

       if (peTiene = *ON);
          @dere += peAdere;
       endif;

       SPCADCOM( peEmpr
               : peSucu
               : peNivt
               : peNivc
               : peCade
               : peErro
               : 'FIN'   );

       SPEXCODE( peEmpr
               : peSucu
               : 6
               : peCade(6)
               : peRama
               : peTiou
               : peStou
               : @femi
               : 'FIN'
               : peTiene
               : peValor
               : peTipoVal
               : peFormAcr
               : peDiasDif
               : peAdere   );

       return @dere;

      /end-free

     P CZWREC_extraPaFijaProductor...
     P                 E

      * ------------------------------------------------------------ *
      * extraPrimaVariable():  Cálculo Extra Prima Variable          *
      *                                                              *
      *     peComi    (output)   Porcentaje de Comisión              *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: % de Extra prima variable y comisión (en peComi)    *
      * ------------------------------------------------------------ *
     P CZWREC_extraPrimaVariable...
     P                 B                   export
     D CZWREC_extraPrimaVariable...
     D                 pi             5  2
     D  peComi                        5  2
     D  peFech                        8  0 const options(*nopass:*omit)

     D EXPV_DEFAULT    c                   0
     D COMI_DEFAULT    c                   0
     D @femi           s              8  0

      /free

       CZWREC_Inz();

       if %parms >= 2 and %addr(peFech) <> *null;
          @femi = peFech;
        else;
          @femi = CZWUTL_getFemi();
       endif;

       peComi = COMI_DEFAULT;
       return EXPV_DEFAULT;

      /end-free

     P CZWREC_extraPrimaVariable...
     P                 E

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
     P CZWREC_extraPrimaVariableProd...
     P                 B                   export
     D CZWREC_extraPrimaVariableProd...
     D                 pi             5  2
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peRama                        2  0 const
     D  peComi                        5  2
     D  peFech                        8  0 const options(*nopass:*omit)

     D @femi           s              8  0
     D k1t6118         ds                  likerec(s1t6118:*key)

      /free

       CZWREC_Inz();

       if %parms >= 7 and %addr(peFech) <> *null;
          @femi = peFech;
        else;
          @femi = CZWUTL_getFemi();
       endif;

       k1t6118.t@empr = peEmpr;
       k1t6118.t@sucu = peSucu;
       k1t6118.t@nivt = peNivt;
       k1t6118.t@nivc = peNivc;
       k1t6118.t@rama = peRama;
       chain %kds(k1t6118) set6118;
       if %found;
          peComi = t@pdn1;
          return t@xrea;
       endif;

       return 0;

      /end-free

     P CZWREC_extraPrimaVariableProd...
     P                 E

