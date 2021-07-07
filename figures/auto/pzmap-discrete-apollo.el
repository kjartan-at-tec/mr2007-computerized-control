(TeX-add-style-hook
 "pzmap-discrete-apollo"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fontenc" "T1") ("inputenc" "utf8")))
   (TeX-run-style-hooks
    "latex2e"
    "standalone"
    "standalone10"
    "fontenc"
    "inputenc"
    "pgf"
    "tikz"
    "setspace"
    "pgfplots")
   (TeX-add-symbols
    "pgfmathresult"
    "axlim"))
 :latex)

