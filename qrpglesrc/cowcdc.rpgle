     H actgrp(*caller) dftactgrp(*no)
     H option(*srcstmt: *nodebugio: *noshowcpy)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COWCDC: Cotizadores QUOM                                     *
      *         WebService - Retorna Cantidad de Cuotas              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                  *21-Jun-2016               *
      * ************************************************************ *
     Fset912    if   e           k disk

     D COWCDC          pr                  extpgm('COWCDC')
     D  peCfpg                        3  0 const
     D  peCcuo                        2  0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D COWCDC          pi
     D  peCfpg                        3  0 const
     D  peCcuo                        2  0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D x               s             10i 0
     D @repl           s          65535a

      /free

       *inlr = *on;
       peErro = 0;
       peCcuo = 0;
       clear peMsgs;

       chain peCfpg set912;
       if %found;
          peCcuo = t@ccuo;
          return;
       endif;

       %subst(@repl:1:3) = %editc(peCfpg:'X');
       x = SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0131'
                        : peMsgs
                        : @repl
                        : %len(%trim(@repl)) );
       peErro = -1;
       return;

      /end-free
