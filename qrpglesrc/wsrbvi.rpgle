     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPVI: QUOM Versión 2                                       *
      *         Bien asegurado vigente para una fecha determinada    *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *24-Ene-2019            *
      * ************************************************************ *
     Fpahpol09  if   e           k disk
     Fset001    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpriv_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpvid_h.rpgle'

     D uri             s            512a
     D Empr            s              1a
     D Sucu            s              2a
     D Nivt            s              1a
     D Nivc            s              5a
     D Nit1            s              1a
     D Niv1            s              5a
     D Arcd            s              6a
     D Spol            s              9a
     D Rama            s              2a
     D Arse            s              2a
     D Oper            s              7a
     D Poco            s              6a
     D Fech            s             10a
     D Femi            s             10a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@Arcd          s              6  0
     D @@Spol          s              9  0
     D @@Rama          s              2  0
     D @@Arse          s              2  0
     D @@Oper          s              7  0
     D @@Fech          s              8  0
     D @@Femi          s              8  0
     D @@Stat          s              1n
     D @@Sspo          s              3  0
     D @@Suop          s              3  0
     D @@Poco          s              6  0
     D @@Paco          s              3  0
     D @@DsV0          ds                  likeds( dsPahev0_t ) dim( 999 )
     D @@DsV0C         s             10i 0
     D p@Poco          s              4  0
     D @@Leng          s             10i 0
     D @@Poli          s              7  0
     D Vigente         s              1a
     D @@repl          s          65535a
     D tmpfec          s               d   datfmt(*iso) inz

     D k1hpol          ds                  likerec(p1hpol:*key)
     D peMsgs          ds                  likeds(paramMsgs)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

     D @lda            ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(@lda:401)
     D  sucu                          2a   overlay(@lda:402)

     D SPVIG3          pr                  extpgm('SPVIG3')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peRama                        2  0
     D  peArse                        2  0
     D  peOper                        7  0
     D  pePoco                        4  0
     D  peFech                        8  0
     D  peFemi                        8  0
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3a   const
     D  peVig2                        1n   options(*nopass) const

     D SPVIG4          pr                  extpgm('SPVIG4')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peRama                        2  0
     D  peArse                        2  0
     D  peOper                        7  0
     D  pePoco                        4  0
     D  peFech                        8  0
     D  peFemi                        8  0
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3a   const

     D SPVIG5          pr                  extpgm('SPVIG5')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peRama                        2  0
     D  peArse                        2  0
     D  peOper                        7  0
     D  pePoco                        6  0
     D  pePaco                        3  0
     D  peFech                        8  0
     D  peFemi                        8  0
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3a   const
     D  peSpvig2                      1n   options(*nopass) const
     D  peNomi                        1n   options(*nopass) const

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
       Empr = REST_getNextPart(url);
       Sucu = REST_getNextPart(url);
       Nivt = REST_getNextPart(url);
       Nivc = REST_getNextPart(url);
       Nit1 = REST_getNextPart(url);
       Niv1 = REST_getNextPart(url);
       Arcd = REST_getNextPart(url);
       Spol = REST_getNextPart(url);
       Rama = REST_getNextPart(url);
       Arse = REST_getNextPart(url);
       Oper = REST_getNextPart(url);
       Poco = REST_getNextPart(url);
       Fech = REST_getNextPart(url);
       Femi = REST_getNextPart(url);

       @lda.empr = empr;
       @lda.sucu = sucu;
       out @lda;

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

       @@Arcd = %dec(arcd:6:0);
       @@Spol = %dec(spol:9:0);
       @@Rama = %dec(rama:2:0);
       @@Arse = %dec(Arse:2:0);
       @@Oper = %dec(Oper:7:0);
       @@Poco = %dec(Poco:6:0);
       Monitor;
         p@Poco = @@poco;
       on-error;
       endmon;

       k1hpol.poEmpr = Empr;
       k1hpol.poSucu = Sucu;
       k1hpol.poArcd = @@Arcd;
       k1hpol.poSpol = @@Spol;
       k1hpol.poNivt = %dec(Nivt:1:0);
       k1hpol.poNivc = %dec(Nivc:5:0);
       k1hpol.poRama = @@Rama;

       setll %kds( k1hpol:7 ) pahpol09;
       if not %equal( pahpol09 );
         %subst(@@repl:01:2) = Rama;
         %subst(@@repl:10:1) = Nivt;
         %subst(@@repl:11:5) = Nivc;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'POL0001'
                      : peMsgs
                      : %trim(@@repl)
                      : %len(%trim(@@repl)) );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : peMsgs.peMsid
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         close *all;
         return;
       else;
         reade %kds( k1hpol:7 ) pahpol09;
         @@Poli = poPoli;
       endif;

       monitor;
         tmpFec  = %date( Fech : *iso );
         @@Fech  = %dec( tmpFec : *iso );
       on-error;
         @@repl = Fech;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0009'
                      : peMsgs
                      : %trim(@@repl)
                      : %len(%trim(@@repl)) );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : peMsgs.peMsid
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         close *all;
         return;
       endmon;

       monitor;
         tmpFec  = %date( Femi : *iso );
         @@Femi  = %dec( tmpFec : *iso );
       on-error;
         @@repl = Femi;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'GEN0009'
                      : peMsgs
                      : %trim(@@repl)
                      : %len(%trim(@@repl)) );
         rc = REST_writeHeader( 400
                              : *omit
                              : *omit
                              : peMsgs.peMsid
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
         REST_end();
         close *all;
         return;
       endmon;

       chain @@Rama set001;
       if %found( set001 );

       // Autos

       if t@Rame = 4;
         if not SPVVEH_getPahet9( Empr
                                : Sucu
                                : @@Arcd
                                : @@Spol
                                : @@Rama
                                : @@Arse
                                : p@Poco
                                : *omit  );

           @@Repl =   %editw ( @@Poco : '0     ')
                  +   %editw ( @@Rama : '0 ')
                  +   %editw ( @@Poli : '0      ' );
           @@Leng = %len ( %trimr ( @@repl ) );
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'BIE0001'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : peMsgs.peMsid
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
         else;

          SPVIG3( @@Arcd
                : @@Spol
                : @@Rama
                : @@Arse
                : @@Oper
                : p@Poco
                : @@Fech
                : @@Femi
                : @@Stat
                : @@Sspo
                : @@Suop
                : *blanks
                : *off    );

          if @@Stat;
            Vigente = 'S';
          else;
            Vigente = 'N';
          endif;

          REST_writeHeader();
          REST_writeEncoding();
          REST_writeXmlLine( 'bienVigente' : '*BEG' );
          REST_writeXmlLine('vigente': Vigente);
          REST_writeXmlLine('suplementoSuperpoliza':%trim(%editc(@@Sspo:'X')));
          REST_writeXmlLine('suplementoPoliza':%trim(%editc(@@Suop:'X')));
          REST_writeXmlLine( 'bienVigente' : '*END' );

          SPVIG3( @@Arcd
                : @@Spol
                : @@Rama
                : @@Arse
                : @@Oper
                : p@Poco
                : @@Fech
                : @@Femi
                : @@Stat
                : @@Sspo
                : @@Suop
                : 'FIN'
                : *off    );

          return;

         endif;
       endif;

       // Riesgo Varios

       if t@Rame <> 4 and t@Rame <> 18 and t@Rame <> 21;
         if not SVPRIV_chkComponente( Empr
                                    : Sucu
                                    : @@Arcd
                                    : @@Spol
                                    : @@Rama
                                    : @@Arse
                                    : @@Oper
                                    : p@Poco );

           @@Repl =   %editw ( @@Poco : '0     ')
                  +   %editw ( @@Rama : '0 ')
                  +   %editw ( @@Poli : '0      ' );
           @@Leng = %len ( %trimr ( @@repl ) );
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'BIE0001'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : peMsgs.peMsid
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
         else;

          SPVIG4( @@Arcd
                : @@Spol
                : @@Rama
                : @@Arse
                : @@Oper
                : p@Poco
                : @@Fech
                : @@Femi
                : @@Stat
                : @@Sspo
                : @@Suop
                : *blanks );

          if @@Stat;
            Vigente = 'S';
          else;
            Vigente = 'N';
          endif;

          REST_writeHeader();
          REST_writeEncoding();
          REST_writeXmlLine( 'bienVigente' : '*BEG' );
          REST_writeXmlLine('vigente': Vigente);
          REST_writeXmlLine('suplementoSuperpoliza':%trim(%editc(@@Sspo:'X')));
          REST_writeXmlLine('suplementoPoliza':%trim(%editc(@@Suop:'X')));
          REST_writeXmlLine( 'bienVigente' : '*END' );

          SPVIG4( @@Arcd
                : @@Spol
                : @@Rama
                : @@Arse
                : @@Oper
                : p@Poco
                : @@Fech
                : @@Femi
                : @@Stat
                : @@Sspo
                : @@Suop
                : 'FIN'   );

          return;

         endif;
       endif;

       if t@Rame = 18 or t@Rame = 21;

         if not SVPVID_getComponentes( Empr
                                     : Sucu
                                     : @@Arcd
                                     : @@Spol
                                     : @@Rama
                                     : @@Arse
                                     : @@Oper
                                     : @@Poco
                                     : @@DsV0
                                     : @@DsV0C );

           @@Repl =   %editw ( @@Poco : '0     ')
                  +   %editw ( @@Rama : '0 ')
                  +   %editw ( @@Poli : '0      ' );
           @@Leng = %len ( %trimr ( @@repl ) );
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'BIE0001'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : peMsgs.peMsid
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
         else;

          @@Paco = @@DsV0(@@DsV0C).v0Paco;
          SPVIG5( @@Arcd
                : @@Spol
                : @@Rama
                : @@Arse
                : @@Oper
                : @@Poco
                : @@Paco
                : @@Fech
                : @@Femi
                : @@Stat
                : @@Sspo
                : @@Suop
                : *blanks
                : *off    );

          if @@Stat;
            Vigente = 'S';
          else;
            Vigente = 'N';
          endif;

          REST_writeHeader();
          REST_writeEncoding();
          REST_writeXmlLine( 'bienVigente' : '*BEG' );
          REST_writeXmlLine('vigente': Vigente);
          REST_writeXmlLine('suplementoSuperpoliza':%trim(%editc(@@Sspo:'X')));
          REST_writeXmlLine('suplementoPoliza':%trim(%editc(@@Suop:'X')));
          REST_writeXmlLine( 'bienVigente' : '*END' );

          SPVIG5( @@Arcd
                : @@Spol
                : @@Rama
                : @@Arse
                : @@Oper
                : @@Poco
                : @@Paco
                : @@Fech
                : @@Femi
                : @@Stat
                : @@Sspo
                : @@Suop
                : 'FIN'
                : *off    );

          return;

         endif;
       endif;

       endif;

       return;

      /end-free

