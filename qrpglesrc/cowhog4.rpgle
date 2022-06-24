     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWHOG4: WebService                                          *
      *          Cotización Riesgos Varios - wrapper para            *
      *          _COWHOG_calculaCaracteristicas()                    *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *19-Ago-2016        *
      * ************************************************************ *

      /copy './qcpybooks/cowhog_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D COWHOG4         pr                  ExtPgm('COWHOG4')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRdes                      40a   const
     D   peCara                            likeds(set160_t) dim(99)
     D   peCaraC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWHOG4         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRdes                      40a   const
     D   peCara                            likeds(set160_t) dim(99)
     D   peCaraC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D x               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       clear peCara;
       clear peMsgs;
       peCaraC = 0;
       peErro  = 0;

       separa = *all'-';

       Data = CRLF                                     + CRLF
            + '<b>COWHOG4 (Request)</b>'               + CRLF
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
            + 'PEXPRO: '  + %editc(peXpro:'X')         + CRLF
            + 'PECOPO: '  + %editc(peCopo:'X')         + CRLF
            + 'PECOPS: '  + %editc(peCops:'X')         + CRLF
            + 'PERDES: '  + %trim(peRdes)              + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       COWHOG_calculaCaracteristicas( peBase
                                    : peNctw
                                    : peRama
                                    : peArse
                                    : peXpro
                                    : peCopo
                                    : peCops
                                    : peRdes
                                    : peCara
                                    : peCaraC
                                    : peErro
                                    : peMsgs );

       Data = '<br><br>'
            + '<b>COWHOG4 (Response)</b>'              + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                  + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       if peCaraC <= 0;
          Data = CRLF + 'No hay características' + CRLF;
          COWLOG_log(peBase : peNctw : Data );
        else;
          for x = 1 to peCaraC;
            Data = 'PECARA(' + %trim(%char(x)) + ')'   + CRLF
                 + '&nbsp;CCBA: ' + %editc(peCara(x).ccba:'X') + CRLF
                 + '&nbsp;DCBA: ' + %trim(peCara(x).dcba)      + CRLF
                 + '&nbsp;MA01: ' + %trim(peCara(x).ma01)      + CRLF
                 + '&nbsp;MA02: ' + %trim(peCara(x).ma02)      + CRLF
                 + '&nbsp;MA03: ' + %trim(peCara(x).ma03)      + CRLF
                 + '&nbsp;CBAE: ' + %trim(peCara(x).cbae)      + CRLF
                 + 'PECARA'                                    + CRLF;
              COWLOG_log( peBase : peNctw : Data );
          endfor;
       endif;

       Data = 'PEERRO: ' +  %trim(%char(peErro))          + CRLF
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
