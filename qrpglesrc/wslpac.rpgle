     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLPAC : WebService                                          *
      *          Retorna Parentesco                                  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                              *27-Ene-2016   *
      * ------------------------------------------------------------ *
      * ATENCION:                                                    *
      * Por el momento devuelvo siempre TITULAR porque es para AP.   *
      * Cuando implementemos VIDA, habrá que hacer algo entre la     *
      * SET069, la SET102 y la SET620.                               *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/wsltab_h.rpgle'

     D WSLPAC          pr                  ExtPgm('WSLPAC')
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peLpac                            likeds(set069_t) dim(999)
     D   peLpacC                     10i 0

     D WSLPAC          pi
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peLpac                            likeds(set069_t) dim(999)
     D   peLpacC                     10i 0

      /free

       *inlr = *on;

       peLpacC = 1;
       peLpac(peLpacC).paco = 1;
       peLpac(peLpacC).pade = 'TITULAR';

       return;

      /end-free
