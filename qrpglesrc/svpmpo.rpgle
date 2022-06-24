     H nomain
      * ************************************************************ *
      * SVPMPO: Programa de Servicio.                                *
      *         Mercado Pago                                         *
      * ------------------------------------------------------------ *
      * Segovia Jennifer                  ** 16-Ago-2020 **          *
      * ************************************************************ *
      * Modificaciones:                                              *
      *  JSN 21/09/2021 - Se agrega condición en el _setPahmpo(),    *
      *                   para evitar duplicidad en los registros    *
      * ************************************************************ *
     Fpahmpo    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpmpo_h.rpgle'
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
     ?* SVPMPO_inz(): Inicializa módulo.                             *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPMPO_inz      B                   export
     D SVPMPO_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahmpo);
         open pahmpo;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPMPO_inz      E

     ?* ------------------------------------------------------------ *
     ?* SVPMPO_End(): Finaliza módulo.                               *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPMPO_End      B                   export
     D SVPMPO_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPMPO_End      E

     ?* ------------------------------------------------------------ *
     ?* SVPMPO_Error(): Retorna el último error del service program  *
     ?*                                                              *
     ?*     peEnbr   (output)  Número de error (opcional)            *
     ?*                                                              *
     ?* Retorna: Mensaje de error.                                   *
     ?* ------------------------------------------------------------ *

     P SVPMPO_Error    B                   export
     D SVPMPO_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPMPO_Error    E

      * ------------------------------------------------------------ *
      * SVPMPO_getPahmpo: Retorna datos de mercado pago              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peTdoc   ( input  ) Tipo de Documento                    *
      *     peNrdo   ( input  ) Número de Documento                  *
      *     peRama   ( input  ) Código de Rama            (Opcional) *
      *     pePoli   ( input  ) Mes de Proceso            (Opcional) *
      *     peDsVw   ( output ) Estrutura de Facturas Web (Opcional) *
      *     peDsVwC  ( output ) Cantidad de Facturas Web  (Opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPMPO_getPahmpo...
     P                 B                   export
     D SVPMPO_getPahmpo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peTdoc                       2  0 const
     D   peNrdo                       8  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   pePoli                       7  0 options( *nopass : *omit ) const
     D   peDsMp                            likeds( dsPahmpo_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsMpC                     10i 0 options( *nopass : *omit )

     D   k1ympo        ds                  likerec( p1hmpo : *key )
     D   @@DsIMp       ds                  likerec( p1hmpo : *input )
     D   @@DsMp        ds                  likeds( dsPahmpo_t ) dim( 9999 )
     D   @@DsMpC       s             10i 0

      /free

       SVPMPO_inz();

       clear @@DsMp;
       @@DsMpC = 0;

       k1ympo.mpEmpr = peEmpr;
       k1ympo.mpSucu = peSucu;
       k1ympo.mpTdoc = peTdoc;
       k1ympo.mpNdoc = peNrdo;

       if %parms >= 4;
         Select;
           when %addr( peRama ) <> *null and
                %addr( pePoli ) <> *null;

             k1ympo.mpRama = peRama;
             k1ympo.mpPoli = pePoli;
             setll %kds( k1ympo : 6 ) pahmpo;
             if not %equal( pahmpo );
               return *off;
             endif;
             reade(n) %kds( k1ympo : 6 ) pahmpo @@DsIMp;
             dow not %eof( pahmpo );
               @@DsMpC += 1;
               eval-corr @@DsMp( @@DsMpC ) = @@DsIMp;
               reade(n) %kds( k1ympo : 6 ) pahmpo @@DsIMp;
             enddo;

           when %addr( peRama ) <> *null and
                %addr( pePoli ) =  *null and

             k1ympo.mpRama = peRama;
             setll %kds( k1ympo : 5 ) pahmpo;
             if not %equal( pahmpo );
               return *off;
             endif;
             reade(n) %kds( k1ympo : 5 ) pahmpo @@DsIMp;
             dow not %eof( pahmpo );
               @@DsMpC += 1;
               eval-corr @@DsMp( @@DsMpC ) = @@DsIMp;
               reade(n) %kds( k1ympo : 5 ) pahmpo @@DsIMp;
             enddo;

           other;

             setll %kds( k1ympo : 4 ) pahmpo;
             if not %equal( pahmpo );
               return *off;
             endif;
             reade(n) %kds( k1ympo : 4 ) pahmpo @@DsIMp;
             dow not %eof( pahmpo );
               @@DsMpC += 1;
               eval-corr @@DsMp( @@DsMpC ) = @@DsIMp;
               reade(n) %kds( k1ympo : 4 ) pahmpo @@DsIMp;
             enddo;
         endsl;
       else;

         setll %kds( k1ympo : 4 ) pahmpo;
         if not %equal( pahmpo );
           return *off;
         endif;
         reade(n) %kds( k1ympo : 4 ) pahmpo @@DsIMp;
         dow not %eof( pahmpo );
           @@DsMpC += 1;
           eval-corr @@DsMp( @@DsMpC ) = @@DsIMp;
           reade(n) %kds( k1ympo : 4 ) pahmpo @@DsIMp;
         enddo;
       endif;

       if %addr( peDsMp ) <> *null;
         eval-corr peDsMp = @@DsMp;
       endif;

       if %addr( peDsMpC ) <> *null;
          peDsMpC = @@DsMpC;
       endif;

       return *on;

      /end-free

     P SVPMPO_getPahmpo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPMPO_setPahmpo: Graba datos de Mercado Pago                *
      *                                                              *
      *     peDsMp   ( input  ) Estructura de PAHMPO                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPMPO_setPahmpo...
     P                 B                   export
     D SVPMPO_setPahmpo...
     D                 pi              n
     D   peDsMp                            likeds( dsPahmpo_t )
     D                                     options( *nopass : *omit ) const

     D k1ympo          ds                  likerec( p1hmpo : *key )
     D @@DsOMp         ds                  likerec( p1hmpo : *output )

     D encontro        s               n

      /free

       SVPMPO_inz();

       encontro = *off;

       k1ympo.mpEmpr = peDsMp.mpEmpr;
       k1ympo.mpSucu = peDsMp.mpSucu;
       k1ympo.mpTdoc = peDsMp.mpTdoc;
       k1ympo.mpNdoc = peDsMp.mpNdoc;
       k1ympo.mpRama = peDsMp.mpRama;
       k1ympo.mpPoli = peDsMp.mpPoli;
       setll %kds( k1ympo : 6 ) pahmpo;
       reade %kds( k1ympo : 6 ) pahmpo;
       dow not %eof( pahmpo );
         if mpClid = peDsMp.mpClid;
           encontro = *on;
         endif;
         reade %kds( k1ympo : 6 ) pahmpo;
       enddo;

       if not encontro;
         eval-corr @@DsOMp = peDsMp;
         monitor;
           write p1hmpo @@DsOMp;
         on-error;
           return *off;
         endmon;
       endif;

       return *on;

      /end-free

     P SVPMPO_setPahmpo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPMPO_updPahmpo: Actualiza datos de Mercado Pago            *
      *                                                              *
      *     peDsMp   ( input  ) Estructura de PAHMPO                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPMPO_updPahmpo...
     P                 B                   export
     D SVPMPO_updPahmpo...
     D                 pi              n
     D   peDsMp                            likeds( dsPahmpo_t )
     D                                     options( *nopass : *omit ) const

     D k1ympo          ds                  likerec( p1hmpo : *key )
     D @@DsOMp         ds                  likerec( p1hmpo : *output )

      /free

       SVPMPO_inz();

       k1ympo.mpEmpr = peDsMp.mpEmpr;
       k1ympo.mpSucu = peDsMp.mpSucu;
       k1ympo.mpTdoc = peDsMp.mpTdoc;
       k1ympo.mpNdoc = peDsMp.mpNdoc;
       k1ympo.mpRama = peDsMp.mpRama;
       k1ympo.mpPoli = peDsMp.mpPoli;
       chain %kds( k1ympo : 6 ) pahmpo;
       if %found( pahmpo );
         eval-corr @@DsOMp = peDsMp;
         update p1hmpo @@DsOMp;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPMPO_updPahmpo...
     P                 E

