     H nomain
      * ************************************************************ *
      * SVPPRD: Producción Por Artículos                             *
      *         Planes por productor.                                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                   *03-Oct-2016              *
      * ************************************************************ *
     Fset102p   if   e           k disk    usropn prefix(tp:2)
     Fset102p01 if   e           k disk    usropn prefix(tp:2)
     F                                     rename(s1t102p:s1t102p01)
     Fset102    if   e           k disk    usropn
     Fset102w   if   e           k disk    usropn prefix(t2:2)
     Fset626    if   e           k disk    usropn prefix(t6:2)
     Fset627    if   e           k disk    usropn prefix(t7:2)
     Fset001    if   e           k disk    usropn prefix(tr:2)

      /copy './qcpybooks/svpprd_h.rpgle'

     D SetError        pr
     D  peErrn                       10i 0
     D  peErrm                       80a

     D ok_web          pr             1N
     D  peRama                        2  0 const
     D  peXpro                        3  0 const

     D SVPPRD_errn     s             10i 0
     D SVPPRD_errm     s             80a
     D Initialized     s              1N

      * ------------------------------------------------------------ *
      * SVPPRD_planesPorProductor(): Listado de planes por Productor *
      *                                                              *
      *    peEmpr  (input)   Empresa                                 *
      *    peSucu  (input)   Sucursal                                *
      *    peRama  (input)   Rama                                    *
      *    peArcd  (input)   Artículo                                *
      *    peNivt  (input)   Tipo de Intermediario                   *
      *    peNivc  (input)   Código de Intermediario                 *
      *    pePlan  (output)  Array de Planes (registro SET102)       *
      *    peFweb  (input)   Filtrar habilitados para web            *
      *                                                              *
      * retorna: cantidad de planes especiales o 0 si no hay         *
      * ------------------------------------------------------------ *
     P SVPPRD_planesPorProductor...
     P                 B                   Export
     D SVPPRD_planesPorProductor...
     D                 pi            10i 0
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peArcd                        6  0 const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  pePlan                             likeds(regPlan_t) dim(999)
     D  peFweb                        1N   const options(*nopass:*omit)

     D k1t102          ds                  likerec(s1t102:*key)
     D k1t102p         ds                  likerec(s1t102p01:*key)
     D k2t102p         ds                  likerec(s1t102p:*key)
     D k1t626          ds                  likerec(s1t626:*key)
     D k1t627          ds                  likerec(s1t627:*key)

     D x               s             10i 0
     D @web            s              1N   inz(*off)

      /free

       SVPPRD_inz();

       x = 0;

       if %parms >= 8 and %addr(peFweb) <> *null;
          @web = peFweb;
       endif;

       chain peRama set001;
       if not %found;
          return x;
       endif;

       // ------------------------------------
       // Cargar todos los especiales
       // ------------------------------------
       k1t102p.tpnivt = peNivt;
       k1t102p.tpnivc = peNivc;
       k1t102p.tprama = peRama;
       setll %kds(k1t102p:3) set102p01;
       reade %kds(k1t102p:3) set102p01;
       dow not %eof;

           // ---------------------------------
           // Filtro por Artículo
           // ---------------------------------
           if trrame = 18 or trrame = 21;
              k1t627.t7arcd = peArcd;
              k1t627.t7rama = peRama;
              k1t627.t7arse = 1;
              k1t627.t7xpro = tpxpro;
              setll %kds(k1t627) set627;
            else;
              k1t626.t6arcd = peArcd;
              k1t626.t6rama = peRama;
              k1t626.t6arse = 1;
              k1t626.t6xpro = tpxpro;
              setll %kds(k1t626) set626;
           endif;
           if %equal;
              k1t102.t@rama = tprama;
              k1t102.t@xpro = tpxpro;
              chain %kds(k1t102) set102;
              if %found;
                 // ----------------------------
                 // Filtro web
                 // ----------------------------
                 if @web and ok_web( t@rama : t@xpro )
                    or
                    not @web;
                    x += 1;
                    pePlan(x).t@xpro = t@xpro;
                    pePlan(x).t@prds = t@prds;
                    pePlan(x).t@1021 = t@1021;
                    pePlan(x).t@1022 = t@1022;
                    pePlan(x).t@1023 = t@1023;
                    pePlan(x).t@ctar = t@ctar;
                    pePlan(x).t@cta1 = t@cta1;
                    pePlan(x).t@cta2 = t@cta2;
                    pePlan(x).t@cagr = t@cagr;
                    pePlan(x).t@prdl = t@prdl;
                    pePlan(x).t@psua = t@psua;
                    pePlan(x).t@mar1 = t@mar1;
                    pePlan(x).t@mar2 = t@mar2;
                    pePlan(x).t@mar3 = t@mar3;
                    pePlan(x).t@mar4 = t@mar4;
                    pePlan(x).t@mar5 = t@mar5;
                 endif;
              endif;
           endif;

        reade %kds(k1t102p:3) set102p01;
       enddo;

       // ------------------------------------
       // Cargar los no especiales
       // ------------------------------------
       k1t102.t@rama = peRama;
       setll %kds(k1t102:1) set102;
       reade %kds(k1t102:1) set102;
       dow not %eof;

           // ---------------------------------
           // Filtro por Artículo
           // ---------------------------------
           if trrame = 18 or trrame = 21;
              k1t627.t7arcd = peArcd;
              k1t627.t7rama = peRama;
              k1t627.t7arse = 1;
              k1t627.t7xpro = t@xpro;
              setll %kds(k1t627) set627;
            else;
              k1t626.t6arcd = peArcd;
              k1t626.t6rama = peRama;
              k1t626.t6arse = 1;
              k1t626.t6xpro = t@xpro;
              setll %kds(k1t626) set626;
           endif;
           if %equal;
              if @web and ok_web( t@rama : t@xpro )
                 or
                 not @web;
                 k2t102p.tprama = t@rama;
                 k2t102p.tpxpro = t@xpro;
                 setll %kds(k2t102p:2) set102p;
                 if not %equal;
                    x += 1;
                    pePlan(x).t@xpro = t@xpro;
                    pePlan(x).t@prds = t@prds;
                    pePlan(x).t@1021 = t@1021;
                    pePlan(x).t@1022 = t@1022;
                    pePlan(x).t@1023 = t@1023;
                    pePlan(x).t@ctar = t@ctar;
                    pePlan(x).t@cta1 = t@cta1;
                    pePlan(x).t@cta2 = t@cta2;
                    pePlan(x).t@cagr = t@cagr;
                    pePlan(x).t@prdl = t@prdl;
                    pePlan(x).t@psua = t@psua;
                    pePlan(x).t@mar1 = t@mar1;
                    pePlan(x).t@mar2 = t@mar2;
                    pePlan(x).t@mar3 = t@mar3;
                    pePlan(x).t@mar4 = t@mar4;
                    pePlan(x).t@mar5 = t@mar5;
                 endif;
              endif;
           endif;

        reade %kds(k1t102:1) set102;
       enddo;

       return x;

      /end-free

     P SVPPRD_planesPorProductor...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPRD_chkPlanPorProductor(): Verifica si un plan es válido  *
      *                               para un productor.             *
      *                                                              *
      *    peEmpr  (input)   Empresa                                 *
      *    peSucu  (input)   Sucursal                                *
      *    peRama  (input)   Rama                                    *
      *    peArcd  (input)   Artículo                                *
      *    peNivt  (input)   Tipo de Intermediario                   *
      *    peNivc  (input)   Código de Intermediario                 *
      *    peXpro  (input)   Código de Plan                          *
      *                                                              *
      * retorna: *ON si es válido, *OFF si no lo es.                 *
      * ------------------------------------------------------------ *
     P SVPPRD_chkPlanPorProductor...
     P                 B                   Export
     D SVPPRD_chkPlanPorProductor...
     D                 pi             1N
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peArcd                        6  0 const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peXpro                        3  0 const

     D x               s             10i 0
     D z               s             10i 0
     D pePlan          ds                  likeds(regPlan_t) dim(999)
     D @xpro           s              3  0 dim(999)
     D y               s             10i 0

      /free

       SVPPRD_inz();

       x = SVPPRD_planesPorProductor( peEmpr
                                    : peSucu
                                    : peRama
                                    : peArcd
                                    : peNivt
                                    : peNivc
                                    : pePlan
                                    : *omit    );

       for y = 1 to x;
           z = %lookup(pePlan(y).t@xpro:@xpro);
           if z = 0;
              z = %lookup(*zeros:@xpro);
              @xpro(z) = pePlan(y).t@xpro;
           endif;
       endfor;

       if %lookup(peXpro : @xpro ) <> *zeros;
          return *on;
        else;
          return *off;
       endif;

      /end-free

     P SVPPRD_chkPlanPorProductor...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPRD_inz(): Inicializa módulo.                             *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P SVPPRD_inz      B                   Export
     D SVPPRD_inz      pi

      /free

       if Initialized;
          return;
       endif;

       if not %open(set001);
          open set001;
       endif;

       if not %open(set102);
          open set102;
       endif;

       if not %open(set102w);
          open set102w;
       endif;

       if not %open(set102p);
          open set102p;
       endif;

       if not %open(set102p01);
          open set102p01;
       endif;

       if not %open(set626);
          open set626;
       endif;

       if not %open(set627);
          open set627;
       endif;

       Initialized = *on;
       return;

      /end-free

     P SVPPRD_inz      E

      * ------------------------------------------------------------ *
      * SVPPRD_end(): Finaliza Módulo.                               *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     P SVPPRD_end      B                   Export
     D SVPPRD_end      pi

      /free

       close *all;
       Initialized = *OFF;

      /end-free

     P SVPPRD_end      E

      * ------------------------------------------------------------ *
      * SVPPRD_error(): Retorna último error del módulo.             *
      *                                                              *
      *      peErrn   (output)   Código de Error.                    *
      *                                                              *
      * retorna: Mensaje                                             *
      * ------------------------------------------------------------ *
     P SVPPRD_error    B                   export
     D SVPPRD_error    pi            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peErrn) <> *null;
           peErrn = SVPPRD_errn;
       endif;

       return SVPPRD_errm;

      /end-free

     P SVPPRD_error    E

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0
     D  peErrm                       80a

      /free

       SVPPRD_errn = peErrn;
       SVPPRD_errm = peErrm;

      /end-free

     P SetError        E

      * ------------------------------------------------------------ *
      * ok_web(): Verifica web                                       *
      *                                                              *
      *      peRama   (input)    Código de Rama.                     *
      *      peXpro   (input)    Código de Producto.                 *
      *                                                              *
      * retorna: *ON si está habilitado para web, *OFF si no         *
      * ------------------------------------------------------------ *
     P ok_web          B
     D ok_web          pi             1N
     D  peRama                        2  0 const
     D  peXpro                        3  0 const

     D k1t102w         ds                  likerec(s1t102w:*key)

     D hab             s              1N   inz(*OFF)

      /free

       k1t102w.t2rama = peRama;
       k1t102w.t2xpro = peXpro;
       setgt  %kds(k1t102w:2) set102w;
       readpe %kds(k1t102w:2) set102w;
       dow not %eof;
           if t2fech <= %dec(%date());
              if t2mp01 = 'S';
                 hab = *on;
              endif;
            leave;
           endif;
        readpe %kds(k1t102w:2) set102w;
       enddo;

       return hab;

      /end-free

     P ok_web          E

