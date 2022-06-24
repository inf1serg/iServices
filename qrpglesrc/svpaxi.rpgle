     H nomain
     H option(*nodebugio)
      * ************************************************************ *
      * SVPAXI  :Programa de Servicio.                               *
      *          Ajuste por Inflación.                               *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        04-Ene-2021             *
      * ------------------------------------------------------------ *
      * SGF 12/01/21: Agrego lógica para Vida Colectivo.             *
      * SGF 19/01/21: Soporte para póliza global.                    *
      * SGF 21/01/21: Póliza global también va a set622.             *
      * SGF 23/06/22: Fecha base (pxFeba) como opcional.             *
      *                                                              *
      * ************************************************************ *
     Fgntind    if   e           k disk    usropn
     Fgnhvin    if   e           k disk    usropn
     Fpahed9    if   e           k disk    usropn
     Fpahed0    if   e           k disk    usropn
     Fset622    if   e           k disk    usropn

      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy inf1serg/qcpybooks,svpaxi_h
      /copy './qcpybooks/svpaxi_h.rpgle'

     D SetError        pr
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a
     D Initialized     s              1N

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

      * ------------------------------------------------------------ *
      * SetError(): Establece error del modulo.                      *
      *                                                              *
      *     Procedimiento interno                                    *
      *                                                              *
      *     peErrn   (input)   Número de error                       *
      *     peErrm   (input)   Mensaje de error                      *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       errn = peErrn;
       errm = peErrm;

      /end-free

     P SetError        E


      * ------------------------------------------------------------ *
      * SVPAXI_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPAXI_inz      b                   export
     D SVPAXI_inz      pi

      /free

       if Initialized;
          return;
       endif;

       if not %open(gntind);
          open gntind;
       endif;

       if not %open(gnhvin);
          open gnhvin;
       endif;

       if not %open(pahed9);
          open pahed9;
       endif;

       if not %open(pahed0);
          open pahed0;
       endif;

       if not %open(set622);
          open set622;
       endif;

       Initialized = *on;

       return;

      /end-free

     P SVPAXI_inz      e

      * ------------------------------------------------------------ *
      * SVPAXI_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPAXI_End      b                   export
     D SVPAXI_End      pi

      /free

       close *all;
       Initialized = *OFF;

      /end-free

     P SVPAXI_End      e

      * ------------------------------------------------------------ *
      * SVPAXI_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     P SVPAXI_Error    b                   export
     D SVPAXI_Error    pi            80a
     D   peErrn                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peErrn) <> *null;
           peErrn = Errn;
       endif;

       return Errm;

      /end-free

     P SVPAXI_Error    e

      * ------------------------------------------------------------ *
      * SVPAXI_chkIndice(): Verifica existencia de indice.           *
      *                                                              *
      *     peIndi   (input)   Codigo de Indice                      *
      *     peNinl   (output)  Descripcion de Indice                 *
      *                                                              *
      * Retorna: ON existe, OFF no existe                            *
      * ------------------------------------------------------------ *
     p SVPAXI_chkIndice...
     p                 b                   export
     D SVPAXI_chkIndice...
     D                 pi             1n
     D   peIndi                       2a   const
     D   peNinl                      30a   options(*nopass:*omit)

      /free

       SVPAXI_inz();

       chain peIndi gntind;
       if not %found;
          SetError( SVPAXI_NOIND
                  : 'Codigo de Indice inexistente' );
          return *off;
       endif;

       if %parms >= 2 and %addr(peNinl) <> *null;
          peNinl = inninl;
       endif;

       return *on;

      /end-free

     p SVPAXI_chkIndice...
     p                 e

      * ------------------------------------------------------------ *
      * SVPAXI_getIndice(): Recupera valor de indice.                *
      *                                                              *
      *     peIndi   (input)   Codigo de Indice                      *
      *     peFech   (input)   Fecha a la cual recuperar             *
      *                                                              *
      * Retorna: 1 por error, valor del indice si ok                 *
      * ------------------------------------------------------------ *
     p SVPAXI_getIndice...
     p                 b                   export
     D SVPAXI_getIndice...
     D                 pi            15  6
     D   peIndi                       2a   const
     D   peFech                       8  0 const options(*nopass:*omit)

     D @@fech          s              8  0

     D k1hvin          ds                  likerec(g1hvin:*key)

      /free

       SVPAXI_inz();

       if SVPAXI_chkIndice( peIndi ) = *off;
          return 1;
       endif;

       @@fech = %dec(%date():*iso);
       if %parms >= 2 and %addr(peFech) <> *null;
          @@fech = peFech;
       endif;

       k1hvin.viindi = peIndi;
       k1hvin.vifina = %dec( %subst(%editc(@@fech:'X'):1:4) : 4 : 0);
       k1hvin.vifinm = %dec( %subst(%editc(@@fech:'X'):5:2) : 2 : 0);
       chain %kds(k1hvin:3) gnhvin;
       if not %found;
          return 1;
       endif;

       return vivain;

      /end-free

     p SVPAXI_getIndice...
     p                 e

      * ------------------------------------------------------------ *
      * SVPAXI_getCocienteEntreIndices(): Obtiene cociente entre dos *
      *                          valores de un indice.               *
      *                                                              *
      *     peIndi   (input)   Codigo de Indice                      *
      *     peFeba   (input)   Fecha base                            *
      *     peFeac   (input)   Fecha ajuste                          *
      *                                                              *
      * Retorna: 0 por error, cociente si ok                         *
      * ------------------------------------------------------------ *
     p SVPAXI_getCocienteEntreIndices...
     p                 b                   export
     D SVPAXI_getCocienteEntreIndices...
     D                 pi            15  6
     D   peIndi                       2a   const
     D   peFeba                       8  0 const options(*nopass:*omit)
     D   peFeac                       8  0 const options(*nopass:*omit)

     D @@feba          s              8  0
     D @@feac          s              8  0
     D @@inba          s             15  6
     D @@inac          s             15  6
     D @@aux           s             29  9

      /free

       SVPAXI_inz();

       if SVPAXI_chkIndice( peIndi ) = *off;
          return 1;
       endif;

       @@feba = %dec(%date():*iso);
       @@feac = %dec(%date():*iso);

       if %parms >= 2 and %addr(peFeba) <> *null;
          @@feba = peFeba;
       endif;

       if %parms >= 3 and %addr(peFeac) <> *null;
          @@feac = peFeac;
       endif;

       @@inba = SVPAXI_getIndice( peIndi : @@feba );
       @@inac = SVPAXI_getIndice( peIndi : @@feac );

       if @@inba <> 0;
          @@aux = @@inac / @@inba;
          return %dech(@@aux:15:6);
       endif;

       return 1;

      /end-free

     p SVPAXI_getCocienteEntreIndices...
     p                 e

      * ------------------------------------------------------------ *
      * SVPAXI_ajustarPorInflacion(): Ajustar por inflación cualquier*
      *                          importe.                            *
      *                                                              *
      *     peIndi   (input)   Codigo de Indice                      *
      *     peImpo   (input)   Importe a ajustar                     *
      *     peFeba   (input)   Fecha base                            *
      *     peFeac   (input)   Fecha ajuste                          *
      *                                                              *
      * Retorna: 0 por error, importe ajustado si ok                 *
      * ------------------------------------------------------------ *
     p SVPAXI_ajustarPorInflacion...
     p                 b                   export
     D SVPAXI_ajustarPorInflacion...
     D                 pi            15  2
     D   peIndi                       2a   const
     D   peImpo                      15  2 const
     D   peFeba                       8  0 const options(*nopass:*omit)
     D   peFeac                       8  0 const options(*nopass:*omit)

     D @@feba          s              8  0
     D @@feac          s              8  0
     D @@aux           s             29  9

      /free

       SVPAXI_inz();

       if SVPAXI_chkIndice( peIndi ) = *off;
          return peImpo;
       endif;

       @@feba = %dec(%date():*iso);
       @@feac = %dec(%date():*iso);

       if %parms >= 3 and %addr(peFeba) <> *null;
          @@feba = peFeba;
       endif;

       if %parms >= 4 and %addr(peFeac) <> *null;
          @@feac = peFeac;
       endif;

       @@aux = peImpo * SVPAXI_getCocienteEntreIndices( peIndi
                                                      : @@feba
                                                      : @@feac );

       return %dech(@@aux:15:2);

      /end-free

     p SVPAXI_ajustarPorInflacion...
     p                 e

      * ------------------------------------------------------------ *
      * SVPAXI_ajusteRamaSecuencia(): Ajustar por inflación una      *
      *                               rama/secuencia.                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento de Superpoliza             *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Secuencia Artículo/Rama               *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento                            *
      *     peImpo   (input)   Importe a ajustar                     *
      *     peFeac   (input)   Fecha ajuste                          *
      *     peIndi   (input)   Codigo de Indice (opc)                *
      *                                                              *
      * Retorna: Importe ajustado o mismo importe                    *
      * ------------------------------------------------------------ *
     P SVPAXI_ajusteRamaSecuencia...
     p                 b                   export
     D SVPAXI_ajusteRamaSecuencia...
     D                 pi            15  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peFeac                       8  0 const
     D   peImpo                      15  2 const
     D   peIndi                       2a   const options(*nopass:*omit)
     D   peViba                      15  6 options(*nopass:*omit)
     D   peViaj                      15  6 options(*nopass:*omit)
     D   pxFeba                       8  0 options(*nopass:*omit)

     D @@aux           s             29  9
     D @@indi          s              2a
     D peFeba          s              8  0
     D @@xpro          s              3  0
     D ok              s              1n

     D peDsD0          ds                  likeds( dsPahed0_t ) dim( 999 )
     D p2DsD0          ds                  likeds( dsPahed0_t ) dim( 999 )
     D peDsC1          ds                  likeds ( dsPaheC1_t ) dim( 999 )
     D p2DsC1          ds                  likeds ( dsPaheC1_t ) dim( 999 )
     D peDsD0c         s             10i 0
     D p2DsD0c         s             10i 0
     D peDsC1C         s             10i 0

      /free

       SVPAXI_inz();

       if peRama = 80;
          if %parms >= 16 and %addr(pxFeba) <> *null;
             return SVPAXI_ajusteRamaSecuenciaVida( peEmpr
                                                  : peSucu
                                                  : peArcd
                                                  : peSpol
                                                  : peSspo
                                                  : peRama
                                                  : peArse
                                                  : peOper
                                                  : pePoli
                                                  : peSuop
                                                  : peFeac
                                                  : peImpo
                                                  : peIndi
                                                  : peViba
                                                  : peViaj
                                                  : pxFeba  );
          endif;
          return SVPAXI_ajusteRamaSecuenciaVida( peEmpr
                                               : peSucu
                                               : peArcd
                                               : peSpol
                                               : peSspo
                                               : peRama
                                               : peArse
                                               : peOper
                                               : pePoli
                                               : peSuop
                                               : peFeac
                                               : peImpo
                                               : peIndi
                                               : peViba
                                               : peViaj  );
       endif;

       @@indi = 'AI';
       if %parms >= 13 and %addr(peIndi) <> *null;
          @@indi = peIndi;
       endif;

       if %parms >= 14 and %addr(peViba) <> *null;
          peViba = 1;
       endif;

       if %parms >= 15 and %addr(peViaj) <> *null;
          peViaj = 1;
       endif;

       if %parms >= 16 and %addr(pxFeba) <> *null;
          pxFeba = 0;
       endif;

       if SVPAXI_chkIndice( @@indi ) = *off;
          return peImpo;
       endif;

       if SVPPOL_getPoliza( peEmpr
                          : peSucu
                          : peRama
                          : pePoli
                          : peSuop
                          : peArcd
                          : peSpol
                          : peSspo
                          : peArse
                          : peOper
                          : peDsD0
                          : peDsD0C ) = *off;
          return peImpo;
       endif;

       if peDsD0C <= 0;
          return peImpo;
       endif;

       if SPVSPO_getCabeceraSuplemento( peEmpr
                                      : peSucu
                                      : peArcd
                                      : peSpol
                                      : peSspo
                                      : peDsC1
                                      : peDsC1C ) = *off;
          return peImpo;
       endif;

       if peDsC1C <= 0;
          return peImpo;
       endif;

       //
       // Endosos positivos que no sean TIOU = 4 ni
       // TIOU = 3 and STOU = 90
       //  Para estos casos, la fecha base es la fecha de
       //  emisión del mismo movimiento
       //
       if peDsD0(1).d0prim >= 0   and
          (peDsD0(1).d0tiou <> 4) and
          not (peDsD0(1).d0tiou = 3 and peDsD0(1).d0stou = 90);
          peFeba = (peDsC1(1).c1fema * 10000)
                 + (peDsC1(1).c1femm *   100)
                 +  peDsC1(1).c1femd;
          if %parms >= 16 and %addr(pxFeba) <> *null;
             pxFeba = peFeba;
          endif;
        else;
          //
          // Resto del universo: fecha base del endoso
          // afectado
          // OJOTA con esto porque acá hay que iterar
          // hasta dar con el endoso afectado
          //
          @@xpro = peDsC1(1).c1xpro;
          ok = *off;
          dou ok;
              if peDsC1(1).c1xpro = peDsC1(1).c1sspo;
                 peFeba = (peDsC1(1).c1fema * 10000)
                        + (peDsC1(1).c1femm *   100)
                        +  peDsC1(1).c1femd;
                 if %parms >= 16 and %addr(pxFeba) <> *null;
                    pxFeba = peFeba;
                 endif;
                 leave;
              endif;
              if SVPPOL_getPoliza( peEmpr
                                 : peSucu
                                 : peRama
                                 : pePoli
                                 : @@xpro
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : p2DsD0
                                 : p2DsD0C ) = *off or p2DsD0C <= 0;
                 return peImpo;
              endif;
              if SPVSPO_getCabeceraSuplemento( peEmpr
                                             : peSucu
                                             : peArcd
                                             : peSpol
                                             : p2DsD0(1).d0sspo
                                             : peDsC1
                                             : peDsC1C ) = *off
                                               or
                                             peDsC1C <= 0;
                 return peImpo;
              endif;
              if p2DsD0(1).d0prim >= 0   and
                 (p2DsD0(1).d0tiou <> 4) and
                 not (p2DsD0(1).d0tiou = 3 and p2DsD0(1).d0stou = 90);
                 peFeba = (peDsC1(1).c1fema * 10000)
                        + (peDsC1(1).c1femm *   100)
                        +  peDsC1(1).c1femd;
                 if %parms >= 16 and %addr(pxFeba) <> *null;
                    pxFeba = peFeba;
                 endif;
                 ok = *on;
                 leave;
               else;
                 @@xpro = peDsC1(1).c1xpro;
              endif;
          enddo;
       endif;

       if %parms >= 14 and %addr(peViba) <> *null;
          peViba = SVPAXI_getIndice( @@indi : peFeba );
       endif;

       if %parms >= 15 and %addr(peViaj) <> *null;
          peViaj = SVPAXI_getIndice( @@indi : peFeac );
       endif;

       //
       // Ultimo seguro por las que te jedi
       //
       if peFeba <= 0;
          return peImpo;
       endif;

       return SVPAXI_ajustarPorInflacion( @@indi
                                        : peImpo
                                        : peFeba
                                        : peFeac );

      /end-free

     P SVPAXI_ajusteRamaSecuencia...
     p                 e

      * ------------------------------------------------------------ *
      * SVPAXI_ajusteRamaSecuenciaVida(): Ajustar por inflación una  *
      *                               rama/secuencia.                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Artículo                              *
      *     peSpol   (input)   Superpoliza                           *
      *     peSspo   (input)   Suplemento de Superpoliza             *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Secuencia Artículo/Rama               *
      *     peOper   (input)   Operacion                             *
      *     peSuop   (input)   Suplemento                            *
      *     peImpo   (input)   Importe a ajustar                     *
      *     peFeac   (input)   Fecha ajuste                          *
      *     peIndi   (input)   Codigo de Indice (opc)                *
      *                                                              *
      * Retorna: Importe ajustado o mismo importe                    *
      * ------------------------------------------------------------ *
     P SVPAXI_ajusteRamaSecuenciaVida...
     p                 b                   export
     D SVPAXI_ajusteRamaSecuenciaVida...
     D                 pi            15  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peFeac                       8  0 const
     D   peImpo                      15  2 const
     D   peIndi                       2a   const options(*nopass:*omit)
     D   peViba                      15  6 options(*nopass:*omit)
     D   peViaj                      15  6 options(*nopass:*omit)
     D   pxFeba                       8  0 options(*nopass:*omit)

     D @@aux           s             29  9
     D @@indi          s              2a
     D peFeba          s              8  0
     D @@xpro          s              3  0
     D nuev            s              1n
     D refa            s              1n
     D reno            s              1n
     D global          s              1n
     D x               s             10i 0

     D k1hed9          ds                  likerec(p1hed9:*key)
     D k1t622          ds                  likerec(s1t622:*key)

     D peDsD0          ds                  likeds( dsPahed0_t ) dim( 999 )
     D p2DsD0          ds                  likeds( dsPahed0_t ) dim( 999 )
     D peDsC1          ds                  likeds ( dsPaheC1_t ) dim( 999 )
     D p2DsC1          ds                  likeds ( dsPaheC1_t ) dim( 999 )
     D inEd0           ds                  likerec(p1hed0:*input)
     D peDsD0c         s             10i 0
     D p2DsD0c         s             10i 0
     D peDsC1C         s             10i 0

      /free

       SVPAXI_inz();

       k1hed9.d9empr = peEmpr;
       k1hed9.d9sucu = peSucu;
       k1hed9.d9arcd = peArcd;
       k1hed9.d9spol = peSpol;
       k1hed9.d9sspo = peSspo;
       k1t622.t@arcd = peArcd;
       k1t622.t@rama = peRama;
       k1t622.t@arse = peArse;
       k1t622.t@oper = peOper;

       setll %kds(k1hed9:5) pahed9;
       setll %kds(k1t622:4) set622;

       global = %equal(pahed9) or %equal(set622);

       @@indi = 'AI';
       if %parms >= 13 and %addr(peIndi) <> *null;
          @@indi = peIndi;
       endif;

       if %parms >= 14 and %addr(peViba) <> *null;
          peViba = 1;
       endif;

       if %parms >= 15 and %addr(peViaj) <> *null;
          peViaj = 1;
       endif;

       if %parms >= 16 and %addr(pxFeba) <> *null;
          pxFeba = 0;
       endif;

       if SVPAXI_chkIndice( @@indi ) = *off;
          return peImpo;
       endif;

       if SVPPOL_getPoliza( peEmpr
                          : peSucu
                          : peRama
                          : pePoli
                          : peSuop
                          : peArcd
                          : peSpol
                          : peSspo
                          : peArse
                          : peOper
                          : peDsD0
                          : peDsD0C ) = *off;
          return peImpo;
       endif;

       if peDsD0C <= 0;
          return peImpo;
       endif;

       if SPVSPO_getCabeceraSuplemento( peEmpr
                                      : peSucu
                                      : peArcd
                                      : peSpol
                                      : peSspo
                                      : peDsC1
                                      : peDsC1C ) = *off;
          return peImpo;
       endif;

       if peDsC1C <= 0;
          return peImpo;
       endif;

       //
       // Endosos positivos que no sean TIOU = 4 ni
       // TIOU = 3 and STOU = 90
       //  Para estos casos, la fecha base es la fecha de
       //  emisión del mismo movimiento
       //
       if peDsD0(1).d0prim >= 0   and
          (peDsD0(1).d0tiou <> 4) and
          not (peDsD0(1).d0tiou = 3 and peDsD0(1).d0stou = 90);
          peFeba = (peDsC1(1).c1fema * 10000)
                 + (peDsC1(1).c1femm *   100)
                 +  peDsC1(1).c1femd;
          if %parms >= 16 and %addr(pxFeba) <> *null;
             pxFeba = peFeba;
          endif;
        else;
          //
          // Resto del universo: fecha base del endoso
          // afectado
          // OJOTA con esto porque acá hay que iterar
          // hasta dar con el endoso afectado
          //
              if not global;
                 if SVPPOL_getPoliza( peEmpr
                                    : peSucu
                                    : peRama
                                    : pePoli
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : p2DsD0
                                    : p2DsD0C ) = *off or p2DsD0C <= 0;
                    return peImpo;
                 endif;
               else;
                 clear p2DsD0;
                 p2DsD0c = 0;
                 clear p1hed0;
                 setll %kds(k1hed9:4) pahed0;
                 reade %kds(k1hed9:4) pahed0 inEd0;
                 dow not %eof;
                     p2DsD0c += 1;
                     eval-corr p2DsD0(p2DsD0C) = inEd0;
                  reade %kds(k1hed9:4) pahed0 inEd0;
                 enddo;
              endif;
              for x = peSspo downto 1;
                  refa = (p2DsD0(x).d0tiou = 3 and p2DsD0(x).d0stos = 1);
                  nuev = (p2DsD0(x).d0tiou = 1);
                  reno = (p2DsD0(x).d0tiou = 2);
                  if refa or nuev or reno;
                     if SPVSPO_getCabeceraSuplemento( peEmpr
                                                    : peSucu
                                                    : peArcd
                                                    : peSpol
                                                    : p2DsD0(x).d0sspo
                                                    : peDsC1
                                                    : peDsC1C ) = *off;
                        return peImpo;
                     endif;
                     peFeba = (peDsC1(1).c1fema * 10000)
                            + (peDsC1(1).c1femm *   100)
                            +  peDsC1(1).c1femd;
                     if %parms >= 16 and %addr(pxFeba) <> *null;
                        pxFeba = peFeba;
                     endif;
                     leave;
                  endif;
              endfor;
       endif;

       if %parms >= 14 and %addr(peViba) <> *null;
          peViba = SVPAXI_getIndice( @@indi : peFeba );
       endif;

       if %parms >= 15 and %addr(peViaj) <> *null;
          peViaj = SVPAXI_getIndice( @@indi : peFeac );
       endif;

       //
       // Ultimo seguro por las que te jedi
       //
       if peFeba <= 0;
          return peImpo;
       endif;

       return SVPAXI_ajustarPorInflacion( @@indi
                                        : peImpo
                                        : peFeba
                                        : peFeac );

      /end-free

     P SVPAXI_ajusteRamaSecuenciaVida...
     p                 e

