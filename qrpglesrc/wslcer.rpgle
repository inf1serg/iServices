     H nomain
     H datfmt(*iso)
      * ************************************************************ *
      * WSLCER: Programa de Servicio.                                *
      *         Serv.Pgm.- para generac.Certificados de Cobertura.   *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                             03-Jul-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
      * JCB 04/08/2015 Se agregaron nuevas variables comunes NEML y  *
      * ENDO y el archivo GNTEMP.                                    *
      * SGF 06/09/2016 Cuando seleccionaba grupo no tenía en cuenta  *
      *                Consorcio (Grupo "C").                        *
      * GIO 26/06/2018 #5648 Constancia de Cobertura en la WEB       *
      * LRG 27/05/2019 Se adapta para que tome todo Riesgos Varios   *
      *                                                              *
      * ************************************************************ *
     Fpahed091  if   e           k disk    usropn
     Fpahet9    if   e           k disk    usropn
     Fpaher9    if   e           k disk    usropn
     Fpahet002  if   e           k disk    usropn
     Fpaher002  if   e           k disk    usropn
     Fpahev001  if   e           k disk    usropn
     Fpaher02   if   e           k disk    usropn
     Fpaher2    if   e           k disk    usropn
     Fpaher0    if   e           k disk    usropn
     Fset001    if   e           k disk    usropn
     Fpahed0    if   e           k disk    usropn rename(p1hed0:rehed0)
     Fpahec1    if   e           k disk    usropn
     Fsehase01  if   e           k disk    usropn
     Fgntloc    if   e           k disk    usropn
     Fgntemp    if   e           k disk    usropn
     Fpahet0    if   e           k disk    usropn
     Fset205    if   e           k disk    usropn
     Fset225    if   e           k disk    usropn
     Fgnhdaf    if   e           k disk    usropn
     Fset210    if   e           k disk    usropn prefix('X_')
     Fset208    if   e           k disk    usropn
     Fset211    if   e           k disk    usropn prefix('Y_')
     Fset061    if   e           k disk    usropn
     Fset107    if   e           k disk    usropn prefix('Z_')
     Fset162    if   e           k disk    usropn prefix('A_')
     Fset101    if   e           k disk    usropn
     Fset2252   if   e           k disk    usropn
     Fset124    if   e           k disk    usropn
     Fpahccw    if a e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/wslcer_h.rpgle'
      * --------------------------------------------------- *
     DSPVIG2           pr                  extpgm('SPVIG2')
     D  p@arcd                        6  0
     D  p@spol                        9  0
     D  p@rama                        2  0
     D  p@arse                        2  0
     D  p@oper                        7  0
     D  p@fech                        8  0
     D  p@femi                        8  0
     D  p@stat                         n
     D  p@sspo                        3  0
     D  p@suop                        3  0
     D  p@fpgm                        3
      * --------------------------------------------------- *
     DSPCOBFIN         pr                  extpgm('SPCOBFIN')
     D  p@empr                        1
     D  p@sucu                        2
     D  p@arcd                        6  0
     D  p@spol                        9  0
     D  p@fech                        8  0
     D  p@conv                        1
     D  p@cobf                         n
     D  p@fpgm                        3
      * --------------------------------------------------- *
     D SP0068D         pr                  extpgm('SP0068D')
     D  p@empr                        1a
     D  p@sucu                        2a
     D  p@arcd                        6  0
     D  p@spol                        9  0
     D  p@sspo                        3  0
     D  p@rama                        2  0
     D  p@arse                        2  0
     D  p@oper                        7  0
     D  p@suop                        3  0
     D  p@poco                        4  0
     D  p@clau                        3a   dim(30)
     D  p@clan                        9a   dim(30) options(*nopass:*omit)
      * --------------------------------------------------- *

     D tipo            s              2  0 dim(15) ctdata perrcd(15)

     D  p@base         ds                  likeds(paramBase)
     D  p@empr         s              1a
     D  p@sucu         s              2a
     D  p@arcd         s              6  0
     D  p@poli         s              7  0
     D  p@spol         s              9  0
     D  p@sspo         s              3  0
     D  p@rama         s              2  0
     D  p@arse         s              2  0
     D  p@oper         s              7  0
     D  p@suop         s              3  0
     D  p@poco         s              4  0
     D  p@fech         s              8  0
     D  p@femi         s              8  0
     D  p@stat         s               n
     D  @@stat         s               n
     D  p@conv         s              1
     D  p@cobf         s               n
     D  @@cobf         s               n
     D  p@fpgm         s              3
     D  p@cobl         s              2

     D Initialized     s              1N

      *--- Definiciones de Procedimientos -------------------------- *
      * ------------------------------------------------------------ *
      * WSLCER_autos():         Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Automoviles                     *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos de Automoviles               *
      *                peDcob  -  Textos de Cobertura                *
      *                peDcobC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_autos...
     P                 B                   export
     D WSLCER_autos...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certAut_t)
     D   peDcob                      80    dim(999)
     D   peDcobC                     10i 0
     D   peMsgs                            likeds(paramMsgs)
     D
     D   p@Base        ds                  likeds(paramBase)
     D   p@Rama        s              2  0
     D   p@Poli        s              7  0
     D   p@Spol        s              9  0
     D   p@Sspo        s              3  0
     D   p@Poco        s              4  0
     D   peDsCo        ds                  likeds(certCom_t)
     D   peDsAu        ds                  likeds(certComAut_t)

       WSLCER_inz();

       p@Base = peBase;
       p@Rama = peRama;
       p@Poli = pePoli;
       p@Spol = peSpol;
       p@Sspo = peSspo;
       p@Poco = pePoco;
       clear peDsCo;
       clear peDsAu;
       clear peDsFi;
       clear peDcob;
       clear peDcobC;

       if WSLCER_certCobertura(p@Base:
                               p@Rama:
                               p@Poli:
                               p@Spol:
                               p@Sspo:
                               p@Poco:
                               peDsCo:
                               peDsAu:
                               *omit:
                               *omit:
                               peMsgs);

          peDsFi.ramd = peDsCo.ramd;
          peDsFi.ivig = peDsCo.ivig;
          peDsFi.fvig = peDsCo.fvig;
          peDsFi.asno = peDsCo.asno;
          peDsFi.domi = peDsCo.domi;
          peDsFi.copo = peDsCo.copo;
          peDsFi.cops = peDsCo.cops;
          peDsFi.loca = peDsCo.loca;
          peDsFi.neml = peDsCo.neml;
          peDsFi.endo = peDsCo.endo;
          peDsFi.vhde = peDsAu.vhde;
          peDsFi.vhaÑ = peDsAu.vhaÑ;
          peDsFi.moto = peDsAu.moto;
          peDsFi.chas = peDsAu.chas;
          peDsFi.nmat = peDsAu.nmat;
          peDsFi.vhvu = peDsAu.vhvu;
          peDsFi.ifra = peDsAu.ifra;
          peDsFi.vhcd = peDsAu.vhcd;
          peDsFi.cobl = peDsAu.cobl;
          peDsFi.apno = peDsAu.apno;
          peDsFi.cvde = peDsAu.cvde;
          peDsFi.vhdu = peDsAu.vhdu;

          WSLCER_getTxtAutos(p@Base:
                             p@Rama:
                             p@Poli:
                             p@Spol:
                             p@Sspo:
                             p@Poco:
                             peDcob:
                             peDcobC);

          return *On;

       else;

          return *Off;

       endif;

     P WSLCER_autos...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_autosI():        Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Automoviles (Uso interno)       *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos de Automoviles               *
      *                peDcob  -  Textos de Cobertura                *
      *                peDcobC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_autosI...
     P                 B                   export
     D WSLCER_autosI...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certAut_t)
     D   peDcob                      80    dim(999)
     D   peDcobC                     10i 0
     D   peMsgs                            likeds(paramMsgs)
     D
     D   p@Base        ds                  likeds(paramBase)
     D   p@Empr        s              1
     D   p@Sucu        s              2
     D   p@Rama        s              2  0
     D   p@Poli        s              7  0
     D   p@Spol        s              9  0
     D   p@Sspo        s              3  0
     D   p@Poco        s              4  0

       WSLCER_inz();

       p@Empr = peEmpr;
       p@Sucu = peSucu;
       p@Rama = peRama;
       p@Poli = pePoli;
       p@Spol = peSpol;
       p@Sspo = peSspo;
       p@Poco = pePoco;
       clear p@Base;
       clear peDcob;
       clear peDcobC;
       clear peMsgs;

       WSLCER_getParmBase(p@Empr:
                          p@Sucu:
                          p@Rama:
                          p@Poli:
                          p@Spol:
                          p@Sspo:
                          p@Poco:
                          p@Base);

       return WSLCER_autos(p@Base:
                           p@Rama:
                           p@Poli:
                           p@Spol:
                           p@Sspo:
                           p@Poco:
                           peDsFi:
                           peDcob:
                           peDcobC:
                           peMsgs);

     P WSLCER_autosI...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_embarcaciones()  Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Embarcaciones                   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos de Embarcaciones             *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_embarcaciones...
     P                 B                   export
     D WSLCER_embarcaciones...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certEmb_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
     D
     D   p@Base        ds                  likeds(paramBase)
     D   p@Rama        s              2  0
     D   p@Poli        s              7  0
     D   p@Spol        s              9  0
     D   p@Sspo        s              3  0
     D   p@Poco        s              4  0
     D   peDsCo        ds                  likeds(certCom_t)
     D   peDsEm        ds                  likeds(certComEmb_t)

       WSLCER_inz();

       p@Base = peBase;
       p@Rama = peRama;
       p@Poli = pePoli;
       p@Spol = peSpol;
       p@Sspo = peSspo;
       p@Poco = pePoco;
       clear peDsCo;
       clear peDsEm;
       clear peDsFi;
       clear peDsLc;
       clear peDsLcC;
       clear peClau;
       clear peClauC;
       clear peClan;
       clear peClanC;

       if WSLCER_certCobertura(p@Base:
                               p@Rama:
                               p@Poli:
                               p@Spol:
                               p@Sspo:
                               p@Poco:
                               peDsCo:
                               *omit:
                               peDsEm:
                               *omit:
                               peMsgs);

          peDsFi.ramd = peDsCo.ramd;
          peDsFi.ivig = peDsCo.ivig;
          peDsFi.fvig = peDsCo.fvig;
          peDsFi.asno = peDsCo.asno;
          peDsFi.domi = peDsCo.domi;
          peDsFi.copo = peDsCo.copo;
          peDsFi.cops = peDsCo.cops;
          peDsFi.loca = peDsCo.loca;
          peDsFi.neml = peDsCo.neml;
          peDsFi.endo = peDsCo.endo;
          peDsFi.emcn = peDsEm.emcn;
          peDsFi.emcm = peDsEm.emcm;
          peDsFi.emcf = peDsEm.emcf;
          peDsFi.emca = peDsEm.emca;
          peDsFi.emsc = peDsEm.emsc;
          peDsFi.emsm = peDsEm.emsm;
          peDsFi.emcd = peDsEm.emcd;

          WSLCER_getCoberturasRv(p@Base:
                                 p@Rama:
                                 p@Poli:
                                 p@Spol:
                                 p@Sspo:
                                 p@Poco:
                                 peDsLc:
                                 peDsLcC);

          WSLCER_getClausulas(p@Base:
                              p@Rama:
                              p@Poli:
                              p@Spol:
                              p@Sspo:
                              p@Poco:
                              peClau:
                              peClauC:
                              peClan:
                              peClanC);

          return *On;

       else;

          return *Off;

       endif;

     P WSLCER_embarcaciones...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_embarcacionesI() Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Embarcaciones (Uso interno)     *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos de Embarcaciones             *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_embarcacionesI...
     P                 B                   export
     D WSLCER_embarcacionesI...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certEmb_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
     D
     D   p@Base        ds                  likeds(paramBase)
     D   p@Empr        s              1
     D   p@Sucu        s              2
     D   p@Rama        s              2  0
     D   p@Poli        s              7  0
     D   p@Spol        s              9  0
     D   p@Sspo        s              3  0
     D   p@Poco        s              4  0

       WSLCER_inz();

       p@Empr = peEmpr;
       p@Sucu = peSucu;
       p@Rama = peRama;
       p@Poli = pePoli;
       p@Spol = peSpol;
       p@Sspo = peSspo;
       p@Poco = pePoco;
       clear p@Base;
       clear peDsFi;
       clear peDsLc;
       clear peDsLcC;
       clear peClau;
       clear peClauC;
       clear peClan;
       clear peClanC;
       clear peMsgs;

       WSLCER_getParmBase(p@Empr:
                          p@Sucu:
                          p@Rama:
                          p@Poli:
                          p@Spol:
                          p@Sspo:
                          p@Poco:
                          p@Base);

       return WSLCER_embarcaciones(p@Base:
                                   p@Rama:
                                   p@Poli:
                                   p@Spol:
                                   p@Sspo:
                                   p@Poco:
                                   peDsFi:
                                   peDsLc:
                                   peDsLcC:
                                   peClau:
                                   peClauC:
                                   peClan:
                                   peClanC:
                                   peMsgs);

     P WSLCER_embarcacionesI...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_cofli()          Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Combinado Familiar              *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos Combinado Familiar           *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_cofli...
     P                 B                   export
     D WSLCER_cofli...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
     D
     D   p@Base        ds                  likeds(paramBase)
     D   p@Rama        s              2  0
     D   p@Poli        s              7  0
     D   p@Spol        s              9  0
     D   p@Sspo        s              3  0
     D   p@Poco        s              4  0
     D   peDsCo        ds                  likeds(certCom_t)
     D   peDsCf        ds                  likeds(certComRvs_t)

       WSLCER_inz();

       p@Base = peBase;
       p@Rama = peRama;
       p@Poli = pePoli;
       p@Spol = peSpol;
       p@Sspo = peSspo;
       p@Poco = pePoco;
       clear peDsCo;
       clear peDsCf;
       clear peDsFi;
       clear peDsLc;
       clear peDsLcC;
       clear peClau;
       clear peClauC;
       clear peClan;
       clear peClanC;

       if WSLCER_certCobertura(p@Base:
u                              p@Rama:
                               p@Poli:
                               p@Spol:
                               p@Sspo:
                               p@Poco:
                               peDsCo:
                               *omit:
                               *omit:
                               peDsCf:
                               peMsgs);

          peDsFi.ramd = peDsCo.ramd;
          peDsFi.ivig = peDsCo.ivig;
          peDsFi.fvig = peDsCo.fvig;
          peDsFi.asno = peDsCo.asno;
          peDsFi.domi = peDsCo.domi;
          peDsFi.acop = peDsCo.copo;
          peDsFi.acos = peDsCo.cops;
          peDsFi.aloc = peDsCo.loca;
          peDsFi.ubic = peDsCf.ubic;
          peDsFi.copo = peDsCf.copo;
          peDsFi.cops = peDsCf.cops;
          peDsFi.loca = peDsCf.loca;
          peDsFi.neml = peDsCo.neml;
          peDsFi.endo = peDsCo.endo;
          peDsFi.dviv = peDsCf.dviv;
          peDsFi.ctds = peDsCf.ctds;

          WSLCER_getCoberturasRv(p@Base:
                                 p@Rama:
                                 p@Poli:
                                 p@Spol:
                                 p@Sspo:
                                 p@Poco:
                                 peDsLc:
                                 peDsLcC);

          WSLCER_getClausulas(p@Base:
                              p@Rama:
                              p@Poli:
                              p@Spol:
                              p@Sspo:
                              p@Poco:
                              peClau:
                              peClauC:
                              peClan:
                              peClanC);

          return *On;

       else;

          return *Off;

       endif;

     P WSLCER_cofli...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_cofliI()         Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Combinado Familiar (Uso interno)*
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi  -  Datos Combinado Familiar           *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_cofliI...
     P                 B                   export
     D WSLCER_cofliI...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
     D
     D   p@Base        ds                  likeds(paramBase)
     D   p@Empr        s              1
     D   p@Sucu        s              2
     D   p@Rama        s              2  0
     D   p@Poli        s              7  0
     D   p@Spol        s              9  0
     D   p@Sspo        s              3  0
     D   p@Poco        s              4  0

       WSLCER_inz();

       p@Empr = peEmpr;
       p@Sucu = peSucu;
       p@Rama = peRama;
       p@Poli = pePoli;
       p@Spol = peSpol;
       p@Sspo = peSspo;
       p@Poco = pePoco;
       clear p@Base;
       clear peDsFi;
       clear peDsLc;
       clear peDsLcC;
       clear peClau;
       clear peClauC;
       clear peClan;
       clear peClanC;
       clear peMsgs;

       WSLCER_getParmBase(p@Empr:
                          p@Sucu:
                          p@Rama:
                          p@Poli:
                          p@Spol:
                          p@Sspo:
                          p@Poco:
                          p@Base);

       return WSLCER_cofli(p@Base:
                           p@Rama:
                           p@Poli:
                           p@Spol:
                           p@Sspo:
                           p@Poco:
                           peDsFi:
                           peDsLc:
                           peDsLcC:
                           peClau:
                           peClauC:
                           peClan:
                           peClanC:
                           peMsgs);

     P WSLCER_cofliI...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_incon()          Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Integral Consorcios             *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi -  Datos Integral Consorcios           *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_incon...
     P                 B                   export
     D WSLCER_incon...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
     D
     D   p@Base        ds                  likeds(paramBase)
     D   p@Rama        s              2  0
     D   p@Poli        s              7  0
     D   p@Spol        s              9  0
     D   p@Sspo        s              3  0
     D   p@Poco        s              4  0
     D   peDsCo        ds                  likeds(certCom_t)
     D   peDsIc        ds                  likeds(certComRvs_t)

       WSLCER_inz();

       p@Base = peBase;
       p@Rama = peRama;
       p@Poli = pePoli;
       p@Spol = peSpol;
       p@Sspo = peSspo;
       p@Poco = pePoco;
       clear peDsCo;
       clear peDsIc;
       clear peDsFi;
       clear peDsLc;
       clear peDsLcC;
       clear peClau;
       clear peClauC;
       clear peClan;
       clear peClanC;

       if WSLCER_certCobertura(p@Base:
                               p@Rama:
                               p@Poli:
                               p@Spol:
                               p@Sspo:
                               p@Poco:
                               peDsCo:
                               *omit:
                               *omit:
                               peDsIc:
                               peMsgs);

          peDsFi.ramd = peDsCo.ramd;
          peDsFi.ivig = peDsCo.ivig;
          peDsFi.fvig = peDsCo.fvig;
          peDsFi.asno = peDsCo.asno;
          peDsFi.domi = peDsCo.domi;
          peDsFi.acop = peDsCo.copo;
          peDsFi.acos = peDsCo.cops;
          peDsFi.aloc = peDsCo.loca;
          peDsFi.ubic = peDsIc.ubic;
          peDsFi.copo = peDsIc.copo;
          peDsFi.cops = peDsIc.cops;
          peDsFi.loca = peDsIc.loca;
          peDsFi.neml = peDsCo.neml;
          peDsFi.endo = peDsCo.endo;
          peDsFi.dviv = peDsIc.dviv;
          peDsFi.ctds = peDsIc.ctds;

          WSLCER_getCoberturasRv(p@Base:
                                 p@Rama:
                                 p@Poli:
                                 p@Spol:
                                 p@Sspo:
                                 p@Poco:
                                 peDsLc:
                                 peDsLcC);

          WSLCER_getClausulas(p@Base:
                              p@Rama:
                              p@Poli:
                              p@Spol:
                              p@Sspo:
                              p@Poco:
                              peClau:
                              peClauC:
                              peClan:
                              peClanC);

          return *On;

       else;

          return *Off;

       endif;

     P WSLCER_incon...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_inconI()         Obtiene datos para realizar el ar-   *
      *                         mado del Certificados de Cobertura   *
      *                         para Integral Consorcios (Uso interno)
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsFi -  Datos Integral Consorcios           *
      *                peDsLc  -  Coberturas                         *
      *                peDsLcC -  Cantidad de Elementos              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_inconI...
     P                 B                   export
     D WSLCER_inconI...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)
     D
     D   p@Base        ds                  likeds(paramBase)
     D   p@Empr        s              1
     D   p@Sucu        s              2
     D   p@Rama        s              2  0
     D   p@Poli        s              7  0
     D   p@Spol        s              9  0
     D   p@Sspo        s              3  0
     D   p@Poco        s              4  0

       WSLCER_inz();

       p@Empr = peEmpr;
       p@Sucu = peSucu;
       p@Rama = peRama;
       p@Poli = pePoli;
       p@Spol = peSpol;
       p@Sspo = peSspo;
       p@Poco = pePoco;
       clear p@Base;
       clear peDsFi;
       clear peDsLc;
       clear peDsLcC;
       clear peClau;
       clear peClauC;
       clear peClan;
       clear peClanC;
       clear peMsgs;

       WSLCER_getParmBase(p@Empr:
                          p@Sucu:
                          p@Rama:
                          p@Poli:
                          p@Spol:
                          p@Sspo:
                          p@Poco:
                          p@Base);

       return WSLCER_incon(p@Base:
                           p@Rama:
                           p@Poli:
                           p@Spol:
                           p@Sspo:
                           p@Poco:
                           peDsFi:
                           peDsLc:
                           peDsLcC:
                           peClau:
                           peClauC:
                           peClan:
                           peClanC:
                           peMsgs);

     P WSLCER_inconI...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_valParametros(): Valida Parametros de Entrada para    *
      *                         generacion de Certificados de Co-    *
      *                         bertura.                             *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peMsgs  -  Mensaje de Error                   *
      *                peGrupo -  Grupo de la Rama                   *
      *                                                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     P WSLCER_valParametros...
     P                 B                   export
     D WSLCER_valParametros...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peMsgs                            likeds(paramMsgs)
     D   peGrupo                      1    options(*nopass:*omit)

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpahexx         ds                  likerec(p1het9:*key)
     D kpahev001       ds                  likerec(p1hev001:*key)

     D wexiste         s               n
     D wrepl           s          65535a
     D FechTS          s               z

       WSLCER_inz();

       clear peMsgs;

      *- Validaciones
      *- Valido Parametro Base
       if not SVPWS_chkParmBase ( peBase : peMsgs );
         return *Off;
       endif;

      *- Valido Rama

       p@rama = peRama;

       peGrupo = SVPWS_getGrupoRama(p@rama);

       if peGrupo = *Blanks;
          %subst(wrepl:1:2) = %editc(peRama:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          return *off;
       else;
          if peGrupo = 'V';
             %subst(wrepl:1:2) = %editc(peRama:'X');
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'RAM0003'
                          : peMsgs
                          : %trim(wrepl)
                          : %len(%trim(wrepl))  );
             return *off;
          endif;
       endif;

      *- Valido Poliza
       kpahed091.d0empr = peBase.peEmpr;
       kpahed091.d0sucu = peBase.peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       setll %kds(kpahed091 : 5) pahed091;

       if not %equal(pahed091);
          %subst(wrepl:1:2) = %editc(peRama:'X');
          %subst(wrepl:3:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0009'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          return *off;
       endif;

       reade %kds(kpahed091 : 5) pahed091;

      *- Valido Vigencia Poliza

       p@spol = peSpol;
       p@rama = peRama;
       p@sspo = peSspo;
       p@fech = %dec(%date:*iso);
       p@femi = %dec(%date:*iso);
       p@stat = *Off;
       @@stat = *Off;
       p@fpgm = *Blanks;

       SPVIG2(d0arcd:
              p@spol:
              p@rama:
              d0arse:
              d0oper:
              p@fech:
              p@femi:
              p@stat:
              p@sspo:
              d0suop:
              p@fpgm);

       @@stat = p@stat;
       p@fpgm = 'FIN';

       SPVIG2(d0arcd:
              p@spol:
              p@rama:
              d0arse:
              d0oper:
              p@fech:
              p@femi:
              p@stat:
              p@sspo:
              d0suop:
              p@fpgm);

      *- Valido Componente
       kpahexx.t9empr = peBase.peEmpr;
       kpahexx.t9sucu = peBase.peSucu;
       kpahexx.t9arcd = d0arcd;
       kpahexx.t9spol = peSpol;
       kpahexx.t9rama = peRama;
       kpahexx.t9arse = d0arse;
       kpahexx.t9oper = d0oper;
       kpahexx.t9poco = pePoco;

       kpahev001.v0empr = peBase.peEmpr;
       kpahev001.v0sucu = peBase.peSucu;
       kpahev001.v0arcd = d0arcd;
       kpahev001.v0spol = peSpol;
       kpahev001.v0sspo = peSspo;
       kpahev001.v0rama = peRama;
       kpahev001.v0arse = d0arse;
       kpahev001.v0oper = d0oper;
       kpahev001.v0poco = pePoco;

       wexiste = *off;

       select;

          when peGrupo = 'A';
             setll %kds(kpahexx : 8) pahet9;
             if %equal(pahet9);
                wexiste = *on;
             endif;

          when peGrupo = 'V';
             setll %kds(kpahev001 : 9) pahev001;
             if %equal(pahev001);
                wexiste = *on;
             endif;

          other;
             setll %kds(kpahexx : 8) paher9;
             if %equal(paher9);
                wexiste = *on;
             endif;

       endsl;

       if not wexiste;
          %subst(wrepl:1:6) = %editc(pePoco:'X');
          %subst(wrepl:7:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'BIE0001'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          return *off;
       endif;

      *- Valido Cobertura Financiera Poliza

       p@empr = peBase.peEmpr;
       p@sucu = peBase.peSucu;
       p@spol = peSpol;
       p@fech = %dec(%date:*iso);
       p@conv = 'P';
       p@cobf = *Off;
       @@cobf = *Off;
       p@fpgm = *Blanks;

       SPCOBFIN(p@empr:
                p@sucu:
                d0arcd:
                p@spol:
                p@fech:
                p@conv:
                p@cobf:
                p@fpgm);

       @@cobf = p@cobf;
       p@fpgm = 'FIN';

       SPCOBFIN(p@empr:
                p@sucu:
                d0arcd:
                p@spol:
                p@fech:
                p@conv:
                p@cobf:
                p@fpgm);

       p@base = peBase;
       p@rama = peRama;
       p@poli = pePoli;
       p@spol = peSpol;
       p@sspo = peSspo;
       p@poco = pePoco;

       if WSLCER_GetUltSspo(p@base:
                            p@rama:
                            p@poli:
                            p@spol:
                            p@sspo:
                            p@poco) = -1;

          %subst(wrepl:1:6) = %editc(pePoco:'X');
          %subst(wrepl:7:3) = %editc(peSspo:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'BIE0003'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

          return *off;

       endif;

       // Graba PAHCCW - Constancia Cobertura en la WEB
       FechTS = %timestamp();
       cwempr = peBase.peEmpr;
       cwsucu = peBase.peSucu;
       cwnivt = peBase.peNivt;
       cwnivc = peBase.peNivc;
       cwtims = %editc(%dec(FechTS:*iso):'X');
       cwnit1 = peBase.peNit1;
       cwniv1 = peBase.peNiv1;
       cwrama = peRama;
       cwpoli = pePoli;
       cwarcd = d0arcd;
       cwspol = peSpol;
       cwsspo = peSspo;
       cwpoco = pePoco;
       cwfech = ( %subdt(FechTS:*Y) * 10000 ) +
                ( %subdt(FechTS:*M) * 100 ) +
                  %subdt(FechTS:*D);
       cwtime = ( %subdt(FechTS:*H) * 10000 ) +
                ( %subdt(FechTS:*MN) * 100 ) +
                  %subdt(FechTS:*S);
       cwvige = @@stat;
       cwcobf = @@cobf;
       write p1hccw;

       return *on;

     P WSLCER_valParametros...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_getDatosComunes()  Obtiene datos en comun para todo   *
      *                           tipo de Certificados de Cobertura. *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsCo  -  Datos Comunes                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_getDatosComunes...
     P                 B                   export
     D WSLCER_getDatosComunes...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const options(*omit)
     D   peDsCo                            likeds(certCom_t)

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpahed0         ds                  likerec(rehed0:*key)
     D kpahec1         ds                  likerec(p1hec1:*key)
     D kgntloc         ds                  likerec(g1tloc:*key)

       WSLCER_inz();

       clear peDsCo.ramd;

       chain (peRama) set001;
       if %found(set001);
          peDsCo.ramd = t@ramd;
       endif;

       chain (peBase.peEmpr) gntemp;
       if %found(gntemp);
          peDsCo.neml = emneml;
       endif;

       clear p1hed0;

       kpahed091.d0empr = peBase.peEmpr;
       kpahed091.d0sucu = peBase.peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       chain %kds(kpahed091 : 5) pahed091;

       kpahed0.d0empr = peBase.peEmpr;
       kpahed0.d0sucu = peBase.peSucu;
       kpahed0.d0arcd = d0arcd;
       kpahed0.d0spol = peSpol;
       kpahed0.d0sspo = peSspo;
       kpahed0.d0rama = peRama;
       kpahed0.d0arse = d0arse;

       chain %kds(kpahed0 : 7) pahed0;

       peDsCo.ivig = d0fioa * 10000 + d0fiom * 100 + d0fiod;
       peDsCo.fvig = d0fhfa * 10000 + d0fhfm * 100 + d0fhfd;
       peDsCo.endo = d0endo;

       clear peDsCo.asno;
       clear peDsCo.domi;
       clear peDsCo.copo;
       clear peDsCo.cops;
       clear peDsCo.loca;

       kpahec1.c1empr = peBase.peEmpr;
       kpahec1.c1sucu = peBase.peSucu;
       kpahec1.c1arcd = d0arcd;
       kpahec1.c1spol = peSpol;
       kpahec1.c1sspo = peSspo;

       chain %kds(kpahec1 : 5) pahec1;
       if %found(pahec1);

          chain (c1asen) sehase01;
          if %found(sehase01);

             peDsCo.asno = dfnomb;
             peDsCo.domi = dfdomi;
             peDsCo.copo = dfcopo;
             peDsCo.cops = dfcops;

             kgntloc.locopo = dfcopo;
             kgntloc.locops = dfcops;

             chain %kds(kgntloc : 2) gntloc;
             if %found(gntloc);
                peDsCo.loca = loloca;
             endif;

          endif;


       endif;

       return;

     P WSLCER_getDatosComunes...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_getDatosAutos()    Obtiene datos de Automoviles para  *
      *                           Certificados de Cobertura.         *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsAu  -  Datos de Automoviles               *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_getDatosAutos...
     P                 B                   export
     D WSLCER_getDatosAutos...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsAu                            likeds(certComAut_t)

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpahet0         ds                  likerec(p1het0:*key)

       WSLCER_inz();

       kpahed091.d0empr = peBase.peEmpr;
       kpahed091.d0sucu = peBase.peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       chain %kds(kpahed091 : 5) pahed091;

       clear peDsAu.vhde;
       clear peDsAu.vhaÑ;
       clear peDsAu.moto;
       clear peDsAu.chas;
       clear peDsAu.nmat;
       clear peDsAu.vhvu;
       clear peDsAu.ifra;
       clear peDsAu.cobl;

       kpahet0.t0empr = peBase.peEmpr;
       kpahet0.t0sucu = peBase.peSucu;
       kpahet0.t0arcd = d0arcd;
       kpahet0.t0spol = peSpol;
       kpahet0.t0sspo = peSspo;
       kpahet0.t0rama = peRama;
       kpahet0.t0arse = d0arse;
       kpahet0.t0oper = d0oper;
       kpahet0.t0poco = pePoco;

       chain %kds(kpahet0 : 9) pahet0;

       if %found(pahet0);

          peDsAu.vhde = t0vhde;
          peDsAu.vhaÑ = t0vhaÑ;
          peDsAu.moto = t0moto;
          peDsAu.chas = t0chas;
          peDsAu.nmat = t0nmat;
          peDsAu.vhvu = t0vhvu;
          peDsAu.ifra = t0ifra;
          peDsAu.cobl = t0cobl;

          clear peDsAu.vhcd;
          chain (t0vhcr) set205;
          if %found(set205);
             peDsAu.vhcd = t@vhcd;
          endif;

          clear peDsAu.apno;
          chain (t0acrc) gnhdaf;
          if not %found(gnhdaf);
             peDsAu.apno = '* NO REGISTRA *';
          else;
             peDsAu.apno = dfnomb;
          endif;

          clear peDsAu.cvde;
          if t0mtdf <> *Blanks
             and t0mtdf <> '0';
             chain (t0mtdf) set208;
             if %found(set208);
                peDsAu.cvde = t@mtdd;
             endif;
          else;
             chain (t0vhct) set210;
             if %found(set210);
                peDsAu.cvde = X_t@vhdt;
             endif;
          endif;

          clear peDsAu.vhdu;
          chain (t0vhuv) set211;
          if %found(set211);
             peDsAu.vhdu = Y_t@vhdu;
          endif;

       endif;

       return;

     P WSLCER_getDatosAutos...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_getDatosEmbarcaciones() Obtiene datos de Embarcacio-  *
      *                                nes para Certif.de Cobertura. *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsEm  -  Datos de Embarcaciones             *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_getDatosEmbarcaciones...
     P                 B                   export
     D WSLCER_getDatosEmbarcaciones...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsEm                            likeds(certComEmb_t)

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpaher02        ds                  likerec(p1her02:*key)

       WSLCER_inz();

       kpahed091.d0empr = peBase.peEmpr;
       kpahed091.d0sucu = peBase.peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       chain %kds(kpahed091 : 5) pahed091;

       clear peDsEm.emcn;
       clear peDsEm.emcf;
       clear peDsEm.emca;
       clear peDsEm.emsc;
       clear peDsEm.emsm;

       kpaher02.r0empr2 = peBase.peEmpr;
       kpaher02.r0sucu2 = peBase.peSucu;
       kpaher02.r0arcd2 = d0arcd;
       kpaher02.r0spol2 = peSpol;
       kpaher02.r0sspo2 = peSspo;
       kpaher02.r0rama2 = peRama;
       kpaher02.r0arse2 = d0arse;
       kpaher02.r0oper2 = d0oper;
       kpaher02.r0poco2 = pePoco;

       chain %kds(kpaher02: 9) paher02;
       if %found(paher02);

          peDsEm.emcn = r0emcn2;

          if r0emcr2 = *Blanks;
             peDsEm.emcm = r0emcj2;
          else;
             peDsEm.emcm = r0emcr2;
          endif;

          peDsEm.emcf = r0emcf2;
          peDsEm.emca = r0emca2;

          if (r0emsm2 + r0emsc2) = *Zeros;
             peDsEm.emsc = r0emst2;
          else;
             peDsEm.emsc = r0emsc2;
          endif;

          peDsEm.emsm = r0emsm2;

          clear peDsEm.emcd;
          chain (r0emct2) set061;
          if %found(set061);
             peDsEm.emcd = t@emcd;
          endif;

       endif;

       return;

     P WSLCER_getDatosEmbarcaciones...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_getCoberturasRv()     Obtiene Lista de Coberturas de  *
      *                              Riesgos Varios para Certifica-  *
      *                              dos de Cobertura.               *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsLc  -  Lista de Coberturas                *
      *                peDsLcC -  Cantidad de Elementos              *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_getCoberturasRv...
     P                 B                   export
     D WSLCER_getCoberturasRv...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpaher2         ds                  likerec(p1her2:*key)
     D kset107         ds                  likerec(s1t107:*key)

     D @@sspo          s              3  0

       WSLCER_inz();

       @@sspo = WSLCER_getUltSspo(peBase:
                                  peRama:
                                  pePoli:
                                  peSpol:
                                  peSspo:
                                  pePoco);

       kpahed091.d0empr = peBase.peEmpr;
       kpahed091.d0sucu = peBase.peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       chain %kds(kpahed091 : 5) pahed091;

       clear peDsLc;
       clear peDsLcC;

       kpaher2.r2empr = peBase.peEmpr;
       kpaher2.r2sucu = peBase.peSucu;
       kpaher2.r2arcd = d0arcd;
       kpaher2.r2spol = peSpol;
       kpaher2.r2sspo = @@sspo;
       kpaher2.r2rama = peRama;
       kpaher2.r2arse = d0arse;
       kpaher2.r2oper = d0oper;
       kpaher2.r2poco = pePoco;

       setll %kds(kpaher2:9) paher2;
       reade %kds(kpaher2:9) paher2;

       dow not %eof(paher2) and peDsLcC < 50;

          if r2ecob <> 'B';
             peDsLcC += 1;
             clear s1t107;
             kset107.Z_t@rama = peRama;
             kset107.Z_t@cobc = r2xcob;
             chain %kds(kset107:2) set107;
             peDsLc(peDsLcC).cobd = Z_t@cobl;
             peDsLc(peDsLcC).suma = r2saco;
          endif;

          reade %kds(kpaher2:9) paher2;

       enddo;

       return;

     P WSLCER_getCoberturasRv...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_getDatosRv()          Obtiene Datos de Riesgos Varios *
      *                              para Certificados de Cobertura  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsRv  -  Datos de Riesgos Varios            *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_getDatosRv...
     P                 B                   export
     D WSLCER_getDatosRv...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsRv                            likeds(certComRvs_t)

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpaher0         ds                  likerec(p1her0:*key)
     D kgntloc         ds                  likerec(g1tloc:*key)
     D kset101         ds                  likerec(s1t101:*key)

       WSLCER_inz();

       kpahed091.d0empr = peBase.peEmpr;
       kpahed091.d0sucu = peBase.peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       chain %kds(kpahed091 : 5) pahed091;

       clear peDsRv.ubic;
       clear peDsRv.copo;
       clear peDsRv.cops;

       kpaher0.r0empr = peBase.peEmpr;
       kpaher0.r0sucu = peBase.peSucu;
       kpaher0.r0arcd = d0arcd;
       kpaher0.r0spol = peSpol;
       kpaher0.r0sspo = peSspo;
       kpaher0.r0rama = peRama;
       kpaher0.r0arse = d0arse;
       kpaher0.r0oper = d0oper;
       kpaher0.r0poco = pePoco;

       chain %kds(kpaher0: 9) paher0;
       if %found(paher0);

          peDsRv.ubic = %trim(r0rdes) + ' ' + %trim(%char(r0nrdm));
          peDsRv.copo = r0copo;
          peDsRv.cops = r0cops;

          clear peDsRv.loca;
          kgntloc.locopo = r0copo;
          kgntloc.locops = r0cops;
          chain %kds(kgntloc : 2) gntloc;
          if %found(gntloc);
             peDsRv.loca = loloca;
          endif;

          select;

             when peRama = 27;
                clear peDsRv.dviv;
                chain (r0cviv) set162;
                if %found(set162);
                   peDsRv.dviv = A_t@dviv;
                endif;

             when peRama = 26;
                clear peDsRv.ctds;
                kset101.t@rama = peRama;
                kset101.t@ctar = r0ctar;
                kset101.t@cta1 = r0cta1;
                kset101.t@cta2 = r0cta2;
                chain %kds(kset101:4) set101;
                if %found(set101);
                   peDsRv.ctds = t@ctds;
                endif;

          endsl;

       endif;

       return;

     P WSLCER_getDatosRv...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_getTxtAutos()         Obtiene Texto Cobertura para Au-*
      *                              tomoviles.                      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDcob  -  Textos de Cobertura                *
      *                peDcobC -  Cantidad de Elementos              *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_getTxtAutos...
     P                 B                   export
     D WSLCER_getTxtAutos...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDcob                      80    dim(999)
     D   peDcobC                     10i 0

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpahet0         ds                  likerec(p1het0:*key)
     D kset124         ds                  likerec(s1t124:*key)

     D @@sspo          s              3  0

     D detalle         ds                  likerec(s1t124)

       WSLCER_inz();

       @@sspo = WSLCER_getUltSspo(peBase:
                                  peRama:
                                  pePoli:
                                  peSpol:
                                  peSspo:
                                  pePoco);

       clear peDcob;
       clear peDcobC;

       kpahed091.d0empr = peBase.peEmpr;
       kpahed091.d0sucu = peBase.peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       chain %kds(kpahed091 : 5) pahed091;

       kpahet0.t0empr = peBase.peEmpr;
       kpahet0.t0sucu = peBase.peSucu;
       kpahet0.t0arcd = d0arcd;
       kpahet0.t0spol = peSpol;
       kpahet0.t0sspo = @@sspo;
       kpahet0.t0rama = peRama;
       kpahet0.t0arse = d0arse;
       kpahet0.t0oper = d0oper;
       kpahet0.t0poco = pePoco;

       chain %kds(kpahet0 : 9) pahet0;
       if %found(pahet0);

          chain (t0cobl) set2252;

          kset124.t@rama = peRama;

          if %lookup(t0vhct:tipo) = 0;
             kset124.t@tpcd = t@tpcd;
          else;
             kset124.t@tpcd = t@tpc2;
          endif;

          setll %kds ( kset124 : 2 ) set124;
          reade %kds ( kset124 : 2 ) set124 detalle;

          dow ( not %eof ( set124 ) ) and ( peDcobC < 999 );

            peDcobC += 1;
            peDcob(peDcobC) = detalle.t@tpds;

            reade %kds ( kset124 : 2 ) set124 detalle;

          enddo;

       endif;

       return;

     P WSLCER_getTxtAutos...
     P                 E
      * ------------------------------------------------------------ *
      *  WSLCER_getClausulas()    Recupera Clausulas                 *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peClau  -  Clausulas                          *
      *                peClauC -  Cantidad de Elementos              *
      *                peClan  -  Anexos                             *
      *                peClanC -  Cantidad de Elementos              *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_getClausulas...
     P                 B                   export
     D WSLCER_getClausulas...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30) options(*nopass:*omit)
     D   peClanC                     10i 0 options(*nopass:*omit)

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpaher02        ds                  likerec(p1her02:*key)

     D  p@base         ds                  likeds(paramBase)
     D  p@rama         s              2  0
     D  p@poli         s              7  0
     D  p@spol         s              9  0
     D  p@sspo         s              3  0
     D  p@poco         s              4  0
     D  @@Clau         s              3a   dim(30)
     D  @@Clan         s              9a   dim(30)
     D  @@x            s             10i 0


     D @@sspo          s              3  0

       WSLCER_inz();

       @@sspo = WSLCER_getUltSspo(peBase:
                                  peRama:
                                  pePoli:
                                  peSpol:
                                  peSspo:
                                  pePoco);

       p@base = peBase;
       p@rama = peRama;
       p@poli = pePoli;
       p@spol = peSpol;
       p@sspo = peSspo;
       p@poco = pePoco;
       clear peClau;
       clear peClan;
       clear @@Clau;
       clear @@Clan;
       clear @@x;

       kpahed091.d0empr = peBase.peEmpr;
       kpahed091.d0sucu = peBase.peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       chain %kds(kpahed091 : 5) pahed091;

       SP0068D(p@Base.peEmpr:
               p@Base.peSucu:
               d0arcd:
               p@Spol:
               @@sspo:
               p@Rama:
               d0Arse:
               d0Oper:
               @@sspo:
               p@Poco:
               @@Clau:
               @@Clan);

       for @@x = 1 to 30;

           if @@Clau(@@x) <> *Blanks;
              peClauC += 1;
              peClau(peclauC) = @@Clau(@@x);
           endif;

           if @@Clan(@@x) <> *Blanks;
              peClanC += 1;
              peClan(peclanC) = @@Clan(@@x);
           endif;

       endfor;

       return;

     P WSLCER_getClausulas...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_certCobertura()       Obtiene Datos para Certificados *
      *                              de Cobertura                    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peDsCo  -  Datos Comunes                      *
      *                peDsAu  -  Datos de Automoviles               *
      *                peDsEm  -  Datos de Embarcaciones             *
      *                peDsRv  -  Datos de Riesgos Varios            *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_certCobertura...
     P                 B                   export
     D WSLCER_certCobertura...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsCo                            likeds(certCom_t)
     D   peDsAu                            likeds(certComAut_t)
     D                                     options(*omit)
     D   peDsEm                            likeds(certComEmb_t)
     D                                     options(*omit)
     D   peDsRv                            likeds(certComRvs_t)
     D                                     options(*omit)
     D   peMsgs                            likeds(paramMsgs)

     D   @@base        ds                  likeds(paramBase)
     D   @@rama        s              2  0
     D   @@poli        s              7  0
     D   @@spol        s              9  0
     D   @@sspo        s              3  0
     D   @@poco        s              4  0
     D   peGrupo       s              1

       WSLCER_inz();

       @@base = peBase;
       @@rama = peRama;
       @@poli = pePoli;
       @@spol = peSpol;
       @@sspo = peSspo;
       @@poco = pePoco;
       clear peMsgs;
       clear peGrupo;

       if WSLCER_valParametros(@@base:
                               @@rama:
                               @@poli:
                               @@spol:
                               @@sspo:
                               @@poco:
                               peMsgs:
                               peGrupo);

          @@sspo = WSLCER_getUltSspo(@@base:
                                     @@rama:
                                     @@poli:
                                     @@spol:
                                     @@sspo:
                                     @@poco);

          WSLCER_getDatosComunes(@@base:
                                 @@rama:
                                 @@poli:
                                 @@spol:
                                 @@sspo:
                                 @@poco:
                                 peDsCo);

          select;

             when peGrupo = 'A';
                WSLCER_getDatosAutos(@@base:
                                     @@rama:
                                     @@poli:
                                     @@spol:
                                     @@sspo:
                                     @@poco:
                                     peDsAu);


             when peGrupo = 'T';
                WSLCER_getDatosEmbarcaciones(@@base:
                                             @@rama:
                                             @@poli:
                                             @@spol:
                                             @@sspo:
                                             @@poco:
                                             peDsEm);

             when peGrupo <> 'V';
                WSLCER_getDatosRv(@@base:
                                  @@rama:
                                  @@poli:
                                  @@spol:
                                  @@sspo:
                                  @@poco:
                                  peDsRv);

          endsl;

          return *on;

       else;

          return *off;

       endif;


     P WSLCER_certCobertura...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_getUltSspo():    Retorna el ultimo suplemento de      *
      *                         Superpoliza afectado por el Compo-   *
      *                         nente.                               *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *                                                              *
      * Retorna: Ultimo Suplemento Superpoliza/ -1 si error          *
      * ------------------------------------------------------------ *
     P WSLCER_getUltSspo...
     P                 B                   export
     D WSLCER_getUltSspo...
     D                 pi             3  0
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpahexx         ds                  likerec(p1het002:*key)

     D peGrupo         s              1    inz(*Blanks)

       WSLCER_inz();

       p@rama = peRama;

       peGrupo = SVPWS_getGrupoRama(p@rama);

       kpahed091.d0empr = peBase.peEmpr;
       kpahed091.d0sucu = peBase.peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       setll %kds(kpahed091 : 5) pahed091;

       reade %kds(kpahed091 : 5) pahed091;

       kpahexx.t0empr = peBase.peEmpr;
       kpahexx.t0sucu = peBase.peSucu;
       kpahexx.t0arcd = d0arcd;
       kpahexx.t0spol = peSpol;
       kpahexx.t0rama = peRama;
       kpahexx.t0arse = d0arse;
       kpahexx.t0oper = d0oper;
       kpahexx.t0poco = pePoco;
       kpahexx.t0sspo = peSspo;

       select;

          when peGrupo = 'A';
             setll %kds(kpahexx : 9) pahet002;
             reade %kds(kpahexx : 8) pahet002;
             if not %eof(pahet002);
                return t0sspo;
             else;
                return -1;
             endif;

          other;
             setll %kds(kpahexx : 9) paher002;
             reade %kds(kpahexx : 8) paher002;
             if not %eof(paher002);
                return r0sspo;
             else;
                return -1;
             endif;

       endsl;

     P WSLCER_getUltSspo...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_getParmBase():   Retorna Parametros Base para el ca-  *
      *                         so de ser invocados los procedimien- *
      *                         tos en forma interna.                *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                peRama  -  Rama                               *
      *                pePoli  -  Poliza                             *
      *                peSpol  -  Superpoliza                        *
      *                peSspo  -  Suplemento Superpoliza             *
      *                pePoco  -  Componente                         *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     P WSLCER_getParmBase...
     P                 B                   export
     D WSLCER_getParmBase...
     D                 pi
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peBase                            likeds(paramBase)

     D kpahed091       ds                  likerec(p1hed0:*key)
     D kpahec1         ds                  likerec(p1hec1:*key)

       WSLCER_inz();

       kpahed091.d0empr = peEmpr;
       kpahed091.d0sucu = peSucu;
       kpahed091.d0rama = peRama;
       kpahed091.d0poli = pePoli;
       kpahed091.d0spol = peSpol;

       setll %kds(kpahed091 : 5) pahed091;

       reade %kds(kpahed091 : 5) pahed091;


       kpahec1.c1empr = peEmpr;
       kpahec1.c1sucu = peSucu;
       kpahec1.c1arcd = d0arcd;
       kpahec1.c1spol = peSpol;
       kpahec1.c1sspo = peSspo;

       chain %kds(kpahec1 : 5) pahec1;

       peBase.peEmpr = c1empr;
       peBase.peSucu = c1sucu;
       peBase.peNivt = c1nivt;
       peBase.peNivc = c1nivc;

     P WSLCER_getParmBase...
     P                 E
      * ------------------------------------------------------------ *
      * WSLCER_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P WSLCER_inz      B                   export
     D WSLCER_inz      pi

       if (initialized);
          return;
       endif;

       if not %open(pahed091);
         open pahed091;
       endif;

       if not %open(pahet9);
         open pahet9;
       endif;

       if not %open(paher9);
         open paher9;
       endif;

       if not %open(pahet002);
         open pahet002;
       endif;

       if not %open(paher002);
         open paher002;
       endif;

       if not %open(pahev001);
         open pahev001;
       endif;

       if not %open(paher02);
         open paher02;
       endif;

       if not %open(paher2);
         open paher2;
       endif;

       if not %open(paher0);
         open paher0;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(pahed0);
         open pahed0;
       endif;

       if not %open(pahec1);
         open pahec1;
       endif;

       if not %open(sehase01);
         open sehase01;
       endif;

       if not %open(gntloc);
         open gntloc;
       endif;

       if not %open(pahet0);
         open pahet0;
       endif;

       if not %open(set205);
         open set205;
       endif;

       if not %open(set225);
         open set225;
       endif;

       if not %open(gnhdaf);
         open gnhdaf;
       endif;

       if not %open(set210);
         open set210;
       endif;

       if not %open(set208);
         open set208;
       endif;

       if not %open(set211);
         open set211;
       endif;

       if not %open(set2252);
         open set2252;
       endif;

       if not %open(set124);
         open set124;
       endif;

       if not %open(set061);
         open set061;
       endif;

       if not %open(set107);
         open set107;
       endif;

       if not %open(set162);
         open set162;
       endif;

       if not %open(set101);
         open set101;
       endif;

       if not %open(gntemp);
         open gntemp;
       endif;

       if not %open(pahccw);
         open pahccw;
       endif;

       initialized = *ON;
       return;

     P WSLCER_inz      E
      * ------------------------------------------------------------ *
      * WSLCER_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P WSLCER_End      B                   export
     D WSLCER_End      pi

       close *all;
       initialized = *OFF;

       return;

     P WSLCER_End      E
      * ------------------------------------------------------------ *

**   TIPO - Vehículos que tienen tratamiento especial.
111213141516171819202122242628
