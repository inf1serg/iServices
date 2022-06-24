     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLBVP  : Tareas generales.                                  *
      *           WebService - Retorna beneficiarios de póliza vida. *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *16-May-2017  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *   JSN 22-07-2020 - Se modifica la cantidad de campos de la   *
      *                    clave para la lectura del archivo pahev91 *
      *                                                              *
      * ************************************************************ *
     Fpahev91   if   e           k disk
     Fpahed004  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLBVP          pr                  ExtPgm('WSLBVP')
     D  peBase                             likeds(paramBase) const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peLben                             likeds(pahev91_t) dim(99)
     D  peLbenC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D WSLBVP          pi
     D  peBase                             likeds(paramBase) const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peLben                             likeds(pahev91_t) dim(99)
     D  peLbenC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D ok              s              1n
     D @@repl          s          65535a
     D inv91           ds                  likerec(p1hev9:*input)
     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1hev9          ds                  likerec(p1hev9:*key)

      /free

       *inlr = *on;

       clear peLben;
       clear peMsgs;
       peLbenC = 0;
       peErro  = 0;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       setll %kds(k1hed0:4) pahed004;
       if not %equal(pahed004);
          %subst(@@repl:1:2) = %trim(%char(peRama));
          %subst(@@repl:3:7) = %trim(%char(pePoli));
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                          peMsgs : %trim(@@repl) : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       ok = *off;

       k1hev9.v9empr = peBase.peEmpr;
       k1hev9.v9sucu = peBase.peSucu;
       k1hev9.v9arcd = peArcd;
       k1hev9.v9spol = peSpol;
       setgt %kds(k1hev9:4) pahev91;
       readpe %kds(k1hev9:4) pahev91;
       dow not %eof;
           if v9rama = peRama and
              v9poli = pePoli;
              ok = *on;
              leave;
           endif;
        readpe %kds(k1hev9:4) pahev91;
       enddo;

       if ok = *off;
          return;
       endif;

       k1hev9.v9empr = peBase.peEmpr;
       k1hev9.v9sucu = peBase.peSucu;
       k1hev9.v9arcd = peArcd;
       k1hev9.v9spol = peSpol;
       k1hev9.v9sspo = v9sspo;
       setll %kds(k1hev9:5) pahev91;
       reade %kds(k1hev9:5) pahev91 inv91;
       dow not %eof;

           peLbenC += 1;
           eval-corr peLben(peLbenC) = inv91;

        reade %kds(k1hev9:5) pahev91 inv91;
       enddo;

       return;

      /end-free

