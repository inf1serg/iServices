     H nomain
      * ************************************************************ *
      * SVPLVD: Programa de Servicio.                                *
      *         Lavado de Dinero insert en tablas SQLServer.         *
      * ------------------------------------------------------------ *
      * Gomez Luis Roberto                   05-May-2016             *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      *                                                              *
      * NWN 28/08/2017 - Agrego servicio getPolizaAbierta            *
      *                  Agrego servicio SVPDAF_FecPriPol            *
      *                  Agrego servicio SVPDAF_getDaf               *
      *                  Agrego servicio SVPDAF_getDa1               *
      *                  Agrego servicio SVPASE_getIva               *
      *                  Se controla que los pagos de siniestros     *
      *                  solo se informen si los beneficiarios no son*
      *                  Proveedores.                                *
      *                                                              *
      * GIO 12-12-2007 Req. 5286: Recibe Nrdf, Beneficiario del pago *
      *                en la rutina SVPLVD_setOperacionSiniestroPago *
      * JSN 30-01-2018 Eliminar todos los carácteres menores al hexa *
      *                40 en los campos alfa para evitar basura en   *
      *                rl proceso SOS, en la rutina _setCliente      *
      * JSN 01-02-2018 Modificación en procedimiento _setPolizas,    *
      *                SOS - Transferencia de Datos                  *
      * LRG 02-02-2018 Modificacion setOperacionEmision(), se envia  *
      *                fecha de emision del endoso                   *
      * NWN 22-03-2019 Modificacion mascaras de importes.            *
      *                ( %editc() con código "P" ).                  *
      *                Si la fecha del SVPDAF_FECPRIPOL viene en     *
      *                '00000101' va '19010101'.                     *
      * GIO 08-10-2019 RM#5818 Se incorporan tablas en SVPLVD_Conf_t *
      *                - Relato del hecho                            *
      *                - Pagos Tesoreria                             *
      * GIO 10-10-2019 RM#5821 Se incorporan nuevos datos en la      *
      *                grabacion del procedimiento SVPLVD_setCliente *
      * GIO 15-10-2019 RM#5822 Se incorporan los nuevos campos de    *
      *                tablas en la grabacion en procedimientos:     *
      *                - SVPLVD_setBienesAseguradosAuto()            *
      *                - SVPLVD_setBienesAseguradosRV()              *
      *                - SVPLVD_setBienesAseguradosVida()            *
      * GIO 16-10-2019 RM#5823 Se incorporan nuevos datos en la      *
      *                - Modificar SVPLVD_setSiniestroDenuncia()     *
      * GIO 18-10-2019 RM#5824 Se incorpora el nuevo procedimiento   *
      *                SVPLVD_setPagosTesoreria() para grabar la     *
      *                nueva tabla [dbo].[SOSPagosin]                *
      *                                                              *
      * ************************************************************ *
     Fset330    if   e           k disk    usropn
     Fgnhdaf    if   e           k disk    usropn
     Fpahec1    if   e           k disk    usropn
     Fpahec0    if   e           k disk    usropn
     Fpahet0    if   e           k disk    usropn
     Fpaher0    if   e           k disk    usropn
     Fpahev0    if   e           k disk    usropn
     Fpahev1    if   e           k disk    usropn
     Fpahnx1    if   e           k disk    usropn
     Fpahnx002  if   e           k disk    usropn
     Fsehase    if   e           k disk    usropn
     Fpahed0    if   e           k disk    usropn
     Fpahscd    if   e           k disk    usropn
     Fpahsd0    if   e           k disk    usropn
     Fcnhopa    if   e           k disk    usropn
     Fcntcau    if   e           k disk    usropn

     D maskBR          c                   const( '           0 .  ' )
     D mask132         c                   const( '         0 .  ' )

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svplvd_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'

      * --------------------------------------------------- *
      * Setea
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     D COMA            c                   const(',')
     D COMI            c                   const('''')
     D PARENA          c                   const('(')
     D PARENC          c                   const(')')

     D                uds
     D  ldalma                57     58
     D  usempr               401    401
     D  ussucu               402    403

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPLVD_setCliente: Inserta cliente en Base                   *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     P SVPLVD_setCliente...
     P                 B                   export
     D SVPLVD_setCliente...
     D                 pi            10i 0
     D   peAsen                       7  0 options(*nopass:*omit)

     D @@cuil          s             11  0 inz
     D @@cuit          s             11    inz
     D @@pain          s              5  0 inz
     D @@paid          s             30    inz
     D @@cprf          s              3  0 inz
     D @@dprf          s             25    inz
     D @@tiso          s              2  0 inz
     D @@dtis          s             25    inz
     D @@bloq          s              1    inz
     D @@mota          s             50    inz
     D @@civa          s              1  0 inz
     D @@femi          s              8  0 inz
     D @1femi          s             10    inz
     D @1Nomb          s             40    inz
     D @1Domi          s             35    inz
     D @1Ndom          s              5  0 inz
     D @1Piso          s              3  0 inz
     D @1Deto          s              4    inz
     D @@copo          s              5  0 inz
     D @@cops          s              1  0 inz
     D @1Teln          s              7  0 inz
     D @1Faxn          s              7  0 inz
     D @1Tiso          s              2  0 inz
     D @@Tido          s              2  0 inz
     D @@Nrdo          s              8  0 inz
     D @1Cuit          s             11    inz
     D @1Njub          s             11  0 inz
     D @1Fnac          s              8  0 inz
     D @1Cprf          s              3  0 inz
     D @1Sexo          s              1  0 inz
     D @1Esci          s              1  0 inz
     D @1Raae          s              3  0 inz
     D @1Ciiu          s              6  0 inz
     D @1Dom2          s             50    inz
     D @1Lnac          s             30    inz
     D @1Pesk          s              5  2 inz
     D @1Estm          s              3  2 inz
     D @1Mfum          s              1    inz
     D @1Mzur          s              1    inz
     D @1Mar1          s              1    inz
     D @1Mar2          s              1    inz
     D @1Mar3          s              1    inz
     D @1Mar4          s              1    inz
     D @1Ccdi          s             11    inz
     D @1Pain          s              5  0 inz
     D @@Cnac          s              3  0 inz
     D @1copo          s              5  0 inz
     D @1cops          s              1  0 inz
     D @@enco          s                   like(*in50)
     D @@Nomb          s             40    inz

     D s               s          32767a   varying
     D rc              s             10i 0
     D @@conn          s                   like(Connection)
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D tmpfec          s               d   datfmt(*usa) inz
     D tmpHor          s               t   timfmt(*hms)
     D x               s             10i 0
     D @@Mail          s             50
     D @@exte          s              1
     D @@Domi          s             35
     D @2Bloq          s              1

     d dsHaseTmp       ds                  likerec(s1hase:*input)
     d @@rpro          s              2  0

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return -1;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
       endif;

       if %parms >= 1 and %addr(peAsen) <> *NULL;
          setll peAsen gnhdaf;
          reade peAsen gnhdaf;
       else;
          setll *start gnhdaf;
          read  gnhdaf;
       endif;

       dow not %eof( gnhdaf );
         if not SVPDAF_getDocumento( dfnrdf
                                   : *omit
                                   : *omit
                                   : @@cuit
                                   : @@cuil
                                   : *omit  );
         endif;
         if @@cuit = *blanks;
            @@cuit = *all'0';

         endif;
         @@pain = SVPDAF_getNacionalidad( dfnrdf
                                        : @@paid );

         @@cprf = SVPDAF_getProfesion( dfnrdf
                                     : @@dprf );

         @@tiso = SVPDAF_getTipoSociedad( dfnrdf
                                        : @@dtis );

         if not SVPASE_getBloqueoActual( dfnrdf
                                       : @@bloq
                                       : @@mota );
         endif;

         if not SVPDAF_getDaf( dfnrdf
                             : @1Nomb
                             : @1Domi
                             : @1Ndom
                             : @1Piso
                             : @1Deto
                             : @@copo
                             : @@cops
                             : @1Teln
                             : @1Faxn
                             : @1Tiso
                             : @@tido
                             : @@nrdo
                             : @1Cuit
                             : @1Njub );
         endif;

         if not SVPDAF_getDa1( dfnrdf
                             : @1Nomb
                             : @1Domi
                             : @1Copo
                             : @1Cops
                             : @1Teln
                             : @1Fnac
                             : @1Cprf
                             : @1Sexo
                             : @1Esci
                             : @1Raae
                             : @1Ciiu
                             : @1Dom2
                             : @1Lnac
                             : @1Pesk
                             : @1Estm
                             : @1Mfum
                             : @1Mzur
                             : @1Mar1
                             : @1Mar2
                             : @1Mar3
                             : @1Mar4
                             : @1Ccdi
                             : @1Pain
                             : @@Cnac );
         endif;

         @@civa = SVPASE_getIva( dfnrdf );

         if not SVPDAF_FecPriPol( usEmpr
                                : dfNrdf
                                : @@Femi );
         endif;

           if @@femi <> 00010101;
           @1femi = %char ( %date( %char( @@Femi ) : *iso0 ) );
           else;
           @1femi = '19010101';
           endif;

           @@nomb = SVPDAF_getNombre( dfnrdf );
           @@nomb = %scanrpl( '''' : '"' : @@nomb );

           @@Mail = SVPDAF_getMailValido( dfnrdf );
           @@exte = SVPDAF_getSujetoExterior( dfnrdf );
           @@Domi = SVPDAF_getDomicilio( dfnrdf
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit
                                       : *omit );
           @2Bloq = SVPASE_getCodBloqueo( dfnrdf );

           clear x;
           for x = 1 to %len(@@nomb);
             if %subst(@@nomb:x:1) < x'40';
               %subst(@@nomb:x:1) = ' ';
             endif;
           endfor;

           for x = 1 to %len(@@mail);
             if %subst(@@mail:x:1) < x'40';
               %subst(@@mail:x:1) = ' ';
             endif;
           endfor;

           for x = 1 to %len(@@domi);
             if %subst(@@domi:x:1) < x'40';
               %subst(@@domi:x:1) = ' ';
             endif;
           endfor;

           for x = 1 to %len(@@exte);
             if %subst(@@exte:x:1) < x'40';
               %subst(@@exte:x:1) = ' ';
             endif;
           endfor;

           for x = 1 to %len(@2bloq);
             if %subst(@2bloq:x:1) < x'40';
               %subst(@2bloq:x:1) = ' ';
             endif;
           endfor;

           for x = 1 to %len(@@mota);
             if %subst(@@mota:x:1) < x'40';
               %subst(@@mota:x:1) = ' ';
             endif;
           endfor;

           for x = 1 to %len(@1femi);
             if %subst(@1femi:x:1) < x'40';
               %subst(@1femi:x:1) = ' ';
             endif;
           endfor;

           chain dfnrdf sehase dsHaseTmp;
           if not %found(sehase);
             clear dsHaseTmp;
           endif;
           if dsHaseTmp.asfein = 0;
             dsHaseTmp.asfein = 19010101;
           endif;
           if dsHaseTmp.asfeco = 0;
             dsHaseTmp.asfeco = 19010101;
           endif;

           @@rpro = COWGRAI_GetCodProInd( @@copo
                                        : @@cops );

         s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
           +  %trim( @@conf.tabc )
           + ' (clnrdf, clnomb, clmail, clcuil, clcuit, cldomi, clpain,'
           + 'clcprf, clexte, clbloq, clmota, cltiso, clcopo, clcops,'
           + 'clcnac, clfalt, clciva, cltido, clnrdo, clnrin, clfein,'
           + 'clrpro, clfeco, clciiu )'
           + 'VALUES '
           + PARENA
           + %editc( dfnrdf : 'X' )
           + COMA
           + COMI
           + %trim( @@nomb )
           + COMI
           + COMA
           + COMI
           + %trim( @@Mail )
           + COMI
           + COMA
           + %editc( @@cuil : 'X' )
           + COMA
           + %trim( @@cuit )
           + COMA
           + COMI
           + %trim( @@Domi )
           + COMI
           + COMA
           + %editc( @@pain : 'X' )
           + COMA
           + %editc( @@cprf : 'X' )
           + COMA
           + COMI
           + %trim( @@exte )
           + COMI
           + COMA
           + COMI
           + %trim( @2Bloq )
           + COMI
           + COMA
           + COMI
           + %trim( @@mota )
           + COMI
           + COMA
           + %editc( @@tiso : 'X' )
           + COMA
           + %editc( @@copo : 'X' )
           + COMA
           + %editc( @@cops : 'X' )
           + COMA
           + %editc( @@cnac : 'X' )
           + COMA
           + COMI
           + @1FEMI
           + COMI
           + COMA
           + %editc( @@civa : 'X' )
           + COMA
           + %editc( @@tido : 'X' )
           + COMA
           + %editc( @@nrdo : 'X' )
           + COMA
           + COMI
           + %editc( dsHaseTmp.asnrin : 'X' )
           + COMI
           + COMA
           + COMI
           + %char( %date( %char( dsHaseTmp.asfein ) : *iso0 ))
           + COMI
           + COMA
           + COMI
           + %editc( @@rpro : 'X' )
           + COMI
           + COMA
           + COMI
           + %char( %date( %char( dsHaseTmp.asfeco ) : *iso0 ))
           + COMI
           + COMA
           + %editc( @1Ciiu : 'X' )
           + PARENC;
         //+ case when isvalid(@@femi)=1 then @fechaparm else mifech endcs.

           rc = JDBC_ExecUpd( @@conn : s );
           SVPLVD_cleanUp( 'RNX0301' );
           if rc = -1;
             @@enco = *on;
             //error
           endif;

         if %parms >= 1 and %addr(peAsen) <> *NULL;
             reade peAsen gnhdaf;
           else;
             read  gnhdaf;
         endif;
       enddo;

           JDBC_Close( @@conn );

       return 0;

      /end-free

     P SVPLVD_setCliente...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_setPolizas: Inserta Polizas en Base                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     P SVPLVD_setPolizas...
     P                 B                   export
     D SVPLVD_setPolizas...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D @@Npro          s             40    inz
     D @@Nivt          s              1  0 inz
     D @@Nivc          s              5  0 inz
     D @@fdes          s              8  0 inz
     D @@fhas          s              8  0 inz
     D @@pola          s              9  0 inz
     D @@poln          s              9  0 inz
     D @@polabierta    s              1
     D @@polvigente    s              1

     D s               s          32767a   varying
     D rc              s             10i 0
     D @@conn          s                   like(Connection)
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D tmpfec          s               d   datfmt(*usa) inz
     D tmpHor          s               t   timfmt(*hms)

     D k1yec1          ds                  likerec( p1hec1   : *key )
     D k1yec0          ds                  likerec( p1hec0   : *key )

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return -1;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         return -1;
       endif;

       @@Npro = SPVSPO_getProductor( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol
                                   : *omit
                                   : @@Nivt
                                   : @@Nivc );

       if not SPVSPO_getFecVig ( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : @@fdes
                               : @@fhas );
        // que hacer
       endif;
       // fecha en 99999999
       if @@fhas = *all'9';
          @@fhas = 20991231;
       endif;

       @@pola = SPVSPO_getPolizaAnterior( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol );
       if @@pola = -1;
         @@pola = *Zeros;
       endif;


         k1yec0.c0empr = peEmpr;
         k1yec0.c0sucu = peSucu;
         k1yec0.c0arcd = peArcd;
         k1yec0.c0spol = peSpol;
         chain %kds(k1yec0:4) pahec0;
         if %found(pahec0);
            @@poln = SPVSPO_getpoliza( peEmpr
                                     : peSucu
                                     : peArcd
                                     : c0Spon );
            if @@poln = -1;
              @@poln = *zeros;
            endif;
         else;
            @@poln = *zeros;
         endif;

       @@polabierta = 'C';
       if SPVSPO_getPolizaAbierta( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol ) = *on;
            @@polabierta = 'A';
       endif;

       @@polvigente = 'N';
       if SPVSPO_chkVig( peEmpr
                       : peSucu
                       : peArcd
                       : peSpol ) = *on;
            @@polvigente = 'A';
       endif;



         s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
           +  %trim( @@conf.tabp )
           + ' (porama, popoli, ponivt, ponivc, ponpro, ponrdf, '
           + '  pofemi, povdes, povhas, pofhfa, pomone, popoan, posuas, '
           + '  pocfpg, potvig, postat, poponu) '
           + 'VALUES '
           + PARENA
           + %editc( SPVSPO_getRama ( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol ) : 'X' )
           + COMA
           + %editc( SPVSPO_getPoliza( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol ) : 'X' )
           + COMA
           + %editc( @@nivt : 'X' )
           + COMA
           + %editc( @@nivc : 'X' )
           + COMA
           + COMI
           + %trim( @@Npro )
           + COMI
           + COMA
           + %editc( SPVSPO_getAsen( peEmpr
                                   : peSucu
                                   : peArcd
                                   : peSpol  ): 'X')
           + COMA
           + COMI
           + %char( %date( %char( SPVSPO_getFecEmi( peEmpr
                                                  : peSucu
                                                  : peArcd
                                                  : peSpol ) ) : *iso0))

           + COMI
           + COMA
           + COMI
           + %char( %date( %char( @@Fdes ) : *iso0 ) )
           + COMI
           + COMA
           + COMI
           + %char( %date( %char( @@Fhas ) : *iso0 ) )
           + COMI
           + COMA
           + COMI
           + %char( %date ( %char( SPVSPO_getHastaFacturado( peEmpr
                                                           : peSucu
                                                           : peArcd
                                                           : peSpol ) )
                                                             : *iso0 ) )
           + COMI
           + COMA
           + COMI
           + SPVSPO_getMone( peEmpr
                           : peSucu
                           : peArcd
                           : peSpol )
           + COMI
           + COMA
           + %editc( @@pola :'X')
           + COMA
           + COMI
           + %editc( SPVSPO_getSumaAseguradaEnPesos( peEmpr
                                                   : peSucu
                                                   : peArcd
                                                   : peSpol
                                                   : *omit): 'P' )
           //%editw( SPVSPO_getSumaAseguradaEnPesos( peEmpr
           //                                      : peSucu
           //                                      : peArcd
           //                                      : peSpol
           //                                      : *omit): maskBR )
           + COMI
           + COMA
           + COMI
           + %editc( SPVSPO_getFormaDePago( peEmpr
                                          : peSucu
                                          : peArcd
                                          : peSpol
                                          : *omit  ) : 'X' )
           + COMI
           + COMA
           + COMI
           + @@polabierta
           + COMI
           + COMA
           + COMI
           + @@polvigente
           + COMI
           + COMA
           + %editc( @@poln : 'X' )
           + PARENC;

           rc = JDBC_ExecUpd( @@conn : s );
           SVPLVD_cleanUp( 'RNX0301' );
           if rc = -1;
             //error
           endif;

           JDBC_Close( @@conn );

       return 0;

      /end-free

     P SVPLVD_setPolizas...
     P                 E
      * ------------------------------------------------------------ *
      * SVPLVD_setOperacionEmision: Inserta Oper. Emision            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento de SuperPóliza             *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     P SVPLVD_setOperacionEmision...
     P                 B                   export
     D SVPLVD_setOperacionEmision...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D   @@Sspo        s              3  0
     D   @@femi        s              8  0
     D   k1yec1        ds                  likerec( p1hec1 : *key )

      /free

       SVPLVD_inz();

       clear @@femi;
       k1yec1.c1empr = peEmpr;
       k1yec1.c1sucu = peSucu;
       k1yec1.c1arcd = peArcd;
       k1yec1.c1spol = peSpol;
       k1yec1.c1sspo = peSspo;
       chain %kds( k1yec1 : 5 ) pahec1;

       if %found( pahec1 );
        @@femi = (c1fema * 10000) + (c1femm * 100) + c1femd;
       endif;
       @@Sspo = peSspo;

       if SVPLVD_setOperacion( peEmpr
                             : peSucu
                             : peArcd
                             : peSpol
                             : peSspo
                             : SPVSPO_getRama( peEmpr
                                             : peSucu
                                             : peArcd
                                             : peSpol
                                             : @@Sspo   )
                             : SPVSPO_getPoliza( peEmpr
                                               : peSucu
                                               : peArcd
                                               : peSpol
                                               : @@Sspo )

                             : 'EMI'
                             : @@femi
                             : 0
                             : 0
                             : 0
                             : 0
                             : '0'     ) = -1;
       return -1;
       endif;

       return 0;

      /end-free

     P SVPLVD_setOperacionEmision...
     P                 E
      * ------------------------------------------------------------ *
      * SVPLVD_setOperacionCobranza: Inserta Oper. Cobranza          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   nro de poliza                         *
      *     peFope   (input)   Fecha asiento                         *
      *     pePrim   (input)   Prima                                 *
      *     pePrem   (input)   Premio                                *
      *     peNrcu   (input)   Nro de Cuota                          *
      *     peNrsc   (input)   Sub Nro de Cuota                      *
      *     peImau   (input)   Monto de la cuota                     *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     P SVPLVD_setOperacionCobranza...
     P                 B                   export
     D SVPLVD_setOperacionCobranza...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFope                       8  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   peImau                      15  2 const

      /free

       SVPLVD_inz();

       if SVPLVD_setOperacion( peEmpr
                             : peSucu
                             : peArcd
                             : peSpol
                             : peSspo
                             : peRama
                             : pePoli
                             : 'COB'
                             : peFope
                             : peNrcu
                             : peNrsc
                             : 0
                             : peImau
                             : '0'     ) = -1;
       return -1;
       endif;

       return 0;

      /end-free

     P SVPLVD_setOperacionCobranza...
     P                 E
      * ------------------------------------------------------------ *
      * SVPLVD_setOperacionSiniestroPago: Inserta Pago de Siniestro  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Nro de Siniestro                      *
      *     peNops   (input)   Nro de Operacion                      *
      *     peFmov   (input)   Fecha de movimiento                   *
      *     peImau   (input)   Importe Pago                          *
      *     peTben   (input)   Tipo de Beneficiario                  *
      *     peTmov   (input)   Tipo de Movimiento                    *
      *     peNrdf   (input)   Nro de Persona                        *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     P SVPLVD_setOperacionSiniestroPago...
     P                 B                   export
     D SVPLVD_setOperacionSiniestroPago...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFmov                       8  0 const
     D   peImau                      15  2 const
     D   peTben                       1    const
     D   peTmov                       1    const
     D   peNrdf                       7  0 const

     D   @@tope        s             15    inz
     D   @@Arcd        s              6  0 inz
     D   @@Spol        s              9  0 inz
     D   @@Sspo        s              3  0 inz
     D   @@Nops        s              7  0 inz
     D   @@Nrdf        s              7  0 inz

      /free

       SVPLVD_inz();

       if peTmov = 'I';
         @@tope = 'PAGO_SIN_CAP';
       else;
         @@tope = 'PAGO_SIN_HON';
       endif;

       @@Nops = peNops;
       if SVPSIN_getSpol( peEmpr
                        : peSucu
                        : peRama
                        : peSini
                        : @@Nops
                        : @@Arcd
                        : @@Spol
                        : @@Sspo ) = -1;
         return -1;
       endif;

       @@Nrdf = peNrdf;
       if SVPLVD_setOperacion( peEmpr
                             : peSucu
                             : @@Arcd
                             : @@Spol
                             : @@Sspo
                             : peRama
                             : SVPSIN_getPol( peEmpr
                                            : peSucu
                                            : peRama
                                            : peSini
                                            : @@Nops )
                             : @@tope
                             : peFmov
                             : 0
                             : 0
                             : peSini
                             : peImau
                             : peTben
                             : @@Nrdf  ) = -1;
       return -1;
       endif;

       return 0;

      /end-free

     P SVPLVD_setOperacionSiniestroPago...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_setOperacionSiniestroEstimacion:  Inserta Estimacion  *
      *                                          de siniestro        *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peRama   (input)   Articulo                              *
      *     peSini   (input)   Nro de siniestro                      *
      *     peNops   (input)   Nro de operacion Siniestro            *
      *     pePoco   (input)   Nro de componente                     *
      *     pePaco   (input)   Código de Parentesco                  *
      *     peNrdf   (input)   Nro de Persona                        *
      *     peSebe   (input)   Sec. Benef. Siniestros                *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Codigo de Cobertura                   *
      *     peFmoa   (input)   Año del movimiento                    *
      *     peFmom   (input)   Mes del movimiento                    *
      *     peFmod   (input)   Dia del movimiento                    *
      *     pePsec   (input)   Nro de Secuencia                      *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     P SVPLVD_setOperacionSiniestroEstimacion...
     P                 B                   export
     D SVPLVD_setOperacionSiniestroEstimacion...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNrdf                       7  0 const
     D   peSebe                       6  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFmoa                       4  0 const
     D   peFmom                       2  0 const
     D   peFmod                       2  0 const
     D   pePsec                       2  0 const

      /free

       SVPLVD_inz();

       //if SVPLVD_setOperacion( peRama
       //                      : pePoli
       //                      : peTipo
       //                      : peNrdf
       //                      : peFope
       //                      : pePrim
       //                      : pePrem
       //                      : peFemi
       //                      : peVdes
       //                      : peVhas
       //                      : peHafa
       //                      : peNrcu
       //                      : peNrsc
       //                      : peSini
       //                      : peImau
       //                      : peTben ) = -1;
       //return -1;
       //endif;

       return 0;

      /end-free

     P SVPLVD_setOperacionSiniestroEstimacion...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_getConfiguracion(): Obtiene configuración de conexión *
      *                                                              *
      *     peConf (output)   Registro de Configuración a hoy        *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     P SVPLVD_getConfiguracion...
     P                 B                   Export
     D SVPLVD_getConfiguracion...
     D                 pi            10i 0
     D   peConf                            likeds(SVPLVD_Conf_t)

      /free

       return SVPLVD_getConfiguracionPorFecha( %dec(%date():*iso)
                                             : peConf              );

      /end-free

     P SVPLVD_getConfiguracion...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_getConfiguracionPorFecha(): Obtiene configuración a   *
      *                       una fecha determinada                  *
      *                                                              *
      *     peFech (input)    Fecha a la cual retornar configuración *
      *     peConf (output)   Registro de Configuración              *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     P SVPLVD_getConfiguracionPorFecha...
     P                 B                   Export
     D SVPLVD_getConfiguracionPorFecha...
     D                 pi            10i 0
     D   peFech                       8  0 const
     D   peConf                            likeds(SVPLVD_Conf_t)

     D   found         s               n   inz
     D   svfini        s                   like( t@fini ) inz
     D   svsecu        s                   like( t@secu ) inz
     D   svdriv        s                   like( t@driv ) inz
     D   svdurl        s                   like( t@durl ) inz
     D   svbddu        s                   like( t@bddu ) inz
     D   svpass        s                   like( t@pass ) inz
     D   svbddn        s                   like( t@bddn ) inz
     D   svtabx        s                   like( t@tabx ) inz
     D   svtabc        s                   like( t@tabc ) inz
     D   svtabp        s                   like( t@tabp ) inz
     D   svtabo        s                   like( t@tabo ) inz
     D   svtabd        s                   like( t@tabd ) inz
     D   svtaba        s                   like( t@taba ) inz
     D   svtabr        s                   like( t@tabr ) inz
     D   svtabv        s                   like( t@tabv ) inz
     D   svtabh        s                   like( t@tabh ) inz
     D   svtabt        s                   like( t@tabt ) inz
      /free

       clear peConf;
       found  = *off;

       setll *start set330;
       read set330;
       dow not %eof;

           if t@fini <= peFech;
              svfini = t@fini;
              svsecu = t@secu;
              svdriv = t@driv;
              svdurl = t@durl;
              svbddu = t@bddu;
              svpass = t@pass;
              svbddn = t@bddn;
              svtabx = t@tabx;
              svtabc = t@tabc;
              svtabp = t@tabp;
              svtabo = t@tabo;
              svtabd = t@tabd;
              svtaba = t@taba;
              svtabr = t@tabr;
              svtabv = t@tabv;
              svtabh = t@tabh;
              svtabt = t@tabt;
              found  = *on;
           endif;

        read set330;
       enddo;

       if found;
          peConf.fini = svfini;
          peConf.secu = svsecu;
          peConf.driv = svdriv;
          peConf.durl = svdurl;
          peConf.bddu = svbddu;
          peConf.pass = svpass;
          peconf.bddn = svbddn;
          peConf.tabx = svtabx;
          peConf.tabc = svtabc;
          peConf.tabp = svtabp;
          peConf.tabo = svtabo;
          peConf.tabd = svtabd;
          peConf.taba = svtaba;
          peConf.tabr = svtabr;
          peConf.tabv = svtabv;
          peConf.tabh = svtabh;
          peConf.tabt = svtabt;
          return 0;
       else;
          return -1;
       endif;

      /end-free

     P SVPLVD_getConfiguracionPorFecha...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_getConfiguracionExacta():   Obtiene configuración a   *
      *                       una fecha determinada.                 *
      *                       Secuencia exacta.                      *
      *                                                              *
      *     peFech (input)    Fecha a la cual retornar configuración *
      *     peSecu (input)    Secuencia                              *
      *     peConf (output)   Registro de Configuración              *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     P SVPLVD_getConfiguracionExacta...
     P                 B                   Export
     D SVPLVD_getConfiguracionExacta...
     D                 pi            10i 0
     D   peFech                       8  0 const
     D   peSecu                       3  0 const
     D   peConf                            likeds(SVPLVD_Conf_t)

     D   k1y330        ds                  likerec( s1t330 : *key )

       chain %kds(k1y330) set330;
       if %found( set330 );
          peConf.fini = t@fini;
          peConf.secu = t@secu;
          peConf.driv = t@driv;
          peConf.durl = t@durl;
          peConf.bddu = t@bddu;
          peConf.pass = t@pass;
          peConf.bddn = t@bddn;
          peConf.tabx = t@tabx;
          peConf.tabc = t@tabc;
          peConf.tabp = t@tabp;
          peConf.tabo = t@tabo;
          peConf.tabd = t@tabd;
          peConf.taba = t@taba;
          peConf.tabr = t@tabr;
          peConf.tabv = t@tabv;
          peConf.tabh = t@tabh;
          peConf.tabt = t@tabt;
       else;
          return -1;
       endif;

       return 0;

     P SVPLVD_getConfiguracionExacta...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_setOperacion: Inserta Operacion                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento de SuperPóliza             *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Nro de Poliza                         *
      *     peTipo   (input)   Tipo de Operacion                     *
      *     peFope   (input)   Fecha de Operacion                    *
      *     peNrcu   (input)   Numero de cuota                       *
      *     peNrsc   (input)   Numero de Sub - Cuota                 *
      *     peSini   (input)   Nro de Siniestro                      *
      *     peImau   (input)   Importe Pago                          *
      *     peTben   (input)   Tipo de Beneficiario                  *
      *     peNrdf   (input)   Nro de Persona                        *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     P SVPLVD_setOperacion...
     P                 B
     D SVPLVD_setOperacion...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       8  0 const
     D   pePoli                       7  0 const
     D   peTipo                      15    const
     D   peFope                       8  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   peSini                       7  0 const
     D   peImau                      15  2 const
     D   peTben                       1    const
     D   peNrdf                       7  0 options(*nopass:*omit)

     D s               s          32767A   varying
     D rc              s             10i 0
     D @@conn          s                   like(Connection)
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D @@fdes          s              8  0 inz
     D @@fhas          s              8  0 inz
     D @@Sspo          s              3  0
     D @@Nrdf          s              7  0 inz

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return -1;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         return -1;
       endif;

       if not SPVSPO_getFecVig ( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : @@fdes
                               : @@fhas );
        // que hacer
       endif;
       // fecha en 99999999
       if @@fhas = *all'9';
          @@fhas = 20991231;
       endif;

       @@Sspo = peSspo;

       if %parms >= 15 and %addr( peNrdf ) <> *null;
          @@Nrdf = peNrdf;
       else;
          @@Nrdf = SPVSPO_getAsen( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol
                                 : @@Sspo );
       endif;

         if peTben <> '3';
         s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
           +  %trim( @@conf.tabo)
           + ' (oprama, oppoli, optiop, opnrdf, opfope, opprim, opprem, '
           + 'opfemi, opvdes, opfhas, ophafa, opnrcu, opnrsc, opsini, '
           + 'opimau, optben )'
           + 'VALUES '
           + PARENA
           + %editc( peRama : 'X' )
           + COMA
           + %editc( pePoli : 'X' )
           + COMA
           + COMI
           + %trim( peTipo )
           + COMI
           + COMA
           + %editc( @@Nrdf : 'X' )
           + COMA
           + COMI
           + %char( %date( %char( PeFope ) : *iso0 ))
           + COMI
           + COMA
           + %editc( SPVSPO_getPrima( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : @@Sspo ) : 'P' )
           //%editw( SPVSPO_getPrima( peEmpr
           //                       : peSucu
           //                       : peArcd
           //                       : peSpol
           //                       : @@Sspo ) : maskBR )
           + COMA
           + %editc( SPVSPO_getPremio( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : peSspo ) : 'P' )
           //%editw( SPVSPO_getPremio( peEmpr
           //                        : peSucu
           //                        : peArcd
           //                        : peSpol
           //                        : peSspo ) : maskBR )
           + COMA
           + COMI
           + %char( %date( %char( SPVSPO_getFecEmi( peEmpr
                                                  : peSucu
                                                  : peArcd
                                                  : peSpol ) ) : *iso0))
           + COMI
           + COMA
           + COMI
           + %char( %date( %char( @@Fdes ) : *iso0 ) )
           + COMI
           + COMA
           + COMI
           + %char( %date( %char( @@Fhas ) : *iso0 ) )
           + COMI
           + COMA
           + COMI
           + %char( %date ( %char( SPVSPO_getHastaFacturado( peEmpr
                                                           : peSucu
                                                           : peArcd
                                                           : peSpol ) )
                                                             : *iso0 ) )
           + COMI
           + COMA
           + %editc( peNrcu : 'X' )
           + COMA
           + %editc( peNrsc : 'X' )
           + COMA
           + %editc( peSini : 'X' )
           + COMA
           + %editc( peImau : 'P' )
           //%editw( peImau : maskBR )
           + COMA
           + COMI
           + %trim( peTben )
           + COMI
           + PARENC;
         Endif;

           rc = JDBC_ExecUpd( @@conn : s );
           SVPLVD_cleanUp( 'RNX0301' );
           if rc = -1;
             //error
             return -1;
           endif;

           JDBC_Close( @@conn );
           return 0;

     P SVPLVD_setOperacion...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_setSiniestroDenuncia:  Inserta Denuncia de Siniestro  *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Nro de Siniestro                      *
      *     peFden   (input)   Fecha de denunca                      *
      *     peFsin   (input)   Fecha de sinietro                     *
      *     pePoli   (input)   Nro de Poliza                         *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     P SVPLVD_setSiniestroDenuncia...
     P                 B                   export
     D SVPLVD_setSiniestroDenuncia...
     D                 pi            10i 0
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peFden                       8  0 const
     D   peFsin                       8  0 const
     D   pePoli                       7  0 const

     D s               s          32767a   varying
     D rc              s             10i 0
     D @@conn          s                   like(Connection)
     D @@conf          ds                  likeds(SVPLVD_Conf_t)

     d k1Hscd          ds                  likerec( p1hscd : *key )
     d dsHscdTmp       ds                  likerec( p1hscd : *input )

     d k1Hsd0          ds                  likerec( p1hsd0 : *key )
     d dsHsd0Tmp       ds                  likerec( p1hsd0 : *input )

     d @@cbgi          s            400

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return -1;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         return -1;
       endif;

       clear k1Hscd;
       k1Hscd.cdempr = usempr;
       k1Hscd.cdsucu = ussucu;
       k1Hscd.cdrama = peRama;
       k1Hscd.cdsini = peSini;
       setll %kds( k1Hscd : 4 ) pahscd;
       dou %eof( paHscd );
         reade %kds( k1Hscd : 4 ) pahscd dsHscdTmp;
         if not %eof( paHscd );

           if dsHscdTmp.cdpoli = pePoli;

             s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
               +  %trim( @@conf.tabd)
               + ' (sirama, sisini, sifden, sifsin, sipoli, sicert )'
               + 'VALUES '
               + PARENA
               + %editc( peRama : 'X' )
               + COMA
               + %editc( peSini : 'X' )
               + COMA
               + COMI
               + %char( %date( %char( peFden ) : *iso0) )
               + COMI
               + COMA
               + COMI
               + %char( %date( %char( peFsin ) : *iso0) )
               + COMI
               + COMA
               + %editc( pePoli : 'X' )
               + COMA
               + COMI
               + %editc( dsHscdTmp.cdcert : 'X' )
               + COMI
               + PARENC;

             rc = JDBC_ExecUpd( @@conn : s );
             SVPLVD_cleanUp( 'RNX0301' );
             if rc = -1;
               // error
               return -1;
             endif;

             clear @@cbgi;
             clear k1Hsd0;
             k1Hsd0.d0empr = dsHscdTmp.cdempr;
             k1Hsd0.d0sucu = dsHscdTmp.cdsucu;
             k1Hsd0.d0rama = dsHscdTmp.cdrama;
             k1Hsd0.d0sini = dsHscdTmp.cdsini;
             k1Hsd0.d0nops = dsHscdTmp.cdnops;
             setll %kds( k1Hsd0 : 5 ) pahsd0;
             dou %eof( paHsd0 );
               reade %kds( k1Hsd0 : 5 ) pahsd0 dsHsd0Tmp;
               if not %eof( paHsd0 );
                 @@cbgi = %trim( @@cbgi ) + ' ' + %trim( dsHsd0Tmp.d0retx );
                 @@cbgi = %trim( @@cbgi );
               endif;
             enddo;

             s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
               +  %trim( @@conf.tabh)
               + ' ( pssini, psrama, pscbgi ) '
               + ' VALUES '
               + PARENA
               + COMI
               + %editc( peSini : 'X' )
               + COMI
               + COMA
               + COMI
               + %editc( peRama : 'X' )
               + COMI
               + COMA
               + COMI
               + %trim( @@cbgi )
               + COMI
               + PARENC;

             rc = JDBC_ExecUpd( @@conn : s );
             SVPLVD_cleanUp( 'RNX0301' );
             if rc = -1;
               // error
               return -1;
             endif;

             leave;

           endif;
         endif;
       enddo;


           JDBC_Close( @@conn );
           return 0;

     P SVPLVD_setSiniestroDenuncia...
     P                 E
      * ------------------------------------------------------------ *
      * SVPLVD_delCliente: Elimina cliente en Base                   *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     P SVPLVD_delCliente...
     P                 B                   export
     D SVPLVD_delCliente...
     D                 pi            10i 0
     D   peAsen                       7  0 options(*nopass:*omit)

     D s               s          32767a   varying
     D rc              s             10i 0
     D @@conn          s                   like(Connection)
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D tmpfec          s               d   datfmt(*usa) inz
     D tmpHor          s               t   timfmt(*hms)

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return -1;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         return -1;
       endif;

       if %parms >= 1 and %addr(peAsen) <> *NULL;
         s = 'DELETE FROM' + %trim( @@conf.bddn ) + '.'
           +  %trim( @@conf.tabc )
           + 'WHERE '
           + 'CLNRDF = '
           + %editc( peAsen : 'X' );
       else;
         s = 'DELETE FROM ' + %trim( @@conf.bddn ) + '.'
           +  %trim( @@conf.tabc );
       endif;

           rc = JDBC_ExecUpd( @@conn : s );
           SVPLVD_cleanUp( 'RNX0301' );
           if rc = -1;
             JDBC_Close( @@conn );
             return rc;
           endif;

       JDBC_Close( @@conn );
       return 0;

      /end-free

     P SVPLVD_delCliente...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_getLlamada: Retorna si se ejecutó desde PAX340%       *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPLVD_getLlamada...
     P                 B                   export
     D SVPLVD_getLlamada...
     D                 pi              n

     D QMHRCVPM        pr                  ExtPgm('QMHRCVPM')
     D   MsgInfo                  32767A   options(*varsize)
     D   MsgInfoLen                  10I 0 const
     D   Format                       8A   const
     D   StackEntry                  10A   const
     D   StackCount                  10I 0 const
     D   MsgType                     10A   const
     D   MsgKey                       4A   const
     D   WaitTime                    10I 0 const
     D   MsgAction                   10A   const
     D   ErrorCode                 8000A   options(*varsize)

     D QMHSNDPM        pr                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   const
     D   QualMsgF                    20A   const
     D   MsgData                  32767A   const options(*varsize)
     D   MsgDtaLen                   10I 0 const
     D   MsgType                     10A   const
     D   CallStkEnt                  10A   const
     D   CallStkCnt                  10I 0 const
     D   MessageKey                   4A
     D   ErrorCode                 8000A   options(*varsize)

     D RCVM0200        ds                  qualified
     D  Receiver             111    120A

     D ErrorCode       ds                  qualified
     D   BytesProv                   10I 0 inz(%size(ErrorCode))
     D   BytesAvail                  10I 0 inz(0)

     D MsgKey          s              4A
     D stack_entry     s             10I 0
     D startCnt        s             10I 0

       StartCnt = 1;

       for stack_entry = StartCnt to 50;
         QMHSNDPM( ''
                 : ''
                 : 'TEST'
                 : %len('TEST')
                 : '*RQS'
                 : '*'
                 : stack_entry
                 : MsgKey
                 : ErrorCode  );

         QMHRCVPM( RCVM0200
                 : %size(RCVM0200)
                 : 'RCVM0200'
                 : '*'
                 : stack_entry
                 : '*RQS'
                 : MsgKey
                 : 0
                 : '*REMOVE'
                 : ErrorCode );

         if  %subst ( RCVM0200.Receiver : 1 : 6 ) = 'PAX340';
           return *on;
         endif;
       endfor;
           return *off;

     P SVPLVD_getLlamada...
     P                 E
      * ------------------------------------------------------------ *
      * SVPLVD_setEstadoInicio: Graba Estado de Inicio - Control     *
      *                                                              *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPLVD_setEstadoInicio...
     P                 B                   export
     D SVPLVD_setEstadoInicio...
     D                 pi              n

     D @@estado        s              1
      /free

       SVPLVD_inz();

       @@estado = SVPLVD_getEstadoControl();
       Select;
         when @@estado = 'I';
           //error
            return *off;
         when @@estado = 'F';
           if not SVPLVD_updEstadoControl('I');
             //error
             return *off;
           endif;
         other;
           if not SVPLVD_setEstadoControl('I');
             //error
             return *off;
           endif;
       endsl;
       return *on;
      /end-free

     P SVPLVD_setEstadoInicio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_setEstadoFin: Graba Esatdo de Fin - Control           *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPLVD_setEstadoFin...
     P                 B                   export
     D SVPLVD_setEstadoFin...
     D                 pi              n

     D @@estado        s              1
      /free

       SVPLVD_inz();

       @@estado = SVPLVD_getEstadoControl();
       Select;
         when @@estado = 'I';
           if not SVPLVD_updEstadoControl('F');
             //error
               return *off;
           endif;
         other;
           //error
             return *off;
       endsl;
       return *on;
      /end-free

     P SVPLVD_setEstadoFin...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_getEstadoControl: Retorna ultima Estadoa de Control   *
      *                                                              *
      * Retorna: Estado                                              *
      * ------------------------------------------------------------ *
     P SVPLVD_getEstadoControl...
     P                 B                   export
     D SVPLVD_getEstadoControl...
     D                 pi             1

     D s               s          32767a   varying
     D rs              s                   like(ResultSet)
     D @@estado        s              1    inz
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D @@conn          s                   like(Connection)

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return *blank;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         return *blank;
       endif;

       s = 'SELECT Status FROM ' + %trim( @@conf.bddn ) + '.'
         +  %trim( @@conf.tabx );

       rs = JDBC_ExecQry( @@conn : s );
       if (rs = *null);
         @@estado = *Blanks;
       else;
         dow JDBC_nextRow( rs );
           @@estado = %trim(JDBC_getColByName(rs:'Status'));
           leave;
         enddo;
       endif;

       JDBC_freeResult(rs);
       JDBC_Close( @@conn );
       return @@estado;
      /end-free

     P SVPLVD_getEstadoControl...
     P                 E
      * ------------------------------------------------------------ *
      * SVPLVD_updEstadoControl: Actualiza Estado de Control         *
      *                                                              *
      *        peEsta   (input)  Estado                              *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPLVD_updEstadoControl...
     P                 B                   export
     D SVPLVD_updEstadoControl...
     D                 pi              n
     D   peEsta                       1    const

     D rc              s             10i 0
     D s               s          32767a   varying
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D @@conn          s                   like(Connection)

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return *off;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         return *off;
       endif;

         s = 'UPDATE ' + %trim( @@conf.bddn ) + '.'
           +  %trim( @@conf.tabx)
           + ' SET '
           + 'Empresa = '
           + COMI
           + 'A'
           + COMI
           + COMA
           + 'Status =  '
           + COMI
           + %trim(peEsta)
           + COMI
           + COMA
           + 'UltimaFecha = '
           + COMI
           + %char( %date() : *iso0 )
           + COMI;

           rc = JDBC_ExecUpd( @@conn : s );
           SVPLVD_cleanUp( 'RNX0301' );

           if rc = -1;
             //error
             return *off;
           endif;

           JDBC_Close( @@conn );
           return *on;

     P SVPLVD_updEstadoControl...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_setEstadoControl: Graba Estado de Control             *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPLVD_setEstadoControl...
     P                 B                   export
     D SVPLVD_setEstadoControl...
     D                 pi              n
     D   peEsta                       1    const

     D rc              s             10i 0
     D s               s          32767a   varying
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D @@conn          s                   like(Connection)

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return *off;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         return *off;
       endif;

         s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
           +  %trim( @@conf.tabx)
           + ' ( Empresa, Status, UltimaFecha ) '
           + 'VALUES '
           + PARENA
           + COMI
           +  'A'
           + COMI
           + COMA
           + COMI
           + %trim(peEsta)
           + COMI
           + COMA
           + COMI
           + %char( %date() : *iso0 )
           + COMI
           + PARENC;

           rc = JDBC_ExecUpd( @@conn : s );
           SVPLVD_cleanUp( 'RNX0301' );

           if rc = -1;
             //error
             return *off;
           endif;

           JDBC_Close( @@conn );
           return *on;

     P SVPLVD_setEstadoControl...
     P                 E
      * ------------------------------------------------------------ *
      * SVPLVD_setBienesAseguradosAuto: Insertar BS Autos            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     P SVPLVD_setBienesAseguradosAuto...
     P                 B                   export
     D SVPLVD_setBienesAseguradosAuto...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D rc              s             10i 0 inz
     D s               s          32767a   varying
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D @@conn          s                   like(Connection)
     D tmpfec          s               d   datfmt(*usa) inz
     D tmpHor          s               t   timfmt(*hms)
     D @@vhds          s             40    inz
     D @@vhcd          s             15    inz
     D @@cvde          s             20    inz
     D @@vhdt          s             15    inz
     D @@cobd          s             40    inz
     D @@vhdu          s             15    inz

     D k1yet0          ds                  likerec( p1het0 : *key )

     d k1hed0          ds                  likerec( p1hed0 : *key )
     d dsHed0Tmp       ds                  likerec( p1hed0 : *input )
     d @@suas          s             15  2

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return -1;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         JDBC_Close( @@conn );
         return -1;
       endif;

       k1yet0.t0empr = peEmpr;
       k1yet0.t0sucu = peSucu;
       k1yet0.t0arcd = peArcd;
       k1yet0.t0spol = peSpol;
       k1yet0.t0sspo = peSspo;
       setll %kds( k1yet0 : 5 ) pahet0;
       reade %kds( k1yet0 : 5 ) pahet0;
       dow not %eof( pahet0 );

       clear @@vhds;
       @@vhds = SPVVEH_GetDescripcion( t0Vhmc
                                     : t0Vhmo
                                     : t0Vhcs
                                     : *omit
                                     : *omit
                                     : *omit );

       clear @@vhcd;
       if not  SPVVEH_CheckCarroceria( t0vhcr
                                     : @@vhcd );
       endif;

       clear @@cvde;
       if not  SPVVEH_CheckCapVar( t0Vhca
                                 : t0Vhv1
                                 : t0Vhv2
                                 : @@cvde );
       endif;
       clear @@vhdt;
       if not SPVVEH_CheckTipoVeh( t0vhct
                                 : @@vhdt );
       endif;

       clear @@cobd;
       if not SPVVEH_CheckCobertura( t0cobl
                                   : @@cobd );
       endif;

       clear @@vhdu;
       if not SPVVEH_CheckCodUso( t0vhuv
                                : @@vhdu );
       endif;

       clear k1hed0;
       k1hed0.d0empr = peEmpr;
       k1hed0.d0sucu = peSucu;
       k1hed0.d0arcd = peArcd;
       k1hed0.d0spol = peSpol;
       k1hed0.d0sspo = peSspo;
       setgt %kds( k1hed0 : 5 ) pahed0;
       readpe %kds( k1hed0 : 5 ) pahed0 dsHed0Tmp;
       if %eof( pahed0 );
         clear dsHed0Tmp;
       endif;
       if dsHed0Tmp.d0come = *zeros;
         dsHed0Tmp.d0come = 1;
       endif;
       @@suas = t0vhvu * dsHed0Tmp.d0come;

         s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
           +  %trim( @@conf.taba)
           + ' (t0rama, t0poli, t0poco, t0sspo, t0acrc, t0nacr, t0rpro, '
           + '  t0prod, t0rdep, t0rloc, t0loca, t0vhmc, t0vhmo, t0vhcs, '
           + '  t0vhde, t0vhcr, t0vhdr, t0vhan, t0nmat, t0moto, t0chas, '
           + '  t0vhca, t0vhv1, t0vhv2, t0cvde, t0vhct, t0vhdt, t0vhvu, '
           + '  t0cobl, t0cobd, t0vhuv, t0vhdu, t0vh0k, t0rcle, t0rcco, '
           + '  t0rcac, t0lrce, t0saap, t0claj, t0tarc, t0tair, t0scta, '
           + '  t0prrc, t0prac, t0prin, t0prro, t0pacc, t0praa, t0prsf, '
           + '  t0prce, t0prap, t0ctre, t0ruta, t0mtdf, t0ifra, t0endo, '
           + '  t0tiou, t0stou, t0mone, t0come, t0vhvp ) '
           + 'VALUES '
           + PARENA
           + %editc( t0rama : 'X' )
           + COMA
           + %editc( t0poli : 'X' )
           + COMA
           + %editc( t0poco : 'X' )
           + COMA
           + %editc( t0sspo : 'X' )
           + COMA
           + %editc( t0acrc : 'X' )
           + COMA
           + COMI
           + %trim( SVPDAF_getNombre( t0acrc ) )
           + COMI
           + COMA
           + %editc( t0rpro : 'X' )
           + COMA
           + COMI
           + %trim( SVPDES_provinciaInder( t0rpro ) )
           + COMI
           + COMA
           + %editc( t0rdep : 'X' )
           + COMA
           + %editc( t0rloc : 'X' )
           + COMA
           + COMI
           + ' '
           + COMI
           + COMA
           + COMI
           + %trim( t0vhmc )
           + COMI
           + COMA
           + COMI
           + %trim( t0vhmo )
           + COMI
           + COMA
           + COMI
           + %trim( t0vhcs )
           + COMI
           + COMA
           + COMI
           + %trim( @@vhds )
           + COMI
           + COMA
           + COMI
           + %trim( t0vhcr )
           + COMI
           + COMA
           + COMI
           + %trim( @@vhcd )
           + COMI
           + COMA
           + %editc( t0vhaÑ : 'X' )
           + COMA
           + COMI
           + %trim( t0nmat )
           + COMI
           + COMA
           + COMI
           + %trim( t0moto )
           + COMI
           + COMA
           + COMI
           + %trim( t0chas )
           + COMI
           + COMA
           + %editc( t0vhca : 'X' )
           + COMA
           + %editc( t0vhv1 : 'X' )
           + COMA
           + %editc( t0vhv2 : 'X' )
           + COMA
           + COMI
           + %trim( @@cvde )
           + COMI
           + COMA
           + %editc( t0vhct : 'X' )
           + COMA
           + COMI
           + %trim( @@vhdt )
           + COMI
           + COMA
           + COMI
           + %editc( t0vhvu : 'P' )
           //%editw( t0vhvu : maskBR  )
           + COMI
           + COMA
           + COMI
           + %trim( t0cobl )
           + COMI
           + COMA
           + COMI
           + %trim( @@cobd )
           + COMI
           + COMA
           + %editc( t0vhuv : 'X' )
           + COMA
           + COMI
           + %trim( @@vhdu )
           + COMI
           + COMA
           + COMI
           + %editc( t0vh0k : 'P' )
           //%editw( t0vh0k : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0rcle : 'P' )
           //%editw( t0rcle : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0rcco : 'P' )
           //%editw( t0rcco : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0rcac : 'P' )
           //%editw( t0rcac : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0lrce : 'P' )
           //%editw( t0lrce : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0saap : 'P' )
           //%editw( t0saap : maskBR  )
           + COMI
           + COMA
           + %editc( t0claj : 'X' )
           + COMA
           + %editc( t0tarc : 'X' )
           + COMA
           + %editc( t0tair : 'X' )
           + COMA
           + %editc( t0scta : 'X' )
           + COMA
           + COMI
           + %editc( t0prrc : 'P' )
           //%editw( t0prrc : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0prac : 'P' )
           //%editw( t0prac : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0prin : 'P' )
           //%editw( t0prin : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0prro : 'P' )
           //%editw( t0prro : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0pacc : 'P' )
           //%editw( t0pacc : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0praa : 'P' )
           //%editw( t0praa : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0prsf : 'P' )
           //%editw( t0prsf : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0prce : 'P' )
           //%editw( t0prce : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( t0prap : 'P' )
           //%editw( t0prap : maskBR  )
           + COMI
           + COMA
           + %editc( t0ctre : 'X' )
           + COMA
           + %editc( t0ruta : 'X' )
           + COMA
           + COMI
           + %trim( t0mtdf )
           + COMI
           + COMA
           + COMI
           + %editc( t0ifra : 'P' )
           //%editw( t0ifra : maskBR  )
           + COMI
           + COMA
           + COMI
           + %editc( dsHed0Tmp.d0endo : 'X' )
           + COMI
           + COMA
           + COMI
           + %editc( dsHed0Tmp.d0tiou : 'X' )
           + COMI
           + COMA
           + COMI
           + %editc( dsHed0Tmp.d0stou : 'X' )
           + COMI
           + COMA
           + COMI
           + %trim( dsHed0Tmp.d0mone )
           + COMI
           + COMA
           + COMI
           + %editc( dsHed0Tmp.d0come : 'P' )
           + COMI
           + COMA
           + COMI
           + %editc( @@suas : 'P' )
           + COMI
           + PARENC;
           rc = JDBC_ExecUpd( @@conn : s );
           SVPLVD_cleanUp( 'RNX0301' );

           if rc = -1;
             //error
             JDBC_Close( @@conn );
             return rc;
           endif;

         reade %kds( k1yet0 : 5 ) pahet0;
       enddo;

       JDBC_Close( @@conn );
       return rc;

     P SVPLVD_setBienesAseguradosAuto...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_setBienesAseguradosRV: Insertar BS RV                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     P SVPLVD_setBienesAseguradosRV...
     P                 B                   export
     D SVPLVD_setBienesAseguradosRV...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D rc              s             10i 0
     D s               s          32767a   varying
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D @@conn          s                   like(Connection)
     D tmpfec          s               d   datfmt(*usa) inz
     D tmpHor          s               t   timfmt(*hms)

     D k1yer0          ds                  likerec( p1her0 : *key )

     d k1hed0          ds                  likerec( p1hed0 : *key )
     d dsHed0Tmp       ds                  likerec( p1hed0 : *input )
     d @@suas          s             15  2

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return -1;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         JDBC_Close( @@conn );
         return -1;
       endif;

       k1yer0.r0empr = peEmpr;
       k1yer0.r0sucu = peSucu;
       k1yer0.r0arcd = peArcd;
       k1yer0.r0spol = peSpol;
       k1yer0.r0sspo = peSspo;
       setll %kds( k1yer0 : 5 ) paher0;
       reade %kds( k1yer0 : 5 ) paher0;
       dow not %eof( paher0 );

         clear k1hed0;
         k1hed0.d0empr = peEmpr;
         k1hed0.d0sucu = peSucu;
         k1hed0.d0arcd = peArcd;
         k1hed0.d0spol = peSpol;
         k1hed0.d0sspo = peSspo;
         setgt %kds( k1hed0 : 5 ) pahed0;
         readpe %kds( k1hed0 : 5 ) pahed0 dsHed0Tmp;
         if %eof( pahed0 );
           clear dsHed0Tmp;
         endif;
         if dsHed0Tmp.d0come = *zeros;
           dsHed0Tmp.d0come = 1;
         endif;
         @@suas = r0sacm * dsHed0Tmp.d0come;

         s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
           +  %trim( @@conf.tabr)
           + ' (r0rama, r0poli, r0poco, r0sspo, r0arcd, r0spol, r0acrc, '
           + '  r0nacr, r0rpro, r0prod, r0rdep, r0rloc, r0blck, r0rdes, '
           + '  r0nrdm, r0copo, r0cops, r0loca, r0suin, r0ainn, r0minn, '
           + '  r0dinn, r0suen, r0aegn, r0megn, r0degn, r0xpro, r0prds, '
           + '  r0sacm, r0prbp, r0prgp, r0clfr, r0cagr, r0psmp, r0crea, '
           + '  r0ctar, r0cta1, r0cta2, r0ctds, r0cviv, r0dviv, r0endo, '
           + '  r0tiou, r0stou, r0mone, r0come, r0sacp ) '
           + 'VALUES '
           + PARENA
           + %editc( r0rama : 'X' )
           + COMA
           + %editc( r0poli : 'X' )
           + COMA
           + %editc( r0poco : 'X' )
           + COMA
           + %editc( r0sspo : 'X' )
           + COMA
           + %editc( r0arcd : 'X' )
           + COMA
           + %editc( r0spol : 'X' )
           + COMA
           + %editc( r0acrc : 'X' )
           + COMA
           + COMI
           + %trim( SVPDAF_getNombre( r0acrc ) )
           + COMI
           + COMA
           + %editc( r0rpro : 'X' )
           + COMA
           + COMI
           + %trim( SVPDES_provinciaInder( r0rpro ) )
           + COMI
           + COMA
           + %editc( r0rdep : 'X' )
           + COMA
           + %editc( r0rloc : 'X' )
           + COMA
           + COMI
           + %trim( r0blck )
           + COMI
           + COMA
           + COMI
           + %trim( r0rdes )
           + COMI
           + COMA
           + %editc( r0nrdm : 'X' )
           + COMA
           + %editc( r0copo : 'X' )
           + COMA
           + %editc( r0cops : 'X' )
           + COMA
           + COMI
           + %trim( SVPDES_localidad( r0copo : r0cops ) )
           + COMI
           + COMA
           + %editc( r0suin : 'X' )
           + COMA
           + %editc( r0ainn : 'X' )
           + COMA
           + %editc( r0minn : 'X' )
           + COMA
           + %editc( r0dinn : 'X' )
           + COMA
           + %editc( r0suen : 'X' )
           + COMA
           + %editc( r0aegn : 'X' )
           + COMA
           + %editc( r0megn : 'X' )
           + COMA
           + %editc( r0degn : 'X' )
           + COMA
           + %editc( r0xpro : 'X' )
           + COMA
           + COMI
           + %trim( SVPDES_producto( r0rama : r0xpro ) )
           + COMI
           + COMA
           + %editc( r0sacm : 'P' )
           //%editw( r0sacm : maskBr )
           + COMA
           + %editw( r0prbp : ' 0 .  ' )
           + COMA
           + %editw( r0prgp : ' 0 .  ' )
           + COMA
           + COMI
           + %trim( r0clfr )
           + COMI
           + COMA
           + %editc( r0cagr : 'X' )
           + COMA
           + %editw( r0psmp : ' 0 .  ' )
           + COMA
           + COMI
           + %trim( r0crea )
           + COMI
           + COMA
           + %editc( r0ctar : 'X')
           + COMA
           + COMI
           + %trim( r0cta1 )
           + COMI
           + COMA
           + COMI
           + %trim( r0cta2 )
           + COMI
           + COMA
           + COMI
           + %trim( SVPDES_tarifaRv( r0rama :r0ctar : r0cta1 : r0cta2 ) )
           + COMI
           + COMA
           + %editc( r0cviv : 'X' )
           + COMA
           + COMI
           + %trim( SVPVIV_getDescViv( r0cviv ) )
           + COMI
           + COMA
           + COMI
           + %editc( dsHed0Tmp.d0endo : 'X' )
           + COMI
           + COMA
           + COMI
           + %editc( dsHed0Tmp.d0tiou : 'X' )
           + COMI
           + COMA
           + COMI
           + %editc( dsHed0Tmp.d0stou : 'X' )
           + COMI
           + COMA
           + COMI
           + %trim( dsHed0Tmp.d0mone )
           + COMI
           + COMA
           + COMI
           + %editc( dsHed0Tmp.d0come : 'P' )
           + COMI
           + COMA
           + COMI
           + %editc( @@suas : 'P' )
           + COMI
           + PARENC;
           rc = JDBC_ExecUpd( @@conn : s );
           SVPLVD_cleanUp( 'RNX0301' );

           if rc = -1;
             //error
             JDBC_Close( @@conn );
             return rc;
           endif;

         reade %kds( k1yer0 : 5 ) paher0;
       enddo;

           JDBC_Close( @@conn );
           return rc;

     P SVPLVD_setBienesAseguradosRV...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_setBienesAseguradosVida: Insertar BS Vida             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     P SVPLVD_setBienesAseguradosVida...
     P                 B                   export
     D SVPLVD_setBienesAseguradosVida...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

     D rc              s             10i 0
     D s               s          32767a   varying
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D @@conn          s                   like(Connection)
     D tmpfec          s               d   datfmt(*usa) inz
     D tmpHor          s               t   timfmt(*hms)
     D @@datd          s              3     inz
     D @@nomi          s              7  0  inz

     D k1yev1          ds                  likerec( p1hev1 : *key )
     D k1yev0          ds                  likerec( p1hev0 : *key )
     D k1ynx1          ds                  likerec( p1hnx1 : *key )

     d k1hed0          ds                  likerec( p1hed0 : *key )
     d dsHed0Tmp       ds                  likerec( p1hed0 : *input )
     d @@suas          s             15  2

      /free

       SVPLVD_inz();

       if SVPLVD_getConfiguracion(@@conf) = -1;
         // Error
         return -1;
       endif;

       if SVPLVD_Connect( @@conn
                        : @@conf ) = -1;
         // error
         JDBC_Close( @@conn );
         return rc;
       endif;

       if SVPLVD_chkNominaExterna( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol
                                 : @@nomi );
         k1yev0.v0empr = peEmpr;
         k1yev0.v0sucu = peSucu;
         k1yev0.v0arcd = peArcd;
         k1yev0.v0spol = peSpol;
         setgt  %kds( k1yev0 : 4 ) pahev0;
         readpe %kds( k1yev0 : 4 ) pahev0;
         if not %eof( pahev0 );
           k1yev1.v1empr =  v0empr;
           k1yev1.v1sucu =  v0sucu;
           k1yev1.v1arcd =  v0arcd;
           k1yev1.v1spol =  v0spol;
           k1yev1.v1sspo =  v0sspo;
           k1yev1.v1rama =  v0rama;
           k1yev1.v1arse =  v0arse;
           k1yev1.v1oper =  v0oper;
           k1yev1.v1poco =  v0poco;
           k1yev1.v1paco =  v0paco;
           chain %kds( k1yev1 : 10 ) pahev1;
           if not %found( pahev1 );
             return -1;
           endif;
         else;
           return -1;
         endif;

         clear k1hed0;
         k1hed0.d0empr = peEmpr;
         k1hed0.d0sucu = peSucu;
         k1hed0.d0arcd = peArcd;
         k1hed0.d0spol = peSpol;
         k1hed0.d0sspo = peSspo;
         setgt %kds( k1hed0 : 5 ) pahed0;
         readpe %kds( k1hed0 : 5 ) pahed0 dsHed0Tmp;
         if %eof( pahed0 );
           clear dsHed0Tmp;
         endif;
         if dsHed0Tmp.d0come = *zeros;
           dsHed0Tmp.d0come = 1;
         endif;

         k1ynx1.n1empr = peEmpr;
         k1ynx1.n1sucu = peSucu;
         k1ynx1.n1nomi = @@nomi;
         setll %kds( k1ynx1 : 3 ) pahnx1;
         reade %kds( k1ynx1 : 3 ) pahnx1;
           dow not %eof( pahnx1 );

             SVPDES_tipoDocumento( n1tido : @@datd );

             @@suas = n1suas * dsHed0Tmp.d0come;

             s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
              +  %trim( @@conf.tabv)
              + ' (v0rama, v0poli, v0poco, v0paco, v0sspo, v0nrdf, v0nomb, '
              + '  v0tido, v0datd, v0dtdo, v0nrdo, v0fnaa, v0fnam, v0fnad, '
              + '  v0fiea, v0fiem, v0fied, v0nrla, v0nrln, v0suin, v0ainn, '
              + '  v0minn, v0dinn, v0suen, v0aegn, v0megn, v0degn, v0sexo, '
              + '  v0dsex, v0esci, v0desc, v0naci, v0acti, v0cate, v0actd, '
              + '  v0sacm, v0suas, v0samo, v0pcap, v0xpro, v0prds, v0cant, '
              + '  v0suel, '
              + '  v0endo, v0tiou, v0stou, v0mone, v0come, v0suap ) '
              + 'VALUES '
              + PARENA
              + %editc( v0rama : 'X' )
              + COMA
              + %editc( v0poli : 'X' )
              + COMA
              + %editc( n1poco : 'X' )
              + COMA
              + %editc( v0paco : 'X' )
              + COMA
              + %editc( v0sspo : 'X' )
              + COMA
              + %editc( v0nrdf : 'X' )
              + COMA
              + COMI
              + %trim( n1nomb )
              + COMI
              + COMA
              + %editc( n1tido : 'X' )
              + COMA
              + COMI
              + %trim( @@datd )
              + COMI
              + COMA
              + COMI
              + %trim( SVPDES_tipoDocumento( n1tido ) )
              + COMI
              + COMA
              + %editc( n1nrdo : 'X' )
              + COMA
              + %editc( n1fnaa : 'X' )
              + COMA
              + %editc( n1fnam : 'X' )
              + COMA
              + %editc( n1fnad : 'X' )
              + COMA
              + %editc( n1fiea : 'X' )
              + COMA
              + %editc( n1fiem : 'X' )
              + COMA
              + %editc( n1fied : 'X' )
              + COMA
              + COMI
              + %trim( n1nrla )
              + COMI
              + COMA
              + %editc( n1nrln : 'X' )
              + COMA
              + %editc( n1suin : 'X' )
              + COMA
              + %editc( n1ainn : 'X' )
              + COMA
              + %editc( n1minn : 'X' )
              + COMA
              + %editc( n1dinn : 'X' )
              + COMA
              + %editc( n1suen : 'X' )
              + COMA
              + %editc( n1aegn : 'X' )
              + COMA
              + %editc( n1megn : 'X' )
              + COMA
              + %editc( n1degn : 'X' )
              + COMA
              + %editc( n1sexo : 'X' )
              + COMA
              + COMI
              + %trim( SVPDES_sexo( n1sexo ) )
              + COMI
              + COMA
              + %editc( n1esci : 'X' )
              + COMA
              + COMI
              + %trim( SVPDES_estadoCivil( n1esci ) )
              + COMI
              + COMA
              + COMI
              + %trim( v0naci )
              + COMI
              + COMA
              + %editc( v0acti : 'X' )
              + COMA
              + COMI
              + %editc( v0cate : 'X' )
              + COMI
              + COMA
              + COMI
              + %trim( SVPDES_actividad( v0acti ) )
              + COMI
              + COMA
              + %editw( v1sacm : maskBr )
              + COMA
              + %editc( n1suas :'X' )
              + COMA
              + %editc( v1samo : 'X' )
              + COMA
              + %editw( v1pcap : ' 0 .  ')
              + COMA
              + %editc( v1xpro : 'X' )
              + COMA
              + COMI
              + %trim( SVPDES_producto ( v0rama : v1xpro ) )
              + COMI
              + COMA
              + %editc( n1cant : 'X' )
              + COMA
              + %editw( n1suel : maskBr )
              + COMA
              + COMI
              + %editc( dsHed0Tmp.d0endo : 'X' )
              + COMI
              + COMA
              + COMI
              + %editc( dsHed0Tmp.d0tiou : 'X' )
              + COMI
              + COMA
              + COMI
              + %editc( dsHed0Tmp.d0stou : 'X' )
              + COMI
              + COMA
              + COMI
              + %trim( dsHed0Tmp.d0mone )
              + COMI
              + COMA
              + COMI
              + %editc( dsHed0Tmp.d0come : 'P' )
              + COMI
              + COMA
              + COMI
              + %editc( @@suas : 'P' )
              + COMI
              + PARENC;

              rc = JDBC_ExecUpd( @@conn : s );
              SVPLVD_cleanUp( 'RNX0301' );
              if rc = -1;
                //error
                JDBC_Close( @@conn );
               return rc;
              endif;

           reade %kds( k1ynx1 : 3 ) pahnx1;
          enddo;
       else;
         k1yev0.v0empr = peEmpr;
         k1yev0.v0sucu = peSucu;
         k1yev0.v0arcd = peArcd;
         k1yev0.v0spol = peSpol;
         setll %kds( k1yev0 : 4 ) pahev0;
         reade %kds( k1yev0 : 4 ) pahev0;
         dow not %eof( pahev0 );
           k1yev1.v1empr =  v0empr;
           k1yev1.v1sucu =  v0sucu;
           k1yev1.v1arcd =  v0arcd;
           k1yev1.v1spol =  v0spol;
           k1yev1.v1sspo =  v0sspo;
           k1yev1.v1rama =  v0rama;
           k1yev1.v1arse =  v0arse;
           k1yev1.v1oper =  v0oper;
           k1yev1.v1poco =  v0poco;
           k1yev1.v1paco =  v0paco;
           chain %kds( k1yev1 : 10 ) pahev1;
           if %found( pahev1 );
             SVPDES_tipoDocumento( v0tido : @@datd );

             clear k1hed0;
             k1hed0.d0empr = peEmpr;
             k1hed0.d0sucu = peSucu;
             k1hed0.d0arcd = peArcd;
             k1hed0.d0spol = peSpol;
             k1hed0.d0sspo = peSspo;
             setgt %kds( k1hed0 : 5 ) pahed0;
             readpe %kds( k1hed0 : 5 ) pahed0 dsHed0Tmp;
             if %eof( pahed0 );
               clear dsHed0Tmp;
             endif;
             if dsHed0Tmp.d0come = *zeros;
               dsHed0Tmp.d0come = 1;
             endif;
             @@suas = v1suas * dsHed0Tmp.d0come;

             s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
              +  %trim( @@conf.tabv)
              + ' (v0rama, v0poli, v0poco, v0paco, v0sspo, v0nrdf, v0nomb, '
              + '  v0tido, v0datd, v0dtdo, v0nrdo, v0fnaa, v0fnam, v0fnad, '
              + '  v0fiea, v0fiem, v0fied, v0nrla, v0nrln, v0suin, v0ainn, '
              + '  v0minn, v0dinn, v0suen, v0aegn, v0megn, v0degn, v0sexo, '
              + '  v0dsex, v0esci, v0desc, v0naci, v0acti, v0cate, v0actd, '
              + '  v0sacm, v0suas, v0samo, v0pcap, v0xpro, v0prds, v0cant, '
              + '  v0suel, '
              + '  v0endo, v0tiou, v0stou, v0mone, v0come, v0suap ) '
              + 'VALUES '
              + PARENA
              + %editc( v0rama : 'X' )
              + COMA
              + %editc( v0poli : 'X' )
              + COMA
              + %editc( v0poco : 'X' )
              + COMA
              + %editc( v0paco : 'X' )
              + COMA
              + %editc( v0sspo : 'X' )
              + COMA
              + %editc( v0nrdf : 'X' )
              + COMA
              + COMI
              + %trim( SVPDAF_getNombre( v0nrdf ) )
              + COMI
              + COMA
              + %editc( v0tido : 'X' )
              + COMA
              + COMI
              + %trim( @@datd )
              + COMI
              + COMA
              + COMI
              + %trim( SVPDES_tipoDocumento( v0tido ) )
              + COMI
              + COMA
              + %editc( v0nrdo : 'X' )
              + COMA
              + %editc( v0fnaa : 'X' )
              + COMA
              + %editc( v0fnam : 'X' )
              + COMA
              + %editc( v0fnad : 'X' )
              + COMA
              + %editc( v0fiea : 'X' )
              + COMA
              + %editc( v0fiem : 'X' )
              + COMA
              + %editc( v0fied : 'X' )
              + COMA
              + COMI
              + %trim( v0nrla )
              + COMI
              + COMA
              + %editc( v0nrln : 'X' )
              + COMA
              + %editc( v0suin : 'X' )
              + COMA
              + %editc( v0ainn : 'X' )
              + COMA
              + %editc( v0minn : 'X' )
              + COMA
              + %editc( v0dinn : 'X' )
              + COMA
              + %editc( v0suen : 'X' )
              + COMA
              + %editc( v0aegn : 'X' )
              + COMA
              + %editc( v0megn : 'X' )
              + COMA
              + %editc( v0degn : 'X' )
              + COMA
              + %editc( v0sexo : 'X' )
              + COMA
              + COMI
              + %trim( SVPDES_sexo( v0sexo ) )
              + COMI
              + COMA
              + %editc( v0esci : 'X' )
              + COMA
              + COMI
              + %trim( SVPDES_estadoCivil( v0esci ) )
              + COMI
              + COMA
              + COMI
              + %trim( v0naci )
              + COMI
              + COMA
              + %editc( v0acti : 'X' )
              + COMA
              + COMI
              + %editc( v0cate : 'X' )
              + COMI
              + COMA
              + COMI
              + %trim( SVPDES_actividad( v0acti ) )
              + COMI
              + COMA
              + %editc( v1sacm : 'P' )
              //%editw( v1sacm : maskBr )
              + COMA
              + %editc( v1suas :'P' )
              //%editc( v1suas :'X' )
              + COMA
              + %editc( v1samo : 'P' )
              //%editc( v1samo : 'X' )
              + COMA
              + %editw( v1pcap : ' 0 .  ')
              + COMA
              + %editc( v1xpro : 'X' )
              + COMA
              + COMI
              + %trim( SVPDES_producto ( v0rama : v1xpro ) )
              + COMI
              + COMA
              + %editc( v1cant : 'X' )
              + COMA
              + %editc( v1suel : 'P' )
              // %editw( v1suel : maskBr )
              + COMA
              + COMI
              + %editc( dsHed0Tmp.d0endo : 'X' )
              + COMI
              + COMA
              + COMI
              + %editc( dsHed0Tmp.d0tiou : 'X' )
              + COMI
              + COMA
              + COMI
              + %editc( dsHed0Tmp.d0stou : 'X' )
              + COMI
              + COMA
              + COMI
              + %trim( dsHed0Tmp.d0mone )
              + COMI
              + COMA
              + COMI
              + %editc( dsHed0Tmp.d0come : 'P' )
              + COMI
              + COMA
              + COMI
              + %editc( @@suas : 'P' )
              + COMI
              + PARENC;

              rc = JDBC_ExecUpd( @@conn : s );
              SVPLVD_cleanUp( 'RNX0301' );
              if rc = -1;
                //error
                JDBC_Close( @@conn );
               return rc;
              endif;

           endif;
          reade %kds( k1yev0 : 4 ) pahev0;
         enddo;
       endif;
       JDBC_Close( @@conn );
       return rc;

     P SVPLVD_setBienesAseguradosVida...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_chkNominaExterna: Retorna si tiene Nomina             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peNomi   (output)  Nomina                                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPLVD_chkNominaExterna...
     P                 B                   Export
     D SVPLVD_chkNominaExterna...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNomi                       7  0 options( *nopass : *omit )

     D   k1ynx0        ds                  likerec( p1hnx002 : *key )

      /free
         k1ynx0.n0empr = peEmpr;
         k1ynx0.n0sucu = peSucu;
         k1ynx0.n0arcd = peArcd;
         k1ynx0.n0spol = peSpol;
         chain %kds( k1ynx0 : 4 ) pahnx002;
         if %found( pahnx002 );
           if %parms >= 5 and %addr(peNomi) <> *NULL;
             peNomi =  n0nomi;
             return *on;
           endif;
             return *off;
         endif;
         return *off;
      /end-free

     P SVPLVD_chkNominaExterna...
     P                 E

      * ------------------------------------------------------------ *
      * SVPLVD_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPLVD_inz      B                   export
     D SVPLVD_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set330);
          open set330;
       endif;

       if not %open(pahec1);
          open pahec1;
       endif;

       if not %open(pahec0);
          open pahec0;
       endif;

       if not %open(paher0);
          open paher0;
       endif;

       if not %open(pahet0);
          open pahet0;
       endif;

       if not %open(pahev0);
          open pahev0;
       endif;

       if not %open(pahev1);
          open pahev1;
       endif;

       if not %open(pahnx002);
          open pahnx002;
       endif;

       if not %open(pahnx1);
          open pahnx1;
       endif;

       if not %open(gnhdaf);
          open gnhdaf;
       endif;

       if not %open(sehase);
         open sehase;
       endif;

       if not %open(pahed0);
         open pahed0;
       endif;

       if not %open(pahscd);
         open pahscd;
       endif;

       if not %open(pahsd0);
         open pahsd0;
       endif;

       if not %open(cnhopa);
         open cnhopa;
       endif;

       if not %open(cntcau);
         open cntcau;
       endif;

       initialized = *ON;

       return;

      /end-free

     P SVPLVD_inz      E

      * ------------------------------------------------------------ *
      * SVPLVD_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPLVD_End      B                   export
     D SVPLVD_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPLVD_End      E

      * ------------------------------------------------------------ *
      * SVPLVD_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPLVD_Error    B                   export
     D SVPLVD_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPLVD_Error    E

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
      * SVPLVD_Connect: Conexión a base SQL                          *
      *                                                              *
      *     peConf   (input)   Configuracion                         *
      *     peConn   (output)  Objeto Conexion                       *
      *                                                              *
      * Return 0 / -1                                                *
      * ------------------------------------------------------------ *
     P SVPLVD_Connect...
     P                 B
     D SVPLVD_Connect...
     D                 pi             1  0
     D peConn                              like(Connection)
     D peConf                              likeds(SVPLVD_Conf_t)

      /free

        peConn = JDBC_connect( %trim(peConf.driv)
                             : %trim(peConf.durl)
                             : %trim(peConf.bddu)
                             : %trim(peConf.pass) );
        if (peConn = *NULL);
            return -1;
        endif;

       return 0;

      /end-free

     P SVPLVD_Connect...
     P                 E
      * ------------------------------------------------------------ *
      * SVPLVD_Close: Cierra conexion                                *
      *                                                              *
      *     peConn   (input)  Objeto Conexion                        *
      *                                                              *
      * Return *on / *off                                            *
      * ------------------------------------------------------------ *
     P SVPLVD_Close...
     P                 B
     D SVPLVD_Close...
     D                 pi              n
     D peConn                              like(Connection)

      /free

        JDBC_Close(peConn);

       return *on;

      /end-free

     P SVPLVD_Close...
     P                 E
      * ------------------------------------------------------------ *
      * SVPLVD_cleanUp(): Elimina mensajes controlados del Joblog.   *
      *                                                              *
      *     peMsid (input)  ID de mensaje a eliminar.                *
      *                                                              *
      * retorna: *void                                               *
      * ------------------------------------------------------------ *
     P SVPLVD_cleanUp  B
     D SVPLVD_cleanUp  pi             1N
     D  peMsid                        7a   const

     D QMHRCVPM        pr                  ExtPgm('QMHRCVPM')
     D   MsgInfo                  32766a   options(*varsize)
     D   MsgInfoLen                  10i 0 const
     D   Format                       8a   const
     D   StackEntry                  10a   const
     D   StackCount                  10i 0 const
     D   MsgType                     10a   const
     D   MsgKey                       4a   const
     D   WaitTime                    10i 0 const
     D   MsgAction                   10a   const
     D   ErrorCode                32766a   options(*varsize)

     D RCVM0100_t      ds                  qualified based(TEMPLATE)
     D  BytesRet                     10i 0
     D  BytesAva                     10i 0
     D  MessageSev                   10i 0
     D  MessageId                     7a
     D  MessageType                   2a
     D  MessageKey                    4a
     D  Reserved1                     7a
     D  CCSID_st                     10i 0
     D  CCSID                        10i 0
     D  DataLen                      10i 0
     D  DataAva                      10i 0
     D  Data                        256a

     D RCVM0100        ds                  likeds(RCVM0100_t)

     D ErrorCode       ds
     D  EC_BytesPrv                  10i 0 inz(0)
     D  EC_BytesAva                  10i 0 inz(0)

     D StackCnt        s             10i 0 inz(1)
     D MsgKey          s              4a

      /free

       for StackCnt = 1 to 10;
         MsgKey = *ALLx'00';

         QMHRCVPM( RCVM0100
                 : %size(RCVM0100)
                 : 'RCVM0100'
                 : '*'
                 : StackCnt
                 : '*PRV'
                 : MsgKey
                 : 0
                 : '*SAME'
                 : ErrorCode        );

         if ( RCVM0100.MessageId <> peMsid );
            return *OFF;
         endif;

         MsgKey = RCVM0100.MessageKey;

         QMHRCVPM( RCVM0100
                 : %size(RCVM0100)
                 : 'RCVM0100'
                 : '*'
                 : StackCnt
                 : '*ANY'
                 : MsgKey
                 : 0
                 : '*REMOVE'
                 : ErrorCode        );

         return *ON;
       endfor;

      /end-free

     P SVPLVD_cleanUp  E

      * ------------------------------------------------------------ *
      * SVPLVD_setPagosTesoreria                                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArtc   (input)   Codigo Area Tecnica                   *
      *     pePacp   (input)   Nro. Comprobante Pago                 *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     P SVPLVD_setPagosTesoreria...
     P                 B                   export
     D SVPLVD_setPagosTesoreria...
     D                 pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

     D rc              s             10i 0
     D s               s          32767a   varying
     D @@conf          ds                  likeds(SVPLVD_Conf_t)
     D @@conn          s                   like(Connection)

     d k1Hopa          ds                  likerec( c1hopa : *key )
     d dsHopaTmp       ds                  likerec( c1hopa : *input )

     d k1Hscd          ds                  likerec( p1hscd : *key )
     d dsHscdTmp       ds                  likerec( p1hscd : *input )

     d k1tcau          ds                  likerec( c1tcau : *key )
     d dsTcauTmp       ds                  likerec( c1tcau : *input )

     d @@Poli          s              7  0

     D @@cuil          s             11  0 inz
     D @@cuit          s             11    inz
     D @@pain          s              5  0 inz
     D @@paid          s             30    inz
     D @@cprf          s              3  0 inz
     D @@dprf          s             25    inz
     D @@tiso          s              2  0 inz
     D @@dtis          s             25    inz
     D @@bloq          s              1    inz
     D @@mota          s             50    inz
     D @@civa          s              1  0 inz
     D @@femi          s              8  0 inz
     D @1femi          s             10    inz
     D @1Nomb          s             40    inz
     D @1Domi          s             35    inz
     D @1Ndom          s              5  0 inz
     D @1Piso          s              3  0 inz
     D @1Deto          s              4    inz
     D @@copo          s              5  0 inz
     D @@cops          s              1  0 inz
     D @1Teln          s              7  0 inz
     D @1Faxn          s              7  0 inz
     D @1Tiso          s              2  0 inz
     D @@Tido          s              2  0 inz
     D @@Nrdo          s              8  0 inz
     D @1Cuit          s             11    inz
     D @1Njub          s             11  0 inz
     D @1Fnac          s              8  0 inz
     D @1Cprf          s              3  0 inz
     D @1Sexo          s              1  0 inz
     D @1Esci          s              1  0 inz
     D @1Raae          s              3  0 inz
     D @1Ciiu          s              6  0 inz
     D @1Dom2          s             50    inz
     D @1Lnac          s             30    inz
     D @1Pesk          s              5  2 inz
     D @1Estm          s              3  2 inz
     D @1Mfum          s              1    inz
     D @1Mzur          s              1    inz
     D @1Mar1          s              1    inz
     D @1Mar2          s              1    inz
     D @1Mar3          s              1    inz
     D @1Mar4          s              1    inz
     D @1Ccdi          s             11    inz
     D @1Pain          s              5  0 inz
     D @@Cnac          s              3  0 inz
     D @1copo          s              5  0 inz
     D @1cops          s              1  0 inz
     D @@enco          s                   like(*in50)
     D @@Nomb          s             40    inz
     d @@cbgi          s              3  0
     d @@dbgi          s             60
     d @@cbtr          s              3  0
     d @@dbtr          s             60

      /free

        SVPLVD_inz();

        if SVPLVD_getConfiguracion(@@conf) = -1;
          // Error
          return -1;
        endif;

        if SVPLVD_Connect( @@conn : @@conf ) = -1;
          // error
          JDBC_Close( @@conn );
          return -1;
        endif;

        // Get Datos CNHOPA
        clear k1Hopa;
        k1Hopa.paempr = peEmpr;
        k1Hopa.pasucu = peSucu;
        k1Hopa.paartc = peArtc;
        k1Hopa.papacp = pePacp;
        chain %kds( k1Hopa ) cnhopa dsHopaTmp;
        if not %found( cnhopa );
          clear dsHopaTmp;
        endif;
        if dsHopaTmp.paimme = *zeros and dsHopaTmp.paimco = *zeros;
          dsHopaTmp.paimme = dsHopaTmp.paimau;
          dsHopaTmp.paimco = 1;
        endif;

        // Get Datos Siniestro / Poliza
        clear k1Hscd;
        k1Hscd.cdempr = peEmpr;
        k1Hscd.cdsucu = peSucu;
        k1Hscd.cdrama = dsHopaTmp.parama;
        k1Hscd.cdsini = dsHopaTmp.paliqn;
        setgt %kds( k1Hscd : 4 ) pahscd;
        readpe %kds( k1Hscd : 4 ) pahscd dsHscdTmp;
        if %eof( paHscd );
          clear dsHscdTmp;
        endif;
        @@Poli = dsHscdTmp.cdpoli;

        // Tomar datos del Cliente
        if not SVPDAF_getDocumento( dsHscdTmp.cdasen
                                  : *omit
                                  : *omit
                                  : @@cuit
                                  : @@cuil
                                  : *omit  );
        endif;

        if @@cuit = *blanks;
           @@cuit = *all'0';
        endif;

        @@pain = SVPDAF_getNacionalidad( dsHscdTmp.cdasen
                                       : @@paid );

        if not SVPDAF_getDaf( dsHscdTmp.cdasen
                            : @@Nomb
                            : @1Domi
                            : @1Ndom
                            : @1Piso
                            : @1Deto
                            : @@copo
                            : @@cops
                            : @1Teln
                            : @1Faxn
                            : @1Tiso
                            : @@tido
                            : @@nrdo
                            : @1Cuit
                            : @1Njub );
        endif;

        if not SVPDAF_getDa1( dsHscdTmp.cdasen
                            : @1Nomb
                            : @1Domi
                            : @1Copo
                            : @1Cops
                            : @1Teln
                            : @1Fnac
                            : @1Cprf
                            : @1Sexo
                            : @1Esci
                            : @1Raae
                            : @1Ciiu
                            : @1Dom2
                            : @1Lnac
                            : @1Pesk
                            : @1Estm
                            : @1Mfum
                            : @1Mzur
                            : @1Mar1
                            : @1Mar2
                            : @1Mar3
                            : @1Mar4
                            : @1Ccdi
                            : @1Pain
                            : @@Cnac );
        endif;

        // Get Datos CNTCAU
        clear k1Tcau;
        k1Tcau.caempr = peEmpr;
        k1Tcau.cacoma = dsHopaTmp.pbcoma;
        chain %kds( k1Tcau ) cntcau dsTcauTmp;
        if not %found( cntcau );
          clear dsTcauTmp;
        endif;

        clear @@cbgi;
        clear @@dbgi;
        clear @@cbtr;
        clear @@dbtr;
        if dsHopaTmp.paivcv = 1;
          monitor;
            @@cbgi = %dec( dsHopaTmp.pbcoma : 2 : 0);
          on-error;
            clear @@cbgi;
          endmon;
          @@dbgi = %trim( dsTcauTmp.cancal );
        else;
          monitor;
            @@cbtr = %dec( dsHopaTmp.pbcoma : 2 : 0);
          on-error;
            clear @@cbtr;
          endmon;
          @@dbtr = %trim( dsTcauTmp.cancal );
        endif;

        s = 'INSERT INTO ' + %trim( @@conf.bddn ) + '.'
          +  %trim( @@conf.tabt)
          + ' ( pssini, psrama, pspoli, psmone, psimpp, psimmo, pstcam, '
          + '   pscfpg, psorch, pscbgi, psdbgi, pscbtr, psdbtr, psbenn, '
          + '   psbene, pstido, psnrdo, pscuil, pscuit, pspain ) '
          + ' VALUES '
          + PARENA
          + COMI
          + %trim(%editc(dsHopaTmp.paliqn : 'Z' ))
          + COMI
          + COMA
          + COMI
          + %trim(%editc( dsHopaTmp.parama : 'Z' ))
          + COMI
          + COMA
          + COMI
          + %trim(%editc( @@Poli : 'Z' ))
          + COMI
          + COMA
          + COMI
          + dsHopaTmp.pacomo
          + COMI
          + COMA
          + COMI
          + %editc( dsHopaTmp.paimau : 'P' )
          + COMI
          + COMA
          + COMI
          + %trim(%editc( dsHopaTmp.paimme : 'P' ))
          + COMI
          + COMA
          + COMI
          + %trim(%editc( dsHopaTmp.paimco : 'P' ))
          + COMI
          + COMA
          + COMI
          + %trim(%editc( dsHopaTmp.paivcv : 'X' ))
          + COMI
          + COMA
          + COMI
          + %trim(%editc( dsHopaTmp.pbivch : 'X' ))
          + COMI
          + COMA
          + %editc( @@cbgi : 'X' )
          + COMA
          + COMI
          + %trim(@@dbgi)
          + COMI
          + COMA
          + %editc( @@cbtr : 'X' )
          + COMA
          + COMI
          + %trim(@@dbtr)
          + COMI
          + COMA
          + COMI
          + %editc( dsHscdTmp.cdasen : 'X' )
          + COMI
          + COMA
          + COMI
          + %trim(@@Nomb)
          + COMI
          + COMA
          + COMI
          + %editc( @@tido : 'X' )
          + COMI
          + COMA
          + COMI
          + %editc( @@nrdo : 'X' )
          + COMI
          + COMA
          + %editc( @@cuil : 'X' )
          + COMA
          + %trim( @@cuit )
          + COMA
          + %editc( @@pain : 'X' )
          + PARENC;

          rc = JDBC_ExecUpd( @@conn : s );
          SVPLVD_cleanUp( 'RNX0301' );

          if rc = -1;
            // error
            JDBC_Close( @@conn );
            return rc;
          endif;

        JDBC_Close( @@conn );
        return rc;

     P SVPLVD_setPagosTesoreria...
     P                 E

