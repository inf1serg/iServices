     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt:*noshowcpy)
     H bnddir('HDIILE/HDIBDIR')
      * ********************************************************** *
      * COW312: Emision Automatica Desde Web                       *
      *         Determina Plan de Pagos                            *
      * ---------------------------------------------------------- *
      * Sergio Fernandez                    *25-Abr-2017           *
      * ---------------------------------------------------------- *
      * SGF 11/06/2020: Arrego temporal. Voy a set608 a ver si el  *
      *                 plan de pago especial esta. Si no, dejo el *
      *                 que venia. Jennifer ya hizo este arreglo   *
      *                 bien y lo instalaremos luego.              *
      *                                                            *
      * ********************************************************** *
     Fctw000    if   e           k disk
     Fctw001    if   e           k disk
     Fset6118   if   e           k disk
     Fset608    if   e           k disk

     D COW312          pr                  ExtPgm('COW312')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const
     D  peNrpp                        3  0

     D COW312          pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const
     D  peNrpp                        3  0

     D k1w000          ds                  likerec(c1w000:*key)
     D k1w001          ds                  likerec(c1w001:*key)
     D k1t6118         ds                  likerec(s1t6118:*key)
     D k1t608          ds                  likerec(s1t608:*key)

     D qtyRam          s             10i 0

      /free

       *inlr = *on;

       qtyRam = 0;

       k1w000.w0empr = peEmpr;
       k1w000.w0sucu = peSucu;
       k1w000.w0nivt = peNivt;
       k1w000.w0nivc = peNivc;
       k1w000.w0nctw = peNctw;
       chain %kds(k1w000:5) ctw000;
       if not %found;
          return;
       endif;

       peNrpp = w0nrpp;

       k1w001.w1empr = peEmpr;
       k1w001.w1sucu = peSucu;
       k1w001.w1nivt = peNivt;
       k1w001.w1nivc = peNivc;
       k1w001.w1nctw = peNctw;
       setll %kds(k1w001:5) ctw001;
       reade %kds(k1w001:5) ctw001;
       dow not %eof;
           qtyRam += 1;
           if qtyRam > 1;
              return;
           endif;
        reade %kds(k1w001:5) ctw001;
       enddo;

       // -------------------------------------------
       // Plan de pago especial:
       // Si esta propuesta tiene pago en efectivo
       // me fijo si el productor tiene un plan de
       // pago especial en SET6118
       // -------------------------------------------
       if w0cfpg = 4;
          chain %kds(k1w001:5) ctw001;
          if %found;
             k1t6118.t@empr = w1empr;
             k1t6118.t@sucu = w1sucu;
             k1t6118.t@nivt = w1nivt;
             k1t6118.t@nivc = w1nivc;
             k1t6118.t@rama = w1rama;
             chain %kds(k1t6118) set6118;
             if %found;
                if t@nrpp <> 0;
                   k1t608.t@arcd = w0arcd;
                   k1t608.t@cfpg = w0cfpg;
                   k1t608.t@nrpp = t@nrpp;
                   setll %kds(k1t608) set608;
                   if %equal;
                      peNrpp = t@nrpp;
                   endif;
                endif;
             endif;
          endif;
       endif;

       return;

      /end-free
