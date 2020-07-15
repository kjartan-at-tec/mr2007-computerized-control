(TeX-add-style-hook
 "lecture-pid-digital-sp"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("beamer" "presentation" "aspectratio=1610")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("inputenc" "utf8") ("fontenc" "T1") ("ulem" "normalem")))
   (add-to-list 'LaTeX-verbatim-environments-local "semiverbatim")
<<<<<<< HEAD
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
=======
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "href")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
>>>>>>> b22b6989bdef1c67fd3782e3ca70ba70c94ec33b
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
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
<<<<<<< HEAD
    "shift"
    "diff"
    "Td"
    "NN"
    "uampl"
    "ttdelay"
    "TTcnst"
    "ggain"
    "tdelay"
    "Tcnst")
   (LaTeX-add-labels
    "sec:org39380f2"
    "sec:org5a7a827"
    "sec:org950e38a"
    "sec:org935e007"))
=======
    "Td"
    "NN"
    "Tcnst"
    "tdelay"
    "uampl"
    "ttdelay"
    "TTcnst"
    "ggain")
   (LaTeX-add-labels
    "sec:orge119e86"
    "sec:orgbe0adf6"
    "sec:orgf21e7fa"
    "sec:org5065305"))
>>>>>>> b22b6989bdef1c67fd3782e3ca70ba70c94ec33b
 :latex)

