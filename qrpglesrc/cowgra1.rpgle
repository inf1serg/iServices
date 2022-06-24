     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H actgrp(*new)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWGRA1: Get Nueva Cotizacion                                 *
      *     peBase   (input)   Base                                   *
      *     peArcd   (input)   Código de Artículo                     *
      *     peMone   (input)   Código de Moneda                       *
      *     peTiou   (input)   Tipo de Operación                      *
      *     peStou   (input)   SubTipo de Operación de Usuario        *
      *     peStos   (input)   SubTipo de Operación de Sistema        *
      *     peSpo1   (input)   SuperPoliza Relacionada                *
      *     peNctw   (output)  Número de Cotización                   *
      *     peErro   (output)  Indicador de Error                     *
      *     peMsgs   (output)  Estructura de Error                    *
      * ------------------------------------------------------------ *
      * Gomez Luis                           22-Sep-2015             *
      * ------------------------------------------------------------ *
      * ************************************************************ *
      * Modificaciones:                                              *
      * LRG 19/09/2017 - Se agrega Auditoria de llamada              *
      *                                                              *
      * ************************************************************ *
      *Parametros
     D  COWGRA1        pr                  ExtPgm('COWGRA1')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peMone                       2      const
     D   peTiou                       1  0   const
     D   peStou                       2  0   const
     D   peStos                       2  0   const
     D   peSpo1                       7  0   const
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D  COWGRA1        pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peMone                       2      const
     D   peTiou                       1  0   const
     D   peStou                       2  0   const
     D   peStos                       2  0   const
     D   peSpo1                       7  0   const
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D fecha           s               d
     D hora            s               t
     D @@DsTim         ds                  likeds( Dsctwtim_t )

      /free

        *inlr = *on;

        fecha  = %date();
        hora   = %time();
        separa = *all'-';

        COWGRAI_getNuevaCotizacion( peBase
                                 : peArcd
                                 : peMone
                                 : peTiou
                                 : peStou
                                 : peStos
                                 : peSpo1
                                 : peNctw
                                 : peErro
                                 : peMsgs );



        if peErro = 0;

          clear @@DsTim;
          @@DsTim.w0empr = Pebase.peEmpr;
          @@DsTim.w0sucu = peBase.peSucu;
          @@DsTim.w0nivt = peBase.peNivt;
          @@DsTim.w0nivc = peBase.peNivc;
          @@DsTim.w0niv1 = peBase.peNiv1;
          @@DsTim.w0nit1 = peBase.peNit1;
          @@DsTim.w0nctw = peNctw;
          @@DsTim.w0hcct = %dec(%time);
          COWGRAI_setAuditoria( @@DsTim );
          COWGRAI_End();

           Data = '<br><br>'
                + '<b>COWGRA1 (Request)</b>'                    + CRLF
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
                + 'PEMONE: '       + peMone                     + CRLF
                + 'PETIOU: '       + %editc(peTiou:'X')         + CRLF
                + 'PESTOU: '       + %editc(peStou:'X')         + CRLF
                + 'PESTOS: '       + %editc(peStos:'X')         + CRLF
                + 'PESPO1: '       + %editc(peSpo1:'X');

           COWLOG_log( peBase : peNctw : Data );

           Data = '<br><br>'
                + '<b>COWGRA1 (Response)</b>'          + CRLF
                + 'Fecha/Hora: '
                + %trim(%char(%date():*iso)) + ' '
                + %trim(%char(%time():*iso))               + CRLF
                + 'PENCTW: '       + %editc(peNctw:'X')   + CRLF
                + 'PEERRO: '       +  %trim(%char(peErro))+ CRLF
                + 'PEMSGS'                                + CRLF
                + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev) + CRLF
                + '&nbsp;PEMSID: ' + peMsgs.peMsid        + CRLF
                + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1) + CRLF
                + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2) + CRLF
                + 'PEMSGS'                                + CRLF;

           COWLOG_log( peBase : peNctw : Data );

           Data = separa;
           COWLOG_log( peBase : peNctw : Data );
        else;
           COWGRAI_End();

        endif;

      /end-free
