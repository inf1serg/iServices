     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSLIND1 : Tareas generales.                                  *
      *           WebService - Retorna orden de indicadores          *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *30-Oct-2015  *
      * ------------------------------------------------------------ *
      *                                                              *
      *                                                              *
      * ************************************************************ *
     Fsetind    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLIND1         pr                  ExtPgm('WSLIND1')
     D   peBase                            likeds(paramBase) const
     D   peLind                            likeds(indicadores_t) dim(999)
     D   peLindC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLIND1         pi
     D   peBase                            likeds(paramBase) const
     D   peLind                            likeds(indicadores_t) dim(999)
     D   peLindC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1tind          ds                  likerec(s1tind:*key)

      /free

       *inlr = *on;

       clear peMsgs;
       peLindC = 0;

       // --------------------------------------
       // Parámetro Base
       // --------------------------------------
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       k1tind.t@empr = peBase.peEmpr;
       k1tind.t@sucu = peBase.peSucu;
       k1tind.t@nivt = peBase.peNivt;
       k1tind.t@nivc = peBase.peNivc;
       setll %kds(k1tind:4) setind;
       reade %kds(k1tind:4) setind;
       dow not %eof;

           peLindC += 1;
           peLind(peLindC).orde = t@orde;
           peLind(peLindC).indi = t@indi;

        reade %kds(k1tind:4) setind;
       enddo;

       // -------------------------------
       // Si no hay, retorno default
       // -------------------------------
       if peLindC = 0;
          peLindC = 5;
          peLind(1).orde = 1;
          peLind(1).indi = 'pePvig';
          peLind(2).orde = 2;
          peLind(2).indi = 'peCart';
          peLind(3).orde = 3;
          peLind(3).indi = 'peCzas';
          peLind(4).orde = 4;
          peLind(4).indi = 'peStro';
          peLind(5).orde = 5;
          peLind(5).indi = 'peCotw';
       endif;

       return;

      /end-free
