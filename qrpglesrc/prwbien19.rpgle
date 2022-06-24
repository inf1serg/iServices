     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * PRWBIEN19: WebService                                        *
      *            Insertar Bienes de Sepelio                        *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *27-Abr-2020        *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/PRWBIEN_H.rpgle'

     D PRWBIEN19       pr                  extpgm('PRWBIEN19')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peBsep                             likeds(prwBienSepe_t) dim(10)
     D  peBsepC                      10i 0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D PRWBIEN19       pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peBsep                             likeds(prwBienSepe_t) dim(10)
     D  peBsepC                      10i 0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D Data            s          65535a   varying
     D x               s             10i 0
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D @@DsTim         ds                  likeds( Dsctwtim_t )

      /free

       *inlr = *on;

       COWLOG_log( peBase : peNctw : '<br><br>PRWBIEN19' );

       clear peErro;
       clear peMsgs;

       separa = *all'-';

       Data = CRLF                                         + CRLF
            + '<b>PRWBIEN19 - Insertar Bien Sepelio</b>' + CRLF
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
            + 'PENCTW: '  + %editc(peNctw:'X')         + CRLF
            + 'PEBSEPC:'  + %editc(peBsepc:'X')        + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for x = 1 to peBSepC;
           if peBsep(x).poco <= 0;
              leave;
           endif;
           Data = 'PEBSEP(' + %editc(x:'X') + ')'          + CRLF
            + '&nbsp;POCO: ' + %editc(peBsep(x).Poco:'X')  + CRLF
            + '&nbsp;PACO: ' + %editc(peBsep(x).Paco:'X')  + CRLF
            + '&nbsp;NOMB: ' + %trim(peBsep(x).Nomb)       + CRLF
            + '&nbsp;APEL: ' + %trim(peBsep(x).Apel)       + CRLF
            + '&nbsp;FNAC: ' + %editc(peBsep(x).Fnac:'X')  + CRLF
            + '&nbsp;TIDO: ' + %editc(peBsep(x).Tido:'X')  + CRLF
            + '&nbsp;NRDO: ' + %editc(peBsep(x).Nrdo:'X')  + CRLF
            + '&nbsp;CNAC: ' + %editc(peBsep(x).Cnac:'X')  + CRLF
            + '&nbsp;CUIT: ' + %editc(peBsep(x).Cuit:'X')  + CRLF
            + 'PEBSEP'                                     + CRLF;
          COWLOG_log( peBase : peNctw : Data );
       endfor;

       PRWBIEN_insertaAseguradoSepelio( peBase
                                      : peNctw
                                      : peRama
                                      : peArse
                                      : peBsep
                                      : peBsepC
                                      : peErro
                                      : peMsgs );

       Data = CRLF                                     + CRLF
            + '<b>PRWBIEN19 - Insertar Bien Sepelio (Response)</b>'+CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEERRO: ' + %editc(peErro:'X')          + CRLF
            + 'PEMSID: ' + peMsgs.peMsid               + CRLF
            + 'PEMSG1: ' + peMsgs.peMsg1               + CRLF
            + 'PEMSG2: ' + peMsgs.peMsg2               + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = separa;
       COWLOG_log( peBase : peNctw : Data );

       return;

      /end-free
