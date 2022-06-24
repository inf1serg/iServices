     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLMSR : WebService - Marca mensajes/Intermed.como leidos,   *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            18/08/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * NWN NWN 10/01/2017 : Cuando se lo llama con un mensaje leido *
      *                      marcar como no leido. Cuando se lo llama*
      *                      con un mensaje no leido , marcar como   *
      *                      leido.                                  *
      * ************************************************************ *
     Fgntmsg    uf   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLMSR          pr                  ExtPgm('WSLMSR')
     D   peBase                            likeds(paramBase) const
     D   peMsid                      25    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLMSR          pi
     D   peBase                            likeds(paramBase) const
     D   peMsid                      25    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0

     D ktmsg           ds                  likerec(g1tmsg:*key)

     D @@cant          s             10i 0

     D                sds
     D  vsuser               254    263

       *inLr = *On;

       clear peErro;
       clear peMsgs;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       ktmsg.sgempr = peBase.peEmpr;
       ktmsg.sgsucu = peBase.peSucu;
       ktmsg.sgnivt = peBase.peNivt;
       ktmsg.sgnivc = peBase.peNivc;
       ktmsg.sgmsid = peMsid;

       chain %kds(ktmsg : 5) gntmsg;
       if %found(gntmsg);
          if sgread = '0';
             sgread = '1';
             sguser = vsuser;
             sgdate = %dec(%date():*iso);
             sgtime = %dec(%time():*iso);
             update g1tmsg;
             else;
             sgread = '0';
             sguser = vsuser;
             sgdate = %dec(%date():*iso);
             sgtime = %dec(%time():*iso);
             update g1tmsg;
          endif;
       else;
          %subst(@@repl:1:25) = peMsid;
          @@Leng = %len ( %trimr ( @@repl ) );
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'MSG0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl))  );
         peErro = -1;
         return;
       endif;

       return;
