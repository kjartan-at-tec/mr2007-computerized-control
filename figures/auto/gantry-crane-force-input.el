(TeX-add-style-hook
 "gantry-crane-force-input"
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
    "setspace")
   (TeX-add-symbols
    "beamh"
    "beaml"
    "carth"
    "cartw"
    "cartpos"
    "thta"
    "cablel"
    "contw"
    "conth")
   (LaTeX-add-environments
    '("exercise" LaTeX-env-args ["argument"] 0)))
 :latex)

