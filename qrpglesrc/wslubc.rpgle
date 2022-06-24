     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLUBC  : Tareas generales.                                  *
      *           WebService - Retorna Claúsulas de una ubicación    *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Gronda                                   *24-Abr-2015  *
      * Jorge Gronda -MODIFICADO                       *22-May-2015  *
      * ------------------------------------------------------------ *
      * ************************************************************ *
     Fpaher995  if   e           k disk
     Fpahed004  if   e           k disk
     Fset001    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLUBC          pr                  ExtPgm('WSLUBC')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peCubi                            likeDs(pahrsvs4_t)  DIM(60)
     D   peCubic                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLUBC          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peCubi                            likeDs(pahrsvs4_t)  DIM(60)
     D   peCubic                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SP0068D         pr                  extpgm('SP0068D')
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0
     D   peSpol                       9  0
     D   peSspo                       3  0
     D   peRama                       2  0
     D   peArse                       2  0
     D   peOper                       7  0
     D   peSuop                       3  0
     D   pePoco                       4  0
     D   peClau                       3a   dim(30)
     D   peClan                       9a   dim(30) options(*nopass:*omit)

     D k1hed0          ds                  likerec(p1hed004 : *key)
     D k1her9          ds                  likerec(p1her9   : *key)

     D @@repl          s          65535a
     D @@leng          s             10i 0
     D peClau          s              3a   dim(30)
     D peClan          s              9a   dim(30)
     D @@Poco          s              6  0
     D d               s             10i 0
     D x               s             10i 0

       *inLr = *On;

       peCubiC = *Zeros;
       peErro  = *Zeros;

       clear peCubi;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       chain peRama set001;
       if not %found (set001);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %editw(peRama:'0 ')
                       : %len(%editw(peRama:'0 ')) );
          peErro = -1;
          return;
       endif;

      if t@rame = 18 or t@rame = 21 or t@rame = 4;
         @@Repl = %editw( peRama : '0 ' ) + %editw(pePoli : '0      '  );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                         peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;
       endif;

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       chain %kds(k1hed0:4) pahed004;
       if not %found;
          @@Repl = %editw( peRama : '0 ' ) + %editw(pePoli : '0      ' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : @@Repl
                       : %len(%trimr(@@Repl)) );
          peErro = -1;
          return;
       endif;


       k1her9.r9empr = peBase.peEmpr;
       k1her9.r9sucu = peBase.peSucu;
       k1her9.r9rama = peRama;
       k1her9.r9poli = pePoli;
       k1her9.r9spol = peSpol;
       k1her9.r9poco = pePoco;
       chain %kds(k1her9:6) paher995;
       if not %found;
          @@Poco = pePoco;
          @@Repl = %editw( @@Poco : '    0 ' )
                 + %editw( peRama : '0 ' )
                 + %editw(pePoli : '     0 ' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'BIE0001'
                       : peMsgs
                       : @@Repl
                       : %len(%trimr(@@Repl)) );
          peErro = -1;
          return;
       endif;

       SP0068D( peBase.peEmpr
              : peBase.peSucu
              : r9arcd
              : r9spol
              : r9sspo
              : r9rama
              : r9arse
              : r9oper
              : r9sspo
              : r9poco
              : peClau
              : peClan );

       for x = 1 to 30;
           if peClau(x) <> *blanks;
              peCubiC += 1;
              peCubi(peCubiC).clau = peClau(x);
              peCubi(peCubiC).clan = peClan(x);
           endif;
       endfor;

       return;

