     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRCF1: QUOM Versión 2                                       *
      *         Solicitud de cambio de forma de pago                 *
      * ------------------------------------------------------------ *
      * Luis Roberto Gomez                   *16-Jun-2020            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *  JSN 28/08/2020 - Se agrega validaciones en los _setCbio y   *
      *                   en el _chkPoliCbioV3                       *
      *  JSN 02/08/2020 - Se agrega validacion de saldo y se mueve   *
      *                   el error que pertenecia a _chkPoliCbioV3   *
      *                   a la misma.                                *
      *  ERC 21/01/2021 - Inhabilitar para el cambio de forma de pago*
      *                   a las anuladas.                            *
      *  JSN 26/02/2021 - Se agregar grabar archivo PAHAG1, cuando la*
      *                   solicitud provenga de la Wed de Asegurado  *
      *                   y el mismo de Error.                       *
      * ************************************************************ *
     Fpahcf1    uf a e           k disk
     Fcntvtc    if   e           k disk
     Fpahag1    if a e           k disk

      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/spvtcr_h.rpgle'
      /copy './qcpybooks/spvfdp_h.rpgle'
      /copy './qcpybooks/svpart_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/svpend_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D arcd            s              6a
     D spol            s              9a
     D rama            s              2a
     D poli            s              7a
     D tdoc            s              2a
     D ndoc            s             11a
     D cfpg            s              1a
     D info            s            256a
     D tcven           s              4a
     D tipo            s              1a
     D from            s              1a
      * Variables ----------------------------------------------
     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0
     D @@desd          s              6  0
     D @@empr          s              1a
     D @@sucu          s              2a
     D @@nivt          s              1  0
     D @@nivc          s              5  0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@arcd          s              6  0
     D @@spol          s              9  0
     D @@rama          s              2  0
     D @@poli          s              7  0
     D @@tdoc          s              2  0
     D @@ndoc          s             11  0
     D @@tipo          s              1
     D @@from          s              1
     D @@repl          s          65535a
     D @@long          s             10i 0
     D @@Nrpp          s              3  0
     D @@Cfpg          s              1  0
     D @@Sspo          s              3  0
     D @@Nrdf          s              7  0
     D @@Cuit          s             11
     D @@Femi          s              8  0
     D @@DMA           s              8  0
     D @@Mens          s            512
     D @@MsgID         s              7
     D @@Ivbc          s              3  0
     D @@Ivsu          s              3  0
     D @@Tcta          s              2  0
     D @@Ncta          s             25
     D @@Tcvt          s              6  0
     D @@Cfp1          s              1  0
     D @@Ncb1          s             25
     D @@Ctc1          s              3  0
     D @@Nrt1          s             20  0
     D @@Fvt1          s              6  0
     D @@Proc          s              1
     D @@Obse          s            200
     D @1ndoc          s              8  0
     D @1Cfpg          s              1  0
     D @@Ffta          s              4  0
     D @@Fftm          s              2  0
     D ErrCode         s             10i 0
     D ErrText         s             80A
     D @@Cade          s              5  0 dim(9)
     D @@DsTc          ds                  likeds ( DSFMTTCR )
     D @@DsDe          ds                  likeds ( DSFMTDEB )
     D @@DsEf          ds                  likeds ( DSFMTCOB )
     D @@DsA1          ds                  likeds ( dsPahea1_t )
     D @@DsC0          ds                  likeds ( dsPahec0_t )
     D @@DsC3          ds                  likeds( dsPahec3V2_t )
     D DsD0            ds                  likeds ( dsPahed0_t ) dim( 999 )
     D DsD0C           s             10i 0
     D DsAs            ds                  likeds ( dsPaheas_t ) dim( 9999 )
     D DsAsC           s             10i 0
     D k1ycf1          ds                  likerec( p1hcf1 : *key )
     D @@msg           s          65535a
     D @@endp          s              3    inz('   ')
     D @@vali          s               n
     D @@Fem6          s              6  0
     D @@tcv6          s              6  0
     D @@Vsys          s            512
     D peSald          s             13  2
     D peCant          s              5  0
     D peCcuo          s              3  0
     D pePrem          s             13  2
     D peEndp          s              3a
     D @@Tnum          s              1    inz('0')
     D @@Nres          s              7  0
     D @@Arse          s              2  0
     D @@Oper          s              7  0

     D url             s           3000a   varying
     D x               s             10i 0
     D z               s             10i 0
     D rc              s              1n
     D rc2             s             10i 0

      * Programas --------------------------------------------------*
     D PAR312I         pr                  extpgm('PAR312I')
     D  empr                          1
     D  sucu                          2
     D  arcd                          6  0
     D  spo1                          9  0
     D  spol                          9  0
     D  sspo                          3  0
     D  endp                          3
     D  nrpp                          3  0 const options(*Nopass)

     D SPT902          pr                  extpgm('SPT902')
     D  petnum                        1
     D  penres                        7  0

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

     d PAR310X3        pr                  extpgm('PAR310X3')
     d  peEmpr                        1a                           const
     d  peFema                        4  0
     d  peFemm                        2  0
     d  peFemd                        2  0

     d PAR317V         pr                  extpgm('PAR317V')
     d  peEmpr                        1a                           const
     d  peSucu                        2a                           const
     d  peArcd                        6  0                         const
     d  peSpol                        9  0                         const
     d  peRama                        2  0                         const
     d  pePoli                        7  0                         const
     d  peErro                        1n
     d  peMens                      512a

     D GSWEB310X       pr                  EXTPGM('GSWEB310X')
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const

     D GSWEB315X       pr                  EXTPGM('GSWEB315X')
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const

     D GSWEB520        pr                  EXTPGM('GSWEB520')
     D                                1    const
     D                                2    const
     D                                6  0 const
     D                                9  0 const
     D                                3  0 const

     D SP0079          pr                  extpgm('SP0079')
     D                                6  0
     D                                9  0
     D                                8  0
     D                                5  0
     D                               13  2
     D                                3  0
     D                               13  2
     D                                3

     d sleep           pr            10u 0 extproc('sleep')
     d  secs                         10u 0 value

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
     D @@erro          s               n
     D @@msgs          ds                  likeds(paramMsgs)
     D pemsgs          ds                  likeds(paramMsgs)
     D @@DsGc          ds                  likeds ( dsGnhdtc_t ) dim( 99 )
     D @@DsGcC         s             10i 0

      * Dtaara envío automático ------------------------------------ *
     D dtapdf          ds                  dtaara(DTAPDF01) qualified
     D  filler                       22a   overlay(dtapdf:1)
     D  enviar                        1a   overlay(dtapdf:*next)
     D  filer2                       77a   overlay(dtapdf:*next)

      * Claves de arvhivos ----------------------------------------- *
     D k1tvtc          ds                  likerec(c1tvtc:*key)

      /free

       *inlr = *on;

        //peMsg = PsDs.JobName;
        //WSLOG( peMsg );
        //peMsg = PsDs.JobUser;
        //WSLOG( peMsg );
        //peMsg = %editc(PsDs.JobNbr:'X');
        //WSLOG( peMsg  );
        //sleep(60);

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
         @@msgs.pemsev = 40;
         @@msgs.peMsid = 'RPG0001';
         @@msgs.pemsg1 = 'Error al parsear URL';
         @@msgs.pemsg2 = 'Error al parsear URL';
         exsr setError;
       endif;

       Data = CRLF + CRLF
            + '&nbsp<b>' +  psds.this  + '</b>'
            + '<b>Cambio de Forma de Pago (Request)</b>'    + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspURL   : '      + uri               + CRLF ;
       COWLOG_pgmlog( psds.this : Data );

       url = %trim(uri);
       empr =  REST_getNextPart(url);
       sucu =  REST_getNextPart(url);
       nivt =  REST_getNextPart(url);
       nivc =  REST_getNextPart(url);
       nit1 =  REST_getNextPart(url);
       niv1 =  REST_getNextPart(url);
       arcd =  REST_getNextPart(url);
       spol =  REST_getNextPart(url);
       rama =  REST_getNextPart(url);
       poli =  REST_getNextPart(url);
       tdoc =  REST_getNextPart(url);
       ndoc =  REST_getNextPart(url);
       cfpg =  REST_getNextPart(url);
       info =  REST_getNextPart(url);
       tcven = REST_getNextPart(url);
       tipo =  REST_getNextPart(url);
       from =  REST_getNextPart(url);

       tipo = %xlate( min : may : tipo );
       if ( tipo <> 'T' and tipo <> 'W' );
          tipo = 'T';
       endif;

       from = %xlate( min : may : from );
       if from = ' ';
          from = 'W';
       endif;

       if %check('0123456789':%trim(nivt)) <> *zeros;
          @@nivt = 0;
       else;
          monitor;
            @@nivt = %int( %trim(nivt) );
          on-error;
            @@nivt = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(nivc)) <> *zeros;
          @@nivc = 0;
       else;
          monitor;
            @@nivc = %int( %trim(nivc) );
          on-error;
            @@nivc = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(nit1)) <> *zeros;
          @@niv1 = 0;
       else;
          monitor;
            @@niv1 = %int( %trim(niv1) );
          on-error;
            @@niv1 = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(nit1)) <> *zeros;
          @@nit1 = 0;
       else;
          monitor;
            @@nit1 = %int( %trim(nit1) );
          on-error;
            @@nit1 = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(rama)) <> *zeros;
          @@rama = 0;
       else;
          monitor;
            @@rama = %int( %trim(rama) );
          on-error;
            @@rama = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(poli)) <> *zeros;
          @@poli = 0;
       else;
          monitor;
            @@poli = %int( %trim(poli) );
          on-error;
            @@poli = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(arcd)) <> *zeros;
          @@arcd = 0;
       else;
          monitor;
            @@arcd = %int( %trim(arcd) );
          on-error;
            @@arcd = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(spol)) <> *zeros;
          @@spol = 0;
       else;
          monitor;
            @@spol = %int( %trim(spol) );
          on-error;
            @@spol = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(tdoc)) <> *zeros;
          @@tdoc = 0;
       else;
          monitor;
            @@tdoc = %int( %trim(tdoc) );
          on-error;
            @@tdoc = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(ndoc)) <> *zeros;
          @@ndoc = 0;
       else;
          monitor;
            @@ndoc = %int( %trim(ndoc) );
          on-error;
            @@ndoc = 0;
          endmon;
       endif;

       if %check('0123456789':%trim(cfpg)) <> *zeros;
          @@cfpg = 0;
       else;
          monitor;
            @@cfpg = %int( %trim(cfpg) );
          on-error;
            @@cfpg = 0;
          endmon;
       endif;

       @@Base.peEmpr = empr;
       @@Base.peSucu = sucu;
       @@Base.peNivc = @@nivc;
       @@Base.peNivt = @@nivt;

       // Obtener Ultimo Suplemento
       @@Sspo = SPVSPO_getUltimoSuplemento( @@Base.peEmpr
                                          : @@Base.peSucu
                                          : @@Arcd
                                          : @@Spol        );

       PAR310X3( @@Base.peEmpr : @@a : @@m : @@d);
       @@femi = (@@a * 10000) + (@@m * 100) + @@d;
       @@fem6 = (@@a * 100) +  @@m;

       clear @@DsC0;
       //Obtener datos de pahec0;
       if SPVSPO_getCabecera( @@Base.peEmpr
                            : @@Base.peSucu
                            : @@Arcd
                            : @@Spol
                            : @@DsC0        );

         clear @@Fvt1;

         if @@DsC0.c0Cfpg = 1;
           if SPVTCR_fechaVencimientoTcr( @@DsC0.c0Asen
                                        : @@DsC0.c0Ctcu
                                        : @@DsC0.c0Nrtc
                                        : @@Ffta
                                        : @@Fftm        );

             @@Fvt1 = @@Fftm * 10000 + @@Ffta;
           endif;
         endif;

         if @@DsC0.c0Cfpg = 2 or @@DsC0.c0Cfpg = 3;
           @@Ncb1 = SPVCBU_getCBUEntero( @@DsC0.c0Ivbc
                                       : @@DsC0.c0Ivsu
                                       : @@DsC0.c0Tcta
                                       : @@DsC0.c0Ncta );
         else;
           @@Ncb1 = *blanks;
         endif;

         @@Cfp1 = @@DsC0.c0Cfpg;
         @@Ctc1 = @@DsC0.c0Ctcu;
         @@Nrt1 = @@DsC0.c0Nrtc;

       endif;

       exsr valida;
       exsr procesar;

      /end-free

       //* ---------------------------------------------------------- *
       begsr valida;

       // Valida Superpoliza...

       if not SPVSPO_chkSpol( @@Base.peEmpr
                            : @@Base.peSucu
                            : @@Arcd
                            : @@Spol        );

         clear @@repl;
         @@repl = %editC( @@Arcd : 'X')
                + %editC( @@Spol : 'X');
         @@long = %len ( %trim ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0017'
                       : @@msgs : @@repl : @@long );
         exsr setError;

       endif;

       if not SVPVAL_rama( @@Rama );

         clear @@repl;
         @@repl = %editC( @@Rama : 'X');
         @@long = %len ( %trim ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'RAM0001'
                       : @@msgs : @@repl : @@long );
         exsr setError;

       endif;

       if not SVPPOL_chkPoliza( @@Base.peEmpr
                              : @@Base.peSucu
                              : @@Rama
                              : @@Poli        );

         clear @@repl;
         @@repl = %editC( @@Rama : 'X');
         %subst(@@repl:3:7) = %editc( @@poli :'X');
         @@long = %len ( %trim ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009'
                       : @@msgs : @@repl : @@long );
         exsr setError;

       endif;

       // Validar si tiene OP anuladas...

           if SPVSPO_chkAnuladaV2( @@Base.peEmpr
                            : @@Base.peSucu
                            : @@Arcd
                            : @@Spol
                            : @@Femi        );

             clear @@repl;
             @@repl = %editC( @@poli : 'X');
             @@long = %len ( %trim ( @@repl ) );

             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0019'
                           : @@msgs : @@repl : @@long );
             exsr setError;

           endif;

       // Validar poliza vigente - SPVIG2...

       if SVPVLS_getValSys( 'HPOLVIGCFP' : *omit : @@Vsys );
         if @@Vsys = 'S';

           if not SPVSPO_chkVig( @@Base.peEmpr
                               : @@Base.peSucu
                               : @@Arcd
                               : @@Spol         );

             clear @@repl;
             @@repl = %editC( @@Arcd : 'X')
                    + %editC( @@Spol : 'X');
             @@long = %len ( %trim ( @@repl ) );

             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0016'
                           : @@msgs : @@repl : @@long );
             exsr setError;

           endif;
         endif;
       endif;

       // Validar si poliza tiene movimientos pendientes - PAR317V...

       @@erro = *off;
       clear @@mens;
       PAR317V( @@Base.peEmpr
              : @@Base.peSucu
              : @@Arcd
              : @@Spol
              : @@Rama
              : @@Poli
              : @@Erro
              : @@Mens );

       if not @@erro;
         if %subst(%trim(@@mens):1 :4) <> '0005';
           clear @@repl;
           Select;
             when %subst(%trim(@@mens) :1 :4) = '0001';
                  %subst(@@repl:1:7) = %editc( @@Poli :'X');
                  %subst(@@repl:8:17) = 'GAUS';
                  @@msgID = 'POL0018';

             when %subst(%trim(@@mens):1 :4) = '0002';
                  %subst(@@repl:1:7) = %editc( @@Poli :'X');
                  %subst(@@repl:8:17) = 'SPEEDWAY';
                  @@msgID = 'POL0018';

             when %subst(%trim(@@mens):1 :4) = '0003';
                  %subst(@@repl:1:7) = %editc( @@Poli :'X');
                  @@msgID = 'POL0019';

             when %subst(%trim(@@mens):1 :4) = '0004';
                  %subst(@@repl:1:7) = %editc( @@Poli :'X');
                  @@msgID = 'POL0020';

             when %subst(%trim(@@mens):1 :4) = '0005';
                  @@nrpp = SPVSPO_getCodPlanDePago( @@Base.peEmpr
                                                  : @@Base.peSucu
                                                  : @@Arcd
                                                  : @@Spol        );

                  %subst(@@repl:1:3) = %editc( @@nrpp :'X');
                  @@msg  = SVPDES_planDePago( @@nrpp );
                  %subst(@@repl:4:33) = @@msg;
                  //%subst(%trim(SVPDES_planDePago( @@nrpp )):1 : 30);
                  %subst(@@repl:34:7) = %editc( @@Poli :'X');
                  @@msgID = 'POL0021';

             when %subst(%trim(@@mens):1 :4) = '0006';
                  %subst(@@repl:1:7) = %editc( @@Poli :'X');
                  @@msgID = 'POL0022';

             when %subst(%trim(@@mens):1 :4) = '0007';
                  %subst(@@repl:1:7) = %editc( @@Poli :'X');
                  @@msgID = 'POL0023';

             when %subst(%trim(@@mens):1 :4) = '0008';
                  %subst(@@repl:1:7) = %editc( @@Poli :'X');
                  @@msgID = 'POL0024';

           other;
             @@msgID = 'POL0017';
           endsl;
           @@long = %len ( %trim ( @@repl ) );
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': @@msgID
                         : @@msgs : @@repl : @@long );
           exsr setError;
         endif;
       endif;

       // Validar si la póliza tiene movimientos pendientes en CTW0003...

       if COWGRAI_getPendientes( @@Base
                               : @@Arcd
                               : @@Spol );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0180'
                       : @@msgs : @@repl : @@long );
         exsr setError;

       endif;

       // Valida si está pendiente de anulación...

       if SPVSPO_chkBloqueo( @@Base.peEmpr
                           : @@Base.peSucu
                           : @@Arcd
                           : @@Spol        );

          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0008'
                        : @@msgs : @@repl : @@long );
          exsr setError;

       endif;

       // Valida si la póliza esta en condiciones para realizar cambios...

       if not SPVFDP_chkPoliCbioV3( @@Base.peEmpr
                                  : @@Base.peSucu
                                  : @@Arcd
                                  : @@Spol
                                  : *omit         );

         ErrText = SPVSPO_Error(ErrCode);

         select;
           when ( ErrCode = SPVSPO_CPENT );
             @@repl = %editC ( @@Rama : '4' : *ASTFILL )  +
                      %editC ( @@Poli : '4' : *ASTFILL )  +
                      %editC ( @@sspo : '4' : *ASTFILL );
             @@long = %len ( %trim ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0003'
                           : @@Msgs : @@repl : @@long );

           when ( ErrCode = SPVSPO_CPPRE );
             @@repl = %editC ( @@Rama : '4' : *ASTFILL )  +
                      %editC ( @@Poli : '4' : *ASTFILL )  +
                      %editC ( @@sspo : '4' : *ASTFILL );
             @@long = %len ( %trim ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0004'
                           : @@Msgs : @@repl : @@long );

           when ( ErrCode = SPVSPO_SPPSP );
             @@repl = %editC ( @@Rama : '4' : *ASTFILL )  +
                      %editC ( @@Poli : '4' : *ASTFILL )  +
                      %editC ( @@Sspo : '4' : *ASTFILL );
             @@long = %len ( %trim ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0005'
                           : @@Msgs : @@repl : @@long );

           other;
             @@repl = %editC ( @@Rama : '4' : *ASTFILL )  +
                      %editC ( @@Poli : '4' : *ASTFILL );
             @@long = %len ( %trim ( @@repl ) );
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0006'
                           : @@Msgs : @@repl : @@long );
         endsl;
         exsr setError;
       endif;

       // Valida si la póliza tiene saldo...

       @@DMA = *all'9';

       SP0079  ( @@Arcd
               : @@Spol
               : @@DMA
               : peCant
               : peSald
               : peCcuo
               : pePrem
               : peEndp );

       if peSald = *zeros;

         @@repl = %editC ( @@Rama : '4' : *ASTFILL )  +
                  %editC ( @@Poli : '4' : *ASTFILL )  +
                  %editC ( @@Sspo : '4' : *ASTFILL );
         @@long = %len ( %trim ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0012'
                       : @@Msgs : @@repl : @@long );
         exsr setError;

       endif;

       // Valida si es un artículo Mensual...

       if SVPART_isMensual( @@Arcd : @@Rama );

         if @@Cfpg = 4;
           clear @@repl;
           @@repl = %editC( @@Arcd : 'X')
                  + %editC( @@Rama : 'X')
                  + %editC( @@Cfpg : 'X');
           @@long = %len ( %trim ( @@repl ) );

           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0009'
                         : @@msgs : @@repl : @@long );
           exsr setError;
         endif;
       endif;

       //Obtener Plan de Pago...

       @1Cfpg = @@Cfpg;
       if @@Cfpg = 3;
         @1Cfpg = 2;
       endif;

       if Tipo = 'W';
         @@Nrpp = SPVFDP_getPlanDePagoWeb( @@Arcd
                                         : @1Cfpg );
       else;
         @@Nrpp = SPVFDP_getPlanDePago( @@Arcd
                                      : @1Cfpg );
       endif;

       if @@Nrpp = *Zeros;
         clear @@repl;
         @@repl = %editC( @@Arcd : 'X')
                + %editC( @@Cfpg : 'X');
         @@long = %len ( %trim ( @@repl ) );

         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0010'
                       : @@msgs : @@repl : @@long );
         exsr setError;
       endif;

       // Validar datos de adicionales de la forma de pago...

       select;
         when @@Cfpg = 1;
           if %check('0123456789':%trim(info)) <> *zeros;
             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'TCR0006'
                           : @@msgs : @@repl : @@long );
             exsr setError;
           else;
             if SPVFDP_setDsTcr( info : @@DsTc );
               rc2 = SPVTCR_chkTarjCredito( @@DsTc.tcCtcu
                                          : @@DsTc.tcNrtc );
               if rc2 = 0;
                 if %check('0123456789':%trim(tcven)) <> *zeros;
                   SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0187'
                                 : @@msgs : @@repl : @@long );
                   exsr setError;
                 else;
                   monitor;
                     clear @@m;
                     clear @@a;
                     @@m = %int(%subst(%trim(tcven):1:2));
                     @@a = %int(%subst(tcven:3:2)) + 2000;
                     @@Tcvt = ( @@a * 100) + @@m;
                   on-error;
                     @@Tcvt = 0;
                   endmon;

                   k1tvtc.tcfini = %dec(%date():*iso);
                   setll %kds(k1tvtc:1) cntvtc;
                   read cntvtc;
                   if %eof;
                      tcmar1 = 'S';
                   endif;

                   if @@Tcvt <= *zeros;
                      SVPWS_getMsgs( '*LIBL'
                                   : 'WSVMSG'
                                   : 'COW0187'
                                   : @@msgs      );
                      exsr setError;
                   endif;

                   //@@tcv6 = %int(%subst( %editc( @@tcvt : 'X' ) :3 :4 ) +
                   //              %subst( %editc( @@tcvt : 'X' ) :1 :2 ));
                   @@tcv6 = %int(%subst( %editc( @@tcvt : 'X' ) :5 :2 ) +
                                 %subst( %editc( @@tcvt : 'X' ) :1 :4 ));

                   if @@Tcvt < @@fem6;
                      SVPWS_getMsgs( '*LIBL'
                                   : 'WSVMSG'
                                   : 'COW0078'
                                   : @@msgs      );
                      exsr setError;
                   endif;
                 endif;
               else;

                 select;
                   when Rc2 = -1;
                     @@MsgId = 'TCR0001';
                   when Rc2 = -2;
                     @@MsgId = 'TCR0003';
                   when Rc2 = -3;
                     @@MsgId = 'TCR0004';
                   when Rc2 = -4;
                     @@MsgId = 'TCR0005';
                 endsl;

                 clear @@repl;
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': @@MsgID
                               : @@Msgs : @@repl : @@long );
                 exsr setError;
               endif;
             else;
               SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0002'
                             : @@Msgs : @@repl : @@long );
               exsr setError;
             endif;
           endif;

         when @@Cfpg = 2 or @@Cfpg = 3;
           if %check('0123456789':%trim(info)) <> *zeros;
               SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0079' : @@Msgs );
               exsr setError;
           else;
             monitor;
               if not SPVFDP_setDsDeb ( Info : @@DsDe );
                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0002' : @@Msgs );
                 exsr setError;
               endif;

               if not SPVCBU_GetCBUSeparado( @@DsDe.deNcbu
                                           : @@Ivbc
                                           : @@Ivsu
                                           : @@Tcta
                                           : @@Ncta        );

                 ErrText = SPVCBU_Error(ErrCode);

                 select;

                   when ( ErrCode = SPVCBU_BCONF );
                     @@repl = %char ( @@ivbc );
                     @@long = %len ( %trim ( @@repl ) );
                     SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0001'
                                   : @@Msgs : @@repl : @@long );
                     exsr setError;

                   when ( ErrCode = SPVCBU_BSUNF );
                     @@repl = %editC ( @@ivbc : '4' : *ASTFILL )  +
                              %editC ( @@ivsu : '4' : *ASTFILL );
                     @@long = %len ( %trim ( @@repl ) );
                     SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0002'
                                   : @@Msgs : @@repl : @@long );
                     exsr setError;

                   when ( ErrCode = SPVCBU_CTINV or errCode = SPVCBU_TCTBL );
                     @@repl = %char ( @@tcta );
                     @@long = %len ( %trim ( @@repl ) );
                     SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0003'
                                   : @@Msgs : @@repl : @@long );
                     exsr setError;

                   when ( ErrCode = SPVCBU_NCINV );
                     @@repl = %trim ( @@ncta );
                     @@long = %len ( %trim ( @@repl ) );
                     SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0004'
                                   : @@Msgs : @@repl : @@long );
                     exsr setError;

                   other;
                     @@repl = %trim ( @@DsDe.deNcbu );
                     @@long = %len ( %trim ( @@repl ) );
                     SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'DEB0005'
                                   : @@Msgs : @@repl : @@long );

                     exsr setError;
                 endsl;
               endif;
             on-error;
               SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0079'
                             : @@Msgs : @@repl : @@long );
               exsr setError;
             endmon;
           endif;

         other;
            @@DsEf.coCobr = @@base.peNivc;
            @@dsEf.coZona = 9999999;
       endsl;

       // Valida si al menos hay un cambio en los datos de forma de pago...

       if SVPVLS_getValSys( 'HVALCAMCFP' : *omit : @@Vsys );
         if @@Vsys = 'S';
           if @@Cfpg = @@DsC0.c0Cfpg;
             select;
               when @@Cfpg = 1 and @@DsTc.tcCtcu = @@Ctc1 and
                    @@DsTc.tcNrtc = @@Nrt1 and @@tcv6 = @@Fvt1;

                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0011' : @@Msgs );
                 exsr setError;

               when ( @@Cfpg = 2 or @@Cfpg = 3 ) and @@DsDe.deNcbu = @@Ncb1;

                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0011' : @@Msgs );
                 exsr setError;

               when @@Cfpg = 4 or @@Cfpg = 5;

                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0011' : @@Msgs );
                 exsr setError;

             endsl;
           endif;
         endif;
       endif;

       if Tipo = 'W';

         // Productor habilitado...

         if not SVPWS_chkParmBase ( @@base : @@msgs );
           exsr setError;
         endif;

         if not SVPVAL_formaDePagoWeb( @@Cfpg );

           clear @@repl;
           @@repl = %editC( @@Cfpg : 'X');
           @@long = %len ( %trim ( @@repl ) );

           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0026'
                         : @@msgs : @@repl : @@long );
           exsr setError;

         endif;

         if from = 'W';
           if not SVPWS_chkParmBase ( @@Base : @@Msgs );
             exsr setError;
           endif;
         endif;

         if from = 'A';

           clear @@Nrdf;
           if not SVPASE_isAseguradoHdi( @@Tdoc
                                       : @@Ndoc
                                       : @@Nrdf
                                       : *omit
                                       : *omit  );
             //falta mensaje
           else;
             // Valida que el asegurado pueda ser asociado al productor
             clear @@Cade;
             SVPINT_GetCadena( @@Base.peEmpr
                             : @@Base.peSucu
                             : @@Base.peNivt
                             : @@Base.peNivc
                             : @@Cade        );

             if @@Tdoc = 98;
               // Validacion por CUIT
               @@Cuit = %editc( @@Ndoc : 'X' );
               if not SVPVAL_chkProductorAsegurado( 9
                                                  : @@Cade(9)
                                                  : *omit
                                                  : *omit
                                                  : @@Cuit    );

                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ASE0001'
                               : @@msgs : @@repl : @@long );
                 exsr setError;
               endif;
             else;
               @1Ndoc = @@Ndoc;
               // Validacion por Tipo y Numero de Documento
               if not SVPVAL_chkProductorAsegurado( 9
                                                  : @@Cade(9)
                                                  : @@Tdoc
                                                  : @1Ndoc
                                                  : *omit     );

                 SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ASE0001'
                               : @@msgs : @@repl : @@long );
                 exsr setError;
               endif;
             endif;
           endif;

           if @@DsC0.c0Asen <> @@Nrdf;
             //Agregar mensaje;
           endif;

         endif;
       endif;

       endsr;

       //* ---------------------------------------------------------- *
       begsr procesar;

       select;

         when ( @@Cfpg = 1 );

           @@desd = *Month * 10000 + *Year;
           if @@Tcv6 = @@desd;
              if *month = 1;
                 @@desd = (12 * 10000) + ( *year - 1);
              else;
                 @@desd = ( (*month-1) * 10000) + *year;
              endif;
           endif;

           SPVTCR_setTcr ( @@DsC0.c0Asen : @@DsTc.tcCtcu : @@DsTc.tcNrtc
                                : @@desd : @@Tcv6 : PsDs.JobCurU );

           if SPVTCR_getDesbloqueadas( @@DsC0.c0Asen
                                     : @@DsGc
                                     : @@DsGcC );
             for z = 1 to @@DsGcC;

                if @@DsGc(z).dfCtcu <> @@DsTc.tcCtcu and
                   @@DsGc(z).dfNrtc <> @@DsTc.tcNrtc;
                   SPVTCR_setBloqTc( @@DsC0.c0Asen
                                   : @@DsGc(z).dfCtcu
                                   : @@DsGc(z).dfNrtc
                                   : PsDs.JobCurU      );
                endif;
             endfor;
           endif;

           SPVTCR_setDesbloqueo( @@DsC0.c0Asen
                               : @@DsTc.tcCtcu
                               : @@DsTc.tcNrtc
                               : PsDs.JobCurU  );

           SPVTCR_updFechaVencimiento( @@DsC0.c0Asen
                                     : @@DsTc.tcCtcu
                                     : @@DsTc.tcNrtc
                                     : @@a
                                     : @@m
                                     : PsDs.JobCurU  );

           if not SPVFDP_setCbioTarjCredV2 ( @@Base.peEmpr : @@Base.peSucu :
                                             @@Arcd : @@Spol : @@DsTc.tcCtcu :
                                             @@DsTc.tcNrtc : PsDs.JobCurU );

             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0007'
                           : @@msgs : @@repl : @@long );
             exsr setError;
           endif;

         when ( ( @@Cfpg = 2 ) or ( @@Cfpg = 3 ) );



       if not SPVCBU_SetCBUEntero ( @@DsDe.deNcbu : @@DsC0.c0Asen
                               : PsDs.JobCurU );

                 ErrText = SPVCBU_Error(ErrCode);

                 IF  ( ErrCode = SPVCBU_CBUHDI );
                     SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COW0079'
                                   : @@Msgs);
                     exsr setError;
                 endif;

       endif;

           SPVCBU_setBloqueo( @@DsC0.c0Asen
                            : @@Ivbc
                            : @@Ivsu
                            : @@Tcta
                            : @@Ncta
                            : PsDs.JobCurU );

           if not SPVFDP_setCbioDebitBcoV2 ( @@Base.peEmpr : @@Base.peSucu :
                                             @@Arcd : @@Spol : @@DsDe.deNcbu :
                                             PsDs.JobCurU );

             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0007'
                           : @@msgs : @@repl : @@long );
             exsr setError;
           endif;
         other;

           if not SPVFDP_setCbioCobradorV2 ( @@Base.peEmpr : @@Base.peSucu :
                                             @@Arcd : @@Spol : @@DsEf.coCobr :
                                             @@dsEf.coZona : PsDs.JobCurU );

             SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0007'
                           : @@msgs : @@repl : @@long );
             exsr setError;
           endif;

       endsl;

       // Graba nuevo plan de pagos...

       clear @@DsC3;
       if SPVSPO_getPlanDePagoV2( @@base.peEmpr
                                : @@base.peSucu
                                : @@arcd
                                : @@spol
                                : @@sspo
                                : @@DsC3        );

         @@DsC3.c3Nrpp = @@Nrpp;

         SPVSPO_updPlanDePago( @@DsC3 );

       endif;

       // Retorna datos de los endoso de la poliza...

       if SVPEND_getPaheas( @@Base
                          : @@Arcd
                          : @@Spol
                          : @@Rama
                          : *omit
                          : *omit
                          : *omit
                          : DsAs
                          : DsAsC  );

         for x = 1 to DsAsC;

           // Si todo esta OK, actualiza los archivos PAHEAS y PAHEA1 de
           // endoso...

           if SVPEND_permitirEndoso( @@Base
                                   : @@Arcd
                                   : @@Spol
                                   : @@Rama
                                   : DsAs(x).asArse
                                   : DsAs(x).asOper
                                   : DsAs(x).asPoco
                                   : '0'              );

             clear @@DsA1;

             @@DsA1.a1Empr = @@Base.peEmpr;
             @@DsA1.a1Sucu = @@Base.peSucu;
             @@DsA1.a1Arcd = @@Arcd;
             @@DsA1.a1Spol = @@Spol;
             @@DsA1.a1Rama = @@Rama;
             @@DsA1.a1Arse = DsAs(x).asArse;
             @@DsA1.a1Oper = DsAs(x).asOper;
             @@DsA1.a1Sspo = DsAs(x).asSspo;
             @@DsA1.a1Poco = DsAs(x).asPoco;
             @@DsA1.a1Nivt = @@Nivt;
             @@DsA1.a1Nivc = @@Nivc;
             @@DsA1.a1Mens = 'Aviso: Cambio de Forma de Pago';
             @@DsA1.a1User = PsDs.JobCurU;
             @@DsA1.a1Date = @@femi;
             @@DsA1.a1Time = %dec(%time);

             SVPEND_setPahea1( @@DsA1 );

             @@Obse = @@DsA1.a1Mens;
           endif;
         endfor;
       endif;

       @@Proc = '0';
       exsr GrabPahcf1;

       exsr graPol;

       if from <> 'A';
         REST_writeHeader();
         REST_writeEncoding();

         REST_startArray('resultado');
           REST_writeXmlLine('ok' : '1');
         REST_endArray('resultado');
       endif;

       clear peMsgs;
       Data = '<br><br><b>WSRCF1-Cambio de forma de pago '
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

       endsr;

       //* ---------------------------------------------------------- *
       begsr GrabPahcf1;

         k1ycf1.cfEmpr = @@Base.peEmpr;
         k1ycf1.cfSucu = @@Base.peSucu;
         k1ycf1.cfArcd = @@Arcd;
         k1ycf1.cfSpol = @@Spol;
         k1ycf1.cfRama = @@Rama;
         k1ycf1.cfPoli = @@Poli;
         chain %kds( k1ycf1 : 6 ) pahcf1;
         if %found( pahcf1 );
           delete p1hcf1;
         endif;

           cfEmpr = @@Base.peEmpr;
           cfSucu = @@Base.peSucu;
           cfArcd = @@Arcd;
           cfSpol = @@Spol;
           cfRama = @@Rama;
           cfPoli = @@Poli;
           cfNivt = @@Base.peNivt;
           cfNivc = @@Base.peNivc;
           cfNrdf = @@DsC0.c0Asen;
           cfCfpg = @@Cfpg;

           select;
             when @@Cfpg = 1;
               clear cfNcbu;

               cfCtcu = @@DsTc.tcCtcu;
               cfNrtc = @@DsTc.tcNrtc;
               cfFvtc = @@Tcv6;

             when @@Cfpg = 2 or @@Cfpg = 3;
               clear cfCtcu;
               clear cfNrtc;
               clear cfFvtc;

               cfNcbu = @@DsDe.deNcbu;

             other;
               clear cfNcbu;
               clear cfCtcu;
               clear cfNrtc;
               clear cfFvtc;

           endsl;

           cfCfp1 = @@Cfp1;
           cfNcb1 = @@Ncb1;
           cfCtc1 = @@Ctc1;
           cfNrt1 = @@Nrt1;
           cfFvt1 = @@Fvt1;
           cfProc = @@Proc;
           cfObse = @@Obse;
           cfMar1 = '0';
           cfMar2 = '0';
           cfMar3 = '0';
           cfMar4 = '0';
           cfMar5 = '0';
           cfUser = PsDs.JobCurU;
           cfDate = @@femi;
           cfTime = %dec(%time);
           cfFrom = from;

           write p1hcf1;

       endsr;

     * ------------------------------------------------------------------- *
       begsr grapol;

         GSWEB310X( @@Base.peEmpr
                  : @@Base.peSucu
                  : @@Arcd
                  : @@Spol        );

         in dtapdf;
         unlock dtapdf;
         if dtapdf.enviar = 'S';
            if @@Arcd <> 89;
               GSWEB520( @@Base.peEmpr
                       : @@Base.peSucu
                       : @@Arcd
                       : @@Spol
                       : @@Sspo        );
            endif;
         endif;

         GSWEB315X( @@Base.peEmpr
                  : @@Base.peSucu
                  : @@Arcd
                  : @@Spol
                  : @@Sspo          );

       endsr;

       //* ---------------------------------------------------------- *
       begsr setError;

         if from = 'A';
           exsr GuardaSolicitud;
           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0007'
                         : peMsgs : @@repl : @@long );

           peMsgs.peMsid = @@msgs.peMsid;
           peMsgs.peMsev = @@msgs.peMsev;
           peMsgs.peMsg2 = @@msgs.peMsg1;

         else;

           SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'CFP0007'
                         : peMsgs : @@repl : @@long );

           peMsgs.peMsid = @@msgs.peMsid;
           peMsgs.peMsev = @@msgs.peMsev;
           peMsgs.peMsg2 = @@msgs.peMsg1;

           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
         endif;

          Data = '<br><br><b>WSRCF1-Cambio de forma de pago '
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

       //* ---------------------------------------------------------- *
       begsr GuardaSolicitud;

         // Obtengo número de solicitud...
         clear Dsd0;
         clear DsD0C;
         clear @@Nres;
         clear @@Arse;
         clear @@Oper;
         SPT902(@@Tnum:@@Nres);

         if SVPPOL_getPoliza( Empr : Sucu : @@Rama : @@Poli : *omit : *omit
                            : *omit : *omit : *omit : *omit : DsD0  : DsD0C );

           @@Arse = DsD0(DsD0C).d0Arse;
           @@Oper = DsD0(DsD0C).d0Oper;
         endif;

         clear p1hag1;

         g1empr = Empr;
         g1sucu = Sucu;
         g1nres = @@Nres;
         g1arcd = @@Arcd;
         g1spol = @@Spol;
         g1rama = @@Rama;
         g1arse = @@Arse;
         g1oper = @@Oper;
         g1poli = @@Poli;
         g1cfpg = @@Cfpg;
         g1nrpp = @@Nrpp;

         if @@Cfpg = 1;
           g1ctcu = %dec( %subst( Info : 1 : 3 ) : 3 : 0 );
           g1nrtc = %dec( %subst( Info : 4 : 20 ) : 20 : 0 );

           if @@Tcvt = *zeros;
             monitor;
               clear @@m;
               clear @@a;
               @@m = %int(%subst(%trim(tcven):1:2));
               @@a = %int(%subst(tcven:3:2)) + 2000;
               g1fvto = ( @@a * 100) + @@m;
             on-error;
               g1fvto = 0;
             endmon;
           else;
             g1fvto = @@Tcvt;
           endif;
           g1ncbu = *zeros;
         endif;

         if @@Cfpg = 2 or @@Cfpg = 3;
           g1ncbu = %dec( %subst( Info : 1 : 22 ) : 22 : 0 );
           g1ctcu = *zeros;
           g1nrtc = *zeros;
           g1fvto = *zeros;
         endif;

         g1mar1 = '0';
         g1mar2 = '0';
         g1mar3 = '0';
         g1mar4 = '0';
         g1mar5 = '0';
         g1mar6 = '0';
         g1mar7 = '0';
         g1mar8 = '0';
         g1mar9 = '0';
         g1mar0 = '0';
         g1date = %dec(%date():*iso);
         g1time = %dec(%time():*iso);
         g1user = PsDs.JobCurU;

         write p1hag1;

       endsr;

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/getsysv_h.rpgle'
