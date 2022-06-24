     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWRTV11: Recupera la cabecera de la Cotización           *
      * --------------------------------------------------------- *
      * Sergio Fernandez                    *24-Nov-2017          *
      * ----------------------------------------------------------*
      *                                                           *
      * ********************************************************* *
     Fgntloc02  if   e           k disk

     D COWRTV11        pr                  ExtPgm('COWRTV11')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0  const
     D  peClie                             likeds(ClienteCot_t)
     D  peFctw                        8  0
     D  peMone                        2
     D  peNmol                       30
     D  peCome                        9  6
     D  peLoca                       25
     D  peArcd                        6  0
     D  peArno                       30
     D  peSpol                        9  0
     D  peSspo                        3  0
     D  peNcil                       30
     D  peTiou                        1  0
     D  peStou                        2  0
     D  peStos                        2  0
     D  peSpo1                        9  0
     D  peCfpg                        3  0
     D  peDefp                       20
     D  peNcbu                       22  0
     D  peCtcu                        3  0
     D  peNrtc                       20  0
     D  peFvct                        6  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWRTV11        pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0  const
     D  peClie                             likeds(ClienteCot_t)
     D  peFctw                        8  0
     D  peMone                        2
     D  peNmol                       30
     D  peCome                        9  6
     D  peLoca                       25
     D  peArcd                        6  0
     D  peArno                       30
     D  peSpol                        9  0
     D  peSspo                        3  0
     D  peNcil                       30
     D  peTiou                        1  0
     D  peStou                        2  0
     D  peStos                        2  0
     D  peSpo1                        9  0
     D  peCfpg                        3  0
     D  peDefp                       20
     D  peNcbu                       22  0
     D  peCtcu                        3  0
     D  peNrtc                       20  0
     D  peFvct                        6  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

      * Variables para Log
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')
     D rc              s              1n
     D @@ctw3          ds                  likeds(Asegurado_t) dim(999)
     D @@ctw3C         s             10i 0

     D peTipe          s              1a
     D peAsen          s              7  0
     D peNomb          s             40a
     D peCopo          s              5  0
     D peCops          s              1  0
     D peCiva          s              2  0

      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

       *inlr  = *on;

       clear peClie;
       peFctw = 0;
       peMone = *blanks;
       peNmol = *blanks;
       peCome = 0;
       peLoca = *blanks;
       peArcd = 0;
       peArno = *blanks;
       peSpol = 0;
       peSspo = 0;
       peNcil = *blanks;
       peTiou = 0;
       peStou = 0;
       peStos = 0;
       peSpo1 = 0;
       peCfpg = 0;
       peDefp = *blanks;
       peNcbu = 0;
       peCtcu = 0;
       peNrtc = 0;
       peFvct = 0;
       peErro = 0;
       clear peMsgs;

       Data = CRLF                                          + CRLF
            + '<b>COWRTV11 (Request)</b>'                   + CRLF
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

       rc = COWRTV_getAsegurado( peBase
                               : peNctw
                               : @@ctw3
                               : @@ctw3C );

       if rc;
          if @@ctw3C >= 1;
             peClie.asen = peAsen;
             peClie.tido = @@ctw3(1).w3tido;
             peClie.nrdo = @@ctw3(1).w3nrdo;
             peClie.nomb = peNomb;
             peClie.cuit = @@ctw3(1).w3cuit;
             peClie.tipe = peTipe;
             peClie.copo = peCopo;
             peClie.cops = peCops;
             peClie.civa = peCiva;
             chain (peCopo:peCops) gntloc02;
             if not %found;
                loproc = *blanks;
                prrpro = 0;
             endif;
             peClie.proc = loproc;
             peClie.rpro = prrpro;
          endif;
       endif;

       Data =
              '<br><br><b>COWRTV11 (Response)</b>'     + CRLF
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
            + 'PEFVCT: '  + %editc(peFvct:'X')         + CRLF
            + 'PETIDO: '  + %editc(peClie.tido:'X')    + CRLF
            + 'PENRDO: '  + %editc(peClie.nrdo:'X')    + CRLF
            + 'PECUIT: '  + %trim(peClie.cuit);
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
