     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLPBA: Programa de Servicio.                                *
      *         Serv.Pgm.- Lista Plan para Llamada a COWAPE          *
      * ------------------------------------------------------------ *
      *  Parámetros:                                                 *
      *             peArcd  (input)   Articulos                      *
      *             peRama  (input)   Rama                           *
      *             peArse  (input)   sec de poliza en ram           *
      *             paCape  (output)  Datos de APE                   *
      *             paCapec (output)  cantidad de planes             *
      *             peErro  (output)  Indicador de Error             *
      *             peMsgs  (output)  Estructura de Error            *
      *                                                              *
      * ------------------------------------------------------------ *
      * Luis R. Gomez        *17-MAR-2016                            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fset627    if   e           k disk    prefix( t1 : 2 )
      *
     Dwslpba           pr                  extpgm('WSLPBA')
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCape                             likeds( infoape ) dim(999)
     D  peCapeC                      10i 0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     Dwslpba           pi
     D  peArcd                        6  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCape                             likeds( infoape ) dim(999)
     D  peCapeC                      10i 0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D  wrepl          s          65535a
     D  k1y627         ds                  likerec( s1t627 : *key )

      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

      /free
       clear peCape;
       clear peCapeC;

       *inlr = *on;
       k1y627.t1arcd = peArcd;
       k1y627.t1rama = peRama;
       k1y627.t1arse = peArse;
       setll %kds( k1y627 : 3 ) set627;
       if not %equal( set627 );
         %subst(wrepl:1:6) = %editc(peArcd:'X');
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0128'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           peErro = -1;
           return;
       endif;
       reade %kds( k1y627 : 3 ) set627;
       dow not %eof( set627 );
         peCapeC += 1;
         exsr carga_ape;
         reade %kds( k1y627 : 3 ) set627;
       enddo;

      // Carga datos para llamar COWAPE ..................................//
       begsr carga_ape;
        peCape(peCapeC).Xpro = t1xpro;
        peCape(peCapeC).Paco = 1;
        peCape(peCapeC).Acti = t1cact;
        peCape(peCapeC).Secu = 1;
        peCape(peCapeC).Cant = 1;
        peCape(peCapeC).Tipe = 'F';
       endsr;

      /end-free
