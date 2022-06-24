     h Dftactgrp(*No)
     h option(*srcstmt: *nodebugio: *noshowcpy)
     h bnddir('HDIILE/HDIBDIR')
      **---------------------------------------------------------**
      *  Sistema       : CONSULTAS WEB
      *  Origen        : Software local
      *  Programa      : COW121
      *  Programacion  : Sergio Luis Puentes Valladares
      *  Fecha         : 2020/01/20
      *  Abr.Dev.      :
      *  Objetivo      : Consulta de Cotizaciones de Vehiculos
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
      *  COW121FM   Consulta de Cotizaciones de Vehiculos         DSPF
      *  CTW000     Cotización Web: Cabecera de Cotizaciones      PF
      *  CTWET0     Cotización Web: Cabecera Vehículos            PF
      *  CTWETC     Cotización Web: Coberturas                    PF
      *  SET205     Tabla de Carrocerias                          PF
      *  SET210     Tabla de Tipo de vehículos                    PF
      *  SET211     Tabla de Uso de Vehículos                     PF
      *  SET225     Tabla de Coberturas autos                     PF
      *
      **---------------------------------------------------------**
      *  Ind        Uso
      *
      *
      *
      **---------------------------------------------------------**
     * Define Archivos
      **---------------------------------------------------------**
     fcow121fm  cf   e             Workstn
     f                                     Sfile(Cow121cs1:NrSfl)
     f                                     Sfile(Cow121cs2:RrSfl)
     f                                     InfDs(Iofb)
     fctwet0    if   e           k Disk
     fctwetc    if   e           k Disk
     fctw000    if   e           k Disk
     fset205    if   e           k Disk
     fset210    if   e           k Disk
     fset211    if   e           k Disk
     fset225    if   e           k Disk
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
     d  xRama1                        2s 0
     d  xPoco1                        4s 0
     d  xArse1                        2s 0

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
     d  pePoco2                       4a
     d  peCobl2                       2a
     d  peErro2                      10i 0
     d  peMsgs2                      80a

     d  peEmpr3                       1a
     d  peSucu3                       2a
     d  peNivt3                       1a
     d  peNivc3                       5a
     d  peNctw3                       7a
     d  peRama3                       2a
     d  pePoco3                       4a
     d  peArse3                       2a
     d  peCobl3                       2a
     d  peErro3                      10i 0
     d  peMsgs3                      80a

     d  peEmpr4                       1a
     d  peSucu4                       2a
     d  peNivt4                       1a
     d  peNivc4                       5a
     d  peNctw4                       7a
     d  peRama4                       2a
     d  pePoco4                       4a
     d  peArse4                       2a
      * peErro4= 0 -> OK
      * peErro4= -1 -> NO OK
     d  peErro4                      10i 0
     d  peMsgs4                      80a

     d  peEmpr5                       1a
     d  peSucu5                       2a
     d  peNivt5                       1a
     d  peNivc5                       5a
     d  peNctw5                       7a
     d  peRama5                       2a
      * peErro5= 0 -> OK
      * peErro5= -1 -> NO OK
     d  peErro5                      10i 0
     d  peMsgs5                      80a

      *---------------------------------------------------------------*
     * Define Constantes de Programa
      *---------------------------------------------------------------*
     d up              c                   'ABCDEFGHIJKLMNNOPQRSTUVWXY-
     d                                     ZAEIOUAEIOUNAEIOU'
     d lo              c                   'abcdefghijklmn¤opqrstuvwxy-
     d                                     z ?¡¢£???"¥µÖàé'

      *----------------------------------------------------------------*
     * Define copys
      *----------------------------------------------------------------*
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'

      *----------------------------------------------------------------*
     * Define klist de archivos
      *----------------------------------------------------------------*
     d k1twet0         ds                  likerec(C1wet0:*key)
     d k1twetc         ds                  likerec(C1wetc:*key)
     d k1tw000         ds                  likerec(C1w000:*key)
     d k1t205          ds                  likerec(S1t205:*key)
     d k1t210          ds                  likerec(S1t210:*key)
     d k1t211          ds                  likerec(S1t211:*key)
     d k1t225          ds                  likerec(S1t225:*key)

      *----------------------------------------------------------------*
     * Define programas invocados
      *----------------------------------------------------------------*
     d Main            pr                  ExtPgm('COW121    ')
     d  peEmpr                        1a   const
     d  peSucu                        2a   const
     d  peNivt                        1a   const
     d  peNivc                        5a   const
     d  peNctw                        7a   const
     d  peRama                        2a   const
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro                       10i 0
     d  peMsgs                       80a

     d Cobertura       pr                  ExtPgm('COW122    ')
     d  peEmpr1                       1a   const
     d  peSucu1                       2a   const
     d  peNivt1                       1a   const
     d  peNivc1                       5a   const
     d  peNctw1                       7a   const
     d  peRama1                       2a   const
     d  pePoco1                       4a   const
     d  peArse1                       2a   const
     d  peCobl1                       2a   const
      * peErro1= 0 -> OK
      * peErro1= -1 -> NO OK
     d  peErro1                      10i 0
     d  peMsgs1                      80a

     d DesctoRecargo   pr                  ExtPgm('COW123    ')
     d  peEmpr2                       1a   const
     d  peSucu2                       2a   const
     d  peNivt2                       1a   const
     d  peNivc2                       5a   const
     d  peNctw2                       7a   const
     d  peRama2                       2a   const
     d  peArse2                       2a   const
     d  pePoco2                       4a   const
     d  peCobl2                       2a   const
      * peErro2= 0 -> OK
      * peErro2= -1 -> NO OK
     d  peErro2                      10i 0
     d  peMsgs2                      80a

     d Scoring         pr                  ExtPgm('COW124    ')
     d  peEmpr3                       1a   const
     d  peSucu3                       2a   const
     d  peNivt3                       1a   const
     d  peNivc3                       5a   const
     d  peNctw3                       7a   const
     d  peRama3                       2a   const
     d  pePoco3                       4a   const
     d  peArse3                       2a   const
      * peErro3= 0 -> OK
      * peErro3= -1 -> NO OK
     d  peErro3                      10i 0
     d  peMsgs3                      80a

     d Accesorios      pr                  ExtPgm('COW125    ')
     d  peEmpr4                       1a   const
     d  peSucu4                       2a   const
     d  peNivt4                       1a   const
     d  peNivc4                       5a   const
     d  peNctw4                       7a   const
     d  peRama4                       2a   const
     d  pePoco4                       4a   const
     d  peArse4                       2a   const
      * peErro4= 0 -> OK
      * peErro4= -1 -> NO OK
     d  peErro4                      10i 0
     d  peMsgs4                      80a

     d Inspeccion      pr                  ExtPgm('COW126    ')
     d  peEmpr5                       1a   const
     d  peSucu5                       2a   const
     d  peNivt5                       1a   const
     d  peNivc5                       5a   const
     d  peNctw5                       7a   const
     d  peRama5                       2a   const
      * peErro5= 0 -> OK
      * peErro5= -1 -> NO OK
     d  peErro5                      10i 0
     d  peMsgs5                      80a

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
      * peErro = 0 -> OK
      * peErro = -1 -> NO OK
     d  peErro                       10i 0
     d  peMsgs                       80a

      *----------------------------------------------------------------*
     * Define renombre de campos
      *----------------------------------------------------------------*
     IS1t225
     I              T@Date                      t@Fech

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
                Write  Cow121cca;
                Write  Cow121cp1;
                Exfmt  Cow121cc1;

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
                Write  Cow121cca;
                Write  Cow121cp1;
                Exfmt  Cow121cc2;

                // F12 = volver
                If  Wkypres  = F12;
                    xxpoco   = 0;
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
              If xxPoco <> *Zeros;
                 // Carga data de Subfile
                 If xxPoco <= Wsftot1;
                    Exsr ChgDtaSfl1;
                    LeaveSr;
                 EndIf;
              EndIf;

              // Valida datos
              For xCiclo = 1  to WsfNum1;
                  NrSfl = xCiclo;
                  Chain xCiclo  Cow121cs1;
                      If x1Opci <> *Zeros;
                         // Opciones
                         Select;
                           // Consulta
                           When x1Opci = 5;
                                xData = '1';
                                xEmpr = x1Empr;
                                xSucu = x1Sucu;
                                xNivt = x1Nivt;
                                xNivc = x1Nivc;
                                xNctw = xxNctw;
                                xRama = x1Rama;
                                xPoco = x1Poco;
                                xArse = x1Arse;
                                Clear  x1Opci;
                                Update Cow121cs1;
                                Leave;
                           // Scoring
                           When x1Opci = 6;
                                peNivt3 = %Editc(x1Nivt:'X');
                                peNivc3 = %Editc(x1Nivc:'X');
                                peNctw3 = %Editc(x1Nctw:'X');
                                peRama3 = %Editc(x1Rama:'X');
                                pePoco3 = %Editc(x1Poco:'X');
                                peArse3 = %Editc(x1Arse:'X');
                                Scoring(x1Empr :
                                        x1Sucu :
                                        peNivt :
                                        peNivc :
                                        peNctw :
                                        peRama3:
                                        pePoco3:
                                        peArse3:
                                        peErro3:
                                        peMsgs3);
                                Clear  x1Opci;
                                Update Cow121cs1;
                                Leave;
                           // Accesorios
                           When x1Opci = 7;
                                peNivt4 = %Editc(x1Nivt:'X');
                                peNivc4 = %Editc(x1Nivc:'X');
                                peNctw4 = %Editc(x1Nctw:'X');
                                peRama4 = %Editc(x1Rama:'X');
                                pePoco4 = %Editc(x1Poco:'X');
                                peArse4 = %Editc(x1Arse:'X');
                                Accesorios(x1Empr :
                                           x1Sucu :
                                           peNivt :
                                           peNivc :
                                           peNctw :
                                           peRama4:
                                           pePoco4:
                                           peArse4:
                                           peErro4:
                                           peMsgs4);
                                Clear  x1Opci;
                                Update Cow121cs1;
                                Leave;
                           // Inspecciones/Rastreadores
                           When x1Opci = 8;
                                peNivt5 = %Editc(x1Nivt:'X');
                                peNivc5 = %Editc(x1Nivc:'X');
                                peNctw5 = %Editc(x1Nctw:'X');
                                peRama5 = %Editc(x1Rama:'X');
                                Inspeccion(x1Empr :
                                           x1Sucu :
                                           peNivt :
                                           peNivc :
                                           peNctw :
                                           peRama5:
                                           peErro5:
                                           peMsgs5);
                                Clear  x1Opci;
                                Update Cow121cs1;
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
                  Chain xCiclo  Cow121cs2;
                    If x1Opci <> *Zeros;
                      Select;
                        // Cobertura
                        When x1Opci = 1;
                           peNivt1 = %Editc(x1Nivt:'X');
                           peNivc1 = %Editc(x1Nivc:'X');
                           peNctw1 = %Editc(x1Nctw:'X');
                           peRama1 = %Editc(x1Rama:'X');
                           pePoco1 = %Editc(x1Poco:'X');
                           peArse1 = %Editc(x1Arse:'X');
                           peCobl1 = x1Cobl;
                           Cobertura(x1Empr :
                                     x1Sucu :
                                     peNivt :
                                     peNivc :
                                     peNctw :
                                     peRama1:
                                     pePoco1:
                                     peArse1:
                                     peCobl1:
                                     peErro1:
                                     peMsgs1);
                            Clear  x1Opci;
                            update Cow121cs2;
                            Leave;
                        // Descuentos y/o Recargos
                        When x1Opci = 2;
                           peNivt2 = %Editc(x1Nivt:'X');
                           peNivc2 = %Editc(x1Nivc:'X');
                           peNctw2 = %Editc(x1Nctw:'X');
                           peRama2 = %Editc(x1Rama:'X');
                           peArse2 = %Editc(x1Arse:'X');
                           pePoco2 = %Editc(x1Poco:'X');
                           peCobl2 = x1Cobl;
                           DesctoRecargo(x1Empr :
                                         x1Sucu :
                                         peNivt :
                                         peNivc :
                                         peNctw :
                                         peRama2:
                                         peArse2:
                                         pePoco2:
                                         peCobl2:
                                         peErro2:
                                         peMsgs2);
                            Clear  x1Opci;
                            update Cow121cs2;
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
              Write Cow121cc1;
              *in30 = '1';
              *in31 = '0';
              *in32 = '1';

              // Inicializa variables de Subfile
              NrSfl       = *Zeros;

              // Posicionamiento
              // asigna campos clave
              Clear k1twet0;
              k1twet0.t0empr = peEmpr;
              k1twet0.t0sucu = peSucu;
              k1twet0.t0nivt = %Dec(peNivt:1:0);
              k1twet0.t0nivc = %Dec(peNivc:5:0);
              k1twet0.t0nctw = %Dec(peNctw:7:0);
              If xxPoco = *Zeros;
                 // Posicionamiento
                 Setll %kds(k1twet0:5) CTwet0;
                 // Lectura de CTwet0
                 Reade %kds(k1twet0:5) CTwet0;
              Else;
                 k1twet0.t0rama = xRama1;
                 k1twet0.t0poco = xxPoco;
                 // Posicionamiento
                 Setll %kds(k1twet0:7) CTwet0;
                 // Lectura de CTwet0
                 Reade %kds(k1twet0:6) CTwet0;
              Endif;

              // Carga Subfile - Principal
              Dow Not %Eof(CTwet0);
                  Clear Cow121cs1;
                     // Carga datos
                     x1Nivt  = t0Nivt;
                     x1Nivc  = t0Nivc;
                     x1Poco  = t0Poco;
                     x1Vhde  = t0Vhde;

                     // Carga campos keys
                     x1Empr  = t0Empr;
                     x1Sucu  = t0Sucu;
                     x1Rama  = t0Rama;
                     x1Arse  = t0Arse;

                     // Guarda Rama
                     xRama1  = t0Rama;

                  NrSfl += 1;
                  Write Cow121cs1;
                  // Lectura de CTwet0
                  If xxPoco = *Zeros;
                     Reade %kds(k1twet0:5) CTwet0;
                  Else;
                     Reade %kds(k1twet0:6) CTwet0;
                  Endif;
              EndDo;

              //  Verifica, si cargo subfile
              If NrSfl = 0;
                 NrSfl += 1;
                 Write Cow121cs1;
              EndIf;

              //  Posiciona Record Subfile number, inicio
              xxPoco  = 0;
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
              Write Cow121cc2;
              *in33 = '1';
              *in34 = '0';
              *in35 = '1';

              // Inicializa variables de Subfile
              RrSfl       = *Zeros;

              // Carga datos en control
              Exsr ChgDtaTab1;

              // Posicionamiento
              // asigna campos clave
              Clear k1twetc;
              k1twetc.t0empr = xEmpr;
              k1twetc.t0sucu = xSucu;
              k1twetc.t0nivt = xnivt;
              k1twetc.t0nivc = xnivc;
              k1twetc.t0nctw = xnctw;
              k1twetc.t0rama = xrama;
              k1twetc.t0arse = xarse;
              k1twetc.t0poco = xpoco;
              // Posicionamiento
              Setll %kds(k1twetc:8) CTwetc;
              // Lectura de CTwet0
              Reade %kds(k1twetc:8) CTwetc;

              // Carga Subfile - Principal
              Dow Not %Eof(CTwetc);
                    Clear Cow121cs2;
                     // Carga datos
                     x1Empr  = T0Empr;
                     x1Sucu  = T0Sucu;
                     x1Nivt  = T0Nivt;
                     x1Nivc  = T0Nivc;
                     x1Nctw  = T0Nctw;
                     x1Rama  = T0Rama;
                     x1Arse  = T0Arse;
                     x1Poco  = T0Poco;
                     x1Cobl  = T0Cobl;
                     // Lectura de archivo set225
                        Clear k1t225;
                        k1t225.t@cobl = t0Cobl;
                        Chain %kds(k1t225) Set225;
                        x1cobd = t@cobd;
                     x1Cobs  = 'S';
                     if T0Cobs = '0';
                        x1Cobs = 'N';
                     EndIf;
                     x1Rras  = T0Rras;
                     x1Rins  = T0Rins;
                    RrSfl += 1;
                    Write Cow121cs2;
                  // Lectura de CTwetc
                  Reade %kds(k1twetc:8) CTwetc;
              EndDo;

              //  Verifica, si cargo subfile
              If RrSfl = 0;
                 *in40  = *on;
                 RrSfl += 1;
                 Write Cow121cs2;
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
         //* ChgDtaTab1 - Rutina carga datos de Tabla CTwet0     *
         //*--------------------------------------------------------*
          BegSr  ChgDtaTab1;

              // Inicializa registro
              Clear C1WET0;

              // Posicionamiento
              Clear k1twet0;
              k1twet0.t0empr = xEmpr;
              k1twet0.t0sucu = xSucu;
              k1twet0.t0nivt = xnivt;
              k1twet0.t0nivc = xnivc;
              k1twet0.t0nctw = xnctw;
              k1twet0.t0rama = xrama;
              k1twet0.t0poco = xpoco;
              k1twet0.t0arse = xarse;
              // Lectura de archivo CTwet0
              Chain %kds(k1twet0) CTwet0;

              // Carga datos en form - Pantalla
              xxPoco = t0Poco;
              xxVhmc = t0Vhmc;
              xxVhmo = t0Vhmo;
              xxVhcs = t0Vhcs;
              xxVhde = t0Vhde;
              xxVhcr = t0Vhcr;
                // Lectura de archivo set205
                Clear k1t205;
                k1t205.t@vhcr = t0vhcr;
                  Chain %kds(k1t205) Set205;
                  xdVhcr = t@vhcd;
              xxTmat = t0Tmat;
              xxNmat = t0Nmat;
              xxVhan = t0Vhan;
              xxVhni = t0Vhni;
              xxMoto = t0Moto;
              xxChas = t0Chas;
              xxVhca = t0Vhca;
              xxVhv1 = t0Vhv1;
              xxVhv2 = t0Vhv2;
              xxMtdf = t0Mtdf;
              xxVhct = t0Vhct;
                // Lectura de archivo set210
                Clear k1t210;
                k1t210.t@vhct = t0vhct;
                  Chain %kds(k1t210) Set210;
                  xdVhct = t@vhdt;
              xxVhuv = t0Vhuv;
                // Lectura de archivo set211
                Clear k1t211;
                k1t211.t@vhuv = t0vhuv;
                  Chain %kds(k1t211) Set211;
                  xdVhuv = t@vhdu;
              xxVhvu = t0Vhvu;
              xxM0km = t0M0km;
              xxCopo = t0Copo;
              xxCops = t0Cops;
              xxScta = t0Scta;
              xxMgnc = t0Mgnc;
              xxRgnc = t0Rgnc;
              xxRuta = t0Ruta;
              xxTmat = t0Tmat;
              xxNmat = t0Nmat;
              xxCtre = t0Ctre;
              xxNmer = t0Nmer;
              xxAver = t0Aver;
              xxIris = t0Iris;
              xxCesv = t0Cesv;
              xxClin = t0Clin;
              xxAcrc = t0Acrc;
              xxDweb = t0Dweb;
              xxPweb = t0PWeb;

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
