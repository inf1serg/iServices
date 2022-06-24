     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSLIND2 : Tareas generales.                                  *
      *           WebService - Actualiza orden de indicadores        *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *30-Oct-2015  *
      * ------------------------------------------------------------ *
      *                                                              *
      *                                                              *
      * ************************************************************ *
     Fsetind    uf a e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLIND2         pr                  ExtPgm('WSLIND2')
     D   peBase                            likeds(paramBase) const
     D   peLind                            likeds(indicadores_t) dim(999)
     D                                     const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLIND2         pi
     D   peBase                            likeds(paramBase) const
     D   peLind                            likeds(indicadores_t) dim(999)
     D                                     const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1tind          ds                  likerec(s1tind:*key)
     D x               s             10i 0

      /free

       *inlr = *on;

       clear peMsgs;

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
           delete s1tind;
        reade %kds(k1tind:4) setind;
       enddo;

       for x = 1 to 999;
           if peLind(x).indi <> *blanks;
              t@empr = peBase.peEmpr;
              t@sucu = peBase.peSucu;
              t@nivt = peBase.peNivt;
              t@nivc = peBase.peNivc;
              t@orde = peLind(x).orde;
              t@indi = peLind(x).indi;
              write s1tind;
            else;
              leave;
           endif;
       endfor;

       return;

      /end-free
