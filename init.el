
;; load-path
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp" "conf")
(setq make-backup-files nil)

(require 'install-elisp) 
(setq install-elisp-repository-directory "~/.emacs.d/elisp") 

(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;; grep-edit
(require 'grep-edit)

;; for jQuery Development
(autoload #'espresso-mode "espresso" "Start espresso-mode" t)
(add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))

;; for iOS Development
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))

(setq ff-other-file-alist
     '(("\\.mm?$" (".h"))
       ("\\.cc$"  (".hh" ".h"))
       ("\\.hh$"  (".cc" ".C"))

       ("\\.c$"   (".h"))
       ("\\.h$"   (".c" ".cc" ".C" ".CC" ".cxx" ".cpp" ".m" ".mm"))

       ("\\.C$"   (".H"  ".hh" ".h"))
       ("\\.H$"   (".C"  ".CC"))

       ("\\.CC$"  (".HH" ".H"  ".hh" ".h"))
       ("\\.HH$"  (".CC"))

       ("\\.cxx$" (".hh" ".h"))
       ("\\.cpp$" (".hpp" ".hh" ".h"))

       ("\\.hpp$" (".cpp" ".c"))))
(add-hook 'objc-mode-hook
         (lambda ()
           (define-key c-mode-base-map (kbd "C-c o") 'ff-find-other-file)
         ))

(require 'auto-complete-config)
(require 'ac-company)
(global-auto-complete-mode t)
(ac-company-define-source ac-source-company-xcode company-xcode)
(setq ac-modes (append ac-modes '(objc-mode)))
(add-hook 'objc-mode-hook
         (lambda ()
           (define-key objc-mode-map (kbd "\t") 'ac-complete)
           (push 'ac-source-company-xcode ac-sources)
;;	   (push 'ac-source-c++-keywords ac-sources)
         ))
(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)
(define-key ac-completing-map (kbd "M-/") 'ac-stop)
(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")
(setq ac-candidate-max 20)

(require 'etags-table)
(add-to-list  'etags-table-alist
              '("\\.[mh]$" "~/.emacs.d/share/tags/objc.TAGS"))
(defvar ac-source-etags
  '((candidates . (lambda ()
         (all-completions ac-target (tags-completion-table))))
    (candidate-face . ac-candidate-face)
    (selection-face . ac-selection-face)
    (requires . 3))
  "")
(add-hook 'objc-mode-hook
          (lambda ()
            (push 'ac-source-etags ac-sources)))

;;(defun smartchr-custom-keybindings ()
;;  (local-set-key (kbd "=") (smartchr '(" = " " == "  "=")))
;;  (local-set-key (kbd "(") (smartchr '("(`!!')" "(")))
;;  (local-set-key (kbd "[") (smartchr '("[`!!']" "[ [`!!'] ]" "[")))
;;  (local-set-key (kbd "{") (smartchr '("{\n`!!'\n}" "{`!!'}" "{")))
;;  (local-set-key (kbd "`") (smartchr '("\``!!''" "\`")))
;;  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\"")))
;;  (local-set-key (kbd ">") (smartchr '(">" " => " " => '`!!''" " => \"`!!'\"")))
;;  )

;;(defun smartchr-custom-keybindings-objc ()
;;  (local-set-key (kbd "@") (smartchr '("@\"`!!'\"" "@")))
;;  )

;;(add-hook 'c-mode-common-hook 'smartchr-custom-keybindings)
;;(add-hook 'objc-mode-hook 'smartchr-custom-keybindings-objc)

;; color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-calm-forest)

;; redo+.el
(when (require 'redo+ nil t)
  (global-set-key (kbd "C-'") 'redo))

;; js2.el
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq js-indent-level 2)

;; rinari
(require 'ido)
(ido-mode t)
(add-to-list 'load-path "~/.emacs.d/elisp/rinari")
(require 'rinari)

;; tramp
(add-to-list 'load-path "~/.emacs.d/elisp/tramp/lisp/")
(require 'tramp)

;; actionscript-mode
(require 'actionscript-mode)
(setq auto-mode-alist
      (append '(("\\.as$" . actionscript-mode))
	       auto-mode-alist))


;; eshell
(dolist (dir (list
              "/usr/local/port/bin"
	      "/usr/local/port/lib/mysql5/bin"
              (expand-file-name "~/bin")
              (expand-file-name "~/.emacs.d/bin")
              ))
(when (and (file-exists-p dir) (not (member dir exec-path)))
   (setenv "PATH" (concat dir ":" (getenv "PATH")))
   (setq exec-path (append (list dir) exec-path))))

(add-hook 'after-init-hook  (lambda() (eshell)))


;; encoding
(set-default-coding-systems 'utf-8)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(prefer-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)