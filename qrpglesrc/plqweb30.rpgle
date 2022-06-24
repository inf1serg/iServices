     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB30:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _borrarDepositoBancario()              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB30        pr                  ExtPgm('PLQWEB30')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNdep                      30a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB30        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNdep                      30a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_borrarDepositoBancario( peBase
                                    : peNrpl
                                    : peIvbc
                                    : peNdep
                                    : peErro
                                    : peMsgs );

       return;

      /end-free
