     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRCXA: QUOM Versión 2                                       *
      *         Lista cuentas bancarias de un asegurado              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *02-Ene-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'

     D WSLCXA          pr                  ExtPgm('WSLCXA')
     D  peBase                             likeds(paramBase) const
     D  peAsen                        7  0 const
     D  peTipo                       10a   const
     D  peDcbu                             likeds(AsegCbus_t) dim(100)
     D  peDcbuC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D asen            s              7a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D x               s             10i 0
     D @@asen          s              7  0
     D cbue            s             22a

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peDcbu          ds                  likeds(AsegCbus_t) dim(100)
     D peErro          s             10i 0
     D peDcbuC         s             10i 0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       asen = REST_getNextPart(url);
       monitor;
          @@asen = %dec(asen:7:0);
        on-error;
          @@asen = 0;
       endmon;

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endif;

       clear peBase;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       WSLCXA( peBase
             : @@asen
             : '*ALL'
             : peDcbu
             : peDcbuC
             : peErro
             : peMsgs );

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'cuentasBancarias' );

       for x = 1 to peDcbuC;
           cbue = %trim(peDcbu(x).ncbu);
           %subst(cbue:1:18) = *all'*';
           REST_startArray( 'cuentaBancaria' );
            REST_writeXmlLine( 'numeroCbu'     : %trim(peDcbu(x).ncbu) );
            REST_writeXmlLine( 'numeroCbuEdit' : %trim(cbue)           );
            REST_writeXmlLine( 'codigoBloqueo' : %trim(peDcbu(x).bloq) );
            REST_writeXmlLine( 'descriBloqueo' : %trim(peDcbu(x).blod) );
           REST_endArray( 'cuentaBancaria' );
       endfor;

       REST_endArray( 'cuentasBancarias' );

       return;

