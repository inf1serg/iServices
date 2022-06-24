     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt)
     H bnddir('HDIILE/HDIBDIR')
     *****************************************************************
     *  COW00011: Consulta General de Cotizaciones Prima/Premio      *
     *                                                               *
     *  Alvarez Fernando                            *08/01/2016      *
     *                                                               *
     *****************************************************************
     * Modificaciones:                                               *
     *****************************************************************
     Fcow00011m cf   e             workstn
     Fctw000    if   e           k disk
     Fctw001    if   e           k disk
     Fctw001c   if   e           k disk
     Fsehni2    if   e           k disk
     Fgnhdaf    if   e           k disk
     *****************************************************************
     D COW000111       pr                  EXTPGM('COW00011')
     D    empr                        1    const
     D    sucu                        2    const
     D    nivt                        1  0 const
     D    nivc                        5  0 const
     D    nctw                        7  0 const
     D    rama                        2  0 const

     D COW000111       pi
     D  peEmpr                        1    const
     D  peSucu                        2    const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     *****************************************************************
     D @@base          ds                  likeds(paramBase)
     *****************************************************************
      /copy './qcpybooks/cowgrai_h.rpgle'
     *****************************************************************
     C                   eval      @@base.peEmpr = peEmpr
     C                   eval      @@base.peSucu = peSucu
     C                   eval      @@base.peNivt = peNivt
     C                   eval      @@base.peNivc = peNivc
     C     k1yni2        chain     sehni2
     C     n2nrdf        chain     gnhdaf
     C                   eval      xxnivt = peNivt
     C                   eval      xxnivc = peNivc
     C                   eval      xxnctw = peNctw
     C                   eval      xxnomb = dfnomb
     C     k1y000        chain     c1w000                                       |
     C                   eval      xxarcd = w0arcd
     C                   eval      xxspol = w0spol
     C     k1y001        chain     c1w001                                       |
     C     k1y001c       chain     c1w001c                                      |
1b C                   if        %found                                       ||
2b C                   dou       *inkl                                        ||:::::
     C                   exsr      borr01                                       ||    :
     C                   exsr      carg01                                       ||    :
     C                   exfmt     cow00011                                     ||    :
3b C                   select                                                 |||   :
3x C                   when      *inkl                                        |||   :
3x C                   when      not *in29                                    |||   :
     C                   eval      *inkl = '1'                                  |||   :
3e C                   endsl                                                  |||   :
2e C                   enddo                                                  ||:::::
1e C                   endif                                                  ||
     C                   seton                                            lr    |
     ******************************************************
     C     *inzsr        begsr                                                  |
     C     k1y000        klist                                                  |
     C                   kfld                    peEmpr                         |
     C                   kfld                    peSucu                         |
     C                   kfld                    peNivt                         |
     C                   kfld                    peNivc                         |
     C                   kfld                    peNctw                         |
     C     k1y001        klist                                                  |
     C                   kfld                    peEmpr                         |
     C                   kfld                    peSucu                         |
     C                   kfld                    peNivt                         |
     C                   kfld                    peNivc                         |
     C                   kfld                    peNctw                         |
     C                   kfld                    peRama                         |
     C     k1y001c       klist                                                  |
     C                   kfld                    peEmpr                         |
     C                   kfld                    peSucu                         |
     C                   kfld                    peNivt                         |
     C                   kfld                    peNivc                         |
     C                   kfld                    peNctw                         |
     C                   kfld                    peRama                         |
     C     k1yni2        klist
     C                   kfld                    peEmpr
     C                   kfld                    peSucu
     C                   kfld                    peNivt
     C                   kfld                    peNivc
     C                   endsr                                                  |
     ******************************************************
     C     borr01        begsr                                                  |
     C                   clear                   x1prim                         |
     C                   clear                   x1bpri                         |
     C                   clear                   x1neto                         |
     C                   clear                   x1read                         |
     C                   clear                   x1refi                         |
     C                   clear                   x1dere                         |
     C                   clear                   x1ipr2                         |
     C                   clear                   x1ipr5                         |
     C                   clear                   x1seri                         |
     C                   clear                   x1seem                         |
     C                   clear                   x1impi                         |
     C                   clear                   x1sers                         |
     C                   clear                   x1tssn                         |
     C                   clear                   x1ipr1                         |
     C                   clear                   x1ipr3                         |
     C                   clear                   x1ipr4                         |
     C                   clear                   x1ipr6                         |
     C                   clear                   x1ipr7                         |
     C                   clear                   x1ipr8                         |
     C                   clear                   x1ipr9                         |
     C                   clear                   x1subt                         |
     C                   clear                   x1prem                         |
     C                   clear                   xxprem                         |
     C                   clear                   xxipr9                         |
     C                   clear                   x1bpip                         |
     C                   clear                   x1xref                         |
     C                   clear                   x1xrea                         |
     C                   clear                   x1bpep                         |
     C                   clear                   x1pivi                         |
     C                   clear                   x1pivn                         |
     C                   clear                   x1pivr                         |
     C                   clear                   x1pimi                         |
     C                   clear                   x1psso                         |
     C                   clear                   x1pssn                         |
     C                   clear                   x1paga                         |
     C                   clear                   x1sald                         |
     C                   clear                   xxcome                         |
     C                   clear                   xxmone                         |
     C                   endsr                                                  |
     ******************************************************
     C     carg01        begsr                                                  |
     C                   eval      x1prim = COWGRAI_getPrimaRamaArse
     C                                      ( @@base : peNctw : peRama )
     C                   eval      x1bpri = *Zeros
     C                   eval      x1neto = x1prim - x1bpri                     |
     C                   eval      x1read = w1read                              |
     C                   eval      x1refi = w1refi                              |
     C                   eval      x1dere = w1dere                              |
     C                   eval      x1ipr2 = w1ipr2                              |
     C                   eval      x1ipr5 = w1ipr5                              |
     C                   eval      x1bpip = *Zeros                              |
     C                   eval      x1xrea = w1xrea                              |
     C                   eval      x1xref = w1xref                              |
     C                   eval      x1bpep = *Zeros                              |
     C     x1neto        add       x1read        x1subt                         |
     C                   add       x1refi        x1subt                         |
     C                   add       x1dere        x1subt                         |
     C                   eval      x1seri = w1seri                              |
     C                   eval      x1seem = w1seem                              |
     C                   eval      x1impi = w1impi                              |
     C                   eval      x1sers = w1sers                              |
     C                   eval      x1tssn = w1tssn                              |
     C                   eval      x1pimi = w1pimi                              |
     C                   eval      x1psso = w1psso                              |
     C                   eval      x1pssn = w1pssn                              |
     C                   eval      x1ipr1 = w1ipr1                              |
     C                   eval      x1ipr3 = w1ipr3                              |
     C                   eval      x1ipr4 = w1ipr4                              |
     C                   eval      x1pivi = w1pivi                              |
     C                   eval      x1pivn = w1pivn                              |
     C                   eval      x1pivr = w1pivr                              |
     C                   eval      x1ipr6 = w1ipr6                              |
     C                   eval      x1ipr7 = w1ipr7                              |
     C                   eval      x1ipr8 = w1ipr8                              |
     C                   eval      x1ipr9 = w1ipr9                              |
     C                   eval      x1prem = w1prem                              |
     C                   eval      xxmone = w0mone                              |
     C                   eval      xxcome = w0come                              |
     C                   endsr                                                  |
     ******************************************************
