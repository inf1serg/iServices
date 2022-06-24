     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * PRWASE11: WebService: wrapper para _deleteClausulaV()     *
      * --------------------------------------------------------- *
      * Alvarez Fernando                     07-Abr-2016          *
      * ********************************************************* *

     D PRWASE11        pr                  ExtPgm('PRWASE11')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWASE11        pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D o               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

       *inlr  = *on;

       Data = CRLF                                          + CRLF
            + '<b>PRWASE11 (Request)</b>'                   + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + 'PEBASE'                                      + CRLF
            + '&nbsp;PEEMPR: ' + peBase.peEmpr              + CRLF
            + '&nbsp;PESUCU: ' + peBase.peSucu              + CRLF
            + '&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
            + '&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
            + '&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
            + '&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
            + 'PEBASE'                                      + CRLF
            + 'PENCTW: ' + %editc(peNctw:'X')               + CRLF
            + 'PERAMA: ' + %editc(peRama:'X')               + CRLF
            + 'PEARSE: ' + %editc(peArse:'X')               + CRLF
            + 'PESECU: ' + %editc(peSecu:'X');
            COWLOG_log( peBase : peNctw : Data );

       PRWASE_deleteClausulaV ( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : peSecu
                              : peErro
                              : peMsgs );

       Data =
              '<br><br><b>PRWASE11 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PENCTW: '       + %editc(peNctw:'X')   + CRLF
            + 'PEERRO: '       +  %trim(%char(peErro))+ CRLF
            + 'PEMSGS'                                + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev) + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid        + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1) + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2) + CRLF
            + 'PEMSGS'                                + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       PRWASE_end();

       return;
