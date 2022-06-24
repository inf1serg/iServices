     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRS002:  WebService                                          *
      *          Pre-Denuncia de Siniestro                           *
      *          Verifica póliza vigente para una patente.           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *09-Ago-2017        *
      * ************************************************************ *
     Fpahet910  if   e           k disk
     Fpahec1    if   e           k disk

      /copy './qcpybooks/svppds_h.rpgle'

     D PRS002          pr                  ExtPgm('PRS002')
     D  peBase                             likeds(paramBase) const
     D  pePate                       25a   const
     D  peFocu                        8  0 const
     D  peHocu                        6  0 const
     D  peRama                        2  0
     D  pePoli                        7  0
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D PRS002          pi
     D  peBase                             likeds(paramBase) const
     D  pePate                       25a   const
     D  peFocu                        8  0 const
     D  peHocu                        6  0 const
     D  peRama                        2  0
     D  pePoli                        7  0
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D SPVIG3          pr                  extpgm('SPVIG3')
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  pePoco                        4  0 const
     D  peFech                        8  0 const
     D  peFemi                        8  0 const
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3    const
     D  peVig2                        1n   options(*nopass) const

     D ok1             s              1n
     D ok2             s              1n
     D peStat          s              1n
     D peSspo          s              3  0
     D peSuop          s              3  0
     D cade            s              5  0 dim(9)
     D @focu           s              8a
     D @fsia           s              4a
     D @fsim           s              2a
     D @fsid           s              2a
     D @fsin           s             10a
     D @repl           s          65535a

     D k1het9          ds                  likerec(p1het9:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)

     D Local           ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(Local:401)
     D  sucu                          2a   overlay(Local:*next)

      /free

       *inlr = *on;

       clear peMsgs;
       peErro = 0;
       peRama = 0;
       pePoli = 0;
       peArcd = 0;
       peSpol = 0;

       if SVPWS_chkParmBase( peBase : peMsgs ) = *off;
          peErro = -1;
          return;
       endif;

       Local.empr = peBase.peEmpr;
       Local.sucu = peBase.peSucu;
       out Local;

       k1het9.t9empr = peBase.peEmpr;
       k1het9.t9sucu = peBase.peSucu;
       k1het9.t9nmat = pePate;
       setll %kds(k1het9:3) pahet910;
       reade %kds(k1het9:3) pahet910;
       dow not %eof;

           if t9poli <> 0;

              ok1 = *off;
              ok2 = *off;

              k1hec1.c1empr = t9empr;
              k1hec1.c1sucu = t9sucu;
              k1hec1.c1arcd = t9arcd;
              k1hec1.c1spol = t9spol;
              setgt  %kds(k1hec1:4) pahec1;
              readpe %kds(k1hec1:4) pahec1;
              if %eof;
                 peErro = -1;
                 return;
              endif;
              cade(1) = c1niv1;
              cade(2) = c1niv2;
              cade(3) = c1niv3;
              cade(4) = c1niv4;
              cade(5) = c1niv5;
              cade(6) = c1niv6;
              cade(7) = c1niv7;
              cade(8) = c1niv8;
              cade(9) = c1niv9;
              if peBase.peNivc = cade(peBase.peNivt);
                 ok1 = *on;
              endif;
              if peBase.peNiv1 = cade(peBase.peNit1);
                 ok2 = *on;
              endif;
              if ok1 and ok2;
                 SPVIG3( t9arcd
                       : t9spol
                       : t9rama
                       : t9arse
                       : t9oper
                       : t9poco
                       : peFocu
                       : 99999999
                       : peStat
                       : peSspo
                       : peSuop
                       : *blanks
                       : *on     );
                 if peStat;
                    peRama = t9rama;
                    pePoli = t9poli;
                    peArcd = t9arcd;
                    peSpol = t9spol;
                    leave;
                 endif;
              endif;
           endif;

        reade %kds(k1het9:3) pahet910;
       enddo;

       if peRama = 0 or pePoli = 0 or peArcd = 0 or peSpol = 0;
          @focu = %editc(peFocu:'X');
          @fsia = %subst(@focu:1:4);
          @fsim = %subst(@focu:5:2);
          @fsid = %subst(@focu:7:2);
          @fsin = @fsid
                + '/'
                + @fsim
                + '/'
                + @fsia;
          %subst(@repl:01:10) = @fsin;
          %subst(@repl:11:25) = pePate;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0005'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );
          peErro = -1;
          return;
       endif;

       return;

      /end-free
