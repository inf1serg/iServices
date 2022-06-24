     H nomain
      * ************************************************************ *
      * SVPEMI: Programa de Servicio.                                *
      *         Emision.-                                            *
      * ------------------------------------------------------------ *
      * Gomez Luis R.                     ** 18-abr-2018 **          *
      * ************************************************************ *
      * Modificaciones:                                              *
      *                                                              *
      * NWN 10/05/2019: Agregado de Derecho de emisión en SPEXCODE.  *
      * GIO 24-06-2019 El derecho de emisión por endosos y por rama  *
      *                se toma del SET122 -> SVPEMI_getImpuetosPorc  *
      *                para endosos                                  *
      * LRG 01/03/2020: Se agregan los procedimientos:               *
      *                 _CalculaPrimas                               *
      *                 _calcImpuestosPorc                           *
      *                 _calcPremio                                  *
      *                                                              *
      * ************************************************************ *
     Fpawpc0    uf a e           k disk    usropn
     Fpahec1    uf a e           k disk    usropn
     Fset001    if   e           k disk    usropn
     Fset121    if   e           k disk    usropn
     Fset122    if   e           k disk    usropn
     Fset123    if   e           k disk    usropn
     Fset228    if   e           k disk    usropn
     Fset611    if   e           k disk    usropn
     Fset6111   if   e           k disk    usropn
     Fset6118   if   e           k disk    usropn
     Fset621    if   e           k disk    usropn
     Fset9431   if   e           k disk    usropn
     Fset94301  if   e           k disk    usropn
     Fpahcd5    uf a e           k disk    usropn
     Fpahcd502  if   e           k disk    usropn
     Fpaheg3    if   e           k disk    usropn
     Fsehni201  if   e           k disk    usropn
     Fpahcc2    uf a e           k disk    usropn
     Fsehase    if   e           k disk    usropn

      *--- PR Externos --------------------------------------------- *
     D SPT224          pr                  extpgm('SPT224')
     D  Ds224                              likeds  ( dsSet224_t ) const
     D  @in20                         1
     D  endpgm                        2    const

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpemi_h.rpgle'

      * ------------------------------------------------------------ *
      * Setea error global
      * --------------------------------------------------- *
     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

     D Local           ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(Local:401)
     D  sucu                          2a   overlay(Local:402)

     ?* Procedimientos --------------------------------------------- *

     Dpar313d          pr                  extpgm('PAR313D')
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peSuop                        3  0 const
     D  pePrrc                       15  2
     D  pePrac                       15  2
     D  pePrin                       15  2
     D  pePrro                       15  2
     D  pePacc                       15  2
     D  pePraa                       15  2
     D  pePrsf                       15  2
     D  pePrce                       15  2
     D  pePrap                       15  2
     D  peCdin                       10    options(*nopass) const
     D  peLote                        3  0 options(*nopass) const
     D  pePoli                        7  0 options(*nopass) const
     D  peEndo                        7  0 options(*nopass) const
      *
     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

     D SPDERE          pr                  extpgm('SPDERE')
     D peTiou                         1  0
     D peStou                         2  0
     D petio1                         1  0
     D peEnco                         1
     D peClos                         3
     D peStos                         2  0

     D SPCADCOM        pr                  extpgm('SPCADCOM')
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1  0
     D  nivc                          5  0
     D  cade                          5  0 dim(9)
     D  erro                           n
     D  endp                          3a
     D  nrdf                          7  0 dim(9) options(*nopass)

     Dspexcode         pr                  extpgm('SPEXCODE')
     D                                1a
     D                                2a
     D                                1  0
     D                                5  0
     D                                2  0
     D                                1  0
     D                                2  0
     D                                8  0
     D                                3a
     D                                 n
     D                               15  2
     D                                1a
     D                                1a
     D                                5  0
     D                               15  2

     D
     DPAR312C1         pr                  extpgm('PAR312C1')
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peSuop                        3  0 const
     D  peMone                        2
     D  peMar1                        1
     D  peDere                       15  2
     D  peXrea                        5  2
     D  peXref                        5  2
     D  peMarp                        1
     D  peEnco                        1
     D  peFinp                        3    options(*nopass)
     D  peModo                        1    options(*nopass)
     D  peCdin                       10    options(*nopass)
     D  peLote                        6  2 options(*nopass)
     D  pePoli                        7  0 options(*nopass)
     D  peEndo                        7  0 options(*nopass)
     D  pePoco                        4  0 options(*nopass)

     DDBA918R          pr                  extpgm('DBA918R')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNrpp                        3  0 const
     D  peMone                        2a   const
     D  peXref                        5  2
     D  peFech                        8  0 const options(*nopass:*omit)

     DPRO401S          pr                  extpgm('PRO401S')
     D                                2  0 const
     D                                2  0 const
     D                                2    const
     D                               15  6 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                                9  6 options(*nopass)
     D                                9  6 options(*nopass)
     D                                2  0 options(*nopass)
     D                               15  2 options(*nopass)

     Dpro401n          pr                  extpgm('PRO401N')
     D                                2  0 const
     D                                2  0 const
     D                                2    const
     D                               15  6 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                                9  6 options(*nopass)
     D                                9  6 options(*nopass)
     D                                2  0 options(*nopass)
     D                               15  2 options(*nopass)

     Dpro401m          pr                  extpgm('PRO401M')
     D                                2  0 const
     D                                2  0 const
     D                                1    const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2

     Dpro401o          pr                  extpgm('PRO401O')
     D                                2  0 const
     D                                2  0 const
     D                                2    const
     D                               15  6 const
     D                               15  2 const
     D                               15  2 const
     D                                7  0 const
     D                                2  0 const
     D                               15  2 const
     D                               15  2 const
     D                               15  2 const
     D                                9  6 const
     D                               15  2 const
     D                               11    options(*nopass)
      *
     Dpro401t          pr                  extpgm('PRO401T')
     D                               15  6 const
     D                                2  0 const
     D                                1    const
     D                               15  2 const
     D                               15  2 const
     D                                5  2 const
     D                                5  2 const
     D                                5  2 const
     D                               15  2
     D                               15  2
     D                               15  2

     Dpro401te         pr                  extpgm('PRO401TE')
     D                                7  0 const
     D                                5  2 const
     D                                1

     DSP0078           pr                  extpgm('SP0078')
     D                                7  0 const
     D                                2  0
     D                                8  0
     D                                8  0
     D                               15  2
     D                               15  2
     D                                5  2
     D                                1

     D PAR312E         pr                  ExtPgm('PAR312E')
     D  prem                         15  2
     D  ccuo                          2  0
     D  ci1c                          1  0
     D  dv1c                          2  0
     D  cimc                          1  0
     D  immc                         15  2
     D  dfv1                          2  0
     D  dfm1                          2  0
     D  dfv2                          2  0
     D  dfm2                          2  0
     D  ivat                         15  2
     D  fdia                          2  0
     D  fmes                          2  0
     D  faÑo                          4  0
     D  come                         15  6
     D  fech                          8  0 dim(30)
     D  impo                         15  2 dim(30)
     D  nrpp                          3  0 const options(*nopass:*omit)

     D SP0001          pr                  extpgm('SP0001')
     D  fech                          8  0
     D  cant                          2  0
     D  fpgm                          3a   options(*nopass)

     Dspchkcode        pr                  extpgm('SPCHKCODE')
     D                                1
     D                                2
     D                                6  0
     D                                9  0
     D                                1  0
     D                                 n
     D                                3

     Dspdfec           pr                  extpgm('SPDFEC')
     D  peFvod                        2  0
     D  peFvom                        2  0
     D  peFvoa                        4  0
     D  peFiod                        2  0
     D  peFiom                        2  0
     D  peFioa                        4  0
     D  peLap1                        5  0


     ?*--- Definicion de Procedimiento ----------------------------- *
     ?* ------------------------------------------------------------ *
     ?* SVPEMI_inz(): Inicializa módulo.                             *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPEMI_inz      B                   export
     D SVPEMI_inz      pi

      /free

       if (initialized);
          return;
       endif;

       Local.empr = 'A';
       Local.sucu = 'CA';
       out Local;

       if not %open(pawpc0);
         open pawpc0;
       endif;

       if not %open(pahec1);
         open pahec1;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(set121);
         open set121;
       endif;

       if not %open(set122);
         open set122;
       endif;

       if not %open(set123);
         open set123;
       endif;

       if not %open(set611);
         open set611;
       endif;

       if not %open(set6111);
         open set6111;
       endif;

       if not %open(set6118);
         open set6118;
       endif;

       if not %open(set621);
         open set621;
       endif;

       if not %open(set9431);
         open set9431;
       endif;

       if not %open(set94301);
         open set94301;
       endif;

       if not %open(pahcd5);
         open pahcd5;
       endif;

       if not %open(pahcd502);
         open pahcd502;
       endif;

       if not %open(paheg3);
         open paheg3;
       endif;

       if not %open(sehni201);
         open sehni201;
       endif;

       if not %open(pahcc2);
         open pahcc2;
       endif;

       if not %open(set228);
         open set228;
       endif;

       if not %open(sehase);
         open sehase;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPEMI_inz      E

     ?* ------------------------------------------------------------ *
     ?* SVPEMI_End(): Finaliza módulo.                               *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPEMI_End      B                   export
     D SVPEMI_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPEMI_End      E

     ?* ------------------------------------------------------------ *
     ?* SVPEMI_Error(): Retorna el último error del service program  *
     ?*                                                              *
     ?*     peEnbr   (output)  Número de error (opcional)            *
     ?*                                                              *
     ?* Retorna: Mensaje de error.                                   *
     ?* ------------------------------------------------------------ *

     P SVPEMI_Error    B                   export
     D SVPEMI_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPEMI_Error    E

     ?* ------------------------------------------------------------ *
     ?* SVPEMI_setSuspendida: Suspender Superpoliza.-                *
     ?*                                                              *
     ?*     peDsSp   ( input )  Estructura de suspendida             *
     ?*                                                              *
     ?* Retorna: *on = Se suspendio / *off = No se suspendio         *
     ?* ------------------------------------------------------------ *
     p SVPEMI_setSuspendida...
     p                 b                   export
     D SVPEMI_setSuspendida...
     D                 pi              n
     D   peDsSp                            likeds  ( dsPawpc0_t ) const

     D   @@DsOsp       ds                  likerec ( p1wpc0 : *output )

      /free

       SVPEMI_inz();

       if not SPVSPO_chkSpolSuspendida ( peDsSp.w0empr
                                       : peDsSp.w0sucu
                                       : peDsSp.w0arcd
                                       : peDsSp.w0spol );
       endif;

       eval-corr @@DsOSp = peDsSp;

       write p1wpc0 @@DsOSp;

       return *on;
      /end-free

     p SVPEMI_setSuspendida...
     p                 e

     ?* ------------------------------------------------------------ *
     ?* SVPEMI_calcPrima : Calcula prima.-                           *
     ?*                                                              *
     ?*     peEmpr  ( input  )  Empresa                              *
     ?*     peSucu  ( input  )  Sucursal                             *
     ?*     peArcd  ( input  )  Articulo                             *
     ?*     peSpol  ( input  )  SuperPoliza                          *
     ?*     peSspo  ( input  )  Suplemento                           *
     ?*     peRama  ( input  )  Rama                                 *
     ?*     peArse  ( input  )  Cant. de polizas                     *
     ?*     peOper  ( input  )  Código de operación                  *
     ?*     peSuop  ( input  )  Suplemento de Operacion              *
     ?*     pePoco  ( input  )  Número de Componente                 *
     ?*     peRiec  ( input  )  Código de Riesgo                     *
     ?*     peXcob  ( input  )  Código de Cobertura                  *
     ?*     peMont  ( input  )  Monto de Prima inicial               *
     ?*                                                              *
     ?* Retorna: Devuelve valor de Prima                             *
     ?* ------------------------------------------------------------ *
     p SVPEMI_calcPrima...
     p                 b                   export
     D SVPEMI_calcPrima...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peMont                      15  2 const

     D   @@empr        s              1
     D   @@sucu        s              2
     D   @@arcd        s              6  0
     D   @@spol        s              9  0
     D   @@sspo        s              3  0
     D   @@rama        s              2  0
     D   @@arse        s              2  0
     D   @@oper        s              7  0
     D   @@suop        s              3  0
     D   @@poco        s              4  0
     D   @@riec        s              3
     D   @@xcob        s              3  0
     D   @@mont        s             15  2
     D   @@end         s              3

      /free

       SVPEMI_end();

       @@empr = peEmpr;
       @@sucu = peSucu;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@sspo = peSspo;
       @@rama = peRama;
       @@arse = peArse;
       @@oper = peOper;
       @@suop = peSuop;
       @@poco = pePoco;
       @@riec = peRiec;
       @@xcob = peXcob;
       @@mont = peMont;

       PAR314E( @@empr
              : @@sucu
              : @@arcd
              : @@spol
              : @@sspo
              : @@rama
              : @@arse
              : @@oper
              : @@suop
              : @@poco
              : @@riec
              : @@xcob
              : @@mont
              : @@end   );

         return @@mont;
      /end-free

     p SVPEMI_calcPrima...
     p                 e

     ?* ------------------------------------------------------------ *
     ?* SVPEMI_setCabeceraEndosoSuperpoliza: Graba Cabecera de Endoso*
     ?*                                      de Superpoliza          *
     ?*                                                              *
     ?*     peDsC1  (  input  )  Estructura de Detalle               *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     p SVPEMI_setCabeceraEndosoSuperpoliza...
     p                 b                   export
     D SVPEMI_setCabeceraEndosoSuperpoliza...
     D                 pi              n
     D   peDsC1                            likeds( dsPahec1_t ) const

     D   @@DsOC1       ds                  likerec( p1hec1 : *output )

      /free

       SVPEMI_inz();

       if not SPVSPO_chkSspo( peDsC1.c1empr
                            : peDsC1.c1sucu
                            : peDsC1.c1arcd
                            : peDsC1.c1spol
                            : peDsC1.c1sspo );
         return *off;
       endif;

       eval-corr @@DsOC1 = peDsC1;
       monitor;
         write p1hec1 @@DsOC1;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free
     p SVPEMI_setCabeceraEndosoSuperpoliza...
     p                 e

     ?* ------------------------------------------------------------ *
     ?* SVPEMI_calcPrimaDelPeriodo: Cálculo de Prima del Período     *
     ?*                                                              *
     ?*     peEmpr  ( input  )  Empresa                              *
     ?*     peSucu  ( input  )  Sucursal                             *
     ?*     peArcd  ( input  )  Articulo                             *
     ?*     peSpol  ( input  )  SuperPoliza                          *
     ?*     peSspo  ( input  )  Suplemento                           *
     ?*     peRama  ( input  )  Rama                                 *
     ?*     peArse  ( input  )  Cant. de polizas                     *
     ?*     peOper  ( input  )  Código de operación                  *
     ?*     peSuop  ( input  )  Suplemento de Operacion              *
     ?*     pePrrc  ( output )  Prima Rc                             *
     ?*     pePrac  ( output )  Prima de Accidente                   *
     ?*     pePrin  ( output )  Prima Incendio                       *
     ?*     pePrro  ( output )  Prima Robo                           *
     ?*     pePacc  ( output )  Prima Accesorio                      *
     ?*     pePraa  ( output )  Prima Ajuste Automatico              *
     ?*     pePrsf  ( output )  Prima Sin Franquicia                 *
     ?*     pePrce  ( output )  Prima Rc Exterior                    *
     ?*     pePrap  ( output )  Prima Accidentes Personales          *
     ?*     peCdin  ( input  )  Codigo interfaz  ( opcional )        *
     ?*     peLote  ( input  )  Nro. de Lote     ( opcional )        *
     ?*     pePoli  ( input  )  Poliza           ( opcional )        *
     ?*     peEndo  ( input  )  Endoso           ( opcional )        *
     ?*                                                              *
     ?* Retorna: Devuelve valor de Prima                             *
     ?* ------------------------------------------------------------ *
     p SVPEMI_calcPrimaDelPeriodo...
     p                 b                   export
     D SVPEMI_calcPrimaDelPeriodo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePrrc                      15  2
     D   pePrac                      15  2
     D   pePrin                      15  2
     D   pePrro                      15  2
     D   pePacc                      15  2
     D   pePraa                      15  2
     D   pePrsf                      15  2
     D   pePrce                      15  2
     D   pePrap                      15  2
     D   peCdin                      10    options(*nopass) const
     D   peLote                       3  0 options(*nopass) const
     D   pePoli                       7  0 options(*nopass) const
     D   peEndo                       7  0 options(*nopass) const

      /free

       SVPEMI_inz();

       Select;
         when %parms >= 19;

            PAR313D( peEmpr
                   : peSucu
                   : peArcd
                   : peSpol
                   : peSspo
                   : peRama
                   : peArse
                   : peOper
                   : peSuop
                   : pePrrc
                   : pePrac
                   : pePrin
                   : pePrro
                   : pePacc
                   : pePraa
                   : pePrsf
                   : pePrce
                   : pePrap
                   : peCdin
                   : peLote
                   : pePoli
                   : peEndo );

       when %parms <= 18;

         PAR313D( peEmpr
                : peSucu
                : peArcd
                : peSpol
                : peSspo
                : peRama
                : peArse
                : peOper
                : peSuop
                : pePrrc
                : pePrac
                : pePrin
                : pePrro
                : pePacc
                : pePraa
                : pePrsf
                : pePrce
                : pePrap );

       endsl;

       return *on;

      /end-free

     p SVPEMI_calcPrimaDelPeriodo...
     p                 e

     ?* -------------------------------------------------------------*
     ?* SVPEMI_getImpuetosPorc: Retorna Porcentajes de Impuestos     *
     ?*                                                              *
     ?*     peEmpr  ( input  )  Empresa                              *
     ?*     peSucu  ( input  )  Sucursal                             *
     ?*     peArcd  ( input  )  Articulo                             *
     ?*     peSpol  ( input  )  SuperPoliza                          *
     ?*     peSspo  ( input  )  Suplemento                           *
     ?*     pePrim  ( input  )  Prima                                *
     ?*     peDsPi  ( output )  Estructura % Impuestos               *
     ?*                                                              *
     ?* Retorna : *on = encontro / *off = No encontro                *
     ?* -------------------------------------------------------------*
     P SVPEMI_getImpuetosPorc...
     P                 B                   export
     D SVPEMI_getImpuetosPorc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePrim                      15  2 const
     D   peDsPi                            likeds( dsPorcImp_t )

     D k1y001          ds                  likerec( s1t001  : *key )
     D k1y122          ds                  likerec( s1t122  : *key )
     D k1y123          ds                  likerec( s1t123  : *key )
     D k1y611          ds                  likerec( s1t611  : *key )
     D k1y6118         ds                  likerec( s1t6118 : *key )

     D @@aux1          s             29  9
     D @@empr          s              1a
     D @@sucu          s              2a
     D @@arcd          s              6  0
     D @@spol          s              7  0
     D @@sspo          s              3  0
     D @@rama          s              2  0
     D @@arse          s              2  0
     D @@oper          s              7  0
     D @@suop          s              3  0
     D @@mone          s              2
     D @@come          s             15  6
     D @1mar1          s              1
     D @1marp          s              1
     D @@nivt          s              1  0
     D @@nivc          s              5  0
     D @@nomb          s             40
     D @1tiou          s              1  0
     D @@tiou          s              1  0
     D @@stou          s              2  0
     D @@stos          s              2  0
     D @1dere          s             15  2
     D @1xrea          s              5  2
     D @1xref          s              5  2
     D @@bpip          s              5  2
     D @1bpri          s             15  2
     D @@endp          s              3a   inz ( '   ' )
     D @@dere          s             15  2
     D @@enco          s              1
     D @@marp          s              1
     D @@mar1          s              1
     D @@modo          s              1
     D @@neto          s             15  2
     D @@pgm           s              3
     D @@d             s              2  0
     D @@m             s              2  0
     D @@a             s              4  0
     D @@cade          s              5  0 dim(9)
     D @@erro          s              1n
     D @@facc          s              1
     D @@fech          s              8  0
     D @@niv6          s              1  0 inz ( 6 )
     D @@tien          s               n
     D @@vacc          s             15  2
     D @@tvcc          s              1a
     D @@xdia          s              5  0

      *
     D rc              s               n
      *
     D @@DsArt         ds                  likeds( dsset630_t )
     D @@DsD0          ds                  likeds( dsPahed0_t ) dim( 999 )
     D @@DsD0C         s             10i 0
     D @1DsD0          ds                  likeds( dsPahed0_t ) dim( 999 )
     D @1DsD0C         s             10i 0
     D @@DsC1          ds                  likeds( dsPahec1_t ) dim( 999 )
     D @@DsC1C         s             10i 0
     D @@DsC3          ds                  likeds( dsPahec3V2_t )

       SVPEMI_inz();

       rc = SVPART_getParametria( peArcd
                                : @@DsArt );

       @@sspo = peSspo;
       clear @@DsC3;
       rc = SPVSPO_getPlandePagoV2( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : @@sspo
                                  : @@DsC3 );

       rc = SPVSPO_getCabeceraSuplemento( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : @@DsC1
                                        : @@DsC1C );

       rc = SVPPOL_getPolizadesdeSuperPoliza( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsD0
                                            : @@DsD0C       );

       eval(h) @1bpri = ( pePrim * @@DsC3.c3bpip ) / 100 ;
       @@neto = pePrim - @1bpri;
       @@rama = @@DsD0( @@DsD0C ).d0rama;
       @@tiou = @@DsD0( @@DsD0C ).d0tiou;
       @@stou = @@DsD0( @@DsD0C ).d0stou;
       @@stos = @@Dsd0( @@DsD0C ).d0stos;
       @@arse = @@DsD0( @@DsD0C ).d0arse;
       @@oper = @@Dsd0( @@DsD0C ).d0oper;
       @@aux1 = @@DsD0( @@DsD0C ).d0dup2 * @@DsD0( @@DsD0C ).d0pecu;

       @@nivt = @@DsC1( @@DsC1C ).c1nivt;
       @@nivc = @@DsC1( @@DsC1C ).c1nivc;
       @@mone = @@DsC1( @@DsC1C ).c1mone;
       @@come = @@DsC1( @@DsC1C ).c1come;

       chain @@rama set001;
       if not %found( set001 );
         return *off;
       endif;
       chain @@rama set123;
       if not %found( set123 );
         return *off;
       endif;

       k1y611.t@plac = @@Dsd0( @@DsD0C ).d0plac;
       k1y611.t@mone = @@mone;
       setll %kds( k1y611 : 2 ) set611;
       reade %kds( k1y611 : 2 ) set611;
       dow not %eof( set611 );
         if @@aux1 <= t@xmes;
           @@marp = t@marp;
           @@mar1 = t@mar1;
           t@dere = *zeros;
           leave;
         endif;
        reade %kds( k1y611 : 2 ) set611;
       enddo;

       k1y6118.t@empr = peEmpr;
       k1y6118.t@sucu = peSucu;
       k1y6118.t@nivt = @@nivt;
       k1y6118.t@nivc = @@nivc;
       k1y6118.t@rama = @@rama;

       if @@DsArt.t@ma26 = '1';
         chain %kds( k1y6118 : 5 ) set6118;

         if %found( set6118 );
           @@marp = t@marp;
           @@mar1 = t@mar1;
         endif;
       endif;

       // Condiciones Especiales de Recargo...
       @@mar1 = '_';
       if @@mar1 <> *blanks;
         if t@marp = 'T';
           SPDERE( @@tiou
                 : @@stou
                 : @1tiou
                 : @@enco
                 : @@pgm
                 : @@stos );

           k1y122.t@rama = @@rama;
           k1y122.t@arcd = peArcd;
           k1y122.t@mone = @@mone;
           k1y122.t@tiou = @1tiou;
           chain %kds( k1y122 : 4 ) set122;
           if %found( set122 );
             Select;
               When @@neto > t@tpr1 and
                    @@neto > t@tpr2 and
                    @@neto > t@tpr3 and
                    @@neto > t@tpr4;
                    @@dere = t@dem5;

               When @@neto > t@tpr1 and
                    @@neto > t@tpr2 and
                    @@neto > t@tpr3;
                    @@dere = t@dem4;

               When @@neto > t@tpr1 and
                    @@neto > t@tpr2;
                    @@dere = t@dem3;

               When @@neto > t@tpr1;
                    @@dere = t@dem2;
               other;
                    @@dere = t@dem1;
             endsl;
           endif;

           t@dere = @@dere;
           @1mar1 = @@mar1;
           @1dere = t@dere;
           @1xrea = t@xrea;
           @1xref = t@xref;
           @1marp = t@marp;
           clear @@enco;
           clear @@pgm;
           @@modo = 'I';

           PAR312C1( @@empr
                   : @@sucu
                   : @@arcd
                   : @@spol
                   : @@sspo
                   : @@rama
                   : @@arse
                   : @@oper
                   : @@suop
                   : @@mone
                   : @1mar1
                   : @1dere
                   : @1xrea
                   : @1xref
                   : @1marp
                   : @@enco
                   : @@pgm
                   : @@modo );

           if @@enco = 'S';
             t@xref = @1xref;
             t@xrea = @1xrea;
             t@dere = @1dere;
             @@marp = @1marp;
           endif;
         endif;
       endif;

       if @@DsArt.t@ma25 = '1' and
          @@tiou = 3           and
          t@rame <> 04 ;

          rc = SVPPOL_getPolizadesdeSuperPoliza( peEmpr
                                               : peSucu
                                               : peArcd
                                               : peSpol
                                               : 0
                                               : @@rama
                                               : @@arse
                                               : @@oper
                                               : 0
                                               : @1DsD0
                                               : @1DsD0C );
          t@bpip =  @1DsD0( 1 ).d0bpip;
          t@xref =  @1DsD0( 1 ).d0xref;
          t@xrea =  @1DsD0( 1 ).d0xrea;
          if @1DsD0( 1 ).d0bpep <> *zeros;
            t@dere = @1DsD0( 1 ).d0bpep;
            t@marp = 'P';
            @@marp = 'P';
          else;
            t@dere = @1DsD0( 1 ).d0dere;
            t@marp = ' ';
            @@marp = ' ';
          endif;
       endif;

       //Derecho por importe o % ?...
       if @@marp      = ' '  or
          @@marp      = 'T'  or
          @@marp      = 'A';
          peDsPi.Tder = 'I';
       endif;

       if @@marp = 'T' or @@tiou = 3;
         SPDERE( @@tiou
               : @@stou
               : @1tiou
               : @@enco
               : @@pgm
               : @@stos );

         k1y122.t@rama = @@rama;
         k1y122.t@arcd = peArcd;
         k1y122.t@mone = @@mone;
         k1y122.t@tiou = @1tiou;
         chain %kds( k1y122 : 4 ) set122;
         if %found( set122 );
           Select;
             When @@neto > t@tpr1 and
                  @@neto > t@tpr2 and
                  @@neto > t@tpr3 and
                  @@neto > t@tpr4;
                  t@dere = t@dem5;

             When @@neto > t@tpr1 and
                  @@neto > t@tpr2 and
                  @@neto > t@tpr3;
                  t@dere = t@dem4;

             When @@neto > t@tpr1 and
                  @@neto > t@tpr2;
                  t@dere = t@dem3;

             When @@neto > t@tpr1;
                  t@dere = t@dem2;
             other;
                  t@dere = t@dem1;
           endsl;
         endif;
       endif;

       PAR310X3 ( peEmpr : @@a : @@m : @@d );

       @@fech = (@@a * 10000) + (@@m * 100) + @@d;

       SPCADCOM ( @@empr
                : @@sucu
                : @@nivt
                : @@nivc
                : @@cade
                : @@erro
                : @@endp );

       SPEXCODE( @@empr : @@sucu : @@niv6 : @@cade( 6 ) : @@rama : @@tiou
               : @@stou : @@fech : @@endp : @@tien : @@vacc : @@tvcc
               : @@facc : @@xdia : @@dere);

       if @@tien;
         if @@come <> *Zeros;
           @@vacc = @@vacc/@@come;
           @@dere = @@dere/@@come;
         endif;
         t@dere = t@dere + @@dere;
       endif;

       peDsPi.Bpip = t@bpip + @@dsC3.c3bpip;

       DBA918R( peEmpr
              : peSucu
              : @@DsC3.c3nrpp
              : @@mone
              : t@xref
              : *omit          );

       peDsPi.xref = t@xref;
       peDsPi.xrea = t@xrea;
       peDsPi.dere = t@dere;
       peDsPi.pimi = t@pimi;
       peDsPi.pssn = t@pssn;
       peDsPi.psso = t@psso;
       peDsPi.pivi = t@pivi;
       peDsPi.pivn = t@pivn;
       peDsPi.pivr = t@pivr;
       peDsPi.ivam = t@ivam;
       peDsPi.depp = *zeros;
       peDsPi.vacc = @@dere;

       return *on;

      /end-free

     P SVPEMI_getImpuetosPorc...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcPercepcion(): Retorna Importe de Percepcion           *
      *                          ( Calcula Perecpcion - IPR6 )           *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peMone (input)  Código de Moneda de Emision                 *
      *      peCome (input)  Cotizacion Moneda Emision                   *
      *      peNeto (input)  Prima Neta ( Prima - Bonificaciones ) x Porc*
      *      peSuas (input)  Suma Asegurada                              *
      *      peCiva (input)  Condicion de IVA                            *
      *      peIpr1 (input)  Impuesto Valor Agregado ( IVA )             *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peCuit (input)  Cuit                           ( opcional ) *
      *      peAsen (input)  Asegurado                      ( opcional ) *
      *      pePorc (input)  Porcentaje de Componente       ( opcional ) *
      *      pePpr1 (output) Impuesto Valor Agregado x Porc ( opcional ) *
      *      pePpr3 (output) IVA-Importe Percepcion x Porc  ( opcional ) *
      *      pePpr4 (output) IVA-Resp.No Inscripto x Porc   ( opcional ) *
      *                                                                  *
      * Retorna Importe de Percepcion / -1 = No calculo.                 *
      * ---------------------------------------------------------------- *
     P SVPEMI_CalcPercepcion...
     P                 B                   export
     D SVPEMI_CalcPercepcion...
     D                 pi            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   peNeto                      15  2 const
     D   peSuas                      15  2 const
     D   peCiva                       2  0 const
     D   peIpr1                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peCuit                      11    options( *omit : *nopass )
     D   peAsen                       7  0 options( *omit : *nopass )
     D   pePorc                       9  6 options( *omit : *nopass )
     D   pePpr1                      15  2 options( *omit : *nopass )
     D   pePpr3                      15  2 options( *omit : *nopass )
     D   pePpr4                      15  2 options( *omit : *nopass )

     D   @@ipr6        s             15  2 inz
     D   p@Porc        s              9  6
     D   p@Asen        s              7  0
     D   p@Cuit        s             11
     D   @@ipr1        s             15  2 inz
     D   @@ipr3        s             15  2 inz
     D   @@ipr4        s             15  2 inz

      /free

         SVPEMI_inz();

         if %parms >= 11 and %addr( peCuit ) <> *Null;
           p@Cuit = peCuit;
         endif;

         if %parms >= 12 and %addr( peAsen ) <> *Null;
           p@Asen = peAsen;
         endif;

         if %parms >= 13 and %addr( pePorc ) <> *Null;
           if pePorc = *Zeros;
             p@Porc = 100;
           else;
             p@Porc = pePorc;
           endif;
         else;
           p@Porc = 100;
         endif;

         @@ipr1 = peIpr1;
         @@ipr3 = peIpr3;
         @@ipr4 = peIpr4;

         pro401o( peRpro
                : peRama
                : peMone
                : peCome
                : peNeto
                : peSuas
                : p@Asen
                : peCiva
                : @@Ipr1
                : @@Ipr3
                : @@Ipr4
                : p@Porc
                : @@Ipr6
                : p@Cuit );

        if %parms >= 14 and %addr( pePpr1 ) <> *Null;
          pePpr1 = @@ipr1;
        endif;

        if %parms >= 15 and %addr( pePpr3 ) <> *Null;
          pePpr3 = @@ipr3;
        endif;

        if %parms >= 16 and %addr( pePpr4 ) <> *Null;
          pePpr4 = @@ipr4;
        endif;

        return @@Ipr6;

       /end-free

     P SVPEMI_CalcPercepcion...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcAlicuotaPercepcion(): Retorna Importe de Alicuota de  *
      *                                  Percepcion                      *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peIpr1 (input)  Impuesto Valor Agregado ( IVA )             *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peSubt (input)  Prima Neta ( Prima - Bonificaciones ) Total *
      *      peAsen (input)  Código de Asegurado                         *
      *      peCiva (input)  Código de IVA                               *
      *                                                                  *
      * Retorna Importe Alicuota de Percepcion / 0  = No Tiene           *
      * ---------------------------------------------------------------- *
     P SVPEMI_CalcAlicuotaPercepcion...
     P                 B                   export
     D SVPEMI_CalcAlicuotaPercepcion...
     D                 pi            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peIpr1                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peSubt                      15  2 const
     D   peAsen                       7  0 const
     D   peCiva                       2  0 const

     D   @@subt        s             15  2 inz
     D   @@d           s              2  0
     D   @@m           s              2  0
     D   @@a           s              4  0
     D   @@fech        s              8  0
     D   @@imau        s             15  2
     D   @@porc        s              5  2
     D   @@erro        s              1
     D   @@Rpro        s              2  0

     D   k1y94301      ds                  likerec( s1t94301 : *key )
     D   k1y9431       ds                  likerec( s1t9431  : *key )

      /free

       SVPEMI_inz();
       @@rpro = peRpro;
       k1y94301.t@rpro = 20;
       chain %kds( k1y94301 : 1 ) set94301;
         if %found( set94301 );
            k1y9431.t@cdin = t@cdin;
            k1y9431.t@rama = peRama;
            chain %kds( k1y9431 : 2 ) set9431;
            if not %found( set9431 );
              Select;
                When peCiva = 1;
                   @@subt   = peSubt;
                When peCiva = 7;
                   @@subt   =  peIpr1 + peIpr3;
                Other;
                   @@subt   =  peSubt + peIpr1;
              endsl;

              PAR310X3 ( Local.empr : @@a : @@m : @@d );
              @@fech = (@@a * 10000) + (@@m * 100) + @@d;
              SP0078 ( peAsen
                     : @@rpro
                     : @@fech
                     : @@fech
                     : @@subt
                     : @@imau
                     : @@porc
                     : @@erro );

           if @@imau <> *zeros;
             return @@imau;
           endif;
         endif;
        endif;

        return 0;

       /end-free

     P SVPEMI_CalcAlicuotaPercepcion...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcSelladosProvinciales():Retorna Importe de Sellados    *
      *                                   de Riesgos - Provinciales      *
      *                                   ( Calcula Sellado )            *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peMone (input)  Codigo de Moneda de Emision                 *
      *      peCome (input)  Cotizacion Moneda Emision                   *
      *      pePrim (input)  Prima x Porc                                *
      *      peBpri (input)  Bonificaciones x Porc                       *
      *      peRead (input)  Recargo Administrativo x Porc               *
      *      peRefi (input)  Recargo Financiero     x Porc               *
      *      peDere (input)  Derecho de Emision     x Porc               *
      *      peSubt (input)  Subtotal               x Porc               *
      *      peSuas (input)  Suma Asegurada                              *
      *      peImpi (input)  Impuestos Internos    ( Totales  )          *
      *      peSers (input)  Servicios Sociales    ( Totales  )          *
      *      peTssn (input)  Tasa SSN              ( Totales  )          *
      *      peIpr1 (input)  IVA                   ( Totales  )          *
      *      peIpr2 (input)  Acciones              ( Totales  )          *
      *      peIpr3 (input)  IVA-Importe Percepcion( Totales  )          *
      *      peIpr4 (input)  IVA-Resp.No Inscripto ( Totales  )          *
      *      peIpr5 (input)  Recargo de Capital    ( Totales  )          *
      *      peIpr6 (input)  Percepcion            ( Totales  )          *
      *      peIpr7 (input)  Ing.Brutos Riesgo     ( Totales  )          *
      *      peIpr8 (input)  Ing.Brutos Empresa    ( Totales  )          *
      *      pePrit (input)  Prima                 ( Totales  )          *
      *      peTiso (input)  Tipo de Sociedad                            *
      *      pePorc (input)  Porcentaje            ( Opcional )          *
      *      pePor1 (input)  Porcentaje 1          ( Opcional )          *
      *      peImfo (input)  Importe Folio         ( Opcional )          *
      *                                                                  *
      * Retorna Importe Sellado / -1 = No calculo                        *
      * ---------------------------------------------------------------- *
     P SVPEMI_CalcSelladosProvinciales...
     P                 B                   export
     D SVPEMI_CalcSelladosProvinciales...
     D                 pi            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   pePrim                      15  2 const
     D   peBpri                      15  2 const
     D   peRead                      15  2 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peSubt                      15  2 const
     D   peSuas                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   pePrit                      15  2 const
     D   peTiso                       2  0 const
     D   pePorc                       9  6 options( *nopass : *omit )
     D   pePor1                       9  6 options( *nopass : *omit )
     D   peImfo                      15  2 options( *nopass : *omit )

     D   @@seri        s             15  2
     D   @@imfo        s             15  2
     D   @@porc        s              9  6
     D   @@por1        s              9  6
     D   @@tiso        s              2  0
     D   @@rama        s              2  0

     D   k1y121        ds                  likerec( s1t121 : *key )

      /free

       SVPEMI_inz();
       @@rama = peRama;
       if %addr( pePorc ) = *null;
         k1y121.t@rpro = peRpro;
         k1y121.t@rama = @@rama;
         k1y121.t@tiso = peTiso;
         chain %kds( k1y121 : 3 ) set121;
         if not %found( set121 );
           k1y121.t@tiso = *zeros;
           chain %kds( k1y121 : 3 ) set121;
           if not %found( set121 );
             k1y121.t@rama = *zeros;
             chain %kds( k1y121 : 3 ) set121;
             if not %found( set121 );
               k1y121.t@tiso = peTiso;
               chain %kds( k1y121 : 3 ) set121;
             endif;
           endif;
         endif;
         if %found( set121 );
           if t@bcsl = 7 or t@bcsl = 4;
             clear @@porc;
             if pePrim <> *zeros;
               @@porc = ( Peprim / pePrit ) * 100;
             endif;
           endif;
         endif;
       else;
         @@porc = pePorc;
       endif;

       clear @@imfo;
       if %addr( peImfo ) <> *null;
         @@imfo= peImfo;
       endif;

       clear @@por1;
       if %addr( pePor1 ) <> *null;
         @@por1 = pePor1;
       endif;
       @@tiso = peTiso;

       PRO401S( peRpro
              : @@rama
              : peMone
              : peCome
              : pePrim
              : peBpri
              : peRead
              : peRefi
              : peDere
              : peSubt
              : peSuas
              : @@seri
              : peImpi
              : peSers
              : peTssn
              : peIpr1
              : peIpr2
              : peIpr3
              : peIpr4
              : peIpr5
              : peIpr6
              : peIpr7
              : peIpr8
              : @@porc
              : @@por1
              : @@tiso
              : @@imfo );

        return @@seri;

       /end-free
     P SVPEMI_CalcSelladosProvinciales...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcSelladoDeLaEmpresa(): Retorna Sellado de Empresa      *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peMone (input)  Codigo de Moneda de Emision                 *
      *      peCome (input)  Cotizacion Moneda Emision                   *
      *      pePrim (input)  Prima                                       *
      *      peBpri (input)  Bonificaciones                              *
      *      peRead (input)  Recargo Administrativo                      *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *      peSubt (input)  Subtotal x Porcentaje                       *
      *      peSuas (input)  Suma Asegurada                              *
      *      peImpi (input)  Impuestos Internos     ( Totales  )         *
      *      peSers (input)  Servicios Sociales     ( Totales  )         *
      *      peTssn (input)  Tasa SSN               ( Totales  )         *
      *      peIpr1 (input)  IVA                    ( Totales  )         *
      *      peIpr2 (input)  Acciones               ( Totales  )         *
      *      peIpr3 (input)  IVA-Importe Percepcion ( Totales  )         *
      *      peIpr4 (input)  IVA-Resp.No Inscripto  ( Totales  )         *
      *      peIpr5 (input)  Recargo de Capital     ( Totales  )         *
      *      peIpr6 (input)  Percepcion             ( Totales  )         *
      *      peIpr7 (input)  Ing.Brutos Riesgo      ( Totales  )         *
      *      peIpr8 (input)  Ing.Brutos Empresa     ( Totales  )         *
      *      pePrit (input)  Prima                  ( Totales  )         *
      *      peTiso (input)  Tipo de Sociedad                            *
      *      pePorc (input)  Porcentaje             ( Opcional )         *
      *      pePor1 (input)  Porcentaje 1           ( Opcional )         *
      *      peImfo (input)  Importe Folios         ( Opcional )         *
      *                                                                  *
      * Retorna Importe Sellado / -1 = No calculo                        *
      * ---------------------------------------------------------------- *
     P SVPEMI_CalcSelladoDeLaEmpresa...
     P                 B                   export
     D SVPEMI_CalcSelladoDeLaEmpresa...
     D                 pi            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   pePrim                      15  2 const
     D   peBpri                      15  2 const
     D   peRead                      15  2 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peSubt                      15  2 const
     D   peSuas                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   pePrit                      15  2 const
     D   peTiso                       2  0 const
     D   pePorc                       9  6 options( *nopass : *omit )
     D   pePor1                       9  6 options( *nopass : *omit )
     D   peimfo                      15  2 options( *nopass : *omit )

     D   @@seem        s             15  2 inz
     D   @@imfo        s             15  2
     D   @@porc        s              9  6
     D   @@por1        s              9  6
     D   @@tiso        s              2  0
     D   @@rama        s              2  0

     D   k1y121        ds                  likerec( s1t121 : *key )

      /free

       SVPEMI_inz();

       @@rama = peRama;
       if %addr( pePorc ) = *null;
         k1y121.t@rpro = peRpro;
         k1y121.t@rama = @@rama;
         k1y121.t@tiso = peTiso;
         chain %kds( k1y121 : 3 ) set121;
         if not %found( set121 );
           k1y121.t@tiso = *zeros;
           chain %kds( k1y121 : 3 ) set121;
           if not %found( set121 );
             k1y121.t@rama = *zeros;
             chain %kds( k1y121 : 3 ) set121;
             if not %found( set121 );
               k1y121.t@tiso = peTiso;
               chain %kds( k1y121 : 3 ) set121;
             endif;
           endif;
         endif;
         if %found( set121 );
           if t@bcsl = 7 or t@bcsl = 4;
             clear @@porc;
             if pePrim <> *zeros;
               @@porc = ( Peprim / pePrit ) * 100;
             endif;
           endif;
         endif;
       else;
         @@porc = pePorc;
       endif;

       clear @@imfo;
       if %addr( peImfo ) <> *null;
         @@imfo= peImfo;
       endif;

       clear @@por1;
       if %addr( pePor1 ) <> *null;
         @@por1 = pePor1;
       endif;
       @@tiso = peTiso;

       pro401n( peRpro
              : @@rama
              : peMone
              : peCome
              : pePrim
              : peBpri
              : peRead
              : peRefi
              : peDere
              : peSubt
              : peSuas
              : @@seem
              : peImpi
              : peSers
              : peTssn
              : peIpr1
              : peIpr2
              : peIpr3
              : peIpr4
              : peIpr5
              : peIpr6
              : peIpr7
              : peIpr8
              : @@porc
              : @@por1
              : @@tiso
              : @@imfo );

        return @@seem;

       /end-free
     P SVPEMI_CalcSelladoDeLaEmpresa...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcIngresosBrutos:  Retorna Importe de Inrgesos Brutos   *
      *                             ( Calcula IIb )                      *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peTipo (input)  Tipo de Impuesto  ( 'R' o 'E' )             *
      *      peNeto (input)  Prima Neta ( Prima - Bonificaciones )       *
      *      peRead (input)  Recargo Administrativo                      *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *                                                                  *
      * Retorna Importe IIB / -1 = No calculó                            *
      * ---------------------------------------------------------------- *
     P SVPEMI_CalcIngresosBrutos...
     P                 B                   export
     D SVPEMI_CalcIngresosBrutos...
     D                 pi            15  2
     D peRpro                         2  0 const
     D peRama                         2  0 const
     D peTipo                         1    const
     D peNeto                        15  2 const
     D peRead                        15  2 const
     D peRefi                        15  2 const
     D peDere                        15  2 const

     D @@iprx          s             15  2 inz

      /free

        SVPEMI_inz();

        pro401m( peRpro
               : peRama
               : peTipo
               : peNeto
               : peRead
               : peRefi
               : peDere
               : @@iprx );

        return @@iprx;

       /end-free

     P SVPEMI_CalcIngresosBrutos...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcIVA(): Retorna Importe Impuesto Valor agregado (IVA)  *
      *                   ( Calcula IVA )                                *
      *                                                                  *
      *      peCome (input)  Cotizacion de Moneda                        *
      *      peCiva (input)  Condicion de IVA                            *
      *      peSubt (input)  Subtotal(neto+refi+read+dere+ipr7+ipr8)     *
      *      pePivi (input)  % IVA Inscripto                             *
      *      pePivn (input)  % IVA No Inscripto                          *
      *      pePivr (input)  % Res.3125                                  *
      *      peIvam (input)  Mínimo Res.3125                             *
      *      peAsen (input)  Nro. de Asegurado ( opcional )              *
      *                                                                  *
      * Retorna Importe IVA / -1 = No Calculó                            *
      * ---------------------------------------------------------------- *
     P SVPEMI_CalcIVA...
     P                 B                   export
     D SVPEMI_CalcIVA...
     D                 pi            15  2
     D   peCome                      15  6   const
     D   peCiva                       2  0   const
     D   peSubt                      15  2   const
     D   pePivi                       5  2   const
     D   pePivn                       5  2   const
     D   pePivr                       5  2
     D   peIvam                      15  2   const
     D   peAsen                       7  0   options( *nopass :*omit )
      *
     D   @@ivrs        s              1
     D   @@ipr1        s             15  2
     D   @@ipr3        s             15  2
     D   @@ipr4        s             15  2
     D   @@asen        s              7  0
     D   @@pivr        s              5  2
     D   @@sino        s              1
     D   Asegurado     s               n

      /free

       SVPEMI_inz();

       // Excepcion...
       Asegurado = *off;
       if %parms >= 8 and %addr( peAsen ) <> *null;
         Asegurado = *on;
         @@asen = peAsen;
       endif;

       if Asegurado;
         PRO401TE( @@asen
                 : @@pivr
                 : @@sino );
         if @@sino = 'S';
           pePivr = @@pivr;
         endif;

         chain @@asen sehase;
         if %found( sehase );
           @@ivrs = asivrs;
         else;
           @@ivrs = '1';
           if peCiva = 1;
             @@ivrs = '0';
           endif;
         endif;
       else;
         @@ivrs = '1';
         if peCiva = 1;
           @@ivrs = '0';
         endif;
       endif;

       clear @@ipr1;
       clear @@ipr3;
       clear @@ipr4;


       PRO401T( peCome
              : peCiva
              : @@ivrs
              : peSubt
              : peIvam
              : pePivi
              : pePivn
              : pePivr
              : @@ipr1
              : @@ipr3
              : @@ipr4  );

       return @@ipr1;

      /end-free
     P SVPEMI_CalcIVA...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcIVATotal(): Retorna Importe Impuesto Valor agregado   *
      *                        ( Calcula Suma IVA TOTAL )                *
      *                                                                  *
      *      peCome ( input  ) Cotizacion de Moneda                      *
      *      peCiva ( input  ) Condicion de IVA                          *
      *      peSubt ( input  ) Subtotal(neto+refi+read+dere+ipr7+ipr8)   *
      *      pePivi ( input  ) % IVA Inscripto                           *
      *      pePivn ( input  ) % IVA No Inscripto                        *
      *      pePivr ( input  ) % Res.3125                                *
      *      peIvam ( input  ) Mínimo Res.3125                           *
      *      peAsen ( input  ) Nro. de Asegurado            ( opcional ) *
      *      peIpr1 ( output ) Imp.IVA                      ( opcional ) *
      *      peIpr3 ( output ) Imp.Percepcion               ( opcional ) *
      *      peIpr4 ( output ) Imp.Responsable No Inscripto ( opcional ) *
      *                                                                  *
      * Retorna Importe IVA / -1 = No Calculó                            *
      * ---------------------------------------------------------------- *
     P SVPEMI_CalcIVATotal...
     P                 B                   export
     D SVPEMI_CalcIVATotal...
     D                 pi            15  2
     D   peCome                      15  6   const
     D   peCiva                       2  0   const
     D   peSubt                      15  2   const
     D   pePivi                       5  2   const
     D   pePivn                       5  2   const
     D   pePivr                       5  2
     D   peIvam                      15  2   const
     D   peAsen                       7  0   options( *nopass :*omit )
     D   peIpr1                      15  2   options( *nopass :*omit )
     D   peIpr3                      15  2   options( *nopass :*omit )
     D   peIpr4                      15  2   options( *nopass :*omit )
      *
     D   @@mone        s              2
     D   @@ivrs        s              1
     D   @@ipr1        s             15  2
     D   @@ipr3        s             15  2
     D   @@ipr4        s             15  2
     D   @@asen        s              7  0
     D   @@pivr        s              5  2
     D   @@sino        s              1
     D   Asegurado     s               n

      /free

       SVPEMI_inz();

       // PRO401TE.- Excepcion...
       Asegurado = *off;
       if %parms >= 8 and %addr( peAsen ) <> *null;
         Asegurado = *on;
         @@asen = peAsen;
       endif;

       if Asegurado;
         PRO401TE( @@asen
                 : @@pivr
                 : @@sino );
         if @@sino = 'S';
           pePivr = @@pivr;
         endif;

         chain @@asen sehase;
         if %found( sehase );
           @@ivrs = asivrs;
         else;
           @@ivrs = '1';
           if peCiva = 1;
             @@ivrs = '0';
           endif;
         endif;
       else;
         @@ivrs = '1';
         if peCiva = 1;
           @@ivrs = '0';
         endif;
       endif;

       clear @@ipr1;
       clear @@ipr3;
       clear @@ipr4;


       PRO401T( peCome
              : peCiva
              : @@ivrs
              : peSubt
              : peIvam
              : pePivi
              : pePivn
              : pePivr
              : @@ipr1
              : @@ipr3
              : @@ipr4  );

       if %addr( @@ipr1 ) <> *null;
         peIpr1 = @@ipr1;
       endif;

       if %addr( @@ipr3 ) <> *null;
         peIpr3 = @@ipr3;
       endif;

       if %addr( @@ipr4 ) <> *null;
         peIpr4 = @@ipr4;
       endif;

       return @@ipr1 + @@ipr3 + @@ipr4;

      /end-free
     P SVPEMI_CalcIVATotal...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcIVANoInscripto():Retorna Importe de IVA-Responsable   *
      *                          no inscripto ( Calcula Importe )        *
      *                                                                  *
      *      peCome (input)  Cotizacion de Moneda                        *
      *      peCiva (input)  Condicion de IVA                            *
      *      peSubt (input)  Subtotal(neto+refi+read+dere+ipr7+ipr8)     *
      *      pePivi (input)  % IVA Inscripto                             *
      *      pePivn (input)  % IVA No Inscripto                          *
      *      pePivr (input)  % Res.3125                                  *
      *      peIvam (input)  Mínimo Res.3125                             *
      *      peAsen (input)  Nro. de Asegurado ( opcional )              *
      *                                                                  *
      * Retorna Importe Res. No Insc. / -1 = No Calculó                  *
      * ---------------------------------------------------------------- *
     P SVPEMI_CalcIVANoInscripto...
     P                 B                   export
     D SVPEMI_CalcIVANoInscripto...
     D                 pi            15  2
     D   peCome                      15  6   const
     D   peCiva                       2  0   const
     D   peSubt                      15  2   const
     D   pePivi                       5  2   const
     D   pePivn                       5  2   const
     D   pePivr                       5  2
     D   peIvam                      15  2   const
     D   peAsen                       7  0   options( *nopass :*omit )
      *
     D   @@mone        s              2
     D   @@ivrs        s              1
     D   @@ipr1        s             15  2
     D   @@ipr3        s             15  2
     D   @@ipr4        s             15  2
     D   @@asen        s              7  0
     D   @@pivr        s              5  2
     D   @@sino        s              1
     D   Asegurado     s               n

      /free

       SVPEMI_inz();

       // PRO401TE.- Excepcion...
       Asegurado = *off;
       if %parms >= 8 and %addr( peAsen ) <> *null;
         Asegurado = *on;
         @@asen = peAsen;
       endif;

       if Asegurado;
         PRO401TE( @@asen
                 : @@pivr
                 : @@sino );
         if @@sino = 'S';
           pePivr = @@pivr;
         endif;

         chain @@asen sehase;
         if %found( sehase );
           @@ivrs = asivrs;
         else;
           @@ivrs = '1';
           if peCiva = 1;
             @@ivrs = '0';
           endif;
         endif;
       else;
         @@ivrs = '1';
         if peCiva = 1;
           @@ivrs = '0';
         endif;
       endif;

       clear @@ipr1;
       clear @@ipr3;
       clear @@ipr4;

       PRO401T( peCome
              : peCiva
              : @@ivrs
              : peSubt
              : peIvam
              : pePivi
              : pePivn
              : pePivr
              : @@ipr1
              : @@ipr3
              : @@ipr4  );

       return @@ipr4;

      /end-free
     P SVPEMI_CalcIVANoInscripto...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_CalcIVAPercepcion(): Retorna Importe de IVA-Percepcion    *
      *                                                                  *
      *      peCome (input)  Cotizacion de Moneda                        *
      *      peCiva (input)  Condicion de IVA                            *
      *      peSubt (input)  Subtotal(neto+refi+read+dere+ipr7+ipr8)     *
      *      pePivi (input)  % IVA Inscripto                             *
      *      pePivn (input)  % IVA No Inscripto                          *
      *      pePivr (input)  % Res.3125                                  *
      *      peIvam (input)  Mínimo Res.3125                             *
      *      peAsen (input)  Nro. de Asegurado ( opcional )              *
      *                                                                  *
      * Retorna Importe IVA Percepcion/ -1 = No Calculó                  *
      * ---------------------------------------------------------------- *
     P SVPEMI_CalcIVAPercepcion...
     P                 B                   export
     D SVPEMI_CalcIVAPercepcion...
     D                 pi            15  2
     D   peCome                      15  6   const
     D   peCiva                       2  0   const
     D   peSubt                      15  2   const
     D   pePivi                       5  2   const
     D   pePivn                       5  2   const
     D   pePivr                       5  2
     D   peIvam                      15  2   const
     D   peAsen                       7  0   options( *nopass :*omit )
      *
     D   @@mone        s              2
     D   @@ivrs        s              1
     D   @@ipr1        s             15  2
     D   @@ipr3        s             15  2
     D   @@ipr4        s             15  2
     D   @@asen        s              7  0
     D   @@pivr        s              5  2
     D   @@sino        s              1
     D   Asegurado     s               n

      /free

       SVPEMI_inz();

       // PRO401TE.- Excepcion...
       Asegurado = *off;
       if %parms >= 8 and %addr( peAsen ) <> *null;
         Asegurado = *on;
         @@asen = peAsen;
       endif;

       if Asegurado;
         PRO401TE( @@asen
                 : @@pivr
                 : @@sino );
         if @@sino = 'S';
           pePivr = @@pivr;
         endif;

         chain @@asen sehase;
         if %found( sehase );
           @@ivrs = asivrs;
         else;
           @@ivrs = '1';
           if peCiva = 1;
             @@ivrs = '0';
           endif;
         endif;
       else;
         @@ivrs = '1';
         if peCiva = 1;
           @@ivrs = '0';
         endif;
       endif;

       clear @@ipr1;
       clear @@ipr3;
       clear @@ipr4;

       PRO401T( peCome
              : peCiva
              : @@ivrs
              : peSubt
              : peIvam
              : pePivi
              : pePivn
              : pePivr
              : @@ipr1
              : @@ipr3
              : @@ipr4  );

       return @@ipr3;

      /end-free
     P SVPEMI_CalcIVAPercepcion...
     P                 E

      * ------------------------------------------------------------ *
      *  SVPEMI_setAjustaImportes(): Se ajusta Importes según tabla  *
      *                                                              *
      *     peArcd    ( input )  Articulo                            *
      *     peRama    ( input )  Rama                                *
      *     peArse    ( input )  Cant. Pólizas por Rama              *
      *     pePrim    ( input )  Prima                   ( Totales ) *
      *     peBpri    ( input )  Bonificacion sobre Prima( Totales ) *
      *     pePrem    ( input )  Premio                  ( Totales ) *
      *     peRead    ( input )  Recargo Administrativo  ( Totales ) *
      *     peRefi    ( input )  Recargo Financiero      ( Totales ) *
      *     peDere    ( input )  Derecho de Emision      ( Totales ) *
      *     peImpi    ( input )  Impuestos Internos      ( Totales ) *
      *     peSers    ( input )  Servicios Sociales      ( Totales ) *
      *     peTssn    ( input )  Tasa SSN                ( Totales ) *
      *     prRpro    ( input )  Codigo de Provincia     ( x Prov  ) *
      *     pePri1    ( input )  Prima                   ( x Prov  ) *
      *     pePre1    ( input )  Premio                  ( x Prov  ) *
      *     peBpr1    ( input )  Bonificacion            ( x Prov  ) *
      *     peDer1    ( input )  Derecho de Emision      ( x Prov  ) *
      *     peRef1    ( input )  Recargo Financiero      ( x Prov  ) *
      *     peRea1    ( input )  Recargo Administrativo  ( x Prov  ) *
      *                                                              *
      * Retorna *on = Ajusto Ok / *off = No ajusto.                  *
      * -------------------------------------------------------------*
     P SVPEMI_setAjustaImportes...
     P                 B                   export
     D SVPEMI_setAjustaImportes...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePrim                      15  2
     D   peBpri                      15  2
     D   pePrem                      15  2
     D   peRead                      15  2
     D   peRefi                      15  2
     D   peDere                      15  2
     D   peImpi                      15  2
     D   peSers                      15  2
     D   peTssn                      15  2
     D   peRpro                       2  0 dim( 30 )
     D   pePri1                      15  2 dim( 30 )
     D   pePre1                      15  2 dim( 30 )
     D   peBpr1                      15  2 dim( 30 )
     D   peDer1                      15  2 dim( 30 )
     D   peRef1                      15  2 dim( 30 )
     D   peRea1                      15  2 dim( 30 )

     D @@prem          s             15  2 inz
     D @@prem1         s             15  1 inz
     D @@deci          s              2  2 inz                                  ||
     D @@subt          s             15  2 inz
     D @@subtEg3       s             15  2 inz
     D @@dife          s             15  2 inz
     D @@prim          s             15  2 inz
     D @@ImpEg3        ds                  likeds( ImpEg3 )
     D @@primero       s              1n   inz('1')
     D @@aux1          s             29  9
     D @@dere          s             15  2
     D @@DsArt         ds                  likeds( dsset630_t )
     D rc              s               n
     D x               s             10i 0

      /free

       COWGRAI_inz();

       rc = SVPART_getParametria( peArcd
                                : @@DsArt );

       @@prem = pePrem;
       @@subt = ( pePrim - pebpri ) +  peRead + peRefi + peDere;

