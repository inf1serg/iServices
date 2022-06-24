     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLSTC  : Tareas generales.                                  *
      *           WebService - Retorna textos de caratula Siniestro. *
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *21-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 27/04/2015 - Agrego validacion de parametro base         *
      * SGF 22/05/2015 - Nueva versión: sin paginado.                *
      *                  De nada sirve: jamás en la historia un stro *
      *                  tuvo más de 20 líneas.                      *
      *                                                              *
      * ************************************************************ *
     Fpahscd    if   e           k disk
     Fpahstc    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSTC          pr                  ExtPgm('WSLSTC')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peTcsi                            likeds(pahstc_t) dim(100)
     D   peTcsiC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSTC          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peTcsi                            likeds(pahstc_t) dim(100)
     D   peTcsiC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1yscd          ds                  likerec(p1hscd:*key)
     D k1ystc          ds                  likerec(p1hstc:*key)

     D respue          s          65536
     d longm           s             10i 0

     D textos          ds                  likerec(p1hstc)

       *inLr = *On;

       peTcsiC = *Zeros;
       peErro  = *Zeros;

       clear peTcsi;
       clear peMsgs;
       clear respue;
       clear longm;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       k1yscd.cdempr = peBase.peEmpr;
       k1yscd.cdsucu = peBase.peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;

       setll %kds ( k1yscd : 4 ) pahscd;
       reade %kds ( k1yscd : 4 ) pahscd;

       if %eof( pahscd );
          respue =  %char(peRama) + %char(peSini);
          longm  = 9;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'SIN0001' :
                          peMsgs : respue  : longm );
         peErro = -1;
         return;
       endif;

       k1ystc.stempr = k1yscd.cdempr;
       k1ystc.stsucu = k1yscd.cdsucu;
       k1ystc.strama = k1yscd.cdrama;
       k1ystc.stsini = k1yscd.cdsini;
       k1ystc.stnops = cdnops;

       setll %kds ( k1ystc : 5 ) pahstc;
       reade %kds ( k1ystc : 5 ) pahstc;
       dow ( not %eof ( pahstc ) ) and ( peTcsiC < 100 );

         if %subst(stretx:1:1) <> '&' and
            %subst(stretx:1:1) <> '#';
            peTcsiC += 1;
            peTcsi(peTcsiC).stretx = stretx;
         endif;

         reade %kds ( k1ystc : 5 ) pahstc;

       enddo;

       return;
