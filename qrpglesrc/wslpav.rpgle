     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H datfmt(*iso)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLPAV  : Tareas generales.                                  *
      *           WebService - Retorna listas de Pólizas a Vencer    *
      *                        de un Intermediario                   *
      *                                                              *
      * ------------------------------------------------------------ *
      * Ruben Vinent                                   *08-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * SGF 20/11/2015 - Agrego llamada a WSPCSP y retorno el        *
      *                  resultado como parte de la respuesta.       *
      * GIO 20/07/2018 - Se recompila por cambio en pahpol01         *
      *                                                              *
      * ************************************************************ *
     Fpahpol01  if   e           k disk
     Fset001    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

      /copy './qcpybooks/spvfec_h.rpgle'

     D WSLPAV          pr                  ExtPgm('WSLPAV')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keypav_t) const
     D   pePreg                            likeds(keypav_t)
     D   peUreg                            likeds(keypav_t)
     D   peLpol                            likeds(pahpol_t) dim(99)
     D   peLpolC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPAV          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1a   const
     D   pePosi                            likeds(keypav_t) const
     D   pePreg                            likeds(keypav_t)
     D   peUreg                            likeds(keypav_t)
     D   peLpol                            likeds(pahpol_t) dim(99)
     D   peLpolC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

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

     D k1hpol          ds                  likerec(p1hpol:*key)

     D POLIZAS         ds                  likerec(p1hpol)
     D @@repl          s          65535a
     D @@leng          s             10i 0
     D @@cant          s             10i 0
     D wfdes           s               d
     D wfhas           s               d
     D wfanua          s              8  0
     D wfanua6         s              6  0
     D wfanua6D        s               d
     D fecdesde        s              8  0
     D fechasta        s              8  0
     D @@anul          s              1a

     D @@more          s               n

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

      *- Valido fechas desde hasta


         fecdesde = %dec(peposi.pofdes);

         if fecdesde <= 00010101;
            wfdes = %date();
           else;
            test(de) *iso fecdesde;
         if not %error;
            wfdes = peposi.pofdes;
         endif;
         endif;


         fechasta = %dec(peposi.pofhas);

         if fechasta <= 00010101;
            wfhas = %date();
           else;
            test(de) *iso fechasta;
         if not %error;
            wfhas = peposi.pofhas;
         endif;
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
      *
      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       dow ( ( not finArc ) and ( peLpolC < @@cant ) );

         @@anul = ' ';
         DXP021( polizas.poempr
               : polizas.posucu
               : polizas.poarcd
               : polizas.pospol
               : *year
               : *month
               : *day
               : @@anul
               : *blanks        );


         // ------------------------------
         // Muevo Datos directamente de PAHPOL
         // ------------------------------

       if  polizas.poanua  >= wfdes        and
           polizas.poanua  <= wfhas        and
           polizas.poponu  <> 0;

         peLpolC += 1;

       if peLpolC = 1;
         exsr priReg;
       endif;

         peLpol( peLpolC ).poempr = polizas.poempr;
         peLpol( peLpolC ).posucu = polizas.posucu;
         peLpol( peLpolC ).porama = polizas.porama;
         peLpol( peLpolC ).popoli = polizas.popoli;
         peLpol( peLpolC ).pocert = polizas.pocert;
         peLpol( peLpolC ).poarcd = polizas.poarcd;
         peLpol( peLpolC ).pospol = polizas.pospol;
         peLpol( peLpolC ).poarse = polizas.poarse;
         peLpol( peLpolC ).pooper = polizas.pooper;
         peLpol( peLpolC ).ponivt = polizas.ponivt;
         peLpol( peLpolC ).ponivc = polizas.ponivc;
         peLpol( peLpolC ).poasen = polizas.poasen;
         peLpol( peLpolC ).pofemi = polizas.pofemi;
         peLpol( peLpolC ).pofdes = polizas.pofdes;
         peLpol( peLpolC ).pofhas = polizas.pofhas;
         peLpol( peLpolC ).pohafa = polizas.pohafa;
         peLpol( peLpolC ).poanua = polizas.poanua;
         peLpol( peLpolC ).pomone = polizas.pomone;
         peLpol( peLpolC ).poprim = polizas.poprim;
         peLpol( peLpolC ).pobpri = polizas.pobpri;
         peLpol( peLpolC ).porefi = polizas.porefi;
         peLpol( peLpolC ).poread = polizas.poread;
         peLpol( peLpolC ).podere = polizas.podere;
         peLpol( peLpolC ).poseri = polizas.poseri;
         peLpol( peLpolC ).poseem = polizas.poseem;
         peLpol( peLpolC ).poimpi = polizas.poimpi;
         peLpol( peLpolC ).posers = polizas.posers;
         peLpol( peLpolC ).potssn = polizas.potssn;
         peLpol( peLpolC ).poipr1 = polizas.poipr1;
         peLpol( peLpolC ).poipr3 = polizas.poipr3;
         peLpol( peLpolC ).poipr4 = polizas.poipr4;
         peLpol( peLpolC ).poipr2 = polizas.poipr2;
         peLpol( peLpolC ).poipr5 = polizas.poipr5;
         peLpol( peLpolC ).poipr6 = polizas.poipr6;
         peLpol( peLpolC ).poipr7 = polizas.poipr7;
         peLpol( peLpolC ).poipr8 = polizas.poipr8;
         peLpol( peLpolC ).poipr9 = polizas.poipr9;
         peLpol( peLpolC ).poprem = polizas.poprem;
         peLpol( peLpolC ).poprco = polizas.poprco;
         peLpol( peLpolC ).ponivt1 = polizas.ponivt1;
         peLpol( peLpolC ).ponivc1 = polizas.ponivc1;
         peLpol( peLpolC ).pocopr1 = polizas.pocopr1;
         peLpol( peLpolC ).ponivt2 = polizas.ponivt2;
         peLpol( peLpolC ).ponivc2 = polizas.ponivc2;
         peLpol( peLpolC ).pocopr2 = polizas.pocopr2;
         peLpol( peLpolC ).ponivt3 = polizas.ponivt3;
         peLpol( peLpolC ).ponivc3 = polizas.ponivc3;
         peLpol( peLpolC ).pocopr3 = polizas.pocopr3;
         peLpol( peLpolC ).ponivt4 = polizas.ponivt4;
         peLpol( peLpolC ).ponivc4 = polizas.ponivc4;
         peLpol( peLpolC ).pocopr4 = polizas.pocopr4;
         peLpol( peLpolC ).ponivt5 = polizas.ponivt5;
         peLpol( peLpolC ).ponivc5 = polizas.ponivc5;
         peLpol( peLpolC ).pocopr5 = polizas.pocopr5;
         peLpol( peLpolC ).ponivt6 = polizas.ponivt6;
         peLpol( peLpolC ).ponivc6   = polizas.ponivc6;
         peLpol( peLpolC ).pocopr6   = polizas.pocopr6;
         peLpol( peLpolC ).ponivt7   = polizas.ponivt7;
         peLpol( peLpolC ).ponivc7   = polizas.ponivc7;
         peLpol( peLpolC ).pocopr7   = polizas.pocopr7;
         peLpol( peLpolC ).ponivt8   = polizas.ponivt8;
         peLpol( peLpolC ).ponivc8   = polizas.ponivc8;
         peLpol( peLpolC ).pocopr8   = polizas.pocopr8;
         peLpol( peLpolC ).ponivt9   = polizas.ponivt9;
         peLpol( peLpolC ).ponivc9   = polizas.ponivc9;
         peLpol( peLpolC ).pocopr9   = polizas.pocopr9;
         peLpol( peLpolC ).pomarsin  = polizas.pomarsin;
         peLpol( peLpolC ).popoan    = polizas.popoan;
         peLpol( peLpolC ).poponu    = polizas.poponu;
         peLpol( peLpolC ).popatente = polizas.popatente;
         peLpol( peLpolC ).podesanu  = polizas.podesanu;
         peLpol( peLpolC ).pomar1    = polizas.pomar1;
         peLpol( peLpolC ).pomar2    = polizas.pomar2;
         peLpol( peLpolC ).pomar3    = polizas.pomar3;
         peLpol( peLpolC ).pomar4    = polizas.pomar4;
         peLpol( peLpolC ).pomar5    = polizas.pomar5;
         peLpol( peLpolC ).pomar6    = polizas.pomar6;
         peLpol( peLpolC ).pomar7    = polizas.pomar7;
         peLpol( peLpolC ).pomar8    = polizas.pomar8;
         peLpol( peLpolC ).pomar9    = polizas.pomar9;
         peLpol( peLpolC ).pofemianu = polizas.pofemianu;
         peLpol( peLpolC ).pofemireh = polizas.pofemireh;
         peLpol( peLpolC ).pots20    = *Zeros;
         peLpol( peLpolC ).ponctz    = polizas.ponctz;
         peLpol( peLpolC ).poncbu    = polizas.poncbu;
         peLpol( peLpolC ).poxrea    = polizas.poxrea;
         peLpol( peLpolC ).pointeg   = polizas.pointeg;
         peLpol( peLpolC ).pocobf    = polizas.pocobf;
         peLpol( peLpolC ).poemcn    = polizas.poemcn;
         peLpol( peLpolC ).potiou    = polizas.potiou;
         peLpol( peLpolC ).postou    = polizas.postou;
         peLpol( peLpolC ).postos    = polizas.postos;
         peLpol( peLpolC ).podsop    = polizas.podsop;
         peLpol( peLpolC ).poxref    = polizas.poxref;
         peLpol( peLpolC ).popimi    = polizas.popimi;
         peLpol( peLpolC ).popsso    = polizas.popsso;
         peLpol( peLpolC ).popssn    = polizas.popssn;
         peLpol( peLpolC ).popivi    = polizas.popivi;
         peLpol( peLpolC ).popivn    = polizas.popivn;
         peLpol( peLpolC ).popivr    = polizas.popivr;
         peLpol( peLpolC ).poasno    = polizas.poasno;

         chain polizas.porama set001;
         if not %found;
            t@ramd = *blanks;
            t@ramb = *blanks;
         endif;
         peLpol(peLpolC).poramd = t@ramd;
         peLpol(peLpolC).poramb = t@ramb;

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

         exsr borCom;

         exsr UltReg;

       endif;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( pahpol01 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       DXP021( polizas.poempr
             : polizas.posucu
             : polizas.poarcd
             : polizas.pospol
             : *year
             : *month
             : *day
             : @@anul
             : 'FIN'          );

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

             k1hpol.poempr = peBase.peEmpr;
             k1hpol.posucu = peBase.peSucu;
             k1hpol.ponivt = peBase.peNivt;
             k1hpol.ponivc = peBase.peNivc;
             k1hpol.porama = pePosi.porama;
             k1hpol.popoli = pePosi.popoli;
             k1hpol.poanua = pePosi.pofdes;
             k1hpol.pocert = pePosi.pocert;
             k1hpol.poarcd = pePosi.poarcd;
             k1hpol.pospol = pePosi.pospol;
             k1hpol.poarse = pePosi.poarse;
             k1hpol.pooper = pePosi.pooper;

          select;
           when ( peRoll = 'F' );
             setgt %kds ( k1hpol : 12 ) pahpol01;
           when ( peRoll = 'I' );
             setll %kds ( k1hpol : 12 ) pahpol01;
           when ( peRoll = 'R' );
             setll %kds ( k1hpol : 12 ) pahpol01;
          endsl;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

             reade %kds ( k1hpol : 4 ) pahpol01 polizas;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

             readpe %kds ( k1hpol : 4 ) pahpol01;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

             setll %kds( k1hpol : 12 ) pahpol01;

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

         pePreg.poanua = polizas.poanua;
         pePreg.porama = polizas.porama;
         pePreg.popoli = polizas.popoli;
         pePreg.pocert = polizas.pocert;
         pePreg.poarcd = polizas.poarcd;
         pePreg.pospol = polizas.pospol;
         pePreg.poarse = polizas.poarse;
         pePreg.pooper = polizas.pooper;
         pePreg.pofdes = pePosi.poFdes;
         pePreg.pofhas = pePosi.poFhas;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.poanua = polizas.poanua;
         peUreg.porama = polizas.porama;
         peUreg.popoli = polizas.popoli;
         peUreg.pocert = polizas.pocert;
         peUreg.poarcd = polizas.poarcd;
         peUreg.pospol = polizas.pospol;
         peUreg.poarse = polizas.poarse;
         peUreg.pooper = polizas.pooper;
         peUreg.pofdes = pePosi.poFdes;
         peUreg.pofhas = pePosi.poFhas;

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

             return %eof ( pahpol01 );

     P finArc          E

