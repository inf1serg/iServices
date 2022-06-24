     H nomain
      * ************************************************************ *
      * SVPPOL: Programa de Servicio.                                *
      *         Polizas                                              *
      * ------------------------------------------------------------ *
      * Gomez Luis R.                     ** 21-Mar-2018 **          *
      * ************************************************************ *
      * Modificaciones:                                              *
      *   JSN 10/07/2018 - Se agrega los procedimientos:             *
      *                    _setSuscripcionPolizaElectronica()        *
      *                    _isSuscriptaPolizaElectronica()           *
      *                                                              *
      *   LRG 28/09/2018 -_setPoliza                                 *
      *                   _updPoliza                                 *
      *                   _getSuperPoliza                            *
      *                   _getArticulo                               *
      *                   _getPolizadesdeSuperpoliza                 *
      *                   _chkCondicionesComerciales                 *
      *                   _getCondicionesComerciales                 *
      *                   _setCondicionesComerciales                 *
      *                   _delCondicionesComerciales                 *
      *                   _chkTexto                                  *
      *                   _getTextos                                 *
      *                   _setTextos                                 *
      *                   _chkComisionesxInt                         *
      *                   _getComisionesxInt                         *
      *                   _setComisionesxInt                         *
      *                   _updComisionesxInt                         *
      *                   _delComisionesxInt                         *
      *                   _chkClausula                               *
      *                   _getClausulas                              *
      *                   _setClausulas                              *
      *                   _chkAnexo                                  *
      *                   _getAnexos                                 *
      *                   _setAnexos                                 *
      *                   _getVariacionDeComision                    *
      *                                                              *
      * GIO 30/05/2019 RM#5012 Las polizas de Vida y AP que          *
      *                cuenten con Iterfase no deben generar los     *
      *                PDF con certificados de incorporación.        *
      *                Asimismo discontinuar para todos los casos    *
      *                los certific. de cobertura tipo (pergamino).  *
      *                Se agrega el procedimiento:                   *
      *                - SVPPOL_isNominaExterna                      *
      * SGF 25/07/2019 Agrego _tipoAsistencia.                       *
      * LRG 08/04/2020 Nuevos procedimientos:                        *
      *                      _getPremioAcumulado                     *
      *                      _getPrimaAcumulada                      *
      * JSN 29/09/2020 Se agrega condición en el procedimiento       *
      *                _getComisionesxInt para obtener datos del     *
      *                archivo lógico PAHED302                       *
      * JSN 17/09/2020 Nuevos procedimientos:                        *
      *                 _getDeuda                                    *
      *                 _getProximaCuotaAVencer                      *
      * JSN 12/01/2021 Se modifica el procedimiento                  *
      *                _getProximaCuotaAVencer                       *
      * SGF 15/05/2021 Agrego:                                       *
      *                _permiteAnular                                *
      *                _permiteArrepentir                            *
      *                _anulacionEnProceso                           *
      * SGF 12/11/2021 Asistencia Motos.                             *
      *                AON Assist para Comercio y Consorcio.         *
      * SGF 26/11/2021 Asistencia Motos: de acuerdo a SPASIMO.       *
      * SGF 20/12/2021 _getVariacionComision() va siempre sobre el   *
      *                endoso cero. Ver Redmine 11239.               *
      *                                                              *
      * ************************************************************ *
     Fpahed004  if   e           k disk    usropn
     Fpahed0    uf a e           k disk    usropn
     Fpaheda    uf a e           k disk    usropn
     Fpahed1    uf a e           k disk    usropn
     Fpahed2    uf a e           k disk    usropn
     Fpahed3    uf a e           k disk    usropn
     Fpahed4    uf a e           k disk    usropn
     Fpahed5    uf a e           k disk    usropn
     Fpahnx004  if   e           k disk    usropn
     Fset001    if   e           k disk    usropn
     Fpahed005  if   e           k disk    usropn
     Fpahed302  if   e           k disk    usropn rename( p1hed3 : p1hed302 )
     Fpahcd501  if   e           k disk    usropn
     Fpahag404  if   e           k disk    usropn
     Fgti982    if   e           k disk    usropn
     Fpawkl1    if   e           k disk    usropn
     Fpawpc0    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svppol_h.rpgle'
      * ------------------------------------------------------------ *
      * Setea error global
      * --------------------------------------------------- *
     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- PR Externos --------------------------------------------- *
     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

     D SPOPFECH        pr                  extpgm('SPOPFECH')
     D  peFech                        8  0
     D  peSign                        1a   const
     D  peTipo                        1a   const
     D  peCant                        5  0 const
     D  @@Fech                        8  0
     D  peErro                        1a
     D  peFfec                        3a   options(*nopass) const

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

      *--- Definicion de Procedimiento ----------------------------- *
     ?* ------------------------------------------------------------ *
     ?* SVPPOL_inz(): Inicializa módulo.                             *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPPOL_inz      B                   export
     D SVPPOL_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pahed004);
         open pahed004;
       endif;

       if not %open(pahed0);
         open pahed0;
       endif;

       if not %open(paheda);
         open paheda;
       endif;

       if not %open(pahed1);
         open pahed1;
       endif;

       if not %open(pahed2);
         open pahed2;
       endif;

       if not %open(pahed3);
         open pahed3;
       endif;

       if not %open(pahed4);
         open pahed4;
       endif;

       if not %open(pahed5);
         open pahed5;
       endif;

       if not %open(pahnx004);
         open pahnx004;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(pahed005);
         open pahed005;
       endif;

       if not %open(pahed302);
         open pahed302;
       endif;

       if not %open(pahcd501);
         open pahcd501;
       endif;

       if not %open(pahag404);
         open pahag404;
       endif;

       if not %open(gti982);
         open gti982;
       endif;

       if not %open(pawkl1);
         open pawkl1;
       endif;

       if not %open(pawpc0);
         open pawpc0;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPPOL_inz      E

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_End(): Finaliza módulo.                               *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPPOL_End      B                   export
     D SVPPOL_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPPOL_End      E

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_Error(): Retorna el último error del service program  *
     ?*                                                              *
     ?*     peEnbr   (output)  Número de error (opcional)            *
     ?*                                                              *
     ?* Retorna: Mensaje de error.                                   *
     ?* ------------------------------------------------------------ *

     P SVPPOL_Error    B                   export
     D SVPPOL_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPPOL_Error    E

     ?* ------------------------------------------------------------ *
     P SVPPOL_getPoliza...
     P                 B                   export
     D SVPPOL_getPoliza...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peArcd                       6  0 options( *nopass : *omit ) const
     D   peSpol                       9  0 options( *nopass : *omit ) const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peDsD0                            likeds ( dsPahed0_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD0C                     10i 0 options( *nopass : *omit )

     D   k1yed4        ds                  likerec( p1hed004 : *key    )
     D   @@DsID0       ds                  likerec( p1hed004 : *input  )
     D   @@DsD0        ds                  likeds ( dsPahed0_t ) dim( 999 )
     D   @@DsD0C       s             10i 0

      /free

       SVPPOL_inz();

       clear peDsD0;
       peDsD0C = 0;

       k1yed4.d0empr = peEmpr;
       k1yed4.d0sucu = peSucu;
       k1yed4.d0rama = peRama;
       k1yed4.d0poli = pePoli;

       if %parms >= 5;
         Select;
           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peSspo ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null;

                k1yed4.d0suop = peSuop;
                k1yed4.d0arcd = peArcd;
                k1yed4.d0spol = peSpol;
                k1yed4.d0sspo = peSspo;
                k1yed4.d0arse = peArse;
                k1yed4.d0oper = peOper;
                setll %kds( k1yed4 : 10 ) pahed004;
                if not %equal( pahed004 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 10 ) pahed004 @@DsID0;
                dow not %eof( pahed004 );
                  @@DsD0C += 1;
                  eval-corr @@DsD0 ( @@DsD0C ) = @@DsID0;
                 reade(n) %kds( k1yed4 : 10 ) pahed004 @@DsID0;
                enddo;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peSspo ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null;

                k1yed4.d0suop = peSuop;
                k1yed4.d0arcd = peArcd;
                k1yed4.d0spol = peSpol;
                k1yed4.d0sspo = peSspo;
                k1yed4.d0arse = peArse;
                setll %kds( k1yed4 : 9 ) pahed004;
                if not %equal( pahed004 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 9 ) pahed004 @@DsID0;
                dow not %eof( pahed004 );
                  @@DsD0C += 1;
                  eval-corr @@DsD0 ( @@DsD0C ) = @@DsID0;
                 reade(n) %kds( k1yed4 : 9 ) pahed004 @@DsID0;
                enddo;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peSspo ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yed4.d0suop = peSuop;
                k1yed4.d0arcd = peArcd;
                k1yed4.d0spol = peSpol;
                k1yed4.d0sspo = peSspo;
                setll %kds( k1yed4 : 8 ) pahed004;
                if not %equal( pahed004 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 8 ) pahed004 @@DsID0;
                dow not %eof( pahed004 );
                  @@DsD0C += 1;
                  eval-corr @@DsD0 ( @@DsD0C ) = @@DsID0;
                 reade(n) %kds( k1yed4 : 8 ) pahed004 @@DsID0;
                enddo;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peSspo ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yed4.d0suop = peSuop;
                k1yed4.d0arcd = peArcd;
                k1yed4.d0spol = peSpol;
                setll %kds( k1yed4 : 7 ) pahed004;
                if not %equal( pahed004 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 7 ) pahed004 @@DsID0;
                dow not %eof( pahed004 );
                  @@DsD0C += 1;
                  eval-corr @@DsD0 ( @@DsD0C ) = @@DsID0;
                 reade(n) %kds( k1yed4 : 7 ) pahed004 @@DsID0;
                enddo;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) =  *null and
                %addr( peSspo ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yed4.d0suop = peSuop;
                k1yed4.d0arcd = peArcd;
                setll %kds( k1yed4 : 6 ) pahed004;
                if not %equal( pahed004 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 6 ) pahed004 @@DsID0;
                dow not %eof( pahed004 );
                  @@DsD0C += 1;
                  eval-corr @@DsD0 ( @@DsD0C ) = @@DsID0;
                 reade(n) %kds( k1yed4 : 6 ) pahed004 @@DsID0;
                enddo;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) =  *null and
                %addr( peSpol ) =  *null and
                %addr( peSspo ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yed4.d0suop = peSuop;
                setll %kds( k1yed4 : 5 ) pahed004;
                if not %equal( pahed004 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 5 ) pahed004 @@DsID0;
                dow not %eof( pahed004 );
                  @@DsD0C += 1;
                  eval-corr @@DsD0 ( @@DsD0C ) = @@DsID0;
                 reade(n) %kds( k1yed4 : 5 ) pahed004 @@DsID0;
                enddo;
           other;
                setll %kds( k1yed4 : 4 ) pahed004;
                if not %equal( pahed004 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 4 ) pahed004 @@DsID0;
                dow not %eof( pahed004 );
                  @@DsD0C += 1;
                  eval-corr @@DsD0 ( @@DsD0C ) = @@DsID0;
                 reade(n) %kds( k1yed4 : 4 ) pahed004 @@DsID0;
                enddo;
           endsl;
       else;

         setll  %kds( k1yed4 : 4 ) pahed004;
         if not %equal( pahed004 );
           return *off;
         endif;
         reade(n) %kds( k1yed4 : 4 ) pahed004 @@DsID0;
         dow not %eof( pahed004 );
           @@DsD0C += 1;
           eval-corr @@DsD0 ( @@DsD0C ) = @@DsID0;
           reade(n) %kds( k1yed4 : 4 ) pahed004 @@DsID0;
         enddo;
       endif;

       if %addr( peDsD0 ) <> *null;
         eval-corr peDsD0 = @@DsD0;
       endif;

       if %addr( peDsD0C ) <> *null;
          peDsD0C = @@DsD0C;
       endif;

       return *on;
      /end-free

     P SVPPOL_getPoliza...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_setSuscripcionPolizaElectronica: Graba suscripción de *
     ?*                                         póliza Electrónica   *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant de Polizas                      *
     ?*     peOper   ( input  ) Numero de Operacion                  *
     ?*     pePoli   ( input  ) Poliza                               *
     ?*     peSusc   ( input  ) Suscripta "S" o "N"                  *
     ?*     peMail   ( input  ) Mail                                 *
     ?*                                                              *
     ?* Retorna: *On / *Off                                          *
     ?* ------------------------------------------------------------ *
     P SVPPOL_setSuscripcionPolizaElectronica...
     P                 B                   export
     D SVPPOL_setSuscripcionPolizaElectronica...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSusc                       1    const
     D   peMail                      50    const

     D k1yeda          ds                  likerec( p1heda : *key )

      /free

       SVPPOL_inz();

       k1yeda.daEmpr = peEmpr;
       k1yeda.daSucu = peSucu;
       k1yeda.daArcd = peArcd;
       k1yeda.daSpol = peSpol;
       k1yeda.daRama = peRama;
       k1yeda.daArse = peArse;
       k1yeda.daOper = peOper;
       k1yeda.daPoli = pePoli;

       chain %kds( k1yeda : 8 ) paheda;
       if %found( paheda );

         if peSusc = 'S';
           daMar1 = '1';
         else;
           daMar1 = '0';
         endif;

         daMail = peMail;
         daDate = %dec(%date);
         daTime = %dec(%time);
         daUser = @PsDs.CurUsr;
         update p1heda;
         return *on;

       endif;

       daEmpr = peEmpr;
       daSucu = peSucu;
       daArcd = peArcd;
       daSpol = peSpol;
       daRama = peRama;
       daArse = peArse;
       daOper = peOper;
       daPoli = pePoli;
       daMail = peMail;

       if peSusc = 'S';
         daMar1 = '1';
       else;
         daMar1 = '0';
       endif;

       daMar2 = '0';
       daMar3 = '0';
       daMar4 = '0';
       daMar5 = '0';
       daMar6 = '0';
       daMar7 = '0';
       daMar8 = '0';
       daMar9 = '0';
       daMar0 = '0';
       daDate = %dec(%date);
       daTime = %dec(%time);
       daUser = @PsDs.CurUsr;

       write p1heda;

       return *on;
      /end-free

     P SVPPOL_setSuscripcionPolizaElectronica...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_isSuscriptaPolizaElectronica: Retorna suscripción de  *
     ?*                                      póliza Electrónica      *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant de Polizas                      *
     ?*     peOper   ( input  ) Numero de Operacion                  *
     ?*     pePoli   ( input  ) Poliza                               *
     ?*     peMail   ( input  ) Mail (Opcional)                      *
     ?*                                                              *
     ?* Retorna: *On / *Off                                          *
     ?* ------------------------------------------------------------ *
     P SVPPOL_isSuscriptaPolizaElectronica...
     P                 B                   export
     D SVPPOL_isSuscriptaPolizaElectronica...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peMail                      50    options(*nopass:*omit)

     D k1yeda          ds                  likerec( p1heda : *key )

      /free

       SVPPOL_inz();

       k1yeda.daEmpr = peEmpr;
       k1yeda.daSucu = peSucu;
       k1yeda.daArcd = peArcd;
       k1yeda.daSpol = peSpol;
       k1yeda.daRama = peRama;
       k1yeda.daArse = peArse;
       k1yeda.daOper = peOper;
       k1yeda.daPoli = pePoli;

       chain %kds( k1yeda : 8 ) paheda;
       if %found( paheda );
         if %parms >= 9 and %addr( peMail ) <> *null;
           peMail = daMail;
         endif;

         if daMar1 = '1';
           return *on;
         else;
           return *off;
         endif;
       endif;

       if %parms >= 9 and %addr( peMail ) <> *null;
         peMail = *blanks;
       endif;

       return *off;
      /end-free

     P SVPPOL_isSuscriptaPolizaElectronica...
     P                 E

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_chkPoliza: Validar Poliza.-                           *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Poliza                               *
     ?*     peSuop   ( input  ) SubOperacion              (opcional) *
     ?*     peArcd   ( input  ) Articulo                  (opcional) *
     ?*     peSpol   ( input  ) SuperPoliza               (opcional) *
     ?*     peSspo   ( input  ) Suplemento de SuperPoliza (opcional) *
     ?*     peArse   ( input  ) Cant.Polizas por Rama/Art (opcional) *
     ?*     peOper   ( input  ) Numero de Operacion       (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si existe /  *off = No existe                 *
     ?* ------------------------------------------------------------ *
     P SVPPOL_chkPoliza...
     P                 b                   export
     D SVPPOL_chkPoliza...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peArcd                       6  0 options( *nopass : *omit ) const
     D   peSpol                       9  0 options( *nopass : *omit ) const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const

     D   k1yed0        ds                  likerec( p1hed004 : *key )

      /free

       SVPPOL_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0rama = peRama;
       k1yed0.d0poli = pePoli;
       if %parms >= 5;
         Select;
           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peSspo ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null;

                k1yed0.d0suop = peSuop;
                k1yed0.d0arcd = peArcd;
                k1yed0.d0spol = peSpol;
                k1yed0.d0sspo = peSspo;
                k1yed0.d0arse = peArse;
                k1yed0.d0oper = peOper;
                setll %kds( k1yed0 : 10 ) pahed004;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peSspo ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null;

                k1yed0.d0suop = peSuop;
                k1yed0.d0arcd = peArcd;
                k1yed0.d0spol = peSpol;
                k1yed0.d0sspo = peSspo;
                k1yed0.d0arse = peArse;
                setll %kds( k1yed0 : 9 ) pahed004;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peSspo ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yed0.d0suop = peSuop;
                k1yed0.d0arcd = peArcd;
                k1yed0.d0spol = peSpol;
                k1yed0.d0sspo = peSspo;
                setll %kds( k1yed0 : 8 ) pahed004;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) <> *null and
                %addr( peSspo ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yed0.d0suop = peSuop;
                k1yed0.d0arcd = peArcd;
                k1yed0.d0spol = peSpol;
                setll %kds( k1yed0 : 7 ) pahed004;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) <> *null and
                %addr( peSpol ) =  *null and
                %addr( peSspo ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yed0.d0suop = peSuop;
                k1yed0.d0arcd = peArcd;
                setll %kds( k1yed0 : 6 ) pahed004;

           when %addr( peSuop ) <> *null and
                %addr( peArcd ) =  *null and
                %addr( peSpol ) =  *null and
                %addr( peSspo ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null;

                k1yed0.d0suop = peSuop;
                setll %kds( k1yed0 : 5 ) pahed004;
           other;
                setll %kds( k1yed0 : 4 ) pahed004;
           endsl;
       else;

         setll %kds( k1yed0 : 4 ) pahed004;
       endif;

       return %equal();

      /end-free

     P SVPPOL_chkPoliza...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_setPoliza: Grabar Poliza.-                            *
     ?*                                                              *
     ?*     peDsD0   ( input  ) Estructura Poliza                    *
     ?*                                                              *
     ?* Retorna: *on = Si existe /  *off = No existe                 *
     ?* ------------------------------------------------------------ *
     P SVPPOL_setPoliza...
     P                 b                   export
     D SVPPOL_setPoliza...
     D                 pi              n
     D   peDsD0                            likeds( dsPahed0_t )
     D                                     options( *nopass : *omit ) const

     D   @@DsOD0       ds                  likerec( p1hed0 : *output )

      /free

       SVPPOL_inz();

       if SVPPOL_chkPoliza( peDsD0.d0empr
                          : peDsD0.d0sucu
                          : peDsD0.d0rama
                          : peDsD0.d0poli
                          : peDsD0.d0suop
                          : peDsD0.d0arcd
                          : peDsD0.d0spol
                          : peDsD0.d0sspo
                          : peDsD0.d0arse
                          : peDsD0.d0oper  );

         return *off;
       endif;

       eval-corr @@DsOD0 = peDsD0;
       monitor;
         write p1heD0 @@DsOD0;
       on-error;
         return *off;
       endmon;

       return *on;

     P SVPPOL_setPoliza...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_updPoliza: Actualizar Poliza.-                        *
     ?*                                                              *
     ?*     peDsD0   ( input  ) Estructura Poliza                    *
     ?*                                                              *
     ?* Retorna: *on = Si actualizo / *off = No actualizo            *
     ?* ------------------------------------------------------------ *
     P SVPPOL_updPoliza...
     P                 b                   export
     D SVPPOL_updPoliza...
     D                 pi              n
     D   peDsD0                            likeds( dsPahed0_t )
     D                                     options( *nopass : *omit ) const

     D   @@DsOD0       ds                  likerec( p1hed0 : *output )
     D   k1yed0        ds                  likerec( p1hed0 : *key    )

      /free

       SVPPOL_inz();

       k1yed0.d0empr = peDsD0.d0empr;
       k1yed0.d0sucu = peDsD0.d0sucu;
       k1yed0.d0arcd = peDsD0.d0arcd;
       k1yed0.d0spol = peDsD0.d0spol;
       k1yed0.d0sspo = peDsD0.d0sspo;
       k1yed0.d0rama = peDsD0.d0rama;
       k1yed0.d0arse = peDsD0.d0arse;
       k1yed0.d0oper = peDsD0.d0oper;
       k1yed0.d0suop = peDsD0.d0suop;
       chain %kds( k1yed0 : 9 ) pahed0;
       if not %found( pahed0 );
         return *off;
       endif;

       eval-corr @@DsOD0 = peDsD0;
       monitor;
         update p1heD0 @@DsOD0;
       on-error;
         return *off;
       endmon;

       return *on;

     P SVPPOL_updPoliza...
     P                 e
     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getSuperPoliza: Rertorna Nro de SupePoliza de una     *
     ?*                        Poliza                                *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Poliza                               *
     ?*     peSuop   ( input  ) SubOperacion              (opcional) *
     ?*                                                              *
     ?* Retorna: Nro de SuperPoliza / -1 = No encontró               *
     ?* ------------------------------------------------------------ *
     P SVPPOL_getSuperPoliza...
     P                 b                   export
     D SVPPOL_getSuperPoliza...
     D                 pi             9  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     D   @@DsD0        ds                  likeds ( dsPahed0_t ) dim( 999 )
     D   @@DsD0C       s             10i 0

      /free

       SVPPOL_inz();

       if %parms >= 5 and %addr( peSuop ) <> *null;
         if not SVPPOL_getPoliza( peEmpr
                                : peSucu
                                : peRama
                                : pePoli
                                : peSuop
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : @@DsD0
                                : @@DsD0C );
           return -1;
         endif;
       else;
         if not SVPPOL_getPoliza( peEmpr
                                : peSucu
                                : peRama
                                : pePoli
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : @@DsD0
                                : @@DsD0C );
           return -1;
         endif;
       endif;

       return @@DsD0(@@DsD0C).d0spol;

      /end-free

     P SVPPOL_getSuperPoliza...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getArticulo: Rertorna Código de Articlo               *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     pePoli   ( input  ) Poliza                               *
     ?*     peSuop   ( input  ) SubOperacion              (opcional) *
     ?*                                                              *
     ?* Retorna: Código de Articulo / -1 = No encontró               *
     ?* ------------------------------------------------------------ *
     P SVPPOL_getArticulo...
     P                 b                   export
     D SVPPOL_getArticulo...
     D                 pi             6  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     D   @@DsD0        ds                  likeds ( dsPahed0_t ) dim( 999 )
     D   @@DsD0C       s             10i 0

      /free

       SVPPOL_inz();

       if %parms >= 5 and %addr( peSuop ) <> *null;
         if not SVPPOL_getPoliza( peEmpr
                                : peSucu
                                : peRama
                                : pePoli
                                : peSuop
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : @@DsD0
                                : @@DsD0C );
           return -1;
         endif;
       else;
         if not SVPPOL_getPoliza( peEmpr
                                : peSucu
                                : peRama
                                : pePoli
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : *omit
                                : @@DsD0
                                : @@DsD0C );
           return -1;
         endif;
       endif;

       return @@DsD0( @@DsD0C ).d0arcd;

      /end-free

     P SVPPOL_getArticulo...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getPolizadesdeSuperPoliza: Retorna informacion        *
     ?*                                   de Poliza.-                *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peDsD0   ( output ) Estructura Poliza         (opcional) *
     ?*     peDsD0C  ( output ) Cantidad de Polizas       (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_getPolizadesdeSuperPoliza...
     P                 b                   export
     D SVPPOL_getPolizadesdeSuperPoliza...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsD0                            likeds( dsPahed0_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD0C                     10i 0 options( *nopass : *omit )

     D   k1yed0        ds                  likerec( p1hed0 : *key   )
     D   @@DsID0       ds                  likerec( p1hed0 : *input )
     D   @@DsD0c       s             10i 0
     D   @@DsD0        ds                  likeds( dsPahed0_t ) dim( 999 )

      /free

       SVPPOL_inz();

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null ;

              k1yed0.d0sspo = pesspo;
              k1yed0.d0rama = peRama;
              k1yed0.d0arse = peArse;
              k1yed0.d0oper = peOper;
              k1yed0.d0suop = peSuop;
              setll %kds( k1yed0 : 9 ) pahed0;
              if not %equal( pahed0 );
                return *off;
              endif;
              reade(n) %kds( k1yed0 : 9 ) pahed0 @@DsID0;
              dow not %eof( pahed0 );
                @@DsD0c += 1;
                eval-corr @@DsD0( @@DsD0C ) = @@DsID0;
               reade(n) %kds( k1yed0 : 9 ) pahed0 @@DsID0;
              enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null ;

              k1yed0.d0sspo = pesspo;
              k1yed0.d0rama = peRama;
              k1yed0.d0arse = peArse;
              k1yed0.d0oper = peOper;
              setll %kds( k1yed0 : 8 ) pahed0;
              if not %equal( pahed0 );
                return *off;
              endif;
              reade(n) %kds( k1yed0 : 8 ) pahed0 @@DsID0;
              dow not %eof( pahed0 );
                @@DsD0c += 1;
                eval-corr @@DsD0( @@DsD0C ) = @@DsID0;
               reade(n) %kds( k1yed0 : 8 ) pahed0 @@DsID0;
              enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

              k1yed0.d0sspo = pesspo;
              k1yed0.d0rama = peRama;
              k1yed0.d0arse = peArse;
              setll %kds( k1yed0 : 7 ) pahed0;
              if not %equal( pahed0 );
                return *off;
              endif;
              reade(n) %kds( k1yed0 : 7 ) pahed0 @@DsID0;
              dow not %eof( pahed0 );
                @@DsD0C += 1;
                eval-corr @@DsD0( @@DsD0C ) = @@DsID0;
               reade(n) %kds( k1yed0 : 7 ) pahed0 @@DsID0;
              enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

              k1yed0.d0sspo = pesspo;
              k1yed0.d0rama = peRama;
              setll %kds( k1yed0 : 6 ) pahed0;
              if not %equal( pahed0 );
                return *off;
              endif;
              reade(n) %kds( k1yed0 : 6 ) pahed0 @@DsID0;
              dow not %eof( pahed0 );
                @@DsD0C += 1;
                eval-corr @@DsD0( @@DsD0C ) = @@DsID0;
               reade(n) %kds( k1yed0 : 6 ) pahed0 @@DsID0;
              enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

              k1yed0.d0sspo = pesspo;
              setll %kds( k1yed0 : 5 ) pahed0;
              if not %equal( pahed0 );
                return *off;
              endif;
              reade(n) %kds( k1yed0 : 5 ) pahed0 @@DsID0;
              dow not %eof( pahed0 );
                @@DsD0C += 1;
                eval-corr @@DsD0( @@DsD0C ) = @@DsID0;
               reade(n) %kds( k1yed0 : 5 ) pahed0 @@DsID0;
              enddo;

           other;
             setll %kds( k1yed0 : 4 ) pahed0;
             if not %equal( pahed0 );
               return *off;
             endif;
             reade(n) %kds( k1yed0 : 4 ) pahed0 @@DsID0;
             dow not %eof( pahed0 );
               @@DsD0c += 1;
               eval-corr @@DsD0( @@DsD0C ) = @@DsID0;
              reade(n) %kds( k1yed0 : 4 ) pahed0 @@DsID0;
             enddo;
         endsl;
       else;
         setll %kds( k1yed0 : 4 ) pahed0;
         if not %equal( pahed0 );
           return *off;
         endif;
         reade(n) %kds( k1yed0 : 4 ) pahed0 @@DsID0;
         dow not %eof( pahed0 );
           @@DsD0c += 1;
           eval-corr @@DsD0( @@DsD0C ) = @@DsID0;
          reade(n) %kds( k1yed0 : 4 ) pahed0 @@DsID0;
         enddo;
       endif;

       if %addr( peDsD0  ) <> *null;
          eval-corr peDsD0  = @@DsD0;
       endif;

       if %addr( peDsD0C ) <> *null;
          eval peDsD0C = @@DsD0C;
       endif;

       return *on;

      /end-free

     P SVPPOL_getPolizadesdeSuperPoliza...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_chkCondicionesComerciales: Valida condiciones         *
     ?*                                   Comerciales.-              *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_chkCondicionesComerciales...
     P                 b                   export
     D SVPPOL_chkCondicionesComerciales...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     D   k1yed1        ds                  likerec( p1hed1 : *key )

      /free

       SVPPOL_inz();

       k1yed1.d1empr = peEmpr;
       k1yed1.d1sucu = peSucu;
       k1yed1.d1arcd = peArcd;
       k1yed1.d1spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null ;

                k1yed1.d1sspo = pesspo;
                k1yed1.d1rama = peRama;
                k1yed1.d1arse = peArse;
                k1yed1.d1oper = peOper;
                k1yed1.d1suop = peSuop;
                setll %kds( k1yed1 : 9 ) pahed1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null ;

                k1yed1.d1sspo = pesspo;
                k1yed1.d1rama = peRama;
                k1yed1.d1arse = peArse;
                k1yed1.d1oper = peOper;
                setll %kds( k1yed1 : 8 ) pahed1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed1.d1sspo = pesspo;
                k1yed1.d1rama = peRama;
                k1yed1.d1arse = peArse;
                setll %kds( k1yed1 : 7 ) pahed1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed1.d1sspo = pesspo;
                k1yed1.d1rama = peRama;
                setll %kds( k1yed1 : 6 ) pahed1;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed1.d1sspo = pesspo;
                setll %kds( k1yed1 : 5 ) pahed1;

           other;
             setll %kds( k1yed1 : 4 ) pahed1;
         endsl;
       else;
         setll %kds( k1yed1 : 4 ) pahed1;
       endif;

       return %equal;

      /end-free

     P SVPPOL_chkCondicionesComerciales...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getCondicionesComerciales: Retorna condiciones        *
     ?*                                   Comerciales.-              *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peDsD1   ( output ) Est. Condic. Comerciales  (opcional) *
     ?*     peDsD1C  ( output ) Cant. Cond. Comerciales   (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_getCondicionesComerciales...
     P                 b                   export
     D SVPPOL_getCondicionesComerciales...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsD1                            likeds( dsPahed1_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD1C                     10i 0 options( *nopass : *omit )

     D   k1yed1        ds                  likerec( p1hed1 : *key )
     D   @@DsID1       ds                  likerec( p1hed1 : *input )
     D   @@DsD1        ds                  likeds( dsPahed1_t ) dim( 999 )
     D   @@DsD1C       s             10i 0

      /free

       SVPPOL_inz();

       k1yed1.d1empr = peEmpr;
       k1yed1.d1sucu = peSucu;
       k1yed1.d1arcd = peArcd;
       k1yed1.d1spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null ;

                k1yed1.d1sspo = pesspo;
                k1yed1.d1rama = peRama;
                k1yed1.d1arse = peArse;
                k1yed1.d1oper = peOper;
                k1yed1.d1suop = peSuop;
                setll %kds( k1yed1 : 9 ) pahed1;
                if not %equal( pahed1 );
                  return *off;
                endif;
                reade(n) %kds( k1yed1 : 9 ) pahed1 @@DsID1;
                dow not %eof( pahed1 );
                  @@DsD1C += 1;
                  eval-corr @@DsD1( @@DsD1C ) = @@DsID1;
                 reade(n) %kds( k1yed1 : 9 ) pahed1 @@DsID1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null ;

                k1yed1.d1sspo = pesspo;
                k1yed1.d1rama = peRama;
                k1yed1.d1arse = peArse;
                k1yed1.d1oper = peOper;
                setll %kds( k1yed1 : 8 ) pahed1;
                if not %equal( pahed1 );
                  return *off;
                endif;
                reade(n) %kds( k1yed1 : 8 ) pahed1 @@DsID1;
                dow not %eof( pahed1 );
                  @@DsD1C += 1;
                  eval-corr @@DsD1( @@DsD1C ) = @@DsID1;
                 reade(n) %kds( k1yed1 : 8 ) pahed1 @@DsID1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed1.d1sspo = pesspo;
                k1yed1.d1rama = peRama;
                k1yed1.d1arse = peArse;
                setll %kds( k1yed1 : 7 ) pahed1;
                if not %equal( pahed1 );
                  return *off;
                endif;
                reade(n) %kds( k1yed1 : 7 ) pahed1 @@DsID1;
                dow not %eof( pahed1 );
                  @@DsD1C += 1;
                  eval-corr @@DsD1( @@DsD1C ) = @@DsID1;
                 reade(n) %kds( k1yed1 : 7 ) pahed1 @@DsID1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed1.d1sspo = pesspo;
                k1yed1.d1rama = peRama;
                setll %kds( k1yed1 : 6 ) pahed1;
                if not %equal( pahed1 );
                  return *off;
                endif;
                reade(n) %kds( k1yed1 : 6 ) pahed1 @@DsID1;
                dow not %eof( pahed1 );
                  @@DsD1C += 1;
                  eval-corr @@DsD1( @@DsD1C ) = @@DsID1;
                 reade(n) %kds( k1yed1 : 6 ) pahed1 @@DsID1;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed1.d1sspo = pesspo;
                setll %kds( k1yed1 : 5 ) pahed1;
                if not %equal( pahed1 );
                  return *off;
                endif;
                reade(n) %kds( k1yed1 : 5 ) pahed1 @@DsID1;
                dow not %eof( pahed1 );
                  @@DsD1C += 1;
                  eval-corr @@DsD1( @@DsD1C ) = @@DsID1;
                 reade(n) %kds( k1yed1 : 5 ) pahed1 @@DsID1;
                enddo;

           other;
             setll %kds( k1yed1 : 4 ) pahed1;
             if not %equal( pahed1 );
               return *off;
             endif;
             reade(n) %kds( k1yed1 : 4 ) pahed1 @@DsID1;
             dow not %eof( pahed1 );
               @@DsD1C += 1;
               eval-corr @@DsD1( @@DsD1C ) = @@DsID1;
              reade(n) %kds( k1yed1 : 4 ) pahed1 @@DsID1;
             enddo;
         endsl;
       else;
         setll %kds( k1yed1 : 4 ) pahed1;
         if not %equal( pahed1 );
           return *off;
         endif;
         reade(n) %kds( k1yed1 : 4 ) pahed1 @@DsID1;
         dow not %eof( pahed1 );
           @@DsD1C += 1;
           eval-corr @@DsD1( @@DsD1C ) = @@DsID1;
          reade(n) %kds( k1yed1 : 4 ) pahed1 @@DsID1;
         enddo;
       endif;

       if %parms >= 5;
         if %addr( peDsD1  ) <> *null;
           eval-corr peDsD1 = @@DsD1;
         endif;
         if %addr( peDsD1C ) <> *null;
           peDsD1C = @@DsD1C;
         endif;
       endif;

       return *on;

      /end-free

     P SVPPOL_getCondicionesComerciales...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_setCondicionesComerciales: Graba ondiciones           *
     ?*                                   Comerciales.-              *
     ?*                                                              *
     ?*     peDsD1  (  input  )  Est. Cond. Comerciale               *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P SVPPOL_setCondicionesComerciales...
     P                 b                   export
     D SVPPOL_setCondicionesComerciales...
     D                 pi              n
     D   peDsD1                            likeds( dsPahed1_t ) const

     D   @@DsOD1       ds                  likerec( p1hed1 : *output )

      /free

       SVPPOL_inz();

       if SVPPOL_chkCondicionesComerciales( peDsD1.d1empr
                                          : peDsD1.d1sucu
                                          : peDsD1.d1arcd
                                          : peDsD1.d1spol
                                          : peDsD1.d1sspo
                                          : peDsD1.d1rama
                                          : peDsD1.d1arse
                                          : peDsD1.d1oper
                                          : peDsD1.d1suop  );
         return *off;
       endif;

       eval-corr @@DsOD1 = peDsD1;
       monitor;
         write p1heD1 @@DsOD1;
       on-error;
         return *off;
       endmon;

       return *on;

     P SVPPOL_setCondicionesComerciales...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_delCondicionesComerciales: Eliminar Condiciones       *
     ?*                                   Comerciales.-              *
     ?*                                                              *
     ?*     peDsD1  (  input  )  Est. Cond. Comerciales              *
     ?*                                                              *
     ?* Retorna: *on = Elimino ok / *off = No Elimino                *
     ?* ------------------------------------------------------------ *
     P SVPPOL_delCondicionesComerciales...
     P                 b                   export
     D SVPPOL_delCondicionesComerciales...
     D                 pi              n
     D   peDsD1                            likeds( dsPahed1_t ) const

     D   k1yed1        ds                  likerec( p1hed1 : *key )

      /free

       SVPPOL_inz();

       k1yed1.d1empr = peDsD1.d1empr;
       k1yed1.d1sucu = peDsD1.d1sucu;
       k1yed1.d1arcd = peDsD1.d1arcd;
       k1yed1.d1spol = peDsD1.d1spol;
       k1yed1.d1sspo = peDsD1.d1sspo;
       k1yed1.d1rama = peDsD1.d1rama;
       k1yed1.d1arse = peDsD1.d1arse;
       k1yed1.d1oper = peDsD1.d1oper;
       k1yed1.d1suop = peDsD1.d1suop;
       chain %kds( k1yed1 : 9 ) pahed1;
       if %found( pahed1 );
         delete p1hed1;
       endif;

       return *on;
      /end-free

     P SVPPOL_delCondicionesComerciales...
     p                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_chkTexto: Validar si la poliza contiene textos        *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peNrre   ( input  ) Nro. de linea de Texto    (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_chkTexto...
     P                 b                   export
     D SVPPOL_chkTexto...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peNrre                       3  0 options( *nopass : *omit ) const

     D   k1yed2        ds                  likerec( p1hed2 : *key )

      /free

       SVPPOL_inz();

       k1yed2.d2empr = peEmpr;
       k1yed2.d2sucu = peSucu;
       k1yed2.d2arcd = peArcd;
       k1yed2.d2spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNrre ) <> *null     ;

                k1yed2.d2sspo = pesspo;
                k1yed2.d2rama = peRama;
                k1yed2.d2arse = peArse;
                k1yed2.d2oper = peOper;
                k1yed2.d2suop = peSuop;
                k1yed2.d2nrre = peNrre;
                setll %kds( k1yed2 : 10 ) pahed2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2sspo = pesspo;
                k1yed2.d2rama = peRama;
                k1yed2.d2arse = peArse;
                k1yed2.d2oper = peOper;
                k1yed2.d2suop = peSuop;
                setll %kds( k1yed2 : 9 ) pahed2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2sspo = pesspo;
                k1yed2.d2rama = peRama;
                k1yed2.d2arse = peArse;
                k1yed2.d2oper = peOper;
                setll %kds( k1yed2 : 8 ) pahed2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2sspo = pesspo;
                k1yed2.d2rama = peRama;
                k1yed2.d2arse = peArse;
                setll %kds( k1yed2 : 7 ) pahed2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2sspo = pesspo;
                k1yed2.d2rama = peRama;
                setll %kds( k1yed2 : 6 ) pahed2;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2sspo = pesspo;
                setll %kds( k1yed2 : 5 ) pahed2;

           other;
             setll %kds( k1yed2 : 4 ) pahed2;
         endsl;
       else;
         setll %kds( k1yed2 : 4 ) pahed2;
       endif;

       return %equal;

      /end-free

     P SVPPOL_chkTexto...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getTextos: Retorna Textos .-                          *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peNrre   ( input  ) Nro. de linea de Texto    (opcional) *
     ?*     peDsD2   ( output ) Est. Condic. Comerciales  (opcional) *
     ?*     peDsD2C  ( output ) Cant. Cond. Comerciales   (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_getTextos...
     P                 b                   export
     D SVPPOL_getTextos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peNrre                       3  0 options( *nopass : *omit ) const
     D   peDsD2                            likeds( dsPahed2_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD2C                     10i 0 options( *nopass : *omit )

     D   k1yed2        ds                  likerec( p1hed2 : *key )
     D   @@DsID2       ds                  likerec( p1hed2 : *input )
     D   @@DsD2        ds                  likeds( dsPahed2_t ) dim( 999 )
     D   @@DsD2C       s             10i 0

      /free

       SVPPOL_inz();

       k1yed2.d2empr = peEmpr;
       k1yed2.d2sucu = peSucu;
       k1yed2.d2arcd = peArcd;
       k1yed2.d2spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNrre ) <> *null     ;

                k1yed2.d2Sspo = peSspo;
                k1yed2.d2Rama = peRama;
                k1yed2.d2Arse = peArse;
                k1yed2.d2Oper = peOper;
                k1yed2.d2Suop = peSuop;
                k1yed2.d2Nrre = peNrre;
                setll %kds( k1yed2 : 10 ) pahed2;
                if %equal( pahed2 );
                  return %eof;
                endif;
                reade(n) %kds( k1yed2 : 10 ) pahed2 @@DsID2;
                dow not %eof( pahed2 );
                  @@DsD2C += 1;
                  eval-corr @@DsD2( @@DsD2C ) = @@DsID2;
                 reade(n) %kds( k1yed2 : 10 ) pahed2 @@DsID2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2Sspo = peSspo;
                k1yed2.d2Rama = peRama;
                k1yed2.d2Arse = peArse;
                k1yed2.d2Oper = peOper;
                k1yed2.d2Suop = peSuop;
                setll %kds( k1yed2 : 9 ) pahed2;
                if %equal( pahed2 );
                  return %eof;
                endif;
                reade(n) %kds( k1yed2 : 9 ) pahed2 @@DsID2;
                dow not %eof( pahed2 );
                  @@DsD2C += 1;
                  eval-corr @@DsD2( @@DsD2C ) = @@DsID2;
                 reade(n) %kds( k1yed2 : 9 ) pahed2 @@DsID2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2Sspo = peSspo;
                k1yed2.d2Rama = peRama;
                k1yed2.d2Arse = peArse;
                k1yed2.d2Oper = peOper;
                setll %kds( k1yed2 : 8 ) pahed2;
                if %equal( pahed2 );
                  return %eof;
                endif;
                reade(n) %kds( k1yed2 : 8 ) pahed2 @@DsID2;
                dow not %eof( pahed2 );
                  @@DsD2C += 1;
                  eval-corr @@DsD2( @@DsD2C ) = @@DsID2;
                 reade(n) %kds( k1yed2 : 8 ) pahed2 @@DsID2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2Sspo = peSspo;
                k1yed2.d2Rama = peRama;
                k1yed2.d2Arse = peArse;
                setll %kds( k1yed2 : 7 ) pahed2;
                if %equal( pahed2 );
                  return %eof;
                endif;
                reade(n) %kds( k1yed2 : 7 ) pahed2 @@DsID2;
                dow not %eof( pahed2 );
                  @@DsD2C += 1;
                  eval-corr @@DsD2( @@DsD2C ) = @@DsID2;
                 reade(n) %kds( k1yed2 : 7 ) pahed2 @@DsID2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2Sspo = peSspo;
                k1yed2.d2Rama = peRama;
                setll %kds( k1yed2 : 6 ) pahed2;
                if %equal( pahed2 );
                  return %eof;
                endif;
                reade(n) %kds( k1yed2 : 6 ) pahed2 @@DsID2;
                dow not %eof( pahed2 );
                  @@DsD2C += 1;
                  eval-corr @@DsD2( @@DsD2C ) = @@DsID2;
                 reade(n) %kds( k1yed2 : 6 ) pahed2 @@DsID2;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNrre ) =  *null     ;

                k1yed2.d2Sspo = peSspo;
                setll %kds( k1yed2 : 5 ) pahed2;
                if %equal( pahed2 );
                  return %eof;
                endif;
                reade(n) %kds( k1yed2 : 5 ) pahed2 @@DsID2;
                dow not %eof( pahed2 );
                  @@DsD2C += 1;
                  eval-corr @@DsD2( @@DsD2C ) = @@DsID2;
                 reade(n) %kds( k1yed2 : 5 ) pahed2 @@DsID2;
                enddo;

           other;
             setll %kds( k1yed2 : 4 ) pahed2;
             if %equal( pahed2 );
               return %eof;
             endif;
             reade(n) %kds( k1yed2 : 4 ) pahed2 @@DsID2;
             dow not %eof( pahed2 );
               @@DsD2C += 1;
               eval-corr @@DsD2( @@DsD2C ) = @@DsID2;
              reade(n) %kds( k1yed2 : 4 ) pahed2 @@DsID2;
             enddo;
         endsl;
       else;
         setll %kds( k1yed2 : 4 ) pahed2;
         if %equal( pahed2 );
           return %eof;
         endif;
         reade(n) %kds( k1yed2 : 4 ) pahed2 @@DsID2;
         dow not %eof( pahed2 );
           @@DsD2C += 1;
           eval-corr @@DsD2( @@DsD2C ) = @@DsID2;
          reade(n) %kds( k1yed2 : 4 ) pahed2 @@DsID2;
         enddo;
       endif;

       if %parms >= 5;
         if %addr( peDsD2  ) <> *null;
           eval-corr peDsD2 = @@DsD2;
         endif;
         if %addr( peDsD2C ) <> *null;
           peDsD2C = @@DsD2C;
         endif;
       endif;

       return *on;

      /end-free

     P SVPPOL_getTextos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_setTextos: Graba Textos                               *
     ?*                                                              *
     ?*     peDsD2  (  input  )  Est. Cond. Comerciale               *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P SVPPOL_setTextos...
     P                 b                   export
     D SVPPOL_setTextos...
     D                 pi              n
     D   peDsD2                            likeds( dsPahed2_t ) const

     D   @@DsOD2       ds                  likerec( p1hed2 : *output )

      /free

       SVPPOL_inz();

       if SVPPOL_chkTexto( peDsD2.d2empr
                         : peDsD2.d2sucu
                         : peDsD2.d2arcd
                         : peDsD2.d2spol
                         : peDsD2.d2sspo
                         : peDsD2.d2rama
                         : peDsD2.d2arse
                         : peDsD2.d2oper
                         : peDsD2.d2suop
                         : peDsD2.d2nrre );
         return *off;
       endif;

       eval-corr @@DsOD2 = peDsD2;
       monitor;
         write p1heD2 @@DsOD2;
       on-error;
         return *off;
       endmon;

       return *on;

     P SVPPOL_setTextos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_chkComisionesxInt: Validar Comisiones por             *
     ?*                           Intermediarios                     *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peNivt   ( input  ) Nivel de Intermediario    (opcional) *
     ?*     peNivc   ( input  ) Código de Intermediario   (opcional) *
     ?*     peRpro   ( input  ) Provincia Inder           (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_chkComisionesxInt...
     P                 b                   export
     D SVPPOL_chkComisionesxInt...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peNivt                       1  0 options( *nopass : *omit ) const
     D   peNivc                       5  0 options( *nopass : *omit ) const
     D   peRpro                       2  0 options( *nopass : *omit ) const

     D   k1yed3        ds                  likerec( p1hed3 : *key )

      /free

       SVPPOL_inz();

       k1yed3.d3empr = peEmpr;
       k1yed3.d3sucu = peSucu;
       k1yed3.d3arcd = peArcd;
       k1yed3.d3spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNivt ) <> *null and
                %addr( peNivc ) <> *null and
                %addr( peRpro ) <> *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                k1yed3.d3suop = peSuop;
                k1yed3.d3nivt = peNivt;
                k1yed3.d3nivc = peNivc;
                k1yed3.d3rpro = peRpro;
                setll %kds( k1yed3 : 12 ) pahed3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNivt ) <> *null and
                %addr( peNivc ) <> *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                k1yed3.d3suop = peSuop;
                k1yed3.d3nivt = peNivt;
                k1yed3.d3nivc = peNivc;
                setll %kds( k1yed3 : 11 ) pahed3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNivt ) <> *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                k1yed3.d3suop = peSuop;
                k1yed3.d3nivt = peNivt;
                setll %kds( k1yed3 : 10 ) pahed3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                k1yed3.d3suop = peSuop;
                setll %kds( k1yed3 : 9 ) pahed3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                setll %kds( k1yed3 : 8 ) pahed3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                setll %kds( k1yed3 : 7 ) pahed3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                setll %kds( k1yed3 : 6 ) pahed3;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                setll %kds( k1yed3 : 5 ) pahed3;

           other;
             setll %kds( k1yed3 : 4 ) pahed3;
         endsl;
       else;
         setll %kds( k1yed3 : 4 ) pahed3;
       endif;

       return %equal;

      /end-free

     P SVPPOL_chkComisionesxInt...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getComisionesxInt : Retorna Comisiones.-              *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peNivt   ( input  ) Nivel de Intermediario    (opcional) *
     ?*     peNivc   ( input  ) Código de Intermediario   (opcional) *
     ?*     peRpro   ( input  ) Provincia Inder           (opcional) *
     ?*     peDsD3   ( output ) Est. Comisiones           (opcional) *
     ?*     peDsD3C  ( output ) Cant. Comisiones          (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     p SVPPOL_getComisionesxInt...
     p                 b                   export
     D SVPPOL_getComisionesxInt...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peNivt                       1  0 options( *nopass : *omit ) const
     D   peNivc                       5  0 options( *nopass : *omit ) const
     D   peRpro                       2  0 options( *nopass : *omit ) const
     D   peDsD3                            likeds( dsPahed3_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD3C                     10i 0 options( *nopass : *omit )

     D   k1yed3        ds                  likerec( p1hed3 : *key )
     D   @@DsID3       ds                  likerec( p1hed3 : *input )
     D   @@DsD3        ds                  likeds ( dsPahed3_t ) dim( 999 )
     D   @@DsD3C       s             10i 0
     D   k1yed302      ds                  likerec( p1hed302 : *key )
     D   @@DsID302     ds                  likerec( p1hed302 : *input )

      /free

       SVPPOL_inz();

       k1yed3.d3empr = peEmpr;
       k1yed3.d3sucu = peSucu;
       k1yed3.d3arcd = peArcd;
       k1yed3.d3spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNivt ) <> *null and
                %addr( peNivc ) <> *null and
                %addr( peRpro ) <> *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                k1yed3.d3suop = peSuop;
                k1yed3.d3nivt = peNivt;
                k1yed3.d3nivc = peNivc;
                k1yed3.d3rpro = peRpro;
                setll %kds( k1yed3 : 12 ) pahed3;
                if not %equal( pahed3 );
                  return %equal;
                endif;
                reade(n) %kds( k1yed3 : 12 ) pahed3 @@DsID3;
                dow not %eof( pahed3 );
                  @@DsD3C += 1;
                  eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
                 reade(n) %kds( k1yed3 : 12 ) pahed3 @@DsID3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNivt ) <> *null and
                %addr( peNivc ) <> *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                k1yed3.d3suop = peSuop;
                k1yed3.d3nivt = peNivt;
                k1yed3.d3nivc = peNivc;
                setll %kds( k1yed3 : 11 ) pahed3;
                if not %equal( pahed3 );
                  return %equal;
                endif;
                reade(n) %kds( k1yed3 : 11 ) pahed3 @@DsID3;
                dow not %eof( pahed3 );
                  @@DsD3C += 1;
                  eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
                 reade(n) %kds( k1yed3 : 11 ) pahed3 @@DsID3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNivt ) <> *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                k1yed3.d3suop = peSuop;
                k1yed3.d3nivt = peNivt;
                setll %kds( k1yed3 : 10 ) pahed3;
                if not %equal( pahed3 );
                  return %equal;
                endif;
                reade(n) %kds( k1yed3 : 10 ) pahed3 @@DsID3;
                dow not %eof( pahed3 );
                  @@DsD3C += 1;
                  eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
                 reade(n) %kds( k1yed3 : 10 ) pahed3 @@DsID3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                k1yed3.d3suop = peSuop;
                setll %kds( k1yed3 : 9 ) pahed3;
                if not %equal( pahed3 );
                  return %equal;
                endif;
                reade(n) %kds( k1yed3 : 9 ) pahed3 @@DsID3;
                dow not %eof( pahed3 );
                  @@DsD3C += 1;
                  eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
                 reade(n) %kds( k1yed3 : 9 ) pahed3 @@DsID3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) <> *null;

                k1yed302.d3empr = peEmpr;
                k1yed302.d3sucu = peSucu;
                k1yed302.d3arcd = peArcd;
                k1yed302.d3spol = peSpol;
                k1yed302.d3sspo = pesspo;
                k1yed302.d3rama = peRama;
                k1yed302.d3arse = peArse;
                k1yed302.d3oper = peOper;
                k1yed302.d3suop = peSuop;
                k1yed302.d3rpro = peRpro;
                setll %kds( k1yed302 : 10 ) pahed302;
                if not %equal( pahed302 );
                  return %equal;
                endif;
                reade(n) %kds( k1yed302 : 10 ) pahed302 @@DsID302;
                dow not %eof( pahed302 );
                  @@DsD3C += 1;
                  eval-corr @@DsD3( @@DsD3C ) = @@DsID302;
                 reade(n) %kds( k1yed302 : 10 ) pahed302 @@DsID302;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                k1yed3.d3oper = peOper;
                setll %kds( k1yed3 : 8 ) pahed3;
                if not %equal( pahed3 );
                  return %equal;
                endif;
                reade(n) %kds( k1yed3 : 8 ) pahed3 @@DsID3;
                dow not %eof( pahed3 );
                  @@DsD3C += 1;
                  eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
                 reade(n) %kds( k1yed3 : 8 ) pahed3 @@DsID3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                k1yed3.d3arse = peArse;
                setll %kds( k1yed3 : 7 ) pahed3;
                if not %equal( pahed3 );
                  return %equal;
                endif;
                reade(n) %kds( k1yed3 : 7 ) pahed3 @@DsID3;
                dow not %eof( pahed3 );
                  @@DsD3C += 1;
                  eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
                 reade(n) %kds( k1yed3 : 7 ) pahed3 @@DsID3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                k1yed3.d3rama = peRama;
                setll %kds( k1yed3 : 6 ) pahed3;
                if not %equal( pahed3 );
                  return %equal;
                endif;
                reade(n) %kds( k1yed3 : 6 ) pahed3 @@DsID3;
                dow not %eof( pahed3 );
                  @@DsD3C += 1;
                  eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
                 reade(n) %kds( k1yed3 : 6 ) pahed3 @@DsID3;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null and
                %addr( peNivt ) =  *null and
                %addr( peNivc ) =  *null and
                %addr( peRpro ) =  *null     ;

                k1yed3.d3sspo = pesspo;
                setll %kds( k1yed3 : 5 ) pahed3;
                if not %equal( pahed3 );
                  return %equal;
                endif;
                reade(n) %kds( k1yed3 : 5 ) pahed3 @@DsID3;
                dow not %eof( pahed3 );
                  @@DsD3C += 1;
                  eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
                 reade(n) %kds( k1yed3 : 5 ) pahed3 @@DsID3;
                enddo;

           other;
             setll %kds( k1yed3 : 4 ) pahed3;
             if not %equal( pahed3 );
               return %equal;
             endif;
             reade(n) %kds( k1yed3 : 4 ) pahed3 @@DsID3;
             dow not %eof( pahed3 );
               @@DsD3C += 1;
               eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
               reade(n) %kds( k1yed3 : 4 ) pahed3 @@DsID3;
             enddo;
         endsl;
       else;
         setll %kds( k1yed3 : 4 ) pahed3;
         if not %equal( pahed3 );
           return %equal;
         endif;
         reade(n) %kds( k1yed3 : 4 ) pahed3 @@DsID3;
         dow not %eof( pahed3 );
           @@DsD3C += 1;
           eval-corr @@DsD3( @@DsD3C ) = @@DsID3;
           reade(n) %kds( k1yed3 : 4 ) pahed3 @@DsID3;
         enddo;
       endif;

       if %addr( peDsD3 ) <> *null;
         eval-corr peDsD3 = @@DsD3;
       endif;

       if %addr( peDsD3C ) <> *null;
          peDsD3C = @@DsD3C;
       endif;

       return *on;

      /end-free

     p SVPPOL_getComisionesxInt...
     p                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_setComisionesxInt: Graba Comisiones.-                 *
     ?*                                                              *
     ?*     peDsD3  (  input  )  Est. Comisiones                     *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P SVPPOL_setComisionesxInt...
     P                 b                   export
     D SVPPOL_setComisionesxInt...
     D                 pi              n
     D   peDsD3                            likeds( dsPahed3_t ) const

     D   @@DsOD3       ds                  likerec( p1hed3 : *output )

      /free

       SVPPOL_inz();

       if SVPPOL_chkComisionesxInt( peDsD3.d3empr
                                  : peDsD3.d3sucu
                                  : peDsD3.d3arcd
                                  : peDsD3.d3spol
                                  : peDsD3.d3sspo
                                  : peDsD3.d3rama
                                  : peDsD3.d3arse
                                  : peDsD3.d3oper
                                  : peDsD3.d3suop
                                  : peDsD3.d3nivt
                                  : peDsD3.d3nivc
                                  : peDsD3.d3rpro );
         return *off;
       endif;

       eval-corr @@DsOD3 = peDsD3;
       monitor;
         write p1heD3 @@DsOD3;
       on-error;
         return *off;
       endmon;

       return *on;

     P SVPPOL_setComisionesxInt...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_updComisionesxInt: Actualiza Comiciones.-             *
     ?*                                                              *
     ?*     peDsD3  (  input  )  Est. Comisiones                     *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P SVPPOL_updComisionesxInt...
     P                 b                   export
     D SVPPOL_updComisionesxInt...
     D                 pi              n
     D   peDsD3                            likeds( dsPahed3_t ) const

     D   k1yed3        ds                  likerec( p1hed3 : *key )
     D   @@DsOD3       ds                  likerec( p1hed3 : *output )

      /free

       SVPPOL_inz();

       k1yed3.d3empr = peDsD3.d3empr;
       k1yed3.d3sucu = peDsD3.d3sucu;
       k1yed3.d3arcd = peDsD3.d3arcd;
       k1yed3.d3spol = peDsD3.d3spol;
       k1yed3.d3sspo = peDsD3.d3sspo;
       k1yed3.d3rama = peDsD3.d3rama;
       k1yed3.d3arse = peDsD3.d3arse;
       k1yed3.d3oper = peDsD3.d3oper;
       k1yed3.d3suop = peDsD3.d3suop;
       k1yed3.d3nivt = peDsD3.d3nivt;
       k1yed3.d3nivc = peDsD3.d3nivc;
       k1yed3.d3rpro = peDsD3.d3rpro;
       chain %kds( k1yed3 : 12 ) pahed3;
       if %found( pahed3 );

         eval-corr @@DsOD3 = peDsD3;
         monitor;
           update p1heD3 @@DsOD3;
         on-error;
           return *off;
         endmon;

       endif;

       return *on;

     P SVPPOL_updComisionesxInt...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_delComisionesxInt: Elimina Comisiones.-               *
     ?*                                                              *
     ?*     peDsD3  (  input  )  Est. Comisiones                     *
     ?*     peDsD3C (  input  )  Cant. Est. Comisiones               *
     ?*                                                              *
     ?* Retorna: *on = elimino ok / *off = no elimino                *
     ?* ------------------------------------------------------------ *
     P SVPPOL_delComisionesxInt...
     P                 b                   export
     D SVPPOL_delComisionesxInt...
     D                 pi              n
     D   peDsD3                            likeds( dsPahed3_t ) dim( 999 ) const
     D   peDsD3C                     10i 0

     D   x             s             10i 0
     D   k1yed3        ds                  likerec( p1hed3 : *key )

      /free

       SVPPOL_inz();

       for x = 1 to peDsD3C;
         k1yed3.d3empr = peDsD3( x ).d3empr;
         k1yed3.d3sucu = peDsD3( x ).d3sucu;
         k1yed3.d3arcd = peDsD3( x ).d3arcd;
         k1yed3.d3spol = peDsD3( x ).d3spol;
         k1yed3.d3sspo = peDsD3( x ).d3sspo;
         k1yed3.d3rama = peDsD3( x ).d3rama;
         k1yed3.d3arse = peDsD3( x ).d3arse;
         k1yed3.d3oper = peDsD3( x ).d3oper;
         k1yed3.d3suop = peDsD3( x ).d3suop;
         k1yed3.d3nivt = peDsD3( x ).d3nivt;
         k1yed3.d3nivc = peDsD3( x ).d3nivc;
         k1yed3.d3rpro = peDsD3( x ).d3rpro;
         chain %kds( k1yed3 : 12 ) pahed3;
         if %found( pahed3 );
           delete p1hed3;
         endif;
       endfor;

       return *on;

     P SVPPOL_delComisionesxInt...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_chkClausula:Validar si la poliza contiene clausulas   *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_chkClausula...
     P                 b                   export
     D SVPPOL_chkClausula...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     D   k1yed4        ds                  likerec( p1hed4 : *key )

      /free

       SVPPOL_inz();

       k1yed4.d4empr = peEmpr;
       k1yed4.d4sucu = peSucu;
       k1yed4.d4arcd = peArcd;
       k1yed4.d4spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null ;

                k1yed4.d4sspo = pesspo;
                k1yed4.d4rama = peRama;
                k1yed4.d4arse = peArse;
                k1yed4.d4oper = peOper;
                k1yed4.d4suop = peSuop;
                setll %kds( k1yed4 : 9 ) pahed4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null ;

                k1yed4.d4sspo = pesspo;
                k1yed4.d4rama = peRama;
                k1yed4.d4arse = peArse;
                k1yed4.d4oper = peOper;
                setll %kds( k1yed4 : 8 ) pahed4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed4.d4sspo = pesspo;
                k1yed4.d4rama = peRama;
                k1yed4.d4arse = peArse;
                setll %kds( k1yed4 : 7 ) pahed4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed4.d4sspo = pesspo;
                k1yed4.d4rama = peRama;
                setll %kds( k1yed4 : 6 ) pahed4;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed4.d4sspo = pesspo;
                setll %kds( k1yed4 : 5 ) pahed4;

           other;
             setll %kds( k1yed4 : 4 ) pahed4;
         endsl;
       else;
         setll %kds( k1yed4 : 4 ) pahed4;
       endif;

       return %equal;

      /end-free

     P SVPPOL_chkClausula...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getClausulas: Retorna Clauslas.-                      *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peDsD4   ( output ) Est. Clausulas            (opcional) *
     ?*     peDsD4C  ( output ) Cant. Clausulas           (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_getClausulas...
     P                 b                   export
     D SVPPOL_getClausulas...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsD4                            likeds( dsPahed4_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD4C                     10i 0 options( *nopass : *omit )

     D   k1yed4        ds                  likerec( p1hed4 : *key )
     D   @@DsID4       ds                  likerec( p1hed4 : *input )
     D   @@DsD4        ds                  likeds( dsPahed4_t ) dim( 999 )
     D   @@DsD4C       s             10i 0

      /free

       SVPPOL_inz();

       k1yed4.d4empr = peEmpr;
       k1yed4.d4sucu = peSucu;
       k1yed4.d4arcd = peArcd;
       k1yed4.d4spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null ;

                k1yed4.d4sspo = pesspo;
                k1yed4.d4rama = peRama;
                k1yed4.d4arse = peArse;
                k1yed4.d4oper = peOper;
                k1yed4.d4suop = peSuop;
                setll %kds( k1yed4 : 9 ) pahed4;
                if not %equal( pahed4 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 9 ) pahed4 @@DsID4;
                dow not %eof( pahed4 );
                  @@DsD4C += 1;
                  eval-corr @@DsD4( @@DsD4C ) = @@DsID4;
                 reade(n) %kds( k1yed4 : 9 ) pahed4 @@DsID4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null ;

                k1yed4.d4sspo = pesspo;
                k1yed4.d4rama = peRama;
                k1yed4.d4arse = peArse;
                k1yed4.d4oper = peOper;
                setll %kds( k1yed4 : 8 ) pahed4;
                if not %equal( pahed4 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 8 ) pahed4 @@DsID4;
                dow not %eof( pahed4 );
                  @@DsD4C += 1;
                  eval-corr @@DsD4( @@DsD4C ) = @@DsID4;
                 reade(n) %kds( k1yed4 : 8 ) pahed4 @@DsID4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed4.d4sspo = pesspo;
                k1yed4.d4rama = peRama;
                k1yed4.d4arse = peArse;
                setll %kds( k1yed4 : 7 ) pahed4;
                if not %equal( pahed4 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 7 ) pahed4 @@DsID4;
                dow not %eof( pahed4 );
                  @@DsD4C += 1;
                  eval-corr @@DsD4( @@DsD4C ) = @@DsID4;
                 reade(n) %kds( k1yed4 : 7 ) pahed4 @@DsID4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed4.d4sspo = pesspo;
                k1yed4.d4rama = peRama;
                setll %kds( k1yed4 : 6 ) pahed4;
                if not %equal( pahed4 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 6 ) pahed4 @@DsID4;
                dow not %eof( pahed4 );
                  @@DsD4C += 1;
                  eval-corr @@DsD4( @@DsD4C ) = @@DsID4;
                 reade(n) %kds( k1yed4 : 6 ) pahed4 @@DsID4;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed4.d4sspo = pesspo;
                setll %kds( k1yed4 : 5 ) pahed4;
                if not %equal( pahed4 );
                  return *off;
                endif;
                reade(n) %kds( k1yed4 : 5 ) pahed4 @@DsID4;
                dow not %eof( pahed4 );
                  @@DsD4C += 1;
                  eval-corr @@DsD4( @@DsD4C ) = @@DsID4;
                 reade(n) %kds( k1yed4 : 5 ) pahed4 @@DsID4;
                enddo;

           other;
             setll %kds( k1yed4 : 4 ) pahed4;
             if not %equal( pahed4 );
               return *off;
             endif;
             reade(n) %kds( k1yed4 : 4 ) pahed4 @@DsID4;
             dow not %eof( pahed4 );
               @@DsD4C += 1;
               eval-corr @@DsD4( @@DsD4C ) = @@DsID4;
              reade(n) %kds( k1yed4 : 4 ) pahed4 @@DsID4;
             enddo;
         endsl;
       else;
         setll %kds( k1yed4 : 4 ) pahed4;
         if not %equal( pahed4 );
           return *off;
         endif;
         reade(n) %kds( k1yed4 : 4 ) pahed4 @@DsID4;
         dow not %eof( pahed4 );
           @@DsD4C += 1;
           eval-corr @@DsD4( @@DsD4C ) = @@DsID4;
          reade(n) %kds( k1yed4 : 4 ) pahed4 @@DsID4;
         enddo;
       endif;

       if %parms >= 5;
         if %addr( peDsD4  ) <> *null;
           eval-corr peDsD4 = @@DsD4;
         endif;
         if %addr( peDsD4C ) <> *null;
           peDsD4C = @@DsD4C;
         endif;
       endif;

       return *on;

      /end-free

     P SVPPOL_getClausulas...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_setClausulas: Graba Clausulas                         *
     ?*                                                              *
     ?*     peDsD4  (  input  )  Est. Clausulas                      *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P SVPPOL_setClausulas...
     P                 b                   export
     D SVPPOL_setClausulas...
     D                 pi              n
     D   peDsD4                            likeds( dsPahed4_t ) const

     D   @@DsOD4       ds                  likerec( p1hed4 : *output )

      /free

       SVPPOL_inz();

       if SVPPOL_chkClausula( peDsD4.d4empr
                            : peDsD4.d4sucu
                            : peDsD4.d4arcd
                            : peDsD4.d4spol
                            : peDsD4.d4sspo
                            : peDsD4.d4rama
                            : peDsD4.d4arse
                            : peDsD4.d4oper
                            : peDsD4.d4suop  );
         return *off;
       endif;

       eval-corr @@DsOD4 = peDsD4;
       monitor;
         write p1heD4 @@DsOD4;
       on-error;
         return *off;
       endmon;

       return *on;

     P SVPPOL_setClausulas...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_chkAnexos: Validar si la poliza contiene Anexos.-     *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_chkAnexo...
     P                 b                   export
     D SVPPOL_chkAnexo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const

     D   k1yed5        ds                  likerec( p1hed5 : *key )

      /free

       SVPPOL_inz();

       k1yed5.d5empr = peEmpr;
       k1yed5.d5sucu = peSucu;
       k1yed5.d5arcd = peArcd;
       k1yed5.d5spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null ;

                k1yed5.d5sspo = pesspo;
                k1yed5.d5rama = peRama;
                k1yed5.d5arse = peArse;
                k1yed5.d5oper = peOper;
                k1yed5.d5suop = peSuop;
                setll %kds( k1yed5 : 9 ) pahed5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null ;

                k1yed5.d5sspo = pesspo;
                k1yed5.d5rama = peRama;
                k1yed5.d5arse = peArse;
                k1yed5.d5oper = peOper;
                setll %kds( k1yed5 : 8 ) pahed5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed5.d5sspo = pesspo;
                k1yed5.d5rama = peRama;
                k1yed5.d5arse = peArse;
                setll %kds( k1yed5 : 7 ) pahed5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed5.d5sspo = pesspo;
                k1yed5.d5rama = peRama;
                setll %kds( k1yed5 : 6 ) pahed5;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed5.d5sspo = pesspo;
                setll %kds( k1yed5 : 5 ) pahed5;

           other;
             setll %kds( k1yed5 : 4 ) pahed5;
         endsl;
       else;
         setll %kds( k1yed5 : 4 ) pahed5;
       endif;

       return %equal;

      /end-free

     P SVPPOL_chkAnexo...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getAnexos: Retorna Anexos.-                           *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peSspo   ( input  ) Suplemento                (opcional) *
     ?*     peRama   ( input  ) Rama                      (opcional) *
     ?*     peArse   ( input  ) Cant. de Polizas          (opcional) *
     ?*     peOper   ( input  ) Código de Operacion       (opcional) *
     ?*     peSuop   ( input  ) Cant.de Polizas           (opcional) *
     ?*     peDsD5   ( output ) Est. Clausulas            (opcional) *
     ?*     peDsD5C  ( output ) Cant. Clausulas           (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPPOL_getAnexos...
     P                 b                   export
     D SVPPOL_getAnexos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options( *nopass : *omit ) const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   peSuop                       3  0 options( *nopass : *omit ) const
     D   peDsD5                            likeds( dsPahed5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsD5C                     10i 0 options( *nopass : *omit )

     D   k1yed5        ds                  likerec( p1hed5 : *key )
     D   @@DsID5       ds                  likerec( p1hed5 : *input )
     D   @@DsD5        ds                  likeds( dsPahed5_t ) dim( 999 )
     D   @@DsD5C       s             10i 0

      /free

       SVPPOL_inz();

       k1yed5.d5empr = peEmpr;
       k1yed5.d5sucu = peSucu;
       k1yed5.d5arcd = peArcd;
       k1yed5.d5spol = peSpol;

       if %parms >= 5;
         Select;
           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) <> *null ;

                k1yed5.d5sspo = pesspo;
                k1yed5.d5rama = peRama;
                k1yed5.d5arse = peArse;
                k1yed5.d5oper = peOper;
                k1yed5.d5suop = peSuop;
                setll %kds( k1yed5 : 9 ) pahed5;
                if not %equal( pahed5 );
                  return *off;
                endif;
                reade(n) %kds( k1yed5 : 9 ) pahed5 @@DsID5;
                dow not %eof( pahed5 );
                  @@DsD5C += 1;
                  eval-corr @@DsD5( @@DsD5C ) = @@DsID5;
                 reade(n) %kds( k1yed5 : 9 ) pahed5 @@DsID5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( peSuop ) =  *null ;

                k1yed5.d5sspo = pesspo;
                k1yed5.d5rama = peRama;
                k1yed5.d5arse = peArse;
                k1yed5.d5oper = peOper;
                setll %kds( k1yed5 : 8 ) pahed5;
                if not %equal( pahed5 );
                  return *off;
                endif;
                reade(n) %kds( k1yed5 : 8 ) pahed5 @@DsID5;
                dow not %eof( pahed5 );
                  @@DsD5C += 1;
                  eval-corr @@DsD5( @@DsD5C ) = @@DsID5;
                 reade(n) %kds( k1yed5 : 8 ) pahed5 @@DsID5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed5.d5sspo = pesspo;
                k1yed5.d5rama = peRama;
                k1yed5.d5arse = peArse;
                setll %kds( k1yed5 : 7 ) pahed5;
                if not %equal( pahed5 );
                  return *off;
                endif;
                reade(n) %kds( k1yed5 : 7 ) pahed5 @@DsID5;
                dow not %eof( pahed5 );
                  @@DsD5C += 1;
                  eval-corr @@DsD5( @@DsD5C ) = @@DsID5;
                 reade(n) %kds( k1yed5 : 7 ) pahed5 @@DsID5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed5.d5sspo = pesspo;
                k1yed5.d5rama = peRama;
                setll %kds( k1yed5 : 6 ) pahed5;
                if not %equal( pahed5 );
                  return *off;
                endif;
                reade(n) %kds( k1yed5 : 6 ) pahed5 @@DsID5;
                dow not %eof( pahed5 );
                  @@DsD5C += 1;
                  eval-corr @@DsD5( @@DsD5C ) = @@DsID5;
                 reade(n) %kds( k1yed5 : 6 ) pahed5 @@DsID5;
                enddo;

           when %addr( peSspo ) <> *null and
                %addr( peRama ) =  *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( peSuop ) =  *null ;

                k1yed5.d5sspo = pesspo;
                setll %kds( k1yed5 : 5 ) pahed5;
                if not %equal( pahed5 );
                  return *off;
                endif;
                reade(n) %kds( k1yed5 : 5 ) pahed5 @@DsID5;
                dow not %eof( pahed5 );
                  @@DsD5C += 1;
                  eval-corr @@DsD5( @@DsD5C ) = @@DsID5;
                 reade(n) %kds( k1yed5 : 5 ) pahed5 @@DsID5;
                enddo;

           other;
             setll %kds( k1yed5 : 4 ) pahed5;
             if not %equal( pahed5 );
               return *off;
             endif;
             reade(n) %kds( k1yed5 : 4 ) pahed5 @@DsID5;
             dow not %eof( pahed5 );
               @@DsD5C += 1;
               eval-corr @@DsD5( @@DsD5C ) = @@DsID5;
              reade(n) %kds( k1yed5 : 4 ) pahed5 @@DsID5;
             enddo;
         endsl;
       else;
         setll %kds( k1yed5 : 4 ) pahed5;
         if not %equal( pahed5 );
           return *off;
         endif;
         reade(n) %kds( k1yed5 : 4 ) pahed5 @@DsID5;
         dow not %eof( pahed5 );
           @@DsD5C += 1;
           eval-corr @@DsD5( @@DsD5C ) = @@DsID5;
          reade(n) %kds( k1yed5 : 4 ) pahed5 @@DsID5;
         enddo;
       endif;

       if %parms >= 5;
         if %addr( peDsD5  ) <> *null;
           eval-corr peDsD5 = @@DsD5;
         endif;
         if %addr( peDsD5C ) <> *null;
           peDsD5C = @@DsD5C;
         endif;
       endif;

       return *on;

      /end-free

     P SVPPOL_getAnexos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_setAnexos: Graba Anexos                               *
     ?*                                                              *
     ?*     peDsD5  (  input  )  Est. Anexos                         *
     ?*                                                              *
     ?* Retorna: *on = Grabo ok / *off = No Grabo                    *
     ?* ------------------------------------------------------------ *
     P SVPPOL_setAnexos...
     P                 b                   export
     D SVPPOL_setAnexos...
     D                 pi              n
     D   peDsD5                            likeds( dsPahed5_t ) const

     D   @@DsOD5       ds                  likerec( p1hed5 : *output )

      /free

       SVPPOL_inz();

       if SVPPOL_chkAnexo( peDsD5.d5empr
                         : peDsD5.d5sucu
                         : peDsD5.d5arcd
                         : peDsD5.d5spol
                         : peDsD5.d5sspo
                         : peDsD5.d5rama
                         : peDsD5.d5arse
                         : peDsD5.d5oper
                         : peDsD5.d5suop  );
         return *off;
       endif;

       eval-corr @@DsOD5 = peDsD5;
       monitor;
         write p1heD5 @@DsOD5;
       on-error;
         return *off;
       endmon;

       return *on;

     P SVPPOL_setAnexos...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPPOL_getVariacionDeComision                                *
     ?*    Retorna diferencia de Comision entre el ultimo movimiento *
     ?*    anterior y el movimiento actual.                          *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peRama   ( input  ) Rama                                 *
     ?*     peArse   ( input  ) Cant. de Polizas                     *
     ?*     peOper   ( input  ) Código de Operacion                  *
     ?*                                                              *
     ?* Retorna: 3/0                                                 *
     ?* ------------------------------------------------------------ *
     P SVPPOL_getVariacionDeComision...
     P                 b                   export
     D SVPPOL_getVariacionDeComision...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const

     D   k1yed0        ds                  likerec( p1hed0 : *key    )
     D   k1yed1        ds                  likerec( p1hed1 : *key    )
     D   k1yed3        ds                  likerec( p1hed3 : *key    )

     D   @@dife        s              3  0

      /free

       SVPPOL_inz();

       @@dife = *zeros;

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;
       setgt %kds( k1yed0 : 4 ) pahed0;
       readpe(n) %kds( k1yed0 : 4 ) pahed0;
         dow not %eof( pahed0 );
          if d0tiou = 1 or d0tiou = 2;
           leave;
          endif;
       readpe(n) %kds( k1yed0 : 4 ) pahed0;
       enddo;

       k1yed1.d1empr = d0empr;
       k1yed1.d1sucu = d0sucu;
       k1yed1.d1arcd = d0arcd;
       k1yed1.d1spol = d0spol;
       k1yed1.d1sspo = d0sspo;
        chain %kds( k1yed1 : 5 ) pahed1;
         if %found(pahed1);
          k1yed3.d3empr = d0empr;
          k1yed3.d3sucu = d0sucu;
          k1yed3.d3arcd = d0arcd;
          k1yed3.d3spol = d0spol;
          k1yed3.d3sspo = d0sspo;
          k1yed3.d3rama = d0rama;
          k1yed3.d3arse = d0arse;
          k1yed3.d3oper = d0oper;
          k1yed3.d3suop = d0suop;
          k1yed3.d3nivt = 1;
           chain %kds( k1yed3 : 10 ) pahed3;
            if %found(pahed3);
              @@dife = d3xopr - d1pdn1;
            endif;
         endif;

       return @@dife;

     P SVPPOL_getVariacionDeComision...
     P                 e

      * ------------------------------------------------------------ *
      * SVPPOL_isNominaExterna: Retorna si es Nomina Externa y       *
      *                         opcionalmente, numero de nomina      *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peNomi   ( output ) Numero de Nomina                     *
      *                                                              *
      * Retorna: *off / *on                                          *
      * ------------------------------------------------------------ *
     P SVPPOL_isNominaExterna...
     P                 b                   export
     D SVPPOL_isNominaExterna...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peNomi                       7  0 options( *nopass : *omit )

     D dsHnx004        ds                  likerec( p1hnx004 : *input )
     D k1Hnx004        ds                  likerec( p1hnx004 : *key )

      /free

       SVPPOL_inz();

       k1Hnx004.n0Empr = peEmpr;
       k1Hnx004.n0Sucu = peSucu;
       k1Hnx004.n0Rama = peRama;
       k1Hnx004.n0Poli = pePoli;

       chain(n) %kds( k1Hnx004 : 4 ) pahnx004 dsHnx004;
       if not %found ( pahnx004 );
         if %parms >= 5 and %addr( peNomi ) <> *Null;
           clear peNomi;
         endif;
         return *off;
       endif;

       if %parms >= 5 and %addr( peNomi ) <> *Null;
         peNomi = dsHnx004.n0nomi;
       endif;
       return *on;

      /end-free

     P SVPPOL_isNominaExterna...
     P                 e

      * ------------------------------------------------------------ *
      * SVPPOL_tipoAsistencia: Retorna el tipo de asistencia que de  *
      *                        la póliza.                            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia Artículo/Rama              *
      *     peOper   ( input  ) Operación                            *
      *     pePoli   ( input  ) Poliza                               *
      *     peCuad   ( output ) Nombre del cuadernillo de asistencia *
      *                                                              *
      * Retorna: IKE = IKE Asistencia                                *
      *          EUR = Europ Assist                                  *
      *          AON = Aon Assist                                    *
      *       Blanco = Sin asistencia                                *
      * ------------------------------------------------------------ *
     P SVPPOL_tipoAsistencia...
     P                 B                   export
     D SVPPOL_tipoAsistencia...
     D                 pi             3a
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peCuad                     256a   options(*nopass:*omit)

     D SPDETEUR        pr                  extpgm('SPDETEUR')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peEeur                        1n
     D  peEpgm                        3a   const
     D  peTpcd                        2a   options(*nopass)

     D SPDETAON        pr                  extpgm('SPDETAON')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peEaon                        1n
     D  peEpgm                        3a   const
     D  peTpcd                        2a   options(*nopass)

     D SPASIMO         pr                  extpgm('SPASIMO')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peAmot                        1n

     D peEeur          s              1n
     D peEaon          s              1n
     D peAmot          s              1n
     D peCval          s             10a
     D peVsys          s            512a
     D tasi            s             10a
     D cuad            s            256a
     D peSspo          s              3  0

      /free

       SVPPOL_inz();

       chain peRama set001;
       if not %found;
          if %parms >= 9 and %addr(peCuad) <> *null;
              peCuad = *blanks;
          endif;
          return *blanks;
       endif;

       SPDETAON( peEmpr
               : peSucu
               : peArcd
               : peSpol
               : peEaon
               : *blanks  );

       SPDETEUR( peEmpr
               : peSucu
               : peArcd
               : peSpol
               : peEeur
               : *blanks  );

       peSspo = SPVSPO_getUltimoSuplemento( peEmpr
                                          : peSucu
                                          : peArcd
                                          : peSpol );

       SPASIMO ( peEmpr
               : peSucu
               : peArcd
               : peSpol
               : peSspo
               : peAmot   );

       cuad   = *blanks;
       peCval = *blanks;
       peVsys = *blanks;
       tasi   = *blanks;

       select;
        when peRama = 3 or peRama = 6;
             tasi   = 'IKE';
             peCval = 'HIKEAUTOMO';
             if peEaon;
                tasi   = 'AON';
                peCval = 'HAONAUTOMO';
             endif;
        when peRama = 12;
             if peAmot;
                tasi   = 'IKE';
                peCval = 'HIKEMOTOVE';
                if peEaon;
                   tasi   = 'AON';
                   peCval = 'HAONAUTOMO';
                endif;
              else;
                tasi   = 'IKE';
                peCval = 'HIKEAUTOMO';
                if peEaon;
                   tasi   = 'AON';
                   peCval = 'HAONNOTOVE';
                endif;
             endif;
        when peRama = 17;
             peCval = 'HIKEEMBARC';
             tasi   = 'IKE';
        when peRama = 26;
             peCval = 'HIKECONSOR';
             tasi   = 'IKE';
             if peEaon;
                peCval = 'HAONCONSOR';
                tasi   = 'AON';
             endif;
        when peRama = 27;
             peCval = 'HIKECOMFAM';
             if peEaon;
                peCval = 'HAONCOMFAM';
                tasi   = 'AON';
             endif;
             if peEeur;
                peCval = 'HEURCOMFAM';
                tasi   = 'EUR';
             endif;
        when peRama = 28;
             peCval = 'HIKECOMERC';
             tasi   = 'IKE';
             if peEaon;
                peCval = 'HAONCOMERC';
                tasi   = 'AON';
             endif;
       endsl;

       if peCval <> *blanks;
          if SVPVLS_getValSys( peCval: *omit : peVsys );
             cuad = %trim(peVsys);
          endif;
       endif;

       if %parms >= 9 and %addr(peCuad) <> *null;
          peCuad = cuad;
       endif;

       return tasi;

      /end-free

     P SVPPOL_tipoAsistencia...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPOL_getPremioAcumulado: Retorna premio acumulado          *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peSspo   ( input  ) Suplemento              ( opcional ) *
      *     peRama   ( input  ) Rama                    ( opcional ) *
      *     peArse   ( input  ) Secuencia Artículo/Rama ( opcional ) *
      *     peOper   ( input  ) Operación               ( opcional ) *
      *     peSuop   ( input  ) Suplemento de Operacion ( opcional ) *
      *     peRead   ( output ) Recargo Administrativo  ( opcional ) *
      *     peRefi   ( output ) Recargo Financiero      ( opcional ) *
      *     peDere   ( output ) Derecho de Emision      ( opcional ) *
      *                                                              *
      * Retorna: Premio Acumulado                                    *
      * ------------------------------------------------------------ *
     P SVPPOL_getPremioAcumulado...
     P                 B                   export
     D SVPPOL_getPremioAcumulado...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options(*nopass:*omit)
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peOper                       7  0 const options(*nopass:*omit)
     D   peSuop                       3  0 const options(*nopass:*omit)
     D   peRead                      15  2 options(*nopass:*omit)
     D   peRefi                      15  2 options(*nopass:*omit)
     D   peDere                      15  2 options(*nopass:*omit)

     D   @@prem        s             15  2
     D   @@read        s             15  2
     D   @@refi        s             15  2
     D   @@dere        s             15  2

     D   k1yed0        ds                  likerec( p1hed005 : *key )

      /free

       SVPPOL_inz();

       clear @@prem;

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;

       Select;
         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) <> *null
                          and  %addr( peOper ) <> *null
                          and  %addr( peSuop ) <> *null;

              k1yed0.d0sspo = peSspo;
              k1yed0.d0rama = peRama;
              k1yed0.d0arse = peArse;
              k1yed0.d0oper = peOper;
              k1yed0.d0suop = peSuop;

              setll %kds( k1yed0 : 9 ) pahed005;
              reade %kds( k1yed0 : 9 ) pahed005;
              dow not %eof( pahed005 );
                @@prem += d0prem;
                @@read += d0read;
                @@refi += d0refi;
                @@dere += d0dere;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 9 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) <> *null
                          and  %addr( peOper ) <> *null
                          and  %addr( peSuop ) =  *null;

              k1yed0.d0sspo = peSspo;
              k1yed0.d0rama = peRama;
              k1yed0.d0arse = peArse;
              k1yed0.d0oper = peOper;

              setll %kds( k1yed0 : 8 ) pahed005;
              reade %kds( k1yed0 : 8 ) pahed005;
              dow not %eof( pahed005 );
                @@prem += d0prem;
                @@read += d0read;
                @@refi += d0refi;
                @@dere += d0dere;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 8 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) <> *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              k1yed0.d0sspo = peSspo;
              k1yed0.d0rama = peRama;
              k1yed0.d0arse = peArse;

              setll %kds( k1yed0 : 7 ) pahed005;
              reade %kds( k1yed0 : 7 ) pahed005;
              dow not %eof( pahed005 );
                @@prem += d0prem;
                @@read += d0read;
                @@refi += d0refi;
                @@dere += d0dere;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 7 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) =  *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              k1yed0.d0sspo = peSspo;
              k1yed0.d0rama = peRama;

              setll %kds( k1yed0 : 6 ) pahed005;
              reade %kds( k1yed0 : 6 ) pahed005;
              dow not %eof( pahed005 );
                @@prem += d0prem;
                @@read += d0read;
                @@refi += d0refi;
                @@dere += d0dere;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 6 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) =  *null
                          and  %addr( peArse ) =  *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              k1yed0.d0sspo = peSspo;

              setll %kds( k1yed0 : 5 ) pahed005;
              reade %kds( k1yed0 : 5 ) pahed005;
              dow not %eof( pahed005 );
                @@prem += d0prem;
                @@read += d0read;
                @@refi += d0refi;
                @@dere += d0dere;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 5 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) =  *null
                          and  %addr( peRama ) =  *null
                          and  %addr( peArse ) =  *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              setll %kds( k1yed0 : 4 ) pahed005;
              reade %kds( k1yed0 : 4 ) pahed005;
              dow not %eof( pahed005 );
                @@prem += d0prem;
                @@read += d0read;
                @@refi += d0refi;
                @@dere += d0dere;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 4 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) =  *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) <> *null
                          and  %addr( peOper ) <> *null
                          and  %addr( peSuop ) <> *null;

              setll %kds( k1yed0 : 4 ) pahed005;
              reade %kds( k1yed0 : 4 ) pahed005;
              dow not %eof( pahed005 );
                if peRama = d0rama and
                   peArse = d0arse and
                   peOper = d0oper and
                   peSuop = d0suop;

                  @@prem += d0prem;
                  @@read += d0read;
                  @@refi += d0refi;
                  @@dere += d0dere;

                 if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                    leave;
                 endif;

                 endif;
               reade %kds( k1yed0 : 4 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) =  *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) =  *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              setll %kds( k1yed0 : 4 ) pahed005;
              reade %kds( k1yed0 : 4 ) pahed005;
              dow not %eof( pahed005 );
                if peRama = d0rama;

                  @@prem += d0prem;
                  @@read += d0read;
                  @@refi += d0refi;
                  @@dere += d0dere;

                  if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                     leave;
                  endif;

                 endif;
               reade %kds( k1yed0 : 4 ) pahed005;
              enddo;

         other;
            setll %kds( k1yed0 : 4 ) pahed005;
            reade %kds( k1yed0 : 4 ) pahed005;
            dow not %eof( pahed005 );
              @@prem += d0prem;
               @@read += d0read;
               @@refi += d0refi;
               @@dere += d0dere;

              if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                 leave;
              endif;

             reade %kds( k1yed0 : 4 ) pahed005;
            enddo;
       endsl;

       if %parms >= 5 and %addr( peRead ) <> *null;
          peRead = @@read;
       endif;

       if %parms >= 5 and %addr( peRefi ) <> *null;
          peRefi = @@refi;
       endif;

       if %parms >= 5 and %addr( pedere ) <> *null;
          peDere = @@dere;
       endif;

       return @@prem;
      /end-free

     P SVPPOL_getPremioAcumulado...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPOL_getPrimaAcumulada: Retorna prima acumulada            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peSspo   ( input  ) Suplemento              ( opcional ) *
      *     peRama   ( input  ) Rama                    ( opcional ) *
      *     peArse   ( input  ) Secuencia Artículo/Rama ( opcional ) *
      *     peOper   ( input  ) Operación               ( opcional ) *
      *     peSuop   ( input  ) Suplemento de Operacion ( opcional ) *
      *                                                              *
      * Retorna: Prima Acumulada                                     *
      * ------------------------------------------------------------ *
     P SVPPOL_getPrimaAcumulada...
     P                 B                   export
     D SVPPOL_getPrimaAcumulada...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const options(*nopass:*omit)
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peOper                       7  0 const options(*nopass:*omit)
     D   peSuop                       3  0 const options(*nopass:*omit)

     D   @@prim        s             15  2

     D   k1yed0        ds                  likerec( p1hed005 : *key )

      /free

       SVPPOL_inz();

       clear @@prim;

       k1yed0.d0empr = peEmpr;
       k1yed0.d0sucu = peSucu;
       k1yed0.d0arcd = peArcd;
       k1yed0.d0spol = peSpol;

       Select;
         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) <> *null
                          and  %addr( peOper ) <> *null
                          and  %addr( peSuop ) <> *null;

              k1yed0.d0sspo = peSspo;
              k1yed0.d0rama = peRama;
              k1yed0.d0arse = peArse;
              k1yed0.d0oper = peOper;
              k1yed0.d0suop = peSuop;

              setll %kds( k1yed0 : 9 ) pahed005;
              reade %kds( k1yed0 : 9 ) pahed005;
              dow not %eof( pahed005 );
                @@prim += d0prim;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 9 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) <> *null
                          and  %addr( peOper ) <> *null
                          and  %addr( peSuop ) =  *null;

              k1yed0.d0sspo = peSspo;
              k1yed0.d0rama = peRama;
              k1yed0.d0arse = peArse;
              k1yed0.d0oper = peOper;

              setll %kds( k1yed0 : 8 ) pahed005;
              reade %kds( k1yed0 : 8 ) pahed005;
              dow not %eof( pahed005 );
                @@prim += d0prim;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 8 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) <> *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              k1yed0.d0sspo = peSspo;
              k1yed0.d0rama = peRama;
              k1yed0.d0arse = peArse;

              setll %kds( k1yed0 : 7 ) pahed005;
              reade %kds( k1yed0 : 7 ) pahed005;
              dow not %eof( pahed005 );
                @@prim += d0prim;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 7 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) =  *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              k1yed0.d0sspo = peSspo;
              k1yed0.d0rama = peRama;

              setll %kds( k1yed0 : 6 ) pahed005;
              reade %kds( k1yed0 : 6 ) pahed005;
              dow not %eof( pahed005 );
                @@prim += d0prim;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 6 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) <> *null
                          and  %addr( peRama ) =  *null
                          and  %addr( peArse ) =  *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              k1yed0.d0sspo = peSspo;

              setll %kds( k1yed0 : 5 ) pahed005;
              reade %kds( k1yed0 : 5 ) pahed005;
              dow not %eof( pahed005 );
                @@prim += d0prim;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 5 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) =  *null
                          and  %addr( peRama ) =  *null
                          and  %addr( peArse ) =  *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              setll %kds( k1yed0 : 4 ) pahed005;
              reade %kds( k1yed0 : 4 ) pahed005;
              dow not %eof( pahed005 );
                @@prim += d0prim;

                if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                   leave;
                endif;

               reade %kds( k1yed0 : 4 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) =  *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) <> *null
                          and  %addr( peOper ) <> *null
                          and  %addr( peSuop ) <> *null;

              setll %kds( k1yed0 : 4 ) pahed005;
              reade %kds( k1yed0 : 4 ) pahed005;
              dow not %eof( pahed005 );
                if peRama = d0rama and
                   peArse = d0arse and
                   peOper = d0oper and
                   peSuop = d0suop;

                  @@prim += d0prim;

                 if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                    leave;
                 endif;

                 endif;
               reade %kds( k1yed0 : 4 ) pahed005;
              enddo;

         when %parms >= 5 and  %addr( peSspo ) =  *null
                          and  %addr( peRama ) <> *null
                          and  %addr( peArse ) =  *null
                          and  %addr( peOper ) =  *null
                          and  %addr( peSuop ) =  *null;

              setll %kds( k1yed0 : 4 ) pahed005;
              reade %kds( k1yed0 : 4 ) pahed005;
              dow not %eof( pahed005 );
                if peRama = d0rama;

                  @@prim += d0prim;

                  if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                     leave;
                  endif;

                 endif;
               reade %kds( k1yed0 : 4 ) pahed005;
              enddo;

         other;
            setll %kds( k1yed0 : 4 ) pahed005;
            reade %kds( k1yed0 : 4 ) pahed005;
            dow not %eof( pahed005 );
              @@prim += d0prim;

              if d0tiou = 3 and d0stou = 11 and d0stos = 1;
                 leave;
              endif;

             reade %kds( k1yed0 : 4 ) pahed005;
            enddo;
       endsl;

       return @@prim;
      /end-free

     P SVPPOL_getPrimaAcumulada...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPOL_getUltimoSuopFacturacion: Retorna ultimo endoso de    *
      *                                  Facturacion.                *
      *                                                              *
      * Ultima facturacion es Poliza Nueva/Refacturacion/Renovacion  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peSspo   ( output ) Suplemento Superpoliza  ( opcional ) *
      *                                                              *
      * Retorna: Suop con ultima facturacion                         *
      * ------------------------------------------------------------ *
     P SVPPOL_getUltimoSuopFacturacion...
     P                 B                   export
     D SVPPOL_getUltimoSuopFacturacion...
     D                 pi             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

     D peHed0C         s             10i 0
     D z               s             10i 0
     D rc              s              1n
     D peHed0          ds                  likeds ( dsPahed0_t ) dim( 999 )

      /free

       SVPPOL_inz();

       rc = SVPPOL_getPoliza( peEmpr
                            : peSucu
                            : peRama
                            : pePoli
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : peHed0
                            : peHed0C );

       if rc = *off;
          return 0;
       endif;

       if %parms >= 5 and %addr(peSspo) <> *null;
          peSspo = peHed0(peHed0C).d0sspo;
       endif;

       return %dec(peHed0(peHed0C).d0suop:3:0);

      /end-free

     P SVPPOL_getUltimoSuopFacturacion...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPOL_getDeuda: Retorna deuda acumulada                     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peDsCd   ( output ) Est. Cuotas               (opcional) *
      *     peDsCdC  ( output ) Cant. Cuotas              (opcional) *
      *                                                              *
      * Retorna: Importe                                             *
      * ------------------------------------------------------------ *
     P SVPPOL_getDeuda...
     P                 B                   export
     D SVPPOL_getDeuda...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peDsCd                            likeds( dsPahcd5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsCdC                     10i 0 options( *nopass : *omit )

     D k1hcd5          ds                  likerec( p1hcd501 : *key )

     D hoy             s              8  0
     D aÑo             s              4  0
     D mes             s              2  0
     D dia             s              2  0

     D @@Rc1           s               n
     D @@RqFi          s              8  0 inz(*zeros)
     D @@RqSg          s              1    inz(*zeros)
     D @@RqQd          s              3  0 inz(*zeros)
     D @@RqFf          s              8  0 inz(*zeros)
     D @@Spol          s              9  0
     D @@Arcd          s              6  0
     D @@Cfpg          s              1  0
     D @@FecDate       s               d
     D @@CuoPend       s               n
     D @@FechaAux      s              8  0
     D @@DeudaTot      s             15  2
     D @@DsICd         ds                  likerec( p1hcd501 : *input  )
     D DsCd5           ds                  likeds( dsPahcd5_t ) dim( 999 )
     D DsCd5C          s             10i 0

     D                 ds
     D dsFamd                  1      8  0
     D dsF1aa                  1      4  0
     D dsF1mm                  5      6  0
     D dsF1dd                  7      8  0

      /free

       SVPPOL_inz();

       @@Rc1  = *Off;
       DsCd5C = 0;
       clear DsCd5;
       clear @@DeudaTot;

       PAR310X3( peEmpr : aÑo : mes : dia );
       hoy = ( aÑo * 10000) + ( mes * 100) + dia;

       @@Spol = SVPPOL_getSuperPoliza( peEmpr : peSucu : peRama : pePoli );
       @@Arcd = SVPPOL_getArticulo( peEmpr : peSucu : peRama : pePoli );
       @@Cfpg = SPVSPO_getFormaDePago( peEmpr : peSucu : @@Arcd : @@Spol );

       k1hcd5.d5empr = peEmpr;
       k1hcd5.d5sucu = peSucu;
       k1hcd5.d5rama = peRama;
       k1hcd5.d5poli = pePoli;
       setll %kds( k1hcd5 : 4 ) pahcd501;
       dou %eof( pahcd501 );
         reade(n) %kds( k1hcd5 : 4 ) pahcd501 @@DsICd;
         if not %eof( pahcd501 );
           if @@DsICd.d5Sttc <> '3';

             @@FechaAux = ( @@DsICd.d5fvca * 10000 )
                        + ( @@DsICd.d5fvcm * 100   ) + @@DsICd.d5fvcd;

             // Primer Vencimiento Impago
             if not @@Rc1;

               @@FechaAux = ( @@DsICd.d5fvca * 10000 )
                          + ( @@DsICd.d5fvcm * 100   ) + @@DsICd.d5fvcd;

               clear @@RqFf;
               select;
                when @@Cfpg = 1;
                  dsFamd = @@FechaAux;
                  dsF1dd = 1;

                  @@FecDate = %date(dsFamd);
                  @@FecDate = @@FecDate + %months(1);
                  @@FecDate = @@FecDate - %days(1);

                  @@RqFi = %dec(@@FecDate);
                  @@RqSg = '+';
                  @@RqQd = 1;
                  @@RqFf = SPVFEC_SumResDiaHabF8( @@RqFi
                                                : @@RqSg
                                                : @@RqQd );

                when @@Cfpg = 2 or @@Cfpg = 3;
                  @@RqFi = @@FechaAux;
                  @@RqSg = '+';
                  @@RqQd = 2;
                  @@RqFf = SPVFEC_SumResDiaHabF8( @@RqFi
                                                : @@RqSg
                                                : @@RqQd );

                other;
                  @@RqFf = @@FechaAux;

               endsl;

               @@RqFi = @@FechaAux;
               @@CuoPend = *Off;
               if @@RqFf < hoy;
                 @@CuoPend = *On;
               endif;

               @@Rc1 = *On;

             endif;

             // Acumula deuda total
             if @@FechaAux < hoy;
               DsCd5C += 1;
               eval-corr DsCd5( DsCd5C ) = @@DsICd;
               @@DeudaTot += @@DsICd.d5imcu;
             endif;
           endif;
         endif;
       enddo;

       if %addr( peDsCd ) <> *null;
         eval-corr peDsCd = DsCd5;
       endif;

       if %addr( peDsCdC ) <> *null;
          peDsCdC = DsCd5C;
       endif;

       return @@DeudaTot;

      /end-free

     P SVPPOL_getDeuda...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPOL_getProximaCuotaAVencer: Retorna proxima cuota a       *
      *                                vencer                        *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peRama   ( input  ) Rama                                 *
      *     pePoli   ( input  ) Poliza                               *
      *     peDsCd   ( output ) Est. Cuotas               (opcional) *
      *     peDsCdC  ( output ) Cant. Cuotas              (opcional) *
      *                                                              *
      * Retorna: Importe de cuota a vencer                           *
      * ------------------------------------------------------------ *
     P SVPPOL_getProximaCuotaAVencer...
     P                 B                   export
     D SVPPOL_getProximaCuotaAVencer...
     D                 pi            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peDsCd                            likeds( dsPahcd5_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsCdC                     10i 0 options( *nopass : *omit )

     D k1hcd5          ds                  likerec( p1hcd501 : *key )

     D i               s             10i 0
     D hoy             s              8  0
     D aÑo             s              4  0
     D mes             s              2  0
     D dia             s              2  0
     D @@Impo          s             15  2
     D proxVto         s              8  0
     D @@DsICd         ds                  likerec( p1hcd501 : *input  )
     D DsCd5           ds                  likeds( dsPahcd5_t ) dim( 999 )
     D DsCd5C          s             10i 0

     D cuotas          ds                  qualified dim(256)
     D  fvto                          8  0
     D  imcu                         15  2

      /free

       SVPPOL_inz();

       clear cuotas;
       clear DsCd5;

       @@Impo  = 0;
       DsCd5C  = 0;
       proxVto = 0;

       PAR310X3( peEmpr : aÑo : mes : dia );
       hoy = ( aÑo * 10000) + ( mes * 100) + dia;

       k1hcd5.d5Empr = peEmpr;
       k1hcd5.d5Sucu = peSucu;
       k1hcd5.d5Rama = peRama;
       k1hcd5.d5Poli = pePoli;
       setll %kds( k1hcd5 : 4 ) pahcd501;
       reade(n) %kds( k1hcd5 : 4 ) pahcd501 @@DsICd;
       dow not %eof;
         if @@DsICd.d5sttc <> '3';
           proxVto = ( @@DsICd.d5fvca * 10000 )
                   + ( @@DsICd.d5fvcm * 100   ) + @@DsICd.d5fvcd;
           if proxVto >= hoy;
             i = %lookup( proxVto : cuotas(*).fvto );
             if i = 0;
               i = %lookup( 0 : cuotas(*).fvto );
             endif;
             if i > 0;
               DsCd5C += 1;
               eval-corr DsCd5( DsCd5C ) = @@DsICd;
               cuotas(i).fvto  = proxVto;
               cuotas(i).imcu += @@DsICd.d5imcu;
             endif;
           endif;
         endif;
         reade(n) %kds( k1hcd5 : 4 ) pahcd501 @@DsICd;
       enddo;

       sorta cuotas(*).fvto;
       for i = 1 to 256;
         if cuotas(i).imcu <> 0;
           proxVto = cuotas(i).fvto;
           @@Impo  = cuotas(i).imcu;
           leave;
         endif;
       endfor;

       if %addr( peDsCd ) <> *null;
         eval-corr peDsCd = DsCd5;
       endif;

       if %addr( peDsCdC ) <> *null;
          peDsCdC = DsCd5C;
       endif;

       return @@Impo;

      /end-free

     P SVPPOL_getProximaCuotaAVencer...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPOL_permiteAnular: Retorna si una poliza permite anularse *
      *                       desde Autogestion.                     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia Artículo/Rama              *
      *     peOper   ( input  ) Operación                            *
      *     pePoli   ( input  ) Poliza                               *
      *                                                              *
      * Retorna: *ON = Se permite                                    *
      *          *OFF = No se permite                                *
      * ------------------------------------------------------------ *
     P SVPPOL_permiteAnular...
     P                 B                   export
     D SVPPOL_permiteAnular...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const

      /free

       SVPPOL_inz();

       //
       // Por ahora, solo permito anular Ap Transito que
       // se vende por Autogestion. O sea que cualquier
       // otro artículo, no permite.
       //
       if peArcd <> 2025;
          return *off;
       endif;

       if SVPPOL_permiteArrepentir( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol
                                  : peRama
                                  : peArse
                                  : peOper
                                  : pePoli  );
          return *off;
       endif;

       if SVPPOL_anulacionEnProceso( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : peRama
                                   : peArse
                                   : peOper
                                   : pePoli );
          return *off;
       endif;

       return *on;

      /end-free

     P SVPPOL_permiteAnular...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPOL_permiteArrepentir: Retorna si una poliza permite el   *
      *                           botón de arrepentimiento.          *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia Artículo/Rama              *
      *     peOper   ( input  ) Operación                            *
      *     pePoli   ( input  ) Poliza                               *
      *                                                              *
      * Retorna: *ON = Se permite                                    *
      *          *OFF = No se permite                                *
      * ------------------------------------------------------------ *
     P SVPPOL_permiteArrepentir...
     P                 B                   export
     D SVPPOL_permiteArrepentir...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const

     D @vsys           s            512a
     D dias            s              3  0
     D hoy             s              8  0
     D femi            s              8  0
     D femi2           s              8  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D peCant          s              5  0
     D peErro          s              1a

     D k1wkl1          ds                  likerec(p1wkl1:*key)
     D k1i982          ds                  likerec(g1t982:*key)
     D k1wpc0          ds                  likerec(p1wpc0:*key)

      /free

       SVPPOL_inz();

       if SVPVLS_getValSys( 'HAUGDIAARR' : *omit : @vsys );
          dias = %dec(@vsys:3:0);
        else;
          dias = 10;
       endif;

       peCant = dias;

       femi = SPVSPO_getFecEmi( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol );
       SPOPFECH( femi
               : '+'
               : 'D'
               : peCant
               : femi2
               : peErro
               : 'AMD'   );

       femi = femi2;

       PAR310X3( peEmpr : peFema : peFemm : peFemd );
       hoy = ( peFema * 10000)
           + ( peFemm *   100)
           +   peFemd;

       if (hoy >= femi);
          return *off;
       endif;

       //
       // Si tiene siniestros, no puede arrepentirse
       //
       if SVPSIN_getSini( peEmpr
                        : peSucu
                        : peArcd
                        : peSpol );
          return *off;
       endif;

       //
       // Endosos pendientes en PAWPC0
       //
       k1wpc0.w0empr = peEmpr;
       k1wpc0.w0sucu = peSucu;
       k1wpc0.w0arcd = peArcd;
       k1wpc0.w0spo1 = peSpol;
       setll %kds(k1wpc0) pawpc0;
       if %equal;
          return *off;
       endif;

       //
       // Endosos pendientes en GTI982
       //
       k1i982.g2arcd = peArcd;
       k1i982.g2poli = pePoli;
       setll %kds(k1i982:2) gti982;
       if %equal;
          return *off;
       endif;

       if SVPPOL_anulacionEnProceso( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : peRama
                                   : peArse
                                   : peOper
                                   : pePoli );
          return *off;
       endif;

       return *on;

      /end-free

     P SVPPOL_permiteArrepentir...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPOL_anulacionEnProceso: Retorna si una póliza esta en     *
      *                            proceso de anulación.             *
      *                                                              *
      *  Como, por el momento, aquellas pólizas que se arrepientan o *
      *  anulen desde el portal de autogestion no van a impactar en  *
      *  GAUS si no que se enviará un mail, este procedimiento le    *
      *  dice al portal que todavía no se anuló.                     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia Artículo/Rama              *
      *     peOper   ( input  ) Operación                            *
      *     pePoli   ( input  ) Poliza                               *
      *                                                              *
      * Retorna: *ON = Está en proceso                               *
      *          *OFF = Ya está anulada                              *
      * ------------------------------------------------------------ *
     P SVPPOL_anulacionEnProceso...
     P                 B                   export
     D SVPPOL_anulacionEnProceso...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const

     D k1hag4          ds                  likerec(p1hag4:*key)
     D k1wkl1          ds                  likerec(p1wkl1:*key)
     D k1i982          ds                  likerec(g1t982:*key)
     D k1wpc0          ds                  likerec(p1wpc0:*key)

      /free

       SVPPOL_inz();

       if SPVSPO_chkAnuladaV2( peEmpr
                             : peSucu
                             : peArcd
                             : peSpol
                             : *omit   );
          return *off;
       endif;

       k1wkl1.l1empr = peEmpr;
       k1wkl1.l1sucu = peSucu;
       k1wkl1.l1arcd = peArcd;
       k1wkl1.l1spol = peSpol;
       setll %kds(k1wkl1) pawkl1;
       if %equal;
          return *on;
       endif;

       k1i982.g2arcd = peArcd;
       k1i982.g2poli = pePoli;
       setll %kds(k1i982:2) gti982;
       reade %kds(k1i982:2) gti982;
       dow not %eof;
           if %scan('Anul' : g2log1) > 0;
              return *on;
           endif;
       reade %kds(k1i982:2) gti982;
       enddo;

       k1hag4.g4empr = peEmpr;
       k1hag4.g4sucu = peSucu;
       k1hag4.g4arcd = peArcd;
       k1hag4.g4spol = peSpol;
       k1hag4.g4rama = peRama;
       k1hag4.g4arse = peArse;
       k1hag4.g4oper = peOper;
       k1hag4.g4poli = pePoli;
       k1hag4.g4endo = 0;
       chain(n) %kds(k1hag4) pahag404;
       if %found( pahag404 );
         if g4mar5 <> '4' and g4Mar5 <> '9';
           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SVPPOL_anulacionEnProceso...
     P                 E

