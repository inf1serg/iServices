     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB22:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _tipoDePago()                          *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB22        pr                  ExtPgm('PLQWEB22')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peTipo                       2    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB22        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peTipo                       2    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_tipoDePago( peBase
                        : peNrpl
                        : peTipo
                        : peErro
                        : peMsgs  );

       return;

      /end-free
