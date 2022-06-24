     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLCEN  : Tareas generales.                                  *
      *           WebService - Retorna las Cuotas de un Endoso       *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Gronda                                   *07-May-2015  *
      * ------------------------------------------------------------ *
      * SGF 23/05/2015: Todo desde GAUS.                             *
      *                                                              *
      * ************************************************************ *
     Fpahcd5    if   e           k disk
     Fpahcd6    if   e           k disk
     Fpahed004  if   e           k disk
     Fpahec0    if   e           k disk
     Fpahec1    if   e           k disk
     Fgntmon    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLCEN          pr                  ExtPgm('WSLCEN')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peCuot                            likeds(pahcuo_t) dim(100)
     D   peCuotC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLCEN          pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peCuot                            likeds(pahcuo_t) dim(100)
     D   peCuotC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hcd5          ds                  likerec(p1hcd5   : *key)
     D k1hcd6          ds                  likerec(p1hcd6   : *key)
     D k1hed0          ds                  likerec(p1hed004 : *key)
     D k1hec0          ds                  likerec(p1hec0   : *key)
     D k1hec1          ds                  likerec(p1hec1   : *key)

     D @@repl          s          65535a
     D fecha           s              8  0

       *inLr = *On;

       peErro  = *Zeros;
       peCuotC = *Zeros;

       clear peCuot;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       setll %kds(k1hed0:4) pahed004;
       if not %equal;
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %trim(%char(pePoli));

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
          peErro = -1;
          return;
       endif;

       k1hec0.c0empr = peBase.peEmpr;
       k1hec0.c0sucu = peBase.peSucu;
       k1hec0.c0arcd = peArcd;
       k1hec0.c0spol = peSpol;
       setll %kds(k1hec0:4) pahec0;
       if not %equal;
          %subst(@@repl:1:6) = %trim(%char(peArcd));
          %subst(@@repl:7:9) = %trim(%char(peSpol));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPO0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
          peErro = -1;
          return;
       endif;

       k1hec1.c1empr = peBase.peEmpr;
       k1hec1.c1sucu = peBase.peSucu;
       k1hec1.c1arcd = peArcd;
       k1hec1.c1spol = peSpol;
       k1hec1.c1sspo = peSspo;
       chain %kds(k1hec1:5) pahec1;
       if not %found;
          %subst(@@repl:01:3) = %editc(peSspo:'X');
          %subst(@@repl:04:6) = %trim(%char(peArcd));
          %subst(@@repl:10:9) = %trim(%char(peSpol));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPO0002'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
          peErro = -1;
          return;
       endif;

       k1hcd5.d5empr = peBase.peEmpr;
       k1hcd5.d5sucu = peBase.peSucu;
       k1hcd5.d5arcd = peArcd;
       k1hcd5.d5spol = peSpol;
       k1hcd5.d5sspo = peSspo;
       k1hcd5.d5rama = peRama;
       k1hcd5.d5arse = peArse;
       k1hcd5.d5oper = peOper;
       k1hcd5.d5suop = peSuop;
       setll %kds(k1hcd5:9) pahcd5;
       reade %kds(k1hcd5:9) pahcd5;
       dow not %eof and peCuotC < 100;

           peCuotC += 1;

           peCuot(peCuotC).cdsspo = d5sspo;
           peCuot(peCuotC).cdsuop = d5suop;
           peCuot(peCuotC).cdnrcu = d5nrcu;
           peCuot(peCuotC).cdnrsc = d5nrsc;
           peCuot(peCuotC).cdmone = c1mone;
           chain c1mone gntmon;
           if %found;
              peCuot(peCuotC).cdnmoc = monmoc;
            else;
              peCuot(peCuotC).cdnmoc = *all'?';
           endif;
           fecha = (d5fvca * 10000) + (d5fvcm * 100) + d5fvcd;
           test(de) *iso fecha;
           if %error;
              peCuot(peCuotC).cdfcuo = d'0001-01-01';
            else;
              peCuot(peCuotC).cdfcuo = %date(fecha:*iso);
           endif;
           peCuot(peCuotC).cdimcu = d5imcu;

           k1hcd6.d6empr = d5empr;
           k1hcd6.d6sucu = d5sucu;
           k1hcd6.d6arcd = d5Arcd;
           k1hcd6.d6spol = d5Spol;
           k1hcd6.d6sspo = d5Sspo;
           k1hcd6.d6rama = d5Rama;
           k1hcd6.d6arse = d5Arse;
           k1hcd6.d6oper = d5Oper;
           k1hcd6.d6suop = d5Suop;
           k1hcd6.d6nrcu = d5nrcu;
           k1hcd6.d6nrsc = d5nrsc;
           setll %kds(k1hcd6:11) pahcd6;
           reade %kds(k1hcd6:11) pahcd6;
           dow not %eof;
               peCuot(peCuotC).cdnras = d6nras;
               fecha = (d6fasa * 10000) + (d6fasm * 100) + d6fasd;
               test(de) *iso fecha;
               if %error;
                  peCuot(peCuotC).cdfpag = d'0001-01-01';
                else;
                  peCuot(peCuotC).cdfpag = %date(fecha:*iso);
               endif;
               fecha = (d6rpaa * 10000) + (d6rpmm * 100) + d6rpdd;
               test(de) *iso fecha;
               if %error;
                  peCuot(peCuotC).cdfrealpag = d'0001-01-01';
                else;
                  peCuot(peCuotC).cdfrealpag = %date(fecha:*iso);
               endif;
               peCuot(peCuotC).cdimpag += d6prem;
            reade %kds(k1hcd6:11) pahcd6;
           enddo;

        reade %kds(k1hcd5:9) pahcd5;
       enddo;

       return;

