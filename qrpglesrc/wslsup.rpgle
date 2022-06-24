     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLSUP  : Tareas generales.                                  *
      *           WebService - Retorna Lista de endosos de una Póliza*
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda                             *16-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 21/04/2015 - Cambio Dim de peLsup a 100                  *
      *                - Agrego validacion de parametros base        *
      * SGF 04/05/2015 - Refresco descripciones de rama, productor   *
      *                  asegurado, moneda y tipo de operación desde *
      *                  las tablas de GAUS.                         *
      * JJG 26/05/2015 - Tratamiento de Paginado                     *
      * SFA 17/07/2015 - Se modifica logica sobre peMore             *
      * IVG 05/08/2015 - De acuerdo a lo que indique el nuevo        *
      *                  parametro peAsdc se debera leer de forma    *
      *                  ascendente o descendente                    *
      * SGF 06/09/2016 - Nro de plan de pagos y forma de pago.       *
      * NWN 10/01/2017 - Carga solamente el/los suplementos corres-  *
      *                  pondientes a la ultima Cadena.              *
      * JSN 20/03/2017 - se agrega condicion de que cargue los datos *
      *                  siempre y cuando el campo d0tiou <> 3 y     *
      *                  d0stou <> 90                                *
      * SGF 11/05/2017 - Vuelvo a incluir a los 3/90.                *
      *                                                              *
      * ************************************************************ *

     Fpahed091  if   e           k disk
     Fpahed004  if   e           k disk
     Fpahec1    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D NIVC            s              5  0 dim(9)

     D WSLSUP          pr                  ExtPgm('WSLSUP')
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peAsdc                       1
     D   pePosi                            likeds(keysup_t) const
     D   pePreg                            likeds(keysup_t)
     D   peUreg                            likeds(keysup_t)
     D   peLsup                            likeds(pahsup_t) dim(99)
     D   peLsupC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D wslsup          pi
     D   peBase                            likeds(paramBase) const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   peAsdc                       1
     D   pePosi                            likeds(keysup_t) const
     D   pePreg                            likeds(keysup_t)
     D   peUreg                            likeds(keysup_t)
     D   peLsup                            likeds(pahsup_t) dim(99)
     D   peLsupC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSXSUP          pr                  ExtPgm('WSXSUP')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSuop                       3  0 const
     D   peArcd                       6  0 const
     D   peCert                       9  0 const
     D   peSspo                       3  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSupl                            likeds( pahsup_t )

     D finArc          pr              n

     D k1hed091        ds                  likerec(p1hed0   : *key)

     D khed004         ds                  likerec(p1hed004:*key)

     D k1hec1          ds                  likerec(p1hec1:*key)

     D @@cant          s             10i 0
     D @@more          s               n
     D paso            s               n

     D endosos         ds                  likeds(paHsup_t)
     D @@repl          s          65535a
     D @@leng          s             10i 0

       *inLr = *On;
       @@more = *On;

       peLsupC = *Zeros;
       peErro  = *Zeros;

       clear peLsup;
       clear peMsgs;
       paso = *off;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;


      *- Valido Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Parametro Tipo de Lectura,
      *- si es distinto de A y D le muevo una D
       if ( peAsdc <> 'A' ) and ( peAsdc <> 'D');
         peAsdc = 'D';
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       exsr leeArc;

       if paso = *on;

           WSXSUP( peBase
                 : d0Rama
                 : d0Poli
                 : d0Spol
                 : d0Suop
                 : d0Arcd
                 : d0Cert
                 : d0Sspo
                 : d0Arse
                 : d0Oper
                 : endosos );

       exsr priReg;

       endif;

       dow ( ( not finArc ) and ( pelsupC < @@cant ) );

       if paso = *on;

         // ------------------------------
         // Muevo Datos directamente de WSXSUP
         // ------------------------------
         pelsupC += 1;

           WSXSUP( peBase
                 : d0Rama
                 : d0Poli
                 : d0Spol
                 : d0Suop
                 : d0Arcd
                 : d0Cert
                 : d0Sspo
                 : d0Arse
                 : d0Oper
                 : endosos );

         pelsup( pelsupC ).psempr = endosos   .psempr;
         pelsup( pelsupC ).pssucu = endosos   .pssucu;
         pelsup( pelsupC ).psRama = endosos   .psRama;
         pelsup( pelsupC ).psPoli = endosos   .psPoli;
         pelsup( pelSupc ).psSuop = endosos   .psSuop;
         pelsup( pelsupC ).psCert = endosos   .psCert;
         pelsup( pelsupC ).psArcd = endosos   .psArcd;
         pelsup( pelsupC ).psSpol = endosos   .psSpol;
         pelsup( pelsupC ).psSspo = endosos   .psSspo;
         pelsup( pelsupC ).psArse = endosos   .psArse;
         pelsup( pelsupC ).psOper = endosos   .psOper;
         pelsup( pelsupC ).psRamd = endosos   .psRamd;
         pelsup( pelsupC ).psRamb = endosos   .psRamb;
         pelsup( pelsupC ).psSoln = endosos   .psSoln;
         pelsup( pelsupC ).psAsen = endosos   .psAsen;
         pelsup( pelsupC ).psAsno = endosos   .psAsno;
         pelsup( pelsupC ).psFemi = endosos   .psFemi;
         pelsup( pelsupC ).psFdes = endosos   .psFdes;
         pelsup( pelsupC ).psFhas = endosos   .psFhas;
         pelsup( pelsupC ).psHafa = endosos   .psHafa;
         pelsup( pelsupC ).psAnua = endosos   .psAnua;
         pelsup( pelsupC ).psMone = endosos   .psMone;
         pelsup( pelsupC ).psNmoc = endosos   .psNmoc;
         pelsup( pelsupC ).psPrim = endosos   .Psprim;
         pelsup( pelsupC ).psBpri = endosos   .psBpri;
         pelsup( pelsupC ).psRefi = endosos   .psRefi;
         pelsup( pelsupC ).psRead = endosos   .psRead;
         pelsup( pelsupC ).psDere = endosos   .psDere;
         pelsup( pelsupC ).psSeri = endosos   .psSeri;
         pelsup( pelsupC ).psSeem = endosos   .psSeem;
         pelsup( pelsupC ).psImpi = endosos   .psImpi;
         pelsup( pelsupC ).psSers = endosos   .psSers;
         pelsup( pelsupC ).psTssn = endosos   .psTssn;
         pelsup( pelsupC ).psIpr1 = endosos   .psIpr1;
         pelsup( pelsupC ).psIpr3 = endosos   .psIpr3;
         pelsup( pelsupC ).PsIpr4 = endosos   .psIpr4;
         pelsup( pelsupC ).psipr2 = endosos   .psipr2;
         pelsup( pelsupC ).psipr5 = endosos   .psipr5;
         pelsup( pelsupC ).psipr6 = endosos   .psipr6;
         pelsup( pelsupC ).psipr7 = endosos   .psipr7;
         pelsup( pelsupC ).psipr8 = endosos   .psipr8;
         pelsup( pelsupC ).psipr9 = endosos   .psipr9;
         pelsup( pelsupC ).psprem = endosos   .psprem;
         pelsup( pelsupC ).psprco = endosos   .psprco;
         pelsup( pelsupC ).pssald = endosos   .pssald;
         pelsup( pelsupC ).psnivt1= endosos   .psnivt1;
         pelsup( pelsupC ).psnivc1= endosos   .psnivc1;
         pelsup( pelsupC ).pscopr1= endosos   .pscopr1;
         pelsup( pelsupC ).psxopr1= endosos   .psxopr1;
         pelsup( pelsupC ).psxcco1= endosos   .psxcco1;
         pelsup( pelsupC ).psxfno1= endosos   .psxfno1;
         pelsup( pelsupC ).psxfnn1= endosos   .psxfnn1;
         pelsup( pelsupC ).psnivt2= endosos   .psnivt2;
         pelsup( pelsupC ).psnivc2= endosos   .psnivc2;
         pelsup( pelsupC ).pscopr2= endosos   .pscopr2;
         pelsup( pelsupC ).psxopr2= endosos   .psxopr2;
         pelsup( pelsupC ).psxcco2= endosos   .psxcco2;
         pelsup( pelsupC ).psxfno2= endosos   .psxfno2;
         pelsup( pelsupC ).psxfnn2= endosos   .psxfnn2;
         pelsup( pelsupC ).psnivt3= endosos   .psnivt3;
         pelsup( pelsupC ).psnivc3= endosos   .psnivc3;
         pelsup( pelsupC ).pscopr3= endosos   .pscopr3;
         pelsup( pelsupC ).psxopr3= endosos   .psxopr3;
         pelsup( pelsupC ).psxcco3= endosos   .psxcco3;
         pelsup( pelsupC ).psxfno3= endosos   .psxfno3;
         pelsup( pelsupC ).psxfnn3= endosos   .psxfnn3;
         pelsup( pelsupC ).psnivt4= endosos   .psnivt4;
         pelsup( pelsupC ).psnivc4= endosos   .psnivc4;
         pelsup( pelsupC ).pscopr4= endosos   .pscopr4;
         pelsup( pelsupC ).psxopr4= endosos   .psxopr4;
         pelsup( pelsupC ).psxcco4= endosos   .psxcco4;
         pelsup( pelsupC ).psxfno4= endosos   .psxfno4;
         pelsup( pelsupC ).psxfnn4= endosos   .psxfnn4;
         pelsup( pelsupC ).psnivt5= endosos   .psnivt5;
         pelsup( pelsupC ).psnivc5= endosos   .psnivc5;
         pelsup( pelsupC ).pscopr5= endosos   .pscopr5;
         pelsup( pelsupC ).psxopr5= endosos   .psxopr5;
         pelsup( pelsupC ).psxcco5= endosos   .psxcco5;
         pelsup( pelsupC ).psxfno5= endosos   .psxfno5;
         pelsup( pelsupC ).psxfnn5= endosos   .psxfnn5;
         pelsup( pelsupC ).psnivt6= endosos   .psnivt6;
         pelsup( pelsupC ).psnivc6= endosos   .psnivc6;
         pelsup( pelsupC ).pscopr6= endosos   .pscopr6;
         pelsup( pelsupC ).psxopr6= endosos   .psxopr6;
         pelsup( pelsupC ).psxcco6= endosos   .psxcco6;
         pelsup( pelsupC ).psxfno6= endosos   .psxfno6;
         pelsup( pelsupC ).psxfnn6= endosos   .psxfnn6;
         pelsup( pelsupC ).psnivt7= endosos   .psnivt7;
         pelsup( pelsupC ).psnivc7= endosos   .psnivc7;
         pelsup( pelsupC ).pscopr7= endosos   .pscopr7;
         pelsup( pelsupC ).psxopr7= endosos   .psxopr7;
         pelsup( pelsupC ).psxcco7= endosos   .psxcco7;
         pelsup( pelsupC ).psxfno7= endosos   .psxfno7;
         pelsup( pelsupC ).psxfnn7= endosos   .psxfnn7;
         pelsup( pelsupC ).psnivt8= endosos   .psnivt8;
         pelsup( pelsupC ).psnivc8= endosos   .psnivc8;
         pelsup( pelsupC ).pscopr8= endosos   .pscopr8;
         pelsup( pelsupC ).psxopr8= endosos   .psxopr8;
         pelsup( pelsupC ).psxcco8= endosos   .psxcco8;
         pelsup( pelsupC ).psxfno8= endosos   .psxfno8;
         pelsup( pelsupC ).psxfnn8= endosos   .psxfnn8;
         pelsup( pelsupC ).psnivt9= endosos   .psnivt9;
         pelsup( pelsupC ).psnivc9= endosos   .psnivc9;
         pelsup( pelsupC ).pscopr9= endosos   .pscopr9;
         pelsup( pelsupC ).psxopr9= endosos   .psxopr9;
         pelsup( pelsupC ).psxcco9= endosos   .psxcco9;
         pelsup( pelsupC ).psxfno9= endosos   .psxfno9;
         pelsup( pelsupC ).psxfnn9= endosos   .psxfnn9;
         pelsup( pelsupC ).psmarsin=endosos   .psmarsin;
         pelsup( pelsupC ).pscfpg = endosos   .pscfpg ;
         pelsup( pelsupC ).psctcu = endosos   .psctcu ;
         pelsup( pelsupC ).psnrtc = endosos   .psnrtc ;
         pelsup( pelsupC ).psivbc = endosos   .psivbc ;
         pelsup( pelsupC ).psivsu = endosos   .psivsu ;
         pelsup( pelsupC ).pstcta = endosos   .pstcta ;
         pelsup( pelsupC ).psncta = endosos   .psncta ;
         pelsup( pelsupC ).psraan = endosos   .psraan ;
         pelsup( pelsupC ).pspoan = endosos   .pspoan ;
         pelsup( pelsupC ).psarca = endosos   .psarca ;
         pelsup( pelsupC ).psspoa = endosos   .psspoa ;
         pelsup( pelsupC ).psranu = endosos   .psranu ;
         pelsup( pelsupC ).psponu = endosos   .psponu ;
         pelsup( pelsupC ).psarcn = endosos   .psarcn ;
         pelsup( pelsupC ).psspon = endosos   .psspon ;
         pelsup( pelsupC ).pspatente=endosos  .pspatente ;
         pelsup( pelsupC ).psecon = endosos   .psecon ;
         pelsup( pelsupC ).psdesanu=endosos   .psdesanu;
         pelsup( pelsupC ).psmar1 = endosos   .psmar1;
         pelsup( pelsupC ).psmar2 = endosos   .psmar2;
         pelsup( pelsupC ).psmar3 = endosos   .psmar3;
         pelsup( pelsupC ).psmar4 = endosos   .psmar4;
         pelsup( pelsupC ).psmar5 = endosos   .psmar5;
         pelsup( pelsupC ).psmar6 = endosos   .psmar6;
         pelsup( pelsupC ).psmar7 = endosos   .psmar7;
         pelsup( pelsupC ).psmar8 = endosos   .psmar8;
         pelsup( pelsupC ).psmar9 = endosos   .psmar9;
         pelsup( pelsupC ).pssalve01=endosos  .pssalve01;
         pelsup( pelsupC ).pssalve02=endosos  .pssalve02;
         pelsup( pelsupC ).pssalve03=endosos  .pssalve03;
         pelsup( pelsupC ).pssalve04=endosos  .pssalve04;
         pelsup( pelsupC ).pssalve05=endosos  .pssalve05;
         pelsup( pelsupC ).pssalve06=endosos  .pssalve06;
         pelsup( pelsupC ).pssalve07=endosos  .pssalve07;
         pelsup( pelsupC ).pssalve08=endosos  .pssalve08;
         pelsup( pelsupC ).pssalve09=endosos  .pssalve09;
         pelsup( pelsupC ).pssalav01=endosos  .pssalav01;
         pelsup( pelsupC ).pssalav02=endosos  .pssalav02;
         pelsup( pelsupC ).pssalav03=endosos  .pssalav03;
         pelsup( pelsupC ).pssalav04=endosos  .pssalav04;
         pelsup( pelsupC ).pssalav05=endosos  .pssalav05;
         pelsup( pelsupC ).pssalav06=endosos  .pssalav06;
         pelsup( pelsupC ).pssalav07=endosos  .pssalav07;
         pelsup( pelsupC ).pssalav08=endosos  .pssalav08;
         pelsup( pelsupC ).pssalav09=endosos  .pssalav09;
         pelsup( pelsupC ).pstiou   =endosos  .pstiou   ;
         pelsup( pelsupC ).psstou   =endosos  .psstou   ;
         pelsup( pelsupC ).psstos   =endosos  .psstos   ;
         pelsup( pelsupC ).psdsop   =endosos  .psdsop   ;
         pelsup( pelsupC ).psemcn   =endosos  .psemcn   ;
         pelsup( pelsupC ).psxref   =endosos  .psxref   ;
         pelsup( pelsupC ).psxrea   =endosos  .psxrea   ;
         pelsup( pelsupC ).pspimi   =endosos  .pspimi   ;
         pelsup( pelsupC ).pspsso   =endosos  .pspsso   ;
         pelsup( pelsupC ).pspssn   =endosos  .pspssn   ;
         pelsup( pelsupC ).pspivi   =endosos  .pspivi   ;
         pelsup( pelsupC ).pspivn   =endosos  .pspivn   ;
         pelsup( pelsupC ).pspivr   =endosos  .pspivr   ;
         pelsup( pelsupC ).psnlib   =endosos  .psnlib   ;
         pelsup( pelsupC ).pscome   =endosos  .pscome   ;
         pelsup( pelsupC ).psnrpp   =endosos  .psnrpp   ;
         pelsup( pelsupC ).psdefp   =endosos  .psdefp   ;

         exsr borCom;

         exsr UltReg;

       endif;

         exsr leeArc;


       enddo;

       if ( peRoll = 'R' );
         peMore = @@more;
       else;
         select;
            when %eof ( pahed091 );
               peMore = *Off;
            other;
               peMore = *On;
         endsl;
       endif;


       return;

      *- Rutina de Posicionamiento de Archivo. Segun peOrde, pePosi, peRoll
       begsr posArc;

       k1hed091.D0Empr = peBase.peEmpr;
       k1hed091.d0Sucu = peBase.peSucu;
       k1hed091.d0Rama = pePosi.psRama;
       k1hed091.d0Poli = peposi.psPoli;
       k1hed091.d0Spol = pePosi.psSpol;
       if peAsdc = 'D'
       and pePosi.psSuop = *Zeros;
          k1hed091.d0suop = *Hival;
       else;
          k1hed091.d0suop = peposi.psSuop;
       endif;
       k1hed091.d0arcd = pePosi.psarcd;
       k1hed091.d0cert = peposi.psCert;
       k1hed091.d0sspo = pePosi.psSspo;
       k1hed091.d0arse = pePosi.psArse;
       k1hed091.d0oper = peposi.psoper;

       if ( peAsdc = 'A' );
          if ( peRoll = 'F' );
             setgt %kds ( k1hed091 : 11) pahed091;
          else;
             setll %kds ( k1hed091 : 11) pahed091;
          endif;
       else;
          if ( peRoll = 'F' );
             setll %kds ( k1hed091 : 6 ) pahed091;
          else;
             setgt %kds ( k1hed091 : 6 ) pahed091;
          endif;
       endif;

       endsr;

      *- Rutinas de Lectura para Adelante o Atras
       begsr leeArc;

       if ( peAsdc = 'A' );
          reade %kds ( k1hed091 : 4 ) pahed091;
       else;
          readpe %kds ( k1hed091 : 5 ) pahed091;
       endif;

       exsr busec1;

       //khed004.d0empr = peBase.peEmpr;
       //khed004.d0sucu = peBase.peSucu;
       //khed004.d0rama = d0Rama;
       //khed004.d0poli = d0Poli;

       //setll %kds ( khed004 : 4 ) pahed004;

       //if not %equal ( pahed004 );
       //  @@Repl =   %editw ( d0Rama  : '0 ' )
       //       +   %editw ( d0Poli  : '0      ' );

       //@@Leng = %len ( %trimr ( @@repl ) );

       //SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0009' :
       //                peMsgs : @@Repl  : @@Leng );
       //peErro = -1;
       //return;
       //endif;
       endsr;

      *- Rutina de Lectura para Atras en caso de Paginado "F"
       begsr retArc;

       readpe %kds ( k1hed091 : 5 ) pahed091;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr priArc;

       setll %kds ( k1HED091 : 11 ) pahED091;

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

       if ( peAsdc = 'A' );
          pepreg.psRama = endosos   .psRama;
          pepreg.psPoli = endosos   .psPoli;
          pepreg.psspol = endosos   .psspol;
          pepreg.pssuop = endosos   .pssuop;
          pepreg.psarcd = endosos   .psarcd;
          pepreg.pscert = endosos   .pscert;
          pepreg.pssspo = endosos   .pssspo;
          pepreg.psarse = endosos   .psarse;
          pepreg.psoper = endosos   .psoper;
       else;
          peUreg.psRama = endosos   .psRama;
          peUreg.psPoli = endosos   .psPoli;
          peUreg.psspol = endosos   .psspol;
          peUreg.pssuop = endosos   .pssuop;
          peUreg.psarcd = endosos   .psarcd;
          peUreg.pscert = endosos   .pscert;
          peUreg.pssspo = endosos   .pssspo;
          peUreg.psarse = endosos   .psarse;
          peUreg.psoper = endosos   .psoper;
       endif;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

       if ( peAsdc = 'A' );
          peUreg.psRama = endosos   .psRama;
          peUreg.psPoli = endosos   .psPoli;
          peUreg.psspol = endosos   .psspol;
          peUreg.pssuop = endosos   .pssuop;
          peUreg.psarcd = endosos   .psarcd;
          peUreg.pscert = endosos   .pscert;
          peUreg.pssspo = endosos   .pssspo;
          peUreg.psarse = endosos   .psarse;
          peUreg.psoper = endosos   .psoper;
       else;
          pepreg.psRama = endosos   .psRama;
          pepreg.psPoli = endosos   .psPoli;
          pepreg.psspol = endosos   .psspol;
          pepreg.pssuop = endosos   .pssuop;
          pepreg.psarcd = endosos   .psarcd;
          pepreg.pscert = endosos   .pscert;
          pepreg.pssspo = endosos   .pssspo;
          pepreg.psarse = endosos   .psarse;
          pepreg.psoper = endosos   .psoper;
       endif;

       endsr;

      *- Borro Comisiones segun peNit1
       begsr borCom;

         select;
           when ( peBase.peNit1 = 1 );
             peLsup( peLSupC ).psnivt2 = *Zeros;
             peLsup( peLsupc ).psnivt3 = *Zeros;
             peLsup( peLsupc ).psnivt4 = *Zeros;
             peLsup( peLsupc ).psnivt5 = *Zeros;
             peLsup( peLsupc ).psnivt6 = *Zeros;
             peLsup( peLsupc ).psnivt7 = *Zeros;
             peLsup( peLsupc ).psnivt8 = *Zeros;
             peLsup( peLsupc ).psnivt9 = *Zeros;
             peLsup( peLsupc ).psnivc2 = *Zeros;
             peLsup( peLsupc ).psnivc3 = *Zeros;
             peLsup( peLsupc ).psnivc4 = *Zeros;
             peLsup( peLsupc ).psnivc5 = *Zeros;
             peLsup( peLsupc ).psnivc6 = *Zeros;
             peLsup( peLsupc ).psnivc7 = *Zeros;
             peLsup( peLsupc ).psnivc8 = *Zeros;
             peLsup( peLsupc ).psnivc9 = *Zeros;
             peLsup( peLsupc ).pscopr2 = *Zeros;
             peLsup( peLsupc ).pscopr3 = *Zeros;
             peLsup( peLsupc ).pscopr4 = *Zeros;
             peLsup( peLsupc ).pscopr5 = *Zeros;
             peLsup( peLsupc ).pscopr6 = *Zeros;
             peLsup( peLsupc ).pscopr7 = *Zeros;
             peLsup( peLsupc ).pscopr8 = *Zeros;
             peLsup( peLsupc ).pscopr9 = *Zeros;
             peLsup( peLsupc ).psxopr2 = *Zeros;
             peLsup( peLsupc ).psxopr3 = *Zeros;
             peLsup( peLsupc ).psxopr4 = *Zeros;
             peLsup( peLsupc ).psxopr5 = *Zeros;
             peLsup( peLsupc ).psxopr6 = *Zeros;
             peLsup( peLsupc ).psxopr7 = *Zeros;
             peLsup( peLsupc ).psxopr8 = *Zeros;
             peLsup( peLsupc ).psxopr9 = *Zeros;
           when ( peBase.peNit1 = 2 );
             peLsup( peLsupc ).psnivt3 = *Zeros;
             peLsup( peLsupc ).psnivt4 = *Zeros;
             peLsup( peLsupc ).psnivt5 = *Zeros;
             peLsup( peLsupc ).psnivt6 = *Zeros;
             peLsup( peLsupc ).psnivt7 = *Zeros;
             peLsup( peLsupc ).psnivt8 = *Zeros;
             peLsup( peLsupc ).psnivt9 = *Zeros;
             peLsup( peLsupc ).psnivc3 = *Zeros;
             peLsup( peLsupc ).psnivc4 = *Zeros;
             peLsup( peLsupc ).psnivc5 = *Zeros;
             peLsup( peLsupc ).psnivc6 = *Zeros;
             peLsup( peLsupc ).psnivc7 = *Zeros;
             peLsup( peLsupc ).psnivc8 = *Zeros;
             peLsup( peLsupc ).psnivc9 = *Zeros;
             peLsup( peLsupc ).pscopr3 = *Zeros;
             peLsup( peLsupc ).pscopr4 = *Zeros;
             peLsup( peLsupc ).pscopr5 = *Zeros;
             peLsup( peLsupc ).pscopr6 = *Zeros;
             peLsup( peLsupc ).pscopr7 = *Zeros;
             peLsup( peLsupc ).pscopr8 = *Zeros;
             peLsup( peLsupc ).pscopr9 = *Zeros;
             peLsup( peLsupc ).psxopr3 = *Zeros;
             peLsup( peLsupc ).psxopr4 = *Zeros;
             peLsup( peLsupc ).psxopr5 = *Zeros;
             peLsup( peLsupc ).psxopr6 = *Zeros;
             peLsup( peLsupc ).psxopr7 = *Zeros;
             peLsup( peLsupc ).psxopr8 = *Zeros;
             peLsup( peLsupc ).psxopr9 = *Zeros;
           when ( peBase.peNit1 = 3 );
             peLsup( peLsupc ).psnivt4 = *Zeros;
             peLsup( peLsupc ).psnivt5 = *Zeros;
             peLsup( peLsupc ).psnivt6 = *Zeros;
             peLsup( peLsupc ).psnivt7 = *Zeros;
             peLsup( peLsupc ).psnivt8 = *Zeros;
             peLsup( peLsupc ).psnivt9 = *Zeros;
             peLsup( peLsupc ).psnivc4 = *Zeros;
             peLsup( peLsupc ).psnivc5 = *Zeros;
             peLsup( peLsupc ).psnivc6 = *Zeros;
             peLsup( peLsupc ).psnivc7 = *Zeros;
             peLsup( peLsupc ).psnivc8 = *Zeros;
             peLsup( peLsupc ).psnivc9 = *Zeros;
             peLsup( peLsupc ).pscopr4 = *Zeros;
             peLsup( peLsupc ).pscopr5 = *Zeros;
             peLsup( peLsupc ).pscopr6 = *Zeros;
             peLsup( peLsupc ).pscopr7 = *Zeros;
             peLsup( peLsupc ).pscopr8 = *Zeros;
             peLsup( peLsupc ).pscopr9 = *Zeros;
             peLsup( peLsupc ).psxopr4 = *Zeros;
             peLsup( peLsupc ).psxopr5 = *Zeros;
             peLsup( peLsupc ).psxopr6 = *Zeros;
             peLsup( peLsupc ).psxopr7 = *Zeros;
             peLsup( peLsupc ).psxopr8 = *Zeros;
             peLsup( peLsupc ).psxopr9 = *Zeros;
           when ( peBase.peNit1 = 4 );
             peLsup( peLsupc ).psnivt5 = *Zeros;
             peLsup( peLsupc ).psnivt6 = *Zeros;
             peLsup( peLsupc ).psnivt7 = *Zeros;
             peLsup( peLsupc ).psnivt8 = *Zeros;
             peLsup( peLsupc ).psnivt9 = *Zeros;
             peLsup( peLsupc ).psnivc5 = *Zeros;
             peLsup( peLsupc ).psnivc6 = *Zeros;
             peLsup( peLsupc ).psnivc7 = *Zeros;
             peLsup( peLsupc ).psnivc8 = *Zeros;
             peLsup( peLsupc ).psnivc9 = *Zeros;
             peLsup( peLsupc ).pscopr5 = *Zeros;
             peLsup( peLsupc ).pscopr6 = *Zeros;
             peLsup( peLsupc ).pscopr7 = *Zeros;
             peLsup( peLsupc ).pscopr8 = *Zeros;
             peLsup( peLsupc ).pscopr9 = *Zeros;
             peLsup( peLsupc ).psxopr5 = *Zeros;
             peLsup( peLsupc ).psxopr6 = *Zeros;
             peLsup( peLsupc ).psxopr7 = *Zeros;
             peLsup( peLsupc ).psxopr8 = *Zeros;
             peLsup( peLsupc ).psxopr9 = *Zeros;
           when ( peBase.peNit1 = 5 );
             peLsup( peLsupc ).psnivt6 = *Zeros;
             peLsup( peLsupc ).psnivt7 = *Zeros;
             peLsup( peLsupc ).psnivt8 = *Zeros;
             peLsup( peLsupc ).psnivt9 = *Zeros;
             peLsup( peLsupc ).psnivc6 = *Zeros;
             peLsup( peLsupc ).psnivc7 = *Zeros;
             peLsup( peLsupc ).psnivc8 = *Zeros;
             peLsup( peLsupc ).psnivc9 = *Zeros;
             peLsup( peLsupc ).pscopr6 = *Zeros;
             peLsup( peLsupc ).pscopr7 = *Zeros;
             peLsup( peLsupc ).pscopr8 = *Zeros;
             peLsup( peLsupc ).pscopr9 = *Zeros;
             peLsup( peLsupc ).psxopr6 = *Zeros;
             peLsup( peLsupc ).psxopr7 = *Zeros;
             peLsup( peLsupc ).psxopr8 = *Zeros;
             peLsup( peLsupc ).psxopr9 = *Zeros;
           when ( peBase.peNit1 = 6 );
             peLsup( peLsupc ).psnivt7 = *Zeros;
             peLsup( peLsupc ).psnivt8 = *Zeros;
             peLsup( peLsupc ).psnivt9 = *Zeros;
             peLsup( peLsupc ).psnivc7 = *Zeros;
             peLsup( peLsupc ).psnivc8 = *Zeros;
             peLsup( peLsupc ).psnivc9 = *Zeros;
             peLsup( peLsupc ).pscopr7 = *Zeros;
             peLsup( peLsupc ).pscopr8 = *Zeros;
             peLsup( peLsupc ).pscopr9 = *Zeros;
             peLsup( peLsupc ).psxopr7 = *Zeros;
             peLsup( peLsupc ).psxopr8 = *Zeros;
             peLsup( peLsupc ).psxopr9 = *Zeros;
           when ( peBase.peNit1 = 7 );
             peLsup( peLsupc ).psnivt8 = *Zeros;
             peLsup( peLsupc ).psnivt9 = *Zeros;
             peLsup( peLsupc ).psnivc8 = *Zeros;
             peLsup( peLsupc ).psnivc9 = *Zeros;
             peLsup( peLsupc ).pscopr8 = *Zeros;
             peLsup( peLsupc ).pscopr9 = *Zeros;
             peLsup( peLsupc ).psxopr8 = *Zeros;
             peLsup( peLsupc ).psxopr9 = *Zeros;
           when ( peBase.peNit1 = 8 );
             peLsup( peLsupc ).psnivt9 = *Zeros;
             peLsup( peLsupc ).psnivc9 = *Zeros;
             peLsup( peLsupc ).pscopr9 = *Zeros;
             peLsup( peLsupc ).psxopr9 = *Zeros;
         endsl;

       endsr;

       begsr busec1;

       k1hec1.c1empr = d0Empr;
       k1hec1.c1sucu = d0Sucu;
       k1hec1.c1arcd = d0arcd;
       k1hec1.c1spol = d0spol;
       k1hec1.c1sspo = d0sspo;
       Chain %kds(k1hec1:5)pahec1;
       if %found(pahec1);
         exsr cargonivc;
         if peBase.penivc = nivc(peBase.penivt) and
            peBase.peniv1 = nivc(pebase.penit1);
           paso = *on;
         else;
           paso = *off;
         endif;
       endif;

       endsr;

       begsr cargonivc;

       nivc(1) = c1niv1;
       nivc(2) = c1niv2;
       nivc(3) = c1niv3;
       nivc(4) = c1niv4;
       nivc(5) = c1niv5;
       nivc(6) = c1niv6;
       nivc(7) = c1niv7;
       nivc(8) = c1niv8;
       nivc(9) = c1niv9;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

       return %eof ( pahed091 );

     P finArc          E
