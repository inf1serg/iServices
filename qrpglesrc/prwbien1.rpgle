     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWBIEN1:WebService                                          *
      *          Propuesta Web                                       *
      *          Wrapper para _updateVehiculo()                      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *07-Oct-2015        *
      * ************************************************************ *

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/prwbien_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D PRWBIEN1        pr                  ExtPgm('PRWBIEN1')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePate                      25a   const
     D   peChas                      25a   const
     D   peMoto                      25a   const
     D   peAver                       1a   const
     D   peNmer                      40a   const
     D   peAcrc                       7  0 const
     D   peRuta                      16  0 const
     D   peCesv                       1a   const
     D   peIris                       1a   const
     D   peVhuv                       2  0 const
     D   peInsp                            likeds(prwbienInsp_t) const
     D   peRast                            likeds(prwbienRast_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWBIEN1        pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePate                      25a   const
     D   peChas                      25a   const
     D   peMoto                      25a   const
     D   peAver                       1a   const
     D   peNmer                      40a   const
     D   peAcrc                       7  0 const
     D   peRuta                      16  0 const
     D   peCesv                       1a   const
     D   peIris                       1a   const
     D   peVhuv                       2  0 const
     D   peInsp                            likeds(prwbienInsp_t) const
     D   peRast                            likeds(prwbienRast_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      /free

       *inlr = *on;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>PRWBIEN1 (Request)</b>'              + CRLF
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
            + 'PEPATE: '  + pePate                     + CRLF
            + 'PECHAS: '  + peChas                     + CRLF
            + 'PEMOTO: '  + peMoto                     + CRLF
            + 'PEAVER: '  + peAver                     + CRLF
            + 'PENMER: '  + peNmer                     + CRLF
            + 'PEACRC: '  + %editc(peAcrc:'X')         + CRLF
            + 'PERUTA: '  + %editc(peRuta:'X')         + CRLF
            + 'PECESV: '  + peCesv                     + CRLF
            + 'PEIRIS: '  + peIris                     + CRLF
            + 'PEVHUV: '  + %editc(peVhuv:'X')         + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = 'PEINPS' + CRLF
            + '&nbsp;TIPO: ' + peInsp.tipo + CRLF
            + '&nbsp;NOMB: ' + peInsp.nomb + CRLF
            + '&nbsp;DOMI: ' + peInsp.domi + CRLF
            + '&nbsp;NTEL: ' + peInsp.ntel + CRLF
            + '&nbsp;NTE1: ' + peInsp.nte1 + CRLF
            + '&nbsp;MAIL: ' + peInsp.mail + CRLF
            + '&nbsp;HDES: ' + %editc(peInsp.hdes:'X') + CRLF
            + '&nbsp;HHAS: ' + %editc(peInsp.hhas:'X') + CRLF
            + '&nbsp;NRIN: ' + peInsp.nrin + CRLF
            + '&nbsp;CTRO: ' + peInsp.ctro + CRLF
            + '&nbsp;COME: ' + peInsp.come + CRLF
            + 'PEINSP' + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = 'PERAST' + CRLF
            + '&nbsp;HAVE: ' + peRast.have + CRLF
            + '&nbsp;RAST: ' + %editc(peRast.rast:'X') + CRLF
            + '&nbsp;DRAS: ' + peRast.dras + CRLF
            + '&nbsp;NOMB: ' + peRast.nomb + CRLF
            + '&nbsp;DOMI: ' + peRast.domi + CRLF
            + '&nbsp;NTEL: ' + peRast.ntel + CRLF
            + '&nbsp;NTE1: ' + peRast.nte1 + CRLF
            + '&nbsp;MAIL: ' + peRast.mail + CRLF
            + '&nbsp;HDES: ' + %editc(peRast.hdes:'X') + CRLF
            + '&nbsp;HHAS: ' + %editc(peRast.hhas:'X') + CRLF
            + 'PERAST' + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       PRWBIEN_setVehiculo( peBase
                          : peNctw
                          : peRama
                          : peArse
                          : pePoco
                          : pePate
                          : peChas
                          : peMoto
                          : peAver
                          : peNmer
                          : peAcrc
                          : peRuta
                          : peCesv
                          : peIris
                          : peVhuv
                          : peInsp
                          : peRast
                          : peErro
                          : peMsgs );

       Data = '<br><br>'
            + '<b>PRWBIEN1 (Response)</b>'             + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF;
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
