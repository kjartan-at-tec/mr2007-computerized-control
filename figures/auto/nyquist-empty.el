(TeX-add-style-hook
 "nyquist-empty"
 (lambda ()
   (TeX-run-style-hooks
    "latex2e"
    "standalone"
    "standalone10"
    "amsmath"
    "tikz"
    "pgf"
    "pgfplots"))
 :latex)

