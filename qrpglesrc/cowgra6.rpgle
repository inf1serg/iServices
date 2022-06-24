     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWGRA6: Validar que sea una persona Valida para emitir   *
      * --------------------------------------------------------- *
      * Julio Barranco                       22-Sep-2015          *
      * ********************************************************* *

      *Parametros
     DCOWGRA6          pr                  extpgm('COWGRA6')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTipe                       1    const
     D   peTido                       2  0 const
     D   peNrdo                       9  0 const
     D   peCuit                      11  0 const
     D   peCuil                      11  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     DCOWGRA6          pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTipe                       1    const
     D   peTido                       2  0 const
     D   peNrdo                       9  0 const
     D   peCuit                      11  0 const
     D   peCuil                      11  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * Variables para Log
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

      /free

       *inlr = *on;

      //Log de Entrada...
       Data = CRLF                                          + CRLF
            + '<b>COWGRA6 (Request)</b>'                    + CRLF
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
            + 'PETIPE: '  + %trim(peTipe)                   + CRLF
            + 'PETIDO: '  + %editc(peTido:'X')              + CRLF
            + 'PENRDO: '  + %editc(peNrdo:'X')              + CRLF
            + 'PECUIT: '  + %editc(peCuit:'X')              + CRLF
            + 'PECUIL: '  + %editc(peCuil:'X');
       COWLOG_log( peBase : peNctw : Data );

       COWGRAI_personaIsValid ( peBase :
                                peNctw :
                                peTipe :
                                peTido :
                                peNrdo :
                                peCuit :
                                peCuil :
                                peErro :
                                peMsgs );
       Data =
              '<br><br><b>COWGRA6 (Response)</b>'         + CRLF
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

       COWGRAI_End();

       Return;

      /end-free
