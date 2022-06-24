     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRPQ8: QUOM Versión 2                                       *
      *         Preliquidación - Insertar/Eliminar Cheque            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *17-Jul-2017            *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/plqweb_h.rpgle'

     D PLQWEB27        pr                  ExtPgm('PLQWEB27')
     D  peBase                             likeds(paramBase) const
     D  peNrpl                        7  0 const
     D  peIvbc                        3  0 const
     D  peNche                       30    const
     D  peFche                        8  0 const
     D  peEfvo                       15  2 const
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D PLQWEB28        pr                  ExtPgm('PLQWEB28')
     D  peBase                             likeds(paramBase) const
     D  peNrpl                        7  0 const
     D  peIvbc                        3  0 const
     D  peNche                       30    const
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D nrpl            s              7a
     D acci            s              1a
     D ivbc            s              3a
     D nche            s             30a
     D fche            s             10a
     D efvo            s             15
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D x               s             10i 0
     D @fche           s             10d
     D peEfvo          s             15  2
     D peNrpl          s              7  0
     D peIvbc          s              3  0
     D peFche          s              8  0

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0

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
       nrpl = REST_getNextPart(url);
       acci = REST_getNextPart(url);
       ivbc = REST_getNextPart(url);
       nche = REST_getNextPart(url);
       fche = REST_getNextPart(url);
       efvo = REST_getNextPart(url);

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

       if acci <> 'I' and
          acci <> 'E';
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'PQW0012'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
       endif;

       monitor;
          peEfvo = %dec(efvo:15:2);
        on-error;
          peEfvo = 0;
       endmon;

       monitor;
         peNrpl = %dec(nrpl:7:0);
        on-error;
         peNrpl = 0;
       endmon;

       monitor;
         peIvbc = %dec(ivbc:3:0);
        on-error;
         peIvbc = 0;
       endmon;

       monitor;
         @fche = %date(fche:*iso);
         peFche = %dec(@fche:*iso);
        on-error;
         peFche = 0;
       endmon;

       clear peBase;
       clear peMsgs;
       peErro = 0;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       if acci = 'I';
          PLQWEB27( peBase
                  : peNrpl
                  : peIvbc
                  : nche
                  : peFche
                  : peEfvo
                  : peErro
                  : peMsgs );
       endif;

       if acci = 'E';
          PLQWEB28( peBase
                  : peNrpl
                  : peIvbc
                  : nche
                  : peErro
                  : peMsgs );
       endif;

       if peErro = -1;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
           REST_end();
           return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'preliquidacion' : 'OK' );

       REST_end();

       return;

