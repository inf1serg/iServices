     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLAOR: Programa de Servicio.                                *
      *         Serv.Pgm.- Lista Articulos - Automaticos o no.       *
      * ------------------------------------------------------------ *
      *  Parámetros:                                                 *
      *             peArcd (input)   Articulos                       *
      *             peRama (input)   Rama                            *
      *             peArse (input)   sec de poliza en rama           *
      *             peMar5 (output)  Automatico o No                 *
      *             peOrde (output)  Nro de Orden                    *
      *             peErro (output)  Indicador de Error              *
      *             peMsgs (output)  Estructura de Error             *
      *                                                              *
      * ------------------------------------------------------------ *
      * Luis R. Gomez        *17-MAR-2016                            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fset621    if   e           k disk    prefix( t1 : 2 )
      *
     Dwslaor           pr                  extpgm('WSLAOR')
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peMar5                        1
     D  peOrde                        2  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     Dwslaor           pi
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peMar5                        1
     D  peOrde                        2  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D  k1y621         ds                  likerec( s1t621 : *key )
     D  wrepl          s          65535a

      /copy './qcpybooks/svpws_h.rpgle'

      /free

       *inlr = *on;

       k1y621.t1arcd = peArcd;
       k1y621.t1rama = peRama;
       k1y621.t1arse = peArse;
       chain %kds( k1y621 ) set621;
       if %found( set621 );
         pemar5 = t1mar5;
         peorde = t1orde;
       else;
         %subst(wrepl:1:6) = %editc(peArcd:'X');
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           peErro = -1;
       endif;

      /end-free
