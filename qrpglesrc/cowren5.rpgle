     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************* *
      * COWREN5: Lista formas de pago de una superpóliza.             *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Nro. de Cotizacion                     *
      *     peArcd   (input)   Artículo                               *
      *     peSpol   (input)   SuperPóliza                            *
      *     peCfpg   (input)   Forma de Pago                          *
      *     peLfpg   (output)  Lista de Formas de Pago                *
      *     peLfpgC  (output)  Cantidad en peLfpg                     *
      *     peErro   (output)  Error                                  *
      *     peMsgs   (output)  Mensaje de Error                       *
      *                                                               *
      * ------------------------------------------------------------- *
      * Sergio Fernandez                    *27-Dic-2016              *
      * ------------------------------------------------------------- *
      * GIO 06/02/18 - Modifica procedimiento _getListaFormasDePago   *
      *                para devolver AAAA/MM de Vencimiento Tarjeta   *
      *                                                               *
      * ************************************************************* *

     D COWREN5         pr                  ExtPgm('COWREN5')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peCfpg                        1  0 const
     D  peLfpg                             likeds(dsCfpg_t) dim(999)
     D  peLfpgC                      10i 0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)


     D COWREN5         pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peCfpg                        1  0 const
     D  peLfpg                             likeds(dsCfpg_t) dim(999)
     D  peLfpgC                      10i 0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      /copy './qcpybooks/cowren_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D fecha           s               d
     D hora            s               t
     D x               s             10i 0

      /free

        *inlr = *on;
        fecha  = %date();
        hora   = %time();
        separa = *all'-';
        peErro = *Zeros;
        clear peMsgs;
        clear peLfpg;
        peLfpgC = 0;

        Data = '<br><br>'
             + '<b>COWREN5 (Request)</b>'                    + CRLF
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
             + 'PENCTW: '       + %editc(peNctw:'X')         + CRLF
             + 'PEARCD: '       + %editc(peArcd:'X')         + CRLF
             + 'PESPOL: '       + %editc(peSpol:'X')         + CRLF
             + 'PECFPG: '       + %editc(peCfpg:'X')         + CRLF;

        COWLOG_log( peBase : peNctw : Data );

        COWREN_getListaFormasDePago  ( peBase
                                     : peNctw
                                     : peArcd
                                     : peSpol
                                     : peCfpg
                                     : peLfpg
                                     : peLfpgC
                                     : peErro
                                     : peMsgs   );

        Data = '<br><br>'                                     + CRLF
             + '<b>COWREN5 (Response)</b>'                    + CRLF
             + 'Fecha/Hora: '
             + %trim(%char(%date():*iso))                     + ' '
             + %trim(%char(%time():*iso))                     + CRLF;
        COWLOG_log( peBase : peNctw : Data );

        for x = 1 to peLfpgC;
            Data = 'PELFPG(' + %trim(%char(x)) + ')' + CRLF
                 + '&nbsp;PECFPG: ' + peLfpg(x).cfpg + CRLF
                 + '&nbsp;PENRPP: ' + peLfpg(x).nrpp + CRLF
                 + '&nbsp;PENCBU: ' + peLfpg(x).ncbu + CRLF
                 + '&nbsp;PECTCU: ' + peLfpg(x).ctcu + CRLF
                 + '&nbsp;PENRTC: ' + peLfpg(x).nrtc + CRLF
                 + '&nbsp;PEFVTC: ' + peLfpg(x).fvtc + CRLF
                 + 'PELFPG'                          + CRLF;
            COWLOG_log( peBase : peNctw : Data );
        endfor;

        Data = 'PEERRO:' + %trim(%char(peErro))               + CRLF
             + 'PEMSGS: '                                     + CRLF
             + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)        + CRLF
             + '&nbsp;PEMSID: ' + peMsgs.peMsid               + CRLF
             + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)        + CRLF
             + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)        + CRLF
             + 'PEMSGS'                                       + CRLF        ;
         COWLOG_log( peBase : peNctw : Data );

         Data = separa;
         COWLOG_log( peBase : peNctw : Data );
         return;

      /end-free
