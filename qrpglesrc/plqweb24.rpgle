     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB24:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _listarCuotasMarcadas()                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB24        pr                  ExtPgm('PLQWEB24')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keycmar_t) const
     D   pePreg                            likeds(keycmar_t)
     D   peUreg                            likeds(keycmar_t)
     D   peLdet                            likeds(listcmar_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB24        pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(keycmar_t) const
     D   pePreg                            likeds(keycmar_t)
     D   peUreg                            likeds(keycmar_t)
     D   peLdet                            likeds(listcmar_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_listarCuotasMarcadas( peBase
                                  : peCant
                                  : peRoll
                                  : pePosi
                                  : pePreg
                                  : peUreg
                                  : peLdet
                                  : peLdetC
                                  : peMore
                                  : peErro
                                  : peMsgs );

       return;

      /end-free
