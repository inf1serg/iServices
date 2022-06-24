     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWGRA2: Delete cotizacion                                *
      *                                                           *
      *     peBase   (input)   Base                               *
      *     peNctw   (input)   Número de Cotización               *
      *     peErro   (output)  Indicador de Error                 *
      *     peMsgs   (output)  Estructura de Error                *
      *                                                           *
      * --------------------------------------------------------- *
      * Gomez Luis                           22-Sep-2015          *
      * ********************************************************* *

      *Parametros
     DCOWGRA2          pr                  extpgm('COWGRA2')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     DCOWGRA2          pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
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
            + '<b>COWGRA2 (Request)</b>'                    + CRLF
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
            + 'PEBASE';
       COWLOG_log( peBase : peNctw : Data );

       COWGRAI_deleteCotizacion( peBase
                               : peNctw
                               : peErro
                               : peMsgs );
      //Log de Respuesta...
       Data =
              '<br><br><b>COWGRA2 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEERRO: ' +  %trim(%char(peErro))       + CRLF
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
