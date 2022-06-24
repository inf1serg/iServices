     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB33:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _listaValores()                        *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *24-Abr-2017        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB33        pr                  ExtPgm('PLQWEB33')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peLval                            likeds(listaValores_t) dim(99)
     D   peLvalC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB33        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peLval                            likeds(listaValores_t) dim(99)
     D   peLvalC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       peErro = 0;
       peLvalC= 0;
       clear peMsgs;
       clear peLval;

       PLQWEB_listaValores( peBase
                          : peNrpl
                          : peLval
                          : peLvalC
                          : peErro
                          : peMsgs );

       return;

      /end-free
