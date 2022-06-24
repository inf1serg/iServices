     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB28:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _borrarCheque()                        *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB28        pr                  ExtPgm('PLQWEB28')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNche                      30    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB28        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNche                      30    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_borrarCheque  ( peBase
                            : peNrpl
                            : peIvbc
                            : peNche
                            : peErro
                            : peMsgs );

       return;

      /end-free
