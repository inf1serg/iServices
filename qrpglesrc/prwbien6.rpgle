     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWBIEN6:WebService                                          *
      *          Propuesta Web                                       *
      *          Wrapper para _insertObjetoAsegurado()               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *07-Oct-2015        *
      * ************************************************************ *

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/prwbien_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWBIEN6        pr                  ExtPgm('PRWBIEN6')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const
     D   peObje                      74a   const
     D   peSuas                      15  2 const
     D   peMarc                      45a   const
     D   peMode                      45a   const
     D   peNser                      45a   const
     D   peDeta                     400a   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWBIEN6        pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const
     D   peOsec                       9  0 const
     D   peObje                      74a   const
     D   peSuas                      15  2 const
     D   peMarc                      45a   const
     D   peMode                      45a   const
     D   peNser                      45a   const
     D   peDeta                     400a   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a


      /free

       *inlr = *on;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>PRWBIEN6 (Request)</b>'              + CRLF
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
            + 'PERAMA: '  + %editc(peRama:'X')         + CRLF
            + 'PEARSE: '  + %editc(peArse:'X')         + CRLF
            + 'PEPOCO: '  + %editc(pePoco:'X')         + CRLF
            + 'PERIEC: '  + peRiec                     + CRLF
            + 'PEXCOB: '  + %editc(peXcob:'X')         + CRLF
            + 'PEOSEC: '  + %editc(peOsec:'X')         + CRLF
            + 'PEOBJE: '  + %trim(peObje)              + CRLF
            + 'PESUAS: '  +
                     %editw(peSuas:' .   .   .   . 0 ,  ') + CRLF
            + 'PEMARC: '  + %trim(peMarc)              + CRLF
            + 'PEMODE: '  + %trim(peMode)              + CRLF
            + 'PENSER: '  + %trim(peNser)              + CRLF
            + 'PEDETA: '  + %trim(peDeta) + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       PRWBIEN_setObjetoAsegurado( peBase
                                 : peNctw
                                 : peRama
                                 : peArse
                                 : pePoco
                                 : peRiec
                                 : peXcob
                                 : peOsec
                                 : peObje
                                 : peSuas
                                 : peMarc
                                 : peMode
                                 : peNser
                                 : peDeta
                                 : peErro
                                 : peMsgs );

       Data = '<br><br>'
            + '<b>PRWBIEN6 (Response)</b>'             + CRLF
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
