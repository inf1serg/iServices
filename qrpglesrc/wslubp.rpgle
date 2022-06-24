     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

     * ************************************************************** *
     * WSLUBP : WebService - Retorna Lista de Ubicaciones de Póliza.  *
     * -------------------------------------------------------------- *
     * RDV 22/06/2015 - Creacion del programa                         *
     * -------------------------------------------------------------- *
     * Modificaciones:                                                *
     * SFA 17/07/2015 - Se modifica logica sobre peMore               *
     * JSN 23/05/2018 - Se agrega campos, Código de tipo de vivienda  *
     *                  y ubicación de Riesgo, solo con la inf. del   *
     *                  campo r9Rdes.                                 *
     * LRG 08/01/2019 - Se limita a enviar r9rdes en rsubic por       *
     *                  limitaciones de longitud con la reno web      *
     * SGF 07/04/2021 - Agrego clasificación de riesgo y capitulo de  *
     *                  tarifa.                                       *
     * ************************************************************** *
     Fpaher994  if   e           k disk
     Fpaher995  if   e           k disk    rename(p1her9:p1her995)
     Fpahed004  if   e           k disk
     Fpaher0    if   e           k disk
     Fset001    if   e           k disk
     Fset101    if   e           k disk
     Fset102    if   e           k disk
     Fgntloc    if   e           k disk
     Fgntpro    if   e           k disk

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D wslubp          pr                  extpgm('WSLUBP')
     D   pebase                            likeds(parambase) const
     D   pecant                      10i 0 const
     D   peroll                       1    const
     D   peposi                            likeds(keyubp_t) const
     D   pepreg                            likeds(keyubp_t)
     D   peureg                            likeds(keyubp_t)
     D   pelubi                            likeds(pahrsvs_t) dim(99)
     D   pelubic                     10i 0
     D   pemore                        n
     D   peerro                            like(paramerro)
     D   pemsgs                            likeds(parammsgs)

     D wslubp          pi
     D   pebase                            likeds(parambase) const
     D   pecant                      10i 0 const
     D   peroll                       1a   const
     D   peposi                            likeds(keyubp_t) const
     D   pepreg                            likeds(keyubp_t)
     D   peureg                            likeds(keyubp_t)
     D   pelubi                            likeds(pahrsvs_t) dim(99)
     D   pelubic                     10i 0
     D   pemore                        n
     D   peerro                            like(paramerro)
     D   pemsgs                            likeds(parammsgs)

     D WSLUBR          pr                  ExtPgm('WSLUBR')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peLryc                            likeds(pahrsvs1_t) dim(99)
     D   peLrycC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D sp0068z         pr                  extpgm('SP0068Z')
     D   psarcd                       6  0
     D   psspol                       9  0
     D   pssspo                       3  0
     D   psrama                       2  0
     D   psarse                       2  0
     D   psoper                       7  0
     D   pssuop                       3  0
     D   cla                          3    dim(60)
     D   ane                          1    dim(60)
     D   p@fpgm                       3

     D finarc          pr              n

     D ubicacion       ds                  likerec(p1her9)
     D @@cant          s             10i 0
     D @@repl          s          65535a
     D @@leng          s             10i 0
     D x@x             s              2  0
     D cla             s              3    dim(60)
     D ane             s              1    dim(60)
     D p@fpgm          s              3
     D x               s             10i 0
     D @saco           s             15  2
     D peErr1          s                   like(paramErro)
     D peMsg1          ds                  likeds(paramMsgs)
     D peLryc          ds                  likeds(pahrsvs1_t) dim(99)
     D peLrycC         s             10i 0

     D @@more          s               n

     D k1her9          ds                  likerec(p1her9   :*key)
     D khed004         ds                  likerec(p1hed004 :*key)
     D k1her0          ds                  likerec(p1her0   :*key)
     D k1t001          ds                  likerec(s1t001   :*key)
     D k1t101          ds                  likerec(s1t101   :*key)
     D k1t102          ds                  likerec(s1t102   :*key)
     D k1tloc          ds                  likerec(g1tloc   :*key)

      /free

       *inlr = *on;

       p@fpgm  = 'FIN';

       pelubic = *zeros;
       peerro  = *zeros;

       @@more  = *on;

       clear pelubi;
       clear pemsgs;

     *- Validaciones
     *- Valido Parametro Base

