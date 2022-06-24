     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLTXU : WebService - Retorna texto clausula bien asegurado. *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            08/06/2015    *
      * ************************************************************ *
     Fpahed004  if   e           k disk
     Fpaher995  if   e           k disk
     Fpahet995  if   e           k disk
     Fpahec1    if   e           k disk
     Fset001    if   e           k disk
     Fset126    if   e           k disk    prefix(X_)

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLTXU          pr                  ExtPgm('WSLTXU')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peClau                       9    const
     D   peText                            likeds(clatxt_t) dim(9999)
     D   peTextC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLTXU          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peClau                       9    const
     D   peText                            likeds(clatxt_t) dim(9999)
     D   peTextC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SP0068D         pr                  extpgm('SP0068D')
     D   pEmpr                        1a
     D   pSucu                        2a
     D   pArcd                        6  0
     D   pSpol                        9  0
     D   pSspo                        3  0
     D   pRama                        2  0
     D   pArse                        2  0
     D   pOper                        7  0
     D   pSuop                        3  0
     D   pPoco                        4  0
     D   pClau                        3a   dim(30)
     D   pClan                        9a   dim(30) options(*nopass:*omit)

     D WSXTXC          pr                  ExtPgm('WSXTXC')
     D  paRama                        2  0
     D  paNlib                        2  0
     D  paClau                        3a
     D  paTpds                      240a   dim(9999)
     D  paTpdsC                      10i 0

     D khed004         ds                  likerec(p1hed004:*key)

     D kher995         ds                  likerec(p1her9:*key)

     D khet995         ds                  likerec(p1het9:*key)

     D khec1           ds                  likerec(p1hec1:*key)

     D kset126         ds                  likerec(s1t126:*key)

     D @@Poco          s              6  0
     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D i               s             10i 0

     D Clau            s              3a
     D pxClau          s              3a   dim(30)
     D pxClan          s              9a   dim(30)
     D pxTpds          s            240a   dim(9999)
     D pxTpdsC         s             10i 0

       *inLr = *On;

       clear peText;
       clear peTextC;
       clear peErro;
       clear peMsgs;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Exista Poliza
       khed004.d0empr = peBase.peEmpr;
       khed004.d0sucu = peBase.peSucu;
       khed004.d0rama = peRama;
       khed004.d0poli = pePoli;

       chain %kds(khed004:4) pahed004;

       if not %found( pahed004 );

         @@Repl =   %editw ( peRama : '0 ')
                +   %editw ( pePoli : '0      ' );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                             peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;

       endif;

      *- Valido Poliza de Riesgos Varios o Autos
       clear t@rame;
       chain (peRama) set001;

       if t@rame = 18 or t@rame = 21;

         @@Repl =   %editw ( peRama : '0 ')
                +   %editw ( pePoli : '0      ' );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                             peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;

       endif;

       if t@rame = 4;

      *- Valido Exista Componente (Autos)
          khet995.t9empr = peBase.peEmpr;
          khet995.t9sucu = peBase.peSucu;
          khet995.t9rama = peRama;
          khet995.t9poli = pePoli;
          khet995.t9spol = peSpol;
          khet995.t9poco = pePoco;
          khet995.t9arcd = d0arcd;
          khet995.t9arse = d0arse;
          khet995.t9oper = d0oper;

          chain %kds(khet995:6) pahet995;

          if not %found( pahet995 );

            @@Poco = pePoco;
            @@Repl =   %editw ( @@Poco : '0     ')
                   +   %editw ( peRama : '0 ')
                   +   %editw ( pePoli : '0      ' );
            @@Leng = %len ( %trimr ( @@repl ) );
            SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'BIE0001' :
                             peMsgs : @@Repl  : @@Leng );
            peErro = -1;
            return;

          else;

            khec1.c1empr = peBase.peEmpr;
            khec1.c1sucu = peBase.peSucu;
            khec1.c1arcd = t9arcd;
            khec1.c1spol = peSpol;
            khec1.c1sspo = t9sspo;

            r9empr = t9empr;
            r9sucu = t9sucu;
            r9rama = t9rama;
            r9arcd = t9arcd;
            r9spol = t9spol;
            r9sspo = t9sspo;
            r9arse = t9arse;
            r9oper = t9oper;
            r9poco = t9poco;

          endif;

       endif;

       if t@rame <> 4 and t@rame <> 18 and t@rame <> 21;

      *- Valido Exista Componente (Riesgos Varios)
          kher995.r9empr = peBase.peEmpr;
          kher995.r9sucu = peBase.peSucu;
          kher995.r9rama = peRama;
          kher995.r9poli = pePoli;
          kher995.r9spol = peSpol;
          kher995.r9poco = pePoco;
          kher995.r9arcd = d0arcd;
          kher995.r9arse = d0arse;
          kher995.r9oper = d0oper;

          chain %kds(kher995:6) paher995;

          if not %found( paher995 );

            @@Poco = pePoco;
            @@Repl =   %editw ( @@Poco : '0     ')
                   +   %editw ( peRama : '0 ')
                   +   %editw ( pePoli : '0      ' );
            @@Leng = %len ( %trimr ( @@repl ) );
            SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'BIE0001' :
                             peMsgs : @@Repl  : @@Leng );
            peErro = -1;
            return;

          else;

             khec1.c1empr = peBase.peEmpr;
             khec1.c1sucu = peBase.peSucu;
             khec1.c1arcd = r9arcd;
             khec1.c1spol = peSpol;
             khec1.c1sspo = r9sspo;

          endif;

       endif;

       chain %kds ( khec1:5) pahec1;

       if %found ( pahec1 );

          kset126.X_t@rama = peRama;
          kset126.X_t@fioa = c1fioa;
          kset126.X_t@fiom = c1fiom;
          kset126.X_t@fiod = c1fiod;

          setgt  %kds ( kset126 : 4 ) set126;
          readpe %kds ( kset126 : 1 ) set126;

          if not %eof( set126 );

             clear pxClau;
             clear pxClan;

             SP0068D(
             r9empr:
             r9sucu:
             r9arcd:
             r9spol:
             r9sspo:
             r9rama:
             r9arse:
             r9oper:
             r9sspo:
             r9poco:
             pxClau:
             pxClan);

             i = *zero;

             Clau = %subst(peClau:1:3);

             i = %lookup(Clau:pxClau:1);

             if i = *zero;
                i = %lookup(peClau:pxClan:1);
             endif;

             if i = *zero;
                @@Poco = pePoco;
                @@Repl =   %editw ( @@Poco : '0     ')
                      +    peClau ;
                @@Leng = %len ( %trimr ( @@repl ) );
                SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CLA0003' :
                             peMsgs : @@Repl  : @@Leng );
                peErro = -1;
                return;
             endif;

             WSXTXC(
             r9Rama:
             X_t@nlib:
             pxClau(i):
             pxTpds:
             pxTpdsC);

             for i = 1 to pxTpdsC;

                peText(i).tpds = pxTpds(i);

             endfor;

             peTextC = pxTpdsC;

          endif;

       endif;

       return;
