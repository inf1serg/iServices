     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWBIEN13:WebService                                         *
      *          Propuesta Web                                       *
      *          Wrapper para _insertAseguradoV                      *
      * ------------------------------------------------------------ *
      * Aalvarez Fernando                        *28-Dic-2015        *
      * ************************************************************ *

      /copy './qcpybooks/prwbien_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWBIEN13       pr                  ExtPgm('PRWBIEN13')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peNaci                      25    const
     D   peActi                       5  0 const
     D   peCate                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWBIEN13       pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peNaci                      25    const
     D   peActi                       5  0 const
     D   peCate                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

       *inlr = *on;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>PRWBIEN13 (Request)</b>'              + CRLF
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
            + 'PEPACO: '  + %editc(pePaco:'X')         + CRLF
            + 'PENOMB: '  + peNomb                     + CRLF
            + 'PETIDO: '  + %editc(peTido:'X')         + CRLF
            + 'PENRDO: '  + %editc(peNrdo:'X')         + CRLF
            + 'PEFNAC: '  + %editc(peFnac:'X')         + CRLF
            + 'PENACI: '  + peNaci                     + CRLF
            + 'PEACTI: '  + %editc(peActi:'X')         + CRLF
            + 'PECATE: '  + %editc(peCate:'X');
       COWLOG_log( peBase : peNctw : Data );

       PRWBIEN_insertAseguradoV ( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : pePoco
                                : pePaco
                                : peNomb
                                : peTido
                                : peNrdo
                                : peFnac
                                : peNaci
                                : peActi
                                : peCate
                                : peErro
                                : peMsgs );

       Data = '<br><br>'
            + '<b>PRWBIEN13 (Response)</b>'             + CRLF
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