1b   if not svpws_chkparmbase ( pebase : pemsgs );
         peerro = -1;
         return;
1e   endif;

     *- Valido Parametro Forma de Paginado

1b   if not svpws_chkroll ( peroll : pemsgs );
         peerro = -1;
         return;
1e   endif;

     *- Valido Cantidad de Lineas a Retornar

       @@cant = pecant;
1b   if ( ( pecant <= *zeros ) or ( pecant > 99 ) );
         @@cant = 99;
1e   endif;

     *- Valido Existencia de poliza enviada por parametro.
       exsr verpol;

     *- Valido Existencia de Rama de Riesgos Vario.

       exsr verram;

     *- Valido Existencia de una Ubicacion en la tabla PAHER995.

       exsr verubi;

     *- Posicionamiento en archivo
       exsr posarc;

     * Retrocedo si es paginado 'R'

       exsr retpag;

       exsr leearc;

1b   dow ( ( not finarc ) and ( pelubic < @@cant ) );

        // ------------------------------
        // muevo datos a las ds's peLubi
        // ------------------------------

         pelubic += 1;

3b    if pelubic = 1;
          exsr prireg;
3e    endif;

        pelubi(pelubic).rsempr =  ubicacion.r9empr;
        pelubi(pelubic).rssucu =  ubicacion.r9sucu;
        pelubi(pelubic).rsrama =  ubicacion.r9rama;
        pelubi(pelubic).rspoli =  ubicacion.r9poli;
        pelubi(pelubic).rspoco =  ubicacion.r9poco;
        pelubi(pelubic).rscert =  ubicacion.r9cert;
        pelubi(pelubic).rsarcd =  ubicacion.r9arcd;
        pelubi(pelubic).rsspol =  ubicacion.r9spol;
        pelubi(pelubic).rsarse =  ubicacion.r9arse;
        pelubi(pelubic).rsoper =  ubicacion.r9oper;
        pelubi(pelubic).rsubic =  (%trim(ubicacion.r9rdes));
        pelubi(pelubic).rsnrdm =  ubicacion.r9nrdm;
        pelubi(pelubic).rsrpro =  ubicacion.r9rpro;
        pelubi(pelubic).rsrdep =  ubicacion.r9rdep;
        pelubi(pelubic).rsrloc =  ubicacion.r9rloc;
        pelubi(pelubic).rsblck =  ubicacion.r9blck;
        peLubi(peLubic).rsRdes =  %trim(ubicacion.r9Rdes);

     *  muevo campos a la clave del Paher0
     *  accedo al Paher0

        k1her0.r0empr = ubicacion.r9empr;
        k1her0.r0sucu = ubicacion.r9sucu;
        k1her0.r0arcd = ubicacion.r9arcd;
        k1her0.r0spol = ubicacion.r9spol;
        k1her0.r0sspo = ubicacion.r9sspo;
        k1her0.r0rama = ubicacion.r9rama;
        k1her0.r0arse = ubicacion.r9arse;
        k1her0.r0oper = ubicacion.r9oper;
        k1her0.r0poco = ubicacion.r9poco;

        chain %kds( k1her0 : 9 ) paher0;
3b    if %found;

        pelubi(pelubic).rsxpro    = r0xpro;

     *  muevo campos a la clave del Set102
     *  accedo al Set102.

        k1t102.t@xpro = r0xpro;
        k1t102.t@rama = r0rama;

        chain %kds(k1t102) set102;
4b    if %found;
        pelubi(pelubic).rsprds    = t@prds;
4x     else;
        pelubi(pelubic).rsprds    = '*';
4e    endif;

        pelubi(pelubic).rssuas    = r0suas;
        pelubi(pelubic).rssamo    = r0samo;
        pelubi(pelubic).rsctar    = r0ctar;
        pelubi(pelubic).rscta1    = r0cta1;
        pelubi(pelubic).rscta2    = r0cta2;
