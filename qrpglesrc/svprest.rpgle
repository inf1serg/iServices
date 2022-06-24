     H nomain
      * ************************************************************ *
      * SVPREST:Programa de Servicio.                                *
      *         Validaciones para APIs REST de QUOM                  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                    *26-May-2017             *
      * ------------------------------------------------------------ *
      * Modificacion:                                                *
      * EXT 19/07/2018 : Se agrega procedimiento SVPREST_editFecha() *
      *                  - SVPREST_editFecha()                       *
      *                  - SVPREST__editImporte()                    *
      * SGF 05/09/2018 : Agrego _chkCliente() y _chkPolizaCliente(). *
      * GIO 18/01/2019 : RM#03885 Autogestion Procesos Backend       *
      *                  Cambio Tipo Documento (tdoc) a 98           *
      * ************************************************************ *
     Fsehni201  if   e           k disk    usropn
     Fsehase    if   e           k disk    usropn
     Fgnhdaf05  if   e           k disk    usropn
     Fgnhdaf06  if   e           k disk    usropn
     Fpahaag    if   e           k disk    usropn
     Fgnttdo    if   e           k disk    usropn

      /copy './qcpybooks/svprest_h.rpgle'

     D SVPREST_errn    s             10i 0
     D SVPREST_errm    s             80a
     D initialized     s              1n

     D SetError        pr
     D   errn                        10i 0 const
     D   errm                        80a   const

      * ------------------------------------------------------------ *
      * SVPREST_chkBase(): Valida parámetro base                     *
      *                                                              *
      *    peEmpr (input) Empresa tal como se recupera de la URL     *
      *    peSucu (input) Sucursal tal como se recupera de la URL    *
      *    peNivt (input) Tipo de intermediario de la URL            *
      *    peNivc (input) Cód. de intermediario de la URL            *
      *    peNit1 (input) Tipo de intermediario de la URL            *
      *    peNiv1 (input) Cód. de intermediario de la URL            *
      *    peMsgs (output) Mensaje de error                          *
      *                                                              *
      * Retorna: *on si OK, *off si no                               *
      * ------------------------------------------------------------ *
     P SVPREST_chkBase...
     P                 b                   export
     D SVPREST_chkBase...
     D                 pi             1n
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1a   const
     D  peNivc                        5a   const
     D  peNit1                        1a   const
     D  peNiv1                        5a   const
     D  peMsgs                             likeds(paramMsgs)

     D k1hni2          ds                  likerec(s1hni201:*key)
     D rc2             s             10i 0
     D @@repl          s          65535a

      /free

       SVPREST_inz();

       clear peMsgs;

       k1hni2.n2empr = peEmpr;
       k1hni2.n2sucu = peSucu;

       monitor;
          k1hni2.n2nivt = %dec(peNivt:1:0);
        on-error;
          k1hni2.n2nivt = 0;
       endmon;

       monitor;
          k1hni2.n2nivc = %dec(peNivc:5:0);
        on-error;
          k1hni2.n2nivc = 0;
       endmon;

       setll %kds(k1hni2) sehni201;
       if not %equal;
          %subst(@@repl:1:1) = peNivt;
          %subst(@@repl:2:5) = peNivc;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'PRD0001'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          return *off;
       endif;

       monitor;
          k1hni2.n2nivt = %dec(peNit1:1:0);
        on-error;
          k1hni2.n2nivt = 0;
       endmon;

       monitor;
          k1hni2.n2nivc = %dec(peNiv1:5:0);
        on-error;
          k1hni2.n2nivc = 0;
       endmon;

       setll %kds(k1hni2) sehni201;
       if not %equal;
          %subst(@@repl:1:1) = peNit1;
          %subst(@@repl:2:5) = peNiv1;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'PRD0001'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          return *off;
       endif;

       return *on;

      /end-free

     P SVPREST_chkBase...
     P                 e

      * ------------------------------------------------------------ *
      * SVPREST_inz(): Inicializar módulo                            *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPREST_inz     B                   Export
     D SVPREST_inz     pi

      /free

        if initialized;
           return;
        endif;

        if not %open(sehni201);
           open sehni201;
        endif;

        if not %open(sehase);
           open sehase;
        endif;

        if not %open(gnhdaf05);
           open gnhdaf05;
        endif;

        if not %open(gnhdaf06);
           open gnhdaf06;
        endif;

        if not %open(gnttdo);
           open gnttdo;
        endif;

        if not %open(pahaag);
           open pahaag;
        endif;

        initialized = *on;
        return;

      /end-free
     P SVPREST_inz     E

      * ------------------------------------------------------------ *
      * SVPREST_end(): Finalizar  módulo                             *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPREST_end     b                   Export
     D SVPREST_end     pi

      /free

        close *all;
        initialized = *off;
        return;

      /end-free
     P SVPREST_end     E

      * ------------------------------------------------------------ *
      * SVPREST_error(): Retorna último error del módulo.            *
      *                                                              *
      *       peErrn (input) - Número de Error                       *
      *                                                              *
      * Retorna: Mensaje con el último error                         *
      * ------------------------------------------------------------ *
     P SVPREST_error   b                   export
     D SVPREST_error   pi            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      /free

       SVPReST_inz();

       if %parms >= 1 and %addr(peErrn) <> *null;
          peErrn = SVPREST_errn;
       endif;

       return SVPREST_errm;

      /end-free

     P SVPREST_error   e

     P SetError        B
     D SetError        pi
     D   peErrn                      10i 0 const
     D   peErrm                      80a   const

      /free

       SVPREST_errn = peErrn;
       SVPREST_errm = peErrm;
       return;

      /end-free

     P SetError        E

      * ------------------------------------------------------------ *
      * SVPREST_editFecha(): Retorna fecha ISO                       *
      *                                                              *
      *    peFech (input) Fecha AAAAMMDD                             *
      *                                                              *
      * Retorna: AAAA-MM-DD si Ok, 0001-01-01 si fecha invalida      *
      * ------------------------------------------------------------ *
     P SVPREST_editFecha...
     P                 b                   export
     D SVPREST_editFecha...
     D                 pi            10
     D  peFech                        8  0 Const

      /free

       SVPREST_inz();

       test(DE) *iso peFech;
       if %error();
         return '0001-01-01';
       endif;

       return %char( %date( peFech : *Iso ) );


      /end-free

     P SVPREST_editFecha...
     P                 e

      * ------------------------------------------------------------ *
      * SVPREST_editImporte(): Retorna importe en string de 30       *
      *                                                              *
      *    peFech (input) Fecha AAAAMMDD                             *
      *                                                              *
      * Retorna: (S)EEEEEEEEEEEEEEEEEEEEEEEEEEE.DD (edicion Z)       *
      * ------------------------------------------------------------ *
     P SVPREST_editImporte...
     P                 b                   export
     D SVPREST_editImporte...
     D                 pi            30
     D  peImpo                       15  2 Const

     D retImpo         s             30

      /free

       SVPREST_inz();

       retImpo = %editW( peImpo
                       : '                          0.  ' );

       if ( peImpo < *Zeros );
         return '-' + %trim ( retImpo );
       endif;

       return %trim ( retImpo );

      /end-free

     P SVPREST_editImporte...
     P                 e

      * ------------------------------------------------------------ *
      * SVPREST_chkCliente(): Valida que un documento sea cliente    *
      *                                                              *
      *    peEmpr (input) Empresa tal como se recupera de la URL     *
      *    peSucu (input) Sucursal tal como se recupera de la URL    *
      *    peTdoc (input) Tipo de documento de la URL                *
      *    peNdoc (input) Número de documento de la URL              *
      *    peMsgs (output) Mensaje de error                          *
      *    peNrdf (output) -opc- Código de Daf encontrado.           *
      *                                                              *
      * Retorna: *on si OK, *off si no                               *
      * ------------------------------------------------------------ *
     P SVPREST_chkCliente...
     P                 b                   export
     D SVPREST_chkCliente...
     D                 pi             1n
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peTdoc                        2a   const
     D  peNdoc                       11a   const
     D  peMsgs                             likeds(paramMsgs)
     D  peNrdf                        7  0 options(*nopass:*omit)

     D k1hdaf          ds                  likerec(g1hdaf05:*key)
     D p@Tdoc          s              2  0
     D p@Ndoc          s             11  0
     D peCuit          s             11a
     D @@repl          s          65535a

     D @@TdocCUIT      s              2  0 inz(98)

      /free

       SVPREST_inz();

       monitor;
          p@Tdoc  = %dec( peTdoc : 2 : 0);
        on-error;
          p@Tdoc  = 0;
       endmon;

       monitor;
          p@Ndoc  = %dec( peNdoc : 11: 0);
        on-error;
          p@Ndoc  = 0;
       endmon;

       setll p@Tdoc gnttdo;
       if not %equal and p@Tdoc <> @@TdocCUIT;
          %subst(@@repl:1:2) = peTdoc;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AAG0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          return *off;
       endif;

       if p@Tdoc = @@TdocCUIT;
          peCuit = %editc(p@Ndoc:'X');
          setll peCuit gnhdaf06;
          reade peCuit gnhdaf06;
          dow not %eof;
              setll dfnrdf sehase;
              if %equal;
                 if %parms >= 6 and %addr(peNrdf) <> *null;
                    peNrdf = dfnrdf;
                 endif;
                 return *on;
              endif;
           reade peCuit gnhdaf06;
          enddo;
        else;
          k1hdaf.dftido = p@Tdoc;
          k1hdaf.dfnrdo = p@Ndoc;
          setll %kds(k1hdaf:2) gnhdaf05;
          reade %kds(k1hdaf:2) gnhdaf05;
          dow not %eof;
              setll dfnrdf sehase;
              if %equal;
                 if %parms >= 6 and %addr(peNrdf) <> *null;
                    peNrdf = dfnrdf;
                 endif;
                 return *on;
              endif;
           reade %kds(k1hdaf:2) gnhdaf05;
          enddo;
       endif;

       %subst(@@repl:1:02) = peTdoc;
       %subst(@@repl:3:11) = peNdoc;
       SVPWS_getMsgs( '*LIBL'
                    : 'WSVMSG'
                    : 'AAG0008'
                    : peMsgs
                    : %trim(@@repl)
                    : %len(%trim(@@repl)) );

       return *off;

      /end-free

     P SVPREST_chkCliente...
     P                 e

      * ------------------------------------------------------------ *
      * SVPREST_chkPolizaCliente(): Valida relación Póliza/Documento *
      *                                                              *
      *    peEmpr (input) Empresa tal como se recupera de la URL     *
      *    peSucu (input) Sucursal tal como se recupera de la URL    *
      *    peArcd (input) Artículo                                   *
      *    peSpol (input) Superpóliza                                *
      *    peRama (input) Rama                                       *
      *    pePoli (input) Póliza                                     *
      *    peTdoc (input) Tipo de documento de la URL                *
      *    peNdoc (input) Número de documento de la URL              *
      *    peMsgs (output) Mensaje de error                          *
      *                                                              *
      * Retorna: *on si OK, *off si no                               *
      * ------------------------------------------------------------ *
     P SVPREST_chkPolizaCliente...
     P                 B                   export
     D SVPREST_chkPolizaCliente...
     D                 pi             1n
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6a   const
     D  peSpol                        9a   const
     D  peRama                        2a   const
     D  pePoli                        7a   const
     D  peTdoc                        2a   const
     D  peNdoc                       11a   const
     D  peMsgs                             likeds(paramMsgs)

     D p@Tdoc          s              2  0
     D p@Ndoc          s             11  0
     D p@Arcd          s              6  0
     D p@Spol          s              9  0
     D p@Rama          s              2  0
     D p@Poli          s              7  0
     D @@repl          s          65535a

     D k1haag          ds                  likerec(p1haag:*key)

      /free

       SVPREST_inz();

       monitor;
         p@Tdoc = %dec( peTdoc : 2 : 0);
        on-error;
         p@Tdoc = 0;
       endmon;

       monitor;
         p@Ndoc = %dec( peNdoc : 11: 0);
        on-error;
         p@Ndoc = 0;
       endmon;

       monitor;
         p@Arcd = %dec( peArcd :  6: 0);
        on-error;
         p@Arcd = 0;
       endmon;

       monitor;
         p@Spol = %dec( peSpol : 9: 0);
        on-error;
         p@Spol = 0;
       endmon;

       monitor;
         p@Rama = %dec( peRama : 2: 0);
        on-error;
         p@Rama = 0;
       endmon;

       monitor;
         p@Poli = %dec( pePoli : 7: 0);
        on-error;
         p@Poli = 0;
       endmon;

       k1haag.agempr = peEmpr;
       k1haag.agsucu = peSucu;
       k1haag.agarcd = p@Arcd;
       k1haag.agspol = p@Spol;
       k1haag.agrama = p@Rama;
       k1haag.agpoli = p@Poli;
       k1haag.agtdoc = p@Tdoc;
       k1haag.agndoc = p@Ndoc;
       setll %kds(k1haag) pahaag;
       if not %equal;
          %subst(@@repl:01:07) = pePoli;
          %subst(@@repl:08:02) = peTdoc;
          %subst(@@repl:10:11) = peNdoc;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0015'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          return *off;
       endif;

       return *on;

      /end-free

     P SVPREST_chkPolizaCliente...
     P                 E

