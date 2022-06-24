     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPDRV: Programa de Servicio.                                *
      *         Descuentos RV                                        *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     17-07-2015              *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      *                                                              *
      * LRG 04/01/16  * Se agrega procedimiento _getCodBuenResultado *
      * JSN 12/04/2021 - Se modifica los nombres de los Errores de   *
      *                  SVPSIN a SVPDRV                             *
      * ************************************************************ *
     Fset160    if   e           k disk    usropn prefix ( t1 : 2 )
     Fset16003  if   e           k disk    usropn prefix ( t1 : 2 )
     F                                     rename ( s1t160 : s3t160 )
     Fset252    if   e           k disk    usropn
     Fset25202  if   e           k disk    usropn rename ( s1t252 : s2t252 )
     Fset25203  if   e           k disk    usropn rename ( s1t252 : s3t252 )
     Fset253    if   e           k disk    usropn
     Fset25301  if   e           k disk    usropn rename ( s1t253 : s2t253 )

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/SVPDRV_H.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPDRV_chkDescuentoCarac(): Chequea si descuento pertenece   *
      * a la caracteristica                                          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peCcba   (input)   Codigo de Caracteristica              *
      *     peCcbp   (input)   Codigo de Descuento                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRV_chkDescuentoCarac...
     P                 B                   export
     D SVPDRV_chkDescuentoCarac...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peRama                       2  0 const
     D   peCcba                       3  0 const
     D   peCcbp                       3  0 const

     D k1y160          ds                  likerec( s1t160 : *Key )

      /free

       SVPDRV_inz();

       k1y160.t1empr = peEmpr;
       k1y160.t1sucu = peSucu;
       k1y160.t1rama = peRama;
       k1y160.t1ccba = peCcba;
       chain %kds ( k1y160 ) set160;

       if not %found ( set160 ) or ( t1ccbp <> peCcbp );
         SetError( SVPDRV_DESNC
                 : 'Descuento no pertenece a la Caracteristica' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPDRV_chkDescuentoCarac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_getDescuentoCarac(): Retornar el descuento de la carc.*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peCcba   (input)   Codigo de Caracteristica              *
      *                                                              *
      * Retorna: Codigo de Descuento                                 *
      * ------------------------------------------------------------ *

     P SVPDRV_getDescuentoCarac...
     P                 B                   export
     D SVPDRV_getDescuentoCarac...
     D                 pi             3  0
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peRama                       2  0 const
     D   peCcba                       3  0 const

     D k1y160          ds                  likerec( s1t160 : *Key )

      /free

       SVPDRV_inz();

       k1y160.t1empr = peEmpr;
       k1y160.t1sucu = peSucu;
       k1y160.t1rama = peRama;
       k1y160.t1ccba = peCcba;
       chain %kds ( k1y160 ) set160;

       if not %found ( set160 );
         SetError( SVPDRV_CARNE
                 : 'Caracteristica no Existente' );
         return -1;
       endif;

       return t1ccbp;

      /end-free

     P SVPDRV_getDescuentoCarac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_getCaracDescuento(): Retorna caracteristicas que      *
      * que tiene el descuento                                       *
      *                                                              *
      *     peCcbp   (input)   Codigo de Descuento                   *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peCcba   (input)   Codigo de Caracteristica              *
      *                                                              *
      * Retorna: Lista de Caracteristicas                            *
      * ------------------------------------------------------------ *
     P SVPDRV_getCaracDescuento...
     P                 B                   export
     D SVPDRV_getCaracDescuento...
     D                 pi              n
     D   peCcbp                       3  0 const
     D   peLcar                            likeds(carac_t) dim(99)
     D   peLcarC                     10i 0

     D k1y160          ds                  likerec( s3t160 : *Key )

      /free

       SVPDRV_inz();

       clear peLcar;
       peLcarC = *Zeros;

       k1y160.t1ccbp = peCcbp;
       setll %kds ( k1y160 : 1 ) set16003;
       reade %kds ( k1y160 : 1 ) set16003;

       dow not %eof ( set16003 );

         peLcarC += 1;

         peLcar( peLcarC ).empr = t1empr;
         peLcar( peLcarC ).sucu = t1sucu;
         peLcar( peLcarC ).rama = t1rama;
         peLcar( peLcarC ).ccba = t1ccba;
         peLcar( peLcarC ).dcba = t1dcba;
         peLcar( peLcarC ).cbae = t1cbae;
         peLcar( peLcarC ).bloq = t1bloq;
         peLcar( peLcarC ).tpcs = t1tpcs;
         peLcar( peLcarC ).tpcn = t1tpcn;
         peLcar( peLcarC ).ma01 = t1ma01;
         peLcar( peLcarC ).ma02 = t1ma02;
         peLcar( peLcarC ).ma03 = t1ma03;
         peLcar( peLcarC ).ma04 = t1ma04;
         peLcar( peLcarC ).ma05 = t1ma05;
         peLcar( peLcarC ).ma06 = t1ma06;
         peLcar( peLcarC ).ma07 = t1ma07;
         peLcar( peLcarC ).ma08 = t1ma08;
         peLcar( peLcarC ).ma09 = t1ma09;
         peLcar( peLcarC ).ma10 = t1ma10;

         reade %kds ( k1y160 : 1 ) set16003;

       enddo;

       return *On;

      /end-free

     P SVPDRV_getCaracDescuento...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_chkCoberturaDescuento(): Chequea si la cobertura es   *
      * afectada por el descuento                                    *
      *                                                              *
      *     peCcbp   (input)   Codigo de Descuento                   *
      *     peXcob   (input)   Cobertura                             *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRV_chkCoberturaDescuento...
     P                 B                   export
     D SVPDRV_chkCoberturaDescuento...
     D                 pi              n
     D   peCcbp                       3  0 const
     D   peXcob                       3  0 const
     D   peFech                       8  0 options (*Omit:*Nopass)

     D k1y252          ds                  likerec( s2t252 : *Key )
     D k1y253          ds                  likerec( s1t253 : *Key )

     D @@fech          s              8  0

      /free

       SVPDRV_inz();

       if %parms >= 3 and %addr( peFech ) <> *Null;
         @@fech = peFech;
       else;
         @@fech = *Year * 10000 + *Month * 100 + *Day;
       endif;

       k1y252.t@ccbp = peCcbp;
       setll %kds ( k1y252 : 1 ) set25202;
       reade %kds ( k1y252 : 1 ) set25202;

       dow not %eof ( set25202 );

         if ( t@mar1 = 'N' and @@fech >= t@fech );

           k1y253.t@nres = t@nres;
           setll %kds ( k1y253 : 1 ) set253;
           reade %kds ( k1y253 : 1 ) set253;

           dow not %eof ( set253 );

              if ( t@xcob = peXcob );

                return *On;

              endif;

             reade %kds ( k1y253 : 1 ) set253;

           enddo;

         endif;

         reade %kds ( k1y252 : 1 ) set25202;

       enddo;

       return *Off;

      /end-free

     P SVPDRV_chkCoberturaDescuento...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_getCoberturaDescuento(): Retorna las coberturas       *
      * afectadas por el descuento                                   *
      *                                                              *
      *     peCcbp   (input)   Codigo de Descuento                   *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peRama   (input)   Codigo de Rama                        *
      *     peXpro   (input)   Codigo de Producto                    *
      *     peLcob   (output)  Lista Cobertura                       *
      *     peLcobC  (output)  Cantidad Cobertura                    *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRV_getCoberturaDescuento...
     P                 B                   export
     D SVPDRV_getCoberturaDescuento...
     D                 pi              n
     D   peCcbp                       3  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peLdes                            likeds(cobCa_t) dim(999)
     D   peLdesC                     10i 0
     D   peFech                       8  0 options (*Omit:*Nopass)

     D k1y252          ds                  likerec( s2t252 : *Key )
     D k1y253          ds                  likerec( s1t253 : *Key )

     D @@fech          s              8  0

      /free

       SVPDRV_inz();

       if %parms >= 7 and %addr( peFech ) <> *Null;
         @@fech = peFech;
       else;
         @@fech = *Year * 10000 + *Month * 100 + *Day;
       endif;

       clear peLdes;
       peLdesC = *Zeros;

       k1y252.t@ccbp = peCcbp;
       k1y252.t@arcd = peArcd;
       k1y252.t@rama = peRama;
       k1y252.t@xpro = peXpro;
       setll %kds ( k1y252 : 4 ) set25202;
       reade %kds ( k1y252 : 4 ) set25202;

       dow not %eof ( set25202 );

         if ( t@mar1 = 'N' and @@fech >= t@fech );

           k1y253.t@nres = t@nres;
           setll %kds ( k1y253 : 1 ) set253;
           reade %kds ( k1y253 : 1 ) set253;

           dow not %eof ( set253 );

             peLdesC += 1;

             peLdes( peLdesC ).empr = t@empr;
             peLdes( peLdesC ).sucu = t@sucu;
             peLdes( peLdesC ).arcd = t@arcd;
             peLdes( peLdesC ).rama = t@rama;
             peLdes( peLdesC ).xpro = t@xpro;
             peLdes( peLdesC ).xcob = t@xcob;
             peLdes( peLdesC ).ccbp = t@ccbp;
             peLdes( peLdesC ).nive = t@nive;
             peLdes( peLdesC ).recs = t@recs;
             peLdes( peLdesC ).recn = t@recn;
             peLdes( peLdesC ).bons = t@bons;
             peLdes( peLdesC ).bonn = t@bonn;

             reade %kds ( k1y253 : 1 ) set253;

           enddo;

         endif;

         reade %kds ( k1y252 : 4 ) set25202;

       enddo;

       return *On;

      /end-free

     P SVPDRV_getCoberturaDescuento...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_getCoberturaDescuentoCab(): Retorna las coberturas    *
      * afectadas por el descuento. Filtro para Arcd/Rama/Xpro       *
      *                                                              *
      *     peCcbp   (input)   Codigo de Descuento                   *
      *     peArcd   (input)   Articulo                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Producto                              *
      *     peLcob   (output)  Lista Cobertura                       *
      *     peLcobC  (output)  Cantidad Cobertura                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRV_getCoberturaDescuentoCab...
     P                 B                   export
     D SVPDRV_getCoberturaDescuentoCab...
     D                 pi              n
     D   peCcbp                       3  0 const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peLdes                            likeds(cobCa_t) dim(999)
     D   peLdesC                     10i 0

     D @@Ldes          ds                  likeds(cobCa_t) dim(999)
     D @@LdesC         s             10i 0

     D x               s             10i 0

      /free

       SVPDRV_inz();

       clear peLdes;
       clear @@Ldes;

       peLdesC = *Zeros;
       @@LdesC = *Zeros;

       SVPDRV_getCoberturaDescuento ( peCcbp : peArcd : peRama
                                    : peXpro : @@Ldes : @@LdesC );

       for x = 1 to @@LdesC;

         if ( @@Ldes( x ).arcd = peArcd ) and
            ( @@Ldes( x ).rama = peRama ) and
            ( @@Ldes( x ).xpro = peXpro );

           peLdesC += 1;
           peLdes( peLdesC ) = @@Ldes( x );

         endif;

       endfor;

       return *On;

      /end-free

     P SVPDRV_getCoberturaDescuentoCab...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_getDescuentosCobertura(): Retorna los Descuentos      *
      * afectados por la cobertura                                   *
      *                                                              *
      *     peXcob   (input)   Cobertura                             *
      *     peLdes   (output)  Lista Descuentos                      *
      *     peLdesC  (output)  Cantidad Descuentos                   *
      *     peFech   (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRV_getDescuentosCobertura...
     P                 B                   export
     D SVPDRV_getDescuentosCobertura...
     D                 pi              n
     D   peXcob                       3  0 const
     D   peLdes                            likeds(cobCa_t) dim(999)
     D   peLdesC                     10i 0
     D   peFech                       8  0 options (*Omit:*Nopass)

     D k1y253          ds                  likerec( s2t253 : *Key )
     D k1y252          ds                  likerec( s3t252 : *Key )

     D @@fech          s              8  0

      /free

       SVPDRV_inz();

       if %parms >= 4 and %addr( peFech ) <> *Null;
         @@fech = peFech;
       else;
         @@fech = *Year * 10000 + *Month * 100 + *Day;
       endif;

       clear peLdes;
       peLdesC = *Zeros;

       k1y253.t@xcob = peXcob;
       setll %kds ( k1y253 : 1 ) set25301;
       reade %kds ( k1y253 : 1 ) set25301;

       dow not %eof ( set25301 );

         k1y252.t@nres = t@nres;
         setll %kds ( k1y252 : 1 ) set25203;
         reade %kds ( k1y252 : 1 ) set25203;

         if %found ( set25203 );

           if ( t@mar1 = 'N' and @@fech >= t@fech );

             peLdesC += 1;

             peLdes( peLdesC ).empr = t@empr;
             peLdes( peLdesC ).sucu = t@sucu;
             peLdes( peLdesC ).arcd = t@arcd;
             peLdes( peLdesC ).rama = t@rama;
             peLdes( peLdesC ).xpro = t@xpro;
             peLdes( peLdesC ).xcob = t@xcob;
             peLdes( peLdesC ).ccbp = t@ccbp;
             peLdes( peLdesC ).nive = t@nive;
             peLdes( peLdesC ).recs = t@recs;
             peLdes( peLdesC ).recn = t@recn;
             peLdes( peLdesC ).bons = t@bons;
             peLdes( peLdesC ).bonn = t@bonn;

           endif;

         endif;

         reade %kds ( k1y253 : 1 ) set25301;

       enddo;

       return *On;

      /end-free

     P SVPDRV_getDescuentosCobertura...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_chkDescuento(): Retorna si se realizaron Descuentos   *
      *                                                              *
      *     peNive   (input)  % por Niveles                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRV_chkDescuento...
     P                 B                   export
     D SVPDRV_chkDescuento...
     D                 pi              n
     D   peNive                            likeds(descCo_t)

      /free

       SVPDRV_inz();

       if ( peNive.niv1 <> *Zeros ) or ( peNive.niv2 <> *Zeros ) or
          ( peNive.niv3 <> *Zeros ) or ( peNive.niv4 <> *Zeros ) or
          ( peNive.niv5 <> *Zeros ) or ( peNive.niv6 <> *Zeros ) or
          ( peNive.niv7 <> *Zeros ) or ( peNive.niv8 <> *Zeros ) or
          ( peNive.niv9 <> *Zeros );

         return *On;

       endif;

       return *Off;

      /end-free

     P SVPDRV_chkDescuento...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_getDescuentosCobNiv():Retorna niveles de descuentos   *
      *                                                              *
      *     peLdes   (input)  Lista Descuentos                       *
      *     peLdec   (output) Lista de Coberturas x % Niveles        *
      *     peLdecC  (output) Cantidad de Lista                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRV_getDescuentosCobNiv...
     P                 B                   export
     D SVPDRV_getDescuentosCobNiv...
     D                 pi              n
     D   peLdes                            likeds(cobCa_t) dim(999) const
     D   peLdesC                     10i 0
     D   peLdec                            likeds(descCo_t) dim(999)
     D   peLdecC                     10i 0

     D x               s             10i 0
     D y               s             10i 0
     D z               s             10i 0

      /free

       SVPDRV_inz();

       clear peLdec;

       peLdecC = *Zeros;
       z = *Zeros;

       for x = 1 to peLdesC;

         y = SVPDRV_chkCobList ( peLdec : peLdes( x ).xcob );

         if ( y = *Zeros );

           z += 1;
           y = z;
           peLdec( y ).xcob = peLdes( x ).xcob;

         endif;

         select;

           when ( peLdes( x ).nive = 1 );
             peLdec( y ).niv1 -= peLdes( x ).bons;
             peLdec( y ).niv1 -= peLdes( x ).bonn;
             peLdec( y ).niv1 += peLdes( x ).recs;
             peLdec( y ).niv1 += peLdes( x ).recn;
           when ( peLdes( x ).nive = 2 );
             peLdec( y ).niv2 -= peLdes( x ).bons;
             peLdec( y ).niv2 -= peLdes( x ).bonn;
             peLdec( y ).niv2 += peLdes( x ).recs;
             peLdec( y ).niv2 += peLdes( x ).recn;
           when ( peLdes( x ).nive = 3 );
             peLdec( y ).niv3 -= peLdes( x ).bons;
             peLdec( y ).niv3 -= peLdes( x ).bonn;
             peLdec( y ).niv3 += peLdes( x ).recs;
             peLdec( y ).niv3 += peLdes( x ).recn;
           when ( peLdes( x ).nive = 4 );
             peLdec( y ).niv4 -= peLdes( x ).bons;
             peLdec( y ).niv4 -= peLdes( x ).bonn;
             peLdec( y ).niv4 += peLdes( x ).recs;
             peLdec( y ).niv4 += peLdes( x ).recn;
           when ( peLdes( x ).nive = 5 );
             peLdec( y ).niv5 -= peLdes( x ).bons;
             peLdec( y ).niv5 -= peLdes( x ).bonn;
             peLdec( y ).niv5 += peLdes( x ).recs;
             peLdec( y ).niv5 += peLdes( x ).recn;
           when ( peLdes( x ).nive = 6 );
             peLdec( y ).niv6 -= peLdes( x ).bons;
             peLdec( y ).niv6 -= peLdes( x ).bonn;
             peLdec( y ).niv6 += peLdes( x ).recs;
             peLdec( y ).niv6 += peLdes( x ).recn;
           when ( peLdes( x ).nive = 7 );
             peLdec( y ).niv7 -= peLdes( x ).bons;
             peLdec( y ).niv7 -= peLdes( x ).bonn;
             peLdec( y ).niv7 += peLdes( x ).recs;
             peLdec( y ).niv7 += peLdes( x ).recn;
           when ( peLdes( x ).nive = 8 );
             peLdec( y ).niv8 -= peLdes( x ).bons;
             peLdec( y ).niv8 -= peLdes( x ).bonn;
             peLdec( y ).niv8 += peLdes( x ).recs;
             peLdec( y ).niv8 += peLdes( x ).recn;
           when ( peLdes( x ).nive = 9 );
             peLdec( y ).niv9 -= peLdes( x ).bons;
             peLdec( y ).niv9 -= peLdes( x ).bonn;
             peLdec( y ).niv9 += peLdes( x ).recs;
             peLdec( y ).niv9 += peLdes( x ).recn;

         endsl;

       endfor;

       peLdecC = y;

       return peLdecC <> 0;

      /end-free

     P SVPDRV_getDescuentosCobNiv...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_chkCobList(): Retorna si Cobertura en Lista           *
      *                                                              *
      *     peLcob   (input)  Lista de Coberturas                    *
      *     peXcob   (input)  Cobertura                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRV_chkCobList...
     P                 B                   export
     D SVPDRV_chkCobList...
     D                 pi            10i 0
     D   peLcob                            likeds(descCo_t) dim(20) const
     D   peXcob                       3  0 const

     D x               s             10i 0

      /free

       SVPDRV_inz();

       for x = 1 to %elem( peLcob );

         if ( peLcob( x ).xcob ) = peXcob;
           return x;
         endif;

       endfor;

       return *Zeros;

      /end-free

     P SVPDRV_chkCobList...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDRV_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDRV_inz      B                   export
     D SVPDRV_inz      pi

      /free

       if not %open(set160);
         open set160;
       endif;

       if not %open(set16003);
         open set16003;
       endif;

       if not %open(set252);
         open set252;
       endif;

       if not %open(set25202);
         open set25202;
       endif;

       if not %open(set25203);
         open set25203;
       endif;

       if not %open(set253);
         open set253;
       endif;

       if not %open(set25301);
         open set25301;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPDRV_inz      E

      * ------------------------------------------------------------ *
      * SVPDRV_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDRV_End      B                   export
     D SVPDRV_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPDRV_End      E

      * ------------------------------------------------------------ *
      * SVPDRV_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPDRV_Error    B                   export
     D SVPDRV_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPDRV_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDRV_getListaCodBuenResultado(): Retorna Lista de Cód.     *
      *                                    de Buen Resultado         *
      *     peEmpr   (input)  Empresa                                *
      *     peSucu   (input)  Sucursal                               *
      *     peLBue   (output) Lista de Códigos                       *
      *     peLBueC  (output) Cantidad                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDRV_getCodBuenResultado...
     P                 B                   export
     D SVPDRV_getCodBuenResultado...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peLBue                       3  0 dim(10)
     D   peLBueC                     10i 0

      /free

       SVPDRV_inz();

       peLBue(1) = 997;
       peLBue(2) = 998;
       peLBue(3) = 999;
       peLBueC = 3;

       return *on;

      /end-free

     P SVPDRV_getCodBuenResultado...
     P                 E
