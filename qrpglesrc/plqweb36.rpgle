     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB36:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _borrarECheque()                       *
      * ------------------------------------------------------------ *
      * Facundo Astiz                            *17-Feb-2022        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB36        pr                  ExtPgm('PLQWEB36')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNech                      30    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB36        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNech                      30    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_borrarECheque  ( peBase
                             : peNrpl
                             : peIvbc
                             : peNech
                             : peErro
                             : peMsgs );

       return;

      /end-free
