     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB16:WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _marcarQuincActualSuperPolizaEndoso()  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB16        pr                  ExtPgm('PLQWEB16')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB16        pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_marcarQuincenaActualSuperPolizaEndoso( peBase
                                                   : peNrpl
                                                   : peArcd
                                                   : peSpol
                                                   : peSspo
                                                   : peImpn
                                                   : peImpb
                                                   : peErro
                                                   : peMsgs  );

       return;

      /end-free
