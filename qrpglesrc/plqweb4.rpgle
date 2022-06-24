     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB4: WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _marcarQuincenaAnterior()              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB4         pr                  ExtPgm('PLQWEB4')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0
     D   peImpb                      15  2
     D   peImpn                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB4         pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0
     D   peImpb                      15  2
     D   peImpn                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_marcarQuincenaAnterior( peBase
                                    : peNrpl
                                    : peImpn
                                    : peImpb
                                    : peErro
                                    : peMsgs  );

       return;

      /end-free