3e    endif;

        pelubi(pelubic).rsacrc    = ubicacion.r9acrc;
        pelubi(pelubic).rssuin    = ubicacion.r9suin;
        pelubi(pelubic).rsainn    = ubicacion.r9ainn;
        pelubi(pelubic).rsminn    = ubicacion.r9minn;
        pelubi(pelubic).rsdinn    = ubicacion.r9dinn;
        pelubi(pelubic).rssuen    = ubicacion.r9suen;
        pelubi(pelubic).rsaegn    = ubicacion.r9aegn;
        pelubi(pelubic).rsmegn    = ubicacion.r9megn;
        pelubi(pelubic).rsdegn    = ubicacion.r9degn;

     *  muevo campos a la clave del Set101.

        k1t101.t@rama = r0rama;
        k1t101.t@ctar = r0ctar;
        k1t101.t@cta1 = r0cta1;
        k1t101.t@cta2 = r0cta2;

        chain %kds(k1t101) set101;
3b    if %found;
        pelubi(pelubic).rsctds = t@ctds;
3x     else;
        pelubi(pelubic).rsctds = *all'*';
3e    endif;

     *  Nuevos Campos..

        peLubi(peLubic).rsTviv = r0Cviv;

        pelubi(pelubic).rscopo = r0copo;
        pelubi(pelubic).rscops = r0cops;

        k1tloc.locopo = r0copo;
        k1tloc.locops = r0cops;
        chain %kds ( k1tloc ) gntloc;

3b    if %found ( gntloc );
          pelubi(pelubic).rszrrv = lozrrv;
          pelubi(pelubic).rsloca = loloca;
3x    else;
          pelubi(pelubic).rszrrv = *zeros;
          pelubi(pelubic).rsloca = *blanks;
3e    endif;

        chain loproc gntpro;

3b    if %found ( gntpro );
          pelubi(pelubic).rsprod = prprod;
3x    else;
          pelubi(pelubic).rsprod = *blanks;
3e    endif;

     *  buscar las cláusulas...

           sp0068z( r0arcd
                  : r0spol
                  : r0sspo
                  : r0rama
                  : r0arse
                  : r0oper
                  : r0suop
                  : cla
                  : ane
                  : p@fpgm );

3b    for  x@x = 1 to 60;
4b    if   cla(x@x) = 'N';
        pelubi(pelubic).rsclaj =  'S';
4x    else;
        pelubi(pelubic).rsclaj =  'N';
4e    endif;
3e    endfor ;

        peLubi(peLubic).rsClfr = r0clfr;
        peLubi(peLubic).rsCagr = r0cagr;

        // ----------------------------------------------
        // Suma Asegurada sale de los Riesgos/Coberturas
        // ----------------------------------------------
        WSLUBR( peBase
              : r0rama
              : r0poli
              : r0spol
              : r0poco
              : peLryc
              : peLrycC
              : peErr1
              : peMsg1   );
        @saco = 0;
        for x = 1 to peLrycC;
            @saco += peLryc(x).rssaco;
        endfor;
        pelubi(pelubic).rssuas    = @saco;

         exsr ultreg;

         exsr leearc;

1e   enddo;

1b   select;
1x     when ( peroll = 'R' );
           pemore = @@more;
1x     when %eof ( paher994 );
           pemore = *off;
1x     other;
           pemore = *on;
