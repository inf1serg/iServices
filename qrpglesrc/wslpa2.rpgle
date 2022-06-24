     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLPA2  : Tareas generales.                                  *
      *           WebService - Retorna Lista de Pólizas a Vencer     *
      *                                                              *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                               *28-Jul-2016  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *                                                              *
      * SGF 22/08/2016: Si vigencia abierta, mover anualidad.        *
      * SGF 13/09/2016: No listar:                                   *
      *                 Anuladas, Renovadas, Con Stros Totales, con  *
      *                 Saldo ni frenadas por Técnica.               *
      * LRG 02/11/2016: Se agregan filtro en el retroceso.           *
      * GIO 20/07/2018: Se recompila por cambio en pahpol01          *
      *                                                              *
      * ************************************************************ *
     Fpahpol01  if   e           k disk    rename ( p1hpol : p1hpol )
     Fpahpol10  if   e           k disk    rename ( p1hpol : p2hpol )
     Fpahpol11  if   e           k disk    rename ( p1hpol : p3hpol )
     Fsehase01  if   e           k disk
     Fsehni201  if   e           k disk
     Fset001    if   e           k disk
     Fgntmon    if   e           k disk
     Fpahec1    if   e           k disk
     Fpahavr    if   e           k disk
     Fpawrn1    if   e           k disk
     Fpahscd03  if   e           k disk
     Fpahsbe    if   e           k disk
     Fpahsb1    if   e           k disk
     Fset6303   if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'

     D WSLPA2          pr                  ExtPgm('WSLPA2')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   peFdes                        d   const
     D   peFhas                        d   const
     D   pePosi                            likeds(keypa2_t) const
     D   pePreg                            likeds(keypa2_t)
     D   peUreg                            likeds(keypa2_t)
     D   peLpol                            likeds(pahpol_t) dim(99)
     D   peLpolC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPA2          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   peOrde                      10a   const
     D   peFdes                        d   const
     D   peFhas                        d   const
     D   pePosi                            likeds(keypa2_t) const
     D   pePreg                            likeds(keypa2_t)
     D   peUreg                            likeds(keypa2_t)
     D   peLpol                            likeds(pahpol_t) dim(99)
     D   peLpolC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLOG           pr                  ExtPgm('QUOMDATA/WSLOG')
     D  msg                         512a   const

     D sleep           pr            10u 0 extproc('sleep')
     D  secs                         10u 0 value

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

     D SP0079B         pr                  EXTPGM('SP0079B')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peFech                        8  0 const
     D  peCant                        5  0

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

     D DXP021          pr                  ExtPgm('DXP021')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peFema                        4  0 const
     D  peFemm                        2  0 const
     D  peFemd                        2  0 const
     D  peAnul                        1a
     D  peFpgm                        3a   const

     D finArc          pr              n

     D k0hpol          ds                  likerec(p1hpol   : *key)
     D k1hpol          ds                  likerec(p1hpol   : *key)
     D k2hpol          ds                  likerec(p2hpol   : *key)
     D k3hpol          ds                  likerec(p3hpol   : *key)
     D k1t001          ds                  likerec(s1t001   : *key)
     D k1hase          ds                  likerec(s1hase01 : *key)
     D k1hni2          ds                  likerec(s1hni201 : *key)
     D k1tmon          ds                  likerec(g1tmon   : *key)
     D k1hec1          ds                  likerec(p1hec1   : *key)
     D k1havr          ds                  likerec(p1havr   : *key)
     D k1wrn1          ds                  likerec(p1wrn1   : *key)
     D k1hscd          ds                  likerec(p1hscd03 : *key)
     D k1hsbe          ds                  likerec(p1hsbe   : *key)
     D k1hsb1          ds                  likerec(p1hsb1   : *key)

     D @@cant          s             10i 0
     D @@more          s               n

     D @femianu        s              8  0
     D @femireh        s              8  0
     D @@Prcp          s             15  2
     D cobf_fech       s              8  0
     D cobf_conv       s              1a
     D @fpgm           s              3
     D @@fech          s               d
     D pReg            s               n
     D peAnul          s              1a
     D sini_tot        s              1N
     D cuCant          s              5  0

     D psds           sds                  qualified
     D  job                          26a   overlay(PsDs:244)

       *inLr = *On;

       //wslog(psds.job);
       //sleep(60);

       peLpolC = *Zeros;
       peErro  = *Zeros;

       @@more  = *On;
       pReg  = *Off;

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
       if not SVPWS_chkOrde ( 'WSLPA2' : peOrde : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Si no llego fecha en el pePosi, es primera vez y utilizo el peFdes
       if pePosi.pofech = %date(00010103) or
          pePosi.pofech = %date(19691231);
         @@fech = peFdes;
       else;
         @@fech = pePosi.pofech;
       endif;

       peLpolC = 0;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       dow ( ( not finArc ) and ( peLpolC < @@cant ) );

        if ( ( poanua >= peFdes ) and ( poanua <= peFhas ) );


        if Muestra();

          if not pReg;
            exsr priReg;
          endif;

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
            if %nullind(pofhas) = *on;
               peLpol( peLpolC ).pofhas = poanua;
            endif;
            peLpol( peLpolC ).pohafa = pohafa;
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
            peLpol( peLpolC ).potiou = potiou;
            peLpol( peLpolC ).postou = postou;
            peLpol( peLpolC ).postos = postos;

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

      *       Cálculo de la CBU
              if c1cfpg = 2 or c1cfpg = 3;
                 peLpol( peLpolC ).pocfpg = c1cfpg;
                 poncbu  = SPVCBU_GetCBUEntero ( poivbc : poivsu :
                                                 potcta : poncta );
              endif;

            endif;

          exsr borCom;

          exsr UltReg;

          endif;

        endif;

        endif;

        exsr leeArc;

       enddo;

       if peLpolC = *Zeros;
         clear pePreg;
       endif;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when finArc;
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       DXP021( poempr
             : posucu
             : poarcd
             : pospol
             : *year
             : *month
             : *day
             : peAnul
             : 'FIN' );

       return;

      *- Rutina de Posicionamiento de Archivo. Segun peOrde, pePosi, peRoll
       begsr posArc;

         k0hpol.poempr = peBase.peEmpr;
         k0hpol.posucu = peBase.peSucu;
         k0hpol.ponivt = peBase.peNivt;
         k0hpol.ponivc = peBase.peNivc;

         select;
           when ( peOrde = 'ANUALIDAD' );
             k1hpol.poempr = peBase.peEmpr;
             k1hpol.posucu = peBase.peSucu;
             k1hpol.ponivt = peBase.peNivt;
             k1hpol.ponivc = peBase.peNivc;
             k1hpol.poanua = @@fech;
             k1hpol.porama = pePosi.porama;
             k1hpol.popoli = pePosi.popoli;
             if ( peRoll = 'F' );
               setgt %kds ( k1hpol : 7 ) pahpol01;
             else;
               setll %kds ( k1hpol : 7 ) pahpol01;
             endif;
           when ( peOrde = 'ASEGURADO' );
             k2hpol.poempr = peBase.peEmpr;
             k2hpol.posucu = peBase.peSucu;
             k2hpol.ponivt = peBase.peNivt;
             k2hpol.ponivc = peBase.peNivc;
             k2hpol.poanua = @@fech;
             k2hpol.poasno = pePosi.poasno;
             k2hpol.porama = pePosi.porama;
             k2hpol.popoli = pePosi.popoli;
             if ( peRoll = 'F' );
               setgt %kds ( k2hpol : 8 ) pahpol10;
             else;
               setll %kds ( k2hpol : 8 ) pahpol10;
             endif;
           when ( peOrde = 'RAMAPOLIZA' );
             k3hpol.poempr = peBase.peEmpr;
             k3hpol.posucu = peBase.peSucu;
             k3hpol.ponivt = peBase.peNivt;
             k3hpol.ponivc = peBase.peNivc;
             k3hpol.poanua = @@fech;
             k3hpol.porama = pePosi.poRama;
             k3hpol.popoli = pePosi.poPoli;
             if ( peRoll = 'F' );
               setgt %kds ( k3hpol : 7 ) pahpol11;
             else;
               setll %kds ( k3hpol : 7 ) pahpol11;
             endif;
         endsl;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

         select;
           when ( peOrde = 'ANUALIDAD' );
             reade %kds ( k0hpol : 4 ) pahpol01;
           when ( peOrde = 'ASEGURADO' );
             reade %kds ( k0hpol : 4 ) pahpol10;
           when ( peOrde = 'RAMAPOLIZA' );
             reade %kds ( k0hpol : 4 ) pahpol11;
         endsl;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;


         dou ( ( poanua >= peFdes ) and ( poanua <= peFhas ) );
           select;
             when ( peOrde = 'ANUALIDAD' );
               readpe %kds ( k0hpol : 4 ) pahpol01;
             when ( peOrde = 'ASEGURADO' );
               readpe %kds ( k0hpol : 4 ) pahpol10;
             when ( peOrde = 'RAMAPOLIZA' );
               readpe %kds ( k0hpol : 4 ) pahpol11;
           endsl;

           if finArc;
             leavesr;
           endif;

         enddo;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

         select;
           when ( peOrde = 'ANUALIDAD' );
             setll %kds( k0hpol : 4 ) pahpol01;
           when ( peOrde = 'ASEGURADO' );
             setll %kds( k0hpol : 4 ) pahpol10;
           when ( peOrde = 'RAMAPOLIZA' );
             setll %kds( k0hpol : 4 ) pahpol11;
         endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

         if ( peRoll = 'R' );
           exsr retArc;
           dow ( ( not finArc ) and ( @@cant > 0 ) );
             if Muestra();
               @@cant -= 1;
             endif;
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

         pReg = *On;

         pePreg.pofech = poanua;
         pePreg.porama = porama;
         pePreg.popoli = popoli;
         pePreg.pocert = pocert;
         pePreg.poarcd = poarcd;
         pePreg.pospol = pospol;
         pePreg.poarse = poarse;
         pePreg.pooper = pooper;
         pePreg.poasno = poasno;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.pofech = poanua;
         peUreg.porama = porama;
         peUreg.popoli = popoli;
         peUreg.pocert = pocert;
         peUreg.poarcd = poarcd;
         peUreg.pospol = pospol;
         peUreg.poarse = poarse;
         peUreg.pooper = pooper;
         peUreg.poasno = poasno;

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
           when ( peOrde = 'ANUALIDAD' );
             return %eof ( pahpol01 );
           when ( peOrde = 'ASEGURADO' );
             return %eof ( pahpol10 );
           when ( peOrde = 'RAMAPOLIZA' );
             return %eof ( pahpol11 );
         endsl;

     P finArc          E
      **********************************************************************
      * Muestra: Valida si el registro debe mostrarse.                     *
      * Retorna *On / *Off                                                 *
      **********************************************************************
     P Muestra         B
     D Muestra         pi              n

           chain poarcd set6303;
           if not %found;
              t@3ccuo = 99;
           endif;

           DXP021( poempr
                 : posucu
                 : poarcd
                 : pospol
                 : *year
                 : *month
                 : *day
                 : peAnul
                 : *blanks );
           SP0079B( poarcd
                  : pospol
                  : %dec(%date():*iso)
                  : cuCant            );
           @@prcp = 0;
           if cuCant > t@3ccuo;
              @@prcp = 1;
           endif;
          k1havr.vrempr = poempr;
          k1havr.vrsucu = posucu;
          k1havr.vrrama = porama;
          k1havr.vrpoli = popoli;
          setll %kds(k1havr) pahavr;

          k1wrn1.pwarcd = poarcd;
          k1wrn1.pwspol = pospol;
          k1wrn1.pwrama = porama;
          k1wrn1.pwarse = poarse;
          k1wrn1.pwoper = pooper;
          setll %kds(k1wrn1) pawrn1;
          if not %equal;
             pwmarc = 'S';
             pwmart = 'S';
          endif;

          sini_tot = *off;
          k1hscd.cdempr = poempr;
          k1hscd.cdsucu = posucu;
          k1hscd.cdrama = porama;
          k1hscd.cdpoli = popoli;
          setll %kds(k1hscd:4) pahscd03;
          reade %kds(k1hscd:4) pahscd03;
          dow not %eof;

           if cdsini <> 0;

              k1hsbe.beempr = cdempr;
              k1hsbe.besucu = cdsucu;
              k1hsbe.berama = cdrama;
              k1hsbe.besini = cdsini;
              k1hsbe.benops = cdnops;
              setll %kds(k1hsbe:5) pahsbe;
              reade %kds(k1hsbe:5) pahsbe;
              dow not %eof;

                  k1hsb1.b1empr = beempr;
                  k1hsb1.b1sucu = besucu;
                  k1hsb1.b1rama = berama;
                  k1hsb1.b1sini = besini;
                  k1hsb1.b1nops = benops;
                  k1hsb1.b1poco = bepoco;
                  k1hsb1.b1paco = bepaco;
                  k1hsb1.b1riec = beriec;
                  k1hsb1.b1xcob = bexcob;
                  k1hsb1.b1nrdf = benrdf;
                  k1hsb1.b1sebe = besebe;
                  setll %kds(k1hsb1:11) pahsb1;
                  reade %kds(k1hsb1:11) pahsb1;
                  if not %eof;
                     if b1hecg = '5' or
                        b1hecg = '7' or
                        b1hecg = '9';
                        sini_tot = *on;
                     endif;
                  endif;

               reade %kds(k1hsbe:5) pahsbe;
              enddo;

           endif;

           reade %kds(k1hscd:4) pahscd03;
          enddo;

        if peAnul = ' '       and
           @@prcp = 0         and
           not %equal(pahavr) and
           pwmarc = 'S'       and
           pwmart = 'S'       and
           sini_tot = *off    and
           poponu = 0;

           return *on;

        endif;

        return *off;
     P Muestra         E
