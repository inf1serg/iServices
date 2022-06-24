     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWFPG1: WebService                                          *
      *          Propuesta Web                                       *
      *          Wrapper para _insertarFormaDePago()                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *07-Oct-2015        *
      * ************************************************************ *

      /copy './qcpybooks/PRWFPG_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWFPG1         pr                  ExtPgm('PRWFPG1')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peCfpg                        1  0 const
     D  peNcbu                       22  0 const
     D  peCtcu                        3  0 const
     D  peNrtc                       20  0 const
     D  peFema                        4  0 const
     D  peFemm                        2  0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D PRWFPG1         pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peCfpg                        1  0 const
     D  peNcbu                       22  0 const
     D  peCtcu                        3  0 const
     D  peNrtc                       20  0 const
     D  peFema                        4  0 const
     D  peFemm                        2  0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>PRWFPG1  (Request)</b>'              + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEBASE'                                 + CRLF
            + '&nbsp;PEEMPR: ' + peBase.peEmpr         + CRLF
            + '&nbsp;PESUCU: ' + peBase.peSucu         + CRLF
            + '&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
            + '&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
            + '&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
            + '&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
            + 'PEBASE'                                 + CRLF
            + 'PECFPG: '  + %editc(peCfpg:'X')         + CRLF
            + 'PENCBU: '  + %editc(peNcbu:'X')         + CRLF
            + 'PECTCU: '  + %editc(peCtcu:'X')         + CRLF
            + 'PENRTC: '  + %editc(peNrtc:'X')         + CRLF
            + 'PEFEMA: '  + %editc(peFema:'X')         + CRLF
            + 'PEFEMM: '  + %editc(peFemm:'X');
       COWLOG_log( peBase : peNctw : Data );

       PRWFPG_insertFormaDePago( peBase
                               : peNctw
                               : peCfpg
                               : peNcbu
                               : peCtcu
                               : peNrtc
                               : peFema
                               : peFemm
                               : peErro
                               : peMsgs );

       Data = '<br><br>'
            + '<b>PRWFPG1 (Response)</b>'                 + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                  + CRLF
            + 'PEERRO: ' +  %trim(%char(peErro))          + CRLF
            + 'PEMSGS'                                    + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
            + 'PEMSGS' + CRLF;
       COWLOG_log( peBase : peNctw : Data );
       Data = separa;
       COWLOG_log( peBase : peNctw : Data );

       return;

      /end-free
