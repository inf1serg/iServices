     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLUBF : WebService - Retorna franquicia de riesgo/cobertura *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            03/06/2015    *
      * ------------------------------------------------------------ *
      * SGF 16/08/2016: Si el tope màximo es *hival, no lo muestro.  *
      * JSN 14/08/2019: Se modifica mascara de monto, para el campo  *
      *                 de descripción de las leyenda de franquicia. *
      *                                                              *
      * ************************************************************ *
     Fpaher8    if   e           k disk
     Fpaher0    if   e           k disk
     Fpahed003  if   e           k disk
     Fpahed004  if   e           k disk
     Fpaher995  if   e           k disk
     Fset001    if   e           k disk
     Fset115    if   e           k disk    prefix(X_)

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLUBF          pr                  ExtPgm('WSLUBF')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFran                            likeds(rvfranq_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLUBF          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peFran                            likeds(rvfranq_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D kher0           ds                  likerec(p1her0:*key)
     D kher8           ds                  likerec(p1her8:*key)

     D khed003         ds                  likerec(p1hed003:*key)

     D khed004         ds                  likerec(p1hed004:*key)

     D kher995         ds                  likerec(p1her9:*key)

     D @@Poco          s              6  0
     D @@Repl          s          65535a
     D @@Leng          s             10i 0

       *inLr = *On;

       clear peFran;
       clear peErro;
       clear peMsgs;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Exista Poliza
       khed004.d0empr = peBase.peEmpr;
       khed004.d0sucu = peBase.peSucu;
       khed004.d0rama = peRama;
       khed004.d0poli = pePoli;

       setll %kds(khed004:4) pahed004;

       if not %equal( pahed004 );

         @@Repl =   %editw ( peRama : '0 ')
                +   %editw ( pePoli : '0      ' );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                             peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;

       endif;

      *- Valido Exista Componente
       kher995.r9empr = peBase.peEmpr;
       kher995.r9sucu = peBase.peSucu;
       kher995.r9rama = peRama;
       kher995.r9poli = pePoli;
       kher995.r9spol = peSpol;
       kher995.r9poco = pePoco;

       chain %kds(kher995:6) paher995;

       if not %found( paher995 );

         @@Poco = pePoco;
         @@Repl =   %editw ( @@Poco : '0     ')
                +   %editw ( peRama : '0 ')
                +   %editw ( pePoli : '0      ' );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'BIE0001' :
                             peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;

       endif;

      *- Toma Producto
       kher0.r0empr = peBase.peEmpr;
       kher0.r0sucu = peBase.peSucu;
       kher0.r0arcd = r9arcd;
       kher0.r0spol = r9spol;
       kher0.r0sspo = r9sspo;
       kher0.r0rama = r9rama;
       kher0.r0arse = r9arse;

       chain %kds(kher0:7) paher0;

      *- Valido Poliza de Riesgos Varios
       clear t@rame;
       chain (peRama) set001;

       if t@rame = 4 or t@rame = 18 or t@rame = 21;

         @@Repl =   %editw ( peRama : '0 ')
                +   %editw ( pePoli : '0      ' );
         @@Leng = %len ( %trimr ( @@repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                             peMsgs : @@Repl  : @@Leng );
         peErro = -1;
         return;

       endif;

       khed003.d0empr = peBase.peEmpr;
       khed003.d0sucu = peBase.peSucu;
       khed003.d0arcd = r9arcd;
       khed003.d0spol = peSpol;
       khed003.d0rama = peRama;
       khed003.d0arse = r9arse;

       setgt %kds (khed003:6) pahed003;

       readpe %kds (khed003:6) pahed003;
       dow not %eof(pahed003);

          if d0tiou = 1
          or d0tiou = 2
          or d0tiou = 5
          or d0tiou = 3
          and d0stos <> 09
          and d0stos <> 08;
             kher8.r8empr = peBase.peEmpr;
             kher8.r8sucu = peBase.peSucu;
             kher8.r8arcd = r9arcd;
             kher8.r8spol = peSpol;
             kher8.r8sspo = d0sspo;
             kher8.r8rama = peRama;
             kher8.r8arse = r9arse;
             kher8.r8oper = r9oper;
             kher8.r8poco = pePoco;
             kher8.r8suop = d0suop;
             kher8.r8xpro = r0xpro;
             kher8.r8riec = peRiec;
             kher8.r8cobc = peXcob;

             chain %kds( kher8:13 ) paher8;
             if %found(paher8);
                exsr proces;
                leave;
             endif;
          endif;

          readpe %kds (khed003:6) pahed003;
       enddo;

       if not %found(paher8);
          peFran.r8leye = 'SIN FRANQUICIA';
       endif;

       return;

       begsr proces;

          peFran.r8cfra = r8cfra;

          clear X_t@dfra;
          chain (r8cfra) set115;
          peFran.r8dfra = X_t@dfra;
          peFran.r8cfrs = x_t@cfrs;

          peFran.r8ifra = r8iffi;
          peFran.r8xfra = r8pfva;
          peFran.r8xfr1 = r8pftf;
          peFran.r8ifrm = r8iitf;
          peFran.r8ifrx = r8iatf;
          peFran.r8xfr2 = r8pftv;
          peFran.r8xmin = r8pitv;
          peFran.r8xmax = r8patv;
          clear peFran.r8leye;

          select;

            when peFran.r8cfrs = 0;
               peFran.r8leye = 'SIN FRANQUICIA';
            when peFran.r8cfrs = 1;
               peFran.r8leye = 'Franquicia: $'
               + %trim(%editw(r8iffi:'           0 ,  '))
               + ' por evento.';
            when peFran.r8cfrs = 2;
               peFran.r8leye = 'Deducible: '
               + %trim(%editw(r8pfva:' 0 ,  '))
               + '% de la Suma Asegurada por evento.';
            when peFran.r8cfrs = 3;
             if r8iatf = 9999999999999,00;
               peFran.r8leye = 'Franquicia/Deducible: '
               + %trim(%editw(r8pftf:' 0 ,  '))
               + '% del siniestro, minimo $'
               + %trim(%editw(r8iitf:'           0 ,  '))
               + ', por evento.';
              else;
               peFran.r8leye = 'Franquicia/Deducible: '
               + %trim(%editw(r8pftf:' 0 ,  '))
               + '% del siniestro, minimo $'
               + %trim(%editw(r8iitf:'           0 ,  '))
               + ', maximo $'
               + %trim(%editw(r8iatf:'           0 ,  '))
               + ' por evento.';
             endif;
            when peFran.r8cfrs = 4;
               peFran.r8leye = 'Franquicia/Deducible: '
               + %trim(%editw(r8pftv:' 0 ,  '))
               + '% del Siniestro, min.'
               + %trim(%editw(r8pitv:' 0 ,  '))
               + '%,max.'
               + %trim(%editw(r8patv:' 0 ,  '))
               + '% de la Suma Asegurada al momento del Siniestro.';

          endsl;

       endsr;
