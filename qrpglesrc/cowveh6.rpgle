     H dftactgrp(*no) actgrp(*new)
     H option(*nodebugio:*noshowcpy:*srcstmt)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COWVEH6: WebService                                          *
      *          Cotización Autos - Salvar Accesorios                *
      *                                                              *
      *          peBase (input)  Parámetros Base                     *
      *          peNctw (input)  Número de Cotizacion                *
      *          peRama (input)  Código de Rama                      *
      *          peArse (input)  Secuencia Artículo/Rama             *
      *          pePoco (input)  Número de Componente                *
      *          peAcce (input)  Accesorios                          *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez            *11-Ago-2016                     *
      * ************************************************************ *

     D COWVEH6         pr                  ExtPgm('COWVEH6')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peAcce                            likeds(AccVeh_t) dim(100) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWVEH6         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peAcce                            likeds(AccVeh_t) dim(100) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/cowveh_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D x               s             10i 0
     D rc              s              1n

      /free

       *inlr = *on;

       peErro = 0;
       clear peMsgs;

       separa = *all'-';

       Data = CRLF                                     + CRLF
            + '<b>COWVEH6 (Request)</b>'               + CRLF
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
            + 'PEPOCO: '  + %editc(pePoco:'X')         + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for x = 1 to 100;
        if peAcce(x).secu = 0;
           if x = 1;
              Data = 'No se han enviado accesorios' + CRLF;
              COWLOG_log( peBase : peNctw : Data );
           endif;
           leave;
        endif;
           Data = 'PEACCE' + CRLF
                + '&nbsp;PESECU: '+%editc(peAcce(x).secu:'X') + CRLF
                + '&nbsp;PEACCD: '+%trim(peAcce(x).accd)      + CRLF
                + '&nbsp;PEACCV: '+%editc(peAcce(x).accv:'X') + CRLF
                + '&nbsp;PEMAR1: '+%trim(peAcce(x).mar1)      + CRLF
                + 'PEACCE' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
       endfor;

       rc = COWVEH_saveAccesorios( peBase
                                 : peNctw
                                 : peRama
                                 : peArse
                                 : pePoco
                                 : peAcce );

       if rc = *off;
          peErro = -1;
          peMsgs.peMsev = 40;
          peMsgs.peMsid = 'VEH0001';
          peMsgs.peMsg1 = 'Error al grabar accesorios del vehículo '
                        + %trim(%char(pePoco));
          peMsgs.peMsg2 = peMsgs.peMsg1;
       endif;

       Data = '<br><br>'
            + '<b>COWVEH6 (Response)</b>'                 + CRLF
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
