     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt)
     H bnddir('HDIILE/HDIBDIR')
     *****************************************************************
     *  COW00012: Consulta General de Cotizaciones Prima/Premio      *
     *            y Ejecución para Emitir Póliza.                    *
     *                                                               *
     *  Jennifer Segovia                            *21/05/2019      *
     *                                                               *
     *****************************************************************
     * Modificaciones:                                               *
     *****************************************************************
     Fcow00012m cf   e             workstn
     Fctw000    if   e           k disk
     Fctw001    if   e           k disk
     Fctw001c   if   e           k disk
     Fpahfv1d   uf   e           k disk
     Fpahfv1    uf   e           k disk
     *****************************************************************
     D COW00012        pr                  EXTPGM('COW00012')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peAsen                        7  0 const
     D  peNres                        7  0 const
     D  peAcci                        1    const

     D COW00012        pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peAsen                        7  0 const
     D  peNres                        7  0 const
     D  peAcci                        1    const

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D PRWASE8         pr                  ExtPgm('PRWASE8')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNomb                      40a     const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaco_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t) const
     D   peAgpe                       1a   const
     D   peTarc                            likeds(prwaseTarc_t) const
     D   peNcbu                      22  0   const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWBIEN15       pr                  ExtPgm('PRWBIEN15')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   pePate                      25a   const
     D   peChas                      25a   const
     D   peMoto                      25a   const
     D   peAver                       1a   const
     D   peNmer                      40a   const
     D   peAcrc                       7  0 const
     D   peRuta                      16  0 const
     D   peCesv                       1a   const
     D   peIris                       1a   const
     D   peVhuv                       2  0 const
     D   peInsp                            likeds(prwbienInsp_t2) const
     D   peRast                            likeds(prwbienRast_t ) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWSND4         pr                  ExtPgm('PRWSND4')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peNuse                      50    const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PAR631X         pr                  ExtPgm('PAR631X')
     D  peBase                             likeds(paramBase) const
     D  peAsen                        7  0 const
     D  peNres                        7  0 const

     D @@Year          s              4  0
     D @@Month         s              2  0
     D @@Day           s              2  0
     D @@Ffta          s              4  0
     D @@Fftm          s              2  0

     D p@Nomb          ds                  likeDs(dsNomb_t)
     D p@Domi          ds                  likeDs(dsDomi_t)
     D p@Docu          ds                  likeDs(dsDocu_t)
     D peCont          ds                  likeDs(dsCont_t)
     D p@Naci          ds                  likeDs(dsNaci_t)
     D peMarc          ds                  likeDs(dsMarc_t)
     D p@CbuS          ds                  likeDs(dsCbuS_t)
     D peDape          ds                  likeDs(dsDape_t)
     D peClav          ds                  likeDs(dsClav_t)
     D peText          s             79    dim(999)
     D peTextC         s             10i 0
     D peProv          ds                  likeDs(dsProI_t) dim(999)
     D peProvC         s             10i 0
     D p@Mail          ds                  likeds(Mailaddr_t) dim(100)
     D p@MailC         s             10i 0
     D peNomb          s             40a
     D peDomi          ds                  likeds(prwaseDomi_t)
     D peDocu          ds                  likeds(prwaseDocu_t)
     D peNtel          ds                  likeds(prwaseTele_t)
     D peTiso          s              2  0
     D peNaci          ds                  likeds(prwaseNaco_t)
     D peCprf          s              3  0
     D peSexo          s              1  0
     D peEsci          s              1  0
     D peRaae          s              3  0
     D peMail          ds                  likeds(prwaseEmail_t)
     D peAgpe          s              1a
     D peTarc          ds                  likeds(prwaseTarc_t)
     D peNcbu          s             22  0
     D peCbus          s             22  0
     D peCiva          s              2  0
     D peInsc          ds                  likeds(prwaseInsc_t)
     D peArse          s              2  0 inz(1)
     D peAver          s              1a   inz('N')
     D peNmer          s             40a
     D peAcrc          s              7  0 inz(0)
     D peRuta          s             16  0 inz(0)
     D peCesv          s              1a   inz('S')
     D peIris          s              1a   inz('S')
     D peErro          s             10i 0
     D peNuse          s             50
     D peFdes          s              8  0
     D peFhas          s              8  0
     D peSoln          s              7  0
     D peMsgs          ds                  likeds(paramMsgs)
     D peInsp          ds                  likeds(prwbienInsp_t2)
     D peRast          ds                  likeds(prwbienRast_t )

     D k1y000          ds                  likerec(c1w000:*key)
     D k1y001          ds                  likerec(c1w001:*key)
     D k1yfv1          ds                  likerec(p1hfv1:*key)
     D k1y001c         ds                  likerec(c1w001c:*key)
     D k1yfv1d         ds                  likerec(p1hfv1d:*key)

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)
     *****************************************************************
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/prwbien_h.rpgle'
      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/spvtcr_h.rpgle'
     *****************************************************************

      /free

        *inlr = *on;

        if peAcci = '5';
          *in41 = *on;
        endif;

        xxNivt = peBase.peNivt;
        xxNivc = peBase.peNivc;
        xxNctw = peNctw;
        xxNomb = SVPINT_GetNombre( peBase.peEmpr
                                 : peBase.peSucu
                                 : peBase.peNivt
                                 : peBase.peNivc );

        k1y000.w0Empr = peBase.peEmpr;
        k1y000.w0Sucu = peBase.peSucu;
        k1y000.w0Nivt = peBase.peNivt;
        k1y000.w0Nivc = peBase.peNivc;
        k1y000.w0Nctw = peNctw;
        chain %kds( k1y000 : 5 ) ctw000;
        if %found( ctw000 );
          xxarcd = w0arcd;
          xxspol = w0spol;

          k1y001.w1Empr = peBase.peEmpr;
          k1y001.w1Sucu = peBase.peSucu;
          k1y001.w1Nivt = peBase.peNivt;
          k1y001.w1Nivc = peBase.peNivc;
          k1y001.w1Nctw = peNctw;
          k1y001.w1Rama = peRama;
          chain %kds( k1y001 : 6 ) ctw001;
          if %found( ctw001 );

            k1y001c.w1Empr = peBase.peEmpr;
            k1y001c.w1Sucu = peBase.peSucu;
            k1y001c.w1Nivt = peBase.peNivt;
            k1y001c.w1Nivc = peBase.peNivc;
            k1y001c.w1Nctw = peNctw;
            chain %kds( k1y001c : 5 ) ctw001c;
