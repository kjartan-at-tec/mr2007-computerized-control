(TeX-add-style-hook
 "lsq-example-no-reg"
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
    "pgfplots"
    "pgfplotstable"))
 :latex)

