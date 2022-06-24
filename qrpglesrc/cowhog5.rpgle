     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWHOG5: WebService                                          *
      *          Cotización Riesgos Varios - wrapper para            *
      *          _COWHOG_caracIsValid2()                             *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *01-Nov-2016*       *
      * ************************************************************ *

      /copy './qcpybooks/cowhog_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D COWHOG5         pr                  ExtPgm('COWHOG5')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWHOG5         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCara                            likeds(Caracbien) dim(50) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       separa = *all'-';

       Data = CRLF                                          + CRLF
            + '<b>COWHOG5 (Request)</b>'                    + CRLF
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
            + 'PEPOCO: '  + %editc(pePoco:'X')              + CRLF
            + 'PECOPO: '  + %editc(peCopo:'X')              + CRLF
            + 'PECOPS: '  + %editc(peCops:'X')              + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 50;
           if peCara(i).ccba <= 0;
              leave;
           endif;
           Data = 'PECARA(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;CCBA: ' + %editc(peCara(i).ccba:'X') + CRLF
                + '&nbsp;DCBA: ' + %trim(peCara(i).dcba) + CRLF
                + '&nbsp;MA01: ' + %trim(peCara(i).ma01) + CRLF
                + '&nbsp;MA02: ' + %trim(peCara(i).ma02) + CRLF
                + '&nbsp;MA01M: ' + %trim(peCara(i).ma01m) + CRLF
                + '&nbsp;MA02M: ' + %trim(peCara(i).ma02m) + CRLF
                + '&nbsp;CBAE: ' + %trim(peCara(i).cbae) + CRLF
                + 'PECARA' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
       endfor;

          callp  COWHOG_caracIsValid2( peBase
                                     : peNctw
                                     : peRama
                                     : pePoco
                                     : peCopo
                                     : peCops
                                     : peCara
                                     : peErro
                                     : peMsgs );

       Data = '<br><br>'
            + '<b>COWHOG5 (Response)</b>'                 + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                  + CRLF
            + 'PEERRO: '       +  %trim(%char(peErro))    + CRLF
            + 'PEMSGS'                                    + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
            + 'PEMSGS'                                    + CRLF;
       COWLOG_log( peBase : peNctw : Data );
       Data = separa;
       COWLOG_log( peBase : peNctw : Data );


       return;

      /end-free
