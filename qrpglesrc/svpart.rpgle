     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPART: Programa de servicios.                               *
      *         Administracion de Articulos                          *
      * ------------------------------------------------------------ *
      * Gomez Luis Roberto                   05-Mar-2018             *
      * ------------------------------------------------------------ *
      * ************************************************************ *
      * Modificaciones:                                              *
      * LRG 09-09-2019 : Se agregan nuevos procedimientos            *
      *                  SVPART_getArticulos                         *
      *                  SVPART_getArticulosWeb                      *
      * NWN 10-12-2019 : Se agregan nuevos procedimientos            *
      *                  SVPART_getGrupo                             *
      *                  SVPART_getParametriaWeb2                    *
      *                  SVPART_getGrupoArticulos                    *
      *                                                              *
     ?* SPV 05-12-2020 : Cambia Servicio                             *
     ?*                  SVPART_getGrupo  por SVPART_getGrupo2       *
     ?*                  por incorporacion de campo t@icon en        *
     ?*                  tabla SET639                                *
      * JSN 03-07-2020 : Se agrega el procedimiento _isMensual       *
      * NWN 08-07-2021 : Se agrega el procedimiento                  *
      *                  SVPART_getNumeroProveido.                   *
      * ************************************************************ *

     Fset620    uf a e           k disk    usropn
     Fset630    uf a e           k disk    usropn
     Fset630w   uf a e           k disk    usropn
     Fset630w01 if   e           k disk    usropn  rename( s1t630w : s1t630w01)
     Fset621    uf a e           k disk    usropn
     Fset625    uf a e           k disk    usropn
     Fset639    if   e           k disk    usropn

      *--- Variables Globales -------------------------------------- *
     D tmpfec          s               d   datfmt(*iso)

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     D Local           ds                  dtaara(*lda) qualified
     D  @@empr                        1a   overlay(Local:401)
     D  @@sucu                        2a   overlay(Local:402)

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n
     D rc              s              1n
     D hoy             s              8  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D @@empr          s              1a


      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpart_h.rpgle'

      *--- Renombrar campos ---------------------------------------- *
     Is1t630w
     I              t@date                      z@date
     Is1t639
     I              t@orde                      y@orde
     I              t@date                      y@date
     Is1t630w01
     I              t@date                      x@date

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      *                                                              *
      * SVPART_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPART_inz      B                   export
     D SVPART_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set620);
         open set620;
       endif;

       if not %open(set630);
         open set630;
       endif;

       if not %open(set630w);
         open set630w;
       endif;

       if not %open(set621);
         open set621;
       endif;

       if not %open(set625);
         open set625;
       endif;

       if not %open(set639);
         open set639;
       endif;

       if not %open(set630w01);
         open set630w01;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPART_inz      E

      * ------------------------------------------------------------ *
      * SVPART_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPART_End      B                   export
     D SVPART_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPART_End      E

      * ------------------------------------------------------------ *
      * SVPART_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPART_Error    B                   export
     D SVPART_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPART_Error    E

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
      * SVPART_chkArticulo: Verifica si el Articulo existe.-         *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_chkArticulo...
     P                 B                   export
     D SVPART_chkArticulo...
     D                 pi              n
     D   peArcd                       6  0 const

      /free

       SVPART_inz();
       setll peArcd set620;

       return %equal;

      /end-free
     P SVPART_chkArticulo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getArticulo: Retorna Informacion del Articulo.-       *
      *                                                              *
      *     peArcd   ( input  ) Articulo                             *
      *     peDsAr   ( output ) EStructura de Articulo               *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_getArticulo...
     P                 B                   export
     D SVPART_getArticulo...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peDsAr                            likeds( dsset620_t )

     D   @@DsIAr       ds                  likerec( s1t620 : *input )
      /free

       SVPART_inz();
       clear @@DsIAr;

       chain(n) peArcd set620 @@DsIAr;
       if not %found( set620 );
         return *off;
       endif;

       eval-corr peDsAr = @@DsIAr;
       return *on;

      /end-free
     P SVPART_getArticulo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_setArticulo: Graba Informacion del Articulo.-         *
      *                                                              *
      *     peDsAr   ( input )  EStructura de Articulo               *
      *                                                              *
      * Retorna: *on = Grabo / *off = No Grabo                       *
      * ------------------------------------------------------------ *
     P SVPART_setArticulo...
     P                 B                   export
     D SVPART_setArticulo...
     D                 pi              n
     D   peDsAr                            likeds( dsset620_t )

     D   @@DsIAr       ds                  likerec( s1t620 : *input )
      /free

       SVPART_inz();
       clear @@DsIAr;

       chain(n) peDsAr.t@arcd set620 @@DsIAr;
       if not %found( set620 );
         return *off;
       endif;

       eval-corr peDsAr = @@DsIAr;
       return *on;

      /end-free
     P SVPART_setArticulo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_updArticulo: Actualiza informacion del Articulo.-     *
      *                                                              *
      *     peDsAr   ( input )  Estructura de Articulo               *
      *                                                              *
      * Retorna: *on = Actualizó / *off = No Actualizó               *
      * ------------------------------------------------------------ *
     P SVPART_updArticulo...
     P                 B                   export
     D SVPART_updArticulo...
     D                 pi              n
     D   peDsAr                            likeds( dsset620_t )

     D   @@DsOAr       ds                  likerec( s1t620 : *output )

      /free

       SVPART_inz();
       clear @@DsOAr;

       chain peDsAr.t@arcd set620;
       if %found( set620 );
         eval-corr @@DsOAr = peDsAr;
         update s1t620 @@DsOar;
       else;
         return *off;
       endif;

       return *on;

      /end-free
     P SVPART_updArticulo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_delArticulo: Eliminar un Articulo.-                   *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *                                                              *
      * Retorna: *on = Si Elimino / *off = No elimino                *
      * ------------------------------------------------------------ *
     P SVPART_delArticulo...
     P                 B                   export
     D SVPART_delArticulo...
     D                 pi              n
     D   peArcd                       6  0 const

      /free

       SVPART_inz();

      *1º Se elimina ParametríaWeb...
       rc = SVPART_delParametriaWeb( peArcd );
      *2º Se elimina Parametría...
       rc = SVPART_delParametria( peArcd );
      *3º Se elimina Articulo Final...
       chain peArcd set620;
       if not %found( set620 );
         return *off;
       endif;

       delete s1t620;
       return *on;

      /end-free

     P SVPART_delArticulo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_chkParametria: Verifica si el Articulo tiene          *
      *                       parametros cargado.-                   *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_chkParametria...
     P                 B                   export
     D SVPART_chkParametria...
     D                 pi              n
     D   peArcd                       6  0 const

      /free

       SVPART_inz();
       setll peArcd set630;

       return %equal;

      /end-free
     P SVPART_chkParametria...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getParametria: Retorna Paramertia de Articulos        *
      *                                                              *
      *     peArcd   ( input  ) Articulo                             *
      *     peDsPa   ( output ) Estructura de Parametria de Articulo *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_getParametria...
     P                 B                   export
     D SVPART_getParametria...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peDsPa                            likeds( dsset630_t )

     D   @@DsIPa       ds                  likerec( s1t630 : *input )

      /free

       SVPART_inz();
       clear @@DsIPa;

       chain(n) peArcd set630 @@DsIPa;
       if not %found( set630 );
         return *off;
       endif;

       eval-corr peDsPa = @@DsIPa;
       return *on;

      /end-free
     P SVPART_getParametria...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_setParametria: Graba Parametria de Articulos.-        *
      *                                                              *
      *     peDsPa   ( input )  Estructura de Parametria de Articulos*
      *                                                              *
      * Retorna: *on = Grabó / *off = No Grabó                       *
      * ------------------------------------------------------------ *
     P SVPART_setParametria...
     P                 B                   export
     D SVPART_setParametria...
     D                 pi              n
     D   peDsPa                            likeds( dsset630_t )

     D   @@DsIPa       ds                  likerec( s1t630 : *input )
      /free

       SVPART_inz();
       clear @@DsIPa;

       chain(n) peDsPa.t@arcd set630 @@DsIPa;
       if not %found( set630 );
         return *off;
       endif;

       eval-corr peDsPa = @@DsIPa;
       return *on;

      /end-free
     P SVPART_setParametria...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_updParametria: Actualiza parametria de un Articulo    *
      *                                                              *
      *     peDsAr   ( input )  Estructura de Parametria de Articulo *
      *                                                              *
      * Retorna: *on = Actualizó / *off = No Actualizó               *
      * ------------------------------------------------------------ *
     P SVPART_updParametria...
     P                 B                   export
     D SVPART_updParametria...
     D                 pi              n
     D   peDsPa                            likeds( dsset630_t )

     D   @@DsOPa       ds                  likerec( s1t630 : *output )

      /free

       SVPART_inz();
       clear @@DsOPa;

       chain peDsPa.t@arcd set630;
       if %found( set630 );
         eval-corr @@DsOPa = peDsPa;
         update s1t630 @@DsOPa;
       else;
         return *off;
       endif;

       return *on;

      /end-free
     P SVPART_updParametria...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_delParametria: Eliminar parametria de un Articulo     *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *                                                              *
      * Retorna: *on = Si Eliminó / *off = No Eliminó                *
      * ------------------------------------------------------------ *
     P SVPART_delParametria...
     P                 B                   export
     D SVPART_delParametria...
     D                 pi              n
     D   peArcd                       6  0 const

      /free

       SVPART_inz();

       chain peArcd set630;
       if not %found( set630 );
         return *off;
       endif;

       delete s1t630;
       return *on;

      /end-free

     P SVPART_delParametria...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_chkParametriaWeb:Verifica si el Articulo tiene        *
      *                         parametros WEB cargado.-             *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_chkParametriaWeb...
     P                 B                   export
     D SVPART_chkParametriaWeb...
     D                 pi              n
     D   peArcd                       6  0 const

      /free

       SVPART_inz();

       setgt     peArcd set630w;
       readpe(n) peArcd set630w;
       dow not %eof;
           if t@fech <= %dec(%date());
              if t@mp01 = 'S';
                 return *on;
               else;
                 return *off;
              endif;
           endif;
        readpe peArcd set630w;
       enddo;

       return *off;

      /end-free
     P SVPART_chkParametriaWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getParametriaWeb: Retorna Paramertia de Articulos WEB *
      * "DEPRECATED" Se debe utilizar SVPART_getParametriaWeb2()     *
      *                                                              *
      *     peArcd   ( input  ) Articulo                             *
      *     peDsPw   ( output ) Estructura de Parametria de Articulo *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_getParametriaWeb...
     P                 B                   export
     D SVPART_getParametriaWeb...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peDsPw                            likeds( dsset630w_t )

     D   @@DsIPw       ds                  likerec( s1t630w : *input )
     D   p1Dspw        ds                  likeds( dsset630w2_t )
     D   rc            s              1n

      /free

       SVPART_inz();

       clear peDspw;

       rc = SVPART_getParametriaWeb2(peArcd:p1Dspw);
       eval-corr peDspw = p1Dspw;

       return *on;

      /end-free
     P SVPART_getParametriaWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_setParametriaWeb: Graba Parametria de Articulos WEB.- *
      *                                                              *
      *     peDsPw   ( input )  Estructura de Parametria de Articulos*
      *                                                              *
      * Retorna: *on = Grabó / *off = No Grabó                       *
      * ------------------------------------------------------------ *
     P SVPART_setParametriaWeb...
     P                 B                   export
     D SVPART_setParametriaWeb...
     D                 pi              n
     D   peDsPw                            likeds( dsset630w_t )

     D   @@DsIPw       ds                  likerec( s1t630w : *input )
      /free

       SVPART_inz();
       clear @@DsIPw;

       chain(n) peDsPw.t@arcd set630w @@DsIPw;
       if not %found( set630w );
         return *off;
       endif;

       eval-corr peDsPw = @@DsIPw;
       return *on;

      /end-free

     P SVPART_setParametriaWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_updParametriaWeb: Actualiza parametria de un Articulo *
      *                          Web                                 *
      *     peDsPw   ( input )  Estructura de Parametria de Articulo *
      *                                                              *
      * Retorna: *on = Actualizó / *off = No Actualizó               *
      * ------------------------------------------------------------ *
     P SVPART_updParametriaWeb...
     P                 B                   export
     D SVPART_updParametriaWeb...
     D                 pi              n
     D   peDsPw                            likeds( dsset630w_t )

     D   @@DsOPw       ds                  likerec( s1t630w : *output )

      /free

       SVPART_inz();
       clear @@DsOPw;

       chain peDsPw.t@arcd set630w;
       if %found( set630w );
         eval-corr @@DsOPw = peDsPw;
         update s1t630w @@DsOPw;
       else;
         return *off;
       endif;

       return *on;

      /end-free
     P SVPART_updParametriaWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_delParametriaWeb: Eliminar parametria de un Articulo  *
      *                          Web                                 *
      *     peArcd   (input)   Articulo                              *
      *                                                              *
      * Retorna: *on = Si Eliminó / *off = No Eliminó                *
      * ------------------------------------------------------------ *
     P SVPART_delParametriaWeb...
     P                 B                   export
     D SVPART_delParametriaWeb...
     D                 pi              n
     D   peArcd                       6  0 const

      /free

       SVPART_inz();

       chain peArcd set630w;
       if not %found( set630w );
         return *off;
       endif;

       delete s1t630w;
       return *on;

      /end-free

     P SVPART_delParametriaWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_chkBloqueo: Verificar si el Articulo se encuentra     *
      *                    bloqueado.-                               *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *                                                              *
      * Retorna: *on = Bloqueado / *off = No Bloqueado               *
      * ------------------------------------------------------------ *
     P SVPART_chkBloqueo...
     P                 B                   export
     D SVPART_chkBloqueo...
     D                 pi              n
     D   peArcd                       6  0 const

     D   @@DsAr        ds                  likeds( dsset620_t )

      /free

       SVPART_inz();

       if not SVPART_getArticulo( peArcd : @@DsAr );

         return *off;

       endif;

       if @@DsAr.t@bloq = '1';
         return *on;
       endif;

       return *off;

      /end-free
     P SVPART_chkBloqueo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_chkArticuloRama : Verifica si el Articulo existe.-    *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_chkArticuloRama...
     P                 B                   export
     D SVPART_chkArticuloRama...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const

     D   k1y621        ds                  likerec( s1t621 : *key )

      /free

       SVPART_inz();
       setll peArcd set621;

       return %equal;

      /end-free
     P SVPART_chkArticuloRama...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getArticuloRama: Retorna Informacion del Articulo.-   *
      *                         y sus ramas.                         *
      *     peArcd   ( input  ) Articulo                             *
      *     peDsAr   ( output ) Estructura de Articulo y ramas       *
      *     peDsArC  ( output ) Canidad de Articulos Ramas           *
      *     peRama   ( input  ) Rama   ( opcional )                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_getArticuloRama...
     P                 B                   export
     D SVPART_getArticuloRama...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peDsAr                            likeds( dsset621_t ) dim( 2 )
     D   peDsArC                     10i 0
     D   peRama                       6  0 options( *nopass : *omit )

     D   @@DsIAr       ds                  likerec( s1t621 : *input )
     D   k1y621        ds                  likerec( s1t621 : *key   )

      /free

       SVPART_inz();
       clear @@DsIAr;
       clear peDsAr;
       clear peDsArC;

       if %parms >= 2 and %addr( peRama ) <> *NULL;
          k1y621.t@arcd = peArcd;
          k1y621.t@rama = peRama;
          setll %kds( k1y621 : 2 ) set621;
          if not %equal( set621 );
            return *off;
          endif;
          reade(n) %kds( k1y621 : 2 ) set621 @@DsIAr;
       else;
          setll peArcd set621;
          if not %equal( set621 );
            return *off;
          endif;
          reade(n) peArcd set621 @@DsIAr;
       endif;
       dow not %eof( set621 );
         peDsArC += 1;
         eval-corr peDsAr( peDsArC ) = @@DsIAr;
        reade(n) peArcd set621 @@DsIAr;
       enddo;

       return *on;

      /end-free
     P SVPART_getArticuloRama...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getArticulos: Retorna todos los Articulos             *
      *                                                              *
      *     peDsAr  ( output ) Estructura de Artículos               *
      *     peDsArC ( output ) Cantidad de Artículos                 *
      *     peArcd  ( input  ) Código de Articulo     ( opcional )   *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPART_getArticulos...
     P                 B                   Export
     D SVPART_getArticulos...
     D                 pi              n
     D   peDsAr                            likeds( dsset620_t ) dim( 9999 )
     D   peDsArC                     10i 0
     D   peArcd                       6  0 options( *nopass : *omit )

     D   @@DsIAr       ds                  likerec( s1t620 : *input )

      /free
       SVPART_inz();
       clear peDsAr;
       clear peDsArC;
       if %parms >= 2 and %addr( peArcd ) <> *NULL;
         if not SVPART_getArticulo( peArcd : peDsAr(1) );
           return *off;
         else;
           peDsArC = 1;
         endif;
       else;
         setll *loval set620;
         read(n) set620 @@DsIAr;
         if %eof( set620 );
           return *off;
         endif;
         dow not %eof( set620 );
           peDsArC += 1;
           eval-corr peDsAr( peDsArC ) = @@DsIAr;
          read(n) set620 @@DsIAr;
         enddo;
       endif;

       return *on;

      /end-free
     P SVPART_getArticulos...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getArticulosWeb: Retorna todos los Articulos          *
      *                                                              *
      *     peDsAr  ( output ) Estructura de Artículos               *
      *     peDsArC ( output ) Cantidad de Artículos                 *
      *     peArcd  ( input  ) Código de Articulo     ( opcional )   *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPART_getArticulosWeb...
     P                 B                   Export
     D SVPART_getArticulosWeb...
     D                 pi              n
     D   peDsAr                            likeds( dsset620_t ) dim(9999)
     D   peDsArC                     10i 0
     D   peArcd                       6  0 options( *nopass : *omit )

     D   @@DsIAr       ds                  likerec( s1t620 : *input )

      /free
       SVPART_inz();
       clear peDsAr;
       clear peDsArC;
       if %parms >= 2 and %addr( peArcd ) <> *NULL;
         if SVPART_chkParametriaWeb( peArcd);
           if not SVPART_getArticulo( peArcd : peDsAr(1) );
             return *off;
           else;
             peDsArC = 1;
           endif;
         else;
           return *off;
         endif;
       else;
         setll *loval set620;
         read(n) set620 @@DsIAr;
         if %eof( set620 );
           return *off;
         endif;
         dow not %eof( set620 );
           if SVPART_chkParametriaWeb( @@DsIAr.t@arcd );
             peDsArC += 1;
             eval-corr peDsAr( peDsArC ) = @@DsIAr;
           endif;
          read(n) set620 @@DsIAr;
         enddo;
       endif;

       return *on;

      /end-free
     P SVPART_getArticulosWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_chkScoring : Valida código Articulo maneja  Scoring.  *
      *                                                              *
      *     peArcd   (input)   Código de Articulo                    *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Cant. de Rama/Articulo                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPART_chkScoring...
     P                 B                   export
     D SVPART_chkScoring...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D   k1y625        ds                  likerec( s1t625 : *key )

      /free

       SVPART_inz();

       k1y625.t@arcd = peArcd;
       k1y625.t@rama = peRama;
       k1y625.t@arse = peArse;

       chain(n) %kds( k1y625 : 3 ) set625;
       if %found(set625);
         if t@mar4 = '1';
           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SVPART_chkScoring...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SVPART_getGrupo: Retorna Información del Grupo de Artículos  *
     ?*                                                              *
     ?*  DEPRECATED: Utilizar SVPART_getGrupo2().                    *
     ?*                                                              *
     ?*     peGarc   ( input  ) Articulo                             *
     ?*     peDsAr   ( output ) Estructura de Grupo de Artículo      *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPART_getGrupo...
     P                 B                   export
     D SVPART_getGrupo...
     D                 pi              n
     D   peGarc                       6  0 const
     D   peDsAr                            likeds( dsset639_t )

     D   @@DsIAr       ds                  likerec( s1t639 : *input )
     D @@DsAr          ds                  likeds(dsset639_t1)

      /free

       SVPART_getGrupo2( peGarc : @@DsAr );
       eval-corr peDsAr = @@DsAr;

       return *on;

      /end-free
     P SVPART_getGrupo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getParametriaWeb2: Retorna Paramertia de Articulos WEB*
      *                                                              *
      *     peArcd   ( input  ) Articulo                             *
      *     p1DsPw   ( output ) Estructura de Parametria de Articulo *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_getParametriaWeb2...
     P                 B                   export
     D SVPART_getParametriaWeb2...
     D                 pi              n
     D   peArcd                       6  0 const
     D   p1DsPw                            likeds( dsset630w2_t )

     D   @1DsIPw       ds                  likerec( s1t630w : *input )

      /free

       SVPART_inz();

       clear @1DsIPw;

       setgt     peArcd set630w;
       readpe(n) peArcd set630w @1DsIPw;
       dow not %eof;
         eval-corr p1DsPw = @1DsIPw;
         return *on;
       enddo;

       return *off;

      /end-free
     P SVPART_getParametriaWeb2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getGrupoArticulos: Retorna los Artículos de un        *
      *                           Grupo Determinado.                 *
      *                                                              *
      *     peGarc   ( input  ) Grupo                                *
      *     p@DsPw   ( output ) Estructura de Parametria de Articulos*
      *     p@DsPwC  ( output ) Contador de Articulos                *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPART_getGrupoArticulos...
     P                 B                   export
     D SVPART_getGrupoArticulos...
     D                 pi              n
     D   peGarc                       6  0 const
     D   p1DsPw                            likeds( dsset630w2_t ) dim(9999)
     D   p1DsPwC                     10i 0

     D   @1DsIpw       ds                  likerec(s1t630w01:*input)
     D   i             s              4  0
     D   @secu         s                   like(t@secu)
     D   @arcd         s                   like(t@arcd)
     D   nosigo        s                   like(*in50)

      /free

       SVPART_inz();

       clear @1DsIpw;
       clear p1DsPwC;
       clear hoy;

       PAR310X3( @@empr : peFema : peFemm: peFemd );
       hoy = (peFema * 10000) + (peFemm * 100) + peFemd;

       i = *zeros;
       @secu = *zeros;
       setll    peGarc set630w01;
       reade(n) peGarc set630w01 @1DsIpw;
       dow not %eof(set630w01);

         eval @arcd = @1DsIpw.t@arcd;
        Select;
        when @1DsIpw.t@mp01 = 'S' and hoy >= @1DsIpw.t@fech;
         if nosigo = *off;
          @secu =+1;
          i = i+1;
          eval-corr p1DsPw(i) = @1DsIpw ;
          p1DsPwC += 1;
         endif;
        when @1DsIpw.t@mp01 = 'N' and hoy <= @1DsIpw.t@fech;
         if nosigo = *off;
          @secu =+1;
          i = i+1;
          eval-corr p1DsPw(i) = @1DsIpw ;
          p1DsPwC += 1;
         endif;
        endsl;

       reade(n) peGarc set630w01 @1DsIpw;

         if @arcd <> @1DsIpw.t@arcd or @secu >1;
           eval nosigo = *off;
           @secu = 0;
          else;
           eval nosigo = *on;
           @secu = 1;
         Endif;

       enddo;

       if i=0;
         return *off;
        else;
         return *on;
       endif;

      /end-free
     P SVPART_getGrupoArticulos...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SVPART_getGrupo2: Retorna Información del Grupo de Artículos *
     ?*                                                              *
     ?*     peGarc   ( input  ) Articulo                             *
     ?*     peDsAr   ( output ) Estructura de Grupo de Artículo      *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPART_getGrupo2...
     P                 B                   export
     D SVPART_getGrupo2...
     D                 pi              n
     D   peGarc                       6  0 const
     D   peDsAr                            likeds( dsset639_t1)

     D   @@DsIAr       ds                  likerec( s1t639 : *input )

      /free

       SVPART_inz();
       clear @@DsIAr;

       chain(n) peGarc set639 @@DsIAr;
       if not %found( set639 );
         return *off;
       endif;

       eval-corr peDsAr = @@DsIAr;
       return *on;

      /end-free
     P SVPART_getGrupo2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getExt625 : Retorna información de extension de       *
      *                    un artículo. Archivo set625               *
      *                                                              *
      *     peArcd  ( input  ) Articulo                              *
      *     peRama  ( input  ) Rama                    ( opcional )  *
      *     peArse  ( input  ) Cant. Polizas           ( opcional )  *
      *     peDsAr  ( output ) Estructura de Artículos ( opcional )  *
      *     peDsArC ( output ) Cantidad de Artículos   ( opcional )  *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPART_getExt625...
     P                 B                   Export
     D SVPART_getExt625...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peDs625                           likeds( dsset625_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDs625C                    10i 0 options( *nopass : *omit )

     D   k1y625        ds                  likerec( s1t625 : *key   )
     D   @@DsIAr       ds                  likerec( s1t625 : *input )

      /free

       SVPART_inz();
       clear peDs625;
       clear peDs625C;

       if not SVPART_chkArticulo( peArcd );
         return *off;
       endif;

       if not SVPART_chkArticuloRama( peArcd : peRama );
         return *off;
       endif;

       k1y625.t@arcd = peArcd;
       select;
         when %parms >= 2 and %addr( peRama ) <> *NULL
                          and %addr( peArse ) <> *NULL;
           k1y625.t@rama = peRama;
           k1y625.t@arse = peArse;
           setll   %kds(k1y625 : 3 ) set625;
           reade(n) %kds(k1y625 : 3 ) set625 @@DsIAr;
           if %eof( set625 );
             return *off;
           endif;
           dow not %eof( set625 );
             peDs625C += 1;
             eval-corr peDs625( peDs625C ) = @@DsIAr;
            reade(n) %kds(k1y625 : 3 ) set625 @@DsIAr;
           enddo;

         when %parms >= 2 and %addr( peRama ) <> *NULL
                          and %addr( peArse ) =  *NULL;
           k1y625.t@rama = peRama;
           setll   %kds( k1y625 : 2 ) set625;
           reade(n) %kds( k1y625 : 2 ) set625 @@DsIAr;
           if %eof( set625 );
             return *off;
           endif;
           dow not %eof( set625 );
             peDs625C += 1;
             eval-corr peDs625( peDs625C ) = @@DsIAr;
            reade(n) %kds( k1y625 : 2 ) set625 @@DsIAr;
           enddo;

         other;
           setll %kds( k1y625 : 1 ) set625;
           reade(n) %kds( k1y625 : 1 ) set625 @@DsIAr;
           if %eof( set625 );
             return *off;
           endif;
           dow not %eof( set625 );
             peDs625C += 1;
             eval-corr peDs625( peDs625C ) = @@DsIAr;
            reade(n) %kds( k1y625 : 1 ) set625 @@DsIAr;
           enddo;
       endsl;

       return *on;

      /end-free
     P SVPART_getExt625...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_isMensual : Retorna si es mensual el artículo.        *
      *                                                              *
      *     peArcd  ( input  ) Articulo                              *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPART_isMensual...
     P                 B                   Export
     D SVPART_isMensual...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const

     D   x             s             10i 0
     D   @@DsAr        ds                  likeds( dsSet621_t ) dim(2)
     D   @@DsArC       s             10i 0

      /free

       SVPART_inz();

       clear @@DsAr;

       if SVPART_getArticuloRama( peArcd
                                : @@DsAr
                                : @@DsArC
                                : *omit   );

         for x = 1 to @@DsArC;

           if @@DsAr(x).t@Rama = peRama and @@DsAr(x).t@Dupe = 1;
             return *on;
           endif;

         endfor;
       endif;

       return *off;

      /end-free

     P SVPART_isMensual...
     P                 E

      * ------------------------------------------------------------ *
      * SVPART_getNumeroProveido : Retorna Numero Proveido           *
      *                                                              *
      *     peArcd  ( input  ) Articulo                              *
      *     peRama  ( input  ) Rama                                  *
      *     peArse  ( input  ) Cant. Polizas                         *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPART_getNumeroProveido...
     P                 B                   Export
     D SVPART_getNumeroProveido...
     D                 pi             9  0
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D   k1y621        ds                  likerec( s1t621 : *key   )

      /free

       SVPART_inz();

       if not SVPART_chkArticulo( peArcd );
         return *zeros;
       endif;

       if not SVPART_chkArticuloRama( peArcd : peRama );
         return *zeros;
       endif;

       k1y621.t@arcd = peArcd;
       k1y621.t@rama = peRama;
       k1y621.t@arse = peArse;
       chain %kds(k1y621) set621;
        if %found( set621 );
           return t@prov;
          else;
           return *zeros;
        endif;

      /end-free
     P SVPART_getNumeroProveido...
     P                 E

