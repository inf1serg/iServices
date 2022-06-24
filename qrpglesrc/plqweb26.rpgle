     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB26:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _insertarMontoEfectivo()               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB26        pr                  ExtPgm('PLQWEB26')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB26        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_insertarMontoEfectivo( peBase
                                   : peNrpl
                                   : peEfvo
                                   : peErro
                                   : peMsgs );

       return;

      /end-free
