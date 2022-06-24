     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRO02: QUOM Versión 2                                       *
      *         Ordenes de Pago, Aprobar/Desaprobar - Digital        *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *22-Ene-2021            *
      * ------------------------------------------------------------ *
      * SGF 28/10/21: El control de HVALOPCONR se hace solo si prcoma*
      *               no es ** ni *1.                                *
      * ************************************************************ *
     Fset400    if   e           k disk
     Fsehni4801 if   e           k disk
     Fcntegr    if   e           k disk

      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svpopg_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D artc            s              2a
     D pacp            s              6a
     D acci            s              1a
      * Variables ----------------------------------------------
     D code            s               n
     D @Hoy            s              8  0
     D @Ncbu           s             22
     D @Nrdf           s              7  0
     D @Nomb           s             40
     D @Domi           s             35
     D @Ndom           s              5  0
     D @Piso           s              3  0
     D @Deto           s              4
     D @Copo           s              5  0
     D @Cops           s              1  0
     D @Teln           s              7  0
     D @Faxn           s              7  0
     D @Tiso           s              2  0
     D @Tido           s              2  0
     D @Nrdo           s              8  0
     D @Cuit           s             11
     D @Njub           s             11  0
     D @Cuit2          s             11  0
     D @Arcd           s              6  0
     D @Spol           s              9  0
     D @Sspo           s              3  0
     D @Artc           s              2  0
     D @@Artc          s              2  0
     D @@Pacp          s              6  0
     D @@Retu          s               n
     D @@repl          s          65535a
     D @@long          s             10i 0
     D @@Pfer          s              8  0
     D @@Mayo          s              1a
     D ErrCode         s             10i 0
     D ErrText         s             80A

     D url             s           3000a   varying
     D x               s             10i 0
     D z               s             10i 0
     D rc              s              1n
     D rc2             s             10i 0
     D @@Dsts          s             40a
     D fecha           s              8  0
     D fechOrde        s             10a
     D Ctrl_arba       s               n
     D encontro        s               n
     D fec_pago        s               D   datfmt(*dmy)
     D @@vsys          s            512a

      * Auditorias -------------------------------------------------*
     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)
     D   JobCurU                     10a   overlay(PsDs:358)

     d WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     d  msg                         512a   const
     d  peMsg          s            512a

     d sleep           pr            10u 0 extproc('sleep')
     d  secs                         10u 0 value

      * Verifica si debe controlar contra padrón ARBA pasibles de embargo.
     DSP0085           pr                  extpgm('SP0085')
     D                                1    const
     D                                2    const
     D                                4  0 const
     D                                2  0 const
     D                                2  0 const
     D                               15  2 const
     D                                 n
      * Verifica si el CUIT está en el padrón ARBA pasibles de embargo.
     DSP0084           pr                  extpgm('SP0084')
     D                               11  0 const
     D                                 D   datfmt(*dmy) const
     D                                 n
      *
     D SPFECH          pr                  extpgm('SPFECH')
     D  peFech                       13a
      *
     D SPTRANSF        pr                  ExtPgm('SPTRANSF')
     D                                7  0 const
     D                                 n
     D                               22    options( *nopass : *omit )
      *
     D SPMFEC          pr                  extpgm('SPMFEC')
     D  dia1                          2  0 const
     D  mes1                          2  0 const
     D  aÑo1                          4  0 const
     D  dia2                          2  0 const
     D  mes2                          2  0 const
     D  aÑo2                          4  0 const
     D  mayo                          1
      * -------------------------------------------------------------------- *

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a

      * -------------------------------------------------------------------- *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      * Estructuras ------------------------------------------------ *
     D @@base          ds                  likeds(paramBase)
     D peErro          s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)
     D DsPa            ds                  likeds( dsCnhopa_t ) dim(9999)
     D DsPaC           s             10i 0
     D DsCfp           ds                  likeds( dsCntcfp_t )
     D DsNau           ds                  likeds( dsCntnau_t )
     D DsC1            ds                  likeds( dsPaheC1_t ) dim( 999 )
     D DsC1C           s             10i 0
     D DsNi2           ds                  likeds( DsSehni2_t )

      * Claves de arvhivos ----------------------------------------- *
     D k1hni4          ds                  likerec( s1hni48 : *key )
     D k1yegr          ds                  likerec( c1tegr  : *key )

      * Dtaara envío automático ------------------------------------ *
     D dtapdf          ds                  dtaara(DTAPDF01) qualified
     D  filler                       22a   overlay(dtapdf:1)
     D  enviar                        1a   overlay(dtapdf:*next)
     D  filer2                       77a   overlay(dtapdf:*next)

     D feccuil         ds                  dtaara('DTAFECUIL') qualified
     D  inicuil                       8  0 overlay(feccuil:1)

     D peFech          ds
     D  peFlap                01     05  0
     D  peFfec                06     13  0

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
         peMsgs.pemsev = 40;
         peMsgs.peMsid = 'RPG0001';
         peMsgs.pemsg1 = 'Error al parsear URL';
         peMsgs.pemsg2 = 'Error al parsear URL';
         exsr setError;
       endif;

       Data = CRLF + CRLF
            + '&nbsp<b>' +  psds.this  + '</b>'
            + '<b>Ordenes de Pago(Request)</b>'    + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspURL   : '      + uri               + CRLF ;
       COWLOG_pgmlog( psds.this : Data );

       url = %trim(uri);
       empr =  REST_getNextPart(url);
       sucu =  REST_getNextPart(url);
       artc =  REST_getNextPart(url);
       pacp =  REST_getNextPart(url);
       acci =  REST_getNextPart(url);

       empr = %xlate( min : may : empr );
       sucu = %xlate( min : may : sucu );
       acci = %xlate( min : may : acci );

       monitor;
         @@Artc = %int( %trim(artc) );
       on-error;
         @@Artc = 0;
       endmon;

       monitor;
         @@Pacp = %int( %trim(pacp) );
       on-error;
         @@Pacp = 0;
       endmon;

       if Acci <> 'A' and Acci <> 'D';
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0025' : peMsgs );
         exsr setError;
       endif;

       exsr validaDatos;

       if Acci = 'A';
         DsPa(1).paStop = '0';
       endif;

       if Acci = 'D';
         DsPa(1).paStop = '9';
       endif;

       if not SVPOPG_updCnhopa( DsPa(1) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0004' : peMsgs );
         exsr setError;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray('resultado');
         REST_writeXmlLine('ok' : '1');
       REST_endArray('resultado');

       clear peMsgs;
       Data = '<br><br><b>WSRMPO-Ordenes de Pago Aprobar/Desaprobar'
            + '(Response)</b> : Finalizo OK' + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                  + CRLF
            + 'PEERRO: ' +  '0'                           + CRLF
            + 'PEMSGS'                                    + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
            + 'PEMSGS' + CRLF;
       COWLOG_pgmlog( psds.this : Data );
       separa = *all'-';
       data = separa;
       COWLOG_pgmlog( psds.this : Data );
       REST_end();

      /end-free

       //* ---------------------------------------------------------- *
       begsr validaDatos;

       // Retorna datos de la Orden de Pago...
       clear DsPa;
       DsPaC = 0;
       if not SVPOPG_getCnhopa( Empr : Sucu : @@Artc : @@Pacp : DsPa : DsPaC );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0001' : peMsgs );
         exsr setError;
       endif;

       if DsPa(DsPaC).paStop = '8';
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0023' : peMsgs );
         exsr setError;
       endif;

       if DsPa(DsPaC).pbNras = *zeros;
         *in45 = *on;
       else;
         *in45 = *off;
       endif;

       if DsPa(DsPaC).paStop = '9';
         *in41 = *off;
       else;
         *in41 = *on;
       endif;

       if Acci = 'A';
         if *in45 and not *in41;
         else;
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0022' : peMsgs );
           exsr setError;
         endif;
       endif;

       if Acci = 'D';
         if *in45 and *in41;
         else;
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0022' : peMsgs );
           exsr setError;
         endif;
       endif;

       peFlap = 0;
       peFfec = (DsPa(DsPaC).paFerd * 1000000)
              + (DsPa(DsPaC).paFerm *   10000)
              +  DsPa(DsPaC).paFera;

       // Valida Fecha de Vencimiento...
       SPFECH( peFech );
       if peFlap = *zeros;
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0005' : peMsgs );
         exsr setError;
       endif;

       clear @@Mayo;
       SPMFEC( DsPa(DsPaC).paFerd
             : DsPa(DsPaC).paFerm
             : DsPa(DsPaC).paFera
             : DsPa(DsPaC).paFasd
             : DsPa(DsPaC).paFasm
             : DsPa(DsPaC).paFasa
             : @@Mayo             );

       if @@Mayo = '2';
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0006' : peMsgs );
         exsr setError;
       endif;

       // Valida Forma de Pago...
       clear DsCfp;
       if not SVPTAB_getCntcfp( Empr : Sucu : DsPa(DsPaC).paIvcv : DsCfp);
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0131' : peMsgs );
         exsr setError;
       endif;

       // CBU...
       clear DsNau;
       @@retu = *off;
       if SVPTAB_getCntnau( Empr
                          : Sucu
                          : DsPa(DsPaC).prComa
                          : DsPa(DsPaC).prNrma
                          : DsNau              );

         SPTRANSF( DsNau.naNrdf : @@retu );
       else;
         SPTRANSF( DsPa(DsPaC).prNrma : @@retu );
       endif;

       if not @@retu;
         if SVPTAB_chkCntcfp02( Empr : Sucu : 'C' : DsPa(DsPaC).paIvcv );
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0007' : peMsgs );
           exsr setError;
         endif;
       endif;

       // Salvo el Número de DAF según sea Siniestro o no...
       clear @nrdf;
       select;
         when DsPa(DsPaC).prComa = '**';
           @nrdf = DsPa(DsPaC).prNrma;
         other;
           @nrdf = DsNau.naNrdf;
       endsl;

       // Si Forma de Pago es transferencia, debe tener los datos...
       exsr ClrDatosDAF;

       if SVPDAF_getDaf( @Nrdf : @Nomb : @Domi : @Ndom : @Piso : @Deto
                       : @Copo : @Cops : @Teln : @Faxn : @Tiso : @Tido
                       : @Nrdo : @Cuit : @Njub );

         if DsCfp.fpmar1 = 'U';

           @Cuit2 = 0;
           for x = 1 to 11;
             if  %subst( @Cuit : x : 1 ) <> '0' and
                 %subst( @Cuit : x : 1 ) <> '1' and
                 %subst( @Cuit : x : 1 ) <> '2' and
                 %subst( @Cuit : x : 1 ) <> '3' and
                 %subst( @Cuit : x : 1 ) <> '4' and
                 %subst( @Cuit : x : 1 ) <> '5' and
                 %subst( @Cuit : x : 1 ) <> '6' and
                 %subst( @Cuit : x : 1 ) <> '7' and
                 %subst( @Cuit : x : 1 ) <> '8' and
                 %subst( @Cuit : x : 1 ) <> '9';
               %subst( @Cuit : x : 1 ) = '0';
             endif;
           endfor;

           @Cuit2 = %dec( @Cuit : 11 : 0 );
           if @Cuit2 = 0;
             @Cuit2 = @Njub;
           endif;

           // Al menos debe tener un documento o cuit o cuil...
           if (@Tido > 5 or @Nrdo = *zeros) and @Cuit = '00000000000' and
               @Njub = *zeros;
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0014' : peMsgs );
             exsr setError;
           endif;

           if not SVPDAF_getDa8( @Nrdf :  @Ncbu );
             ErrText = SVPDAF_Error(ErrCode);
             select;
               when ( ErrCode = SVPDAF_DAFCA );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0008' : peMsgs );
                 exsr setError;
               when ( ErrCode = SVPDAF_DAFCB );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0009' : peMsgs );
                 exsr setError;
               other;
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0024' : peMsgs );
                 exsr setError;
             endsl;
           endif;

           // A partir de cierta fecha, debe tener CUIL/CUIT...
           in     fecCuil;
           unlock fecCuil;
           @Hoy = %dec( %date() : *iso );
           if @Hoy >= FecCuil.iniCuil;
             if @Cuit2 <= *zeros;
               SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0010' : peMsgs );
               exsr setError;
             endif;
           endif;

           // Validar Moneda...
           if not SVPVAL_monedaV2( DsPa(DsPaC).paComo );
             ErrText = SVPVAL_Error(ErrCode);
             select;
               when ( ErrCode = SVPVAL_MONNE );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0003' : peMsgs );
                 exsr setError;
               when ( ErrCode = SVPVAL_MONBL );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0004' : peMsgs );
                 exsr setError;
               when ( ErrCode = SVPVAL_MONLC );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0011' : peMsgs );
                 exsr setError;
             endsl;
           endif;

           // Debe ser válida para el negocio de la póliza...
           read set400;
           if not %eof;
             @Artc = t@artc;
           endif;

           if @@Artc = @Artc and (DsCfp.fpMar3 <> 'P' and DsCfp.fpMar3 <> 'A');
             if SVPSIN_getSpol( Empr
                              : Sucu
                              : DsPa(DsPaC).paRama
                              : DsPa(DsPaC).paliqn
                              : *omit
                              : @Arcd
                              : @Spol
                              : @Sspo              ) = 0;

               if SPVSPO_getCabeceraSuplemento( Empr  : Sucu : @Arcd : @Spol
                                              : @Sspo : DsC1 : DsC1C );

                 k1hni4.n48Empr = Empr;
                 k1hni4.n48Sucu = Sucu;
                 k1hni4.n48ivcv = DsPa(DsPaC).paIvcv;
                 setll %kds( k1hni4 : 3 ) sehni4801;
                 reade %kds( K1hni4 : 3 ) sehni4801;
                 dow not %eof( sehni4801 );
                   if n48nivc = DsC1(DsC1C).c1Nivc;
                     encontro = *on;
                     leave;
                   endif;
                   reade %kds( K1hni4 : 3 ) sehni4801;
                 enddo;

                 if not encontro;
                   SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0012' : peMsgs );
                   exsr setError;
                 endif;
               endif;
             endif;
           endif;
         endif;
       else;
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0013' : peMsgs );
         exsr setError;
       endif;

       // Solo para aprobación...
       if %trim(DsPa(DsPaC).paStop) = '9';
         SP0085( Empr
               : Sucu
               : DsPa(DsPaC).paFasA
               : DsPa(DsPaC).paFasM
               : DsPa(DsPaC).paFasD
               : DsPa(DsPaC).paimau
               : Ctrl_arba          );

         if Ctrl_arba;
           if 0 = %check('1234567890':@Cuit) and DsCfp.fpMar4 = 'N';
             fec_pago = %date(*date);
             SP0084( @Cuit2 : fec_pago : code );
             if code;
               SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0015' : peMsgs );
               exsr setError;
             endif;

           endif;
         endif;
       endif;

       // Chequea a la Orden de...
       if DsPa(DsPaC).paIvcv = 1 and DsPa(DsPaC).paNomb = *blanks;
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0016' : peMsgs );
         exsr setError;
       endif;

       // Intermediario...
       if DsPa(DsPaC).paInta <> *zeros or DsPa(DsPaC).paInna <> *zeros;
         if not SVPTAB_chkAgente( Empr : Sucu : DsPa(DsPaC).paInta
                                : DsPa(DsPaC).paInna );

           clear DsNi2;
           if SVPINT_getIntermediario( Empr : Sucu : DsPa(DsPaC).paInta
                                     : DsPa(DsPaC).paInna : DsNi2 ) = -1;

             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0017' : peMsgs );
             exsr setError;
           endif;
        endif;
       endif;

       // Tipo de Gasto...
       if DsPa(DsPaC).paCode <> *zeros;
         k1yegr.teEmpr = Empr;
         k1yegr.teSucu = Sucu;
         k1yegr.teCode = DsPa(DsPaC).paCode;
         chain %kds( k1yegr : 3 ) cntegr;
         if %found( cntegr );
           if temarp = 'T';
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0018' : peMsgs );
             exsr setError;
           endif;
         endif;
       endif;

       // Validar que el Código mayor o el Número Mayor...
       if DsPa(DsPaC).paComa = *blanks or DsPa(DsPaC).paNrma <= *zeros;
         %subst(@@repl:1:2) = %editc( @@Artc : 'X');
         %subst(@@repl:3:6) = %editc( @@Pacp : 'X');
         @@long = %len ( %trim ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0019' : peMsgs
                       : @@repl : @@long );
         exsr setError;
       endif;

       if SVPVLS_getValSys( 'HVALOPCONR' : *omit : @@Vsys );
         if @@Vsys = 'S';
           if DsPa(DsPaC).prComa <> DsPa(DsPaC).paComa or
              DsPa(DsPaC).prNrma <> DsPa(DsPaC).paNrma;
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ODP0020' : peMsgs );
             if DsPa(DsPaC).prComa <> '**' and
                DsPa(DsPaC).prComa <> '*1';
                exsr setError;
             endif;
           endif;
         endif;
       endif;

       endsr;

       //* ---------------------------------------------------------- *
       begsr ClrDatosDAF;

         clear @Nomb;
         clear @Domi;
         clear @Ndom;
         clear @Piso;
         clear @Deto;
         clear @Copo;
         clear @Cops;
         clear @Teln;
         clear @Faxn;
         clear @Tiso;
         clear @Tido;
         clear @Nrdo;
         clear @Cuit;
         clear @Njub;

       endsr;

       //* ---------------------------------------------------------- *
       begsr setError;

         REST_writeHeader( 400
                         : *omit
                         : *omit
                         : peMsgs.peMsid
                         : peMsgs.peMsev
                         : peMsgs.peMsg1
                         : peMsgs.peMsg2 );

          Data = '<br><br><b>WSRO02-Ordenes de Pago Aprobar/Desaprobar'
               + '(Response)</b> : Error' + CRLF
               + 'Fecha/Hora: '
               + %trim(%char(%date():*iso)) + ' '
               + %trim(%char(%time():*iso))                  + CRLF
               + 'PEERRO: ' +  '-1'                          + CRLF
               + 'PEMSGS'                                    + CRLF
               + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
               + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
               + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
               + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
               + 'PEMSGS' + CRLF;
          COWLOG_pgmlog( psds.this : Data );
          separa = *all'-';
          data = separa;
          COWLOG_pgmlog( psds.this : Data );
          REST_end();
          return;
       endsr;

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/getsysv_h.rpgle'
