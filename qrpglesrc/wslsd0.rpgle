     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLSD0  : Tareas generales.                                  *
      *           WebService - Retorna Relato Hecho de un Siniestro  *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda                             *22-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 23/04/2015 - Agrego validacion de parametros base        *
      * SGF 22/05/2015 - Nueva versión: sin paginado.                *
      *                  De nada sirve: jamás en la historia un stro *
      *                  tuvo más de 40 líneas.                      *
      *                                                              *
      * ************************************************************ *
     Fpahscd    if   e           k disk
     Fpahsd0    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSD0          pr                  ExtPgm('WSLSD0')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peRhsi                            likeds(pahsd0_t) dim(100)
     D   peRhsiC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSD0          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peRhsi                            likeds(pahsd0_t) dim(100)
     D   peRhsiC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1yscd          ds                  likerec(p1hscd:*key)
     D k1ysd0          ds                  likerec(p1hsd0:*key)

     D @@repl          s          65535a
     D @@leng          s             10i 0

       *inLr = *On;

       peErro  = *Zeros;
       peRhsiC = *Zeros;

       clear peRhsi;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       k1yscd.cdempr = peBase.peEmpr;
       k1yscd.cdsucu = peBase.peSucu;
       k1yscd.cdrama = peRama;
       k1yscd.cdsini = peSini;

       setll %kds ( k1yscd : 4 ) pahscd;

       if not %equal ( pahscd );
            @@Repl =   %editc ( peRama  : '4' : *astfill )
                   +   %editc ( peSini  : '4' : *astfill );
            @@Leng = %len ( %trim ( @@repl ) );
            SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'SIN0001' :
                          peMsgs : @@Repl  : @@Leng );
            peErro = -1;
            return;
       else;
         reade %kds ( k1yscd : 4 ) pahscd;
       endif;

       k1ysd0.d0empr = k1yscd.cdempr;
       k1ysd0.d0sucu = k1yscd.cdsucu;
       k1ysd0.d0rama = k1yscd.cdrama;
       k1ysd0.d0Sini = k1yscd.cdsini;
       k1ysd0.d0Nops = cdnops;

       setll %kds ( k1ysd0  : 5 ) pahsd0;
       reade %kds ( k1ysd0  : 5 ) pahsd0;

       dow ( not %eof ( pahsd0  ) ) and ( peRhsiC <  100 );

           if %subst(d0retx:1:1) <> '&' and
              %subst(d0retx:1:1) <> '#';
              peRhsiC += 1;
              peRhsi(peRhsiC).d0retx = d0retx;
           endif;

         reade %kds( k1ysd0 : 5 ) pahsd0;
       enddo;

       return;
