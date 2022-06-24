     H dftactgrp(*no) actgrp(*caller)
     H indent('|') option(*nodebugio:*noshowcpy)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COWVEH9: WebService                                          *
      *          Cotización Autos - Descuento/Recargo WEB            *
      *                                                              *
      *          peBase (input)  Parámetros Base                     *
      *          peNctw (input)  Número de Cotizacion                *
      *          peRama (input)  Rama                                *
      *          peDefe (output) % Defecto                           *
      *          peMaxi (output) % Maximo                            *
      *          peErro (output) Estructura de errores               *
      *          peMsgs (output) Estructura de errores               *
      *                                                              *
      * ------------------------------------------------------------ *
      * Externo 1                   * 04-Ene-2018                    *
      * ************************************************************ *

      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svpdau_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpbue_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D COWVEH9         pr                  ExtPgm('COWVEH9')
     D   peBase                            likeds( paramBase ) Const
     D   peNctw                       7  0 Const
     D   peRama                       2  0 Const
     D   peDefe                       5  2
     D   peMaxi                       5  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWVEH9         pi
     D   peBase                            likeds( paramBase ) Const
     D   peNctw                       7  0 Const
     D   peRama                       2  0 Const
     D   peDefe                       5  2
     D   peMaxi                       5  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D @@290           ds                  likeds( dsSet290_t )
     D peCcot          ds                  likeds(CabeceraCot_t)

     D wrepl           s          65535a
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D @@DsTim         ds                  likeDs( Dsctwtim_t)

       *inlr = *on;

       peErro = *Zeros;
       peDefe = *Zeros;
       peMaxi = *Zeros;
       clear peMsgs;

       separa = *all'-';
       Data = CRLF                                     + CRLF
            + '<b>COWVEH9 (Request)</b>'               + CRLF
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
            + 'PERAMA: '  + %editc(peRama:'X');
       COWLOG_log( peBase : peNctw : Data );

       if not COWRTV_getCabeceraCotizacion( peBase : peNctw : peCcot );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'EMI0000'
                      : peMsgs );
         peErro = -1;
       endif;

       if SVPWS_getGrupoRama ( peRama ) <> 'A';
         %subst(wrepl:1:2) = %editc ( peRama : 'X' );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0067'
                      : peMsgs
                      : %trim( wrepl )
                      : %len( %trim( wrepl ) ) );
         peErro = -1;
       endif;

       if ( peErro <> -1 );
         SVPINT_getDescuentoWeb( peBase.peEmpr
                               : peBase.peSucu
                               : peBase.peNivt
                               : peBase.peNivc
                               : peRama
                               : peCcot.fctw
                               : @@290 );
         peDefe = @@290.t@defe;
         peMaxi = @@290.t@porc;
       endif;

       clear @@DsTim;
       if COWGRAI_getAuditoria( peBase
                              : peNctw
                              : @@DsTim );
         @@DsTim.w0fcot = %dec(%date : *iso);
         @@DsTim.w0hcot = %dec(%time);
         COWGRAI_setAuditoria( @@DsTim );
       endif;

       Data =                                            CRLF
            + '<br><br><b>COWVEH9 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEDEFE: '  + %editC( peDefe : '2' )     + CRLF
            + 'PEMAXI: '  + %editC( peMaxi : '2' );
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
