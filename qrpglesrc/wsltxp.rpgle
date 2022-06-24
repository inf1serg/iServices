     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLTXP  : Tareas generales.                                  *
      *           WebService - Retorna Texto de una CLausula de Póli *
      *           za/endoso                                          *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda                             *09-May-2015  *
      * ************************************************************ *
     Fpahec1    if   e           k disk
     Fpahed004  if   e           k disk
     Fset126    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLTXP          pr                  ExtPgm('WSLTXP')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peClau                       9    const
     D   peText                            likeds(clatxt_t) dim(9999)
     D   peTextC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLTXP          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peClau                       9    const
     D   peText                            likeds(clatxt_t) dim(9999)
     D   peTextC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SP0068W         pr                  extpgm('SP0068W')
     D   pEmpr                        1a
     D   pSucu                        2a
     D   pArcd                        6  0
     D   pSpol                        9  0
     D   pSspo                        3  0
     D   pRama                        2  0
     D   pArse                        2  0
     D   pOper                        7  0
     D   pSuop                        3  0
     D   pCla                         3a   dim(60)
     D   pClan                        9a   dim(60) options(*nopass:*omit)
     D   pAnex                        1a   dim(60) options(*nopass:*omit)

     D WSXTXC          pr                  ExtPgm('WSXTXC')
     D  paRama                        2  0
     D  paNlib                        2  0
     D  paClau                        3a
     D  paTpds                      240a   dim(9999)
     D  paTpdsC                      10i 0


     D khec1           ds                  likerec(p1hec1:*key)

     D kset126         ds                  likerec(s1t126:*key)

     D khed004         ds                  likerec(p1hed004:*key)

     D beneficiar      ds                  likerec(p1hec1)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D i               s             10i 0

     D Clau            s              3a
     D pxCla           s              3a   dim(60)
     D pxClan          s              9a   dim(60)
     D pxAnex          s              1a   dim(60)
     D pxTpds          s            240a   dim(9999)
     D pxTpdsC         s             10i 0

     d pxArse          s              2  0
     d pxOper          s              7  0

       *inLr = *On;

      *- Validaciones
      *- Valido Parametros Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

      *- Valido Existe Poliza
       khed004.d0empr = peBase.peEmpr;
       khed004.d0sucu = peBase.peSucu;
       khed004.d0rama = peRama;
       khed004.d0poli = pePoli;

       setll %kds ( khed004:4 ) pahed004;

       if not %equal(pahed004);

          @@Repl = %editw( peRama : '0 ' )
                 + %editw( pePoli : '0      ' );
          %subst(@@repl:1:2) = %editc(peRama:'X');
          %subst(@@repl:3:7) = %trim(%char(pePoli));
          @@Leng = %len ( %trim ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                          peMsgs : @@repl  : @@leng );
          peErro = -1;
          return;

       endif;

       peTextC = *Zeros;
       peErro = *Zeros;

       clear peText;
       clear peMsgs;

       khec1.c1empr = peBase.peEmpr;
       khec1.c1sucu = peBase.peSucu;
       khec1.c1arcd = peArcd;
       khec1.c1spol = peSpol;
       khec1.c1sspo = peSspo;

       chain %kds ( khec1 : 5 ) pahec1;

       if %found ( pahec1 );

          kset126.t@rama = peRama;
          kset126.t@fioa = c1fioa;
          kset126.t@fiom = c1fiom;
          kset126.t@fiod = c1fiod;

          setgt  %kds ( kset126 : 4 ) set126;
          readpe %kds ( kset126 : 1 ) set126;

          if not %eof( set126 );

             clear pxCla ;
             clear pxClan;
             clear pxAnex;

             pxArse  =  peArse;
             pxOper  =  peOper;

             SP0068W(
             C1empr:
             C1sucu:
             C1Arcd:
             C1spol:
             C1sspo:
             T@rama:
             pxarse:
             pxoper:
             c1sspo:
             pxCla :
             pxClan:
             pxAnex);

             i = *zero;

             Clau = %subst(peClau:1:3);

             i = %lookup(Clau:pxCla :1);

             if i = *zero;
                i = %lookup(peClau:pxClan:1);
             endif;

             if i >= 1;
                WSXTXC(
                t@rama:
                t@nlib:
                pxCla (i):
                pxTpds:
                pxTpdsC);

                for i = 1 to pxTpdsC;

                   peText(i).tpds = pxTpds(i);

                endfor;

                peTextC = pxTpdsC;
             endif;

          endif;


       endif;

       return;