1e   endsl;

       return;

      /end-free

     *- Rutina de Posicionamiento de Archivo PAHER995.
       begsr posarc;

         k1her9.r9empr = pebase.peempr;
         k1her9.r9sucu = pebase.pesucu;
         k1her9.r9rama = peposi.r9rama;
         k1her9.r9poli = peposi.r9poli;
         k1her9.r9arcd = peposi.r9arcd;
         k1her9.r9spol = peposi.r9spol;
         k1her9.r9arse = 1;
         k1her9.r9oper = peposi.r9oper;
         k1her9.r9poco = peposi.r9poco;
             select;
             when  peroll = 'F';
               setgt %kds ( k1her9 : 9 ) paher994;
             when  peroll = 'I';
               setll %kds ( k1her9 : 8 ) paher994;
             when  peroll = 'R';
               setll %kds ( k1her9 : 9 ) paher994;
             endsl;

       endsr;

     *- Rutina de Lectura para Adelante
       begsr leearc;

             reade %kds ( k1her9 : 4 ) paher994 ubicacion;

       endsr;

     *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retarc;

             readpe %kds ( k1her9 : 4 ) paher994 ubicacion;

       endsr;

     *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priarc;

             setll %kds( k1her9 : 4 ) paher994;

       endsr;

     *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retpag;

         if ( peroll = 'R' );
           exsr retarc;
           dow ( ( not finarc ) and ( @@cant > 0 ) );
             @@cant -= 1;
             exsr retarc;
           enddo;
           if finarc;
             @@more = *off;
             exsr priarc;
           endif;
           @@cant = pecant;
           if (@@cant <= 0 or @@cant > 99);
              @@cant = 99;
           endif;
         endif;

       endsr;

     *- Rutina que graba el Primer Registro
       begsr prireg;

         pepreg.r9poli = ubicacion.r9poli;
         pepreg.r9rama = ubicacion.r9rama;
         pepreg.r9spol = ubicacion.r9spol;
         pepreg.r9poco = ubicacion.r9poco;
         pepreg.r9arcd = ubicacion.r9arcd;
         pepreg.r9oper = ubicacion.r9oper;

       endsr;

     *- Rutina que graba el Ultimo Registro
       begsr ultreg;

         peureg.r9poli = ubicacion.r9poli;
         peureg.r9rama = ubicacion.r9rama;
         peureg.r9spol = ubicacion.r9spol;
         peureg.r9poco = ubicacion.r9poco;
         peureg.r9arcd = ubicacion.r9arcd;
         peureg.r9oper = ubicacion.r9oper;

       endsr;

     *- Rutina de chequeo de poliza en archivo PAHED004

       begsr verpol;

         khed004.d0empr = pebase.peempr;
         khed004.d0sucu = pebase.pesucu;
         khed004.d0rama = peposi.r9rama;
         khed004.d0poli = peposi.r9poli;

         chain %kds( khed004 : 4 ) pahed004;
         if not %found ( pahed004 );
         @@repl =   %editw ( peposi.r9rama  : '0 ' )
                +   %editw ( peposi.r9poli  : '0      ' );

         @@leng = %len ( %trimr ( @@repl ) );

         svpws_getmsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
                         pemsgs : @@repl  : @@leng );
         peerro = -1;
         return;
         endif;

       endsr;

     *- Rutina que determina si la Poliza pertenece a una Rama de Riesgos

       begsr verram;

         k1t001.t@rama = peposi.r9rama;
         chain %kds(k1t001) set001;
         if not %found or
            t@rame =  4  or t@rame =  18  or t@rame =  21;
         @@repl =   %editw ( peposi.r9rama  : '0 ' )
                +   %editw ( peposi.r9poli  : '0      ' );

         @@leng = %len ( %trimr ( @@repl ) );

         svpws_getmsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                         pemsgs : @@repl  : @@leng );
         peerro = -1;
         return;
         endif;

       endsr;

     *- Rutina que verifica que la Poliza tenga una ubicacion en la tabla
     *- Paher995, si no la tiene es error.

       begsr verubi;

         k1her9.r9empr  = pebase.peempr;
         k1her9.r9sucu  = pebase.pesucu;
         k1her9.r9rama  = peposi.r9rama;
         k1her9.r9poli  = peposi.r9poli;

         chain %kds( k1her9 : 4 ) paher995;
         if not %found or r9rdes = ' ';
          @@repl =   %editw ( peposi.r9rama  : '0 ' )
            +   %editw ( peposi.r9poli  : '0      ' );

          @@leng = %len ( %trimr ( @@repl ) );

          svpws_getmsgs ( '*LIBL' : 'WSVMSG': 'POL0002' :
                         pemsgs : @@repl  : @@leng );
          peerro = -1;
          return;
         endif;

       endsr;

     *- Rutina que determina si es Fin de Archivo
     P finarc          b
     D finarc          pi              n

             return %eof ( paher994 );

     P finarc          e
