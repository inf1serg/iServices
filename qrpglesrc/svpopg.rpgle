     H nomain
      * ************************************************************ *
      * SVPOPG: Programa de Servicio.                                *
      *         Ordenes de Pago                                      *
      * ------------------------------------------------------------ *
      * Segovia Jennifer                  ** 18-Ene-2021 **          *
      * ************************************************************ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *
     Fcnhopa    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpopg_h.rpgle'
      * ------------------------------------------------------------ *
      * Setea error global
      * --------------------------------------------------- *
     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

     D wrepl           s          65535a

      *--- Definicion de Procedimiento ----------------------------- *
     ?* ------------------------------------------------------------ *
     ?* SVPOPG_inz(): Inicializa módulo.                             *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPOPG_inz      B                   export
     D SVPOPG_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(cnhopa);
         open cnhopa;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPOPG_inz      E

     ?* ------------------------------------------------------------ *
     ?* SVPOPG_End(): Finaliza módulo.                               *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPOPG_End      B                   export
     D SVPOPG_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPOPG_End      E

     ?* ------------------------------------------------------------ *
     ?* SVPOPG_Error(): Retorna el último error del service program  *
     ?*                                                              *
     ?*     peEnbr   (output)  Número de error (opcional)            *
     ?*                                                              *
     ?* Retorna: Mensaje de error.                                   *
     ?* ------------------------------------------------------------ *

     P SVPOPG_Error    B                   export
     D SVPOPG_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPOPG_Error    E

      * ------------------------------------------------------------ *
      * SVPOPG_getCnhopa: Retorna datos de ordenes de pago           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArtc   ( input  ) Código Area Técnica                  *
      *     pePacp   ( input  ) Nro. de Comprobante de Pago          *
      *     peDsPa   ( output ) Estrutura de Ordenes de Pago         *
      *     peDsPaC  ( output ) Cantidad de Ordenes de Pago          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPOPG_getCnhopa...
     P                 B                   export
     D SVPOPG_getCnhopa...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 options( *nopass : *omit ) const
     D   peDsPa                            likeds( dsCnhopa_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsPaC                     10i 0 options( *nopass : *omit )

     D   k1yopa        ds                  likerec( c1hopa : *key )
     D   @@DsIPa       ds                  likerec( c1hopa : *input )
     D   @@DsPa        ds                  likeds( dsCnhopa_t ) dim( 9999 )
     D   @@DsPaC       s             10i 0

      /free

       SVPOPG_inz();

       clear @@DsPa;
       @@DsPaC = 0;

       k1yopa.paEmpr = peEmpr;
       k1yopa.paSucu = peSucu;
       k1yopa.paArtc = peArtc;

       if %parms > 3 and %addr( pePacp ) <> *null;

         k1yopa.paPacp = pePacp;
         setll %kds( k1yopa : 4 ) cnhopa;
         if not %equal( cnhopa );
           return *off;
         endif;
         reade(n) %kds( k1yopa : 4 ) cnhopa @@DsIPa;
         dow not %eof( cnhopa );
           @@DsPaC += 1;
           eval-corr @@DsPa( @@DsPaC ) = @@DsIPa;
           reade(n) %kds( k1yopa : 4 ) cnhopa @@DsIPa;
         enddo;

       else;

         setll %kds( k1yopa : 3 ) cnhopa;
         if not %equal( cnhopa );
           return *off;
         endif;
         reade(n) %kds( k1yopa : 3 ) cnhopa @@DsIPa;
         dow not %eof( cnhopa );
           @@DsPaC += 1;
           eval-corr @@DsPa( @@DsPaC ) = @@DsIPa;
           reade(n) %kds( k1yopa : 3 ) cnhopa @@DsIPa;
         enddo;
       endif;

       if %addr( peDsPa ) <> *null;
         eval-corr peDsPa = @@DsPa;
       endif;

       if %addr( peDsPaC ) <> *null;
          peDsPaC = @@DsPaC;
       endif;

       return *on;

      /end-free

     P SVPOPG_getCnhopa...
     P                 E

      * ------------------------------------------------------------ *
      * SVPOPG_getEstadoCnhopa: Retorna estado de la orden de pago   *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArtc   ( input  ) Código Area Técnica                  *
      *     pePacp   ( input  ) Nro. de Comprobante de Pago          *
      *     peEsta   ( output ) Código de Estado                     *
      *     peDest   ( output ) Descripción de Estado    (opcional)  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPOPG_getEstadoCnhopa...
     P                 B                   export
     D SVPOPG_getEstadoCnhopa...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peEsta                       1
     D   peDest                      40    options( *nopass : *omit )

     D @@DsPa          ds                  likeds ( dscnhopa_t ) dim( 9999 )
     D @@DsPaC         s             10i 0

      /free

       SVPOPG_inz();

       clear @@DsPa;
       @@DsPaC = 0;

       if SVPOPG_getCnhopa( peEmpr
                          : peSucu
                          : peArtc
                          : pePacp
                          : @@DsPa
                          : @@DsPaC );

         peEsta = @@DsPa(@@DsPaC).paStop;

         if %parms > 5 and %addr( peDest ) <> *null;
           peDest = SVPDES_estadoOrdenDePago( peEsta );
         endif;

         return *on;
       endif;

       return *off;

      /end-free

     P SVPOPG_getEstadoCnhopa...
     P                 E

      * ------------------------------------------------------------ *
      * SVPOPG_updCnhopa: Actualiza orden de pago                    *
      *                                                              *
      *     peDsPa   ( input  ) Estructura de Orden de Pago          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPOPG_updCnhopa...
     P                 B                   export
     D SVPOPG_updCnhopa...
     D                 pi              n
     D   peDsPa                            likeds( dsCnhopa_t ) const

     D k1yipa          ds                  likerec( c1hopa : *key )
     D dsOipa          ds                  likerec( c1hopa : *output )

      /free

       SVPOPG_inz();

       k1yipa.paEmpr = peDsPa.paEmpr;
       k1yipa.paSucu = peDsPa.paSucu;
       k1yipa.paArtc = peDsPa.paArtc;
       k1yipa.paPacp = peDsPa.paPacp;
       chain %kds( k1yipa : 4 ) cnhopa;
       if %found( cnhopa );
         eval-corr dsOIpa = peDspa;
         update c1hopa dsOIpa;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPOPG_updCnhopa...
     P                 E
