     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB27:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _insertarCheque()                      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB27        pr                  ExtPgm('PLQWEB27')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNche                      30    const
     D   peFche                       8  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB27        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNche                      30    const
     D   peFche                       8  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_insertarCheque( peBase
                            : peNrpl
                            : peIvbc
                            : peNche
                            : peFche
                            : peEfvo
                            : peErro
                            : peMsgs );

       return;

      /end-free
