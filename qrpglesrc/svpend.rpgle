     H nomain
      * ************************************************************ *
      * SVPEND: Programa de Servicio.                                *
      *         Endosos                                              *
      * ------------------------------------------------------------ *
      * Gomez Luis R.                     ** 26-Mar-2018 **          *
      * ************************************************************ *
      * Modificaciones:                                              *
      *   JSN 10-07-2020 - Se agregan los procedimientos:            *
      *                    _permitirEndoso()                         *
      *                    _setPahea1()                              *
      *                    _getPaheas()                              *
      *                                                              *
      *   VCM 21-02-2022 - Se agregan los procedimientos:            *
      *                    _updPaheas()                              *
      *                    _getPaheac()                              *
      *                    _chkPaheac()                              *
      *                    _setPaheac()                              *
      *                    _updPaheac()                              *
      *                    _dltPaheac()                              *
      *                    _getSet174()                              *
      *                    _setPaheacXInt()                          *
      *                                                              *
      *   VCM 21-02-2022 - Descomento close *all de procedimiento:   *
      *                    _SVPEND_End()                             *
      *                                                              *
      * ************************************************************ *
     Fpaheas    uf a e           k disk    usropn
     Fpaheas01  if   e           k disk    usropn rename (p1heas:p1heas01)
     Fpahea1    uf a e           k disk    usropn
     FPaheac    uf a e           k disk    usropn
     Fpaheac01  if   e           k disk    usropn rename (p1heac:p1heac01)
     FSet174    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpend_h.rpgle'

      * ------------------------------------------------------------ *
      * Setea error global
      * ------------------------------------------------------------ *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

      *--- Definicion de Procedimiento ----------------------------- *
     ?* ------------------------------------------------------------ *
     ?* SVPEND_inz(): Inicializa módulo.                             *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPEND_inz      B                   export
     D SVPEND_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(paheas);
         open paheas;
       endif;

       if not %open(pahea1);
         open pahea1;
       endif;

       if not %open(paheas01);
         open paheas01;
       endif;

       if not %open(paheac);
         open paheac;
       endif;

       if not %open(set174);
         open set174;
       endif;

       if not %open(paheac01);
         open paheac01;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPEND_inz      E

     ?* ------------------------------------------------------------ *
     ?* SVPEND_End(): Finaliza módulo.                               *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *
     P SVPEND_End      B                   export
     D SVPEND_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPEND_End      E

     ?* ------------------------------------------------------------ *
     ?* SVPEND_Error(): Retorna el último error del service program  *
     ?*                                                              *
     ?*     peEnbr   (output)  Número de error (opcional)            *
     ?*                                                              *
     ?* Retorna: Mensaje de error.                                   *
     ?* ------------------------------------------------------------ *

     P SVPEND_Error    B                   export
     D SVPEND_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPEND_Error    E

     ?* ------------------------------------------------------------ *
     ?* SetError(): Setea último error y mensaje.                    *
     ?*                                                              *
     ?*     peErrn   (input)   Número de error a setear.             *
     ?*     peErrm   (input)   Texto del mensaje.                    *
     ?*                                                              *
     ?* void                                                         *
     ?* ------------------------------------------------------------ *

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


     ?* ------------------------------------------------------------ *
     ?* SVPEND_chkEndoso: Validaciones Varias para endosar...        *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peSpol   ( input  ) SuperPoliza                          *
     ?*     peTiou   ( input  ) Tipo de endoso                       *
     ?*     peStou   ( input  ) Subtipo de Endoso Usuario            *
     ?*     peStos   ( input  ) Subtipo de Endoso Sistema            *
     ?*                                                              *
     ?* Retorna: *on = Aplicó / *off = No aplicó                     *
     ?* ------------------------------------------------------------ *
     P SVPEND_chkEndoso...
     P                 B                   export
     D SVPEND_chkEndoso...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const

     D   @@marp        s              1

      /free

       SVPEND_inz();

       if not SVPVAL_tipoDeOperacion( peTiou
                                    : peStou
                                    : peStos );
         //error...
         return *off;
       endif;

       if not SVPART_chkArticulo( peArcd );
         //Error...
         return *off;
       endif;

       if SVPART_chkBloqueo( peArcd );
         //Error...
         return *off;
       endif;

       if not SVPART_chkParametria ( peArcd );
         //Error...
       endif;

       if not SPVSPO_chkSpol( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol  );
         //Error...
         return *off;
       endif;

       if SPVSPO_chkSpolRenovada( peEmpr
                                : peSucu
                                : peArcd
                                : peSpol ) > 0;

         //Error...
         return *off;
       endif;

       if SPVSPO_chkAnulada( peEmpr
                           : peSucu
                           : peArcd
                           : peSpol );
         //Error...
         return *off;
       endif;

       if SPVSPO_chkSpolSuspendida( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol  );
         //Error...
         SetError( SVPEND_SPOLS
                 : 'Superpoliza Suspendida');
         return *off;
       endif;

       clear @@marp;
       @@marp = SPVSPO_getSuspEsp( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol );

       if @@marp = '3' or @@marp = '4';
         //Error...
         return *off;
       endif;

       if peTiou = 3 and pestos = 9;
         //Error...
         return *off;
       endif;

       return *on;
      /end-free

     P SVPEND_chkEndoso...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEND_pemitirEndoso: Actualiza si debe permitir endoso      *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Código Rama                          *
      *     peArse   ( input  ) Numero Polizas por Rama              *
      *     peOper   ( input  ) Numero Operacion                     *
      *     pePoco   ( input  ) Número de Componente                 *
      *     peMar1   ( input  ) Permitir endoso                      *
      *                                                              *
      * Retorna: *on = Aplicó / *off = No aplicó                     *
      * ------------------------------------------------------------ *
     P SVPEND_permitirEndoso...
     P                 B                   export
     D SVPEND_permitirEndoso...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoco                       4  0 const
     D   peMar1                       1    const

     D k1yeas          ds                  likerec( p1heas : *key )

      /free

       SVPEND_inz();

       k1yeas.asEmpr = peBase.peEmpr;
       k1yeas.asSucu = peBase.peSucu;
       k1yeas.asNivt = peBase.peNivt;
       k1yeas.asNivc = peBase.peNivc;
       k1yeas.asArcd = peArcd;
       k1yeas.asSpol = peSpol;
       k1yeas.asRama = peRama;
       k1yeas.asArse = peArse;
       k1yeas.asOper = peOper;
       k1yeas.asPoco = pePoco;
       chain %kds( k1yeas : 10 ) paheas;
       if %found ( paheas );
         AsMar1 = peMar1;
         update p1heas;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPEND_permitirEndoso...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEND_setPahea1: Grabar error de endoso                     *
      *                                                              *
      *     peDsA1   ( output ) Registro PAHEA1                      *
      *                                                              *
      * Retorna: *on = Grabo ok / *off = No grabo                    *
      * ------------------------------------------------------------ *
     P SVPEND_setPahea1...
     P                 B                   export
     D SVPEND_setPahea1...
     D                 pi
     D   peDsA1                            likeds( dsPahea1_t )
     D                                     options(*nopass:*omit) const

     D k1yea1          ds                  likerec( p1hea1 : *key )
     D DsOea1          ds                  likerec( p1hea1 : *output )

      /free

       SVPEND_inz();

       k1yea1.a1Empr = peDsA1.a1Empr;
       k1yea1.a1Sucu = peDsA1.a1Sucu;
       k1yea1.a1Nivt = peDsA1.a1Nivt;
       k1yea1.a1Nivc = peDsA1.a1Nivc;
       k1yea1.a1Arcd = peDsA1.a1Arcd;
       k1yea1.a1Spol = peDsA1.a1Spol;
       k1yea1.a1Rama = peDsA1.a1Rama;
       k1yea1.a1Arse = peDsA1.a1Arse;
       k1yea1.a1Oper = peDsA1.a1Oper;
       k1yea1.a1Poco = peDsA1.a1Poco;
       setgt  %kds( k1yea1 : 10 ) pahea1;
       readpe %kds( k1yea1 : 10 ) pahea1;

       eval-corr DsOea1 = peDsA1;
       DsOeA1.a1Secu = a1Secu + 1;

       write p1hea1 DsOea1;

       return;

      /end-free

     P SVPEND_setpahea1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEND_getPaheas: Retorna registros de endoso                *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Código Rama               (opcional) *
      *     peArse   ( input  ) Numero Polizas por Rama   (opcional) *
      *     peOper   ( input  ) Numero Operacion          (opcional) *
      *     pePoco   ( input  ) Número de Componente      (opcional) *
      *     peDsAs   ( output ) Ds de Paheas              (opcional) *
      *     peDsAsC  ( output ) Cantidad de Registro      (opcional) *
      *                                                              *
      * Retorna: *on = encontro / *off = no encontro                 *
      * ------------------------------------------------------------ *
     P SVPEND_getPaheas...
     P                 B                   export
     D SVPEND_getPaheas...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options(*nopass:*omit) const
     D   peArse                       2  0 options(*nopass:*omit) const
     D   peOper                       7  0 options(*nopass:*omit) const
     D   pePoco                       4  0 options(*nopass:*omit) const
     D   peDsAs                            likeds( dsPaheas_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsAsC                     10i 0 options(*nopass:*omit)

     D k1yeas          ds                  likerec( p1heas : *key )
     D DsIAs           ds                  likerec( p1heas :*input)
     D @@DsAs          ds                  likeds( dsPaheas_t ) dim( 9999 )
     D @@DsAsC         s             10i 0

      /free

       SVPEND_inz();

       clear @@DsAs;
       clear @@DsAsC;

       k1yeas.asEmpr = peBase.peEmpr;
       k1yeas.asSucu = peBase.peSucu;
       k1yeas.asNivt = peBase.peNivt;
       k1yeas.asNivc = peBase.peNivc;
       k1yeas.asArcd = peArcd;
       k1yeas.asSpol = peSpol;

       if %parms >= 5;
         select;
           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) <> *null;

             k1yeas.asRama = peRama;
             k1yeas.asArse = peArse;
             k1yeas.asOper = peOper;
             k1yeas.asPoco = pePoco;

             setll %kds( k1yeas : 10 ) paheas;
             if not %equal( paheas );
               return *off;
             endif;
             reade(n) %kds( k1yeas : 10 ) paheas DsIas;
             dow not %eof( paheas );
               @@DsAsC += 1;
               eval-corr @@DsAs( @@DsAsC ) = DsIas;
               reade(n) %kds( k1yeas : 10 ) paheas;
             enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) <> *null and
                %addr( pePoco ) =  *null;

             k1yeas.asRama = peRama;
             k1yeas.asArse = peArse;
             k1yeas.asOper = peOper;

             setll %kds( k1yeas : 9 ) paheas;
             if not %equal( paheas );
               return *off;
             endif;
             reade(n) %kds( k1yeas : 9 ) paheas DsIas;
             dow not %eof( paheas );
               @@DsAsC += 1;
               eval-corr @@DsAs( @@DsAsC ) = DsIas;
               reade(n) %kds( k1yeas : 9 ) paheas;
             enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) <> *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

             k1yeas.asRama = peRama;
             k1yeas.asArse = peArse;

             setll %kds( k1yeas : 8 ) paheas;
             if not %equal( paheas );
               return *off;
             endif;
             reade(n) %kds( k1yeas : 8 ) paheas DsIas;
             dow not %eof( paheas );
               @@DsAsC += 1;
               eval-corr @@DsAs( @@DsAsC ) = DsIas;
               reade(n) %kds( k1yeas : 8 ) paheas;
             enddo;

           when %addr( peRama ) <> *null and
                %addr( peArse ) =  *null and
                %addr( peOper ) =  *null and
                %addr( pePoco ) =  *null;

             k1yeas.asRama = peRama;

             setll %kds( k1yeas : 7 ) paheas;
             if not %equal( paheas );
               return *off;
             endif;
             reade(n) %kds( k1yeas : 7 ) paheas DsIas;
             dow not %eof( paheas );
               @@DsAsC += 1;
               eval-corr @@DsAs( @@DsAsC ) = DsIas;
               reade(n) %kds( k1yeas : 7 ) paheas;
             enddo;

           other;

             setll %kds( k1yeas : 6 ) paheas;
             if not %equal( paheas );
               return *off;
             endif;
             reade(n) %kds( k1yeas : 6 ) paheas DsIas;
             dow not %eof( paheas );
               @@DsAsC += 1;
               eval-corr @@DsAs( @@DsAsC ) = DsIas;
               reade(n) %kds( k1yeas : 6 ) paheas;
             enddo;

         endsl;
       else;
         setll %kds( k1yeas : 6 ) paheas;
         if not %equal( paheas );
           return *off;
         endif;
         reade(n) %kds( k1yeas : 6 ) paheas DsIas;
         dow not %eof( paheas );
           @@DsAsC += 1;
           eval-corr @@DsAs( @@DsAsC ) = DsIas;
           reade(n) %kds( k1yeas : 6 ) paheas;
         enddo;
       endif;

       if %parms >= 6  and %addr( peDsAs ) <> *null;
           eval-corr peDsAs = @@DsAs;
       endif;

       if %parms >= 6  and %addr( peDsAsC ) <> *null;
           peDsAsC = @@DsAsC;
       endif;

       return *on;

      /end-free

     P SVPEND_getPaheas...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPEND_updPaheas(): Actualiza datos en el archivo Paheas          *
      *                                                                   *
      *          peDsAs   ( input  ) Estrutura de Paheas                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPEND_updPaheas...
     P                 B                   export
     D SVPEND_updPaheas...
     D                 pi              n
     D   peDsAs                            likeds( dsPaheas_t ) const

     D  k1yeas         ds                  likerec( p1heas : *key    )
     D  dsOsAs         ds                  likerec( p1heas : *output )

      /free

       SVPEND_inz();

       k1yeas.asEmpr = peDsAs.asEmpr;
       k1yeas.asSucu = peDsAs.asSucu;
       k1yeas.asNivt = peDsAs.asNivt;
       k1yeas.asNivc = peDsAs.asNivc;
       k1yeas.asArcd = peDsAs.asArcd;
       k1yeas.asSpol = peDsAs.asSpol;
       k1yeas.asRama = peDsAs.asRama;
       k1yeas.asArse = peDsAs.asArse;
       k1yeas.asOper = peDsAs.asOper;
       k1yeas.asPoco = peDsAs.asPoco;
       chain %kds( k1yeas : 10 ) Paheas;
       if %found( Paheas );
         eval-corr dsOsAs = peDsAs;
         update p1heas dsOsAs;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPEND_updPaheas...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEND_getPaheac(): Retorna datos de Endosos As/Ca.-         *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNivt   ( input  ) Nro. Intermediario                   *
      *     peNivc   ( input  ) Cod. Intermediario                   *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Rama                      (opcional) *
      *     peArse   ( input  ) Cantidad de polizas       (opcional) *
      *     peOper   ( input  ) Codigo de Operacion       (opcional) *
      *     pePoco   ( input  ) Nro. de Componente        (opcional) *
      *     peDsAc   ( output ) Est. de Componente        (opcional) *
      *     peDsAcC  ( output ) Cant. de Componentes      (opcional) *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPEND_getPaheac...
     P                 B                   export
     D SVPEND_getPaheac...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const
     D   peDsAc                            likeds ( DsPaheac_t ) dim(9999)
     D                                     options(*nopass:*omit)
     D   peDsAcC                     10i 0 options(*nopass:*omit)

     D   k1yeac        ds                  likerec( p1heac : *key   )
     D   @@DsIAc       ds                  likerec( p1heac : *input )
     D   @@DsAc        ds                  likeds ( DsPaheac_t ) dim(9999)
     D   @@DsAcC       s             10i 0

      /free

       SVPEND_inz();

       clear @@DsAc;
       clear @@DsAcC;

       k1yeac.acEmpr = peEmpr;
       k1yeac.acSucu = peSucu;
       k1yeac.acNivt = peNivt;
       k1yeac.acNivc = peNivc;
       k1yeac.acArcd = peArcd;
       k1yeac.acSpol = peSpol;
       k1yeac.acRama = peRama;
       k1yeac.acArse = peArse;
       k1yeac.acOper = peOper;
       k1yeac.acPoco = pePoco;
       setll %kds( k1yeac : 10 ) Paheac;
       if not %equal( Paheac );
          return *off;
       endif;

       reade(n) %kds( k1yeac : 10 ) Paheac @@DsIAc;
       dow not %eof( Paheac );
           @@DsAcC += 1;
           eval-corr @@DsAc ( @@DsAcC ) = @@DsIAc;
           reade(n) %kds( k1yeac : 10 ) Paheac @@DsIAc;
       enddo;


       if %addr( peDsAc ) <> *null;
         eval-corr peDsAc = @@DsAc;
       endif;

       if %addr( peDsAcC ) <> *null;
         peDsAcC = @@DsAcC;
       endif;

       return *on;

      /end-free

     P SVPEND_getPaheac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEND_chkPaheac(): Valida si existe datos de Endosos de     *
      *                     Ac/Ca.-                                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peNivt   ( input  ) Nro. Intermediario                   *
      *     peNivc   ( input  ) Cod. Intermediario                   *
      *     peArcd   ( input  ) Articulo                             *
      *     peSpol   ( input  ) SuperPoliza                          *
      *     peRama   ( input  ) Rama                      (opcional) *
      *     peArse   ( input  ) Cantidad de polizas       (opcional) *
      *     peOper   ( input  ) Codigo de Operacion       (opcional) *
      *     pePoco   ( input  ) Nro. de Componente        (opcional) *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPEND_chkPaheac...
     P                 B                   export
     D SVPEND_chkPaheac...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 options( *nopass : *omit ) const
     D   peArse                       2  0 options( *nopass : *omit ) const
     D   peOper                       7  0 options( *nopass : *omit ) const
     D   pePoco                       4  0 options( *nopass : *omit ) const

     D   k1yeac        ds                  likerec( p1heac : *key   )

      /free

       SVPEND_inz();

       k1yeac.acEmpr = peEmpr;
       k1yeac.acSucu = peSucu;
       k1yeac.acNivt = peNivt;
       k1yeac.acNivc = peNivc;
       k1yeac.acArcd = peArcd;
       k1yeac.acSpol = peSpol;
       k1yeac.acRama = peRama;
       k1yeac.acArse = peArse;
       k1yeac.acOper = peOper;
       k1yeac.acPoco = pePoco;
       setll %kds( k1yeac : 10 ) Paheac;

       return %equal();

      /end-free

     P SVPEND_chkPaheac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEND_setPaheac: Graba datos en el archivo Paheac           *
      *                                                              *
      *     peDsAc   ( input  ) Estructura DsAc                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPEND_setPaheac...
     P                 B                   export
     D SVPEND_setPaheac...
     D                 pi              n
     D   peDsAc                            likeds( dsPaheac_t ) const

     D  k1yeac         ds                  likerec( p1heac : *key    )
     D  dsOsAc         ds                  likerec( p1heac : *output )

      /free

       SVPEND_inz();

       if SVPEND_chkPaheac( peDsAc.acEmpr
                          : peDsAc.acSucu
                          : peDsAc.acNivt
                          : peDsAc.acNivc
                          : peDsAc.acArcd
                          : peDsAc.acSpol
                          : peDsAc.acRama
                          : peDsAc.acArse
                          : peDsAc.acOper
                          : peDsAc.acPoco);

         return *off;
       endif;

       eval-corr DsOsAc = peDsAc;
       monitor;
         write p1heac DsOsAc;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P SVPEND_setPaheac...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPEND_updPaheac(): Actualiza datos en el archivo Paheac          *
      *                                                                   *
      *          peDsAc   ( input  ) Estrutura de Paheac                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPEND_updPaheac...
     P                 B                   export
     D SVPEND_updPaheac...
     D                 pi              n
     D   peDsAc                            likeds( dsPaheac_t ) const

     D  k1yeac         ds                  likerec( p1heac : *key    )
     D  dsOsAc         ds                  likerec( p1heac : *output )

      /free

       SVPEND_inz();

       k1yeac.acEmpr = peDsAc.acEmpr;
       k1yeac.acSucu = peDsAc.acSucu;
       k1yeac.acNivt = peDsAc.acNivt;
       k1yeac.acNivc = peDsAc.acNivc;
       k1yeac.acArcd = peDsAc.acArcd;
       k1yeac.acSpol = peDsAc.acSpol;
       k1yeac.acRama = peDsAc.acRama;
       k1yeac.acArse = peDsAc.acArse;
       k1yeac.acOper = peDsAc.acOper;
       k1yeac.acPoco = peDsAc.acPoco;
       chain %kds( k1yeac : 10 ) Paheac;
       if %found( Paheac );
         eval-corr dsOsAc = peDsAc;
         update p1heac dsOsAc;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPEND_updPaheac...
     P                 E

      * ----------------------------------------------------------------- *
      * SVPEND_dltPaheac(): Elimina datos en el archivo Paheac            *
      *                                                                   *
      *          peDsAc   ( input  ) Estrutura de Paheac                  *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPEND_dltPaheac...
     P                 B                   export
     D SVPEND_dltPaheac...
     D                 pi              n
     D   peDsAc                            likeds( dsPaheac_t ) const

     D  k1yeac         ds                  likerec( p1heac : *key    )

      /free

       SVPEND_inz();

       k1yeac.acEmpr = peDsAc.acEmpr;
       k1yeac.acSucu = peDsAc.acSucu;
       k1yeac.acNivt = peDsAc.acNivt;
       k1yeac.acNivc = peDsAc.acNivc;
       k1yeac.acArcd = peDsAc.acArcd;
       k1yeac.acSpol = peDsAc.acSpol;
       k1yeac.acRama = peDsAc.acRama;
       k1yeac.acArse = peDsAc.acArse;
       k1yeac.acOper = peDsAc.acOper;
       k1yeac.acPoco = peDsAc.acPoco;
       chain %kds( k1yeac : 10 ) Paheac;
       if %found( Paheac );
         delete p1heac;
       endif;

       return *on;

      /end-free

     P SVPEND_dltPaheac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEND_getSet174(): Retorna Porcentajes para Aumento de      *
      *                     Endosos de Ascensores/Calderas           *
      *                                                              *
      *     peFech   ( input  ) Fecha                                *
      *     pePras   ( output ) % de Aumento Ascensores   (opcional) *
      *     pePrca   ( output ) % de Aumento Calderas     (opcional) *
      *                                                              *
      * Retorna: *on = Si encontro / *off = si no encontro           *
      * ------------------------------------------------------------ *
     P SVPEND_getSet174...
     P                 B                   export
     D SVPEND_getSet174...
     D                 pi              n
     D   peFech                       8  0 const
     D   pePras                       5  2 options( *nopass : *omit )
     D   pePrca                       5  2 options( *nopass : *omit )

      /free

       SVPEND_inz();

       setll *loval set174;
       read set174;
       dow not %eof( set174 );

         if peFech >= t@fini;
            pePras = t@pras;
            pePrca = t@prca;
         endif;

       read set174;
       enddo;

       if pePras = *zeros and pePrca = *zeros;
          return *off;
       endif;

       return *on;

      /end-free

     P SVPEND_getSet174...
     P                 E

      * ------------------------------------------------------------ *
      * SVPEND_setPaheacXInt(): Graba datos en Paheac                *
      *                         por Intermediario.-                  *
      *                                                              *
      *     peDsAc   ( input  ) Estructura DsAc                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPEND_setPaheacXInt...
     P                 B                   export
     D SVPEND_setPaheacXInt...
     D                 pi              n
     D   peDsAc                            likeds( dsPaheac_t ) const

     D  k1yeac01       ds                  likerec( p1heac01 : *key  )
     D  dsOsAc         ds                  likerec( p1heac : *output )

      /free

       SVPEND_inz();

       k1yeac01.acempr = peDsAc.acempr;
       k1yeac01.acsucu = peDsAc.acsucu;
       k1yeac01.acnivt = peDsAc.acnivt;
       k1yeac01.acnivc = peDsAc.acnivc;
       k1yeac01.acarcd = peDsAc.acarcd;
       k1yeac01.acspol = peDsAc.acspol;
       k1yeac01.acrama = peDsAc.acrama;
       k1yeac01.acarse = peDsAc.acarse;
       k1yeac01.acoper = peDsAc.acoper;
       k1yeac01.acpoco = peDsAc.acpoco;
       chain %kds( k1yeac01 : 10 ) Paheac01;
       if %found( Paheac01 );
          return *off;
       endif;

       eval-corr DsOsAc = peDsAc;
       monitor;
         write p1heac DsOsAc;
       on-error;
         return *off;
       endmon;

       return *on;
      /end-free

     P SVPEND_setPaheacXInt...
     P                 E



