     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLECO : WebService: Retorna Estado de Cotizacion            *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                              *29/12/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fctw000    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

     D WSLECO          pr                  ExtPgm('WSLECO')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peEsta                            likeds(estadoCot)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLECO          pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peEsta                            likeds(estadoCot)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D wrepl           s          65535a

     D k1y000          ds                  likerec(c1w000:*key)

       *inLr = *On;

       peErro = *Zeros;

       clear peMsgs;
       clear peEsta;

       k1y000.w0empr = PeBase.peEmpr;
       k1y000.w0sucu = PeBase.peSucu;
       k1y000.w0nivt = PeBase.peNivt;
       k1y000.w0nivc = PeBase.peNivc;
       k1y000.w0nctw = peNctw;

       chain(n) %kds( k1y000 ) ctw000;

       if not %found ( ctw000 );

         %subst(wrepl:1:7) = %editc(peNctw:'X');
         %subst(wrepl:8:1) = %editc(peBase.peNivt:'X');
         %subst(wrepl:9:5) = %editc(peBase.peNivc:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0008'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;

       endif;

       peEsta.cest = w0cest;
       peEsta.cses = w0cses;
       peEsta.dest = SVPDES_estadoCot ( w0cest : w0cses );

       return;
