     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWSND6: WebService                                          *
      *          Propuesta Web                                       *
      *          Wrapper para _sendPropuesta()                       *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                         *01-Jul-2021        *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/prwsnd_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWSND6         pr                  ExtPgm('PRWSND6')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWSND6         pi
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
     D @@DsTim         ds                  likeds( Dsctwtim_t )

      /free

       *inlr = *on;

       separa = *all'-';

       peSoln = 0;

       Data = '<br><br>'
            + '<b>PRWSND6 (Request)</b>'               + CRLF
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
            + 'PEFDES: '  + %editc(peFdes:'X')         + CRLF
            + 'PEFHAS: '  + %editc(peFhas:'X');
       COWLOG_log( peBase : peNctw : Data );

       PRWSND_sndPropuesta2( peBase
                           : peNctw
                           : peFdes
                           : peFhas
                           : peErro
                           : peMsgs );
       if peErro = *Zeros;
         clear @@DsTim;
         if COWGRAI_getAuditoria( peBase
                                : peNctw
                                : @@DsTim );
           @@DsTim.w0hpro = %dec( %time );
           COWGRAI_setAuditoria( @@DsTim );
         endif;
       endif;

       if peErro = 0;
          PRWSND_getNroSolicitud( peBase
                                : peNctw
                                : peSoln
                                : peErro
                                : peMsgs );
       endif;

       Data = '<br><br>'
            + '<b>PRWSND6 (Response)</b>'                 + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                  + CRLF
            + 'PESOLN: ' + %trim(%char(peSoln))           + CRLF
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
