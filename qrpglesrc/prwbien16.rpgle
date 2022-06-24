     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWBIEN16: WebService                                        *
      *          Propuesta Web                                       *
      *          Wrapper para _setUbicacion3()                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *12-Mar-2019        *
      * ************************************************************ *

      /copy './qcpybooks/prwbien_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWBIEN16       pr                  ExtPgm('PRWBIEN16')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peNrdm                       5  0 const
     D   peInsp                            const likeds(prwbienInsp_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWBIEN16       pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peNrdm                       5  0 const
     D   peInsp                            const likeds(prwbienInsp_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>PRWBIEN16 (Request)</b>'             + CRLF
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
            + 'PERDES: '  + peRdes                     + CRLF
            + 'PENRDM: '  + %editc(peNrdm:'X')         + CRLF
            + 'PEINSP: '                               + CRLF
            + '&nbsp;PETIPO: ' + %trim(peInsp.tipo)    + CRLF
            + '&nbsp;PENOMB: ' + %trim(peInsp.nomb)    + CRLF
            + '&nbsp;PEDOMI: ' + %trim(peInsp.domi)    + CRLF
            + '&nbsp;PENTEL: ' + %trim(peInsp.ntel)    + CRLF
            + '&nbsp;PENTE1: ' + %trim(peInsp.nte1)    + CRLF
            + '&nbsp;PEMAIL: ' + %trim(peInsp.mail)    + CRLF
            + '&nbsp;PEHDES: ' + %char(peInsp.hdes)    + CRLF
            + '&nbsp;PEHHAS: ' + %char(peInsp.hhas)    + CRLF
            + '&nbsp;PENRIN: ' + %trim(peInsp.nrin)    + CRLF
            + '&nbsp;PECTRO: ' + %trim(peInsp.ctro)    + CRLF
            + '&nbsp;PECOME: ' + %trim(peInsp.come)    + CRLF
            + 'PEINSP: '                               + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       PRWBIEN_setUbicacion3( peBase
                            : peNctw
                            : peRama
                            : peArse
                            : pePoco
                            : peRdes
                            : peNrdm
                            : peInsp
                            : peErro
                            : peMsgs );

       Data = '<br><br>'
            + '<b>PRWBIEN16 (Response)</b>'               + CRLF
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
