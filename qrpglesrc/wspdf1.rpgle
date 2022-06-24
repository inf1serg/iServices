     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSPDF1  : WebService.                                        *
      *           Historico de Solicitud de PDF - Poliza             *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                                  *14-Mar-2017  *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fsehpd1    uf a e           k disk
     Fgntmsg    if a e           k disk

     D WSPDF1          pr                  ExtPgm('WSPDF1')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peEpdf                       1    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSPDF1          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peEpdf                       1    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SndMail         pr                  extpgm('SNDMAIL')
     D  peCprc                       20a   const
     D  peCspr                       20a   const options(*nopass:*omit)
     D  peMens                      512a   varying options(*nopass:*omit)
     D  peLmsg                     5000a   options(*nopass:*omit)

     D cleanUp         pr             1N
     D  peMsid                        7a   const

     D random          pr                  extproc('CEERAN0')
     D  seed                         10u 0
     D  floater                       8f
     D  feedback                     12    options(*omit)

      // Variables...
     D   @@proc        s              1    inz
     D   maxrein       s             10i 0 inz
     D   tmpfec        s               d   datfmt(*iso)
     D   fecini        s              8  0 inz
     D   peMens        s            512a   varying

      // Areas de Datos...
     D Reintentos      ds                  qualified
     D                                     dtaara(WEBDTA003)
     D   Cantidad                    10a   overlay(Reintentos:1)

     D @PsDs          sds                  qualified
     D  CurUsr                       10a   overlay(@PsDs:358)

     D k1yhp1          ds                  likerec( s1hpd1 : *key )
     D k1ymsg          ds                  likerec( g1tmsg : *key )

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/cgi_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

      /free

       *inlr = *On;

       peErro = *Zeros;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       // Proceso...
       @@proc = tipoProc();

       in Reintentos;
       unlock Reintentos;
       monitor;
         MaxRein = %int(Reintentos.Cantidad);
       on-error;
         MaxRein = 10;
       endmon;

       k1yhp1.t@empr =  peBase.peEmpr;
       k1yhp1.t@sucu =  peBase.peSucu;
       k1yhp1.t@arcd =  peArcd;
       k1yhp1.t@rama =  peRama;
       k1yhp1.t@spol =  peSpol;
       k1yhp1.t@sspo =  pesspo;
       k1yhp1.t@poli =  pepoli;
       k1yhp1.t@suop =  pesuop;
       setll %kds( k1yhp1 : 8 ) sehpd1;
       if not %equal( sehpd1 );

         nueva();
         return;

       endif;
       reade %kds( k1yhp1 : 8 ) sehpd1;
       if not %eof( sehpd1 );
         if @@proc = 'W';
           if t@epdf = 'S' and peEpdf = 'N';

             nueva();
             return;

           endif;

           if t@epdf = 'N' and peEpdf = 'S';
             //actualiza...
             t@epdf  = peEpdf;
             t@fult  = %dec( %date   : *iso );
             t@hult  = %dec( %time() : *iso );
             t@proc  = @@proc;
             //no se avisa a nadie...
             t@info  = 'N';

             update s1hpd1;
             return;
           endif;

           return;
         endif;

         // si llamada es batch actualiza...
         if @@proc = 'B';

           t@epdf  = peEpdf;
           t@fult  = %dec( %date   : *iso );
           t@hult  = %dec( %time() : *iso );
           t@proc  = @@proc;
           t@rein += 1;
           t@info  = 'N';

           if peEpdf = 'S';
           //Avisa a productor...
             t@info  = 'S';
             K1ymsg.sgempr = peBase.peEmpr;
             K1ymsg.sgsucu = peBase.peSucu;
             K1ymsg.sgnivt = peBase.peNivt;
             K1ymsg.sgnivc = peBase.peNivc;
             K1ymsg.sgmsid = @@msid;

             chain %kds(k1ymsg) gntmsg;
             if not %found(gntmsg);

               sgempr = peBase.peEmpr;
               sgsucu = peBase.peSucu;
               sgnivt = peBase.peNivt;
               sgnivc = peBase.peNivc;
               sgmsid = @@msid;
               sgfmsg = %date;
               sgimpo = 0;
               sgread = '0';
               sgmar1 = '0';
               sgmar2 = '0';
               sgmar3 = '0';
               sgmar4 = '0';
               sgmar5 = '0';
               sgmar6 = '0';
               sgmar7 = '0';
               sgmar8 = '0';
               sgmar9 = '0';
               sgmar0 = '0';
               sguser = @PsDs.CurUsr;
               sgdate = %dec(%date);
               sgtime = %dec(%time():*iso);

               monitor;
                 tmpfec = %date( t@fini : *iso );
               on-error;
                 tmpfec = %date(00010101: *iso);
                 cleanUp( 'RNX0112' );
               endmon;
               fecini = %int(%char(tmpFec:*eur0));

               sgbody = 'La Póliza ' + %editc(t@poli:'X')
                    + '- '
                    + %trim( SVPDES_articulo( t@arcd ))
                    + ' solicitada en la fecha : '
                    + %editw(fecini :'  /  /    ')
                    +' se encuentra disponible para ser consultada ';

              write g1tmsg;
             endif;
           endif;

           //si no encontró y llegó al límite máximo de reintentos ...
           if peEpdf = 'N' and t@rein = MaxRein;
             //avisa a operaciones...
             t@info  = 'S';

             peMens = '<html>'
                    + 'Se alcanzo el límite'
                    + ' máximo de reintentos'
                    + ' en la búsqueda del siguiente'
                    + ' archivo PDF : '
                    + %trim(t@npdf)
                    + ' por favor verificar por que no se encuentra.'
                    + '</html>';
             sndmail( 'BUSCA POLIZA PDF'
                    : 'AVISO_OPERACIONES'
                    : peMens             );
           endif;
          update s1hpd1;
          return;
         endif;

       endif;

       return;
      /end-free
      * ------------------------------------------------------------ *
      * tipoProc(): Retorna proceso de llamadas                      *
      *                                                              *
      * retorna  Nombre del tipo de envío                            *
      *          "WEB"        = Invoca WEB                           *
      *          "BATCH"      = Invoca BATCH                         *
      * ------------------------------------------------------------ *
     P tipoProc        B
     D tipoProc        pi            20a

	    D QMHRCVPM        PR                  ExtPgm('QMHRCVPM')
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

	    D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
	    D   MessageID                    7A   const
	    D   QualMsgF                    20A   const
	    D   MsgData                  32767A   const options(*varsize)
	    D   MsgDtaLen                   10I 0 const
	    D   MsgType                     10A   const
	    D   CallStkEnt                  10A   const
	    D   CallStkCnt                  10I 0 const
	    D   MessageKey                   4A
	    D   ErrorCode                 8000A   options(*varsize)

	    D RCVM0200        DS                  qualified
	    D  Receiver             111    120A

	    D ErrorCode       ds                  qualified
	    D   BytesProv                   10I 0 inz(%size(ErrorCode))
	    D   BytesAvail                  10I 0 inz(0)

	    D MsgKey          s              4A
	    D stack_entry     s             10I 0
	    D startCnt        s             10I 0

	    D ENV_WEB         c                   'W'
	    D ENV_BATCH       c                   'B'

      /free

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

          select;
           when ( RCVM0200.Receiver = 'GSWEB049' );
                return ENV_BATCH;
          endsl;

		      endfor;

                return ENV_WEB;

      /end-free

     P tipoProc        E
      * ------------------------------------------------------------ *
      * nueva(): Graba Solicitud Nueva                               *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P nueva           b
     D nueva           pi
      /free

         clear s1hpd1;
         t@empr  = peBase.peEmpr;
         t@sucu  = peBase.peSucu;
         t@nivt  = peBase.peNivt;
         t@nivc  = peBase.peNivc;
         t@nit1  = peBase.peNit1;
         t@niv1  = peBase.peNiv1;
         t@arcd  = peArcd;
         t@rama  = perama;
         t@spol  = peSpol;
         t@sspo  = peSspo;
         t@poli  = pePoli;
         t@suop  = peSuop;
         t@fini  = %dec( %date   : *iso );
         t@hini  = %dec( %time() : *iso );
         t@epdf  = peEpdf;
         t@rein  = 1;
         t@fult  = *Zeros;
         t@hult  = *Zeros;
         t@proc  = @@proc;
         t@info  = 'N';
         t@npdf  = 'POLIZA_'
                 + %editc(t@arcd:'X')
                 + '_'
                 + %editc(t@spol:'X')
                 + '_'
                 + %editc(t@sspo:'X')
                 + '_'
                 + %editc(t@rama:'X')
                 + '_'
                 + %editc(t@poli:'X')
                 + '_'
                 + %editc(t@suop:'X')
                 + '.pdf';

         t@ma01 = 'N';
         t@ma02 = 'N';
         t@ma03 = 'N';
         t@ma04 = 'N';
         t@ma05 = 'N';

         write s1hpd1;

      /end-free
     P nueva           e
      //---------------------------------------------------------------
      // Armado de Id de mensaje para grabar en GNTMSG
      //---------------------------------------------------------------
     P @@msid          b
     D @@msid          pi            25a
     D @@msid          s             25a
     D
     D ALFABETO        s             26    inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D ran             s             30
     D seed            s             10u 0
     D floater         s              8f
     D x               s              2s 0
     D y               s             10i 0
       for y = 1 to 99;
         for x = 1 to 25;
            random( seed
                  : Floater
                  : *omit);
            %subst(ran:x:1) = %subst(ALFABETO:%Int(floater*26+1):1);
         endfor;
         K1ymsg.sgempr = peBase.peEmpr;
         K1ymsg.sgsucu = peBase.peSucu;
         K1ymsg.sgnivt = peBase.peNivt;
         K1ymsg.sgnivc = peBase.peNivc;
         K1ymsg.sgmsid = ran;
         chain %kds(k1ymsg) gntmsg;
         if %found(gntmsg);
           iter;
         else;
           return ran;
         endif;
       endfor;

     P @@msid          e
      * ------------------------------------------------------------ *
      * cleanUp():  Elimina mensajes controlados del Joblog.         *
      *                                                              *
      *     peMsid (input)  ID de mensaje a eliminar.                *
      *                                                              *
      * retorna: *void                                               *
      * ------------------------------------------------------------ *
     P cleanUp         B
     D cleanUp         pi             1N
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

       /end-free

     P cleanUp         E
