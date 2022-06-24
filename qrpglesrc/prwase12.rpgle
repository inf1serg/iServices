     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWASE12 :WebService                                         *
      *          Propuesta Web                                       *
      *          Wrapper para _inserBeneficiarioV2()                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *22-Mar-2017        *
      * ************************************************************ *

      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWASE12        pr                  ExtPgm('PRWASE12')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peCuil                      11a   const
     D   peCnre                       1a   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWASE12        pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peCuil                      11a   const
     D   peCnre                       1a   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

       *inlr = *on;

       peErro = 0;
       clear peMsgs;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>PRWASE12 (Request)</b>'                   + CRLF
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
            + 'PERAMA: '  + %editc(peRama:'X')              + CRLF
            + 'PEARSE: '  + %editc(peArse:'X')              + CRLF
            + 'PESECU: '  + %editc(peSecu:'X')              + CRLF
            + 'PENOMB: '  + peNomb                          + CRLF
            + 'PECUIL: '  + peCuil                          + CRLF
            + 'PECNRE: '  + peCnre                          + CRLF
            + 'PETIDO: '  + %editc(peTido:'X')              + CRLF
            + 'PENRDO: '  + %editc(peNrdo:'X');
       COWLOG_log( peBase : peNctw : Data );

       PRWASE_insertBeneficiarioV2( peBase
                                  : peNctw
                                  : peRama
                                  : peArse
                                  : peSecu
                                  : peNomb
                                  : peTido
                                  : peNrdo
                                  : peCuil
                                  : peCnre
                                  : peErro
                                  : peMsgs );

       Data = '<br><br>'
            + '<b>PRWASE12 (Response)</b>'                 + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                   + CRLF
            + 'PEERRO: ' +  %trim(%char(peErro))           + CRLF
            + 'PEMSGS'                                     + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)      + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid             + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)      + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)      + CRLF
            + 'PEMSGS' + CRLF;
       COWLOG_log( peBase : peNctw : Data );
       Data = separa;
       COWLOG_log( peBase : peNctw : Data );

       return;

      /end-free
