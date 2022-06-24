     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWGRA9: Retorna Topes de EPV                             *
      * --------------------------------------------------------- *
      * Sergio Fernandez                    *29-Mar-2016          *
      * --------------------------------------------------------- *
      * Modificaciones:                                           *
      *                                                           *
      * ********************************************************* *

     D COWGRA9         pr                  extpgm('COWGRA9')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peEpvm                        3  0
     D  peEpvx                        3  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWGRA9         pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peEpvm                        3  0
     D  peEpvx                        3  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

      /free

       *inlr = *on;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>COWGRA9 (Request)</b>'               + CRLF
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
            + 'PENCTW: '  + %editc(peNctw:'X')         + CRLF
            + 'PERAMA: '  + %editc(peRama:'X');
       COWLOG_log( peBase : peNctw : Data );

       COWGRAI_getTopesEpv( peBase
                          : peRama
                          : peEpvm
                          : peEpvx
                          : peErro
                          : peMsgs );

       COWGRAI_End();

       Data = '<br><br>'
            + '<b>COWGRA9 (Response)</b>'           + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))            + CRLF
            + 'PEEPVM: ' + %editw(peEpvm:' 0 ')     + CRLF
            + 'PEEPVX: ' + %editw(peEpvx:' 0 ')     + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data =                                               CRLF
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
