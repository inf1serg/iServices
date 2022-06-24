     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB23:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _listarPreliquidacion()                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB23        pr                  ExtPgm('PLQWEB23')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keypliq_t) const
     D   pePreg                            likeds(keypliq_t)
     D   peUreg                            likeds(keypliq_t)
     D   peLdet                            likeds(listpliq_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB23        pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peOrde                      10a   const
     D   pePosi                            likeds(keypliq_t) const
     D   pePreg                            likeds(keypliq_t)
     D   peUreg                            likeds(keypliq_t)
     D   peLdet                            likeds(listpliq_t) dim(99)
     D   peLdetC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_listarPreliquidacion( peBase
                                  : peCant
                                  : peRoll
                                  : peOrde
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
