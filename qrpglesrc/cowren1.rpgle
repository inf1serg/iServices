     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H actgrp(*new)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************* *
      * COWREN1: Check General para Renovacion                        *
      *     peBase   (input)   Base                                   *
      *     peArcd   (input)   Articulo                               *
      *     peSpol   (input)   SuperPoliza                            *
      *     peErro   (output)  Indicador de Error                     *
      *     peMsgs   (output)  Estructura de Error                    *
      * ------------------------------------------------------------- *
      * Gomez Luis                           11-Jul-2016              *
      * ------------------------------------------------------------- *
      * ************************************************************* *
      * Modificaciones:                                               *
      * ************************************************************* *
     Fctw000    if   e           k disk    usropn
      *Parametros
     D  COWREN1        pr                  ExtPgm('COWREN1')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs) dim(20)
     D   peMsgsC                     10i 0

     D  COWREN1        pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs) dim(20)
     D   peMsgsC                     10i 0

     D COWREN1_inz     pr
     D COWREN1_end     pr

     D Initialized     s              1n
      *--- Copy H -------------------------------------------------- *
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
        COWREN1_inz();

        fecha  = %date();
        hora   = %time();
        separa = *all'-';

        if  not COWREN_ChkGeneral( peBase
                                 : peArcd
                                 : peSpol
                                 : peErro
                                 : peMsgs
                                 : peMsgsC );
        endif;

        COWREN_End();

           Data = '<br><br>'
                + '<b>COWREN1 (Request)</b>'                    + CRLF
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
                + 'PEARCD: '       + %editc(peArcd:'X')         + CRLF
                + 'PESPOL: '       + %editc(peSpol:'X');

           COWLOG_log( peBase : 1 : Data );

           Data = '<br><br>'
                + '<b>COWREN1 (Response)</b>'                + CRLF
                + 'Fecha/Hora: '
                + %trim(%char(%date():*iso))                 + ' '
                + %trim(%char(%time():*iso))                 + CRLF
                + 'PEERRO: '         + %trim(%char(peErro))  + CRLF
                + 'PEMSGSC: '         + %trim(%char(peMsgsC))+ CRLF;
           COWLOG_log( peBase : 1 : Data );
           for x = 1 to peMsgsC;
           Data =   'PEMSGS: ' + %trim( %editw( x : '        0 '))    + CRLF
                  + '&nbsp;PEMSEV: ' + %char(peMsgs(x).peMsev)        + CRLF
                  + '&nbsp;PEMSID: ' + peMsgs(x).peMsid               + CRLF
                  + '&nbsp;PEMSG1: ' + %trim(peMsgs(x).peMsg1)        + CRLF
                  + '&nbsp;PEMSG2: ' + %trim(peMsgs(x).peMsg2)        + CRLF
                  + 'PEMSGS'                                          + CRLF;
             COWLOG_log( peBase : 1 : Data );
           endfor;


      /end-free
      * ------------------------------------------------------------ *
      * COWREN1_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWREN1_inz     B
     D COWREN1_inz     pi

       if (initialized);
          return;
       endif;


       if not %open(ctw000);
          open ctw000;
       endif;

       initialized = *ON;
       return;

     P COWREN1_inz     E
      * ------------------------------------------------------------ *
      * COWREB_End:   Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWREN1_End     B
     D COWREN1_End     pi

       close *all;
       initialized = *OFF;

       return;

     P COWREN1_End     E
