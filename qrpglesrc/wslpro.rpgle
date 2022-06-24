     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLPRO  : Tareas generales.                                  *
      *           WebService - Retorna Provincia de CP               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *01-Sep-2016  *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fgntloc    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D WSLPRO          pr                  extpgm('WSLPRO')
     D  peCopo                        5  0 const
     D  peCops                        1  0 const
     D  peProc                        3a
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D WSLPRO          pi
     D  peCopo                        5  0 const
     D  peCops                        1  0 const
     D  peProc                        3a
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      /free

       *inlr = *on;

       peProc = *blanks;
       peErro = 0;
       clear peMsgs;

       chain (peCopo:peCops) gntloc;
       if %found;
          peProc = loproc;
        else;
          peErro = -1;
       endif;

       return;

      /end-free

