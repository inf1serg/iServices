     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB31:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _enviarPreliquidacion()                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB31        pr                  ExtPgm('PLQWEB31')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB31        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_enviarPreliquidacion( peBase
                                  : peNrpl
                                  : peErro
                                  : peMsgs );

       return;

      /end-free
