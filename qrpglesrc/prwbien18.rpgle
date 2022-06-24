     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWBIEN18: WebService                                        *
      *            Propuesta Web                                     *
      *            Wrapper para _dltMascotaAsegurada()               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *16-Mar-2020        *
      * ************************************************************ *

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/prwbien_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWBIEN18       pr                  ExtPgm('PRWBIEN18')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peMsec                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWBIEN18       pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peMsec                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       separa = *all'-';

       Data = CRLF                                     + CRLF
            + '<b>PRWBIEN18'                           + CRLF
            + 'Eliminar mascota asegurada(Request)</b>'+ CRLF
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
            + 'PEMSEC: '  + %editc(peMsec:'X')         + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       PRWBIEN_dltMascotaAsegurada( peBase
                                  : peNctw
                                  : peRama
                                  : peArse
                                  : pePoco
                                  : peRiec
                                  : peXcob
                                  : peMsec
                                  : peErro
                                  : peMsgs );

       Data = '<br><br>'
            + '<b>PRWBIEN18 (Response)</b>'            + CRLF
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
