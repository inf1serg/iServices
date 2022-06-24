     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ************************************************************ *
      * WSLCU1  : Tareas generales.                                  *
      *           WebService - Retorna las cuotas impagas de una     *
      *           póliza.                                            *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *20-Ene-2017  *
      * ------------------------------------------------------------ *
      * SGF 18/04/2020: Agrego moneda.                               *
      * ************************************************************ *
     Fpahcd5    if   e           k disk
     Fpahec0    if   e           k disk
     Fpahec1    if   e           k disk
     Fpahed004  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLCU1          pr                  ExtPgm('WSLCU1')
     D  peBase                             likeds(paramBase) const
     D  pePosi                             likeds(keycu1_t) const
     D  peLcuo                             likeds(cuotasImp_t) dim(100)
     D  peLcuoC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D WSLCU1          pi
     D  peBase                             likeds(paramBase) const
     D  pePosi                             likeds(keycu1_t) const
     D  peLcuo                             likeds(cuotasImp_t) dim(100)
     D  peLcuoC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D k1hec0          ds                  likerec(p1hec0   : *key)
     D k1hec1          ds                  likerec(p1hec1   : *key)
     D k1hed0          ds                  likerec(p1hed004 : *key)
     D k1hcd5          ds                  likerec(p1hcd5   : *key)
     D cuotasOrd       ds                  likeds(cuotasOrd_t) dim(100)

     D @@repl          s          65535a
     D ford            s              8  0
     D x               s             10i 0
     D y               s             10i 0
     D z               s             10i 0

     D cuotasOrd_t     ds                  qualified template
     D  nrcu                          2  0
     D  nrsc                          2  0
     D  sspo                          3  0
     D  suop                          3  0
     D  fvto                         10a
     D  imcu                         15  2
     D  ford                          8  0

      /free

       *inlr = *on;

       peErro  = *Zeros;
       peLcuoC = *Zeros;
       clear peLcuo;
       clear peMsgs;
       clear cuotasOrd;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       k1hec0.c0empr = peBase.peEmpr;
       k1hec0.c0sucu = peBase.peSucu;
       k1hec0.c0arcd = pePosi.arcd;
       k1hec0.c0spol = pePosi.spol;
       setll %kds(k1hec0:4) pahec0;
       if not %equal;
          %subst(@@repl:1:6) = %trim(%char(pePosi.arcd));
          %subst(@@repl:7:9) = %trim(%char(pePosi.spol));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPO0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
          peErro = -1;
          return;
       endif;

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = pePosi.rama;
       k1hed0.d0poli = pePosi.poli;
       setll %kds(k1hed0:4) pahed004;
       if not %equal;
          %subst(@@repl:1:2) = %editc(pePosi.rama:'X');
          %subst(@@repl:3:7) = %trim(%char(pePosi.poli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
          peErro = -1;
          return;
       endif;

       k1hcd5.d5empr = peBase.peEmpr;
       k1hcd5.d5sucu = peBase.peSucu;
       k1hcd5.d5arcd = pePosi.arcd;
       k1hcd5.d5spol = pePosi.spol;

       setll %kds(k1hcd5:4) pahcd5;
       reade %kds(k1hcd5:4) pahcd5;
       dow not %eof and peLcuoC < 100;

           if d5sttc <> '3';
              peLcuoC += 1;
              peLcuo(peLcuoC).mone = d5mone;
              peLcuo(peLcuoC).nrcu = d5nrcu;
              peLcuo(peLcuoC).nrsc = d5nrsc;
              peLcuo(peLcuoC).suop = d5suop;
              peLcuo(peLcuoC).sspo = d5sspo;
              peLcuo(peLcuoC).fvto = %editc(d5fvcd:'X')
                                   + '/'
                                   + %editc(d5fvcm:'X')
                                   + '/'
                                   + %editc(d5fvca:'X');
              ford = (d5fvca * 10000)
                   + (d5fvcm *   100)
                   +  d5fvcd;
              k1hec1.c1empr = d5empr;
              k1hec1.c1sucu = d5sucu;
              k1hec1.c1arcd = d5arcd;
              k1hec1.c1spol = d5spol;
              k1hec1.c1sspo = d5sspo;
              chain %kds(k1hec1) pahec1;
              if %found;
                 if c1come <= 0;
                    c1come = 1;
                 endif;
              endif;
              peLcuo(peLcuoC).imcu = d5imcu;
              eval-corr cuotasOrd(peLcuoC) = peLcuo(peLcuoC);
              cuotasOrd(peLcuoC).ford = ford;
           endif;

        reade %kds(k1hcd5:4) pahcd5;
       enddo;

       sorta cuotasOrd(*).ford;
       x = 100 - peLcuoC + 1;
       z = 0;
       for y = x to 100;
           z += 1;
           eval-corr peLcuo(z) = cuotasOrd(y);
       endfor;

       return;

      /end-free
