     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLPOL  : Tareas generales.                                  *
      *           WebService - Retorna Lista de Pólizas de un Inter- *
      *           mediario.                                          *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda - Norberto Franqueira       *15-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 20/04/2015 - Cambio DIM de peLpol de 500 a 100           *
      * SFA 21/04/2015 - Agrego validacion de parametros base        *
      * SGF 04/05/2015 - Refresco descripciones de rama, productor   *
      *                  asegurado y moneda desde las tablas GAUS.   *
      * SFA 23/05/2015 - Agrego paginado                             *
      * LRG 29/06/2015 - Agrego carga de campos                      *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * SGF 20/11/2015 - Agrego llamada a WSPCSP y retorno el        *
      *                  resultado como parte de la respuesta.       *
      * SGF 05/09/2016 - Upper en asno.                              *
      * SGF 06/09/2016 - Plan de Pago y Descripción forma de pago.   *
      * SGF 08/09/2016 - Ordenamiento por fecha de emisión desc.     *
      * SGF 09/09/2016 - Ultimo tipo de operacion.                   *
      *                                                              *
      * ************************************************************ *
     Fpahpol    if   e           k disk
     Fpahpol02  if   e           k disk    rename ( p1hpol : p2hpol )
     Fpahpol03  if   e           k disk    rename ( p1hpol : p3hpol )
     Fpahpol04  if   e           k disk    rename ( p1hpol : p4hpol )
     Fpahpol05  if   e           k disk    rename ( p1hpol : p5hpol )
     Fpahpol07  if   e           k disk    rename ( p1hpol : p7hpol )
     Fpahpol12  if   e           k disk    rename ( p1hpol : p1hpol2 )
     Fsehase01  if   e           k disk
     Fsehni201  if   e           k disk
     Fset001    if   e           k disk
     Fgntmon    if   e           k disk
     Fpahec1    if   e           k disk
     Fpahec3    if   e           k disk
     Fgntfpg    if   e           k disk
     Fpahed004  if   e           k disk

      /copy inf1serg/qcpybooks,svpws_h
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'

     D WSLPOL          pr                  ExtPgm('WSLPOL')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keypol_t) const
     D   pePreg                            likeds(keypol_t)
     D   peUreg                            likeds(keypol_t)
     D   peLpol                            likeds(pahpol_t) dim(99)
     D   peLpolC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPOL          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keypol_t) const
     D   pePreg                            likeds(keypol_t)
     D   peUreg                            likeds(keypol_t)
     D   peLpol                            likeds(pahpol_t) dim(99)
     D   peLpolC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D GSWEB037        pr                  ExtPgm('GSWEB037')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peTiou                        1  0 const
     D  peStou                        2  0 const
     D  peDsop                       20a

     D GSWEB039        pr                  ExtPgm('GSWEB039')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peMar2                        1a
     D  peMar3                        1a
     D  peFemianu                     8  0
     D  peFemireh                     8  0

     D GSWEB040        pr                  ExtPgm('GSWEB040')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  pePoli                        7  0 const
     D  peSuop                        3  0 const
     D  peNctz                        7  0

     D GSWEB042        pr                  EXTPGM('GSWEB042')
     D                                1    const
     D                                2    const
     D                                6  0 const
     D                                9  0 const
     D                               15  2

     D WSPCSP          pr                  ExtPgm('WSPCSP')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFech                        d   const
     D   peCast                      10i 0
     D   peCasp                      10i 0
     D   peCass                      10i 0
     D   peCasi                      10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D CobFinanc       pr                  extpgm('SPCOBFIN')
     D                                1
     D                                2
     D                                6  0
     D                                9  0
     D                                8  0
     D                                1
     D                                 n
     D                                3a

     D finArc          pr              n

     D k0hpol          ds                  likerec(p1hpol   : *key)
     D k1hpol          ds                  likerec(p1hpol   : *key)
     D k2hpol          ds                  likerec(p2hpol   : *key)
     D k3hpol          ds                  likerec(p3hpol   : *key)
     D k4hpol          ds                  likerec(p4hpol   : *key)
     D k5hpol          ds                  likerec(p5hpol   : *key)
     D k7hpol          ds                  likerec(p7hpol   : *key)
     D k1hpol2         ds                  likerec(p1hpol2  : *key)
     D k1t001          ds                  likerec(s1t001   : *key)
     D k1hase          ds                  likerec(s1hase01 : *key)
     D k1hni2          ds                  likerec(s1hni201 : *key)
     D k1tmon          ds                  likerec(g1tmon   : *key)
     D k1hec1          ds                  likerec(p1hec1   : *key)
     D k1hec3          ds                  likerec(p1hec3   : *key)
     D k1hed0          ds                  likerec(p1hed004 : *key)

     D @@cant          s             10i 0
     D @@more          s               n

     D @femianu        s              8  0
     D @femireh        s              8  0
     D @@Prcp          s             15  2
     D cobf_fech       s              8  0
     D cobf_conv       s              1a
     D @fpgm           s              3

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

       *inLr = *On;

       peLpolC = *Zeros;
       peErro  = *Zeros;

       @@more  = *On;

       clear peLpol;
       clear peMsgs;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      *- Valido Orden de Lectura
       if not SVPWS_chkOrde ( 'WSLPOL' : peOrde : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;
       exsr priReg;

       dow ( ( not finArc ) and ( peLpolC < @@cant ) );

         k1t001.t@rama = porama;
         chain %kds(k1t001) set001;
         if not %found;
            t@mar5 = 'N';
            t@ramd = *blanks;
            t@ramb = *blanks;
         endif;

         // ------------------------------
         // Muevo Datos directamente de PAHPOL
         // ------------------------------
       if t@mar5 = 'S';

         peLpolC += 1;

         GSWEB039( poempr
                 : posucu
                 : poarcd
                 : pospol
                 : porama
                 : poarse
                 : pooper
                 : pomar2
                 : pomar3
                 : @femianu
                 : @femireh );

         pofemianu = d'9999-12-31';
         pofemireh = d'9999-12-31';
         test(de) *iso @femianu;
         if not %error;
            pofemianu = %date(@femianu:*iso);
         endif;
         test(de) *iso @femireh;
         if not %error;
            pofemireh = %date(@femireh:*iso);
         endif;

         peLpol( peLpolC ).poempr = poempr;
         peLpol( peLpolC ).posucu = posucu;
         peLpol( peLpolC ).porama = porama;
         peLpol( peLpolC ).popoli = popoli;
         peLpol( peLpolC ).pocert = pocert;
         peLpol( peLpolC ).poarcd = poarcd;
         peLpol( peLpolC ).pospol = pospol;
         peLpol( peLpolC ).poarse = poarse;
         peLpol( peLpolC ).pooper = pooper;
         peLpol( peLpolC ).ponivt = ponivt;
         peLpol( peLpolC ).ponivc = ponivc;
         peLpol( peLpolC ).poasen = poasen;
         peLpol( peLpolC ).pofemi = pofemi;
         peLpol( peLpolC ).pofdes = pofdes;
         peLpol( peLpolC ).pofhas = pofhas;
         peLpol( peLpolC ).pohafa = pohafa;
         peLpol( peLpolC ).poanua = poanua;
         peLpol( peLpolC ).pomone = pomone;
         peLpol( peLpolC ).poprim = poprim;
         peLpol( peLpolC ).pobpri = pobpri;
         peLpol( peLpolC ).porefi = porefi;
         peLpol( peLpolC ).poread = poread;
         peLpol( peLpolC ).podere = podere;
         peLpol( peLpolC ).poseri = poseri;
         peLpol( peLpolC ).poseem = poseem;
         peLpol( peLpolC ).poimpi = poimpi;
         peLpol( peLpolC ).posers = posers;
         peLpol( peLpolC ).potssn = potssn;
         peLpol( peLpolC ).poipr1 = poipr1;
         peLpol( peLpolC ).poipr3 = poipr3;
         peLpol( peLpolC ).poipr4 = poipr4;
         peLpol( peLpolC ).poipr2 = poipr2;
         peLpol( peLpolC ).poipr5 = poipr5;
         peLpol( peLpolC ).poipr6 = poipr6;
         peLpol( peLpolC ).poipr7 = poipr7;
         peLpol( peLpolC ).poipr8 = poipr8;
         peLpol( peLpolC ).poipr9 = poipr9;
         peLpol( peLpolC ).poprem = poprem;

      * Calculo de Saldo...
         gsweb042 (poEmpr
                 : poSucu
                 : poArcd
                 : poSpol
                 : @@Prcp);
         peLpol( peLpolC ).poprco = @@Prcp;
         peLpol( peLpolC ).ponivt1 = ponivt1;
         peLpol( peLpolC ).ponivc1 = ponivc1;
         peLpol( peLpolC ).pocopr1 = pocopr1;
         peLpol( peLpolC ).ponivt2 = ponivt2;
         peLpol( peLpolC ).ponivc2 = ponivc2;
         peLpol( peLpolC ).pocopr2 = pocopr2;
         peLpol( peLpolC ).ponivt3 = ponivt3;
         peLpol( peLpolC ).ponivc3 = ponivc3;
         peLpol( peLpolC ).pocopr3 = pocopr3;
         peLpol( peLpolC ).ponivt4 = ponivt4;
         peLpol( peLpolC ).ponivc4 = ponivc4;
         peLpol( peLpolC ).pocopr4 = pocopr4;
         peLpol( peLpolC ).ponivt5 = ponivt5;
         peLpol( peLpolC ).ponivc5 = ponivc5;
         peLpol( peLpolC ).pocopr5 = pocopr5;
         peLpol( peLpolC ).ponivt6 = ponivt6;
         peLpol( peLpolC ).ponivc6 = ponivc6;
         peLpol( peLpolC ).pocopr6 = pocopr6;
         peLpol( peLpolC ).ponivt7 = ponivt7;
         peLpol( peLpolC ).ponivc7 = ponivc7;
         peLpol( peLpolC ).pocopr7 = pocopr7;
         peLpol( peLpolC ).ponivt8 = ponivt8;
         peLpol( peLpolC ).ponivc8 = ponivc8;
         peLpol( peLpolC ).pocopr8 = pocopr8;
         peLpol( peLpolC ).ponivt9 = ponivt9;
         peLpol( peLpolC ).ponivc9 = ponivc9;
         peLpol( peLpolC ).pocopr9 = pocopr9;
         peLpol( peLpolC ).pomarsin = SVPSIN_getSini( poEmpr : poSucu
                                                    : poarcd : poSpol);
         peLpol( peLpolC ).popoan = popoan;
         peLpol( peLpolC ).poponu = poponu;
         peLpol( peLpolC ).popatente = popatente;
         peLpol( peLpolC ).podesanu = podesanu;
         peLpol( peLpolC ).pomar1 = pomar1;
         peLpol( peLpolC ).pomar2 = pomar2;
         peLpol( peLpolC ).pomar3 = pomar3;
         peLpol( peLpolC ).pomar4 = pomar4;
         peLpol( peLpolC ).pomar5 = pomar5;
         peLpol( peLpolC ).pomar6 = pomar6;
         peLpol( peLpolC ).pomar7 = pomar7;
         peLpol( peLpolC ).pomar8 = pomar8;
         peLpol( peLpolC ).pomar9 = pomar9;
         peLpol( peLpolC ).pofemianu = pofemianu;
         peLpol( peLpolC ).pofemireh = pofemireh;
         peLpol( peLpolC ).pots20 = *Zeros;
         GSWEB040( poempr
                 : posucu
                 : poarcd
                 : pospol
                 : 0
                 : porama
                 : poarse
                 : pooper
                 : popoli
                 : 0
                 : ponctz );
         peLpol( peLpolC ).ponctz = ponctz;
         peLpol( peLpolC ).poxrea = poxrea;
         peLpol( peLpolC ).pointeg = pointeg;
         callp CobFinanc( poempr
                        : posucu
                        : poarcd
                        : pospol
                        : cobf_fech
                        : cobf_conv
                        : pocobf
                        : @fpgm );
         peLpol( peLpolC ).pocobf = pocobf;
         peLpol( peLpolC ).poemcn = poemcn;
         k1hed0.d0empr = poempr;
         k1hed0.d0sucu = posucu;
         k1hed0.d0rama = porama;
         k1hed0.d0poli = popoli;
         setgt %kds(k1hed0:4) pahed004;
         readpe %kds(k1hed0:4) pahed004;
         if not %eof;
            peLpol( peLpolC ).potiou = d0tiou;
            peLpol( peLpolC ).postou = d0stou;
            peLpol( peLpolC ).postos = d0stos;
          else;
            peLpol( peLpolC ).potiou = potiou;
            peLpol( peLpolC ).postou = postou;
            peLpol( peLpolC ).postos = postos;
         endif;
         GSWEB037( peLpol(peLpolC).poempr
                 : peLpol(peLpolC).posucu
                 : peLpol(peLpolC).porama
                 : peLpol(peLpolC).potiou
                 : peLpol(peLpolC).postou
                 : peLpol(peLpolC).podsop );
         peLpol( peLpolC ).poxref = poxref;
         peLpol( peLpolC ).popimi = popimi;
         peLpol( peLpolC ).popsso = popsso;
         peLpol( peLpolC ).popssn = popssn;
         peLpol( peLpolC ).popivi = popivi;
         peLpol( peLpolC ).popivn = popivn;
         peLpol( peLpolC ).popivr = popivr;
         peLpol( peLpolC ).poubic = poubic;
         peLpol( peLpolC ).poramd = t@ramd;
         peLpol( peLpolC ).poramb = t@ramb;

         // ------------------------------
         // Refresco nombre productor
         // ------------------------------
         k1hni2.n2empr = poempr;
         k1hni2.n2sucu = posucu;
         k1hni2.n2nivt = 1;
         k1hni2.n2nivc = ponivc1;
         chain %kds(k1hni2) sehni201;
         if %found;
           peLpol( peLpolC ).ponino = dfnomb;
         endif;

         // ------------------------------
         // Refresco nombre asegurado
         // ------------------------------
         k1hase.asasen = poasen;
         chain %kds(k1hase) sehase01;
         if %found;
           peLpol( peLpolC ).poasno = dfnomb;
         endif;

         // ------------------------------
         // Refresco nombre moneda
         // ------------------------------
         k1tmon.mocomo = pomone;
         chain %kds(k1tmon) gntmon;
         if %found;
           peLpol( peLpolC ).ponmoc = monmoc;
         endif;

         // ------------------------------
         // Cantidad de siniestros
         // ------------------------------
         WSPCSP( peBase
               : porama
               : popoli
               : %date
               : peLpol(peLpolC).pocast
               : peLpol(peLpolC).pocasp
               : peLpol(peLpolC).pocass
               : peLpol(peLpolC).pocasi
               : peErro
               : peMsgs                 );

         k1hec3.c3empr = poempr;
         k1hec3.c3sucu = posucu;
         k1hec3.c3arcd = poarcd;
         k1hec3.c3spol = pospol;
         setgt %kds(k1hec3:4) pahec3;
         readpe %kds(k1hec3:4) pahec3;
         if %eof;
            peLpol(peLpolC).ponrpp = 0;
          else;
            peLpol(peLpolC).ponrpp = c3nrpp;
         endif;


         // ------------------------------
         // Refresco forma de pago
         // ------------------------------
         k1hec1.c1empr = poempr;
         k1hec1.c1sucu = posucu;
         k1hec1.c1arcd = poarcd;
         k1hec1.c1spol = pospol;
         setgt %kds(k1hec1:4) pahec1;
         readpe %kds(k1hec1:4) pahec1;
         if not %eof;
           peLpol( peLpolC ).pocfpg = c1cfpg;
           peLpol( peLpolC ).poctcu = c1ctcu;
           peLpol( peLpolC ).ponrtc = c1nrtc;
           peLpol( peLpolC ).poivbc = c1ivbc;
           peLpol( peLpolC ).poivsu = c1ivsu;
           peLpol( peLpolC ).potcta = c1tcta;
           peLpol( peLpolC ).poncta = c1ncta;
      *   Cálculo de la CBU
           if c1cfpg = 2 or c1cfpg = 3;
              peLpol( peLpolC ).pocfpg = c1cfpg;
              poncbu  = SPVCBU_GetCBUEntero ( poivbc : poivsu :
                                              potcta : poncta );
           endif;
           chain c1cfpg gntfpg;
           if %found;
              peLpol(peLpolC).podefp = fpdefp;
            else;
              peLpol(peLpolC).podefp = *blanks;
           endif;
          else;
           peLpol(peLpolC).podefp = *blanks;
         endif;

         exsr borCom;

         exsr UltReg;

        endif;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when finArc;
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun peOrde, pePosi, peRoll
       begsr posArc;

         k0hpol.poempr = peBase.peEmpr;
         k0hpol.posucu = peBase.peSucu;
         k0hpol.ponivt = peBase.peNivt;
         k0hpol.ponivc = peBase.peNivc;

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             k1hpol.poempr = peBase.peEmpr;
             k1hpol.posucu = peBase.peSucu;
             k1hpol.ponivt = peBase.peNivt;
             k1hpol.ponivc = peBase.peNivc;
             k1hpol.porama = pePosi.porama;
             k1hpol.popoli = pePosi.popoli;
             if ( peRoll = 'F' );
               setgt %kds ( k1hpol : 6 ) pahpol;
             else;
               setll %kds ( k1hpol : 6 ) pahpol;
             endif;
           when ( peOrde = 'ASEGURADO' );
             k2hpol.poempr = peBase.peEmpr;
             k2hpol.posucu = peBase.peSucu;
             k2hpol.ponivt = peBase.peNivt;
             k2hpol.ponivc = peBase.peNivc;
             k2hpol.poasno = %xlate(min:may:pePosi.poasno);
             if ( peRoll = 'F' );
               setgt %kds ( k2hpol : 5 ) pahpol02;
             else;
               setll %kds ( k2hpol : 5 ) pahpol02;
             endif;
           when ( peOrde = 'MATRICULA' );
             k3hpol.poempr    = peBase.peEmpr;
             k3hpol.posucu    = peBase.peSucu;
             k3hpol.ponivt    = peBase.peNivt;
             k3hpol.ponivc    = peBase.peNivc;
             k3hpol.popatente = %xlate(min:may:pePosi.popatente);
             if ( peRoll = 'F' );
               setgt %kds ( k3hpol : 5 ) pahpol03;
             else;
               setll %kds ( k3hpol : 5 ) pahpol03;
             endif;
           when ( peOrde = 'CUIT' );
             k4hpol.poempr = peBase.peEmpr;
             k4hpol.posucu = peBase.peSucu;
             k4hpol.ponivt = peBase.peNivt;
             k4hpol.ponivc = peBase.peNivc;
             k4hpol.pocuip = %dec ( pePosi.pocuip : 11 : 0 );
             if ( peRoll = 'F' );
               setgt %kds ( k4hpol : 5 ) pahpol04;
             else;
               setll %kds ( k4hpol : 5 ) pahpol04;
             endif;
           when ( peOrde = 'NOMBARCO' );
             k5hpol.poempr = peBase.peEmpr;
             k5hpol.posucu = peBase.peSucu;
             k5hpol.ponivt = peBase.peNivt;
             k5hpol.ponivc = peBase.peNivc;
             k5hpol.poemcn = pePosi.poemcn;
             if ( peRoll = 'F' );
               setgt %kds ( k5hpol : 5 ) pahpol05;
             else;
               setll %kds ( k5hpol : 5 ) pahpol05;
             endif;
           when ( peOrde = 'UBICACION' );
             k7hpol.poempr = peBase.peEmpr;
             k7hpol.posucu = peBase.peSucu;
             k7hpol.ponivt = peBase.peNivt;
             k7hpol.ponivc = peBase.peNivc;
             k7hpol.poubic = pePosi.poubic;
             if ( peRoll = 'F' );
               setgt %kds ( k7hpol : 5 ) pahpol07;
             else;
               setll %kds ( k7hpol : 5 ) pahpol07;
             endif;
           when ( peOrde = 'FECHAEMISI' );
             k1hpol2.poempr = peBase.peEmpr;
             k1hpol2.posucu = peBase.peSucu;
             k1hpol2.ponivt = peBase.peNivt;
             k1hpol2.ponivc = peBase.peNivc;
             k1hpol2.porama = pePosi.porama;
             k1hpol2.popoli = pePosi.popoli;
             k1hpol2.pocert = pePosi.pocert;
             k1hpol2.poarcd = pePosi.poarcd;
             k1hpol2.pospol = pePosi.pospol;
             k1hpol2.poarse = pePosi.poarse;
             k1hpol2.pooper = pePosi.pooper;
             monitor;
                 k1hpol2.pofemi = %date(pePosi.pofemi:*iso);
              on-error;
                 k1hpol2.pofemi = %date(00010101:*iso);
             endmon;
             if ( peRoll = 'F' );
               setgt %kds ( k1hpol2 : 12 ) pahpol12;
             else;
               setll %kds ( k1hpol2 : 12 ) pahpol12;
             endif;
         endsl;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             reade %kds ( k0hpol : 4 ) pahpol;
           when ( peOrde = 'ASEGURADO' );
             reade %kds ( k0hpol : 4 ) pahpol02;
           when ( peOrde = 'MATRICULA' );
             reade %kds ( k0hpol : 4 ) pahpol03;
           when ( peOrde = 'CUIT' );
             reade %kds ( k0hpol : 4 ) pahpol04;
           when ( peOrde = 'NOMBARCO' );
             reade %kds ( k0hpol : 4 ) pahpol05;
           when ( peOrde = 'UBICACION' );
             reade %kds ( k0hpol : 4 ) pahpol07;
           when ( peOrde = 'FECHAEMISI' );
             reade %kds ( k0hpol : 4 ) pahpol12;
         endsl;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             readpe %kds ( k0hpol : 4 ) pahpol;
           when ( peOrde = 'ASEGURADO' );
             readpe %kds ( k0hpol : 4 ) pahpol02;
           when ( peOrde = 'MATRICULA' );
             readpe %kds ( k0hpol : 4 ) pahpol03;
           when ( peOrde = 'CUIT' );
             readpe %kds ( k0hpol : 4 ) pahpol04;
           when ( peOrde = 'NOMBARCO' );
             readpe %kds ( k0hpol : 4 ) pahpol05;
           when ( peOrde = 'UBICACION' );
             readpe %kds ( k0hpol : 4 ) pahpol07;
           when ( peOrde = 'FECHAEMISI' );
             readpe %kds ( k0hpol : 4 ) pahpol12;
         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             setll %kds( k0hpol : 4 ) pahpol;
           when ( peOrde = 'ASEGURADO' );
             setll %kds( k0hpol : 4 ) pahpol02;
           when ( peOrde = 'MATRICULA' );
             setll %kds ( k0hpol : 4 ) pahpol03;
           when ( peOrde = 'CUIT' );
             setll %kds ( k0hpol : 4 ) pahpol04;
           when ( peOrde = 'NOMBARCO' );
             setll %kds ( k0hpol : 4 ) pahpol05;
           when ( peOrde = 'UBICACION' );
             setll %kds ( k0hpol : 4 ) pahpol07;
           when ( peOrde = 'FECHAEMISI' );
             setll %kds ( k0hpol : 4 ) pahpol12;
         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

         if ( peRoll = 'R' );
           exsr retArc;
           dow ( ( not finArc ) and ( @@cant > 0 ) );
             @@cant -= 1;
             exsr retArc;
           enddo;
           if finArc;
             @@more = *Off;
             exsr priArc;
           endif;
           @@cant = peCant;
           if (@@cant <= 0 or @@cant > 99);
              @@cant = 99;
           endif;
         endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;

         pePreg.porama = porama;
         pePreg.popoli = popoli;
         pePreg.pocert = pocert;
         pePreg.poarcd = poarcd;
         pePreg.pospol = pospol;
         pePreg.poarse = poarse;
         pePreg.pooper = pooper;
         pePreg.poasno = poasno;
         pePreg.popatente = popatente;
         pePreg.pocuip = %char ( pocuip );
         pePreg.poemcn = poemcn;
         pePreg.poubic = poubic;
         pePreg.pofemi = %dec(pofemi:*iso);

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.porama = porama;
         peUreg.popoli = popoli;
         peUreg.pocert = pocert;
         peUreg.poarcd = poarcd;
         peUreg.pospol = pospol;
         peUreg.poarse = poarse;
         peUreg.pooper = pooper;
         peUreg.poasno = poasno;
         peUreg.popatente = popatente;
         peUreg.pocuip = %char ( pocuip );
         peUreg.poemcn = poemcn;
         peUreg.poubic = poubic;
         peUreg.pofemi = %dec(pofemi:*iso);

       endsr;

      *- Borro Comisiones segun peNit1
       begsr borCom;

         select;
           when ( peBase.peNit1 = 1 );
             peLpol( peLpolC ).ponivt2 = *Zeros;
             peLpol( peLpolC ).ponivt3 = *Zeros;
             peLpol( peLpolC ).ponivt4 = *Zeros;
             peLpol( peLpolC ).ponivt5 = *Zeros;
             peLpol( peLpolC ).ponivt6 = *Zeros;
             peLpol( peLpolC ).ponivt7 = *Zeros;
             peLpol( peLpolC ).ponivt8 = *Zeros;
             peLpol( peLpolC ).ponivt9 = *Zeros;
             peLpol( peLpolC ).ponivc2 = *Zeros;
             peLpol( peLpolC ).ponivc3 = *Zeros;
             peLpol( peLpolC ).ponivc4 = *Zeros;
             peLpol( peLpolC ).ponivc5 = *Zeros;
             peLpol( peLpolC ).ponivc6 = *Zeros;
             peLpol( peLpolC ).ponivc7 = *Zeros;
             peLpol( peLpolC ).ponivc8 = *Zeros;
             peLpol( peLpolC ).ponivc9 = *Zeros;
             peLpol( peLpolC ).pocopr2 = *Zeros;
             peLpol( peLpolC ).pocopr3 = *Zeros;
             peLpol( peLpolC ).pocopr4 = *Zeros;
             peLpol( peLpolC ).pocopr5 = *Zeros;
             peLpol( peLpolC ).pocopr6 = *Zeros;
             peLpol( peLpolC ).pocopr7 = *Zeros;
             peLpol( peLpolC ).pocopr8 = *Zeros;
             peLpol( peLpolC ).pocopr9 = *Zeros;
           when ( peBase.peNit1 = 2 );
             peLpol( peLpolC ).ponivt3 = *Zeros;
             peLpol( peLpolC ).ponivt4 = *Zeros;
             peLpol( peLpolC ).ponivt5 = *Zeros;
             peLpol( peLpolC ).ponivt6 = *Zeros;
             peLpol( peLpolC ).ponivt7 = *Zeros;
             peLpol( peLpolC ).ponivt8 = *Zeros;
             peLpol( peLpolC ).ponivt9 = *Zeros;
             peLpol( peLpolC ).ponivc3 = *Zeros;
             peLpol( peLpolC ).ponivc4 = *Zeros;
             peLpol( peLpolC ).ponivc5 = *Zeros;
             peLpol( peLpolC ).ponivc6 = *Zeros;
             peLpol( peLpolC ).ponivc7 = *Zeros;
             peLpol( peLpolC ).ponivc8 = *Zeros;
             peLpol( peLpolC ).ponivc9 = *Zeros;
             peLpol( peLpolC ).pocopr3 = *Zeros;
             peLpol( peLpolC ).pocopr4 = *Zeros;
             peLpol( peLpolC ).pocopr5 = *Zeros;
             peLpol( peLpolC ).pocopr6 = *Zeros;
             peLpol( peLpolC ).pocopr7 = *Zeros;
             peLpol( peLpolC ).pocopr8 = *Zeros;
             peLpol( peLpolC ).pocopr9 = *Zeros;
           when ( peBase.peNit1 = 3 );
             peLpol( peLpolC ).ponivt4 = *Zeros;
             peLpol( peLpolC ).ponivt5 = *Zeros;
             peLpol( peLpolC ).ponivt6 = *Zeros;
             peLpol( peLpolC ).ponivt7 = *Zeros;
             peLpol( peLpolC ).ponivt8 = *Zeros;
             peLpol( peLpolC ).ponivt9 = *Zeros;
             peLpol( peLpolC ).ponivc4 = *Zeros;
             peLpol( peLpolC ).ponivc5 = *Zeros;
             peLpol( peLpolC ).ponivc6 = *Zeros;
             peLpol( peLpolC ).ponivc7 = *Zeros;
             peLpol( peLpolC ).ponivc8 = *Zeros;
             peLpol( peLpolC ).ponivc9 = *Zeros;
             peLpol( peLpolC ).pocopr4 = *Zeros;
             peLpol( peLpolC ).pocopr5 = *Zeros;
             peLpol( peLpolC ).pocopr6 = *Zeros;
             peLpol( peLpolC ).pocopr7 = *Zeros;
             peLpol( peLpolC ).pocopr8 = *Zeros;
             peLpol( peLpolC ).pocopr9 = *Zeros;
           when ( peBase.peNit1 = 4 );
             peLpol( peLpolC ).ponivt5 = *Zeros;
             peLpol( peLpolC ).ponivt6 = *Zeros;
             peLpol( peLpolC ).ponivt7 = *Zeros;
             peLpol( peLpolC ).ponivt8 = *Zeros;
             peLpol( peLpolC ).ponivt9 = *Zeros;
             peLpol( peLpolC ).ponivc5 = *Zeros;
             peLpol( peLpolC ).ponivc6 = *Zeros;
             peLpol( peLpolC ).ponivc7 = *Zeros;
             peLpol( peLpolC ).ponivc8 = *Zeros;
             peLpol( peLpolC ).ponivc9 = *Zeros;
             peLpol( peLpolC ).pocopr5 = *Zeros;
             peLpol( peLpolC ).pocopr6 = *Zeros;
             peLpol( peLpolC ).pocopr7 = *Zeros;
             peLpol( peLpolC ).pocopr8 = *Zeros;
             peLpol( peLpolC ).pocopr9 = *Zeros;
           when ( peBase.peNit1 = 5 );
             peLpol( peLpolC ).ponivt6 = *Zeros;
             peLpol( peLpolC ).ponivt7 = *Zeros;
             peLpol( peLpolC ).ponivt8 = *Zeros;
             peLpol( peLpolC ).ponivt9 = *Zeros;
             peLpol( peLpolC ).ponivc6 = *Zeros;
             peLpol( peLpolC ).ponivc7 = *Zeros;
             peLpol( peLpolC ).ponivc8 = *Zeros;
             peLpol( peLpolC ).ponivc9 = *Zeros;
             peLpol( peLpolC ).pocopr6 = *Zeros;
             peLpol( peLpolC ).pocopr7 = *Zeros;
             peLpol( peLpolC ).pocopr8 = *Zeros;
             peLpol( peLpolC ).pocopr9 = *Zeros;
           when ( peBase.peNit1 = 6 );
             peLpol( peLpolC ).ponivt7 = *Zeros;
             peLpol( peLpolC ).ponivt8 = *Zeros;
             peLpol( peLpolC ).ponivt9 = *Zeros;
             peLpol( peLpolC ).ponivc7 = *Zeros;
             peLpol( peLpolC ).ponivc8 = *Zeros;
             peLpol( peLpolC ).ponivc9 = *Zeros;
             peLpol( peLpolC ).pocopr7 = *Zeros;
             peLpol( peLpolC ).pocopr8 = *Zeros;
             peLpol( peLpolC ).pocopr9 = *Zeros;
           when ( peBase.peNit1 = 7 );
             peLpol( peLpolC ).ponivt8 = *Zeros;
             peLpol( peLpolC ).ponivt9 = *Zeros;
             peLpol( peLpolC ).ponivc8 = *Zeros;
             peLpol( peLpolC ).ponivc9 = *Zeros;
             peLpol( peLpolC ).pocopr8 = *Zeros;
             peLpol( peLpolC ).pocopr9 = *Zeros;
           when ( peBase.peNit1 = 8 );
             peLpol( peLpolC ).ponivt9 = *Zeros;
             peLpol( peLpolC ).ponivc9 = *Zeros;
             peLpol( peLpolC ).pocopr9 = *Zeros;
         endsl;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

         select;
           when ( peOrde = 'RAMAPOLIZA' );
             return %eof ( pahpol );
           when ( peOrde = 'ASEGURADO' );
             return %eof ( pahpol02 );
           when ( peOrde = 'MATRICULA' );
             return %eof ( pahpol03 );
           when ( peOrde = 'CUIT' );
             return %eof ( pahpol04 );
           when ( peOrde = 'NOMBARCO' );
             return %eof ( pahpol05 );
           when ( peOrde = 'UBICACION' );
             return %eof ( pahpol07 );
           when ( peOrde = 'FECHAEMISI' );
             return %eof ( pahpol12 );
         endsl;

     P finArc          E
