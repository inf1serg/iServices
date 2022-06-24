      * ************************************************************ *
      * WSPSCD: QUOM Version 2 - Servicio POST                       *
      *         Insertar Caratula de Siniestro.                      *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *20-Oct-2021            *
      * ------------------------------------------------------------ *
      * SGF 16/03/22: La operación de Siniestro que llega tiene que  *
      *               ser de BPM (_chkGti960).                       *
      * SGF 04/05/22: Si la edad es mas de 99, fuerzo 99.            *
      *                                                              *
      * ************************************************************ *
        ctl-opt
         option(*srcstmt) actgrp(*new) dftactgrp(*no)
         bnddir('HDIILE/HDIBDIR')
         alwnull(*usrctl);

        dcl-f set439   usage(*input) keyed;
        dcl-f pahshe01 usage(*input) keyed;
        dcl-f gti980s  usage(*input:*update) keyed;
        dcl-f pahsd1   usage(*input:*output:*update:*delete) keyed;

        dcl-pr SPCEDA1 ExtPgm('SPCEDA1');
               peFnaa  packed(4:0);
               peFnam  packed(2:0);
               peFnad  packed(2:0);
               peFpra  packed(4:0);
               peFprm  packed(2:0);
               peFprd  packed(2:0);
               peEdad  packed(3:0);
        end-pr;

        dcl-pr SAR9191 ExtPgm('SAR9191');
               peRama  packed(2:0);
               peSini  packed(7:0);
               peNops  packed(7:0);
               peOper  packed(7:0);
               pePoco  packed(6:0);
               peDdia  packed(2:0);
               peDmes  packed(2:0);
               peDaÑo  packed(4:0);
               peSdia  packed(2:0);
               peSmes  packed(2:0);
               peSaÑo  packed(4:0);
               peSuop  packed(3:0);
               endpgm  char(3);
        end-pr;

      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpsi1_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

       dcl-ds request likeds(caratulaAutos_t);
       dcl-ds @@Ds456 likeds(dsSet456_t);
       dcl-ds @@Ds402 likeds(dsSet402_t);
       dcl-ds @@DsD0  likeds(dsPahed0_t) dim( 999 );
       dcl-ds @@DsC1  likeds(dsPahsc1_t);
       dcl-ds @@DsCd  likeds(dsPahscd_t);
       dcl-ds @@DsHe  likeds(dsPahshe_t);
       dcl-ds @@DsT0  likeds(dsPahet0_t);
       dcl-ds @@DsLc  likeds(dsGntloc_t) dim(99999);
       dcl-ds @@DsGp  likeds(dsGntpro_t) dim(99);
       dcl-ds @@DsSe  likeds(dsGntsex_t) dim(99);
       dcl-ds @@Ds01  likeds(dsSet001_t);
       dcl-ds @@DsMo  likeds(dsGntmon_t) dim(99);
       dcl-ds @@DsSp  likeds(dsPahssp_t) dim(9999);
       dcl-ds @@Ds98  likeds(dsPahscd_t) dim(999);
       dcl-s @@Ds98C  int(10);
       dcl-s @@DsD0C  int(10);
       dcl-s @@DsLcC  int(10);
       dcl-s @@DsGpC  int(10);
       dcl-s @@DsSeC  int(10);
       dcl-s @@DsMoC  int(10);
       dcl-s @@DsSpC  int(10);
       dcl-s ErrCode  int(10);
       dcl-s ErrText  char(80);
       dcl-s buffer   char(65535);
       dcl-s options  char(100);
       dcl-s @@repl   char(65535);
       dcl-s peValu   char(1024);
       dcl-s @@Proc   char(3);
       dcl-s @@Time   char(6);
       dcl-s @@Rpro   packed(2:0);
       dcl-s @@Hora   packed(2:0);
       dcl-s @@Minu   packed(2:0);
       dcl-s @@Fden   packed(8:0);
       dcl-s @@Habi   char(2);
       dcl-s @@Arse   packed(2:0);
       dcl-s @@Oper   packed(7:0);
       dcl-s @@Cert   packed(9:0);
       dcl-s @@Rame   packed(2:0);
       dcl-s @@Endo   packed(7:0);
       dcl-s @@Asen   packed(7:0);
       dcl-s @@Mone   char(2);
       dcl-s @@Moeq   char(2);
       dcl-s @@Edad   packed(3:0);
       dcl-s @@Ejco   packed(4:0);
       dcl-s @@Cgen   char(1);
       dcl-s @Fnaa    packed(4:0);
       dcl-s @Fnam    packed(2:0);
       dcl-s @Fnad    packed(2:0);
       dcl-s @Fpra    packed(4:0);
       dcl-s @Fprm    packed(2:0);
       dcl-s @Fprd    packed(2:0);
       dcl-s peEdad   packed(3:0);
       dcl-s endpgm   char(3);
       dcl-s rc       int(10);
       dcl-s x        int(10);
       dcl-s z        packed(3:0);

       dcl-s p@Sini   packed(7:0);
       dcl-s p@Focu   packed(8:0);
       dcl-s p@Hocu   packed(4:0);
       dcl-s p@Fnot   packed(8:0);
       dcl-s p@Etim   packed(2:0);
       dcl-s p@Atip   packed(2:0);
       dcl-s p@Ccon   packed(2:0);
       dcl-s p@Sscp   zoned(1:0);
       dcl-s p@Spai   packed(5:0);
       dcl-s p@Lnpr   packed(2:0);
       dcl-s p@Rtnr   packed(3:0);
       dcl-s p@Rkmt   packed(4:0);
       dcl-s p@Crnr   packed(3:0);
       dcl-s p@Sexo   packed(1:0);
       dcl-s p@Pcon   packed(5:0);
       dcl-s p@Fnac   packed(8:0);
       dcl-s p@Naci   packed(3:0);
       dcl-s p@Rnro   packed(8:0);
       dcl-s p@Rven   packed(8:0);
       dcl-s p@Ccop   packed(5:0);
       dcl-s p@CScp   packed(1:0);
       dcl-s p@Rela   packed(2:0);
       dcl-s p@Fdma   packed(8:0);
       dcl-s p@Ddia   packed(2:0);
       dcl-s p@Dmes   packed(2:0);
       dcl-s p@DaÑo   packed(4:0);
       dcl-s p@Sdia   packed(2:0);
       dcl-s p@Smes   packed(2:0);
       dcl-s p@SaÑo   packed(4:0);
       dcl-s p@Nops   packed(7:0);
       dcl-s p@Poco   packed(6:0);
       dcl-s p@Rtrn   char(1);
       dcl-s sini_ant packed(7:0);
       dcl-s p@Esci   packed(1:0);
       dcl-s @@vsys   char(512);
       dcl-s @@code   packed(3:0);

       dcl-c min 'abcdefghijklmnñopqrstuvwxyzáéíóúàèìòùäëïöü';
       dcl-c may 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ';

       dcl-ds peMsgs  likeds(paramMsgs);
       dcl-ds k1y439  likerec(s1t439:*key);
       dcl-ds k1y980  likerec(g1i980s:*key);
       dcl-ds k1yshe  likerec(p1hshe01:*key);

       dcl-ds @PsDs psds qualified;
              CurUsr char(10) pos(358);
       end-ds;

        *inlr = *on;

        REST_getEnvVar('REQUEST_METHOD':peValu);

        if %trim(peValu) <> 'POST';
           REST_writeHeader( 405
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit  );
           REST_end();
           SVPREST_end();
           return;
        endif;

        // Lectura y Parseo

         if REST_getEnvVar('WSPSCD_BODY' : peValu );
            options = 'doc=file path=caratulaSiniestro +
                       case=any allowextra=yes allowmissing=yes';
            monitor;
              xml-into request %xml('/tmp/wspscd.xml' : options);
            on-error;
              exsr $errorParseo;
           endmon;
            Qp0zDltEnv('WSPSCD_BODY');
          else;
            rc = REST_readStdInput( %addr(buffer): %len(buffer) );
            options = 'doc=string path=caratulaSiniestro +
                       case=any allowextra=yes allowmissing=yes';
            monitor;
              xml-into request %xml(buffer : options);
            on-error;
              exsr $errorParseo;
           endmon;
         endif;

         exsr CambiaMinMay;

         p@Sini = *zeros;
         monitor;
           p@Sini = %dec(request.siniestro:7:0);
          on-error;
           p@Sini = *zeros;
         endmon;

         p@Focu = *zeros;
         monitor;
           p@Focu = %dec(%subst(request.fechaOcurrencia:1:4):4:0) * 10000
                  + %dec(%subst(request.fechaOcurrencia:6:2):2:0) * 100
                  + %dec(%subst(request.fechaOcurrencia:9:2):2:0);
          on-error;
           p@Focu = *zeros;
         endmon;

         p@Hocu = *zeros;
         monitor;
           p@Hocu = %dec(%subst(request.horaOcurrencia:1:2):2:0) * 100
                  + %dec(%subst(request.horaOcurrencia:4:2):4:0);
          on-error;
           p@Hocu = *zeros;
         endmon;

         p@Fnot = *zeros;
         monitor;
           p@Fnot = %dec(%subst(request.fechaNotificacion:1:4):4:0) * 10000
                  + %dec(%subst(request.fechaNotificacion:6:2):2:0) * 100
                  + %dec(%subst(request.fechaNotificacion:9:2):2:0);
          on-error;
           p@Fnot = *zeros;
         endmon;

         p@Etim = *zeros;
         monitor;
           p@Etim = %dec(request.estadoTiempo:2:0);
          on-error;
           p@Etim = *zeros;
         endmon;

         p@Atip = *zeros;
         monitor;
           p@Atip = %dec(request.accidenteTipo:2:0);
          on-error;
           p@Atip = *zeros;
         endmon;

         p@Ccon = *zeros;
         monitor;
           p@Ccon = %dec(request.colisionCon:2:0);
          on-error;
           p@Ccon = *zeros;
         endmon;

         p@Sscp = *zeros;
         monitor;
           p@Sscp = %dec(request.lugarDelSiniestro.sufijoCodPostal:1:0);
          on-error;
           p@Sscp = *zeros;
         endmon;

         p@Spai = *zeros;
         monitor;
           p@Spai = %dec(request.lugarDelSiniestro.pais:5:0);
          on-error;
           p@Spai = *zeros;
         endmon;

         p@Lnpr = *zeros;
         monitor;
           p@Lnpr = %dec(request.lugarDelSiniestro.lugarNoPrisma:2:0);
          on-error;
           p@Lnpr = *zeros;
         endmon;

         p@Rtnr = *zeros;
         monitor;
           p@Rtnr = %dec(request.lugarDelSiniestro.rutaNro:3:0);
          on-error;
           p@Rtnr = *zeros;
         endmon;

         p@Rkmt = *zeros;
         monitor;
           p@Rkmt = %dec(request.lugarDelSiniestro.rutaKm:4:0);
          on-error;
           p@Rkmt = *zeros;
         endmon;

         p@Crnr = *zeros;
         monitor;
           p@Crnr = %dec(request.lugarDelSiniestro.cruceRutaNro:3:0);
          on-error;
           p@Crnr = *zeros;
         endmon;

         p@Sexo = *zeros;
         monitor;
           p@Sexo = %dec(request.conductor.sexo:1:0);
          on-error;
           p@Sexo = *zeros;
         endmon;

         p@Pcon = *zeros;
         monitor;
           p@Pcon = %dec(request.conductor.pais:5:0);
          on-error;
           p@Pcon = *zeros;
         endmon;

         p@Fnac = *zeros;
         monitor;
         p@Fnac =%dec(%subst(request.conductor.fechaNacimiento:1:4):4:0)* 10000
                +%dec(%subst(request.conductor.fechaNacimiento:6:2):2:0)* 100
                +%dec(%subst(request.conductor.fechaNacimiento:9:2):2:0);
          on-error;
           p@Fnac = *zeros;
         endmon;

         p@Naci = *zeros;
         monitor;
           p@Naci = %dec(request.conductor.nacionalidad:3:0);
          on-error;
           p@Naci = *zeros;
         endmon;

         p@Rnro = *zeros;
         monitor;
           p@Rnro = %dec(request.conductor.registroNro:8:0);
          on-error;
           p@Rnro = *zeros;
         endmon;

         p@Rven = *zeros;
         monitor;
           p@Rven = %dec(%subst(request.conductor.registroVencimiento:1:4)
                        :4:0) * 10000
                  + %dec(%subst(request.conductor.registroVencimiento:6:2)
                        :2:0) * 100
                  + %dec(%subst(request.conductor.registroVencimiento:9:2)
                        :2:0);
          on-error;
           p@Rven = *zeros;
         endmon;

         p@Ccop = *zeros;
         monitor;
           p@Ccop = %dec(request.conductor.domicilio.codigoPostal:5:0);
          on-error;
           p@Ccop = *zeros;
         endmon;

         p@CScp = *zeros;
         monitor;
           p@Cscp = %dec(request.conductor.domicilio.sufijoCodPostal:1:0);
          on-error;
           p@Cscp = *zeros;
         endmon;

         p@Rela = *zeros;
         monitor;
           p@Rela = %dec(request.conductor.relacionAsegurado:2:0);
          on-error;
           p@Rela = *zeros;
         endmon;

         monitor;
           p@Esci = %dec(request.conductor.estadoCivil:1:0);
          on-error;
           p@Esci = *zeros;
         endmon;

        exsr ValidaCaratulaSin;
        exsr inzDatos;
        exsr MoverCaratulaSin;

        // Validar si existe mas de un siniestro por fecha de ocurrencia...

        clear @@Ds98;
        @@Ds98C = 0;
        if SVPSIN_getSiniestroXFecha( request.empresa
                                    : request.sucursal
                                    : request.rama
                                    : request.poliza.numero
                                    : p@Focu
                                    : @@Ds98
                                    : @@Ds98C               );

          if SVPVLS_getValSys( 'HSINERRAVI' : *omit : @@vsys);
            select;
              when @@vsys = 'A';
                @@Code = 201;
                exsr GrabaSiniestro;
              when @@Vsys = 'E';
                @@Code = 400;
            endsl;

            REST_writeHeader( @@Code
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : *omit );

            REST_startArray( 'siniestrosEquivalentes' );
            for x = 1 to @@Ds98C;
              if @@Ds98(x).cdSini <> *zeros and
                 @@Ds98(x).cdSini <> p@Sini;
                REST_startArray( 'siniestroEquivalente' );
                  REST_writeXmlLine('numeroSiniestro' :
                                     %char( @@Ds98(x).cdSini ) );
                  REST_writeXmlLine('numeroOperacionSiniestro' :
                                     %char( @@Ds98(x).cdNops ) );
                REST_endArray  ( 'siniestroEquivalente' );
              endif;
            endfor;
            REST_endArray  ( 'siniestrosEquivalentes' );

          endif;
        else;

          exsr GrabaSiniestro;
          REST_writeHeader( 201
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit );
          REST_end();

        endif;

        return;

        begsr ValidaCaratulaSin;

        sini_ant = SVPSIN_getSiniestroDesdeNops( request.empresa
                                               : request.sucursal
                                               : request.rama
                                               : request.nroOperStro );

        if sini_ant <> %dec(request.siniestro:7:0);
           %subst(@@repl:1:7) = %editc(request.nroOperStro:'X');
           %subst(@@repl:8:7) = %trim(request.siniestro);
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'SIN0073'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'SIN0073'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;

        // Valida Empresa...

        if not SVPVAL_empresa( request.empresa );
          @@repl = request.empresa;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0113'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'COW0113'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Sucursal...

        if not SVPVAL_sucursal( request.empresa
                              : request.sucursal );

          %subst(@@repl:1:2) = request.sucursal;
          %subst(@@repl:3:1) = request.empresa;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0114'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'COW0114'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Rama...

        if not SVPVAL_rama( request.rama );
          @@repl = %editc( request.rama : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0119'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'COW0119'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Número de Operación de Siniestro...

        if request.nroOperStro = *zeros;
            @@repl = %editc( request.nroOperStro : 'X' );
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0043'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0043'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
        endif;

        // La operación de Siniestro tiene que ser de BPM...
        if SVPSIN_chkGti960( request.empresa
                           : request.sucursal
                           : request.rama
                           : request.nroOperStro ) = *off;
            @@repl = %editc( request.nroOperStro : 'X' );
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0043'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0043'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
        endif;

        // Valida Fecha de Ocurrencia...

        clear @@Fden;
        clear @@Ds456;

        // Obtener Fecha de Denuncia...
        if SVPSIN_getSet456( request.empresa
                           : request.sucursal
                           : @@Ds456          );

          @@Fden = ( @@ds456.t@Fema * 10000 ) + ( @@ds456.t@Femm * 100 )
                 +   @@ds456.t@Femd;
        endif;

        clear p@Fdma;
        p@Fdma = SPVFEC_GiroFecha8( p@Focu : 'DMA' );
        if not SPVFEC_FechaValida8( p@Fdma );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0003'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0003'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Fecha de Ocurrencia no debe ser mayor a la Fecha de Denuncia...

        if SPVFEC_FechaMayor8( @@Fden : p@Focu ) = 2;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0003'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0003'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Hora de Ocurrencia...

        @@Time = %editc( p@Hocu : 'X' );
        @@Hora = %dec  ( %subst(@@Time:1:2): 2: 0 );
        @@Minu = %dec  ( %subst(@@Time:3:2): 2: 0 );

        if @@Hora > 24 or @@Minu > 60;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0007'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0007'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Fecha de Notificación...

        clear p@Fdma;
        p@Fdma = SPVFEC_GiroFecha8( p@Fnot : 'DMA' );
        if not SPVFEC_FechaValida8( p@Fdma );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0012'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0012'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Fecha de Notificación no debe ser mayor a la Fecha de Denuncia...

        if SPVFEC_FechaMayor8( @@Fden : p@Fnot ) = 2;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0012'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0012'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Fecha de Notificación no debe ser menor a la Fecha de Ocurrencia...

        if SPVFEC_FechaMayor8( p@Focu
                             : p@Fnot ) = 1;

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0012'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0012'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Causa...

        if not SVPVAL_causaSiniestro( request.rama : request.causa );

          @@repl = %editc( request.causa : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0002'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0002'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Momento del Día...

        if request.momentoDia <> 'D' and request.momentoDia <> 'N' and
           request.momentoDia <> ' ';

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0013'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0013'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Estado del Tiempo...

        if p@Etim <> *zeros;
          if not SVPVAL_estadoDelTiempo( request.empresa
                                       : request.sucursal
                                       : p@Etim           );

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0014'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0014'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
          endif;
        endif;

        // Valida Tipo de Accidente...

        if p@Atip <> *zeros;
          if not SVPVAL_tipoDeAccidente( request.empresa
                                       : request.sucursal
                                       : p@Atip           );

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0015'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0015'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
          endif;
        endif;

        // Valida Colisión Con...

        if p@Ccon <> *zeros;
          if not SVPVAL_colisionCon( request.empresa
                                   : request.sucursal
                                   : p@Ccon           );

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0016'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0016'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
          endif;
        endif;

        // Valida Póliza...

        if not SVPPOL_chkPoliza( request.empresa
                               : request.sucursal
                               : request.rama
                               : request.poliza.numero
                               : request.poliza.suplPoliza
                               : request.poliza.articulo
                               : request.poliza.superpoliza
                               : request.poliza.suplSuperpoliza
                               : *omit
                               : *omit                          );

          %subst(@@repl:1:2) = %editc( request.rama : 'X' );
          %subst(@@repl:3:7) = %editc( request.poliza.numero : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'POL0009'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        else;
          exsr ObtenerDatos;
        endif;

        // Valida que el asegurado sea el mismo que el de la poliza...

        if request.conductor.esAsegurado = 'S';
          if not SPVSPO_chkAsen( request.empresa
                               : request.sucursal
                               : request.poliza.articulo
                               : request.poliza.superpoliza
                               : request.poliza.suplSuperpoliza
                               : request.conductor.nroDaf       );

            %subst(@@repl:1:7) = %editc( request.conductor.nroDaf : 'X' );
            %subst(@@repl:8:7) = %editc( request.poliza.numero : 'X' );
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0062'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0062'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
          endif;
        endif;

        // Valida Vehículo Asegurado...

        clear @@Dst0;
        if not SPVVEH_getPahet0( request.empresa
                               : request.sucursal
                               : request.poliza.articulo
                               : request.poliza.superpoliza
                               : request.rama
                               : @@Arse
                               : request.vehiculoAsegurado.componente
                               : request.poliza.suplSuperpoliza
                               : @@DsT0                               );

          %subst(@@repl:1:6) = %editc( request.vehiculoAsegurado.componente :
                                       'X' );
          %subst(@@repl:7:2) = %editc( request.rama : 'X' );
          %subst(@@repl:10:7)= %editc( request.poliza.numero : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0010'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'POL0010'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Reasegurado...

        if request.reaseguro <> 'S' and request.reaseguro <> 'N';

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0017'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0017'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
        endif;

        // Valida Recupero...

        if request.recupero <> 'S' and request.recupero <> 'N';

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0018'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0018'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
        endif;

        // Valida Asistencia Medica...

        if request.asistenciaMedica <> 'S' and request.asistenciaMedica <> 'N'
           and request.asistenciaMedica <> ' ';

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0019'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0019'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
        endif;

        // Valida Denuncia Policial...

        if request.denunciaPolicial <> 'S' and request.denunciaPolicial <> 'N'
           and request.denunciaPolicial <> ' ';

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0020'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0020'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
        endif;

        // Valida Comisaria...

        if request.denunciaPolicial <> ' ' and request.comisaria = *blanks;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0021'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0021'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
        endif;

        // Valida Lugar del Siniestro...

        if not SVPVAL_codigoPostal( request.lugarDelSiniestro.codigoPostal
                                  : p@Sscp                                 );

          %subst(@@repl:1:5) = %editc( request.lugarDelSiniestro.codigoPostal
                                     : 'X' );
          %subst(@@repl:6:1) = %editc( p@Sscp : 'X' );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0013'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'COW0013'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        if p@Spai > *zeros;
          if not SVPVAL_chkPaisNac( p@Spai );

            @@repl = %editc( p@Spai : 'X' );
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0037'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0037'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
          endif;
        endif;

        if not SVPVAL_lugarPrisma( request.lugarDelSiniestro.lugarPrisma );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0022'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0022'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        if p@Lnpr > *zeros;
        if not SVPVAL_lugarNoPrisma( request.empresa
                                   : request.sucursal
                                   : p@Lnpr           );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0023'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0023'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;
        endif;

        if request.lugarDelSiniestro.rutaTipo <> ' ' and
           request.lugarDelSiniestro.rutaTipo <> 'N' and
           request.lugarDelSiniestro.rutaTipo <> 'P';

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0024'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0024'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        if request.lugarDelSiniestro.cruceSenalizado <> ' ' and
           request.lugarDelSiniestro.cruceSenalizado <> 'S' and
           request.lugarDelSiniestro.cruceSenalizado <> 'N';

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0025'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0025'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida cruce de tren...

        if request.lugarDelSiniestro.cruceTren <> ' ' and
           request.lugarDelSiniestro.cruceTren <> 'S' and
           request.lugarDelSiniestro.cruceTren <> 'N';

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0026'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0026'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida si existe barrera...

        if request.lugarDelSiniestro.barrera <> ' ' and
           request.lugarDelSiniestro.barrera <> 'S' and
           request.lugarDelSiniestro.barrera <> 'N';

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0027'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0027'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida si existe señalización de cruce de tren...

        if request.lugarDelSiniestro.cruceTrenSenalizado <> ' ' and
           request.lugarDelSiniestro.cruceTrenSenalizado <> 'S' and
           request.lugarDelSiniestro.cruceTrenSenalizado <> 'N';

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0028'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0028'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida si hay semaforo...

        if request.lugarDelSiniestro.semaforo <> ' ' and
           request.lugarDelSiniestro.semaforo <> 'S' and
           request.lugarDelSiniestro.semaforo <> 'N';

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0029'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0029'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida si funciona el semaforo...

        if request.lugarDelSiniestro.semaforo = 'S' and (
           request.lugarDelSiniestro.semaforoFunciona <> 'S' and
           request.lugarDelSiniestro.semaforoFunciona <> 'N' );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0030'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0030'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida el color del semaforo...

        if request.lugarDelSiniestro.semaforo = 'S' and
           request.lugarDelSiniestro.semaforoColor =  ' ';

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0031'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0031'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida número de asegurado del conductor...

        if request.conductor.esAsegurado = 'S' and
           not SVPDAF_chkDaf( request.conductor.nroDaf );

          @@repl = %editc( request.conductor.nroDaf : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'DAF0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'DAF0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida nombre del conductor...

        if request.conductor.nombre = *blanks;

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0009'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'COW0009'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Pais proveniente del conductor...

        if p@Pcon > *zeros;
          if not SVPVAL_chkPaisNac( p@Pcon );

            @@repl = %editc( p@Pcon : 'X' );
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'PRW0015'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'PRW0015'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
          endif;
        endif;

        // Valida el sexo del conductor...

        if p@Sexo = *zeros;

          @@repl = %editc( p@Sexo : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0012'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'PRW0012'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida tipo de documento del conductor...

        if not SVPVAL_tipoDeDocumento( request.conductor.documentoTipo );

          @@repl = %editc( request.conductor.documentoTipo : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AAG0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'AAG0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida número del documento...

        select;
          when request.conductor.esAsegurado = 'S';
            if not SVPASE_isAseguradoHdi( request.conductor.documentoTipo
                                        : request.conductor.documentoNro
                                        : *omit
                                        : *omit
                                        : *omit                           );

              %subst(@@repl:1:2)  = %editc( request.conductor.documentoTipo
                                  : 'X' );
              %subst(@@repl:3:11) = %editc( request.conductor.documentoNro
                                  : 'X' );
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'AAG0008'
                           : peMsgs
                           : %trim(@@repl)
                           : %len(%trim(@@repl)) );
              REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'AAG0008'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
              REST_end();
              SVPREST_end();
              return;
            endif;

          when request.conductor.esAsegurado = 'N';
            if request.conductor.documentoNro = *zeros;

              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'AAG0002'
                           : peMsgs
                           : %trim(@@repl)
                           : %len(%trim(@@repl)) );
              REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'AAG0002'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
              REST_end();
              SVPREST_end();
              return;
            endif;
          other;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0032'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0032'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
        endsl;

        // Valida relación asegurado...

        if p@Rela <> *zeros;

        if not SVPVAL_relacionAsegurado( request.empresa
                                       : request.sucursal
                                       : p@Rela            );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0033'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0033'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;
        endif;

        // valida domicilio del conductor...

        if request.lugarDelSiniestro.calle = *blanks;

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0036'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0036'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida Codigo Postal del Conductor...

        if p@Ccop > *zeros;

        if not SVPVAL_codigoPostal( p@Ccop
                                  : p@CScp  );


          %subst(@@repl:1:5) = %editc( p@Ccop : 'X' );

          %subst(@@repl:6:1) = %editc( p@CScp : 'X' );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0013'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'COW0013'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;
        endif;

        // Valida fecha de nacimiento...

        clear p@Fdma;
        p@Fdma = SPVFEC_GiroFecha8( p@Fnac : 'DMA' );
        if not SPVFEC_FechaValida8( p@Fdma ) and p@fdma <> 0;

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0047'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'PRW0047'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida estado civil del conductor...

        if not SVPVAL_chkEdoCivil( p@Esci ) and p@Esci <> 0;

          @@repl = %editc( p@Esci : 'X' );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0013'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'PRW0013'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida nacionalidad del conductor...

        if p@Naci > *zeros;

          if not SVPVAL_nacionalidad( p@Naci );

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'PRW0042'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'PRW0042'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
          endif;
        endif;

        // Valida examen de alcoholemia...

        if request.conductor.examenAlcoholemia <> *blanks and
           request.conductor.examenAlcoholemia <> 'S'     and
           request.conductor.examenAlcoholemia <> 'N'     and
           request.conductor.examenAlcoholemia <> 'X';

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN0034'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN0034'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        // Valida si es el conductor habitual...

        select;
          when request.conductor.habitual = *blanks;
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0035'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0035'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;

          when request.conductor.habitual = 'S';
            @@Habi = 'H';

          when request.conductor.habitual = 'N';
            @@Habi = 'NH';

        endsl;

        clear endpgm;

        p@Ddia = @@ds456.t@Femd;
        p@Dmes = @@ds456.t@Femm;
        p@DaÑo = @@ds456.t@Fema;
        p@Sdia = %dec(%subst(request.fechaOcurrencia:9:2):2:0);
        p@Smes = %dec(%subst(request.fechaOcurrencia:6:2):2:0);
        p@SaÑo = %dec(%subst(request.fechaOcurrencia:1:4):4:0);
        p@Nops = request.nroOperStro;
        p@Poco = request.vehiculoAsegurado.componente;

        SAR9191( @@DsD0( @@DsD0C ).d0Rama
               : p@Sini
               : p@Nops
               : @@Oper
               : p@poco
               : p@Ddia
               : p@Dmes
               : p@DaÑo
               : p@Sdia
               : p@Smes
               : p@SaÑo
               : @@DsD0( @@DsD0C ).d0suop
               : endpgm                               );

        if not SVPSIN_chkSinModificable( request.empresa
                                       : request.sucursal
                                       : request.rama
                                       : request.nroOperStro );

          ErrText = SVPSIN_Error(ErrCode);
          if ( ErrCode = SVPSIN_SINNM );

            %subst( @@repl : 1 : 2 ) = %editc( request.rama : 'X' );
            %subst( @@repl : 3 : 7 ) = %editc( request.nroOperStro : 'X' );
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'SIN0052'
                         : peMsgs
                         : %trim(@@repl)
                         : %len(%trim(@@repl)) );
            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : 'SIN0052'
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            return;
          endif;
        endif;

        // Validar que el siniestro no este terminado o rechazado...

        if not SVPSIN_chkSiniPend( request.empresa
                                 : request.sucursal
                                 : request.rama
                                 : p@Sini
                                 : request.nroOperStro );

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SIN5010'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'SIN5010'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endif;

        endsr;

        begsr MoverCaratulaSin;

        // Mueve campos a la DS de siniestro...

        @@DsCd.cdEmpr = request.empresa;
        @@DsCd.cdSucu = request.sucursal;
        @@DsCd.cdRama = request.rama;
        @@DsCd.cdSini = p@Sini;
        @@DsCd.cdNops = request.nroOperStro;
        @@DsCd.cdnsag = *zeros;
        @@DsCd.cdejco = @@Ejco;
        @@DsCd.cdArcd = request.poliza.articulo;
        @@DsCd.cdSpol = request.poliza.superpoliza;
        @@DsCd.cdSspo = request.poliza.suplSuperpoliza;
        @@DsCd.cdRame = @@Rame;
        @@DsCd.cdArse = @@Arse;
        @@DsCd.cdOper = @@Oper;
        @@DsCd.cdSuop = request.poliza.suplPoliza;
        @@DsCd.cdMonr = @@Mone;
        @@DsCd.cdMoeq = @@Moeq;
        @@DsCd.cdPoli = request.poliza.numero;
        @@DsCd.cdCert = @@Cert;
        @@DsCd.cdEndo = @@Endo;
        @@DsCd.cdOtom = *zeros;
        @@DsCd.cdAsen = @@Asen;
        @@DsCd.cdSocn = *zeros;
        @@DsCd.cdFsia = %dec(%subst(%char(p@Focu):1:4):4:0);
        @@DsCd.cdFsim = %dec(%subst(%char(p@Focu):5:2):2:0);
        @@DsCd.cdFsid = %dec(%subst(%char(p@Focu):7:2):2:0);
        @@DsCd.cdFdea = @@Ds456.t@Fema;
        @@DsCd.cdFdem = @@Ds456.t@Femm;
        @@DsCd.cdFded = @@Ds456.t@Femd;
        @@DsCd.cdCesi = 1;
        @@DsCd.cdCese = %xlate(min:may:@@Ds402.t@Cese);
        @@DsCd.cdTerm = %xlate(min:may:@@Ds402.t@Mar1);
        @@DsCd.cdJuin = *zeros;
        @@DsCd.cdCauc = request.causa;
        @@DsCd.cdHsin = p@Hocu;
        @@DsCd.cdCopo = request.lugarDelSiniestro.codigoPostal;
        @@DsCd.cdCops = p@Sscp;
        @@DsCd.cdProc = @@Proc;
        @@DsCd.cdRpro = @@Rpro;
        @@DsCd.cdClos = request.lugarDelSiniestro.lugarPrisma;
        @@DsCd.cdNrdf = request.conductor.nroDaf;
        @@DsCd.cdNcon = %trim(request.conductor.nombre);
        @@DsCd.cdNrcv = p@Rnro;
        if p@Rven > *zeros;
          @@DsCd.cdFrva = %dec(%subst(%char( p@Rven ):1:4):4:0);
          @@DsCd.cdFrvm = %dec(%subst(%char( p@Rven ):5:2):2:0);
          @@DsCd.cdFrvd = %dec(%subst(%char( p@Rven ):7:2):2:0);
        endif;
        @@DsCd.cdRcop = *blanks;
        @@DsCd.cdCrcv = request.conductor.registroCategoria;
        @@DsCd.cdCtco = @@Habi;
        @@DsCd.cdEdad = @@Edad;
        @@DsCd.cdSexo = p@Sexo;
        @@DsCd.cdCgen = @@Cgen;
        @@DsCd.cdCesc = p@Esci;
        @@DsCd.cdTalc = *blanks;
        @@DsCd.cdCjrs = *blanks;
        @@DsCd.cdVhts = *blanks;
        @@DsCd.cdCtle = *blanks;
        @@DsCd.cdLudi = request.lugarDelSiniestro.calle;
        @@DsCd.cdMar1 = *off;
        @@DsCd.cdMar2 = *off;
        @@DsCd.cdMar3 = *off;
        @@DsCd.cdMar4 = *off;
        @@DsCd.cdMar5 = *off;
        @@DsCd.cdUser = @PsDs.CurUsr;
        @@DsCd.cdTime = %dec(%time);
        @@DsCd.cdFera = *year;
        @@DsCd.cdFerm = umonth;
        @@DsCd.cdFerd = uday;
        @@DsCd.cdMp06 = request.recupero;
        @@DsCd.cdMp07 = 'N';
        @@DsCd.cdMp08 = request.reaseguro;
        @@DsCd.cdMp09 = 'N';
        @@DsCd.cdMp10 = *off;
        @@DsCd.cdMp11 = *off;
        @@DsCd.cdMp12 = *off;
        @@DsCd.cdMp13 = *off;
        @@DsCd.cdMp14 = *off;
        @@DsCd.cdMp15 = *off;
        @@DsCd.cdMp16 = *off;
        @@DsCd.cdMp17 = *off;
        @@DsCd.cdMp18 = *off;
        @@DsCd.cdMp19 = *off;
        @@DsCd.cdFnoa = %dec(%subst(%char(p@Fnot):1:4):4:0);
        @@DsCd.cdFnom = %dec(%subst(%char(p@Fnot):5:2):2:0);
        @@DsCd.cdFnod = %dec(%subst(%char(p@Fnot):7:2):2:0);
        @@DsCd.cdNhec = *zeros;

        // Mueve campos a la DS de historia de siniestro...

        @@DsHe.heEmpr = request.empresa;
        @@DsHe.heSucu = request.sucursal;
        @@DsHe.heRama = request.rama;
        @@DsHe.heSini = p@Sini;
        @@DsHe.heNops = request.nroOperStro;
        @@DsHe.heFema = @@Ds456.t@Fema;
        @@DsHe.heFemm = @@Ds456.t@Femm;
        @@DsHe.heFemd = @@Ds456.t@Femd;
        @@DsHe.heCesi = 1;
        @@DsHe.heCese = %xlate(min:may:@@Ds402.t@Cese);
        @@DsHe.heTerm = %xlate(min:may:@@Ds402.t@Mar1);
        @@DsHe.heMar1 = *off;
        @@DsHe.heMar2 = *off;
        @@DsHe.heMar3 = *off;
        @@DsHe.heMar4 = *off;
        @@DsHe.heMar5 = *off;
        @@DsHe.heUser = @PsDs.CurUsr;
        @@DsHe.heTime = %dec(%time);
        @@DsHe.heFera = *year;
        @@DsHe.heFerm = umonth;
        @@DsHe.heFerd = uday;

        // Mueve campos a la DS de denuncia - extención...

        @@DsC1.cd1Empr = request.empresa;
        @@DsC1.cd1Sucu = request.sucursal;
        @@DsC1.cd1Rama = request.rama;
        @@DsC1.cd1Sini = p@Sini;
        @@DsC1.cd1Nops = request.nroOperStro;
        @@DsC1.cd1Mar1 = request.momentoDia;
        @@DsC1.cd1Cdes = p@Etim;
        @@DsC1.cd1Pain = p@Spai;
        @@DsC1.cd1Ruta = p@Rtnr;
        @@DsC1.cd1Nrkm = p@Rkmt;
        @@DsC1.cd1Mar2 = request.lugarDelSiniestro.rutaTipo;
        @@DsC1.cd1Rut2 = p@Crnr;
        @@DsC1.cd1Mar3 = request.lugarDelSiniestro.cruceSenalizado;
        @@DsC1.cd1Mar4 = request.lugarDelSiniestro.cruceTren;
        @@DsC1.cd1Mar5 = request.lugarDelSiniestro.barrera;
        @@DsC1.cd1Mar6 = request.lugarDelSiniestro.cruceTrenSenalizado;
        @@DsC1.cd1Esta = request.lugarDelSiniestro.estadoBarrera;
        @@DsC1.cd1Mar7 = request.lugarDelSiniestro.semaforo;
        @@DsC1.cd1Mar8 = request.lugarDelSiniestro.semaforoFunciona;
        @@DsC1.cd1Colo = request.lugarDelSiniestro.semaforoColor;
        @@DsC1.cd1Tcal = request.lugarDelSiniestro.calzadaTipo;
        @@DsC1.cd1Ecal = request.lugarDelSiniestro.calzadaEstado;
        @@DsC1.cd1Paic = p@Pcon;
        @@DsC1.cd1Mar9 = request.conductor.examenAlcoholemia;
        @@DsC1.cd1Rela = p@Rela;
        @@DsC1.cd1Cdcs = p@Atip;
        @@DsC1.cd1Ctco = p@Ccon;
        @@DsC1.cd1Clug = p@Lnpr;
        @@DsC1.cd1User = @PsDs.CurUsr;
        @@DsC1.cd1Date = SPVFEC_Convert8a6(%dec(%date));
        @@DsC1.cd1Time = %dec(%time);
        @@DsC1.cd1Colv = request.vehiculoAsegurado.Color;
        @@DsC1.cd1Asme = request.asistenciaMedica;
        @@DsC1.cd1Denp = request.denunciaPolicial;
        @@DsC1.cd1Comi = request.comisaria;

        endsr;

        begsr CambiaMinMay;

        request.empresa  = %xlate(min:may:request.empresa);
        request.sucursal = %xlate(min:may:request.sucursal);
        request.momentoDia = %xlate(min:may:request.momentoDia);
        request.vehiculoAsegurado.Color = %xlate(min:may:request.
                                          vehiculoAsegurado.Color);
        request.reaseguro = %xlate(min:may:request.reaseguro);
        request.recupero  = %xlate(min:may:request.recupero);
        request.asistenciaMedica = %xlate(min:may:request.asistenciaMedica);
        request.denunciaPolicial = %xlate(min:may:request.denunciaPolicial);
        request.comisaria = %xlate(min:may:request.comisaria);
        request.lugarDelSiniestro.lugarPrisma = %xlate(min:may:request.
                                                lugarDelSiniestro.lugarPrisma);
        request.lugarDelSiniestro.calle = %xlate(min:may:request.
                                          lugarDelSiniestro.calle);
        request.lugarDelSiniestro.entreCalle = %xlate(min:may:request.
                                               lugarDelSiniestro.entreCalle);
        request.lugarDelSiniestro.yCalle = %xlate(min:may:request.
                                           lugarDelSiniestro.yCalle);
        request.lugarDelSiniestro.rutaTipo = %xlate(min:may:request.
                                             lugarDelSiniestro.rutaTipo);
        request.lugarDelSiniestro.cruceSenalizado = %Xlate(min:may:request.
                                            lugarDelSiniestro.cruceSenalizado);
        request.lugarDelSiniestro.cruceTren = %xlate(min:may:request.
                                              lugarDelSiniestro.cruceTren);
        request.lugarDelSiniestro.barrera = %xlate(min:may:request.
                                            lugarDelSiniestro.barrera);
        request.lugarDelSiniestro.cruceTrenSenalizado = %xlate(min:may:request.
                                        lugarDelSiniestro.cruceTrenSenalizado);
        request.lugarDelSiniestro.estadoBarrera = %xlate(min:may:request.
                                              lugarDelSiniestro.estadoBarrera);
        request.lugarDelSiniestro.semaforo = %xlate(min:may:request.
                                             lugarDelSiniestro.semaforo);
        request.lugarDelSiniestro.semaforoFunciona = %xlate(min:may:request.
                                           lugarDelSiniestro.semaforoFunciona);
        request.lugarDelSiniestro.semaforoColor = %xlate(min:may:request.
                                              lugarDelSiniestro.semaforoColor);
        request.lugarDelSiniestro.calzadaTipo = %xlate(min:may:request.
                                                lugarDelSiniestro.calzadaTipo);
        request.lugarDelSiniestro.calzadaEstado = %xlate(min:may:request.
                                              lugarDelSiniestro.calzadaEstado);
        request.conductor.nombre = %xlate(min:may:request.conductor.nombre);
        request.conductor.domicilio.calle = %xlate(min:may:request.conductor.
                                            domicilio.calle);
        request.conductor.email = %xlate(min:may:request.conductor.email);
        request.conductor.examenAlcoholemia = %xlate(min:may:request.conductor.
                                              examenAlcoholemia);
        request.conductor.habitual = %xlate(min:may:request.conductor.
                                     habitual);
        request.conductor.esAsegurado = %xlate(min:may:request.conductor.
                                        esAsegurado);

        endsr;

        begsr inzDatos;

        clear @@DsCd;
        clear @@DsHe;
        clear @@DsC1;
        clear @@DsSp;

        endsr;

        begsr ObtenerDatos;

        clear @@Ds01;
        if not SVPTAB_getSet001( request.rama : @@Ds01 );
          @@Rame = @@Ds01.t@Rame;
        endif;

        clear @@DsD0;
        @@DsD0C = 0;

        if SVPPOL_getPoliza( request.empresa
                           : request.sucursal
                           : request.rama
                           : request.poliza.numero
                           : request.poliza.suplPoliza
                           : request.poliza.articulo
                           : request.poliza.superpoliza
                           : request.poliza.suplSuperpoliza
                           : *omit
                           : *omit
                           : @@DsD0
                           : @@DsD0C                        );

          @@Arse = @@DsD0( @@DsD0C ).d0Arse;
          @@Oper = @@DsD0( @@DsD0C ).d0Oper;
          @@Cert = @@DsD0( @@DsD0C ).d0Cert;
          @@Endo = @@DsD0( @@DsD0C ).d0Endo;
          @@Mone = @@DsD0( @@DsD0C ).d0Mone;

          clear @@DsMo;
          @@DsMoC = 0;
          if SVPTAB_ListaMonedas( @@DsMo : @@DsMoC );
            for x = 1 to @@DsMoC;
              if @@DsMo(x).moComo = @@Mone;
                @@Moeq = @@DsMo(x).moMoeq;
                leave;
              endif;
            endfor;
          endif;
        endif;

        clear @@DsLc;
        clear @@DsGp;

        @@DsLcC = 0;
        @@DsGpC = 0;

        if SVPTAB_getGntloc( @@DsLc
                           : @@DsLcC
                           : request.lugarDelSiniestro.codigoPostal
                           : p@Sscp                                 );

          @@Proc = @@DsLc( @@DsLcC ).loProc;
          if SVPTAB_getGntpro( @@DsGp
                             : @@DsGpC
                             : @@Proc  );

            @@Rpro = @@DsGp( @@DsGpC ).prRpro;
          endif;
        endif;

        if SVPSIN_getset402( request.empresa
                           : request.sucursal
                           : request.rama
                           : 1
                           : @@Ds402          );

        endif;

        if SVPSIN_getSet456( request.empresa
                           : request.sucursal
                           : @@Ds456          );
        endif;

        monitor;
          @Fnaa = %dec(%subst(%char( p@Fnac ):1:4):4:0);
         on-error;
          @Fnaa = 0;
        endmon;
        monitor;
          @Fnam = %dec(%subst(%char( p@Fnac ):5:2):2:0);
         on-error;
          @Fnam = 0;
        endmon;
        monitor;
          @Fnad = %dec(%subst(%char( p@Fnac ):7:2):2:0);
         on-error;
          @Fnad = 0;
        endmon;
        @Fpra = *year;
        @Fprm = *month;
        @Fprd = *day;

        SPCEDA1( @Fnaa
               : @Fnam
               : @Fnad
               : @Fpra
               : @Fprm
               : @Fprd
               : @@Edad );
        if @@edad > 99;
           @@edad = 99;
        endif;

        clear @@DsSe;
        @@DsSeC = 0;
        if SVPTAB_ListaSexos( @@DsSe : @@DsSeC );
          for x = 1 to @@DsSeC;
            if @@DsSe( x ).seCsex = p@Sexo;
              @@Cgen = @@DsSe( x ).seCgen;
              leave;
            endif;
          endfor;
        endif;

        k1y439.t@Empr = request.empresa;
        k1y439.t@Sucu = request.sucursal;
        setgt  %kds( k1y439 : 2 ) set439;
        readpe %kds( k1y439 : 2 ) set439;

        @@Ejco = t@Ejco;

        clear @@Asen;
        @@Asen = SPVSPO_getAsen( request.empresa
                               : request.sucursal
                               : request.poliza.articulo
                               : request.poliza.superpoliza
                               : request.poliza.suplSuperpoliza );

        endsr;

        begsr GrabaSiniestro;

        // Graba caratula de siniestro...

        if SVPSI1_chkPahscd( request.empresa
                           : request.sucursal
                           : request.rama
                           : p@Sini
                           : request.nroOperStro );

          SVPSI1_updPahscd( @@DsCd );
        else;
          SVPSI1_setPahscd( @@DsCd );
        endif;

        // Graba historia de siniestro...

        k1yshe.heEmpr = request.empresa;
        k1yshe.heSucu = request.sucursal;
        k1yshe.heRama = request.rama;
        k1yshe.heNops = request.nroOperStro;
        k1yshe.heSini = p@Sini;
        setgt     %kds( k1yshe : 5 ) pahshe01;
        readpe(n) %kds( k1yshe : 5 ) pahshe01;
        if %eof;
          @@DsHe.hePsec = 1;
          SVPSI1_setPahshe( @@DsHe );
        else;
          SVPSIN_wrtEstSin( @@DsHe.heEmpr
                          : @@DsHe.heSucu
                          : @@DsHe.heRama
                          : @@DsHe.heSini
                          : @@DsHe.heNops
                          : @@DsHe.heFema
                          : @@DsHe.heFemm
                          : @@DsHe.heFemd
                          : @@DsHe.heCesi
                          : @@DsHe.heCese
                          : @@DsHe.heTerm );

        endif;

        // Actualizaa siniestro speedway...

        k1y980.g0sEmpr = request.empresa;
        k1y980.g0sSucu = request.sucursal;
        k1y980.g0sRama = request.rama;
        k1y980.g0sNops = request.nroOperStro;
        chain %kds( k1y980 : 4 ) gti980s;
        if %found( gti980s );

          g0sFsia = ( @@DsCd.cdFsia * 10000 )
                  + ( @@DsCd.cdFsim * 100   )
                  +   @@DsCd.cdFsid;

          g0sHsia = p@Hocu;
        endif;

        // Actualiza siniestro suspendido...

        if SVPSI1_getPahssp( request.empresa
                           : request.sucursal
                           : request.rama
                           : p@Sini
                           : request.nroOperStro
                           : @@DsSp
                           : @@DsSpC             );

          @@DsSp(@@DsSpC).spAp01 = 1;
          @@DsSp(@@DsSpC).spAp06 = 1;
          @@DsSp(@@DsSpC).spNoma = request.conductor.nombre;
          SVPSI1_updPahssp( @@DsSp(@@DsSpC) );
        endif;

        // Graba denuncia de siniestro - extensión de auto...

        if SVPSI1_chkPahsc1( request.empresa
                           : request.sucursal
                           : request.rama
                           : p@Sini
                           : request.nroOperStro );

          SVPSI1_updPahsc1( @@DsC1 );
        else;
          SVPSI1_setPahsc1( @@DsC1 );
        endif;

        endsr;

        begsr $errorParseo;
         @@repl = 'BPM';
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'RPG0001'
                      : peMsgs
                      : %trim(@@repl)
                      : %len(%trim(@@repl)) );
         REST_writeHeader( 400
                         : *omit
                         : *omit
                         : 'RPG0001'
                         : peMsgs.peMsev
                         : peMsgs.peMsg1
                         : peMsgs.peMsg2 );
         REST_end();
         SVPREST_end();
         return;
        endsr;

