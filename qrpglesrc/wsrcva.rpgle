     H option(*srcstmt:*noshowcpy:*nodebugio: *nounref)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRCVA: Mobile.                                              *
      *         AUTOS - Lista de Certificados Varios.                *
      * ------------------------------------------------------------ *
      * Luis R. Gómez                        *22-Ene-2018            *
      * ------------------------------------------------------------ *
      * Modificiones:                                                *
      * SGF 20/09/2048: Monitor en tido y nrdo.                      *
      * LRG 12/04/2019: Enviar polizas vigentes y renovadas          *
      *                 anticipadas                                  *
      *                                                              *
      * ************************************************************ *
     Fpahec0    if   e           k disk
     Fgnhdaf05  if   e           k disk
     Fgnhdaf06  if   e           k disk
     Fpahec002  if   e           k disk
     Fpahed0    if   e           k disk
     Fpahet9    if   e           k disk
     Fsehase    if   e           k disk
     Fset001    if   e           k disk

      * Parametros de entrada ---------------------------------- *
     D tido            s              2a
     D nrdo            s             11a
     D ncel            s             20a
     D mail            s             50a
     D fnac            s             10a

      * Claves -------------------------------------------------- *
     D k1hdaf          ds                  likerec(g1hdaf05:*key)
     D k1hec0          ds                  likerec(p1hec002:*key)
     D k1hed0          ds                  likerec(p1hed0  :*key)
     D k1het9          ds                  likerec(p1het9  :*key)

      * Variables ----------------------------------------------- *
     D uri             s            512a
     D url             s           3000a   varying
     D wrepl           s          65535a
     D x               s             10i 0
     D @@valsys        s            512
     D @@empr          s              1
     D @@sucu          s              2
     D @@rama          s              2  0
     D @@DsMob         ds                  likeds( DsPahmob_t )
     D @@fnac          s              8a
     D @1fnac          s              8  0
     D @@tusr          s             10
     D tmpfec          s             10d
     D @@MS            s            512
     D hoy             s              8  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D peTido          s              2  0
     D peNrdo          s             11  0
     D peCuit          s             11a
     D peSspo          s              3  0
     D peSuop          s              3  0
     D peStat          s              1n
     D pvStat          s              1n
     D salir           s              1n
     D var             s            512a
     D @@nivt          s              1  0
     D @@nivc          s              5  0
     D @@DsTl          ds                  likeds ( DsTelPublic_t ) dim( 100 )
     D @@DsTlC         s             10i 0
     D @@mail          ds                  likeds(Mailaddr_t) dim(100)
     D @@mailC         s             10i 0
     D @@Raan          s              2  0
     D @@Poan          s              7  0
     D @@Arca          s              6  0
     D @@Spoa          s              9  0
     D @@Ranu          s              2  0
     D @@Ponu          s              7  0
     D @@Arcn          s              6  0
     D @@Spon          s              9  0

      * Banderas...
     D peVig2          s               n   inz('1')
     D fnac_valida     s               n   inz('1')
     D estado          s               n
     D procesa         s               n   inz('0')
     D rc              s               n
     D primera         s               n   inz('1')

      * Datos Output...
     D EmpAse          s             50
     D Pais            s             50
     D NomAse          s             50
     D Poliza          s             50
     D NumCer          s             50
     D Domici          s             50
     D Fvigen          s             50
     D Marca           s             15
     D Modelo          s             15
     D Submodelo       s             10
     D Anio            s             50
     D Matricula       s             50
     D Chasis          s             50
     D Paises          s             50
     D Ciudad          s             50
     D Fecha           s             50
     D Tipo            s             50
     D Fdesd           s             50
     D Fhast           s             50
     D Asiste          s             50
     D Interm          s             50
     D DesTel          s             50
     D DesMail         s             50
     D alguna          s              1n
     D renoAnticipada  s              1n
     D head            s              1n
     D @@asen          s              7  0
     D Nombre          s             50

      * Constantes  --------------------------------------------- *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
      * Estructuras --------------------------------------------- *
     D peMsgs          ds                  likeds( paramMsgs )
     D peBase          ds                  likeds( paramBase )
     D meses           s             20a   dim(12) ctdata perrcd(1)

      * Vectores ------------------------------------------------ *
     D @@cade          s              5  0 dim(9)

      * Informacion de Sistema ---------------------------------- *
     D psds           sds                  qualified
     D  this                         10a   overlay( psds : 1 )
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6  0 overlay(PsDs:264)

     D Local           ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(Local:401)
     D  sucu                          2a   overlay(Local:*next)

      * Procedimientos ------------------------------------------ *

     D WSRCV1          pr                  extpgm('WSRCV1')

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D SPVIG2          pr                  extpgm('SPVIG2')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peRama                        2  0
     D  peArse                        2  0
     D  peOper                        7  0
     D  peFech                        8  0
     D  peFemi                        8  0
     D  peStat                        1n
     D  peSspo                        3  0
     D  peSuop                        3  0
     D  peFpgm                        3a   const

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

     D GSWEB035        pr                  ExtPgm('GSWEB035')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peOper                        7  0 const
     D  peRaan                        2  0
     D  pePoan                        7  0
     D  peArca                        6  0
     D  peSpoa                        9  0
     D  peRanu                        2  0
     D  pePonu                        7  0
     D  peArcn                        6  0
     D  peSpon                        9  0

      // Log de llamadas...
     D WSLOG           pr                  extpgm('WSLOG')
     D   MS                         512
     D   MSG           s            512

      // Procedimiento para debug...
     D sleep           pr            10u 0 extproc('sleep')
     D  secs                         10u 0 value

     D fec_ing         s              8  0
     D fec_egr         s              8  0

      * Copy's -------------------------------------------------- *
      /copy './qcpybooks/svpmob_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

      /free

        *inlr = *on;

        alguna = *off;
        head   = *off;
        Local.empr = 'A';
        Local.sucu = 'CA';
        out Local;
        @@empr = %xlate( min : may : Local.empr );
        @@sucu = %xlate( min : may : Local.sucu );

       //Msg = PsDs.JobName;
       //WSLOG( Msg );
       //Msg = PsDs.JobUser;
       //WSLOG( Msg );
       //Msg = %editc(PsDs.JobNbr:'X');
       //WSLOG( Msg  );
       //sleep(60);

        rc  = REST_getUri( psds.this : uri );
        if rc = *off;
           return;
        endif;
        url = %trim( uri );

        // ------------------------------------------
        // Obtener los parámetros de la URL
        // ------------------------------------------
        tido = REST_getNextPart(url);
        nrdo = REST_getNextPart(url);
        ncel = REST_getNextPart(url);
        mail = REST_getNextPart(url);
        fnac = REST_getNextPart(url);

        @@tusr = 'PRINCIPAL';
        @@fnac = %subst(fnac:1:4)
               + %subst(fnac:6:2)
               + %subst(fnac:9:2);
        if @@fnac <> *blanks;
          monitor;
            @1fnac = %dec(@@fnac:8:0);
            tmpfec = %date(@1fnac:*iso);
          on-error;
            fnac_valida = *off;
            @1fnac = 0;
          endmon;
        endif;

        // Datos de Auditoria...
        clear @@DsMob;
        @@DsMob.obempr = @@empr;
        @@DsMob.obsucu = @@sucu;
        @@DsMob.obncel = ncel;
        @@DsMob.obmail = mail;
        @@DsMob.obfnac = @1fnac;
        @@DsMob.obtusr = 'PRINCIPAL';
        @@DsMob.obfech = %char(%timestamp());
        @@DsMob.obresu = '0';

        // Obtener valores de systema ...
        if not SVPVLS_getValSys( 'HAPIEMPR':*omit :@@ValSys );
          wrepl  = 'Empresa';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'API0013'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           // Auditoria...
           @@DsMob.obresu = '1';
           @@DsMob.obobse = '(' + peMsgs.peMsid  + ') ' + peMsgs.peMsg2;
           SVPMOB_setAuditoria( @@DsMob );

           // Respuesta Rest - Cabecera...
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'MOB0001'
                        :  peMsgs );

           rc = REST_writeHeader( 204
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
          @@empr = %trim( @@ValSys );
          @@DsMob.obempr = @@empr;
        endif;

        if not SVPVLS_getValSys( 'HAPISUCU':*omit :@@ValSys );
          wrepl  = 'Sucursal';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'API0013'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           // Auditoria...
           @@DsMob.obresu = '1';
           @@DsMob.obobse = '(' + peMsgs.peMsid + ') ' + peMsgs.peMsg2;
           SVPMOB_setAuditoria( @@DsMob );

           // Respuesta Rest - Cabecera...
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'MOB0001'
                        :  peMsgs );

           rc = REST_writeHeader( 204
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
          @@sucu = %trim( @@ValSys );
          @@DsMob.obsucu = @@sucu;
        endif;

        if not SVPVLS_getValSys( 'HAPIAURAMA':*omit :@@ValSys );
           wrepl = 'Rama';
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0013'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           // Auditoria...
           @@DsMob.obresu = '1';
           @@DsMob.obobse = '(' + peMsgs.peMsid + ') ' + peMsgs.peMsg2;
           SVPMOB_setAuditoria( @@DsMob );

           // Respuesta Rest - Cabecera...
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'MOB0001'
                        :  peMsgs );

           rc = REST_writeHeader( 204
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
           monitor;
             @@rama = %int(%trim( @@ValSys ));
           on-error;
             wrepl = 'Rama';
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'API0013'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             // Auditoria...
             @@DsMob.obresu = '1';
             @@DsMob.obobse = '(' + peMsgs.peMsid + ') ' + peMsgs.peMsg2;
             SVPMOB_setAuditoria( @@DsMob );

             // Respuesta Rest - Cabecera...
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'MOB0001'
                          :  peMsgs );

             rc = REST_writeHeader( 204
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
        endif;

        // Valida Parámetros de entrada...

        // -------------------------------------------
        // Tipo de documento
        // -------------------------------------------
        monitor;
          peTido = %dec(tido:2:0);
         on-error;
             wrepl = %trim(tido);
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'MOB0008'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             // Auditoria...
             @@DsMob.obresu = '1';
             @@DsMob.obobse = '(' + peMsgs.peMsid + ') ' + peMsgs.peMsg2;
             SVPMOB_setAuditoria( @@DsMob );

             // Respuesta Rest - Cabecera...
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'MOB0001'
                          :  peMsgs );

             rc = REST_writeHeader( 204
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

        // -------------------------------------------
        // Número de documento
        // -------------------------------------------
        monitor;
          peNrdo = %dec(nrdo:11:0);
         on-error;
             wrepl = %trim(tido);
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'MOB0009'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             // Auditoria...
             @@DsMob.obresu = '1';
             @@DsMob.obobse = '(' + peMsgs.peMsid + ') ' + peMsgs.peMsg2;
             SVPMOB_setAuditoria( @@DsMob );

             // Respuesta Rest - Cabecera...
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'MOB0001'
                          :  peMsgs );

             rc = REST_writeHeader( 204
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

         // Número de Celular...
         if ncel = *blank or %trim(ncel) = *all'0';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'MOB0002'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl)) );
            // Auditoria...
            @@DsMob.obresu = '1';
            @@DsMob.obobse = '(' + peMsgs.peMsid + ') ' + peMsgs.peMsg1;
            SVPMOB_setAuditoria( @@DsMob );

            // Respuesta Rest - Cabecera...
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'MOB0001'
                         :  peMsgs );

            rc = REST_writeHeader( 204
                                 : *omit
                                 : *omit
                                 : peMsgs.peMsid
                                 : peMsgs.peMsev
                                 : peMsgs.peMsg1
                                 : peMsgs.peMsg2 );

            REST_end();
            close *all;
            return;
         endif;

        // Fecha de nacimiento...
        if not fnac_valida;

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'MOB0005'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          // Auditoria...
          @@DsMob.obresu = '1';
          @@DsMob.obobse = '(' + peMsgs.peMsid + ') ' + peMsgs.peMsg1;
          SVPMOB_setAuditoria( @@DsMob );

          // Respuesta Rest - Cabecera...
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'MOB0001'
                       :  peMsgs );

          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
        endif;

        Local.empr = @@empr;
        Local.sucu = @@sucu;
        out Local;

        PAR310X3( @@empr
                : peFema
                : peFemm
                : peFemd );
        hoy = (peFema * 10000)
            + (peFemm *   100)
            +  peFemd;

        if peTido = 98;
           peCuit = %editc(peNrdo:'X');
           setll peCuit gnhdaf06;
           reade peCuit gnhdaf06;
           dow not %eof;
               exsr $aseg;
            reade peCuit gnhdaf06;
           enddo;
         else;
           monitor;
               k1hdaf.dftido = peTido;
               k1hdaf.dfnrdo = peNrdo;
            on-error;
               k1hdaf.dftido = -1;
               k1hdaf.dfnrdo = -1;
           endmon;
           setll %kds(k1hdaf:2) gnhdaf05;
           reade %kds(k1hdaf:2) gnhdaf05;
           dow not %eof;
               exsr $aseg;
            reade %kds(k1hdaf:2) gnhdaf05;
           enddo;
        endif;

        if not alguna;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'MOB0010'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          // Auditoria...
          @@DsMob.obresu = '1';
          @@DsMob.obobse = '(' + peMsgs.peMsid + ') ' + peMsgs.peMsg1;
          SVPMOB_setAuditoria( @@DsMob );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'MOB0010'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl)) );
          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
        endif;

        REST_writeXmlLine('CertificadosAutos' : '*END' );

        return;

        begsr $aseg;
         chain dfnrdf sehase;
         if %found;
            exsr $oper;
         endif;
        endsr;

        begsr $oper;
         salir = *off;
         k1hec0.c0empr = @@empr;
         k1hec0.c0sucu = @@sucu;
         k1hec0.c0asen = asasen;
         setll %kds(k1hec0:3) pahec002;
         reade %kds(k1hec0:3) pahec002;
         dow not %eof;
            exsr $poli;
          reade %kds(k1hec0:3) pahec002;
         enddo;
        endsr;

        begsr $poli;
         k1hed0.d0empr = c0empr;
         k1hed0.d0sucu = c0sucu;
         k1hed0.d0arcd = c0arcd;
         k1hed0.d0spol = c0spol;
         k1hed0.d0sspo = *zeros;
         setll %kds(k1hed0:5) pahed0;
         reade %kds(k1hed0:5) pahed0;
         dow not %eof;
             chain d0rama set001;
             if not %found;
                t@rame = 0;
             endif;
             if t@rame = 4;
                exsr $vige;
             endif;
             if salir;
                leave;
             endif;
          reade %kds(k1hed0:5) pahed0;
         enddo;
        endsr;

        begsr $vige;
         renoAnticipada = *off;
         SPVIG2( d0arcd
               : d0spol
               : d0rama
               : d0arse
               : d0oper
               : hoy
               : hoy
               : peStat
               : peSspo
               : peSuop
               : *blanks    );

         if peStat;
            exsr $comp;
         else;
           if d0tiou = 2;
              clear @@Raan;
              clear @@Poan;
              clear @@Arca;
              clear @@Spoa;
              clear @@Ranu;
              clear @@Ponu;
              clear @@Arcn;
              clear @@Spon;

              GSWEB035( d0empr
                      : d0sucu
                      : d0arcd
                      : d0spol
                      : d0rama
                      : d0arse
                      : d0oper
                      : @@Raan
                      : @@Poan
                      : @@Arca
                      : @@Spoa
                      : @@Ranu
                      : @@Ponu
                      : @@Arcn
                      : @@Spon );

              if SPVSPO_chkVig( d0empr
                              : d0sucu
                              : @@Arca
                              : @@Spoa );
                renoAnticipada = *on;
                exsr $comp;
              endif;
           endif;
         endif;
        endsr;

        begsr $comp;
         k1het9.t9empr = d0empr;
         k1het9.t9sucu = d0sucu;
         k1het9.t9arcd = d0arcd;
         k1het9.t9spol = d0spol;
         k1het9.t9rama = d0rama;
         k1het9.t9arse = d0arse;
         k1het9.t9oper = d0oper;
         setll %kds(k1het9:7) pahet9;
         reade %kds(k1het9:7) pahet9;
         dow not %eof;
            fec_ing = (t9ainn * 10000)
                    + (t9minn *   100)
                    +  t9dinn;
            fec_egr = (t9aegn * 10000)
                    + (t9megn *   100)
                    +  t9degn;
            if fec_egr <= 0;
               fec_egr = 99999999;
            endif;
            if renoAnticipada;
              pvStat = '1';
            endif;
            if (hoy >= fec_ing and
                hoy <= fec_egr);
                pvStat = '1';
            endif;
            if pvStat;
               salir = *on;
               exsr $cert;
               alguna = *on;
               leave;
            endif;
          reade %kds(k1het9:7) pahet9;
         enddo;
        endsr;

        begsr $cert;
         if not head;
            REST_writeHeader();
            REST_writeEncoding();
            REST_writeXmlLine('CertificadosAutos' : '*BEG' );
            head = *on;
         endif;
         REST_writeXmlLine('Polizas'      : '*BEG' );
         @@asen = SPVSPO_getAsen ( t9empr
                                 : t9sucu
                                 : t9arcd
                                 : t9spol
                                 : t9sspo );

         Nombre = SVPDAF_getNombre( @@asen
                                  : *omit );

         REST_writeXmlLine( 'DatosAsegurado'    : '*BEG' );
           REST_writeXmlLine( 'Nombre'          : %trim(Nombre));
         REST_writeXmlLine( 'DatosAsegurado'    : '*END' );

         Nombre = %scanrpl( '/' : '|'  : Nombre );

         var = 'REQUEST_URI=/QUOMREST/WSRCV1/'
             + %trim(t9moto)
             + '/'
             + %editc(t9poli:'X')
             + '/'
             + %trim(ncel)
             + '/'
             + %trim(mail)
             + '/'
             + %trim(fnac)
             + '/'
             + 'PRINCIPAL'
             + '/'
             + %trim(Nombre)
             + '/'
             + %trim(t9empr)
             + '/'
             + %trim(t9sucu)
             + '/'
             + %editc(t9arcd:'X')
             + '/'
             + %editc(t9spol:'X')
             + '/'
             + %editc(t9rama:'X')
             + '/'
             + %editc(t9arse:'X')
             + '/'
             + %editc(t9oper:'X');
         putenv(%trim(var));
         WSRCV1();
         exsr $inte;
         REST_writeXmlLine('Polizas'      : '*END' );
        endsr;

        begsr $inte;

            Interm = SPVSPO_getProductor( @@empr
                                        : @@sucu
                                        : t9arcd
                                        : t9spol
                                        : t9sspo
                                        : @@nivt
                                        : @@nivc );
            if @@nivt <> 1;
              SVPINT_GetCadena( @@empr
                              : @@sucu
                              : @@nivt
                              : @@nivc
                              : @@cade );
              @@nivt = 1;
              @@nivc = @@cade(1);
              clear Interm;
              Interm = SPVSPO_getProductor( @@empr
                                          : @@sucu
                                          : t9arcd
                                          : t9spol
                                          : t9sspo
                                          : @@nivt
                                          : @@nivc );
            endif;
            rc = SVPINT_getTelefonosWeb( @@empr
                                       : @@sucu
                                       : @@nivt
                                       : @@nivc
                                       : @@DsTl
                                       : @@DsTlC );
            clear @@mail;
            clear @@mailC;
            rc = SVPINT_getMailWeb( @@empr
                                  : @@sucu
                                  : @@nivt
                                  : @@nivc
                                  : @@mail
                                  : @@mailC );



        REST_writeXmlLine( 'DatosDelProductor'  : '*BEG' );
          REST_writeXmlLine( 'Nombre'          : %trim(Interm));

          REST_writeXmlLine( 'Telefonos'          : '*BEG' );
          for x = 1 to @@DsTlC;
            REST_writeXmlLine( 'Telefono'           : '*BEG' );
              REST_writeXmlLine( 'Numero'           : %trim(@@DsTl(x).dfNtel));
              clear DesTel;
              DesTel = SVPDES_TipoDeTelefono( @@Dstl(x).dftipt);
              REST_writeXmlLine( 'Tipo'             : %trim(DesTel));
            REST_writeXmlLine( 'Telefono'           : '*END' );
          endfor;
          REST_writeXmlLine( 'Telefonos'            : '*END' );

          REST_writeXmlLine( 'Correos'              : '*BEG' );
          for x = 1 to @@mailC;
            REST_writeXmlLine( 'Correo'             : '*BEG' );
              REST_writeXmlLine( 'Direccion'        : %trim(@@mail(x).mail));
              DesMail = SVPDES_getMail( @@mail(x).tipo );
              REST_writeXmlLine( 'Tipo'             : %trim(DesMail));
            REST_writeXmlLine( 'Correo'             : '*END' );
          endfor;
          REST_writeXmlLine( 'Correos'              : '*END' );
          REST_writeXmlLine( 'DatosDelProductor'    : '*END' );


        endsr;

       /end-free

**
Enero
Febrero
Marzo
Abril
Mayo
Junio
Julio
Agosto
Septiembre
Octubre
Noviembre
Diciembre
