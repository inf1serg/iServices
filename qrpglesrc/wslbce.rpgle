     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLBCE  : Tareas generales.                                  *
      *           WebService - Retorna datos intermed.x Nivel/Codigo *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *07-Jul-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fpahusu2   if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLBCE          pr                  ExtPgm('WSLBCE')
     D   peCuit                      11    const
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peLint                            likeds(pahint_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLBCE          pi
     D   peCuit                      11    const
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peLint                            likeds(pahint_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLINT          pr                  ExtPgm('WSLINT')
     D   peBase                            likeds(paramBase)
     D   peDint                            likeds(pahint_t)
     D   peMint                            likeds(dsMail_t) dim(100)
     D   peMintc                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D   peBase        ds                  likeds(paramBase)
     D   p@Mint        ds                  likeds(dsMail_t) dim(100)
     D   p@Mintc       s             10i 0
     D   p@Erro        s                   like(paramErro)
     D   p@Msgs        ds                  likeds(paramMsgs)

     D khusu2          ds                  likerec(d1husu2:*key)

     D respue          s          65536
     D longm           s             10i 0

       *inLr = *On;

       clear peErro;
       clear peMsgs;

       peBase.peEmpr = peEmpr;
       peBase.peSucu = peSucu;
       peBase.peNivt = peNivt;
       peBase.peNivc = peNivc;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       khusu2.u2cuit = peCuit;
       khusu2.u2nivt = peNivt;
       khusu2.u2nivc = peNivc;

       chain %kds(khusu2:3) pahusu2;

       if %found(pahusu2);

          WSLINT(peBase:
                 peLint:
                 p@Mint:
                 p@Mintc:
                 p@Erro :
                 p@Msgs);

          return;

       else;

          respue =  %editC(peNivt:'4':*ASTFILL) +
                    %editC(peNivc:'4':*ASTFILL) +
                    %trim(peCuit);
          longm  = 17;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'PRD0005' :
                          peMsgs : respue  : longm );
          peErro = -1;
          return;

       endif;
