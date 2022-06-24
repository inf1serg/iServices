     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWGRA7: Retorna Premio Final                             *
      * --------------------------------------------------------- *
      * Alvarez Fernando                     19-Oct-2015          *
      * --------------------------------------------------------- *
      * Modificaciones:                                           *
      * 15/12/15 - Se realizaron cambios de parametros            *
      * ********************************************************* *

     DCOWGRA7          pr                  extpgm('COWGRA7')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const
     D   peImpu                            likeds(primPrem) dim(99)
     D   peImpuC                     10i 0
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     DCOWGRA7          pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const
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

      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

       *inlr = *on;

       separa = *all'-';

       Data = '<br><br>'
            + '<b>COWGRA7 (Request)</b>'               + CRLF
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
            + 'PENCTW: '  + %editc(peNctw:'X')         + CRLF
            + 'PENRPP: '  + %editc(peNrpp:'X');
       COWLOG_log( peBase : peNctw : Data );

       pePrem = *Zeros;
       peImpuC = *Zeros;

       COWGRAI_updFormaDePagoCot( peBase
                                : peNctw
                                : peNrpp );

       COWGRAI_getPremioFinal ( peBase : peNctw );

       COWRTV_getImpuestos ( peBase : peNctw : peImpu );

       for x = 1 to 99;

         pePrem += peImpu( x ).prem;

         if peImpu( x ).rama = *Zeros;

           leave;

         endif;

       endfor;

       peImpuC = x - 1;

       COWGRAI_End();

       Data = '<br><br>'
            + '<b>COWGRA7 (Response)</b>'              + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEPREM: ' + %editw(pePrem:' .   .   .   . 0 ,  ') + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 99;
           if peImpu(i).rama <= 0;
              leave;
           endif;
           Data = 'PEIMPU(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;RAMA: ' + %editc(peImpu(i).rama:'X') + CRLF
                + '&nbsp;ARSE: ' + %editc(peImpu(i).arse:'X') + CRLF
                + '&nbsp;PRIM: ' +
                         %editw(peImpu(i).prim:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;XREF: ' +
                         %editw(peImpu(i).xref:' 0 ,  ')+CRLF
                + '&nbsp;REFI: ' +
                         %editw(peImpu(i).refi:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;DERE: ' +
                         %editw(peImpu(i).dere:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;SUBT: ' +
                         %editw(peImpu(i).subt:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;SERI: ' +
                         %editw(peImpu(i).seri:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;SEEM: ' +
                         %editw(peImpu(i).seem:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PIMI: ' +
                         %editw(peImpu(i).pimi:' 0 ,  ')+CRLF
                + '&nbsp;IMPI: ' +
                         %editw(peImpu(i).impi:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PSSO: ' +
                         %editw(peImpu(i).psso:' 0 ,  ')+CRLF
                + '&nbsp;SERS: ' +
                         %editw(peImpu(i).sers:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PSSN: ' +
                         %editw(peImpu(i).pssn:' 0 ,  ')+CRLF
                + '&nbsp;TSSN: ' +
                         %editw(peImpu(i).tssn:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PIVI: ' +
                         %editw(peImpu(i).pivi:' 0 ,  ')+CRLF
                + '&nbsp;IPR1: ' +
                         %editw(peImpu(i).ipr1:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PIVN: ' +
                         %editw(peImpu(i).pivn:' 0 ,  ')+CRLF
                + '&nbsp;IPR4: ' +
                         %editw(peImpu(i).ipr4:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PIVR: ' +
                         %editw(peImpu(i).pivr:' 0 ,  ')+CRLF
                + '&nbsp;IPR3: ' +
                         %editw(peImpu(i).ipr3:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;IPR5: ' +
                         %editw(peImpu(i).ipr5:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;IPR6: ' +
                         %editw(peImpu(i).ipr6:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;IPR7: ' +
                         %editw(peImpu(i).ipr7:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;IPR8: ' +
                         %editw(peImpu(i).ipr8:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;IPR9: ' +
                         %editw(peImpu(i).ipr9:' .   .   .   . 0 ,  ')+CRLF
                + '&nbsp;PREM: ' +
                         %editw(peImpu(i).prem:' .   .   .   . 0 ,  ')+CRLF
                + 'PEIMPU' + CRLF;
          COWLOG_log( peBase : peNctw : Data );
       endfor;

       Data = separa + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       return;
