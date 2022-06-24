     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWSND4: WebService                                          *
      *          Propuesta Web                                       *
      *          Wrapper para _sendPropuesta2()                      *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                         *08-Sep-2017        *
      * ************************************************************ *

      /copy './qcpybooks/prwsnd_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'

     D PRWSND4         pr                  ExtPgm('PRWSND4')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peNuse                      50    const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWSND4         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peNuse                      50    const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWSND3         pr                  ExtPgm('PRWSND3')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D @@nuse          s             50

      /free

       *inlr = *on;

       separa = *all'-';

       peSoln = 0;

       Data = '<br><br>'
            + '<b>PRWSND4 (Request)</b>'               + CRLF
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
            + 'PENUSE: '  + peNuse                     + CRLF
            + 'PEFDES: '  + %editc(peFdes:'X')         + CRLF
            + 'PEFHAS: '  + %editc(peFhas:'X');
       COWLOG_log( peBase : peNctw : Data );

       PRWSND3( peBase
              : peNctw
              : peFdes
              : peFhas
              : peSoln
              : peErro
              : peMsgs );

       if peErro = 0;
          @@nuse = peNuse;
          COWGRAI_updCabecera( peBase
                             : peNctw
                             : peErro
                             : peMsgs
                             : *omit
                             : *omit
                             : *omit
                             : @@nuse );

       endif;

       return;

      /end-free
