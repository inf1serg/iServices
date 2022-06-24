     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLSU1  : Tareas generales.                                  *
      *           WebService - Retorna Lista de suplementos          *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                        *13-Ene-2017         *
      * ------------------------------------------------------------ *
      * JSN 20/03/2017 - se agrega condicion de que cargue los datos *
      *                  siempre y cuando el campo c1tiou <> 3 y     *
      *                  c1stou <> 90                                *
      * SGF 11/05/2017 - Incluyo otra vez los 3/90.                  *
      *                                                              *
      * ************************************************************ *

     Fpahec1    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLSU1          pr                  ExtPgm('WSLSU1')
     D   peBase                            likeds(paramBase) const
     D   peAsdc                       1a   const
     D   pePosi                            likeds(keysup_t) const
     D   peLsu1                            likeds(pahsu1_t) dim(1000)
     D   peLsu1C                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLSU1          pi
     D   peBase                            likeds(paramBase) const
     D   peAsdc                       1a   const
     D   pePosi                            likeds(keysup_t) const
     D   peLsu1                            likeds(pahsu1_t) dim(1000)
     D   peLsu1C                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hec1          ds                  likerec(p1hec1:*key)

     D @@endo          s              3  0 dim(1000)
     D @@ascd          s              1a
     D ok1             s              1n
     D ok2             s              1n
     D x               s             10i 0
     D y               s             10i 0

      /free

       *inlr  = *On;

       peLsu1C = *Zeros;
       peErro  = *Zeros;
       clear peLsu1;
       clear peMsgs;
       clear @@endo;

       // ----------------------------------------
       // Valida Parámetro base
       // ----------------------------------------
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       // ----------------------------------------
       // Valida Parámetro tipo de lectura
       // ----------------------------------------
       @@ascd = peAsdc;
       if (peAsdc <> 'A') and (peAsdc <> 'D');
          @@ascd = 'A';
       endif;

       k1hec1.c1empr = peBase.peEmpr;
       k1hec1.c1sucu = peBase.peSucu;
       k1hec1.c1arcd = pePosi.psarcd;
       k1hec1.c1spol = pePosi.psspol;

       setll %kds(k1hec1:4) pahec1;
       reade %kds(k1hec1:4) pahec1;
       dow not %eof;

           ok1 = *off;
           ok2 = *off;

           select;
            when peBase.peNivt = 1;
                 if c1niv1 = peBase.peNivc;
                    ok1 = *on;
                 endif;
            when peBase.peNivt = 2;
                 if c1niv2 = peBase.peNivc;
                    ok1 = *on;
                 endif;
            when peBase.peNivt = 3;
                 if c1niv3 = peBase.peNivc;
                    ok1 = *on;
                 endif;
            when peBase.peNivt = 4;
                 if c1niv4 = peBase.peNivc;
                    ok1 = *on;
                 endif;
            when peBase.peNivt = 5;
                 if c1niv5 = peBase.peNivc;
                    ok1 = *on;
                 endif;
            when peBase.peNivt = 6;
                 if c1niv6 = peBase.peNivc;
                    ok1 = *on;
                 endif;
            when peBase.peNivt = 7;
                 if c1niv7 = peBase.peNivc;
                    ok1 = *on;
                 endif;
            when peBase.peNivt = 8;
                 if c1niv8 = peBase.peNivc;
                    ok1 = *on;
                 endif;
            when peBase.peNivt = 9;
                 if c1niv9 = peBase.peNivc;
                    ok1 = *on;
                 endif;
           endsl;

           select;
            when peBase.peNit1 = 1;
                 if c1niv1 = peBase.peNiv1;
                    ok2 = *on;
                 endif;
            when peBase.peNit1 = 2;
                 if c1niv2 = peBase.peNiv1;
                    ok2 = *on;
                 endif;
            when peBase.peNit1 = 3;
                 if c1niv3 = peBase.peNiv1;
                    ok2 = *on;
                 endif;
            when peBase.peNit1 = 4;
                 if c1niv4 = peBase.peNiv1;
                    ok2 = *on;
                 endif;
            when peBase.peNit1 = 5;
                 if c1niv5 = peBase.peNiv1;
                    ok2 = *on;
                 endif;
            when peBase.peNit1 = 6;
                 if c1niv6 = peBase.peNiv1;
                    ok2 = *on;
                 endif;
            when peBase.peNit1 = 7;
                 if c1niv7 = peBase.peNiv1;
                    ok2 = *on;
                 endif;
            when peBase.peNit1 = 8;
                 if c1niv8 = peBase.peNiv1;
                    ok2 = *on;
                 endif;
            when peBase.peNit1 = 9;
                 if c1niv9 = peBase.peNiv1;
                    ok2 = *on;
                 endif;
           endsl;

           if ok1 and ok2;
              x += 1;
              @@endo(x) = c1sspo;
           endif;

        reade %kds(k1hec1:4) pahec1;
       enddo;

       if @@ascd = 'D';
          sorta(d) @@endo;
       endif;

       for y = 1 to x;
           peLsu1C += 1;
           peLsu1(peLsu1C).pssspo = @@endo(y);
       endfor;

       return;

      /end-free
