     H nomain
     H datedit(*DMY/)
     H alwnull(*usrctl)
      * ************************************************************ *
      * SVPPDS: Programa de Servicio.                                *
      *         Pre-denuncia de siniestro                            *
      * ------------------------------------------------------------ *
      * Segovia Jennifer                     19-May-2017             *
      * ------------------------------------------------------------ *
      * ************************************************************ *
      * Modificaciones:                                              *
      *   JSN 15/01/2019 - Se agrega procedimiento: _setTipoDeVoucher*
      *                                                              *
      * ************************************************************ *
     Fpds000    uf a e           k disk    usropn
     Fpds00006  if   e           k disk    usropn  rename(p1ds00:p1ds006)
     Fpds001    uf a e           k disk    usropn
     Fpahed004  if   e           k disk    usropn
     Fpahpol    if   e           k disk    usropn
     Fset401    if   e           k disk    usropn
     Fset456    if   e           k disk    usropn  prefix(s456_)
     Fpahet910  if   e           k disk    usropn
     Fset915    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svppds_h.rpgle'

     *- Area Local del Sistema. ------------------------ *
     D                sds
     D  ususer               254    263
     D  ususr2               358    367
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D cleanUp         pr             1N
     D  peMsid                        7a   const

     D SPT902          pr                  ExtPgm('SPT902')
     D   peTnum                       1a   const
     D   peNres                       7  0

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- PR Externos --------------------------------------------- *

      *--- Definicion de Procedimiento ----------------------------- *

      * ------------------------------------------------------------ *
      * SVPPDS_SetPreDen(): Graba PDS000                             *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     pePate   (input)   Patente                               *
      *     peFocu   (input)   Fecha Ocurrencia                      *
      *     peHocu   (input)   Hora Ocurrencia                       *
      *     peCaus   (input)   Causa                                 *
      *     pePpdf   (input)   PathPDF                               *
      *                                                              *
      * Retorna: Nro.Pre-Denuncia / -1 Error                         *
      * ------------------------------------------------------------ *

     P SVPPDS_SetPreDen...
     P                 B                   export
     D SVPPDS_SetPreDen...
     D                 pi             7  0
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   peCaus                       4  0 const
     D   peFpdf                    1028    const

     D k1yPds0         ds                  likerec( p1ds00   : *key )
     D k1yed04         ds                  likerec( p1hed004 : *key )
     D k1yepol         ds                  likerec( p1hpol   : *key )
     D k1yt401         ds                  likerec( s1t401   : *key )
     D k1yt456         ds                  likerec( s1t456   : *key )
     D k1yt910         ds                  likerec( p1het9   : *key )

     D @Npds           s              7  0
     D @@Aseg          s              7  0
     D @@Hoy           s              8  0
     D @@Fch           s               d
     D existe          s               n

      /free

       SVPPDS_inz();

       //* Valida parametros

       k1yed04.d0Empr = peBase.peEmpr;
       k1yed04.d0Sucu = peBase.peSucu;
       k1yed04.d0Rama = peRama;
       k1yed04.d0Poli = pePoli;
       chain %kds( k1yed04 : 4 ) pahed004;
       if not %found ( pahed004 );
          SetError( SVPPDS_RAMPOL
                  : 'Rama/Póliza Inexistente' );
          return -1;
       else;

          @@Aseg = SPVSPO_getAsen ( d0Empr
                                  : d0Sucu
                                  : d0Arcd
                                  : d0Spol        );

       endif;

       k1yepol.poEmpr = peBase.peEmpr;
       k1yepol.poSucu = peBase.peSucu;
       k1yepol.poNivt = peBase.peNivt;
       k1yepol.poNivc = peBase.peNivc;
       k1yepol.poRama = peRama;
       k1yepol.poPoli = pePoli;
       chain %kds( k1yepol : 6 ) pahpol;
       if not %found ( pahpol );
          SetError( SVPPDS_RAMPOL
                  : 'Rama/Póliza Inexistente' );
          return -1;
       endif;

       k1yt401.t@Rama = peRama;
       k1yt401.t@Cauc = peCaus;
       chain %kds( k1yt401 : 2 ) set401;
       if not %found ( set401 );
          SetError( SVPPDS_CAUSA
                  : 'Códido de Causa Inexistente' );
          return -1;
       endif;

       k1yt456.s456_t@Empr = peBase.peEmpr;
       k1yt456.s456_t@Sucu = peBase.peSucu;
       chain %kds( k1yt456 : 2 ) set456;

         @@Hoy = (s456_t@Fema * 10000)
               + (s456_t@Femm *   100)
               +  s456_t@Femd;

         if peFocu > @@Hoy;
           SetError( SVPPDS_FOCU
                   : 'Fecha de Ocurrencia Mayor a Fecha Actual' );
           return -1;
         else;
           monitor;
             @@Fch = %date(peFocu:*iso);
           on-error;
             cleanUp( 'RNX0112' );
           endmon;
         endif;

       k1yt910.t9Empr = peBase.peEmpr;
       k1yt910.t9Sucu = peBase.peSucu;
       k1yt910.t9Nmat = pePate;
       setll %kds( k1yt910 : 3 ) pahet910;
       reade %kds( k1yt910 : 3 ) pahet910;
       dow not %eof( pahet910 );

         if t9Rama = peRama and t9Poli = pePoli;
           existe = *on;
           leave;
         endif;

         reade %kds( k1yt910 : 3 ) pahet910;

       enddo;

       if not existe;
         SetError( SVPPDS_PATE
                 : 'Patente Inexistente' );
         return -1;
       endif;

       @npds = SVPPDS_getNroPreDenuncia( peBase.peEmpr: peBase.peSucu );

       p0Empr = peBase.peEmpr;
       p0Sucu = peBase.peSucu;
       p0Nivt = peBase.peNivt;
       p0Nivc = peBase.peNivc;
       p0Npds = @Npds;
       p0Nrdf = @@Aseg;
       p0Nomb = SVPASE_getNombre( @@Aseg );
       p0Rama = peRama;
       p0Poli = pePoli;
       p0Pate = pePate;
       p0Focu = peFocu;
       p0Hocu = peHocu;
       p0Caus = peCaus;
       p0Sini = *Zeros;
       p0Fpdf = peFpdf;
       p0Mar1 = '0';
       p0Mar2 = '0';
       p0Mar3 = '0';
       p0Mar4 = '0';
       p0Mar5 = '0';
       p0User = ususr2;
       p0Date = (*year * 10000)
              + (*month *  100)
              +  *day;
       p0Time = %dec(%time():*iso);

       write p1ds00;

       return @Npds;

      /end-free

     P SVPPDS_SetPreDen...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPDS_updPreDen(): Actualiza PDS000                         *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNpds   (input)   Nro. de Pre-Denuncia de Siniestro     *
      *     peFocu   (input)   Fecha de ocurrencia                   *
      *     peHocu   (input)   Hora de ocurrencia                    *
      *     pePate   (input)   Patente                               *
      *     peSini   (input)   Siniestro                             *
      *     peFpdf   (input)   PDF                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPPDS_updPreDen...
     P                 B                   export
     D SVPPDS_updPreDen...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   pePate                      25    const
     D   peSini                       7  0 options(*nopass:*omit)
     D   peFpdf                    1028    options(*nopass:*omit)

     D k1yPds0         ds                  likerec( p1ds00 : *key )

      /free

       SVPPDS_inz();

       if not SVPPDS_chkPredenuSin( peBase.peEmpr : peBase.peSucu :
                                    peBase.peNivt : peBase.peNivc :
                                    peNpds );

         return *off;

       endif;

       k1yPds0.p0Empr = peBase.peEmpr;
       k1yPds0.p0Sucu = peBase.peSucu;
       k1yPds0.p0Nivt = peBase.peNivt;
       k1yPds0.p0Nivc = peBase.peNivc;
       k1yPds0.p0Npds = peNpds;
       chain %kds ( k1yPds0: 5 ) pds000;

         p0Focu = peFocu;
         p0Hocu = peHocu;
         p0Pate = pePate;

         if %parms >= 6 and %addr(peSini) <> *Null;
           p0Sini = peSini;
         endif;

         if %parms >= 7 and %addr(peFpdf) <> *Null;
           p0Fpdf = peFpdf;
         endif;

         p1Date = (*year * 10000)
                + (*month *  100)
                +  *day;
         p1Time = %dec(%time():*iso);

         update p1ds00;

       return *On;

      /end-free

     P SVPPDS_updPreDen...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPDS_chkPredenuSin(): Valida si existe pre denuncia de     *
      *                         siniestros                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivc   (input)   Código de Intermediario               *
      *     peNpds   (input)   Nro. Pre-Denuncia de Siniestro        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPPDS_chkPredenuSin...
     P                 B                   export
     D SVPPDS_chkPredenuSin...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNpds                       7  0 const

     D k1yPds0         ds                  likerec( p1ds00 : *key )

      /free

       SVPPDS_inz();

       k1yPds0.p0Empr = peEmpr;
       k1yPds0.p0Sucu = peSucu;
       k1yPds0.p0Nivt = peNivt;
       k1yPds0.p0Nivc = peNivc;
       k1yPds0.p0Npds = peNpds;
       setll %kds( k1yPds0 : 5 ) pds000;
       if not %equal( pds000 );
         SetError( SVPPDS_PDSNE
                 : 'Pre-Denuncia de Siniestro Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPPDS_chkPredenuSin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPDS_setFotoPDS(): Graba PDS001                            *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNpds   (input)   Nro. Pre-Denuncia de Siniestro        *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     pePate   (input)   Patente                               *
      *     peFocu   (input)   Fecha Ocurrencia                      *
      *     peHocu   (input)   Hora Ocurrencia                       *
      *     pePdff   (input)   PathPDF(Fotos)                        *
      *     pePdffc  (input)   Cantidad patchPDF                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPPDS_setFotoPDS...
     P                 B                   export
     D SVPPDS_setFotoPDS...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   pePdff                            likeds(pds001_t) dim(10)
     D   pePdffC                     10i 0

     D k1yPds1         ds                  likerec( p1ds01 : *key )

     D i               s             10i 0

      /free

       SVPPDS_inz();

       if not SVPPDS_chkPredenuSin( peBase.peEmpr : peBase.peSucu :
                                    peBase.peNivt : peBase.peNivc :
                                    peNpds );

         return *off;

       endif;

       if SVPPDS_chkFotoPDS( peBase.peEmpr : peBase.peSucu :
                             peBase.peNivt : peBase.peNivc :
                             peNpds );

         SVPPDS_dltFotoPDS( peBase : peNpds );

       endif;

       p1Empr = peBase.peEmpr;
       p1Sucu = peBase.peSucu;
       p1Nivt = peBase.peNivt;
       p1Nivc = peBase.peNivc;
       p1Npds = peNpds;
       p1Rama = peRama;
       p1Poli = pePoli;
       p1Pate = pePate;
       p1Focu = peFocu;
       p1Hocu = peHocu;
       p1Mar1 = '0';
       p1Mar2 = '0';
       p1Mar3 = '0';
       p1Mar4 = '0';
       p1Mar5 = '0';
       p1User = ususr2;
       p1Date = (*year * 10000)
              + (*month *  100)
              +  *day;
       p1Time = %dec(%time():*iso);

       for i = 1 to 10;
         if pePdff(i).fpdf <> *blanks;
            p1Secu = i;
            p1Fpdf = pePdff(i).Fpdf;
            write p1ds01;
         endif;
       endfor;

       return *On;

      /end-free

     P SVPPDS_setFotoPDS...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPDS_chkFotoPDS(): Valida si existe fotos de Pre-Denuncia  *
      *                      de Siniestros                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivc   (input)   Código de Intermediario               *
      *     peNpds   (input)   Nro. Pre-Denuncia de Siniestro        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPPDS_chkFotoPDS...
     P                 B                   export
     D SVPPDS_chkFotoPDS...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peNpds                       7  0 const

     D k1yPds1         ds                  likerec( p1ds01 : *key )

      /free

       SVPPDS_inz();

       k1yPds1.p1Empr = peEmpr;
       k1yPds1.p1Sucu = peSucu;
       k1yPds1.p1Nivt = peNivt;
       k1yPds1.p1Nivc = peNivc;
       k1yPds1.p1Npds = peNpds;
       setll %kds( k1yPds1 : 5 ) pds001;
       if not %equal( pds001 );
         SetError( SVPPDS_FOTO
                 : 'Fotos de Pre-Denuncia de Siniestro Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPPDS_chkFotoPDS...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPDS_dltFotoPDS(): Elimina PDS001                          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNpds   (input)   Nro. de Pre-Denuncia de Siniestro     *
      *                                                              *
      * ------------------------------------------------------------ *

     P SVPPDS_dltFotoPDS...
     P                 B                   export
     D SVPPDS_dltFotoPDS...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const

     D k1yPds1         ds                  likerec( p1ds01 : *key )

      /free

       SVPPDS_inz();


         k1yPds1.p1Empr = peBase.peEmpr;
         k1yPds1.p1Sucu = peBase.peSucu;
         k1yPds1.p1Nivt = peBase.peNivt;
         k1yPds1.p1Nivc = peBase.peNivc;
         k1yPds1.p1Npds = peNpds;
         setll %kds ( k1yPds1 : 5 ) pds001;
         reade %kds ( k1yPds1 : 5 ) pds001;
         dow not %eof ( pds001);

           delete p1ds01;

           reade %kds ( k1yPds1 : 5 ) pds001;

         enddo;


      /end-free

     P SVPPDS_dltFotoPDS...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPDS_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPPDS_inz      B                   export
     D SVPPDS_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(pds000);
         open pds000;
       endif;

       if not %open(pds001);
         open pds001;
       endif;

       if not %open(pahed004);
         open pahed004;
       endif;

       if not %open(pahpol);
         open pahpol;
       endif;

       if not %open(set401);
         open set401;
       endif;

       if not %open(set456);
         open set456;
       endif;

       if not %open(pahet910);
         open pahet910;
       endif;

       if not %open(set915);
         open set915;
       endif;

       if not %open(pds00006);
         open pds00006;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPPDS_inz      E

      * ------------------------------------------------------------ *
      * SVPPDS_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPPDS_End      B                   export
     D SVPPDS_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPPDS_End      E

      * ------------------------------------------------------------ *
      * SVPPDS_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPPDS_Error    B                   export
     D SVPPDS_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPPDS_Error    E

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
      * SVPPDS_SetPreDenWeb(): Recibe Predenuncia Web                *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     pePate   (input)   Patente                               *
      *     peFocu   (input)   Fecha Ocurrencia                      *
      *     peHocu   (input)   Hora Ocurrencia                       *
      *     peCaus   (input)   Causa                                 *
      *     pePpdf   (input)   PathPDF                               *
      *     pePdff   (input)   PathPDF                               *
      *     pePdffc  (input)                                         *
      *                                                              *
      * Retorna: 0 OK, -1 Error.                                     *
      * ------------------------------------------------------------ *
     P SVPPDS_SetPreDenWeb...
     P                 B                   Export
     D SVPPDS_SetPreDenWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   peCaus                       4  0 const
     D   peFpdf                    1028a   const
     D   pePdff                            likeds(pds001_t) dim(10)
     D   pePdffC                     10i 0
     D   peNpds                       7  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D rc              s              7  0
     D r2              s              1n
     D @repl           s          65535a

      /free

       SVPPDS_inz();

       if SVPWS_chkParmBase( peBase : peMsgs ) = *OFF;
          peErro = -1;
          return;
       endif;

       rc = SVPPDS_setPreDen( peBase
                            : peRama
                            : pePoli
                            : pePate
                            : peFocu
                            : peHocu
                            : peCaus
                            : peFpdf  );

       if rc = -1;
          errm = SVPPDS_error(errn);
          select;
           when errn = SVPPDS_RAMPOL;
                %subst(@repl:01:2) = %editc(peRama:'X');
                %subst(@repl:03:7) = %editc(pePoli:'X');
                %subst(@repl:10:1) = %editc(peBase.peNivt:'X');
                %subst(@repl:11:5) = %editc(peBase.peNivc:'X');
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'POL0001'
                             : peMsgs
                             : %trim(@repl)
                             : %len(%trim(@repl)) );
           when errn = SVPPDS_CAUSA;
                %subst(@repl:1:4) = %editc(peCaus:'X');
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN0002'
                             : peMsgs
                             : %trim(@repl)
                             : %len(%trim(@repl)) );
           when errn = SVPPDS_FOCU;
                %subst(@repl:1:10) = %editc(peFocu:'Y');
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN0003'
                             : peMsgs
                             : %trim(@repl)
                             : %len(%trim(@repl)) );
           when errn = SVPPDS_PATE;
                %subst(@repl:1:25) = %trim(pePate);
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN0004'
                             : peMsgs
                             : %trim(@repl)
                             : %len(%trim(@repl)) );
           endsl;
          peErro = -1;
          return;
       endif;

       peNpds = rc;

       r2 = SVPPDS_setFotoPds( peBase
                             : rc
                             : peRama
                             : pePoli
                             : pePate
                             : peFocu
                             : peHocu
                             : pePdff
                             : pePdffC );

       if not r2;
          errm = SVPPDS_error(errn);
          if errn = SVPPDS_PDSNE;
             %subst(@repl:1:7) = %editc(rc:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'SIN0004'
                          : peMsgs
                          : %trim(@repl)
                          : %len(%trim(@repl)) );
          endif;
          peErro = -1;
          return;
       endif;

      /end-free

     P SVPPDS_SetPreDenWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPDS_getNroPreDenuncia(): Obtener número de predenuncia    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *                                                              *
      * Retorna: Nro.Pre-Denuncia / -1 Error                         *
      * ------------------------------------------------------------ *
     P SVPPDS_getNroPreDenuncia...
     P                 B                   Export
     D SVPPDS_getNroPreDenuncia...
     D                 pi             7  0
     D  peEmpr                        1a   const
     D  peSucu                        2a   const

     D k1t915          ds                  likerec(s1t915:*key)

      /free

       SVPPDS_inz();

       k1t915.t@empr = peEmpr;
       k1t915.t@sucu = peSucu;
       k1t915.t@tnum = 'PS';
       chain %kds(k1t915:3) set915;
       if %found;
          t@nres += 1;
          update s1t915;
        else;
          t@empr = peEmpr;
          t@sucu = peSucu;
          t@tnum = 'PS';
          t@dnum = 'PREDENUNCIAS SINIESTROS WEB';
          t@nres = 1;
          t@mp01 = '0';
          t@mp02 = '0';
          t@mp03 = '0';
          t@mp04 = '0';
          t@mp05 = '0';
          t@user = ususr2;
          t@date = %dec(%date():*iso);
          t@time = %dec(%time():*iso);
          write s1t915;
       endif;

       return t@nres;

      /end-free

     P SVPPDS_getNroPreDenuncia...
     P                 E

      * ------------------------------------------------------------ *
      * SVPPDS_SetPreDen2(): Graba PDS000                            *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNpds   (input)   Número de Predenuncia                 *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Poliza                                *
      *     pePate   (input)   Patente                               *
      *     peFocu   (input)   Fecha Ocurrencia                      *
      *     peHocu   (input)   Hora Ocurrencia                       *
      *     peCaus   (input)   Causa                                 *
      *     peErro   (input)   Error                                 *
      *     peMsgs   (input)   Mensajes                              *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P SVPPDS_SetPreDen2...
     P                 b                   export
     D SVPPDS_SetPreDen2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   peCaus                       4  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1hpol          ds                  likerec(p1hpol:*key)
     D k1het9          ds                  likerec(p1het9:*key)
     D k1t401          ds                  likerec(s1t401:*key)
     D k1t456          ds                  likerec(s1t456:*key)
     D k1s000          ds                  likerec(p1ds00:*key)

     D @@aseg          s              7  0
     D @@hoy           s              8  0
     D @@Fch           s             10d
     D @repl           s          65535a
     D existe          s              1n

      /free

       SVPPDS_inz();

       if SVPWS_chkParmBase( peBase : peMsgs ) = *OFF;
          peErro = -1;
          return;
       endif;

       if SVPPDS_chkPredenuncia( peBase.peEmpr
                               : peBase.peSucu
                               : peNpds
                               : *omit
                               : *omit             );
          %subst(@repl:1:7)  = %editc( peNpds :'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0008'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );

         peErro = -1;
         return;
       endif;

       k1hed0.d0Empr = peBase.peEmpr;
       k1hed0.d0Sucu = peBase.peSucu;
       k1hed0.d0Rama = peRama;
       k1hed0.d0Poli = pePoli;
       chain %kds(k1hed0:4) pahed004;
       if not %found(pahed004);
          %subst(@repl:01:2) = %editc(peRama:'X');
          %subst(@repl:03:7) = %editc(pePoli:'X');
          %subst(@repl:10:1) = %editc(peBase.peNivt:'X');
          %subst(@repl:11:5) = %editc(peBase.peNivc:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );
          peErro = -1;
          return;
        else;
          @@Aseg = SPVSPO_getAsen( d0Empr
                                 : d0Sucu
                                 : d0Arcd
                                 : d0Spol );
       endif;

       k1hpol.poEmpr = peBase.peEmpr;
       k1hpol.poSucu = peBase.peSucu;
       k1hpol.poNivt = peBase.peNivt;
       k1hpol.poNivc = peBase.peNivc;
       k1hpol.poRama = peRama;
       k1hpol.poPoli = pePoli;
       setll %kds(k1hpol:6) pahpol;
       if not %equal(pahpol);
          %subst(@repl:01:2) = %editc(peRama:'X');
          %subst(@repl:03:7) = %editc(pePoli:'X');
          %subst(@repl:10:1) = %editc(peBase.peNivt:'X');
          %subst(@repl:11:5) = %editc(peBase.peNivc:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );
          peErro = -1;
          return;
       endif;

       k1t401.t@rama = peRama;
       k1t401.t@cauc = peCaus;
       setll %kds(k1t401:2) set401;
       if not %equal(set401);
          %subst(@repl:1:4) = %editc(peCaus:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0002'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );
          peErro = -1;
          return;
       endif;

       k1t456.s456_t@Empr = peBase.peEmpr;
       k1t456.s456_t@Sucu = peBase.peSucu;
       chain %kds(k1t456:2) set456;

       @@Hoy = (s456_t@Fema * 10000)
             + (s456_t@Femm *   100)
             +  s456_t@Femd;

       if peFocu > @@Hoy;
          %subst(@repl:1:10) = %editc(peFocu:'Y');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0003'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );
          peErro = -1;
          return;
        else;
         monitor;
           @@Fch = %date(peFocu:*iso);
         on-error;
           cleanUp( 'RNX0112' );
         endmon;
       endif;

       k1het9.t9Empr = peBase.peEmpr;
       k1het9.t9Sucu = peBase.peSucu;
       k1het9.t9Nmat = pePate;
       setll %kds(k1het9:3) pahet910;
       reade %kds(k1het9:3) pahet910;
       dow not %eof(pahet910);
           if t9Rama = peRama and t9Poli = pePoli;
              existe = *on;
              leave;
           endif;
        reade %kds(k1het9:3) pahet910;
       enddo;

       if not existe;
          %subst(@repl:1:25) = %trim(pePate);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0004'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );
          peErro = -1;
          return;
       endif;

       p0Empr = peBase.peEmpr;
       p0Sucu = peBase.peSucu;
       p0Nivt = peBase.peNivt;
       p0Nivc = peBase.peNivc;
       p0Npds = peNpds;
       p0Nrdf = @@Aseg;
       p0Nomb = SVPASE_getNombre( @@Aseg );
       p0Rama = peRama;
       p0Poli = pePoli;
       p0Pate = pePate;
       p0Focu = peFocu;
       p0Hocu = peHocu;
       p0Caus = peCaus;
       p0Sini = *Zeros;
       p0Fpdf = *blanks;
       p0Mar1 = '0';
       p0Mar2 = '0';
       p0Mar3 = '0';
       p0Mar4 = '0';
       p0Mar5 = '0';
       p0User = ususr2;
       p0Date = (*year * 10000)
              + (*month *  100)
              +  *day;
       p0Time = %dec(%time():*iso);

       k1s000.p0empr = peBase.peEmpr;
       k1s000.p0sucu = peBase.peSucu;
       k1s000.p0nivt = peBase.peNivt;
       k1s000.p0nivc = peBase.peNivc;
       k1s000.p0npds = peNpds;
       setll %kds(k1s000) pds000;
       if not %equal;
          write p1ds00;
       endif;

      /end-free

     P SVPPDS_SetPreDen2...
     P                 e

      * ------------------------------------------------------------ *
      * SVPPDS_ChkPreDenuncia(): Valida existencia de Predenuncia    *
      *                                                              *
      *     peBase ( input  )   Parametros Base                      *
      *     peNpds ( input  )   Número de Predenuncia                *
      *     peNivt ( input  )   Tipo de Intermediario  ( opcional )  *
      *     peNivc ( input  )   Nivel de Intermediario ( opcional )  *
      *                                                              *
      * Retorna:  *on = Existe / *off = No Existe                    *
      * ------------------------------------------------------------ *
     P SVPPDS_ChkPreDenuncia...
     P                 b                   export
     D SVPPDS_ChkPreDenuncia...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNpds                       7  0 const
     D   peNivt                       1  0 options(*nopass:*omit)
     D   peNivc                       5  0 options(*nopass:*omit)

     D   k1y006        ds                  likerec( p1ds006 : *key )

      /free

        SVPPDS_inz();

        k1y006.p0empr = peEmpr;
        k1y006.p0sucu = peSucu;
        k1y006.p0npds = peNpds;
        if %parms >= 6  and  %addr( peNivt ) <> *null and
                             %addr( peNivc ) <> *null;
          k1y006.p0nivt = peNivt;
          k1y006.p0nivc = peNivc;
          setll %kds( k1y006 : 5 ) pds00006;
        else;
          setll %kds( k1y006 : 3 ) pds00006;
        endif;

        if not %equal( pds00006 );
          SetError( SVPPDS_PDSNE
                  : 'Pre-Denuncia de Siniestro Inexistente' );
          return *off;
        endif;

        return *on;
      /end-free

     P SVPPDS_ChkPreDenuncia...
     P                 e
      * ------------------------------------------------------------ *
      * cleanUp():  Elimina mensajes controlados del Joblog.         *
      *                                                              *
      *     peMsid (input)  ID de mensaje a eliminar.                *
      *                                                              *
      * retorna: *void                                               *
      * ------------------------------------------------------------ *
     P cleanUp         B
     D cleanUp         pi             1N
     D  peMsid                        7a   const

     D QMHRCVPM        pr                  ExtPgm('QMHRCVPM')
     D   MsgInfo                  32766a   options(*varsize)
     D   MsgInfoLen                  10i 0 const
     D   Format                       8a   const
     D   StackEntry                  10a   const
     D   StackCount                  10i 0 const
     D   MsgType                     10a   const
     D   MsgKey                       4a   const
     D   WaitTime                    10i 0 const
     D   MsgAction                   10a   const
     D   ErrorCode                32766a   options(*varsize)

     D RCVM0100_t      ds                  qualified based(TEMPLATE)
     D  BytesRet                     10i 0
     D  BytesAva                     10i 0
     D  MessageSev                   10i 0
     D  MessageId                     7a
     D  MessageType                   2a
     D  MessageKey                    4a
     D  Reserved1                     7a
     D  CCSID_st                     10i 0
     D  CCSID                        10i 0
     D  DataLen                      10i 0
     D  DataAva                      10i 0
     D  Data                        256a

     D RCVM0100        ds                  likeds(RCVM0100_t)

     D ErrorCode       ds
     D  EC_BytesPrv                  10i 0 inz(0)
     D  EC_BytesAva                  10i 0 inz(0)

     D StackCnt        s             10i 0 inz(1)
     D MsgKey          s              4a

      /free

       MsgKey = *ALLx'00';

       QMHRCVPM( RCVM0100
               : %size(RCVM0100)
               : 'RCVM0100'
               : '*'
               : StackCnt
               : '*PRV'
               : MsgKey
               : 0
               : '*SAME'
               : ErrorCode        );

       if ( RCVM0100.MessageId <> peMsid );
          return *OFF;
       endif;

       MsgKey = RCVM0100.MessageKey;

       QMHRCVPM( RCVM0100
               : %size(RCVM0100)
               : 'RCVM0100'
               : '*'
               : StackCnt
               : '*ANY'
               : MsgKey
               : 0
               : '*REMOVE'
               : ErrorCode        );

       return *ON;

      /end-free

     P cleanUp         E

      * ------------------------------------------------------------ *
      * SVPPDS_setTipoDeVoucher: Graba Tipo de Voucher en P0MAR1     *
      *                                                              *
      *     peBase ( input  )   Parametros Base                      *
      *     peNpds ( input  )   Número de Predenuncia                *
      *     peMar1 ( input  )   Tipo de Voucher                      *
      *     peErro ( output )   Error                                *
      *     peMsgs ( output )   Mensajes
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPPDS_setTipoDeVoucher...
     P                 b                   export
     D SVPPDS_setTipoDeVoucher...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNpds                       7  0 const
     D   peMar1                       1    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D   k1y000        ds                  likerec( p1ds00 : *key )
     D @repl           s          65535a

      /free

        SVPPDS_inz();

        if SVPWS_chkParmBase( peBase : peMsgs ) = *OFF;
          peErro = -1;
          return;
        endif;

        if not SVPPDS_chkPredenuncia( peBase.peEmpr
                                    : peBase.peSucu
                                    : peNpds
                                    : *omit
                                    : *omit             );
          %subst(@repl:1:7)  = %editc( peNpds :'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0010'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );

         peErro = -1;
         return;
        endif;

        if peMar1 <> 'R' and peMar1 <> 'C';
          %subst(@repl:1:1)  = peMar1;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0009'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );

         peErro = -1;
         return;
        endif;

        k1y000.p0Empr = peBase.peEmpr;
        k1y000.p0Sucu = peBase.peSucu;
        k1y000.p0Nivt = peBase.peNivt;
        k1y000.p0Nivc = peBase.peNivc;
        k1y000.p0Npds = peNpds;
        chain %kds( k1y000 : 5 ) pds000;
        if %found( pds000 );
          p0mar1 = peMar1;
          p0User = ususr2;
          p0Date = (*year * 10000)
                 + (*month *  100)
                 +  *day;
          p0Time = %dec(%time():*iso);
          update p1ds00;
          return;
        endif;

      /end-free

     P SVPPDS_setTipoDeVoucher...
     P                 e
