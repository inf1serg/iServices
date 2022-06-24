     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCAU  : Tareas generales.                                  *
      *           WebService - Retorna Lista de Causas               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *15-Abr-2015  *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fset40101  if   e           k disk
     Fset401    if   e           k disk

     D WSLCAU          pr                  extpgm('WSLCAU')
     D  peRama                        2  0 const
     D  peLcau                             likeds(causas_t) dim(9999)
     D  peLcauC                      10i 0

     D WSLCAU          pi
     D  peRama                        2  0 const
     D  peLcau                             likeds(causas_t) dim(9999)
     D  peLcauC                      10i 0

      /copy './qcpybooks/wsstruc_h.rpgle'

     D x               s             10i 0
     D k1t401          ds                  likerec(s1t401:*key)

      /free

       *inlr = *on;

       clear peLcau;
       peLcauC = 0;

       setll peRama set40101;
       reade peRama set40101;
       dow not %eof;

           x += 1;
           peLcauC = x;
           peLcau(x).cauc = t@cauc;
           peLcau(x).caud = t@caud;
           k1t401.t@rama = t@rama;
           k1t401.t@cauc = t@cauc;
           chain %kds(k1t401) set401;
           if %found;
              peLcau(x).dcpm = t@dcpm;
            else;
              peLcau(x).dcpm = *blanks;
           endif;

        reade peRama set40101;
       enddo;

       return;

      /end-free
