     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H actgrp(*new)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************* *
      * COWREN2: Retorna Llamadas a COWVEH1/2                         *
      * ************************************************************* *
      * Alvarez Fernando                     24-Ago-2016              *
      * ************************************************************* *
      * Modificaciones:                                               *
      * SFA 01/09/16 - Recompilo por cambios en dsVeh_t               *
      * SGF 07/09/16 - Recompilo por cambios en dsVeh_t               *
      * LRG 08/09/16 - Se incorpora Cod. Mensaje de Error             *
      * LRG 08/09/16 - Se agrega al Log la estructura                 *
      * JSN 10/09/21 - Se reconpila por cambio en la longitud del     *
      *                campo en la DS RGNC dsVeh2_t                   *
      * ************************************************************* *
     D  COWREN2        pr                  ExtPgm('COWREN2')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t) dim(20)
     D   peDsVhC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D  COWREN2        pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsVh                            likeds(dsVeh_t) dim(20)
     D   peDsVhC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      /copy './qcpybooks/cowren_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D fecha           s               d
     D hora            s               t
     D x               s             10i 0
     D y               s             10i 0
     D mask            C                   '            0 ,  '
     D mas1            C                   '    0 ,  '

     D @lda            ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(@lda:401)
     D  sucu                          2a   overlay(@lda:402)

        *inlr = *on;

        @lda.empr = peBase.peEmpr;
        @lda.sucu = peBase.peSucu;
        out @lda;

        peErro = *Zeros;

        fecha  = %date();
        hora   = %time();
        separa = *all'-';

        Data = '<br><br>'
             + '<b>COWREN2 (Request)</b>'                    + CRLF
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
             + 'PENCTW: '       + %editc(peNctw:'X');

        COWLOG_log( peBase : peNctw : Data );

        callp COWREN_getLlamadas( peBase
                                : peNctw
                                : peDsVh
                                : peDsVhC );

        if COWREN_chkErrores( peDsVh : peDsVhC );

          peErro = -1;

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0132'
                       :  peMsgs );

        endif;

        Data = '<br><br>'
             + '<b>COWREN2 (Response)</b>'                    + CRLF
             + 'Fecha/Hora: '
             + %trim(%char(%date():*iso))                     + ' '
             + %trim(%char(%time():*iso))                     + CRLF
             + 'PENCTW: '         + %editc(peNctw:'X')        + CRLF
             + 'PEERRO: '         + %trim(%char(peErro))      + CRLF
             + 'PEMSGS: ' + %trim( %editw( x : '        0 ')) + CRLF
             + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)        + CRLF
             + '&nbsp;PEMSID: ' + peMsgs.peMsid               + CRLF
             + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)        + CRLF
             + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)        + CRLF
             + 'PEMSGS'                                       + CRLF        ;
         COWLOG_log( peBase : peNctw : Data );

         for x = 1 to peDsVhC;
           Data =                                                CRLF
                + 'PEDSVHC: (' + %trim(%char(x)) + ')'         + CRLF
                + '&nbsp;POCO: '+%editc(peDsVh(x).poco : 'X')  + CRLF
                + '&nbsp;VHAN: '+%trim(peDsVh(x).vhan)         + CRLF
                + '&nbsp;VHMC: '+%trim(peDsVh(x).vhmc)         + CRLF
                + '&nbsp;VHMO: '+%trim(peDsVh(x).vhmo)         + CRLF
                + '&nbsp;VHCS: '+%trim(peDsVh(x).vhcs)         + CRLF
                + '&nbsp;VHVU: '+%editw(peDsVh(x).vhvu : mask) + CRLF
                + '&nbsp;MGNC: '+%trim(peDsVh(x).mgnc)         + CRLF
                + '&nbsp;RGNC: '+%editw(peDsVh(x).rgnc : mas1) + CRLF
                + '&nbsp;COPO: '+%editc(peDsVh(x).copo : 'X')  + CRLF
                + '&nbsp;COPS: '+%editc(peDsVh(x).cops : 'X')  + CRLF
                + '&nbsp;SCTA: '+%editc(peDsVh(x).scta : 'X')  + CRLF
                + '&nbsp;CLIN: '+%trim(peDsVh(x).clin)         + CRLF
                + '&nbsp;BURE: '+%editc(peDsVh(x).bure : 'X')  + CRLF
                + '&nbsp;CFPG: '+%editc(peDsVh(x).cfpg : 'X')  + CRLF
                + '&nbsp;TIPE: '+%trim(peDsVh(x).tipe)         + CRLF
                + '&nbsp;CIVA: '+%editc(peDsVh(x).civa : 'X')  + CRLF
                + '&nbsp;MAR1: '+%trim(peDsVh(x).tipe)         + CRLF
                + '&nbsp;NMAT: '+%trim(peDsVh(x).nmat)         + CRLF
                + '&nbsp;MOTO: '+%trim(peDsVh(x).moto)         + CRLF
                + '&nbsp;CHAS: '+%trim(peDsVh(x).chas)         + CRLF
                + '&nbsp;RUTA: '+%editc(peDsVh(x).ruta : 'X')  + CRLF
                + '&nbsp;VHUV: '+%editc(peDsVh(x).vhuv : 'X')  + CRLF
                + '&nbsp;AVER: '+%trim(peDsVh(x).aver)         + CRLF
                + '&nbsp;NMER: '+%trim(peDsVh(x).nmer)         + CRLF
                + '&nbsp;ACRC: '+%editc(peDsVh(x).acrc : 'X')  + CRLF;
         COWLOG_log( peBase : peNctw : Data );

         for y = 1 to 100;
           if peDsVh(x).Acce(y).secu = *zeros;
            leave;
           endif;
           Data =
              '&nbsp;ACCE: (' + %trim( %editw( y : '        0 ')) +')'    +CRLF
            + '&nbsp;&nbsp;PESECU: '+ %editc(peDsVh(x).Acce(y).secu :'X') +CRLF
            + '&nbsp;&nbsp;PEACCD: '+ %trim(peDsVh(x).Acce(y).accd)       +CRLF
            + '&nbsp;&nbsp;PEACCV: '+ %editc(peDsVh(x).Acce(y).accv:'X')  +CRLF
            + '&nbsp;&nbsp;PEMAR1: '+ %trim(peDsVh(x).Acce(y).mar1)       +CRLF
            + '&nbsp;ACCE'    + CRLF;
           COWLOG_log( peBase : peNctw : Data );
         endfor;

         for y = 1 to 20;
           if peDsVh(x).Msgs(y).peMsev =  *zeros;
             leave;
           endif;

           Data =                                                           CRLF
             + '&nbsp;MSGS: (' + %trim( %editw( y : '        0 ')) +' )'  + CRLF
             + '&nbsp;&nbsp;PEMSEV: ' + %char(peDsVh(x).Msgs(y).peMsev)   + CRLF
             + '&nbsp;&nbsp;PEMSID: ' + peDsVh(x).Msgs(y).peMsid          + CRLF
             + '&nbsp;&nbsp;PEMSG1: ' + %trim(peDsVh(x).Msgs(y).peMsg1)   + CRLF
             + '&nbsp;&nbsp;PEMSG2: ' + %trim(peDsVh(x).Msgs(y).peMsg2)   + CRLF
             + '&nbsp;MSGS'                                              + CRLF;
           COWLOG_log( peBase : peNctw : Data );

         endfor;

           Data =  'PEDSVHC' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
         endfor;

         return;
