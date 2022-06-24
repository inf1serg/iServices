     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWSND2: WebService                                          *
      *          Propuesta Web                                       *
      *          Wrapper para _calculaHasta()                        *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *07-Oct-2015        *
      * ************************************************************ *

      /copy './qcpybooks/prwsnd_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWSND2         pr                  ExtPgm('PRWSND2')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peFhfa                       8  0
     D   peModi                       1a
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWSND2         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peFhfa                       8  0
     D   peModi                       1a
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>PRWSND2 (Request)</b>'               + CRLF
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
            + 'PEFDES: '  + %editc(peFdes:'X');
       COWLOG_log( peBase : peNctw : Data );

       PRWSND_calculaHasta( peBase
                          : peNctw
                          : peFdes
                          : peFhas
                          : peFhfa
                          : peModi
                          : peErro
                          : peMsgs );

       Data = '<br><br>'
            + '<b>PRWSND2 (Response)</b>'                 + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                  + CRLF
            + 'PEFHAS: ' +  %editc(peFhas:'X')            + CRLF
            + 'PEFHFA: ' +  %editc(peFhfa:'X')            + CRLF
            + 'PEMODI: ' +  %trim(peModi)                 + CRLF
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
