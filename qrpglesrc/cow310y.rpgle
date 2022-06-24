     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt:*noshowcpy)
      * ************************************************************ *
      * COW310Y: QUOM Web                                            *
      *          Rechazar propuesta web                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *18-Ene-2016            *
      * ************************************************************ *
      *                                                              *
      * ************************************************************ *
     Fctw000    if   e           k disk
     Fctwmsg    if a e           k disk
     Fsehni201  if   e           k disk
     Fset630    if   e           k disk
     Fcow310ym  cf   e             workstn

     D COW310Y         pr                  extpgm('COW310Y')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const

     D COW310Y         pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const

     D PAR310Y         pr                  extpgm('PAR310Y')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpo1                        9  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const
     D  peEpgm                        3a   const
     D  peVspw                        1a   options(*nopass) const

     D lpar310         s              1a

     D PsDs           sds                  qualified
     D  CurUsr                       10a   overlay(PsDs:358)

     C                   eval      *inlr = *on
     C                   exsr      carg00
     C                   dow       not *inkl
     C                   exsr      pant01
     C                   enddo
     C                   if        lpar310 = 'S'
     C                   callp     par310y( peEmpr
     C                                    : peSucu
     C                                    : w0arcd
     C                                    : w0spo1
     C                                    : w0spol
     C                                    : w0sspo
     C                                    : 'FIN'
     C                                    : t@ma44 )
     C                   endif
     C                   return

     C     carg00        begsr
     C     k1w000        chain     ctw000
     C                   if        not %found
     C                   eval      *inkl = *on
     C                   leavesr
     C                   endif
     C     k1hni2        chain     sehni201                           20
     C   20              eval      x1nomb = *all'*'
     C  n20              eval      x1nomb = dfnomb

     C                   eval      x1soln = w0soln
     C                   eval      x1nivt = peNivt
     C                   eval      x1nivc = peNivt
     C                   eval      x1arcd = w0arcd
     C                   eval      x1spol = w0spol

     C     w0arcd        chain     set630                             20
     C   20              eval      t@ma44 = '0'

     C                   endsr

     C     pant01        begsr
     C                   exfmt     cow31001
     C                   exsr      apagar
     C                   select
     C                   when      *inka
     C                   exsr      vali01
     C                   if        not *in50
     C                   exsr      grab01
     C                   exsr      grabmg
     C                   eval      *inkl = *on
     C                   endif
     C                   when      *inkl
     C                   other
     C                   exsr      vali01
     C                   endsl
     C                   endsr

     C     apagar        begsr
     C                   setoff                                       5051
     C                   endsr

     C     vali01        begsr
     C                   if        %len(%trim(x1txmg)) < 3
     C                   eval      *in50 = *on
     C                   eval      *in51 = *on
     C                   endif
     C                   endsr

     C     grab01        begsr
     C                   callp     par310y( peEmpr
     C                                    : peSucu
     C                                    : w0arcd
     C                                    : w0spo1
     C                                    : w0spol
     C                                    : w0sspo
     C                                    : *blanks
     C                                    : t@ma44 )
     C                   eval      lpar310 = 'S'
     C                   endsr

     C     grabmg        begsr
     C     k1wmsg        setgt     ctwmsg
     C     k1wmsg        readpe    ctwmsg
     C                   if        %eof
     C                   eval      msivse  = 1
     C                   else
     C                   eval      msivse += 1
     C                   endif
     C                   eval      msempr = peEmpr
     C                   eval      mssucu = peSucu
     C                   eval      msnivt = peNivt
     C                   eval      msnivc = peNivc
     C                   eval      msnctw = peNctw
     C                   eval      mscpgm = 'COW000'
     C                   eval      mstxmg = x1txmg
     C                   eval      msmar1 = '0'
     C                   eval      msmar2 = '0'
     C                   eval      msmar3 = '0'
     C                   eval      msmar4 = '0'
     C                   eval      msmar5 = '0'
     C                   eval      msuser = PsDs.CurUsr
     C                   eval      msdate = %dec(%date():*iso)
     C                   eval      mstime = %dec(%time():*iso)
     C                   write     c1wmsg
     C                   endsr

     C     *inzsr        begsr
     C     k1w000        klist
     C                   kfld                    peEmpr
     C                   kfld                    peSucu
     C                   kfld                    peNivt
     C                   kfld                    peNivc
     C                   kfld                    peNctw
     C     k1hni2        klist
     C                   kfld                    peEmpr
     C                   kfld                    peSucu
     C                   kfld                    peNivt
     C                   kfld                    peNivc
     C     k1wmsg        klist
     C                   kfld                    peEmpr
     C                   kfld                    peSucu
     C                   kfld                    peNivt
     C                   kfld                    peNivc
     C                   kfld                    peNctw
     C                   endsr

