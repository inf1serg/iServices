     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPASE: Programa de Servicio.                                *
      *         Asegurados.                                          *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                     27-Ene-2015             *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * LRG 24/05/2016 - Agrego servicio getBloqueoActual            *
      * GIO 01/12/2017 Agregado de Nuevos procedimientos:            *
      *                - SVPASE_getAsegurado                         *
      *                - SVPASE_getProductorAsegurado                *
      * GIO 16/07/2018 RM#00728 Chequeo de Asegurado                 *
      *                Agregado de Nuevo procedimiento:              *
      *                - SVPASE_isAseguradoHdi                       *
      * GIO 20/09/2018 RM#03885 Autogestion Procesos Backend         *
      *                Cambio Tipo Documento (tdoc) a 98             *
      * JSN 14/06/2021 Se agrega el procedimiento: _getSehase01      *
      *     28/07/2021 Se agrega el procedimiento: _isAseguradoBco   *
      * ************************************************************ *
     Fsehase    if   e           k disk    usropn
     Fsehase01  if   e           k disk    usropn
     Fsehasl    if   e           k disk    usropn
     Fgnhdaf    if   e           k disk    usropn
     Fgnhda1    if   e           k disk    usropn
     Fgnhdaf05  if   e           k disk    usropn
     Fgnhdaf06  if   e           k disk    usropn
     Fsahint    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpase_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- PR Externos --------------------------------------------- *

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPASE_chkASE(): Valida si existe Asegurado                  *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPASE_chkAse...
     P                 B                   export
     D SVPASE_chkAse...
     D                 pi              n
     D   peAsen                       7  0 const

      /free

       SVPASE_inz();

       setll peAsen sehase;

       if not %equal(sehase);
         SetError( SVPASE_ASEIN
                 : 'Asegurado Inexistente' );
         return *Off;
       endif;

       return *On;

      /end-free

     P SVPASE_chkAse...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getIva(): Retorna Codigo de IVA de Asegurado          *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Codigo de IVA                                       *
      * ------------------------------------------------------------ *

     P SVPASE_getIva...
     P                 B                   export
     D SVPASE_getIva...
     D                 pi             2  0
     D   peAsen                       7  0 const

      /free

       SVPASE_inz();

       chain peAsen sehase;

       return asciva;

      /end-free

     P SVPASE_getIva...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getTipoSociedad(): Retorna Tipo de Sociedad Asegurad  *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Tipo de Sociedad                                    *
      * ------------------------------------------------------------ *

     P SVPASE_getTipoSociedad...
     P                 B                   export
     D SVPASE_getTipoSociedad...
     D                 pi             2  0
     D   peAsen                       7  0 const

      /free

       SVPASE_inz();

       chain peAsen gnhdaf;

       return dftiso;

      /end-free

     P SVPASE_getTipoSociedad...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getCodBloqueo(): Retorna Cod de Bloqueo Asegurado     *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Codigo de Bloqueo                                   *
      * ------------------------------------------------------------ *

     P SVPASE_getCodBloqueo...
     P                 B                   export
     D SVPASE_getCodBloqueo...
     D                 pi             1
     D   peAsen                       7  0 const

      /free

       SVPASE_inz();

       chain peAsen sehase;

       return asbloq;

      /end-free

     P SVPASE_getCodBloqueo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getCuit(): Retorna CUIT de Asegurado                  *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: CUIT                                                *
      * ------------------------------------------------------------ *

     P SVPASE_getCuit...
     P                 B                   export
     D SVPASE_getCuit...
     D                 pi            11
     D   peAsen                       7  0 const

      /free

       SVPASE_inz();

       chain peAsen sehase01;

       return dfcuit;

      /end-free

     P SVPASE_getCuit...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getTipoDoc(): Retorna Tipo de Documento               *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Tipo de Documento                                   *
      * ------------------------------------------------------------ *

     P SVPASE_getTipoDoc...
     P                 B                   export
     D SVPASE_getTipoDoc...
     D                 pi             2  0
     D   peAsen                       7  0 const

      /free

       SVPASE_inz();

       chain peAsen sehase01;

       return dftido;

      /end-free

     P SVPASE_getTipoDoc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getNroDoc(): Retorna Nro de Documento                 *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Tipo de Documento                                   *
      * ------------------------------------------------------------ *

     P SVPASE_getNroDoc...
     P                 B                   export
     D SVPASE_getNroDoc...
     D                 pi             8  0
     D   peAsen                       7  0 const

      /free

       SVPASE_inz();

       chain peAsen sehase01;

       return dfnrdo;

      /end-free

     P SVPASE_getNroDoc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getFecNac(): Retorna Fecha de Nacimiento              *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Fecha de Nacimiento (AAAAMMDD)                      *
      * ------------------------------------------------------------ *

     P SVPASE_getFecNac...
     P                 B                   export
     D SVPASE_getFecNac...
     D                 pi             8  0
     D   peAsen                       7  0 const

      /free

       SVPASE_inz();

       chain peAsen gnhda1;

       return dffnaa*10000 + dffnam*100 + dffnad;

      /end-free

     P SVPASE_getFecNac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getNombre(): Retorna Nombre de Asegurado              *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: Nombre                                              *
      * ------------------------------------------------------------ *

     P SVPASE_getNombre...
     P                 B                   export
     D SVPASE_getNombre...
     D                 pi            40
     D   peAsen                       7  0 const

      /free

       SVPASE_inz();

       chain peAsen sehase01;

       return dfnomb;

      /end-free

     P SVPASE_getNombre...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getBloqueoActual: Retorna Codigo y Motivo de Bloqueo  *
      *                                    Actual                    *
      *     peAsen   (input)   Asegurado                             *
      *     peBloq   (output)  Código de Bloqueo Actual              *
      *     peMota   (output)  Motivo de Bloqueo Actual              *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPASE_getBloqueoActual...
     P                 B                   export
     D SVPASE_getBloqueoActual...
     D                 pi              n
     D   peAsen                       7  0 const
     D   peBloq                       1
     D   peMota                      50

      /free

       SVPASE_inz();

       setgt peAsen sehasl;
       if not %equal( sehasl );
         return *off;
       endif;
       readpe peAsen sehasl;
       if not %eof( sehasl );
          peBloq = slbloa;
          peMota = slmota;
       endif;
       return *on;

     P SVPASE_getBloqueoActual...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPASE_inz      B                   export
     D SVPASE_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(sehase);
         open sehase;
       endif;

       if not %open(sehase01);
         open sehase01;
       endif;

       if not %open(gnhdaf);
         open gnhdaf;
       endif;

       if not %open(gnhda1);
         open gnhda1;
       endif;

       if not %open(sehasl);
         open sehasl;
       endif;

       if not %open(gnhdaf05);
         open gnhdaf05;
       endif;

       if not %open(gnhdaf06);
         open gnhdaf06;
       endif;

       if not %open(sahint);
         open sahint;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPASE_inz      E

      * ------------------------------------------------------------ *
      * SVPASE_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPASE_End      B                   export
     D SVPASE_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPASE_End      E

      * ------------------------------------------------------------ *
      * SVPASE_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPASE_Error    B                   export
     D SVPASE_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPASE_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E
      * ------------------------------------------------------------ *
      * SVPASE_getAsegurado: Obtiene la informacion del Asegurado    *
      *                      desde Nro Persona.-                     *
      *                                                              *
      *     peNrdf   (input)   Nro de persona                        *
      *     peDsAseg (output)  Estructura Asegurado                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPASE_getAsegurado...
     P                 B                   export
     D SVPASE_getAsegurado...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peDsAseg                          likeds( DsAsegurado_t )

     D   k1yase        ds                  likerec( s1hase : *key )
     D   dsIase        ds                  likerec( s1hase : *input)

      /free

       SVPASE_inz();

       clear peDsAseg;
       clear k1yase;

       k1yase.asasen = peNrdf;
       chain(n) %kds( k1yase ) sehase dsIase;
       if %found( sehase );
         eval-corr peDsAseg = dsIase;
       endif;

       return %found( sehase );

      /end-free
     P SVPASE_getAsegurado...
     P                 E
      * ------------------------------------------------------------ *
      * SVPASE_getProductorAsegurado: Obtiene la informacion del     *
      *          Productor asignado al asegurado desde Nro Persona.- *
      *                                                              *
      *     peNrdf   (input)   Nro de persona                        *
      *     peNivt   (output)  Tipo Nivel Intermediario              *
      *     peNivc   (output)  Codigo Nivel Intermediario            *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPASE_getProductorAsegurado...
     P                 B                   export
     D SVPASE_getProductorAsegurado...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNivt                       1  0
     D   peNivc                       5  0

     D   @@DsAseg      ds                  likeds( DsAsegurado_t )

      /free

       SVPASE_inz();

       clear peNivt;
       clear peNivc;
       clear @@DsAseg;

       if not SVPASE_getAsegurado( peNrdf : @@DsAseg );
         return *Off;
       endif;

       peNivt = @@DsAseg.asNivt;
       peNivc = @@DsAseg.asNivc;
       return *On;

      /end-free
     P SVPASE_getProductorAsegurado...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_isAseguradoHdi: Verificar si documento es o no de un  *
      *        asegurado de HDI. Opcionalmente retorna código de     *
      *        asegurado y/o el código de intermediario relacionado  *
      *                                                              *
      *     peTdoc   (input)   Tipo documento                        *
      *     peNdoc   (input)   Número documento                      *
      *     peNrdf   (output)  Nro de persona                        *
      *     peNivt   (output)  Tipo Nivel Intermediario              *
      *     peNivc   (output)  Codigo Nivel Intermediario            *
      *                                                              *
      * Retorna: *on = Si asegurado HDI / *off = Si no lo es         *
      * ------------------------------------------------------------ *
     P SVPASE_isAseguradoHdi...
     P                 B                   export
     D SVPASE_isAseguradoHdi...
     D                 pi              n
     D   peTdoc                       2  0 const
     D   peNdoc                      11  0 const
     D   peNrdf                       7  0 options(*nopass:*omit)
     D   peNivt                       1  0 options(*nopass:*omit)
     D   peNivc                       5  0 options(*nopass:*omit)

     D   kdaf05        ds                  likerec( g1hdaf05 : *key )
     D   kdaf06        ds                  likerec( g1hdaf06 : *key )

     D   @@DsAseg      ds                  likeds( DsAsegurado_t )
     D   @@Return      s               n
     D   @@ReNrdf      s               n
     D   @@ReNivt      s               n
     D   @@ReNivc      s               n

     D @@TdocCUIT      s              2  0 inz(98)

      /free

        SVPASE_inz();

        @@Return = *Off;

        if peTdoc = @@TdocCUIT or SVPVAL_tipoDeDocumento(peTdoc);

          @@ReNrdf = *Off;
          @@ReNivt = *Off;
          @@ReNivc = *Off;
          if %parms >= 3 and %addr(peNrdf) <> *NULL;
            @@ReNrdf = *On;
            clear peNrdf;
          endif;
          if %parms >= 3 and %addr(peNivt) <> *NULL;
            @@ReNivt = *On;
            clear peNivt;
          endif;
          if %parms >= 3 and %addr(peNivc) <> *NULL;
            @@ReNivc = *On;
            clear peNivc;
          endif;

          if peTdoc <> @@TdocCUIT;

            if peNdoc < 100000000;

              kdaf05.dftido = peTdoc;
              kdaf05.dfnrdo = peNdoc;
              setll %kds(kdaf05:2) gnhdaf05;
              dou %eof(gnhdaf05);
                reade %kds(kdaf05:2) gnhdaf05;
                if not %eof(gnhdaf05);
                  clear @@DsAseg;
                  if SVPASE_getAsegurado( dfnrdf : @@DsAseg );
                    @@Return = *On;
                    if @@ReNrdf;
                      peNrdf = @@DsAseg.asAsen;
                    endif;
                    if @@ReNivt;
                      peNivt = @@DsAseg.asNivt;
                    endif;
                    if @@ReNivc;
                      peNivc = @@DsAseg.asNivc;
                    endif;
                    leave;
                  endif;
                endif;
              enddo;

            endif;

          else;

            kdaf06.dfcuit = %editc(peNdoc:'X');
            setll %kds(kdaf06:1) gnhdaf06;
            dou %eof(gnhdaf06);
              reade %kds(kdaf06:1) gnhdaf06;
              if not %eof(gnhdaf06);
                clear @@DsAseg;
                if SVPASE_getAsegurado( dfnrdf : @@DsAseg );
                  @@Return = *On;
                  if @@ReNrdf;
                    peNrdf = @@DsAseg.asAsen;
                  endif;
                  if @@ReNivt;
                    peNivt = @@DsAseg.asNivt;
                  endif;
                  if @@ReNivc;
                    peNivc = @@DsAseg.asNivc;
                  endif;
                  leave;
                endif;
              endif;
            enddo;

          endif;

        endif;

        return @@Return;

      /end-free

     P SVPASE_isAseguradoHdi...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_getSehase01: Obtiene la informacion del Asegurado     *
      *                     desde Nro Persona.-                      *
      *                                                              *
      *     peNrdf   (input)   Nro de persona                        *
      *     peDsAs   (output)  Estructura Asegurado                  *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPASE_getSehase01...
     P                 B                   export
     D SVPASE_getSehase01...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peDsAs                            likeds( DsSehase01_t )

     D   k1yase        ds                  likerec( s1hase01 : *key )
     D   dsIase        ds                  likerec( s1hase01 : *input)

      /free

       SVPASE_inz();

       clear peDsAs;
       clear k1yase;

       k1yase.asasen = peNrdf;
       chain(n) %kds( k1yase ) sehase01 dsIase;
       if %found( sehase01 );
         eval-corr peDsAs = dsIase;
       endif;

       return %found( sehase01 );

      /end-free

     P SVPASE_getSehase01...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_infoAsegurado(): Obtiene la informacion del Asegurado *
      *                         desde Nro Persona.-                  *
      *                                                              *
      *     peNrdf   (input)   Nro de persona                        *
      *     peClie   (output)  Estructura de Cliente                 *
      *     peDomi   (output)  Estructura (Domi, Copo, Cops)         *
      *     peDocu   (output)  Estructura (Tido,Nrdo,Cuit,Cuil)      *
      *     peNtel   (output)  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb) *
      *     peNaci   (output)  Estructura (Fnac,Lnac,Pain,Naci)      *
      *     peMail   (output)  Estructura (Ctce,Mail)                *
      *     peTarc   (output)  Estructura (Ctcu,Nrtc,Ffta,Fftm)      *
      *     peInsc   (output)  Estructura (Fein,Nrin,Feco)           *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPASE_infoAsegurado...
     P                 B                   export
     D SVPASE_infoAsegurado...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peTiso                       2  0
     D   peCprf                       3  0
     D   peSexo                       1  0
     D   peEsci                       1  0
     D   peRaae                       3  0
     D   peAgpe                       1a
     D   peNcbu                      22  0
     D   peCbus                      22  0
     D   peRuta                      16  0
     D   peClie                            likeds(ClienteCot_t)
     D   peDomi                            likeds(prwaseDomi_t)
     D   peDocu                            likeds(prwaseDocu_t)
     D   peNtel                            likeds(prwaseTele_t)
     D   peNaci                            likeds(prwaseNaco_t)
     D   peMail                            likeds(prwaseEmail_t)
     D   peTarc                            likeds(prwaseTarc_t)
     D   peInsc                            likeds(prwaseInsc_t)

     D x               s             10i 0
     D @@DsAs          ds                  likeds( DsSehase01_t )
     D @@Ncbu          s             25a
     D @@Tpa2          s             20a
     D @@Ttr2          s             20a
     D @@Tpag          s             20a
     D @@Tfa1          s             20a
     D @@Tfa2          s             20a
     D @@Tfa3          s             20a
     D @@Nomb          s             40
     D @@Domi          s             35
     D @@Copo          s              5  0
     D @@Cops          s              1  0
     D @@Teln          s              7  0
     D @@Fnac          s              8  0
     D @@Ciiu          s              6  0
     D @@Dom2          s             50
     D @@Lnac          s             30
     D @@Pesk          s              5  2
     D @@Estm          s              3  2
     D @@Mfum          s              1
     D @@Mzur          s              1
     D @@Mar1          s              1
     D @@Mar2          s              1
     D @@Mar3          s              1
     D @@Mar4          s              1
     D @@Ccdi          s             11
     D @@Pain          s              5  0
     D @@Cnac          s              3  0
     D @@Chij          s              2  0
     D @@Cnes          s              1  0
     D @@DsTc          ds                  likeds ( dsGnhdtc_t ) dim( 99 )
     D @@DsTcC         s             10i 0
     D @@Ctce          s              2  0
     D peIvbc          s              3  0
     D peIvsu          s              3  0
     D peTcta          s              2  0
     D peNcta          s             25

      /free

       SVPASE_inz();

       clear @@DsAs;
       clear peClie;
       clear peDomi;
       clear peDocu;
       clear peNtel;
       clear peNaci;
       clear peMail;
       clear peTarc;
       clear peInsc;

       if SVPASE_getSehase01( peNrdf : @@DsAs );
         peClie.asen = @@DsAs.asasen;
         peClie.tido = @@DsAs.dftido;
         peClie.nrdo = @@DsAs.dfnrdo;
         peClie.nomb = %trim(@@DsAs.dfnomb);
         peClie.cuit = @@DsAs.dfcuit;

         peTiso = SVPDAF_getTipoSociedad( peNrdf );
         select;
           when peTiso = 80 or peTiso = 81;
             peClie.tipe = 'C';         // Consorcio
           when peTiso = 98;
             peClie.tipe = 'F';         // Persona Física
           other;
             peClie.tipe = 'J';         // Persona Jurídica
         endsl;

         if SVPDAF_getDa12( peNrdf
                          : @@Nomb
                          : @@Domi
                          : @@Copo
                          : @@Cops
                          : @@Teln
                          : @@Fnac
                          : peCprf
                          : peSexo
                          : peEsci
                          : peRaae
                          : @@Ciiu
                          : @@Dom2
                          : @@Lnac
                          : @@Pesk
                          : @@Estm
                          : @@Mfum
                          : @@Mzur
                          : @@Mar1
                          : @@Mar2
                          : @@Mar3
                          : @@Mar4
                          : @@Ccdi
                          : @@Pain
                          : @@Cnac
                          : @@Chij
                          : @@Cnes );
         endif;

         clear peAgpe;
         clear peCbus;
         clear peNcbu;
         clear @@Ncbu;
         clear peIvbc;
         clear peIvsu;
         clear peTcta;
         clear peNcta;

         if SPVCBU_getCuenta( peNrdf : peIvbc : peIvsu : peTcta : peNcta );
           @@Ncbu = SPVCBU_GetCBUEntero( peIvbc : peIvsu : peTcta : peNcta );
         endif;

         if @@Ncbu <> *blanks;
           peNcbu = %dec(%subst(%trim(@@Ncbu):1:22):22:0);
         endif;
         peRuta = asRuta;

         peClie.proc = SVPTAB_getProvincia( @@DsAs.asRpro );
         peClie.rpro = @@DsAs.asRpro;
         peClie.copo = @@DsAs.dfCopo;
         peClie.cops = @@DsAs.dfCops;
         peClie.civa = @@DsAs.asCiva;
         peNaci.fnac = SVPDAF_getFechaNac( peNrdf );
         peNaci.cnac = SVPDAF_getNacionalidad( peNrdf );
         peDocu.tido = @@DsAs.dftido;
         peDocu.nrdo = @@DsAs.dfnrdo;

         if @@DsAs.dfcuit <> *blanks;
           peDocu.cuit = %dec(@@DsAs.dfcuit:11:0);
         endif;

         peDomi.domi = %trim(@@DsAs.dfDomi);
         peDomi.copo = @@DsAs.dfCopo;
         peDomi.cops = @@DsAs.dfCops;
         peInsc.fein = @@DsAs.asfein;
         peInsc.nrin = @@DsAs.asnrin;
         peInsc.feco = @@DsAs.asfeco;
         peMail.Mail = SVPDAF_getMailValido( peNrdf : @@Ctce );
         peMail.ctce = @@Ctce;

         if SVPDAF_getda6( peNrdf
                         : peNtel.nte1
                         : @@Tpa2
                         : peNtel.nte2
                         : @@Ttr2
                         : peNtel.nte3
                         : @@Tpag
                         : @@Tfa1
                         : @@Tfa2
                         : @@Tfa3
                         : peNtel.Pweb );
         endif;

         clear @@DsTc;
         @@DsTcC = 0;
         if SPVTCR_getGnhdtc( peNrdf : *omit : *omit : @@DsTc : @@DsTcC );
           for x = 1 to @@DsTcC;
             if @@DsTc(x).dfBloq = 'N';
               peTarc.ctcu = @@DsTc(x).dfCtcu;
               peTarc.nrtc = @@DsTc(x).dfNrtc;
               peTarc.ffta = @@DsTc(x).dfFfta;
               peTarc.fftm = @@DsTc(x).dfFftm;
               leave;
             endif;
           endfor;
         endif;

         return *on;
       endif;

       return *off;

      /end-free

     P SVPASE_infoAsegurado...
     P                 E

      * ------------------------------------------------------------ *
      * SVPASE_isAseguradoBco: Verificar si el asegurado es de un    *
      *                        banco o directo.                      *
      *                                                              *
      *     peEmpr   (input)   Tipo documento                        *
      *     peSucu   (input)   Número documento                      *
      *     peNivt   (input)   Tipo Nivel Intermediario              *
      *     peNivc   (input)   Codigo Nivel Intermediario            *
      *                                                              *
      * Retorna: *on = Si asegurado Bco / *off = Si no lo es         *
      * ------------------------------------------------------------ *
     P SVPASE_isAseguradoBco...
     P                 B                   export
     D SVPASE_isAseguradoBco...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

     D   k1ysah        ds                  likerec( s2hint : *key )

      /free

        SVPASE_inz();

        k1ysah.inEmpr = peEmpr;
        k1ysah.inSucu = peSucu;
        k1ysah.inNivt = peNivt;
        k1ysah.inNivc = peNivc;
        chain %kds( k1ysah : 4 ) sahint;
        if %found( sahint );
          if inMabc = 'S';
            return *on;
          endif;
        endif;

        return *off;

      /end-free

     P SVPASE_isAseguradoBco...
     P                 E
