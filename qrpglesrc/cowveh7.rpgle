     H dftactgrp(*no) actgrp(*new)
     H option(*nodebugio:*noshowcpy:*srcstmt)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COWVEH7: WebService                                          *
      *          Cotización Autos - Lisa Buen Resultado              *
      *                                                              *
      *          peBase   (input)   Parámetros Base                  *
      *          peNctw   (input)   Número de Cotizacion             *
      *          peBure   (input)   Años de Buen Resultado           *
      *          peLbure  (output)  Lista de Cod. de buen resultado  *
      *          peLbureC (output)  Cantidad                         *
      *          peHabi   (output)  Habilita / No Habilita           *
      *          peErro   (output)  Error                            *
      *          peMsgs   (output)  Mensaje de Error                 *
      *                                                              *
      * ------------------------------------------------------------ *
      * Luis R. Gomez               *06-Dic-2017                     *
      * ************************************************************ *

     D COWVEH7         pr                  ExtPgm('COWVEH7')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peBure                       1  0 const
     D   peLbure                           likeds(dsBure_t) dim(99)
     D   peLbureC                    10i 0
     D   peHabi                       1
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWVEH7         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peBure                       1  0 const
     D   peLbure                           likeds(dsBure_t) dim(99)
     D   peLbureC                    10i 0
     D   peHabi                       1
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/cowveh_h.rpgle'

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
        clear peLbure;
        peLbureC = 0;

        Data = '<br><br>'
             + '<b>COWVEH7 (Request)</b>'                    + CRLF
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
             + 'PEBURE: '       + %editc(peBure:'X');

        COWLOG_log( peBase : peNctw : Data );

        COWVEH_getListaBuenResultado ( peBase
                                     : peNctw
                                     : peBure
                                     : peLbure
                                     : peLbureC
                                     : peHabi
                                     : peErro
                                     : peMsgs   );

          Data = '<br><br>'
               + '<b>COWVEH7 (Response)</b>'                    + CRLF
               + 'Fecha/Hora: '
               + %trim(%char(%date():*iso))                     + ' '
               + %trim(%char(%time():*iso))                     + CRLF
               + 'PENCTW: '         + %editc(peNctw:'X')        + CRLF
               + 'PEERRO: '         + %trim(%char(peErro))      + CRLF;
               COWLOG_log( peBase : peNctw : Data );

        for x = 1 to peLbureC;
          Data = 'PELBURE(' + %trim(%char(x)) + ')' + CRLF
               + '&nbsp;PEBURE: ' + %editc(peLbure(x).bure:'X') + CRLF
               + '&nbsp;PEDESC: ' + %trim(peLbure(x).desc)      + CRLF
               + 'PELBURE: '                                    + CRLF      ;
          COWLOG_log( peBase : peNctw : Data );
        endfor;

          Data = 'PEHABI:' + %trim(peHabi)                    + CRLF;
          COWLOG_log( peBase : peNctw : Data );

        //Error
        Data = 'PEMSGS: '                                     + CRLF
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
