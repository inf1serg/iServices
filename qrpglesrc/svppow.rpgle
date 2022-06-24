     H nomain
      * ************************************************************ *
      * SVPPOW: Programa de Servicio.                                *
      *         Polizas Web                                          *
      * ------------------------------------------------------------ *
      * Segovia Jennifer                  ** 23-Jul-2020 **          *
      * ************************************************************ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *
     Fpahpol08  if   e           k disk    usropn rename(p1hpol:p1hpol08)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svppow_h.rpgle'
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
     ?* SVPPOW_inz(): Inicializa módulo.                             *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPPOW_inz      B                   export
     D SVPPOW_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahpol08);
         open pahpol08;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPPOW_inz      E

     ?* ------------------------------------------------------------ *
     ?* SVPPOW_End(): Finaliza módulo.                               *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPPOW_End      B                   export
     D SVPPOW_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPPOW_End      E

     ?* ------------------------------------------------------------ *
     ?* SVPPOW_Error(): Retorna el último error del service program  *
     ?*                                                              *
     ?*     peEnbr   (output)  Número de error (opcional)            *
     ?*                                                              *
     ?* Retorna: Mensaje de error.                                   *
     ?* ------------------------------------------------------------ *

     P SVPPOW_Error    B                   export
     D SVPPOW_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPPOW_Error    E

      * ------------------------------------------------------------ *
      * SVPPOW_getPolizaAsegurado: Retorna datos de la poliza web    *
      *                            por asegurado.                    *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peAsen   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peCert   ( input  ) Certificado                          *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peArse   ( input  ) Cant de Polizas                      *
      *     peOper   ( input  ) Numero de Operacion                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPPOW_getPolizaAsegurado...
     P                 B                   export
     D SVPPOW_getPolizaAsegurado...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   pePoli                       7  0 options( *nopass : *omit ) const
     D   peCert                       9  0 options( *nopass : *omit ) const
     D   peArcd                       6  0 options( *nopass : *omit ) const
     D   peSpol                       9  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peDsP8                            likeds ( dsPahpol_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsP8C                     10i 0 options( *nopass : *omit )

     D   k1yep8        ds                  likerec( p1hpol08 : *key    )
     D   @@DsIP8       ds                  likerec( p1hpol08 : *input  )
     D   @@DsP8        ds                  likeds ( dsPahpol_t ) dim( 999 )
     D   @@DsP8C       s             10i 0

      /free

       SVPPOW_inz();

       clear peDsP8;
       peDsP8C = 0;

       k1yep8.poEmpr = peBase.peEmpr;
       k1yep8.poSucu = peBase.peSucu;
       k1yep8.poNivt = peBase.peNivt;
       k1yep8.poNivc = peBase.peNivc;
       k1yep8.poAsen = peAsen;

       if %parms >= 5;
         Select;
           when %addr( peRama ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peCert ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null;

                k1yep8.poRama = peRama;
                k1yep8.poPoli = pePoli;
                k1yep8.poCert = peCert;
                k1yep8.poArcd = peArcd;
                k1yep8.poSpol = peSpol;
                k1yep8.poArse = peArse;
                k1yep8.poOper = peOper;
                setll %kds( k1yep8 : 12 ) pahpol08;
                if not %equal( pahpol08 );
                  return *off;
                endif;
                reade(n) %kds( k1yep8 : 12 ) pahpol08 @@DsIP8;
                dow not %eof( pahpol08 );
                  @@DsP8C += 1;
                  eval-corr @@DsP8 ( @@DsP8C ) = @@DsIP8;
                 reade(n) %kds( k1yep8 : 12 ) pahpol08 @@DsIP8;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peCert ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null;

                k1yep8.poRama = peRama;
                k1yep8.poPoli = pePoli;
                k1yep8.poCert = peCert;
                k1yep8.poArcd = peArcd;
                k1yep8.poSpol = peSpol;
                k1yep8.poArse = peArse;
                setll %kds( k1yep8 : 11 ) pahpol08;
                if not %equal( pahpol08 );
                  return *off;
                endif;
                reade(n) %kds( k1yep8 : 11 ) pahpol08 @@DsIP8;
                dow not %eof( pahpol08 );
                  @@DsP8C += 1;
                  eval-corr @@DsP8 ( @@DsP8C ) = @@DsIP8;
                 reade(n) %kds( k1yep8 : 11 ) pahpol08 @@DsIP8;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peCert ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yep8.poRama = peRama;
                k1yep8.poPoli = pePoli;
                k1yep8.poCert = peCert;
                k1yep8.poArcd = peArcd;
                k1yep8.poSpol = peSpol;
                setll %kds( k1yep8 : 10 ) pahpol08;
                if not %equal( pahpol08 );
                  return *off;
                endif;
                reade(n) %kds( k1yep8 : 10 ) pahpol08 @@DsIP8;
                dow not %eof( pahpol08 );
                  @@DsP8C += 1;
                  eval-corr @@DsP8 ( @@DsP8C ) = @@DsIP8;
                 reade(n) %kds( k1yep8 : 10 ) pahpol08 @@DsIP8;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peCert ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yep8.poRama = peRama;
                k1yep8.poPoli = pePoli;
                k1yep8.poCert = peCert;
                k1yep8.poArcd = peArcd;
                setll %kds( k1yep8 : 9 ) pahpol08;
                if not %equal( pahpol08 );
                  return *off;
                endif;
                reade(n) %kds( k1yep8 : 9 ) pahpol08 @@DsIP8;
                dow not %eof( pahpol08 );
                  @@DsP8C += 1;
                  eval-corr @@DsP8 ( @@DsP8C ) = @@DsIP8;
                 reade(n) %kds( k1yep8 : 9 ) pahpol08 @@DsIP8;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peCert ) <> *null and
                %addr( peArcd ) =  *null and
                %addr( peSpol ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yep8.poRama = peRama;
                k1yep8.poPoli = pePoli;
                k1yep8.poCert = peCert;
                setll %kds( k1yep8 : 8 ) pahpol08;
                if not %equal( pahpol08 );
                  return *off;
                endif;
                reade(n) %kds( k1yep8 : 8 ) pahpol08 @@DsIP8;
                dow not %eof( pahpol08 );
                  @@DsP8C += 1;
                  eval-corr @@DsP8 ( @@DsP8C ) = @@DsIP8;
                 reade(n) %kds( k1yep8 : 8 ) pahpol08 @@DsIP8;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peCert ) =  *null and
                %addr( peArcd ) =  *null and
                %addr( peSpol ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yep8.poRama = peRama;
                k1yep8.poPoli = pePoli;
                setll %kds( k1yep8 : 7 ) pahpol08;
                if not %equal( pahpol08 );
                  return *off;
                endif;
                reade(n) %kds( k1yep8 : 7 ) pahpol08 @@DsIP8;
                dow not %eof( pahpol08 );
                  @@DsP8C += 1;
                  eval-corr @@DsP8 ( @@DsP8C ) = @@DsIP8;
                 reade(n) %kds( k1yep8 : 7 ) pahpol08 @@DsIP8;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( pePoli ) =  *null and
                %addr( peCert ) =  *null and
                %addr( peArcd ) =  *null and
                %addr( peSpol ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yep8.poRama = peRama;
                setll %kds( k1yep8 : 6 ) pahpol08;
                if not %equal( pahpol08 );
                  return *off;
                endif;
                reade(n) %kds( k1yep8 : 6 ) pahpol08 @@DsIP8;
                dow not %eof( pahpol08 );
                  @@DsP8C += 1;
                  eval-corr @@DsP8 ( @@DsP8C ) = @@DsIP8;
                 reade(n) %kds( k1yep8 : 6 ) pahpol08 @@DsIP8;
                enddo;

           other;
                setll %kds( k1yep8 : 5 ) pahpol08;
                if not %equal( pahpol08 );
                  return *off;
                endif;
                reade(n) %kds( k1yep8 : 5 ) pahpol08 @@DsIP8;
                dow not %eof( pahpol08 );
                  @@DsP8C += 1;
                  eval-corr @@DsP8 ( @@DsP8C ) = @@DsIP8;
                 reade(n) %kds( k1yep8 : 5 ) pahpol08 @@DsIP8;
                enddo;
           endsl;
       else;

         setll  %kds( k1yep8 : 5 ) pahpol08;
         if not %equal( pahpol08 );
           return *off;
         endif;
         reade(n) %kds( k1yep8 : 5 ) pahpol08 @@DsIP8;
         dow not %eof( pahpol08 );
           @@DsP8C += 1;
           eval-corr @@DsP8 ( @@DsP8C ) = @@DsIP8;
           reade(n) %kds( k1yep8 : 5 ) pahpol08 @@DsIP8;
         enddo;
       endif;

       if %addr( peDsP8 ) <> *null;
         eval-corr peDsP8 = @@DsP8;
       endif;

       if %addr( peDsP8C ) <> *null;
          peDsP8C = @@DsP8C;
       endif;

       return *on;

      /end-free

     P SVPPOW_getPolizaAsegurado...
     P                 E

