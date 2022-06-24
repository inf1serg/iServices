
     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR') debug(*yes)

      * ************************************************************ *
      * WSRAGU: Portal de Autogestión de Asegurados.                 *
      *         Actualiza datos del asegurado.                       *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               * 19-Set-2018 *
      * ------------------------------------------------------------ *
      *                                                              *
      * Se espera una estructura como la siguiente:                  *
      *                                                              *
      *  <asegurado>                                                 *
      *   <asen>9999999</asen>                                       *
      *   <cnac>999</cnac>                                           *
      *   <csex>9</csex>                                             *
      *   <njub>99999999999</njub>                                   *
      *   <cesc>9</cesc>                                             *
      *   <fnac>9999-99-99</fnac>                                    *
      *   <chij>99</chij>                                            *
      *   <cnes>9</cnes>                                             *
      *   <mfum>X</mfum>                                             *
      *   <raae>999</raae>                                           *
      *   <cprf>999</cprf>                                           *
      *   <hobb>XXXXX XXXXX XXXXX XXXXX</hobb>                       *
      *   <depo>                    _.                               *
      *     <cdep>999</cdep>         |-> Repetido de 0 a 999 veces   *
      *   </depo>                   _.                               *
      *   <mail>                    _.                               *
      *     <ctce>99</ctce>          |                               *
      *     <mail>xx@xx.com</mail>   |-> Repetido de 0 a 10 veces    *
      *   </mail>                   _.                               *
      *   <tele>                    _.                               *
      *    <tipo>X</tipo>            |                               *
      *    <numero>99999999</numero> |-> Repetido de 0 a 3 veces     *
      *   </tele>                   _.                               *
      *  </asegurado>                                                *
      *                                                              *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SGF 13/06/2019: El mail del asegurado es sólo PARTICULAR.    *
      * SGF 19/06/2019: Acomodo marca de fumador.                    *
      *                                                              *
      * ************************************************************ *

     fsehase    if   e           k disk
     fgnhdaf    uf   e           k disk
     fgnhda1    uf   e           k disk
     fgnhdad    uf   e           k disk
     fgnhda6    uf   e           k disk
     fgnhda7    uf a e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy inf1giov/qcpybooks,spwliblc_h

     d WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     d  msg                         512a   const

     d sleep           pr            10u 0 extproc('sleep')
     d  secs                         10u 0 value

      * ------------------------------------------------------------ *
      * URL y URI
      * ------------------------------------------------------------ *
     d uri             s            512a
     d url             s           3000a   varying

      * ------------------------------------------------------------ *
      * Parámetros de URL
      * ------------------------------------------------------------ *
     d buffer          s          65535a
     d buflen          s             10i 0
     d rc              s             10i 0
     d rc1             s               n
     d fd              s             10i 0
     d peValu          s           1024a

     d psds           sds                  qualified
     d  this                         10a   overlay(psds:1)
     d  job                          26a   overlay(psds:244)
     d  CurUsr                       10a   overlay(PsDs:358)

      * ------------------------------------------------------------ *
      * Asegurado_t: Estructura de Asegurado                         *
      *                                                              *
      *            asen = Código de Asegurado                        *
      *            cnac = Código de Nacionalidad                     *
      *            csex = Código de Sexo                             *
      *            njub = CUIL                                       *
      *            cesc = Código de Estado Civil                     *
      *            fnac = Fecha de Nacimiento (aaaa-mm-dd)           *
      *            chij = Cantidad de hijos                          *
      *            cnes = Código de Nivel de Estudios                *
      *            mfum = Marca de Fumador (0=No/1=Si)               *
      *            raae = Código de Rama de Actividad Económica      *
      *            cprf = Código de Profesión                        *
      *            hobb = Hobbies                                    *
      *            depo = Deportes que practica                      *
      *            mail = Emails de la persona                       *
      *            tele = Teléfonos de la persona                    *
      *                                                              *
      * ------------------------------------------------------------ *
     d asegurado_t     ds                  qualified based(template)
     d  tdoc                          2  0
     d  ndoc                          8  0
     d  asen                          7  0
     d  cnac                          3  0
     d  csex                          1  0
     d  njub                         11  0
     d  cesc                          1  0
     d  fnac                         10a
     d  chij                          2  0
     d  cnes                          1  0
     d  mfum                          1a
     d  raae                          3  0
     d  cprf                          3  0
     d  hobb                        500a
     d  depo                               likeds(deportes_t)
     d  emai                               likeds(emails_t)
     d  tele                               likeds(telefonos_t)
      * ------------------------------------------------------------ *
      * deportes_t: Estructura de deportes que practica la persona   *
      *            cdep = Código de Deporte                          *
      * ------------------------------------------------------------ *
     d deportes_t      ds                  qualified based(template)
     d  deporte                            likeds(deporte_t) dim(999)

     d deporte_t       ds                  qualified based(template)
     d  cdep                          3  0
      * ------------------------------------------------------------ *
      * emails_t:   Estructura de emails de la persona               *
      *             ctce = Código de tipo de mail                    *
      *             mail = Dirección de mail                         *
      * ------------------------------------------------------------ *
     d emails_t        ds                  qualified based(template)
     d  email                              likeds(email_t) dim(10)

     d email_t         ds                  qualified based(template)
     d  ctce                          2  0
     d  mail                         50a
      * ------------------------------------------------------------ *
      * telefonos_t: Estructura de telefonos de la persona           *
      *              tipo = "P"=Particular/"C"=Celular/"L"=Laboral   *
      *              numero = Número de teléfono                     *
      * ------------------------------------------------------------ *
     d telefonos_t     ds                  qualified based(template)
     d  telefono                           likeds(telefono_t) dim(3)

     d telefono_t      ds                  qualified based(template)
     d  tipo                          1a
     d  numero                       20a

     d asegurado       ds                  likeds(asegurado_t) inz
     d options         s            100a
     d peMsgs          ds                  likeds(paramMsgs)
     d @@Tdoc          s              2
     d @@Ndoc          s             11

     d lda             ds                  qualified dtaara(*lda)
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

     d @@Nrdf          s                   like(dfnrdf)
     d Idx             s                   like(dfnrdf)

     d k1hda7          ds                  likerec(g1hda7:*key)

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

        *inlr = *on;

        options = 'doc=string path=asegurado +
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
           close *all;
           return;
        endif;

        rc = REST_readStdInput( %addr(buffer): %len(buffer) );

        monitor;
            xml-into asegurado %xml( buffer : options);
         on-error;
            REST_writeHeader( 204
                            : *omit
                            : *omit
                            : 'RPG0000'
                            : 40
                            : 'Error al parsear XML'
                            : 'Error al parsear XML' );
            REST_end();
            close *all;
            return;
        endmon;

        @@Tdoc = %trim(%editw(asegurado.tdoc:'  '));
        @@Ndoc = %trim(%editw(asegurado.ndoc:'        '));

        clear @@Nrdf;
        if SVPREST_chkCliente( lda.empr
                             : lda.sucu
                             : @@Tdoc
                             : @@Ndoc
                             : peMsgs
                             : @@Nrdf ) = *off;
           rc1 = REST_writeHeader( 204
                                 : *omit
                                 : *omit
                                 : peMsgs.peMsid
                                 : peMsgs.peMsev
                                 : peMsgs.peMsg1
                                 : peMsgs.peMsg2   );
           REST_end();
           close *all;
           return;
        endif;

        rc1 = COWLOG_logConAutoGestion( lda.empr
                                      : lda.sucu
                                      : asegurado.tdoc
                                      : asegurado.ndoc
                                      : psds.this);

        // Update de asegurado
        setll asegurado.asen sehase;
        if not %equal;
           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : 'AGA0008'
                           : 40
                           : 'Asegurado no existe'
                           : 'Asegurado no existe' );
           REST_end();
           close *all;
           return;
        endif;

        chain asegurado.asen gnhdaf;
        if %found(gnhdaf);
           dfnjub = asegurado.njub;
           update g1hdaf;
        endif;

        if asegurado.mfum = 'S' or asegurado.mfum = 's';
           asegurado.mfum = '1';
         else;
           asegurado.mfum = '0';
        endif;

        chain asegurado.asen gnhda1;
        if %found(gnhda1);
           dfcnac = asegurado.cnac;
           dfsexo = asegurado.csex;
           dfesci = asegurado.cesc;
           dffnaa = %dec(%subst(asegurado.fnac:1:4):4:0);
           dffnam = %dec(%subst(asegurado.fnac:6:2):2:0);
           dffnad = %dec(%subst(asegurado.fnac:9:2):2:0);
           dfchij = asegurado.chij;
           dfcnes = asegurado.cnes;
           dfmfum = asegurado.mfum;
           dfraae = asegurado.raae;
           dfcprf = asegurado.cprf;
           update g1hda1;
        endif;

        *in99 = *on;
        for Idx = 1 to 999;
          if asegurado.depo.deporte(Idx).cdep > *zeros;
            if *in99 = *on;
              setll asegurado.asen gnhdad;
              dou %eof(gnhdad);
                reade asegurado.asen gnhdad;
                if not %eof(gnhdad);
                  delete g1hdad;
                endif;
              enddo;
              *in99 = *off;
            endif;

            rc1 = SVPDAF_setGnhDad( asegurado.asen
                                  : asegurado.depo.deporte(Idx).cdep );

          endif;
        endfor;

        // -----------------------------------------------
        // Mail: sólo el primero y que sea particular
        // -----------------------------------------------
        if asegurado.emai.email(1).mail <> *blanks and
           asegurado.emai.email(1).ctce > *zeros;
          if asegurado.emai.email(1).ctce = 1;
             clear k1hda7;
             k1hda7.dfnrdf = asegurado.asen;
             k1hda7.dfctce = asegurado.emai.email(1).ctce;
             setll %kds(k1hda7:2) gnhda7;
             reade %kds(k1hda7:2) gnhda7;
             dow not %eof;
                 if dfctce = 1;
                    delete g1hda7;
                 endif;
              reade %kds(k1hda7:2) gnhda7;
             enddo;
             k1hda7.dfmail = %xlate(may:min:asegurado.emai.email(1).mail);
             setll %kds(k1hda7:3) gnhda7;
             if not %equal;
                dfnrdf = asegurado.asen;
                dfmail = %xlate(may:min:asegurado.emai.email(1).mail);
                dfctce = asegurado.emai.email(1).ctce;
                dfmar1 = '0';
                dfmar2 = '0';
                dfmar3 = '0';
                dfmar4 = '0';
                dfmar5 = '0';
                dfmar6 = '0';
                dfmar7 = '0';
                dfmar8 = '0';
                dfmar9 = '0';
                dfmar0 = '0';
                dfuser = psds.CurUsr;
                dfdate = %dec(%date():*ymd);
                dftime = %dec(%time():*iso);
                write g1hda7;
             endif;
          endif;
        endif;

        chain asegurado.asen gnhda6;
        if %found(gnhda6);

          for Idx = 1 to 3;

            if asegurado.tele.telefono(Idx).tipo <> *blanks and
               asegurado.tele.telefono(Idx).numero <> *blanks;

              select;
              when asegurado.tele.telefono(Idx).tipo = 'P';
                dftel2 = %trim(asegurado.tele.telefono(Idx).numero);

              when asegurado.tele.telefono(Idx).tipo = 'C';
                dftel6 = %trim(asegurado.tele.telefono(Idx).numero);

              endsl;

              dfuser = psds.CurUsr;
              dfdate = %dec(%date():*ymd);
              dftime = %dec(%time():*iso);

            endif;
          endfor;

          update g1hda6;
        endif;

        REST_writeHeader();
        REST_writeEncoding();
        REST_writeXmlLine('resultado':'OK');

        REST_end();
        close *all;
        return;

      /end-free

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/getsysv_h.rpgle'

