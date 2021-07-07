(TeX-add-style-hook
 "nyquist-example"
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

