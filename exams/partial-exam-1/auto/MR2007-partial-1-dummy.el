(TeX-add-style-hook
 "MR2007-partial-1-dummy"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper" "12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "latin1")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art12"
    "epsfig"
    "latexsym"
    "amsmath"
    "amssymb"
    "epic"
    "eepic"
    "psfrag"
    "subfigure"
    "float"
    "euscript"
    "array"
    "inputenc"
    "standalone"
    "tikz"
    "pgf"
    "pgfplots")
   (TeX-add-symbols
    '("mexp" 1)
    '("realdel" 1)
    '("point" 1)
    "abc"
    "bbm"
    "ebm"
    "ctrb"
    "Lap"
    "obsv"
    "imagdel"
    "bC"
    "bR"
    "bmpv"
    "bmps"
    "bmpm"
    "bmpl"
    "emp"
    "zethree"
    "OctaveG")
   (LaTeX-add-environments
    '("exercise" LaTeX-env-args ["argument"] 0))
   (LaTeX-add-counters
    "exerctr"
    "abcctr"))
 :latex)

