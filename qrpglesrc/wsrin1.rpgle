     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRINT: QUOM Versión 2                                       *
      *         Modifica Muestra de Datos de Contacto de Intermed.   *
      * ------------------------------------------------------------ *
      * Externo 1                            *27-Jul-2018            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D user            s            128a
     D tipo            s              1a
     D marca           s              1a

     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  job                          26a   overlay(PsDs:244)

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
       user = REST_getNextPart(url);
       tipo = REST_getNextPart(url);
       marca= REST_getNextPart(url);

       if not SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs);
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

       if ( user = *Blanks );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0019'
                      : peMsgs );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'GEN0019'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         return;
       endif;

       if ( tipo <> 'T' and tipo <> 'M' );
         @@repl = tipo;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0020'
                      : peMsgs
                      : %trim( @@repl )
                      : %len( %trim( @@repl ) ) );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'GEN0020'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         return;
       endif;

       if ( marca <> 'S' and marca <> 'N' );
         @@repl = marca;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0021'
                      : peMsgs
                      : %trim( @@repl )
                      : %len( %trim( @@repl ) ) );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'GEN0021'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         return;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRIN1':peBase);

       if ( tipo = 'M' );
         rc = SVPINT_setMostrarMails( empr
                                    : sucu
                                    : %dec( nivt : 1 : 0 )
                                    : %dec( nivc : 5 : 0 )
                                    : marca );
       else;
         rc = SVPINT_setMostrarTelefonos( empr
                                        : sucu
                                        : %dec( nivt : 1 : 0 )
                                        : %dec( nivc : 5 : 0 )
                                        : marca );
       endif;

       if not rc;
         rc = REST_writeHeader( 400 );
       else;
         rc = REST_writeHeader( 204 );
       endif;
       REST_end();

       return;
