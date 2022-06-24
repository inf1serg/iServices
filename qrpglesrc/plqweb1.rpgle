     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PLQWEB1: WebService                                          *
      *          Preliquidación Web                                  *
      *          Wrapper para _nuevaPreliquidacion()                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *23-Sep-2015        *
      * ------------------------------------------------------------ *
      * SGF 18/07/2020: Agrego parametro para saber si incluye o no  *
      *                 debito automatico.                           *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB1         pr                  ExtPgm('PLQWEB1')
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0
     D   peFhas                       8  0
     D   peDaut                       1a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PLQWEB1         pi
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0
     D   peFhas                       8  0
     D   peDaut                       1a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

      /free

       *inlr = *on;

       PLQWEB_nuevaPreliquidacion( peBase
                                 : peNrpl
                                 : peFhas
                                 : peDaut
                                 : peErro
                                 : peMsgs  );

       return;

      /end-free
