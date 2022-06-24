     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWBIEN17: WebService                                        *
      *            Propuesta Web                                     *
      *            Wrapper para _setMascotaAsegurada()               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *16-Mar-2020        *
      * ************************************************************ *

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/prwbien_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

      *
      * peBase = Parametro Base
      * peNctw = Numero de cotizacion web
      * peRama = Rama
      * peArse = Secuencia Articulo/Rama
      * pePoco = Numero de Componente
      * peRiec = Codigo de Riesgo
      * peXcob = Codigo de Cobertura
      * peMsec = Secuencia de Mascota
      * peCtma = Tipo de Mascota (tabla SET136)
      * peCraz = Raza de Mascota (tabla SET137)
      * peFnaa = Año de Nacimiento de la mascota
      * pePvac = Plan de Vacunacion? S=Si/N=No
      * peExpo = Se usa para exposicion? S=Si/N=No
      * peCria = Extender cobertura a la cria? S=Si/N=No
      * peSuas = Suma Asegurada de la mascota
      *

     D PRWBIEN17       pr                  ExtPgm('PRWBIEN17')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const
     D   peMsec                       9  0 const
     D   peCtma                       2  0 const
     D   peCraz                       4  0 const
     D   peFnaa                       4  0 const
     D   pePvac                       1a   const
     D   peExpo                       1a   const
     D   peCria                       1a   const
     D   peSuas                      15  2 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWBIEN17       pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const
     D   peMsec                       9  0 const
     D   peCtma                       2  0 const
     D   peCraz                       4  0 const
     D   peFnaa                       4  0 const
     D   pePvac                       1a   const
     D   peExpo                       1a   const
     D   peCria                       1a   const
     D   peSuas                      15  2 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a


      /free

       *inlr = *on;

       separa = *all'-';

       Data = CRLF                                     + CRLF
            + '<b>PRWBIEN17'
            + 'Insertar mascota asegurada(Request)</b>'+ CRLF
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
            + 'PEPOCO: '  + %editc(pePoco:'X')         + CRLF
            + 'PERIEC: '  + peRiec                     + CRLF
            + 'PEXCOB: '  + %editc(peXcob:'X')         + CRLF
            + 'PEMSEC: '  + %editc(peMsec:'X')         + CRLF
            + 'PECTMA: '  + %char(peCtma)              + CRLF
            + 'PECRAZ: '  + %char(peCraz)              + CRLF
            + 'PEFNAA: '  + %char(peFnaa)              + CRLF
            + 'PEPVAC: '  + %trim(pePvac)              + CRLF
            + 'PECRIA: '  + %trim(peCria)              + CRLF
            + 'PEEXPO: '  + %trim(peExpo)              + CRLF
            + 'PESUAS: '  +
                     %editw(peSuas:' .   .   .   . 0 ,  ') + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       PRWBIEN_setMascotaAsegurada( peBase
                                  : peNctw
                                  : peRama
                                  : peArse
                                  : pePoco
                                  : peRiec
                                  : peXcob
                                  : peMsec
                                  : peCtma
                                  : peCraz
                                  : peFnaa
                                  : pePvac
                                  : peCria
                                  : peExpo
                                  : peSuas
                                  : peErro
                                  : peMsgs );

       Data = '<br><br>'
            + '<b>PRWBIEN17 (Response)</b>'            + CRLF
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
