     H actgrp(*caller) dftactgrp(*no)
     h DatFmt(*ISO) DatEdit(*DMY) DecEdit('0,')
     h Option(*Nodebugio) Debug(*Yes)
     H bnddir('HDIILE/HDIBDIR')
      **---------------------------------------------------------**
      *  Sistema       : CONSULTAS WEB
      *  Origen        : Software local
      *  Programa      : COW141
      *  Programacion  : Sergio Luis Puentes Valladares
      *  Fecha         : 2020/01/28
      *  Abr.Dev.      :
      *  Objetivo      : Consulta de Cotizaciones de Vida y AP
      *
      *
      *  Project Name  :
      *  Work ID       :

      **---------------------------------------------------------**
      *   Fecha    User    Modificacion
      **---------------------------------------------------------**
      *
      *
      *
      **---------------------------------------------------------**
      *  Objeto     D e s c r i p c i o n                         Tipo
      **---------------------------------------------------------**
      *  COW141FM   Consulta de Cotizaciones de Vida y AP         DSPF
      *  CTWEVC     Cotizacion Vida. Prima Actividades/Categoria  PF
      *  CTWEV1     Cotizacion Vida. Componentes                  PF
      *  CTW000     Cotización Web: Cabecera de Cotizaciones      PF
      *  SET069     VIDA: Tablas de Parentesco                    PF
      *  SET107     Coberturas                                    PF
      *
      **---------------------------------------------------------**
      *  Ind        Uso
      *
      *
      *
      **---------------------------------------------------------**
     * Define Archivos
      **---------------------------------------------------------**
     fcow141fm  cf   e             Workstn
     f                                     Sfile(Cow141cs1:NrSfl)
     f                                     Sfile(Cow141cs2:RrSfl)
     f                                     InfDs(Iofb)
     fctwevc    if   e           k Disk
     fctwev1    if   e           k Disk
     fctw000    if   e           k Disk
     fset069    if   e           k Disk
     fset107    if   e           k Disk
      *---------------------------------------------------------------*
     * Define Estructura de Programa
      *---------------------------------------------------------------*
     d Parms          sds
     d  WsProg                 1     10
     d  WsStat                11     15  0
     d  ErrMsi                40     46
     d  ErrMsg                91    169
     d  JobNam               244    253
     d  WsPant               244    253
     d  Userid               254    263
     d  JobNbr               264    269
      *---------------------------------------------------------------*
     * Define Estructura de Pantalla
      *---------------------------------------------------------------*
     d Iofb            DS
     d  Wpfopn                 9      9
     d  Wpfeof                10     10
     d  WMsgid                46     52
     d  Wkypres              369    369
     d  WCurso               370    371B 0
     d  WSrn                 376    377B 0
     d  WSrnb                378    379B 0
      *
     d  F01            c                   Const(X'31')
     d  F02            c                   Const(X'32')
     d  F03            c                   Const(X'33')
     d  F04            c                   Const(X'34')
     d  F05            c                   Const(X'35')
     d  F06            c                   Const(X'36')
     d  F07            c                   Const(X'37')
     d  F08            c                   Const(X'38')
     d  F09            c                   Const(X'39')
     d  F10            c                   Const(X'3A')
     d  F11            c                   Const(X'3B')
     d  F12            c                   Const(X'3C')
     d  F13            c                   Const(X'B1')
     d  F14            c                   Const(X'B2')
     d  F15            c                   Const(X'B3')
     d  F16            c                   Const(X'B4')
     d  F17            c                   Const(X'B5')
     d  F18            c                   Const(X'B6')
     d  F19            c                   Const(X'B7')
     d  F20            c                   Const(X'B8')
     d  F21            c                   Const(X'B9')
     d  F22            c                   Const(X'BA')
     d  F23            c                   Const(X'BB')
     d  F24            c                   Const(X'BC')
     d  Enter          c                   Const(X'F1')
     d  Help           c                   Const(X'F3')
     d  PageUp         c                   Const(X'F4')
     d  PageDn         c                   Const(X'F5')
     d  Print          c                   Const(X'F6')

      *---------------------------------------------------------------*
     * Define Variables de Programa
      *---------------------------------------------------------------*
     d xVariables      ds                  Inz
     d  xInd                          5s 0
     d  xPos                          5s 0
     d  xLine                         5s 0
     d  xCiclo                        5s 0

     d  xFormat                       2A
     d  xData                         1A
     d  xError                        1A

     d  xFecha                        8A
     d  xTime                         8A
     d  xFecha1                       8S 0
     d  xTime1                        8S 0
     d  xTime_S                      26A
     d  xTime0                        8A
     d  xFecha0                      10A
     d  xTime_Stamp    S               Z

      *---------------------------------------------------
     * Define Variables de Subfile
      *---------------------------------------------------
     d XSubfile        DS                  Inz
     d  NrSfl                         4S 0
     d  RrSfl                         4S 0
     d  SrSfl                         4S 0
     d  ZrSfl                         4S 0
     d  WsfNum1                       4S 0
     d  WsfNum2                       4S 0
     d  WsfNum3                       4S 0
     d  WsfNum4                       4S 0
     d  Wsftot1                       4S 0
     d  Wsftot2                       4S 0
     d  Wsftot3                       4S 0
     d  Wsftot4                       4S 0

      *---------------------------------------------------
     * Define Variables de Keys
      *---------------------------------------------------
     d xKey1           DS                  Inz
     d  xEMPR                         1a
     d  xSUCU                         2a
     d  xNIVT                         1s 0
     d  xNIVC                         5s 0
     d  xNCTW                         7s 0
     d  xRAMA                         2s 0
     d  xPOCO                         4s 0
     d  xARSE                         2s 0

      *---------------------------------------------------
     * Define parametros de programas invocados
      *---------------------------------------------------
     d xParms          DS                  Inz
     d  peEmpr1                       1a
     d  peSucu1                       2a
     d  peNivt1                       1a
     d  peNivc1                       5a
     d  peNctw1                       7a
     d  peRama1                       2a
     d  pePoco1                       4a
     d  peArse1                       2a
     d  peCobl1                       2a
     d  peErro1                      10i 0
     d  peMsgs1                      80a

     d  peEmpr2                       1a
     d  peSucu2                       2a
     d  peNivt2                       1a
     d  peNivc2                       5a
     d  peNctw2                       7a
     d  peRama2                       2a
     d  peArse2                       2a
     d  pePoco2                       6a
     d  pePaco2                       3a
     d  peErro2                      10i 0
     d  peMsgs2                      80a

     d  peEmpr3                       1a
     d  peSucu3                       2a
     d  peNivt3                       1a
     d  peNivc3                       5a
     d  peNctw3                       7a
     d  peRama3                       2a
     d  peArse3                       2a
     d  pePoco3                       6a
     d  pePaco3                       3a
     d  peErro3                      10i 0
     d  peMsgs3                      80a


      *---------------------------------------------------------------*
     * Define Copys
      *---------------------------------------------------------------*
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'

      *---------------------------------------------------------------*
     * Define Constantes de Programa
      *---------------------------------------------------------------*
     d up              c                   'ABCDEFGHIJKLMNNOPQRSTUVWXY-
     d                                     ZAEIOUAEIOUNAEIOU'
     d lo              c                   'abcdefghijklmn¤opqrstuvwxy-
     d                                     z ?¡¢£???"¥µÖàé'

      *----------------------------------------------------------------*
     * Define klist de archivos
      *----------------------------------------------------------------*
     D k1twevc         ds                  likerec(C1wevc:*key)
     D k1twev1         ds                  likerec(C1wev1:*key)
     d k1tw000         ds                  likerec(C1w000:*key)
     D k1t069          ds                  likerec(S1t069:*key)
     D k1t107          ds                  likerec(S1t107:*key)

      *----------------------------------------------------------------*
     * Define programas invocados
      *----------------------------------------------------------------*
     d Main            pr                  ExtPgm('COW141    ')
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peNivt                        1a   const
     d  peNivc                        5a   const
     d  peNctw                        7a   const
     d  peRama                        2a   const
     d  peArse                        2a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro                       10i 0
     d  peMsgs                       80a

     d Componentes     pr                  ExtPgm('COW142    ')
     d  peEmpr2                       1a   const
     d  peSucu2                       2a   const
     d  peNivt2                       1a   const
     d  peNivc2                       5a   const
     d  peNctw2                       7a   const
     d  peRama2                       2a   const
     d  peArse2                       2a   const
     d  pePoco2                       6a   const
     d  pePaco2                       3a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro2                      10i 0
     d  peMsgs2                      80a

     d Coberturas      pr                  ExtPgm('COW143    ')
     d  peEmpr3                       1a   const
     d  peSucu3                       2a   const
     d  peNivt3                       1a   const
     d  peNivc3                       5a   const
     d  peNctw3                       7a   const
     d  peRama3                       2a   const
     d  peArse3                       2a   const
     d  pePoco3                       6a   const
     d  pePaco3                       3a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro3                      10i 0
     d  peMsgs3                      80a

      *----------------------------------------------------------------*
     * Define parametros de programas invocados
      *----------------------------------------------------------------*
     d Main            pi
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peNivt                        1a   const
     d  peNivc                        5a   const
     d  peNctw                        7a   const
     d  peRama                        2a   const
     d  peArse                        2a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro                       10i 0
     d  peMsgs                       80a

      /Free
         //*--------------------------------------------------------*
         //*    C  u  e  r  p  o      P  r  i  n  c  i  p  a  l     *
         //*--------------------------------------------------------*
         // Inicializa variables
            Exsr RtvDtaSis;

         // Ciclo de Proceso - Paneles
            Dow xFormat <> *Blanks;
                Select;
                   When xFormat = '10';  // Panel Principal
                        Exsr HndDtaP10;
                   When xFormat = '20';  // Panel Componentes
                        Exsr HndDtaP20;
                EndSl;
            EndDo;

         // Fin de Programa
            *inlr = *On;

         //*--------------------------------------------------------*
         //* HndDtaP10 - Rutina Manejo Panel 10                     *
         //*--------------------------------------------------------*
          BegSr  HndDtaP10;

            // Inicializa variables de panel 10
            wMsg  = *Blanks;

            // Carga data de cabecera
            xxnivt = %Dec(peNivt:1:0);
            xxnivc = %Dec(peNivc:5:0);
            xxProd = SVPINT_GetNombre( peEmpr:
                                       peSucu:
                                       %Dec(peNivt:1:0):
                                       %Dec(peNivc:5:0));
            xxnctw = %Dec(peNctw:7:0);
            xxrama = %Dec(peRama:2:0);
            xxdram = SVPDES_rama( xxRama);
            // Carga data de cabecera
            Exsr RtvDtaCab;

            // Carga data de Subfile
            Exsr ChgDtaSfl1;

            // Ciclo Manejo Panel 10
            Dow xFormat = '10';

                // Despliega Subfile-Control
                Write  Cow141cca;
                Write  Cow141cp1;
                Exfmt  Cow141cc1;

                // F12 = Salir
                If  Wkypres  = F12;
                    xFormat  = *Blanks;
                EndIf;

                // Intro:Valida - Procesa
                If  Wkypres  = Enter;
                    Exsr ValDtaP10;
                    If   xError = *Blanks;
                         If  xData <> *Blanks;
                             xFormat  = '20';
                         EndIf;
                    EndIf;
                EndIf;

            EndDo;

          EndSr;

         //*--------------------------------------------------------*
         //* HndDtaP20 - Rutina Manejo Panel 20                     *
         //*--------------------------------------------------------*
          BegSr  HndDtaP20;

            // Inicializa variables de panel 20
            wMsg  = *Blanks;

            // Carga data de Subfile
            Exsr ChgDtaSfl2;

            // Ciclo Manejo Panel 20
            Dow xFormat = '20';

                // Despliega Subfile-Control
                Write  Cow141cca;
                Write  Cow141cp1;
                Exfmt  Cow141cc2;

                // F12 = volver
                If  Wkypres  = F12;
                    xxActi   = 0;
                    xFormat  = '10';
                EndIf;

                // Intro:Valida - Procesa
                If  Wkypres  = Enter;
                    Exsr ValDtaP20;
                EndIf;

            EndDo;

          EndSr;

         //*--------------------------------------------------------*
         //* ValDtaP10 - Rutina Valida Datos Panel 10               *
         //*--------------------------------------------------------*
          BegSr  ValDtaP10;
              // Inicializa variables
              Clear xData;
              Clear wMsg;
              Clear xError;
              Clear xKey1;

              // Posicionamiento en Subfile
              If xxActi <> *Zeros;
                 // Carga data de Subfile
                 If xxActi <= Wsftot1;
                    Exsr ChgDtaSfl1;
                    LeaveSr;
                 EndIf;
              EndIf;

              // Valida datos
              For xCiclo = 1  to WsfNum1;
                  NrSfl = xCiclo;
                  Chain xCiclo  Cow141cs1;
                      If x1Opci <> *Zeros;
                         // Opciones
                         Select;
                           // Consulta
                           When x1Opci = 5;
                                xData = '1';
                                Clear  x1Opci;
                                Update Cow141cs1;
                                Leave;
                           // Error
                           Other;
                            wMsg   = 'Error..Opcion ingresada es incorrecta';
                             xError = '1';
                             Leave;
                         EndSl;
                       EndIf;
               EndFor;
          EndSr;


         //*--------------------------------------------------------*
         //* ValDtaP20 - Rutina Valida Datos Panel 20               *
         //*--------------------------------------------------------*
          BegSr  ValDtaP20;
              // Inicializa variables
              Clear xData;
              Clear wMsg;
              Clear xError;
              Clear xKey1;

              // Valida datos
              For xCiclo = 1  to WsfNum2;
                  RrSfl = xCiclo;
                  Chain xCiclo  Cow141cs2;
                    If x1Opci <> *Zeros;
                      Select;
                        // Componentes
                        When x1Opci = 1;
                           peNivt2 = %Editc(x1Nivt:'X');
                           peNivc2 = %Editc(x1Nivc:'X');
                           peNctw2 = %Editc(x1Nctw:'X');
                           peRama2 = %Editc(x1Rama:'X');
                           peArse2 = %Editc(x1Arse:'X');
                           pePoco2 = %Editc(x1Poco:'X');
                           pePaco2 = %Editc(x1Paco:'X');
                           Componentes(x1Empr :
                                       x1Sucu :
                                       peNivt2:
                                       peNivc2:
                                       peNctw2:
                                       peRama2:
                                       peArse2:
                                       pePoco2:
                                       pePaco2:
                                       peErro2:
                                       peMsgs2);
                            Clear  x1Opci;
                            update Cow141cs2;
                            Leave;
                        // Coberturas
                        When x1Opci = 2;
                           peNivt3 = %Editc(x1Nivt:'X');
                           peNivt3 = %Editc(x1Nivt:'X');
                           peNivc3 = %Editc(x1Nivc:'X');
                           peNctw3 = %Editc(x1Nctw:'X');
                           peRama3 = %Editc(x1Rama:'X');
                           peArse3 = %Editc(x1Arse:'X');
                           pePoco3 = %Editc(x1Poco:'X');
                           pePaco3 = %Editc(x1Paco:'X');
                           Coberturas(x1Empr :
                                      x1Sucu :
                                      peNivt :
                                      peNivc :
                                      peNctw :
                                      peRama3:
                                      peArse3:
                                      pePoco3:
                                      pePaco3:
                                      peErro3:
                                      peMsgs3);
                            Clear  x1Opci;
                            update Cow141cs2;
                            Leave;
                        Other;
                          wMsg   = 'Error..Opcion ingresada es incorrecta';
                          xError = '1';
                          Leave;
                      EndSl;
                    EndIf;
               EndFor;
          EndSr;

         //*--------------------------------------------------------*
         //* ChgDtaSfl1 - Rutina Carga Datos Subfile 1              *
         //*--------------------------------------------------------*
          BegSr  ChgDtaSfl1;

              // Limpia Subfile
              *in30 = '0';
              *in31 = '1';
              Write Cow141cc1;
              *in30 = '1';
              *in31 = '0';
              *in32 = '1';

              // Inicializa variables de Subfile
              NrSfl       = *Zeros;

              // Posicionamiento
              // asigna campos clave
              Clear k1twevc;
              k1twevc.v0empr = peEmpr;
              k1twevc.v0sucu = peSucu;
              k1twevc.v0nivt = %Dec(peNivt:1:0);
              k1twevc.v0nivc = %Dec(peNivc:5:0);
              k1twevc.v0nctw = %Dec(peNctw:7:0);
              k1twevc.v0rama = %Dec(peRama:2:0);
              k1twevc.v0arse = %Dec(peArse:2:0);
              If xxActi = *Zeros;
                 // Posicionamiento
                 Setll %kds(k1twevc:7) CTwevc;
                 // Lectura de CTwevc
                 Reade %kds(k1twevc:7) CTwevc;
              Else;
                 k1twevc.v0acti = xxActi;
                 // Posicionamiento
                 k1twevc.v0acti = xxActi;
                 Setll %kds(k1twevc:8) CTwevc;
                 // Lectura de CTwer0
                 Reade %kds(k1twevc:7) CTwevc;
              Endif;

              // Carga Subfile - Principal
              Dow Not %Eof(CTwevc);
                  Clear Cow141cs1;
                     // Carga datos
                     x1Acti = v0Acti;
                     x1Secu = v0Secu;
                     x1Cate = v0Cate;
                     x1Cant = v0Cant;
                     x1Dact = svpdes_actividad(v0Acti);

                     // Carga campos keys
                     x1Empr = v0Empr;
                     x1Sucu = v0Sucu;
                     x1Rama = v0Rama;
                     x1Arse = v0Arse;

                  NrSfl += 1;
                  Write Cow141cs1;
                  // Lectura de CTwer0
                  Reade %kds(k1twevc:7) CTwevc;
              EndDo;

              //  Verifica, si cargo subfile
              If NrSfl = 0;
                 NrSfl += 1;
                 Write Cow141cs1;
              EndIf;

              //  Posiciona Record Subfile number, inicio
              xxActi  = 0;
              WsfNum1 = NrSfl;
              //  Guarda total de registros Subfile
              If Wsftot1 = *Zeros;
                 Wsftot1 = NrSfl;
              EndIf;
              NrSfl   = 1;

          EndSr;

         //*--------------------------------------------------------*
         //* ChgDtaSfl2 - Rutina Carga Datos Subfile 2              *
         //*--------------------------------------------------------*
          BegSr  ChgDtaSfl2;

              // Limpia Subfile
              *in33 = '0';
              *in34 = '1';
              Write Cow141cc2;
              *in33 = '1';
              *in34 = '0';
              *in35 = '1';

              // Inicializa variables de Subfile
              RrSfl       = *Zeros;

              // Carga datos en control
              Exsr ChgDtaTab1;

              // Posicionamiento
              // asigna campos clave
              Clear k1twev1;
              k1twev1.v1empr = peEmpr;
              k1twev1.v1sucu = peSucu;
              k1twev1.v1nivt = %Dec(peNivt:1:0);
              k1twev1.v1nivc = %Dec(peNivc:5:0);
              k1twev1.v1nctw = %Dec(peNctw:7:0);
              k1twev1.v1rama = %Dec(peRama:2:0);
              k1twev1.v1arse = %Dec(peArse:2:0);
              // Posicionamiento
              Setll %kds(k1twev1:7) CTwev1;
              // Lectura de CTwev1
              Reade %kds(k1twev1:7) CTwev1;

              // Carga Subfile - Principal
              Dow Not %Eof(CTwev1);
                    Clear Cow141cs2;
                     // Carga datos
                     x1Poco = v1Poco;
                     x1Paco = v1Paco;
                     // Lectura de archivo set069
                     Clear k1t069;
                     k1t069.t@paco = v1paco;
                     Chain %kds(k1t069) Set069;
                        x1Dpac = t@pade;
                     x1Nomb = v1Nomb;

                     // Carga campos keys
                     x1Empr = v1Empr;
                     x1Sucu = v1Sucu;
                     x1Rama = v1Rama;
                     x1Arse = v1Arse;
                     x1Nivt = v1Nivt;
                     x1Nivc = v1Nivc;
                     x1Nctw = v1Nctw;

                    RrSfl += 1;
                    Write Cow141cs2;
                  // Lectura de CTwev1
                  Reade %kds(k1twev1:7) CTwev1;
              EndDo;

              //  Verifica, si cargo subfile
              If RrSfl = 0;
                 *in40  = *on;
                 RrSfl += 1;
                 Write Cow141cs2;
              EndIf;

              //  Posiciona Record Subfile number, inicio
              WsfNum2 = RrSfl;
              RrSfl   = 1;
              //  Guarda total de registros Subfile
              If Wsftot2 = *Zeros;
                 Wsftot2 = RrSfl;
              EndIf;

          EndSr;

         //*--------------------------------------------------------*
         //* RtvDtaCab  - Rutina Recupera datos de Tabla CTw000     *
         //*--------------------------------------------------------*
          BegSr  RtvDtaCab;

              // Inicializa registro
              Clear C1W000;

              // Posicionamiento
              Clear k1tw000;
              k1tw000.w0empr = peEmpr;
              k1tw000.w0sucu = peSucu;
              k1tw000.w0nivt = %Dec(peNivt:1:0);
              k1tw000.w0nivc = %Dec(peNivc:5:0);
              k1tw000.w0nctw = %Dec(peNctw:7:0);
              // Lectura de archivo CTw000
              Chain %kds(k1tw000) CTw000;
                  xxArcd = W0Arcd;
                  xxArno = W0Arno;

          EndSr;

         //*--------------------------------------------------------*
         //* RtvDtaTab1 - Rutina Recupera datos de Tabla CTwer0     *
         //*--------------------------------------------------------*
          BegSr  ChgDtaTab1;

              // Inicializa registro
              Clear C1WEVC;

              // Posicionamiento
              Clear k1twevc;
              k1twevc.v0empr = x1Empr;
              k1twevc.v0sucu = x1Sucu;
              k1twevc.v0nivt = x1nivt;
              k1twevc.v0nivc = x1nivc;
              k1twevc.v0nctw = x1nctw;
              k1twevc.v0rama = x1rama;
              k1twevc.v0arse = x1arse;
              k1twevc.v0acti = x1acti;
              k1twevc.v0secu = x1secu;
              // Lectura de archivo CTwevc
              Chain %kds(k1twevc) CTwevc;

              // Carga datos en form - Pantalla
              xxActi = v0Acti;
              xxSecu = v0Secu;
              xxCate = v0Cate;
              xxCant = v0Cant;
              xxSuas = v0Suas;
              xxPrim = v0Prim;
              xxSeri = v0Seri;
              xxSeem = v0Seem;
              xxImpi = v0Impi;
              xxSers = v0Sers;
              xxTssn = v0Tssn;
              xxIpr1 = v0Ipr1;
              xxIpr4 = v0Ipr4;
              xxIpr3 = v0Ipr3;
              xxIpr6 = v0Ipr6;
              xxIpr7 = v0Ipr7;
              xxIpr8 = v0Ipr8;
              xxIpr9 = v0Ipr9;
              xxPrem = v0Prem;

          EndSr;

         //*--------------------------------------------------------*
         //* RtvPrmPrc - Rutina Recupera Parametros de Proceso      *
         //*--------------------------------------------------------*
          BegSr  RtvPrmPrc;

             // Recupera fecha de proceso
             xTime_Stamp = %Timestamp();
             xTime_S     = %Char(xTime_Stamp);
             xFecha      = %Subst(xTime_S:01:04)
                         + %Subst(xTime_S:06:02)
                         + %Subst(xTime_S:09:02);
             xFecha0     = %Subst(xTime_S:09:02) + '/'
                         + %Subst(xTime_S:06:02) + '/'
                         + %Subst(xTime_S:01:04);
             xTime       = %Subst(xTime_S:12:02)
                         + %Subst(xTime_S:15:02)
                         + %Subst(xTime_S:18:02)
                         + %Subst(xTime_S:21:02);
             xTime0      = %Subst(xTime_S:12:02)
                         + %Subst(xTime_S:15:02)
                         + %Subst(xTime_S:18:02)
                         + %Subst(xTime_S:21:02);
             xFecha1     = %Int(xFecha);
             xTime1      = %Int(xTime);

          EndSr;
         //*--------------------------------------------------------*
         //* RtvDtaSis - Rutina Inicial, Recupera datos de Sistema  *
         //*--------------------------------------------------------*
          BegSr  RtvDtaSis;

             //  Recupera Parametros de Proceso
             Exsr RtvPrmPrc;

             // Inicializa variables de programas
             xFormat = '10';

          EndSr;

      /End-Free
