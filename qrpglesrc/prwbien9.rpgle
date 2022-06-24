     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWBIEN9:WebService                                          *
      *          Propuesta Web                                       *
      *          Wrapper para _insertAsegurado()                     *
      * ------------------------------------------------------------ *
      * Julio Barranco                           *23-Nov-2015        *
      * ************************************************************ *

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/prwbien_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWBIEN9        pr                  ExtPgm('PRWBIEN9')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peNomb                      20    const
     D   peApel                      20    const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peSuas                      13  0 const
     D   peSmue                      13  0 const
     D   peSinv                      13  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWBIEN9        pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peSecu                       2  0 const
     D   peNomb                      20    const
     D   peApel                      20    const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peSuas                      13  0 const
     D   peSmue                      13  0 const
     D   peSinv                      13  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>PRWBIEN9 (Request)</b>'              + CRLF
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
            + 'PESECU: '  + %editc(peSecu:'X')         + CRLF
            + 'PENOMB: '  + peNomb                     + CRLF
            + 'PEAPEL: '  + peApel                     + CRLF
            + 'PETIDO: '  + %editc(peTido:'X')         + CRLF
            + 'PENRDO: '  + %editc(peNrdo:'X')         + CRLF
            + 'PEFNAC: '  + %editc(peFnac:'X')         + CRLF
            + 'PESUAS: '  +
                       %editw(peSuas:' .   .   . 0 .   ') + CRLF
            + 'PESMUE: '  +
                       %editw(peSmue:' .   .   . 0 .   ') + CRLF
            + 'PESINV: '  +
                       %editw(peSinv:' .   .   . 0 .   ');
       COWLOG_log( peBase : peNctw : Data );

       PRWBIEN_insertAsegurado( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : pePoco
                              : peRiec
                              : peXcob
                              : peSecu
                              : peNomb
                              : peApel
                              : peTido
                              : peNrdo
                              : peFnac
                              : peSuas
                              : peSmue
                              : peSinv
                              : peErro
                              : peMsgs );

       Data = '<br><br>'
            + '<b>PRWBIEN9 (Response)</b>'             + CRLF
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
