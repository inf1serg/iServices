     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRTAB: Retorna tablas de WSLTAB                             *
      * ------------------------------------------------------------ *
      * Externo 1                            *24-Oct-2018            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/wsltab_h.rpgle'

     D uri             s            512a
     D nomb            s             20a
     D tipo            s              1a

     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n

     D peErro          s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)

     D gen_t           ds                  qualified template
     D  codi                         20a
     D  desc                         80a
     D  mweb                          1a

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  job                          26a   overlay(PsDs:244)

     D x               s             10i 0
     D cReg            s             10i 0

     D lGen            ds                  likeds( gen_t ) dim( 999 )
     D lEst            ds                  likeds( gntnes_t ) dim( 9 )
     D lDep            ds                  likeds( gntdep_t ) dim( 999 )


       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       nomb = REST_getNextPart(url);
       tipo = REST_getNextPart(url);

       if ( nomb = *Blanks );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0024'
                      : peMsgs );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'GEN0024'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         return;
       endif;

       if ( tipo <> 'T' and tipo <> 'W' );
         tipo = 'T';
       endif;

       select;
         when ( nomb = 'DEPORTES' );
           WSLTAB_listaDeportes( lDep : cReg );
           for x = 1 to cReg;
             lGen( x ).codi = %editC( lDep( x ).cdep : 'X' );
             lGen( x ).desc = lDep( x ).ddep;
             lGen( x ).mweb = lDep( x ).mweb;
           endfor;

         when ( nomb = 'NIVELES_ESTUDIO' );
           WSLTAB_listaNivelesEstudio( lEst : cReg );
           for x = 1 to cReg;
             lGen( x ).codi = %editC( lEst( x ).cnes : 'X' );
             lGen( x ).desc = lEst( x ).dnes;
             lGen( x ).mweb = lEst( x ).mweb;
           endfor;

         other;
           @@repl = nomb;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'GEN0025'
                        : peMsgs
                        : %trim( @@repl )
                        : %len( %trim( @@repl ) ) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'GEN0025'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           return;
       endsl;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'Tabla' );
         REST_writeXmlLine( 'cantidadRegistros' : %editC( cReg : 'Z' ) );
         REST_startArray( 'Registros' );
           for x = 1 to cReg;
             REST_startArray( 'Registro' );
             REST_writeXmlLine( 'codigo'      : %trim( lGen( x ).codi ) );
             REST_writeXmlLine( 'descripcion' : %trim( lGen( x ).desc ) );
             REST_writeXmlLine( 'web'         : %trim( lGen( x ).mweb ) );
             REST_endArray( 'Registro' );
           endfor;
         REST_endArray( 'Registros' );
       REST_endArray( 'Tabla' );

       REST_end();
       return;
