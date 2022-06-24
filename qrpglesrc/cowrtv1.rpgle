     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWRTV1: Recupera la cabecera de la Cotización            *
      * --------------------------------------------------------- *
      * Alvarez Fernando                     22-Sep-2015          *
      * ----------------------------------------------------------*
      * 15/12/15 - Se realizaron cambios de parametros            *
      * SGF 06/08/2016: Recibir peAsen.                           *
      *                                                           *
      * ********************************************************* *

     D COWRTV1         pr                  ExtPgm('COWRTV1')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peFctw                       8  0
     D   peAsen                       7  0
     D   peNomb                      40
     D   peMone                       2
     D   peNmol                      30
     D   peCome                       9  6
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peLoca                      25
     D   peArcd                       6  0
     D   peArno                      30
     D   peSpol                       9  0
     D   peSspo                       3  0
     D   peTipe                       1
     D   peCiva                       2  0
     D   peNcil                      30
     D   peTiou                       1  0
     D   peStou                       2  0
     D   peStos                       2  0
     D   peSpo1                       9  0
     D   peCfpg                       3  0
     D   peDefp                      20
     D   peNcbu                      22  0
     D   peCtcu                       3  0
     D   peNrtc                      20  0
     D   peFvct                       6  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWRTV1         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peFctw                       8  0
     D   peAsen                       7  0
     D   peNomb                      40
     D   peMone                       2
     D   peNmol                      30
     D   peCome                       9  6
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peLoca                      25
     D   peArcd                       6  0
     D   peArno                      30
     D   peSpol                       9  0
     D   peSspo                       3  0
     D   peTipe                       1
     D   peCiva                       2  0
     D   peNcil                      30
     D   peTiou                       1  0
     D   peStou                       2  0
     D   peStos                       2  0
     D   peSpo1                       9  0
     D   peCfpg                       3  0
     D   peDefp                      20
     D   peNcbu                      22  0
     D   peCtcu                       3  0
     D   peNrtc                      20  0
     D   peFvct                       6  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * Variables para Log
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

       *inlr  = *on;

      //Log de Entrada...
       Data = CRLF                                          + CRLF
            + '<b>COWRTV1 (Request)</b>'                    + CRLF
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
            + 'PENCTW: '  + %editc(peNctw:'X');
       COWLOG_log( peBase : peNctw : Data );

       COWRTV_getCabecera ( peBase
                          : peNctw
                          : peFctw
                          : peAsen
                          : peNomb
                          : peMone
                          : peNmol
                          : peCome
                          : peCopo
                          : peCops
                          : peLoca
                          : peArcd
                          : peArno
                          : peSpol
                          : peSspo
                          : peTipe
                          : peCiva
                          : peNcil
                          : peTiou
                          : peStou
                          : peStos
                          : peSpo1
                          : peCfpg
                          : peDefp
                          : peNcbu
                          : peCtcu
                          : peNrtc
                          : peFvct
                          : peErro
                          : peMsgs );

      //Log de Respuesta...
       Data =
              '<br><br><b>COWRTV1 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEFCTW: '  + %editc(peFctw:'X')         + CRLF
            + 'PEASEN: '  + %editc(peAsen:'X')         + CRLF
            + 'PENOMB: '  + %trim(peNomb)              + CRLF
            + 'PEMONE: '  + peMone                     + CRLF
            + 'PENMOL: '  + %trim(peNmol)              + CRLF
            + 'PECOME: '  + %trim(%editc(peCome:'K'))  + CRLF
            + 'PECOPO: '  + %editc(peCopo:'X')         + CRLF
            + 'PECOPS: '  + %editc(peCops:'X')         + CRLF
            + 'PELOCA: '  + %trim(peLoca)              + CRLF
            + 'PEARCD: '  + %editc(peArcd:'X')         + CRLF
            + 'PEARNO: '  + %trim(peArno)              + CRLF
            + 'PESPOL: '  + %editc(peSpol:'X')         + CRLF
            + 'PESSPO: '  + %editc(peSspo:'X')         + CRLF
            + 'PETIPE: '  + %trim(peTipe)              + CRLF
            + 'PECIVA: '  + %editc(peCiva:'X')         + CRLF
            + 'PENCIL: '  + %trim(peNcil)              + CRLF
            + 'PETIOU: '  + %editc(peTiou:'X')         + CRLF
            + 'PESTOU: '  + %editc(peStou:'X')         + CRLF
            + 'PESTOS: '  + %editc(peStos:'X')         + CRLF
            + 'PESPO1: '  + %editc(peSpo1:'X')         + CRLF
            + 'PECFPG: '  + %editc(peCfpg:'X')         + CRLF
            + 'PEDEFP: '  + %trim(peDefp)              + CRLF
            + 'PENCBU: '  + %editc(peNcbu:'X')         + CRLF
            + 'PECTCU: '  + %editc(peCtcu:'X')         + CRLF
            + 'PENRTC: '  + %editc(peNrtc:'X')         + CRLF
            + 'PEFVCT: '  + %editc(peFvct:'X');
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

       COWRTV_end();

       return;
