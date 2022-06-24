     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB35:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _insertarECheque()                     *
      * ------------------------------------------------------------ *
      * Facundo Astiz                            *17-Feb-2022        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB35        pr                  ExtPgm('PLQWEB35')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNech                      30    const
     D   peFche                       8  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB35        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peIvbc                       3  0 const
     D   peNech                      30    const
     D   peFche                       8  0 const
     D   peEfvo                      15  2 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_insertarECheque( peBase
                             : peNrpl
                             : peIvbc
                             : peNech
                             : peFche
                             : peEfvo
                             : peErro
                             : peMsgs );

       return;

      /end-free
