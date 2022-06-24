     H nomain
      * ************************************************************ *
      * SVPVID: Programa de Servicio.                                *
      *         Vida                                                 *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                  ** 25-Ene-2019 **          *
      * ************************************************************ *
      * Modificaciones:                                              *
      * JSN 10/06/2019 - Se agrega los procedimientos:               *
      *                    * _getExtensionVida()                     *
      *                    * _getEdadMaximaDeVida()                  *
      *                    * _getEdadMinimaDeVida()                  *
      * NWN 13/05/2022 - Se agrega los procedimientos:               *
      *                    * _getPahev1.                             *
      *                    * _getPahev2.                             *
      *                    * _getUltCompoVida.                       *
      *                                                              *
      * ************************************************************ *
     Fpahev0    if   e           k disk    usropn
     Fset627    if   e           k disk    usropn
     Fpahev1    if   e           k disk    usropn
     Fpahev2    if   e           k disk    usropn

      * ------------------------------------------------------------ *
      * Setea error global
      * --------------------------------------------------- *
     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpvid_h.rpgle'

      *--- Definicion de Procedimiento ----------------------------- *
     ?* ------------------------------------------------------------ *
     ?* SVPVID_inz(): Inicializa módulo.                             *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPVID_inz      B                   export
     D SVPVID_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahev0);
         open pahev0;
       endif;

       if not %open(set627);
         open set627;
       endif;

       if not %open(pahev1);
         open pahev1;
       endif;

       if not %open(pahev2);
         open pahev2;
       endif;

       initialized = *ON;

       return;

      /end-free

     P SVPVID_inz      E

     ?* ------------------------------------------------------------ *
     ?* SVPVID_End(): Finaliza módulo.                               *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPVID_End      B                   export
     D SVPVID_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPVID_End      E

     ?* ------------------------------------------------------------ *
     ?* SVPVID_Error(): Retorna el último error del service program  *
     ?*                                                              *
     ?*     peEnbr   (output)  Número de error (opcional)            *
     ?*                                                              *
     ?* Retorna: Mensaje de error.                                   *
     ?* ------------------------------------------------------------ *

     P SVPVID_Error    B                   export
     D SVPVID_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPVID_Error    E

     ?* ------------------------------------------------------------ *
     ?* SVPVID_chkComponente : Validar Componentes.-                 *
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
     P SVPVID_chkComponente...
     p                 b                   export
     D SVPVID_chkComponente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       6  0 options( *nopass : *omit ) const

     D   k1yev0        ds                  likerec( p1hev0 : *key   )

      /free

       SVPVID_inz();

       k1yev0.v0empr = peEmpr;
       k1yev0.v0sucu = peSucu;
       k1yev0.v0arcd = peArcd;
       k1yev0.v0spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null;

                k1yev0.v0rama = peRama;
                k1yev0.v0arse = peArse;
                k1yev0.v0oper = peOper;
                k1yev0.v0poco = pePoco;
                setll %kds( k1yev0 : 8 ) pahev0;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null;

                k1yev0.v0rama = peRama;
                k1yev0.v0arse = peArse;
                k1yev0.v0oper = peOper;
                setll %kds( k1yev0 : 7 ) pahev0;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yev0.v0rama = peRama;
                k1yev0.v0arse = peArse;
                setll %kds( k1yev0 : 6 ) pahev0;

           when %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yev0.v0rama = peRama;
                setll %kds( k1yev0 : 5 ) pahev0;

           other;

             setll %kds( k1yev0 : 4 ) pahev0;
         endsl;
       else;

         setll %kds( k1yev0 : 4 ) pahev0;

       endif;

       return %equal();

      /end-free

     P SVPVID_chkComponente...
     p                 e

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getComponentes: Retorna Componentes.-                 *
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
     P SVPVID_getComponentes...
     P                 b                   export
     D SVPVID_getComponentes...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       6  0 options( *nopass : *omit ) const
     D   peDsV0                            likeds( dsPahev0_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsV0C                     10i 0 options( *nopass : *omit )

     D   k1yev0        ds                  likerec( p1hev0 : *key   )
     D   @@DsIV0       ds                  likerec( p1hev0 : *input )
     D   @@DsV0        ds                  likeds( dsPahev0_t ) dim( 999 )
     D   @@DsV0C       s             10i 0

      /free

       SVPVID_inz();

       k1yev0.v0empr = peEmpr;
       k1yev0.v0sucu = peSucu;
       k1yev0.v0arcd = peArcd;
       k1yev0.v0spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null;

                k1yev0.v0rama = peRama;
                k1yev0.v0arse = peArse;
                k1yev0.v0oper = peOper;
                k1yev0.v0poco = pePoco;
                setll %kds( k1yev0 : 8 ) pahev0;
                if not %equal( pahev0 );
                  return *off;
                endif;
                reade(n) %kds( k1yev0 : 8 ) pahev0 @@DsIV0;
                dow not %eof( pahev0 );
                  @@DsV0C += 1;
                  eval-corr @@DsV0( @@DsV0C ) = @@DsIV0;
                 reade(n) %kds( k1yev0 : 8 ) pahev0 @@DsIV0;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null;

                k1yev0.v0rama = peRama;
                k1yev0.v0arse = peArse;
                k1yev0.v0oper = peOper;
                setll %kds( k1yev0 : 7 ) pahev0;
                if not %equal( pahev0 );
                  return *off;
                endif;
                reade(n) %kds( k1yev0 : 7 ) pahev0 @@DsIV0;
                dow not %eof( pahev0 );
                  @@DsV0C += 1;
                  eval-corr @@DsV0( @@DsV0C ) = @@DsIV0;
                 reade(n) %kds( k1yev0 : 7 ) pahev0 @@DsIV0;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yev0.v0rama = peRama;
                k1yev0.v0arse = peArse;
                setll %kds( k1yev0 : 6 ) pahev0;
                if not %equal( pahev0 );
                  return *off;
                endif;
                reade(n) %kds( k1yev0 : 6 ) pahev0 @@DsIV0;
                dow not %eof( pahev0 );
                  @@DsV0C += 1;
                  eval-corr @@DsV0( @@DsV0C ) = @@DsIV0;
                 reade(n) %kds( k1yev0 : 6 ) pahev0 @@DsIV0;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

                k1yev0.v0rama = peRama;
                setll %kds( k1yev0 : 5 ) pahev0;
                if not %equal( pahev0 );
                  return *off;
                endif;
                reade(n) %kds( k1yev0 : 5 ) pahev0 @@DsIV0;
                dow not %eof( pahev0 );
                  @@DsV0C += 1;
                  eval-corr @@DsV0( @@DsV0C ) = @@DsIV0;
                 reade(n) %kds( k1yev0 : 5 ) pahev0 @@DsIV0;
                enddo;

           other;

             setll %kds( k1yev0 : 4 ) pahev0;
             if not %equal( pahev0 );
               return *off;
             endif;
             reade(n) %kds( k1yev0 : 4 ) pahev0 @@DsIV0;
             dow not %eof( pahev0 );
               @@DsV0C += 1;
               eval-corr @@DsV0( @@DsV0C ) = @@DsIV0;
              reade(n) %kds( k1yev0 : 4 ) pahev0 @@DsIV0;
             enddo;
         endsl;
       else;

         setll %kds( k1yev0 : 4 ) pahev0;
         if not %equal( pahev0 );
           return *off;
         endif;
         reade(n) %kds( k1yev0 : 4 ) pahev0 @@DsIV0;
         dow not %eof( pahev0 );
           @@DsV0C += 1;
           eval-corr @@DsV0( @@DsV0C ) = @@DsIV0;
          reade(n) %kds( k1yev0 : 4 ) pahev0 @@DsIV0;
         enddo;
       endif;

       if %addr( peDsV0 ) <> *null;
         eval-corr peDsV0 = @@DsV0;
       endif;

       if %addr( peDsV0C ) <> *null;
         eval peDsV0C = @@DsV0C;
       endif;

       return *on;

      /end-free

     P SVPVID_getComponentes...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getExtensionVida: Retorna datos de Extensión Vida     *
     ?*                                                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cantidad de polizas                  *
     ?*     peXpro   ( input  ) Código de Producto        (opcional) *
     ?*     peDs627  ( output ) Est. de Extensión Vida    (opcional) *
     ?*     peDs627C ( output ) Cant. de Extensión Vida   (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPVID_getExtensionVida...
     P                 b                   export
     D SVPVID_getExtensionVida...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       6  0 options( *nopass : *omit ) const
     D   peDs627                           likeds( dsSet627_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDs627C                    10i 0 options( *nopass : *omit )

     D   k1y627        ds                  likerec( s1t627 : *key   )
     D   @@DsI627      ds                  likerec( s1t627 : *input )
     D   @@Ds627       ds                  likeds( dsSet627_t ) dim( 999 )
     D   @@Ds627C      s             10i 0

      /free

       SVPVID_inz();

       clear @@DsI627;
       clear @@Ds627;
       clear @@Ds627C;

       k1y627.t@Arcd = peArcd;
       k1y627.t@Rama = peRama;
       k1y627.t@Arse = peArse;

       if %parms >= 4 and %addr( peXpro ) <> *null;

         k1y627.t@Xpro = peXpro;
         setll %kds( k1y627 : 4 ) set627;
         if not %equal( set627 );
           return *off;
         endif;
         reade(n) %kds( k1y627 : 4 ) set627 @@DsI627;
         dow not %eof( set627 );
           @@Ds627C += 1;
           eval-corr @@Ds627( @@Ds627C ) = @@DsI627;
           reade(n) %kds( k1y627 : 4 ) set627 @@DsI627;
         enddo;

       else;

         setll %kds( k1y627 : 3 ) set627;
         if not %equal( set627 );
           return *off;
         endif;
         reade(n) %kds( k1y627 : 3 ) set627 @@DsI627;
         dow not %eof( set627 );
           @@Ds627C += 1;
           eval-corr @@Ds627( @@Ds627C ) = @@DsI627;
           reade(n) %kds( k1y627 : 3 ) set627 @@DsI627;
         enddo;

       endif;

       if %addr( peDs627 ) <> *null;
         eval-corr peDs627 = @@Ds627;
       endif;

       if %addr( peDs627C ) <> *null;
         eval peDs627C = @@Ds627C;
       endif;

       return *on;

      /end-free

     P SVPVID_getExtensionVida...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getEdadMaximaDeVida: Retorna Edad Máxima de Vida.     *
     ?*                                                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cantidad de polizas                  *
     ?*     peXpro   ( input  ) Código de Producto                   *
     ?*     peEdma   ( output ) Edad Máxima                          *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPVID_getEdadMaximaDeVida...
     P                 b                   export
     D SVPVID_getEdadMaximaDeVida...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       6  0 const
     D   peEdma                       2  0 options( *nopass : *omit )

     D   @@Ds627       ds                  likeds( dsSet627_t ) dim( 999 )
     D   @@Ds627C      s             10i 0

      /free

       SVPVID_inz();

       clear @@Ds627;
       clear @@Ds627C;

       if SVPVID_getExtensionVida( peArcd : peRama : peArse : PeXpro :
                                  @@Ds627 : @@Ds627C );

         peEdma = @@Ds627(@@Ds627C).t@Edma;
         return *on;

       endif;

       return *off;

      /end-free

     P SVPVID_getEdadMaximaDeVida...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getEdadMinimaDeVida: Retorna Edad Mínima de Vida.     *
     ?*                                                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cantidad de polizas                  *
     ?*     peXpro   ( input  ) Código de Producto                   *
     ?*     peEdmi   ( output ) Edad Mínima                          *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPVID_getEdadMinimaDeVida...
     P                 b                   export
     D SVPVID_getEdadMinimaDeVida...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       6  0 const
     D   peEdmi                       2  0 options( *nopass : *omit )

     D   @@Ds627       ds                  likeds( dsSet627_t ) dim( 999 )
     D   @@Ds627C      s             10i 0

      /free

       SVPVID_inz();

       clear @@Ds627;
       clear @@Ds627C;

       if SVPVID_getExtensionVida( peArcd : peRama : peArse : PeXpro :
                                  @@Ds627 : @@Ds627C );

         peEdmi = @@Ds627(@@Ds627C).t@Edmi;
         return *on;

       endif;

       return *off;

      /end-free

     P SVPVID_getEdadMinimaDeVida...
     P                 e
     ?* ------------------------------------------------------------ *
     ?* SVPVID_getPahev1(): Retorna datos de detalle por suplemento  *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     pePaco   ( input  ) Código de Parentesco      (opcional) *
     ?*     peSuop   ( input  ) Suplemento de la Operación(opcional) *
     ?*     peDsV1   ( output ) Est. de Componente        (opcional) *
     ?*     peDsV1C  ( output ) Cant. de Componentes      (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPVID_getPahev1...
     P                 b                   export
     D SVPVID_getPahev1...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       6  0 options( *nopass : *omit ) const
     D   pePaco                       3  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsV1                            likeds( dsPahev1_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsV1C                     10i 0 options( *nopass : *omit )

     D   k1yev1        ds                  likerec( p1hev1 : *key   )
     D   @@DsIV1       ds                  likerec( p1hev1 : *input )
     D   @@DsV1        ds                  likeds( dsPahev1_t ) dim( 999 )
     D   @@DsV1C       s             10i 0

      /free

       SVPVID_inz();

       k1yev1.v1empr = peEmpr;
       k1yev1.v1sucu = peSucu;
       k1yev1.v1arcd = peArcd;
       k1yev1.v1spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( pePaco ) <> *null and
                %addr( peSuop ) <> *null;

                k1yev1.v1Sspo = peSspo;
                k1yev1.v1rama = peRama;
                k1yev1.v1arse = peArse;
                k1yev1.v1oper = peOper;
                k1yev1.v1poco = pePoco;
                k1yev1.v1Paco = pePaco;
                k1yev1.v1Suop = peSuop;
                setll %kds( k1yev1 : 11 ) pahev1;
                if not %equal( pahev1 );
                  return *off;
                endif;
                reade(n) %kds( k1yev1 : 11 ) pahev1 @@DsIV1;
                dow not %eof( pahev1 );
                  @@DsV1C += 1;
                  eval-corr @@DsV1( @@DsV1C ) = @@DsIV1;
                 reade(n) %kds( k1yev1 : 11 ) pahev1 @@DsIV1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( pePaco ) <> *null and
                %addr( peSuop ) =  *null;

                k1yev1.v1Sspo = peSspo;
                k1yev1.v1rama = peRama;
                k1yev1.v1arse = peArse;
                k1yev1.v1oper = peOper;
                k1yev1.v1poco = pePoco;
                k1yev1.v1Paco = pePaco;
                setll %kds( k1yev1 : 10 ) pahev1;
                if not %equal( pahev1 );
                  return *off;
                endif;
                reade(n) %kds( k1yev1 : 10 ) pahev1 @@DsIV1;
                dow not %eof( pahev1 );
                  @@DsV1C += 1;
                  eval-corr @@DsV1( @@DsV1C ) = @@DsIV1;
                 reade(n) %kds( k1yev1 : 10 ) pahev1 @@DsIV1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev1.v1Sspo = peSspo;
                k1yev1.v1rama = peRama;
                k1yev1.v1arse = peArse;
                k1yev1.v1oper = peOper;
                k1yev1.v1poco = pePoco;
                setll %kds( k1yev1 : 9 ) pahev1;
                if not %equal( pahev1 );
                  return *off;
                endif;
                reade(n) %kds( k1yev1 : 9 ) pahev1 @@DsIV1;
                dow not %eof( pahev1 );
                  @@DsV1C += 1;
                  eval-corr @@DsV1( @@DsV1C ) = @@DsIV1;
                 reade(n) %kds( k1yev1 : 9 ) pahev1 @@DsIV1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev1.v1Sspo = peSspo;
                k1yev1.v1Rama = peRama;
                k1yev1.v1Arse = peArse;
                k1yev1.v1Oper = peOper;
                setll %kds( k1yev1 : 8 ) pahev1;
                if not %equal( pahev1 );
                  return *off;
                endif;
                reade(n) %kds( k1yev1 : 8 ) pahev1 @@DsIV1;
                dow not %eof( pahev1 );
                  @@DsV1C += 1;
                  eval-corr @@DsV1( @@DsV1C ) = @@DsIV1;
                 reade(n) %kds( k1yev1 : 8 ) pahev1 @@DsIV1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev1.v1Sspo = peSspo;
                k1yev1.v1Rama = peRama;
                k1yev1.v1Arse = peArse;
                setll %kds( k1yev1 : 7 ) pahev1;
                if not %equal( pahev1 );
                  return *off;
                endif;
                reade(n) %kds( k1yev1 : 7 ) pahev1 @@DsIV1;
                dow not %eof( pahev1 );
                  @@DsV1C += 1;
                  eval-corr @@DsV1( @@DsV1C ) = @@DsIV1;
                 reade(n) %kds( k1yev1 : 7 ) pahev1 @@DsIV1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev1.v1Sspo = peSspo;
                k1yev1.v1Rama = peRama;
                setll %kds( k1yev1 : 6 ) pahev1;
                if not %equal( pahev1 );
                  return *off;
                endif;
                reade(n) %kds( k1yev1 : 6 ) pahev1 @@DsIV1;
                dow not %eof( pahev1 );
                  @@DsV1C += 1;
                  eval-corr @@DsV1( @@DsV1C ) = @@DsIV1;
                 reade(n) %kds( k1yev1 : 6 ) pahev1 @@DsIV1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev1.v1Sspo = peSspo;
                setll %kds( k1yev1 : 5 ) pahev1;
                if not %equal( pahev1 );
                  return *off;
                endif;
                reade(n) %kds( k1yev1 : 5 ) pahev1 @@DsIV1;
                dow not %eof( pahev1 );
                  @@DsV1C += 1;
                  eval-corr @@DsV1( @@DsV1C ) = @@DsIV1;
                 reade(n) %kds( k1yev1 : 5 ) pahev1 @@DsIV1;
                enddo;

           other;

             setll %kds( k1yev1 : 4 ) pahev1;
             if not %equal( pahev1 );
               return *off;
             endif;
             reade(n) %kds( k1yev1 : 4 ) pahev1 @@DsIV1;
             dow not %eof( pahev1 );
               @@DsV1C += 1;
               eval-corr @@DsV1( @@DsV1C ) = @@DsIV1;
              reade(n) %kds( k1yev1 : 4 ) pahev1 @@DsIV1;
             enddo;
         endsl;
       else;

         setll %kds( k1yev1 : 4 ) pahev1;
         if not %equal( pahev1 );
           return *off;
         endif;
         reade(n) %kds( k1yev1 : 4 ) pahev1 @@DsIV1;
         dow not %eof( pahev1 );
           @@DsV1C += 1;
           eval-corr @@DsV1( @@DsV1C ) = @@DsIV1;
          reade(n) %kds( k1yev1 : 4 ) pahev1 @@DsIV1;
         enddo;
       endif;

       if %addr( peDsV1 ) <> *null;
         eval-corr peDsV1 = @@DsV1;
       endif;

       if %addr( peDsV1C ) <> *null;
         eval peDsV1C = @@DsV1C;
       endif;

       return *on;

      /end-free

     P SVPVID_getPahev1...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPVID_getPahev2(): Retorna datos de detalle por suplemento  *
     ?*                     Coberturas                               *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cantidad de polizas       (opcional) *
     ?*     peOper   ( input  ) Codigo de Operacion       (opcional) *
     ?*     pePoco   ( input  ) Nro. de Componente        (opcional) *
     ?*     pePaco   ( input  ) Código de Parentesco      (opcional) *
     ?*     peSuop   ( input  ) Suplemento de la Operación(opcional) *
     ?*     peDsV2   ( output ) Riesgos/Coberturas Compon (opcional) *
     ?*     peDsV2C  ( output ) Cant.Riesgo/Cobert.Compon (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPVID_getPahev2...
     P                 b                   export
     D SVPVID_getPahev2...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       6  0 options( *nopass : *omit ) const
     D   pePaco                       3  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsV2                            likeds( dsPahev2_t ) dim( 99999 )
     D                                     options( *nopass : *omit )
     D   peDsV2C                     10i 0 options( *nopass : *omit )

     D   k1yev2        ds                  likerec( p1hev2 : *key   )
     D   @@DsIV2       ds                  likerec( p1hev2 : *input )
     D   @@DsV2        ds                  likeds( dsPahev2_t ) dim( 999 )
     D   @@DsV2C       s             10i 0

      /free

       SVPVID_inz();

       k1yev2.v2empr = peEmpr;
       k1yev2.v2sucu = peSucu;
       k1yev2.v2arcd = peArcd;
       k1yev2.v2spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( pePaco ) <> *null and
                %addr( peSuop ) <> *null;

                k1yev2.v2Sspo = peSspo;
                k1yev2.v2rama = peRama;
                k1yev2.v2arse = peArse;
                k1yev2.v2oper = peOper;
                k1yev2.v2poco = pePoco;
                k1yev2.v2Paco = pePaco;
                k1yev2.v2Suop = peSuop;
                setll %kds( k1yev2 : 11 ) pahev2;
                if not %equal( pahev2 );
                  return *off;
                endif;
                reade(n) %kds( k1yev2 : 11 ) pahev2 @@DsIV2;
                dow not %eof( pahev2 );
                  @@DsV2C += 1;
                  eval-corr @@DsV2( @@DsV2C ) = @@DsIV2;
                 reade(n) %kds( k1yev2 : 11 ) pahev2 @@DsIV2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( pePaco ) <> *null and
                %addr( peSuop ) =  *null;

                k1yev2.v2Sspo = peSspo;
                k1yev2.v2rama = peRama;
                k1yev2.v2arse = peArse;
                k1yev2.v2oper = peOper;
                k1yev2.v2poco = pePoco;
                k1yev2.v2Paco = pePaco;
                setll %kds( k1yev2 : 10 ) pahev2;
                if not %equal( pahev2 );
                  return *off;
                endif;
                reade(n) %kds( k1yev2 : 10 ) pahev2 @@DsIV2;
                dow not %eof( pahev2 );
                  @@DsV2C += 1;
                  eval-corr @@DsV2( @@DsV2C ) = @@DsIV2;
                 reade(n) %kds( k1yev2 : 10 ) pahev2 @@DsIV2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev2.v2Sspo = peSspo;
                k1yev2.v2rama = peRama;
                k1yev2.v2arse = peArse;
                k1yev2.v2oper = peOper;
                k1yev2.v2poco = pePoco;
                setll %kds( k1yev2 : 9 ) pahev2;
                if not %equal( pahev2 );
                  return *off;
                endif;
                reade(n) %kds( k1yev2 : 9 ) pahev2 @@DsIV2;
                dow not %eof( pahev2 );
                  @@DsV2C += 1;
                  eval-corr @@DsV2( @@DsV2C ) = @@DsIV2;
                 reade(n) %kds( k1yev2 : 9 ) pahev2 @@DsIV2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev2.v2Sspo = peSspo;
                k1yev2.v2Rama = peRama;
                k1yev2.v2Arse = peArse;
                k1yev2.v2Oper = peOper;
                setll %kds( k1yev2 : 8 ) pahev2;
                if not %equal( pahev2 );
                  return *off;
                endif;
                reade(n) %kds( k1yev2 : 8 ) pahev2 @@DsIV2;
                dow not %eof( pahev2 );
                  @@DsV2C += 1;
                  eval-corr @@DsV2( @@DsV2C ) = @@DsIV2;
                 reade(n) %kds( k1yev2 : 8 ) pahev2 @@DsIV2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev2.v2Sspo = peSspo;
                k1yev2.v2Rama = peRama;
                k1yev2.v2Arse = peArse;
                setll %kds( k1yev2 : 7 ) pahev2;
                if not %equal( pahev2 );
                  return *off;
                endif;
                reade(n) %kds( k1yev2 : 7 ) pahev2 @@DsIV2;
                dow not %eof( pahev2 );
                  @@DsV2C += 1;
                  eval-corr @@DsV2( @@DsV2C ) = @@DsIV2;
                 reade(n) %kds( k1yev2 : 7 ) pahev2 @@DsIV2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev2.v2Sspo = peSspo;
                k1yev2.v2Rama = peRama;
                setll %kds( k1yev2 : 6 ) pahev2;
                if not %equal( pahev2 );
                  return *off;
                endif;
                reade(n) %kds( k1yev2 : 6 ) pahev2 @@DsIV2;
                dow not %eof( pahev2 );
                  @@DsV2C += 1;
                  eval-corr @@DsV2( @@DsV2C ) = @@DsIV2;
                 reade(n) %kds( k1yev2 : 6 ) pahev2 @@DsIV2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null and
                %addr( pePaco ) =  *null and
                %addr( peSuop ) =  *null;

                k1yev2.v2Sspo = peSspo;
                setll %kds( k1yev2 : 5 ) pahev2;
                if not %equal( pahev2 );
                  return *off;
                endif;
                reade(n) %kds( k1yev2 : 5 ) pahev2 @@DsIV2;
                dow not %eof( pahev2 );
                  @@DsV2C += 1;
                  eval-corr @@DsV2( @@DsV2C ) = @@DsIV2;
                 reade(n) %kds( k1yev2 : 5 ) pahev2 @@DsIV2;
                enddo;

           other;

             setll %kds( k1yev2 : 4 ) pahev2;
             if not %equal( pahev2 );
               return *off;
             endif;
             reade(n) %kds( k1yev2 : 4 ) pahev2 @@DsIV2;
             dow not %eof( pahev2 );
               @@DsV2C += 1;
               eval-corr @@DsV2( @@DsV2C ) = @@DsIV2;
              reade(n) %kds( k1yev2 : 4 ) pahev2 @@DsIV2;
             enddo;
         endsl;
       else;

         setll %kds( k1yev2 : 4 ) pahev2;
         if not %equal( pahev2 );
           return *off;
         endif;
         reade(n) %kds( k1yev2 : 4 ) pahev2 @@DsIV2;
         dow not %eof( pahev2 );
           @@DsV2C += 1;
           eval-corr @@DsV2( @@DsV2C ) = @@DsIV2;
          reade(n) %kds( k1yev2 : 4 ) pahev2 @@DsIV2;
         enddo;
       endif;

       if %addr( peDsV2 ) <> *null;
         eval-corr peDsV2 = @@DsV2;
       endif;

       if %addr( peDsV2C ) <> *null;
         eval peDsV2C = @@DsV2C;
       endif;

       return *on;

      /end-free

     P SVPVID_getPahev2...
     P                 e
     ?* ------------------------------------------------------------ *
     ?* SVPVID_getUltCompoVida() : Retorna Ultimo Componente de Vida.*
     ?*                                                              *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cantidad de polizas                  *
     ?*     peOper   ( input  ) Codigo de Operacion                  *
     ?*     pePoco   ( Output ) Componente                           *
     ?*     pePaco   ( Output ) Parentezco                           *
     ?*                                                              *
     ?* Retorna: *on = Si existe / *off = No existe                  *
     ?* ------------------------------------------------------------ *
     P SVPVID_getUltCompoVida...
     P                 b                   export
     D SVPVID_getUltCompoVida...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       6  0
     D   pePaco                       3  0

     D   k1yev0        ds                  likerec( p1hev0 : *key   )

      /free

       SVPVID_inz();

       k1yev0.v0empr = peEmpr;
       k1yev0.v0sucu = peSucu;
       k1yev0.v0arcd = peArcd;
       k1yev0.v0spol = peSpol;
       k1yev0.v0rama = perama;
       k1yev0.v0arse = pearse;
       k1yev0.v0oper = peoper;
       setgt %kds(k1yev0:7) pahev0;
       readpe(n) %kds(k1yev0:7) pahev0;
       if %found(pahev0);
         pePoco = v0poco ;
         pePaco = v0paco ;
         return *on  ;
       endif;

         pePoco = *zeros ;
         pePaco = *zeros ;
         return *off ;

      /end-free

     P SVPVID_getUltCompoVida...
     P                 e
