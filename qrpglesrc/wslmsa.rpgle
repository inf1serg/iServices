     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLMSA : WebService - Retorna mensajes por Asegurado.        *
      * ------------------------------------------------------------ *
      * Julio Barranco                                 01/03/2016    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fgntms101  if   e           k disk
     Fgntms102  if   e           k disk    rename(g1tms1:g1tms102)
     Fgntms103  if   e           k disk    rename(g1tms1:g1tms103)
     Fsehase    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'

     D WSLMSA          pr                  ExtPgm('WSLMSA')
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peType                       2    const
     D   pePosi                            likeds(keymsg_t) const
     D   pePreg                            likeds(keymsg_t)
     D   peUreg                            likeds(keymsg_t)
     D   peLmsg                            likeds(gntmsg_t) dim(99)
     D   peLmsgC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLMSA          pi
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peType                       2    const
     D   pePosi                            likeds(keymsg_t) const
     D   pePreg                            likeds(keymsg_t)
     D   peUreg                            likeds(keymsg_t)
     D   peLmsg                            likeds(gntmsg_t) dim(99)
     D   peLmsgC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D ktms1           ds                  likerec(g1tms1:*key)

     D finArc          pr              n

     D @@cant          s             10i 0
     D @@type          s              2
     D @@fmsg          s               d
     D wrepl           s          65535a

       *inLr = *On;

       clear peLmsg;
       clear peLmsgC;
       clear peErro;
       clear peMsgs;

       @@more = *On;

      *- Validaciones
       if not SVPVAL_empresa ( peEmpr );

         %subst(wrepl:1:1) = peEmpr;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0113'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;

       endif;

       if not SVPVAL_sucursal ( peEmpr : peSucu );

         %subst(wrepl:1:1) = peEmpr;
         %subst(wrepl:2:2) = peSucu;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0114'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;

       endif;

      *- Valido Existencia de Asegurado
       setll peAsen sehase;
       if not %equal ( sehase );

         %subst(wrepl:1:7) = %editC(peAsen:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;
       endif;

      *- Valido Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      *- Valido Tipo de Mensaje
       @@type = peType;
       if peType <> 'T '
        and peType <> 'NL'
        and peType <> 'L ';
          @@type = 'T ';
       endif;

      *- Valido Fecha de Mensaje
       @@fmsg = pePosi.fmsg;
       test(e) pePosi.fmsg;
       if %error
        or pePosi.fmsg > %date();
          @@fmsg = %date();
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       exsr priReg;

       dow ( ( not finArc ) and ( peLmsgC < @@cant ) );

         peLmsgC += 1;

         peLmsg(peLmsgC).msid = s1msid;
         peLmsg(peLmsgC).body = s1body;
         peLmsg(peLmsgC).impo = s1impo;
         peLmsg(peLmsgC).read = s1read;

         exsr UltReg;

         exsr leeArc;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( gntms101 )
         or %eof( gntms102 )
         or %eof( gntms103 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

       ktms1.s1empr = peEmpr;
       ktms1.s1sucu = peSucu;
       ktms1.s1Asen = peAsen;
       ktms1.s1fmsg = peposi.fmsg;
       ktms1.s1msid = pePosi.msid;

       if ( peRoll = 'F' );
          select;
             when @@type = 'T ';
                setgt %kds ( ktms1 : 4 ) gntms101;
             when @@type = 'NL';
                setgt %kds ( ktms1 : 4 ) gntms102;
             when @@type = 'L ';
                setgt %kds ( ktms1 : 4 ) gntms103;
          endsl;
       else;
          select;
             when @@type = 'T ';
                setll %kds ( ktms1 : 4 ) gntms101;
             when @@type = 'NL';
                setll %kds ( ktms1 : 4 ) gntms102;
             when @@type = 'L ';
                setll %kds ( ktms1 : 4 ) gntms103;
          endsl;
       endif;

       endsr;

      *- Rutina de Lectura para Adelante
       begsr leeArc;

       select;
          when @@type = 'T ';
             reade %kds ( ktms1 : 4 ) gntms101;
          when @@type = 'NL';
             reade %kds ( ktms1 : 4 ) gntms102;
          when @@type = 'L ';
             reade %kds ( ktms1 : 4 ) gntms103;
       endsl;

       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       select;
          when @@type = 'T ';
             readpe %kds ( ktms1 : 4 ) gntms101;
          when @@type = 'NL';
             readpe %kds ( ktms1 : 4 ) gntms102;
          when @@type = 'L ';
             readpe %kds ( ktms1 : 4 ) gntms103;
       endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       select;
          when @@type = 'T ';
             setll %kds ( ktms1 : 4 ) gntms101;
          when @@type = 'NL';
             setll %kds ( ktms1 : 4 ) gntms102;
          when @@type = 'L ';
             setll %kds ( ktms1 : 4 ) gntms103;
       endsl;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

       if ( peRoll = 'R' );
         exsr retArc;
         dow ( ( not finArc ) and ( @@cant > 0 ) );
           @@cant -= 1;
           exsr retArc;
         enddo;
         if finArc;
           @@more = *Off;
           exsr priArc;
         endif;
         @@cant = peCant;
         if (@@cant <= 0 or @@cant > 99);
            @@cant = 99;
         endif;
       endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;

       pePreg.fmsg = s1fmsg;
       pePreg.msid = s1msid;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       peUreg.fmsg = s1fmsg;
       peUreg.msid = s1msid;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       select;
          when @@type = 'T ';
             return %eof ( gntms101 );
          when @@type = 'NL';
             return %eof ( gntms102 );
          when @@type = 'L ';
             return %eof ( gntms103 );
       endsl;

     P finArc          E
