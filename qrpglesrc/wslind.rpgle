     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSLIND  : Tareas generales.                                  *
      *           WebService - Indicadores                           *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *13-Oct-2015  *
      * ------------------------------------------------------------ *
      * SGF 18/08/2016: TAB004 es ahora TAB007.                      *
      * SGF 23/08/2016: MAL el campo de cantidad vigente en peStro.  *
      * SGF 31/08/2021: COMPARA EN CASA no cuenta cotizaciones web.  *
      *                                                              *
      * ************************************************************ *
     Fpahind    if   e           k disk
     Fset001    if   e           k disk
     Fctw000    if   e           k disk
     Ftab007    if   e           k disk
     Fctw001    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLIND          pr                  ExtPgm('WSLIND')
     D   peBase                            likeds(paramBase) const
     D   pePvig                            likeds(indPrdvig_t) dim(99)
     D   pePvigC                     10i 0
     D   peCart                            likeds(indCart_t)
     D   peCzas                            likeds(indCzas_t)
     D   peStro                            likeds(indStros_t)
     D   peCotw                            likeds(indCotiw_t)
     D   peFpro                            likeds(indFech_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLIND          pi
     D   peBase                            likeds(paramBase) const
     D   pePvig                            likeds(indPrdvig_t) dim(99)
     D   pePvigC                     10i 0
     D   peCart                            likeds(indCart_t)
     D   peCzas                            likeds(indCzas_t)
     D   peStro                            likeds(indStros_t)
     D   peCotw                            likeds(indCotiw_t)
     D   peFpro                            likeds(indFech_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hind          ds                  likerec(p1hind:*key)
     D k1w000          ds                  likerec(c1w000:*key)
     D k1w001          ds                  likerec(c1w001:*key)

     D aux             s             29  9

      * ------------------------------------------------------------ *
      * Cartera Vigente
      * ------------------------------------------------------------ *
     D @auvi           s             10i 0
     D @hovi           s             10i 0
     D @vivi           s             10i 0
     D @revi           s             10i 0
     D @totvi          s             10i 0

      * ------------------------------------------------------------ *
      * Cobranzas
      * ------------------------------------------------------------ *
     D @dx45           s             10i 0
     D @dm45           s             10i 0
     D @axfp           s             10i 0

      * ------------------------------------------------------------ *
      * Cotizaciones web
      * ------------------------------------------------------------ *
     D @cwau           s             10i 0
     D @cwho           s             10i 0
     D @cwvi           s             10i 0
     D @cwre           s             10i 0
     D @cwto           s             10i 0

     D PsDs           sds                  qualified
     D  Job                          10a   overlay(psds:244)
     D  User                         10a   overlay(psds:*next)
     D  Nbr                           6a   overlay(psds:*next)

      /free

       *inlr = *on;

       clear peMsgs;
       clear pePvig;
       clear peCart;
       clear peCzas;
       clear peStro;
       clear peCotw;
       pePvigC = 0;

       @auvi  = 0;
       @hovi  = 0;
       @vivi  = 0;
       @revi  = 0;
       @totvi = 0;

       // --------------------------------------
       // Parámetro Base
       // --------------------------------------
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       read tab007;
       peFpro.fech = t4fecpro2;
       peFpro.hora = t4horpro2;

       k1hind.ndempr = peBase.peEmpr;
       k1hind.ndsucu = peBase.peSucu;
       k1hind.ndnivt = peBase.peNivt;
       k1hind.ndnivc = peBase.peNivc;

       setll %kds(k1hind:4) pahind;
       reade %kds(k1hind:4) pahind;
       dow not %eof;

           // ----------------------------
           // Producción Vigente
           // ----------------------------
           pePvigC += 1;
           pePvig(pePvigC).rama = ndrama;
           chain ndrama set001;
           if not %found;
              t@ramd = *all'*';
              t@rame = 0;
           endif;
           pePvig(pePvigC).ramd = t@ramd;
           pePvig(pePvigC).qty  = ndqvig;
           pePvig(pePvigC).prim = ndtpri;
           pePvig(pePvigC).prem = ndtpre;

           // ----------------------------
           // Cartera vigente
           // ----------------------------
           select;
            when t@rame = 4;
                 @auvi += ndqvig;
                 peStro.Aucs += ndqstd;
                 peStro.Auvi += ndqvig;
            when t@rame = 18 or t@rame = 21;
                 @vivi += ndqvig;
                 peStro.Vics += ndqstd;
                 peStro.Vivi += ndqvig;
            when t@rama = 27;
                 @hovi += ndqvig;
                 peStro.Hocs += ndqstd;
                 peStro.Hovi += ndqvig;
            other;
                 @revi += ndqvig;
                 peStro.Recs += ndqstd;
                 peStro.Revi += ndqvig;
           endsl;
           @totvi += ndqvig;

           // ----------------------------
           // Cobranzas
           // ----------------------------
           @dx45 += ndqd45;
           @dm45 += ndqm45;
           @axfp += ndqafp;

        reade %kds(k1hind:4) pahind;
       enddo;

       // ---------------------------
       // Calcula % Cartera Vigente
       // ---------------------------
       monitor;
          if (@totvi <> 0);
             aux = (@auvi / @totvi) * 100;
             peCart.auvi = %dec(aux:5:2);
             aux = (@hovi / @totvi) * 100;
             peCart.hovi = %dec(aux:5:2);
             aux = (@vivi / @totvi) * 100;
             peCart.vivi = %dec(aux:5:2);
             aux = (@revi / @totvi) * 100;
             peCart.revi = %dec(aux:5:2);
          endif;
        on-error;
             peCart.auvi = 0;
             peCart.hovi = 0;
             peCart.vivi = 0;
             peCart.revi = 0;
       endmon;

       // ---------------------------
       // Calcula % Siniestros Autos
       // ---------------------------
       monitor;
         if peStro.auvi <> 0;
            aux = (peStro.Aucs / peStro.Auvi) * 100;
            peStro.Auxx = %dec(aux:5:2);
         endif;
        on-error;
           peStro.Auxx = 0;
       endmon;

       // ---------------------------
       // Calcula % Siniestros Hogar
       // ---------------------------
       monitor;
         if peStro.hovi <> 0;
            aux = (peStro.Hocs / peStro.Hovi) * 100;
            peStro.Hoxx = %dec(aux:5:2);
         endif;
        on-error;
            peStro.Hoxx = 0;
       endmon;

       // ---------------------------
       // Calcula % Siniestros Vida
       // ---------------------------
       monitor;
          if peStro.vivi <> 0;
             aux = (peStro.Vics / peStro.Vivi) * 100;
             peStro.Vixx = %dec(aux:5:2);
          endif;
       on-error;
          peStro.Vixx = 0;
       endmon;

       // ---------------------------
       // Calcula % Siniestros Resto
       // ---------------------------
       monitor;
         if peStro.revi <> 0;
            aux = (peStro.Recs / peStro.Revi) * 100;
            peStro.Rexx = %dec(aux:5:2);
         endif;
       on-error;
            peStro.Rexx = 0;
       endmon;

       // ---------------------------
       // Calcula % Cobranzas
       // ---------------------------
       monitor;
          if (@totvi <> 0);
             aux = (@dx45 / @totvi) * 100;
             peCzas.xx45 = %dec(aux:5:2);
             aux = (@dm45 / @totvi) * 100;
             peCzas.xm45 = %dec(aux:5:2);
             aux = (@axfp / @totvi) * 100;
             peCzas.xaxf = %dec(aux:5:2);
          endif;
       on-error;
          peCzas.xx45 = 0;
          peCzas.xm45 = 0;
          peCzas.xaxf = 0;
       endmon;

       // ---------------------------
       // Cotizaciones Web
       // ---------------------------
       @cwau = 0;
       @cwho = 0;
       @cwvi = 0;
       @cwre = 0;
       @cwto = 0;
       if peBase.peNivc <> 78751;
          k1w000.w0empr = peBase.peEmpr;
          k1w000.w0sucu = peBase.peSucu;
          k1w000.w0nivt = peBase.peNivt;
          k1w000.w0nivc = peBase.peNivc;
          k1w001.w1empr = peBase.peEmpr;
          k1w001.w1sucu = peBase.peSucu;
          k1w001.w1nivt = peBase.peNivt;
          k1w001.w1nivc = peBase.peNivc;
          setll %kds(k1w000:4) ctw000;
          reade %kds(k1w000:4) ctw000;
          dow not %eof;

              @cwto += 1;

              k1w001.w1nctw = w0nctw;
              setll %kds(k1w001:5) ctw001;
              reade %kds(k1w001:5) ctw001;
              dow not %eof;
                  chain w1rama set001;
                  if %found;
                     select;
                      when t@rame = 4;
                           @cwau += 1;
                      when t@rama = 27;
                           @cwho += 1;
                      when t@rame = 18 or t@rame = 21;
                           @cwvi += 1;
                   other;
                        @cwre += 1;
                  endsl;
                  endif;
               reade %kds(k1w001:5) ctw001;
              enddo;

           reade %kds(k1w000:4) ctw000;
          enddo;
       endif;

       monitor;
          if @cwto <> 0;
             aux = (@cwau / @cwto) * 100;
             peCotw.Xacw = %dec(aux:5:2);
             aux = (@cwho / @cwto) * 100;
             peCotw.Xhcw = %dec(aux:5:2);
             aux = (@cwvi / @cwto) * 100;
             peCotw.Xvcw = %dec(aux:5:2);
             aux = (@cwre / @cwto) * 100;
             peCotw.Xrcw = %dec(aux:5:2);
          endif;
        on-error;
             peCotw.Xacw = 0;
             peCotw.Xhcw = 0;
             peCotw.Xvcw = 0;
             peCotw.Xrcw = 0;
       endmon;

       return;

      /end-free
