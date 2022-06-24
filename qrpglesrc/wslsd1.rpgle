     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLSD1  : Tareas generales.                                  *
      *           WebService - Retorna daños vehiculo en Siniestro.  *
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *22-Abr-2015  *
      * ------------------------------------------------------------ *
      * SGF 22/05/2015 - Nueva versión: sin paginado.                *
      *                  De nada sirve: jamás en la historia un stro *
      *                  tuvo más de 40 líneas.                      *
      *                                                              *
      * ************************************************************ *
     Fpahscd    if   e           k disk
     Fpahsd1    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSD1          pr                  ExtPgm('WSLSD1')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDdvh                            likeds(pahsd1_t) dim(100)
     D   peDdvhC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSD1          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peDdvh                            likeds(pahsd1_t) dim(100)
     D   peDdvhC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1yscd          ds                  likerec(p1hscd:*key)
     D k1ysd1          ds                  likerec(p1hsd1:*key)

     D respue          s          65536
     D longm           s             10i 0

       *inLr = *On;

       peDdvhC = *Zeros;
       peErro  = *Zeros;

       clear peDdvh;
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
          respue =  %editC(peRama:'4':*ASTFILL) +
                    %editC(peSini:'4':*ASTFILL);
          longm  = 9;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'SIN0001' :
                          peMsgs : respue  : longm );
         peErro = -1;
         return;
       endif;

       k1ysd1.d1empr = k1yscd.cdempr;
       k1ysd1.d1sucu = k1yscd.cdsucu;
       k1ysd1.d1rama = k1yscd.cdrama;
       k1ysd1.d1sini = k1yscd.cdsini;
       k1ysd1.d1nops = cdnops;

       setll %kds ( k1ysd1 : 5 ) pahsd1;
       reade %kds ( k1ysd1 : 5 ) pahsd1;
       dow ( not %eof ( pahsd1 ) ) and ( peDdvhC < 100 );

           if %subst(d1retx:1:1) <> '&' and
              %subst(d1retx:1:1) <> '#';
              peDdvhC += 1;
              peDdvh(peDdvhC).d1retx = d1retx;
           endif;

         reade %kds ( k1ysd1 : 5 ) pahsd1;
       enddo;

       return;
