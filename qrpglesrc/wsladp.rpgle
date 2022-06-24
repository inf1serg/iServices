     H option(*nodebugio: *srcstmt: *noshowcpy)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLADP  : WebService - Retorna Datos del Asegurado de una    *
      *           SuperPóliza.                                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez               *12-Ene-2016                  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * JSN 28/02/2019  Recompilacion por cambio en la estructura    *
      *                 PAHASE_T                                     *
      *                                                              *
      * ************************************************************ *
     Fpahec1    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLADP          pr                  ExtPgm('WSLADP')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peDase                            likeds(pahase_t)
     D   peMase                            likeds(dsMail_t) dim(100)
     D   peMaseC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLADP          pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peDase                            likeds(pahase_t)
     D   peMase                            likeds(dsMail_t) dim(100)
     D   peMaseC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLASE          pr                  ExtPgm('WSLASE')
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0 const
     D   peDase                            likeds(pahase_t)
     D   peMase                            likeds(dsMail_t) dim(100)
     D   peMaseC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a

     D k1hec1          ds                  likerec(p1hec1 : *key)

       *inLr = *On;

       clear peMase;
       clear peDase;
       clear peMaseC;
       clear peErro;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       k1hec1.c1empr = peBase.peEmpr;
       k1hec1.c1sucu = peBase.peSucu;
       k1hec1.c1arcd = peArcd;
       k1hec1.c1spol = peSpol;
       chain %kds(k1hec1:4) pahec1;
       if not %found;
          %subst(@@Repl:1:6) = %trim(%char(peArcd));
          %subst(@@Repl:7:9) = %trim(%char(peSpol));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPO0001'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl))   );
          peErro = -1;
          return;
       endif;

       k1hec1.c1empr = peBase.peEmpr;
       k1hec1.c1sucu = peBase.peSucu;
       k1hec1.c1arcd = peArcd;
       k1hec1.c1spol = peSpol;
       setgt %kds(k1hec1:4) pahec1;
       readpe %kds(k1hec1:4) pahec1;
       if %eof;
          %subst(@@Repl:1:6) = %trim(%char(peArcd));
          %subst(@@Repl:7:9) = %trim(%char(peSpol));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPO0001'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl))   );
          peErro = -1;
          return;
       endif;

       WSLASE( peBase
             : c1asen
             : peDase
             : peMase
             : peMaseC
             : peErro
             : peMsgs );

       return;
