     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************** *
      * WSLVHP : WebService - Retorna Lista de Vehiculos de una Póliza.*
      * -------------------------------------------------------------- *
      * CSz 20/04/2015 - Creacion del programa                         *
      * -------------------------------------------------------------- *
      * Modificaciones:                                                *
      * SFA 23/04/2015 - Agrego validacion de parametros base          *
      * SGF 07/05/2015 - Tomar todos desde los archivos de GAUS.       *
      *                  No hay paginado. No tiene sentido: la flota   *
      *                  más grande vigente es de 54 veh y la flota    *
      *                  más grande emitida en los últimos 3 años tiene*
      *                  79 (y es la misma, sólo que con los años se   *
      *                  redujo la cantidad de autos).                 *
      * SFA 14/07/2016 - Cambio PAHET995 por PAHET994                  *
      * SGF 21/06/2019 - Franquicia desde ultimo endoso y no desde ET9.*
      * SGF 20/12/2019 - Aumento entradas de array.                    *
      * SGF 07/04/2022 - SPASIMO.                                      *
      *                                                                *
      * ************************************************************** *
     Fset001    if   e           k disk
     Fpahet994  if   e           k disk
     Fpahet995  if   e           k disk    rename(p1het9:p1het995)
     Fpahet002  if   e           k disk
     Fset201    if   e           k disk
     Fset202    if   e           k disk
     Fset203    if   e           k disk
     Fset205    if   e           k disk
     Fset210    if   e           k disk    prefix(tt:2)
     Fset211    if   e           k disk    prefix(tu:2)
     Fset215    if   e           k disk
     Fset225    if   e           k disk
     Fpahscd11  if   e           k disk
     Fpahsbe    if   e           k disk
     Fpahsb1    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fpahed9    if   e           k disk
     Fpahec0    if   e           k disk
     Fset208    if   e           k disk
     Fpahed004  if   e           k disk
     Fpahed003  if   e           k disk
     Fpahet4    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLVHP          pr                  ExtPgm('WSLVHP')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peLveh                            likeds(pahaut_t) dim(500)
     D   peLvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLVHP          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peLveh                            likeds(pahaut_t) dim(500)
     D   peLvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SPREBRV2        pr                  ExtPgm('SPREBRV2')
     D   peAsen                       7  0 const
     D   peNmat                      25a   const
     D   peRebr                       1  0
     D   peSini                       7  0
     D   peFden                       8  0
     D   peMar2                       1a

     D SPASIMO         pr                  extpgm('SPASIMO')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peAmot                        1n

     D inAut           ds                  likeds(pahaut_t)

     D k1hed0          ds                  likerec(p1hed004 : *key)
     D k2hed0          ds                  likerec(p1hed003 : *key)
     D k1het9          ds                  likerec(p1het9   : *key)
     D k2het9          ds                  likerec(p1het995 : *key)
     D k1het0          ds                  likerec(p1het002 : *key)
     D k1het4          ds                  likerec(p1het4   : *key)
     D k1hscd          ds                  likerec(p1hscd11 : *key)
     D k1hsbe          ds                  likerec(p1hsbe   : *key)
     D k1hsb1          ds                  likerec(p1hsb1   : *key)
     D k1t215          ds                  likerec(s1t215   : *key)
     D k1hed9          ds                  likerec(p1hed9   : *key)
     D k1hec0          ds                  likerec(p1hec0   : *key)

     D @@Repl          s          65535a
     D hoy             s              8  0
     D fecsb1          s              8  0
     D peRebr          s              1  0
     D peSini          s              7  0
     D peFden          s              8  0
     D @prrc           s             15  2
     D @prca           s             15  2
     D svsspo          s              3  0
     D peSino          s              1n

       *inLr = *On;

       hoy = (*year * 10000)
           + (*month *  100)
           +  *day;

       clear peErro;
       clear peMsgs;
       clear peLveh;
       clear peLvehC;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       chain peRama set001;
 b1    if not %found (set001);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %editw(peRama:'0 ')
                       : %len(%editw(peRama:'0 ')) );
          peErro = -1;
          return;
       endif;

 b2    if t@rame <> 4;
          @@Repl = %editw( peRama : '0 ' ) + %editw(pePoli : '0      ' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0003'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peErro = -1;
          return;
 x2    endif;

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       chain %kds(k1hed0:4) pahed004;
       if not %found;
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peErro = -1;
          return;
       endif;

       k2het9.t9empr = peBase.peEmpr;
       k2het9.t9sucu = peBase.peSucu;
       k2het9.t9rama = peRama;
       k2het9.t9poli = pePoli;
       k2het9.t9spol = peSpol;

       setll %kds ( k2het9 : 5 ) pahet995;
       if not %equal;
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0002'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peErro = -1;
          return;
       endif;

       k1het9.t9empr = peBase.peEmpr;
       k1het9.t9sucu = peBase.peSucu;
       k1het9.t9rama = peRama;
       k1het9.t9poli = pePoli;
       k1het9.t9arcd = d0arcd;
       k1het9.t9spol = peSpol;

       setll %kds ( k1het9 : 6 ) pahet994;
       reade %kds ( k1het9 : 6 ) pahet994;

 b2    dow ( not %eof (pahet994) ) and ( peLvehC < 500 );

         peLvehC += 1;

         k1hed9.d9empr = cdempr;
         k1hed9.d9sucu = cdsucu;
         k1hed9.d9arcd = cdarcd;
         k1hed9.d9spol = cdspol;
         setll %kds(k1hed9:4) pahed9;

         k1hec0.c0empr = t9empr;
         k1hec0.c0sucu = t9sucu;
         k1hec0.c0arcd = t9arcd;
         k1hec0.c0spol = t9spol;
         chain %kds(k1hec0:4) pahec0;

         // ----------------------------
         // Datos directos de ET9
         // ----------------------------
         peLveh(peLvehC).auempr = t9empr;
         peLveh(peLvehC).ausucu = t9sucu;
         peLveh(peLvehC).aurama = t9rama;
         peLveh(peLvehC).aupoli = t9poli;
         peLveh(peLvehC).aupoco = t9poco;
         if %equal(pahed9);
            peLveh(peLvehC).aucert = t9spol;
          else;
            peLveh(peLvehC).aucert = 0;
         endif;
         peLveh(peLvehC).auarcd = t9arcd;
         peLveh(peLvehC).auspol = t9spol;
         peLveh(peLvehC).auarse = t9arse;
         peLveh(peLvehC).auoper = t9oper;
         peLveh(peLvehC).auvhmc = t9vhmc;
         peLveh(peLvehC).auvhmo = t9vhmo;
         peLveh(peLvehC).auvhcs = t9vhcs;
         peLveh(peLvehC).auvhca = t9vhca;
         peLveh(peLvehC).auvhv1 = t9vhv1;
         peLveh(peLvehC).auvhv2 = t9vhv2;
         peLveh(peLvehC).auvhcr = t9vhcr;
         peLveh(peLvehC).auvhct = t9vhct;
         peLveh(peLvehC).auvhuv = t9vhuv;
         peLveh(peLvehC).auvhan = t9vhaÑ;
         peLveh(peLvehC).auvhni = t9vhni;
         if t9nmat <> '-';
            peLveh(peLvehC).aupatente = t9nmat;
          else;
            peLveh(peLvehC).aupatente = 'A/D';
         endif;
         peLveh(peLvehC).aumoto = t9moto;
         peLveh(peLvehC).auchas = t9chas;
         peLveh(peLvehC).ausuin = t9suin;
         peLveh(peLvehC).auainn = t9ainn;
         peLveh(peLvehC).auminn = t9minn;
         peLveh(peLvehC).audinn = t9dinn;
         peLveh(peLvehC).ausuen = t9suen;
         peLveh(peLvehC).auaegn = t9aegn;
         peLveh(peLvehC).aumegn = t9megn;
         peLveh(peLvehC).audegn = t9degn;
         peLveh(peLvehC).auruta = t9ruta;
         peLveh(peLvehC).aunmer = t9nmer;
         peLveh(peLvehC).auacrc = t9acrc;
         peLveh(peLvehC).auts20 = 0;
         peLveh(peLvehC).auifra = t9ifra;
         peLveh(peLvehC).aumar4 = t9mtdf;

         // ----------------------------
         // Datos desde ultimo ET0
         // ----------------------------
         k1het0.t0empr = t9empr;
         k1het0.t0sucu = t9sucu;
         k1het0.t0arcd = t9arcd;
         k1het0.t0spol = t9spol;
         k1het0.t0rama = t9rama;
         k1het0.t0arse = t9arse;
         k1het0.t0oper = t9oper;
         k1het0.t0poco = t9poco;
         setll %kds(k1het0:8) pahet002;
         reade %kds(k1het0:8) pahet002;
         if not %eof;
            peLveh(peLvehC).auvhvu = t0vhvu;
            peLveh(peLvehC).auvh0k = t0vh0k;
            peLveh(peLvehC).aurcle = t0rcle;
            peLveh(peLvehC).aurcco = t0rcco;
            peLveh(peLvehC).aurcac = t0rcac;
            peLveh(peLvehC).aulrce = t0lrce;
            peLveh(peLvehC).ausaap = t0saap;
            peLveh(peLvehC).aucobl = t0cobl;
            peLveh(peLvehC).auclaj = t0claj;
            peLveh(peLvehC).aucfas = t0cfas;
            peLveh(peLvehC).autarc = t0tarc;
            peLveh(peLvehC).autair = t0tair;
            peLveh(peLvehC).auscta = t0scta;
            peLveh(peLvehC).auaver = t0mar1;
            peLveh(peLvehC).auctre = t0ctre;
            peLveh(peLvehC).auifra = t0ifra;
         endif;

         // ----------------------------
         // Descripciones
         // ----------------------------
         chain peLveh(peLvehC).auvhmc set201;
         if %found;
            peLveh(peLvehC).auvhmd = t@vhmd;
         endif;

         chain peLveh(peLvehC).auvhmo set202;
         if %found;
            peLveh(peLvehC).auvhdm = t@vhdm;
         endif;

         chain peLveh(peLvehC).auvhcs set203;
         if %found;
            peLveh(peLvehC).auvhds = t@vhds;
         endif;

         k1t215.t@vhca = peLveh(peLvehC).auvhca;
         k1t215.t@vhv1 = peLveh(peLvehC).auvhv1;
         k1t215.t@vhv2 = peLveh(peLvehC).auvhv2;
         chain %kds(k1t215:3) set215;
         if %found;
            peLveh(peLvehC).aucvde = t@cvde;
         endif;

         chain peLveh(peLvehC).auvhcr set205;
         if %found;
            peLveh(peLvehC).auvhcd = t@vhcd;
         endif;

         chain peLveh(peLvehC).auvhct set210;
         if %found;
            peLveh(peLvehC).auvhdt = ttvhdt;
         endif;

         chain peLveh(peLvehC).auvhuv set211;
         if %found;
            peLveh(peLvehC).auvhdu = tuvhdu;
         endif;

         chain peLveh(peLvehC).aucobl set225;
         if %found;
            peLveh(peLvehC).aucobd = t@cobd;
         endif;

         chain peLveh(peLvehC).auacrc gnhdaf;
         if %found;
            peLveh(peLvehC).aunomb = dfnomb;
         endif;

         if peLveh(peLvehC).aumar4 <> *blanks;
            chain peLveh(peLvehC).aumar4 set208;
            if %found;
               peLveh(peLvehC).auvhdt = t@mtdd;
            endif;
         endif;

         SPREBRV2( c0asen
                 : t9nmat
                 : peRebr
                 : peSini
                 : peFden
                 : peLveh(peLvehC).aumar2 );

         peLveh(peLvehC).aurebr = peRebr;
         peLveh(peLvehC).ausini = peSini;
         peLveh(peLvehC).aufden = peFden;

         peLveh(peLvehC).aumar1 = *off;
         k1hscd.cdempr = t9empr;
         k1hscd.cdsucu = t9sucu;
         k1hscd.cdarcd = t9arcd;
         k1hscd.cdspol = t9spol;
         setll %kds(k1hscd:4) pahscd11;
         reade %kds(k1hscd:4) pahscd11;
         dow not %eof;
           k1hsbe.beempr = cdempr;
           k1hsbe.besucu = cdsucu;
           k1hsbe.berama = cdrama;
           k1hsbe.besini = cdsini;
           k1hsbe.benops = cdnops;
           k1hsbe.bepoco = t9poco;
           setll %kds(k1hsbe:6) pahsbe;
           reade %kds(k1hsbe:6) pahsbe;
           dow not %eof;
              if (bemar2 = '1');
                 k1hsb1.b1empr = beempr;
                 k1hsb1.b1sucu = besucu;
                 k1hsb1.b1rama = berama;
                 k1hsb1.b1sini = besini;
                 k1hsb1.b1nops = benops;
                 k1hsb1.b1poco = bepoco;
                 k1hsb1.b1paco = bepaco;
                 k1hsb1.b1riec = beriec;
                 k1hsb1.b1xcob = bexcob;
                 k1hsb1.b1nrdf = c0asen;
                 setll %kds(k1hsb1:10) pahsb1;
                 reade %kds(k1hsb1:10) pahsb1;
                 dow not %eof;
                     fecsb1 = (b1fema * 10000)
                            + (b1femm *   100)
                            +  b1femd;
                     if fecsb1 <= hoy;
                        if b1hecg = '5' or
                           b1hecg = '7' or
                           b1hecg = '9';
                           peLveh(peLvehC).aumar1 = *on;
                           leave;
                        endif;
                     endif;
                  reade %kds(k1hsb1:10) pahsb1;
                 enddo;
              endif;
              if peLveh(peLvehC).aumar1 = *on;
                 leave;
              endif;
            reade %kds(k1hsbe:6) pahsbe;
           enddo;
           if peLveh(peLvehC).aumar1 = *on;
              leave;
           endif;
          reade %kds(k1hscd:4) pahscd11;
         enddo;

         if t9vhv2 = 5 or t9vhv2 = 9;
            peLveh(peLvehC).aumar5 = 'S';
          else;
            peLveh(peLvehC).aumar5 = 'N';
         endif;

         k1het4.t4empr = t0empr;
         k1het4.t4sucu = t0sucu;
         k1het4.t4arcd = t0arcd;
         k1het4.t4spol = t0spol;
         k1het4.t4sspo = t0sspo;
         k1het4.t4rama = t0rama;
         k1het4.t4arse = t0arse;
         k1het4.t4oper = t0oper;
         k1het4.t4suop = t0suop;
         k1het4.t4poco = t0poco;
         k1het4.t4ccbp = 997;
         setll %kds(k1het4) pahet4;
         if %equal;
            peLveh(peLvehC).aumar3 = 'S';
          else;
            peLveh(peLvehC).aumar3 = 'N';
         endif;

         // ------------------------------
         // Asistencia Técnica y mecánica
         // ------------------------------
         if ( t9vhca = 1 or
              t9vhca = 4 or
              t9vhca = 5 );
            peLveh(peLvehC).auatec = 'SI';
            peLveh(peLvehC).auamec = 'SI';
          else;
            peLveh(peLvehC).auatec = 'NO';
            peLveh(peLvehC).auamec = 'NO';
         endif;

         if t9rama = 12;
            SPASIMO( t9empr
                   : t9sucu
                   : t9arcd
                   : t9spol
                   : t9sspo
                   : peSino );
            if peSino;
               peLveh(peLvehC).auatec = 'SI';
               peLveh(peLvehC).auamec = 'SI';
            endif;
         endif;

         // -----------------------------------------
         // Quieren la Prima en la WEB (?)
         // A la web va el último estado de c/vehículo
         // asi que me fijo la última facturación
         // y mando toda la prima de ahí en adelante
         // para el vehículo
         // -----------------------------------------
         k2hed0.d0empr = t9empr;
         k2hed0.d0sucu = t9sucu;
         k2hed0.d0arcd = t9arcd;
         k2hed0.d0spol = t9spol;
         k2hed0.d0rama = t9rama;
         k2hed0.d0arse = t9arse;
         setgt  %kds(k2hed0:6) pahed003;
         readpe %kds(k2hed0:6) pahed003;
         dow not %eof;
             if d0tiou = 1 or
                d0tiou = 2 or
                (d0tiou = 3 and d0stos = 1);
                svsspo = d0sspo;
                leave;
             endif;
          readpe %kds(k2hed0:6) pahed003;
         enddo;

         @prca = 0;
         @prrc = 0;
         setgt  %kds(k1het0:8) pahet002;
         readpe %kds(k1het0:8) pahet002;
         dow not %eof;
             if t0sspo >= svsspo;
                @prrc += t0prrc + t0prap + t0prce;
                @prca += t0prac
                       + t0prin
                       + t0prro
                       + t0prsf
                       + t0pacc
                       + t0praa;
             endif;
          readpe %kds(k1het0:8) pahet002;
         enddo;

         peLveh(peLvehC).auprrc = @prrc;
         peLveh(peLvehC).auprca = @prca;
         peLveh(peLvehC).auprim = @prrc + @prca;

         reade %kds(k1het9:6) pahet994;

 e2    enddo;

       return;
