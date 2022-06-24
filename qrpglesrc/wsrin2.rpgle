     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRIN2: Actualiza mail de intermediario                      *
      * ------------------------------------------------------------ *
      * Externo 1                            *12-Sep-2018            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      * ************************************************************ *
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fpahwmp    uf a e           k disk
     Fsehni2p   uf a e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D tipo            s              1a
     D mail            s             50a

     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0

     D k1hni2p         ds                  likerec(s1hni2p:*key)
     D k1hwmp          ds                  likerec(p1hwmp:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  CurUsr                       10a   overlay(PsDs:358)

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

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
       tipo = REST_getNextPart(url);
       mail = REST_getNextPart(url);

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

       if ( tipo <> 'S' and tipo <> 'N' );
         @@repl = tipo;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0023'
                      : peMsgs
                      : %trim( @@repl )
                      : %len( %trim( @@repl ) ) );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'GEN0023'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         return;
       endif;

       if ( tipo = 'S' );
         if ( mail = *Blanks );
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'AAG0003'
                        : peMsgs );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'AAG0003'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           return;
         endif;
       endif;

       //Veo si existe en sehni2p
       k1hni2p.npempr = empr;
       k1hni2p.npsucu = sucu;
       k1hni2p.npnivt = %dec( nivt : 1 : 0 );
       k1hni2p.npnivc = %dec( nivc : 5 : 0 );
       chain %kds( k1hni2p : 4 ) sehni2p;

       if ( tipo = 'N' );
         if not %found( sehni2p );
           %subst( @@repl : 1 : 1 ) = nivt;
           %subst( @@repl : 2 : 5 ) = nivc;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRD0006'
                        : peMsgs
                        : %trim( @@repl )
                        : %len( %trim( @@repl ) ) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'PRD0006'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           return;
         endif;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec( nivt : 1 : 0 );
       peBase.peNivc = %dec( nivc : 5 : 0 );
       peBase.peNit1 = %dec( nit1 : 1 : 0 );
       peBase.peNiv1 = %dec( niv1 : 5 : 0 );

       COWLOG_logcon('WSRIN2':peBase);

       //Veo si existe en PAHWMP
       k1hwmp.wmnivt = %dec( nivt : 1 : 0 );
       k1hwmp.wmnivc = %dec( nivc : 5 : 0 );
       chain %kds( k1hwmp : 2 ) pahwmp;

       if ( tipo = 'S' );
         npdate = %dec( %date( ) : *iso );
         nptime = %dec( %time( ) : *iso );
         npuser = psds.curUsr;
         npmail = %trim( %xlate( may : min : mail ) );
         if %found( sehni2p );
           update s1hni2p;
         else;
           npempr = empr;
           npsucu = sucu;
           npnivt = %dec( nivt : 1 : 0 );
           npnivc = %dec( nivc : 5 : 0 );
           npmar1 = '0';
           npmar2 = '0';
           npmar3 = '0';
           npmar4 = '0';
           npmar5 = '0';
           write s1hni2p;
         endif;

         wmmail = %trim( %xlate( may : min : mail ) );
         wmmais = %trim( %xlate( may : min : mail ) );
         if %found( pahwmp );
           update p1hwmp;
         else;
           wmnivt = %dec( nivt : 1 : 0 );
           wmnivc = %dec( nivc : 5 : 0 );
           write p1hwmp;
         endif;
       else;
         delete s1hni2p;
         if %found( pahwmp );
           delete p1hwmp;
         endif;
       endif;

       rc = REST_writeHeader( 204 );
       REST_end();

       return;
