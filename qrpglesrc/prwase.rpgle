     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * PRWASE: Tomador y asegurados adicionales                     *
      * ------------------------------------------------------------ *
      * Barranco Julio                       21-sep-2015             *
      * ------------------------------------------------------------ *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *>           BNDDIR(HDIILE/HDIBDIR) -             <*           *
      *> TEXT('Propuesta Web: Asegurados')              <*           *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((PRWASE)) <*     *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((PRWASE)) <*          *
      *> IGN: DLTSPLF FILE(PRWASE)                           <*      *
      *                                                              *
      * ************************************************************ *
      * Modificaciones:                                              *
      *   Luis R. Gomez  - 18-Abril-2016  Se guardan CUIL, AGPE -    *
      *                 insertAseguradoTomador2                      *
      * SFA 01/06/2016 - Cambio insertAseguradoTomador2              *
      *                         insertAseguradoAdicional2            *
      * SGF 23/09/2016 - Validar nacionalidad vs documento.          *
      * SGF 11/10/2016 - Mensaje diferente para Nacionalidad <= 0.   *
      * SGF 22/03/2017 - Agrego Tipo y Nro de Documento en beneficia-*
      *                  rios de AP.                                 *
      *                  Depreco _insertBeneficiarioV() e implemento *
      *                  _insertBeneficiarioV2().                    *
      *                                                              *
      * LRG 05/06/2018 - Se modifica el retorno de error de las      *
      *                  validaciones de peCbus.                     *
      *                - Se valida si cuit/dni pertenecen al         *
      *                  productor.                                  *
      *                - Se valida si el Asegurado enviado esta      *
      *                  asociado al cuit/dni enviado, caso          *
      *                  contrario se obtiene automaticamente.       *
      *                                                              *
      * GIO 13/12/2018 - Web Valida la Fecha de Nacimiento del       *
      *                  Asegurado Tomador                           *
      * LRG 21/12/2019 - Se modifica validacion de fecha de          *
      *                  nacimiento                                  *
      * NWN 11/03/2019 - Se agrega nuevo mensaje de validación en    *
      *                  COWGRAI_chkTarjCredito (TCR0005).           *
      * JSN 26/02/2019 - Se agrega SVPINT_getCadena para buscar ca-  *
      *                  becera de Intermediario en el procedimiento *
      *                  _insertAseguradoTomador2                    *
      *                                                              *
      * GIO 29/03/2019: RM#03835 Desarrollo Servicio REST WSRECV     *
      *                 Ajusta condiciones para Endoso 3/7/4         *
      *                 Cambio en Patente - Chasis - Motor           *
      * JSN 10/07/2019 - Se elimina en el procedimiento prwase_isValid
      *                  el llamado a SVPASE_chkASE                  *
      * JSN 28/06/2019 - Se modifico el procedimiento                *
      *                  _insertAseguradoTomador2 para que el tipo   *
      *                  de mail sea particular.                     *
      * JSN 21/04/2020 - Se modifico el procedimiento                *
      *                  _isValid se agrega el filtro para Endoso    *
      *                  3/1/5.                                      *
      * LRG 23/06/2020 - Nuevo Procedimiento :                       *
      *                  PRWASE_isValid2                             *
      *                  Se depreca _isValid                         *
      * JSN 22/02/2021 - Se agrega validación de CUIT en _isValid2   *
      * JSN 19/03/2021 - Se elimino la validación del CUIT en        *
      *                  _isValid2 y se agrega validación por tipo   *
      *                  de persona tipe = 'C'                       *
      * JSN 11/05/2021 _ Se agrega el procedimiento:                 *
      *                  _getAseguradoTomador                        *
      * SGF 24/02/2022 _ Valida tipo/nro de documento bloqueado en   *
      *                  _isValid2().                                *
      * ************************************************************ *
     Fctw000    if   e           k disk    usropn
     Fctw001    if   e           k disk    usropn
     Fctw003    uf a e           k disk    usropn
     Fctw004    uf a e           k disk    usropn
     Fctwet0    if   e           k disk    usropn
     Fctwet4    if   e           k disk    usropn
     Fctwetc    if   e           k disk    usropn
     Fctwer0    if   e           k disk    usropn
     Fctwer2    if   e           k disk    usropn
     Fctwer4    if   e           k disk    usropn
     Fctwer6    if   e           k disk    usropn
     Fset103    if   e           k disk    usropn
     Fset1031   if   e           k disk    usropn
     Fset250    if   e           k disk    usropn
     Fset160    if   e           k disk    usropn
     Fsehasc    if   e           k disk    usropn
     Fctwevb    uf a e           k disk    usropn
     Fgntnac    if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n

     D wrepl           s          65535a
     D ErrCode         s             10i 0
     D ErrText         s             80A

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     Is1t160
     I              t@date                      z@date

      *--- Definicion de Procedimiento --------------------------------- *
      * ---------------------------------------------------------------- *
      * PRWASE_isValid(): Valida los datos del asegurado que se está     *
      *                   cargando.                                      *
      *                                                                  *
      * *******************  DEPRECATED *******************************  *
      * llama PRWASE_isValid2                                            *
      *                                                                  *
      *                                                                  *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNcTw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peCbus  -  CBU para pagos de siniestros           *
      *                peRuta  -  número de RUTA                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *                                                                  *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_isValid...
     P                 B                   export
     D PRWASE_isValid...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaco_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t)  const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t)  const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      /free
       PRWASE_inz();

       PRWASE_isValid2( peBase
                      : peAsen
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
                      : peCbus
                      : peRuta
                      : peCiva
                      : peInsc
                      : peErro
                      : peMsgs
                      : peNctw );

       return;

      /end-free

     P PRWASE_isValid...
     P                 E
      * ---------------------------------------------------------------- *
      * PRWASE_insertAseguradoTomador():permite insertar asegurado toma- *
      *                                 dor, si ya hubiera uno, el mismo *
      *                                 es reemplazado por el enviado    *
      *                                 aquí.                            *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_insertAseguradoTomador...
     P                 B                   export
     D PRWASE_insertAseguradoTomador...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaci_t) const
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

     D k1y003          ds                  likerec(c1w003:*key)
     D actualiza       s               n
     D p@tipe          s              1

      /free

       PRWASE_inz();

       peErro = *Zeros;

       PRWASE_isValid ( peBase :
                        peNctw :
                        peAsen :
                        peDomi :
                        peDocu :
                        peNtel :
                        peTiso :
                        peNaci :
                        peCprf :
                        peSexo :
                        peEsci :
                        peRaae :
                        peMail :
                        peCbus :
                        peRuta :
                        peCiva :
                        peInsc :
                        peErro :
                        peMsgs );

       if peErro <> *Zeros;
         return;
       endif;

       //Valido tipo de Persona que se grabó en la cabecera no sea distinto
       //al que se recibe acá.

       p@tipe = COWGRAI_getTipoPersona( peBase : peNctw ) = *off;

       if (p@tipe = 'F' and petiso <> 98) or (p@tipe = 'J' and petiso = 98) or
          (p@tipe = 'C' and ( petiso <> 80 and petiso <> 81));

           %subst(wrepl:1:1) = p@tipe;
           %subst(wrepl:3:2) = %editc( petiso : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0106'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


         peErro = -1;
         return;

       endif;

       //si todo esta Ok... Grabo el asegurado titular.
       k1y003.w3empr  = PeBase.peEmpr;
       k1y003.w3sucu  = PeBase.peSucu;
       k1y003.w3nivt  = PeBase.peNivt;
       k1y003.w3nivc  = PeBase.peNivc;
       k1y003.w3nctw  = peNctw;
       k1y003.w3nase  = 1;

       chain %kds ( k1y003 : 6 ) ctw003;
       if %found ( ctw003 );
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       clear c1w003;

       w3empr = PeBase.peEmpr;
       w3sucu = PeBase.peSucu;
       w3nivt = PeBase.peNivt;
       w3nivc = PeBase.peNivc;
       w3nctw = peNctw;
       w3nase = 1;
       w3asen = peAsen;
       w3tiso = peTiso;
       w3nomb = ' ';
       w3fnac = peNaci.fnac;
       w3csex = peSexo;
       w3cesc = peEsci;
       w3tido = peDocu.tido;
       w3nrdo = peDocu.nrdo;
       w3cuit = %editc( peDocu.cuit :'X' );
       //w3njub
       w3domi = peDomi.domi;
       w3copo = peDomi.copo;
       w3cops = peDomi.cops;
       w3rpro = COWGRAI_GetCodProInd ( peDomi.copo : peDomi.cops );
       //w3agre
       w3civa = peCiva;
       w3telp = peNtel.nte1;
       w3telc = peNtel.nte3;
       w3telt = peNtel.nte2;
       w3naco = *Blanks;
       w3fein = peInsc.fein;
       w3nrin = peInsc.nrin;
       w3feco = peInsc.feco;
       w3raae = peRaae;
       w3cprf = peCprf;

       if actualiza = *off;
         write c1w003;
       else;
         update c1w003;
       endif;

       return;

      /end-free

     P PRWASE_insertAseguradoTomador...
     P                 E
      * ---------------------------------------------------------------- *
      * PRWASE_insertAseguradoTomador2():permite insertar asegurado toma-*
      *                                 dor, si ya hubiera uno, el mismo *
      *                                 es reemplazado por el enviado    *
      *                                 aquí.                            *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peNomb  -  Nombre de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_insertAseguradoTomador2...
     P                 B                   export
     D PRWASE_insertAseguradoTomador2...
     D                 pi
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

     D k1y003          ds                  likerec(c1w003:*key)
     D k1y004          ds                  likerec(c1w004:*key)
     D CambAseg        s               n
     D actualiza       s               n
     D p@tipe          s              1
     D rc2             s             10i 0
     D @id             s              7a
     D @@Asen          s              7  0
     D @@Tido          s              2  0
     D @@Nrdo          s              8  0
     D @@Cuit          s             11
     D @CNivt          s              1  0
     D @CNivc          s              5  0
     D @@Cade          s              5  0 dim(9)

      /free

       PRWASE_inz();

       peErro = *Zeros;

       PRWASE_isValid ( peBase :
                        peNctw :
                        peAsen :
                        peDomi :
                        peDocu :
                        peNtel :
                        peTiso :
                        peNaci :
                        peCprf :
                        peSexo :
                        peEsci :
                        peRaae :
                        peMail :
                        peCbus :
                        peRuta :
                        peCiva :
                        peInsc :
                        peErro :
                        peMsgs );

       if peErro <> *Zeros;
         return;
       endif;

       if peTarc.ctcu > 0;
          rc2 = COWGRAI_chkTarjCredito( peBase
                                      : peNctw
                                      : peTarc.ctcu
                                      : peTarc.nrtc  );
          if rc2 < 0;
                select;
                 when rc2 = -1;
                      @id = 'TCR0001';
                 when rc2 = -2;
                      @id = 'TCR0003';
                 when rc2 = -3;
                      @id = 'TCR0004';
                 when rc2 = -4;
                      @id = 'TCR0005';
                endsl;
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : @id
                             : peMsgs      );
                peErro = -1;
                return;
          endif;
       endif;

       //Valido tipo de Persona que se grabó en la cabecera no sea distinto
       //al que se recibe acá.

       p@tipe = COWGRAI_getTipoPersona( peBase : peNctw );

       if (p@tipe = 'F' and petiso <> 98) or (p@tipe = 'J' and petiso = 98) or
          (p@tipe = 'C' and ( petiso <> 80 and petiso <> 81));

           %subst(wrepl:1:1) = p@tipe;
           %subst(wrepl:3:2) = %editc( petiso : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0106'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


         peErro = -1;
         return;

       endif;

       @@Tido = peDocu.Tido;
       @@Nrdo = peDocu.Nrdo;
       @@Cuit = %editc(peDocu.Cuit:'X');
       CambAseg = *off;
       clear @@Cade;
       clear @CNivt;
       clear @CNivc;

       Select;
         when p@tipe = 'J' and petiso <> 98;
           @@Asen = SVPDAF_getAseguradoxCuit( @@Cuit );
           SVPINT_GetCadena( peBase.peEmpr
                           : peBase.peSucu
                           : peBase.peNivt
                           : peBase.peNivc
                           : @@Cade        );

           @CNivt = 9;
           @CNivc = @@Cade(9);

           if not SVPVAL_chkProductorAsegurado( @CNivt
                                              : @CNivc
                                              : *omit
                                              : *omit
                                              : @@Cuit   );
             wrepl = *blanks;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'API0015'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
           else;
             if peAsen = *zeros;
               CambAseg = *on;
             else;
               if not SVPDAF_chkAseguradoxDoc_xCuit( peAsen
                                                   : *omit
                                                   : *omit
                                                   : @@Cuit );
                 if @@Asen <> *zeros;
                   CambAseg = *on;
                 endif;
               endif;
             endif;
           endif;
         when p@tipe = 'F' and petiso = 98;
           @@Asen = SVPDAF_getAseguradoxDoc( @@Tido : @@Nrdo );
           SVPINT_GetCadena( peBase.peEmpr
                           : peBase.peSucu
                           : peBase.peNivt
                           : peBase.peNivc
                           : @@Cade        );

           @CNivt = 9;
           @CNivc = @@Cade(9);

           if not SVPVAL_chkProductorAsegurado( @CNivt
                                              : @CNivc
                                              : @@Tido
                                              : @@Nrdo
                                              : *omit         );
             wrepl = *blanks;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'API0015'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

             peErro = -1;
             return;
           else;
             if peAsen = *zeros;
               CambAseg = *on;
             else;
               if not SVPDAF_chkAseguradoxDoc_xCuit( peAsen
                                                   : @@Tido
                                                   : @@Nrdo
                                                   : *omit   );
                 if @@Asen <> *zeros;
                   CambAseg = *on;
                 endif;
               endif;
             endif;
           endif;
       endsl;


       //si todo esta Ok... Grabo el asegurado titular.
       k1y003.w3empr  = PeBase.peEmpr;
       k1y003.w3sucu  = PeBase.peSucu;
       k1y003.w3nivt  = PeBase.peNivt;
       k1y003.w3nivc  = PeBase.peNivc;
       k1y003.w3nctw  = peNctw;
       k1y003.w3nase  = 0;

       chain %kds ( k1y003 : 6 ) ctw003;
       if %found ( ctw003 );
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       clear c1w003;

       w3empr = PeBase.peEmpr;
       w3sucu = PeBase.peSucu;
       w3nivt = PeBase.peNivt;
       w3nivc = PeBase.peNivc;
       w3nctw = peNctw;
       w3nase = 0;
       if CambAseg = *on;
         w3asen = @@Asen;
       else;
         w3asen = peAsen;
       endif;
       w3tiso = peTiso;
       w3nomb = peNomb;
       w3fnac = peNaci.fnac;
       w3csex = peSexo;
       w3cesc = peEsci;
       w3tido = peDocu.tido;
       w3nrdo = peDocu.nrdo;
       w3cuit = %editc( peDocu.cuit :'X' );
       w3njub = peDocu.cuil;
       w3domi = peDomi.domi;
       w3copo = peDomi.copo;
       w3cops = peDomi.cops;
       w3rpro = COWGRAI_GetCodProInd ( peDomi.copo : peDomi.cops );
       if peAgpe = 'S';
          w3agre = '0';
       else;
          w3agre = '1';
       endif;
       w3civa = peCiva;
       w3telp = peNtel.nte1;
       w3telc = peNtel.nte3;
       w3telt = peNtel.nte2;
       w3naco = *Blanks;
       w3fein = peInsc.fein;
       w3nrin = peInsc.nrin;
       w3feco = peInsc.feco;
       w3raae = peRaae;
       w3cprf = peCprf;
       w3ctcu = petarc.ctcu;
       w3nrtc = petarc.nrtc;
       w3ffta = petarc.ffta;
       w3fftm = petarc.fftm;
       w3ncbu = peNcbu;
       w3cbus = peCbus;
       w3ruta = peRuta;
       w3cnac = peNaci.cnac;

       if actualiza = *off;
         write c1w003;
       else;
         update c1w003;
       endif;

       //Graba el email del Asegurado...
         k1y004.w4empr = PeBase.peEmpr;
         k1y004.w4sucu = PeBase.peSucu;
         k1y004.w4nivt = PeBase.peNivt;
         k1y004.w4nivc = PeBase.peNivc;
         k1y004.w4nctw = peNctw;
         k1y004.w4nase = 0;
         if CambAseg = *on;
           k1y004.w4asen = @@Asen;
         else;
           k1y004.w4asen = peAsen;
         endif;
         chain %kds( k1y004 : 7 ) ctw004;
         if %found ( ctw004 );
           actualiza = *on;
         else;
           actualiza = *off;
         endif;

         if peMail.ctce > 0 and
            peMail.mail <> ' ';

            w4empr = PeBase.peEmpr;
            w4sucu = PeBase.peSucu;
            w4nivt = PeBase.peNivt;
            w4nivc = PeBase.peNivc;
            w4nctw = peNctw;
            w4nase = 0;
            if CambAseg = *on;
              w4asen = @@Asen;
            else;
              w4asen = peAsen;
            endif;
            w4ctce = 1;
            w4mail = peMail.mail;
            if actualiza = *off;
              write c1w004;
            else;
              update c1w004;
            endif;
         endif;
       return;

      /end-free

     P PRWASE_insertAseguradoTomador2...
     P                 E
      * ---------------------------------------------------------------- *
      * PRWASE_deleteAseguradoTomador(): permite eliminar el asegurado   *
      *                                  tomador.                        *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_deleteAseguradoTomador...
     P                 B                   export
     D PRWASE_deleteAseguradoTomador...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const

     D k1y003          ds                  likerec(c1w003:*key)
     D p@Msgs          ds                  likeds(paramMsgs)

      /free

       PRWASE_inz();

       k1y003.w3empr = PeBase.peEmpr;
       k1y003.w3sucu = PeBase.peSucu;
       k1y003.w3nivt = PeBase.peNivt;
       k1y003.w3nivc = PeBase.peNivc;
       k1y003.w3nctw = peNctw;
       k1y003.w3nase = 0;

       chain %kds ( k1y003 : 6 ) ctw003;
       if %found(ctw003);

         delete c1w003;

       endif;

       return;

      /end-free

     P PRWASE_deleteAseguradoTomador...
     P                 E
      * ---------------------------------------------------------------- *
      * PRWASE_insertAseguradoAdicional():permite insertar asegurado adi-*
      *                                   cional.                        *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peNase  -  Número de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_insertAseguradoAdicional...
     P                 B                   export
     D PRWASE_insertAseguradoAdicional...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNase                       6  0   const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaci_t) const
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

     D k1y003          ds                  likerec(c1w003:*key)
     D actualiza       s               n

      /free

       PRWASE_inz();

       peErro = *Zeros;

       PRWASE_isValid ( peBase :
                        peNctw :
                        peAsen :
                        peDomi :
                        peDocu :
                        peNtel :
                        peTiso :
                        peNaci :
                        peCprf :
                        peSexo :
                        peEsci :
                        peRaae :
                        peMail :
                        peCbus :
                        peRuta :
                        peCiva :
                        peInsc :
                        peErro :
                        peMsgs );


       //si todo esta Ok... Grabo el asegurado adicional.

       k1y003.w3empr = PeBase.peEmpr;
       k1y003.w3sucu = PeBase.peSucu;
       k1y003.w3nivt = PeBase.peNivt;
       k1y003.w3nivc = PeBase.peNivc;
       k1y003.w3nctw = peNctw;
       k1y003.w3nase = peNase;

       chain %kds ( k1y003 : 6 ) ctw003;
       if %found ( ctw003 );
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       clear c1w003;

       w3empr = PeBase.peEmpr;
       w3sucu = PeBase.peSucu;
       w3nivt = PeBase.peNivt;
       w3nivc = PeBase.peNivc;
       w3nctw = peNctw;
       w3nase = peNase;
       w3asen = peAsen;
       w3tiso = peTiso;
       w3nomb = ' ';
       w3fnac = peNaci.fnac;
       w3csex = peSexo;
       w3cesc = peEsci;
       w3tido = peDocu.tido;
       w3nrdo = peDocu.nrdo;
       w3cuit = %editc( peDocu.cuit :'X' );
       //w3njub
       w3domi = peDomi.domi;
       w3copo = peDomi.copo;
       w3cops = peDomi.cops;
       w3rpro = COWGRAI_GetCodProInd ( peDomi.copo : peDomi.cops );
       //w3agre
       w3civa = peCiva;
       w3telp = peNtel.nte1;
       w3telc = peNtel.nte3;
       w3telt = peNtel.nte2;
       w3naco = *Blanks;
       w3fein = peInsc.fein;
       w3nrin = peInsc.nrin;
       w3feco = peInsc.feco;
       w3raae = peRaae;
       w3cprf = peCprf;

       if actualiza = *off;
         write c1w003;
       else;
         update c1w003;
       endif;

       return;

      /end-free

     P PRWASE_insertAseguradoAdicional...
     P                 E
      * ---------------------------------------------------------------- *
      * PRWASE_insertAseguradoAdicional2():permite insertar asegurado adi*
      *                                   cional.                        *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peNase  -  Número de Asegurado                    *
      *                peNomb  -  Nombre de Asegurado                    *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_insertAseguradoAdicional2...
     P                 B                   export
     D PRWASE_insertAseguradoAdicional2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNase                       6  0   const
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

     D k1y003          ds                  likerec(c1w003:*key)
     D actualiza       s               n

      /free

       PRWASE_inz();

       peErro = *Zeros;

       PRWASE_isValid ( peBase :
                        peNctw :
                        peAsen :
                        peDomi :
                        peDocu :
                        peNtel :
                        peTiso :
                        peNaci :
                        peCprf :
                        peSexo :
                        peEsci :
                        peRaae :
                        peMail :
                        peCbus :
                        peRuta :
                        peCiva :
                        peInsc :
                        peErro :
                        peMsgs );


       //si todo esta Ok... Grabo el asegurado adicional.

       k1y003.w3empr = PeBase.peEmpr;
       k1y003.w3sucu = PeBase.peSucu;
       k1y003.w3nivt = PeBase.peNivt;
       k1y003.w3nivc = PeBase.peNivc;
       k1y003.w3nctw = peNctw;
       k1y003.w3nase = peNase;

       chain %kds ( k1y003 : 6 ) ctw003;
       if %found ( ctw003 );
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       clear c1w003;

       w3empr = PeBase.peEmpr;
       w3sucu = PeBase.peSucu;
       w3nivt = PeBase.peNivt;
       w3nivc = PeBase.peNivc;
       w3nctw = peNctw;
       w3nase = peNase;
       w3asen = peAsen;
       w3tiso = peTiso;
       w3nomb = peNomb;
       w3fnac = peNaci.fnac;
       w3csex = peSexo;
       w3cesc = peEsci;
       w3tido = peDocu.tido;
       w3nrdo = peDocu.nrdo;
       w3cuit = %editc( peDocu.cuit :'X' );
       //w3njub
       w3domi = peDomi.domi;
       w3copo = peDomi.copo;
       w3cops = peDomi.cops;
       w3rpro = COWGRAI_GetCodProInd ( peDomi.copo : peDomi.cops );
       //w3agre
       w3civa = peCiva;
       w3telp = peNtel.nte1;
       w3telc = peNtel.nte3;
       w3telt = peNtel.nte2;
       w3naco = *Blanks;
       w3fein = peInsc.fein;
       w3nrin = peInsc.nrin;
       w3feco = peInsc.feco;
       w3raae = peRaae;
       w3cprf = peCprf;
       w3cnac = peNaci.cnac;

       if actualiza = *off;
         write c1w003;
       else;
         update c1w003;
       endif;

       return;

      /end-free

     P PRWASE_insertAseguradoAdicional2...
     P                 E
      * ---------------------------------------------------------------- *
      * PRWASE_deleteAseguradoAdicional():permite eliminar asegurado adi-*
      *                                   cional.                        *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *                peNase  -  Número de Asegurado                    *
      *                                                                  *
      *        Output:                                                   *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_deleteAseguradoAdicional...
     P                 B                   export
     D PRWASE_deleteAseguradoAdicional...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNase                       6  0   const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1y003          ds                  likerec(c1w003:*key)

      /free

       PRWASE_inz();

       peErro = *Zeros;

       //Valido ParmBase
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return;

       endif;

       //Valido Cotización
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;

         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTNP = ErrCode;

           %subst(wrepl:1:7) = %editc(peNctw:'X');
           %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
           %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       k1y003.w3empr = PeBase.peEmpr;
       k1y003.w3sucu = PeBase.peSucu;
       k1y003.w3nivt = PeBase.peNivt;
       k1y003.w3nivc = PeBase.peNivc;
       k1y003.w3nctw = peNctw;
       k1y003.w3nase = peNase;
       k1y003.w3asen = peasen;

       chain %kds ( k1y003 : 7 ) ctw003;
       if %found();

         delete c1w003;

       endif;


       return;

      /end-free

     P PRWASE_deleteAseguradoAdicional...
     P                 E
      * ---------------------------------------------------------------- *
      * PRWASE_ConfiguracionAsegurados ():permite traer la configuración *
      *                                   de los parametros que son y que*
      *                                   no son obligatorios.           *
      *        Input :                                                   *
      *                                                                  *
      *                peFech  -  Fecha                                  *
      *                                                                  *
      *        Output:                                                   *
      *                peCase  -  Ds configuracion                       *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_ConfiguracionAsegurados...
     P                 B                   export
     D PRWASE_ConfiguracionAsegurados...
     D                 pi
     D   peFech                       8  0 const
     D   peCase                            likeds(prwaseCase_t)

     D k1yasc          ds                  likerec(s1hasc:*key)

      /free

       PRWASE_inz();

       k1yasc.scfech = peFech;

       setll %kds ( k1yasc : 1 ) sehasc;
       read sehasc;

       peCase.cmafi = scmafi;
       peCase.ctefi = sctefi;
       peCase.cnaci = scnaci;
       peCase.csexo = scsexo;
       peCase.cesci = scesci;
       peCase.ccprf = sccprf;
       peCase.craae = scraae;
       peCase.cmaju = scmaju;
       peCase.cteju = scteju;
       peCase.cfein = scfein;
       peCase.cnrin = scnrin;
       peCase.cfeco = scfeco;
       peCase.craaej= scraaej;

       return;

      /end-free

     P PRWASE_ConfiguracionAsegurados...
     P                 E
      * ------------------------------------------------------------ *
      * PRWASE_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P PRWASE_inz      B                   export
     D PRWASE_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(ctw000);
         open ctw000;
       endif;

       if not %open(ctw001);
         open ctw001;
       endif;

       if not %open(ctw003);
         open ctw003;
       endif;

       if not %open(ctw004);
         open ctw004;
       endif;

       if not %open(ctwet0);
         open ctwet0;
       endif;

       if not %open(ctwet4);
         open ctwet4;
       endif;

       if not %open(ctwetc);
         open ctwetc;
       endif;

       if not %open(ctwer0);
         open ctwer0;
       endif;

       if not %open(ctwer2);
         open ctwer2;
       endif;

       if not %open(ctwer4);
         open ctwer4;
       endif;

       if not %open(ctwer6);
         open ctwer6;
       endif;

       if not %open(set103);
         open set103;
       endif;

       if not %open(set1031);
         open set1031;
       endif;

       if not %open(set250);
         open set250;
       endif;

       if not %open(set160);
         open set160;
       endif;

       if not %open(sehasc);
         open sehasc;
       endif;

       if not %open(ctwevb);
         open ctwevb;
       endif;

       if not %open(gntnac);
         open gntnac;
       endif;

       initialized = *ON;
       return;

      /end-free

     P PRWASE_inz      E

      * ------------------------------------------------------------ *
      * PRWASE_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P PRWASE_End      B                   export
     D PRWASE_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P PRWASE_End      E

      * ------------------------------------------------------------ *
      * PRWASE_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P PRWASE_Error    B                   export
     D PRWASE_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P PRWASE_Error    E

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

      * -----------------------------------------------------------------*
      * PRWASE_insertBeneficiarioV():Inserta beneficiarios de poliza     *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia Persona                       *
      *         peNomb (input)   Nombre                                  *
      *         peApel (input)   Apellido                                *
      *         peCuit (input)   Cuit/Cuil                               *
      *         peCnre (input)   Marca de Clausula de no Repeticion      *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWASE_insertBeneficiarioV...
     P                 B                   export
     D PRWASE_insertBeneficiarioV...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peNomb                      20    const
     D   peApel                      20    const
     D   peCuit                      11    const
     D   peCnre                       1    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1yevb          ds                  likerec(c1wevb:*key)
     D actualiza       s               n

       PRWASE_inz();

       peErro = *Zeros;
       clear peMsgs;

       // ---------------------------
       // Valido ParmBase
       // ---------------------------
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
          peErro = -1;
          return;
       endif;

       // ---------------------------
       // Valido Cotización
       // ---------------------------
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;
          ErrText = COWGRAI_Error(ErrCode);
          if COWGRAI_COTNP = ErrCode;
             %subst(wrepl:1:7) = %editc(peNctw:'X');
             %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
             %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0008'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
          endif;
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de vida
       // ------------------------------------------------
       if SVPWS_getGrupoRama ( peRama ) <> 'V';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       k1yevb.v0empr = peBase.peEmpr;
       k1yevb.v0sucu = peBase.peSucu;
       k1yevb.v0nivt = peBase.peNivt;
       k1yevb.v0nivc = peBase.peNivc;
       k1yevb.v0nctw = peNctw;
       k1yevb.v0rama = peRama;
       k1yevb.v0arse = peArse;
       k1yevb.v0secu = peSecu;

       chain %kds( k1yevb ) ctwevb;

       if %found( ctwevb );
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       v0empr = peBase.peEmpr;
       v0sucu = peBase.peSucu;
       v0nivt = peBase.peNivt;
       v0nivc = peBase.peNivc;
       v0nctw = peNctw;
       v0rama = peRama;
       v0arse = peArse;
       v0secu = peSecu;
       v0nomb = %trim( peApel ) + ', ' + %trim( peNomb );
       v0cuit = peCuit;
       v0mar1 = peCnre;
       v0mar2 = *Zeros;
       v0mar3 = *Zeros;
       v0mar4 = *Zeros;
       v0mar5 = *Zeros;
       v0user = @PsDs.CurUsr;
       v0date = %dec(%date);
       v0time = %dec(%time);

       if actualiza;
         update c1wevb;
       else;
         write c1wevb;
       endif;

     P PRWASE_insertBeneficiarioV...
     P                 E
      * -----------------------------------------------------------------*
      * PRWASE_insertBeneficiarioV2(): Inserta beneficiarios de poliza   *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia Persona                       *
      *         peNomb (input)   Nombre                                  *
      *         peTido (input)   Tipo de Documento                       *
      *         peNrdo (input)   Nro  de Documento                       *
      *         peCuit (input)   Cuit/Cuil                               *
      *         peCnre (input)   Marca de Clausula de no Repeticion      *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWASE_insertBeneficiarioV2...
     P                 B                   export
     D PRWASE_insertBeneficiarioV2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peCuit                      11a   const
     D   peCnre                       1    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1yevb          ds                  likerec(c1wevb:*key)
     D actualiza       s               n

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

       PRWASE_inz();

       peErro = *Zeros;
       clear peMsgs;

       // ---------------------------
       // Valido ParmBase
       // ---------------------------
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
          peErro = -1;
          return;
       endif;

       // ---------------------------
       // Valido Cotización
       // ---------------------------
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;
          ErrText = COWGRAI_Error(ErrCode);
          if COWGRAI_COTNP = ErrCode;
             %subst(wrepl:1:7) = %editc(peNctw:'X');
             %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
             %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0008'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
          endif;
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de vida
       // ------------------------------------------------
       if SVPWS_getGrupoRama ( peRama ) <> 'V';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0073'
                       : peMsgs      );
          peErro = -1;
          return;
       endif;

       k1yevb.v0empr = peBase.peEmpr;
       k1yevb.v0sucu = peBase.peSucu;
       k1yevb.v0nivt = peBase.peNivt;
       k1yevb.v0nivc = peBase.peNivc;
       k1yevb.v0nctw = peNctw;
       k1yevb.v0rama = peRama;
       k1yevb.v0arse = peArse;
       k1yevb.v0secu = peSecu;

       chain %kds( k1yevb ) ctwevb;

       if %found( ctwevb );
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       v0empr = peBase.peEmpr;
       v0sucu = peBase.peSucu;
       v0nivt = peBase.peNivt;
       v0nivc = peBase.peNivc;
       v0nctw = peNctw;
       v0rama = peRama;
       v0arse = peArse;
       v0secu = peSecu;
       v0nomb = %xlate( min : may : peNomb );
       v0tido = peTido;
       v0nrdo = peNrdo;
       v0cuit = peCuit;
       v0mar1 = peCnre;
       v0mar2 = *Zeros;
       v0mar3 = *Zeros;
       v0mar4 = *Zeros;
       v0mar5 = *Zeros;
       v0user = @PsDs.CurUsr;
       v0date = %dec(%date);
       v0time = %dec(%time);

       if actualiza;
         update c1wevb;
       else;
         write c1wevb;
       endif;

     P PRWASE_insertBeneficiarioV2...
     P                 E
      * -----------------------------------------------------------------*
      * PRWASE_dltBeneficiarioV(): Elimina Beneficiario                 *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWASE_dltBeneficiarioV...
     P                 B                   export
     D PRWASE_dltBeneficiarioV...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1yevb          ds                  likerec(c1wevb:*key)

       PRWASE_inz();

       peErro = *Zeros;
       clear peMsgs;

       // ---------------------------
       // Valido ParmBase
       // ---------------------------
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
          peErro = -1;
          return;
       endif;

       // ---------------------------
       // Valido Cotización
       // ---------------------------
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;
          ErrText = COWGRAI_Error(ErrCode);
          if COWGRAI_COTNP = ErrCode;
             %subst(wrepl:1:7) = %editc(peNctw:'X');
             %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
             %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0008'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
          endif;
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de vida
       // ------------------------------------------------
       if SVPWS_getGrupoRama ( peRama ) <> 'V';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       k1yevb.v0empr = peBase.peEmpr;
       k1yevb.v0sucu = peBase.peSucu;
       k1yevb.v0nivt = peBase.peNivt;
       k1yevb.v0nivc = peBase.peNivc;
       k1yevb.v0nctw = peNctw;
       k1yevb.v0rama = peRama;
       k1yevb.v0arse = peArse;
       k1yevb.v0secu = peSecu;

       chain %kds( k1yevb ) ctwevb;
       if %found();

         delete c1wevb;
         return;

       else;

         SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0107'
                       : peMsgs      );
         peErro = -1;
         return;

       endif;

       return;

     P PRWASE_dltBeneficiarioV...
     P                 E

      * -----------------------------------------------------------------*
      * PRWASE_insertClausulaV():Inserta Clausula de No Repeticion       *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia Persona                       *
      *         peNomb (input)   Nombre / Razon Social                   *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWASE_insertClausulaV...
     P                 B                   export
     D PRWASE_insertClausulaV...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peNomb                      20    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1yevb          ds                  likerec(c1wevb:*key)
     D actualiza       s               n

       PRWASE_inz();

       peErro = *Zeros;
       clear peMsgs;

       // ---------------------------
       // Valido ParmBase
       // ---------------------------
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
          peErro = -1;
          return;
       endif;

       // ---------------------------
       // Valido Cotización
       // ---------------------------
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;
          ErrText = COWGRAI_Error(ErrCode);
          if COWGRAI_COTNP = ErrCode;
             %subst(wrepl:1:7) = %editc(peNctw:'X');
             %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
             %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0008'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
          endif;
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de vida
       // ------------------------------------------------
       if SVPWS_getGrupoRama ( peRama ) <> 'V';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       k1yevb.v0empr = peBase.peEmpr;
       k1yevb.v0sucu = peBase.peSucu;
       k1yevb.v0nivt = peBase.peNivt;
       k1yevb.v0nivc = peBase.peNivc;
       k1yevb.v0nctw = peNctw;
       k1yevb.v0rama = peRama;
       k1yevb.v0arse = peArse;
       k1yevb.v0secu = peSecu;

       chain %kds( k1yevb ) ctwevb;

       if %found( ctwevb );
         actualiza = *on;
       else;
         actualiza = *off;
       endif;

       v0empr = peBase.peEmpr;
       v0sucu = peBase.peSucu;
       v0nivt = peBase.peNivt;
       v0nivc = peBase.peNivc;
       v0nctw = peNctw;
       v0rama = peRama;
       v0arse = peArse;
       v0secu = peSecu;
       v0nomb = peNomb;
       v0cuit = *Blanks;
       v0mar1 = 'S';
       v0mar2 = '1';
       v0mar3 = *Zeros;
       v0mar4 = *Zeros;
       v0mar5 = *Zeros;
       v0user = @PsDs.CurUsr;
       v0date = %dec(%date);
       v0time = %dec(%time);

       if actualiza;
         update c1wevb;
       else;
         write c1wevb;
       endif;

     P PRWASE_insertClausulaV...
     P                 E
      * -----------------------------------------------------------------*
      * PRWASE_deleteClausulaV():Elimina Clausula de No Repeticion       *
      *                                                                  *
      *         peBase (input)   Paramametro Base                        *
      *         peNctw (input)   Numero de Cotizacion                    *
      *         peRama (input)   Rama                                    *
      *         peArse (input)   Arse                                    *
      *         peSecu (input)   Secuencia                               *
      *         peErro (output)  Indicador de Error                      *
      *         peMsgs (output)  Estructura de Error                     *
      *                                                                  *
      * Retorna: Void                                                    *
      * ---------------------------------------------------------------- *
     P PRWASE_deleteClausulaV...
     P                 B                   export
     D PRWASE_deleteClausulaV...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D k1yevb          ds                  likerec(c1wevb:*key)

       PRWASE_inz();

       peErro = *Zeros;
       clear peMsgs;

       // ---------------------------
       // Valido ParmBase
       // ---------------------------
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
          peErro = -1;
          return;
       endif;

       // ---------------------------
       // Valido Cotización
       // ---------------------------
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;
          ErrText = COWGRAI_Error(ErrCode);
          if COWGRAI_COTNP = ErrCode;
             %subst(wrepl:1:7) = %editc(peNctw:'X');
             %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
             %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'COW0008'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
          endif;
          peErro = -1;
          return;
       endif;

       // ------------------------------------------------
       // Valido que sea una rama de vida
       // ------------------------------------------------
       if SVPWS_getGrupoRama ( peRama ) <> 'V';
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0073'
                         : peMsgs      );
          peErro = -1;
          return;
       endif;

       k1yevb.v0empr = peBase.peEmpr;
       k1yevb.v0sucu = peBase.peSucu;
       k1yevb.v0nivt = peBase.peNivt;
       k1yevb.v0nivc = peBase.peNivc;
       k1yevb.v0nctw = peNctw;
       k1yevb.v0rama = peRama;
       k1yevb.v0arse = peArse;
       k1yevb.v0secu = peSecu;

       chain %kds( k1yevb ) ctwevb;
       if %found();

         delete c1wevb;
         return;

       else;

         SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0107'
                       : peMsgs      );
         peErro = -1;
         return;

       endif;

       return;

     P PRWASE_deleteClausulaV...
     P                 E
      * ---------------------------------------------------------------- *
      * PRWASE_isValid2(): Valida los datos del asegurado que se está    *
      *                    cargando.                                     *
      *                                                                  *
      *         peBase ( input  ) Base                                   *
      *         peAsen ( input  ) Código de Asegurado                    *
      *         peDomi ( input  ) Estructura (Domi, Copo, Cops)          *
      *         peDocu ( input  ) Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *         peNtel ( input  ) Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *         peTiso ( input  ) Código Tipo de Persona                 *
      *         peNaci ( input  ) Estructura (Fnac,Lnac,Pain,Naci)       *
      *         peCprf ( input  ) Código de profesión                    *
      *         peSexo ( input  ) Código de Sexo                         *
      *         peEsci ( input  ) Código de Estado Civil                 *
      *         peRaae ( input  ) Código Rama Actividad Económica        *
      *         peMail ( input  ) Estructura (Ctce,Mail)                 *
      *         peCbus ( input  ) CBU para pagos de siniestros           *
      *         peRuta ( input  ) número de RUTA                         *
      *         peCiva ( input  ) Código Inscripción de IVA              *
      *         peInsc ( input  ) Estructura (Fein,Nrin,Feco)            *
      *         peErro ( output ) Indicador de Error                     *
      *         peMsgs ( output ) Estructura de Error                    *
      *         peNctw ( input  ) Número de Cotización   ( opcional )    *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_isValid2...
     P                 B                   export
     D PRWASE_isValid2...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0   const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaco_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t)  const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t)  const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D   peNctw                       7  0   const options(*nopass:*omit)

     D k1y000          ds                  likerec(c1w000:*key)
     D ind             s               n
     D p@Case          ds                  likeds(prwaseCase_t)
     D esCotiWeb       s               n

     D*- Fecha AAAA MM DD
     D                 ds
     D dsFecH                  1      8  0
     D  dsFecA                 1      4  0
     D  dsFecM                 5      6  0
     D  dsFecD                 7      8  0

     d @@MayorEdadVS   s            512                      inz(*blanks)
     d @@MayorEdad     s              2  0
     d @@vsys          s            512

     d @@tiou          s              1  0
     d @@stou          s              2  0
     d @@stos          s              2  0

      /free

       PRWASE_inz();

       peErro = *Zeros;

       @@Vsys = 'N';
       if SVPVLS_getValSys( 'HVALASEBLK'
                          : *omit
                          : @@Vsys      ) = *off;
          @@Vsys = 'N';
       endif;

       //Valido ParmBase
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;

         peErro = -1;
         return;

       endif;

       esCotiWeb = *off;
       //Valido Cotización
       if %parms >= 19 and %addr( peNctw ) <> *null;
          esCotiWeb = *on;
       endif;
       if esCotiWeb;
          if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;
             ErrText = COWGRAI_Error(ErrCode);
             if COWGRAI_COTNP = ErrCode;
                %subst(wrepl:1:7) = %trim(%char(peNctw));
                %subst(wrepl:8:1) = %editc(peBase.peNivt:'X');
                %subst(wrepl:9:5) = %trim(%char(peBase.peNivc));
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0008'
                             : peMsgs
                             : %trim(wrepl)
                             : %len(%trim(wrepl))  );
             endif;
             peErro = -1;
             return;
          endif;
       endif;

       PRWASE_ConfiguracionAsegurados( %dec(%date:*iso) : p@case );

       //Valido el domicilio
       if peDomi.domi = *blanks;

         wrepl = *blanks;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0002'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       //Valido el Código Postal
       if SVPVAL_codigoPostal ( peDomi.Copo :
                                peDomi.Cops ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_COPNE = ErrCode;

           %subst(wrepl:1:5) = %editc(peDomi.Copo:'X');
           %subst(wrepl:7:1) = %editc(peDomi.Cops:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido el tipo de documento.
       if SVPVAL_tipoDeDocumento ( peDocu.Tido ) = *off and peTiso = 98;

           %subst(wrepl:1:2) = %editc(peDocu.Tido:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0004'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );



         peErro = -1;
         return;

       endif;

       //Valido que el número de documento no sea cero
       if peDocu.Nrdo <= 0 and peTiso = 98;

         wrepl = *blanks;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0005'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       //
       // Valido Documento bloqueado
       //
       if peTiso = 98;
          if (esCotiWeb);
             if @@Vsys = 'S';
                if not SVPVAL_chkBlkDocumento( peBase
                                             : peNctw
                                             : peDocu.tido
                                             : peDocu.nrdo );
                   %subst(wrepl:1:8) = %editc(peDocu.nrdo:'X');
                   SVPWS_getMsgs( '*LIBL'
                                : 'WSVMSG'
                                : 'PRW0063'
                                : peMsgs
                                : %trim(wrepl)
                                : %len(%trim(wrepl))  );
                   peErro = -1;
                   return;
                endif;
             endif;
          endif;
       endif;

       //Valido que el CUIT no este bloqueado.
       if peDocu.Cuit <= 0 and ( peTiso <> 98 and peTiso <> 81 );

         wrepl = *blanks;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0006'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );


         peErro = -1;
         return;

       endif;

       //Valido que el CUIT no este bloqueado.
       if esCotiWeb;
          if SVPVAL_chkBlkCuit ( peBase : peNctw : peDocu.Cuit ) = *off
             and ( peTiso <> 98 and peTiso <> 81 );

            ErrText = SVPVAL_Error(ErrCode);

            if SVPVAL_ASBLK = ErrCode;

              %subst(wrepl:1:11) = %editc(peDocu.Cuit:'X');

              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0007'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );

            endif;

            peErro = -1;
            return;

          endif;
       endif;

       //Valido número de CUIT.
       if peDocu.Cuit <> 0;

         if SVPVAL_CuitCuil ( %editc( peDocu.Cuit : 'Z') ) = *off;

           %subst(wrepl:1:11) = %editc(peDocu.Cuit:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

       endif;

       //Valido número de CUIL
       if peDocu.Cuil <> 0;

         if SVPVAL_CuitCuil ( %editc( peDocu.Cuil : 'Z') ) = *off;

           %subst(wrepl:1:11) = %editc(peDocu.Cuil:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0009'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

       endif;

       if SVPVAL_chkTipoPersona ( peTiso ) = *off;

           %subst(wrepl:1:2) = %editc(peTiso:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0019'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


         peErro = -1;
         return;

       endif;

       //Valido Fecha de Nacimiento para personas fisicas
       if peTiso = 98 and peNaci.Fnac <> 0;

         test(DE) *iso peNaci.Fnac;
         if %error;

           wrepl = *blanks;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl)) );

           peErro = -1;
           return;

         else;

           if %dec(%date(peNaci.Fnac:*iso)) > %dec(%date():*iso);

             wrepl = *blanks;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0047'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl)) );

             peErro = -1;
             return;

           else;

             @@MayorEdad = 18;
             if SVPVLS_getValSys( 'HMAYOREDAD' : *omit : @@MayorEdadVS );
               @@MayorEdad = %dec(%trim(@@MayorEdadVS) : 2 : 0);
             endif;

             dsFecH = %dec(%date(peNaci.Fnac:*iso));
             if ( dsFecM * 100 ) + dsFecD <= ( *month * 100 ) + *day;

               if (*year - dsFecA) < @@MayorEdad;

                 wrepl = *blanks;
                 SVPWS_getMsgs( '*LIBL'
                              : 'WSVMSG'
                              : 'PRW0048'
                              : peMsgs
                              : %trim(wrepl)
                              : %len(%trim(wrepl)) );

                 peErro = -1;
                 return;

               endif;

             else;

               if (*year - dsFecA - 1 ) < @@MayorEdad;

                 wrepl = *blanks;
                 SVPWS_getMsgs( '*LIBL'
                              : 'WSVMSG'
                              : 'PRW0048'
                              : peMsgs
                              : %trim(wrepl)
                              : %len(%trim(wrepl)) );

                 peErro = -1;
                 return;

               endif;

             endif;

           endif;

         endif;

       endif;

       //Valido Código de Profesión
       if peCprf <> 0;

         if SVPVAL_chkProfesionWeb ( peCprf ) = *off;

              %subst(wrepl:1:3) = %editc( peCprf:'X');

              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0011'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );


            peErro = -1;
            return;

         endif;

       endif;


       //Valido primer digito verificador del CBU
       if peCbus <> 0;

         if SPVCBU_Check1erDigVerif ( %editc(peCbus:'X') );

           ErrText = SPVCBU_Error(ErrCode);

           if SPVCBU_D1INV = ErrCode;

             %subst(wrepl:1:22) = %editc(peCbus:'X');

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0016'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

             peErro = -1;
             return;
           endif;

         endif;

       endif;

       //Valido segundo digito verificador del CBU
       if peCbus <> 0;

         if SPVCBU_Check2doDigVerif ( %editc(peCbus:'X'));

           ErrText = SPVCBU_Error(ErrCode);

           if SPVCBU_D2INV = ErrCode;

             %subst(wrepl:1:22) = %editc(peCbus:'X');

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0016'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

             peErro = -1;
             return;
           endif;

         endif;

       endif;

       //Valido Número de Ruta
       if esCotiWeb;
          if SVPVAL_chkNroDeRuta ( peBase : peNctw ) and  peRuta = 0;

            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'PRW0031'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            peErro = -1;
            return;

          endif;
       endif;

       //Valido Código de IVA

       if SVPVAL_ivaWeb ( peCiva ) =  *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_IVANW = ErrCode;

           %subst(wrepl:1:2) = %editc(peCiva:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0012'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         if SVPVAL_IVANE = ErrCode;

           %subst(wrepl:1:2) = %editc(peCiva:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


         endif;

        peErro = -1;
        return;

       endif;

       //Valido Codigo de pais de Nacimiento
       if peNaci.pain <> 0;

         if SVPVAL_chkPaisNac ( peNaci.pain ) = *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_PAINV = ErrCode;

             %subst(wrepl:1:5) = %editc(peNaci.Pain:'X');

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0015'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

           endif;

           peErro = -1;
           return;

         endif;

       endif;

       //Valido Codigo de Nacionalidad
       if peNaci.cnac <> *ZEros;

         if not SVPVAL_nacionalidad ( peNaci.cnac );

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_PAINV = ErrCode;

             %subst(wrepl:1:5) = %editc(peNaci.Pain:'X');

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0042'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

           endif;

           peErro = -1;
           return;

         endif;

       endif;

       // Si operacion 3/7/4 or 3/1/5 => No hacer la validacion
       if esCotiWeb;
         COWGRAI_getTipoDeOperacion ( peBase : peNctw
                                    : @@tiou : @@stou : @@stos);
         if not ( @@tiou = 3 and @@stou = 7 and @@stos = 4 ) and
            not ( @@tiou = 3 and @@stou = 1 and @@stos = 5 );
            if peTiso = 98 and peNaci.cnac <= 0;
               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'PRW0044'
                            : peMsgs     );
               peErro = -1;
               return;
            endif;
         endif;
       endif;

       //Valido Sexo.
       if peSexo <> 0;

         if SVPVAL_chkSexoWeb ( peSexo ) = *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_SEXNW = ErrCode;

             %subst(wrepl:1:1) = %editc( peSexo:'X');

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0012'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

           endif;

           peErro = -1;
           return;

         endif;

       endif;


       //Valido Estado Civil.
       if peEsci <> 0;

         if SVPVAL_chkEdoCivilWeb( peEsci ) = *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_ESCNW = ErrCode;

             %subst(wrepl:1:3) = %editc( peEsci:'X');

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0013'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

           endif;

           peErro = -1;
           return;

         endif;

       endif;

       //Valido Rama actividad Economica
       if peRaae <> 0;

         if SVPVAL_chkRamaActEWeb( peRaae ) = *off;

           ErrText = SVPVAL_Error(ErrCode);

           if SVPVAL_RAENW = ErrCode;

             %subst(wrepl:1:3) = %editc( peRaae:'X');

             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0014'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );

           endif;

           peErro = -1;
           return;

         endif;

       endif;

       if peTiso <> 98;

       //Valido Fecha de Inscripción
         test(DE) *iso peInsc.Fein;
         if %error and p@case.cfein = 'S';

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0017'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

         //Valido Fecha de Contrato
         test(DE) *iso peInsc.Feco;
         if %error and p@case.cfeco = 'S';

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0018'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

       endif;

       //Valido Mail
       if not ( @@tiou = 3 and @@stou = 7 and @@stos = 4 ) and
          not ( @@tiou = 3 and @@stou = 1 and @@stos = 5 );
          if peMail.mail <> *blanks;

            if MAIL_isValid( peMail.mail ) = *off;


              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'PRW0025'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );

              peErro = -1;
              return;

            endif;

          endif;
       endif;

       //Valido pagina Web
       if peNtel.pweb <> *blanks;

         if SVPVAL_urlIsValid ( %trim(peNtel.pweb) :
                                %len ( %trim(peNtel.pweb) ) ) = *off;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0032'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

       endif;

       PRWASE_ConfiguracionAsegurados ( %dec(%date:*iso) : p@Case );

       if peTiso = 98;
       //
       //fisicas
       //

         //Valido el mail.
         if p@Case.cmafi = 'S' and peMail.mail = *blanks;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0020'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


            peErro = -1;
            return;

         endif;

         //Valido Estado Civil
         if p@Case.cesci ='S' and peEsci = 0;

               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'PRW0021'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );


             peErro = -1;
             return;

         endif;


         //Valido el telefono
         if p@Case.ctefi ='S' and peNtel.nte1 = *blanks and peNtel.nte2 =*blanks
         and peNtel.nte3 = *blanks and peNtel.nte4 =*blanks;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0022'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


           peErro = -1;
           return;

         endif;


         //Valido la nacionalidad
         if p@Case.cnaci ='S' and peNaci.cnac = *Zeros and peTiso <> 98;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0023'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


           peErro = -1;
           return;

         endif;


         //Valido Sexo si es obligatorio o no.
         if p@Case.csexo = 'S' and peSexo = 0;

           SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'PRW0024'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );


           peErro = -1;
           return;

         endif;

         //Valido Código de Profesión
         if p@Case.ccprf = 'S' and peCprf = 0;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0026'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


            peErro = -1;
            return;

         endif;


         //Valido Rama actividad Economica
         if p@Case.craae = 'S' and peRaae = 0;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0027'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


             peErro = -1;
             return;

         endif;

       else;

         //
         //Juridicos
         //

         //Valido Rama actividad Economica
         if p@Case.craaej = 'S' and peRaae = 0;

           SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0027'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );


           peErro = -1;
           return;

         endif;

         //Valido Numero de inscripción
         if p@Case.cnrin = 'S' and peInsc.nrin = 0;

           SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0028'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

         //Valido Fecha de Contrato
         if p@Case.cfeco = 'S' and peInsc.feco = 0;

           SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0029'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

         //Valido Fecha de Inscripción
         if p@Case.cfein = 'S' and peInsc.fein = 0;

           SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRW0030'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

       endif;

       if peTiso = 98 and @@tiou <> 3;
          if peDocu.tido = 4 and peDocu.nrdo >=90000000 and peNaci.cnac = 2;
             chain peNaci.cnac gntnac;
             if not %found;
                acdnac = 'ARGENTINA';
             endif;
             %subst(wrepl:1:8)  = %trim(%char(peDocu.nrdo));
             %subst(wrepl:9:20) = %trim(acdnac);
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0043'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
          if peDocu.tido = 4 and peDocu.nrdo <90000000 and peNaci.cnac<>2;
             chain peNaci.cnac gntnac;
             if not %found;
                acdnac = 'NO ENCONTRADA';
             endif;
             %subst(wrepl:1:8)  = %trim(%char(peDocu.nrdo));
             %subst(wrepl:9:20) = %trim(acdnac);
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'PRW0043'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             peErro = -1;
             return;
          endif;
       endif;

       return;

      /end-free

     P PRWASE_isValid2...
     P                 E
      * ---------------------------------------------------------------- *
      * PRWASE_getAseguradoTomador(): Retorna asegurado tomador          *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peAsen  -  Código de Asegurado                    *
      *        Output:                                                   *
      *                peNomb  -  Nombre del Asegurado                   *
      *                peDomi  -  Estructura (Domi, Copo, Cops)          *
      *                peDocu  -  Estructura (Tido,Nrdo,Cuit,Cuil)       *
      *                peNtel  -  Estructura (Nte1,Nte2,Nte3,Nte4,Pweb)  *
      *                peTiso  -  Código Tipo de Persona                 *
      *                peNaci  -  Estructura (Fnac,Lnac,Pain,Naci)       *
      *                peCprf  -  Código de profesión                    *
      *                peSexo  -  Código de Sexo                         *
      *                peEsci  -  Código de Estado Civil                 *
      *                peRaae  -  Código Rama Actividad Económica        *
      *                peMail  -  Estructura (Ctce,Mail)                 *
      *                peAgpe  -  Agente de Percepción(S/N)              *
      *                peTarc  -  Estructura (Ctcu,Nrtc,Ffta,Fftm)       *
      *                peNcbu  -  CBU pago de Pólizas                    *
      *                peCbus  -  CBU para pago de Siniestros            *
      *                peRuta  -  Número de Ruta                         *
      *                peCiva  -  Código Inscripción de IVA              *
      *                peInsc  -  Estructura (Fein,Nrin,Feco)            *
      *                                                                  *
      * ---------------------------------------------------------------- *

     P PRWASE_getAseguradoTomador...
     P                 B                   export
     D PRWASE_getAseguradoTomador...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNomb                      40
     D   peDomi                            likeds(prwaseDomi_t)
     D   peDocu                            likeds(prwaseDocu_t)
     D   peNtel                            likeds(prwaseTele_t)
     D   peTiso                       2  0
     D   peNaci                            likeds(prwaseNaco_t)
     D   peCprf                       3  0
     D   peSexo                       1  0
     D   peEsci                       1  0
     D   peRaae                       3  0
     D   peMail                            likeds(prwaseEmail_t)
     D   peAgpe                       1a
     D   peTarc                            likeds(prwaseTarc_t)
     D   peNcbu                      22  0
     D   peCbus                      22  0
     D   peRuta                      16  0
     D   peCiva                       2  0
     D   peInsc                            likeds(prwaseInsc_t)

     D k1y003          ds                  likerec(c1w003:*key)
     D p@tipe          s              1

      /free

       PRWASE_inz();

       k1y003.w3empr  = PeBase.peEmpr;
       k1y003.w3sucu  = PeBase.peSucu;
       k1y003.w3nivt  = PeBase.peNivt;
       k1y003.w3nivc  = PeBase.peNivc;
       k1y003.w3nctw  = peNctw;
       k1y003.w3nase  = 0;

       chain %kds ( k1y003 : 6 ) ctw003;
       if %found ( ctw003 );
         petiso = w3tiso;
         peNomb = w3nomb;
         peNaci.fnac = w3fnac;
         peNaci.cnac = w3cnac;
         peSexo = w3csex;
         peEsci = w3cesc;
         peDocu.tido = w3tido;
         peDocu.nrdo = w3nrdo;
         peDocu.cuit = %dec(w3cuit:11:0);
         peDomi.domi = w3domi;
         peDomi.copo = w3copo;
         peDomi.cops = w3cops;
         peCiva = w3civa;
         peNtel.nte1 = w3telp;
         peNtel.nte3 = w3telc;
         peNtel.nte2 = w3telt;
         peInsc.fein = w3fein;
         peInsc.nrin = w3nrin;
         peInsc.feco = w3feco;
         peRaae = w3raae;
         peCprf = w3cprf;

         return *on;
       endif;

       return *off;

      /end-free

     P PRWASE_getAseguradoTomador...
     P                 E
