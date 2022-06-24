     h option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     h bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRIPW: QUOM Versión 2                                       *
      *         Informa cuota pagada por transferencia.              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *17-Feb-2020            *
      * Sergio Luis Puentes Valladares       *18-Feb-2020            *
      * ------------------------------------------------------------ *
     * Archivo    Descripcion                                 Tp    *
      * --------   -----------------------------------------   --    *
      * pahcc2     Prod.Art. SuperPòliza/Suplemento/Cuota      PF    *
      * pahed004   Prod.Art. Rama/Secuencia                    LF    *
      * pahipw     Aviso de Pagos Web                          PF    *
      *                                                              *
      * ------------------------------------------------------------ *
     * Error      Descripcion                                       *
      * --------   -----------------------------------------         *
      * CUO0001    Cuota Inexistente                                 *
      * CUO0002    Cuota no esta impaga                              *
      * CUO0003    Fecha Incorrecta                                  *
      * CUO0004    Importe de Cuota incorrecto                       *
      * POL0001    Operacion Inexistente                             *
      * CUO0006    Formato de datos web incorrecto                   *
      *                                                              *
      * ------------------------------------------------------------ *
     *  Fecha     User    Modificacion                              *
      * --------  -------- ----------------------------------------- *
      * 11/05/2020 SPV     Recompilado por cambio en PAHIPW          *
      * 13/05/2020 SGF     Control sobre nombre de archivo.          *
      * 01/06/2020 SGF     Archivo ya no es obligatorio.             *
      * 22/06/2020 NWN     Se envia a la DTAQ solamente en la alta   *
      *                    al PAWIPW.                                *
      *                                                              *
      *                                                              *
      * ************************************************************ *
     Fpahcc2    if   e           k disk
     Fpahed004  if   e           k disk
     Fpahipw    uf a e           k disk

      *----------------------------------------------------------------
     * Define copys
      *----------------------------------------------------------------
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/dtaq_h.rpgle'

      *----------------------------------------------------------------
     * Define variables
      *----------------------------------------------------------------
     d empr            s              1a
     d sucu            s              2a
     d nivt            s              1a
     d nivc            s              5a
     d nit1            s              1a
     d niv1            s              5a
     d arcd            s              6a
     d spol            s              9a
     d sspo            s              3a
     d rama            s              2a
     d poli            s              7a
     d suop            s              3a
     d nrcu            s              2a
     d imcu            s             15a
     d ftra            s             10a
     d ivbc            s              3a

     d fecha_hoy       s              8s 0
     d @empr           s              1a
     d @dia            s              2p 0
     d @mes            s              2p 0
     d @ano            s              4p 0
     d @fec1           s              8a
     d @ftra           s              8s 0
     D @@repl          s          65535a
     D @Error          s              1a

     d uri             s            512a
     d url             s           3000a   varying
     d rc              s              1n
     d rc2             s             10i 0

     D Data            ds                  qualified
     D  empr                          1a
     D  sucu                          2a
     D  nivt                          1a
     D  nivc                          5a
     D  arcd                          6a
     D  spol                          9a
     D  sspo                          3a
     D  rama                          2a
     D  arse                          2a
     D  oper                          7a
     D  suop                          3a
     D  poli                          7a
     D  nrcu                          2a
     D  ivbc                          3a
     D  imcu                         15a
     D  ftra                          8a
     D  keyw                         10a

      *----------------------------------------------------------------*
     * Define estructuras
      *----------------------------------------------------------------*
     d peMsgs          ds                  likeds(paramMsgs)
     d peBase          ds                  likeds(paramBase)
     d peEmpr          s              1a
     d peSucu          s              2a
     d peNivt          s              1s 0
     d peNivc          s              5s 0
     d peNit1          s              1s 0
     d peNiv1          s              5s 0
     d peArcd          s              6s 0
     d peSpol          s              9s 0
     d peSspo          s              3s 0
     d peRama          s              2s 0
     d pePoli          s              7s 0
     d peSuop          s              3s 0
     d peNrcu          s              2s 0
     d peImcu          s             15s 2
     d peFtra          s              8s 0
     d peIvbc          s              3s 0
     d peArse          s              2s 0 inz(1)
     d peOper          s              7s 0
     d arch            s            512a
     d @@arch          s            512a   varying
     d @@imcu          s             15  0

      *----------------------------------------------------------------*
     * Define klist de archivos
      *----------------------------------------------------------------*
     d k1hcc2          ds                  likerec(P1hcc2:*key)
     d k1hipw          ds                  likerec(P1hipw:*key)
     d k1hed0          ds                  likerec(P1hed004:*key)

     *------------------------------------------------------------------*
     * Define programas invocados
     *------------------------------------------------------------------*
     d FechaHoy        pr                  extpgm('PAR310X3')
     d  empr                               like(@empr)
     d  fema                               like(@ano)
     d  femm                               like(@mes)
     d  femd                               like(@dia)

     d AvisoPago       pr                  extpgm('PAR390Y')
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peNivt                        1  0 const
     d  peNivc                        5  0 const
     d  peArcd                        6  0 const
     d  peSpol                        9  0 const
     d  peSspo                        3  0 const
     d  peRama                        2  0 const
     d  peArse                        2  0 const
     d  peOper                        7  0 const
     d  peSuop                        3  0 const
     d  pePoli                        7  0 const
     d  peNrcu                        2  0 const
     d  peImcu                       15  2 const
     d  peIvbc                        3  0 const
     d  peArch                      512a   const

      *---------------------------------------------------------------*
     * Define Estructura de Programa
      *---------------------------------------------------------------*
     d psds           sds                  qualified
     d  this                         10a   overlay(psds:1)
     d  usr                          10a   overlay(psds:358)

      /free
         // *----------------------------------------------------------
         // *     C  u  e  r  p  o       P  r  i  n  c  i  p  a  l
         // *----------------------------------------------------------

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
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);
       sspo = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       suop = REST_getNextPart(url);
       nrcu = REST_getNextPart(url);
       ivbc = REST_getNextPart(url);
       ftra = REST_getNextPart(url);
       imcu = REST_getNextPart(url);

       arch = *blanks;
       if url <> *blanks;
          arch = REST_getNextPart(url);
       endif;
       @@arch = arch;
       if %len(%trim(@@arch)) <= 4 or
          %trim(@@arch) = 'NULL';
          arch = *blanks;
          @@arch = *blanks;
       endif;

       // ------------------------------------------
       // Valida parámetro base
       // ------------------------------------------
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
             close *all;
             return;
       endif;

       // ------------------------------------------
       // Asigna parámetros a variables de programa 1
       // ------------------------------------------
       peEmpr = empr;
       peSucu = sucu;
       monitor;
         peNivt = %dec(nivt:1:0);
         on-error;
           peNivt = 0;
       endmon;
       monitor;
         peNivc = %dec(nivc:5:0);
         on-error;
           peNivc = 0;
       endmon;
       monitor;
         peNit1 = %dec(nit1:1:0);
         on-error;
           peNit1 = 0;
       endmon;
       monitor;
         peNiv1 = %dec(niv1:5:0);
         on-error;
           peNiv1 = 0;
       endmon;
       monitor;
         pearcd = %dec(arcd:6:0);
         on-error;
           pearcd = 0;
       endmon;
       monitor;
         pespol = %dec(spol:9:0);
         on-error;
           pespol = 0;
       endmon;
       monitor;
         pesspo = %dec(sspo:3:0);
         on-error;
           pesspo = 0;
       endmon;

       // ------------------------------------------
       // Valida Existencia de Suplemento
       // ------------------------------------------
       if not SPVSPO_chkSspo ( peEmpr: peSucu: peArcd: peSpol: peSSpo );
             %subst(@@repl:1:3)  = sspo;
             %subst(@@repl:4:6)  = arcd;
             %subst(@@repl:10:9) = spol;
             rc2 = SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'SPO0002'
                                : peMsgs
                                : %trim(@@repl)
                                : %len(%trim(@@repl)) );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'SPO0002'
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
             REST_end();
             close *all;
             return;
       endif;

       // ------------------------------------------
       // Asigna parámetros a variables de programa 2
       // ------------------------------------------
       monitor;
         perama = %dec(rama:2:0);
         on-error;
           perama = 0;
           Exsr ErrDtaWeb;
       endmon;
       monitor;
         pepoli = %dec(poli:7:0);
         on-error;
           pepoli = 0;
           Exsr ErrDtaWeb;
       endmon;
       monitor;
         pesuop = %dec(suop:3:0);
         on-error;
           pesuop = 0;
           Exsr ErrDtaWeb;
       endmon;
       monitor;
         penrcu = %dec(nrcu:2:0);
         on-error;
           penrcu = 0;
           Exsr ErrDtaWeb;
       endmon;
       monitor;
         peivbc = %dec(ivbc:3:0);
         on-error;
           peivbc = 0;
           Exsr ErrDtaWeb;
       endmon;
       monitor;
         peimcu = %dec(imcu:15:2);
         on-error;
           peimcu = 0;
           Exsr ErrDtaWeb;
       endmon;

       if %len(%trim(ftra)) > 0;
          @fec1 = %Subst(ftra:01:04)
                + %Subst(ftra:06:02)
                + %Subst(ftra:09:02);
          peftra = %dec(@fec1:08:0);
       Else;
           Exsr ErrDtaWeb;
       EndIf;


       // ------------------------------------------
       // Valida Existencia de Cuota
       // ------------------------------------------
       Clear @Error;
       Clear k1hcc2;
       Clear p1hcc2;
       k1hcc2.c2Empr = peEmpr;
       k1hcc2.c2Sucu = peSucu;
       k1hcc2.c2Arcd = peArcd;
       k1hcc2.c2Spol = peSpol;
       k1hcc2.c2Sspo = peSspo;
       k1hcc2.c2Nrcu = peNrcu;
       Chain %kds( k1hcc2:6 ) pahcc2;
          If Not %found( pahcc2 );
             @Error = '1';
             SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'CUO0001'
                             : peMsgs     );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : peMsgs.peMsid
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
          EndIf;

          If PeNrcu = *Zeros;
             @Error = '1';
             SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'CUO0001'
                             : peMsgs     );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : peMsgs.peMsid
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
          EndIf;

          If c2sttc = '3';
             @Error = '1';
             SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'CUO0002'
                             : peMsgs     );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : peMsgs.peMsid
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
          EndIf;
          If @Error <> *Blanks;
             REST_end();
             SVPREST_end();
             close *all;
             return;
          EndIf;

       // ------------------------------------------
       // Valida Importe de Cuota
       // ------------------------------------------
       If peImcu = *Zeros;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'CUO0004'
                          : peMsgs     );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : peMsgs.peMsid
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
             REST_end();
             SVPREST_end();
             close *all;
             return;
       EndIf;

       // ------------------------------------------
       // Recupera Fecha de Emision de Hoy
       // ------------------------------------------
       FechaHoy(empr:@ano:@mes:@dia);
       fecha_hoy = (@ano*10000) + (@mes*100) + @dia;
       If peFtra > fecha_hoy;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'CUO0003'
                          : peMsgs     );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : peMsgs.peMsid
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
             REST_end();
             SVPREST_end();
             close *all;
             return;
       EndIf;

       // ------------------------------------------
       // Recupera datos Prod.Art/Rama/Póliza/Supl.
       // ------------------------------------------
       Clear k1hed0;
       Clear P1hed004;
       k1hed0.d0Empr = peEmpr;
       k1hed0.d0Sucu = peSucu;
       k1hed0.d0Rama = peRama;
       k1hed0.d0Poli = pePoli;
       k1hed0.d0Suop = peSuop;
       k1hed0.d0Arcd = peArcd;
       k1hed0.d0Spol = peSpol;
       k1hed0.d0Sspo = peSspo;
       k1hed0.d0Arse = peArse;
       Chain %kds(k1hed0:9) Pahed004;
          If  Not %Found(Pahed004);
              %subst(@@repl:01:2) = %editc(peRama:'X');
              %subst(@@repl:03:7) = %editc(pePoli:'X');
              %subst(@@repl:10:1) = %editc(peNivt:'X');
              %subst(@@repl:11:5) = %editc(peNivc:'X');

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
             SVPREST_end();
             close *all;
             return;
          EndIf;
          peOper = d0Oper;

       // ------------------------------------------
       // Veo si tiene cuotas comprometidas
       // ------------------------------------------

       k1hcc2.c2Empr = peEmpr;
       k1hcc2.c2Sucu = peSucu;
       k1hcc2.c2Arcd = peArcd;
       k1hcc2.c2Spol = peSpol;
       setll %kds( k1hcc2:4 ) pahcc2;
       reade %kds( k1hcc2:4 ) pahcc2;
       dow Not %eof( pahcc2 );
          if c2sttc = '2';
             @Error = '1';
             SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'CUO0007'
                             : peMsgs     );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : peMsgs.peMsid
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
          EndIf;
       reade %kds( k1hcc2:4 ) pahcc2;
       Enddo;

       // ------------------------------------------
       // Genera aviso de pagos web
       // ------------------------------------------
       Clear P1hipw;
       Clear k1hipw;
       k1hipw.pwEmpr = peEmpr;
       k1hipw.pwSucu = peSucu;
       k1hipw.pwNivt = peNivt;
       k1hipw.pwNivc = peNivc;
       k1hipw.pwArcd = peArcd;
       k1hipw.pwSpol = peSpol;
       k1hipw.pwSspo = peSspo;
       k1hipw.pwRama = peRama;
       k1hipw.pwArse = peArse;
       k1hipw.pwOper = peOper;
       k1hipw.pwSuop = peSuop;
       k1hipw.pwPoli = pePoli;
       k1hipw.pwNrcu = peNrcu;
       Chain %kds(k1hipw) Pahipw;
          If  Not %Found(Pahipw);
              pwEmpr = peEmpr;
              pwSucu = peSucu;
              pwNivt = peNivt;
              pwNivc = peNivc;
              pwArcd = peArcd;
              pwSpol = peSpol;
              pwSspo = peSspo;
              pwRama = peRama;
              pwArse = peArse;
              pwOper = peOper;
              pwPoli = pePoli;
              pwSuop = peSuop;
              pwNrcu = peNrcu;
              pwIvbc = peIvbc;
              pwMone = '00';
              pwCimp = peImcu;
              pwMar1 = '0';
              pwFtrn = peFtra;
              pwarch = arch;
              pwmenv = ' ';
              pwdat1 = %dec(%date():*iso);
              pwtim1 = %dec(%time():*iso);
              pwusr1 = PsDs.Usr;
              Write P1hipw;
              exsr snddtaq;
          EndIf;

       REST_writeHeader();
       REST_writeEncoding();
       REST_startArray( 'resultado' );
       REST_writeXmlLine( 'ok' : '1' );
       REST_endArray  ( 'resultado' );

       REST_end();

       return;

       // *----------------------------------------------------------
       // ** ErrDtaWeb - Rutina manejo de Error de datos web
       // *----------------------------------------------------------
       BegSr ErrDtaWeb;
             // *--------------------------------------
             // ** Manejo de error datos web
             // *--------------------------------------
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'CUO0006'
                          : peMsgs     );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : peMsgs.peMsid
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
             REST_end();
             SVPREST_end();
             close *all;
             return;

       EndSr;

       BegSr snddtaq;
       // --------------------------------------
       // Pongo mensaje en la cola de datos para
       // imputacion automatica
       // --------------------------------------
       @@imcu = peImcu * 100;
       clear data;
       Data.empr = peEmpr;
       Data.sucu = peSucu;
       Data.nivt = %editc(peNivt:'X');
       Data.nivc = %editc(peNivc:'X');
       Data.arcd = %editc(peArcd:'X');
       Data.spol = %editc(peSpol:'X');
       Data.sspo = %editc(peSspo:'X');
       Data.rama = %editc(peRama:'X');
       Data.arse = %editc(peArse:'X');
       Data.oper = %editc(peOper:'X');
       Data.suop = %editc(peSuop:'X');
       Data.poli = %editc(pePoli:'X');
       Data.ivbc = %editc(peIvbc:'X');
       Data.nrcu = %editc(peNrcu:'X');
       Data.imcu = %editc(@@imcu:'X');
       Data.ftra = %editc(%dec(peFtra:8:0):'X');
       Data.keyw = 'IMPUTAR   ';
       QSNDDTAQ( 'QUOMCUO02'
               : '*LIBL'
               : %len(%trim(data))
               : Data                    );


       EndSr;

      /end-free
