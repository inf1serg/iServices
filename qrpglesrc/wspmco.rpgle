     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSPMCO: QUOM Version 2 - Servicio POST                       *
      *         Marcar Cobertura Siniestrada                         *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *03-Nov-2021            *
      * ************************************************************ *
     Fpahscd    if   e           k disk
     Fpahet9    if   e           k disk
     Fpahet0    if   e           k disk
     Fset210    if   e           k disk    prefix(tt:2)
     Fset402    if   e           k disk
     Fset403    if   e           k disk
     Fset404    if   e           k disk
     Fset408    if   e           k disk
     Fset409    if   e           k disk
     Fset406    if   e           k disk
     Fset412    if   e           k disk
     Fpahsbs    uf a e           k disk
     Fpahsva    uf a e           k disk
     Fpahsvd    uf a e           k disk
     Fpahssp    uf a e           k disk
     Fpahshe    if   e           k disk

      /copy './qcpybooks/sinest_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/svpsuc_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D SP0004          pr                  extpgm('SP0004')
     D t0vhmc                         3a   const
     D t0vhmo                         3a   const
     D t0vhcs                         3a   const
     D x2vehi                        40a
     D p@erro                         1a
     D p@vhmd                        15a
     D p@vhdm                        15a
     D p@vhds                        10a

     D request         ds                  likeds(wspmco_t)
     D peMsgs          ds                  likeds(paramMsgs)
     D pevalu          s           1024a
     d buffer          s            512a
     D options         s            100a
     D @repl           s          65535a
     D rc1             s             10i 0
     D existe          s              1n
     D x2vehi          s             40a
     D p@vhdm          s             15a
     D p@vhmd          s             15a
     D p@vhds          s             10a
     D p@erro          s              1a

     D k1hscd          ds                  likerec(p1hscd:*key)
     D k1het9          ds                  likerec(p1het9:*key)
     D k1het0          ds                  likerec(p1het0:*key)
     D k1t412          ds                  likerec(s1t412:*key)
     D k1hsbs          ds                  likerec(p1hsbs:*key)
     D k1hshe          ds                  likerec(p1hshe:*key)

     D k1hsva          ds                  likerec(p1hsva:*key)
     D k1hsvd          ds                  likerec(p1hsvd:*key)
     D k1hssp          ds                  likerec(p1hssp:*key)
     D k1t402          ds                  likerec(s1t402:*key)

     D PsDs           sds                  qualified
     D  CurUsr                       10a   overlay(psds:358)

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       *inlr = *on;

        options = 'doc=string path=marcarCobertura +
                   case=any allowextra=yes allowmissing=yes';

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

        if REST_getEnvVar('WSPMCO_BODY' : peValu );
           buffer = peValu;
           Qp0zDltEnv('WSPMCO_BODY');
         else;
           rc1= REST_readStdInput( %addr(buffer): %len(buffer) );
        endif;

        monitor;
          xml-into request %xml(buffer : options);
        on-error;
          @repl = 'wspcmo_t posta';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RPG0001'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl)) );
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
        endmon;

        request.empresa  = %xlate( min : may : request.empresa);
        request.sucursal = %xlate( min : may : request.sucursal);
        if SVPEMP_getDatosDeEmpresa( request.empresa : *omit ) = *off;
           %subst(@repl:1:1) = request.empresa;
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0113'
                             : peMsgs
                             : @repl
                             : %len(%trim(@repl)) );
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

        if SVPSUC_getDatosDeSucursal( request.empresa
                                    : request.sucursal
                                    : *omit            ) = *off;
           %subst(@repl:1:1) = request.empresa;
           %subst(@repl:2:2) = request.sucursal;
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0114'
                             : peMsgs
                             : @repl
                             : %len(%trim(@repl)) );
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

        k1hscd.cdempr = request.empresa;
        k1hscd.cdsucu = request.sucursal;
        k1hscd.cdrama = request.rama;
        k1hscd.cdsini = request.siniestro;
        k1hscd.cdnops = request.nroOperStro;
        chain %kds(k1hscd:5) pahscd;
        if not %found;
           %subst(@repl:1:2) = %editc(request.rama:'X');
           %subst(@repl:3:7) = %editc(request.siniestro:'X');
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN0001'
                             : peMsgs
                             : @repl
                             : %len(%trim(@repl)) );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'SIN0001'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;

        existe = *off;
        k1het9.t9empr = request.empresa;
        k1het9.t9sucu = request.sucursal;
        k1het9.t9arcd = cdarcd;
        k1het9.t9spol = cdspol;
        setll %kds(k1het9:4) pahet9;
        reade %kds(k1het9:4) pahet9;
        dow not %eof;
            if t9poco = request.componente;
               existe = *on;
               leave;
            endif;
         reade %kds(k1het9:4) pahet9;
        enddo;
        if existe = *off;
           %subst(@repl:1:6) = %editc(request.componente:'X');
           %subst(@repl:7:2) = %editc(cdrama:'X');
           %subst(@repl:9:7) = %editc(cdpoli:'X');
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'BIE0001'
                             : peMsgs
                             : @repl
                             : %len(%trim(@repl)) );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'BIE0001'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;

        k1het0.t0empr = request.empresa;
        k1het0.t0sucu = request.sucursal;
        k1het0.t0arcd = cdarcd;
        k1het0.t0spol = cdspol;
        k1het0.t0sspo = cdsspo;
        k1het0.t0rama = request.rama;
        k1het0.t0arse = cdarse;
        k1het0.t0oper = cdoper;
        k1het0.t0suop = cdsuop;
        k1het0.t0poco = request.componente;
        chain %kds(k1het0:10) pahet0;
        if not %found;
           %subst(@repl:1:6) = %editc(request.componente:'X');
           %subst(@repl:7:2) = %editc(cdrama:'X');
           %subst(@repl:9:7) = %editc(cdpoli:'X');
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'BIE0001'
                             : peMsgs
                             : @repl
                             : %len(%trim(@repl)) );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'BIE0001'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;

        if request.parentesco <> 1;
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN5000'
                             : peMsgs   );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'SIN5000'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;

        setll request.cobertura set409;
        if not %equal;
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN5001'
                             : peMsgs   );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'SIN5001'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;

        k1t412.t@cobl = t0cobl;
        k1t412.t@xcob = request.cobertura;
        chain %kds(k1t412:2) set412;
        if not %found;
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN5002'
                             : peMsgs   );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'SIN5002'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;

        if request.lesiones <> *blanks;
        setll request.lesiones set406;
        if not %equal;
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN5003'
                             : peMsgs   );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'SIN5003'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;
        endif;

        if request.lesiones <> *blanks and t@hecg <> '1' and
           t@hecg <> '2';
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN5004'
                             : peMsgs   );
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : 'SIN5004'
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
        endif;

        chain %kds(k1hscd:5) pahsbs;
        if %found;
           if bspoco <> request.componente;
              rc1= SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'SIN5005'
                                : peMsgs   );
              REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'SIN5005'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
              REST_end();
              SVPREST_end();
              return;
           endif;
        endif;

        k1hsbs.bsempr = request.empresa;
        k1hsbs.bssucu = request.sucursal;
        k1hsbs.bsrama = request.rama;
        k1hsbs.bssini = request.siniestro;
        k1hsbs.bsnops = request.nroOperStro;
        k1hsbs.bspoco = request.componente;
        k1hsbs.bspaco = request.parentesco;
        k1hsbs.bsriec = t0cobl;
        k1hsbs.bsxcob = request.cobertura;
        setll %kds(k1hsbs) pahsbs;
        if %equal;
              rc1= SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'SIN5006'
                                : peMsgs   );
              REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'SIN5006'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
              REST_end();
              SVPREST_end();
              return;
           endif;

        chain t0vhct set210;
        if not %found;
           ttvhte = *blanks;
        endif;

        if ttvhte = '06' or
           ttvhte = '10' or
           ttvhte = 'M1' or
           ttvhte = 'M2' or
           ttvhte = 'M3';
           setll request.alcance set403;
           if not %equal;
              rc1= SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'SIN5007'
                                : peMsgs   );
              REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'SIN5007'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
              REST_end();
              SVPREST_end();
              return;
           endif;
        endif;

        if ttvhte = 'M1' or
           ttvhte = 'M2' or
           ttvhte = 'M3';
           setll request.jurisNacional set404;
           if not %equal;
              rc1= SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'SIN5008'
                                : peMsgs   );
              REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'SIN5008'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
              REST_end();
              SVPREST_end();
              return;
           endif;
           setll request.tipoServicio set408;
           if not %equal;
              rc1= SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'SIN5009'
                                : peMsgs   );
              REST_writeHeader( 400
                              : *omit
                              : *omit
                              : 'SIN5009'
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
              REST_end();
              SVPREST_end();
              return;
           endif;
        endif;

        setgt  %kds(k1hscd:5) pahshe;
        readpe %kds(k1hscd:5) pahshe;
        if %eof;
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN5010'
                             : peMsgs   );
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

        k1t402.t@empr = request.empresa;
        k1t402.t@sucu = request.sucursal;
        k1t402.t@rama = request.rama;
        k1t402.t@cesi = hecesi;
        chain %kds(k1t402) set402;
        if not %found;
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN5010'
                             : peMsgs   );
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

        if t@cese = 'BA' or
           t@cese = 'TR' or
           t@cese = 'RC' or
           t@cese = 'BE' or
           t@cese = 'BC' or
           t@cese = 'BZ' or
           t@cese = 'BT' or
           t@cese = 'JC';
           rc1= SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'SIN5010'
                             : peMsgs   );
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

        //
        // Grabar PAHSVA
        //
        k1hsva.vaempr = request.empresa;
        k1hsva.vasucu = request.sucursal;
        k1hsva.varama = request.rama;
        k1hsva.vasini = request.siniestro;
        k1hsva.vanops = request.nroOperStro;
        k1hsva.vapoco = request.componente;
        k1hsva.vapaco = request.parentesco;
        k1hsva.vavhmc = t0vhmc;
        k1hsva.vavhmo = t0vhmo;
        k1hsva.vavhcs = t0vhcs;
        k1hsva.vapsec = 1;
        chain %kds(k1hsva) pahsva;
        if not %found;
           vaempr = request.empresa;
           vasucu = request.sucursal;
           varama = request.rama;
           vasini = request.siniestro;
           vanops = request.nroOperStro;
           vapoco = request.componente;
           vapaco = request.parentesco;
           vavhmc = t0vhmc;
           vavhmo = t0vhmo;
           vavhcs = t0vhcs;
           vapsec = 1;
           vavhcr = t0vhcr;
           vavhaÑ = t0vhaÑ;
           vavhni = t0vhni;
           vapatl = t0patl;
           vapatn = t0patn;
           vapanl = t0panl;
           vapann = t0pann;
           vatmat = t0tmat;
           vanmat = t0nmat;
           vamoto = t0moto;
           vachas = t0chas;
           vavhuv = t0vhuv;
           vavhct = t0vhct;
           vavhvu = t0vhvu;
           vavh0k = t0vh0k;
           vahecg = t@hecg;
           vatalc = request.alcance;
           vacjrs = request.jurisNacional;
           vavhts = request.tipoServicio;
           vactle = request.lesiones;
           vamar1 = *off;
           vamar2 = *off;
           vamar3 = *off;
           vamar4 = *off;
           vamar5 = *off;
           vauser = psDs.curusr;
           vatime = %dec(%time():*iso);
           vafera = *year;
           vaferm = *month;
           vaferd = *day;
           write p1hsva;
        endif;

        //
        // Grabar PAHSBS
        //
        SP0004( t0vhmc
              : t0vhmo
              : t0vhcs
              : x2vehi
              : p@erro
              : p@vhmd
              : p@vhdm
              : p@vhds );
        k1hsbs.bsempr = request.empresa;
        k1hsbs.bssucu = request.sucursal;
        k1hsbs.bsrama = request.rama;
        k1hsbs.bssini = request.siniestro;
        k1hsbs.bsnops = request.nroOperStro;
        k1hsbs.bspoco = request.componente;
        k1hsbs.bspaco = request.parentesco;
        k1hsbs.bsriec = t0cobl;
        k1hsbs.bsxcob = request.cobertura;
        setll %kds(k1hsbs) pahsbs;
        if not %equal;
           bsempr = request.empresa;
           bssucu = request.sucursal;
           bsrama = request.rama;
           bssini = request.siniestro;
           bsnops = request.nroOperStro;
           bspoco = request.componente;
           bspaco = request.parentesco;
           bsriec = t0cobl;
           bsxcob = request.cobertura;
           bsctle = request.lesiones;
           bsasen = cdasen;
           bssocn = cdsocn;
           bsarcd = cdarcd;
           bsspol = cdspol;
           bssspo = cdsspo;
           bsarse = cdarse;
           bsoper = cdoper;
           bssuop = cdsuop;
           bscert = *zeros;
           bspoli = cdpoli;
           bsagec = *zeros;
           bsnsag = *zeros;
           bsnrdf = *zeros;
           bsnomb = x2vehi;
           bstido = *zeros;
           bsnrdo = *zeros;
           bscuil = *zeros;
           bspinc = *zeros;
           bsjuin = *zeros;
           bsmar1 = 'N';
           bsmar2 = *on;
           bsmar3 = *off;
           bsmar4 = *off;
           bsmar5 = *off;
           bsstrg = *off;
           bsuser = psds.curusr;
           bstime = %dec(%time():*iso);
           bsfera = *year;
           bsferm = *month;
           bsferd = *day;
           write p1hsbs;
        endif;

        //
        // Grabar PAHSVD
        //
        setll %kds(k1hsbs:9) pahsvd;
        if not %equal;
           vdempr = request.empresa;
           vdsucu = request.sucursal;
           vdrama = request.rama;
           vdsini = request.siniestro;
           vdnops = request.nroOperStro;
           vdpoco = request.componente;
           vdpaco = request.parentesco;
           vdriec = t0cobl;
           vdxcob = request.cobertura;
           vdmar1 = *off;
           vdmar2 = *off;
           vdmar3 = *off;
           vdmar4 = *off;
           vdmar5 = *off;
           vduser = psds.curusr;
           vdtime = %dec(%time():*iso);
           vdfera = *year;
           vdferm = *month;
           vdferd = *day;
           write p1hsvd;
        endif;

        //
        // Grabar paso 5 en PAHSSP
        //
        k1hssp.spempr = request.empresa;
        k1hssp.spsucu = request.sucursal;
        k1hssp.sprama = request.rama;
        k1hssp.spsini = request.siniestro;
        k1hssp.spnops = request.nroOperStro;
        chain %kds(k1hssp:5) pahssp;
        if %found;
           spap05 = 1;
           update p1hssp;
        endif;

        REST_writeHeader( 201
                        : *omit
                        : *omit
                        : *omit
                        : *omit
                        : *omit
                        : *omit );

        REST_end();
        SVPREST_end();

        return;

