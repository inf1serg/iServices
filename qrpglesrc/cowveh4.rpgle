     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWVEH4: WebService                                          *
      *          Cotización Autos - wrapper para _detalleCobertura() *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *22-Sep-2015        *
      * ************************************************************ *

      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowveh_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D COWVEH4         pr                  ExtPgm('COWVEH4')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peScta                       1  0 const
     D   peCobl                       2    const
     D   peTxtd                            likeds(textdeta) dim(999)
     D   peTxtdC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWVEH4         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peScta                       1  0 const
     D   peCobl                       2    const
     D   peTxtd                            likeds(textdeta) dim(999)
     D   peTxtdC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      /free

       *inlr = *on;

       Data = CRLF                                     + CRLF
            + '<b>COWVEH4 (Request)</b>'               + CRLF
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
            + 'PEBASE'                                      + CRLF
            + 'PERAMA: '  + %editc(peRama:'X')         + CRLF
            + 'PEARSE: '  + %editc(peArse:'X')         + CRLF
            + 'PEPOCO: '  + %editc(pePoco:'X')         + CRLF
            + 'PESCTA: '  + %editc(peScta:'X')         + CRLF
            + 'PECOBL: '  + %trim(peCobl)              + CRLF
            + 'PEBASE';
            COWLOG_log( peBase : peNctw : Data );

       callp  COWVEH_detalleCobertura( peBase
                                     : peNctw
                                     : peRama
                                     : peArse
                                     : pePoco
                                     : peScta
                                     : peCobl
                                     : peTxtd
                                     : peTxtdC
                                     : peErro
                                     : peMsgs  );

       Data =
              '<br><br><b>COWVEH4 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso));
       COWLOG_log( peBase : peNctw : Data );

         for i = 1 to 999;
           if peTxtd(i).tpnl = *zeros;
             leave;
           endif;
           Data =                                               CRLF
                + 'PETXTD(' + %trim(%char(i)) + ')'           + CRLF
                + '&nbsp;TPNL: ' + %editc(petxtd(i).tpnl:'X') + CRLF
                + '&nbsp;TPDS: ' + %trim(petxtd(i).tpds)      + CRLF
                + 'PETXTD';
           COWLOG_log( peBase : peNctw : Data );
         endfor;

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