?  ?   select;
         when @@DsArt.t@ma09 = '1';
           if pePrem > *Zeros;
             pePrem += 0,05;
             @@prem1 = pePrem;
             pePrem  = @@prem1;
           else;
             pePrem -= 0,05;
             @@prem1 = pePrem;
             pePrem  = @@prem1;
           endif;
         when @@DsArt.t@ma09 = '2';
           if pePrem > *Zeros;
           pePrem += 0,50;
           pePrem  = %int(pePrem);
         else;
           pePrem -= 0,50;
           pePrem  = %int(pePrem);
         endif;
       endsl;

       //ajusta...
       if @@DsArt.t@ma09 = '1' or @@DsArt.t@ma09 = '2';
         @@deci = @@prem - pePrem;
         select;
           when peRead <> *zeros;
                peRead -= @@deci;
           when peRefi <> *zeros;
                peRefi -= @@deci;
           when peDere <> *zeros;
                peDere -= @@deci;
                @@dere = peDere;
           when pebpri <> *zeros;
                pebpri += @@deci;
           when peImpi <> *zeros;
                peImpi -= @@deci;
           when peSers <> *zeros;
                peSers -= @@deci;
           when peTssn <> *zeros;
                peTssn -= @@deci;
           other;
                pePrem = @@prem;
           endsl;
         endif;

         @@subt = ( pePrim - peBpri ) +  peRead + peRefi + peDere;
         @@ImpEg3.prim = %XFoot( pePri1 );
         @@ImpEg3.bpri = %XFoot( peBpr1 );
         @@ImpEg3.dere = %XFoot( peDer1 );
         @@ImpEg3.read = %XFoot( peRea1 );
         @@ImpEg3.refi = %XFoot( peRef1 );

         @@dife = pePrim - @@ImpEg3.prim;
         for x = 1 to 30;
           if pePri1( x ) <> *zeros;
              pePri1( x ) += @@dife;
              leave;
           endif;
         endfor;

         @@dife = peBpri - @@ImpEg3.bpri;
         for x = 1 to 30;
           if peBpr1( x ) <> *zeros;
              peBpr1( x ) += @@dife;
              leave;
           endif;
         endfor;

         @@dife = peDere - @@ImpEg3.dere;
         for x = 1 to 30;
           if peDer1( x ) <> *zeros;
              peDer1( x ) += @@dife;
              leave;
           endif;
         endfor;

         @@dife = peRead - @@ImpEg3.read;
         for x = 1 to 30;
           if peRea1( x ) <> *zeros;
              peRea1( x ) += @@dife;
              leave;
           endif;
         endfor;

         @@dife = peRefi - @@ImpEg3.refi;
         for x = 1 to 30;
           if peRef1( x ) <> *zeros;
              peRef1( x ) += @@dife;
              leave;
           endif;
         endfor;

         for x = 1 to 30;
           if peRpro( x ) <> *zeros;
              @@subtEg3   = ( pePri1( x ) - peBpr1( x ) )
                          + peDer1( x )
                          + peRef1( x )
                          + peRea1( x );

             //Calcula premio x Prov...
             if @@subt <> *zeros;
               @@aux1    = pePrem / @@subt;
               pePre1( X ) = @@aux1 * @@subtEg3;
             endif;
          endif;
        endfor;

        //ajusta premio decimal..
        @@ImpEg3.prem = %XFoot( pePre1 );
        for x = 1 to 30;
          if pePre1( x ) <> *zeros;
            monitor;
             @@deci    = pePrem - @@ImpEg3.prem;
            on-error;
             return *off;
            endmon;
            pePre1( x ) += @@deci;
            leave;
          endif;
        endfor;

       return *on;

      /end-free

     P SVPEMI_setAjustaImportes...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_setCuotaxCalculo(): Graba cuotas calculadas.-             *
      *                                                                  *
      *      peEmpr ( input )  Empresa                                   *
      *      peSucu ( input )  Sucursal                                  *
      *      peArcd ( input )  Articulo                                  *
      *      peSpol ( input )  Super Poliza                              *
      *      peSspo ( input )  Suplemento Super Poliza                   *
      *                                                                  *
      * Retorna *on = Calcula Cuota / *off = No Calculó                  *
      * ---------------------------------------------------------------- *
     P SVPEMI_setCuotaxCalculo...
     P                 B                   export
     D SVPEMI_setCuotaxCalculo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D @@sspo          s              3  0
     D @@fech          s              8  0
     D @@fdes          s              8  0
     D @@femi          s              8  0
     D @@fema          s              4  0
     D @@femm          s              2  0
     D @@femd          s              2  0
     D @@faÑo          s              4  0
     D @@fmes          s              2  0
     D @@fdia          s              2  0
     D @@DsC3          ds                  likeds( dsPahec3V2_t )
     D @@DsD0          ds                  likeds( dsPahed0_t ) dim( 999 )
     D @@DsD0C         s             10i 0
     D @@DsC1          ds                  likeds( dsPaheC1_t ) dim( 999 )
     D @@DsC1C         s             10i 0
     D @@DsArt         ds                  likeds( dsset630_t )
     D rc              s               n
     D fec             s              8  0 dim(30)                              FECHA
     D imp             s             15  2 dim(30)                              IMPORTE
     D @@desd          s              8  0
     D @@dup1          s              2  0
     D @@hafa          s              8  0
     D x               s             10i 0
     D y               s             10i 0
     D k               s             10i 0
     D @@ncbu          s             25
     D @@ivat          s             15  2

      *- Agrupación día mes año en un solo campo...
     D                 ds
     D  p@fdma                01     08  0
     D  p@fdia                01     02  0
     D  p@fmes                03     04  0
     D  p@faÑo                05     08  0

      *- Agrupación día mes año en un solo campo cálculo de 1ra cuota...
     D                 ds
     D  p@1dma                01     08  0
     D  p@fe1d                01     02  0
     D  p@fe1m                03     04  0
     D  p@fe1a                05     08  0

      *- Agrupación día mes año en un solo campo cálculo de 2da cuota...
     D                 ds
     D  p@2dma                01     08  0
     D  p@fe2d                01     02  0
     D  p@fe2m                03     04  0
     D  p@fe2a                05     08  0

      *- Agrupación día mes año en un solo campo cálculo de 3ra cuota...
     D                 ds
     D  p@3dma                01     08  0
     D  p@fe3d                01     02  0
     D  p@fe3m                03     04  0
     D  p@fe3a                05     08  0

      *- Agrupación año mes día en un solo campo cálculo de 1ra cuota...
     D                 ds
     D  p@1amd                01     08  0
     D  d@fe1a                01     04  0
     D  d@fe1m                05     06  0
     D  d@fe1d                07     08  0

      *- Agrupación año mes día en un solo campo cálculo de 2da cuota...
     D                 ds
     D  p@2amd                01     08  0
     D  d@fe2a                01     04  0
     D  d@fe2m                05     06  0
     D  d@fe2d                07     08  0

      *- Agrupación año mes día en un solo campo cálculo de 3ra cuota...
     D                 ds
     D  p@3amd                01     08  0
     D  d@fe3a                01     04  0
     D  d@fe3m                05     06  0
     D  d@fe3d                07     08  0

     D  k1ycd5         ds                  likerec( p1hcd5 : *key )

      /free

       SVPEMI_inz();

       //Fecha tentativa de emision...
       @@fema = *zeros;
       @@femm = *zeros;
       @@femd = *zeros;

       PAR310X3( peEmpr
               : @@fema
               : @@femm
               : @@femd );

       rc = SVPART_getParametria( peArcd
                                : @@DsArt );

       clear @@DsC3;
       @@sspo = peSspo;
       rc = SPVSPO_getPlandePagoV2( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : @@sspo
                                  : @@DsC3 );

       rc = SPVSPO_getCabeceraSuplemento( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : @@DsC1
                                        : @@DsC1C );

       rc = SVPPOL_getPolizadesdeSuperPoliza( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsD0
                                            : @@DsD0C       );
       clear @@ivat;
       @@ivat = @@DsD0( @@DsD0C ).d0ipr1
              + @@DsD0( @@DsD0C ).d0ipr3;

       //Definir la fecha base de calculo de cuotas...
        Select;
         when @@DsC3.c3fb1c = 0  or @@DsC3.c3fb1c = 3;
          @@faÑo = @@DsD0( @@DsD0C ).d0fioa;
          @@fmes = @@DsD0( @@DsD0C ).d0fiom;
          @@fdia = @@DsD0( @@DsD0C ).d0fiod;

         when @@DsC3.c3fb1c = 1  or @@DsC3.c3fb1c = 4;
          @@faÑo = @@fema;
          @@fmes = @@femm;
          @@fdia = @@femd;

         when @@DsC3.c3fb1c = 2  or @@DsC3.c3fb1c = 5;
          @@fdes = ( @@DsD0( @@DsD0C ).d0fioa * 10000  ) +
                   ( @@DsD0( @@DsD0C ).d0fiom * 100    ) +
                   ( @@DsD0( @@DsD0C ).d0fiod          ) ;
          @@femi = ( @@fema * 10000 ) + ( @@femm * 100 ) + ( @@femd );
          if @@fdes >= @@femi;
           @@faÑo = @@DsD0( @@DsD0C ).d0fioa;
           @@fmes = @@DsD0( @@DsD0C ).d0fiom;
           @@fdia = @@DsD0( @@DsD0C ).d0fiod;
          else;
           @@faÑo = @@fema;
           @@fmes = @@femm;
           @@fdia = @@femd;
          endif;
         endsl;

         fec = *zeros;
         imp = *zeros;

         if @@DsD0( @@DsD0C ).d0depp > *zeros;
           imp(1) = @@DsD0( @@DsD0C ).d0depp;
           @@DsC3.c3ccuo += 1;
         endif;

         //El código de fecha base para vto.de primer cuota
         //cuando contiene 3/4/5 condiciona también el vto.
         //de la segunda cuota...
         if @@DsC3.c3fb1c = 3 and fec(02) = *zeros  or
            @@DsC3.c3fb1c = 4 and fec(02) = *zeros  or
            @@DsC3.c3fb1c = 5 and fec(02) = *zeros ;
          @@dup1 = 2;
          @@desd = ( @@DsD0( @@DsD0C ).d0fioa * 10000  ) +
                   ( @@DsD0( @@DsD0C ).d0fiom * 100    ) +
                   ( @@DsD0( @@DsD0C ).d0fiod          ) ;
          @@desd = SPVFEC_GiroFecha8 ( @@desd : 'DMA' );
          SP0001 ( @@desd
                 : @@dup1 );
          fec(02) = @@desd;
         endif;

       //el código de valor de primera cuota 8 condiciona
       //el valor de la primera cuota de la siguiente forma
       //16% para consumidores finales y 20% para otras
       //categorias...
        if @@DsC3.c3ci1c = 8  and @@DsC3.c3ccuo > 1  and
         imp(01) = *zeros;

         select;
          when  @@DsC1( @@DsC1C ).c1civa = 05;
            eval(h) imp(01) = @@DsD0( @@DsD0C ).d0prem * 0,16;
          other;
            eval(h) imp(01) = @@DsD0( @@DsD0C ).d0prem * 0,20;
         endsl;
        endif;

       //Redondeo de cuotas...
       // Definir forma de redondeo de cuotas
       select;
        when @@DsC1( @@DsC1C ).c1cfpg = 1 and @@DsArt.t@ma35 = '1';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 2 and @@DsArt.t@ma35 = '2';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 3 and @@DsArt.t@ma35 = '3';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 4 and @@DsArt.t@ma35 = '4';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 5 and @@DsArt.t@ma35 = '5';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 6 and @@DsArt.t@ma35 = '6';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 7 and @@DsArt.t@ma35 = '7';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 1 and @@DsArt.t@ma35 = 'A'  or
             @@DsC1( @@DsC1C ).c1cfpg = 2 and @@DsArt.t@ma35 = 'A'  or
             @@DsC1( @@DsC1C ).c1cfpg = 3 and @@DsArt.t@ma35 = 'A';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 4 and @@DsArt.t@ma35 = 'B'  or
             @@DsC1( @@DsC1C ).c1cfpg = 5 and @@DsArt.t@ma35 = 'B'  or
             @@DsC1( @@DsC1C ).c1cfpg = 6 and @@DsArt.t@ma35 = 'B'  or
             @@DsC1( @@DsC1C ).c1cfpg = 7 and @@DsArt.t@ma35 = 'B';
         imp(30) = 0,99;

        when @@DsArt.t@ma35 = 'C';
         imp(30) = 0,99;

       endsl;

      //ejecutar el calculo...
        PAR312E ( @@DsD0( @@DsD0C ).d0prem
                : @@DsC3.c3ccuo
                : @@DsC3.c3ci1c
                : @@DsC3.c3dv1c
                : @@DsC3.c3cimc
                : @@DsC3.c3immc
                : @@DsC3.c3dfv1
                : @@DsC3.c3dfm1
                : @@DsC3.c3dfv2
                : @@DsC3.c3dfm2
                : @@ivat
                : @@fdia
                : @@fmes
                : @@faÑo
                : @@DsD0( @@DsD0C ).d0come
                : fec
                : imp
                : @@DsC3.c3nrpp             );
      //Verifica cuotas fuera de vigencia...
       @@hafa = ( @@DsD0( @@DsD0C ).d0fhfa * 10000 ) +
                ( @@DsD0( @@DsD0C ).d0fhfm * 100 ) +
                ( @@DsD0( @@DsD0C ).d0fhfd );
       y = *zeros;
       for x=1 to 30;
        if fec(x) <> *zeros;
         @@fech = SPVFEC_GiroFecha8 ( fec(x) : 'AMD' );
         if @@fech <= @@hafa;
         y +=1;
         endif;
        endif;
       endfor;
      //si la cantidad de cuotas validas es menor mandar
      //recalculo de cuotas...
       if y < @@DsC3.c3ccuo;
        @@DsC3.c3ccuo = y;
        imp = *zeros;
        fec = *zeros;
        imp(1) = *zeros;

      //el código de fecha base para vto.de primer cuota
      //cuando contiene 3/4/5 condiciona también el vto.
      //de la segunda cuota...
        if @@DsC3.c3fb1c = 3  and fec(02) = *zeros  or
           @@DsC3.c3fb1c = 4  and fec(02) = *zeros  or
           @@DsC3.c3fb1c = 5  and fec(02) = *zeros;
         @@dup1 = 2;
         @@desd = ( @@DsD0( @@DsD0C ).d0fioa * 10000  ) +
                  ( @@DsD0( @@DsD0C ).d0fiom * 100    ) +
                  ( @@DsD0( @@DsD0C ).d0fiod          ) ;
         @@desd = SPVFEC_GiroFecha8 ( @@desd : 'DMA' );
         SP0001 ( @@desd
                : @@dup1 );
         fec(02) = @@desd;
        endif;

      //el código de valor de primera cuota 8 condiciona
      //el valor de la primera cuota de la siguiente forma
      //16% para consumidores finales y 20% para otras
      //categorias...
        if @@DsC3.c3ci1c = 8 and imp(01) = *zeros;
         select;
          when @@DsC1( @@DsC1C ).c1civa = 05;
   c       eval(h) imp(01) = @@DsD0( @@DsD0C ).d0prem * 0,16;
          other;
   c       eval(h) imp(01) = @@DsD0( @@DsD0C ).d0prem * 0,20;
         endsl;
        endif;
      //Redondeo de cuotas...

       // Definir forma de redondeo de cuotas
       select;
        when @@DsC1( @@DsC1C ).c1cfpg = 1 and @@DsArt.t@ma35 = '1';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 2 and @@DsArt.t@ma35 = '2';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 3 and @@DsArt.t@ma35 = '3';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 4 and @@DsArt.t@ma35 = '4';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 5 and @@DsArt.t@ma35 = '5';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 6 and @@DsArt.t@ma35 = '6';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 7 and @@DsArt.t@ma35 = '7';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 1 and @@DsArt.t@ma35 = 'A'  or
             @@DsC1( @@DsC1C ).c1cfpg = 2 and @@DsArt.t@ma35 = 'A'  or
             @@DsC1( @@DsC1C ).c1cfpg = 3 and @@DsArt.t@ma35 = 'A';
         imp(30) = 0,99;

        when @@DsC1( @@DsC1C ).c1cfpg = 4 and @@DsArt.t@ma35 = 'B'  or
             @@DsC1( @@DsC1C ).c1cfpg = 5 and @@DsArt.t@ma35 = 'B'  or
             @@DsC1( @@DsC1C ).c1cfpg = 6 and @@DsArt.t@ma35 = 'B'  or
             @@DsC1( @@DsC1C ).c1cfpg = 7 and @@DsArt.t@ma35 = 'B';
         imp(30) = 0,99;

        when @@DsArt.t@ma35 = 'C';
         imp(30) = 0,99;

       endsl;

        PAR312E ( @@DsD0( @@DsD0C ).d0prem
                : @@DsC3.c3ccuo
                : @@DsC3.c3ci1c
                : @@DsC3.c3dv1c
                : @@DsC3.c3cimc
                : @@DsC3.c3immc
                : @@DsC3.c3dfv1
                : @@DsC3.c3dfm1
                : @@DsC3.c3dfv2
                : @@DsC3.c3dfm2
                : @@ivat
                : @@fdia
                : @@fmes
                : @@faÑo
                : @@DsD0( @@DsD0C ).d0come
                : fec
                : imp
                : @@DsC3.c3nrpp             );
       endif;

       // borrar cuotas anteriores...
       k1ycd5.d5empr = peEmpr;
       k1ycd5.d5sucu = peSucu;
       k1ycd5.d5arcd = peArcd;
       k1ycd5.d5spol = peSpol;
       k1ycd5.d5sspo = peSspo;
       k1ycd5.d5rama = @@DsD0( @@DsD0C ).d0rama;
       k1ycd5.d5arse = @@DsD0( @@DsD0C ).d0arse;
       k1ycd5.d5oper = @@DsD0( @@DsD0C ).d0oper;
       k1ycd5.d5suop = @@DsD0( @@DsD0C ).d0suop;
       setll %kds( k1ycd5 : 9 ) pahcd5;
       reade %kds( k1ycd5 : 9 ) pahcd5;
        dow not %eof( pahcd5 );
          delete p1hcd5;
         reade %kds( k1ycd5 : 9 ) pahcd5;
       enddo;

      //grabacion de nuevas cuotas...
       d5empr = peEmpr;
       d5sucu = peSucu;
       d5arcd = peArcd;
       d5spol = peSpol;
       d5sspo = peSspo;
       d5rama = @@DsD0( @@DsD0C ).d0rama;
       d5arse = @@DsD0( @@DsD0C ).d0arse;
       d5oper = @@DsD0( @@DsD0C ).d0oper;
       d5suop = @@DsD0( @@DsD0C ).d0suop;
       d5mone = @@DsD0( @@DsD0C ).d0mone;

       for k = 1 to 30;
        if fec(k) <> *zeros;

         //Si es la cuota 1 graba fecha...
         if k = 1;
          p@1dma = fec(k);
          d@fe1d = p@fe1d;
          d@fe1m = p@fe1m;
          d@fe1a = p@fe1a;
         endif;

         //Si es la cuota 2 graba fecha
         if k = 2;
          p@2dma = fec(k);
          d@fe2d = p@fe2d;
          d@fe2m = p@fe2m;
          d@fe2a = p@fe2a;
         endif;

         //Si es la cuota 3 graba fecha
         if k = 3;
          p@3dma = fec(k);
          d@fe3d = p@fe3d;
          d@fe3m = p@fe3m;
          d@fe3a = p@fe3a;
         endif;

         //Si es la cuota 2 pregunta si la fecha es menor a la fecha de
         // la primera cuota...
         if k = 2;
          if p@2amd < p@1amd;
           fec(k) = p@1dma;
           p@2dma = p@1dma;
           d@fe2d = p@fe2d;
           d@fe2m = p@fe2m;
           d@fe2a = p@fe2a;
          endif;
         endif;

         //Si es la cuota 3 pregunta si la fecha es menor a la fecha de la
         //segunda cuota...
         if k = 3;
          if p@3amd < p@2amd;
           fec(k) = p@2dma;
          endif;
         endif;
         d5nrcu = k;
         d5nrsc = *zeros;
         p@fdma = fec(k);
         d5fvcd = p@fdia;
         d5fvcm = p@fmes;
         d5fvca = p@faÑo;
         d5imcu = imp(k);
         d5ctcu = @@DsC1( @@DsC1c ).c1ctcu;
         d5nrct = @@DsC1( @@DsC1c ).c1nrct;
         d5ivr2 = @@DsC1( @@DsC1c ).c1ivr2;
         d5nrrt = @@DsC1( @@DsC1c ).c1nrrt;
         d5nrlo = @@DsC1( @@DsC1c ).c1nrlo;
         d5cbrn = @@DsC1( @@DsC1C ).c1cbrn;
         d5czco = @@DsC1( @@DsC1C ).c1czco;
         d5nrla = @@DsC1( @@DsC1C ).c1nrla;
         d5nrln = @@DsC1( @@DsC1C ).c1nrln;
         d5nrcc = *zeros;
         d5cert = *zeros;
         d5poli = *zeros;
         d5cfpg = @@DsC1( @@DsC1C ).c1cfpg;
         // Código de estado de cuota...
         select;
         when @@DsC1( @@DsC1C).c1cfpg = 1;
          d5sttc = '1';
         when @@DsC1( @@DsC1C).c1cfpg = 2;
          d5sttc = '1';
         when @@DsC1( @@DsC1C).c1cfpg = 3;
          d5sttc = '1';
         when @@DsC1( @@DsC1C).c1cfpg = 4;
          d5sttc = '0';
         when @@DsC1( @@DsC1C).c1cfpg = 5;
          d5sttc = '0';
         when @@DsC1( @@DsC1C).c1cfpg = 6;
          d5sttc = '6';
         when @@DsC1( @@DsC1C).c1cfpg = 7;
          d5sttc = '7';
         other;
          d5sttc = '0';
         endsl;
         d5marp = '0';
         d5mar2 = '0';
         d5strg = '0';
         d5user = @PsDs.CurUsr;
         d5date = udate;
         d5time = %dec(%time():*iso);
         d5ivbc = @@DsC1( @@DsC1C ).c1ivbc;
         d5ivsu = @@DsC1( @@DsC1C ).c1ivsu;
         d5tcta = @@DsC1( @@DsC1C ).c1tcta;
         d5mar3 = *off;
         d5mar4 = *off;
         d5cn02 = *zeros;
         d5imau = *zeros;
         write p1hcd5;
        else;
         leave;
        endif;
       endfor;

       return *on;

     P SVPEMI_setCuotaxCalculo...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_setComisionxCalculo(): Graba Comisiones calculadas.-      *
      *                                                                  *
      *      peEmpr ( input )  Empresa                                   *
      *      peSucu ( input )  Sucursal                                  *
      *      peArcd ( input )  Articulo                                  *
      *      peSpol ( input )  Super Poliza                              *
      *      peSspo ( input )  Suplemento Super Poliza                   *
      *                                                                  *
      * Retorna *on = Calculo Comision / *off = No Calculó               *
      * ---------------------------------------------------------------- *
     P SVPEMI_setComisionxCalculo...
     P                 B                   export
     D SVPEMI_setComisionxCalculo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
      *
     D @@DsD0          ds                  likeds( dsPaheD0_t ) dim( 999 )
     D @@DsD0C         s             10i 0
     D @@DsD1          ds                  likeds( dsPaheD1_t ) dim( 999 )
     D @@DsD1C         s             10i 0
     D @@DsD3          ds                  likeds( dsPaheD3_t ) dim( 999 )
     D @@DsD3C         s             10i 0
     D @@DsC1          ds                  likeds( dsPaheC1_t ) dim( 999 )
     D @@DsC1C         s             10i 0
     D @@DsC0          ds                  likeds( dsPahec0_t )
     D @@DsC3          ds                  likeds( dsPahec3V2_t ) dim( 999 )
     D @@DsC3C         s             10i 0
      *
     D @@aux1          s             29  6
     D @@aux2          s             29  6
     D @@aux3          s             29  6
     D @@aux4          s             29  6
     D @@aux5          s             29  6
     D @@aux6          s             29  6
     D @@aux7          s             29  6
     D @@DsArt         ds                  likeds( dsset630_t )
     D rc              s               n
     D x               s             10i 0
     D z               s             10i 0
     D fecha_hoy       s              8  0
     D @@d             s              2  0
     D @@m             s              2  0
     D @@a             s              4  0
     D @@dupe          s              9  0
     D @sihay          s               n
     D act_code        s               n
     D nt              s              1  0 dim(9)
     D nc              s              5  0 dim(9)
     D no              s             40    dim(9)
     D xpr             s              5  2 dim(9)
     D xco             s              5  2 dim(9)
     D xf1             s              5  2 dim(9)
     D xf2             s              5  2 dim(9)
     D if2             s              9  2 dim(9)
     D fac             s              1    dim(9)
     D pd              s              5  2 dim(9)
     D pc              s              5  2 dim(9)
     D pf              s              5  2 dim(9)
     D pg              s              5  2 dim(9)
     D pdd             s              7  4 dim(9)
     D pcc             s              7  4 dim(9)
     D pff             s              7  4 dim(9)
     D pgg             s              7  4 dim(9)
     D @xpr            s              5  2 dim(9)
     D @xco            s              5  2 dim(9)
     D @xf1            s              5  2 dim(9)
     D @xf2            s              5  2 dim(9)
     D @if2            s              9  2 dim(9)
     D endpgm          s              3
     D tiene_exco      s               n
     D exco_va         s             15  2
     D exco_tiva       s              1
     D exco_facc       s              1
     D exco_dife       s              5  0
     D exco_dere       s             15  2
     D prima_base      s             15  2
     D @@lap1          s              5  0
     D @@ma20          s              1
     D @@secu          s              2  0
     D @@empr          s              1
     D @@sucu          s              2
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@tiou          s              1  0

     D k1y611          ds                  likerec( s1t611   : *key )
     D k1y6111         ds                  likerec( s1t6111  : *key )
     D k1y6118         ds                  likerec( s1t6118  : *key )
     D k1yeg3          ds                  likerec( p1heg3   : *key )
     D k1yni2          ds                  likerec( s1hni201 : *key )

      /free

       // por ahora esta para RV...

       SVPEMI_inz();

       PAR310X3 ( peEmpr : @@a : @@m : @@d );
       fecha_hoy = ( @@a * 1000 ) + ( @@m * 100 ) + @@d;
       rc = SVPART_getParametria( peArcd : @@DsArt );
       rc = SVPPOL_getPolizadesdeSuperPoliza( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsD0
                                            : @@DsD0C );

       rc = SPVSPO_getCabecera( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : @@DsC0 );

       rc = SPVSPO_getCabeceraSuplemento( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : @@DsC1
                                        : @@DsC1C );

       rc = SVPPOL_getComisionesxInt( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : peSspo
                                    : @@DsD0( @@DsD0C ).d0rama
                                    : @@DsD0( @@DsD0C ).d0arse
                                    : @@DsD0( @@DsD0C ).d0oper
                                    : @@DsD0( @@DsD0C ).d0suop
                                    : *omit
                                    : *omit
                                    : *omit
                                    : @@DsD3
                                    : @@Dsd3C   );

       rc = SVPPOL_getCondicionesComerciales( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : @@DsD0( @@DsD0C ).d0rama
                                            : @@DsD0( @@DsD0C ).d0arse
                                            : @@DsD0( @@DsD0C ).d0oper
                                            : @@DsD0( @@DsD0C ).d0suop
                                            : @@DsD1
                                            : @@DsD1C                  );

       // buscar plan comercial...

       @@aux1 = @@DsD0( @@DsD0C ).d0dup2 * @@DsD0( @@DsD0C ).d0pecu;
       clear @@dupe;

       Select;
         when @@DsC0.c0mar5 = '1';
           @@dupe = @@DsC0.c0dupe;
         when @@DsC0.c0mar5 = '2';
           @@dupe = @@DsC0.c0dupe * 12;
       endsl;

       if @@DsD0( @@DsD0C ).d0tiou = 2 or
          @@DsD0( @@DsD0C ).d0tiou = 3 and
          @@DsC0.c0spoa > *zeros       or
          @@DsD0( @@DsD0C ).d0tiou = 5 and
          @@DsC0.c0spoa > *zeros;
            @@aux1 += @@dupe;
       endif;

       k1y611.t@plac = @@Dsd0( @@DsD0C ).d0plac;
       k1y611.t@mone = @@DsD0( @@DsD0C ).d0mone;
       setll %kds( k1y611 : 2 ) set611;
       reade %kds( k1y611 : 2 ) set611;
       dow not %eof( set611 );
         if @@aux1 <= t@xmes;
           @sihay = *on;
           leave;
         endif;
        reade %kds( k1y611 : 2 ) set611;
       enddo;

       if @@DsArt.t@ma26 = '1';

         k1y6118.t@empr = peEmpr;
         k1y6118.t@sucu = peSucu;
         k1y6118.t@nivt = @@DsC1( @@DsC1C ).c1nivt;
         k1y6118.t@nivc = @@DsC1( @@DsC1C ).c1nivc;
         k1y6118.t@rama = @@DsD0( @@DsD0C ).d0rama;
         chain %kds( k1y6118 : 5 ) set6118;
       endif;

       pd(01) = t@pdn1;
       pd(02) = t@pdn2;
       pd(03) = t@pdn3;
       pd(04) = t@pdn4;
       pd(05) = t@pdn5;
       pd(06) = t@pdn6;
       pd(07) = t@pdn7;
       pd(08) = t@pdn8;
       pd(09) = t@pdn9;

       pc(01) = t@pdc1;
       pc(02) = t@pdc2;
       pc(03) = t@pdc3;
       pc(04) = t@pdc4;
       pc(05) = t@pdc5;
       pc(06) = t@pdc6;
       pc(07) = t@pdc7;
       pc(08) = t@pdc8;
       pc(09) = t@pdc9;

       pf(01) = t@pdf1;
       pf(02) = t@pdf2;
       pf(03) = t@pdf3;
       pf(04) = t@pdf4;
       pf(05) = t@pdf5;
       pf(06) = t@pdf6;
       pf(07) = t@pdf7;
       pf(08) = t@pdf8;
       pf(09) = t@pdf9;

       pg(01) = t@pdg1;
       pg(02) = t@pdg2;
       pg(03) = t@pdg3;
       pg(04) = t@pdg4;
       pg(05) = t@pdg5;
       pg(06) = t@pdg6;
       pg(07) = t@pdg7;
       pg(08) = t@pdg8;
       pg(09) = t@pdg9;

       pdd = pd / 100;
       pcc = pc / 100;
       pff = pf / 100;
       pgg = pg / 100;

       fac(1) = t@fac1;
       fac(2) = t@fac2;
       fac(3) = t@fac3;
       fac(4) = t@fac4;
       fac(5) = t@fac5;
       fac(6) = t@fac6;
       fac(7) = t@fac7;
       fac(8) = t@fac8;
       fac(9) = t@fac9;

       // bus001...

       clear nt ;
       clear nc ;
       clear no ;
       clear xpr;
       clear xco;
       clear xf1;
       clear xf2;

       for x = 1 to @@DsD3C;
         if %lookup( @@DsD3( x ).d3nivt : nt) = *zeros;
           z += 1;
           nt (z) = @@DsD3( x ).d3nivt;
           nc (z) = @@DsD3( x ).d3nivc;
           xpr(z) = @@DsD3( x ).d3xopr;
           xco(z) = @@DsD3( x ).d3xcco;
           xf1(z) = @@DsD3( x ).d3xfno;

           if @@DsD1( @@DsD1C ).d1bas4 = '5';
             xf2(z) = *zeros;
             if2(z) = @@DsD3( x ).d3cfnn;
           else;
             xf2(z) = @@DsD3( x ).d3xfnn;
             if2(z) = *zeros;
           endif;
           fac(z)   = @@DsD3( x ).d3facc;
           //@@t    = @@DsD3( x ).d3nivt;
           //@@c    = @@DsD3( x ).d3nivc;
         endif;
       endfor;

       @@empr = peEmpr;
       @@sucu = peSucu;
       @@arcd = peArcd;
       @@spol = peSpol;
       @@tiou = @@DsD0( @@DsD0C ).d0tiou;

       SPCHKCODE( @@empr
                : @@sucu
                : @@arcd
                : @@spol
                : @@tiou
                : act_code
                : endpgm      );

       if act_code;
         for x = 1 to 9;
           spexcode( @@empr
                   : @@sucu
                   : nt( x )
                   : nc( x )
                   : @@DsD0( @@DsD0C ).d0rama
                   : @@DsC1( @@DsC1C ).c1tiou
                   : @@DsC1( @@DsC1C ).c1stou
                   : fecha_hoy
                   : endpgm
                   : tiene_exco
                   : exco_va
                   : exco_tiva
                   : exco_facc
                   : exco_dife
                   : exco_dere );

           if tiene_exco;
             if @@Dsc1( @@DsC1C ).c1come <> *zeros;
               eval(h) exco_va = exco_va/@@DsC1( @@DsC1C ).c1come;
             endif;

             if prima_base = *zeros;
                k1yeg3.g3empr = peEmpr;
                k1yeg3.g3sucu = peSucu;
                k1yeg3.g3arcd = peArcd;
                k1yeg3.g3spol = peSpol;
                k1yeg3.g3sspo = peSspo;
                k1yeg3.g3rama = @@DsD0( @@DsD0C ).d0rama;
                k1yeg3.g3arse = @@DsD0( @@DsD0C ).d0arse;
                k1yeg3.g3oper = @@DsD0( @@DsD0C ).d0oper;
                k1yeg3.g3suop = @@DsD0( @@DsD0C ).d0suop;
                setll %kds( k1yeg3 : 9 ) paheg3;
                reade %kds( k1yeg3 : 9 ) paheg3;
               dow not %eof( paheg3 );
                prima_base = g3prim - g3bpri;
                reade %kds( k1yeg3 : 9 ) paheg3;
               enddo;
               clear @@aux3;
               if prima_base <> *zeros;
                 @@aux3 = (exco_va / prima_base) * 100;
               endif;
               eval(h) xpr(x) = @@aux3;
                       fac(x) = exco_facc;
             endif;

           endif;
         endfor;
       endif;
       clear prima_base;

       //Validaciones...
       if not @sihay;
         //error...
       endif;

       if @@DsD1( @@DsD1C ).d1bbrk <> '1' and
          @@DsD1( @@DsD1C ).d1bbrk <> '2' and
          @@DsD1( @@DsD1C ).d1bbrk <> *blanks;
         //error...
       endif;

       if @@DsD1( @@DsD1C ).d1bbrk <> *blanks and
          @@DsD1( @@DsD1C ).d1xbrk = *zeros   or
          @@DsD1( @@DsD1C ).d1bbrk = *blanks  and
          @@DsD1( @@DsD1C ).d1xbrk <> *zeros     ;
         //error...
       endif;

       @@aux5 = %XFoot( xpr );
       if @@aux5 > t@xopr;
         //error...
       endif;

       @@aux5 = %XFoot( xco );
       if @@aux5 > t@xcco;
         //error...
       endif;

       @@aux5 = %XFoot( xf1 );
       if @@aux5 > t@xfno;
         //error...
       endif;

       @@aux5 = %XFoot( xf2 );
       if @@aux5 > t@xfnn;
         //error...
       endif;

       @@aux5 = %XFoot( if2 );
       if @@aux5 > t@cfnn;
         //error...
       endif;

       // si todo ok .. Graba
       @@DsD1( @@DsD1C ).d1xmes = t@xmes;
       @@DsD1( @@DsD1C ).d1xopr = t@xopr;
       @@DsD1( @@DsD1C ).d1xcco = t@xcco;
       @@DsD1( @@DsD1C ).d1xfno = t@xfno;
       @@DsD1( @@DsD1C ).d1xfnn = t@xfnn;
       @@DsD1( @@DsD1C ).d1copr = *zeros;
       @@DsD1( @@DsD1C ).d1ccob = *zeros;
       @@DsD1( @@DsD1C ).d1cfno = *zeros;
       @@DsD1( @@DsD1C ).d1cfnn = t@cfnn;
       @@DsD1( @@DsD1C ).d1fac1 = t@fac1;
       @@DsD1( @@DsD1C ).d1fac2 = t@fac2;
       @@DsD1( @@DsD1C ).d1fac3 = t@fac3;
       @@DsD1( @@DsD1C ).d1fac4 = t@fac4;
       @@DsD1( @@DsD1C ).d1fac5 = t@fac5;
       @@DsD1( @@DsD1C ).d1fac6 = t@fac6;
       @@DsD1( @@DsD1C ).d1fac7 = t@fac7;
       @@DsD1( @@DsD1C ).d1fac8 = t@fac8;
       @@DsD1( @@DsD1C ).d1fac9 = t@fac9;
       @@DsD1( @@DsD1C ).d1nmd1 = t@nmd1;
       @@DsD1( @@DsD1C ).d1nmd2 = t@nmd2;
       @@DsD1( @@DsD1C ).d1nmc1 = t@nmc1;
       @@DsD1( @@DsD1C ).d1nmc2 = t@nmc2;
       @@DsD1( @@DsD1C ).d1pdn1 = t@pdn1;
       @@DsD1( @@DsD1C ).d1pdn2 = t@pdn2;
       @@DsD1( @@DsD1C ).d1pdn3 = t@pdn3;
       @@DsD1( @@DsD1C ).d1pdn4 = t@pdn4;
       @@DsD1( @@DsD1C ).d1pdn5 = t@pdn5;
       @@DsD1( @@DsD1C ).d1pdn6 = t@pdn6;
       @@DsD1( @@DsD1C ).d1pdn7 = t@pdn7;
       @@DsD1( @@DsD1C ).d1pdn8 = t@pdn7;
       @@DsD1( @@DsD1C ).d1pdc9 = t@pdc9;
       @@DsD1( @@DsD1C ).d1pdf1 = t@pdf1;
       @@DsD1( @@DsD1C ).d1pdf2 = t@pdf2;
       @@DsD1( @@DsD1C ).d1pdf3 = t@pdf3;
       @@DsD1( @@DsD1C ).d1pdf4 = t@pdf4;
       @@DsD1( @@DsD1C ).d1pdf5 = t@pdf5;
       @@DsD1( @@DsD1C ).d1pdf6 = t@pdf6;
       @@DsD1( @@DsD1C ).d1pdf7 = t@pdf7;
       @@DsD1( @@DsD1C ).d1pdf8 = t@pdf8;
       @@DsD1( @@DsD1C ).d1pdf9 = t@pdf9;
       @@DsD1( @@DsD1C ).d1pdg1 = t@pdg1;
       @@DsD1( @@DsD1C ).d1pdg2 = t@pdg2;
       @@DsD1( @@DsD1C ).d1pdg3 = t@pdg3;
       @@DsD1( @@DsD1C ).d1pdg4 = t@pdg4;
       @@DsD1( @@DsD1C ).d1pdg5 = t@pdg5;
       @@DsD1( @@DsD1C ).d1pdg6 = t@pdg6;
       @@DsD1( @@DsD1C ).d1pdg7 = t@pdg7;
       @@DsD1( @@DsD1C ).d1pdg8 = t@pdg8;
       @@DsD1( @@DsD1C ).d1pdg9 = t@pdg9;
       @@DsD1( @@DsD1C ).d1ndc1 = t@ndc1;
       @@DsD1( @@DsD1C ).d1ndc2 = t@ndc2;
       @@DsD1( @@DsD1C ).d1ndc3 = t@ndc3;
       @@DsD1( @@DsD1C ).d1ndc4 = t@ndc4;
       @@DsD1( @@DsD1C ).d1ndc5 = t@ndc5;
       @@DsD1( @@DsD1C ).d1ndc6 = t@ndc6;
       @@DsD1( @@DsD1C ).d1ndc7 = t@ndc7;
       @@DsD1( @@DsD1C ).d1ndc8 = t@ndc8;
       @@DsD1( @@DsD1C ).d1ndc9 = t@ndc9;
       @@DsD1( @@DsD1C ).d1tarc = t@tarc;
       @@DsD1( @@DsD1C ).d1tair = t@tair;
       @@DsD1( @@DsD1C ).d1scta = t@scta;
       @@DsD1( @@DsD1C ).d1prec = t@prec;
       @@DsD1( @@DsD1C ).d1mar1 = '0'   ;
       @@DsD1( @@DsD1C ).d1mar2 = '0'   ;
       @@DsD1( @@DsD1C ).d1mar3 = '0'   ;
       @@DsD1( @@DsD1C ).d1mar4 = '0'   ;
       @@DsD1( @@DsD1C ).d1mar5 = '0'   ;
       @@DsD1( @@DsD1C ).d1strg = '0'   ;
       @@DsD1( @@DsD1C ).d1user = @PsDs.CurUsr;
       @@DsD1( @@DsD1C ).d1time = %dec(%time():*iso);
       @@DsD1( @@DsD1C ).d1date = udate;
       select;
         when @@DsD1( @@DsD1C).d1bbrk = '1';
           @@aux7 = @@DsD0( @@DsD0C ).d0prim - @@DsD0( @@DsD0C ).d0bpri;
         when @@DsD1( @@DsD1C).d1bbrk = '2';
            @@aux7 = @@DsD0( @@DsD0C ).d0prem;
         other;
            @@aux7 = *zeros;
       endsl;
       eval(h) @@aux7 = @@DsD1( @@DsD1C ).d1xbrk * @@aux7;
       @@Dsd1( @@Dsd1C ).d1cbrk = @@aux7 / 100;
       rc = SVPPOL_setCondicionesComerciales( @@DsD1( @@DsD1C ) );

       //
       clear @@DsD3;
       clear @@DsD3C;
       for x = 1 to z;
         k1yeg3.g3empr = peEmpr;
         k1yeg3.g3sucu = peSucu;
         k1yeg3.g3arcd = peArcd;
         k1yeg3.g3spol = peSpol;
         k1yeg3.g3sspo = peSspo;
         k1yeg3.g3rama = @@DsD0( @@DsD0C ).d0rama;
         k1yeg3.g3arse = @@DsD0( @@DsD0C ).d0arse;
         k1yeg3.g3oper = @@DsD0( @@DsD0C ).d0oper;
         k1yeg3.g3suop = @@DsD0( @@DsD0C ).d0suop;
         setll %kds( k1yeg3 : 9 ) paheg3;
         reade %kds( k1yeg3 : 9 ) paheg3;
         dow not %eof( paheg3 );
           if g3mar1 = '0';
             @@DsD3( x ).d3empr = g3empr;
             @@DsD3( x ).d3sucu = g3sucu;
             @@DsD3( x ).d3arcd = g3arcd;
             @@DsD3( x ).d3spol = g3spol;
             @@DsD3( x ).d3sspo = g3sspo;
             @@DsD3( x ).d3rama = g3rama;
             @@DsD3( x ).d3arse = g3arse;
             @@DsD3( x ).d3oper = g3oper;
             @@DsD3( x ).d3suop = g3suop;
             @@DsD3( x ).d3nivt = nt( x );
             @@DsD3( x ).d3nivc = nc( x );
             @@DsD3( x ).d3rpro = g3rpro;
             @@DsD3( x ).d3cert = *zeros;
             @@DsD3( x ).d3poli = *zeros;
             @@DsD3( x ).d3plac = @@DsD0( @@DsD0C ).d0plac;
             @@DsD3( x ).d3mone = @@DsD0( @@DsD0C ).d0mone;
             k1yni2.n2empr = @@DsD3( x ).d3empr;
             k1yni2.n2sucu = @@DsD3( x ).d3sucu;
             k1yni2.n2nivt = @@DsD3( x ).d3nivt;
             k1yni2.n2nivc = @@DsD3( x ).d3nivc;
             chain %kds( k1yni2 : 4 ) sehni201;
             if %found( sehni201 );
               @@DsD3( x ).d3inta = n2inta;
               @@DsD3( x ).d3inna = n2inna;
             endif;
             if @@Dsd3( x ).d3inta = 4;
               @@secu += 1;
               @@DsD3( x ).d3secu = @@secu;
             else;
               @@DsD3( x ).d3secu = 1;
             endif;
             @@DsD3( x ).d3copc = @@DsD0( @@DsD0C ).d0copc;
             @@DsD3( x ).d3ncoc = @@DsD0( @@DsD0C ).d0ncoc;
             @@DsD3( x ).d3xopr = xpr(x);
             @@DsD3( x ).d3xcco = xco(x);
             @@DsD3( x ).d3xfno = xf1(x);
             @@DsD3( x ).d3xfnn = xf2(x);
             @@DsD3( x ).d3facc = fac(x);
             select;
               when t@bas1 = '1';
                    @@aux3 = g3prim - g3bpri;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
               when t@bas1 = '2';
                    eval(h) @@aux4 = g3prem * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
               when t@bas1 = '3';
                    eval(h) @@aux4 = g3dere * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
               when t@bas1 = '4';
                    eval(h) @@aux4 = g3sast * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
               when t@bas1 = '5';
                    clear @@DsD3( x ).d3copr;
               when t@bas1 = '6';
                    @@aux3 = (g3prim - g3bpri ) + g3read;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
               when t@bas1 = '7';
                    @@aux3 = (g3prim - g3bpri ) + g3read + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
               when t@bas1 = '8';
                    @@aux3 = (g3prim - g3bpri ) + g3read + g3refi + g3dere;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
               when t@bas1 = 'A';
                    @@aux3 = g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
               when t@bas1 = 'B';
                    @@aux3 = (g3prim - g3bpri ) + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
               when t@bas1 = 'C';
                    @@aux3 = g3read + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xopr;
                    eval(h) @@DsD3( x ).d3copr = @@aux4 / 100;
             endsl;

             select;
               when t@bas2 = '1';
                    @@aux3 = g3prim - g3bpri;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               when t@bas2 = '2';
                    eval(h) @@aux4 = g3prem * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               when t@bas2 = '3';
                    eval(h) @@aux4 = g3dere * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               when t@bas2 = '4';
                    clear @@DsD3( x ).d3ccob;
               when t@bas2 = '5';
                    clear @@DsD3( x ).d3ccob;
               when t@bas2 = '6';
                    @@aux3 = ( g3prim - g3bpri) + g3read;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               when t@bas2 = '7';
                    @@aux3 = ( g3prim - g3bpri) + g3read + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               when t@bas2 = '8';
                    @@aux3 = ( g3prim - g3bpri) + g3read + g3refi + g3dere;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               when t@bas2 = '9';
                    @@aux3 = g3read;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               when t@bas2 = 'A';
                    @@aux3 = g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               when t@bas2 = 'B';
                    @@aux3 = ( g3prim - g3bpri ) + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               when t@bas2 = 'C';
                    @@aux3 = g3refi + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xcco;
                    eval(h) @@DsD3( x ).d3ccob = @@aux4 / 100;
               endsl;

             select;
               when t@bas3 = '1';
                    @@aux3 = g3prim - g3bpri;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               when t@bas3 = '2';
                    @@aux4 = g3prim * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               when t@bas3 = '3';
                    @@aux4 = g3dere * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               when t@bas3 = '4';
                    clear @@DsD3( x ).d3cfno;
               when t@bas3 = '5';
                    clear @@DsD3( x ).d3cfno;
               when t@bas3 = '6';
                    @@aux3 = ( g3prim - g3bpri ) + g3read;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               when t@bas3 = '7';
                    @@aux3 = ( g3prim - g3bpri ) + g3read + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               when t@bas3 = '8';
                    @@aux3 = ( g3prim - g3bpri ) + g3read + g3refi + g3dere;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               when t@bas3 = '9';
                    @@aux3 = g3read;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               when t@bas3 = 'A';
                    @@aux3 = g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               when t@bas3 = 'B';
                    @@aux3 = ( g3prim - g3bpri ) + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               when t@bas3 = 'C';
                    @@aux3 = ( g3prim - g3bpri ) + g3read + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfno;
                    eval(h) @@DsD3( x ).d3cfno = @@aux4 / 100;
               endsl;

             select;
               when t@bas4 = '1';
                    @@aux3 = ( g3prim - g3bpri );
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;
               when t@bas4 = '2';
                    eval(h) @@aux4 = g3prem + @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;
               when t@bas4 = '3';
                    eval(h) @@aux4 = g3dere * @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;
               when t@bas4 = '4';
                    clear @@DsD3( x ).d3cfnn;
               when t@bas4 = '5';
                    clear @@DsD3( x ).d3cfnn;

                    SPDFEC( @@DsD0( @@DsD0C ).d0fvod
                          : @@DsD0( @@DsD0C ).d0fvom
                          : @@DsD0( @@DsD0C ).d0fvoa
                          : @@DsD0( @@DsD0C ).d0fiod
                          : @@DsD0( @@DsD0C ).d0fiom
                          : @@DsD0( @@DsD0C ).d0fioa
                          : @@lap1                   );

                    if @@lap1 <> 365 and @@lap1 <> 366 ;
                       @@DsD3( x ).d3cfnn =  @@DsD3( x ).d3cfnn / 365;
                       @@DsD3( x ).d3cfnn =  @@DsD3( x ).d3cfnn * @@lap1;
                    endif;

               when t@bas4 = '6';
                    @@aux3 = ( g3prim - g3bpri ) + g3read;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;

               when t@bas4 = '7';
                    @@aux3 = ( g3prim - g3bpri ) + g3read + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;

               when t@bas4 = '8';
                    @@aux3 = ( g3prim - g3bpri ) + g3read + g3refi + g3dere;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;

               when t@bas4 = '9';
                    @@aux3 = g3read;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;

               when t@bas4 = 'A';
                    @@aux3 = g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;

               when t@bas4 = 'B';
                    @@aux3 = ( g3prim - g3bpri ) + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;

               when t@bas4 = 'C';
                    @@aux3 = g3read + g3refi;
                    eval(h) @@aux4 = @@aux3 * @@DsD3( x ).d3xfnn;
                    eval(h) @@DsD3( x ).d3cfnn = @@aux4 / 100;
            endsl;

            @@DsD3( x ).d3mar1 = '0';
            @@DsD3( x ).d3mar2 = '0';
            @@DsD3( x ).d3mar3 = '0';
            @@DsD3( x ).d3mar4 = '0';
            @@DsD3( x ).d3mar5 = '0';
            @@DsD3( x ).d3strg = '0';
            @@DsD3( x ).d3user = @PsDs.CurUsr;
            @@DsD3( x ).d3time = %dec(%time():*iso);
            @@DsD3( x ).d3date = udate;

            if @@DsD0( @@DsD0C ).d0prem = *zeros;
              if @@DsD3( x ).d3copr <> *zeros or
                 @@DsD3( x ).d3ccob <> *zeros or
                 @@DsD3( x ).d3cfno <> *zeros or
                 @@DsD3( x ).d3cfnn <> *zeros;
                if @@DsD3( x ).d3facc <> 'A';
                   @@DsD3( x ).d3mar1 = 'A';
                   @@ma20 = '0';
                endif;
              endif;
            endif;

            if n2mar1 = '2'  and
               @@DsD3( x ).d3mar1 <> 'A' and @@DsD3( x ).d3facc <> 'A';
               @@DsD3( x ).d3mar1 = 'A';
            endif;

            @@DsD3( x ).d3mar2 = n2mar1;

            if @@ma20 = 'E' or @@ma20 = 'A';
               @@DsD3( x ).d3facc = @@ma20;
               @@DsD3( x ).d3mar1 = '0';
               @@DsD3( x ).d3mar2 = '0';
            endif;

            if not SVPPOL_updComisionesxInt( @@DsD3( x ) );
              //error
            endif;

           endif;
          reade %kds( k1yeg3 : 9 ) paheg3;
         enddo;
       endfor;

       return *on;
      /end-free

     P SVPEMI_setComisionxCalculo...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMI_setCuotasUnificadasxCalculo: Graba cuotas Unificadas      *
      *                                     Calculo.-                    *
      *      peEmpr ( input )  Empresa                                   *
      *      peSucu ( input )  Sucursal                                  *
      *      peArcd ( input )  Articulo                                  *
      *      peSpol ( input )  Super Poliza                              *
      *      peSspo ( input )  Suplemento Super Poliza                   *
      *                                                                  *
      * Retorna *on = Calculo Comision / *off = No Calculó               *
      * ---------------------------------------------------------------- *
     P SVPEMI_setCuotasUnificadasxCalculo...
     P                 B                   export
     D SVPEMI_setCuotasUnificadasxCalculo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
      *
     D @@DsD0          ds                  likeds( dsPaheD0_t ) dim( 999 )
     D @@DsD0C         s             10i 0
     D @@DsC1          ds                  likeds( dsPaheC1_t ) dim( 999 )
     D @@DsC1C         s             10i 0
     D @@DsC3          ds                  likeds( dsPahec3V2_t )
     D @@DsArt         ds                  likeds( dsset630_t )
      *
     D x               s             10i 0
     D rc              s               n
     D @@d             s              2  0
     D @@m             s              2  0
     D @@a             s              4  0
     D @@sspo          s              3  0
     D @@aux1          s             30  9
     D @@nrcu          s              2  0
     D @@imcu          s             15  2

     D k1ycc2          ds                  likerec( p1hcc2   : *key )
     D k1ycd5          ds                  likerec( p1hcd502 : *key )

      /free

       SVPEMI_inz();

       PAR310X3 ( peEmpr : @@a : @@m : @@d );

       rc = SVPART_getParametria( peArcd : @@DsArt );

       rc = SPVSPO_getCabeceraSuplemento( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : @@DsC1
                                        : @@DsC1C );

       rc = SVPPOL_getPolizadesdeSuperPoliza( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsD0
                                            : @@DsD0C );
       @@sspo = peSspo;
       clear @@DsC3;
       if SPVSPO_getPlandePagoV2( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol
                                : @@sspo
                                : @@DsC3 );
       endif;

       for x = 1 to @@DsD0C;
         @@aux1 += @@DsD0( @@DsD0C ).d0prem;
       endfor;

       // elimina todo...
       k1ycc2.c2empr = peEmpr;
       k1ycc2.c2sucu = peSucu;
       k1ycc2.c2arcd = peArcd;
       k1ycc2.c2spol = peSpol;
       k1ycc2.c2sspo = peSspo;
       setll %kds( k1ycc2 :  5 ) pahcc2;
       reade %kds( k1ycc2 :  5 ) pahcc2;
       dow not %eof( pahcc2 );
        delete p1hcc2;
        reade %kds( k1ycc2 :  5 ) pahcc2;
       enddo;

       clear @@nrcu;
       k1ycd5.d5empr = peEmpr;
       k1ycd5.d5sucu = peSucu;
       k1ycd5.d5arcd = peArcd;
       k1ycd5.d5spol = peSpol;
       k1ycd5.d5sspo = peSspo;
       chain %kds( k1ycd5 : 5 ) pahcd502;
       if %found( pahcd502 );
        @@nrcu = d5nrcu;
       endif;

       setll %kds( k1ycd5 : 5 ) pahcd502;
       reade %kds( k1ycd5 : 5 ) pahcd502;
       dow not %eof( pahcd502 );
         if d5nrcu <> @@nrcu;
            c2imcu = @@imcu;
            write p1hcc2;
            clear @@imcu;
            clear p1hcc2;
         endif;

         c2empr = d5empr;
         c2sucu = d5sucu;
         c2arcd = d5arcd;
         c2spol = d5spol;
         c2sspo = d5sspo;
         c2nrcu = d5nrcu;
         c2nrsc = *zeros;
         c2fvca = d5fvca;
         c2fvcm = d5fvcm;
         c2fvcd = d5fvcd;
         c2mone = d5mone;
         @@imcu+= d5imcu;
         c2ctcu = d5ctcu;
         c2nrct = d5nrct;
         c2ivr2 = d5ivr2;
         c2nrrt = d5nrrt;
         c2nrlo = d5nrlo;
         c2nrcc = d5nrcc;
         c2cbrn = d5cbrn;
         c2czco = d5czco;
         c2nrla = d5nrla;
         c2nrln = d5nrln;
         c2cert = d5cert;
         c2cfpg = @@DsC1( @@DsC1C ).c1cfpg;
         c2sttc = d5sttc;
         c2marp = d5marp;
         c2mar2 = d5mar2;
         c2strg = d5strg;
         c2user = @PsDs.CurUsr;
         c2time = %dec(%time():*iso);
         c2date = udate;
         c2ivbc = d5ivbc;
         c2ivsu = d5ivsu;
         c2tcta = d5tcta;
         c2mar3 = d5mar3;
         c2mar4 = d5mar4;
         c2cn02 = d5cn02;
         c2imau = d5imau;
         @@nrcu = d5nrcu;
        reade %kds( k1ycd5 : 5 ) pahcd502;
       enddo;

       if @@nrcu <> *zeros;
         c2imcu = @@imcu;
         write p1hcc2;
         clear @@imcu;
         clear p1hcc2;
       endif;


       return *on;

      /end-free

     P SVPEMI_setCuotasUnificadasxCalculo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEMI_CalculaPrimas : Calcula primas.-                      *
      *                                                              *
      *     peEmpr  ( input        ) Empresa                         *
      *     peSucu  ( input        ) Sucursal                        *
      *     peArcd  ( input        ) Articulo                        *
      *     peSpol  ( input        ) SuperPoliza                     *
      *     peSspo  ( input        ) Suplemento                      *
      *     peRama  ( input        ) Rama                            *
      *     peArse  ( input        ) Cant. de polizas                *
      *     peOper  ( input        ) Código de operación             *
      *     peSuop  ( input        ) Suplemento de Operacion         *
      *     pePoco  ( input        ) Número de Componente            *
      *     peVhvu  ( input/output ) Suma Asegurada                  *
      *                                                              *
      * Retorna: Devuelve valor de Prima                             *
      * ------------------------------------------------------------ *
     p SVPEMI_CalculaPrimas...
     p                 b                   export
     D SVPEMI_CalculaPrimas...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   pePoco                       4  0 const
     D   peTiou                       2  0 const
     D   peStos                       1  0 const
     D   peStou                       1  0 const
     D   peVhvu                      15  2

     D   x             s             10i 0
     D   @in20         s              1
     D   endpgm        s              2
     D   @@DsT0        ds                  likeds(dsPahet0_t)
     D   @@DsD0        ds                  likeds(dsPahed0_t) dim( 999 )
     D   @@DsD0C       s             10i 0
     D   @@vh0k        s             15  2
     D   x@vh0k        s             15  2
     D   x@vhvu        s             15  2
     D   @@vhvu        s             15  2
     D   @@vase        s             15  2
     D   @@in20        s               n
     D   @@sspo        s              3  0

     D   @@Ds625       ds                  likeds( dsset625_t ) dim( 9999 )
     D   @@Ds224       ds                  likeds( dsSet224_t )

     D   k1y228        ds                  likerec( s1t228  : *key )

      /free

       SVPEMI_end();


       @@sspo = peSspo;
       if not SPVVEH_getPahet0( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : peRama
                              : peArse
                              : pePoco
                              : @@sspo
                              : @@DsT0 );
          //error...
        endif;

        if not SVPPOL_getPoliza( peEmpr
                               : peSucu
                               : peRama
                               : @@DsT0.t0poli
                               : peSuop
                               : peArcd
                               : peSpol
                               : @@sspo
                               : peArse
                               : peOper
                               : @@DsD0
                               : @@DsD0C );
       // Error...
       endif;

       clear x;
       clear @@Ds625;

          if not SVPART_getExt625( peArcd
                                 : peRama
                                 : peArse
                                 : @@Ds625
                                 : x       );
             //Error...
             return *zeros;
          endif;

          if @@Ds625(1).t@mar3 = '1';
             @@vh0k = SPVVEH_getValor0km( @@dsT0.t0vhmc
                                        : @@dsT0.t0vhmo
                                        : @@DsT0.t0vhcs );

             @@vhvu = SPVVEH_getValorUsado( @@DsT0.t0vhmc
                                          : @@DsT0.t0vhmo
                                          : @@DsT0.t0vhcs );

             SPT224( @@Ds224
                   : @@in20
                   : 'RT'   );

             if @@in20 <> '0';
                @@Ds224.t@como = '00';
             endif;

             x@vh0k = @@vh0k;
             x@vhvu = @@vhvu;
             SPVVEH_getConvSumaAsegurada( @@Ds224.t@como
                                        : @@DsD0(@@DsD0C).d0mone
                                        : x@vh0k
                                        : x@vhvu                 );
             if x@vh0k <> *zeros;
                @@vh0k = x@vh0k;
             endif;

             if x@vhvu <> *zeros;
                @@vhvu = x@vhvu;
             endif;
           endif;

           @@vase = *zeros;

           k1y228.t@tair = @@DsT0.t0tair;
           k1y228.t@cobl = @@DsT0.t0cobl;
           k1y228.t@mone = @@DsD0( @@DsD0C ).d0mone;
           k1y228.t@vhca = @@DsT0.t0vhca;
           k1y228.t@vhv2 = @@DsT0.t0vhv2;
           setll %kds(k1y228:5) s1t228;
           if %equal();
             reade %kds(k1y228:5) s1t228;
             if not %eof();
               if @@DsT0.t0vhvu >= t@cap1  and
                  @@DsT0.t0vhvu <= t@cap2;
                  @@vase  = t@cap3;
               endif;
             endif;
           endif;

           if @@vase = *zeros;
              k1y228.t@cobl = @@DsT0.t0cobl;
              setll %kds(k1y228) set228;
              if %equal();
                reade %kds(k1y228) set228;
                if not %eof();
                  if @@DsT0.t0vhvu >= t@cap1  and
                     @@DsT0.t0vhvu <= t@cap2;
                     @@vase = t@cap3;
                  endif;
                endif;
              endif;
           endif;

          if @@vase = *zeros;
             @@vase = @@DsT0.t0vhvu;
          endif;

          if peVhvu <> 0;
            @@DsT0.t0vhvu = pevhvu;
            @@vase = peVhvu;
          endif;

       return @@vase;
      /end-free

     p SVPEMI_CalculaPrimas...
     p                 e

      * -------------------------------------------------------------*
      * SVPEMI_calcImpuestosPorc. Calcula Porcentajes de Impuestos   *
      *                                                              *
      *     peEmpr  ( input  )  Empresa                              *
      *     peSucu  ( input  )  Sucursal                             *
      *     peArcd  ( input  )  Articulo                             *
      *     peRama  ( input  )  Rama                                 *
      *     pePrim  ( input  )  Prima                                *
      *     peNrpp  ( input  )  Plan de Pago                         *
      *     peDup2  ( input  )  Duracion de Período en meses         *
      *     pePecu  ( input  )  Periodo en curso                     *
      *     pePlac  ( input  )  Plan Comrcial                        *
      *     peDsPi  ( output )  Estructura % Impuestos ( opcional )  *
      *     peFemi  ( input  )  Fecha de emision       ( opcional )  *
      *     peBpip  ( input  )  % Bonificacion Prima   ( opcional )  *
      *     peBpep  ( input  )  % Derecho de Emision   ( opcional )  *
      *     peDere  ( input  )  $ Derecho de Emision   ( opcional )  *
      *     peTiou  ( input  )  Tipo de operacion      ( opcional )  *
      *     peStou  ( input  )  Subtipo Usuario        ( opcional )  *
      *     peStos  ( input  )  subtipo Sistema        ( opcional )  *
      *     penivt  ( input  )  Tipo intermediario     ( opcional )  *
      *     penivc  ( input  )  Nivel intermediario    ( opcional )  *
      *     peXrea  ( input  )  Recargo financiro      ( opcional )  *
      *     peXref  ( input  )  Recargo Administrativo ( opcional )  *
      *                                                              *
      *                                                              *
      * Retorna : *on = Calculó / *off = No Calculó                  *
      * -------------------------------------------------------------*
     P SVPEMI_calcImpuestosPorc...
     P                 B                   export
     D SVPEMI_calcImpuestosPorc...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   pePrim                      15  2 const
     D   peNrpp                       3  0 const
     D   peDup2                       2  0 const
     D   pePecu                       3  0 const
     D   pePlac                       3  0 const
     D   peMone                       2    const
     D   peDsPi                            likeds( dsPorcImp_t )
     D   peFemi                       8  0 const options(*nopass:*omit)
     D   peBpip                       5  2 const options(*nopass:*omit)
     D   peBpep                       5  2 const options(*nopass:*omit)
     D   peDere                      15  2 const options(*nopass:*omit)
     D   peTiou                       1  0 const options(*nopass:*omit)
     D   peStou                       2  0 const options(*nopass:*omit)
     D   peStos                       2  0 const options(*nopass:*omit)
     D   peCome                      15  6 const options(*nopass:*omit)
     D   peNivt                       1  0 const options(*nopass:*omit)
     D   peNivc                       5  0 const options(*nopass:*omit)
     D   peXrea                       5  2 const options(*nopass:*omit)
     D   peXref                       5  2 const options(*nopass:*omit)
      *
     D   @@neto        s             15  0
     D   @@tiou        s              1  0
     D   @@stou        s              2  0
     D   @@stos        s              2  0
     D   @@aux1        s             29  9
     D   @@mone        s              2
     D   @@come        s             15  6
     D   @1tiou        s              1  0
     D   @@enco        s              1
     D   @@pgm         s              3
     D   @1mar1        s              1
     D   @1dere        s             15  2
     D   @1xrea        s              5  2
     D   @1xref        s              5  2
     D   @@modo        s              1
     D   @@cade        s              5  0 dim(9)
     D   @@endp        s              3    inz ( '   ' )
     D   @@facc        s              1
     D   @@fech        s              8  0
     D   @@niv6        s              1  0 inz ( 6 )
     D   @@tien        s               n
     D   @@vacc        s             15  2
     D   @@tvcc        s              1a
     D   @@xdia        s              5  0
     D   @@empr        s              1
     D   @@sucu        s              2
     D   @@rama        s              2  0
     D   @@erro        s              1n
     D   @@marp        s              1
     D   @@mar1        s              1
     D   @1bpri        s             15  2
     D   @1marp        s              1
     D   @@bpep        s              5  2
     D   @@dere        s             15  2
     D   @@nivc        s              5  0
     D   @@nivt        s              1  0
     D   @@xrea        s              5  2
     D   @@xref        s              5  2
     D   @@bpip        s              5  2
      *
     D   @@a           s              4  0
     D   @@m           s              2  0
     D   @@d           s              2  0
      *
     D   k1y001        ds                  likerec( s1t001  : *key )
     D   k1y122        ds                  likerec( s1t122  : *key )
     D   k1y123        ds                  likerec( s1t123  : *key )
     D   k1y611        ds                  likerec( s1t611  : *key )
     D   k1y6118       ds                  likerec( s1t6118 : *key )
      *
     D   rc            s               n
      *
     D   @@DsArt       ds                  likeds( dsset630_t )
     D   @@DsPi        ds                  likeds( dsPorcImp_t )

       SVPEMI_inz();

       clear @@DsArt;
       clear @@DsPi;
       rc = SVPART_getParametria( peArcd : @@DsArt );

       @1bpri = *zeros;
       @@bpip = *zeros;
       if %parms >= 10 and %addr( peBpip ) <> *null;
          @@bpip = peBpip;
          eval(h) @1bpri = ( pePrim * peBpip ) / 100 ;
       endif;

       if %parms >= 10 and %addr( peFemi ) <> *null;
          @@fech = peFemi;
       else;
          PAR310X3 ( peEmpr : @@a : @@m : @@d );
          @@fech = (@@a * 10000) + (@@m * 100) + @@d;
       endif;

       if %parms >= 10 and %addr( peCome ) <> *null;
          @@come = peCome;
       else;
          @@come = SVPTAB_cotizaMoneda( peMone : @@fech );
       endif;

       clear @@bpep;
       if %parms >= 10 and %addr( peBpep ) <> *null;
          @@bpep = peBpep;
       endif;


       clear @@nivt;
       if %parms >= 10 and %addr( peNivt ) <> *null;
          @@nivt = peNivt;
       else;
          @@nivt = 1;
       endif;

       clear @@nivc;
       if %parms >= 10 and %addr( peNivc ) <> *null;
          @@nivc = peNivc;
       else;
          @@nivc = 99646;
       endif;


       @@neto = pePrim - @1bpri;
       @@tiou = peTiou;
       @@stou = peStou;
       @@stos = peStos;
       @@aux1 = peDup2 * pePecu;
       @@nivt = peNivt;
       @@nivc = peNivc;
       @@mone = peMone;
       @@come = peCome;
       @@rama = peRama;
       @@empr = peEmpr;
       @@sucu = peSucu;

       chain peRama set001;
       if not %found( set001 );
         return *off;
       endif;
       chain PeRama set123;
       if not %found( set123 );
         return *off;
       endif;

       k1y611.t@plac = pePlac;
       k1y611.t@mone = @@mone;
       setll %kds( k1y611 : 2 ) set611;
       reade %kds( k1y611 : 2 ) set611;
       dow not %eof( set611 );
         if @@aux1 <= t@xmes;
           @@marp = t@marp;
           @@mar1 = t@mar1;
           t@dere = *zeros;
           leave;
         endif;
        reade %kds( k1y611 : 2 ) set611;
       enddo;

       k1y6118.t@empr = peEmpr;
       k1y6118.t@sucu = peSucu;
       k1y6118.t@nivt = peNivt;
       k1y6118.t@nivc = peNivc;
       k1y6118.t@rama = peRama;

       if @@DsArt.t@ma26 = '1';
         chain %kds( k1y6118 : 5 ) set6118;
         if %found( set6118 );
           @@marp = t@marp;
           @@mar1 = t@mar1;
         endif;
       endif;

       // Condiciones Especiales de Recargo...
       @@mar1 = '_';
       if @@mar1 <> *blanks;
         if t@marp = 'T';
           SPDERE( @@tiou
                 : @@stou
                 : @1tiou
                 : @@enco
                 : @@pgm
                 : @@stos );

           k1y122.t@rama = @@rama;
           k1y122.t@arcd = peArcd;
           k1y122.t@mone = @@mone;
           k1y122.t@tiou = @1tiou;
           chain %kds( k1y122 : 4 ) set122;
           if %found( set122 );
             Select;
               When @@neto > t@tpr1 and
                    @@neto > t@tpr2 and
                    @@neto > t@tpr3 and
                    @@neto > t@tpr4;
                    @@dere = t@dem5;

               When @@neto > t@tpr1 and
                    @@neto > t@tpr2 and
                    @@neto > t@tpr3;
                    @@dere = t@dem4;

               When @@neto > t@tpr1 and
                    @@neto > t@tpr2;
                    @@dere = t@dem3;

               When @@neto > t@tpr1;
                    @@dere = t@dem2;
               other;
                    @@dere = t@dem1;
             endsl;
           endif;

           t@dere = @@dere;
           @1mar1 = @@mar1;
           @1dere = t@dere;
           @1xrea = t@xrea;
           @1xref = t@xref;
           @1marp = t@marp;
           clear @@enco;
           clear @@pgm;
           @@modo = 'I';

           // Dejo este llamado para que recuerden que se puede obtener
           // un derecho ed emision diferente por zona, vehiculo, etc...
           //PAR312C1( @@empr
           //        : @@sucu
           //        : @@arcd
           //        : @@spol
           //        : @@sspo
           //        : @@rama
           //        : @@arse
           //        : @@oper
           //        : @@suop
           //        : @@mone
           //        : @1mar1
           //        : @1dere
           //        : @1xrea
           //        : @1xref
           //        : @1marp
           //        : @@enco
           //        : @@pgm
           //        : @@modo );

           //if @@enco = 'S';
           //  t@xref = @1xref;
           //  t@xrea = @1xrea;
           //  t@dere = @1dere;
           //  @@marp = @1marp;
           //endif;
         endif;
       endif;

       if @@DsArt.t@ma25 = '1' and
          @@tiou = 3           and
          t@rame <> 04 ;

          t@bpip =  @@bpip;
          t@xref =  @@xref;
          t@xrea =  @@xrea;
          if @@bpep <> *zeros;
            t@dere = @@bpep;
            t@marp = 'P';
            @@marp = 'P';
          else;
            t@dere = @@dere;
            t@marp = ' ';
            @@marp = ' ';
          endif;
       endif;

       //Derecho por importe o % ?...
       if @@marp      = ' '  or
          @@marp      = 'T'  or
          @@marp      = 'A';
          peDsPi.Tder = 'I';
       endif;

       if @@marp = 'T' or @@tiou = 3;
         SPDERE( @@tiou
               : @@stou
               : @1tiou
               : @@enco
               : @@pgm
               : @@stos );

         k1y122.t@rama = @@rama;
         k1y122.t@arcd = peArcd;
         k1y122.t@mone = @@mone;
         k1y122.t@tiou = @1tiou;
         chain %kds( k1y122 : 4 ) set122;
         if %found( set122 );
           Select;
             When @@neto > t@tpr1 and
                  @@neto > t@tpr2 and
                  @@neto > t@tpr3 and
                  @@neto > t@tpr4;
                  t@dere = t@dem5;

             When @@neto > t@tpr1 and
                  @@neto > t@tpr2 and
                  @@neto > t@tpr3;
                  t@dere = t@dem4;

             When @@neto > t@tpr1 and
                  @@neto > t@tpr2;
                  t@dere = t@dem3;

             When @@neto > t@tpr1;
                  t@dere = t@dem2;
             other;
                  t@dere = t@dem1;
           endsl;
         endif;
       endif;

       if %parms >= 10 and %addr( peDere ) <> *null and @@marp <> 'T' and
          @@tiou <> 1 and @@tiou <> 2;
          t@dere = peDere;
       endif;

       if t@dere = *Zeros;
          t@dere = 1;
       endif;

       SPCADCOM ( @@empr
                : @@sucu
                : @@nivt
                : @@nivc
                : @@cade
                : @@erro
                : @@endp );

       SPEXCODE( @@empr : @@sucu : @@niv6 : @@cade( 6 ) : @@rama : @@tiou
               : @@stou : @@fech : @@endp : @@tien : @@vacc : @@tvcc
               : @@facc : @@xdia : @@dere);

       if @@tien;
         if @@come <> *Zeros;
           @@vacc = @@vacc/@@come;
           @@dere = @@dere/@@come;
         endif;
         t@dere = t@dere + @@dere;
       endif;

       peDsPi.Bpip = t@bpip + @@bpip;

       DBA918R( peEmpr
              : peSucu
              : peNrpp
              : @@mone
              : t@xref
              : *omit          );

       peDsPi.xref = t@xref;
       peDsPi.xrea = t@xrea;
       peDsPi.dere = t@dere;
       peDsPi.pimi = t@pimi;
       peDsPi.pssn = t@pssn;
       peDsPi.psso = t@psso;
       peDsPi.pivi = t@pivi;
       peDsPi.pivn = t@pivn;
       peDsPi.pivr = t@pivr;
       peDsPi.ivam = t@ivam;
       peDsPi.depp = *zeros;
       peDsPi.vacc = @@dere;

       return *on;

      /end-free

     P SVPEMI_calcImpuestosPorc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEMI_calcPremio(): Calcular Premio                         *
      *                                                              *
      *     peEmpr  ( input  )  Empresa                              *
      *     peSucu  ( input  )  Sucursal                             *
      *     peArcd  ( input  )  Codigo de Articulo                   *
      *     peRama  ( input  )  Rama                                 *
      *     peRpro  ( input  )  Provincia Inder                      *
      *     peNrpp  ( input  )  Plan de Pago                         *
      *     peCfpg  ( input  )  Forma de Pago                        *
      *     pePrim  ( input  )  Prima                                *
      *     peDup2  ( input  )  Duracion de Período en meses         *
      *     pePecu  ( input  )  Periodo en curso                     *
      *     pePlac  ( input  )  Plan Comrcial                        *
      *     peMone  ( input  )  Moneda                               *
      *     peCiva  ( input  )  Condicion de Iva                     *
      *     peSuas  ( input  )  Suma Asegurada                       *
      *     peFemi  ( input  )  Fecha de emision       ( opcional )  *
      *     peBpip  ( input  )  % Bonificacion Prima   ( opcional )  *
      *     peBpep  ( input  )  % Derecho de Emision   ( opcional )  *
      *     peDere  ( input  )  $ Derecho de Emision   ( opcional )  *
      *     peTiou  ( input  )  Tipo de operacion      ( opcional )  *
      *     peStou  ( input  )  Subtipo Usuario        ( opcional )  *
      *     peStos  ( input  )  subtipo Sistema        ( opcional )  *
      *     peNivt  ( input  )  Tipo intermediario     ( opcional )  *
      *     peNivc  ( input  )  Nivel intermediario    ( opcional )  *
      *     peXrea  ( input  )  Recargo financiro      ( opcional )  *
      *     peXref  ( input  )  Recargo Administrativo ( opcional )  *
      *     peArse  ( input  )  Cantidad de polizas    ( opcional )  *
      *     peCcom  ( input  )  Cantidad de componentes( opcional )  *
      *     peDsPi  ( output )  Estructura % Impuestos ( opcional )  *
      *     peDsTi  ( output )  Totales calculados     ( opcional )  *
      *     peDsIp  ( output )  Totales x Prov         ( opcional )  *
      *                                                              *
      * Retorna: Premio                                              *
      * -------------------------------------------------------------*
     P SVPEMI_calcPremio...
     P                 B                   export
     D SVPEMI_calcPremio...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peRpro                       2  0 const
     D   pePrim                      15  2 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0 const
     D   peTiso                       2  0 const
     D   peAsen                       7  0 const
     D   peDup2                       2  0 const
     D   pePecu                       3  0 const
     D   pePlac                       3  0 const
     D   peMone                       2    const
     D   peCiva                       2  0 const
     D   peSuas                      15  2 const
     D   peFemi                       8  0 const options(*nopass:*omit)
     D   peBpip                       5  2 const options(*nopass:*omit)
     D   peBpep                       5  2 const options(*nopass:*omit)
     D   peDere                      15  2 const options(*nopass:*omit)
     D   peTiou                       1  0 const options(*nopass:*omit)
     D   peStou                       2  0 const options(*nopass:*omit)
     D   peStos                       2  0 const options(*nopass:*omit)
     D   peCome                      15  6 const options(*nopass:*omit)
     D   peNivt                       1  0 const options(*nopass:*omit)
     D   peNivc                       5  0 const options(*nopass:*omit)
     D   peXrea                       5  2 const options(*nopass:*omit)
     D   peXref                       5  2 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peCcom                      10i 0 const options(*nopass:*omit)
     D   peDsPi                            likeds(dsPorcImp_t    )
     D                                           options(*nopass:*omit)
     D   peDsIt                            likeds(dsImpTotales_t )
     D                                           options(*nopass:*omit)
     D   peDsIp                            likeds(dsImpEg3_t     ) dim(30)
     D                                           options(*nopass:*omit)
      *
     D   x             s             10i 0
     D   pro           s              2  0 dim(30)
     D   pri           s             15  2 dim(30)
     D   net           s             15  2 dim(30)
     D   bon           s             15  2 dim(30)
     D   rea           s             15  2 dim(30)
     D   ref           s             15  2 dim(30)
     D   der           s             15  2 dim(30)
     D   sub           s             15  2 dim(30)
     D   sel           s             15  2 dim(30)
     D   see           s             15  2 dim(30)
     D   ib1           s             15  2 dim(30)
     D   ib2           s             15  2 dim(30)
     D   per           s             15  2 dim(30)
     D   pre           s             15  2 dim(30)
     D   ipr1          s             15  2 dim(30)
     D   ipr3          s             15  2 dim(30)
     D   ipr4          s             15  2 dim(30)
     D   ipr6          s             15  2 dim(30)
     D   sefr          s             15  2 dim(30)
     D   sefe          s             15  2 dim(30)
      *
     D   @@prim        s             15  2
     D   @@neto        s             15  2
     D   @@subt        s             15  2
     D   @@bpri        s             15  2
     D   @@dere        s             15  2
     D   @1dere        s             15  2
     D   @@refi        s             15  2
     D   @@seri        s             15  2
     D   @@seem        s             15  2
     D   @@impi        s             15  2
     D   @@sers        s             15  2
     D   @@tssn        s             15  2
     D   @@ipr1        s             15  2
     D   @@ipr2        s             15  2
     D   @@ipr3        s             15  2
     D   @@ipr4        s             15  2
     D   @@ipr5        s             15  2
     D   @@ipr6        s             15  2
     D   @@ipr7        s             15  2
     D   @@ipr8        s             15  2
     D   @@ipr9        s             15  2
     D   @@pivr        s              5  2
     D   @@prem        s             15  2
     D   @@read        s             15  2
     D   @@copr        s             15  2
     D   @@pro         s              2  0
     D   @@copo        s              5  0
     D   @@cops        s              1  0
     D   @@aux6        s             29  6
     D   @@porc        s              9  6
     D   @@ivam        s             15  2
     D   @@ivat        s             15  2
     D   canpro        s             10i 0
     D   @@tiso        s              2  0
     D   otro_sellado  s               n
     D   @@imau        s             15  2
     D   @@sefr        s             15  2
     D   @@sefe        s             15  2
     D   @@siva        s             15  2
     D   @@femi        s              8  0
     D   @@bpip        s              5  2
     D   @@bpep        s              5  2
     D   @@tiou        s              1  0
     D   @@stou        s              2  0
     D   @@stos        s              2  0
     D   @@come        s             15  6
     D   @@nivt        s              1  0
     D   @@nivc        s              5  0
     D   @@xrea        s              5  2
     D   @@xref        s              5  2
     D   @@a           s              4  0
     D   @@m           s              2  0
     D   @@d           s              2  0
     D   @@asen        s              7  0
     D   @@suas        s             15  2
     D   @@civa        s              2  0
     D   @@mone        s              2
     D   @@arse        s              2  0
     D   @@rama        s              2  0
     D   @@ccom        s             10i 0
      *
     D   rc            s               n
     D   @@DsArt       ds                  likeds (   dsset630_t    )
     D   @@DsPi        ds                  likeds (   dsPorcImp_t   )
     D   @@DsIp        ds                  likeds (    dsImpEg3_t   ) dim( 30 )
     D   @@DsIt        ds                  likeds (  dsImpTotales_t )
      *

      /free
       SPVVEH_inz();

       rc = SVPART_getParametria( peArcd : @@DsArt );

       @@prim  = pePrim;
       clear @@DsPi;
       @@asen = peAsen;
       @@civa = peCiva;
       @@suas = peSuas;
       @@mone = peMone;
       @@rama = peRama;
       @@tiso = peTiso;
       canpro = 1;
       pro( 1 ) = peRpro;
       pri( 1 ) = @@prim;
       // Inicialmente toma fecha hoy ...
       PAR310X3 ( peEmpr : @@a : @@m : @@d );
       @@femi = (@@a * 10000) + (@@m * 100) + @@d;

       if %parms >= 15 and %addr( peFemi ) <> *null;
          @@femi = peFemi;
       endif;

       if %parms >= 15 and %addr( peBpip ) <> *null;
          @@bpip = peBpip;
       endif;

       if %parms >= 15 and %addr( peBpep ) <> *null;
         @@bpep = peBpep;
       endif;

       if %parms >= 15 and %addr( peDere ) <> *null;
         @@dere = peDere;
       endif;
       @@ccom = 1;
       if %parms >= 15 and %addr( peCcom ) <> *null;
         if peCcom <> *zeros;
            @@ccom = peCcom;
         endif;
       endif;

       // Inicialmente asume poliza nueva...
       @@tiou = 1;
       @@stou = 0;
       @@stos = 0;

       if %parms >= 15 and %addr( peTiou ) <> *null or
                           %addr( peStou ) <> *null or
                           %addr( peStos ) <> *null;
           @@tiou = peTiou;
           @@stou = peStou;
           @@stos = peStos;
       endif;

       // Inicialmente busca moneda con @@femi...
       @@come = SVPTAB_cotizaMoneda( @@mone : @@femi );

       if %parms >= 15 and %addr( peCome ) <> *null;
         @@come = peCome;
       endif;

       //Inicialmente asume nivel 1...
       @@nivt = 1;
       if %parms >= 15 and %addr( peNivt ) <> *null;
         @@nivt = peNivt;
       endif;

       //Inicialmente asume intermediario generico ...
       @@nivc = 99646;
       if %parms >= 15 and %addr( peNivc ) <> *null;
         @@nivc = peNivc;
       endif;

       //Inicialmente asume 1 ...
       @@arse = 1;
       if %parms >= 15 and %addr( peArse ) <> *null;
         @@arse = peArse;
       endif;

       rc = SVPEMI_calcImpuestosPorc( peEmpr
                                    : peSucu
                                    : peArcd
                                    : @@rama
                                    : pePrim
                                    : peNrpp
                                    : peDup2
                                    : pePecu
                                    : pePlac
                                    : @@mone
                                    : @@DsPi
                                    : @@femi
                                    : @@bpip
                                    : @@bpep
                                    : @@dere
                                    : @@tiou
                                    : @@stou
                                    : @@stos
                                    : @@come
                                    : @@nivt
                                    : @@nivc
                                    : *omit
                                    : *omit    );


       //Inicialmente asume 0 ...
       @@xrea = 0;
       if %parms >= 15 and %addr( peXrea ) <> *null;
         @@xrea = peXrea;
       else;
         @@xrea = @@DsPi.xrea;
       endif;

       //Inicialmente asume 0 ...
       @@xref = 0;
       if %parms >= 15 and %addr( peXref ) <> *null;
         @@xref = peXref;
       else;
         @@xref = @@DsPi.xref;
       endif;

       // Importe bonificacion...
       eval(h) @@bpri = ( @@prim * @@dsPi.bpip ) / 100;

       // Importe Neto...
       @@neto = @@prim - @@bpri;

       // Importe Recargo financiero...
       @@refi = ( @@neto * @@xref ) / 100;

       // Importe de Recargo Administrativo...
       @@read = ( @@neto * @@xrea ) / 100;

       // Bonificacion por Provincia...
       bon = ( pri * @@DsPi.bpip ) / 100;
       //bon =  pri * @@DsPi.bpip;

       // Neto por Provincia...
       net = pri - bon;

       // Recargo financiero por Provincia...
       ref = ( net * @@DsPi.xref ) / 100;

       // Recargo administrativo por Provincia...
       rea = ( net * @@xrea ) / 100 ;

       //Importe de derecho de emision...
       if @@prim = *zeros;
          clear @@dsPi.dere;
          clear @@dsPi.bpep;
       else;
          if @@nivc = 99646;
            clear @@dsPi.dere;
            clear @@dsPi.bpep;
          else;
            @@dsPi.dere = @@dsPi.dere / @@ccom;
            @@dsPi.bpep = @@dsPi.bpep / @@ccom;
          endif;
       endif;

       if @@DsPi.tder = 'I';
         if canpro = 0;
           return 0;
         endif;
         @1dere  = @@dsPi.dere / canpro;
         for x = 1 to 30;
           if pro( x ) <> *zeros;
             der( x ) = @1dere;
           endif;
         endfor;
         @@dere = @@dsPi.dere;
       else;
       // calculo derecho .. dividir equitativamente por provinc...
           eval(h) @@dere = ( net( x ) * @@dsPi.bpep ) / 100;
         for x = 1 to 30;
           if pro( x ) <> *zeros;
             eval(h) der( x ) = ( net( x ) * @@dsPi.bpep ) / 100;
           endif;
         endfor;

       endif;

       // Calcular subtotal...
       @@subt = @@neto + @@refi + @@read + @@dere;
       sub = net + ref + rea + der;

       // Balance...

       // Prima...
       @@aux6 = %XFoot(pri);
       @@aux6 = @@prim - @@aux6;
       for x = 1 to 30;
         if pri(x) <> *zeros;
           pri(x)  += @@aux6;
         leave;
         endif;
       endfor;

       // Bonificacion...
       @@aux6 = %XFoot(bon);
       @@aux6 = @@bpri - @@aux6;
       for x = 1 to 30;
         if bon(x) <> *zeros;
           bon(x) += @@aux6;
         leave;
         endif;
       endfor;

       // Recargo Administrativo...
       @@aux6 = %XFoot(rea);
       @@aux6 = @@read - @@aux6;
       for x =1 to 30;
         if rea(x) <> *zeros;
           rea(x) += @@aux6;
         leave;
         endif;
       endfor;

       // Recargo Financiero...
       @@aux6 = %XFoot(ref);
       @@aux6 = @@refi - @@aux6;
       for x = 1 to 30;
         if ref(x) <> *zeros;
           ref(x) += @@aux6;
         leave;
         endif;
       endfor;

       // Derecho de emision...
       @@aux6 = %XFoot(der);
       @@aux6 = @@dere - @@aux6;
       for x = 1 to 30;
         if der(x) <> *zeros;
           der(x) += @@aux6;
         leave;
         endif;
       endfor;

       // Calcular Impuestos Internos...
       @@impi = ( @@subt * @@DsPi.pimi ) / 100;

       // Calcular Tasa de Superintedencia...
       @@tssn = ( @@subt * @@DsPi.pssn ) / 100;

       // Calcular Servicios Sociales...
       @@sers = ( @@subt * @@DsPi.psso ) / 100;

       // Calcular ingreso bruto ( Convenio Multilateral );
       for x = 1 to 30;
         if pro( x ) <> *zeros;
           // IIB...
           ib1(x) = SVPEMI_CalcIngresosBrutos( pro( x )
                                             : @@rama
                                             : 'R'
                                             : net( x )
                                             : rea( x )
                                             : ref( x )
                                             : der( x ) );
           @@ipr7 += ib1( x );
         endif;
         if pro( x ) <> @@pro;
           // IIB Empresa...
           ib2(x) = SVPEMI_CalcIngresosBrutos( pro( x )
                                             : @@rama
                                             : 'R'
                                             : net( x )
                                             : rea( x )
                                             : ref( x )
                                             : der( x ) );
           @@ipr8 += ib2( x );
         endif;
       endfor;

       // Calcula IVA...
       @@siva = @@subt;
       @@pivr = @@DsPi.pivr;
       @@ivat = SVPEMI_CalcIVATotal( @@come
                                   : peCiva
                                   : @@subt
                                   : @@DsPi.pivi
                                   : @@DsPi.pivn
                                   : @@pivr
                                   : @@DsPi.ivam
                                   : @@asen
                                   : @@ipr1
                                   : @@ipr3
                                   : @@ipr4                   );

       @@DsPi.pivr = @@pivr;

       // Calcular Percepcion de Ingresos Brutos...
       clear @@ipr6;
       for x = 1 to 30;
         if pro( x ) <> *zeros;
           clear @@porc;
           if pri( x ) <> *zeros;
             @@porc = ( pri( x ) / @@prim ) * 100;
             ipr6( x ) = SVPEMI_CalcPercepcion( pro( x )
                                              : @@rama
                                              : @@mone
                                              : @@come
                                              : sub( x )
                                              : @@suas
                                              : @@civa
                                              : @@ipr1
                                              : @@ipr3
                                              : @@ipr4
                                              : *omit
                                              : @@asen
                                              : @@porc
                                              : ipr1( x )
                                              : ipr3( x )
                                              : ipr4( x ) );
           @@ipr6 += ipr6( x );
           endif;
         endif;
       endfor;

       // Calcular Alicuota de Percepcion...
       @@imau = SVPEMI_CalcAlicuotaPercepcion( 20
                                             : @@rama
                                             : @@ipr1
                                             : @@ipr3
                                             : @@ipr4
                                             : @@subt
                                             : @@asen
                                             : @@civa );
       // Calcular sellados...
       // PRO401N--> svpemi...
       otro_sellado = *off;
       for x = 1 to 30;
         if pro( x ) <> *zeros;
           sel( X ) = SVPEMI_CalcSelladosProvinciales( pro( x )
                                                     : @@rama
                                                     : @@mone
                                                     : @@come
                                                     : pri( x )
                                                     : bon( x )
                                                     : rea( x )
                                                     : ref( x )
                                                     : der( x )
                                                     : sub( x )
                                                     : @@suas
                                                     : @@impi
                                                     : @@sers
                                                     : @@tssn
                                                     : @@ipr1
                                                     : @@ipr2
                                                     : @@ipr3
                                                     : @@ipr4
                                                     : @@ipr5
                                                     : @@ipr6
                                                     : @@ipr7
                                                     : @@ipr8
                                                     : @@prim
                                                     : @@tiso
                                                     : *omit
                                                     : *omit
                                                     : sefr( x ) );
           @@seri += sel( X );
         endif;

          if pro( x ) <> 20 and sel( x ) <> *zeros;
            otro_sellado = *on;
          endif;

          if pro( x ) <> @@pro;
            see( X ) = SVPEMI_CalcSelladosProvinciales( @@pro
                                                      : @@rama
                                                      : @@mone
                                                      : @@come
                                                      : pri( x )
                                                      : bon( x )
                                                      : rea( x )
                                                      : ref( x )
                                                      : der( x )
                                                      : sub( x )
                                                      : @@suas
                                                      : @@impi
                                                      : @@sers
                                                      : @@tssn
                                                      : @@ipr1
                                                      : @@ipr2
                                                      : @@ipr3
                                                      : @@ipr4
                                                      : @@ipr5
                                                      : @@ipr6
                                                      : @@ipr7
                                                      : @@ipr8
                                                      : @@prim
                                                      : @@tiso
                                                      : *omit
                                                      : *omit
                                                      : sefe( x ) );
         @@seem += see ( x );
         endif;
       endfor;

       // Calcular premio...
       @@prem = @@neto
              + @@refi
              + @@read
              + @@dere
              + @@seri
              + @@seem
              + @@impi
              + @@sers
              + @@tssn
              + @@ipr1
              + @@ipr2
              + @@ipr3
              + @@ipr4
              + @@ipr5
              + @@ipr6
              + @@ipr7
              + @@ipr8;

       if not SVPEMI_setAjustaImportes( peArcd
                                      : @@rama
                                      : @@arse
                                      : @@prim
                                      : @@bpri
                                      : @@prem
                                      : @@read
                                      : @@refi
                                      : @@dere
                                      : @@impi
                                      : @@sers
                                      : @@tssn
                                      : pro
                                      : pri
                                      : pre
                                      : bon
                                      : der
                                      : ref
                                      : rea  );
         return 0;
       endif;

       @@siva = ( @@prim - @@bpri ) + @@read + @@refi  + @@dere;

       if %addr( peDsIp ) <> *null;
         clear @@DsIp;
         for x = 1 to 30;
           peDsIp( x ).pro  = pro  ( x );
           peDsIp( x ).pri  = pri  ( x );
           peDsIp( x ).bon  = bon  ( x );
           peDsIp( x ).ref  = ref  ( x );
           peDsIp( x ).rea  = rea  ( x );
           peDsIp( x ).der  = der  ( x );
           peDsIp( x ).sel  = sel  ( x );
           peDsIp( x ).see  = see  ( x );
           peDsIp( x ).ib1  = ib1  ( x );
           peDsIp( x ).ib2  = ib2  ( x );
           peDsIp( x ).pre  = pre  ( x );
           peDsIp( x ).ipr1 = ipr1 ( x );
           peDsIp( x ).ipr3 = ipr3 ( x );
           peDsIp( x ).ipr4 = ipr4 ( x );
           peDsIp( x ).per  = ipr6 ( x );
           peDsIp( x ).sefe = sefe ( x );
           peDsIp( x ).sefr = sefr ( x );
         endfor;
       endif;

       if %addr( peDsIt ) <> *null;
         clear peDsIt;

       //if %parms >= 10 and %addr( peDere ) <> *null;
       //   @@dere = peDere;
       //endif;

       //if %parms >= 10 and %addr( peXref ) <> *null;
       //   @@xref = peXref;
       //endif;

       //if %parms >= 10 and %addr( peXrea ) <> *null;
       //  @@read = peXrea;
       //endif;

         peDsIt.prim = @@prim;
         peDsIt.bpri = @@bpri;
         peDsIt.refi = @@refi;
         peDsIt.read = @@read;
         peDsIt.dere = @@dere;
         peDsIt.seri = @@seri;
         peDsIt.seem = @@seem;
         peDsIt.imau = @@imau;
         peDsIt.ipr7 = @@ipr7;
         peDsIt.ipr8 = @@ipr8;
         peDsIt.prem = @@prem;
         peDsIt.ipr1 = @@ipr1;
         peDsIt.ipr3 = @@ipr3;
         peDsIt.ipr4 = @@ipr4;
         peDsIt.ipr6 = @@ipr6;
         peDsIt.sefr = @@sefr;
         peDsIt.sefe = @@sefe;
         peDsIt.impi = @@impi;
         peDsIt.tssn = @@tssn;
         peDsIt.sers = @@sers;
         peDsIt.siva = @@siva;
       endif;

       if %addr( peDsPi ) <> *null;
         clear peDsPi;
         eval-corr peDsPi = @@DsPi;

         if @@ipr3 = *zeros;
           clear peDsPi.pivr;
         endif;
         if @@ipr4 = *zeros;
           clear peDsPi.pivn;
         endif;

       endif;

       return @@prem;
      /end-free
     P SVPEMI_calcPremio...
     P                 E



