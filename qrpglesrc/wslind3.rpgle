     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSLIND3 : Tareas generales.                                  *
      *           WebService - Retorna indicador por menú            *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *30-Oct-2015  *
      * ------------------------------------------------------------ *
      *                                                              *
      *                                                              *
      * ************************************************************ *
     Fsetin1    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLIND3         pr                  ExtPgm('WSLIND3')
     D   peBase                            likeds(paramBase) const
     D   peMenu                      50a   const
     D   peIndi                      10a
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLIND3         pi
     D   peBase                            likeds(paramBase) const
     D   peMenu                      50a   const
     D   peIndi                      10a
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1tind          ds                  likerec(s1tin1:*key)

      /free

       *inlr = *on;

       clear peMsgs;
       peIndi = *blanks;

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
          peIndi = t@indi;
       endif;

       return;

      /end-free
