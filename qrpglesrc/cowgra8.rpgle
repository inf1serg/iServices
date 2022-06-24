     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWGRA8: Actualiza las condiciones comerciales y          *
      *          Retorna Premio Final                             *
      *       "Es la joya con dos parámetros nuevos"              *
      * --------------------------------------------------------- *
      * Julio Barranco                       22-Mar-2016          *
      * --------------------------------------------------------- *
      * Modificaciones:                                           *
      *  LRG   03/11/16 - se permite comision en cero             *
      *  LRG   11/06/19 - se valida topes de comision             *
      *                                                           *
      * ********************************************************* *

     DCOWGRA8          pr                  extpgm('COWGRA8')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const
     D   peCond                            likeds(Condcome) dim(99) const
     D   peCondC                     10i 0 const
     D   peImpu                            likeds(primPrem) dim(99)
     D   peImpuC                     10i 0
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     DCOWGRA8          pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const
     D   peCond                            likeds(Condcome) dim(99) const
     D   peCondC                     10i 0 const
     D   peImpu                            likeds(primPrem) dim(99)
     D   peImpuC                     10i 0
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)


     D x               s             10i 0
     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D
     D*Condcome        ds                  qualified based(template)
     D*  rama                         2  0
     D*  xrea                         5  2
     D
     D  @@dife         s              5  2
     D  @@xopr         s              5  2
     D  p@xrea         s              5  2
     D  p@xopr         s              5  2
     D
     D wrepl           s          65535a
     D ErrCode         s             10i 0
     D ErrText         s             80A
     D
     D Cowgra7         pr                  extpgm('COWGRA7')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const
     D   peImpu                            likeds(primPrem) dim(99)
     D   peImpuC                     10i 0
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D
     D sleep           pr            10u 0 extproc('sleep')
     D   secs                        10u 0 value
     D
     D COWGRA9         pr                  extpgm('COWGRA9')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peEpvm                        3  0
     D  peEpvx                        3  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D  peEpvm         s              3  0
     D  peEpvx         s              3  0

      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

       *inlr = *on;

       //sleep(60);

       separa = *all'-';

       Data = '<br><br>'
            + '<b>COWGRA8 '
            + 'Calcula Premio (Request)</b>'                + CRLF
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
            + 'PENCTW: '  + %trim(%editw(peNctw:'     0 ')) + CRLF
            + 'PENRPP: '  + %trim(%editw(peNrpp:' 0 '))     + CRLF
            + 'PECONDC: ' + %trim(%editw(peCondC:'        0 '));

       COWLOG_log( peBase : peNctw : Data );

       if peCondc <> 0;

         for x = 1 to peCondC;

           Data = '<br><br>'
                + 'PECOND' + '(' + %trim( %editw(x : '        0 ')) + ')' + CRLF
                + '&nbsp;PERAMA: '
                + %trim(%editw(peCond(x).Rama:' 0 '))            + CRLF
                + '&nbsp;PEXREA: '
                + %trim(%editw(peCond(x).Xrea:' 0 ,  -')) +'%'   + CRLF
                + 'PECOND'                                       + CRLF;

           COWLOG_log( peBase : peNctw : Data );

           //Valido que no existan errores
           COWGRA9( peBase
                  : peNctw
                  : peCond(x).Rama
                  : peEpvm
                  : peEpvx
                  : peErro
                  : peMsgs );

           clear peErro;
           clear peMsgs;

           @@dife = *zeros;
           @@xopr = *zeros;
           peEpvx= peEpvx * (-1);
           if peCond(x).xrea <> 0 ;

             COWGRAI_GetCondComerciales (peBase:
                                         peNctw:
                                         peCond(x).Rama:
                                         p@xrea:
                                         p@xopr);


             @@dife = p@xrea - peCond(x).xrea;
             @@xopr = p@xopr - @@dife;

             if @@xopr < 0 or

               (@@dife > peEpvm or @@dife < peEpvx );

               peErro = -1;

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0129'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

               Data = '<br><br>'
                    + '<b>COWGRA8 (Response)</b>'                 + CRLF
                    + 'Fecha/Hora: '
                    + %trim(%char(%date():*iso)) + ' '
                    + %trim(%char(%time():*iso))                  + CRLF
                    + 'PEXREA:'
                    +  %trim(%editw(peCond(x).xrea : ' 0 ,  -'))  + CRLF
                    + 'PEXOPR:'
                    + %trim(%editw(@@xopr : ' 0 ,  -')) +'%'      + CRLF
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

             endif;

           endif;

           if peErro = 0;

             COWGRAI_updImpConcComer ( peBase :
                                       peNctw :
                                       peCond(x).Rama :
                                       peCond(x).Xrea );

           endif;

         endfor;

       endif;

       if peErro = 0;

         COWGRA7 ( peBase :
                   peNctw :
                   peNrPP :
                   peImpu :
                   peImpuC:
                   pePrem :
                   peErro :
                   peMsgs );

       endif;

       return;
