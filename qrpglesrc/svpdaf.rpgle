     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPDAF: Programa de Servicio.                                *
      *         Dato Filiatorio.                                     *
      *                                                              *
      * Alvarez Fernando                      2016/06/06             *
      *------------------------------------------------------------- *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -                  <*           *
      *>           BNDDIR(HDIILE/HDIBDIR) -             <*           *
      *> TEXT('Prorama de Servicio: Dato Filiatorio') <*        *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPDAF)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPDAF)) <*         *
      *> IGN: DLTSPLF FILE(SVPDAF)                           <*     *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * SFA 29/06/2016 Modifico Procedimientos                       *
      * SFA 28/07/2016 getDa8 agrego (n)                             *
      * SFA 23/08/2016 Modifico Procedimientos                       *
      * JSN 30/01/2017 Cambio de Minuscula a Mayuscula en el campo   *
      *                peDomi al momento de Guardar o actualizar el  *
      *                archivo GNHDAF                                *
      * SGF 17/07/2017 En SVPDAF controlo tipo y número de documento *
      *                sólo para personas físicas.                   *
      * JSN 03/05/2017 Se graba la fecha de registro correctamente   *
      *                en el procedimiento setda8.                   *
      * NWN 31/08/2017 Agregado de Procedimiento FECPRIPOL.          *
      * LRG 07/06/2017 Nuevos procedimientos getAseguradoxDoc,       *
      *                                      getAseguradoxCuit.-     *
      * GIO 01/12/2017 Agregado de Nuevos procedimientos:            *
      *                - SVPDAF_getListaAseguradoxDoc                *
      *                - SVPDAF_getListaAseguradoxCuit               *
      *                - SVPDAF_setllAseguradoxDoc                   *
      *                - SVPDAF_readAseguradoxDoc                    *
      *                - SVPDAF_setllAseguradoxCuit                  *
      *                - SVPDAF_readAseguradoxCuit                   *
      * JSN 01/02/2018 Modificación en procedimiento _getMailValido  *
      *                SOS - Transferencia de Datos                  *
      * JSN 25/01/2018 Nuevos procedimiento: SVPDAF_getDa9           *
      *                                      SVPDAF_setDa9           *
      *                                      SVPDAF_chkDa9           *
      *                                      SVPDAF_delDa9           *
      *                                      SVPDAF_updDa7           *
      *                                      SVPDAF_dltDa7_2         *
      * LRG 26/01/2018 Nuevos procedimiento: SVPDAF_chkDa62          *
      *                                      SVPDAF_chkDato72        *
      *                                      SVPDAF_getMailWeb       *
      *                                      SVPDAF_getMail          *
      * JSN 06/02/2018 Modificación en procedimiento _getDa1         *
      *                                              _getDa6         *
      *                                              _getDaf         *
      * JSN 18/02/2018 Nuevo procedimiento _chkda1, el mismo se      *
      *                agrego en los procedimientos: _getNombre,     *
      *                _getDomicilio, _getLocalidad, _getFechaNac,   *
      *                _getPaisdeNac, _getNacionalidad, _getProfesion*
      *                _getSujetoExterior, _updda, _setda1           *
      * JSN 02/03/2018 Nuevo procedimiento: _chkAseguradoxDoc:xCuit  *
      * JSN 31/07/2018 Nuevo procedimiento: _getDa12, _setDa12 y     *
      *                                     _updDa12                 *
      *                Modificación en los procedimientos: _getDa1,  *
      *                _setDa1 y _updDa1                             *
      * SGF 01/08/2018 Nuevo procedimiento: _chkGnhDad               *
      *                                     _setGnhDad               *
      *                                     _dltGnhDad               *
      * JSN 03/08/2018 Nuevo procedimiento: _updDa72                 *
      * GIO 19/01/2019 RM#03885 Autogestion Procesos Backend         *
      *                Ajusta Flags al grabar en GNHDA7 / GNHDA8     *
      * JSN 22/03/2021 Se modifica el procedimiento: _chkDatoF, se   *
      *                agrega el procedimiento: _dltGnhDadDaf        *
      * ************************************************************ *
     Fgnhdaf    uf a e           k disk    usropn
     Fgnhda1    uf a e           k disk    usropn
     Fgnhda2    uf a e           k disk    usropn
     Fgnhda4    uf a e           k disk    usropn
     Fgnhda6    uf a e           k disk    usropn
     Fgnhda7    uf a e           k disk    usropn
     Fgnhda8    uf a e           k disk    usropn
     Fpahec018  if   e           k disk    usropn
     Fgnhdaf05  if   e           k disk    usropn
     Fgnhdaf06  if   e           k disk    usropn
     Fgnhda9    uf a e           k disk    usropn
     Fgnhdad    uf a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

     D tmpfec          s               d   datfmt(*iso) inz

      ** - Area del Sistema. ---------------------------- *
     D                sds
     D  usjobn               244    253
     D  ususer               254    263
      *--- PR Externos --------------------------------------------- *
     D PGG010          pr                  extpgm('PGG010')
     D  nrdf                          7  0

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPDAF_chkDaf(): Chequea si existe Dato Filiatorio           *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDaf...
     P                 B                   export
     D SVPDAF_chkDaf...
     D                 pi              n
     D   peNrdf                       7  0 const

       SVPDAF_inz();

       setll peNrdf gnhdaf;

       if not %equal(gnhdaf);
         SetError( SVPDAF_DAFIN
                 : 'Dato Filiatorio Inexistente' );
         return *Off;
       endif;

       return *On;

     P SVPDAF_chkDaf...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkDatoF: Chequea si puede grabar en GNHDAF           *
      *                                                              *
      *     peNomb   (input)   Nombre                                *
      *     peDomi   (input)   Domicilio                             *
      *     peNdom   (input)   Nro. Domicilio                        *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTiso   (input)   Tipo de Sociedad                      *
      *     peTido   (input)   Tipo Documento                        *
      *     peNrdo   (input)   Nro. Documento                        *
      *     peDocu   (input)   Estructura Documentos (opcional)      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDatoF...
     P                 B                   export
     D SVPDAF_chkDatoF...
     D                 pi              n
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peNdom                       5  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTiso                       2  0 const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peDocu                            likeDs(dsDocu_t) const
     D                                     options(*nopass:*omit)

       SVPDAF_inz();

       if not SVPVAL_nombreCliente ( peNomb );
         return *Off;
       endif;

       if not SVPVAL_domiCliente ( peDomi : peNdom );
         return *Off;
       endif;

       if not SVPVAL_codigoPostal ( peCopo : peCops );
         return *Off;
       endif;

       if not SVPVAL_chkTipoPersona ( peTiso );
         return *Off;
       endif;

       if not SVPVAL_tipoDeDocumento ( peTido ) and peTiso = 98;
         return *Off;
       endif;

       if not SVPVAL_nroDeDocumento ( peNrdo ) and peTiso = 98;
         return *Off;
       endif;

       if peNrdo > *zero and ( peTiso = 80 or peTiso = 81 );
         if not SVPVAL_nroDeDocumento ( peNrdo );
           return *off;
         endif;
       endif;

       if %parms >= 9 and %addr(peDocu) <> *null;
          if peTiso <> 98;
            select;
              when peTiso <> 80 and peTiso <> 81;
                if SVPVAL_CuitCuil( %trim(peDocu.cuit) ) = *OFF;
                  return *off;
                endif;
              when ( peTiso = 80 or peTiso = 81 ) and peDocu.cuil <> 0;
                if SVPVAL_CuitCuil( %trim(peDocu.cuit) ) = *OFF;
                  return *off;
                endif;
            endsl;
          endif;
       endif;

       if %parms >= 9 and %addr(peDocu) <> *null;
          if peDocu.cuil <> 0 and peTiso = 98;
             if SVPVAL_CuitCuil( %editc(peDocu.cuil:'X') ) = *OFF;
                return *off;
             endif;
          endif;
       endif;

       return *on;

     P SVPDAF_chkDatoF...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato1:  Chequea si puede grabar en GNHDA1          *
      *                                                              *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     pePain   (input)   Código de Pais                        *
      *     peCnac   (input)   Código de Nacionalidad                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDato1...
     P                 B                   export
     D SVPDAF_chkDato1...
     D                 pi              n
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const

       SVPDAF_inz();

       if peCopo <> *Zeros;
         if not SVPVAL_codigoPostal ( peCopo : peCops );
           return *Off;
         endif;
       endif;

       if peFnac <> *Zeros;
         monitor;
         tmpFec = %date( %char ( peFnac ) : *iso0 );
         on-error;
           SetError( SVPDAF_FEBII
                   : 'Fecha de Nacimiento invalida');
           return *off;
         endmon;
       endif;

       if peCprf <> *Zeros;
         if not SVPVAL_chkProfesion ( peCprf );
           return *Off;
         endif;
       endif;

       if peEsci <> *Zeros;
         if not SVPVAL_chkEdoCivil ( peEsci );
           return *Off;
         endif;
       endif;

       if peRaae <> *Zeros;
         if not SVPVAL_chkRamaActE ( peRaae );
           return *Off;
         endif;
       endif;

       if pePain <> *Zeros;
         if not SVPVAL_chkPaisNac ( pePain );
           return *Off;
         endif;
       endif;

       if peCnac <> *Zeros;
         if not SVPVAL_nacionalidad ( peCnac );
           return *Off;
         endif;
       endif;

       return *on;

     P SVPDAF_chkDato1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato2: Valida datos de Provincia IIBB              *
      *                                                              *
      *     peRpro   (input)   Provincia                             *
      *     peFech   (input)   Fecha Base Impuesto                   *
      *     peNri1   (input)   Nro Insc Ibr                          *
      *     peNri2   (input)   Nro Insc Ibr C Mult                   *
      *     peNri3   (input)   Nro Insc Ibr Nuevo                    *
      *     peNri4   (input)   Nro Insc Impuesto                     *
      *     peIim1   (input)   Importe Nri1                          *
      *     peStrg   (input)   Hacer Percepcion                      *
      *     peNnib   (input)   Nro Nuevo Ibr                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDato2...
     P                 B                   export
     D SVPDAF_chkDato2...
     D                 pi              n
     D   peRpro                       2  0 const
     D   peFech                       8  0 const
     D   peNri1                      13  0 const
     D   peNri2                      13  0 const
     D   peNri3                      13  0 const
     D   peNri4                      13  0 const
     D   peIim1                      15  2 const
     D   peStrg                       1    const
     D   peNnib                      14    const

       SVPDAF_inz();

       if not SVPVAL_chkProvinciaInder( peRpro );
         return *Off;
       endif;

       monitor;
       tmpFec = %date( %char ( peFech ) : *iso0 );
       on-error;
         SetError( SVPDAF_FEBII
                 : 'Fecha de Base de impuestos invalida');
         return *off;
       endmon;

       if peNri1 = *Zeros and peNnib = *Blanks;
         SetError( SVPDAF_NRIBR
                 : 'Ingresar Nro de Inscripcion a Ingresos Brutos');
         return *off;
       endif;

       if peStrg <> '0' and  peStrg <> '1';
         SetError( SVPDAF_ESTRG
                 : 'Estado de Registro debe ser Si o No');
         return *off;
       endif;

       return *On;

     P SVPDAF_chkDato2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato6:  Chequea si puede grabar en GNHDA6          *
      *                                                              *
      *     pePweb   (input)   Pagina Web                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDato6...
     P                 B                   export
     D SVPDAF_chkDato6...
     D                 pi              n
     D   pePweb                      50    const

       SVPDAF_inz();

       if pePweb <> *Blanks;
         if not SVPVAL_urlIsValid ( %trim(pePweb)
                                  : %len ( %trim(pePweb) ) );
           return *Off;
         endif;
       endif;

       return *on;

     P SVPDAF_chkDato6...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato7: Valida para Grabar en GNHDA7                *
      *                                                              *
      *     peCtce   (input)   Tipo de Mail                          *
      *     peMail   (input)   Mail                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDato7...
     P                 B                   export
     D SVPDAF_chkDato7...
     D                 pi              n
     D   peCtce                       2  0 const
     D   peMail                      50    const

     D k1yda7          ds                  likerec(g1hda7:*Key)

       SVPDAF_inz();

       if not SVPVAL_tipoMail ( peCtce );
         return *Off;
       endif;

       if not MAIL_isValid( peMail );
         SetError( SVPDAF_MERRO
                 : 'Mail Invalido' );
         return *Off;
       endif;

       return *on;

     P SVPDAF_chkDato7...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_chkDato8: Valida CBU para pago de Siniestros          *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peFech   (input)   Fecha Desde                           *
      *     peNcbu   (input)   CBU                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDato8...
     P                 B                   export
     D SVPDAF_chkdato8...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peFech                       8  0 const
     D   peNcbu                      22a   const

     D @@ivbc          s              3  0
     D @@ivsu          s              3  0
     D @@tcta          s              2  0
     D @@ncta          s             25

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       if not SPVCBU_GetCBUSeparado ( peNcbu : @@ivbc : @@ivsu : @@tcta
                                    : @@ncta );
         return *Off;
       endif;

       monitor;
       tmpFec = %date( %char ( peFech ) : *iso0 );
       on-error;
         SetError( SVPDAF_FEBII
                 : 'Fecha Desde Invalida');
         return *off;
       endmon;

       return *on;

     P SVPDAF_chkDato8...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getNroDaf(): Retorna NUEVO Numero de Dato Filiatorio  *
      *                                                              *
      * Retorna: NUEVO Numero de Dato Filiatorio                     *
      * ------------------------------------------------------------ *
     P SVPDAF_getNroDaf...
     P                 B                   export
     D SVPDAF_getNroDaf...
     D                 pi             7  0

     D @@nrdf          s              7  0

       SVPDAF_inz();

       PGG010 ( @@nrdf );

       return @@nrdf;

     P SVPDAF_getNroDaf...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDaf: Retorna GNHDAF                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (output)  Nombre                                *
      *     peDomi   (output)  Domicilio                             *
      *     peNdom   (output)  Nro. Domicilio                        *
      *     pePiso   (output)  Piso                                  *
      *     peDeto   (output)  Departamento                          *
      *     peCopo   (output)  Codigo Postal                         *
      *     peCops   (output)  SubCodigo Postal                      *
      *     peTeln   (output)  Nro. Telefono                         *
      *     peFaxn   (output)  Nro. Fax                              *
      *     peTiso   (output)  Tipo de Sociedad                      *
      *     peTido   (output)  Tipo Documento                        *
      *     peNrdo   (output)  Nro. Documento                        *
      *     peCuit   (output)  CUIT                                  *
      *     peNjub   (output)  Nro. Jubilacion                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDaf...
     P                 B                   export
     D SVPDAF_getDaf...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                      40
     D   peDomi                      35
     D   peNdom                       5  0
     D   pePiso                       3  0
     D   peDeto                       4
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peTeln                       7  0
     D   peFaxn                       7  0
     D   peTiso                       2  0
     D   peTido                       2  0
     D   peNrdo                       8  0
     D   peCuit                      11
     D   peNjub                      11  0

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       chain(n) peNrdf gnhdaf;
       if %found( gnhdaf );

         peNomb = dfnomb;
         peDomi = dfdomi;
         peNdom = dfndom;
         pePiso = dfpiso;
         peDeto = dfdeto;
         peCopo = dfcopo;
         peCops = dfcops;
         peTeln = dfteln;
         peFaxn = dffaxn;
         peTiso = dftiso;
         peTido = dftido;
         peNrdo = dfnrdo;
         peCuit = dfcuit;
         peNjub = dfnjub;

       endif;

       return *on;

     P SVPDAF_getDaf...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDa1: Retorna GNHDA1                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (output)  Nombre Alternativo                    *
      *     peDomi   (output)  Domicilio Postal                      *
      *     peCopo   (output)  Codigo Postal                         *
      *     peCops   (output)  SubCodigo Postal                      *
      *     peTeln   (output)  Telefono                              *
      *     peFnac   (output)  Fecha de Nacimiento                   *
      *     peCprf   (output)  Codigo de Profesion                   *
      *     peSexo   (output)  Codigo de Sexo                        *
      *     peEsci   (output)  Código de estado Civil                *
      *     peRaae   (output)  Código de Rama Actividad Económica    *
      *     peCiiu   (output)  Ciiu                                  *
      *     peDom2   (output)  Domicilio                             *
      *     pePesk   (output)  Peso                                  *
      *     peEstm   (output)  Estatura                              *
      *     peMfum   (output)  Marca de Fuma                         *
      *     peMzur   (output)  Marca de Zurdo                        *
      *     peMar1   (output)  Pago Aporte Previsional               *
      *     peMar2   (output)  Sujeto Exterior                       *
      *     peMar3   (output)  Constancia Empadronamiento AFIP       *
      *     peMar4   (output)  Acreedor Prendario                    *
      *     peCcdi   (output)  Clave Tributaria                      *
      *     pePain   (output)  Pais de Nacimiento                    *
      *     peCnac   (output)  Nacionalidad                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDa1...
     P                 B                   export
     D SVPDAF_getDa1...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                      40
     D   peDomi                      35
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peTeln                       7  0
     D   peFnac                       8  0
     D   peCprf                       3  0
     D   peSexo                       1  0
     D   peEsci                       1  0
     D   peRaae                       3  0
     D   peCiiu                       6  0
     D   peDom2                      50
     D   peLnac                      30
     D   pePesk                       5  2
     D   peEstm                       3  2
     D   peMfum                       1
     D   peMzur                       1
     D   peMar1                       1
     D   peMar2                       1
     D   peMar3                       1
     D   peMar4                       1
     D   peCcdi                      11
     D   pePain                       5  0
     D   peCnac                       3  0

     D p@Chij          s              2  0
     D p@Cnes          s              1  0

       SVPDAF_inz();

       clear p@Chij;
       clear p@Cnes;

       if not SVPDAF_getDa12( peNrdf
                            : peNomb
                            : peDomi
                            : peCopo
                            : peCops
                            : peTeln
                            : peFnac
                            : peCprf
                            : peSexo
                            : peEsci
                            : peRaae
                            : peCiiu
                            : peDom2
                            : peLnac
                            : pePesk
                            : peEstm
                            : peMfum
                            : peMzur
                            : peMar1
                            : peMar2
                            : peMar3
                            : peMar4
                            : peCcdi
                            : pePain
                            : peCnac
                            : p@Chij
                            : p@Cnes );

         return *Off;
       endif;

       return *on;

     P SVPDAF_getDa1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDa2: Retorna GNHDA2                                *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *     peLibr   (output)  Estructura GNHDA2                     *
      *     peLibrC  (output)  Cant Estructura GNHDA2                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDa2...
     P                 B                   export
     D SVPDAF_getDa2...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peLibr                            likeds( dsProI_t ) dim(999)
     D   peLibrC                     10i 0

     D k1yda2          ds                  likerec( g1hda2 : *key )

     D x               s             10i 0

       SVPDAF_inz();

       peLibrC = *Zeros;

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       k1yda2.dfnrdf = peNrdf;
       setll %kds( k1yda2 : 1 ) gnhda2;
         if not %equal( gnhda2 );
         SetError( SVPDAF_DPROV
                 : 'Provincia no asociada a la persona');
         return *off;
       endif;

       reade(n) %kds( k1yda2 : 1 ) gnhda2;

       dow not %eof ( gnhda2 );

         peLibrC += 1;

         peLibr( peLibrC ).Rpro = dfrpro;
         peLibr( peLibrC ).Fech = dfftia * 10000 + dfftim * 100 + dfftid;
         peLibr( peLibrC ).Nri1 = dfnri1;
         peLibr( peLibrC ).Nri2 = dfnri2;
         peLibr( peLibrC ).Nri3 = dfnri3;
         peLibr( peLibrC ).Nri4 = dfnri4;
         peLibr( peLibrC ).Iim1 = dfiim1;
         peLibr( peLibrC ).Strg = dfstrg;
         peLibr( peLibrC ).Nnib = dfnnib;

         reade(n) %kds( k1yda2 : 1 ) gnhda2;

       enddo;

       return *On;

     P SVPDAF_getDa2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDa4(): Retorna textos de Dato Filiatorio           *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *     peText   (output)  Vector de Textos                      *
      *     peTextC  (output)  Cantidad Vector de Textos             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDa4...
     P                 B                   export
     D SVPDAF_getDa4...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peText                      79    dim(999)
     D   peTextC                     10i 0

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       peTextC = *Zeros;

       setll peNrdf gnhda4;
       reade(n) peNrdf gnhda4;

       dow not %eof ( gnhda4 );

         peTextC += 1;
         peText ( peTextC ) = dfretx;

         reade(n) peNrdf gnhda4;

       enddo;

       return *On;

     P SVPDAF_getDa4...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDa6: Retorna GNHDA6                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peTpa1   (output)  Telefono Particular #1                *
      *     peTpa2   (output)  Telefono Particular #2                *
      *     peTtr1   (output)  Telefono Trabajo #1                   *
      *     peTtr2   (output)  Telefono Trabajo #2                   *
      *     peTcel   (output)  Telefono Celular                      *
      *     peTpag   (output)  Telefono Pager                        *
      *     peTfa1   (output)  Telefono Fax #1                       *
      *     peTfa2   (output)  Telefono Fax #2                       *
      *     peTfa3   (output)  Telefono Fax #3                       *
      *     pePweb   (output)  Pagina Web                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDa6...
     P                 B                   export
     D SVPDAF_getDa6...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peTpa1                      20
     D   peTpa2                      20
     D   peTtr1                      20
     D   peTtr2                      20
     D   peTcel                      20
     D   peTpag                      20
     D   peTfa1                      20
     D   peTfa2                      20
     D   peTfa3                      20
     D   pePweb                      50

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       chain(n) peNrdf gnhda6;
       if %found( gnhda6 );

         peTpa1 = dftel2;
         peTpa2 = dftel3;
         peTtr1 = dftel4;
         peTtr2 = dftel5;
         peTcel = dftel6;
         peTpag = dftel7;
         peTfa1 = dftel8;
         peTfa2 = dftel9;
         peTfa3 = dftel0;
         pePweb = dfpweb;

       endif;

       return *on;

     P SVPDAF_getDa6...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDa7: Retorna GNHDA7                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peMail   (output)  DS con los mails (ver MailAddr_t en   *
      *     peMailC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDa7...
     P                 B                   export
     D SVPDAF_getDa7...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(Mailaddr_t) dim(100)
     D   peMailC                     10i 0

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       peMailC = SVPMAIL_xNrDaf ( peNrdf : peMail );

       return *on;

     P SVPDAF_getDa7...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDa8: Retorna CBU de Siniestro                      *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNcbu   (input)   CBU                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDa8...
     P                 B                   export
     D SVPDAF_getDa8...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNcbu                      22a

     D k1yda8          ds                  likerec(g1hda8:*Key)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       k1yda8.dfnrdf = peNrdf;
       setgt %kds ( k1yda8 : 1 ) gnhda8;
       readpe(n) %kds ( k1yda8 : 1 ) gnhda8;

       if dfmar1 = '0';
         SetError( SVPDAF_DAFCA
                 : 'Dato Filiatorio sin CBU Activa' );
         return *Off;
       endif;

       if %eof ( gnhda8 );
         SetError( SVPDAF_DAFCB
                 : 'Dato Filiatorio sin CBU' );
         return *Off;
       endif;

       peNcbu = dfncbu;

       return *on;

     P SVPDAF_getDa8...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDatoFiliatorio(): Retorna Todo el Dato Filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (output)  Estructura Nombres                    *
      *     peDomi   (output)  Estructura Domicilios                 *
      *     peDocu   (output)  Estructura Documentos                 *
      *     peCont   (output)  Estructura Telefonos/Pagina Web       *
      *     peNaci   (output)  Estructura Nacimiento                 *
      *     peMarc   (output)  Estructura Marcas Varias              *
      *     peCbuS   (output)  Estructura CBU Siniestros             *
      *     peDape   (output)  Estructura Datos Personales           *
      *     peClav   (output)  Estructura Claves Tributarias         *
      *     peText   (output)  Estructura Texto                      *
      *     peTextC  (output)  Cantidad Texto                        *
      *     peProv   (output)  Estructura Provincias IIBB            *
      *     peProvC  (output)  Cantidad Provincias IIBB              *
      *     peMail   (output)  Estructura Mails                      *
      *     peMailC  (output)  Cantidad Mails                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDatoFiliatorio...
     P                 B                   export
     D SVPDAF_getDatoFiliatorio...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                            likeDs(dsNomb_t)
     D   peDomi                            likeDs(dsDomi_t)
     D   peDocu                            likeDs(dsDocu_t)
     D   peCont                            likeDs(dsCont_t)
     D   peNaci                            likeDs(dsNaci_t)
     D   peMarc                            likeDs(dsMarc_t)
     D   peCbuS                            likeDs(dsCbuS_t)
     D   peDape                            likeDs(dsDape_t)
     D   peClav                            likeDs(dsClav_t)
     D   peText                      79    dim(999)
     D   peTextC                     10i 0
     D   peProv                            likeDs(dsProI_t) dim(999)
     D   peProvC                     10i 0
     D   peMail                            likeds(Mailaddr_t) dim(100)
     D   peMailC                     10i 0

       SVPDAF_inz();

       SVPDAF_getDaf ( peNrdf
                     : peNomb.nomb
                     : peDomi.domi
                     : peDomi.ndom
                     : peDomi.piso
                     : peDomi.deto
                     : peDomi.copo
                     : peDomi.cops
                     : peCont.teln
                     : peCont.faxn
                     : peDocu.tiso
                     : peDocu.tido
                     : peDocu.nrdo
                     : peDocu.cuit
                     : peDocu.cuil );

       SVPDAF_getDa1 ( peNrdf
                     : peNomb.nom1
                     : peDomi.dom1
                     : peDomi.cop1
                     : peDomi.cos1
                     : peCont.tel1
                     : peNaci.fnac
                     : peDape.cprf
                     : peDape.sexo
                     : peDape.esci
                     : peDape.raae
                     : peClav.cciu
                     : peDomi.dom2
                     : peNaci.lnac
                     : peDape.pesk
                     : peDape.estm
                     : peMarc.mfum
                     : peMarc.mzur
                     : peMarc.mar1
                     : peMarc.mar2
                     : peMarc.mar3
                     : peMarc.mar4
                     : peClav.ccdi
                     : peNaci.pain
                     : peNaci.cnac );

       SVPDAF_getDa2 ( peNrdf
                     : peProv
                     : peProvC );

       SVPDAF_getDa4 ( peNrdf
                     : peText
                     : peTextC );

       SVPDAF_getDa6 ( peNrdf
                     : peCont.tpa1
                     : peCont.tpa2
                     : peCont.ttr1
                     : peCont.ttr2
                     : peCont.tcel
                     : peCont.tpag
                     : peCont.tfa1
                     : peCont.tfa2
                     : peCont.tfa3
                     : peCont.pweb );

       SVPDAF_getDa7 ( peNrdf
                     : peMail
                     : peMailC );

       SVPDAF_getDa8 ( peNrdf
                     : peCbuS );


       return *on;

     P SVPDAF_getDatoFiliatorio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getNombre(): Retorna Nombre de Dato Filiatorio        *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNom1   (input)   Nombre Alternativo                    *
      *                                                              *
      * Retorna: Nombre                                              *
      * ------------------------------------------------------------ *
     P SVPDAF_getNombre...
     P                 B                   export
     D SVPDAF_getNombre...
     D                 pi            40
     D   peNrdf                       7  0 const
     D   peNom1                      40    options(*Omit:*Nopass)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Blanks;
       endif;

       chain(n) peNrdf gnhdaf;

       if %parms >= 2 and %addr( peNom1 ) <> *Null;

         if SVPDAF_chkDa1 ( peNrdf );
           chain(n) peNrdf gnhda1;
           peNom1 = dfnom1;
         endif;

       endif;

       return dfnomb;

     P SVPDAF_getNombre...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDomicilio(): Retorna Domicilio de Dato Filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDomi   (output)  Domicilio                             *
      *     peNdom   (output)  Nro de Domicilio                      *
      *     pePiso   (output)  Piso                                  *
      *     peDeto   (output)  Departamento                          *
      *     peDom1   (output)  Domicilio 1                           *
      *     peDom2   (output)  Domicilio 2                           *
      *                                                              *
      * Retorna: Domicilio                                           *
      * ------------------------------------------------------------ *
     P SVPDAF_getDomicilio...
     P                 B                   export
     D SVPDAF_getDomicilio...
     D                 pi            35
     D   peNrdf                       7  0 const
     D   peNdom                       5  0 options(*Omit:*Nopass)
     D   pePiso                       3  0 options(*Omit:*Nopass)
     D   peDeto                       4    options(*Omit:*Nopass)
     D   peDom1                      35    options(*Omit:*Nopass)
     D   peDom2                      50    options(*Omit:*Nopass)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Blanks;
       endif;

       chain(n) peNrdf gnhdaf;

       if %parms >= 1 and %addr( peNdom ) <> *Null;
         peNdom = dfNdom;
       endif;

       if %parms >= 2 and %addr( pePiso ) <> *Null;
         pePiso = dfpiso;
       endif;

       if %parms >= 3 and %addr( peDeto ) <> *Null;
         peDeto = dfdeto;
       endif;

       if SVPDAF_chkDa1 ( peNrdf );

         chain(n) peNrdf gnhda1;

         if %parms >= 4 and %addr( peDom1 ) <> *Null;
           peDom1 = dfnom1;
         endif;

         if %parms >= 5 and %addr( peDom2 ) <> *Null;
           peDom2 = dfdom2;
         endif;

       endif;

       return dfdomi;

     P SVPDAF_getDomicilio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getLocalidad(): Retorna Localidad de Dato Filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peCopo   (output)  Codigo Postal                         *
      *     peCops   (output)  SubCodigo Postal                      *
      *     peLoca   (output)  Localidad                             *
      *     peCop1   (output)  Codigo Postal                         *
      *     peCos1   (output)  SubCodigo Postal                      *
      *     peLoc1   (output)  Localidad                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getLocalidad...
     P                 B                   export
     D SVPDAF_getLocalidad...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peLoca                      25    options(*Omit:*Nopass)
     D   peCop1                       5  0 options(*Omit:*Nopass)
     D   peCos1                       1  0 options(*Omit:*Nopass)
     D   peLoc1                      25    options(*Omit:*Nopass)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       chain(n) peNrdf gnhdaf;

       peCopo = dfcopo;
       peCops = dfcops;

       if %parms >= 4 and %addr( peLoca ) <> *Null;
         peLoca = SVPDES_localidad ( peCopo : peCops );
       endif;

       if SVPDAF_chkDa1 ( peNrdf );
         chain(n) peNrdf gnhda1;

         if %parms >= 5 and %addr( peCop1 ) <> *Null;
           peCop1 = dfcop1;
         endif;

         if %parms >= 6 and %addr( peCos1 ) <> *Null;
           peCos1 = dfcos1;
         endif;

         if %parms >= 7 and %addr( peLoc1 ) <> *Null;
           peLoc1 = SVPDES_localidad ( dfcop1 : dfcos1 );
         endif;
       endif;

       return *On;

     P SVPDAF_getLocalidad...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDocumento(): Retorna Documento de Dato Filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peTido   (output)  Tipo Documento                        *
      *     peNrdo   (output)  Nro Documento                         *
      *     peCuit   (output)  CUIT                                  *
      *     peCuil   (output)  CUIL                                  *
      *     peDtdo   (output)  Descripcion Tipo de Documento         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDocumento...
     P                 B                   export
     D SVPDAF_getDocumento...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peTido                       2  0 options(*Omit:*Nopass)
     D   peNrdo                       8  0 options(*Omit:*Nopass)
     D   peCuit                      11    options(*Omit:*Nopass)
     D   peCuil                      11  0 options(*Omit:*Nopass)
     D   peDtdo                      20    options(*Omit:*Nopass)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       chain(n) peNrdf gnhdaf;

       if %parms >= 2 and %addr( peTido ) <> *Null;
         peTido = dftido;
       endif;

       if %parms >= 3 and %addr( peNrdo ) <> *Null;
         peNrdo = dfnrdo;
       endif;

       if %parms >= 4 and %addr( peCuit ) <> *Null;
         peCuit = dfcuit;
       endif;

       if %parms >= 5 and %addr( peCuil ) <> *Null;
         peCuil = dfnjub;
       endif;

       if %parms >= 6 and %addr( peDtdo ) <> *Null;
         peDtdo = SVPDES_tipoDocumento( peTido );
       endif;

       return *On;

     P SVPDAF_getDocumento...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_getFechaNac(): Retorna Fec de Nacimiento              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: Fecha de Nacimiento                                 *
      * ------------------------------------------------------------ *
     P SVPDAF_getFechaNac...
     P                 B                   export
     D SVPDAF_getFechaNac...
     D                 pi             8  0
     D   peNrdf                       7  0 const

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Zeros;
       endif;

       if SVPDAF_chkDa1 ( peNrdf );
         chain(n) peNrdf gnhda1;

         return dffnaa * 10000 + dffnam * 100 + dffnad;
       endif;

       return *Zeros;

     P SVPDAF_getFechaNac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getPaisDeNac(): Retorna Pais de Nacimiento            *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     pePaid   (output)  Descricion de Pais                    *
      *                                                              *
      * Retorna: Pais de Nacimiento                                  *
      * ------------------------------------------------------------ *
     P SVPDAF_getPaisDeNac...
     P                 B                   export
     D SVPDAF_getPaisDeNac...
     D                 pi             5  0
     D   peNrdf                       7  0 const
     D   pePaid                      30    options(*Omit:*Nopass)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Zeros;
       endif;

       if SVPDAF_chkDa1 ( peNrdf );
         chain(n) peNrdf gnhda1;

         if %parms >= 2 and %addr( pePaid ) <> *Null;
           pePaid = SVPDES_paisDeNac( dfpain );
         endif;

         return dfpain;
       endif;

       return *Zeros;

     P SVPDAF_getPaisDeNac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getNacionalidad(): Retorna Nacionalidad               *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDnac   (output)  Descricion de Nacionalidad            *
      *                                                              *
      * Retorna: Nacionalidad                                        *
      * ------------------------------------------------------------ *
     P SVPDAF_getNacionalidad...
     P                 B                   export
     D SVPDAF_getNacionalidad...
     D                 pi             3  0
     D   peNrdf                       7  0 const
     D   peDnac                      30    options(*Omit:*Nopass)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Zeros;
       endif;

       if SVPDAF_chkDa1 ( peNrdf );
         chain(n) peNrdf gnhda1;

         if %parms >= 2 and %addr( peDnac ) <> *Null;
           peDnac = SVPDES_nacionalidad( dfcnac );
         endif;

         return dfcnac;
       endif;

       return *Zeros;

     P SVPDAF_getNacionalidad...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getMailValido(): Retorna PRIMER mail valido           *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peCtce   (input)   Tipo de Mail                          *
      *                                                              *
      * Retorna: Mail                                                *
      * ------------------------------------------------------------ *
     P SVPDAF_getMailValido...
     P                 B                   export
     D SVPDAF_getMailValido...
     D                 pi            50
     D   peNrdf                       7  0 const
     D   peCtce                       2  0 options(*Omit:*Nopass)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Blanks;
       endif;

       setll peNrdf gnhda7;
       reade(n) peNrdf gnhda7;

       dow not %eof ( gnhda7 );

         if MAIL_isValid( dfmail );

           if %parms >= 2 and %addr( peCtce ) <> *Null;
             peCtce = dfctce;
           endif;

           return dfmail;

         endif;

         reade(n) peNrdf gnhda7;

       enddo;

       return *Blanks;

     P SVPDAF_getMailValido...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getTipoSociedad(): Retorna Tipo de Sociedad           *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDtis   (output)  Tipo de Sociedad                      *
      *                                                              *
      * Retorna: Tipo de Sociedad                                    *
      * ------------------------------------------------------------ *
     P SVPDAF_getTipoSociedad...
     P                 B                   export
     D SVPDAF_getTipoSociedad...
     D                 pi             2  0
     D   peNrdf                       7  0 const
     D   peDtis                      25    options(*Omit:*Nopass)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Zeros;
       endif;

       chain(n) peNrdf gnhdaf;

       if %parms >= 2 and %addr( peDtis ) <> *Null;
         peDtis = SVPDES_tipoSociedad( dftiso );
       endif;

       return dftiso;

     P SVPDAF_getTipoSociedad...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getSujetoExterior(): Retorna si es Sujeto Exterior    *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: Marca                                               *
      * ------------------------------------------------------------ *
     P SVPDAF_getSujetoExterior...
     P                 B                   export
     D SVPDAF_getSujetoExterior...
     D                 pi             1
     D   peNrdf                       7  0 const

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Blanks;
       endif;

       if SVPDAF_chkDa1 ( peNrdf );
         chain(n) peNrdf gnhda1;
         return dfmar4;
       endif;

       return *Blanks;

     P SVPDAF_getSujetoExterior...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getProfesion(): Retorna Profesion                     *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDprf   (input)   Descripcion de Prfecion               *
      *                                                              *
      * Retorna: Tipo de Profesion                                   *
      * ------------------------------------------------------------ *
     P SVPDAF_getProfesion...
     P                 B                   export
     D SVPDAF_getProfesion...
     D                 pi             3  0
     D   peNrdf                       7  0 const
     D   peDprf                      25    options(*Omit:*Nopass)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Zeros;
       endif;

       if SVPDAF_chkDa1 ( peNrdf );
         chain(n) peNrdf gnhda1;

         if %parms >= 2 and %addr( peDprf ) <> *Null;
           peDprf = SVPDES_profesion( dfcprf );
         endif;

         return dfcprf;
       endif;

       return *Zeros;

     P SVPDAF_getProfesion...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDaf: Graba GNHDAF                                  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre                                *
      *     peDomi   (input)   Domicilio                             *
      *     peNdom   (input)   Nro. Domicilio                        *
      *     pePiso   (input)   Piso                                  *
      *     peDeto   (input)   Departamento                          *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Nro. Telefono                         *
      *     peFaxn   (input)   Nro. Fax                              *
      *     peTiso   (input)   Tipo de Sociedad                      *
      *     peTido   (input)   Tipo Documento                        *
      *     peNrdo   (input)   Nro. Documento                        *
      *     peCuit   (input)   CUIT                                  *
      *     peNjub   (input)   Nro. Jubilacion                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDaf...
     P                 B                   export
     D SVPDAF_setDaf...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peNdom                       5  0 const
     D   pePiso                       3  0 const
     D   peDeto                       4    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFaxn                       7  0 const
     D   peTiso                       2  0 const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peCuit                      11    const
     D   peNjub                      11  0 const

     D min             c                   const('abcdefghijklmnñopqrstuvwxy-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXY-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

       SVPDAF_inz();

       if not SVPDAF_chkDatoF ( peNomb
                              : peDomi
                              : peNdom
                              : peCopo
                              : peCops
                              : peTiso
                              : peTido
                              : peNrdo );
         return *Off;
       endif;

       dfnrdf = peNrdf;
       dfnomb = %xlate( min : may : peNomb );
       dfdomi = %xlate( min : may : peDomi );
       dfndom = peNdom;
       dfpiso = pePiso;
       dfdeto = peDeto;
       dfcopo = peCopo;
       dfcops = peCops;
       dfteln = peTeln;
       dffaxn = peFaxn;
       dftiso = peTiso;
       dftido = peTido;
       dfnrdo = peNrdo;
       dfcuit = peCuit;
       dfnjub = peNjub;
       dfrega = '1';

       write g1hdaf;

       return *on;

     P SVPDAF_setDaf...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa1: Graba GNHDA1                                  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre Alternativo                    *
      *     peDomi   (input)   Domicilio Postal                      *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Telefono                              *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     peCiiu   (input)   Ciiu                                  *
      *     peDom2   (input)   Domicilio                             *
      *     pePesk   (input)   Peso                                  *
      *     peEstm   (input)   Estatura                              *
      *     peMfum   (input)   Marca de Fuma                         *
      *     peMzur   (input)   Marca de Zurdo                        *
      *     peMar1   (input)   Pago Aporte Previsional               *
      *     peMar2   (input)   Sujeto Exterior                       *
      *     peMar3   (input)   Constancia Empadronamiento AFIP       *
      *     peMar4   (input)   Acreedor Prendario                    *
      *     peCcdi   (input)   Clave Tributaria                      *
      *     pePain   (input)   Pais de Nacimiento                    *
      *     peCnac   (input)   Codigo de Nacionalidad                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa1...
     P                 B                   export
     D SVPDAF_setDa1...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   peSexo                       1  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   peCiiu                       6  0 const
     D   peDom2                      50    const
     D   peLnac                      30    const
     D   pePesk                       5  2 const
     D   peEstm                       3  2 const
     D   peMfum                       1    const
     D   peMzur                       1    const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peCcdi                      11    const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const

     D min             c                   const('abcdefghijklmnñopqrstuvwxy-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXY-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

     D p@Chij          s              2  0
     D p@Cnes          s              1  0

       SVPDAF_inz();

       clear p@Chij;
       clear p@Cnes;

       if not SVPDAF_setDa12 ( peNrdf
                             : peNomb
                             : peDomi
                             : peCopo
                             : peCops
                             : peTeln
                             : peFnac
                             : peCprf
                             : peSexo
                             : peEsci
                             : peRaae
                             : peCiiu
                             : peDom2
                             : peLnac
                             : pePesk
                             : peEstm
                             : peMfum
                             : peMzur
                             : peMar1
                             : peMar2
                             : peMar3
                             : peMar4
                             : peCcdi
                             : pePain
                             : peCnac
                             : p@Chij
                             : p@Cnes );

         return *Off;
       endif;

       return *on;

     P SVPDAF_setDa1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa2():     Graba Dato Filiatorio por Provincia     *
      *                                                              *
      *     penrdf   (input)   Asegurado                             *
      *     peRpro   (input)   Provincia                             *
      *     peFech   (input)   Fecha Base Impuesto                   *
      *     peNri1   (input)   Nro Insc Ibr                          *
      *     peNri2   (input)   Nro Insc Ibr C Mult                   *
      *     peNri3   (input)   Nro Insc Ibr Nuevo                    *
      *     peNri4   (input)   Nro Insc Impuesto                     *
      *     peIim1   (input)   Importe Nri1                          *
      *     peStrg   (input)   Hacer Percepcion                      *
      *     peNnib   (input)   Nro Nuevo Ibr                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa2...
     P                 B                   export
     D SVPDAF_setDa2...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peRpro                       2  0 const
     D   peFech                       8  0 const
     D   peNri1                      13  0 const
     D   peNri2                      13  0 const
     D   peNri3                      13  0 const
     D   peNri4                      13  0 const
     D   peIim1                      15  2 const
     D   peStrg                       1    const
     D   peNnib                      14    const

     D k1yda2          ds                  likerec( g1hda2 : *key )

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       if not SVPDAF_chkDato2 ( peRpro
                              : peFech
                              : peNri1
                              : peNri2
                              : peNri3
                              : peNri4
                              : peIim1
                              : peStrg
                              : peNnib );

          return *off;

        endif;

       k1yda2.dfnrdf = penrdf;
       k1yda2.dfrpro = peRpro;
       k1yda2.dfftia = %subdt(tmpFec:*YEARS);
       k1yda2.dfftim = %subdt(tmpFec:*MONTHS);
       k1yda2.dfftid = %subdt(tmpFec:*DAYS);
       setll %kds( k1yda2 ) gnhda2;
         if %equal( gnhda2 );
         SetError( SVPDAF_DPROV
                 : 'Datos de Provincias duplicados ');
         return *off;
       endif;

       dfnrdf = penrdf;
       dfrpro = peRpro;
       dfftia = %subdt(tmpFec:*YEARS);
       dfftim = %subdt(tmpFec:*MONTHS);
       dfftid = %subdt(tmpFec:*DAYS);
       dfnri1 = peNri1;
       dfnri2 = peNri2;
       dfnri3 = peNri3;
       dfnri4 = peNri4;
       dfiim1 = peIim1;
       dfstrg = peStrg;
       dfnnib = peNnib;
       write g1hda2;

       return *On;

     P SVPDAF_setDa2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa2Lista:      Graba Lista de Datos Filiatorios    *
      *                         por Provincia IIBB                   *
      *     penrdf   (input)   Numero de Asegurado                   *
      *     peLibr   (input)   Listado de DAF por Provinicias IIBB   *
      *     peLibrC  (input)   Cantidad                              *
      *                                                              *
      * Return *on / *off                                            *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa2Lista...
     P                 B                   export
     D SVPDAF_setDa2Lista...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peLibr                            likeds( dsProI_t ) dim(999)
     D                                     const
     D   peLibrC                     10i 0 const
     D   x             s             10i 0

       SVPDAF_inz();

       for x = 1 to peLibrC;

         if not SVPDAF_setDa2( penrdf
                             : peLibr(x).Rpro
                             : peLibr(x).Fech
                             : peLibr(x).Nri1
                             : peLibr(x).Nri2
                             : peLibr(x).Nri3
                             : peLibr(x).Nri4
                             : peLibr(x).Iim1
                             : peLibr(x).Strg
                             : peLibr(x).Nnib );

           SVPDAF_dltDa2Pro ( penrdf
                            : peLibr(x).Rpro
                            : peLibr(x).Fech );
           return *off;
         endif;
       endfor;

       return *on;

     P SVPDAF_setDa2Lista...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa4():    Graba textos de Dato Filiatorio          *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *     peText   (input)   Vector de Textos                      *
      *     peTextC  (input)   Cantidad Vector de Textos             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa4...
     P                 B                   export
     D SVPDAF_setDa4...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peText                      79    dim(999) const
     D   peTextC                     10i 0 const

     D x               s             10i 0

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       for x = 1 to peTextC;

         dfnrdf = peNrdf;
         dfnrre = x;
         dfretx = peText( x );

         write g1hda4;

       endfor;

       return *On;

     P SVPDAF_setDa4...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa6: Graba GNHDA6                                  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peTpa1   (input)   Telefono Particular #1                *
      *     peTpa2   (input)   Telefono Particular #2                *
      *     peTtr1   (input)   Telefono Trabajo #1                   *
      *     peTtr2   (input)   Telefono Trabajo #2                   *
      *     peTcel   (input)   Telefono Celular                      *
      *     peTpag   (input)   Telefono Pager                        *
      *     peTfa1   (input)   Telefono Fax #1                       *
      *     peTfa2   (input)   Telefono Fax #2                       *
      *     peTfa3   (input)   Telefono Fax #3                       *
      *     pePweb   (input)   Pagina Web                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa6...
     P                 B                   export
     D SVPDAF_setDa6...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peTpa1                      20    const
     D   peTpa2                      20    const
     D   peTtr1                      20    const
     D   peTtr2                      20    const
     D   peTcel                      20    const
     D   peTpag                      20    const
     D   peTfa1                      20    const
     D   peTfa2                      20    const
     D   peTfa3                      20    const
     D   pePweb                      50    const

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       if not SVPDAF_chkDato6 ( pePweb );
         return *Off;
       endif;

       if SVPDAF_chkDa62 ( peNrdf );
         return *Off;
       endif;

       dfnrdf = peNrdf;
       dftel2 = peTpa1;
       dftel3 = peTpa2;
       dftel4 = peTtr1;
       dftel5 = peTtr2;
       dftel6 = peTcel;
       dftel7 = peTpag;
       dftel8 = peTfa1;
       dftel9 = peTfa2;
       dftel0 = peTfa3;
       dfmail = *Blanks;
       dfpweb = pePweb;

       write g1hda6;

       return *on;

     P SVPDAF_setDa6...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa7:  Graba Mail de Dato Filiatorio                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peMail   (input)   Mail                                  *
      *     peMar1   (input)   Publicar en la Web Mail (Si/No)       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa7...
     P                 B                   export
     D SVPDAF_setDa7...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(Mailaddr_t) const
     D   peMar1                       1    options( *nopass : *omit  )

     D k1yda7          ds                  likerec(g1hda7:*Key)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       k1yda7.dfnrdf = peNrdf;
       k1yda7.dfctce = peMail.tipo;
       k1yda7.dfmail = peMail.Mail;
       chain(n) %kds( k1yda7 ) gnhda7;

       if %found ( gnhda7 );
         SetError( SVPDAF_MAILE
                 : 'Mail Existente' );
         return *Off;
       endif;

       if not MAIL_isValid( peMail.mail );
         SetError( SVPDAF_MERRO
                 : 'Mail Invalido' );
         return *Off;
       endif;

       dfnrdf = peNrdf;
       dfctce = peMail.tipo;
       dfmail = peMail.Mail;

       if %parms >= 3 and %addr( peMar1 ) <> *null;
         dfmar1 = peMar1;
       else;
         dfmar1 = '0';
       endif;

       dfmar2 = '0';
       dfmar3 = '0';
       dfmar4 = '0';
       dfmar5 = '0';
       dfmar6 = '0';
       dfmar7 = '0';
       dfmar8 = '0';
       dfmar9 = '0';
       dfmar0 = '0';
       dfuser = 'SVPDAF';
       dfdate = %dec(%date():*ymd);
       dftime = %dec(%time():*iso);

       write g1hda7;

       return *on;

     P SVPDAF_setDa7...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa7Lista:  Graba Mail de Dato Filiatorio           *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peMail   (input)   Mail                                  *
      *     peMailC  (input)   Mail                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa7Lista...
     P                 B                   export
     D SVPDAF_setDa7Lista...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(Mailaddr_t) dim(100) const
     D   peMailC                     10i 0 const

     D x               s             10i 0

       SVPDAF_inz();

       for x = 1 to peMailC;
         SVPDAF_setDa7 ( peNrdf : peMail(x) );
       endfor;

       return *on;

     P SVPDAF_setDa7Lista...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa8():        Graba CBU para pago de Siniestros    *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peFech   (input)   Fecha Desde                           *
      *     peNcbu   (input)   CBU                                   *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa8...
     P                 B                   export
     D SVPDAF_setDa8...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peFech                       8  0 const
     D   peNcbu                      22a   const
     D   peUser                      10a   const

     D @@ivbc          s              3  0
     D @@ivsu          s              3  0
     D @@tcta          s              2  0
     D @@ncta          s             25

     D k1yda8          ds                  likerec(g1hda8:*Key)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       if not SPVCBU_GetCBUSeparado ( peNcbu : @@ivbc : @@ivsu : @@tcta
                                    : @@ncta );
         return *Off;
       endif;

       monitor;
       tmpFec = %date( %char ( peFech ) : *iso0 );
       on-error;
         SetError( SVPDAF_FEBII
                 : 'Fecha Desde Invalida');
         return *off;
       endmon;

       k1yda8.dfnrdf = peNrdf;
       setgt %kds ( k1yda8 : 1 ) gnhda8;
       readpe %kds ( k1yda8 : 1 ) gnhda8;
       if not %eof ( gnhda8 );
         SVPDAF_updDa8 ( peNrdf : peUser );
       endif;

       k1yda8.dfnrdf = peNrdf;
       k1yda8.dffema = %subdt(tmpFec:*Years);
       k1yda8.dffemm = %subdt(tmpFec:*Months);
       k1yda8.dffemd = %subdt(tmpFec:*Days);
       setgt %kds ( k1yda8 : 4 ) gnhda8;
       readpe %kds ( k1yda8 : 4 ) gnhda8;

       if %eof ( gnhda8 );
         dfpsec = 1;
       else;
         dfpsec += 1;
       endif;

       dfnrdf = peNrdf;
       dffema = %subdt(tmpFec:*Years);
       dffemm = %subdt(tmpFec:*Months);
       dffemd = %subdt(tmpFec:*Days);
       dfncbu = peNcbu;
       dfmar1 = '1';
       dfmar2 = '0';
       dfmar3 = '0';
       dfmar4 = '0';
       dfmar5 = '0';
       dfuser = peUser;
       dfdate = %dec(%date():*ymd);
       dftime = %dec(%time():*iso);

       write g1hda8;

       return *on;

     P SVPDAF_setDa8...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDatoFiliatorio(): Graba   Todo el Dato Filiatorio  *
      *                                                              *
      *     peNomb   (input)   Estructura Nombres                    *
      *     peDomi   (input)   Estructura Domicilios                 *
      *     peDocu   (input)   Estructura Documentos                 *
      *     peCont   (input)   Estructura Telefonos/Pagina Web       *
      *     peNaci   (input)   Estructura Nacimiento                 *
      *     peMarc   (input)   Estructura Marcas Varias              *
      *     peCbuS   (input)   Estructura CBU Siniestros             *
      *     peDape   (input)   Estructura Datos Personales           *
      *     peClav   (input)   Estructura Claves Tributarias         *
      *     peText   (input)   Estructura Texto                      *
      *     peTextC  (input)   Cantidad Texto                        *
      *     peProv   (input)   Estructura Provincias IIBB            *
      *     peProvC  (input)   Cantidad Provincias IIBB              *
      *     peMail   (input)   Estructura Mails                      *
      *     peMailC  (input)   Cantidad Mails                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDatoFiliatorio...
     P                 B                   export
     D SVPDAF_setDatoFiliatorio...
     D                 pi             7  0
     D   peNomb                            likeDs(dsNomb_t) const
     D   peDomi                            likeDs(dsDomi_t) const
     D   peDocu                            likeDs(dsDocu_t) const
     D   peCont                            likeDs(dsCont_t) const
     D   peNaci                            likeDs(dsNaci_t) const
     D   peMarc                            likeDs(dsMarc_t) const
     D   peCbuS                            likeDs(dsCbuS_t) const
     D   peDape                            likeDs(dsDape_t) const
     D   peClav                            likeDs(dsClav_t) const
     D   peText                      79    dim(999) const
     D   peTextC                     10i 0 const
     D   peProv                            likeDs(dsProI_t) dim(999) const
     D   peProvC                     10i 0 const
     D   peMail                            likeds(Mailaddr_t) dim(100) const
     D   peMailC                     10i 0 const

     D @@nrdf          s              7  0
     D x               s             10i 0

       SVPDAF_inz();

       if not SVPDAF_chkDatoF ( peNomb.nomb
                              : peDomi.domi
                              : peDomi.ndom
                              : peDomi.copo
                              : peDomi.cops
                              : peDocu.tiso
                              : peDocu.tido
                              : peDocu.nrdo
                              : peDocu      );
         return *Zeros;
       endif;

       if not SVPDAF_chkDato1 ( peDomi.cop1
                              : peDomi.cos1
                              : peNaci.fnac
                              : peDape.cprf
                              : peDape.esci
                              : peDape.raae
                              : peNaci.pain
                              : peNaci.cnac );
         return *Zeros;
       endif;

       for x = 1 to peProvC;

         if not SVPDAF_chkDato2 ( peProv(x).rpro
                                : peProv(x).fech
                                : peProv(x).Nri1
                                : peProv(x).Nri2
                                : peProv(x).Nri3
                                : peProv(x).Nri4
                                : peProv(x).Iim1
                                : peProv(x).Strg
                                : peProv(x).Nnib );
           return *Zeros;
         endif;

       endfor;

       if not SVPDAF_chkDato6 ( peCont.pweb );
         return *Zeros;
       endif;

       for x = 1 to peProvC;

         if not SVPDAF_chkDato7 ( peMail(x).tipo
                                : peMail(x).mail );
           return *Zeros;
         endif;

       endfor;

       @@nrdf = SVPDAF_getNroDaf();

       SVPDAF_setDaf ( @@nrdf
                     : peNomb.nomb
                     : peDomi.domi
                     : peDomi.ndom
                     : peDomi.piso
                     : peDomi.deto
                     : peDomi.copo
                     : peDomi.cops
                     : peCont.teln
                     : peCont.faxn
                     : peDocu.tiso
                     : peDocu.tido
                     : peDocu.nrdo
                     : peDocu.cuit
                     : peDocu.cuil );

       SVPDAF_setDa1 ( @@nrdf
                     : peNomb.nom1
                     : peDomi.dom1
                     : peDomi.cop1
                     : peDomi.cos1
                     : peCont.tel1
                     : peNaci.fnac
                     : peDape.cprf
                     : peDape.sexo
                     : peDape.esci
                     : peDape.raae
                     : peClav.cciu
                     : peDomi.dom2
                     : peNaci.lnac
                     : peDape.pesk
                     : peDape.estm
                     : peMarc.mfum
                     : peMarc.mzur
                     : peMarc.mar1
                     : peMarc.mar2
                     : peMarc.mar3
                     : peMarc.mar4
                     : peClav.ccdi
                     : peNaci.pain
                     : peNaci.cnac );

       SVPDAF_setDa2Lista ( @@nrdf
                          : peProv
                          : peProvC );

       SVPDAF_setDa4 ( @@nrdf
                     : peText
                     : peTextC );

       SVPDAF_setDa6 ( @@nrdf
                     : peCont.tpa1
                     : peCont.tpa2
                     : peCont.ttr1
                     : peCont.ttr2
                     : peCont.tcel
                     : peCont.tpag
                     : peCont.tfa1
                     : peCont.tfa2
                     : peCont.tfa3
                     : peCont.pweb );

       SVPDAF_setDa7Lista ( @@nrdf
                          : peMail
                          : peMailC );

       return @@nrdf;

     P SVPDAF_setDatoFiliatorio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_updDaf: Actualiza GNHDAF                              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre                                *
      *     peDomi   (input)   Domicilio                             *
      *     peNdom   (input)   Nro. Domicilio                        *
      *     pePiso   (input)   Piso                                  *
      *     peDeto   (input)   Departamento                          *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Nro. Telefono                         *
      *     peFaxn   (input)   Nro. Fax                              *
      *     peTiso   (input)   Tipo de Sociedad                      *
      *     peTido   (input)   Tipo Documento                        *
      *     peNrdo   (input)   Nro. Documento                        *
      *     peCuit   (input)   CUIT                                  *
      *     peNjub   (input)   Nro. Jubilacion                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_updDaf...
     P                 B                   export
     D SVPDAF_updDaf...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peNdom                       5  0 const
     D   pePiso                       3  0 const
     D   peDeto                       4    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFaxn                       7  0 const
     D   peTiso                       2  0 const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peCuit                      11    const
     D   peNjub                      11  0 const

     D min             c                   const('abcdefghijklmnñopqrstuvwxy-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXY-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       if not SVPDAF_chkDatoF ( peNomb
                              : peDomi
                              : peNdom
                              : peCopo
                              : peCops
                              : peTiso
                              : peTido
                              : peNrdo );
         return *Off;
       endif;

       chain peNrdf gnhdaf;

       dfnrdf = peNrdf;
       dfnomb = %xlate( min : may : peNomb );
       dfdomi = %xlate( min : may : peDomi );
       dfndom = peNdom;
       dfpiso = pePiso;
       dfdeto = peDeto;
       dfcopo = peCopo;
       dfcops = peCops;
       dfteln = peTeln;
       dffaxn = peFaxn;
       dftiso = peTiso;
       dftido = peTido;
       dfnrdo = peNrdo;
       dfcuit = peCuit;
       dfnjub = peNjub;
       dfrega = '1';

       update g1hdaf;

       return *on;

     P SVPDAF_updDaf...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_updDa1: Actualiza GNHDA1                              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre Alternativo                    *
      *     peDomi   (input)   Domicilio Postal                      *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Telefono                              *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     peCiiu   (input)   Ciiu                                  *
      *     peDom2   (input)   Domicilio                             *
      *     pePesk   (input)   Peso                                  *
      *     peEstm   (input)   Estatura                              *
      *     peMfum   (input)   Marca de Fuma                         *
      *     peMzur   (input)   Marca de Zurdo                        *
      *     peMar1   (input)   Pago Aporte Previsional               *
      *     peMar2   (input)   Sujeto Exterior                       *
      *     peMar3   (input)   Constancia Empadronamiento AFIP       *
      *     peMar4   (input)   Acreedor Prendario                    *
      *     peCcdi   (input)   Clave Tributaria                      *
      *     pePain   (input)   Pais de Nacimiento                    *
      *     peCnac   (input)   Codigo de Nacionalidad                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_updDa1...
     P                 B                   export
     D SVPDAF_updDa1...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   peSexo                       1  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   peCiiu                       6  0 const
     D   peDom2                      50    const
     D   peLnac                      30    const
     D   pePesk                       5  2 const
     D   peEstm                       3  2 const
     D   peMfum                       1    const
     D   peMzur                       1    const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peCcdi                      11    const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const

     D min             c                   const('abcdefghijklmnñopqrstuvwxy-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXY-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
     D @@fdef          s              8  0 inz(19500101)
     D p@Chij          s              2  0
     D p@Cnes          s              1  0

       SVPDAF_inz();

       clear p@Chij;
       clear p@Cnes;

       if not SVPDAF_updDa12 ( peNrdf
                             : peNomb
                             : peDomi
                             : peCopo
                             : peCops
                             : peTeln
                             : peFnac
                             : peCprf
                             : peSexo
                             : peEsci
                             : peRaae
                             : peCiiu
                             : peDom2
                             : peLnac
                             : pePesk
                             : peEstm
                             : peMfum
                             : peMzur
                             : peMar1
                             : peMar2
                             : peMar3
                             : peMar4
                             : peCcdi
                             : pePain
                             : peCnac
                             : p@Chij
                             : p@Cnes );

         return *Off;
       endif;

       return *on;

     P SVPDAF_updDa1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_updDa6: Actualiza GNHDA6                              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peTpa1   (input)   Telefono Particular #1                *
      *     peTpa2   (input)   Telefono Particular #2                *
      *     peTtr1   (input)   Telefono Trabajo #1                   *
      *     peTtr2   (input)   Telefono Trabajo #2                   *
      *     peTcel   (input)   Telefono Celular                      *
      *     peTpag   (input)   Telefono Pager                        *
      *     peTfa1   (input)   Telefono Fax #1                       *
      *     peTfa2   (input)   Telefono Fax #2                       *
      *     peTfa3   (input)   Telefono Fax #3                       *
      *     pePweb   (input)   Pagina Web                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_updDa6...
     P                 B                   export
     D SVPDAF_updDa6...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peTpa1                      20    const
     D   peTpa2                      20    const
     D   peTtr1                      20    const
     D   peTtr2                      20    const
     D   peTcel                      20    const
     D   peTpag                      20    const
     D   peTfa1                      20    const
     D   peTfa2                      20    const
     D   peTfa3                      20    const
     D   pePweb                      50    const

       SVPDAF_inz();

       if not SVPDAF_chkDato6 ( pePWeb );
         return *Off;
       endif;

       if not SVPDAF_chkDa62( peNrdf );
         return *Off;
       endif;

       chain peNrdf gnhda6;

       dfnrdf = peNrdf;
       dftel2 = peTpa1;
       dftel3 = peTpa2;
       dftel4 = peTtr1;
       dftel5 = peTtr2;
       dftel6 = peTcel;
       dftel7 = peTpag;
       dftel8 = peTfa1;
       dftel9 = peTfa2;
       dftel0 = peTfa3;
       dfmail = *Blanks;
       dfpweb = pePweb;
       update g1hda6;
       return *on;

     P SVPDAF_updDa6...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_updDa8: Actualiza CBU para Siniestros                 *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_updDa8...
     P                 B                   export
     D SVPDAF_updDa8...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peUser                      10a   const

     D k1yda8          ds                  likerec(g1hda8:*Key)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       k1yda8.dfnrdf = peNrdf;
       setgt %kds ( k1yda8 : 1 ) gnhda8;
       readpe %kds ( k1yda8 : 1 ) gnhda8;

       if %eof ( gnhda8 );
         SetError( SVPDAF_DAFIN
                 : 'Dato Filiatorio sin CBU Activa' );
         return *Off;
       endif;

       if dfmar1 = '0';
         dfmar1 = '1';
       else;
         dfmar1 = '0';
       endif;

       dfuser = peUser;

       update g1hda8;

       return *on;

     P SVPDAF_updDa8...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltDaf: Elimina GNHDAF                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_dltDaf...
     P                 B                   export
     D SVPDAF_dltDaf...
     D                 pi              n
     D   peNrdf                       7  0 const

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       chain peNrdf gnhdaf;

       delete g1hdaf;

       return *on;

     P SVPDAF_dltDaf...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa1: Elimina GNHDA1                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_dltDa1...
     P                 B                   export
     D SVPDAF_dltDa1...
     D                 pi              n
     D   peNrdf                       7  0 const

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       chain peNrdf gnhda1;
       if %found( gnhda1 );
         delete g1hda1;
       endif;

       return *on;

     P SVPDAF_dltDa1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa2:      Elimina dato Filiatorio por Provincia    *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_dltDa2...
     P                 B                   export
     D SVPDAF_dltDa2...
     D                 pi              n
     D   peNrdf                       7  0 const

       SVPDAF_inz();

       setll peNrdf gnhda2;
       reade peNrdf gnhda2;

       dow not %eof( gnhda2 );

         delete g1hda2;
         reade peNrdf gnhda2;

       enddo;

       return *on;

     P SVPDAF_dltDa2...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa2Pro:   Elimina dato Filiatorio por Provincia    *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *     peRpro   (input)   Provincia                             *
      *     peFech   (input)   Fecha Base de Impusto                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_dltDa2Pro...
     P                 B                   export
     D SVPDAF_dltDa2Pro...
     D                 pi              n
     D   penrdf                       7  0 const
     D   peRpro                       2  0 const
     D   peFech                       8  0 const

     D k1yda2          ds                  likerec( g1hda2 : *key )

       SVPDAF_inz();

       k1yda2.dfnrdf = penrdf;
       k1yda2.dfrpro = peRpro;
       k1yda2.dfftia = %subdt(tmpFec:*YEARS);
       k1yda2.dfftim = %subdt(tmpFec:*MONTHS);
       k1yda2.dfftid = %subdt(tmpFec:*DAYS);
       setll %kds( k1yda2 ) gnhda2;
        if not %equal( gnhda2 );
          SetError( SVPDAF_DPROV
                  : 'Provincia no asociada a la persona');
          return *off;
        endif;

       reade %kds( k1yda2 ) gnhda2;
         dow not %eof( gnhda2 );

           delete g1hda2;

           reade %kds( k1yda2 ) gnhda2;
         enddo;

       return *on;

     P SVPDAF_dltDa2Pro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa4():    Elimina textos de Dato Filiatorio        *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_dltDa4...
     P                 B                   export
     D SVPDAF_dltDa4...
     D                 pi              n
     D   peNrdf                       7  0 const

       SVPDAF_inz();

       setll peNrdf gnhda4;
       reade peNrdf gnhda4;

       dow not %eof ( gnhda4 );

         delete g1hda4;
         reade peNrdf gnhda4;

       enddo;

       return *On;

     P SVPDAF_dltDa4...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa6: Elimina GNHDA6                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_dltDa6...
     P                 B                   export
     D SVPDAF_dltDa6...
     D                 pi              n
     D   peNrdf                       7  0 const

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       chain peNrdf gnhda6;
       if %found( gnhda6 );
         delete g1hda6;
       endif;

       return *on;

     P SVPDAF_dltDa6...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa7:  Elimina Mail de Dato Filiatorio              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_dltDa7...
     P                 B                   export
     D SVPDAF_dltDa7...
     D                 pi              n
     D   peNrdf                       7  0 const

     D k1yda7          ds                  likerec(g1hda7:*Key)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;


       setll peNrdf gnhda7;
       reade %kds( k1yda7 ) gnhda7;

       dow not %eof ( gnhda7 );

         delete g1hda7;
         reade %kds( k1yda7 ) gnhda7;

       enddo;

       return *on;

     P SVPDAF_dltDa7...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltDatoFiliatorio(): Elimina TODO el dato filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_dltDatoFiliatorio...
     P                 B                   export
     D SVPDAF_dltDatoFiliatorio...
     D                 pi              n
     D   peNrdf                       7  0 const

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       SVPDAF_dltDaf ( peNrdf );
       SVPDAF_dltDa1 ( peNrdf );
       SVPDAF_dltDa2 ( peNrdf );
       SVPDAF_dltDa4 ( peNrdf );
       SVPDAF_dltDa6 ( peNrdf );
       SVPDAF_dltDa7 ( peNrdf );

       return *on;

     P SVPDAF_dltDatoFiliatorio...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDAF_inz      B                   export
     D SVPDAF_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(gnhdaf);
         open gnhdaf;
       endif;

       if not %open(gnhda1);
         open gnhda1;
       endif;

       if not %open(gnhda2);
         open gnhda2;
       endif;

       if not %open(gnhda4);
         open gnhda4;
       endif;

       if not %open(gnhda6);
         open gnhda6;
       endif;

       if not %open(gnhda7);
         open gnhda7;
       endif;

       if not %open(gnhda8);
         open gnhda8;
       endif;

       if not %open(pahec018);
         open pahec018;
       endif;

       if not %open(gnhdaf05);
         open gnhdaf05;
       endif;

       if not %open(gnhdaf06);
         open gnhdaf06;
       endif;

       if not %open(gnhda9);
         open gnhda9;
       endif;

       if not %open(gnhdad);
         open gnhdad;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPDAF_inz      E

      * ------------------------------------------------------------ *
      * SVPDAF_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDAF_End      B                   export
     D SVPDAF_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPDAF_End      E

      * ------------------------------------------------------------ *
      * SVPDAF_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPDAF_Error    B                   export
     D SVPDAF_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPDAF_Error    E

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
      * SVPDAF_FecPriPol(): Fecha de Emisión de Primera Póliza       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peFemi   (output)  Fecha Primera Póliza Emitida          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_FecPriPol...
     P                 B                   export
     D SVPDAF_FecPriPol...
     D                 pi             1n
     D   peEmpr                       1    const
     D   peNrdf                       7  0 const
     D   peFemi                       8  0

     D k1yec018        ds                  likerec(p1hec018:*Key)

      /free

       k1yec018.c0empr = peEmpr;
       k1yec018.c0asen = peNrdf;
       setll %kds( k1yec018 : 2 ) pahec018;
       reade %kds( k1yec018 : 2 ) pahec018;
         dow not %eof( pahec018 );
          if c0cert <> *zeros;
           pefemi = c0femi;
           leave;
          endif;
       reade %kds( k1yec018 : 2 ) pahec018;
       enddo;

       if pefemi = *zeros;
        pefemi = 00010101;
       endif;

       return *on;

      /end-free
     P SVPDAF_FecPriPol...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getAseguradoxDoc(): Retorna Nro. de Asegurado desde   *
      *                            Nro y Tipo de Documento.-         *
      *                                                              *
      *     peTido   (input)   Tipo de Documento                     *
      *     peNrdo   (input)   Nro de docuemnto                      *
      *                                                              *
      * Retorna: Nro de Asegurado / 0 = No encontró                  *
      * ------------------------------------------------------------ *
     P SVPDAF_getAseguradoxDoc...
     P                 B                   export
     D SVPDAF_getAseguradoxDoc...
     D                 pi             7  0
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const

     D   k1ydaf        ds                  likerec( g1hdaf05 : *key )

      /free

       SVPDAF_inz();
       k1ydaf.dftido = peTido;
       k1ydaf.dfnrdo = peNrdo;
       chain %kds( k1ydaf : 2 ) gnhdaf05;
       if %found( gnhdaf05 );
         return dfnrdf;
       endif;

       return *Zeros;

      /end-free
     P SVPDAF_getAseguradoxDoc...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_getAseguradoxCuit(): Retorna Nro. de Asegurado desde  *
      *                            Cuit.-                            *
      *                                                              *
      *     peCuit   (input)   Nro de CUIT                           *
      *                                                              *
      * Retorna: Nro de Asegurado / 0 = No encontró                  *
      * ------------------------------------------------------------ *
     P SVPDAF_getAseguradoxCuit...
     P                 B                   export
     D SVPDAF_getAseguradoxCuit...
     D                 pi             7  0
     D   peCuit                      11    const

     D   k1ydaf        ds                  likerec( g1hdaf06 : *key )

      /free

       SVPDAF_inz();
       k1ydaf.dfCuit = peCuit;
       chain %kds( k1ydaf : 1 ) gnhdaf06;
       if %found( gnhdaf06 );
         return dfnrdf;
       endif;

       return *zeros;

      /end-free
     P SVPDAF_getAseguradoxCuit...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_getListaAseguradoxDoc : Retorna Lista de Nro. de      *
      *                                Asegurado desde Nro y Tipo de *
      *                                Documento.-                   *
      *                                                              *
      *     peTido   (input)   Tipo de Documento                     *
      *     peNrdo   (input)   Nro de Documento                      *
      *     peNrdf   (output)  Nro de persona (Lista)                *
      *     peNrdfC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On ( Lista ) / *Off ( No encontró )                *
      * ------------------------------------------------------------ *
     P SVPDAF_getListaAseguradoxDoc...
     P                 B                   export
     D SVPDAF_getListaAseguradoxDoc...
     D                 pi              n
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peNrdf                       7  0 dim( 100 )
     D   peNrdfC                     10i 0

     D   k1ydaf        ds                  likerec( g1hdaf05 : *key )

      /free

       SVPDAF_inz();

       clear peNrdf;
       clear peNrdfC;

       k1ydaf.dftido = peTido;
       k1ydaf.dfnrdo = peNrdo;
       setll %kds( k1ydaf : 2 ) gnhdaf05;
       if not %equal( gnhdaf05 );
         return *off;
       endif;

       dou %eof(gnhdaf05);
         reade %kds( k1ydaf : 2 ) gnhdaf05;
         if not %eof(gnhdaf05);
           if peNrdfC < 100;
             eval peNrdfC += 1;
             eval peNrdf( peNrdfC ) = dfnrdf;
           else;
             leave;
           endif;
         endif;
       enddo;

       return *on;

      /end-free

     P SVPDAF_getListaAseguradoxDoc...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_getListaAseguradoxCuit : Retorna Lista de Nro. de     *
      *                                 Asegurado desde CUIT.-       *
      *                                                              *
      *     peCuit   (input)   Nro de CUIT                           *
      *     peNrdf   (output)  Nro de persona (Lista)                *
      *     peNrdfC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On ( Lista ) / *Off ( No encontró )                *
      * ------------------------------------------------------------ *
     P SVPDAF_getListaAseguradoxCuit...
     P                 B                   export
     D SVPDAF_getListaAseguradoxCuit...
     D                 pi              n
     D   peCuit                      11    const
     D   peNrdf                       7  0 dim( 100 )
     D   peNrdfC                     10i 0

     D   k1ydaf        ds                  likerec( g1hdaf06 : *key )

      /free

       SVPDAF_inz();

       clear peNrdf;
       clear peNrdfC;

       k1ydaf.dfCuit = peCuit;
       setll %kds( k1ydaf : 1 ) gnhdaf06;
       if not %equal( gnhdaf06 );
         return *off;
       endif;

       dou %eof(gnhdaf06);
         reade %kds( k1ydaf : 1 ) gnhdaf06;
         if not %eof(gnhdaf06);
           if peNrdfC < 100;
             eval peNrdfC += 1;
             eval peNrdf( peNrdfC ) = dfnrdf;
           else;
             leave;
           endif;
         endif;
       enddo;

       return *on;

      /end-free

     P SVPDAF_getListaAseguradoxCuit...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_setllAseguradoxDoc: Se posiciona en archivo Datos     *
      *        Filiatorios Asegurado desde Nro y Tipo de Documento.- *
      *                                                              *
      *     peTido   (input)   Tipo de Documento ( opcional )        *
      *     peNrdo   (input)   Nro de Documento  ( opcional )        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPDAF_setllAseguradoxDoc...
     P                 B                   export
     D SVPDAF_setllAseguradoxDoc...
     D                 pi              n
     D   peTido                       2  0 options(*nopass:*omit)
     D   peNrdo                       8  0 options(*nopass:*omit)

     D   k1ydaf05      ds                  likerec( g1hdaf05 : *key )

      /free

       SVPDAF_inz();

       clear k1ydaf05;

       Select;
       When %parms >= 1 and %addr( peTido ) <> *null
                        and %addr( peNrdo ) <> *null;
         k1ydaf05.dftido = peTido;
         k1ydaf05.dfnrdo = peNrdo;
         setll %kds( k1ydaf05 : 2 ) gnhdaf05;
       other;
         setll *loval gnhdaf05;
       endsl;

       return %equal;

      /end-free
     P SVPDAF_setllAseguradoxDoc...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_readAseguradoxDoc : Leer un registro de Datos         *
      *        Filiatorios Asegurado desde Nro y Tipo de Documento.- *
      *                                                              *
      *     peDsDaf  (output)  Estructura DAF                        *
      *     peTido   (input)   Tipo de Documento ( opcional )        *
      *     peNrdo   (input)   Nro de Documento  ( opcional )        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPDAF_readAseguradoxDoc...
     P                 B                   export
     D SVPDAF_readAseguradoxDoc...
     D                 pi              n
     D   peDsDaf                           likeds( DsDafAseg_t )
     D   peTido                       2  0 options(*nopass:*omit)
     D   peNrdo                       8  0 options(*nopass:*omit)

     D   k1ydaf05      ds                  likerec( g1hdaf05 : *key )
     D   dsIDaf05      ds                  likerec( g1hdaf05 : *input)

      /free

       SVPDAF_inz();

       clear peDsDaf;
       clear k1ydaf05;

       Select;
       When %parms >= 1 and %addr( peTido ) <> *null
                        and %addr( peNrdo ) <> *null;
         k1ydaf05.dftido = peTido;
         k1ydaf05.dfnrdo = peNrdo;
         reade %kds( k1ydaf05 : 2 ) gnhdaf05 dsIDaf05;
       other;
         read gnhdaf05 dsIDaf05;
       endsl;

       if not %eof( gnhdaf05 );
         eval-corr peDsDaf = dsIDaf05;
       endif;
       return %eof( gnhdaf05 );

      /end-free
     P SVPDAF_readAseguradoxDoc...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_setllAseguradoxCuit: Se posiciona en archivo Datos    *
      *        Filiatorios Asegurado desde Nro CUIT.-                *
      *                                                              *
      *     peCuit   (input)   Nro CUIT          ( opcional )        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPDAF_setllAseguradoxCuit...
     P                 B                   export
     D SVPDAF_setllAseguradoxCuit...
     D                 pi              n
     D   peCuit                      11    options(*nopass:*omit)

     D   k1ydaf06      ds                  likerec( g1hdaf06 : *key )

      /free

       SVPDAF_inz();

       clear k1ydaf06;

       Select;
       When %parms >= *zeros and %addr( peCuit ) <> *null;
         k1ydaf06.dfcuit = peCuit;
         setll %kds( k1ydaf06 : 1 ) gnhdaf06;
       other;
         setll *loval gnhdaf06;
       endsl;

       return %equal;

      /end-free
     P SVPDAF_setllAseguradoxCuit...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_readAseguradoxCuit : Leer un registro de Datos        *
      *        Filiatorios Asegurado desde Nro CUIT.-                *
      *                                                              *
      *     peDsDaf  (output)  Estructura DAF                        *
      *     peCuit   (input)   Nro CUIT          ( opcional )        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPDAF_readAseguradoxCuit...
     P                 B                   export
     D SVPDAF_readAseguradoxCuit...
     D                 pi              n
     D   peDsDaf                           likeds( DsDafAseg_t )
     D   peCuit                      11    options(*nopass:*omit)

     D   k1ydaf06      ds                  likerec( g1hdaf06 : *key )
     D   dsIDaf06      ds                  likerec( g1hdaf06 : *input)

      /free

       SVPDAF_inz();

       clear peDsDaf;
       clear k1ydaf06;

       Select;
       When %parms >= *zeros and %addr( peCuit ) <> *null;
         k1ydaf06.dfcuit = peCuit;
         reade %kds( k1ydaf06 : 1 ) gnhdaf06 dsIDaf06;
       other;
         read gnhdaf06 dsIDaf06;
       endsl;

       if not %eof( gnhdaf06 );
         eval-corr peDsDaf = dsIDaf06;
       endif;
       return %eof( gnhdaf06 );

      /end-free
     P SVPDAF_readAseguradoxCuit...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_getDa9 : Retorna datos de los telefonos que se deba   *
      *                 publicar en la Web.                          *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDsTl   (output)  Estructura de datos                   *
      *     peDsTlC  (output)  Cantidad                              *
      *     peNtel   (input)   Número Telefónico                     *
      *     peTipt   (input)   Tipo de Telefono                      *
      *                                                              *
      * Retorna: *On ( Lista ) / *Off ( No encontró )                *
      * ------------------------------------------------------------ *
     P SVPDAF_getDa9...
     P                 B                   export
     D SVPDAF_getDa9...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peDsTl                            likeds ( DsTelPublic_t )
     D                                     dim(10)
     D   peDsTlC                     10i 0
     D   peNtel                      20    options( *nopass : *omit  )

     D   DsIda9        ds                  likerec( g1hda9 : *input )
     D   k1yda9        ds                  likerec( g1hda9 : *key   )

      /Free

       SVPDAF_inz();

       clear peDsTl;
       clear peDsTlC;

       Select;
         When %parms >= 1 and %addr( peNrdf ) <> *null
                          and %addr( peNtel ) <> *null;

           k1yda9.dfNrdf = peNrdf;
           k1yda9.dfNtel = peNtel;
           chain %kds( k1yda9 : 2 ) gnhda9 DsIda9;
           if %found( gnhda9 );
             eval-corr peDsTl = dsIda9;
           else;
             return *off;
           endif;

         When %parms >= 1 and %addr( peNrdf ) <> *null
                          and %addr( peNtel ) =  *null;

           setll peNrdf gnhda9;
           reade peNrdf gnhda9 DsIda9;
           dow not %eof( gnhda9 );
             peDsTlC += 1;
             eval-corr peDsTl( peDsTlC ) = dsIda9;
             reade peNrdf gnhda9 DsIda9;
           enddo;

       endsl;

       return *on;

      /end-free
     P SVPDAF_getda9...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa9: Graba GNHDA9                                  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNtel   (input)   Número Telefono                       *
      *     peTipt   (input)   Tipo de Telefono                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa9...
     P                 B                   export
     D SVPDAF_setDa9...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNtel                      20    const
     D   peTipt                       2    const

     D   @@Ntel        s             20

      /free

       SVPDAF_inz();

       @@Ntel = peNtel;
       if SVPDAF_chkDa9 ( peNrdf
                        : @@Ntel );
         return *off;

       endif;

       dfNrdf = peNrdf;
       dfNtel = peNtel;
       dfTipt = peTipt;
       dfMar1 = '0';
       dfMar2 = '0';
       dfMar3 = '0';
       dfMar4 = '0';
       dfMar5 = '0';
       dfuser = ususer;
       dfFech = (uyear  * 10000)
              + (umonth *   100)
              +  uday;
       dfTime = %dec(%time():*iso);

       write g1hda9;

       return *on;

      /end-free
     P SVPDAF_setda9...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkDa9(): Chequea si existe Dato telefónico en gnhda9 *
      *                                                              *
      *     peNrdf   (input)   Dato filatorio                        *
      *     peNtel   (input)   Número Telefono                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDa9...
     P                 B                   export
     D SVPDAF_chkDa9...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNtel                      20    options( *nopass : *omit  )

     D   k1yda9        ds                  likerec( g1hda9 : *key   )

      /Free

       SVPDAF_inz();

       if %parms >= 1 and %addr( peNrdf ) <> *null
                      and %addr( peNtel ) <> *null;

         k1yda9.dfNrdf = peNrdf;
         k1yda9.dfNtel = peNtel;
         setll %kds( k1yda9 : 2 ) gnhda9;

       else;

         setll peNrdf gnhda9;

       endif;

       return %equal;

      /end-free
     P SVPDAF_chkDa9...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_delDa9(): Elimina registro en gnhda9                  *
      *                                                              *
      *     peNrdf   (input)   Dato filatorio                        *
      *     peNtel   (input)   Número Telefono                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_delDa9...
     P                 B                   export
     D SVPDAF_delDa9...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNtel                      20    options( *nopass : *omit  )

     D   k1yda9        ds                  likerec( g1hda9 : *key   )

      /Free

       SVPDAF_inz();

       if %parms >= 1 and %addr( peNrdf ) <> *null
                      and %addr( peNtel ) <> *null;

         k1yda9.dfNrdf = peNrdf;
         k1yda9.dfNtel = peNtel;
         chain %kds( k1yda9 : 2 ) gnhda9;
         if %found( gnhda9 );
           delete g1hda9;
         endif;

       else;

         setll peNrdf gnhda9;
         reade peNrdf gnhda9;
         dow not %eof( gnhda9 );
           delete g1hda9;
           reade peNrdf gnhda9;
         enddo;

       endif;

       return *On;

      /end-free
     P SVPDAF_delDa9...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_updDa7:  Actualiza Mail de Dato Filiatorio            *
      *                                                              *
      *     peMail2  (input)   Estructura de Mail                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_updDa7...
     P                 B                   export
     D SVPDAF_updDa7...
     D                 pi              n
     D   peMail2                           likeds(DsMailDa7_t) const

     D k1yda7          ds                  likerec(g1hda7:*Key)
     D dsIda7          ds                  likerec( g1hda7 : *input)
     D dsOda7          ds                  likerec( g1hda7 : *output)

       SVPDAF_inz();

       k1yda7.dfNrdf = peMail2.dfNrdf;
       k1yda7.dfCtce = peMail2.dfCtce;
       chain %kds ( k1yda7 : 2 ) gnhda7 dsIda7;
       if %found( gnhda7 );
         eval-corr dsIda7 = peMail2;
         dsIda7.dfdate = %dec(%date():*iso);
         dsIda7.dftime = %dec(%time():*iso);
         dsIda7.dfuser = ususer;
         eval-corr dsOda7 = dsIda7;
         update g1hda7 dsOda7;
         return *on;
       endif;

       return *off;

     P SVPDAF_updDa7...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa7_2: Elimina registro en gnhda7                  *
      *                                                              *
      *     peNrdf   (input)   Dato filatorio                        *
      *     peCtce   (input)   Tipo de correo                        *
      *     peMail   (input)   Dirección e-Mail                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_dltDa7_2...
     P                 B                   export
     D SVPDAF_dltDa7_2...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peCtce                       2  0 options( *nopass : *omit  )
     D   peMail                      50    options( *nopass : *omit  )

     D   k1yda7        ds                  likerec( g1hda7 : *key   )

      /Free

       SVPDAF_inz();

       Select;

         when %parms >= 2 and %addr( peNrdf ) <> *null
                          and %addr( peCtce ) <> *null
                          and %addr( peMail ) <> *null;

           k1yda7.dfNrdf = peNrdf;
           k1yda7.dfCtce = peCtce;
           k1yda7.dfMail = peMail;
           chain %kds( k1yda7 : 3 ) gnhda7;
           if %found( gnhda7 );
             delete g1hda7;
           endif;

         when %parms >= 2 and %addr( peNrdf ) <> *null
                          and %addr( peCtce ) <> *null
                          and %addr( peMail ) = *null;

           k1yda7.dfNrdf = peNrdf;
           k1yda7.dfCtce = peCtce;
           setll %kds( k1yda7 : 2 ) gnhda7;
           reade %kds( k1yda7 : 2 ) gnhda7;
           dow not %eof( gnhda7 );
             delete g1hda7;
             reade %kds( k1yda7 : 2 ) gnhda7;
           enddo;

         other;

           setll peNrdf gnhda7;
           reade peNrdf gnhda7;
           dow not %eof( gnhda7 );
             delete g1hda7;
             reade peNrdf gnhda7;
           enddo;
       endsl;

       return *On;

      /end-free
     P SVPDAF_dltDa7_2...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDAF_chkDa62 : Chequear si tiene telefono cargado.         *
      *                                                              *
      *     peNrdf   (input)   Dato filatorio                        *
      *                                                              *
      * Retorna: *On  = Si existe                                    *
      *          *Off = No existe                                    *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDa62...
     P                 B                   export
     D SVPDAF_chkDa62...
     D                 pi              n
     D   peNrdf                       7  0 const

      /free

       SVPDAF_inz();

       setll peNrdf gnhda6;

       return %equal;

      /end-free
     P SVPDAF_chkDa62...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato72: Valida para Grabar en GNHDA7               *
      *                                                              *
      *     peNrdf   (input)   Nro de Asegurado                      *
      *     peCtce   (input)   Tipo de Mail                          *
      *     peMail   (input)   Mail                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDato72...
     P                 B                   export
     D SVPDAF_chkDato72...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peCtce                       2  0 const
     D   peMail                      50    options(*nopass:*omit)const
     D

     D k1yda7          ds                  likerec(g1hda7:*Key)

       SVPDAF_inz();

       if %parms >= 2 and %addr( peNrdf ) <> *null
                      and %addr( peCtce ) <> *null
                      and %addr( peMail ) <> *null;

         k1yda7.dfnrdf = peNrdf;
         k1yda7.dfctce = peCtce;
         k1yda7.dfmail = peMail;
         setll %kds( k1yda7 : 3 ) gnhda7;

         return %equal;

       else;

         k1yda7.dfnrdf = peNrdf;
         k1yda7.dfctce = peCtce;
         setll %kds( k1yda7 : 2 ) gnhda7;

         return %equal;

       endif;

     P SVPDAF_chkDato72...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getMailWeb: Retorna los mail para mostrar via WEB     *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peMail   (output)  DS con los mails (ver MailAddr_t en   *
      *     peMailC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getMailWeb...
     P                 B                   export
     D SVPDAF_getMailWeb...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(Mailaddr_t) dim(100)
     D   peMailC                     10i 0

     D   @@mail        ds                  likeds(DsMailDa7_t) dim(100)
     D   @@mailC       s             10i 0
     D   x             s             10i 0

       SVPDAF_inz();

       if not SVPDAF_getMail( peNrdf
                            : @@mail
                            : @@mailC );
         return *off;
       endif;

       for x = 1 to @@mailC;
         if @@mail(x).dfMar1 = '1';
           peMailC += 1;
           peMail(peMailC).mail = %trim( @@mail(x).dfmail );
           peMail(peMailC).tipo = @@mail(x).dfctce;
           peMail(peMailC).nomb = SVPDAF_getNombre( peNrdf );
         endif;
       endfor;

       return *on;

     P SVPDAF_getMailWeb...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getMail: Retorna Mail del Asegurado                   *
      *                                                              *
      *     peNrdf   (input)   Nro de Asegurado                      *
      *     peMail   (output)  DS con los mails                      *
      *     peMailC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On  = Existen                                      *
      *          *Off = No Existen                                   *
      * ------------------------------------------------------------ *
     P SVPDAF_getMail...
     P                 B                   export
     D SVPDAF_getMail...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(DsMailDa7_t) dim(100)
     D   peMailC                     10i 0

     D k1yda7          ds                  likerec( g1hda7   : *Key   )
     D dsIDaf07        ds                  likerec( g1hda7   : *input )

       SVPDAF_inz();

       setll peNrdf gnhda7;
       if not %equal( gnhda7 );
         return *off;
       endif;
       reade peNrdf gnhda7 dsIDaf07;
       dow not %eof( gnhda7 );
         peMailC += 1;
         eval-corr peMail( peMailC ) = dsIDaf07;
        reade peNrdf gnhda7 dsIDaf07;
       enddo;

       return *on;

     P SVPDAF_getMail...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkDa1: Chequea si existe en GNHDA1                   *
      *                                                              *
      *     peNrdf   (input)   Nro de Asegurado                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkDa1...
     P                 B                   export
     D SVPDAF_chkDa1...
     D                 pi              n
     D   peNrdf                       7  0 const


       SVPDAF_inz();

       setll peNrdf gnhda1;

       return %equal;

     P SVPDAF_chkDa1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkAseguradoxDoc_xCUIT                                *
      *                                                              *
      *     peNrdf   (input)   Nro. de Asegurado                     *
      *     peTido   (input)   Tipo de documento                     *
      *     peNrdo   (input)   Nro. de documento                     *
      *     peCuit   (input)   CUIT                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_chkAseguradoxDoc_xCUIT...
     P                 B                   export
     D SVPDAF_chkAseguradoxDoc_xCUIT...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peTido                       2  0 options(*nopass:*omit)
     D   peNrdo                       8  0 options(*nopass:*omit)
     D   peCuit                      11    options(*nopass:*omit)

     D k1ydaf05        ds                  likerec( g1hdaf05 : *Key )
     D k1ydaf06        ds                  likerec( g1hdaf06 : *key )

       SVPDAF_inz();

       select;

         when %parms >= 1 and %addr( peNrdf ) <> *null
                          and %addr( peTido ) <> *null
                          and %addr( peNrdo ) <> *null
                          and %addr( peCuit )  = *null;

           k1ydaf05.dfTido = peTido;
           k1ydaf05.dfNrdo = peNrdo;
           k1ydaf05.dfNrdf = peNrdf;
           setll %kds( k1ydaf05 : 3 ) gnhdaf05;


         when %parms >= 1 and %addr( peNrdf ) <> *null
                          and %addr( peTido )  = *null
                          and %addr( peNrdo )  = *null
                          and %addr( peCuit ) <> *null;

           k1ydaf06.dfCuit = peCuit;
           k1ydaf06.dfNrdf = peNrdf;
           setll %kds( k1ydaf06 : 2 ) gnhdaf06;

         other;
           return *off;
       endsl;

       return %equal;

     P SVPDAF_chkAseguradoxDoc_xCUIT...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_getDa12: Retorna GNHDA1, versión 2                    *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (output)  Nombre Alternativo                    *
      *     peDomi   (output)  Domicilio Postal                      *
      *     peCopo   (output)  Codigo Postal                         *
      *     peCops   (output)  SubCodigo Postal                      *
      *     peTeln   (output)  Telefono                              *
      *     peFnac   (output)  Fecha de Nacimiento                   *
      *     peCprf   (output)  Codigo de Profesion                   *
      *     peSexo   (output)  Codigo de Sexo                        *
      *     peEsci   (output)  Código de estado Civil                *
      *     peRaae   (output)  Código de Rama Actividad Económica    *
      *     peCiiu   (output)  Ciiu                                  *
      *     peDom2   (output)  Domicilio                             *
      *     pePesk   (output)  Peso                                  *
      *     peEstm   (output)  Estatura                              *
      *     peMfum   (output)  Marca de Fuma                         *
      *     peMzur   (output)  Marca de Zurdo                        *
      *     peMar1   (output)  Pago Aporte Previsional               *
      *     peMar2   (output)  Sujeto Exterior                       *
      *     peMar3   (output)  Constancia Empadronamiento AFIP       *
      *     peMar4   (output)  Acreedor Prendario                    *
      *     peCcdi   (output)  Clave Tributaria                      *
      *     pePain   (output)  Pais de Nacimiento                    *
      *     peCnac   (output)  Nacionalidad                          *
      *     peChij   (output)  Cantidad de Hijos                     *
      *     peCnes   (output)  Código Nivel de Estudio               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_getDa12...
     P                 B                   export
     D SVPDAF_getDa12...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                      40
     D   peDomi                      35
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peTeln                       7  0
     D   peFnac                       8  0
     D   peCprf                       3  0
     D   peSexo                       1  0
     D   peEsci                       1  0
     D   peRaae                       3  0
     D   peCiiu                       6  0
     D   peDom2                      50
     D   peLnac                      30
     D   pePesk                       5  2
     D   peEstm                       3  2
     D   peMfum                       1
     D   peMzur                       1
     D   peMar1                       1
     D   peMar2                       1
     D   peMar3                       1
     D   peMar4                       1
     D   peCcdi                      11
     D   pePain                       5  0
     D   peCnac                       3  0
     D   peChij                       2  0
     D   peCnes                       1  0

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       chain(n) peNrdf gnhda1;
       if %found( gnhda1 );

         peNomb = dfnom1;
         peDomi = dfdom1;
         peCopo = dfcop1;
         peCops = dfcos1;
         peTeln = dftel1;
         peFnac = dffnaa * 10000 + dffnam * 100 + dffnad;
         peCprf = dfcprf;
         peSexo = dfsexo;
         peEsci = dfesci;
         peRaae = dfraae;
         peDom2 = dfdom2;
         pePain = dfpain;
         peCnac = dfcnac;
         peCiiu = dfciiu;
         peDom2 = dfdom2;
         peLnac = dflnac;
         pePesk = dfpesk;
         peEstm = dfestm;
         peMfum = dfmfum;
         peMzur = dfmzur;
         peMar1 = dfmar1;
         peMar2 = dfmar2;
         peMar3 = dfmar3;
         peMar4 = dfmar4;
         peCcdi = dfccdi;
         peChij = dfChij;
         peCnes = dfCnes;

       endif;

       return *on;

     P SVPDAF_getDa12...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setDa12: Graba GNHDA1, versión 2                      *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre Alternativo                    *
      *     peDomi   (input)   Domicilio Postal                      *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Telefono                              *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     peCiiu   (input)   Ciiu                                  *
      *     peDom2   (input)   Domicilio                             *
      *     pePesk   (input)   Peso                                  *
      *     peEstm   (input)   Estatura                              *
      *     peMfum   (input)   Marca de Fuma                         *
      *     peMzur   (input)   Marca de Zurdo                        *
      *     peMar1   (input)   Pago Aporte Previsional               *
      *     peMar2   (input)   Sujeto Exterior                       *
      *     peMar3   (input)   Constancia Empadronamiento AFIP       *
      *     peMar4   (input)   Acreedor Prendario                    *
      *     peCcdi   (input)   Clave Tributaria                      *
      *     pePain   (input)   Pais de Nacimiento                    *
      *     peCnac   (input)   Codigo de Nacionalidad                *
      *     peChij   (input)   Cantidad de Hijos                     *
      *     peCnes   (input)   Código de Nivel de Estudio            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_setDa12...
     P                 B                   export
     D SVPDAF_setDa12...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   peSexo                       1  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   peCiiu                       6  0 const
     D   peDom2                      50    const
     D   peLnac                      30    const
     D   pePesk                       5  2 const
     D   peEstm                       3  2 const
     D   peMfum                       1    const
     D   peMzur                       1    const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peCcdi                      11    const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const
     D   peChij                       2  0 const
     D   peCnes                       1  0 const

     D min             c                   const('abcdefghijklmnñopqrstuvwxy-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXY-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       if not SVPDAF_chkDato1 ( peCopo
                              : peCops
                              : peFnac
                              : peCprf
                              : peEsci
                              : peRaae
                              : pePain
                              : peCnac );
         return *Off;
       endif;

       if SVPDAF_chkDa1 ( peNrdf );
         return *off;
       endif;

       dfnrdf = peNrdf;
       dfnom1 = %xlate( min : may : peNomb );
       dfdom1 = %xlate( min : may : peDomi );
       dfcop1 = peCopo;
       dfcos1 = peCops;
       dftel1 = peTeln;
       dffnaa = %subdt(tmpFec:*Years);
       dffnam = %subdt(tmpFec:*Months);
       dffnad = %subdt(tmpFec:*Days);
       dfcprf = peCprf;
       dfsexo = peSexo;
       dfesci = peEsci;
       dfraae = peRaae;
       dfciiu = peCiiu;
       dfdom2 = peDom2;
       dflnac = peLnac;
       dfpesk = pePesk;
       dfestm = peEstm;
       dfmfum = peMfum;
       dfmzur = peMzur;
       dfmar1 = peMar1;
       dfmar2 = peMar2;
       dfmar3 = peMar3;
       dfmar4 = peMar4;
       dfmar5 = *Blanks;
       dfnaci = *Blanks;
       dfnaco = *Blanks;
       dfpain = pePain;
       dfcnac = peCnac;
       dfChij = peChij;
       dfCnes = peCnes;

       write g1hda1;

       return *on;

     P SVPDAF_setDa12...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_updDa12 Actualiza GNHDA1, versión 2                   *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre Alternativo                    *
      *     peDomi   (input)   Domicilio Postal                      *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Telefono                              *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     peCiiu   (input)   Ciiu                                  *
      *     peDom2   (input)   Domicilio                             *
      *     pePesk   (input)   Peso                                  *
      *     peEstm   (input)   Estatura                              *
      *     peMfum   (input)   Marca de Fuma                         *
      *     peMzur   (input)   Marca de Zurdo                        *
      *     peMar1   (input)   Pago Aporte Previsional               *
      *     peMar2   (input)   Sujeto Exterior                       *
      *     peMar3   (input)   Constancia Empadronamiento AFIP       *
      *     peMar4   (input)   Acreedor Prendario                    *
      *     peCcdi   (input)   Clave Tributaria                      *
      *     pePain   (input)   Pais de Nacimiento                    *
      *     peCnac   (input)   Codigo de Nacionalidad                *
      *     peChij   (input)   Cantidad de Hijos                     *
      *     peCnes   (input)   Código de nivel de Estudio            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_updDa12...
     P                 B                   export
     D SVPDAF_updDa12...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   peSexo                       1  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   peCiiu                       6  0 const
     D   peDom2                      50    const
     D   peLnac                      30    const
     D   pePesk                       5  2 const
     D   peEstm                       3  2 const
     D   peMfum                       1    const
     D   peMzur                       1    const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peCcdi                      11    const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const
     D   peChij                       2  0 const
     D   peCnes                       1  0 const

     D min             c                   const('abcdefghijklmnñopqrstuvwxy-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXY-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')
     D @@fdef          s              8  0 inz(19500101)

       SVPDAF_inz();

       if not SVPDAF_chkDaf ( peNrdf );
         return *Off;
       endif;

       if not SVPDAF_chkDato1 ( peCopo
                              : peCops
                              : peFnac
                              : peCprf
                              : peEsci
                              : peRaae
                              : pePain
                              : peCnac );
         return *Off;
       endif;
       monitor;
         tmpFec = %date( %char ( peFnac ) : *iso0 );
       on-error;
         tmpFec = %date( %char ( @@fdef ) : *iso0 );
       endmon;

       if not SVPDAF_chkDa1 ( peNrdf );
         return *off;
       endif;

       chain peNrdf gnhda1;

       dfnrdf = peNrdf;
       dfnom1 = %xlate( min : may : peNomb );
       dfdom1 = %xlate( min : may : peDomi );
       dfcop1 = peCopo;
       dfcos1 = peCops;
       dftel1 = peTeln;
       dffnaa = %subdt(tmpFec:*Years);
       dffnam = %subdt(tmpFec:*Months);
       dffnad = %subdt(tmpFec:*Days);
       dfcprf = peCprf;
       dfsexo = peSexo;
       dfesci = peEsci;
       dfraae = peRaae;
       dfciiu = peCiiu;
       dfdom2 = peDom2;
       dflnac = *Blanks;
       dfpesk = pePesk;
       dfestm = peEstm;
       dfmfum = peMfum;
       dfmzur = peMzur;
       dfmar1 = peMar1;
       dfmar2 = peMar2;
       dfmar3 = peMar3;
       dfmar4 = peMar4;
       dfmar5 = *Blanks;
       dfnaci = *Blanks;
       dfnaco = *Blanks;
       dfpain = pePain;
       dfcnac = peCnac;
       dfChij = peChij;
       dfCnes = peCnes;

       update g1hda1;

       return *on;

     P SVPDAF_updDa12...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_chkGnhDad(): Verifica existencia en GNHDAD.           *
      *                                                              *
      *     peNrdf   (input)   Número de Dato Filiatorio             *
      *     peCdep   (input)   Código de Deporte                     *
      *                                                              *
      * Retorna: *On existe / *off no existe                         *
      * ------------------------------------------------------------ *
     P SVPDAF_chkGnhDad...
     P                 B                   export
     D SVPDAF_chkGnhDad...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peCdep                       3  0 const

      /free

       SVPDAF_inz();

       setll (peNrdf:peCdep) gnhdad;
       return %equal;

      /end-free

     P SVPDAF_chkGnhDad...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_setGnhDad(): Graba registro en GNHDAD.                *
      *                                                              *
      *     peNrdf   (input)   Número de Dato Filiatorio             *
      *     peCdep   (input)   Código de Deporte                     *
      *                                                              *
      * Retorna: *On grabó bien/*off hubo problema                   *
      * ------------------------------------------------------------ *
     P SVPDAF_setGnhDad...
     P                 b                   export
     D SVPDAF_setGnhDad...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peCdep                       3  0 const

      /free

       SVPDAF_inz();

       setll (peNrdf:peCdep) gnhdad;
       if not %equal;
          adnrdf = peNrdf;
          adcdep = peCdep;
          admar1 = '0';
          admar2 = '0';
          admar3 = '0';
          admar4 = '0';
          admar5 = '0';
          admar6 = '0';
          admar7 = '0';
          admar8 = '0';
          admar9 = '0';
          admar0 = '0';
          aduser = ususer;
          addate = %dec(%date():*iso);
          adtime = %dec(%time():*iso);
          write g1hdad;
          return *on;
       endif;

       return *off;

      /end-free

     P SVPDAF_setGnhDad...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltGnhDad(): Borra registro de GNHDAD.                *
      *                                                              *
      *     peNrdf   (input)   Número de Dato Filiatorio             *
      *     peCdep   (input)   Código de Deporte                     *
      *                                                              *
      * Retorna: *On borró bien/*off hubo problema                   *
      * ------------------------------------------------------------ *
     P SVPDAF_dltGnhDad...
     P                 b                   export
     D SVPDAF_dltGnhDad...
     D                 pi              n
     D   peNrdf                       7  0 const
     D   peCdep                       3  0 const

      /free

       SVPDAF_inz();

       chain (peNrdf:peCdep) gnhdad;
       if %found;
          delete g1hdad;
          return *on;
       endif;

       return *off;

      /end-free

     P SVPDAF_dltGnhDad...
     P                 e

      * ------------------------------------------------------------ *
      * SVPDAF_updDa72:  Actualiza Mail de Dato Filiatorio           *
      *                                                              *
      *     peMail2  (input)   Estructura de Mail                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P SVPDAF_updDa72...
     P                 B                   export
     D SVPDAF_updDa72...
     D                 pi              n
     D   peMail2                           likeds(DsMailDa7_t) const

     D k1yda7          ds                  likerec( g1hda7 : *Key)
     D dsIda7          ds                  likerec( g1hda7 : *input)
     D dsOda7          ds                  likerec( g1hda7 : *output)

       SVPDAF_inz();

       k1yda7.dfNrdf = peMail2.dfNrdf;
       k1yda7.dfCtce = peMail2.dfCtce;
       k1yda7.dfMail = peMail2.dfMail;
       chain %kds ( k1yda7 : 3 ) gnhda7 dsIda7;
       if %found( gnhda7 );
         eval-corr dsIda7 = peMail2;
         dsIda7.dfdate = %dec(%date():*iso);
         dsIda7.dftime = %dec(%time():*iso);
         dsIda7.dfuser = ususer;
         eval-corr dsOda7 = dsIda7;
         update g1hda7 dsOda7;
         return *on;
       endif;

       return *off;

     P SVPDAF_updDa72...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDAF_dltGnhDadDaf: Elimina todos los registros de GNHDAD   *
      *                      para un DAF.                            *
      *                                                              *
      *     peNrdf   (input)   Número de Dato Filiatorio             *
      *                                                              *
      * Retorna: *On borró bien/*off hubo problema                   *
      * ------------------------------------------------------------ *
     P SVPDAF_dltGnhDadDaf...
     P                 b                   export
     D SVPDAF_dltGnhDadDaf...
     D                 pi              n
     D   peNrdf                       7  0 const

     D rc              s              1n

      /free

       SVPDAF_inz();

       setll    peNrdf gnhdad;
       reade(n) peNrdf gnhdad;
       dow not %eof;
           rc = SVPDAF_dltGnhDad( adnrdf : adcdep );
        reade(n) peNrdf gnhdad;
       enddo;

       return *on;

      /end-free

     P SVPDAF_dltGnhDadDaf...
     P                 e

