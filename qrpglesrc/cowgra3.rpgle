     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWGRA3: Actualiza Cotizacion                             *
      *                                                           *
      *     peBase   (input)   Base                               *
      *     peNctw   (input)   Número de Cotización               *
      *     peAsen   (input)   Código de Asegurado                *
      *     peNomb   (input)   Nombre del Cliente                 *
      *     peCiva   (input)   Código de Iva del Cliente          *
      *     peTipe   (input)   Tipo de Personaación de Usuario    *
      *     peCopo   (input)   Código Postaleración de Sistema    *
      *     peCops   (input)   Sufijo Código Postal               *
      *     peErro   (output)  Indicador de Error                 *
      *     peMsgs   (output)  Estructura de Error                *
      *                                                           *
      * --------------------------------------------------------- *
      * Gomez Luis                           22-Sep-2015          *
      * --------------------------------------------------------- *
      * SGF 06/08/2016: Recibo peAsen.                            *
      * SGF 31/10/2016: Recibo peCuit, peTido y peNrdo.           *
      *                                                           *
      * ********************************************************* *

      *Parametros
     DCOWGRA3          pr                  extpgm('COWGRA3')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNomb                      40      const
     D   peCiva                       2  0   const
     D   peTipe                       1      const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCuit                      11a     const
     D   peTido                       1  0   const
     D   peNrdo                       8  0   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     DCOWGRA3          pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNomb                      40      const
     D   peCiva                       2  0   const
     D   peTipe                       1      const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCuit                      11a     const
     D   peTido                       1  0   const
     D   peNrdo                       8  0   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * Variables para Log
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

      /free

       *inlr = *on;

      //Log de Entrada...
       Data = CRLF                                          + CRLF
            + '<b>COWGRA3 (Request)</b>'                    + CRLF
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
            + 'PEASEN: '  + %editc(peAsen:'X')              + CRLF
            + 'PENOMB: '  + %trim(peNomb)                   + CRLF
            + 'PECIVA: '  + %editc(peCiva:'X')              + CRLF
            + 'PETIPE: '  + %trim(peTipe)                   + CRLF
            + 'PECOPO: '  + %editc(peCopo:'X')              + CRLF
            + 'PECOPS: '  + %editc(peCops:'X')              + CRLF
            + 'PECUIT: '  + peCuit                          + CRLF
            + 'PETIDO: '  + %editc(peTido:'X')              + CRLF
            + 'PENRDO: '  + %editc(peNrdo:'X');
       COWLOG_log( peBase : peNctw : Data );

       COWGRAI_saveCotizacion( peBase
                             : peNctw
                             : peAsen
                             : peNomb
                             : peCiva
                             : peTipe
                             : peCopo
                             : peCops
                             : peCuit
                             : peTido
                             : peNrdo
                             : peErro
                             : peMsgs );

       Data =
              '<br><br><b>COWGRA3 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
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

       COWGRAI_End();

       Return;

      /end-free
