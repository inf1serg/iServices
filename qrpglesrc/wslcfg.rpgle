     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCFG: WebService - Realiza Cambio de forma de Pago Poliza  *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                               *30-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SGF 21/11/2015: Nueva versión: Acomodo para que sea SOAP.    *
      *                                                              *
      * ************************************************************ *
     Fpahed004  if   e           k disk
     Fset001    if   e           k disk
     Fsehni201  if   e           k disk

      /copy './qcpybooks/spvfdp_h.rpgle'
      /copy './qcpybooks/spvtcr_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'

     D WSLCFG          pr                  ExtPgm('WSLCFG')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peInfo                     256    const
     D   peLong                      10i 0 const
     D   peNfdp                       1  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLCFG          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peInfo                     256    const
     D   peLong                      10i 0 const
     D   peNfdp                       1  0 const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SndMail         pr                  extpgm('SNDMAIL')
     D  peCprc                       20a   const
     D  peCspr                       20a   const options(*nopass:*omit)
     D  peMens                      512a   varying options(*nopass:*omit)
     D  peLmsg                     5000a   options(*nopass:*omit)

     D @@user          s             10a   inz('CAMBIOWEB')

     D @@repl          s          65535a
     D @@long          s             10i 0

     D @@prod          s            512a
     D @@rama          s            512a
     D @@dfdp          s            512a
     D @@body          s            512a   varying

     D @@sspo          s              3  0
     D @@asen          s              7  0
     D @@desd          s              6  0
     D @@hast          s              6  0

     D @@ivbc          s              3  0
     D @@ivsu          s              3  0
     D @@tcta          s              2  0
     D @@ncta          s             25

     D ErrCode         s             10i 0
     D ErrText         s             80a

     D k1hed0          ds                  likeRec( p1hed004 : *Key )
     D k1yni2          ds                  likeRec( s1hni201 : *Key )

     D @@dsTc          ds                  likeds ( DSFMTTCR )
     D @@dsDe          ds                  likeds ( DSFMTDEB )
     D @@dsEf          ds                  likeds ( DSFMTCOB )

       *inLr = *On;

       peErro = *Zeros;
       clear peMsgs;

       // Valido existencia de productor
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       // Valido existencia de poliza
       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       setll %kds ( k1hed0 : 4 ) pahed004;

       if not %equal ( pahed004 );

         %subst(@@repl:1:2) = %editc(peRama:'X');
         %subst(@@repl:3:7) = %trim(%char(pePoli));
         @@long = %len ( %trim ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                         peMsgs : @@Repl  : @@long );

         peErro = -1;
         return;

       endif;

       // Obtengo Artuclo y SuperPoliza
       reade %kds ( k1hed0 : 4 ) pahed004;

       // Valido si productor esta habilitado
       if not SPVFDP_chkIntFdpWeb ( peBase.peEmpr : peBase.peSucu
                                  : peBase.peNivt : peBase.peNivc );

         @@repl = %editC( peBase.peNivt : '4' : *ASTFILL )
                + %editC( peBase.peNivc : '4' : *ASTFILL );
         @@long = %len ( %trim ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PRD0004'
                       : peMsgs : @@repl : @@long );

         peErro = -1;
         return;

       endif;

       // Valido si forma de pago es valida
       if not SPVFDP_chkNuevaFDP ( peNfdp );

         @@repl = %editC( peNfdp : '4' : *ASTFILL );
         @@long = %len ( %trim ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0001'
                       : peMsgs : @@repl : @@long );

         peErro = -1;
         return;

       endif;

       // Valido que se pueda realizar el cambio de forma de pago
       if not SPVFDP_chkPoliCbioV2 ( peBase.peEmpr : peBase.peSucu :
                                     d0arcd : d0spol : @@sspo );

         ErrText = SPVSPO_Error(ErrCode);

         select;

           when ( ErrCode = SPVSPO_CPENT );
             @@repl = %editC ( peRama : '4' : *ASTFILL )  +
                      %editC ( pePoli : '4' : *ASTFILL )  +
                      %editC ( @@sspo : '4' : *ASTFILL );
             @@long = %len ( %trim ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0003'
                           : peMsgs : @@repl : @@long );

           when ( ErrCode = SPVSPO_CPPRE );
             @@repl = %editC ( peRama : '4' : *ASTFILL )  +
                      %editC ( pePoli : '4' : *ASTFILL )  +
                      %editC ( @@sspo : '4' : *ASTFILL );
             @@long = %len ( %trim ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0004'
                           : peMsgs : @@repl : @@long );

           when ( ErrCode = SPVSPO_SPPSP );
             @@repl = %editC ( peRama : '4' : *ASTFILL )  +
                      %editC ( pePoli : '4' : *ASTFILL )  +
                      %editC ( @@sspo : '4' : *ASTFILL );
             @@long = %len ( %trim ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0005'
                           : peMsgs : @@repl : @@long );

           other;
             @@repl = %editC ( peRama : '4' : *ASTFILL )  +
                      %editC ( pePoli : '4' : *ASTFILL );
             @@long = %len ( %trim ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0006'
                           : peMsgs : @@repl : @@long );

         endsl;

         peErro = -1;
         return;

       endif;

       select;

         when ( peNfdp = 1 );

           if not SPVFDP_setDsTcr ( peInfo : @@dsTc );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0002' : peMsgs );
             peErro = -1;
             return;
           endif;

           if not SPVTCR_chkTcr ( @@dsTc.tcCtcu : @@dsTc.tcNrtc );

             ErrText = SPVTCR_Error(ErrCode);

             select;

               when ( ErrCode = SPVTCR_EMINE );
                 @@repl = %char ( @@dsTc.tcCtcu );
                 @@long = %len ( %trim ( @@repl ) );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'TCR0001'
                               : peMsgs : @@repl : @@long );

               when ( ErrCode = SPVTCR_EMBLO );
                 @@repl = %char ( @@dsTc.tcCtcu );
                 @@long = %len ( %trim ( @@repl ) );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'TCR0002'
                               : peMsgs : @@repl : @@long );

               when ( ErrCode = SPVTCR_NROCE );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'TCR0003' : peMsgs );

               other;
                 @@repl = %char ( @@dsTc.tcNrtc );
                 @@long = %len ( %trim ( @@repl ) );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'TCR0004'
                               : peMsgs : @@repl : @@long );

             endsl;
             peErro = -1;
             return;
           endif;

           @@asen = SPVSPO_getAsen ( peBase.peEmpr : peBase.peSucu
                                   : d0arcd : d0spol );
           @@desd = *Month * 10000 + *Year;
           @@hast = *Month * 10000 + *Year + 5;

           SPVTCR_setTcr ( @@asen : @@dsTc.tcCtcu : @@dsTc.tcNrtc
                         : @@desd : @@hast : @@user );

           if SPVFDP_setCbioTarjCredV2 ( peBase.peEmpr : peBase.peSucu :
                                         d0arcd : d0spol : @@dsTc.tcCtcu :
                                         @@dsTc.tcNrtc : @@user );
           endif;

         when ( ( peNfdp = 2 ) or ( peNfdp = 3 ) );

           if not SPVFDP_setDsDeb ( peInfo : @@dsDe );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0002' : peMsgs );
             peErro = -1;
             return;
           endif;

           if not SPVCBU_GetCBUSeparado ( @@dsDe.deNcbu : @@ivbc : @@ivsu
                                        : @@tcta : @@ncta );

             ErrText = SPVCBU_Error(ErrCode);

             select;

               when ( ErrCode = SPVCBU_BCONF );
                 @@repl = %char ( @@ivbc );
                 @@long = %len ( %trim ( @@repl ) );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0001'
                               : peMsgs : @@repl : @@long );

               when ( ErrCode = SPVCBU_BSUNF );
                 @@repl = %editC ( @@ivbc : '4' : *ASTFILL )  +
                          %editC ( @@ivsu : '4' : *ASTFILL );
                 @@long = %len ( %trim ( @@repl ) );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0002'
                               : peMsgs : @@repl : @@long );

               when ( ErrCode = SPVCBU_CTINV or errCode = SPVCBU_TCTBL );
                 @@repl = %char ( @@tcta );
                 @@long = %len ( %trim ( @@repl ) );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0003'
                               : peMsgs : @@repl : @@long );

               when ( ErrCode = SPVCBU_NCINV );
                 @@repl = %trim ( @@ncta );
                 @@long = %len ( %trim ( @@repl ) );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0004'
                               : peMsgs : @@repl : @@long );

               other;
                 @@repl = %trim ( @@dsDe.deNcbu );
                 @@long = %len ( %trim ( @@repl ) );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0005'
                               : peMsgs : @@repl : @@long );

             endsl;
             peErro = -1;
             return;
           endif;

           @@asen = SPVSPO_getAsen ( peBase.peEmpr : peBase.peSucu
                                   : d0arcd : d0spol );
           SPVCBU_SetCBUEntero ( @@dsDe.deNcbu : @@asen : @@user );

           if SPVFDP_setCbioDebitBcoV2 ( peBase.peEmpr : peBase.peSucu :
                                         d0arcd : d0spol :
                                         @@dsDe.deNcbu : @@user );
           endif;
         other;

           if not SPVFDP_setDsCob ( peInfo : @@dsEf );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0002' : peMsgs );
             peErro = -1;
             return;
           endif;

           if SPVFDP_setCbioCobradorV2 ( peBase.peEmpr : peBase.peSucu :
                                         d0arcd : d0spol : @@dsEf.coCobr :
                                         @@dsEf.coZona : @@user );
           endif;

       endsl;

       k1yni2.n2empr = peBase.peEmpr;
       k1yni2.n2sucu = peBase.peSucu;
       k1yni2.n2nivt = peBase.peNivt;
       k1yni2.n2nivc = peBase.peNivc;
       chain %kds ( k1yni2 ) sehni201;

       @@prod = %char ( peBase.peNivt ) + '/' + %char ( peBase.peNivc )
              + ' ' + %trim ( dfnomb );

       chain peRama set001;
       @@rama = %char ( peRama ) + ' - ' + %trim ( t@ramd );

       MAIL_getBody ( 'FDPWEB' : 'CAMFDP' : @@body );

         @@body = %scanrpl( '%%PROD%%' : %trim ( @@prod ) : @@body );
         @@body = %scanrpl( '%%RAMA%%' : %trim ( @@rama ) : @@body );
         @@body = %scanrpl( '%%POLI%%' : %editc ( pePoli : 'X' ) : @@body );

       SNDMAIL ( 'FDPWEB' : 'CAMFDP' : @@body );

       return;
