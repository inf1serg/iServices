     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSLIND4 : Tareas generales.                                  *
      *           WebService - Establece indicador por menú          *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *30-Oct-2015  *
      * ------------------------------------------------------------ *
      *                                                              *
      *                                                              *
      * ************************************************************ *
     Fsetin1    uf a e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLIND4         pr                  ExtPgm('WSLIND4')
     D   peBase                            likeds(paramBase) const
     D   peMenu                      50a   const
     D   peIndi                      10a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLIND4         pi
     D   peBase                            likeds(paramBase) const
     D   peMenu                      50a   const
     D   peIndi                      10a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1tind          ds                  likerec(s1tin1:*key)

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
       k1tind.t@menu = peMenu;
       chain %kds(k1tind:5) setin1;
       if %found;
          t@indi = peIndi;
          update s1tin1;
        else;
          t@empr = peBase.peEmpr;
          t@sucu = peBase.peSucu;
          t@nivt = peBase.peNivt;
          t@nivc = peBase.peNivc;
          t@menu = peMenu;
          t@indi = peIndi;
          write s1tin1;
       endif;

       return;

      /end-free
