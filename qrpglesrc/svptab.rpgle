     H nomain
      * ************************************************************ *
      * SVPTAB: Programa de Servicio.                                *
      *         Tabla                                                *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                  ** 21-Ago-2019 **          *
      * ************************************************************ *
      * LRG 30-01-2020 : Se agrega el procedimiento _cotizaMoneda    *
      * JSN 25/03/2020 - Se agrega los Procedimientos:               *
      *                  _getTipoMascotas().                         *
      *                  _getRazaMascotas().                         *
      *                  _getRelaMascotas().                         *
      *                  _getTipoMascotasWeb().                      *
      *                  _getRelaMascotasWeb().                      *
      * SGF 27/04/2020 - Agrego _getParentescosVida.                 *
      * LRG 10-06-2020 : Se agrega el procedimiento                  *
      *                           _getFormasDePago                   *
      *                           _getCombinacionFormaDePago         *
      * JSN 23/09/2020 - Se agrega el procedimiento:                 *
      *                   _getResBcoXCodCobW                         *
      * JSN 29/01/2021 - Se agrega los procedimientos:               *
      *                   _getCntcfp                                 *
      *                   _getCntnau                                 *
      *                   _chkAgente                                 *
      * JSN 18/03/2021 - Se agrega el procedimiento:                 *
      *                   _getTipoDePersona                          *
      *                   _getRequiereAPRC                           *
      *                   _getProvincia                              *
      * NWN 23/06/2021 - Se agrega los procedimientos:               *
      *                   _getSet001                                 *
      * ************************************************************ *
     Fset2370   if   e           k disk    usropn
     Fset2371   if   e           k disk    usropn
     Fset23711  if   e           k disk    usropn
     Fgntcmo    if   e           k disk    usropn
     Fset136    if   e           k disk    usropn
     Fset13601  if   e           k disk    usropn rename(s1t136:s1t13601)
     Fset137    if   e           k disk    usropn
     Fset138    if   e           k disk    usropn
     Fset069    if   e           k disk    usropn
     Fgntfpg    if   e           k disk    usropn
     Fgntfpg02  if   e           k disk    usropn rename(g1tfpg:g1tfpg02)
     Fset919    if   e           k disk    usropn
     Fcntrba04  if   e           k disk    usropn
     Fcntcfp    if   e           k disk    usropn
     Fcntnau01  if   e           k disk    usropn
     Fsehint    if   e           k disk    usropn
     Fcntcfp02  if   e           k disk    usropn
     Fset6202   if   e           k disk    usropn
     Fset100    if   e           k disk    usropn
     Fset102    if   e           k disk    usropn
     Fgntpro01  if   e           k disk    usropn
     Fset001    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svptab_h.rpgle'

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

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

     D Initialized     s              1N
      * ------------------------------------------------------------ *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

     Is1t136
     I              t@date                      @@date
     Is1t13601
     I              t@date                      @@date
     Is1t137
     I              t@date                      @@date
     Is1t138
     I              t@date                      @@date
     Is1t919
     I              t@date                      @@date
     Ic1tcfp
     I              fpdate                      @1date
     Ic1tcfp01
     I              fpdate                      @1date
     Is1t6202
     I              t@date                      @@date
     Is1t001
     I              t@date                      xxdate


      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPTAB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPTAB_inz      B                   export
     D SVPTAB_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set2370);
         open set2370;
       endif;

       if not %open(set2371);
         open set2371;
       endif;

       if not %open(set23711);
         open set23711;
       endif;

       if not %open(gntcmo);
         open gntcmo;
       endif;

       if not %open(set136);
         open set136;
       endif;

       if not %open(set13601);
         open set13601;
       endif;

       if not %open(set137);
         open set137;
       endif;

       if not %open(set138);
         open set138;
       endif;

       if not %open(set069);
         open set069;
       endif;

       if not %open(gntfpg);
         open gntfpg;
       endif;

       if not %open(gntfpg02);
         open gntfpg02;
       endif;

       if not %open(set919);
         open set919;
       endif;

       if not %open(cntrba04);
         open cntrba04;
       endif;

       if not %open(cntcfp);
         open cntcfp;
       endif;

       if not %open(cntnau01);
         open cntnau01;
       endif;

       if not %open(sehint);
         open sehint;
       endif;

       if not %open(cntcfp02);
         open cntcfp02;
       endif;

       if not %open(set6202);
         open set6202;
       endif;

       if not %open(set100);
         open set100;
       endif;

       if not %open(set102);
         open set102;
       endif;

       if not %open(gntpro01);
         open gntpro01;
       endif;

       if not %open(set001);
         open set001;
       endif;

       initialized = *ON;

       return;

      /end-free

     P SVPTAB_inz      E

      * ------------------------------------------------------------ *
      * SVPTAB_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPTAB_End      B                   export
     D SVPTAB_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPTAB_End      E

      * ------------------------------------------------------------ *
      * SVPTAB_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPTAB_Error    B                   export
     D SVPTAB_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPTAB_Error    E

      * ------------------------------------------------------------- *
      * SVPTAB_getCuestionarios(): Retorna Cuestionario               *
      *                                                               *
      *     peDsCu   ( output ) Estructura de cuestionario            *
      *     peDsCuC  ( output ) cantidad de cuestionario              *
      *     peTaaj   ( input  ) codigo de cuestionario    ( opcional )*
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCuestionarios...
     p                 b                   export
     D SVPTAB_getCuestionarios...
     D                 pi
     D   peDsCu                            likeds( set2370_t ) dim( 99 )
     D   peDsCuc                     10i 0
     D   peTaaj                       2  0 options( *nopass : *omit )

     D   @@DsCu        ds                  likerec( s1t2370 : *input )

      /free

       SVPTAB_inz();

       clear peDsCu;
       clear peDsCuC;

       if %parms >= 2 and %addr(peTaaj) <> *NULL;
          if SVPTAB_getCuestionario( peTaaj : peDsCu(1) );
            peDsCuC = 1;
          endif;
       else;
         clear @@DsCu;
         setll *loval set2370;
         dou %eof( set2370 );
           read set2370 @@DsCu;
           if not %eof( set2370 );
             peDsCuC += 1;
             eval-corr peDsCu( peDsCuC ) = @@DsCu;
           endif;
         enddo;
       endif;

       return;

      /end-free

     P SVPTAB_getCuestionarios...
     p                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getPreguntas(): Retorna Cuestionario                   *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peDsPr   ( output ) Estructura de pregunta                *
      *     peDsPrC  ( output ) cantidad de preguntas                 *
      *     peCosg   ( input  ) codigo de pregunta     ( opcional )   *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getPreguntas...
     p                 b                   export
     D SVPTAB_getPreguntas...
     D                 pi
     D   peTaaj                       2  0 const
     D   peDsPr                            likeds( set2371_t ) dim( 200 )
     D   peDsPrc                     10i 0
     D   peCosg                       4    options( *nopass : *omit )

     D @@DsPr          ds                  likerec( s1t2371 : *input )
     D k1yspr          ds                  likerec( s1t2371 : *key   )

      /free

       SVPTAB_inz();

       clear peDsPr;
       clear @@DsPr;
       clear peDsPrC;

       if %parms >= 3 and %addr(peCosg) <> *NULL;
         if SVPTAB_getPregunta( peTaaj : peCosg : peDsPr(1) );
           peDsPrC = 1;
         endif;
       else;
         clear k1yspr;
         k1yspr.t@taaj = peTaaj;
         setll %kds(k1yspr:1) set2371;
         dou %eof( set2371 );
           reade %kds(k1yspr:1) set2371 @@DsPr;
           if not %eof( set2371 );
             peDsprC += 1;
             eval-corr peDsPr( peDsPrC ) = @@DsPr;
           endif;
         enddo;
       endif;

       return;

      /end-free

     P SVPTAB_getPreguntas...
     p                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getCuestionario(): Retorna Cuestionario                *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peDsCu   ( output ) Estructura de cuestionario            *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCuestionario...
     p                 b                   export
     D SVPTAB_getCuestionario...
     D                 pi              n
     D   peTaaj                       2  0 const
     D   peDsCu                            likeds( set2370_t )

     D   @@DsCu        ds                  likerec( s1t2370 : *input )

      /free

       SVPTAB_inz();

       clear peDsCu;

       chain(n) peTaaj set2370 @@DsCu;
       if %found( set2370 );
          eval-corr peDsCu = @@DsCu;
          return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getCuestionario...
     p                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getPregunta(): Retorna Pregunta                        *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peCosg   ( input  ) codigo de pregunta                    *
      *     peDsPr   ( output ) Estructura de pregunta                *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getPregunta...
     p                 b                   export
     D SVPTAB_getPregunta...
     D                 pi              n
     D   peTaaj                       2  0 const
     D   peCosg                       4    const
     D   peDsPr                            likeds( set2371_t )

     D   @@DsPr        ds                  likerec( s1t2371 : *input )
     D   k1yspr        ds                  likerec( s1t2371 : *key )

      /free

       SVPTAB_inz();

       clear peDsPr;

       k1yspr.t@taaj = peTaaj;
       k1yspr.t@cosg = peCosg;
       chain(n) %kds( k1yspr : 2 ) set2371 @@DsPr;
       if %found( set2371 );
          eval-corr peDsPr = @@DsPr;
          return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getPregunta...
     p                 e

      * ------------------------------------------------------------- *
      * SVPTAB_chkCuestionario(): Retorna Cuestionario                *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_chkCuestionario...
     P                 b                   export
     D SVPTAB_chkCuestionario...
     D                 pi              n
     D   peTaaj                       2  0 const

      /free

       SVPTAB_inz();

       setll peTaaj set2370;

       if %equal;
         return *on;
       else;
         SetError( SVPTAB_VTAAJ
                 : 'Cuestionario Inexistente' );
         return *Off;
       endif;

      /end-free

     P SVPTAB_chkCuestionario...
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
      * SVPTAB_getPreguntaExcluyente(): Retorna Código Excluyente por *
      *                                 pregunta                      *
      *                                                               *
      *     peTaaj   ( input  ) Código de Cuestionario                *
      *     peCosg   ( input  ) Código de Pregunta                    *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getPreguntaExcluyente...
     P                 b                   export
     D SVPTAB_getPreguntaExcluyente...
     D                 pi             4
     D   peTaaj                       2  0 const
     D   peCosg                       4    const

     D @@DsPr          ds                  likeds( set2371_t )

      /free

       SVPTAB_inz();

       clear @@DsPr;

       if SVPTAB_getPregunta( peTaaj
                            : peCosg
                            : @@DsPr );

         return @@DsPr.t@Coex;
       endif;

       return *blanks;

      /end-free

     P SVPTAB_getPreguntaExcluyente...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getItemsExcluyentes(): Retorna Items Excluyentes.      *
      *                                                               *
      *     peTaaj   ( input  ) Código de Cuestionario                *
      *     peCoex   ( output ) Vector de Código de Exclusión         *
      *     peCosg   ( output ) Vector de Código de Pregunta          *
      *                                                               *
      * ------------------------------------------------------------- *
     P SVPTAB_getItemsExcluyentes...
     P                 b                   export
     D SVPTAB_getItemsExcluyentes...
     D                 pi
     D   peTaaj                       2  0 const
     D   peCoex                       4    dim(200)
     D   peCosg                       4    dim(200)

     D   k1y3711       ds                  likerec( s1t23711 : *input )

     D   x             s             10i 0

      /free

       SVPTAB_inz();

       x = 0;
       clear peCoex;

       k1y3711.t@Taaj = peTaaj;
       setll    %kds( k1y3711 : 1 ) set23711;
       reade(n) %kds( k1y3711 : 1 ) set23711;
       dow not %eof( set23711 );
         x = %lookup( t@Coex : peCoex : 1);
         if x = 0;
           x = %lookup( *blanks : peCoex : 1);
           peCoex(x) = t@Coex;
           peCosg(x) = t@Cosg;
         endif;
         reade(n) %kds( k1y3711 : 1 ) set23711;
       enddo;

      /end-free

     P SVPTAB_getItemsExcluyentes...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getItemsObligatorio(): Retorna Items Obligatorio       *
      *                                                               *
      *     peTaaj   ( input  ) Código de Cuestionario                *
      *     peCosg   ( output ) Vector de Código de Pregunta          *
      *                                                               *
      * ------------------------------------------------------------- *
     P SVPTAB_getItemsObligatorio...
     P                 b                   export
     D SVPTAB_getItemsObligatorio...
     D                 pi
     D   peTaaj                       2  0 const
     D   peCosg                       4    dim(200)

     D i               s             10i 0
     D x               s             10i 0
     D @@DsPr          ds                  likeds( set2371_t ) dim( 200 )
     D @@DsPrc         s             10i 0

      /free

       SVPTAB_inz();

       x = 0;
       clear peCosg;

       SVPTAB_getPreguntas( peTaaj
                          : @@DsPr
                          : @@DsPrC );

       for i = 1 to @@DsPrC;
         if @@DsPr(i).t@Cman = '1';
           x = %lookup( @@DsPr(i).t@Cosg : peCosg : 1);
           if x = 0;
             x = %lookup( *blanks : peCosg : 1);
             peCosg(x) = @@DsPr(i).t@Cosg;
           endif;
         endif;
       endfor;


      /end-free

     P SVPTAB_getItemsObligatorio...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_cotizaMoneda(): Retorna cotización de la moneda.      *
      *                                                              *
      *     peComo ( input  ) Código de Moneda                       *
      *     peFcot ( input  ) Fecha de Cotización (aaaammdd)         *
      * Retorna : Cotizacion de Moneda / 0 = no tiene                *
      * ------------------------------------------------------------ *
     P SVPTAB_cotizaMoneda...
     P                 B                   export
     D SVPTAB_cotizaMoneda...
     D                 pi            15  6
     D   peComo                       2      const
     D   peFcot                       8  0   const

     D k1ycmo          ds                  likerec(g1tcmo:*key)

     D                 ds
     D feccmo                  1      8  0
     D feccoa                  1      4  0
     D feccom                  5      6  0
     D feccod                  7      8  0

      /free

       SVPTAB_inz();

       feccmo = peFcot;
       k1ycmo.mocomo = peComo;
       k1ycmo.mofcoa = feccoa;
       k1ycmo.mofcom = feccom;
       k1ycmo.mofcod = feccod;

       setgt %kds( k1ycmo ) gntcmo;
       readpe peComo gntcmo;

       if not %eof ( gntcmo );

         return mocotv;

       endif;

       return 0;

      /end-free

     P SVPTAB_cotizaMoneda...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_getTipoMascotas(): Retorna Tipo de Mascotas            *
      *                                                               *
      *     peDstm   ( output ) Estructura de Tipo de Mascotas        *
      *     peDstmC  ( output ) Cantidad de Tipo de Mascotas          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getTipoMascotas...
     P                 b                   export
     D SVPTAB_getTipoMascotas...
     D                 pi
     D   peDsTm                            likeds( dsSet136_t ) dim(99)
     D   peDsTmC                     10i 0

     D   @@DsTm        ds                  likerec( s1t136 : *input )

      /free

       SVPTAB_inz();

       clear peDsTm;

       setll *loval set136;
       dou %eof( set136 );
         read set136 @@DsTm;
         if not %eof( set136 );
           peDsTmC += 1;
           eval-corr peDsTm( peDsTmC ) = @@DsTm;
         endif;
       enddo;

       return;

      /end-free

     P SVPTAB_getTipoMascotas...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getRazaMascotas(): Retorna Raza de Mascotas            *
      *                                                               *
      *     peDsRm   ( output ) Estructura de Raza de Mascotas        *
      *     peDsRmC  ( output ) Cantidad de Raza de Mascotas          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getRazaMascotas...
     P                 b                   export
     D SVPTAB_getRazaMascotas...
     D                 pi
     D   peDsRm                            likeds( dsSet137_t ) dim(9999)
     D   peDsRmC                     10i 0

     D   @@DsRm        ds                  likerec( s1t137 : *input )

      /free

       SVPTAB_inz();

       clear peDsRm;

       setll *loval set137;
       dou %eof( set137 );
         read set137 @@DsRm;
         if not %eof( set137 );
           peDsRmC += 1;
           eval-corr peDsRm( peDsRmC ) = @@DsRm;
         endif;
       enddo;

       return;

      /end-free

     P SVPTAB_getRazaMascotas...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getRelaMascotas(): Retorna Relación Tipo de Mascota y  *
      *                           Raza de Mascota                     *
      *                                                               *
      *     peCtma   ( input  ) Código Tipo de Mascotas
      *     peDsRm   ( output ) Estructura de Relación de Mascota     *
      *     peDsRmC  ( output ) Cantidad de Relación de Mascota       *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getRelaMascotas...
     P                 b                   export
     D SVPTAB_getRelaMascotas...
     D                 pi              n
     D   peCtma                       2  0 const
     D   peDsRm                            likeds( dsSet138_t ) dim(9999)
     D   peDsRmC                     10i 0

     D @@DsRm          ds                  likerec( s1t138 : *input )
     D k1y138          ds                  likerec( s1t138 : *key )

      /free

       SVPTAB_inz();

       clear peDsRm;

       k1y138.t@Ctma = peCtma;
       setll %kds( k1y138 : 1 ) set138;
       if not %equal( set138 );
         return *off;
       endif;

       reade(n) %kds( k1y138 : 1 ) set138 @@DsRm;
       dow not %eof( set138 );
         peDsRmC += 1;
         eval-corr peDsRm( peDsRmC ) = @@DsRm;
         reade(n) %kds( k1y138 : 1 ) set138 @@DsRm;
       enddo;

       return *on;

      /end-free

     P SVPTAB_getRelaMascotas...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getTipoMascotasWeb(): Retorna Tipo de Mascotas         *
      *                              habilitado en la WEB             *
      *                                                               *
      *     peDstm   ( output ) Estructura de Tipo de Mascotas        *
      *     peDstmC  ( output ) Cantidad de Tipo de Mascotas          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getTipoMascotasWeb...
     P                 b                   export
     D SVPTAB_getTipoMascotasWeb...
     D                 pi
     D   peDsTm                            likeds( dsSet136_t ) dim(99)
     D   peDsTmC                     10i 0

     D   @@DsTm        ds                  likerec( s1t13601 : *input )

      /free

       SVPTAB_inz();

       clear peDsTm;

       setll *loval set13601;
       dou %eof( set13601 );
         read set13601 @@DsTm;
         if not %eof( set13601 );
           peDsTmC += 1;
           eval-corr peDsTm( peDsTmC ) = @@DsTm;
         endif;
       enddo;

       return;

      /end-free

     P SVPTAB_getTipoMascotasWeb...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getRelaMascotasWeb(): Retorna Relación Tipo de Mascota *
      *                              y Raza de Mascota habilitado en  *
      *                              la WEB                           *
      *                                                               *
      *     peCtma   ( input  ) Código Tipo de Mascotas               *
      *     peDsRm   ( output ) Estructura de Relación de Mascota     *
      *     peDsRmC  ( output ) Cantidad de Relación de Mascota       *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getRelaMascotasWeb...
     P                 b                   export
     D SVPTAB_getRelaMascotasWeb...
     D                 pi              n
     D   peCtma                       2  0 const
     D   peDsRm                            likeds( dsSet138_t ) dim(9999)
     D   peDsRmC                     10i 0

     D x               s             10i 0
     D @@DsRm          ds                  likeds( dsSet138_t ) dim(9999)
     D @@DsRmC         s             10i 0

      /free

       SVPTAB_inz();

       x = 0;
       @@DsRmC = 0;

       clear peDsRm;
       clear @@DsRm;

       if SVPTAB_getRelaMascotas( peCtma
                                : @@DsRm
                                : @@DsRmC );

         for x = 1 to @@DsRmC;
           if @@DsRm(x).t@Mweb = '1';
             peDsRmC += 1;
             eval-corr peDsRm( peDsRmC ) = @@DsRm(x);
           endif;
         endfor;

         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getRelaMascotasWeb...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getParentescoVida():  Retorna tabla de parentescos     *
      *                                                               *
      *     peDsRm   ( output ) Estructura de Parentescos             *
      *     peDsRmC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getParentescoVida...
     P                 b                   export
     D SVPTAB_getParentescoVida...
     D                 pi              n
     D   peT069                            likeds(set069_t) dim(999)
     D   peT069C                     10i 0

     D in069           ds                  likerec(s1t069:*input)

      /free

       SVPTAB_inz();

       setll *start set069;
       read set069 in069;
       dow not %eof;
           peT069C += 1;
           eval-corr peT069(peT069C) = in069;
        read set069 in069;
       enddo;

       return *on;

      /end-free

     P SVPTAB_getParentescoVida...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getFormasDePago(): Retorna lista con todas las formas  *
      *                           de pago                             *
      *                                                               *
      *     peTipo   ( input  ) Tipo de forma de pago                 *
      *     peDsFpg  ( output ) Estructura de Tipo de formas de pago  *
      *     peDsFpgC ( output ) Cantidad                              *
      *     peCfpg   ( input  ) Código de Forma de pago               *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getFormasDePago...
     P                 b                   export
     D SVPTAB_getFormasDePago...
     D                 pi              n
     D   peTipo                       1    const
     D   peDsFpg                           likeds( dsGntfpg_t ) dim(99)
     D   peDsFpgC                    10i 0
     D   peCfpg                       1  0 const options(*nopass:*omit)

     D   @@DsIFpg      ds                  likerec( g1tfpg : *input )
     D   @@DsIFpg2     ds                  likerec( g1tfpg02: *input )

      /free

       SVPTAB_inz();

       clear peDsFpg;
       clear peDsFpgC;

       If %parms >= 4;
         If peTipo = 'W';
            if %addr( peCfpg ) = *null;
               setll *loval gntfpg02;
               read gntfpg02 @@DsIFpg2;
               dow not %eof();
                   peDsFpgC += 1;
                   eval-corr peDsFpg(peDsFpgC)= @@DsIFpg2;
                read gntfpg02 @@DsIFpg2;
               enddo;
            else;
               setll peCfpg gntfpg02;
               reade peCfpg gntfpg02 @@DsIFpg2;
               dow not %eof();
                   peDsFpgC += 1;
                   eval-corr peDsFpg(peDsFpgC)= @@DsIFpg2;
                reade peCfpg gntfpg02 @@DsIFpg2;
               enddo;
            endif;
         else;
            If %addr( peCfpg ) = *null;
               setll *loval gntfpg;
               read gntfpg @@DsIFpg;
               dow not %eof();
                   peDsFpgC += 1;
                   eval-corr peDsFpg(peDsFpgC)= @@DsIFpg;
                read gntfpg @@DsIFpg;
               enddo;
            else;
               setll peCfpg gntfpg;
               reade peCfpg gntfpg @@DsIFpg;
               dow not %eof();
                  peDsFpgC += 1;
                  eval-corr peDsFpg(peDsFpgC)= @@DsIFpg;
                reade peCfpg gntfpg @@DsIFpg;
               enddo;
            endif;
         endif;
       else;
         if peTipo = 'W';
            setll *loval gntfpg02;
            read gntfpg02 @@DsIFpg2;
            dow not %eof();
                peDsFpgC += 1;
                eval-corr peDsFpg(peDsFpgC)= @@DsIFpg2;
             read gntfpg02 @@DsIFpg2;
            enddo;
         else;
            setll *loval gntfpg;
            read gntfpg @@DsIFpg;
            dow not %eof();
                peDsFpgC += 1;
                eval-corr peDsFpg(peDsFpgC)= @@DsIFpg;
             read gntfpg @@DsIFpg;
            enddo;
         endif;
       endif;

       if peDsFpgC = 0;
          return *off;
       endif;
       return *on;

      /end-free

     P SVPTAB_getFormasDePago...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getCombinacionFormaDePago(): Retorna combianciones de  *
      *                                     formas de pagos por       *
      *                                     articulo                  *
      *     peArcd   ( input  ) Codigo de Articulo                    *
      *     peCfpg   ( input  ) Tipo de forma de pago                 *
      *     peCfp1   ( input  ) Relacion de forma de pago             *
      *     peDsCf   ( output ) Estructura de Combinaciones           *
      *     peDsCfC  ( output ) Cantidad de Combinaciones             *
      *     peTipo   ( input  ) Tipo de Solicitud                     *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCombinacionFormaDePago...
     P                 b                   export
     D SVPTAB_getCombinacionFormaDePago...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const options(*nopass:*omit)
     D   peCfp1                       1  0 const options(*nopass:*omit)
     D   peDsCf                            likeds( dsSet919_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsCfC                     10i 0 options(*nopass:*omit)
     D   peTipo                       1    options(*nopass:*omit)

     D   @@tipo        s              1
     D   @@DsICf       ds                  likerec( s1t919 : *input )
     D   @@DsCf        ds                  likeds( dsSet919_t ) dim(999)
     D   @@DsCfC       s             10i 0
     D   k1y919        ds                  likerec( s1t919 : *key )

      /free

       SVPTAB_inz();

       clear @@DsCf;
       clear @@DsCfC;
       @@tipo = 'T';
       if %parms >= 1;

          if %addr(peTipo) <> *null;
             @@tipo = %xlate( min : may : petipo );
             if ( @@tipo <> 'T' and @@tipo <> 'W' );
                @@tipo = 'T';
             endif;
          endif;

          Select;
            when %addr( peCfpg ) <> *null and
                 %addr( peCfp1 ) <> *null;

                 k1y919.t@arcd = peArcd;
                 k1y919.t@cfpg = peCfpg;
                 k1y919.t@cfp1 = peCfp1;
                 setll %kds( k1y919 : 3 ) set919;
                 reade %kds( k1y919 : 3 ) set919 @@DsICf;
                 dow not %eof();
                   if ( @@tipo = 'W' and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                      ( @@tipo <> 'W' and
                      SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                         @@DsCfC += 1;
                         eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
                   endif;
                  reade %kds( k1y919 : 3 ) set919 @@DsICf;
                 enddo;

            when %addr( peCfpg ) <> *null and
                 %addr( peCfp1 ) =  *null;

                 k1y919.t@arcd = peArcd;
                 k1y919.t@cfpg = peCfpg;
                 setll %kds( k1y919 : 2 ) set919;
                 reade %kds( k1y919 : 2 ) set919 @@DsICf;
                 dow not %eof();
                   if ( @@tipo = 'W' and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                      ( @@tipo <> 'W' and
                      SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                         @@DsCfC += 1;
                         eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
                   endif;
                  reade  %kds( k1y919 : 2 ) set919 @@DsICf;
                 enddo;

            when %addr( peCfpg ) =  *null and
                 %addr( peCfp1 ) <> *null;

                 k1y919.t@arcd = peArcd;
                 setll %kds( k1y919 : 1 ) set919;
                 reade %kds( k1y919 : 1 ) set919 @@DsICf;
                 dow not %eof();
                   if t@cfp1 = peCfp1;
                     if ( @@tipo = 'W' and
                        SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                        SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                        ( @@tipo <> 'W' and
                        SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                        SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                           @@DsCfC += 1;
                           eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
                     endif;
                   endif;
                  reade %kds( k1y919 : 1 ) set919 @@DsICf;
                 enddo;
            other;
              k1y919.t@arcd = peArcd;
              setll %kds( k1y919 : 1 ) set919;
              reade %kds( k1y919 : 1 ) set919 @@DsICf;
               dow not %eof();
                   if ( @@tipo = 'W' and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                      ( @@tipo <> 'W' and
                      SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                         @@DsCfC += 1;
                         eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
                   endif;
                reade  %kds( k1y919 : 1 )set919 @@DsICf;
               enddo;
            endsl;
       else;
         k1y919.t@arcd = peArcd;
         setll %kds( k1y919 : 1 ) set919;
         reade %kds( k1y919 : 1 ) set919 @@DsICf;
          dow not %eof();
              if ( @@tipo = 'W' and
                 SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                 SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                 ( @@tipo <> 'W' and
                 SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                 SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                    @@DsCfC += 1;
                    eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
              endif;
            reade %kds( k1y919 : 1 ) set919 @@DsICf;
          enddo;

       endif;

       if @@DsCfc = 0;
         return *off;
       endif;
       if %addr(peDsCf) <> *null;
          eval-corr peDsCf = @@DsCf;
       endif;
       if %addr(peDsCfC) <> *null;
          peDsCfC = @@DsCfC;
       endif;

       return *on;

      /end-free

     P SVPTAB_getCombinacionFormaDePago...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPTAB_getResBcoXCodCobW: Retorna Datos de Resolución de     *
     ?*                           Banco por Código de Cobranza WEB   *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peIvbc   ( input  ) Código del Banco                     *
     ?*     peIvsu   ( input  ) Sucursal del Banco        (opcional) *
     ?*     peComa   ( input  ) Código de Mayor Auxiliar  (opcional) *
     ?*     peNrma   ( input  ) Número de Mayor Auxiliar  (opcional) *
     ?*     peDsBa   ( output ) Estruct. Resolución Bco.  (opcional) *
     ?*     peDsBaC  ( output ) Cant. Reg. Resolución Bco.(opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPTAB_getResBcoXCodCobW...
     P                 B                   export
     D SVPTAB_getResBcoXCodCobW...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 options( *nopass : *omit )const
     D   peComa                       2    options( *nopass : *omit )const
     D   peNrma                       7  0 options( *nopass : *omit )const
     D   peDsBa                            likeds ( dsCntrba_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsBaC                     10i 0 options( *nopass : *omit )

     D   k1yeba        ds                  likerec( c1trba04 : *key )
     D   @@DsIBa       ds                  likerec( c1trba04 : *input )
     D   @@DsBa        ds                  likeds ( dsCntrba_t ) dim( 999 )
     D   @@DsBaC       s             10i 0

      /free

       SVPTAB_inz();

       clear @@DsBa;
       @@DsBaC = 0;

       k1yeba.rbEmpr = peEmpr;
       k1yeba.rbSucu = peSucu;
       k1yeba.rbIvbc = peIvbc;

       if %parms >= 4;
         Select;
           when %addr( peIvsu ) <> *null and
                %addr( peComa ) <> *null and
                %addr( peNrma ) <> *null;

              k1yeba.rbIvsu = peIvsu;
              k1yeba.rbComa = peComa;
              k1yeba.rbNrma = peNrma;
              setll %kds( k1yeba : 6 ) cntrba04;
              if not %equal( cntrba04 );
                return *off;
              endif;
              reade(n) %kds( k1yeba : 6 ) cntrba04 @@DsIBa;
              dow not %eof( cntrba04 );
                @@DsBaC += 1;
                eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
               reade(n) %kds( k1yeba : 6 ) cntrba04 @@DsIBa;
              enddo;

           when %addr( peIvsu ) <> *null and
                %addr( peComa ) <> *null and
                %addr( peNrma ) =  *null;

              k1yeba.rbIvsu = peIvsu;
              k1yeba.rbComa = peComa;
              setll %kds( k1yeba : 5 ) cntrba04;
              if not %equal( cntrba04 );
                return *off;
              endif;
              reade(n) %kds( k1yeba : 5 ) cntrba04 @@DsIBa;
              dow not %eof( cntrba04 );
                @@DsBaC += 1;
                eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
               reade(n) %kds( k1yeba : 5 ) cntrba04 @@DsIBa;
              enddo;

           when %addr( peIvsu ) <> *null and
                %addr( peComa ) =  *null and
                %addr( peNrma ) =  *null;

              k1yeba.rbIvsu = peIvsu;
              setll %kds( k1yeba : 4 ) cntrba04;
              if not %equal( cntrba04 );
                return *off;
              endif;
              reade(n) %kds( k1yeba : 4 ) cntrba04 @@DsIBa;
              dow not %eof( cntrba04 );
                @@DsBaC += 1;
                eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
               reade(n) %kds( k1yeba : 4 ) cntrba04 @@DsIBa;
              enddo;

           other;
             setll %kds( k1yeba : 3 ) cntrba04;
             if not %equal( cntrba04 );
               return *off;
             endif;
             reade(n) %kds( k1yeba : 3 ) cntrba04 @@DsIBa;
             dow not %eof( cntrba04 );
               @@DsBaC += 1;
               eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
              reade(n) %kds( k1yeba : 3 ) cntrba04 @@DsIBa;
             enddo;
          endsl;
       else;
         setll %kds( k1yeba : 3 ) cntrba04;
         if not %equal( cntrba04 );
           return *off;
         endif;
         reade(n) %kds( k1yeba : 3 ) cntrba04 @@DsIBa;
         dow not %eof( cntrba04 );
           @@DsBaC += 1;
           eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
          reade(n) %kds( k1yeba : 3 ) cntrba04 @@DsIBa;
         enddo;
       endif;

       if %addr( peDsBa ) <> *null;
         eval-corr peDsBa = @@DsBa;
       endif;

       if %addr( peDsBaC ) <> *null;
         peDsBaC = @@DsBaC;
       endif;

       return *on;

      /end-free

     P SVPTAB_getResBcoXCodCobW...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_getCntcfp(): Retorna datos de Forma de Pago.           *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peIvcv   ( input  ) Código del valor                      *
      *     peDsFp   ( output ) Estructura de Cntcfp                  *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCntcfp...
     P                 b                   export
     D SVPTAB_getCntcfp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvcv                       2  0 const
     D   peDsFp                            likeds( dsCntcfp_t )

     D   k1ycfp        ds                  likerec( c1tcfp : *key   )
     D   @@DsIFp       ds                  likerec( c1tcfp : *input )

      /free

       SVPTAB_inz();

       clear peDsFp;

       k1ycfp.fpEmpr = peEmpr;
       k1ycfp.fpSucu = peSucu;
       k1ycfp.fpIvcv = peIvcv;
       chain %kds( k1ycfp : 3 ) cntcfp @@DsIFp;
       if %found( cntcfp );
         eval-corr peDsFp = @@DsIFp;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getCntcfp...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getCntnau(): Retorna datos de Mayor Auxiliar.          *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar              *
      *     peNrma   ( input  ) Número de Mayor Auxiliar              *
      *     peDsNa   ( output ) Estructura de Cntnau                  *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCntnau...
     P                 b                   export
     D SVPTAB_getCntnau...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peDsNa                            likeds( dsCntnau_t )

     D   k1ynau        ds                  likerec( c1tnau01 : *key   )
     D   @@DsINa       ds                  likerec( c1tnau01 : *input )

      /free

       SVPTAB_inz();

       clear peDsNa;

       k1ynau.naEmpr = peEmpr;
       k1ynau.naSucu = peSucu;
       k1ynau.naComa = peComa;
       k1ynau.naNrma = peNrma;
       chain %kds( k1ynau : 4 ) cntnau01 @@DsINa;
       if %found( cntnau01 );
         eval-corr peDsNa = @@DsINa;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getCntnau...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_chkAgente(): Chequea si existe Agente en el archivo   *
      *                     SEHINT.-                                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peInta   (input)   Tipo de Agente                        *
      *     peInna   (input)   Nro de Agente                         *
      *                                                              *
      * Retorna: *on Encontro / *off No encontro                     *
      * ------------------------------------------------------------ *
     P SVPTAB_chkAgente...
     P                 B                   export
     D SVPTAB_chkAgente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peInta                       1  0 const
     D   peInna                       5  0 const

     D   k1yint        ds                  likerec( s1hint : *key )

      /free

        SVPTAB_inz();

        clear k1yint;

        k1yint.inEmpr = peEmpr;
        k1yint.inSucu = peSucu;
        k1yint.inInta = peInta;
        k1yint.inInna = peInna;
        chain %kds( k1yint : 4 ) sehint;
        if %found( sehint );
          return *on;
        endif;

        return *off;

      /end-free
     P SVPTAB_chkAgente...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_chkCntcfp02(): chequea datos de Forma de Pago.         *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peMar1   ( input  ) Código Equivalente                    *
      *     peIvcv   ( input  ) Código del valor                      *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_chkCntcfp02...
     P                 b                   export
     D SVPTAB_chkCntcfp02...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peMar1                       1    const
     D   peIvcv                       2  0 const

     D   k1yp01        ds                  likerec( c1tcfp01 : *key   )

      /free

       SVPTAB_inz();

       k1yp01.fpEmpr = peEmpr;
       k1yp01.fpSucu = peSucu;
       k1yp01.fpMar1 = peMar1;
       k1yp01.fpIvcv = peIvcv;
       chain %kds( k1yp01 : 4 ) cntcfp02;
       if %found( cntcfp02 );
         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_chkCntcfp02...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPTAB_getTipoDePersona(): Retorna datos de Tipo de Persona  *
     ?*                                                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peTipe   ( input  ) Código Tipo de Persona    (opcional) *
     ?*     peDs02   ( output ) Estruct. set6202          (opcional) *
     ?*     peDs02C  ( output ) Cant. Reg. set6202        (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPTAB_getTipoDePersona...
     P                 B                   export
     D SVPTAB_getTipoDePersona...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peTipe                       1    options( *nopass : *omit )const
     D   peDs02                            likeds ( set6202_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDs02C                     10i 0 options( *nopass : *omit )

     D   k1y202        ds                  likerec( s1t6202 : *key )
     D   @@DsI02       ds                  likerec( s1t6202 : *input )
     D   @@Ds02        ds                  likeds ( set6202_t ) dim( 999 )
     D   @@Ds02C       s             10i 0

      /free

       SVPTAB_inz();

       clear @@Ds02;
       @@Ds02C = 0;

       k1y202.t@Arcd = peArcd;

       if %parms >= 2 and %addr(peTipe) <> *NULL;
         k1y202.t@Tipe = peTipe;
         setll %kds( k1y202 : 2 ) set6202;
         if not %equal( set6202 );
           return *off;
         endif;
         reade(n) %kds( k1y202 : 2 ) set6202 @@DsI02;
         dow not %eof( set6202 );
           @@Ds02C += 1;
           eval-corr @@Ds02( @@Ds02C ) = @@DsI02;
          reade(n) %kds( k1y202 : 2 ) set6202 @@DsI02;
         enddo;
       else;
         setll %kds( k1y202 : 1 ) set6202;
         if not %equal( set6202 );
           return *off;
         endif;
         reade(n) %kds( k1y202 : 1 ) set6202 @@DsI02;
         dow not %eof( set6202 );
           @@Ds02C += 1;
           eval-corr @@Ds02( @@Ds02C ) = @@DsI02;
          reade(n) %kds( k1y202 : 1 ) set6202 @@DsI02;
         enddo;
       endif;

       if %addr( peDs02 ) <> *null;
         eval-corr peDs02 = @@Ds02;
       endif;

       if %addr( peDs02C ) <> *null;
         peDs02C = @@Ds02C;
       endif;

       return *on;

      /end-free

     P SVPTAB_getTipoDePersona...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getPremioProd(): Retorna premio del producto del ar-  *
      *                         chivo SET100                         *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Producto                              *
      *     peMone   (input)   Moneda                                *
      *                                                              *
      * Retorna: t@prem                                              *
      * ------------------------------------------------------------ *
     P SVPTAB_getPremioProd...
     P                 B                   export
     D SVPTAB_getPremioProd...
     D                 pi            15  2
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peMone                       2    const

     D   k1y100        ds                  likerec( s1t100 : *key )

      /free

        SVPTAB_inz();

        k1y100.t@Rama = peRama;
        k1y100.t@Xpro = peXpro;
        k1y100.t@Mone = peMone;
        chain %kds( k1y100 : 3 ) set100;
        if %found( set100 );
          return t@prem;
        endif;

        return *zeros;

      /end-free

     P SVPTAB_getPremioProd...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_getRequiereAPRC(): Retorna si la Rama y el Producto    *
      *                           requiere AP y RC                    *
      *                                                               *
      *     peRama   ( input  ) Rama                                  *
      *     peXpro   ( input  ) Producto                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getRequiereAPRC...
     P                 b                   export
     D SVPTAB_getRequiereAPRC...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peReAP                       1
     D   peReRC                       1

     D   k1y102        ds                  likerec( s1t102 : *key   )

      /free

       SVPTAB_inz();

       k1y102.t@Rama = peRama;
       k1y102.t@Xpro = peXpro;
       chain %kds( k1y102 : 2 ) set102;
       if %found( set102 );
         peReAP = t@Mar1;
         peReRC = t@Mar2;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getRequiereAPRC...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getProvincia(): Retorna provincia                      *
      *                                                               *
      *     peRpro   ( input  ) Provincia Index                       *
      *                                                               *
      * Retorna: PRPROC                                               *
      * ------------------------------------------------------------- *
     P SVPTAB_getProvincia...
     P                 b                   export
     D SVPTAB_getProvincia...
     D                 pi             3
     D   peRpro                       2  0 const

     D   k1ypro        ds                  likerec( g1tpro01 : *key )

      /free

       SVPTAB_inz();

       k1ypro.prRpro = peRpro;
       chain %kds( k1ypro : 1 ) gntpro01;
       if %found( gntpro01 );
         return prProc;
       endif;

       return *zeros;

      /end-free

     P SVPTAB_getProvincia...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_getSet001() : Obtiene SET001                          *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peDs001  (output)  Estructura SET001                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_getSet001...
     P                 B                   export
     D SVPTAB_getSet001...
     D                 pi              n
     D   peRama                       2  0 const
     D   peDs001                           likeds ( DsSET001_t )

     D k1y001          ds                  likerec( s1t001 : *key )
     D @@Ds001         ds                  likerec( s1t001 : *input )

      /free

       SVPTAB_inz();

       clear peDs001;
       k1y001.t@rama = peRama;
       chain %kds(k1y001) set001 @@Ds001;
       if %found(set001);
         eval-corr peDs001 = @@Ds001;
         return *off;
       endif;

       return *on;

      /end-free

     P SVPTAB_getSet001...
     P                 E

