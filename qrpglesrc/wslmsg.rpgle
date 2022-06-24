     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLMSG : WebService - Retorna mensajes por Intermediario.    *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            13/08/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * NWN NWN 10/01/2017 : Asterisqueo Sentencia.                  *
      * ************************************************************ *
     Fgntmsg01  if   e           k disk
     Fgntmsg02  if   e           k disk    rename(g1tmsg:r02)
     Fgntmsg03  if   e           k disk    rename(g1tmsg:r03)

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLMSG          pr                  ExtPgm('WSLMSG')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peType                       2    const
     D   pePosi                            likeds(keymsg_t) const
     D   pePreg                            likeds(keymsg_t)
     D   peUreg                            likeds(keymsg_t)
     D   peLmsg                            likeds(gntmsg_t) dim(99)
     D   peLmsgC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLMSG          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peType                       2    const
     D   pePosi                            likeds(keymsg_t) const
     D   pePreg                            likeds(keymsg_t)
     D   peUreg                            likeds(keymsg_t)
     D   peLmsg                            likeds(gntmsg_t) dim(99)
     D   peLmsgC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D ktmsg           ds                  likerec(g1tmsg:*key)

     D finArc          pr              n

     D @@cant          s             10i 0
     D @@type          s              2
     D @@fmsg          s               d
     D xx              s             10a

     D psds           sds                  qualified
     D  job                          26a   overlay(psds:244)

       *inLr = *On;

       clear peLmsg;
       clear peLmsgC;
       clear peErro;
       clear peMsgs;

       @@more = *On;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      *- Valido Tipo de Mensaje
       @@type = peType;
       if peType <> 'T '
        and peType <> 'NL'
        and peType <> 'L ';
          @@type = 'T ';
       endif;

      *- Valido Fecha de Mensaje
       @@fmsg = pePosi.fmsg;
       test(e) pePosi.fmsg;
       if %error
        or pePosi.fmsg > %date();
          @@fmsg = %date();
       endif;

       // 10/01/2017
       // @@fmsg = %date();

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       exsr priReg;

       dow ( ( not finArc ) and ( peLmsgC < @@cant ) );

         peLmsgC += 1;

         peLmsg(peLmsgC).msid = sgmsid;
         peLmsg(peLmsgC).body = sgbody;
         peLmsg(peLmsgC).impo = sgimpo;
         peLmsg(peLmsgC).read = sgread;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( gntmsg01 )
         or %eof( gntmsg02 )
         or %eof( gntmsg03 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

       ktmsg.sgempr = peBase.peEmpr;
       ktmsg.sgsucu = peBase.peSucu;
       ktmsg.sgnivt = peBase.peNivt;
       ktmsg.sgnivc = peBase.peNivc;
       ktmsg.sgfmsg = @@fmsg;
       ktmsg.sgmsid = pePosi.msid;

       if ( peRoll = 'F' );
          select;
             when @@type = 'T ';
                setgt %kds ( ktmsg : 6 ) gntmsg01;
             when @@type = 'NL';
                setgt %kds ( ktmsg : 6 ) gntmsg02;
             when @@type = 'L ';
                setgt %kds ( ktmsg : 6 ) gntmsg03;
          endsl;
       else;
          select;
             when @@type = 'T ';
                setll %kds ( ktmsg : 6 ) gntmsg01;
             when @@type = 'NL';
                setll %kds ( ktmsg : 6 ) gntmsg02;
             when @@type = 'L ';
                setll %kds ( ktmsg : 6 ) gntmsg03;
          endsl;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       select;
          when @@type = 'T ';
             reade %kds ( ktmsg : 4 ) gntmsg01;
          when @@type = 'NL';
             reade %kds ( ktmsg : 4 ) gntmsg02;
          when @@type = 'L ';
             reade %kds ( ktmsg : 4 ) gntmsg03;
       endsl;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       select;
          when @@type = 'T ';
             readpe %kds ( ktmsg : 4 ) gntmsg01;
          when @@type = 'NL';
             readpe %kds ( ktmsg : 4 ) gntmsg02;
          when @@type = 'L ';
             readpe %kds ( ktmsg : 4 ) gntmsg03;
       endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       select;
          when @@type = 'T ';
             setll %kds ( ktmsg : 4 ) gntmsg01;
          when @@type = 'NL';
             setll %kds ( ktmsg : 4 ) gntmsg02;
          when @@type = 'L ';
             setll %kds ( ktmsg : 4 ) gntmsg03;
       endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

       if ( peRoll = 'R' );
         exsr retArc;
         dow ( ( not finArc ) and ( @@cant > 0 ) );
           @@cant -= 1;
           exsr retArc;
         enddo;
         if finArc;
           @@more = *Off;
           exsr priArc;
         endif;
         @@cant = peCant;
         if (@@cant <= 0 or @@cant > 99);
            @@cant = 99;
         endif;
       endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;

       pePreg.fmsg = sgfmsg;
       pePreg.msid = sgmsid;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.fmsg = sgfmsg;
       peUreg.msid = sgmsid;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       select;
          when @@type = 'T ';
             return %eof ( gntmsg01 );
          when @@type = 'NL';
             return %eof ( gntmsg02 );
          when @@type = 'L ';
             return %eof ( gntmsg03 );
       endsl;

     P finArc          E
