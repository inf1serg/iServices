     H nomain
      * ************************************************************ *
      * SVPRIV: Programa de Servicio.                                *
      *         Riesgos Varios                                       *
      * ------------------------------------------------------------ *
      * Gomez Luis R.                     ** 16-abr-2018 **          *
      * ************************************************************ *
      * Modificaciones:                                              *
      * GIO 24-06-2019 El derecho de emisión por endosos y por rama  *
      *                se toma del SET122 -> SVPEMI_getImpuetosPorc  *
      * SGF 24-03-2020 Agrego PAHERA y consulta de Mascotas.         *
      * LRG 14-07-2020: Nuevo procedimiento _chkCoBajaCobertura      *
      *                                                              *
      * VCM 03-03-2022 Se agrean los nuevos procedimientos:          *
      *                _getUltimoEstadoComponente                    *
      *                _getCtwer2                                    *
      *                _updCtwer2                                    *
      *                                                              *
      * ************************************************************ *
     Fpaher0    uf a e           k disk    usropn
     Fpaher001  if   e           k disk    usropn
     Fpaher1    uf a e           k disk    usropn
     Fpaher1b   uf a e           k disk    usropn
     Fpaher2    uf a e           k disk    usropn
     Fpaher201  if   e           k disk    usropn
     Fpaher3    uf a e           k disk    usropn
     Fpaher4    uf a e           k disk    usropn
     Fpaher5    uf a e           k disk    usropn
     Fpaher6    uf a e           k disk    usropn
     Fpaher7    uf a e           k disk    usropn
     Fpaher8    uf a e           k disk    usropn
     Fpaher9    uf a e           k disk    usropn
     Fpaher02   uf a e           k disk    usropn
     Fpaher92   uf a e           k disk    usropn
     Fset697    if   e           k disk    usropn
     Fgntloc    if   e           k disk    usropn
     Fgntpro    if   e           k disk    usropn
     Fset1031   if   e           k disk    usropn
     Fpahera    if   e           k disk    usropn
     Fpaher002  if   e           k disk    usropn
     Fctwer2    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpriv_h.rpgle'

      * ------------------------------------------------------------ *
      * Setea error global
      * --------------------------------------------------- *
     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

      *--- Definicion de Procedimiento ----------------------------- *
     ?* ------------------------------------------------------------ *
     ?* SVPRIV_inz(): Inicializa módulo.                             *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPRIV_inz      B                   export
     D SVPRIV_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(paher0);
         open paher0;
       endif;

       if not %open(paher001);
         open paher001;
       endif;

       if not %open(paher1);
         open paher1;
       endif;

       if not %open(paher1b);
         open paher1b;
       endif;

       if not %open(paher2);
         open paher2;
       endif;

       if not %open(paher201);
         open paher201;
       endif;

       if not %open(paher3);
         open paher3;
       endif;

       if not %open(paher4);
         open paher4;
       endif;

       if not %open(paher5);
         open paher5;
       endif;

       if not %open(paher6);
         open paher6;
       endif;

       if not %open(paher7);
         open paher7;
       endif;

       if not %open(paher8);
         open paher8;
       endif;

       if not %open(paher9);
         open paher9;
       endif;

       if not %open( set697 );
          open set697;
       endif;

       if not %open( gntloc );
          open gntloc;
       endif;

       if not %open( gntpro );
          open gntpro;
       endif;

       if not %open( paher02 );
          open paher02;
       endif;

       if not %open( paher92 );
          open paher92;
       endif;

       if not %open( set1031 );
          open set1031;
       endif;

       if not %open( pahera );
          open pahera;
       endif;

       if not %open( paher002 );
          open paher002;
       endif;

       if not %open( ctwer2 );
          open ctwer2;
       endif;

       initialized = *ON;

       return;

      /end-free

     P SVPRIV_inz      E

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_End(): Finaliza módulo.                               *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPRIV_End      B                   export
     D SVPRIV_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPRIV_End      E

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_Error(): Retorna el último error del service program  *
     ?*                                                              *
     ?*     peEnbr   (output)  Número de error (opcional)            *
     ?*                                                              *
     ?* Retorna: Mensaje de error.                                   *
     ?* ------------------------------------------------------------ *

     P SVPRIV_Error    B                   export
     D SVPRIV_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPRIV_Error    E

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkSuplemento  : Validar Suplementos                  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe /  *off = No existe                 *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkSuplemento...
     P                 b                   export
     D SVPRIV_chkSuplemento...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     D   k1yer0        ds                  likerec( p1her0 : *key   )

      /free

       SVPRIV_inz();

       k1yer0.r0Empr = peEmpr;
       k1yer0.r0Sucu = peSucu;
       k1yer0.r0Arcd = peArcd;
       k1yer0.r0Spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                k1yer0.r0Arse = peArse;
                k1yer0.r0Oper = peOper;
                k1yer0.r0Poco = pePoco;
                k1yer0.r0Suop = peSuop;
                setll %kds( k1yer0 : 10 ) paher0;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                k1yer0.r0Arse = peArse;
                k1yer0.r0Oper = peOper;
                k1yer0.r0Poco = pePoco;
                setll %kds( k1yer0 : 9 ) paher0;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                k1yer0.r0Arse = peArse;
                k1yer0.r0Oper = peOper;
                setll %kds( k1yer0 : 8 ) paher0;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                k1yer0.r0Arse = peArse;
                setll %kds( k1yer0 : 7 ) paher0;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                setll %kds( k1yer0 : 6 ) paher0;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer0.r0Sspo = peSspo;
                setll %kds( k1yer0 : 5 ) paher0;
         other;

           setll %kds( k1yer0 : 4 ) paher0;
         endsl;
       else;

         setll %kds( k1yer0 : 4 ) paher0;
       endif;

       return %equal();

      /end-free

     P SVPRIV_chkSuplemento...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getSuplementos : Retorna Suplementos                  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peDsR0   ( output ) Estructura Riesgos Varios (opcional) *
     ?*     peDsR0C  ( output ) Cantidad de Riesgos       (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getSuplementos...
     P                 b                   export
     D SVPRIV_getSuplementos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsR0                            likeds ( dsPaher0_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR0C                     10i 0 options( *nopass : *omit )

     D   k1yer0        ds                  likerec( p1her0   : *key   )
     D   @@DsIR0       ds                  likerec( p1her0   : *input )
     D   k1yer001      ds                  likerec( p1her001 : *key   )
     D   @@DsIR001     ds                  likerec( p1her001 : *input )
     D   @@DsR0        ds                  likeds ( dsPaher0_t ) dim( 999 )
     D   @@DsR0C       s             10i 0

      /free

       SVPRIV_inz();

       clear @@DsR0;
       clear @@DsR0C;

       k1yer0.r0empr = peEmpr;
       k1yer0.r0sucu = peSucu;
       k1yer0.r0arcd = peArcd;
       k1yer0.r0spol = peSpol;

       k1yer001.r0empr = peEmpr;
       k1yer001.r0sucu = peSucu;
       k1yer001.r0arcd = peArcd;
       k1yer001.r0spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peEmpr ) <> *null and
                %addr( peSucu ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) <> *null;

                k1yer001.r0Sspo = peSspo;
                k1yer001.r0Rama = peRama;
                k1yer001.r0Arse = peArse;
                k1yer001.r0Oper = peOper;
                k1yer001.r0Suop = peSuop;
                setll %kds( k1yer001 : 9 ) paher001;
                if not %equal( paher001 );
                  return %equal();
                endif;
                reade %kds( k1yer001 : 9 ) paher001 @@DsIR001;
                dow not %eof( paher001 );
                  @@DsR0C += 1;
                  eval-corr @@DsR0( @@DsR0C ) = @@DsIR001;
                 reade %kds( k1yer001 : 9 ) paher001 @@DsIR001;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                k1yer0.r0Arse = peArse;
                k1yer0.r0Oper = peOper;
                k1yer0.r0Poco = pePoco;
                k1yer0.r0Suop = peSuop;
                setll %kds( k1yer0 : 10 ) paher0;
                if not %equal( paher0 );
                  return %equal();
                endif;
                reade %kds( k1yer0 : 10 ) paher0 @@DsIR0;
                dow not %eof( paher0 );
                  @@DsR0C += 1;
                  eval-corr @@DsR0( @@DsR0C ) = @@DsIR0;
                 reade %kds( k1yer0 : 10 ) paher0 @@DsIR0;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) = *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                k1yer0.r0Arse = peArse;
                k1yer0.r0Oper = peOper;
                k1yer0.r0Poco = pePoco;
                setll %kds( k1yer0 : 9 ) paher0;
                if not %equal( paher0 );
                  return %equal();
                endif;
                reade %kds( k1yer0 : 9 ) paher0 @@DsIR0;
                dow not %eof( paher0 );
                  @@DsR0C += 1;
                  eval-corr @@DsR0( @@DsR0C ) = @@DsIR0;
                 reade %kds( k1yer0 : 9 ) paher0 @@DsIR0;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                k1yer0.r0Arse = peArse;
                k1yer0.r0Oper = peOper;
                setll %kds( k1yer0 : 8 ) paher0;
                if not %equal( paher0 );
                  return %equal();
                endif;
                reade %kds( k1yer0 : 8 ) paher0 @@DsIR0;
                dow not %eof( paher0 );
                  @@DsR0C += 1;
                  eval-corr @@DsR0( @@DsR0C ) = @@DsIR0;
                 reade %kds( k1yer0 : 8 ) paher0 @@DsIR0;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                k1yer0.r0Arse = peArse;
                setll %kds( k1yer0 : 7 ) paher0;
                if not %equal( paher0 );
                  return %equal();
                endif;
                reade %kds( k1yer0 : 7 ) paher0 @@DsIR0;
                dow not %eof( paher0 );
                  @@DsR0C += 1;
                  eval-corr @@DsR0( @@DsR0C ) = @@DsIR0;
                 reade %kds( k1yer0 : 8 ) paher0 @@DsIR0;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer0.r0Sspo = peSspo;
                k1yer0.r0Rama = peRama;
                setll %kds( k1yer0 : 6 ) paher0;
                if not %equal( paher0 );
                  return %equal();
                endif;
                reade %kds( k1yer0 : 6 ) paher0 @@DsIR0;
                dow not %eof( paher0 );
                  @@DsR0C += 1;
                  eval-corr @@DsR0( @@DsR0C ) = @@DsIR0;
                 reade %kds( k1yer0 : 6 ) paher0 @@DsIR0;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer0.r0Sspo = peSspo;
                setll %kds( k1yer0 : 5 ) paher0;
                if not %equal( paher0 );
                  return %equal();
                endif;
                reade %kds( k1yer0 : 5 ) paher0 @@DsIR0;
                dow not %eof( paher0 );
                  @@DsR0C += 1;
                  eval-corr @@DsR0( @@DsR0C ) = @@DsIR0;
                 reade %kds( k1yer0 : 5 ) paher0 @@DsIR0;
                enddo;
         other;

           setll %kds( k1yer0 : 4 ) paher0;
           if not %equal( paher0 );
             return %equal();
           endif;
           reade %kds( k1yer0 : 4 ) paher0 @@DsIR0;
             dow not %eof( paher0 );
                @@DsR0C += 1;
                eval-corr @@DsR0( @@DsR0C ) = @@DsIR0;
              reade %kds( k1yer0 : 4 ) paher0 @@DsIR0;
             enddo;
         endsl;
       else;

         setll %kds( k1yer0 : 4 ) paher0;
         if not %equal( paher0 );
           return %equal();
         endif;
         reade %kds( k1yer0 : 4 ) paher0 @@DsIR0;
           dow not %eof( paher0 );
             @@DsR0C += 1;
             eval-corr @@DsR0( @@DsR0C ) = @@DsIR0;
           reade %kds( k1yer0 : 4 ) paher0 @@DsIR0;
           enddo;
       endif;

       if %addr(peDsR0) <> *null;
         eval-corr peDsR0 = @@DsR0;
       endif;

       if %addr(peDsR0C) <> *null;
         peDsR0C = @@DsR0C;
       endif;

       return *on;

      /end-free

     P SVPRIV_getSuplementos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setSuplemento  : Grabar Suplementos                   *
     ?*                                                              *
     ?*     peDsR0   ( input  ) Estructura Riesgos Varios            *
     ?*                                                              *
     ?* Retorna: *on = Si graba  / *off = No graba                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setSuplemento...
     P                 b                   export
     D SVPRIV_setSuplemento...
     D                 pi              n
     D   peDsR0                             const likeds( dsPaher0_t )

     D   @@DsOR0       ds                  likerec( p1her0 : *output )
     D   x             s             10i 0

      /free

       SVPRIV_inz();

       if SVPRIV_chkSuplemento( peDsR0.r0empr
                              : peDsR0.r0sucu
                              : peDsR0.r0arcd
                              : peDsR0.r0spol
                              : peDsR0.r0sspo
                              : peDsR0.r0rama
                              : peDsR0.r0arse
                              : peDsR0.r0oper
                              : peDsR0.r0poco
                              : peDsR0.r0suop );
         return *off;
       endif;

       eval-corr @@DsOR0 = peDsR0;
       monitor;
         write p1heR0 @@DsOR0;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_setSuplemento...
     P                 e
     ?* ------------------------------------------------------------ *
     ?* SVPRIV_updSuplemento  : Actualizar Suplemento                *
     ?*                                                              *
     ?*     peDsR0   ( input  ) Estructura Riesgos Varios            *
     ?*                                                              *
     ?* Retorna: *on = Si graba  / *off = No graba                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_updSuplemento...
     P                 b                   export
     D SVPRIV_updSuplemento...
     D                 pi              n
     D   peDsR0                             const likeds( dsPaher0_t )

     D   @@DsOR0       ds                  likerec( p1her0 : *output )
     D   k1yer0        ds                  likerec( p1her0 : *key    )
     D   x             s             10i 0

      /free

       SVPRIV_inz();

       k1yer0.r0empr = peDsR0.r0empr;
       k1yer0.r0sucu = peDsR0.r0sucu;
       k1yer0.r0arcd = peDsR0.r0arcd;
       k1yer0.r0spol = peDsR0.r0spol;
       k1yer0.r0sspo = peDsR0.r0sspo;
       k1yer0.r0rama = peDsR0.r0rama;
       k1yer0.r0arse = peDsR0.r0arse;
       k1yer0.r0oper = peDsR0.r0oper;
       k1yer0.r0poco = peDsR0.r0poco;
       k1yer0.r0suop = peDsR0.r0suop;
       chain %kds( k1yer0 : 10 ) paher0;
       if not %found( paher0 );
         return *off;
       endif;

       eval-corr @@DsOR0 = peDsR0;
       monitor;
         update p1heR0 @@DsOR0;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_updSuplemento...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltSuplemento  : Elimina Suplemento                   *
     ?*                                                              *
     ?*     peDsR0   ( input  ) Estructura Riesgos Varios            *
     ?*                                                              *
     ?* Retorna: *on = Elimina / *off = No elimina                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltSuplemento...
     P                 b                   export
     D SVPRIV_dltSuplemento...
     D                 pi              n
     D   peDsR0                            const likeds( dsPaher0_t )

     D   k1yer0        ds                  likerec( p1her0 : *key   )

       /free

        SVPRIV_inz();

        k1yer0.r0empr = peDsR0.r0empr;
        k1yer0.r0sucu = peDsR0.r0sucu;
        k1yer0.r0arcd = peDsR0.r0arcd;
        k1yer0.r0spol = peDsR0.r0spol;
        k1yer0.r0sspo = peDsR0.r0sspo;
        k1yer0.r0rama = peDsR0.r0rama;
        k1yer0.r0arse = peDsR0.r0arse;
        k1yer0.r0oper = peDsR0.r0oper;
        k1yer0.r0poco = peDsR0.r0poco;
        k1yer0.r0suop = peDsR0.r0suop;

        chain %kds( k1yer0 : 10 ) paher0;
        if %found( paher0 );
          delete p1her0;
        endif;

        return *on;

       /end-free

     P SVPRIV_dltSuplemento...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkPersona  :   Validar Personas.-                    *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peSecu   ( input  ) Secuencias                (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkPersona...
     P                 b                   export
     D SVPRIV_chkPersona...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peSecu                       2  0 options( *nopass : *omit ) const

     D   k1yer1        ds                  likerec( p1her1 : *key   )

      /free

       SVPRIV_inz();

       k1yer1.r1empr = peEmpr;
       k1yer1.r1sucu = peSucu;
       k1yer1.r1arcd = peArcd;
       k1yer1.r1spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) <> *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                k1yer1.r1suop = peSuop;
                k1yer1.r1riec = peRiec;
                k1yer1.r1xcob = peXcob;
                k1yer1.r1secu = peSecu;
                setll %kds( k1yer1 : 13 ) paher1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                k1yer1.r1suop = peSuop;
                k1yer1.r1riec = peRiec;
                k1yer1.r1xcob = peXcob;
                setll %kds( k1yer1 : 12 ) paher1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                k1yer1.r1suop = peSuop;
                k1yer1.r1riec = peRiec;
                setll %kds( k1yer1 : 11 ) paher1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                k1yer1.r1suop = peSuop;
                setll %kds( k1yer1 : 10 ) paher1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                setll %kds( k1yer1 : 9 ) paher1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                setll %kds( k1yer1 : 8 ) paher1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                setll %kds( k1yer1 : 7 ) paher1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                setll %kds( k1yer1 : 6 ) paher1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                setll %kds( k1yer1 : 5 ) paher1;

           other;

             setll %kds( k1yer1 : 4 ) paher1;
         endsl;
       else;

         setll %kds( k1yer1 : 4 ) paher1;

       endif;

       return %equal();
      /end-free

     P SVPRIV_chkPersona...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getPersonas : Retorna Personas.-                      *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peSecu   ( input  ) Secuencias                (opcional) *
     ?*     peDsR1   ( output ) Est. de Personas          (opcional) *
     ?*     peDsR1C  ( output ) Cantidad de Personas      (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getPersonas...
     P                 b                   export
     D SVPRIV_getPersonas...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peSecu                       2  0 options( *nopass : *omit ) const
     D   peDsR1                            likeds( dsPaher1_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR1C                     10i 0 options( *nopass : *omit )

     D   k1yer1        ds                  likerec( p1her1 : *key   )
     D   @@DsIR1       ds                  likerec( p1her1 : *input )
     D   @@DsR1        ds                  likeds ( dsPaher1_t ) dim( 999 )
     D   @@DsR1C       s             10i 0

      /free

       SVPRIV_inz();

       k1yer1.r1empr = peEmpr;
       k1yer1.r1sucu = peSucu;
       k1yer1.r1arcd = peArcd;
       k1yer1.r1spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) <> *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                k1yer1.r1suop = peSuop;
                k1yer1.r1riec = peRiec;
                k1yer1.r1xcob = peXcob;
                k1yer1.r1secu = peSecu;
                setll %kds( k1yer1 : 13 ) paher1;
                if not %equal( paher1 );
                  return %equal();
                endif;
                reade(n) %kds( k1yer1 : 13 ) paher1 @@DsIR1;
                dow not %eof( paher1 );
                  @@DsR1C += 1;
                  eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
                 reade(n) %kds( k1yer1 : 13 ) paher1 @@DsIR1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                k1yer1.r1suop = peSuop;
                k1yer1.r1riec = peRiec;
                k1yer1.r1xcob = peXcob;
                setll %kds( k1yer1 : 12 ) paher1;
                if not %equal( paher1 );
                  return %equal();
                endif;
                reade(n) %kds( k1yer1 : 12 ) paher1 @@DsIR1;
                dow not %eof( paher1 );
                  @@DsR1C += 1;
                  eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
                 reade(n) %kds( k1yer1 : 12 ) paher1 @@DsIR1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                k1yer1.r1suop = peSuop;
                k1yer1.r1riec = peRiec;
                setll %kds( k1yer1 : 11 ) paher1;
                if not %equal( paher1 );
                  return %equal();
                endif;
                reade(n) %kds( k1yer1 : 11 ) paher1 @@DsIR1;
                dow not %eof( paher1 );
                  @@DsR1C += 1;
                  eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
                 reade(n) %kds( k1yer1 : 11 ) paher1 @@DsIR1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                k1yer1.r1suop = peSuop;
                setll %kds( k1yer1 : 10 ) paher1;
                if not %equal( paher1 );
                  return %equal();
                endif;
                reade(n) %kds( k1yer1 : 10 ) paher1 @@DsIR1;
                dow not %eof( paher1 );
                  @@DsR1C += 1;
                  eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
                 reade(n) %kds( k1yer1 : 10 ) paher1 @@DsIR1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                k1yer1.r1poco = pePoco;
                setll %kds( k1yer1 : 9 ) paher1;
                if not %equal( paher1 );
                  return %equal();
                endif;
                reade(n) %kds( k1yer1 : 9 ) paher1 @@DsIR1;
                dow not %eof( paher1 );
                  @@DsR1C += 1;
                  eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
                 reade(n) %kds( k1yer1 : 9 ) paher1 @@DsIR1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                k1yer1.r1oper = peOper;
                setll %kds( k1yer1 : 8 ) paher1;
                if not %equal( paher1 );
                  return %equal();
                endif;
                reade(n) %kds( k1yer1 : 8 ) paher1 @@DsIR1;
                dow not %eof( paher1 );
                  @@DsR1C += 1;
                  eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
                 reade(n) %kds( k1yer1 : 8 ) paher1 @@DsIR1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                k1yer1.r1arse = peArse;
                setll %kds( k1yer1 : 7 ) paher1;
                if not %equal( paher1 );
                  return %equal();
                endif;
                reade(n) %kds( k1yer1 : 7 ) paher1 @@DsIR1;
                dow not %eof( paher1 );
                  @@DsR1C += 1;
                  eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
                 reade(n) %kds( k1yer1 : 7 ) paher1 @@DsIR1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                k1yer1.r1rama = peRama;
                setll %kds( k1yer1 : 6 ) paher1;
                if not %equal( paher1 );
                  return %equal();
                endif;
                reade(n) %kds( k1yer1 : 6 ) paher1 @@DsIR1;
                dow not %eof( paher1 );
                  @@DsR1C += 1;
                  eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
                 reade(n) %kds( k1yer1 : 6 ) paher1 @@DsIR1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                k1yer1.r1sspo = peSspo;
                setll %kds( k1yer1 : 5 ) paher1;
                if not %equal( paher1 );
                  return %equal();
                endif;
                reade(n) %kds( k1yer1 : 5 ) paher1 @@DsIR1;
                dow not %eof( paher1 );
                  @@DsR1C += 1;
                  eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
                 reade(n) %kds( k1yer1 : 5 ) paher1 @@DsIR1;
                enddo;

           other;

             setll %kds( k1yer1 : 4 ) paher1;
             if not %equal( paher1 );
               return %equal();
             endif;
             reade(n) %kds( k1yer1 : 4 ) paher1 @@DsIR1;
             dow not %eof( paher1 );
               @@DsR1C += 1;
               eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
              reade(n) %kds( k1yer1 : 4 ) paher1 @@DsIR1;
             enddo;

         endsl;
       else;

           setll %kds( k1yer1 : 4 ) paher1;
           if not %equal( paher1 );
             return %equal();
           endif;
           reade(n) %kds( k1yer1 : 4 ) paher1 @@DsIR1;
           dow not %eof( paher1 );
             @@DsR1C += 1;
             eval-corr @@DsR1( @@DsR1C ) = @@DsIR1;
             reade(n) %kds( k1yer1 : 4 ) paher1 @@DsIR1;
           enddo;

       endif;

       if %addr( peDsR1 ) <> *null;
         eval-corr peDsR1 = @@DsR1;
       endif;

       if %addr( peDsR1C ) <> *null;
         peDsR1C = @@DsR1C;
       endif;

       return *on;
      /end-free

     P SVPRIV_getPersonas...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setPersona  : Graba Personas.-                        *
     ?*                                                              *
     ?*     peDsR1   ( input  ) Est. de Personas                     *
     ?*                                                              *
     ?* Retorna: *on = Si Graba / *off = No Graba                    *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setPersona...
     P                 b                   export
     D SVPRIV_setPersona...
     D                 pi              n
     D   peDsR1                            const likeds( dsPaher1_t )

     D   @@DsOR1       ds                  likerec( p1her1 : *output )

      /free

       SVPRIV_inz();

       if SVPRIV_chkPersona( peDsR1.r1empr
                           : peDsR1.r1sucu
                           : peDsR1.r1arcd
                           : peDsR1.r1spol
                           : peDsR1.r1sspo
                           : peDsR1.r1rama
                           : peDsR1.r1arse
                           : peDsR1.r1oper
                           : peDsR1.r1poco
                           : peDsR1.r1suop
                           : peDsR1.r1riec
                           : peDsR1.r1xcob
                           : peDsR1.r1secu );
         return *off;
       endif;

       eval-corr @@DsOR1 = peDsR1;
       monitor;
         write p1heR1 @@DsOR1;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_setPersona...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltPersona  : Elimina Persona.-                       *
     ?*                                                              *
     ?*     peDsR1   ( input  ) Est. de Personas                     *
     ?*                                                              *
     ?* Retorna: *on = Elimina / *off = No elimina                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltPersona...
     P                 b                   export
     D SVPRIV_dltPersona...
     D                 pi              n
     D   peDsR1                            const likeds( dsPaher1_t )

     D   k1yer1        ds                  likerec( p1her1 : *key   )

       /free

        SVPRIV_inz();

        k1yer1.r1empr = peDsR1.r1empr;
        k1yer1.r1sucu = peDsR1.r1sucu;
        k1yer1.r1arcd = peDsR1.r1arcd;
        k1yer1.r1spol = peDsR1.r1spol;
        k1yer1.r1sspo = peDsR1.r1sspo;
        k1yer1.r1rama = peDsR1.r1rama;
        k1yer1.r1arse = peDsR1.r1arse;
        k1yer1.r1oper = peDsR1.r1oper;
        k1yer1.r1poco = peDsR1.r1poco;
        k1yer1.r1suop = peDsR1.r1suop;
        k1yer1.r1riec = peDsR1.r1riec;
        k1yer1.r1xcob = peDsR1.r1xcob;
        k1yer1.r1secu = peDsR1.r1secu;

        chain %kds( k1yer1 : 13 ) paher1;
        if %found( paher1 );
          delete p1her1;
        endif;

       return *on;
      /end-free

     P SVPRIV_dltPersona...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltPersonas : Elimina Personas.-                      *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) superPoliza                          *
     ?*     peSspo   ( input  ) Suplemento Superpoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peSecu   ( input  ) Secuencias                (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si elimino / *off = No elimino                *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltPersonas...
     P                 b                   export
     D SVPRIV_dltPersonas...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peSecu                       2  0 options( *nopass : *omit ) const

     D   @@DsR1        ds                  likeds ( dsPaher1_t ) dim( 999 )
     D   @@DsR1C       s             10i 0
     D   x             s             10i 0
     D   rc            s               n

      /free

       SVPRIV_inz();

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) <> *null    ;

                if not SVPRIV_getPersonas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : peRama
                                         : peArse
                                         : peOper
                                         : pePoco
                                         : peSuop
                                         : peRiec
                                         : peXcob
                                         : peSecu
                                         : @@DsR1
                                         : @@DsR1C );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) =  *null    ;

                if not SVPRIV_getPersonas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : peRama
                                         : peArse
                                         : peOper
                                         : pePoco
                                         : peSuop
                                         : peRiec
                                         : peXcob
                                         : *omit
                                         : @@DsR1
                                         : @@DsR1C );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                if not SVPRIV_getPersonas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : peRama
                                         : peArse
                                         : peOper
                                         : pePoco
                                         : peSuop
                                         : peRiec
                                         : *omit
                                         : *omit
                                         : @@DsR1
                                         : @@DsR1C );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                if not SVPRIV_getPersonas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : peRama
                                         : peArse
                                         : peOper
                                         : pePoco
                                         : peSuop
                                         : *omit
                                         : *omit
                                         : *omit
                                         : @@DsR1
                                         : @@DsR1C );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                if not SVPRIV_getPersonas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : peRama
                                         : peArse
                                         : peOper
                                         : pePoco
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : @@DsR1
                                         : @@DsR1C );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                if not SVPRIV_getPersonas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : peRama
                                         : peArse
                                         : peOper
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : @@DsR1
                                         : @@DsR1C );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                if not SVPRIV_getPersonas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : peRama
                                         : peArse
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : @@DsR1
                                         : @@DsR1C );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                if not SVPRIV_getPersonas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : peRama
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : @@DsR1
                                         : @@DsR1C );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null    ;

                if not SVPRIV_getPersonas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : @@DsR1
                                         : @@DsR1C );
                  return *off;
                endif;

           other;

             if not SVPRIV_getPersonas( peEmpr
                                      : peSucu
                                      : peArcd
                                      : peSpol
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : *omit
                                      : @@DsR1
                                      : @@DsR1C );
               return *off;
             endif;

         endsl;
       else;

         if not SVPRIV_getPersonas( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit
                                  : @@DsR1
                                  : @@DsR1C );
           return *off;
         endif;

       endif;

       for x = 1 to @@DsR1C;

          rc = SVPRIV_dltPersona( @@DsR1( @@DsR1C ) );

       endfor;

       return *on;

     P SVPRIV_dltPersonas...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkBeneficiario :  Validar Beneficiarios.-            *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peSecu   ( input  ) Secuencias                (opcional) *
     ?*     peSebe   ( input  ) Beneficiarios             (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkBeneficiario...
     P                 b                   export
     D SVPRIV_chkBeneficiario...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peSecu                       2  0 options( *nopass : *omit ) const
     D   peSebe                       2  0 options( *nopass : *omit ) const

     D   k1yeb1        ds                  likerec( p1her1b : *key   )

      /free

       SVPRIV_inz();

       k1yeb1.b1empr = peEmpr;
       k1yeb1.b1sucu = peSucu;
       k1yeb1.b1arcd = peArcd;
       k1yeb1.b1spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) <> *null and
                %addr( peSebe ) <> *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                k1yeb1.b1riec = peRiec;
                k1yeb1.b1xcob = peXcob;
                k1yeb1.b1secu = peSecu;
                k1yeb1.b1sebe = peSebe;
                setll %kds( k1yeb1 : 14 ) paher1b;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) <> *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                k1yeb1.b1riec = peRiec;
                k1yeb1.b1xcob = peXcob;
                k1yeb1.b1secu = peSecu;
                setll %kds( k1yeb1 : 13 ) paher1b;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                k1yeb1.b1riec = peRiec;
                k1yeb1.b1xcob = peXcob;
                setll %kds( k1yeb1 : 12 ) paher1b;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                k1yeb1.b1riec = peRiec;
                setll %kds( k1yeb1 : 11 ) paher1b;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                setll %kds( k1yeb1 : 10 ) paher1b;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                setll %kds( k1yeb1 : 9 ) paher1b;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                setll %kds( k1yeb1 : 8 ) paher1b;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                setll %kds( k1yeb1 : 7 ) paher1b;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                setll %kds( k1yeb1 : 6 ) paher1b;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                setll %kds( k1yeb1 : 5 ) paher1b;

           other;

             setll %kds( k1yeb1 : 4 ) paher1b;
         endsl;
       else;

         setll %kds( k1yeb1 : 4 ) paher1b;

       endif;

       return %equal();

      /end-free

     P SVPRIV_chkBeneficiario...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getBeneficiarios:  Retorna Beneficiarios.-            *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peSecu   ( input  ) Secuencias                (opcional) *
     ?*     peSebe   ( input  ) Beneficiarios             (opcional) *
     ?*     peDsB1   ( output ) Beneficiarios             (opcional) *
     ?*     peDsB1C  ( output ) Beneficiarios             (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getBeneficiarios...
     P                 b                   export
     D SVPRIV_getBeneficiarios...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peSecu                       2  0 options( *nopass : *omit ) const
     D   peSebe                       2  0 options( *nopass : *omit ) const
     D   peDsB1                            likeds( dsPaher1b_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsB1C                     10i 0 options( *nopass : *omit )

     D   k1yeb1        ds                  likerec( p1her1b : *key   )
     D   @@DsIB1       ds                  likerec( p1her1b : *input )
     D   @@DsB1        ds                  likeds ( dsPaher1b_t ) dim( 999 )
     D   @@DsB1C       s             10i 0

      /free

       SVPRIV_inz();

       k1yeb1.b1empr = peEmpr;
       k1yeb1.b1sucu = peSucu;
       k1yeb1.b1arcd = peArcd;
       k1yeb1.b1spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) <> *null and
                %addr( peSebe ) <> *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                k1yeb1.b1riec = peRiec;
                k1yeb1.b1xcob = peXcob;
                k1yeb1.b1secu = peSecu;
                k1yeb1.b1sebe = peSebe;
                setll %kds( k1yeb1 : 14 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 14 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 14 ) paher1b @@DsIB1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) <> *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                k1yeb1.b1riec = peRiec;
                k1yeb1.b1xcob = peXcob;
                k1yeb1.b1secu = peSecu;
                setll %kds( k1yeb1 : 13 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 13 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 13 ) paher1b @@DsIB1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                k1yeb1.b1riec = peRiec;
                k1yeb1.b1xcob = peXcob;
                setll %kds( k1yeb1 : 12 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 12 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 12 ) paher1b @@DsIB1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                k1yeb1.b1riec = peRiec;
                setll %kds( k1yeb1 : 11 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 11 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 11 ) paher1b @@DsIB1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                k1yeb1.b1suop = peSuop;
                setll %kds( k1yeb1 : 10 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 10 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 10 ) paher1b @@DsIB1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                k1yeb1.b1poco = pePoco;
                setll %kds( k1yeb1 : 9 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 9 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 9 ) paher1b @@DsIB1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                k1yeb1.b1oper = peOper;
                setll %kds( k1yeb1 : 8 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 8 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 8 ) paher1b @@DsIB1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                k1yeb1.b1arse = peArse;
                setll %kds( k1yeb1 : 7 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 7 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 7 ) paher1b @@DsIB1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                k1yeb1.b1rama = peRama;
                setll %kds( k1yeb1 : 6 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 6 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 6 ) paher1b @@DsIB1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                k1yeb1.b1sspo = peSspo;
                setll %kds( k1yeb1 : 5 ) paher1b;
                if not %equal( paher1b );
                  return *off;
                endif;
                reade(n) %kds( k1yeb1 : 5 ) paher1b @@DsIB1;
                dow not %eof( paher1b );
                  @@DsB1C += 1;
                  eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
                 reade(n) %kds( k1yeb1 : 5 ) paher1b @@DsIB1;
                enddo;

           other;

             setll %kds( k1yeb1 : 4 ) paher1b;
             if not %equal( paher1b );
               return *off;
             endif;
             reade(n) %kds( k1yeb1 : 4 ) paher1b @@DsIB1;
             dow not %eof( paher1b );
               @@DsB1C += 1;
               eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
              reade(n) %kds( k1yeb1 : 4 ) paher1b @@DsIB1;
             enddo;
         endsl;
       else;

         setll %kds( k1yeb1 : 4 ) paher1b;
         if not %equal( paher1b );
           return *off;
         endif;
         reade(n) %kds( k1yeb1 : 4 ) paher1b @@DsIB1;
         dow not %eof( paher1b );
           @@DsB1C += 1;
           eval-corr @@DsB1( @@DsB1C ) = @@DsIB1;
          reade(n) %kds( k1yeb1 : 4 ) paher1b @@DsIB1;
         enddo;

       endif;

       if %addr( peDsB1 ) <> *null;
          eval-corr peDsB1 = @@DsB1;
       endif;

       if %addr( peDsB1C ) <> *null;
          peDsB1C = @@DsB1C;
       endif;

       return *on;

      /end-free

     P SVPRIV_getBeneficiarios...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setBeneficiario :  Graba Beneficiarios.-              *
     ?*                                                              *
     ?*     peDsB1   ( input  ) Est. de Beneficiarios                *
     ?*                                                              *
     ?* Retorna: *on = Si Graba / *off = No Graba                    *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setBeneficiario...
     P                 b                   export
     D SVPRIV_setBeneficiario...
     D                 pi              n
     D   peDsB1                            const likeds( dsPaher1b_t )

     D   @@DsOB1       ds                  likerec( p1her1b : *output )

      /free

        SVPRIV_inz();

        if SVPRIV_chkBeneficiario ( peDsB1.b1empr
                                  : peDsB1.b1sucu
                                  : peDsB1.b1arcd
                                  : peDsB1.b1spol
                                  : peDsB1.b1sspo
                                  : peDsB1.b1rama
                                  : peDsB1.b1arse
                                  : peDsB1.b1oper
                                  : peDsB1.b1poco
                                  : peDsB1.b1suop
                                  : peDsB1.b1riec
                                  : peDsB1.b1xcob
                                  : peDsB1.b1secu
                                  : peDsB1.b1sebe  );
          return *off;
        endif;

        eval-corr @@DsOB1 = peDsB1;
        monitor;
          write p1her1b @@DsOB1;
        on-error;
          return *off;
        endmon;

       return *on;
      /end-free

     P SVPRIV_setBeneficiario...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltBeneficiario :  Elimina Beneficiario.-             *
     ?*                                                              *
     ?*     peDsB1   ( input  ) Est. de Beneficiarios                *
     ?*                                                              *
     ?* Retorna: *on = Elimina / *off = No elimina                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltBeneficiario...
     P                 b                   export
     D SVPRIV_dltBeneficiario...
     D                 pi              n
     D   peDsB1                            const likeds( dsPaher1B_t )

     D   k1yeb1        ds                  likerec( p1her1b : *key   )

       /free

        SVPRIV_inz();

        k1yeb1.b1empr = peDsB1.b1empr;
        k1yeb1.b1sucu = peDsB1.b1sucu;
        k1yeb1.b1arcd = peDsB1.b1arcd;
        k1yeb1.b1spol = peDsB1.b1spol;
        k1yeb1.b1sspo = peDsB1.b1sspo;
        k1yeb1.b1rama = peDsB1.b1rama;
        k1yeb1.b1arse = peDsB1.b1arse;
        k1yeb1.b1oper = peDsB1.b1oper;
        k1yeb1.b1poco = peDsB1.b1poco;
        k1yeb1.b1suop = peDsB1.b1suop;
        k1yeb1.b1riec = peDsB1.b1riec;
        k1yeb1.b1xcob = peDsB1.b1xcob;
        k1yeb1.b1secu = peDsB1.b1secu;
        k1yeb1.b1sebe = peDsB1.b1sebe;

        chain %kds( k1yeb1 : 14 ) paher1b;
        if %found( paher1b );
          delete p1her1b;
        endif;

       return *on;
      /end-free

     P SVPRIV_dltBeneficiario...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltBeneficiarios:  Elimina Beneficiarios.-            *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento Superpoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peSecu   ( input  ) Secuencias                (opcional) *
     ?*     peSebe   ( input  ) Beneficiarios             (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si elimino / *off = No elimino                *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltBeneficiarios...
     P                 b                   export
     D SVPRIV_dltBeneficiarios...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peSecu                       2  0 options( *nopass : *omit ) const
     D   peSebe                       2  0 options( *nopass : *omit ) const

     D   @@DsB1        ds                  likeds ( dsPaher1b_t ) dim( 999 )
     D   @@DsB1C       s             10i 0
     D   x             s             10i 0
     D   rc            s               n

      /free

       SVPRIV_inz();

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) <> *null and
                %addr( peSebe ) <> *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peRama
                                              : peArse
                                              : peOper
                                              : pePoco
                                              : peSuop
                                              : peRiec
                                              : peXcob
                                              : peSecu
                                              : peSebe
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) <> *null and
                %addr( peSebe ) =  *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peRama
                                              : peArse
                                              : peOper
                                              : pePoco
                                              : peSuop
                                              : peRiec
                                              : peXcob
                                              : peSecu
                                              : *omit
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peRama
                                              : peArse
                                              : peOper
                                              : pePoco
                                              : peSuop
                                              : peRiec
                                              : peXcob
                                              : *omit
                                              : *omit
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peRama
                                              : peArse
                                              : peOper
                                              : pePoco
                                              : peSuop
                                              : peRiec
                                              : *omit
                                              : *omit
                                              : *omit
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peRama
                                              : peArse
                                              : peOper
                                              : pePoco
                                              : peSuop
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peRama
                                              : peArse
                                              : peOper
                                              : pePoco
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peRama
                                              : peArse
                                              : peOper
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peRama
                                              : peArse
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : peRama
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peSecu ) =  *null and
                %addr( peSebe ) =  *null    ;

                if not SVPRIV_getBeneficiarios( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peSspo
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : *omit
                                              : @@DsB1
                                              : @@DsB1C );
                  return *off;

                endif;

           other;

             if not SVPRIV_getBeneficiarios( peEmpr
                                           : peSucu
                                           : peArcd
                                           : peSpol
                                           : *omit
                                           : *omit
                                           : *omit
                                           : *omit
                                           : *omit
                                           : *omit
                                           : *omit
                                           : *omit
                                           : *omit
                                           : *omit
                                           : @@DsB1
                                           : @@DsB1C );
               return *off;
             endif;

         endsl;
       else;
         if not SVPRIV_getBeneficiarios( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : @@DsB1
                                       : @@DsB1C );
           return *off;
         endif;

       endif;

       for x = 1 to @@DsB1C;
          rc = SVPRIV_dltBeneficiario( @@DsB1( x ) );
       endfor;

       return *on;

     P SVPRIV_dltBeneficiarios...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkCobertura  : Validar detalle de Coberturas y       *
     ?*                        Riesgos.-                             *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkCobertura...
     P                 b                   export
     D SVPRIV_chkCobertura...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const

     D   k1yer2        ds                  likerec( p1her2 : *key )

      /free

       SVPRIV_inz();

       k1yer2.r2empr = peEmpr;
       k1yer2.r2sucu = peSucu;
       k1yer2.r2arcd = peArcd;
       k1yer2.r2spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null    ;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                k1yer2.r2poco = pePoco;
                k1yer2.r2suop = peSuop;
                k1yer2.r2riec = peRiec;
                k1yer2.r2xcob = peXcob;
                setll %kds( k1yer2 : 12 ) paher2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null    ;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                k1yer2.r2poco = pePoco;
                k1yer2.r2suop = peSuop;
                k1yer2.r2riec = peRiec;
                setll %kds( k1yer2 : 11 ) paher2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null    ;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                k1yer2.r2poco = pePoco;
                k1yer2.r2suop = peSuop;
                setll %kds( k1yer2 : 10 ) paher2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null    ;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                k1yer2.r2poco = pePoco;
                setll %kds( k1yer2 : 9 ) paher2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null    ;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                setll %kds( k1yer2 : 8 ) paher2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null    ;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                setll %kds( k1yer2 : 7 ) paher2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null    ;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                setll %kds( k1yer2 : 6 ) paher2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null    ;

                k1yer2.r2sspo = peSspo;
                setll %kds( k1yer2 : 5 ) paher2;

           other;

             setll %kds( k1yer2 : 4 ) paher2;
         endsl;
       else;

         setll %kds( k1yer2 : 4 ) paher2;

       endif;

       return %equal();

      /end-free

     P SVPRIV_chkCobertura...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getCoberturas : Retorna detalle de Coberturas y       *
     ?*                        Riesgos.-                             *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peDsR2   ( output ) Estructura Riesgos Varios (opcional) *
     ?*     peDsR2C  ( output ) Estructura Riesgos Varios (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getCoberturas...
     P                 b                   export
     D SVPRIV_getCoberturas...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peDsR2                            likeds( dsPaher2_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR2C                     10i 0 options( *nopass : *omit )

     D   k1yer2        ds                  likerec( p1her2   : *key   )
     D   k1yer201      ds                  likerec( p1her201 : *key   )
     D   @@DsIR2       ds                  likerec( p1her2   : *input )
     D   @@DsR2        ds                  likeds( dsPaher2_t ) dim( 999 )
     D   @@DsR2C       s             10i 0

      /free

       SVPRIV_inz();

       k1yer2.r2Empr = peEmpr;
       k1yer2.r2Sucu = peSucu;
       k1yer2.r2Arcd = peArcd;
       k1yer2.r2Spol = peSpol;

       k1yer201.r2Empr = peEmpr;
       k1yer201.r2Sucu = peSucu;
       k1yer201.r2Arcd = peArcd;
       k1yer201.r2Spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null ;

                k1yer201.r2sspo = peSspo;
                k1yer201.r2rama = peRama;
                k1yer201.r2arse = peArse;
                k1yer201.r2oper = peOper;
                k1yer201.r2suop = peSuop;
                k1yer201.r2riec = peRiec;
                k1yer201.r2xcob = peXcob;
                setll %kds( k1yer201 : 12 ) paher201;
                if not %equal( paher201 );
                  return *off;
                endif;
                reade(n) %kds( k1yer201 : 12 ) paher201;
                dow not %eof( paher201 );

                  k1yer2.r2sspo = r2sspo;
                  k1yer2.r2rama = r2rama;
                  k1yer2.r2arse = r2arse;
                  k1yer2.r2oper = r2oper;
                  k1yer2.r2poco = r2poco;
                  k1yer2.r2suop = r2suop;
                  k1yer2.r2riec = r2riec;
                  k1yer2.r2xcob = r2xcob;
                  chain(n) %kds( k1yer2 : 12 ) paher2 @@DsIR2;
                  if %found( paher2 );
                   @@DsR2C += 1;
                   eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
                  endif;

                 reade(n) %kds( k1yer201 : 12 ) paher201;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null ;

                k1yer201.r2sspo = peSspo;
                k1yer201.r2rama = peRama;
                k1yer201.r2arse = peArse;
                k1yer201.r2oper = peOper;
                k1yer201.r2suop = peSuop;
                setll %kds( k1yer201 : 9 ) paher201;
                if not %equal( paher201 );
                  return *off;
                endif;
                reade(n) %kds( k1yer201 : 9 ) paher201;
                dow not %eof( paher201 );

                  k1yer2.r2sspo = r2sspo;
                  k1yer2.r2rama = r2rama;
                  k1yer2.r2arse = r2arse;
                  k1yer2.r2oper = r2oper;
                  k1yer2.r2poco = r2poco;
                  k1yer2.r2suop = r2suop;
                  k1yer2.r2riec = r2riec;
                  k1yer2.r2xcob = r2xcob;
                  chain(n) %kds( k1yer2 : 12 ) paher2 @@DsIR2;
                  if %found( paher2 );
                   @@DsR2C += 1;
                   eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
                  endif;

                 reade(n) %kds( k1yer201 : 9 ) paher201;
                enddo;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null ;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                k1yer2.r2poco = pePoco;
                k1yer2.r2suop = peSuop;
                k1yer2.r2riec = peRiec;
                k1yer2.r2xcob = peXcob;
                setll %kds( k1yer2 : 12 ) paher2;
                if not %equal( paher2 );
                  return *off;
                endif;
                reade(n) %kds( k1yer2 : 12 ) paher2 @@DsIR2;
                dow not %eof( paher2 );
                    @@DsR2C += 1;
                    eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
                 reade(n) %kds( k1yer2 : 12 ) paher2 @@DsIR2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null ;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                k1yer2.r2poco = pePoco;
                k1yer2.r2suop = peSuop;
                k1yer2.r2Riec = peRiec;
                setll %kds( k1yer2 : 11 ) paher2;
                if not %equal( paher2 );
                  return *off;
                endif;
                reade(n) %kds( k1yer2 : 11 ) paher2 @@DsIR2;
                dow not %eof( paher2 );
                  @@DsR2C += 1;
                  eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
                 reade(n) %kds( k1yer2 : 11 ) paher2 @@DsIR2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                k1yer2.r2poco = pePoco;
                k1yer2.r2suop = peSuop;
                setll %kds( k1yer2 : 10 ) paher2;
                if not %equal( paher2 );
                  return *off;
                endif;
                reade(n) %kds( k1yer2 : 10 ) paher2 @@DsIR2;
                dow not %eof( paher2 );
                  @@DsR2C += 1;
                  eval-corr @@DsR2( @@Dsr2C ) = @@DsIR2;
                 reade(n) %kds( k1yer2 : 10 ) paher2 @@DsIR2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                k1yer2.r2poco = pePoco;
                setll %kds( k1yer2 : 9 ) paher2;
                if not %equal( paher2 );
                  return *off;
                endif;
                reade(n) %kds( k1yer2 : 9 ) paher2 @@DsIR2;
                dow not %eof( paher2 );
                  @@DsR2C += 1;
                  eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
                 reade(n) %kds( k1yer2 : 9 ) paher2 @@DsIR2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                k1yer2.r2oper = peOper;
                setll %kds( k1yer2 : 8 ) paher2;
                if not %equal( paher2 );
                  return *off;
                endif;
                reade(n) %kds( k1yer2 : 8 ) paher2 @@DsIR2;
                dow not %eof( paher2 );
                  @@DsR2C += 1;
                  eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
                 reade(n) %kds( k1yer2 : 8 ) paher2 @@DsIR2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                k1yer2.r2arse = peArse;
                setll %kds( k1yer2 : 7 ) paher2;
                if not %equal( paher2 );
                  return *off;
                endif;
                reade(n) %kds( k1yer2 : 7 ) paher2 @@DsIR2;
                dow not %eof( paher2 );
                  @@DsR2C += 1;
                  eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
                 reade(n) %kds( k1yer2 : 7 ) paher2 @@DsIR2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null;

                k1yer2.r2sspo = peSspo;
                k1yer2.r2rama = peRama;
                setll %kds( k1yer2 : 6 ) paher2;
                if not %eof( paher2 );
                  return *off;
                endif;
                reade(n) %kds( k1yer2 : 6 ) paher2 @@DsIR2;
                dow not %eof( paher2 );
                  @@DsR2C += 1;
                  eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
                 reade(n) %kds( k1yer2 : 6 ) paher2 @@DsIR2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null;

                k1yer2.r2sspo = peSspo;
                setll %kds( k1yer2 : 5 ) paher2;
                if not %equal( paher2 );
                  return *off;
                endif;
                reade(n) %kds( k1yer2 : 5 ) paher2 @@DsIR2;
                dow not %eof( paher2 );
                  @@DsR2C += 1;
                  eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
                 reade(n) %kds( k1yer2 : 5 ) paher2 @@DsIR2;
                enddo;
         other;

           setll %kds( k1yer2 : 4 ) paher2;
           if not %equal( paher2 );
             return *off;
           endif;
           reade(n) %kds( k1yer2 : 4 ) paher2 @@DsIR2;
             dow not %eof( paher2 );
                @@DsR2C += 1;
                eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
              reade(n) %kds( k1yer2 : 4 ) paher2 @@DsIR2;
             enddo;
         endsl;
       else;

         setll %kds( k1yer2 : 4 ) paher2;
         if not %equal( paher2 );
           return *off;
         endif;
         reade(n) %kds( k1yer2 : 4 ) paher2 @@DsIR2;
           dow not %eof( paher2 );
             @@DsR2C += 1;
             eval-corr @@DsR2( @@DsR2C ) = @@DsIR2;
           reade(n) %kds( k1yer2 : 4 ) paher2 @@DsIR2;
           enddo;
       endif;

       if %addr( peDsR2 ) <> *null;
         eval-corr peDsR2 = @@DsR2;
       endif;

       if %addr( peDsR2C ) <> *null;
         peDsR2C = @@DsR2C;
       endif;

       return *on;

      /end-free

     P SVPRIV_getCoberturas...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setCobertura  : Graba detalle de Coberturas y Riesgos *
     ?*                                                              *
     ?*     peDsR2   ( input  ) Estructura Coberturas                *
     ?*                                                              *
     ?* Retorna: *on = Si graba / *off = No Graba                    *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setCobertura...
     P                 b                   export
     D SVPRIV_setCobertura...
     D                 pi              n
     D   peDsR2                            const likeds( dsPaher2_t )

     D   @@DsOR2       ds                  likerec( p1her2 : *output )

      /free

       SVPRIV_inz();

       if SVPRIV_chkCobertura( peDsR2.r2empr
                             : peDsR2.r2sucu
                             : peDsR2.r2arcd
                             : peDsR2.r2spol
                             : peDsR2.r2sspo
                             : peDsR2.r2rama
                             : peDsR2.r2arse
                             : peDsR2.r2oper
                             : peDsR2.r2poco
                             : peDsR2.r2suop
                             : peDsR2.r2riec
                             : peDsR2.r2xcob );
         return *off;
       endif;

       eval-corr @@DsOR2 = peDsR2;
       monitor;
         write p1heR2 @@DsOR2;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_setCobertura...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_updCobertura  : Actualiza detalle de Cobertura  y     *
     ?*                        Riesgo                                *
     ?*     peDsR2   ( input  ) Estructura Coberturas                *
     ?*                                                              *
     ?* Retorna: *on = Si graba / *off = No Graba                    *
     ?* ------------------------------------------------------------ *
     P SVPRIV_updCobertura...
     P                 b                   export
     D SVPRIV_updCobertura...
     D                 pi              n
     D   peDsR2                            const likeds( dsPaher2_t )

     D   k1yer2        ds                  likerec( p1her2 : *key    )
     D   @@DsOR2       ds                  likerec( p1her2 : *output )

      /free

       SVPRIV_inz();

       k1yer2.r2empr = peDsR2.r2empr;
       k1yer2.r2sucu = peDsR2.r2sucu;
       k1yer2.r2arcd = peDsR2.r2arcd;
       k1yer2.r2spol = peDsR2.r2spol;
       k1yer2.r2sspo = peDsR2.r2sspo;
       k1yer2.r2rama = peDsR2.r2rama;
       k1yer2.r2arse = peDsR2.r2arse;
       k1yer2.r2oper = peDsR2.r2oper;
       k1yer2.r2poco = peDsR2.r2poco;
       k1yer2.r2suop = peDsR2.r2suop;
       k1yer2.r2riec = peDsR2.r2riec;
       k1yer2.r2xcob = peDsR2.r2xcob;
       chain %kds( k1yer2 : 12 ) paher2;
       if not %found( paher2 );
         return *off;
       endif;

       eval-corr @@DsOR2 = peDsR2;
       monitor;
         update p1heR2 @@DsOR2;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_updCobertura...
     P                 e
     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltCobertura  : Elimina Cobertura  y Riesgo           *
     ?*                                                              *
     ?*     peDsR2   ( input  ) Estructura Coberturas                *
     ?*                                                              *
     ?* Retorna: *on = Elimina / *off = No elimina                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltCobertura...
     P                 b                   export
     D SVPRIV_dltCobertura...
     D                 pi              n
     D   peDsR2                            const likeds( dsPaher2_t )

     D   k1yer2        ds                  likerec( p1her2 : *key   )

      /free

       SVPRIV_inz();

       k1yer2.r2empr = peDsR2.r2empr;
       k1yer2.r2sucu = peDsR2.r2sucu;
       k1yer2.r2arcd = peDsR2.r2arcd;
       k1yer2.r2spol = peDsR2.r2spol;
       k1yer2.r2sspo = peDsR2.r2sspo;
       k1yer2.r2rama = peDsR2.r2rama;
       k1yer2.r2arse = peDsR2.r2arse;
       k1yer2.r2oper = peDsR2.r2oper;
       k1yer2.r2poco = peDsR2.r2poco;
       k1yer2.r2suop = peDsR2.r2suop;
       k1yer2.r2riec = peDsR2.r2riec;
       k1yer2.r2xcob = peDsR2.r2xcob;
       chain %kds( k1yer2 : 12 ) paher2;
       if %found( paher2 );
         delete p1her2;
       endif;

       return *on;

     P SVPRIV_dltCobertura...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkTexto : Validar Textos.-                           *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro de Componente         (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peRiec   ( input  ) Riesgo                    (opcional) *
     ?*     peXcob   ( input  ) Cobertura                 (opcional) *
     ?*     peNrre   ( input  ) Nro. de linea de Texto    (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkTexto...
     P                 b                   export
     D SVPRIV_chkTexto...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peNrre                       3  0 options( *nopass : *omit ) const

     D   k1yer3        ds                  likerec( p1her3 : *key )

      /free

       SVPRIV_inz();

       k1yer3.r3empr = peEmpr;
       k1yer3.r3sucu = peSucu;
       k1yer3.r3arcd = peArcd;
       k1yer3.r3spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peNrre ) <> *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                k1yer3.r3suop = peSuop;
                k1yer3.r3riec = peRiec;
                k1yer3.r3xcob = peXcob;
                k1yer3.r3nrre = peNrre;
                setll %kds( k1yer3 : 13 ) paher3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                k1yer3.r3suop = peSuop;
                k1yer3.r3riec = peRiec;
                k1yer3.r3xcob = peXcob;
                setll %kds( k1yer3 : 12 ) paher3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                k1yer3.r3suop = peSuop;
                k1yer3.r3riec = peRiec;
                setll %kds( k1yer3 : 11 ) paher3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                k1yer3.r3suop = peSuop;
                setll %kds( k1yer3 : 10 ) paher3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                setll %kds( k1yer3 : 9 ) paher3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                setll %kds( k1yer3 : 8 ) paher3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                setll %kds( k1yer3 : 7 ) paher3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                setll %kds( k1yer3 : 6 ) paher3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                setll %kds( k1yer3 : 5 ) paher3;

           other;
                setll %kds( k1yer3 : 5 ) paher3;
         endsl;
       else;
                setll %kds( k1yer3 : 5 ) paher3;
       endif;

       return %equal();

      /end-free

     P SVPRIV_chkTexto...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getTextos: Retorna Textos .-                          *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro de Componente         (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peRiec   ( input  ) Riesgo                    (opcional) *
     ?*     peXcob   ( input  ) Cobertura                 (opcional) *
     ?*     peNrre   ( input  ) Nro. de linea de Texto    (opcional) *
     ?*     peDsR3   ( output ) Est. Textos               (opcional) *
     ?*     peDsR3C  ( output ) Cant. Textos              (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getTextos...
     P                 b                   export
     D SVPRIV_getTextos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peNrre                       3  0 options( *nopass : *omit ) const
     D   peDsR3                            likeds( dsPaher3_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR3C                     10i 0 options( *nopass : *omit )

     D   k1yer3        ds                  likerec( p1her3 : *key   )
     D   @@DsIR3       ds                  likerec( p1her3 : *input )
     D   @@DsR3        ds                  likeds ( dsPaher3_t ) dim( 999 )
     D   @@DsR3C       s             10i 0

      /free

       SVPRIV_inz();

       k1yer3.r3empr = peEmpr;
       k1yer3.r3sucu = peSucu;
       k1yer3.r3arcd = peArcd;
       k1yer3.r3spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peNrre ) <> *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                k1yer3.r3suop = peSuop;
                k1yer3.r3riec = peRiec;
                k1yer3.r3xcob = peXcob;
                k1yer3.r3nrre = peNrre;
                setll %kds( k1yer3 : 13 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 13 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 13 ) paher3 @@DsIR3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                k1yer3.r3suop = peSuop;
                k1yer3.r3riec = peRiec;
                k1yer3.r3xcob = peXcob;
                setll %kds( k1yer3 : 12 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 12 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 12 ) paher3 @@DsIR3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                k1yer3.r3suop = peSuop;
                k1yer3.r3riec = peRiec;
                setll %kds( k1yer3 : 11 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 11 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 11 ) paher3 @@DsIR3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null    ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                k1yer3.r3suop = peSuop;
                setll %kds( k1yer3 : 10 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 10 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 10 ) paher3 @@DsIR3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                k1yer3.r3poco = pePoco;
                setll %kds( k1yer3 : 9 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 9 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 9 ) paher3 @@DsIR3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                k1yer3.r3oper = peOper;
                setll %kds( k1yer3 : 8 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 8 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 8 ) paher3 @@DsIR3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                k1yer3.r3arse = peArse;
                setll %kds( k1yer3 : 7 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 7 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 7 ) paher3 @@DsIR3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                k1yer3.r3sspo = peSspo;
                k1yer3.r3rama = peRama;
                setll %kds( k1yer3 : 6 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 6 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 6 ) paher3 @@DsIR3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                k1yer3.r3sspo = peSspo;
                setll %kds( k1yer3 : 5 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 5 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 5 ) paher3 @@DsIR3;
                enddo;
           other;
                setll %kds( k1yer3 : 4 ) paher3;
                if not %equal( paher3 );
                  return *off;
                endif;
                reade(n) %kds( k1yer3 : 4 ) paher3 @@DsIR3;
                dow not %eof( paher3 );
                  @@DsR3C += 1;
                  eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
                 reade(n) %kds( k1yer3 : 4 ) paher3 @@DsIR3;
                enddo;
         endsl;
       else;
         setll %kds( k1yer3 : 4 ) paher3;
         if not %equal( paher3 );
           return *off;
          endif;
          reade(n) %kds( k1yer3 : 4 ) paher3 @@DsIR3;
          dow not %eof( paher3 );
            @@DsR3C += 1;
            eval-corr @@DsR3( @@DsR3C ) = @@DsIR3;
           reade(n) %kds( k1yer3 : 4 ) paher3 @@DsIR3;
          enddo;
       endif;

       if %addr( peDsR3 ) <> *null;
         eval-corr peDsR3 = @@DsR3;
       endif;

       if %addr( peDsR3C ) <> *null;
         peDsR3C = @@DsR3C;
       endif;

       return *on;

      /end-free

     P SVPRIV_getTextos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setTexto : Graba Textos                               *
     ?*                                                              *
     ?*     peDsR3  (  input  )  Est. Textos                         *
     ?*                                                              *
     ?* Retorna: *on = Grabo / *off = No Grabo                       *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setTexto...
     P                 b                   export
     D SVPRIV_setTexto...
     D                 pi              n
     D   peDsR3                            const likeds( dsPaher3_t )

     D   @@DsOR3       ds                  likerec( p1her3 : *output )

      /free

       SVPRIV_inz();

       if SVPRIV_chkTexto( peDsR3.r3empr
                         : peDsR3.r3sucu
                         : peDsR3.r3arcd
                         : peDsR3.r3spol
                         : peDsR3.r3sspo
                         : peDsR3.r3rama
                         : peDsR3.r3arse
                         : peDsR3.r3oper
                         : peDsR3.r3poco
                         : peDsR3.r3suop
                         : peDsR3.r3riec
                         : peDsR3.r3xcob
                         : peDsR3.r3nrre  );
         return *off;
       endif;

       eval-corr @@DsOR3 = peDsR3;
       monitor;
         write p1heR3 @@DsOR3;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_setTexto...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltTexto : Elimina Texto.-                            *
     ?*                                                              *
     ?*     peDsR3  (  input  )  Est. Textos                         *
     ?*                                                              *
     ?* Retorna: *on = Elimina / *off = No elimina                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltTexto...
     P                 b                   export
     D SVPRIV_dltTexto...
     D                 pi              n
     D   peDsR3                            const likeds( dsPaher3_t )

     D   k1yer3        ds                  likerec( p1her3 : *key )

      /free

       SVPRIV_inz();

       k1yer3.r3empr = peDsR3.r3empr;
       k1yer3.r3sucu = peDsR3.r3sucu;
       k1yer3.r3arcd = peDsR3.r3arcd;
       k1yer3.r3spol = peDsR3.r3spol;
       k1yer3.r3sspo = peDsR3.r3sspo;
       k1yer3.r3rama = peDsR3.r3rama;
       k1yer3.r3arse = peDsR3.r3arse;
       k1yer3.r3oper = peDsR3.r3oper;
       k1yer3.r3poco = peDsR3.r3poco;
       k1yer3.r3suop = peDsR3.r3suop;
       k1yer3.r3riec = peDsR3.r3riec;
       k1yer3.r3xcob = peDsR3.r3xcob;
       k1yer3.r3nrre = peDsR3.r3nrre;
       chain %kds( k1yer3 : 13 ) paher3;
       if %found( paher3 );
         delete p1her3;
       endif;
       return *on;
      /end-free

     P SVPRIV_dltTexto...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltTextos: Elimina Textos .-                          *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro de Componente         (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peRiec   ( input  ) Riesgo                    (opcional) *
     ?*     peXcob   ( input  ) Cobertura                 (opcional) *
     ?*     peNrre   ( input  ) Nro. de linea de Texto    (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si elimino / *off = No elimino                *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltTextos...
     P                 b                   export
     D SVPRIV_dltTextos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peNrre                       3  0 options( *nopass : *omit ) const

     D   @@DsR3        ds                  likeds ( dsPaher3_t ) dim( 999 )
     D   @@DsR3C       s             10i 0
     D   x             s             10i 0
     D   rc            s               n

      /free

       SVPRIV_inz();

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peNrre ) <> *null ;

                if not SVPRIV_getTextos( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : peArse
                                       : peOper
                                       : pePoco
                                       : peSuop
                                       : peRiec
                                       : peXcob
                                       : peNrre
                                       : @@DsR3
                                       : @@DsR3c  );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                if not SVPRIV_getTextos( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : peArse
                                       : peOper
                                       : pePoco
                                       : peSuop
                                       : peRiec
                                       : *omit
                                       : *omit
                                       : @@DsR3
                                       : @@DsR3c  );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                if not SVPRIV_getTextos( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : peArse
                                       : peOper
                                       : pePoco
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : @@DsR3
                                       : @@DsR3c  );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                if not SVPRIV_getTextos( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : peArse
                                       : peOper
                                       : pePoco
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : @@DsR3
                                       : @@DsR3c  );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                if not SVPRIV_getTextos( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : peArse
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : @@DsR3
                                       : @@DsR3c  );
                  return *off;
                endif;


           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                if not SVPRIV_getTextos( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : peRama
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : @@DsR3
                                       : @@DsR3c  );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNrre ) =  *null ;

                if not SVPRIV_getTextos( peEmpr
                                       : peSucu
                                       : peArcd
                                       : peSpol
                                       : peSspo
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : @@DsR3
                                       : @@DsR3c  );
                  return *off;
                endif;

           other;

             if not SVPRIV_getTextos( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : *omit
                                    : @@DsR3
                                    : @@DsR3c  );
               return *off;
             endif;
         endsl;
       else;

        if not SVPRIV_getTextos( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : *omit
                               : *omit
                               : *omit
                               : *omit
                               : *omit
                               : *omit
                               : *omit
                               : *omit
                               : *omit
                               : @@DsR3
                               : @@DsR3c  );
           return *off;
         endif;
       endif;

       for x = 1 to @@DsR3C;
         rc = SVPRIV_dltTexto( @@DsR3( x ) );
       endfor;

       return *on;

     P SVPRIV_dltTextos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkDescuento  : Validar Descuentos.-                  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peNive   ( input  ) Nivel de Descuento        (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkDescuento...
     P                 b                   export
     D SVPRIV_chkDescuento...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peNive                       1  0 options( *nopass : *omit ) const

     D   k1yer4        ds                  likerec( p1her4 : *key )

      /free

       SVPRIV_inz();

       k1yer4.r4empr = peEmpr;
       k1yer4.r4sucu = peSucu;
       k1yer4.r4arcd = peArcd;
       k1yer4.r4spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peNive ) <> *null;

                k1yer4.r4sspo = peSspo;
                k1yer4.r4rama = peRama;
                k1yer4.r4arse = peArse;
                k1yer4.r4oper = peOper;
                k1yer4.r4poco = pePoco;
                k1yer4.r4suop = peSuop;
                k1yer4.r4xcob = peXcob;
                k1yer4.r4nive = peNive;
                setll %kds( k1yer4 : 12 ) paher4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peNive ) =  *null;

                k1yer4.r4sspo = peSspo;
                k1yer4.r4rama = peRama;
                k1yer4.r4arse = peArse;
                k1yer4.r4oper = peOper;
                k1yer4.r4poco = pePoco;
                k1yer4.r4suop = peSuop;
                k1yer4.r4xcob = peXcob;
                setll %kds( k1yer4 : 11 ) paher4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4sspo = peSspo;
                k1yer4.r4rama = peRama;
                k1yer4.r4arse = peArse;
                k1yer4.r4oper = peOper;
                k1yer4.r4poco = pePoco;
                k1yer4.r4suop = peSuop;
                setll %kds( k1yer4 : 10 ) paher4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                k1yer4.r4Rama = peRama;
                k1yer4.r4Arse = peArse;
                k1yer4.r4Oper = peOper;
                k1yer4.r4Poco = pePoco;
                setll %kds( k1yer4 : 9 ) paher4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                k1yer4.r4Rama = peRama;
                k1yer4.r4Arse = peArse;
                k1yer4.r4Oper = peOper;
                setll %kds( k1yer4 : 8 ) paher4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                k1yer4.r4Rama = peRama;
                k1yer4.r4Arse = peArse;
                setll %kds( k1yer4 : 7 ) paher4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                k1yer4.r4Rama = peRama;
                setll %kds( k1yer4 : 6 ) paher4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                setll %kds( k1yer4 : 5 ) paher4;
         other;

           setll %kds( k1yer4 : 4 ) paher4;
         endsl;
       else;

         setll %kds( k1yer4 : 4 ) paher4;
       endif;

       return %equal();

      /end-free

     P SVPRIV_chkDescuento...
     P                 e
     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getDescuentos : Retorna Descuentos.-                  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peNive   ( input  ) Nivel de descuento        (opcional) *
     ?*     peDsR4   ( input  ) Est. de Descuentos        (opcional) *
     ?*     peDsR4C  ( input  ) Cantidad de Descuentos    (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getDescuentos...
     P                 b                   export
     D SVPRIV_getDescuentos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peNive                       1  0 options( *nopass : *omit ) const
     D   peDsR4                            likeds( dsPaher4_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR4C                     10i 0 options( *nopass : *omit )

     D   k1yer4        ds                  likerec( p1her4 : *key )
     D   @@DsR4        ds                  likeds( dsPaher4_t ) dim( 999 )
     D   @@DsR4C       s             10i 0
     D   @@DsIR4       ds                  likerec( p1her4 : *input )

      /free

       SVPRIV_inz();

       k1yer4.r4empr = peEmpr;
       k1yer4.r4sucu = peSucu;
       k1yer4.r4arcd = peArcd;
       k1yer4.r4spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peNive ) <> *null;

                k1yer4.r4sspo = peSspo;
                k1yer4.r4rama = peRama;
                k1yer4.r4arse = peArse;
                k1yer4.r4oper = peOper;
                k1yer4.r4poco = pePoco;
                k1yer4.r4suop = peSuop;
                k1yer4.r4xcob = peXcob;
                k1yer4.r4nive = peNive;
                setll %kds( k1yer4 : 12 ) paher4;
                if not %equal( paher4 );
                  return *off;
                endif;
                reade(n) %kds( k1yer4 : 12 ) paher4 @@DsIR4;
                dow not %eof( paher4 );
                  @@DsR4C += 1;
                  eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
                  reade(n) %kds( k1yer4 : 12 ) paher4 @@DsIR4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peNive ) =  *null;

                k1yer4.r4sspo = peSspo;
                k1yer4.r4rama = peRama;
                k1yer4.r4arse = peArse;
                k1yer4.r4oper = peOper;
                k1yer4.r4poco = pePoco;
                k1yer4.r4suop = peSuop;
                k1yer4.r4xcob = peXcob;
                setll %kds( k1yer4 : 11 ) paher4;
                if not %equal( paher4 );
                  return *off;
                endif;
                reade(n) %kds( k1yer4 : 11 ) paher4 @@DsIR4;
                dow not %eof( paher4 );
                  @@DsR4C += 1;
                  eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
                  reade(n) %kds( k1yer4 : 11 ) paher4 @@DsIR4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4sspo = peSspo;
                k1yer4.r4rama = peRama;
                k1yer4.r4arse = peArse;
                k1yer4.r4oper = peOper;
                k1yer4.r4poco = pePoco;
                k1yer4.r4suop = peSuop;
                setll %kds( k1yer4 : 10 ) paher4;
                if not %equal( paher4 );
                  return *off;
                endif;
                reade(n) %kds( k1yer4 : 10 ) paher4 @@DsIR4;
                dow not %eof( paher4 );
                  @@DsR4C += 1;
                  eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
                  reade(n) %kds( k1yer4 : 10 ) paher4 @@DsIR4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                k1yer4.r4Rama = peRama;
                k1yer4.r4Arse = peArse;
                k1yer4.r4Oper = peOper;
                k1yer4.r4Poco = pePoco;
                setll %kds( k1yer4 : 9 ) paher4;
                if not %equal( paher4 );
                  return *off;
                endif;
                reade(n) %kds( k1yer4 : 9 ) paher4 @@DsIR4;
                dow not %eof( paher4 );
                  @@DsR4C += 1;
                  eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
                  reade(n) %kds( k1yer4 : 9 ) paher4 @@DsIR4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                k1yer4.r4Rama = peRama;
                k1yer4.r4Arse = peArse;
                k1yer4.r4Oper = peOper;
                setll %kds( k1yer4 : 8 ) paher4;
                if not %equal( paher4 );
                  return *off;
                endif;
                reade(n) %kds( k1yer4 : 8 ) paher4 @@DsIR4;
                dow not %eof( paher4 );
                  @@DsR4C += 1;
                  eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
                  reade(n) %kds( k1yer4 : 8 ) paher4 @@DsIR4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                k1yer4.r4Rama = peRama;
                k1yer4.r4Arse = peArse;
                setll %kds( k1yer4 : 7 ) paher4;
                if not %equal( paher4 );
                  return *off;
                endif;
                reade(n) %kds( k1yer4 : 7 ) paher4 @@DsIR4;
                dow not %eof( paher4 );
                  @@DsR4C += 1;
                  eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
                  reade(n) %kds( k1yer4 : 7 ) paher4 @@DsIR4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                k1yer4.r4Rama = peRama;
                setll %kds( k1yer4 : 6 ) paher4;
                if not %equal( paher4 );
                  return *off;
                endif;
                reade(n) %kds( k1yer4 : 6 ) paher4 @@DsIR4;
                dow not %eof( paher4 );
                  @@DsR4C += 1;
                  eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
                  reade(n) %kds( k1yer4 : 6 ) paher4 @@DsIR4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peNive ) =  *null;

                k1yer4.r4Sspo = peSspo;
                setll %kds( k1yer4 : 5 ) paher4;
                if not %equal( paher4 );
                  return *off;
                endif;
                reade(n) %kds( k1yer4 : 5 ) paher4 @@DsIR4;
                dow not %eof( paher4 );
                  @@DsR4C += 1;
                  eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
                  reade(n) %kds( k1yer4 : 5 ) paher4 @@DsIR4;
                enddo;
         other;

           setll %kds( k1yer4 : 4 ) paher4;
           if not %equal( paher4 );
             return *off;
           endif;
           reade(n) %kds( k1yer4 : 4 ) paher4 @@DsIR4;
           dow not %eof( paher4 );
             @@DsR4C += 1;
             eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
            reade(n) %kds( k1yer4 : 4 ) paher4 @@DsIR4;
           enddo;
         endsl;
       else;

         setll %kds( k1yer4 : 4 ) paher4;
         if not %equal( paher4 );
           return *off;
         endif;
         reade(n) %kds( k1yer4 : 4 ) paher4 @@DsIR4;
         dow not %eof( paher4 );
           @@DsR4C += 1;
           eval-corr @@DsR4( @@DsR4C ) = @@DsIR4;
           reade(n) %kds( k1yer4 : 4 ) paher4 @@DsIR4;
         enddo;
       endif;

       if %addr( peDsR4 ) <> *null;
         eval-corr peDsR4 = @@DsR4;
       endif;

       if %addr( peDsR4C ) <> *null;
         peDsR4C = @@DsR4C;
       endif;

       return *on;

      /end-free

     P SVPRIV_getDescuentos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setDescuento  : Grabar Descuentos.-                   *
     ?*                                                              *
     ?*     peDsR4   ( input  ) Est. de Descuentos                   *
     ?*                                                              *
     ?* Retorna: *on = Graba / *off = No graba                       *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setDescuento...
     P                 b                   export
     D SVPRIV_setDescuento...
     D                 pi              n
     D   peDsR4                            const likeds( dsPaher4_t )

     D   @@DsOR4       ds                  likerec( p1her4 : *output )

      /free

       SVPRIV_inz();

       if SVPRIV_chkDescuento( peDsR4.r4empr
                             : peDsR4.r4sucu
                             : peDsR4.r4arcd
                             : peDsR4.r4spol
                             : peDsR4.r4sspo
                             : peDsR4.r4rama
                             : peDsR4.r4arse
                             : peDsR4.r4oper
                             : peDsR4.r4poco
                             : peDsR4.r4suop
                             : peDsR4.r4xcob
                             : peDsR4.r4nive );
         return *off;
       endif;

       eval-corr @@DsOR4 = peDsR4;
       monitor;
         write p1heR4 @@DsOR4;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_setDescuento...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltDescuento : Eliminar Descuento.-                   *
     ?*                                                              *
     ?*     peDsR4   ( input  ) Est. de Descuentos                   *
     ?*                                                              *
     ?* Retorna: *on = Elimina / *off = No Elimina                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltDescuento...
     P                 b                   export
     D SVPRIV_dltDescuento...
     D                 pi              n
     D   peDsR4                            const likeds( dsPaher4_t )

     D   k1yer4        ds                  likerec( p1her4 : *key )

      /free

       SVPRIV_inz();

       k1yer4.r4empr = peDsR4.r4empr;
       k1yer4.r4sucu = peDsR4.r4sucu;
       k1yer4.r4arcd = peDsR4.r4arcd;
       k1yer4.r4spol = peDsR4.r4spol;
       k1yer4.r4sspo = peDsR4.r4sspo;
       k1yer4.r4rama = peDsR4.r4rama;
       k1yer4.r4arse = peDsR4.r4arse;
       k1yer4.r4oper = peDsR4.r4oper;
       k1yer4.r4poco = peDsR4.r4poco;
       k1yer4.r4suop = peDsR4.r4suop;
       k1yer4.r4xcob = peDsR4.r4xcob;
       k1yer4.r4nive = peDsR4.r4nive;

       chain %kds( k1yer4 : 12 ) paher4;
       if %found( paher4 );
         delete p1her4;
       endif;

       return *on;

      /end-free

     P SVPRIV_dltDescuento...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkMejora : Validar Mejoras.-                         *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peMejo   ( input  ) Mejoras                   (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkMejora...
     P                 b                   export
     D SVPRIV_chkMejora...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peMejo                       4  0 options( *nopass : *omit ) const

     D   k1yer5        ds                  likerec( p1her5 : *key )

      /free

       SVPRIV_inz();

       k1yer5.r5empr = peEmpr;
       k1yer5.r5sucu = peSucu;
       k1yer5.r5arcd = peArcd;
       k1yer5.r5spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peMejo ) <> *null;

                k1yer5.r5sspo = peSspo;
                k1yer5.r5rama = peRama;
                k1yer5.r5arse = peArse;
                k1yer5.r5oper = peOper;
                k1yer5.r5poco = pePoco;
                k1yer5.r5suop = peSuop;
                k1yer5.r5mejo = peMejo;
                setll %kds( k1yer5 : 11 ) paher5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5sspo = peSspo;
                k1yer5.r5rama = peRama;
                k1yer5.r5arse = peArse;
                k1yer5.r5oper = peOper;
                k1yer5.r5poco = pePoco;
                k1yer5.r5suop = peSuop;
                setll %kds( k1yer5 : 10 ) paher5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                k1yer5.r5Rama = peRama;
                k1yer5.r5Arse = peArse;
                k1yer5.r5Oper = peOper;
                k1yer5.r5Poco = pePoco;
                setll %kds( k1yer5 : 9 ) paher5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                k1yer5.r5Rama = peRama;
                k1yer5.r5Arse = peArse;
                k1yer5.r5Oper = peOper;
                setll %kds( k1yer5 : 8 ) paher5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                k1yer5.r5Rama = peRama;
                k1yer5.r5Arse = peArse;
                setll %kds( k1yer5 : 7 ) paher5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                k1yer5.r5Rama = peRama;
                setll %kds( k1yer5 : 6 ) paher5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                setll %kds( k1yer5 : 5 ) paher5;
         other;

           setll %kds( k1yer5 : 4 ) paher5;
         endsl;
       else;

         setll %kds( k1yer5 : 4 ) paher5;
       endif;

       return %equal();

      /end-free

     P SVPRIV_chkMejora...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getMejoras: Retorna Mejoras.-                         *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peMejo   ( input  ) Mejoras                   (opcional) *
     ?*     peDsr5   ( output ) Est. de Mejoras           (opcional) *
     ?*     peDsr5C  ( output ) Cantidad de Mejoras       (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getMejoras...
     P                 b                   export
     D SVPRIV_getMejoras...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peMejo                       4  0 options( *nopass : *omit ) const
     D   peDsR5                            likeds( dsPaher5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR5C                     10i 0 options( *nopass : *omit )

     D   k1yer5        ds                  likerec( p1her5 : *key   )
     D   @@DsIR5       ds                  likerec( p1her5 : *input )
     D   @@DsR5        ds                  likeds( dsPaher5_t ) dim( 999 )
     D   @@DsR5C       s             10i 0

      /free

       SVPRIV_inz();

       k1yer5.r5empr = peEmpr;
       k1yer5.r5sucu = peSucu;
       k1yer5.r5arcd = peArcd;
       k1yer5.r5spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peMejo ) <> *null;

                k1yer5.r5sspo = peSspo;
                k1yer5.r5rama = peRama;
                k1yer5.r5arse = peArse;
                k1yer5.r5oper = peOper;
                k1yer5.r5poco = pePoco;
                k1yer5.r5suop = peSuop;
                k1yer5.r5mejo = peMejo;
                setll %kds( k1yer5 : 11 ) paher5;
                if not %equal( paher5 );
                  return *off;
                endif;
                reade(n) %kds( k1yer5 : 11 ) paher5 @@DsIR5;
                dow not %eof( paher5 );
                  @@DsR5C +=1;
                  eval-corr @@DsR5( @@DsR5C ) = @@DsIR5;
                 reade(n) %kds( k1yer5 : 11 ) paher5 @@DsIR5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5sspo = peSspo;
                k1yer5.r5rama = peRama;
                k1yer5.r5arse = peArse;
                k1yer5.r5oper = peOper;
                k1yer5.r5poco = pePoco;
                k1yer5.r5suop = peSuop;
                setll %kds( k1yer5 : 10 ) paher5;
                if not %equal( paher5 );
                  return *off;
                endif;
                reade(n) %kds( k1yer5 : 10 ) paher5 @@DsIR5;
                dow not %eof( paher5 );
                  @@DsR5C +=1;
                  eval-corr @@DsR5( @@DsR5C ) = @@DsIR5;
                 reade(n) %kds( k1yer5 : 10 ) paher5 @@DsIR5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                k1yer5.r5Rama = peRama;
                k1yer5.r5Arse = peArse;
                k1yer5.r5Oper = peOper;
                k1yer5.r5Poco = pePoco;
                setll %kds( k1yer5 : 9 ) paher5;
                if not %equal( paher5 );
                  return *off;
                endif;
                reade(n) %kds( k1yer5 : 9 ) paher5 @@DsIR5;
                dow not %eof( paher5 );
                  @@DsR5C +=1;
                  eval-corr @@DsR5( @@DsR5C ) = @@DsIR5;
                 reade(n) %kds( k1yer5 : 9 ) paher5 @@DsIR5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                k1yer5.r5Rama = peRama;
                k1yer5.r5Arse = peArse;
                k1yer5.r5Oper = peOper;
                setll %kds( k1yer5 : 8 ) paher5;
                if not %equal( paher5 );
                  return *off;
                endif;
                reade(n) %kds( k1yer5 : 8 ) paher5 @@DsIR5;
                dow not %eof( paher5 );
                  @@DsR5C +=1;
                  eval-corr @@DsR5( @@DsR5C ) = @@DsIR5;
                 reade(n) %kds( k1yer5 : 8 ) paher5 @@DsIR5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                k1yer5.r5Rama = peRama;
                k1yer5.r5Arse = peArse;
                setll %kds( k1yer5 : 7 ) paher5;
                if not %equal( paher5 );
                  return *off;
                endif;
                reade(n) %kds( k1yer5 : 7 ) paher5 @@DsIR5;
                dow not %eof( paher5 );
                  @@DsR5C +=1;
                  eval-corr @@DsR5( @@DsR5C ) = @@DsIR5;
                 reade(n) %kds( k1yer5 : 7 ) paher5 @@DsIR5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                k1yer5.r5Rama = peRama;
                setll %kds( k1yer5 : 6 ) paher5;
                if not %equal( paher5 );
                  return *off;
                endif;
                reade(n) %kds( k1yer5 : 6 ) paher5 @@DsIR5;
                dow not %eof( paher5 );
                  @@DsR5C +=1;
                  eval-corr @@DsR5( @@DsR5C ) = @@DsIR5;
                 reade(n) %kds( k1yer5 : 6 ) paher5 @@DsIR5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peMejo ) =  *null;

                k1yer5.r5Sspo = peSspo;
                setll %kds( k1yer5 : 5 ) paher5;
                if not %equal( paher5 );
                  return *off;
                endif;
                reade(n) %kds( k1yer5 : 5 ) paher5 @@DsIR5;
                dow not %eof( paher5 );
                  @@DsR5C +=1;
                  eval-corr @@DsR5( @@DsR5C ) = @@DsIR5;
                 reade(n) %kds( k1yer5 : 5 ) paher5 @@DsIR5;
                enddo;
         other;

           setll %kds( k1yer5 : 4 ) paher5;
           if not %equal( paher5 );
             return *off;
           endif;
           reade(n) %kds( k1yer5 : 4 ) paher5 @@DsIR5;
           dow not %eof( paher5 );
             @@DsR5C +=1;
             eval-corr @@DsR5( @@DsR5C ) = @@DsIR5;
            reade(n) %kds( k1yer5 : 4 ) paher5 @@DsIR5;
           enddo;
         endsl;
       else;

         setll %kds( k1yer5 : 4 ) paher5;
         if not %equal( paher5 );
           return *off;
         endif;
         reade(n) %kds( k1yer5 : 4 ) paher5 @@DsIR5;
         dow not %eof( paher5 );
           @@DsR5C +=1;
           eval-corr @@DsR5( @@DsR5C ) = @@DsIR5;
          reade(n) %kds( k1yer5 : 4 ) paher5 @@DsIR5;
         enddo;
       endif;

       if %addr( peDsR5 ) <> *null;
         eval-corr peDsR5 = @@DsR5;
       endif;

       if %addr( peDsR5C ) <> *null;
         peDsR5C = @@DsR5C;
       endif;

       return *on;

      /end-free

     P SVPRIV_getMejoras...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setMejora : Graba Mejoras.-                           *
     ?*                                                              *
     ?*     peDsr5   ( input  ) Est. de Mejoras                      *
     ?*                                                              *
     ?* Retorna: *on = Graba / *off = No Graba                       *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setMejora...
     P                 b                   export
     D SVPRIV_setMejora...
     D                 pi              n
     D   peDsR5                            const likeds( dsPaher5_t )

     D   @@DsOR5       ds                  likerec( p1her5 : *output )

      /free

       SVPRIV_inz();

       if SVPRIV_chkMejora( peDsR5.r5empr
                          : peDsR5.r5sucu
                          : peDsR5.r5arcd
                          : peDsR5.r5spol
                          : peDsR5.r5sspo
                          : peDsR5.r5rama
                          : peDsR5.r5arse
                          : peDsR5.r5oper
                          : peDsR5.r5poco
                          : peDsR5.r5suop
                          : peDsR5.r5mejo );
         return *off;
       endif;

       eval-corr @@DsOR5 = peDsR5;
       monitor;
         write p1heR5 @@DsOR5;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_setMejora...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltMejora : Elimina Mejora.-                          *
     ?*                                                              *
     ?*     peDsr5   ( input  ) Est. de Mejoras                      *
     ?*                                                              *
     ?* Retorna: *on = Elimino / *off = No Elimino                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltMejora...
     P                 b                   export
     D SVPRIV_dltMejora...
     D                 pi              n
     D   peDsR5                            const likeds( dsPaher5_t )

     D   k1yer5        ds                  likerec( p1her5 : *key   )

      /free

       SVPRIV_inz();

        k1yer5.r5empr = peDsR5.r5empr;
        k1yer5.r5sucu = peDsR5.r5sucu;
        k1yer5.r5arcd = peDsR5.r5arcd;
        k1yer5.r5spol = peDsR5.r5spol;
        k1yer5.r5sspo = peDsR5.r5sspo;
        k1yer5.r5rama = peDsR5.r5rama;
        k1yer5.r5arse = peDsR5.r5arse;
        k1yer5.r5oper = peDsR5.r5oper;
        k1yer5.r5poco = peDsR5.r5poco;
        k1yer5.r5suop = peDsR5.r5suop;
        k1yer5.r5mejo = peDsR5.r5mejo;
        chain %kds( k1yer5 : 11 ) paher5;
        if %found( paher5 );
          delete p1her5;
        endif;

       return *on;
      /end-free

     P SVPRIV_dltMejora...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkCaracteristica : Validar Caracteristica.-          *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peCcba   ( input  ) Caracteristica            (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkCaracteristica...
     P                 b                   export
     D SVPRIV_chkCaracteristica...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peCcba                       3  0 options( *nopass : *omit ) const

     D   k1yer6        ds                  likerec( p1her6 : *key )

      /free

       SVPRIV_inz();

       k1yer6.r6empr = peEmpr;
       k1yer6.r6sucu = peSucu;
       k1yer6.r6arcd = peArcd;
       k1yer6.r6spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peCcba ) <> *null;

                k1yer6.r6sspo = peSspo;
                k1yer6.r6rama = peRama;
                k1yer6.r6arse = peArse;
                k1yer6.r6oper = peOper;
                k1yer6.r6poco = pePoco;
                k1yer6.r6suop = peSuop;
                k1yer6.r6ccba = peCcba;
                setll %kds( k1yer6 : 11 ) paher6;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6sspo = peSspo;
                k1yer6.r6rama = peRama;
                k1yer6.r6arse = peArse;
                k1yer6.r6oper = peOper;
                k1yer6.r6poco = pePoco;
                k1yer6.r6suop = peSuop;
                setll %kds( k1yer6 : 10 ) paher6;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                k1yer6.r6Rama = peRama;
                k1yer6.r6Arse = peArse;
                k1yer6.r6Oper = peOper;
                k1yer6.r6Poco = pePoco;
                setll %kds( k1yer6 : 9 ) paher6;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                k1yer6.r6Rama = peRama;
                k1yer6.r6Arse = peArse;
                k1yer6.r6Oper = peOper;
                setll %kds( k1yer6 : 8 ) paher6;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                k1yer6.r6Rama = peRama;
                k1yer6.r6Arse = peArse;
                setll %kds( k1yer6 : 7 ) paher6;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                k1yer6.r6Rama = peRama;
                setll %kds( k1yer6 : 6 ) paher6;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                setll %kds( k1yer6 : 5 ) paher6;
         other;

           setll %kds( k1yer6 : 4 ) paher6;
         endsl;
       else;

         setll %kds( k1yer6 : 4 ) paher6;
       endif;

       return %equal();

     P SVPRIV_chkCaracteristica...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getCaracteristicas: Retorna Caracteristica.-          *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peCcba   ( input  ) Caracteristica            (opcional) *
     ?*     peDsR6   ( output ) Est. Caracteristica       (opcional) *
     ?*     peDsr6C  ( output ) Cant. Caracteristica      (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getCaracteristicas...
     P                 b                   export
     D SVPRIV_getCaracteristicas...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peCcba                       3  0 options( *nopass : *omit ) const
     D   peDsR6                            likeds( dsPaher6_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR6C                     10i 0 options( *nopass : *omit )

     D   k1yer6        ds                  likerec( p1her6 : *key )
     D   @@DsIR6       ds                  likerec( p1her6 : *input )
     D   @@DsR6        ds                  likeds( dsPaher6_t ) dim( 999 )
     D   @@DsR6C       s             10i 0

      /free

       SVPRIV_inz();

       k1yer6.r6empr = peEmpr;
       k1yer6.r6sucu = peSucu;
       k1yer6.r6arcd = peArcd;
       k1yer6.r6spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peCcba ) <> *null;

                k1yer6.r6sspo = peSspo;
                k1yer6.r6rama = peRama;
                k1yer6.r6arse = peArse;
                k1yer6.r6oper = peOper;
                k1yer6.r6poco = pePoco;
                k1yer6.r6suop = peSuop;
                k1yer6.r6ccba = peCcba;
                setll %kds( k1yer6 : 11 ) paher6;
                if not %equal( paher6 );
                  return *off;
                endif;
                reade(n) %kds( k1yer6 : 11 ) paher6 @@DsIR6;
                dow not %eof( paher6 );
                  @@DsR6C += 1;
                  eval-corr @@DsR6( @@DsR6C ) = @@DsIr6;
                 reade(n) %kds( k1yer6 : 11 ) paher6 @@DsIR6;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6sspo = peSspo;
                k1yer6.r6rama = peRama;
                k1yer6.r6arse = peArse;
                k1yer6.r6oper = peOper;
                k1yer6.r6poco = pePoco;
                k1yer6.r6suop = peSuop;
                setll %kds( k1yer6 : 10 ) paher6;
                if not %equal( paher6 );
                  return *off;
                endif;
                reade(n) %kds( k1yer6 : 10 ) paher6 @@DsIR6;
                dow not %eof( paher6 );
                  @@DsR6C += 1;
                  eval-corr @@DsR6( @@DsR6C ) = @@DsIr6;
                 reade(n) %kds( k1yer6 : 10 ) paher6 @@DsIR6;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                k1yer6.r6Rama = peRama;
                k1yer6.r6Arse = peArse;
                k1yer6.r6Oper = peOper;
                k1yer6.r6Poco = pePoco;
                setll %kds( k1yer6 : 9 ) paher6;
                if not %equal( paher6 );
                  return *off;
                endif;
                reade(n) %kds( k1yer6 : 9 ) paher6 @@DsIR6;
                dow not %eof( paher6 );
                  @@DsR6C += 1;
                  eval-corr @@DsR6( @@DsR6C ) = @@DsIr6;
                 reade(n) %kds( k1yer6 : 9 ) paher6 @@DsIR6;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                k1yer6.r6Rama = peRama;
                k1yer6.r6Arse = peArse;
                k1yer6.r6Oper = peOper;
                setll %kds( k1yer6 : 8 ) paher6;
                if not %equal( paher6 );
                  return *off;
                endif;
                reade(n) %kds( k1yer6 : 8 ) paher6 @@DsIR6;
                dow not %eof( paher6 );
                  @@DsR6C += 1;
                  eval-corr @@DsR6( @@DsR6C ) = @@DsIr6;
                 reade(n) %kds( k1yer6 : 8 ) paher6 @@DsIR6;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                k1yer6.r6Rama = peRama;
                k1yer6.r6Arse = peArse;
                setll %kds( k1yer6 : 7 ) paher6;
                if not %equal( paher6 );
                  return *off;
                endif;
                reade(n) %kds( k1yer6 : 7 ) paher6 @@DsIR6;
                dow not %eof( paher6 );
                  @@DsR6C += 1;
                  eval-corr @@DsR6( @@DsR6C ) = @@DsIr6;
                 reade(n) %kds( k1yer6 : 7 ) paher6 @@DsIR6;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                k1yer6.r6Rama = peRama;
                setll %kds( k1yer6 : 6 ) paher6;
                if not %equal( paher6 );
                  return *off;
                endif;
                reade(n) %kds( k1yer6 : 6 ) paher6 @@DsIR6;
                dow not %eof( paher6 );
                  @@DsR6C += 1;
                  eval-corr @@DsR6( @@DsR6C ) = @@DsIr6;
                 reade(n) %kds( k1yer6 : 6 ) paher6 @@DsIR6;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peCcba ) =  *null;

                k1yer6.r6Sspo = peSspo;
                setll %kds( k1yer6 : 5 ) paher6;
                if not %equal( paher6 );
                  return *off;
                endif;
                reade(n) %kds( k1yer6 : 5 ) paher6 @@DsIR6;
                dow not %eof( paher6 );
                  @@DsR6C += 1;
                  eval-corr @@DsR6( @@DsR6C ) = @@DsIr6;
                 reade(n) %kds( k1yer6 : 5 ) paher6 @@DsIR6;
                enddo;
         other;

           setll %kds( k1yer6 : 4 ) paher6;
           if not %equal( paher6 );
             return *off;
           endif;
           reade(n) %kds( k1yer6 : 4 ) paher6 @@DsIR6;
           dow not %eof( paher6 );
             @@DsR6C += 1;
             eval-corr @@DsR6( @@DsR6C ) = @@DsIr6;
            reade(n) %kds( k1yer6 : 4 ) paher6 @@DsIR6;
           enddo;
         endsl;
       else;

         setll %kds( k1yer6 : 4 ) paher6;
         if not %equal( paher6 );
           return *off;
         endif;
         reade(n) %kds( k1yer6 : 4 ) paher6 @@DsIR6;
         dow not %eof( paher6 );
           @@DsR6C += 1;
           eval-corr @@DsR6( @@DsR6C ) = @@DsIr6;
          reade(n) %kds( k1yer6 : 4 ) paher6 @@DsIR6;
         enddo;
       endif;

       if %addr( peDsR6 ) <> *null;
          eval-corr peDsr6 = @@DsR6;
       endif;

       if %addr( peDsR6C ) <> *null;
         peDsr6C = @@DsR6C;
       endif;

       return *on;

      /end-free

     P SVPRIV_getCaracteristicas...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setCaracteristica : Graba Caracteristica.-            *
     ?*                                                              *
     ?*     peDsr6   ( input  ) Est. de Caracteristicas              *
     ?*                                                              *
     ?* Retorna: *on = Graba / *off = No Graba                       *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setCaracteristica...
     P                 b                   export
     D SVPRIV_setCaracteristica...
     D                 pi              n
     D   peDsR6                            const likeds( dsPaher6_t )

     D   @@DsOR6       ds                  likerec( p1her6 : *output )

       /free

       SVPRIV_inz();

        if SVPRIV_chkCaracteristica( peDsR6.r6empr
                                   : peDsR6.r6sucu
                                   : peDsR6.r6arcd
                                   : peDsR6.r6spol
                                   : peDsR6.r6sspo
                                   : peDsR6.r6rama
                                   : peDsR6.r6arse
                                   : peDsR6.r6oper
                                   : peDsR6.r6poco
                                   : peDsR6.r6suop
                                   : peDsR6.r6ccba );
          return *off;
        endif;

        eval-corr @@DsOR6 = peDsR6;
        monitor;
          write p1heR6 @@DsOR6;
        on-error;
          return *off;
        endmon;

        return *on;

       /end-free

     P SVPRIV_setCaracteristica...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltCaracteristica : Elimina Caracteristica.-          *
     ?*                                                              *
     ?*     peDsr6   ( input  ) Est. de Caracteristica.-             *
     ?*                                                              *
     ?* Retorna: *on = Elimino / *off = No Elimino                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltCaracteristica...
     P                 b                   export
     D SVPRIV_dltCaracteristica...
     D                 pi              n
     D   peDsR6                            const likeds( dsPaher6_t )

     D   k1yer6        ds                  likerec( p1her6 : *key )

       /free

       SVPRIV_inz();

        k1yer6.r6empr = peDsR6.r6empr;
        k1yer6.r6sucu = peDsR6.r6sucu;
        k1yer6.r6arcd = peDsR6.r6arcd;
        k1yer6.r6spol = peDsR6.r6spol;
        k1yer6.r6sspo = peDsR6.r6sspo;
        k1yer6.r6rama = peDsR6.r6rama;
        k1yer6.r6arse = peDsR6.r6arse;
        k1yer6.r6oper = peDsR6.r6oper;
        k1yer6.r6poco = peDsR6.r6poco;
        k1yer6.r6suop = peDsR6.r6suop;
        k1yer6.r6ccba = peDsR6.r6ccba;
        chain %kds( k1yer6 : 11 ) paher6;
        if %found( paher6 );
          delete p1her6;
        endif;


       return *on;

       /end-free

     P SVPRIV_dltCaracteristica...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkObjeto : Validar Objetos.-                         *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peOsec   ( input  ) Objeto                    (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkObjeto...
     P                 b                   export
     D SVPRIV_chkObjeto...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peOsec                       9  0 options( *nopass : *omit ) const

     D   k1yer7        ds                  likerec( p1her7 : *key   )

      /free

       SVPRIV_inz();

       k1yer7.r7empr = peEmpr;
       k1yer7.r7sucu = peSucu;
       k1yer7.r7arcd = peArcd;
       k1yer7.r7spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peOsec ) <> *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                k1yer7.r7suop = peSuop;
                k1yer7.r7riec = peRiec;
                k1yer7.r7xcob = peXcob;
                k1yer7.r7osec = peOsec;
                setll %kds( k1yer7 : 13 ) paher7;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                k1yer7.r7suop = peSuop;
                k1yer7.r7riec = peRiec;
                k1yer7.r7xcob = peXcob;
                setll %kds( k1yer7 : 12 ) paher7;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                k1yer7.r7suop = peSuop;
                k1yer7.r7riec = peRiec;
                setll %kds( k1yer7 : 11 ) paher7;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                k1yer7.r7suop = peSuop;
                setll %kds( k1yer7 : 10 ) paher7;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                setll %kds( k1yer7 : 9 ) paher7;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                setll %kds( k1yer7 : 8 ) paher7;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                setll %kds( k1yer7 : 7 ) paher7;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                setll %kds( k1yer7 : 6 ) paher7;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                setll %kds( k1yer7 : 5 ) paher7;

           other;

             setll %kds( k1yer7 : 4 ) paher7;
         endsl;
       else;

         setll %kds( k1yer7 : 4 ) paher7;

       endif;

       return %equal();

      /end-free

     P SVPRIV_chkObjeto...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getObjetos: Retorna Objetos.-                         *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peOsec   ( input  ) Objeto                    (opcional) *
     ?*     peDsr7   ( input  ) Est. de Objetos           (opcional) *
     ?*     peDsr7C  ( input  ) Cantidad de Objetos       (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getObjetos...
     P                 b                   export
     D SVPRIV_getObjetos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peOsec                       9  0 options( *nopass : *omit ) const
     D   peDsR7                            likeds( dsPaher7_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR7C                     10i 0 options( *nopass : *omit )

     D   k1yer7        ds                  likerec( p1her7 : *key   )
     D   @@DsIR7       ds                  likerec( p1her7 : *input )
     D   @@DsR7        ds                  likeds( dsPaher7_t ) dim( 999 )
     D   @@DsR7C       s             10i 0

      /free

       SVPRIV_inz();

       k1yer7.r7empr = peEmpr;
       k1yer7.r7sucu = peSucu;
       k1yer7.r7arcd = peArcd;
       k1yer7.r7spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peOsec ) <> *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                k1yer7.r7suop = peSuop;
                k1yer7.r7riec = peRiec;
                k1yer7.r7xcob = peXcob;
                k1yer7.r7osec = peOsec;
                setll %kds( k1yer7 : 13 ) paher7;
                if not %equal( paher7 );
                  return *off;
                endif;
                reade(n) %kds( k1yer7 : 13 ) paher7 @@DsIR7;
                dow not %eof( paher7 );
                  @@DsR7C += 1;
                  eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
                 reade(n) %kds( k1yer7 : 13 ) paher7 @@DsIR7;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                k1yer7.r7suop = peSuop;
                k1yer7.r7riec = peRiec;
                k1yer7.r7xcob = peXcob;
                setll %kds( k1yer7 : 12 ) paher7;
                if not %equal( paher7 );
                  return *off;
                endif;
                reade(n) %kds( k1yer7 : 12 ) paher7 @@DsIR7;
                dow not %eof( paher7 );
                  @@DsR7C += 1;
                  eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
                 reade(n) %kds( k1yer7 : 12 ) paher7 @@DsIR7;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                k1yer7.r7suop = peSuop;
                k1yer7.r7riec = peRiec;
                setll %kds( k1yer7 : 11 ) paher7;
                if not %equal( paher7 );
                  return *off;
                endif;
                reade(n) %kds( k1yer7 : 11 ) paher7 @@DsIR7;
                dow not %eof( paher7 );
                  @@DsR7C += 1;
                  eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
                 reade(n) %kds( k1yer7 : 11 ) paher7 @@DsIR7;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                k1yer7.r7suop = peSuop;
                setll %kds( k1yer7 : 10 ) paher7;
                if not %equal( paher7 );
                  return *off;
                endif;
                reade(n) %kds( k1yer7 : 10 ) paher7 @@DsIR7;
                dow not %eof( paher7 );
                  @@DsR7C += 1;
                  eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
                 reade(n) %kds( k1yer7 : 10 ) paher7 @@DsIR7;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                k1yer7.r7poco = pePoco;
                setll %kds( k1yer7 : 9 ) paher7;
                if not %equal( paher7 );
                  return *off;
                endif;
                reade(n) %kds( k1yer7 : 9 ) paher7 @@DsIR7;
                dow not %eof( paher7 );
                  @@DsR7C += 1;
                  eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
                 reade(n) %kds( k1yer7 : 9 ) paher7 @@DsIR7;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                k1yer7.r7oper = peOper;
                setll %kds( k1yer7 : 8 ) paher7;
                if not %equal( paher7 );
                  return *off;
                endif;
                reade(n) %kds( k1yer7 : 8 ) paher7 @@DsIR7;
                dow not %eof( paher7 );
                  @@DsR7C += 1;
                  eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
                 reade(n) %kds( k1yer7 : 8 ) paher7 @@DsIR7;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                k1yer7.r7arse = peArse;
                setll %kds( k1yer7 : 7 ) paher7;
                if not %equal( paher7 );
                  return *off;
                endif;
                reade(n) %kds( k1yer7 : 7 ) paher7 @@DsIR7;
                dow not %eof( paher7 );
                  @@DsR7C += 1;
                  eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
                 reade(n) %kds( k1yer7 : 7 ) paher7 @@DsIR7;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                k1yer7.r7rama = peRama;
                setll %kds( k1yer7 : 6 ) paher7;
                if not %equal( paher7 );
                  return *off;
                endif;
                reade(n) %kds( k1yer7 : 6 ) paher7 @@DsIR7;
                dow not %eof( paher7 );
                  @@DsR7C += 1;
                  eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
                 reade(n) %kds( k1yer7 : 6 ) paher7 @@DsIR7;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                k1yer7.r7sspo = peSspo;
                setll %kds( k1yer7 : 5 ) paher7;
                if not %equal( paher7 );
                  return *off;
                endif;
                reade(n) %kds( k1yer7 : 5 ) paher7 @@DsIR7;
                dow not %eof( paher7 );
                  @@DsR7C += 1;
                  eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
                 reade(n) %kds( k1yer7 : 5 ) paher7 @@DsIR7;
                enddo;

           other;

             setll %kds( k1yer7 : 4 ) paher7;
             if not %equal( paher7 );
               return *off;
             endif;
             reade(n) %kds( k1yer7 : 4 ) paher7 @@DsIR7;
             dow not %eof( paher7 );
               @@DsR7C += 1;
               eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
              reade(n) %kds( k1yer7 : 4 ) paher7 @@DsIR7;
             enddo;
         endsl;
       else;

         setll %kds( k1yer7 : 4 ) paher7;
         if not %equal( paher7 );
           return *off;
         endif;
         reade(n) %kds( k1yer7 : 4 ) paher7 @@DsIR7;
         dow not %eof( paher7 );
           @@DsR7C += 1;
           eval-corr @@Dsr7( @@Dsr7C ) = @@DsIr7;
          reade(n) %kds( k1yer7 : 4 ) paher7 @@DsIR7;
         enddo;
       endif;

       if %addr( peDsR7 ) <> *null;
         eval-corr peDsR7 = @@DsR7;
       endif;

       if %addr( peDsR7C ) <> *null;
         eval peDsR7C = @@DsR7C;
       endif;

       return *on;
      /end-free

     P SVPRIV_getObjetos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setObjeto : Graba Objetos.-                           *
     ?*                                                              *
     ?*     peDsr7   ( input  ) Est. de Objetos                      *
     ?*                                                              *
     ?* Retorna: *on = Graba / *off = No Graba                       *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setObjeto...
     P                 b                   export
     D SVPRIV_setObjeto...
     D                 pi              n
     D   peDsR7                            const likeds( dsPaher7_t )

     D   @@DsOR7       ds                  likerec( p1her7 : *output )

      /free

       SVPRIV_inz();

        if SVPRIV_chkObjeto( peDsR7.r7empr
                           : peDsR7.r7sucu
                           : peDsR7.r7arcd
                           : peDsR7.r7spol
                           : peDsR7.r7sspo
                           : peDsR7.r7rama
                           : peDsR7.r7arse
                           : peDsR7.r7oper
                           : peDsR7.r7poco
                           : peDsR7.r7suop
                           : peDsR7.r7riec
                           : peDsR7.r7xcob
                           : peDsR7.r7osec );
          return *off;
        endif;

       eval-corr @@DsOR7 = peDsR7;
       monitor;
         write p1heR7 @@DsOR7;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_setObjeto...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltObjeto : Elimina Objeto.-                          *
     ?*                                                              *
     ?*     peDsr7   ( input  ) Est. de Objetos                      *
     ?*                                                              *
     ?* Retorna: *on = Elimino / *off = No Elimino                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltObjeto...
     P                 b                   export
     D SVPRIV_dltObjeto...
     D                 pi              n
     D   peDsR7                            const likeds( dsPaher7_t )

     D   k1yer7        ds                  likerec( p1her7 : *key )

      /free

       SVPRIV_inz();

        k1yer7.r7empr = peDsR7.r7empr;
        k1yer7.r7sucu = peDsR7.r7sucu;
        k1yer7.r7arcd = peDsR7.r7arcd;
        k1yer7.r7spol = peDsR7.r7spol;
        k1yer7.r7sspo = peDsR7.r7sspo;
        k1yer7.r7rama = peDsR7.r7rama;
        k1yer7.r7arse = peDsR7.r7arse;
        k1yer7.r7oper = peDsR7.r7oper;
        k1yer7.r7poco = peDsR7.r7poco;
        k1yer7.r7suop = peDsR7.r7suop;
        k1yer7.r7riec = peDsR7.r7riec;
        k1yer7.r7xcob = peDsR7.r7xcob;
        k1yer7.r7osec = peDsR7.r7osec;
        chain %kds( k1yer7 : 13 ) paher7;
        if %found( paher7 );
          delete p1her7;
        endif;

        return *on;
      /end-free

     P SVPRIV_dltObjeto...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltObjetos: Elimina Objetos.-                         *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) superPoliza                          *
     ?*     peSspo   ( input  ) Suplemento Superpoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peXcob   ( input  ) Coberturas                (opcional) *
     ?*     peOsec   ( input  ) Objeto                    (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si elimino / *off = No elimino                *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltObjetos...
     P                 b                   export
     D SVPRIV_dltObjetos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peXcob                       3  0 options( *nopass : *omit ) const
     D   peOsec                       9  0 options( *nopass : *omit ) const

     D   @@DsR7        ds                  likeds( dsPaher7_t ) dim( 999 )
     D   @@DsR7C       s             10i 0
     D   x             s             10i 0
     D   rc            s               n

      /free

       SVPRIV_inz();

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peOsec ) <> *null    ;

                if not SVPRIV_getObjetos( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : peRama
                                        : peArse
                                        : peOper
                                        : pePoco
                                        : peSuop
                                        : peRiec
                                        : peXcob
                                        : peOsec
                                        : @@DsR7
                                        : @@DsR7c );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) <> *null and
                %addr( peOsec ) =  *null    ;

                if not SVPRIV_getObjetos( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : peRama
                                        : peArse
                                        : peOper
                                        : pePoco
                                        : peSuop
                                        : peRiec
                                        : peXcob
                                        : *omit
                                        : @@DsR7
                                        : @@DsR7c );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                if not SVPRIV_getObjetos( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : peRama
                                        : peArse
                                        : peOper
                                        : pePoco
                                        : peSuop
                                        : peRiec
                                        : *omit
                                        : *omit
                                        : @@DsR7
                                        : @@DsR7c );
                  return *off;
                endif;


           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                if not SVPRIV_getObjetos( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : peRama
                                        : peArse
                                        : peOper
                                        : pePoco
                                        : peSuop
                                        : *omit
                                        : *omit
                                        : *omit
                                        : @@DsR7
                                        : @@DsR7c );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                if not SVPRIV_getObjetos( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : peRama
                                        : peArse
                                        : peOper
                                        : pePoco
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : @@DsR7
                                        : @@DsR7c );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                if not SVPRIV_getObjetos( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : peRama
                                        : peArse
                                        : peOper
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : @@DsR7
                                        : @@DsR7c );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                if not SVPRIV_getObjetos( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : peRama
                                        : peArse
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : @@DsR7
                                        : @@DsR7c );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                if not SVPRIV_getObjetos( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : peRama
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : @@DsR7
                                        : @@DsR7c );
                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peXcob ) =  *null and
                %addr( peOsec ) =  *null    ;

                if not SVPRIV_getObjetos( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : @@DsR7
                                        : @@DsR7c );
                  return *off;
                endif;

           other;

             if not SVPRIV_getObjetos( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : @@DsR7
                                     : @@DsR7c );
               return *off;
             endif;

         endsl;
       else;

         if not SVPRIV_getObjetos( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : *omit
                                 : @@DsR7
                                 : @@DsR7c );
           return *off;
         endif;
       endif;

       for x = 1 to @@Dsr7C;

         rc = SVPRIV_dltObjeto( @@DsR7( @@DsR7C ) );

       endfor;

       return *on;

     P SVPRIV_dltObjetos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkFranquicia : Validar Franquicias.-                 *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peXpro   ( input  ) Producto                  (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peCobc   ( input  ) Cobertura                 (opcional) *
     ?*     peMone   ( input  ) Moneda                    (opcional) *
     ?*     peSaha   ( input  ) Franquicia                (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkFranquicia...
     P                 b                   export
     D SVPRIV_chkFranquicia...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peXpro                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peCobc                       3  0 options( *nopass : *omit ) const
     D   peMone                       2    options( *nopass : *omit ) const
     D   peSaha                      15  2 options( *nopass : *omit ) const

     D   k1yer8        ds                  likerec( p1her8 : *key   )

      /free

       SVPRIV_inz();

       k1yer8.r8empr = peEmpr;
       k1yer8.r8sucu = peSucu;
       k1yer8.r8arcd = peArcd;
       k1yer8.r8spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) <> *null and
                %addr( peMone ) <> *null and
                %addr( peSaha ) <> *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                k1yer8.r8riec = peRiec;
                k1yer8.r8cobc = peCobc;
                k1yer8.r8mone = peMone;
                k1yer8.r8saha = peSaha;
                setll %kds( k1yer8 : 15 ) paher8;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) <> *null and
                %addr( peMone ) <> *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                k1yer8.r8riec = peRiec;
                k1yer8.r8cobc = peCobc;
                k1yer8.r8mone = peMone;
                setll %kds( k1yer8 : 14 ) paher8;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) <> *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                k1yer8.r8riec = peRiec;
                k1yer8.r8cobc = peCobc;
                setll %kds( k1yer8 : 13 ) paher8;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                k1yer8.r8riec = peRiec;
                setll %kds( k1yer8 : 12 ) paher8;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                setll %kds( k1yer8 : 11 ) paher8;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                setll %kds( k1yer8 : 9 ) paher8;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                setll %kds( k1yer8 : 8 ) paher8;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                setll %kds( k1yer8 : 7 ) paher8;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                setll %kds( k1yer8 : 6 ) paher8;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                setll %kds( k1yer8 : 5 ) paher8;

           other;

             setll %kds( k1yer8 : 4 ) paher8;
         endsl;
       else;

         setll %kds( k1yer8 : 4 ) paher8;

       endif;

       return %equal();
      /end-free

     P SVPRIV_chkFranquicia...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getFranquicias: Retorna Franquicias.-                 *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento SuperPoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peXpro   ( input  ) Producto                  (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peCobc   ( input  ) Cobertura                 (opcional) *
     ?*     peMone   ( input  ) Moneda                    (opcional) *
     ?*     peSaha   ( input  ) Franquicia                (opcional) *
     ?*     peDsR8   ( output ) Est. de Franquicia        (opcional) *
     ?*     peDsR8C  ( output ) Cant. de Franquicia       (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getFranquicias...
     P                 b                   export
     D SVPRIV_getFranquicias...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peXpro                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peCobc                       3  0 options( *nopass : *omit ) const
     D   peMone                       2    options( *nopass : *omit ) const
     D   peSaha                      15  2 options( *nopass : *omit ) const
     D   peDsR8                            likeds( dsPaher8_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR8C                     10i 0 options( *nopass : *omit )

     D   k1yer8        ds                  likerec( p1her8 : *key   )
     D   @@DsIR8       ds                  likerec( p1her8 : *input )
     D   @@DsR8        ds                  likeds( dsPaher8_t ) dim( 999 )
     D   @@DsR8C       s             10i 0

      /free

       SVPRIV_inz();

       k1yer8.r8empr = peEmpr;
       k1yer8.r8sucu = peSucu;
       k1yer8.r8arcd = peArcd;
       k1yer8.r8spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) <> *null and
                %addr( peMone ) <> *null and
                %addr( peSaha ) <> *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                k1yer8.r8riec = peRiec;
                k1yer8.r8cobc = peCobc;
                k1yer8.r8mone = peMone;
                k1yer8.r8saha = peSaha;
                setll %kds( k1yer8 : 15 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 15 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 15 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) <> *null and
                %addr( peMone ) <> *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                k1yer8.r8riec = peRiec;
                k1yer8.r8cobc = peCobc;
                k1yer8.r8mone = peMone;
                setll %kds( k1yer8 : 14 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 14 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 14 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) <> *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                k1yer8.r8riec = peRiec;
                k1yer8.r8cobc = peCobc;
                setll %kds( k1yer8 : 13 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 13 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 13 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                k1yer8.r8riec = peRiec;
                setll %kds( k1yer8 : 12 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 12 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 12 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                k1yer8.r8xpro = peXpro;
                setll %kds( k1yer8 : 11 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 11 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 11 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                k1yer8.r8suop = peSuop;
                setll %kds( k1yer8 : 10 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 10 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 10 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8oper = peOper;
                k1yer8.r8poco = pePoco;
                setll %kds( k1yer8 : 9 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 9 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 9 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                k1yer8.r8arse = peOper;
                setll %kds( k1yer8 : 8 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 8 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 8 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                k1yer8.r8arse = peArse;
                setll %kds( k1yer8 : 7 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 7 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 7 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                k1yer8.r8rama = peRama;
                setll %kds( k1yer8 : 6 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 6 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 6 ) paher8 @@DsIR8;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                k1yer8.r8sspo = peSspo;
                setll %kds( k1yer8 : 5 ) paher8;
                if not %equal( paher8 );
                  return *off;
                endif;
                reade(n) %kds( k1yer8 : 5 ) paher8 @@DsIR8;
                dow not %eof( paher8 );
                  @@DsR8C += 1;
                  eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
                 reade(n) %kds( k1yer8 : 5 ) paher8 @@DsIR8;
                enddo;

           other;

             setll %kds( k1yer8 : 4 ) paher8;
             if not %equal( paher8 );
               return *off;
             endif;
             reade(n) %kds( k1yer8 : 4 ) paher8 @@DsIR8;
             dow not %eof( paher8 );
               @@DsR8C += 1;
               eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
              reade(n) %kds( k1yer8 : 4 ) paher8 @@DsIR8;
             enddo;
         endsl;
       else;

         setll %kds( k1yer8 : 4 ) paher8;
         if not %equal( paher8 );
           return *off;
         endif;
         reade(n) %kds( k1yer8 : 4 ) paher8 @@DsIR8;
         dow not %eof( paher8 );
           @@DsR8C += 1;
           eval-corr @@DsR8( @@DsR8C ) = @@DsIR8;
          reade(n) %kds( k1yer8 : 4 ) paher8 @@DsIR8;
         enddo;
       endif;

       if %addr( peDsR8 ) <> *null;
         eval-corr peDsR8 = @@DsR8;
       endif;

       if %addr( peDsR8C ) <> *null;
         eval peDsR8C = @@DsR8C;
       endif;

       return *on;
      /end-free

     P SVPRIV_getFranquicias...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setFranquicia : Grabar Franquicias.-                  *
     ?*                                                              *
     ?*     peDsR8   ( input  ) Est. de Franquicia                   *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setFranquicia...
     P                 b                   export
     D SVPRIV_setFranquicia...
     D                 pi              n
     D   peDsR8                            const likeds( dsPaher8_t )

     D   @@DsOR8       ds                  likerec( p1her8 : *output )

      /free

       SVPRIV_inz();

       if SVPRIV_chkFranquicia( peDsR8.r8empr
                              : peDsR8.r8sucu
                              : peDsR8.r8arcd
                              : peDsR8.r8spol
                              : peDsR8.r8sspo
                              : peDsR8.r8rama
                              : peDsR8.r8arse
                              : peDsR8.r8oper
                              : peDsR8.r8poco
                              : peDsR8.r8suop
                              : peDsR8.r8xpro
                              : peDsR8.r8riec
                              : peDsR8.r8cobc
                              : peDsR8.r8mone
                              : peDsR8.r8saha  );
         return *off;
       endif;

       eval-corr @@DsOR8 = peDsR8;
       monitor;
         write p1heR8 @@DsOR8;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_setFranquicia...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltFranquicia : Eliminar Franquicia.-                 *
     ?*                                                              *
     ?*     peDsR8   ( input  ) Est. de Franquicia                   *
     ?*                                                              *
     ?* Retorna: *on = Elimino / *off = No Elimino                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltFranquicia...
     P                 b                   export
     D SVPRIV_dltFranquicia...
     D                 pi              n
     D   peDsR8                            const likeds( dsPaher8_t )

     D   k1yer8        ds                  likerec( p1her8 : *key )

      /free

       SVPRIV_inz();

       k1yer8.r8empr = peDsR8.r8empr;
       k1yer8.r8sucu = peDsR8.r8sucu;
       k1yer8.r8arcd = peDsR8.r8arcd;
       k1yer8.r8spol = peDsR8.r8spol;
       k1yer8.r8sspo = peDsR8.r8sspo;
       k1yer8.r8rama = peDsR8.r8rama;
       k1yer8.r8arse = peDsR8.r8arse;
       k1yer8.r8oper = peDsR8.r8oper;
       k1yer8.r8poco = peDsR8.r8poco;
       k1yer8.r8suop = peDsR8.r8suop;
       k1yer8.r8riec = peDsR8.r8riec;
       k1yer8.r8cobc = peDsR8.r8cobc;
       k1yer8.r8mone = peDsR8.r8mone;
       k1yer8.r8saha = peDsR8.r8saha;
       chain %kds( k1yer8 : 14 ) paher8;
       if %found( paher8 );
         delete p1her8;
       endif;

       return *on;

      /end-free

     P SVPRIV_dltFranquicia...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltFranquicias: Elimina Franquicias.-                 *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) superPoliza                          *
     ?*     peSspo   ( input  ) Suplemento Superpoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peXpro   ( input  ) Producto                  (opcional) *
     ?*     peRiec   ( input  ) Riesgos                   (opcional) *
     ?*     peCobc   ( input  ) Cobertura                 (opcional) *
     ?*     peMone   ( input  ) Moneda                    (opcional) *
     ?*     peSaha   ( input  ) Franquicia                (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si elimina / *off = No elimino                *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltFranquicias...
     P                 b                   export
     D SVPRIV_dltFranquicias...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peXpro                       3  0 options( *nopass : *omit ) const
     D   peRiec                       3    options( *nopass : *omit ) const
     D   peCobc                       3  0 options( *nopass : *omit ) const
     D   peMone                       2    options( *nopass : *omit ) const
     D   peSaha                      15  2 options( *nopass : *omit ) const

     D   @@DsR8        ds                  likeds( dsPaher8_t ) dim( 999 )
     D   @@DsR8C       s             10i 0
     D   x             s             10i 0
     D   rc            s               n

      /free

       SVPRIV_inz();

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) <> *null and
                %addr( peMone ) <> *null and
                %addr( peSaha ) <> *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : peArse
                                            : peOper
                                            : pePoco
                                            : peSuop
                                            : peXpro
                                            : peRiec
                                            : peCobc
                                            : peMone
                                            : peSaha
                                            : @@DsR8
                                            : @@DsR8C );


                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) <> *null and
                %addr( peMone ) <> *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : peArse
                                            : peOper
                                            : pePoco
                                            : peSuop
                                            : peXpro
                                            : peRiec
                                            : peCobc
                                            : peMone
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) <> *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : peArse
                                            : peOper
                                            : pePoco
                                            : peSuop
                                            : peXpro
                                            : peRiec
                                            : peCobc
                                            : *omit
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) <> *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : peArse
                                            : peOper
                                            : pePoco
                                            : peSuop
                                            : peXpro
                                            : peRiec
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) <> *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : peArse
                                            : peOper
                                            : pePoco
                                            : peSuop
                                            : peXpro
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : peArse
                                            : peOper
                                            : pePoco
                                            : peSuop
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : peArse
                                            : peOper
                                            : pePoco
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : peArse
                                            : peOper
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : peArse
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : peRama
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peXpro ) =  *null and
                %addr( peRiec ) =  *null and
                %addr( peCobc ) =  *null and
                %addr( peMone ) =  *null and
                %addr( peSaha ) =  *null    ;

                if not SVPRIV_getFranquicias( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : peSspo
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsR8
                                            : @@DsR8C );

                  return *off;
                endif;
           other;

             if not SVPRIV_getFranquicias( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : *omit
                                         : @@DsR8
                                         : @@DsR8C );

               return *off;
             endif;

         endsl;
       else;

         if not SVPRIV_getFranquicias( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : @@DsR8
                                     : @@DsR8C );

           return *off;
         endif;

       endif;

       for x = 1 to @@DsR8C;

         SVPRIV_dltFranquicia( @@DsR8( @@DsR8C ) );

       endfor;

       return *off;

     P SVPRIV_dltFranquicias...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkComponente : Validar Componentes.-                 *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkComponente...
     p                 b                   export
     D SVPRIV_chkComponente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const

     D   k1yer9        ds                  likerec( p1her9 : *key   )

      /free

       SVPRIV_inz();

       k1yer9.r9empr = peEmpr;
       k1yer9.r9sucu = peSucu;
       k1yer9.r9arcd = peArcd;
       k1yer9.r9spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null;

                k1yer9.r9rama = peRama;
                k1yer9.r9arse = peArse;
                k1yer9.r9oper = peOper;
                k1yer9.r9poco = pePoco;
                setll %kds( k1yer9 : 8 ) paher9;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null;

                k1yer9.r9rama = peRama;
                k1yer9.r9arse = peArse;
                k1yer9.r9oper = peOper;
                setll %kds( k1yer9 : 7 ) paher9;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yer9.r9rama = peRama;
                k1yer9.r9arse = peArse;
                setll %kds( k1yer9 : 6 ) paher9;

           when %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yer9.r9rama = peRama;
                setll %kds( k1yer9 : 5 ) paher9;

           other;

             setll %kds( k1yer9 : 4 ) paher9;
         endsl;
       else;

         setll %kds( k1yer9 : 4 ) paher9;

       endif;

       return %equal();

      /end-free

     P SVPRIV_chkComponente...
     p                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getComponentes: Retorna Componentes.-                 *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peDsR9   ( output ) Est. de Componente        (opcional) *
     ?*     peDsR9C  ( output ) Cant. de Componentes      (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getComponentes...
     P                 b                   export
     D SVPRIV_getComponentes...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peDsR9                            likeds( dsPaher9_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR9C                     10i 0 options( *nopass : *omit )

     D   k1yer9        ds                  likerec( p1her9 : *key   )
     D   @@DsIR9       ds                  likerec( p1her9 : *input )
     D   @@DsR9        ds                  likeds( dsPaher9_t ) dim( 999 )
     D   @@DsR9C       s             10i 0

      /free

       SVPRIV_inz();

       k1yer9.r9empr = peEmpr;
       k1yer9.r9sucu = peSucu;
       k1yer9.r9arcd = peArcd;
       k1yer9.r9spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null;

                k1yer9.r9rama = peRama;
                k1yer9.r9arse = peArse;
                k1yer9.r9oper = peOper;
                k1yer9.r9poco = pePoco;
                setll %kds( k1yer9 : 8 ) paher9;
                if not %equal( paher9 );
                  return *off;
                endif;
                reade(n) %kds( k1yer9 : 8 ) paher9 @@DsIR9;
                dow not %eof( paher9 );
                  @@DsR9C += 1;
                  eval-corr @@DsR9( @@DsR9C ) = @@DsIR9;
                 reade(n) %kds( k1yer9 : 8 ) paher9 @@DsIR9;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null;

                k1yer9.r9rama = peRama;
                k1yer9.r9arse = peArse;
                k1yer9.r9oper = peOper;
                setll %kds( k1yer9 : 7 ) paher9;
                if not %equal( paher9 );
                  return *off;
                endif;
                reade(n) %kds( k1yer9 : 7 ) paher9 @@DsIR9;
                dow not %eof( paher9 );
                  @@DsR9C += 1;
                  eval-corr @@DsR9( @@DsR9C ) = @@DsIR9;
                 reade(n) %kds( k1yer9 : 7 ) paher9 @@DsIR9;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yer9.r9rama = peRama;
                k1yer9.r9arse = peArse;
                setll %kds( k1yer9 : 6 ) paher9;
                if not %equal( paher9 );
                  return *off;
                endif;
                reade(n) %kds( k1yer9 : 6 ) paher9 @@DsIR9;
                dow not %eof( paher9 );
                  @@DsR9C += 1;
                  eval-corr @@DsR9( @@DsR9C ) = @@DsIR9;
                 reade(n) %kds( k1yer9 : 6 ) paher9 @@DsIR9;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yer9.r9rama = peRama;
                setll %kds( k1yer9 : 5 ) paher9;
                if not %equal( paher9 );
                  return *off;
                endif;
                reade(n) %kds( k1yer9 : 5 ) paher9 @@DsIR9;
                dow not %eof( paher9 );
                  @@DsR9C += 1;
                  eval-corr @@DsR9( @@DsR9C ) = @@DsIR9;
                 reade(n) %kds( k1yer9 : 5 ) paher9 @@DsIR9;
                enddo;

           other;

             setll %kds( k1yer9 : 4 ) paher9;
             if not %equal( paher9 );
               return *off;
             endif;
             reade(n) %kds( k1yer9 : 4 ) paher9 @@DsIR9;
             dow not %eof( paher9 );
               @@DsR9C += 1;
               eval-corr @@DsR9( @@DsR9C ) = @@DsIR9;
              reade(n) %kds( k1yer9 : 4 ) paher9 @@DsIR9;
             enddo;
         endsl;
       else;

         setll %kds( k1yer9 : 4 ) paher9;
         if not %equal( paher9 );
           return *off;
         endif;
         reade(n) %kds( k1yer9 : 4 ) paher9 @@DsIR9;
         dow not %eof( paher9 );
           @@DsR9C += 1;
           eval-corr @@DsR9( @@DsR9C ) = @@DsIR9;
          reade(n) %kds( k1yer9 : 4 ) paher9 @@DsIR9;
         enddo;
       endif;

       if %addr( peDsR9 ) <> *null;
         eval-corr peDsR9 = @@DsR9;
       endif;

       if %addr( peDsR9C ) <> *null;
         eval peDsR9C = @@DsR9C;
       endif;

       return *on;
      /end-free

     P SVPRIV_getComponentes...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setComponente : Grabar Componentes.-                  *
     ?*                                                              *
     ?*     peDsR9   ( input  ) Est. de Componente                   *
     ?*                                                              *
     ?* Retorna: *on = Graba / *off = No Graba                       *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setComponente...
     P                 b                   export
     D SVPRIV_setComponente...
     D                 pi              n
     D   peDsR9                            const likeds( dsPaher9_t )

     D   @@DsOR9       ds                  likerec( p1her9 : *output )

      /free

       SVPRIV_inz();

       if SVPRIV_chkComponente ( peDsR9.r9empr
                               : peDsR9.r9sucu
                               : peDsR9.r9arcd
                               : peDsR9.r9spol
                               : peDsR9.r9rama
                               : peDsR9.r9arse
                               : peDsR9.r9oper
                               : peDsR9.r9poco  );
         return *off;
       endif;

       eval-corr @@DsOR9 = peDsR9;
       monitor;
         write p1heR9 @@DsOR9;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_setComponente...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltComponente : Eliminar Componente.-                 *
     ?*                                                              *
     ?*     peDsR9   ( input  ) Est. de Componente                   *
     ?*                                                              *
     ?* Retorna: *on = Elimino / *off = No Elimino                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltComponente...
     P                 b                   export
     D SVPRIV_dltComponente...
     D                 pi              n
     D   peDsR9                            const likeds( dsPaher9_t )

     D   k1yer9        ds                  likerec( p1her9 : *key )

      /free

       SVPRIV_inz();

       k1yer9.r9empr = peDsR9.r9empr;
       k1yer9.r9sucu = peDsR9.r9sucu;
       k1yer9.r9arcd = peDsR9.r9arcd;
       k1yer9.r9spol = peDsR9.r9spol;
       k1yer9.r9rama = peDsR9.r9rama;
       k1yer9.r9arse = peDsR9.r9arse;
       k1yer9.r9oper = peDsR9.r9oper;
       k1yer9.r9poco = peDsR9.r9poco;
       chain %kds( k1yer9 : 8 ) paher9;
       if %found( paher9 );
         delete p1her9;
       endif;

       return *on;

      /end-free

     P SVPRIV_dltComponente...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_updComponente : Actualiza Componente.-                *
     ?*                                                              *
     ?*     peDsR9   ( input  ) Est. de Componente                   *
     ?*                                                              *
     ?* Retorna: *on = Actualizo / *off = No Actualizo               *
     ?* ------------------------------------------------------------ *
     P SVPRIV_updComponente...
     P                 b                   export
     D SVPRIV_updComponente...
     D                 pi              n
     D   peDsR9                            const likeds( dsPaher9_t )

     D   k1yer9        ds                  likerec( p1her9 : *key   )
     D   @@DsOR9       ds                  likerec( p1her9 : *output )

      /free

       SVPRIV_inz();

       k1yer9.r9empr = peDsR9.r9empr;
       k1yer9.r9sucu = peDsR9.r9sucu;
       k1yer9.r9arcd = peDsR9.r9arcd;
       k1yer9.r9spol = peDsR9.r9spol;
       k1yer9.r9rama = peDsR9.r9rama;
       k1yer9.r9arse = peDsR9.r9arse;
       k1yer9.r9oper = peDsR9.r9oper;
       k1yer9.r9poco = peDsR9.r9poco;
       chain %kds( k1yer9 : 8 ) paher9;
       if not %found( paher9 );
        return *off;
       endif;

       eval-corr @@DsOR9  = peDsR9;
       monitor;
         update p1her9 @@DsOR9;
       on-error;
         return *off;
       endmon;

       return *on;

      /end-free

     P SVPRIV_updComponente...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_calcPremio: Calculo de Premio.-                       *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucursal                             *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) Super Poliza                         *
     ?*     peSspo   ( input  ) Suplemento                           *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. de Articulos                   *
     ?*     peOper   ( input  ) Nro. Operacion                       *
     ?*     peSuop   ( input  ) Suplemento de Operacion              *
     ?*     peDsIp   ( output ) Importes por Provincia ( opcional )  *
     ?*     peDsIt   ( output ) Importes Totales       ( opcional )  *
     ?*     peDsPi   ( output ) % de Importes Totales  ( opcional )  *
     ?*                                                              *
     ?* Retorna: Premio / -1 = No Calculó.                           *
     ?* ------------------------------------------------------------ *
     P SVPRIV_calcPremio...
     P                 b                   export
     D SVPRIV_calcPremio...
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
     D   peDsIp                            likeds (    dsImpEg3_t   ) dim( 30 )
     D                                     options( *omit : *nopass )
     D   peDsIt                            likeds (  dsImpTotales_t )
     D                                     options( *omit : *nopass )
     D   peDsPi                            likeds (   dsPorcImp_t   )
     D                                     options( *omit : *nopass )
      *
     D   x             s             10i 0
     D   pro           s              2  0 dim(30)                              Provincias
     D   pri           s             15  2 dim(30)                              Primas
     D   net           s             15  2 dim(30)                              Prima Neta
     D   bon           s             15  2 dim(30)                              Bonificación
     D   rea           s             15  2 dim(30)                              Rec.Admin.
     D   ref           s             15  2 dim(30)                              Rec.Finan.
     D   der           s             15  2 dim(30)                              Der.Emisión
     D   sub           s             15  2 dim(30)                              Subtotales
     D   sel           s             15  2 dim(30)                              Sellado Rgo.
     D   see           s             15  2 dim(30)                              Sellado Emp.
     D   ib1           s             15  2 dim(30)                              Ingr.Brutos.
     D   ib2           s             15  2 dim(30)                              Ingr.Brutos.
     D   per           s             15  2 dim(30)                              Percepción
     D   pre           s             15  2 dim(30)                              Premio
     D   ipr1          s             15  2 dim(30)                              Premio
     D   ipr3          s             15  2 dim(30)                              Premio
     D   ipr4          s             15  2 dim(30)                              Premio
     D   ipr6          s             15  2 dim(30)                              Premio
     D   sefr          s             15  2 dim(30)                              Premio
     D   sefe          s             15  2 dim(30)                              Premio
      *
     D   @@DsR0        ds                  likeds ( dsPaher0_t ) dim( 999 )
     D   @@DsR0C       s             10i 0
     D   @@DsR2        ds                  likeds ( dsPaher2_t ) dim( 999 )
     D   @@DsR2C       s             10i 0
     D   @@DsC3        ds                  likeds( dsPahec3V2_t )
     D   @@DsC1        ds                  likeds( dsPahec1_t )  dim( 999 )
     D   @@DsC1C       s             10i 0
     D   @@DsD0        ds                  likeds( dsPahed0_t )  dim( 999 )
     D   @@DsD0C       s             10i 0
     D   @@DsPi        ds                  likeds (   dsPorcImp_t   )
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
     D   @@sefr        s             15  2                                      Premio
     D   @@sefe        s             15  2                                      Premio
     D   @@siva        s             15  2                                      Premio
      *
     D   rc            s               n
     D   @@DsArt       ds                  likeds( dsset630_t )
      *
     D   k1y697        ds                  likerec( s1t697 : *key )
     D   k1yloc        ds                  likerec( g1tloc : *key )
     D   k1ypro        ds                  likerec( g1tpro : *key )

      /free

       SVPRIV_inz();

       @@pro = 20;
       if SVPEMP_getLocalidadDeEmpresa( peEmpr
                                      : @@copo
                                      : @@cops );
         k1yloc.locopo = @@copo;
         k1yloc.locops = @@cops;
         chain %kds( k1yloc : 2 ) gntloc;
         if %found( gntloc );
           chain loproc gntpro;
             if %found( gntpro );
               @@pro = prrpro;
             endif;
         endif;
       endif;

       rc = SVPART_getParametria( peArcd
                                : @@DsArt );

       rc = SPVSPO_getCabeceraSuplemento( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : @@DsC1
                                        : @@DsC1C  );

       @@tiso = SVPDAF_getTipoSociedad( @@DsC1( @@DsC1C ).c1asen );
       rc = SVPPOL_getPolizadesdeSuperPoliza( peEmpr
                                            : peSucu
                                            : peArcd
                                            : peSpol
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : *omit
                                            : @@DsD0
                                            : @@DsD0C       );

       if not SVPRIV_getcoberturas( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : peSspo
                                  : peRama
                                  : peArse
                                  : peOper
                                  : *omit
                                  : peSuop
                                  : *omit
                                  : *omit
                                  : @@DsR2
                                  : @@DsR2C );
          return 0;
       endif;

       for x = 1 to @@DsR2C;

         if SVPRIV_getSuplementos( @@DsR2( x ).r2empr
                                 : @@DsR2( x ).r2sucu
                                 : @@DsR2( x ).r2arcd
                                 : @@DsR2( x ).r2spol
                                 : @@DsR2( x ).r2sspo
                                 : @@DsR2( x ).r2rama
                                 : @@DsR2( x ).r2arse
                                 : @@DsR2( x ).r2oper
                                 : @@DsR2( x ).r2poco
                                 : @@DsR2( x ).r2suop
                                 : @@DsR0
                                 : @@DsR0C              );

           pro( @@DsR0( @@DsR0c ).r0rpro )  = @@DsR0( @@DsR0C ).r0rpro;
           pri( @@DsR0( @@DsR0c ).r0rpro ) += @@DsR2( x ).r2ptco;
           @@prim += @@DsR2( x ).r2ptco;
         endif;
       endfor;

       clear canpro;
       for x = 1 to 30;
         if pro( x ) <> *zeros;
           canpro += 1 ;
         endif;
       endfor;


       clear @@DsPi;
       rc = SVPEMI_getImpuetosPorc( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : peSspo
                                  : @@prim
                                  : @@DsPi );

       // Importe bonificacion...
       eval(h) @@bpri = ( @@prim * @@dsPi.bpip ) / 100;

       // Importe Neto...
       @@neto = @@prim - @@bpri;

       // Importe Recargo financiero...
       @@refi = ( @@neto * @@DsPi.xref ) / 100;

       // Importe de Recargo Administrativo...
       @@read = ( @@neto * @@DsPi.xrea ) / 100;

       // Bonificacion por Provincia...
       bon = ( pri * @@DsPi.bpip ) / 100;
       //bon =  pri * @@DsPi.bpip;

       // Neto por Provincia...
       net = pri - bon;

       // Recargo financiero por Provincia...
       ref = ( net * @@DsPi.xref ) / 100;

       // Recargo administrativo por Provincia...
       rea = ( net * @@DsPi.xrea ) / 100 ;

       //Importe de derecho de emision...
       if @@prim = *zeros;
          clear @@dsPi.dere;
          clear @@dsPi.bpep;
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
                                             : peRama
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
                                             : peRama
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
       @@ivat = SVPEMI_CalcIVATotal( @@Dsd0( @@DsD0C ).d0come
                                   : @@DsC1( @@DsC1C ).c1civa
                                   : @@subt
                                   : @@DsPi.pivi
                                   : @@DsPi.pivn
                                   : @@pivr
                                   : @@DsPi.ivam
                                   : @@DsC1( @@DsC1c ).c1asen
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
                                              : peRama
                                              : @@DsD0( @@DsD0C ).d0mone
                                              : @@DsD0( @@DsD0C ).d0come
                                              : sub( x )
                                              : @@DsD0( @@DsD0C ).d0suas
                                              : @@DsC1( @@DsC1C ).c1civa
                                              : @@ipr1
                                              : @@ipr3
                                              : @@ipr4
                                              : *omit
                                              : @@DsC1( @@DsC1C ).c1asen
                                              : @@porc
                                              : ipr1( x )
                                              : ipr3( x )
                                              : ipr4( x )                 );
           @@ipr6 += ipr6( x );
           endif;
         endif;
       endfor;

       // Calcular Alicuota de Percepcion...
       @@imau = SVPEMI_CalcAlicuotaPercepcion( 20
                                             : peRama
                                             : @@ipr1
                                             : @@ipr3
                                             : @@ipr4
                                             : @@subt
                                             : @@DsC1( @@DsC1C ).c1asen
                                             : @@DsC1( @@DsC1C ).c1civa );
       // Calcular sellados...
       // PRO401N--> svpemi...
       otro_sellado = *off;
       for x = 1 to 30;
         if pro( x ) <> *zeros;
           sel( X ) = SVPEMI_CalcSelladosProvinciales( pro( x )
                                                     : peRama
                                                     : @@DsC1( @@DsC1C ).c1mone
                                                     : @@DsC1( @@DsC1C ).c1come
                                                     : pri( x )
                                                     : bon( x )
                                                     : rea( x )
                                                     : ref( x )
                                                     : der( x )
                                                     : sub( x )
                                                     : @@DsD0( @@DsD0C ).d0suas
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
                                                      : peRama
                                                      : @@DsC1( @@DsC1C ).c1mone
                                                      : @@DsC1( @@DsC1C ).c1come
                                                      : pri( x )
                                                      : bon( x )
                                                      : rea( x )
                                                      : ref( x )
                                                      : der( x )
                                                      : sub( x )
                                                      : @@DsD0( @@DsD0C ).d0suas
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
                                      : peRama
                                      : peArse
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
         clear peDsIp;
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
         if @@ipr3 = *zeros;
           clear @@DsPi.pivr;
         endif;
         if @@ipr4 = *zeros;
           clear @@DsPi.pivn;
         endif;

         eval peDsPi = @@DsPi;
       endif;

       return @@prem;

      /end-free

     P SVPRIV_calcPremio...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkCasco:  Validar Casco                              *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) superPoliza                          *
     ?*     peSspo   ( input  ) Suplemento Superpoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe /  *off = No existe                 *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkCasco...
     P                 B                   export
     D SVPRIV_chkCasco...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     D   k1yer02       ds                  likerec( p1her02 : *key )

      /free

       SVPRIV_inz();

       k1yer02.r0empr2 = peEmpr;
       k1yer02.r0sucu2 = peSucu;
       k1yer02.r0arcd2 = peArcd;
       k1yer02.r0spol2 = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                k1yer02.r0Arse2 = peArse;
                k1yer02.r0Oper2 = peOper;
                k1yer02.r0Poco2 = pePoco;
                k1yer02.r0Suop2 = peSuop;
                setll %kds( k1yer02 : 10 ) paher02;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                k1yer02.r0Arse2 = peArse;
                k1yer02.r0Oper2 = peOper;
                k1yer02.r0Poco2 = pePoco;
                setll %kds( k1yer02 : 9 ) paher02;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                k1yer02.r0Arse2 = peArse;
                k1yer02.r0Oper2 = peOper;
                setll %kds( k1yer02 : 8 ) paher02;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                k1yer02.r0Arse2 = peArse;
                setll %kds( k1yer02 : 7 ) paher02;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                setll %kds( k1yer02 : 6 ) paher02;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                setll %kds( k1yer02 : 5 ) paher02;
         other;

           setll %kds( k1yer02 : 4 ) paher02;

         endsl;

       else;

         setll %kds( k1yer02 : 4 ) paher02;

       endif;

       return %equal();

      /end-free

     P SVPRIV_chkCasco...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getCascos: Retorna Informacion de Cascos              *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) superPoliza                          *
     ?*     peSspo   ( input  ) Suplemento Superpoliza    (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peSuop   ( input  ) Suplemento Operacion      (opcional) *
     ?*     peDsR02  ( output ) Estructura Casco          (opcional) *
     ?*     peDsR02C ( output ) Cantidad de Casco         (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe /  *off = No existe                 *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getCascos...
     P                 b                   export
     D SVPRIV_getCascos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsR02                           likeds( dsPaher02_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR02C                    10i 0 options( *nopass : *omit )

     D   @@DsR02       ds                  likeds ( dsPaher02_t ) dim( 999 )
     D   @@DsR02C      s             10i 0
     D   @@DsIR02      ds                  likerec( p1her02  : *input )
     D   k1yer02       ds                  likerec( p1her02 : *key  )

      /free

       SVPRIV_inz();

       clear @@DsR02;
       clear @@DsR02C;

       k1yer02.r0empr2 = peEmpr;
       k1yer02.r0sucu2 = peSucu;
       k1yer02.r0arcd2 = peArcd;
       k1yer02.r0spol2 = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) <> *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                k1yer02.r0Arse2 = peArse;
                k1yer02.r0Oper2 = peOper;
                k1yer02.r0Poco2 = pePoco;
                k1yer02.r0Suop2 = peSuop;
                setll %kds( k1yer02 : 10 ) paher02;
                if not %equal( paher02 );
                  return *off;
                endif;
                reade %kds( k1yer02 : 10 ) paher02 @@DsIR02;
                dow not %eof( paher02 );
                  @@DsR02C += 1;
                  eval-corr @@DsR02( @@DsR02C ) = @@DsIR02;
                 reade %kds( k1yer02 : 10 ) paher02 @@DsIR02;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                k1yer02.r0Arse2 = peArse;
                k1yer02.r0Oper2 = peOper;
                k1yer02.r0Poco2 = pePoco;
                setll %kds( k1yer02 : 9 ) paher02;
                if not %equal( paher02 );
                  return *off;
                endif;
                reade %kds( k1yer02 : 9 ) paher02 @@DsIR02;
                dow not %eof( paher02 );
                  @@DsR02C += 1;
                  eval-corr @@DsR02( @@DsR02C ) = @@DsIR02;
                 reade %kds( k1yer02 : 9 ) paher02 @@DsIR02;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                k1yer02.r0Arse2 = peArse;
                k1yer02.r0Oper2 = peOper;
                setll %kds( k1yer02 : 8 ) paher02;
                if not %equal( paher02 );
                  return *off;
                endif;
                reade %kds( k1yer02 : 8 ) paher02 @@DsIR02;
                dow not %eof( paher02 );
                  @@DsR02C += 1;
                  eval-corr @@DsR02( @@DsR02C ) = @@DsIR02;
                 reade %kds( k1yer02 : 8 ) paher02 @@DsIR02;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                k1yer02.r0Arse2 = peArse;
                setll %kds( k1yer02 : 7 ) paher02;
                if not %equal( paher02 );
                  return *off;
                endif;
                reade %kds( k1yer02 : 7 ) paher02 @@DsIR02;
                dow not %eof( paher02 );
                  @@DsR02C += 1;
                  eval-corr @@DsR02( @@DsR02C ) = @@DsIR02;
                 reade %kds( k1yer02 : 7 ) paher02 @@DsIR02;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                k1yer02.r0Rama2 = peRama;
                setll %kds( k1yer02 : 6 ) paher02;
                if not %equal( paher02 );
                  return *off;
                endif;
                reade %kds( k1yer02 : 6 ) paher02 @@DsIR02;
                dow not %eof( paher02 );
                  @@DsR02C += 1;
                  eval-corr @@DsR02( @@DsR02C ) = @@DsIR02;
                 reade %kds( k1yer02 : 6 ) paher02 @@DsIR02;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yer02.r0Sspo2 = peSspo;
                setll %kds( k1yer02 : 5 ) paher02;
                if not %equal( paher02 );
                  return *off;
                endif;
                reade %kds( k1yer02 : 5 ) paher02 @@DsIR02;
                dow not %eof( paher02 );
                  @@DsR02C += 1;
                  eval-corr @@DsR02( @@DsR02C ) = @@DsIR02;
                 reade %kds( k1yer02 : 5 ) paher02 @@DsIR02;
                enddo;
         other;

           setll %kds( k1yer02 : 4 ) paher02;
           if not %equal( paher02 );
             return *off;
           endif;
           reade %kds( k1yer02 : 4 ) paher02 @@DsIR02;
           dow not %eof( paher02 );
             @@DsR02C += 1;
             eval-corr @@DsR02( @@DsR02C ) = @@DsIR02;
            reade %kds( k1yer02 : 4 ) paher02 @@DsIR02;
           enddo;

         endsl;

       else;

         setll %kds( k1yer02 : 4 ) paher02;
         if not %equal( paher02 );
           return *off;
         endif;
         reade %kds( k1yer02 : 4 ) paher02 @@DsIR02;
         dow not %eof( paher02 );
           @@DsR02C += 1;
           eval-corr @@DsR02( @@DsR02C ) = @@DsIR02;
          reade %kds( k1yer02 : 4 ) paher02 @@DsIR02;
         enddo;

       endif;

       if %addr(peDsR02) <> *null;
         eval-corr peDsR02 = @@DsIR02;
       endif;

       if %addr(peDsR02C) <> *null;
         peDsR02C = @@DsR02C;
       endif;
       return *on;

      /end-free

     P SVPRIV_getCascos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_updCasco:  Actualizar Casco                           *
     ?*                                                              *
     ?*     peDsR02  ( input  ) Estructura Casco                     *
     ?*                                                              *
     ?* Retorna: *on = Si Actualiza / *off = No Actualiza            *
     ?* ------------------------------------------------------------ *
     P SVPRIV_updCasco...
     P                 b                   export
     D SVPRIV_updCasco...
     D                 pi              n
     D   peDsR02                           const likeds( dsPaher02_t )

     D   @@DsOR02      ds                  likerec( p1her02 : *output )
     D   k1yer02       ds                  likerec( p1her02 : *key    )
     D   x             s             10i 0

      /free
       SVPRIV_inz();

       k1yer02.r0empr2 = peDsR02.r0empr2;
       k1yer02.r0sucu2 = peDsR02.r0sucu2;
       k1yer02.r0arcd2 = peDsR02.r0arcd2;
       k1yer02.r0spol2 = peDsR02.r0spol2;
       k1yer02.r0sspo2 = peDsR02.r0sspo2;
       k1yer02.r0rama2 = peDsR02.r0rama2;
       k1yer02.r0arse2 = peDsR02.r0arse2;
       k1yer02.r0oper2 = peDsR02.r0oper2;
       k1yer02.r0poco2 = peDsR02.r0poco2;
       k1yer02.r0suop2 = peDsR02.r0suop2;
       chain %kds( k1yer02 : 10 ) paher02 ;
       if not %found( paher02 );
         return *off;
       endif;

       eval-corr @@DsOR02 = peDsR02;
       monitor;
         update p1heR02 @@DsOR02;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P SVPRIV_updCasco...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setCasco : Graba Casco                                *
     ?*                                                              *
     ?*     peDsR02  ( input  ) Estructura de Casco                  *
     ?*                                                              *
     ?* Retorna: *on = Si graba  / *off = No graba                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setCasco...
     P                 b                   export
     D SVPRIV_setCasco...
     D                 pi              n
     D   peDsR02                           const likeds( dsPaher02_t )

     D   @@DsOR02      ds                  likerec( p1her02 : *output )
     D   x             s             10i 0

      /free
       SVPRIV_inz();

       if SVPRIV_chkCasco( peDsR02.r0empr2
                         : peDsR02.r0sucu2
                         : peDsR02.r0arcd2
                         : peDsR02.r0spol2
                         : peDsR02.r0sspo2
                         : peDsR02.r0rama2
                         : peDsR02.r0arse2
                         : peDsR02.r0oper2
                         : peDsR02.r0poco2
                         : peDsR02.r0suop2 );
         return *off;
       endif;

       eval-corr @@DsOR02 = peDsR02;
       monitor;
         write p1heR02 @@DsOR02;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P SVPRIV_setCasco...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltCasco : Elimina Casco                              *
     ?*                                                              *
     ?*     peDsR02  ( input  ) Estructura Casco                     *
     ?*                                                              *
     ?* Retorna: *on = Elimina / *off = No elimina                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltCasco...
     P                 b                   export
     D SVPRIV_dltCasco...
     D                 pi              n
     D   peDsR02                           const likeds( dsPaher02_t )

     D   k1yer02       ds                  likerec( p1her02 : *key   )

      /free

       SVPRIV_inz();

       k1yer02.r0empr2 = peDsR02.r0empr2;
       k1yer02.r0sucu2 = peDsR02.r0sucu2;
       k1yer02.r0arcd2 = peDsR02.r0arcd2;
       k1yer02.r0spol2 = peDsR02.r0spol2;
       k1yer02.r0sspo2 = peDsR02.r0sspo2;
       k1yer02.r0rama2 = peDsR02.r0rama2;
       k1yer02.r0arse2 = peDsR02.r0arse2;
       k1yer02.r0oper2 = peDsR02.r0oper2;
       k1yer02.r0poco2 = peDsR02.r0poco2;
       k1yer02.r0suop2 = peDsR02.r0suop2;

       chain %kds( k1yer02 : 10 ) paher02;
       if %found( paher02 );
         delete p1her02;
       endif;

       return *on;
      /end-free

     P SVPRIV_dltCasco...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_chkCascoComponente:  Validar Componente  de Casco     *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) superPoliza                          *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe /  *off = No existe                 *
     ?* ------------------------------------------------------------ *
     P SVPRIV_chkCascoComponente...
     P                 b                   export
     D SVPRIV_chkCascoComponente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const

     D   k1yer92       ds                  likerec( p1her92 : *key   )

      /free

       SVPRIV_inz();

       k1yer92.r9empr2 = peEmpr;
       k1yer92.r9sucu2 = peSucu;
       k1yer92.r9arcd2 = peArcd;
       k1yer92.r9spol2 = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null;

                k1yer92.r9rama2 = peRama;
                k1yer92.r9arse2 = peArse;
                k1yer92.r9oper2 = peOper;
                k1yer92.r9poco2 = pePoco;
                setll %kds( k1yer92 : 8 ) paher92;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null;

                k1yer92.r9rama2 = peRama;
                k1yer92.r9arse2 = peArse;
                k1yer92.r9oper2 = peOper;
                setll %kds( k1yer92 : 7 ) paher92;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yer92.r9rama2 = peRama;
                k1yer92.r9arse2 = peArse;
                setll %kds( k1yer92 : 6 ) paher92;

           when %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yer92.r9rama2 = peRama;
                setll %kds( k1yer92 : 5 ) paher92;

           other;

             setll %kds( k1yer92 : 4 ) paher92;
         endsl;
       else;

         setll %kds( k1yer92 : 4 ) paher92;

       endif;

       return *on;

      /end-free

     P SVPRIV_chkCascoComponente...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_getCascoComponentes: Retorna Informacion de           *
     ?*                             componentes de un casco          *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) superPoliza                          *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     peDsR92  ( output ) Estructura Casco  Compon. (opcional) *
     ?*     peDsR92C ( output ) Cantidad de Casco  Comp.  (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe /  *off = No existe                 *
     ?* ------------------------------------------------------------ *
     P SVPRIV_getCascoComponentes...
     P                 b                   export
     D SVPRIV_getCascoComponentes...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peDsR92                           likeds ( dsPaher92_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsR92C                    10i 0 options( *nopass : *omit )

     D   k1yer92       ds                  likerec( p1her92 : *key   )
     D   @@DsIR92      ds                  likerec( p1her92 : *input )
     D   @@DsR92       ds                  likeds ( dsPaher92_t ) dim( 999 )
     D   @@DsR92C      s             10i 0

      /free

       SVPRIV_inz();

       k1yer92.r9empr2 = peEmpr;
       k1yer92.r9sucu2 = peSucu;
       k1yer92.r9arcd2 = peArcd;
       k1yer92.r9spol2 = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null;

                k1yer92.r9rama2 = peRama;
                k1yer92.r9arse2 = peArse;
                k1yer92.r9oper2 = peOper;
                k1yer92.r9poco2 = pePoco;
                setll %kds( k1yer92 : 8 ) paher92;
                if not %equal( paher92 );
                  return *off;
                endif;
                reade(n) %kds( k1yer92 : 8 ) paher92 @@DsIR92;
                dow not %eof( paher92 );
                  @@DsR92C += 1;
                  eval-corr @@DsR92( @@DsR92C ) = @@DsIR92;
                 reade(n) %kds( k1yer92 : 8 ) paher92 @@DsIR92;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null;

                k1yer92.r9rama2 = peRama;
                k1yer92.r9arse2 = peArse;
                k1yer92.r9oper2 = peOper;
                setll %kds( k1yer92 : 7 ) paher92;
                if not %equal( paher92 );
                  return *off;
                endif;
                reade(n) %kds( k1yer92 : 7 ) paher92 @@DsIR92;
                dow not %eof( paher92 );
                  @@DsR92C += 1;
                  eval-corr @@DsR92( @@DsR92C ) = @@DsIR92;
                 reade(n) %kds( k1yer92 : 7 ) paher92 @@DsIR92;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yer92.r9rama2 = peRama;
                k1yer92.r9arse2 = peArse;
                setll %kds( k1yer92 : 6 ) paher92;
                if not %equal( paher92 );
                  return *off;
                endif;
                reade(n) %kds( k1yer92 : 6 ) paher92 @@DsIR92;
                dow not %eof( paher92 );
                  @@DsR92C += 1;
                  eval-corr @@DsR92( @@DsR92C ) = @@DsIR92;
                 reade(n) %kds( k1yer92 : 6 ) paher92 @@DsIR92;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yer92.r9rama2 = peRama;
                setll %kds( k1yer92 : 5 ) paher92;
                if not %equal( paher92 );
                  return *off;
                endif;
                reade(n) %kds( k1yer92 : 5 ) paher92 @@DsIR92;
                dow not %eof( paher92 );
                  @@DsR92C += 1;
                  eval-corr @@DsR92( @@DsR92C ) = @@DsIR92;
                 reade(n) %kds( k1yer92 : 5 ) paher92 @@DsIR92;
                enddo;

           other;

             setll %kds( k1yer92 : 4 ) paher92;
             if not %equal( paher92 );
               return *off;
             endif;
             reade(n) %kds( k1yer92 : 4 ) paher92 @@DsIR92;
             dow not %eof( paher92 );
               @@DsR92C += 1;
               eval-corr @@DsR92( @@DsR92C ) = @@DsIR92;
              reade(n) %kds( k1yer92 : 4 ) paher92 @@DsIR92;
             enddo;
         endsl;
       else;

         setll %kds( k1yer92 : 4 ) paher92;
         if not %equal( paher92 );
           return *off;
         endif;
         reade(n) %kds( k1yer92 : 4 ) paher92 @@DsIR92;
         dow not %eof( paher92 );
           @@DsR92C += 1;
           eval-corr @@DsR92( @@DsR92C ) = @@DsIR92;
          reade(n) %kds( k1yer92 : 4 ) paher92 @@DsIR92;
         enddo;
       endif;

       if %addr( peDsR92 ) <> *null;
         eval-corr peDsR92 = @@DsR92;
       endif;

       if %addr( peDsR92C ) <> *null;
         eval peDsR92C = @@DsR92C;
       endif;

       return *on;
      /end-free

     P SVPRIV_getCascoComponentes...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_updCascoComponente: Actualizar Componente de casco    *
     ?*                                                              *
     ?*     peDsR92  ( input  ) Estructura Componente de Casco       *
     ?*                                                              *
     ?* Retorna: *on = Si Actualiza / *off = No Actualiza            *
     ?* ------------------------------------------------------------ *
     P SVPRIV_updCascoComponente...
     P                 b                   export
     D SVPRIV_updCascoComponente...
     D                 pi              n
     D   peDsR92                           const likeds( dsPaher92_t )

     D   k1yer92       ds                  likerec( p1her92 : *key    )
     D   @@DsOR92      ds                  likerec( p1her92 : *output )

      /free

       SVPRIV_inz();
       clear @@DsOR92;
       k1yer92.r9empr2 = peDsR92.r9empr2;
       k1yer92.r9sucu2 = peDsR92.r9sucu2;
       k1yer92.r9arcd2 = peDsR92.r9arcd2;
       k1yer92.r9spol2 = peDsR92.r9spol2;
       k1yer92.r9rama2 = peDsR92.r9rama2;
       k1yer92.r9arse2 = peDsR92.r9arse2;
       k1yer92.r9oper2 = peDsR92.r9oper2;
       k1yer92.r9poco2 = peDsR92.r9poco2;
       chain %kds( k1yer92 : 8 ) paher92;
       if not %found( paher92 );
        return *off;
       endif;

       eval-corr @@DsOR92  = peDsR92;
       monitor;
         update p1her92 @@DsOR92;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P SVPRIV_updCascoComponente...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_setCascoComponente: Graba Componente de Casco         *
     ?*                                                              *
     ?*     peDsR92  ( input  ) Estructura de Componente de Casco    *
     ?*                                                              *
     ?* Retorna: *on = Si graba  / *off = No graba                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_setCascoComponente...
     P                 b                   export
     D SVPRIV_setCascoComponente...
     D                 pi              n
     D   peDsR92                           const likeds( dsPaher92_t )

     D   @@DsOR92      ds                  likerec( p1her92 : *output )

      /free

       SVPRIV_inz();

       if SVPRIV_chkCascoComponente ( peDsR92.r9empr2
                                    : peDsR92.r9sucu2
                                    : peDsR92.r9arcd2
                                    : peDsR92.r9spol2
                                    : peDsR92.r9rama2
                                    : peDsR92.r9arse2
                                    : peDsR92.r9oper2
                                    : peDsR92.r9poco2 );
         return *off;
       endif;

       eval-corr @@DsOR92 = peDsR92;
       monitor;
         write p1heR92 @@DsOR92;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P SVPRIV_setCascoComponente...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_dltCascoComponente: Elimina Componente de Casco       *
     ?*                                                              *
     ?*     peDsR92  ( input  ) Estructura Componente de Casco       *
     ?*                                                              *
     ?* Retorna: *on = Elimina / *off = No elimina                   *
     ?* ------------------------------------------------------------ *
     P SVPRIV_dltCascoComponente...
     P                 b                   export
     D SVPRIV_dltCascoComponente...
     D                 pi              n
     D   peDsR92                           const likeds( dsPaher92_t )

     D   k1yer92       ds                  likerec( p1her92 : *key )

      /free

       SVPRIV_inz();

       k1yer92.r9empr2 = peDsR92.r9empr2;
       k1yer92.r9sucu2 = peDsR92.r9sucu2;
       k1yer92.r9arcd2 = peDsR92.r9arcd2;
       k1yer92.r9spol2 = peDsR92.r9spol2;
       k1yer92.r9rama2 = peDsR92.r9rama2;
       k1yer92.r9arse2 = peDsR92.r9arse2;
       k1yer92.r9oper2 = peDsR92.r9oper2;
       k1yer92.r9poco2 = peDsR92.r9poco2;
       chain %kds( k1yer92 : 8 ) paher92;
       if %found( paher92 );
         delete p1her92;
       endif;

       return *on;
      /end-free

     P SVPRIV_dltCascoComponente...
     P                 e

     * ------------------------------------------------------------ *
     * SVPRIV_getCantComponentesActivos:  Retorna cantidad de       *
     *                                    componentes Activos       *
     *     peEmpr ( input )  Código de Empresa                      *
     *     peSucu ( input )  Código de Sucursal                     *
     *     peArcd ( input )  Código de Articulo                     *
     *     peSpol ( input )  Nro. de Superpoliza                    *
     *     peRama ( input )  Código de Rama              (opcional) *
     *     peArse ( input )  Cant. Polizas por Rama      (opcional) *
     *     peOper ( input )  Nro. Operación              (opcional) *
     *     pePoco ( input )  Nro. de Componente          (opcional) *
     *                                                              *
     * Retorna: 0 = No tiene componentes / >0 Cantidad              *
     * ------------------------------------------------------------ *
     P SVPRIV_getCantComponentesActivos...
     P                 b                   export
     D SVPRIV_getCantComponentesActivos...
     D                 pi            10  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit )
     D   peArse                       2  0 options( *nopass : *omit )
     D   peOper                       7  0 options( *nopass : *omit )
     D   pePoco                       4  0 options( *nopass : *omit )

     D   @@DsR9        ds                  likeds( dsPaher9_t ) dim( 999 )
     D   @@DsR9C       s             10i 0
     D   @@cant        s             10i 0
     D   x             s             10i 0
     D   rc            s               n

      /free
       SVPRIV_inz();

       clear @@Cant;

       select;
         when %parms >= 5 and %addr( peRama ) <> *NULL
                          and %addr( peArse ) =  *NULL
                          and %addr( peOper ) =  *NULL
                          and %addr( pePoco ) =  *NULL;

           rc = SVPRIV_getComponentes( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : peRama
                                     : *omit
                                     : *omit
                                     : *omit
                                     : @@DsR9
                                     : @@DsR9C );

         when %parms >= 6 and %addr( peRama ) <> *NULL
                          and %addr( peArse ) <> *NULL
                          and %addr( peOper ) =  *NULL
                          and %addr( pePoco ) =  *NULL;

           rc = SVPRIV_getComponentes( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : peRama
                                     : peArse
                                     : *omit
                                     : *omit
                                     : @@DsR9
                                     : @@DsR9C );

         when %parms >= 7 and %addr( peRama ) <> *NULL
                          and %addr( peArse ) <> *NULL
                          and %addr( peOper ) <> *NULL
                          and %addr( pePoco ) =  *NULL;

           rc =  SVPRIV_getComponentes( peEmpr
                                      : peSucu
                                      : peArcd
                                      : peSpol
                                      : peRama
                                      : peArse
                                      : peOper
                                      : *omit
                                      : @@DsR9
                                      : @@DsR9C );

         when %parms >= 8 and %addr( peRama ) <> *NULL
                          and %addr( peArse ) <> *NULL
                          and %addr( peOper ) <> *NULL
                          and %addr( pePoco ) <> *NULL;

           rc =  SVPRIV_getComponentes( peEmpr
                                      : peSucu
                                      : peArcd
                                      : peSpol
                                      : peRama
                                      : peArse
                                      : peOper
                                      : pePoco
                                      : @@DsR9
                                      : @@DsR9C );

         other;

           rc = SVPRIV_getComponentes( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : *omit
                                     : *omit
                                     : *omit
                                     : *omit
                                     : @@DsR9
                                     : @@DsR9C );
       endsl;

       if rc;
         for x = 1 to @@DsR9C;
           if @@DsR9(x).r9strg = '0';
             @@cant += 1;
           endif;
         endfor;
       endif;

       return @@cant;

      /end-free
     P SVPRIV_getCantComponentesActivos...
     P                 e

     * ------------------------------------------------------------ *
     * SVPRIV_getPorcSumaMaxRiesCobe: Retorna porc Máxima por riesgo*
     *                                cobertura                     *
     *     peRama ( input )  Código de Rama                         *
     *     peXpro ( input )  Producto                               *
     *     peRiec ( input )  Riesgo                                 *
     *     peCobc ( input )  Cobertura                              *
     *     peMone ( input )  Moneda                                 *
     *                                                              *
     * Retorna: 0 = No tiene / >0 Porcentaje                        *
     * ------------------------------------------------------------ *
     P SVPRIV_getPorcSumaMaxRiesCobe...
     P                 b                   export
     D SVPRIV_getPorcSumaMaxRiesCobe...
     D                 pi             5  2
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const

     D   k1y1031       ds                  likerec( s1t1031 : *key )

      /free
       SVPRIV_inz();

       k1y1031.t@rama = peRama;
       k1y1031.t@xpro = peXpro;
       k1y1031.t@riec = peRiec;
       k1y1031.t@cobc = peCobc;
       k1y1031.t@mone = peMone;
       chain %kds( k1y1031 : 5 ) set1031;
       if not %found( set1031 );
          t@prsax = 0;
       endif;

       return t@prsax;
      /end-free
     P SVPRIV_getPorcSumaMaxRiesCobe...
     P                 e

      * ------------------------------------------------------------ *
      * SVPRIV_getMascotas: Retorna Mascotas                         *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) superPoliza                          *
      *     peSspo   ( input  ) Suplemento Superpoliza               *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cantidad de polizas                  *
      *     peOper   ( input  ) Codigo de Operacion                  *
      *     pePoco   ( input  ) Nro. de Componente                   *
      *     peSuop   ( input  ) Suplemento Operacion                 *
      *     peRiec   ( input  ) Riesgo                               *
      *     peXcob   ( input  ) Cobertura                            *
      *     peDsra   ( input  ) Array de Mascotas                    *
      *     peDsraC  ( input  ) Cantidad de Mascotas                 *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPRIV_getMascotas...
     P                 b                   export
     D SVPRIV_getMascotas...
     D                 pi              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peSuop                       3  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const
     D   peDsRa                            likeds( dsPahera_t ) dim( 999 )
     D   peDsRaC                     10i 0

     D k1hera          ds                  likerec(p1hera:*key)
     D inpEra          ds                  likerec(p1hera:*input)
     D x               s             10i 0

      /free

       SVPRIV_inz();

       clear peDsRa;
       clear inpEra;

       k1hera.raempr = peEmpr;
       k1hera.rasucu = peSucu;
       k1hera.raarcd = peArcd;
       k1hera.raspol = peSpol;
       k1hera.rasspo = peSspo;
       k1hera.rarama = peRama;
       k1hera.raarse = peArse;
       k1hera.raoper = peOper;
       k1hera.rapoco = pePoco;
       k1hera.rasuop = peSuop;
       k1hera.rariec = peRiec;
       k1hera.raxcob = peXcob;
       setll %kds(k1hera:12) pahera;
       reade %kds(k1hera:12) pahera inpEra;
       dow not %eof;
           x += 1;
           eval-corr peDsRa(x) = inpEra;
        reade %kds(k1hera:12) pahera inpEra;
       enddo;

       peDsRaC = x;
       if x >= 0;
          return *on;
       endif;

       return *off;

      /end-free

     P SVPRIV_getMascotas...
     P                 e

      * ------------------------------------------------------------ *
      * SVPRIV_isCoberturaBaja : Valida si una cobertura esta dada   *
      *                          de baja                             *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cantidad de polizas                  *
      *     peOper   ( input  ) Codigo de Operacion                  *
      *     pePoco   ( input  ) Nro. de Componente                   *
      *     peRiec   ( input  ) Riesgos                              *
      *     peXcob   ( input  ) Coberturas                           *
      *     peSspo   ( input  ) Suplemento SuperPoliza ( opcional )  *
      *     peSuop   ( input  ) Suplemento Operacion   ( opcional )  *
      *                                                              *
      * Retorna: *on = Activa / *off = Baja                          *
      * ------------------------------------------------------------ *
     P SVPRIV_isCoberturaBaja...
     P                 b                   export
     D SVPRIV_isCoberturaBaja...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSspo                       3  0 const options(*nopass:*omit)
     D   peSuop                       3  0 const options(*nopass:*omit)

     D   @@DsR2        ds                  likeds( dsPaher2_t ) dim( 999 )
     D   @@DsR2C       s             10i 0
     D   @@DsR9        ds                  likeds( dsPaher9_t ) dim( 999 )
     D   @@DsR9C       s             10i 0
     D   @@Sspo        s              3  0
     D   @@Suop        s              3  0

      /free

       SVPRIV_inz();

       clear @@DsR9;
       clear @@DsR9C;
       if not SVPRIV_getComponentes( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : peRama
                                   : peArse
                                   : peOper
                                   : pePoco
                                   : @@DsR9
                                   : @@DsR9C );
           return *off;
       endif;

       @@sspo = @@DsR9(@@DsR9C).r9sspo;
       @@suop = @@DsR9(@@DsR9C).r9sspo;

       if %parms >= 11;
          if %addr( peSspo ) <> *null;
             @@sspo = peSspo;
          endif;

          if %addr( peSuop ) <> *null;
             @@sspo = peSuop;
          endif;
       endif;

       clear @@DsR2;
       clear @@DsR2C;

       if not SVPRIV_getCoberturas( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : @@sspo
                                  : peRama
                                  : peArse
                                  : peOper
                                  : pePoco
                                  : @@suop
                                  : peRiec
                                  : peXcob
                                  : @@DsR2
                                  : @@DsR2C );
            return *off;
       endif;

       if @@DsR2( @@DsR2C ).r2ecob = 'B';
          return *on;
       endif;

       return *off;

      /end-free

     P SVPRIV_isCoberturaBaja...
     P                 e

      * ------------------------------------------------------------ *
      * SVPRIV_getUltimoEstadoComponente: Retorna Suplementos        *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Rama                      (opcional) *
      *     peArse   ( input  ) Cantidad de polizas       (opcional) *
      *     peOper   ( input  ) Codigo de Operacion       (opcional) *
      *     pePoco   ( input  ) Nro. de Componente        (opcional) *
      *     peDsR0   ( output ) Estructura Riesgos Varios (opcional) *
      *                                                              *
      * Retorna: *on = Si coincide la Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPRIV_getUltimoEstadoComponente...
     P                 b                   export
     D SVPRIV_getUltimoEstadoComponente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peDsR0                            likeds ( dsPaher0_t )

     D   k1yer0        ds                  likerec( p1her002 : *key   )
     D   @@DsIR0       ds                  likerec( p1her002 : *input )

      /free

       SVPRIV_inz();

       clear @@DsIR0;

       k1yer0.r0empr = peEmpr;
       k1yer0.r0sucu = peSucu;
       k1yer0.r0arcd = peArcd;
       k1yer0.r0spol = peSpol;
       k1yer0.r0Rama = peRama;
       k1yer0.r0Arse = peArse;
       k1yer0.r0Oper = peOper;
       k1yer0.r0Poco = pePoco;

       chain %kds( k1yer0 : 8 ) Paher002 @@DsIR0;
       if not %found( Paher002 );
          return *off;
       endif;

       eval-corr peDsR0  = @@DsIR0;

       return *on;


      /end-free

     P SVPRIV_getUltimoEstadoComponente...
     P                 e

      * ------------------------------------------------------------ *
      * SVPRIV_getCtwer2: Retorna Cotizacion Web: Cobertura de RV    *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peNivt   (input)   Tipo Nivel Intermediario              *
      *     peNivc   (input)   Cod. Nivel Intermediario              *
      *     peNctw   (input)   Nro. Cotizacion                       *
      *     peRama   (input)   Cod. Rama                             *
      *     peArse   (input)   Cant. Polizas por Rama                *
      *     pePoco   (input)   Nro. Componente                       *
      *     peRiec   (input)   Cod. Riesgo                           *
      *     peXcob   (input)   Cod. Cobertura                        *
      *     peDsWR2   Output)  Registro con Ctwer2                   *
      *                                                              *
      * Retorna: *on = Si coincide la Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPRIV_getCtwer2...
     P                 b                   export
     D SVPRIV_getCtwer2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peDsWR2                           likeds(dsCtwer2_t)


     D   k1yer2        ds                  likerec( c1wer2 : *key   )
     D   @@DsIWR2      ds                  likerec( c1wer2 : *input )

      /free

       SVPRIV_inz();
       clear @@DsIwr2;

       k1yer2.r2Empr = peEmpr;
       k1yer2.r2Sucu = peSucu;
       k1yer2.r2Nivt = peNivt;
       k1yer2.r2Nivc = peNivc;
       k1yer2.r2Nctw = peNctw;
       k1yer2.r2Rama = peRama;
       k1yer2.r2Arse = peArse;
       k1yer2.r2Poco = pePoco;
       k1yer2.r2Riec = peRiec;
       k1yer2.r2Xcob = peXcob;

       chain %kds( k1yer2 : 10 ) Ctwer2 @@DsIWR2;
       if not %found( Ctwer2 );
          return *off;
       endif;

       eval-corr peDsWR2  = @@DsIWR2;

       return *on;


      /end-free

     P SVPRIV_getCtwer2...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPRIV_updCtwer2: Actualiza Cotizacion Web: Cobertura de RV  *
     ?*                                                              *
     ?*     peDsWR2  ( input  ) Estructura Cobertura de RV           *
     ?*                                                              *
     ?* Retorna: *on = Si Actualiza / *off = No Actualiza            *
     ?* ------------------------------------------------------------ *
     P SVPRIV_updCtwer2...
     P                 b                   export
     D SVPRIV_updCtwer2...
     D                 pi              n
     D   peDsWR2                           const likeds( dsCtwer2_t )

     D   k1yer2        ds                  likerec( c1wer2 : *key    )
     D   @@DsOWR2      ds                  likerec( c1wer2 : *output )

      /free

       SVPRIV_inz();
       clear @@DsOWR2;
       k1yer2.r2Empr = peDsWR2.r2Empr;
       k1yer2.r2Sucu = peDsWR2.r2Sucu;
       k1yer2.r2Nivt = peDsWR2.r2Nivt;
       k1yer2.r2Nivc = peDsWR2.r2Nivc;
       k1yer2.r2Nctw = peDsWR2.r2Nctw;
       k1yer2.r2Rama = peDsWR2.r2Rama;
       k1yer2.r2Arse = peDsWR2.r2Arse;
       k1yer2.r2Poco = peDsWR2.r2Poco;
       k1yer2.r2Riec = peDsWR2.r2Riec;
       k1yer2.r2Xcob = peDsWR2.r2Xcob;
       chain %kds( k1yer2 : 10 ) Ctwer2;
       if not %found( Ctwer2 );
          return *off;
       endif;

       eval-corr @@DsOWR2  = peDsWR2;
       monitor;
         update c1wer2 @@DsOWR2;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P SVPRIV_updCtwer2...
     P                 e


