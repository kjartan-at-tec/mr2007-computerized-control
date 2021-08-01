(TeX-add-style-hook
 "block-cascade-control"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("fontenc" "T1") ("circuitikz" "american" "siunitx")))
   (TeX-run-style-hooks
    "latex2e"
    "standalone"
    "standalone10"
    "inputenc"
    "fontenc"
    "graphicx"
    "amsmath"
    "circuitikz")
   (LaTeX-add-environments
    '("exercise" LaTeX-env-args ["argument"] 0)))
 :latex)