1b        if %found( ctw001c );
2b          dow not *inkc;
                exsr borr01;
                exsr carg01;
                exfmt cow01201;
3b            select;
3x              when *inka;
                    exsr chkDatosEmi;
                    if x1Erro = *blanks;
                      exsr Emitir;
                      *inkc = *on;
                    else;
                      exfmt cow012ER;
                      exsr ActualCabec;
                      clear x1Erro;
                    endif;
                    *inka = *off;
3x              when *inkb;
                    exsr ActualCabec;
                    PAR631X( peBase
                           : peAsen
                           : peNres );
                    *inkb = *off;
                    x1Erro = 'Reporte Enviado al Correo Electronico';
                    exfmt cow012ER;
                    clear x1Erro;
3e            endsl;
2e          enddo;
1e        endif;
          endif;
        endif;

        return;

      /end-free

     * ------------------------------------------------------------- *
     * Borr01 : Borra Campos de Pantalla.                            *
     * ------------------------------------------------------------- *
       Begsr borr01;

          clear x1Prim;
          clear x1Bpri;
          clear x1Neto;
          clear x1Read;
          clear x1Refi;
          clear x1Dere;
          clear x1Ipr2;
          clear x1Ipr5;
          clear x1Seri;
          clear x1Seem;
          clear x1Impi;
          clear x1Sers;
          clear x1Tssn;
          clear x1Ipr1;
          clear x1Ipr3;
          clear x1Ipr4;
          clear x1Ipr6;
          clear x1Ipr7;
          clear x1Ipr8;
          clear x1Ipr9;
          clear x1Subt;
          clear x1Prem;
          clear xxPrem;
          clear xxIpr9;
          clear x1Bpip;
          clear x1Xref;
          clear x1Xrea;
          clear x1Bpep;
          clear x1Pivi;
          clear x1Pivn;
          clear x1Pivr;
          clear x1Pimi;
          clear x1Psso;
          clear x1Pssn;
          clear x1paga;
          clear x1sald;
          clear xxcome;
          clear xxmone;

       endsr;

     * ------------------------------------------------------------- *
     * Carg01 : Carga Pantalla.                                      *
     * ------------------------------------------------------------- *
       begsr carg01;

          x1Prim = COWGRAI_getPrimaRamaArse( peBase
                                           : peNctw
                                           : peRama );
          x1Bpri = *Zeros;
          x1Neto = x1Prim - x1Bpri;
          x1Read = w1Read;
          x1Refi = w1Refi;
          x1Dere = w1Dere;
          x1Ipr2 = w1Ipr2;
          x1Ipr5 = w1Ipr5;
          x1Bpip = *Zeros;
          x1Xrea = w1Xrea;
          x1Xref = w1Xref;
          x1Bpep = *Zeros;
          x1Subt = x1Read + x1Neto;
          x1Subt += x1Refi;
          x1Subt += x1Dere;
          x1Seri = w1Seri;
          x1Seem = w1Seem;
          x1Impi = w1Impi;
          x1Sers = w1Sers;
          x1Tssn = w1Tssn;
          x1Pimi = w1Pimi;
          x1Psso = w1Psso;
          x1Pssn = w1Pssn;
          x1Ipr1 = w1Ipr1;
          x1Ipr3 = w1Ipr3;
          x1Ipr4 = w1Ipr4;
          x1Pivi = w1Pivi;
          x1Pivn = w1Pivn;
          x1Pivr = w1Pivr;
          x1Ipr6 = w1Ipr6;
          x1Ipr7 = w1Ipr7;
          x1Ipr8 = w1Ipr8;
          x1Ipr9 = w1Ipr9;
          x1Prem = w1Prem;
          xxMone = w0Mone;
          xxCome = w0Come;

       endsr;

     * ------------------------------------------------------------- *
     * Emitir: Emitir Cotización.                                    *
     * ------------------------------------------------------------- *
       begsr emitir;

          clear peInsp;
          clear peRast;
          clear peErro;
          clear peMsgs;

          PAR310X3( peBase.peEmpr : @@year : @@Month : @@Day);
          peFdes = (@@Year * 10000)
                 + (@@Month *  100)
                 +  @@Day;

          peInsp.Tipo = 'Inspector';
          peInsp.Ntel = '11111';
          peInsp.Nte1 = '11111';
          peInsp.Fins = peFdes;

          exsr BuscarDatosCli;

          PRWASE8( peBase
                 : peNctw
                 : peAsen
                 : peNomb
                 : peDomi
                 : peDocu
                 : peNtel
                 : peTiso
                 : peNaci
                 : peCprf
                 : peSexo
                 : peEsci
                 : peRaae
                 : peMail
                 : peAgpe
                 : peTarc
                 : peNcbu
                 : peCbus
                 : peRuta
                 : peCiva
                 : peInsc
                 : peErro
                 : peMsgs );

          if peErro = *zeros;

            peNmer = SVPDAF_getNombre( peAsen );
            peNuse = @PsDs.CurUsr;

            k1yfv1d.fdAsen = peAsen;
            k1yfv1d.fdNres = peNres;
            setll %kds( k1yfv1d : 2 ) pahfv1d;
            reade %kds( k1yfv1d : 2 ) pahfv1d;
            dow not %eof( pahfv1d );

              PRWBIEN15( peBase
                       : peNctw
                       : peRama
                       : peArse
                       : fdNror
                       : fdNmat
                       : fdChas
                       : fdMoto
                       : peAver
                       : peNmer
                       : peAcrc
                       : peRuta
                       : peCesv
                       : peIris
                       : fdVhuv
                       : peInsp
                       : peRast
                       : peErro
                       : peMsgs );

              if peErro <> *zeros;
                exsr MuestraError;
                exsr ActualCabec;
                leave;
              endif;

              reade %kds( k1yfv1d : 2 ) pahfv1d;

            enddo;

            if peErro = *zeros;

              PRWSND4( peBase
                     : peNctw
                     : peFdes
                     : peNuse
                     : peFhas
                     : peSoln
                     : peErro
                     : peMsgs );

              if peErro = *zeros;
                *in41 = *on;
                x1Erro = 'Cotización Nro. ' + %char(peNctw) +
                         ' Exitosa. Nro. Propuesta Asignada ' +
                         %char(peSoln);
                exfmt cow012ER;
                clear x1Erro;
              else;
                exsr MuestraError;
                exsr ActualCabec;
              endif;

            endif;

          else;
            exsr MuestraError;
            exsr ActualCabec;
          endif;

       endsr;

     * ------------------------------------------------------------- *
     * BuscarDatosCli : Buscar Datos del Cliente.                    *
     * ------------------------------------------------------------- *
       begsr BuscarDatosCli;

         exsr LimpiaEstr;

         if SVPDAF_getDatoFiliatorio( peAsen
                                    : p@Nomb
                                    : p@Domi
                                    : p@Docu
                                    : peCont
                                    : p@Naci
                                    : peMarc
                                    : p@CbuS
                                    : peDape
                                    : peClav
                                    : peText
                                    : peTextC
                                    : peProv
                                    : peProvC
                                    : p@Mail
                                    : p@MailC );

           peNomb = p@Nomb.Nomb;

           peDomi.Domi = p@Domi.Domi;
           peDomi.Copo = p@Domi.Copo;
           peDomi.Cops = p@Domi.Cops;

           peTiso = p@Docu.Tiso;

           peDocu.Tido = p@Docu.Tido;
           peDocu.Nrdo = p@Docu.Nrdo;

           if p@Docu.Cuit <> *blanks;
             peDocu.Cuit = %dec(p@Docu.Cuit:11:0);
           endif;

           peDocu.Cuil = p@Docu.Cuil;

           peNtel.Nte1 = peCont.Tpa1;
           peNtel.Nte2 = peCont.Ttr1;
           peNtel.Nte3 = peCont.Tcel;
           peNtel.Nte4 = peCont.Tpag;
           peNtel.Pweb = peCont.Pweb;

           peNaci.Fnac = p@Naci.Fnac;
           peNaci.Lnac = p@Naci.Lnac;
           peNaci.Pain = p@Naci.Pain;
           peNaci.Cnac = p@Naci.Cnac;

           peCprf = peDape.Cprf;
           peSexo = peDape.Sexo;
           peEsci = peDape.Esci;
           peRaae = peDape.Raae;

           peMail.Ctce = p@Mail(1).Tipo;
           peMail.Mail = p@Mail(1).Mail;

           k1yfv1.fvAsen = peAsen;
           k1yfv1.fvNres = peNres;
           chain(n) %kds( k1yfv1 : 2 ) pahfv1;
           if %found( pahfv1 );

             peTarc.Ctcu = fvCtcu;
             peTarc.Nrtc = fvNrtc;

             if SPVTCR_fechaVencimientoTcr( peAsen
                                          : fvCtcu
                                          : fvNrtc
                                          : @@Ffta
                                          : @@Fftm );

               peTarc.Ffta = @@Ffta;
               peTarc.Fftm = @@Fftm;

             endif;

           endif;

           if p@Cbus.Ncbu <> *blanks;
             peNcbu = %dec(p@Cbus.Ncbu:22:0);
           endif;

           peCiva = SVPASE_getIva( peAsen );

         endif;

       endsr;

     * ------------------------------------------------------------- *
     * LimpiaEstr: Limpia Estructuras de Asegurado PRWASE y SVPDAF.  *
     * ------------------------------------------------------------- *
       begsr LimpiaEstr;

         clear peDomi;
         clear peDocu;
         clear peNtel;
         clear peNaci;
         clear peMail;
         clear peTarc;
         clear peInsc;
         clear p@Nomb;
         clear p@Domi;
         clear p@Docu;
         clear peCont;
         clear p@Naci;
         clear peMarc;
         clear peCbuS;
         clear peDape;
         clear peClav;
         clear peText;
         clear peTextC;
         clear peProv;
         clear peProvC;
         clear p@Mail;
         clear p@MailC;

       endsr;

     * ------------------------------------------------------------- *
     * ActualCabec : Actualiza el Estado del Archivo Cabecera PAHFV1 *
     * ------------------------------------------------------------- *
       begsr ActualCabec;

         k1yfv1.fvAsen = peAsen;
         k1yfv1.fvNres = peNres;
         chain %kds( k1yfv1 : 2 ) pahfv1;
         if %found( pahfv1 );
           fvPrem = x1Prem;
           fvXref = x1Xref;
           fvRefi = x1Refi;
           fvSeri = x1Seri;
           fvSeem = x1Seem;
           fvPivi = x1Pivi;
           fvIpr1 = x1Ipr1;
           fvPivn = x1Pivn;
           fvIpr4 = x1Ipr4;
           fvPivr = x1Pivr;
           fvIpr3 = x1Ipr3;
           fvIpr6 = x1Ipr6;
           fvIpr7 = x1Ipr7;
           fvIpr8 = x1Ipr8;
           fvDere = x1Dere;
           fvfctw = w0fctw;
           if *inkb;
             fvEsta = *blanks;
           else;
             if peErro <> *zeros or x1Erro <> *blanks;
               fvEsta = 'ERROR VALIDACI.';
             endif;
           endif;
           update p1hfv1;
         endif;

       endsr;

     * ------------------------------------------------------------- *
     * MuestraError : Muestra Mensaje de Error.                      *
     * ------------------------------------------------------------- *
       begsr MuestraError;

         x1Erro = %trim(peMsgs.peMsg1);
         exfmt cow012er;
         clear x1Erro;
         *in01 = *off;

       endsr;

     * ------------------------------------------------------------- *
     * chkDatosEmi : Chequea que los datos de Patente, Motor y cha-  *
     *               sis estén cargado para realizar la emisión.     *
     * ------------------------------------------------------------- *
       begsr chkDatosEmi;

         k1yfv1d.fdAsen = peAsen;
         k1yfv1d.fdNres = peNres;
         setll    %kds( k1yfv1d : 2 ) pahfv1d;
         reade(n) %kds( k1yfv1d : 2 ) pahfv1d;
         dow not %eof( pahfv1d );

           select;
             when fdNmat = *blanks;
               x1Erro = 'Falta Patente en el vehiculo : ' + %char(fdNror);
               leave;
             when fdMoto = *blanks;
               x1Erro = 'Falta Motor en el vehiculo : ' + %char(fdNror);
               leave;
             when fdChas = *blanks;
               x1Erro = 'Falta Chasis en el vehiculo : ' + %char(fdNror);
               leave;
           endsl;

           reade(n) %kds( k1yfv1d : 2 ) pahfv1d;

         enddo;

       endsr;

     ******************************************************
