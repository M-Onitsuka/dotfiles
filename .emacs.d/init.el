;;(load "${CVSDIR}/jsk_tendon_robot/install/tendon-init.el")
;;(load "/home/kawamura/ros/indigo/src/jsk-ros-pkg/jsk_tendon_robot/install/tendon-init.el")

(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\M-g" 'goto-line)
;;(global-set-key "\M-[" 'backward-paragraph)
;;(global-set-key "\M-]" 'forward-paragraph)
(global-set-key "\M-j" 'next-line)
(global-set-key "\M-k" 'previous-line)
;;(global-set-key "\M-h" 'backward-char)
;;(global-set-key "\M-l" 'forward-char)

;;(global-set-key "\C-" 'mark-paragraph)
(global-unset-key "\C-\\")

;; M-n and M-p
(global-unset-key "\M-p")
(global-unset-key "\M-n")
(defun scroll-up-in-place (n)
  (interactive "p")
  (previous-line n)
  (scroll-down n))
(defun scroll-down-in-place (n)
  (interactive "p")
  (next-line n)
  (scroll-up n))
(global-set-key "\M-n" 'scroll-down-in-place)
(global-set-key "\M-p" 'scroll-up-in-place)

;;paren
(show-paren-mode 1)
;; ;; C-qで移動
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        )
  )
(global-set-key "\C-Q" 'match-paren)

;;global(gtags)
;; (setq load-path (cons "." load-path))
;; (require 'gtags)
;; (global-set-key "\M-t" 'gtags-find-tag)
;; (global-set-key "\M-r" 'gtags-find-rtag)
;; (global-set-key "\M-s" 'gtags-find-symbol)
;; (global-set-key "\M-i" 'gtags-pop-stack)

;;color
(defvar my/bg-color "#072532")
(set-background-color my/bg-color)
(set-foreground-color "#FFFFFF")
                                        ;(load-thema 'deep-blue)

(column-number-mode t)
(which-function-mode t)

;;tabを空白に
;;(add-hook 'lisp-mode-hook '(lambda () (setq tab-width 2)))
;;(setq-default indent-tabs-mode nil)
(setq-default tab-width 4 indent-tabs-mode nil)

;;M-h delete word
(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-word (- arg)))
(global-set-key "\M-h" 'backward-delete-word)

;;C-w action：リージョンが活性化されていればリージョンカット、非活性であれば直前の単語を削除
(defun kill-region-or-backward-delete-word ()
  (interactive)
  (if (region-active-p)
      (kill-region (point) (mark))
    (backward-delete-word 1)))
(global-set-key "\C-w" 'kill-region-or-backward-delete-word)

;;C-c C-k カーソルから行先頭まで削除
(global-set-key (kbd "C-c C-k") '(lambda () (interactive) (kill-line 0)))

;;C-t action:ウィンドウが複数あれば移動、一つならウィンドウ作成
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))
(global-set-key "\C-t" 'other-window-or-split)

;;trr22
;;(add-to-list 'load-path "/usr/share/emacs/site-lisp/trr22")
;;(autoload 'trr "/usr/share/emacs/site-lisp/trr22/trr" nil)

;; frame size
(if (boundp 'window-system)
    (setq default-frame-alist
          (append (list
                   '(width  . 70)
                   '(height .  40)
                   )
                  default-frame-alist)))
(setq intial-frame-alist default-frame-alist)

;;white space settings
(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末
                         tabs           ; タブ
                         spaces         ; スペース
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         ))
(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

;; スペースは全角のみを可視化
(setq whitespace-space-regexp "\\(\u3000+\\)")

;; 保存前に自動でクリーンアップ
(setq whitespace-action '(auto-cleanup))

;;yes or no to y or n
(fset 'yes-or-no-p 'y-or-n-p)
;;C-k で改行コードも含めて行を削除
(setq kill-whole-line t)
;;white space
(global-whitespace-mode 1)
;; regionをdeleteで一括削除
(delete-selection-mode t)

(set-face-attribute 'whitespace-trailing nil
                    :background my/bg-color
                    :foreground "DeepPink"
                    :underline t)
(set-face-attribute 'whitespace-tab nil
                    :background my/bg-color
                    :foreground "LightSkyBlue"
                    :underline t)
(set-face-attribute 'whitespace-space nil
                    :background my/bg-color
                    :foreground "GreenYellow"
                    :weight 'bold)
(set-face-attribute 'whitespace-empty nil
                    :background my/bg-color)

(setq
 ;; クリップボードでコピー＆ペーストできるようにする
 x-select-enable-clipboard t
 ;; PRIMARY selectionを使う(Windowsでは対象外)
 x-select-enable-primary t
 ;; クリップボードでコピー・カットした文字列を
 ;; キルリングにも保存させる
 save-interprogram-paste-before-kill t
 ;; エラー時などはベル音ではなくて画面を1回点滅させる
 visible-bell t
 ;; バックアップファイルはカレントディレクトリではなく
 ;; ~/.emacs.d/backups 以下に保存する
 backup-directory-alist `(("." . ,(concat user-emacs-directory
                                          "backups"))))

;;tendon-init.elから重複しない設定
(require 'cl)
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(defvar installing-package-list
  '(
    ;; package list to use
    whitespace
    smartparens
    rainbow-delimiters
    ))

;; automatically install
(let ((not-installed (loop for x in installing-package-list
                           when (not (package-installed-p x))
                           collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))

(add-to-list 'load-path "~/.emacs.d/elpa/")
(add-to-list 'load-path "~/.emacs.d/cmake")
(add-to-list 'load-path "/opt/ros/indigo/share/emacs/site-lisp")
;;(add-to-list 'load-path "/opt/ros/hydro/share/emacs/site-lisp")
;; or whatever your install space is + "/share/emacs/site-lisp"
;; (require 'rosemacs-config)

;; inhibit startup screen
(setq inhibit-startup-screen t)

;; delete initial scratch message
(setq initial-scratch-message "")


;; tab->space
(setq-default tab-width 4 indent-tabs-mode nil)

;; smartparents
;; (require 'smartparens-config)
;; (smartparens-global-mode t)
;; (show-smartparens-global-mode t)

;; rainbow-delimiters を使うための設定
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; 括弧の色を強調する設定
(require 'cl-lib)
(require 'color)
(defun rainbow-delimiters-using-stronger-colors ()
  (interactive)
  (cl-loop
   for index from 1 to rainbow-delimiters-max-face-count
   do
   (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
     (cl-callf color-saturate-name (face-foreground face) 30))))
(add-hook 'emacs-startup-hook 'rainbow-delimiters-using-stronger-colors)

;; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))

(when (require 'saveplace nil t)
  (setq-default save-place t)
  (setq save-place-file "~/.emacs.d/saved-places"))

(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;;cmake mode
(require 'cmake-mode)
(setq auto-mode-alist
      (append
       '(("CMakeLists\\.txt\\'" . cmake-mode))
       '(("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))

;;(load "${CVSDIR}/jsk_common/jsk_tools/dot-files/dot.emacs") ;; jsk標準
(put 'upcase-region 'disabled nil)

(add-to-list 'load-path "~/.emacs-trr")
(require 'trr)

(require 'company)
(global-company-mode)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(setq company-selection-wrap-around t)

(with-eval-after-load 'company
  (setq company-auto-expand t) ;; 1個目を自動的に補完
  (setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
  (setq company-idle-delay 0) ; 遅延なしにすぐ表示
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の最後の次は先頭に戻る
  (setq completion-ignore-case t)
  (setq company-dabbrev-downcase nil)
  (global-set-key (kbd "C-M-i") 'company-complete)
  ;; C-n, C-pで補完候補を次/前の候補を選択
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
  (define-key company-active-map (kbd "C-h") nil) ;; C-hはバックスペース割当のため無効化
  (define-key company-active-map (kbd "C-S-h") 'company-show-doc-buffer) ;; ドキュメント表示はC-Shift-h

  ;; 未選択項目
  (set-face-attribute 'company-tooltip nil
                      :foreground "white" :background "#696969")
  ;; 未選択項目&一致文字
  (set-face-attribute 'company-tooltip-common nil
                      :foreground "red" :background "#696969")
  ;; 選択項目
  (set-face-attribute 'company-tooltip-selection nil
                      :foreground "white" :background "#4682b4")
  ;; 選択項目&一致文字
  (set-face-attribute 'company-tooltip-common-selection nil
                      :foreground "red" :background "#4682b4")
  ;; スクロールバー
  (set-face-attribute 'company-scrollbar-fg nil
                      :background "#4cd0c1")
  ;; スクロールバー背景
  (set-face-attribute 'company-scrollbar-bg nil
                      :background "#002b37")
  )

(font-lock-add-keywords
 'lisp-mode
 (list
  (list (concat "(" (regexp-opt '("defforeign") t) "\\>") '(1 font-lock-keyword-face nil t))
  (list "\\(self\\)\\>" '(1 font-lock-constant-face nil t))
  (list "\\(\\*\\w\+\\*\\)\\>" '(1 font-lock-constant-face nil t))
  (list "\\(#\\(\\+\\|\\-\\)\.\*\\)" '(1 font-lock-variable-name-face))
  (list "\\(throw-error\\)" '(1 font-lock-warning-face nil t))
  (list (concat "(" (regexp-opt '("warn" "warning-message") t) "\\>") '(1 font-lock-warning-face nil t))
  (list (concat "(" (regexp-opt '("send" "send-all" "send-super") t) "\\>") '(1 font-lock-builtin-face nil t))
  (list "\\(\\*[^ ]*\\*\\)" '(1 font-lock-constant-face nil t))
  (list (concat "(" (regexp-opt '("load") t) "\\>") '(1 font-lock-keyword-face nil t))
  (list (concat "(" (regexp-opt '("setq") t) "\\>") '(1 font-lock-type-face nil t))
  )
  )

;; Highlight special keywords
(require 'hl-todo)
(global-hl-todo-mode)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-builtin-face ((t (:foreground "color-172"))))
 '(font-lock-constant-face ((t (:foreground "color-75"))))
 '(font-lock-function-name-face ((t (:foreground "cyan"))))
 '(font-lock-string-face ((t (:foreground "yellow"))))
 '(hl-todo ((t (:foreground "#cc9393" :inverse-video t :weight bold))))
 '(minibuffer-prompt ((t (:foreground "brightgreen")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-todo-keyword-faces
   (quote
    (("TODO" . "yellow")
     ("OK" . "#7cb8bb")
     ("OKAY" . "#7cb8bb")
     ("FAIL" . "#8c5353")
     ("DEBUG" . "#dc8cc3")
     ("INFO" . "#5f7f5f")
     ("WARNING" . "orange")
     ("ERROR" . "red")
     ("FATAL" . "red")))))
