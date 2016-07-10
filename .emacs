(setq sh-basic-offset 2)
(setq js-indent-level 2)
(setq css-indent-offset 2)

(global-linum-mode 1)
(setq linum-format "%3d│")
(show-paren-mode t)

(custom-set-variables
 '(coffee-tab-width 2))

(setq-default show-trailing-whitespace t)
(menu-bar-mode -1)
(display-battery-mode 1)
(setq column-number-mode t)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line
