     H nomain
      * ************************************************************ *
      * SVPAGA: exportación SVPAGA                                   *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     02-Ago-2021             *
      * ------------------------------------------------------------ *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *> TEXT('Programa de Servicio: Autogestion Asegurados') <*     *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPAGA)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPAGA)) <*         *
      *> IGN: DLTSPLF FILE(SVPAGA)                           <*     *
      * ----------------------------------------------------------- *
      * Modificaciones:                                             *
      *                                                             *
      ***************************************************************
     Fpahag4    uf a e           k disk    usropn
     Fpahag5    uf a e           k disk    usropn
     Fpahag405  if   e           k disk    usropn rename(p1hag4 : p1hag405)
     Fpahtan    uf a e           k disk    usropn
      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpaga_h.rpgle'

     D Initialized     s              1n
     D wrepl           s          65535a
     D ErrN            s             10i 0
     D ErrM            s             80a


     D WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const

     D SetError        pr
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

      *--- Definicion de Procedimiento ----------------------------- *
      * ----------------------------------------------------------------- *
      * SVPAGA_getListaArrepentimiento(): Retorna Lista de arrepentimiento*
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peNivt   ( input  ) Tipo Nivel Intermediario              *
      *         peNivc   ( input  ) Codigo Nivel Intermediario            *
      *         peArcd   ( input  ) Código de Artículo       ( opcional ) *
      *         peSpol   ( input  ) Número de SuperPoliza    ( opcional ) *
      *         peRama   ( input  ) Rama                     ( opcional ) *
      *         peArse   ( input  ) Cant. Pólizas por Rama   ( opcional ) *
      *         peOper   ( input  ) Operación                ( opcional ) *
      *         pePoli   ( input  ) Póliza                   ( opcional ) *
      *         peLArr   ( output ) Lista de Arrepentimiento ( opcional ) *
      *         peLArrC  ( output ) Cantidad                 ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPAGA_getListaArrepentimiento...
     P                 B                   export
     D SVPAGA_getListaArrepentimiento...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 options( *Nopass : *Omit ) const
     D   peSpol                       9  0 options( *Nopass : *Omit ) const
     D   peRama                       2  0 options( *Nopass : *Omit ) const
     D   peArse                       2  0 options( *Nopass : *Omit ) const
     D   peOper                       7  0 options( *Nopass : *Omit ) const
     D   pePoli                       7  0 options( *Nopass : *Omit ) const
     D   peEndo                       7  0 options( *Nopass : *Omit ) const
     D   peLArr                            likeds(dsPahtan_t) dim(999)
     D                                     options( *Nopass : *Omit )
     D   peLArrC                     10i 0 options( *Nopass : *Omit )

     D   k1yagt        ds                  likerec( p1htan : *key    )
     D   @@DsIgt       ds                  likerec( p1htan : *input  )
     D   @@DsGt        ds                  likeds ( dsPahtan_t ) dim( 999 )
     D   @@DsGtC       s             10i 0

      /free

       SVPAGA_inz();

       clear @@DsGt;
       @@DsGtC = 0;

       k1yagt.anEmpr = peEmpr;
       k1yagt.anSucu = peSucu;
       k1yagt.anNivt = peNivt;
       k1yagt.anNivc = peNivc;

       if %parms >= 5;
         Select;
           when %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peEndo ) <> *null;

                k1yagt.anArcd = peArcd;
                k1yagt.anSpol = peSpol;
                k1yagt.anRama = peRama;
                k1yagt.anArse = peArse;
                k1yagt.anOper = peOper;
                k1yagt.anPoli = pePoli;
                k1yagt.anEndo = peEndo;
                setll %kds( k1yagt : 11 ) pahtan;
                if not %equal( pahtan );
                  return *off;
                endif;
                reade(n) %kds( k1yagt : 11 ) pahtan @@DsIGt;
                dow not %eof( pahtan );
                  @@DsGtC += 1;
                  eval-corr @@DsGt ( @@DsGtC ) = @@DsIGt;
                 reade(n) %kds( k1yagt : 11 ) pahtan @@DsIGt;
                enddo;

           when %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peEndo ) =  *null;

                k1yagt.anArcd = peArcd;
                k1yagt.anSpol = peSpol;
                k1yagt.anRama = peRama;
                k1yagt.anArse = peArse;
                k1yagt.anOper = peOper;
                k1yagt.anPoli = pePoli;
                setll %kds( k1yagt : 10 ) pahtan;
                if not %equal( pahtan );
                  return *off;
                endif;
                reade(n) %kds( k1yagt : 10 ) pahtan @@DsIGt;
                dow not %eof( pahtan );
                  @@DsGtC += 1;
                  eval-corr @@DsGt ( @@DsGtC ) = @@DsIGt;
                 reade(n) %kds( k1yagt : 10 ) pahtan @@DsIGt;
                enddo;

           when %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoli ) =  *null and
                %addr( peEndo ) =  *null;

                k1yagt.anArcd = peArcd;
                k1yagt.anSpol = peSpol;
                k1yagt.anRama = peRama;
                k1yagt.anArse = peArse;
                k1yagt.anOper = peOper;
                setll %kds( k1yagt : 9 ) pahtan;
                if not %equal( pahtan );
                  return *off;
                endif;
                reade(n) %kds( k1yagt : 9 ) pahtan @@DsIGt;
                dow not %eof( pahtan );
                  @@DsGtC += 1;
                  eval-corr @@DsGt ( @@DsGtC ) = @@DsIGt;
                 reade(n) %kds( k1yagt : 9 ) pahtan @@DsIGt;
                enddo;

           when %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoli ) =  *null and
                %addr( peEndo ) =  *null;

                k1yagt.anArcd = peArcd;
                k1yagt.anSpol = peSpol;
                k1yagt.anRama = peRama;
                k1yagt.anArse = peArse;
                setll %kds( k1yagt : 8 ) pahtan;
                if not %equal( pahtan );
                  return *off;
                endif;
                reade(n) %kds( k1yagt : 8 ) pahtan @@DsIGt;
                dow not %eof( pahtan );
                  @@DsGtC += 1;
                  eval-corr @@DsGt ( @@DsGtC ) = @@DsIGt;
                 reade(n) %kds( k1yagt : 8 ) pahtan @@DsIGt;
                enddo;

           when %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoli ) =  *null and
                %addr( peEndo ) =  *null;

                k1yagt.anArcd = peArcd;
                k1yagt.anSpol = peSpol;
                k1yagt.anRama = peRama;
                setll %kds( k1yagt : 7 ) pahtan;
                if not %equal( pahtan );
                  return *off;
                endif;
                reade(n) %kds( k1yagt : 7 ) pahtan @@DsIGt;
                dow not %eof( pahtan );
                  @@DsGtC += 1;
                  eval-corr @@DsGt ( @@DsGtC ) = @@DsIGt;
                 reade(n) %kds( k1yagt : 7 ) pahtan @@DsIGt;
                enddo;

           when %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoli ) =  *null and
                %addr( peEndo ) =  *null;

                k1yagt.anArcd = peArcd;
                k1yagt.anSpol = peSpol;
                setll %kds( k1yagt : 6 ) pahtan;
                if not %equal( pahtan );
                  return *off;
                endif;
                reade(n) %kds( k1yagt : 6 ) pahtan @@DsIGt;
                dow not %eof( pahtan );
                  @@DsGtC += 1;
                  eval-corr @@DsGt ( @@DsGtC ) = @@DsIGt;
                 reade(n) %kds( k1yagt : 6 ) pahtan @@DsIGt;
                enddo;

           when %addr( peArcd ) <> *null and
                %addr( peSpol ) =  *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoli ) =  *null and
                %addr( peEndo ) =  *null;

                k1yagt.anArcd = peArcd;
                setll %kds( k1yagt : 5 ) pahtan;
                if not %equal( pahtan );
                  return *off;
                endif;
                reade(n) %kds( k1yagt : 5 ) pahtan @@DsIGt;
                dow not %eof( pahtan );
                  @@DsGtC += 1;
                  eval-corr @@DsGt ( @@DsGtC ) = @@DsIGt;
                 reade(n) %kds( k1yagt : 5 ) pahtan @@DsIGt;
                enddo;
           other;
                setll %kds( k1yagt : 4 ) pahtan;
                if not %equal( pahtan );
                  return *off;
                endif;
                reade(n) %kds( k1yagt : 4 ) pahtan @@DsIGt;
                dow not %eof( pahtan );
                  @@DsGtC += 1;
                  eval-corr @@DsGt ( @@DsGtC ) = @@DsIGt;
                 reade(n) %kds( k1yagt : 4 ) pahtan @@DsIGt;
                enddo;
           endsl;
       else;

         setll  %kds( k1yagt : 4 ) pahtan;
         if not %equal( pahtan );
           return *off;
         endif;
         reade(n) %kds( k1yagt : 4 ) pahtan @@DsIGt;
         dow not %eof( pahtan );
           @@DsGtC += 1;
           eval-corr @@DsGt ( @@DsGtC ) = @@DsIGt;
           reade(n) %kds( k1yagt : 4 ) pahtan @@DsIGt;
         enddo;
       endif;

       if %addr( peLArr ) <> *null;
         eval-corr peLArr = @@DsGt;
       endif;

       if %addr( peLArrC ) <> *null;
         peLarrC = @@DsGtC;
       endif;

       return *on;

      /end-free

     P SVPAGA_getListaArrepentimiento...
     P                 E
      * ------------------------------------------------------------ *
      * SVPAGA_inz(): Inicializa módulo.                             *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPAGA_inz      B                   export
     D SVPAGA_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahag4);
          open pahag4;
       endif;

       if not %open(pahag5);
          open pahag5;
       endif;

       if not %open(pahag405);
          open pahag405;
       endif;

       if not %open(pahtan);
          open pahtan;
       endif;

      /end-free

     P SVPAGA_inz      E
      * ------------------------------------------------------------ *
      * SVPAGA_End(): Finaliza módulo.                               *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPAGA_End      B                   export
     D SVPAGA_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPAGA_End      E

      * ----------------------------------------------------------------- *
      * SVPAGA_getListaArrep72hrsXProd(): Retorna Lista de arrepentimiento*
      *                                   dentro de las 72 horas por pro- *
      *                                   ductor                          *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peNivt   ( input  ) Tipo Nivel Intermediario             *
      *          peNivc   ( input  ) Codigo Nivel Intermediario           *
      *          peLa72   ( output ) Lista de Arrepentimiento             *
      *          peLa72C  ( output ) Cantidad                             *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPAGA_getListaArrep72hrsXProd...
     P                 B                   export
     D SVPAGA_getListaArrep72hrsXProd...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peLa72                            likeds(dsPahtan_t) dim(999)
     D   peLa72C                     10i 0

     D  x              s             10i 0
     D  i              s             10i 0
     D  @@dd           s              2  0
     D  @@mm           s              2  0
     D  @@aa           s              4  0
     D  @@Fech         s              8  0
     D  @@Fec1         s              8  0
     D  @@Date         s               d
     D  @@DsAr         ds                  likeds(dsPahtan_t) dim(999)
     D  @@DsArC        s             10i 0

      /free

       SVPAGA_inz();

       PAR310X3 ( peEmpr : @@aa : @@mm : @@dd );
       @@Fech = (@@aa * 10000) + (@@mm * 100) + @@dd;
       @@Date = %date(@@Fech) - %days(3);
       @@Fec1 = %dec(@@Date);

       if SVPAGA_getListaArrepentimiento( peEmpr
                                        : peSucu
                                        : peNivt
                                        : peNivc
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : @@DsAr
                                        : @@DsArC );
         i = 0;
         for x = 1 to @@DsArC;
           if @@DsAr(x).anMar0 = '0' and ( @@DsAr(x).anFec1 >= @@Fec1 and
              @@DsAr(x).anFec1 <= @@Fech );

             i += 1;
             eval-corr peLa72(i) = @@DsAr(x);
           endif;
         endfor;

         peLa72C = i;
       endif;

       return *on;

      /end-free

     P SVPAGA_getListaArrep72hrsXProd...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPAGA_getPahag4(): Retorna datos del archivo PAHAG4.             *
      *                                                                   *
      *         peEmpr   ( input  ) Empresa                               *
      *         peSucu   ( input  ) Sucursal                              *
      *         peArcd   ( input  ) Código de Artículo                    *
      *         peSpol   ( input  ) Número de SuperPoliza                 *
      *         peRama   ( input  ) Rama                     ( opcional ) *
      *         peArse   ( input  ) Cant. Pólizas por Rama   ( opcional ) *
      *         peOper   ( input  ) Operación                ( opcional ) *
      *         pePoli   ( input  ) Póliza                   ( opcional ) *
      *         peEndo   ( input  ) Número de Endoso         ( opcional ) *
      *         peDsAg   ( output ) Lista de Arrepentimiento ( opcional ) *
      *         peDsAgC  ( output ) Cantidad                 ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPAGA_getPahag4...
     P                 B                   export
     D SVPAGA_getPahag4...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *Nopass : *Omit ) const
     D   peArse                       2  0 options( *Nopass : *Omit ) const
     D   peOper                       7  0 options( *Nopass : *Omit ) const
     D   pePoli                       7  0 options( *Nopass : *Omit ) const
     D   peEndo                       7  0 options( *Nopass : *Omit ) const
     D   peDsAg                            likeds(dsPahag4_t) dim(999)
     D                                     options( *Nopass : *Omit )
     D   peDsAgC                     10i 0 options( *Nopass : *Omit )

     D   k1yag4        ds                  likerec( p1hag4 : *key    )
     D   @@DsIg4       ds                  likerec( p1hag4 : *input  )
     D   @@DsG4        ds                  likeds ( dsPahag4_t ) dim( 999 )
     D   @@DsG4C       s             10i 0

      /free

       SVPAGA_inz();

       clear @@DsG4;
       @@DsG4C = 0;

       k1yag4.g4Empr = peEmpr;
       k1yag4.g4Sucu = peSucu;
       k1yag4.g4Arcd = peArcd;
       k1yag4.g4Spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peEndo ) <> *null;

                k1yag4.g4Rama = peRama;
                k1yag4.g4Arse = peArse;
                k1yag4.g4Oper = peOper;
                k1yag4.g4Poli = pePoli;
                k1yag4.g4Endo = peEndo;
                setll %kds( k1yag4 : 9 ) pahag4;
                if not %equal( pahag4 );
                  return *off;
                endif;
                reade(n) %kds( k1yag4 : 9 ) pahag4 @@DsIG4;
                dow not %eof( pahag4 );
                  @@DsG4C += 1;
                  eval-corr @@DsG4 ( @@DsG4C ) = @@DsIG4;
                 reade(n) %kds( k1yag4 : 9 ) pahag4 @@DsIG4;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoli ) <> *null and
                %addr( peEndo ) =  *null;

                k1yag4.g4Rama = peRama;
                k1yag4.g4Arse = peArse;
                k1yag4.g4Oper = peOper;
                k1yag4.g4Poli = pePoli;
                setll %kds( k1yag4 : 8 ) pahag4;
                if not %equal( pahag4 );
                  return *off;
                endif;
                reade(n) %kds( k1yag4 : 8 ) pahag4 @@DsIG4;
                dow not %eof( pahag4 );
                  @@DsG4C += 1;
                  eval-corr @@DsG4 ( @@DsG4C ) = @@DsIG4;
                 reade(n) %kds( k1yag4 : 8 ) pahag4 @@DsIG4;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoli ) =  *null and
                %addr( peEndo ) =  *null;

                k1yag4.g4Rama = peRama;
                k1yag4.g4Arse = peArse;
                k1yag4.g4Oper = peOper;
                setll %kds( k1yag4 : 7 ) pahag4;
                if not %equal( pahag4 );
                  return *off;
                endif;
                reade(n) %kds( k1yag4 : 7 ) pahag4 @@DsIG4;
                dow not %eof( pahag4 );
                  @@DsG4C += 1;
                  eval-corr @@DsG4 ( @@DsG4C ) = @@DsIG4;
                 reade(n) %kds( k1yag4 : 7 ) pahag4 @@DsIG4;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoli ) =  *null and
                %addr( peEndo ) =  *null;

                k1yag4.g4Rama = peRama;
                k1yag4.g4Arse = peArse;
                setll %kds( k1yag4 : 6 ) pahag4;
                if not %equal( pahag4 );
                  return *off;
                endif;
                reade(n) %kds( k1yag4 : 6 ) pahag4 @@DsIG4;
                dow not %eof( pahag4 );
                  @@DsG4C += 1;
                  eval-corr @@DsG4 ( @@DsG4C ) = @@DsIG4;
                 reade(n) %kds( k1yag4 : 6 ) pahag4 @@DsIG4;
                enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoli ) =  *null and
                %addr( peEndo ) =  *null;

                k1yag4.g4Rama = peRama;
                setll %kds( k1yag4 : 5 ) pahag4;
                if not %equal( pahag4 );
                  return *off;
                endif;
                reade(n) %kds( k1yag4 : 5 ) pahag4 @@DsIG4;
                dow not %eof( pahag4 );
                  @@DsG4C += 1;
                  eval-corr @@DsG4 ( @@DsG4C ) = @@DsIG4;
                 reade(n) %kds( k1yag4 : 5 ) pahag4 @@DsIG4;
                enddo;

           other;
                setll %kds( k1yag4 : 4 ) pahag4;
                if not %equal( pahag4 );
                  return *off;
                endif;
                reade(n) %kds( k1yag4 : 4 ) pahag4 @@DsIG4;
                dow not %eof( pahag4 );
                  @@DsG4C += 1;
                  eval-corr @@DsG4 ( @@DsG4C ) = @@DsIG4;
                 reade(n) %kds( k1yag4 : 4 ) pahag4 @@DsIG4;
                enddo;
           endsl;
       else;

         setll  %kds( k1yag4 : 4 ) pahag4;
         if not %equal( pahag4 );
           return *off;
         endif;
         reade(n) %kds( k1yag4 : 4 ) pahag4 @@DsIG4;
         dow not %eof( pahag4 );
           @@DsG4C += 1;
           eval-corr @@DsG4 ( @@DsG4C ) = @@DsIG4;
           reade(n) %kds( k1yag4 : 4 ) pahag4 @@DsIG4;
         enddo;
       endif;

       if %addr( peDsAg ) <> *null;
         eval-corr peDsAg = @@DsG4;
       endif;

       if %addr( peDsAgC ) <> *null;
         peDsAgC = @@DsG4C;
       endif;

       return *on;

      /end-free

     P SVPAGA_getPahag4...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPAGA_getListaArrepXProductor(): Retorna Lista de arrepentimiento*
      *                                   por productor.                  *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peNivt   ( input  ) Tipo Nivel Intermediario             *
      *          peNivc   ( input  ) Codigo Nivel Intermediario           *
      *          peLaPr   ( output ) Lista de Arrepentimiento             *
      *          peLaPrC  ( output ) Cantidad                             *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPAGA_getListaArrepXProductor...
     P                 B                   export
     D SVPAGA_getListaArrepXProductor...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peLaPr                            likeds(dsPahtan_t) dim(999)
     D   peLaPrC                     10i 0

     D  x              s             10i 0
     D  i              s             10i 0
     D  @@dd           s              2  0
     D  @@mm           s              2  0
     D  @@aa           s              4  0
     D  @@Fech         s              8  0
     D  @@Fec1         s              8  0
     D  @@Date         s               d

      /free

       SVPAGA_inz();

       peLaPrC = 0;
       clear peLaPr;

       if SVPAGA_getListaArrepentimiento( peEmpr
                                        : peSucu
                                        : peNivt
                                        : peNivc
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : *omit
                                        : peLaPr
                                        : peLaPrC );

       endif;

       return *on;

      /end-free

     P SVPAGA_getListaArrepXProductor...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPAGA_chkSolicitudXNres(): Chequea y retorna datos de solicitud  *
      *                             de arrepentimiento.                   *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peNres   ( input  ) ID Trámite                           *
      *          peArcd   ( output ) Código de Artículo      ( opcional ) *
      *          peSpol   ( output ) Número de SuperPoliza   ( opcional ) *
      *          peRama   ( output ) Rama                    ( opcional ) *
      *          peArse   ( output ) Cant. Pólizas por Rama  ( opcional ) *
      *          peOper   ( output ) Operación               ( opcional ) *
      *          pePoli   ( output ) Póliza                  ( opcional ) *
      *          peEndo   ( output ) Número de Endoso        ( opcional ) *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPAGA_chkSolicitudXNres...
     P                 B                   export
     D SVPAGA_chkSolicitudXNres...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNres                      30    const
     D   peArcd                       6  0 options( *Nopass : *Omit )
     D   peSpol                       9  0 options( *Nopass : *Omit )
     D   peRama                       2  0 options( *Nopass : *Omit )
     D   peArse                       2  0 options( *Nopass : *Omit )
     D   peOper                       7  0 options( *Nopass : *Omit )
     D   pePoli                       7  0 options( *Nopass : *Omit )
     D   peEndo                       7  0 options( *Nopass : *Omit )

     D  k1yg405        ds                  likerec( p1hag405 : *key   )

      /free

       SVPAGA_inz();

        k1yg405.g4Empr = peEmpr;
        k1yg405.g4Sucu = peSucu;
        k1yg405.g4Nres = peNres;
        chain(n) %kds( k1yg405 : 3 ) pahag405;
        if not %found( pahag405 );
          return *off;
        endif;

        if %parms >= 4 and %addr(peArcd) <> *NULL;
          peArcd = g4Arcd;
        endif;

        if %parms >= 5 and %addr(peSpol) <> *NULL;
          peSpol = g4Spol;
        endif;

        if %parms >= 6 and %addr(peRama) <> *NULL;
          peRama = g4Rama;
        endif;

        if %parms >= 7 and %addr(peArse) <> *NULL;
          peArse = g4Arse;
        endif;

        if %parms >= 8 and %addr(peOper) <> *NULL;
          peOper = g4Oper;
        endif;

        if %parms >= 9 and %addr(pePoli) <> *NULL;
          pePoli = g4Poli;
        endif;

        if %parms >= 10 and %addr(peEndo) <> *NULL;
          peEndo = g4Endo;
        endif;

        return *on;

      /end-free

     P SVPAGA_chkSolicitudXNres...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPAGA_updEstatusPahag4(): Actualiza estatus del archivo PAHAG4   *
      *                                                                   *
      *          peEmpr   ( input  ) Empresa                              *
      *          peSucu   ( input  ) Sucursal                             *
      *          peArcd   ( input  ) Código de Artículo                   *
      *          peSpol   ( input  ) Número de SuperPoliza                *
      *          peRama   ( input  ) Rama                                 *
      *          peArse   ( input  ) Cant. Pólizas por Rama               *
      *          peOper   ( input  ) Operación                            *
      *          pePoli   ( input  ) Póliza                               *
      *          peEndo   ( input  ) Número de Endoso                     *
      *          peEsta   ( input  ) Estatus                              *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPAGA_updEstatusPahag4...
     P                 B                   export
     D SVPAGA_updEstatusPahag4...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peEndo                       7  0 const
     D   peEsta                       1    const

     D  k1yag4         ds                  likerec( p1hag4 : *key )

      /free

       SVPAGA_inz();

       k1yag4.g4Empr = peEmpr;
       k1yag4.g4Sucu = peSucu;
       k1yag4.g4Arcd = peArcd;
       k1yag4.g4Spol = peSpol;
       k1yag4.g4Rama = peRama;
       k1yag4.g4Arse = peArse;
       k1yag4.g4Oper = peOper;
       k1yag4.g4Poli = pePoli;
       k1yag4.g4Endo = peEndo;
       chain %kds( k1yag4 : 9 ) pahag4;
       if %found( pahag4 );
         g4Mar5 = peEsta;
         update p1hag4;
       endif;

       return *on;

      /end-free

     P SVPAGA_updEstatusPahag4...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPAGA_updPahtan(): Actualiza datos en el archivo pahtan          *
      *                                                                   *
      *          peDsGt   ( input  ) Estrutura de pahtan                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPAGA_updPahtan...
     P                 B                   export
     D SVPAGA_updPahtan...
     D                 pi              n
     D   peDsGt                            likeds( dsPahtan_t ) const

     D  k1yagt         ds                  likerec( p1htan : *key    )
     D  dsOagt         ds                  likerec( p1htan : *output )

      /free

       SVPAGA_inz();

       k1yagt.anEmpr = peDsGt.anEmpr;
       k1yagt.anSucu = peDsGt.anSucu;
       k1yagt.anNivt = peDsGt.anNivt;
       k1yagt.anNivc = peDsGt.anNivc;
       k1yagt.anArcd = peDsGt.anArcd;
       k1yagt.anSpol = peDsGt.anSpol;
       k1yagt.anRama = peDsGt.anRama;
       k1yagt.anArse = peDsGt.anArse;
       k1yagt.anOper = peDsGt.anOper;
       k1yagt.anPoli = peDsGt.anPoli;
       k1yagt.anEndo = peDsGt.anEndo;
       chain %kds( k1yagt : 11 ) pahtan;
       if %found( pahtan );
         eval-corr dsOagt = peDsGt;
         update p1htan dsOagt;
         return *on;
       endif;

       return *on;

      /end-free

     P SVPAGA_updPahtan...
     P                 E

