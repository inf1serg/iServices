     H option(*nodebugio)
     * **************************************************************** *
     * COW000B: Consulta General de Cotizaciones Orden                  *
     *                                                                  *
     * Alvarez Fernando 30/09/2014                                      *
     * **************************************************************** *
     Fcow000bm  cf   e             workstn
     F                                     sfile(cow000bs1:sf1rrn)

     ** *Entry...
     D COW000B         pr                  EXTPGM('COW000B')
     D     fun                       10i 0
     D COW000B         pi
     D   peFun                       10i 0

     ** Variables...
     D msg1            s             25    dim(3) ctdata perrcd(1)
     D pgm1            s              2  0 dim(3) alt(msg1)
     D opc             s              1  0 dim(3)
     D pgm             s              2  0 dim(3)
     D sf1rrn          s              9  0                                      |
     D x               s              9  0                                      -----------*

     ** Local...
     D                uds
     D usempr                401    401
     D ussucu                402    403

     **...
     C                   eval      peFun = *Zeros
     C                   eval      xxiden = 1
     C                   dow       not *inkl
     C                   select
     C                   when      xxiden = 1
2b C                   exsr      pro001                                                  |
     C                   endsl
1e C                   enddo                                                  -----------*
     C                   eval      *inlr = *on                                  |
     C                   return                                                 |
     *****************************************************|
     C     pro001        begsr                                                  |
     C                   exsr      sf1car                                       |
     C                   exfmt     cow000bc1                                               |
2b C                   select                                                 ----------*|
2x C                   when      *in12                                                  /|
     C                   eval      peFun = 40                                             ||
2x C                   when      *in91                                                  ||
2x C                   other                                                            /|
     C                   exsr      vali01b                                                ||
     C  n50              exsr      sropc1                                                 ||
2e C                   endsl                                                  ----------*|
     C                   endsr                                                  |
     *****************************************************|
     C     sropc1        begsr                                                  |
1b C                   do        3             x                              -----------*
     C                   eval      opc(x) = *Zeros                                         |
     C                   eval      pgm(x) = *Zeros                                         |
1e C                   enddo                                                  -----------*
     C                   eval      *in70 = *off                                 |
1b C                   do        3             sf1rrn                         -----------*
     C     sf1rrn        chain     cow000bs1                          70                   |
2b C                   if        not *in70                                    ----------*|
3b C                   if        sfopci <> *zeros                             ---------*||
     C                   z-add     sf1rrn        x                        16             |||
     C                   eval      opc(x) = sfopci                                       |||
     C                   eval      pgm(x) = sfpgmr                                       |||
3e C                   endif                                                  ---------*||
2e C                   endif                                                  ----------*|
1e C                   enddo                                                  -----------*
     ** - Opciones de Proceso.                            |
1b C                   do        3             x                              -----------*
2b C                   if        opc(x) = 1  and                              ----------*|
     C                             pgm(x) <> *Zeros                                       ||
     C                   eval      peFun = pgm(x)                                         ||
     C                   eval      *inkl = *On                                            ||
2e C                   endif                                                  ----------*|
1e C                   enddo                                                  -----------*
     C                   endsr                                                  |
     *****************************************************|
     C     vali01b       begsr                                                  |
     C                   movea     '00'          *in(50)                        |
     C                   endsr                                                  |
     *****************************************************|
     C     sf1car        begsr                                                  |
     C                   setoff                                         3031    |
     C                   seton                                          32      |
     C                   write     cow000bc1                                    |
     C                   setoff                                         32      |
     C                   seton                                          31      |
     C                   eval      sf1rrn = *zeros                              |
1b C                   do        3             x                              -----------*
     C                   eval      sfopci = *zeros                                         |
     C                   eval      sfdptr = msg1(x)                                        |
     C                   eval      sfpgmr = pgm1(x)                                        |
2b C                   if        pgm1(x) = *Zeros                             ----------*|
     C                   eval      *in40 = *on                                            ||
2x C                   else                                                             /|
     C                   eval      *in40 = *off                                           ||
2e C                   endif                                                  ----------*|
     C                   add       1             sf1rrn                                    |
     C                   write     cow000bs1                                               |
     C                   seton                                            30               |
1e C                   enddo                                                  -----------*
     C                   eval      *in33 = *on                                  |
     C                   endsr                                                  |
     *****************************************************|
** .+....1....+....2....+....3....+....4....+....1
 Intermediario           40         - 40
 Numero de Cotizacion    41         - 41
 Articulo/SuperPoliza    43         - 43
