     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt:*noshowcpy)
     H bnddir('HDIILE/HDIBDIR')
      * ********************************************************** *
      * COW313: Emision Automatica Desde Web                       *
      *         Completa CTW* para endosos.                        *
      * ---------------------------------------------------------- *
      * Sergio Fernandez                    *19-Mar-2019           *
      * ---------------------------------------------------------- *
      * LRG 26/06/2019: Se incorpora comision de nivel 6           *
      * JSN 13/09/2019: Se limpia la ds ultEd36.                   *
      * JSN 18/09/2019: Se agrega lectura en el archivo PAHET3     *
      *                 para grabar en CTWET3.                     *
      * ********************************************************** *
     Fctw001    uf a e           k disk
     Fctw001c   uf a e           k disk
     Fctweg3    uf a e           k disk
     Fctwet1    uf a e           k disk
     Fctwet4    uf a e           k disk
     Fctwet0    if   e           k disk
     Fctwetc01  if   e           k disk
     Fpahed0    if   e           k disk
     Fpahed3    if   e           k disk
     Fpahet9    if   e           k disk
     Fpahet002  if   e           k disk
     Fpahet402  if   e           k disk
     Fgnhdaf    if   e           k disk
     Fgntloc02  if   e           k disk
     Fpahet103  if   e           k disk
     Fpahet3    if   e           k disk

     D COW313          pr                  ExtPgm('COW313')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNit1                        1  0 const
     D  peNiv1                        5  0 const
     D  peNctw                        7  0 const

     D COW313          pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNit1                        1  0 const
     D  peNiv1                        5  0 const
     D  peNctw                        7  0 const

      /copy './qcpybooks/cowveh_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'

     D x               s             10i 0
     D peTiou          s              1  0
     D peStou          s              2  0
     D peStos          s              2  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@suas          s             15  2
     D @@come          s             15  6
     D @@mone          s              2a
     D @@asen          s              7  0
     D @@rpro          s              2  0
     D @@Sspo          s              3  0
     D @@Suop          s              3  0
     D @@Dswt3         ds                  likeds ( dsctwet3_t )
     D @@Dst3          ds                  likeds ( dspahet3_t ) dim( 999 )
     D @@Dst3C         s             10i 0
     D peBase          ds                  likeds(paramBase)

     D k1tloc          ds                  likerec(g1tloc02:*key)
     D k1hed0          ds                  likerec(p1hed0:*key)
     D k1hed3          ds                  likerec(p1hed3:*key)
     D k1het9          ds                  likerec(p1het9:*key)
     D k1het0          ds                  likerec(p1het002:*key)
     D k1wetc          ds                  likerec(c1wetc:*key)
     D k1het1          ds                  likerec(p1het1:*key)
     D k1w001          ds                  likerec(c1w001:*key)
     D k1weg3          ds                  likerec(c1weg3:*key)
     D k1wet1          ds                  likerec(c1wet1:*key)
     D k1wet0          ds                  likerec(c1wet0:*key)
     D k1het4          ds                  likerec(p1het4:*key)
     D ultEd0          ds                  likerec(p1hed0:*input)
     D ultEd3          ds                  likerec(p1hed3:*input)
     D ultEd36         ds                  likerec(p1hed3:*input)
     D k1yet3          ds                  likerec(p1het3:*key)

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     Ip1het3
     I              t3date                      txdate

      /free

       *inlr = *on;

       peBase.peEmpr = peEmpr;
       peBase.peSucu = peSucu;
       peBase.peNivt = peNivt;
       peBase.peNivc = peNivc;
       peBase.peNit1 = peNit1;
       peBase.peNiv1 = peNiv1;

       COWGRAI_getTipodeOperacion( peBase
                                 : peNctw
                                 : peTiou
                                 : peStou
                                 : peStos );
       // -----------------------------------------
       // Por ahora, cambio de vehículo.
       // Agregar más operaciones en el futuro
       // -----------------------------------------
       if peTiou <> 3 or peStos <> 4;
          return;
       endif;

       @@arcd = COWGRAI_getArticulo(peBase:peNctw);
       @@spol = COWGRAI_getSuperPolizaReno(peBase:peNctw);
       @@come = COWGRAI_getCotizacionDeMoneda(peBase:peNctw);
       @@mone = COWGRAI_monedaCotizacion(peBase:peNctw);

       @@asen = SPVSPO_getAsen( peEmpr
                              : peSucu
                              : @@arcd
                              : @@spol
                              : *omit  );
       chain @@asen gnhdaf;
       if %found;
          k1tloc.locopo = dfcopo;
          k1tloc.locops = dfcops;
          chain %kds(k1tloc:2) gntloc02;
          if %found;
             @@rpro = prrpro;
          endif;
       endif;

       // -----------------------------------------
       // Obtengo ultimo ED0
       // -----------------------------------------
       k1hed0.d0empr = peEmpr;
       k1hed0.d0sucu = peSucu;
       k1hed0.d0arcd = @@arcd;
       k1hed0.d0spol = @@spol;
       setgt %kds(k1hed0:4) pahed0;
       readpe %kds(k1hed0:4) pahed0 ultEd0;
       if %eof;
          return;
       endif;

       // -----------------------------------------
       // Obtengo ultimo ED3 (productor)
       // -----------------------------------------
       clear ultEd36;

       k1hed3.d3empr = peEmpr;
       k1hed3.d3sucu = peSucu;
       k1hed3.d3arcd = @@arcd;
       k1hed3.d3spol = @@spol;
       setgt %kds(k1hed3:4) pahed3;
       readpe %kds(k1hed3:4) pahed3 ultEd3;
       dow not %eof;
           select;
             when ultEd3.d3nivt = 1;
              leave;
             when ultEd3.d3nivt = 6;
              ultEd36 = ultEd3;
           endsl;
        readpe %kds(k1hed3:4) pahed3 ultEd3;
       enddo;

       // -----------------------------------------
       // Obtengo suma asegurada total
       // OJO a esta parte si alguna vez agregamos
       // otro tipo de endoso.
       // -----------------------------------------
       @@suas = 0;
       k1het9.t9empr = peEmpr;
       k1het9.t9sucu = peSucu;
       k1het9.t9arcd = @@arcd;
       k1het9.t9spol = @@spol;
       setll %kds(k1het9:4) pahet9;
       reade %kds(k1het9:4) pahet9;
       dow not %eof;
           k1het0.t0empr = t9empr;
           k1het0.t0sucu = t9sucu;
           k1het0.t0arcd = t9arcd;
           k1het0.t0spol = t9spol;
           k1het0.t0rama = t9rama;
           k1het0.t0arse = t9arse;
           k1het0.t0oper = t9oper;
           k1het0.t0poco = t9poco;
           k1het0.t0sspo = t9sspo;
           k1het0.t0suop = t9sspo;
           chain %kds(k1het0) pahet002;
           if %found;
              @@suas += t0vhvu;
           endif;
        reade %kds(k1het9:4) pahet9;
       enddo;

       // -----------------------------------------
       // Generar CTW001
       // -----------------------------------------
       k1hed0.d0sspo = ultEd0.d0sspo;
       setll %kds(k1hed0:5) pahed0;
       reade %kds(k1hed0:5) pahed0;
       dow not %eof;
           k1w001.w1empr = d0empr;
           k1w001.w1sucu = d0sucu;
           k1w001.w1nivt = peNivt;
           k1w001.w1nivc = peNivc;
           k1w001.w1nctw = peNctw;
           k1w001.w1rama = d0rama;
           setll %kds(k1w001) ctw001;
           if not %equal;
              w1empr = d0empr;
              w1sucu = d0sucu;
              w1nivt = peNivt;
              w1nivc = peNivc;
              w1nctw = peNctw;
              w1rama = d0rama;
              w1xref = ultEd0.d0xref;
              w1pimi = ultEd0.d0pimi;
              w1psso = ultEd0.d0psso;
              w1pssn = ultEd0.d0pssn;
              w1pivi = ultEd0.d0pivi;
              w1pivn = ultEd0.d0pivn;
              w1pivr = ultEd0.d0pivr;
              w1vacc = 0;
              write c1w001;

              setll %kds(k1w001) ctw001c;
              if not %equal;
                 w1empr = d0empr;
                 w1sucu = d0sucu;
                 w1nivt = peNivt;
                 w1nivc = peNivc;
                 w1nctw = peNctw;
                 w1rama = d0rama;
                 w1xrea = ultEd0.d0xrea;
                 w1xopr = ultEd3.d3xopr;
                 write c1w001c;
                 if ultEd36.d3xopr <> 0;
                   w1nivt = ultEd36.d3nivt;
                   w1nivc = ultEd36.d3nivc;
                   w1xopr = 0;
                   w1copr = 0;
                   write c1w001c;
                 endif;
              endif;

              // ---------------------------------
              // OJO esto cuando mezclemos autos
              // con otras ramas
              // ---------------------------------
              k1weg3.g3empr = peEmpr;
              k1weg3.g3sucu = peSucu;
              k1weg3.g3nivt = peNivt;
              k1weg3.g3nivc = peNivc;
              k1weg3.g3nctw = peNctw;
              k1weg3.g3rama = w1rama;
              k1weg3.g3arse = 1;
              k1weg3.g3rpro = @@rpro;
              setll %kds(k1weg3) ctweg3;
              if not %equal;
                 g3empr = peEmpr;
                 g3sucu = peSucu;
                 g3nivt = peNivt;
                 g3nivc = peNivc;
                 g3nctw = peNctw;
                 g3rama = w1rama;
                 g3arse = 1;
                 g3rpro = @@rpro;
                 g3mone = @@mone;
                 g3come = @@come;
                 g3suas = @@suas;
                 g3sast = @@suas;
                 write c1weg3;
              endif;

           endif;
        reade %kds(k1hed0:5) pahed0;
       enddo;

       k1wet0.t0empr = peEmpr;
       k1wet0.t0sucu = peSucu;
       k1wet0.t0nivt = peNivt;
       k1wet0.t0nivc = peNivc;
       k1wet0.t0nctw = peNctw;
       setll %kds(k1wet0:5) ctwet0;
       reade %kds(k1wet0:5) ctwet0;
       dow not %eof;
           k1het1.t1empr = t0empr;
           k1het1.t1sucu = t0sucu;
           k1het1.t1arcd = @@arcd;
           k1het1.t1spol = @@spol;
           k1het1.t1rama = t0rama;
           k1het1.t1poco = t0poco;
           setgt  %kds(k1het1:6) pahet103;
           readpe %kds(k1het1:6) pahet103;
           k1het1.t1suop = t1suop;
           k1het1.t1sspo = t1sspo;
           setll %kds(k1het1:8) pahet103;
           reade %kds(k1het1:8) pahet103;
           dow not %eof;
               t1nivt = peNivt;
               t1nivc = peNivc;
               t1nctw = peNctw;
               write c1wet1;
            reade %kds(k1het1:8) pahet103;
           enddo;
           k1wetc.t0empr = peEmpr;
           k1wetc.t0sucu = peSucu;
           k1wetc.t0nivt = peNivt;
           k1wetc.t0nivc = peNivc;
           k1wetc.t0nctw = peNctw;
           k1wetc.t0rama = t0rama;
           k1wetc.t0arse = 1;
           k1wetc.t0poco = t0poco;
           chain %kds(k1wetc:8) ctwetc01;
           if not %found;
              t0cobl = *blanks;
           endif;
           k1het4.t4empr = t0empr;
           k1het4.t4sucu = t0sucu;
           k1het4.t4arcd = @@arcd;
           k1het4.t4spol = @@spol;
           k1het4.t4poco = t0poco;
           setgt  %kds(k1het4:5) pahet402;
           readpe %kds(k1het4:5) pahet402;
           k1het4.t4suop = t4suop;
           setll %kds(k1het4:6) pahet402;
           reade %kds(k1het4:6) pahet402;
           dow not %eof;
               t4nivt = peNivt;
               t4nivc = peNivc;
               t4nctw = peNctw;
               t4cobl = t0cobl;
               write c1wet4;
            reade %kds(k1het4:6) pahet402;
           enddo;
        reade %kds(k1wet0:5) ctwet0;
       enddo;

       // -----------------------------------------
       // Generar CTWET3
       // -----------------------------------------

       clear @@Sspo;
       clear @@Suop;
       clear @@Dst3;
       clear @@Dst3C;

       if SPVVEH_getUltimoSuplemento( peEmpr
                                    : peSucu
                                    : @@Arcd
                                    : @@Spol
                                    : t0Rama
                                    : t0Arse
                                    : t0Poco
                                    : @@Sspo
                                    : @@Suop );

         if SPVVEH_getPahet3( peEmpr
                            : peSucu
                            : @@Arcd
                            : @@Spol
                            : t0Rama
                            : t0Arse
                            : t0Poco
                            : @@Sspo
                            : @@Suop
                            : t0Oper
                            : *omit
                            : *omit
                            : @@Dst3
                            : @@Dst3C );

           for x = 1 to @@Dst3C;

             @@Dswt3.t3Empr = @@Dst3(x).t3Empr;
             @@Dswt3.t3Sucu = @@Dst3(x).t3Sucu;
             @@Dswt3.t3Nivt = peNivt;
             @@Dswt3.t3Nivc = peNivc;
             @@Dswt3.t3Nctw = peNctw;
             @@Dswt3.t3Rama = @@Dst3(x).t3Rama;
             @@Dswt3.t3Arse = @@Dst3(x).t3Arse;
             @@Dswt3.t3Poco = @@Dst3(x).t3Poco;
             @@Dswt3.t3Taaj = @@Dst3(x).t3Taaj;
             @@Dswt3.t3Cosg = @@Dst3(x).t3Cosg;
             @@Dswt3.t3Tiaj = @@Dst3(x).t3Tiaj;
             @@Dswt3.t3Tiac = @@Dst3(x).t3Tiac;
             @@Dswt3.t3Vefa = @@Dst3(x).t3Vefa;
             @@Dswt3.t3Corc = @@Dst3(x).t3Corc;
             @@Dswt3.t3Coca = @@Dst3(x).t3Coca;
             @@Dswt3.t3Mar1 = @@Dst3(x).t3Mar1;
             @@Dswt3.t3Mar2 = @@Dst3(x).t3Mar2;
             @@Dswt3.t3Mar3 = @@Dst3(x).t3Mar3;
             @@Dswt3.t3Mar4 = @@Dst3(x).t3Mar4;
             @@Dswt3.t3Mar5 = @@Dst3(x).t3Mar5;
             @@Dswt3.t3Strg = @@Dst3(x).t3Strg;
             @@Dswt3.t3Cant = @@Dst3(x).t3Cant;
             @@Dswt3.t3user = @PsDs.CurUsr;
             @@Dswt3.t3date = udate;
             @@Dswt3.t3time = %dec(%time():*iso);

             if COWVEH_setCtwet3( @@Dswt3 );

             endif;

           endfor;
         endif;
       endif;

       return;

      /end-free
