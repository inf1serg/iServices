     H actgrp(*caller) dftactgrp(*no)
     H option(*srcstmt: *nodebugio: *noshowcpy)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COWUYC: Cotizadores QUOM                                     *
      *         WebService - Retorna Uso y Combustible de un auto    *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                  *21-Jun-2016               *
      * ************************************************************ *
     Fset215    if   e           k disk
     Fset211    if   e           k disk

     D COWUYC          pr                  extpgm('COWUYC')
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  peVhuv                        2  0
     D  peVhdu                       15a
     D  peComb                       20a
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D COWUYC          pi
     D  peVhmc                        3a   const
     D  peVhmo                        3a   const
     D  peVhcs                        3a   const
     D  peVhuv                        2  0
     D  peVhdu                       15a
     D  peComb                       20a
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D t204            ds                  likeds(@@@204)
     D k1t215          ds                  likerec(s1t215:*key)
     D rc              s              1N
     D x               s             10i 0
     D @repl           s          65535a

      /free

       *inlr = *on;
       peErro = 0;
       peVhuv = 0;
       peVhdu = *blanks;
       peComb = *blanks;
       clear peMsgs;

       rc = SPVVEH_checkVeh( peVhmc : peVhmo : peVhcs : t204 );
       if (rc = *off);
          %subst(@repl:1:3) = peVhmc;
          %subst(@repl:4:3) = peVhmo;
          %subst(@repl:7:3) = peVhcs;
          x = SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0130'
                           : peMsgs
                           : @repl
                           : %len(%trim(@repl)) );
          peErro = -1;
          return;
       endif;

       k1t215.t@vhca = t204.t@vhca;
       k1t215.t@vhv1 = t204.t@vhv1;
       k1t215.t@vhv2 = t204.t@vhv2;
       chain %kds(k1t215) set215;
       if not %found;
          return;
       endif;

       chain t@vhuv set211;
       if not %found;
          return;
       endif;

       peVhdu = t@vhdu;
       peVhuv = t@vhuv;

       select;
        when t204.t@vhv2 = 5;
             peComb = 'GNC';
        when t204.t@vhv2 = 6;
             peComb = 'GNC';
        when t204.t@vhv2 = 7;
             peComb = 'DIESEL';
        when t204.t@vhv2 = 8;
             peComb = 'DIESEL';
        other;
             peComb = 'NAFTA';
       endsl;

       return;

      /end-free
