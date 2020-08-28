
(require 'package)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
;;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
;;Mode
(use-package ghub)
(add-to-list 'load-path "~/.emacs.d/elpa/all-the-icons")
(use-package all-the-icons
  :custom
  (all-the-icons-scale-factor 1.0))
(add-to-list 'load-path "~/.emacs.d/elpa/doom-themes")
(use-package doom-themes
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  :custom-face
  (doom-modeline-bar ((t (:background "#6272A4"))))
  :config
  (load-theme 'doom-dracula t)
  ;;(doom-themes-neotree-config)
  ;;(doom-themes-org-config)
  )
;;modeline
(add-to-list 'load-path "~/.emacs.d/elpa/stopwatch")
(require 'stopwatch)
;;(use-package stopwatch)
(add-hook 'prog-mode-hook 'stopwatch-start)
(add-to-list 'load-path "~/.emacs.d/elpa/doom-modeline")
(use-package doom-modeline
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-minor-modes t)
  
  :hook
  (after-init . doom-modeline-mode)
  :config
  (doom-modeline-def-modeline 'main
    '(bar window-number matches buffer-info remote-host buffer-position parrot selection-info)
    '(stopwatch misc-info persp-name debug minor-modes input-method major-mode process vcs checker))
  )

(use-package neotree
  :init
  (setq-default neo-keymap-style 'concise)
  :config
  (setq neo-smart-open t)
  (setq neo-create-file-auto-open t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow 'nerd))
  (bind-key [f9] 'neotree-toggle)
  (bind-key "RET" 'neotree-enter-hide neotree-mode-map)
  (bind-key "a" 'neotree-hidden-file-toggle neotree-mode-map)
  (bind-key "<left>" 'neotree-select-up-node neotree-mode-map)
  (bind-key "<right>" 'neotree-change-root neotree-mode-map))
;; Change neotree's font size
;; Tips from https://github.com/jaypei/emacs-neotree/issues/218
(defun neotree-text-scale ()
  "Text scale for neotree."
  (interactive)
  (text-scale-adjust 0)
  (text-scale-decrease 0.1)
  (message nil))
(add-hook 'neo-after-create-hook
	  (lambda (_)
	    (call-interactively 'neotree-text-scale)))
;; neotree enter hide
;; Tips from https://github.com/jaypei/emacs-neotree/issues/77
(defun neo-open-file-hide (full-path &optional arg)
  "Open file and hiding neotree.
The description of FULL-PATH & ARG is in `neotree-enter'."
  (neo-global--select-mru-window arg)
  (find-file full-path)
  (neotree-hide))
(defun neotree-enter-hide (&optional arg)
  "Neo-open-file-hide if file, Neo-open-dir if dir.
The description of ARG is in `neo-buffer--execute'."
  (interactive "P")
  (neo-buffer--execute arg 'neo-open-file-hide 'neo-open-dir))
;;(defvar sml/no-confirm-load-theme t)
;;(defvar sml/theme 'dark) ;; お好みで
;;(defvar sml/shorten-directory -1) ;; directory pathはフルで表示されたいので
;;(sml/setup)
;; エラー音を鳴らなくする（多分みんなやってる）
(setq ring-bell-function 'ignore)
;; mode line を flash！！
(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-background 'mode-line)))
          (set-face-background 'mode-line "purple")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg) (set-face-background 'mode-line fg))
                               orig-fg))))
;; save時にmode line を光らせる
(add-hook 'after-save-hook
	  (lambda ()
	    (let ((orig-fg (face-background 'mode-line)))
	      (set-face-background 'mode-line "green")
	      (run-with-idle-timer 0.1 nil
				   (lambda (fg) (set-face-background 'mode-line fg))
				   orig-fg))))
(which-function-mode 1)
(require 'linum)            ;\左に行番号表示
(global-linum-mode)
;; 行番号だけでなく列番号も表示する
(column-number-mode 1)
;;(iswitchb-mode 1)
;;文字消去の挙動変更
(delete-selection-mode t)
;; backup ファイルオープン時のバックアップ (xxx~)
;; -------------------------------------------
;; 実行の有無
(setq make-backup-files t)
;; 格納ディレクトリーの変更
;;   (対象ディレクトリー . 格納ディレクトリー) のリスト
(setq backup-directory-alist '((".*" . "~/.ehist")))
;; 番号付けによる複数保存
(setq version-control     t)  ;; 実行の有無
(setq kept-new-versions   5)  ;; 最新の保持数
(setq kept-old-versions   1)  ;; 最古の保持数
(setq delete-old-versions t)  ;; 範囲外を削除
(global-hl-line-mode t)       ;; 現在行をハイライト
(require 'hl-line)
;;(set-face-background 'hl-line "#FFFACB")
(set-face-background 'hl-line "#2F4F4F")
(set-face-attribute 'hl-line nil :inherit nil)
(transient-mark-mode t)
(show-paren-mode t)           ;; 対応する括弧をハイライト
(setq show-paren-style 'mixed)  ;; 括弧のハイライトの設定。
;;選択されたリージョンを色付きにしてわかりやすくする設定
;; マッチした場合の色
(set-face-attribute 'show-paren-match nil :background ' "RoyalBlue1")
(set-face-attribute 'show-paren-match nil :foreground ' "Blue")
;;(set-face-background 'show-paren-match-face "RoyalBlue1")
;;(set-face-foreground 'show-paren-match-face "Blue")
;; マッチしていない場合の色
(set-face-attribute 'show-paren-mismatch nil :background ' "Red")
(set-face-attribute 'show-paren-mismatch nil :foreground ' "Blue")
;;(set-face-background 'show-paren-mismatch-face "Red")
;;(set-face-foreground 'show-paren-mismatch-face "Blue")
;;
;; volatile-highlights
;;
(require 'volatile-highlights)
(volatile-highlights-mode t)
;; auto-save 自動保存ファイル (#xxx#)
;; -------------------------------------------
;; ;; 実行の有無
;; (setq auto-save-default nil)
;; ;; 格納ディレクトリーの変更
;; ;;   (対象ファイルのパターン . 保存ファイルパス) のリスト
;; (setq auto-save-file-name-transforms
;;       (append auto-save-file-name-transforms
;;            '((".*" "~/tmp/" t))))
;; 保存の間隔
(setq auto-save-timeout 10)     ;; 秒   (デフォルト : 30)
(setq auto-save-interval 100)   ;; 打鍵 (デフォルト : 300)
;; auto-save-list 自動保存のリスト  (~/.emacs.d/auto-save-list/.saves-xxx)
;; --------------------------------------------------------------------
;; 実行の有無
(setq auto-save-list-file-prefix nil)
;; ;; 格納ディレクトリーの変更
;; (setq auto-save-list-file-prefix "~/tmp/.saves-")
;; lock ロックファイル (.#xxx)
;; -------------------------------------------
;; 実行の有無
(setq create-lockfiles nil)
;;画面のスクロールの移動量を１にする
(setq scroll-conservatively 1)
;; スクロールした際のカーソルの移動行数
(setq scroll-conservatively 10)
;; スクロール開始のマージンの行数
(setq scroll-margin 1)
;; 1 画面スクロール時に重複させる行数
(setq next-screen-context-lines 10)
;; 1 画面スクロール時にカーソルの画面上の位置をなるべく変えない
(setq scroll-preserve-screen-position t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(all-the-icons-scale-factor 1.0)
 '(doom-themes-enable-bold t)
 '(doom-themes-enable-italic t)
 '(package-selected-packages
   (quote
    (eshell-fringe-status counsel cmake-mode undo-tree neotree smart-mode-line hide-mode-line minimap doom-themes doom use-package doom-modeline imenu-list highlight-indent-guides package-utils auto-complete-c-headers auto-complete rainbow-delimiters))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doom-modeline-bar ((t (:background "#6272A4"))))
 '(imenu-list-entry-face-1 ((t (:foreground "white"))))
 '(region ((t (:background "brown" :distant-foreground "spring green")))))
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
(add-hook 'emacs-lisp-mode-hook '(lambda ()
                                   (require 'auto-complete)
                                   (auto-complete-mode t)
                                   ))
(require 'auto-complete-config)
(ac-config-default)
;; Ctrl+Zで最小化しない
(define-key global-map "\C-z" 'scroll-down)
(setq mouse-wheel-scroll-amount
      '(1                            ; 通常   (デフォルト 5)
	((shift) . 10)                   ; Shift  (デフォルト 1)
	((control) . 40)                ; Ctrl   (デフォルト nil = 無効)
	))
;;インデントに色をつける
(use-package highlight-indent-guides
  :diminish
  :hook
  ((prog-mode yaml-mode) . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-auto-enabled t)
  (highlight-indent-guides-responsive t)
  (highlight-indent-guides-method 'column) ; column
  )
;;(require 'highlight-indent-guides)
;;(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
;;(setq highlight-indent-guides-method 'column)
;;(setq highlight-indent-guides-auto-enabled t)
;;(setq highlight-indent-guides-responsive t)
;;(set-face-background 'highlight-indent-guides-odd-face "lightgreen")
;;(set-face-background 'highlight-indent-guides-even-face "lightgreen")
;;(set-face-foreground 'highlight-indent-guides-character-face "lightgreen")
;;関数の表示
;;(use-package hide-mode-line
;;  :hook
;;  ((neotree-mode imenu-list-minor-mode minimap-mode) . hide-mode-line-mode)
;;  )

(use-package imenu-list
  :bind
  ("<f10>" . imenu-list-smart-toggle)
  :custom-face
  (imenu-list-entry-face-1 ((t (:foreground "white"))))
  :hook
  (after-init . imenu-list-minor-mode)
  :custom
  (imenu-list-focus-after-activation nil)
  (imenu-list-auto-resize t)
  )

;; rainbow-delimiters を使うための設定
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(global-set-key "\C-h" `delete-backward-char)

(global-set-key (kbd "C-c b") 'windmove-left)
(global-set-key (kbd "C-c n") 'windmove-down)
(global-set-key (kbd "C-c p") 'windmove-up)
(global-set-key (kbd "C-c f") 'windmove-right)


(require 'undo-tree)
(global-undo-tree-mode)
(global-set-key (kbd "M-/") 'undo-tree-redo)

(require 'cmake-mode); Add cmake listfile names to the mode list.
(setq auto-mode-alist
      (append
       '(("CMakeLists\\.txt\\'" . cmake-mode))
       '(("\\.cmake\\'" . cmake-mode))
       auto-mode-alist))

;;テンプレートの表示
(require 'autoinsert)
;; テンプレートのディレクトリ
(setq auto-insert-directory "~/.emacs.d/elpa/insert/")

;; 各ファイルによってテンプレートを切り替える
(setq auto-insert-alist
      (nconc '(
               ("\\.cpp$" . ["template.cpp" my-template])
               ("\\.h$"   . ["template.h" my-template])
               ) auto-insert-alist))
(require 'cl)

;; ここが腕の見せ所
(defvar template-replacements-alists
  '(("%file%"             . (lambda () (file-name-nondirectory (buffer-file-name))))
    ("%file-without-ext%" . (lambda () (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    ("%include-guard%"    . (lambda () (format "__SCHEME_%s__" (upcase (file-name-sans-extension (file-name-nondirectory buffer-file-name))))))))

(defun my-template ()
  (time-stamp)
  (mapc #'(lambda(c)
	    (progn
	      (goto-char (point-min))
	      (replace-string (car c) (funcall (cdr c)) nil)))
	template-replacements-alists)
  (goto-char (point-max))
  (message "done."))
(add-hook 'find-file-not-found-hooks 'auto-insert)

(when (require 'ivy nil t)

  ;; M-o を ivy-hydra-read-action に割り当てる．
  (when (require 'ivy-hydra nil t)
    (setq ivy-read-action-function #'ivy-hydra-read-action))
  ;; `ivy-switch-buffer' (C-x b) のリストに recent files と bookmark を含める．
  (setq ivy-use-virtual-buffers t)
  ;; ミニバッファでコマンド発行を認める
  (when (setq enable-recursive-minibuffers t)
    (minibuffer-depth-indicate-mode 1)) ;; 何回層入ったかプロンプトに表示．
  ;; ESC連打でミニバッファを閉じる
  (define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit)
  ;; プロンプトの表示が長い時に折り返す（選択候補も折り返される）
  (setq ivy-truncate-lines nil)
  ;; リスト先頭で `C-p' するとき，リストの最後に移動する
  (setq ivy-wrap t)
  ;; アクティベート
  (ivy-mode 1))

(when (require 'counsel nil t)
  ;; キーバインドは一例です．好みに変えましょう．
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "M-y") 'counsel-yank-pop)
  (global-set-key (kbd "C-M-z") 'counsel-fzf)
  (global-set-key (kbd "C-M-r") 'counsel-recentf)
  (global-set-key (kbd "C-x C-b") 'counsel-ibuffer)
  (global-set-key (kbd "C-M-f") 'counsel-ag)
  ;; アクティベート
  (counsel-mode 1))

;;popwin
(add-to-list 'load-path "~/.emacs.d/elpa/popwin")
(require 'popwin)
(popwin-mode 1)
(setq pop-up-windows nil)
;;(setq display-buffer-function 'popwin:display-buffer) ;;old

(setq popwin:popup-window-position 'bottom)

;;eshellの設定
(global-set-key (kbd "C-c e") 'eshell)
(global-set-key (kbd "C-c t") '(lambda()
                          (interactive)
                          (if (get-buffer "*ansi-term*")
                              (switch-to-buffer "*ansi-term*")
                            (ansi-term "bash")

			    )))

(add-to-list 'popwin:special-display-config
	     '("*ansi-term*" :regexp t :dedicated t :position bottom
	       :height 0.3))


(defun eshell-on-current-dir (&optional arg)
  "invoke eshell and cd to current directory"
  (interactive "P")
  (let ((dir default-directory))
    (eshell arg)
    (cd dir))
  (eshell-emit-prompt)
  (goto-char (point-max)))


(add-to-list 'popwin:special-display-config
             '("\\`\\*eshell" :regexp t :dedicated t :position bottom
               :height 0.3))

(add-hook 'eshell-mode-hook ' eshell-fringe-status-mode)

;; load environment value
(load-file (expand-file-name "~/.emacs.d/shellenv.el"))
(dolist (path (reverse (split-string (getenv "PATH") ":")))
  (add-to-list 'exec-path path))

(add-to-list 'popwin:special-display-config
             '("*undo-tree*" :regexp t :dedicated t :position bottom
               :height 0.3))

(defun revert-buffer-no-confirm (&optional force-reverting)
  "Interactive call to revert-buffer. Ignoring the auto-save
 file and not requesting for confirmation. When the current buffer
 is modified, the command refuses to revert it, unless you specify
 the optional argument: force-reverting to true."
  (interactive "P")
  ;;(message "force-reverting value is %s" force-reverting)
  (if (or force-reverting (not (buffer-modified-p)))
      (revert-buffer :ignore-auto :noconfirm)
    (error "The buffer has been modified")))

(global-set-key (kbd "C-c r") 'revert-buffer-no-confirm)
