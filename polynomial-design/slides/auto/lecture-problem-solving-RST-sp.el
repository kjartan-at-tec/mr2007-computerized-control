(TeX-add-style-hook
 "lecture-problem-solving-RST-sp"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("beamer" "presentation" "aspectratio=169")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("fontenc" "T1") ("ulem" "normalem")))
   (TeX-run-style-hooks
    "latex2e"
    "beamer"
    "beamer10"
    "inputenc"
    "fontenc"
    "graphicx"
    "grffile"
    "longtable"
    "wrapfig"
    "rotating"
    "ulem"
    "amsmath"
    "textcomp"
    "amssymb"
    "capt-of"
    "hyperref"
    "khpreamble")
   (TeX-add-symbols
    "shift"
    "diff")
   (LaTeX-add-labels
    "sec:org70d5d08"
    "sec:org70b8192"
    "sec:orga34f588"))
 :latex)

