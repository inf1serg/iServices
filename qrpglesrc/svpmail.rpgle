     H nomain

     Fgnhdaf    if   e           k disk    usropn
     Fgnhda7    if   e           k disk    usropn
     Fsehni201  if   e           k disk    usropn
     Fcntnau01  if   e           k disk    usropn

      /copy './qcpybooks/svpmail_h.rpgle'

     D SetError        pr
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

     D Errn            s             10i 0
     D Errm            s             80a
     D Initialized     s              1N

      * ------------------------------------------------------------ *
      * SVPMAIL_xNrDaf(): Busca Direcciones de Mail x NRDF.          *
      *                                                              *
      *     peNrdf   (input)   Nro de Dato Filiatorio                *
      *     peCtce   (input)   Tipo de Mail (opcional)               *
      *                        Si no llega, se cargan todos los mails*
      *     peMadd   (output)  DS con los mails (ver MailAddr_t en   *
      *                        el header)                            *
      *                                                              *
      * Retorna: 0 cuando no hay mails                               *
      *         -1 si hay error                                      *
      *         >0 Cantidad de direcciones cargadas                  *
      * ------------------------------------------------------------ *
     P SVPMAIL_xNrDaf  B                   EXPORT
     D SVPMAIL_xNrDaf  pi            10i 0
     D   peNrdf                       7  0 const
     D   peMadd                            likeds(Mailaddr_t) dim(100)
     D   peCtce                       2  0 const options(*nopass:*omit)

     D z               s             10i 0
     D k1hda7          ds                  likerec(g1hda7:*key)

      /free

       SVPMAIL_inz();

       chain peNrdf gnhdaf;
       if not %found;
          SetError( SVPMAIL_DAFNF
                  : 'No se encuentra el Nro de persona' );
          SVPMAIL_end();
          return -1;
       endif;

       k1hda7.dfnrdf = peNrdf;
       if %parms >= 3 and %addr(peCtce) <> *null;
          k1hda7.dfctce = peCtce;
       endif;

       if %parms >= 3 and %addr(peCtce) <> *null;
          setll %kds(k1hda7:2) gnhda7;
          reade %kds(k1hda7:2) gnhda7;
          dow not %eof;
              z += 1;
              if z > 100;
                 leave;
              endif;
              peMadd(z).mail = dfmail;
              peMadd(z).nomb = dfnomb;
              peMadd(z).tipo = dfctce;
           reade %kds(k1hda7:2) gnhda7;
          enddo;
        else;
          setll peNrdf gnhda7;
          reade peNrdf gnhda7;
          dow not %eof;
              z += 1;
              if z > 100;
                 leave;
              endif;
              peMadd(z).mail = dfmail;
              peMadd(z).nomb = dfnomb;
              peMadd(z).tipo = dfctce;
           reade peNrdf gnhda7;
          enddo;
       endif;

       return z;

      /end-free

     P SVPMAIL_xNrDaf  E

      * ------------------------------------------------------------ *
      * SVPMAIL_xNivc(): Busca Direcciones de Mail x Nivt/Nivc.      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   nivel en la cadena                    *
      *     peNivc   (input)   Nro. del Productor/organiz./etc.      *
      *     peMadd   (output)  DS con los mails (ver MailAddr_t en   *
      *                        el header)                            *
      *     peCtce   (input)   Tipo de Mail (opcional)               *
      *                        Si no llega, se cargan todos los mails*
      *                                                              *
      * Retorna: 0 cuando no hay mails                               *
      *         -1 si hay error                                      *
      *         >0 Cantidad de direcciones cargadas                  *
      * ------------------------------------------------------------ *
     P SVPMAIL_xNivc   B                   EXPORT
     D SVPMAIL_xNivc   pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peMadd                            likeds(MailAddr_t) dim(100)
     D   peCtce                       2  0 const options(*nopass:*omit)

     D k1hni2          ds                  likerec(s1hni201:*key)

      /free

       SVPMAIL_inz();

       k1hni2.n2empr = peEmpr;
       k1hni2.n2sucu = peSucu;
       k1hni2.n2nivt = peNivt;
       k1hni2.n2nivc = peNivc;
       chain %kds(k1hni2) sehni201;
       if not %found;
          SetError( SVPMAIL_INTNF
                  : 'No se encuentra el Intermediario' );
          SVPMAIL_end();
          return -1;
       endif;

       if %parms >= 6 and %addr(peCtce) <> *null;
          return SVPMAIL_xNrDaf( n2nrdf
                               : peMadd
                               : peCtce );
        else;
          return SVPMAIL_xNrDaf( n2nrdf
                               : peMadd
                               : *omit   );
       endif;

      /end-free

     P SVPMAIL_xNivc   E

      * ------------------------------------------------------------ *
      * SVPMAIL_xProv(): Busca Direcciones de Mail x Proveedor.      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peComa   (input)   Código de Mayor auxiliar              *
      *     peNrma   (input)   Número de Mayor Auxiliar              *
      *     peMadd   (output)  DS con los mails (ver MailAddr_t en   *
      *                        el header)                            *
      *     peCtce   (input)   Tipo de Mail (opcional)               *
      *                        Si no llega, se cargan todos los mails*
      *                                                              *
      * Retorna: 0 cuando no hay mails                               *
      *         -1 si hay error                                      *
      *         >0 Cantidad de direcciones cargadas                  *
      * ------------------------------------------------------------ *
     P SVPMAIL_xProv   B                   EXPORT
     D SVPMAIL_xProv   pi            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2a   const
     D   peNrma                       7  0 const
     D   peMadd                            likeds(MailAddr_t) dim(100)
     D   peCtce                       2  0 const options(*nopass:*omit)

     D k1tnau          ds                  likerec(c1tnau01:*key)

      /free

       SVPMAIL_inz();

       k1tnau.naempr = peEmpr;
       k1tnau.nasucu = peSucu;
       k1tnau.nacoma = peComa;
       k1tnau.nanrma = peNrma;
       chain %kds(k1tnau) cntnau01;
       if not %found;
          SetError( SVPMAIL_PRONF
                  : 'No se encuentra el Proveedor' );
          SVPMAIL_end();
          return -1;
       endif;

       if %parms >= 6 and %addr(peCtce) <> *null;
          return SVPMAIL_xNrDaf( nanrdf
                               : peMadd
                               : peCtce );
        else;
          return SVPMAIL_xNrDaf( nanrdf
                               : peMadd
                               : *omit   );
       endif;

      /end-free

     P SVPMAIL_xProv   E

      * ------------------------------------------------------------ *
      * SVPMAIL_Inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPMAIL_Inz     B                   EXPORT
     D SVPMAIL_Inz     pi

      /free

       if initialized;
          return;
       endif;

       if not %open(gnhdaf);
          open gnhdaf;
       endif;

       if not %open(gnhda7);
          open gnhda7;
       endif;

       if not %open(cntnau01);
          open cntnau01;
       endif;

       if not %open(sehni201);
          open sehni201;
       endif;

       Initialized = *ON;

      /end-free

     P SVPMAIL_Inz     E

      * ------------------------------------------------------------ *
      * SVPMAIL_End(): Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPMAIL_End     B                   EXPORT
     D SVPMAIL_End     pi

      /free

       close *all;
       Initialized = *OFF;

      /end-free

     P SVPMAIL_End     E

      * ------------------------------------------------------------ *
      * SVPMAIL_Error():Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     P SVPMAIL_Error   B                   EXPORT
     D SVPMAIL_Error   pi            80a
     D   peErrn                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 2 and %addr(peErrn) <> *NULL;
          peErrn = errn;
       endif;

       return errm;

      /end-free

     P SVPMAIL_Error   E

      * ------------------------------------------------------------ *
      * SetError(): Establece valores de error                       *
      *                                                              *
      *     peErrn   (input)   Número de error                       *
      *     peErrm   (input)   Mensaje                               *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       errn = peErrn;
       errm = peErrm;

      /end-free

     P SetError        E

