;;; wordnik.el ---  lookup a word on wordnik
;;
;; Author: Dino Chiesa
;; Created: Thu, 19 Jul 2012  18:03
;; Package-Requires: ()
;; URL: http://www.emacswiki.org/cgi-bin/wiki/wordnik.el
;; X-URL: http://cheeso.members.winisp.net/srcview.aspx?dir=emacs&file=wordnik.el
;; Version: 2012.07.18
;; Keywords: dictionary lookup
;; License: New BSD

;;; Commentary:

;; This module allows a user to look up for a word in a web-accessible
;; dictionary, WordNik, and then display the definition.

;; To use this modike, you must first go to http://wordnik.com/ and register (no
;; cost) to get an API key.  Then, put wordnik.el in your emacs load
;; path and modify your .emacs to do this:

;;   (require 'wordnik)
;;   (setq wordnik-api-key "XXXXXXXXXXXX")  ;; from registration
;;   ;; optional key binding (suggested)
;;   (define-key global-map (kbd "C-c ?") 'wordnik-lookup-word)

;;
;;; Revisions:
;;
;; 2012.07.18  2012-July-17 Dino Chiesa
;;    First release.
;;

;;; License
;;
;; This code is distributed under the New BSD License.
;;
;; Copyright (c) 2008-2012, Dino Chiesa
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met:
;;
;; Redistributions of source code must retain the above copyright
;; notice, this list of conditions and the following disclaimer.
;;
;; Redistributions in binary form must reproduce the above copyright
;; notice, this list of conditions and the following disclaimer in the
;; documentation and/or other materials provided with the distribution.
;;
;; Neither the name of the author or any contributors, nor the names of
;; any organizations they belong to, may be used to endorse or promote
;; products derived from this software without specific prior written
;; permission.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;; A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;; HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
;; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
;; BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
;; OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
;; AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
;; WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;; POSSIBILITY OF SUCH DAMAGE.
;;

(require 'url)
(require 'json)

(defgroup wordnik nil
  "Provides a facility to look up definitions of words."
  :group 'Editing)

(defcustom wordnik-api-key nil
  "The api key for connecting to wordnik.com.

Get one by visiting  http://developer.wordnik.com/

"
  :type 'string
  :group 'wordnik)


(defcustom wordnik-use-powershell-for-msgbox-on-windows t
  "whether to use powershell on Windows for msgbox.
"
  :type 'boolean
  :group 'wordnik)


(defvar wordnik---load-path (or load-file-name "~/wordnik.el")
  "For internal use only. ")

(defun wordnik-get-buffer-for-word (word)
  "Retrieve a definition for the given word, from the
web service."
  ;; could insert a chooser function here
  (if (not (and (boundp 'wordnik-api-key)
                (stringp wordnik-api-key)))
      (let ((msg (concat "You need to get an \"api key\" from WordNik.\n"
                         "Then, set it in your .emacs with a statement like:\n"
                         "    (setq wordnik-api-key \"XXXXXXXXXXXX\") \n")))
        (wordnik-msgbox msg)
        (browse-url "http://developer.wordnik.com")
        nil)
    (url-retrieve-synchronously
     (concat "http://api.wordnik.com/v4/word.json/"
             word
             "/definitions?api_key="
             wordnik-api-key ))))

(defun wordnik-path-of-powershell-exe ()
  "get location of powershell exe."
  (concat
   (or (getenv "windir") "c:\\windows")
   "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"))

(defun wordnik-want-msgbox-via-powershell ()
  "Determine if we want to display a message box
using Windows powershell."

  (and wordnik-use-powershell-for-msgbox-on-windows
       (eq system-type 'windows-nt)
       (file-exists-p (wordnik-path-of-powershell-exe))))


(defun wordnik-msgbox-via-powershell (format-string &rest args)
  "Display a message box via Powershell and Windows Forms. This works
only on Windows OS platforms.

The `message-box' fn works poorly on Windows; it does not allow
the encoding of newlines and also the UI generally looks like a
silly toy.

This can be used in place of `message-box' on Windows.

"
  (flet ((rris (a1 a2 s) (replace-regexp-in-string a1 a2 s)))
    (let* ((msg (format format-string args))
           (ps-cmd
            ;; This is a command to be passed on the cmd.exe line.
            ;; Newlines encoded as \n or `n do not display properly. This
            ;; code transforms splits the string on newlines, then joins,
            ;; using [char]0x000D as the "glue".  Also - need to perform
            ;; special escaping of single and double quotes.  All this
            ;; because we are passing a script to powershell on the
            ;; command line.
            ;;
            ;; creating a file with script code in it, then passing
            ;; that file to powershell, would avoid the need for
            ;; special escaping.  But that is not feasible, since by
            ;; default powershell prohibits executing scripts. But
            ;; powershell allows running script passed as -Command. So.
            (concat "[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms');"
                    "[Windows.Forms.MessageBox]::Show("
                    (mapconcat '(lambda (elt)
                                  (rris (char-to-string 34)
                                        (char-to-string 39)
                                        (pp-to-string
                                         (rris (char-to-string 34)
                                               "'+[char]0x0022+'"
                                               (rris (char-to-string 39)
                                                     "'+[char]0x0027+'"
                                                     elt)
                                               ))))
                               (split-string msg "\n" nil)
                               "+[char]0x000D+")
                    ",'Word Definition from Wordnik (Emacs)',"
                    "[Windows.Forms.MessageBoxButtons]::OK,"
                    "[Windows.Forms.MessageBoxIcon]::Information)"))
           (shell-command
            (format "%s -Command %s"
                    (wordnik-path-of-powershell-exe)
                    (concat "\"& {" ps-cmd "}\""))))
      (shell-command-on-region (point) (point)
                               shell-command
                               nil nil nil))))


(defun wordnik-msgbox (msg)
  "Display a message in a dialog box."
  (if (wordnik-want-msgbox-via-powershell)
      (wordnik-msgbox-via-powershell msg)
    (message-box msg)))


(defun wordnik-process-http-headers ()
  "In the buffer created by `url-retrieve-synchronously',
there are HTTP headers, and content. This fn removes the headers
from the buffer, parsing the Content-Length header to verify that
a substantive response was received.

This implementation deletes each line until finding a blank line,
which in correctly-formatted HTTP messages signals the end of the
headers and the beginning of the message content.
"
  (let ((clength -1)
        (ctype ""))
    (while (/= (point) (line-end-position))
      (when (and (< clength 0)
               (re-search-forward "^[Cc]ontent-[Ll]ength ?: *\\(.*\\)$" (line-end-position) t))
          (setq clength (string-to-number (match-string 1)))
          (goto-char (line-beginning-position)))
      (when (and (< clength 0)
               (re-search-forward "^[Cc]ontent-[Tt]ype ?: *\\(.*\\)$" (line-end-position) t))
          (setq ctype (match-string 1))
          (goto-char (line-beginning-position)))
      (delete-region (point) (line-end-position))
      (delete-char 1))
    (delete-char 1)
    (list ctype clength)))


;;;###autoload
(defun wordnik-get-definition (word)
  "retrieve the definition for the given word, from the remote service.
"
  (let ((defn nil)
        (buf (wordnik-get-buffer-for-word word)))
    (if buf
        (let (head)
          (with-current-buffer buf
            (rename-buffer (concat "*wordnik* - " word) t)
            (goto-char (point-min))
            (setq head (wordnik-process-http-headers))
            (if (string= (substring (nth 0 head) -4) "json")
                (setq defn (json-read)) ;; a vector
              (message-box "No definition found.")))
          (kill-buffer buf)
          defn))))


(defun wordnik-word-at-point ()
  "Uses `bounds-of-thing-at-point', to find and return the word at point.
"
  (if (get 'word 'thing-at-point)
      (funcall (get 'word 'thing-at-point))
    (let ((bounds (bounds-of-thing-at-point 'word)))
      (if bounds
          (buffer-substring-no-properties (car bounds) (cdr bounds))))))


;;;###autoload
(defun wordnik-show-definition (word)
  "A main interactive entry point into the `wordnik.el' capability.
Invoke this interactively, and the fn will prompt the user to
confirm the word to be looked up.  It will then retrieve the
definition for the word, from the remote service, and display a
message box to the user with that information.

"
  (interactive (list (read-string "word: " (wordnik-word-at-point))))
  (let ((defn (wordnik-get-definition word))
        (i 0)
        (msg ""))
    (if defn ;; a vector
        (progn
          (while (< i (length defn))
            (setq msg (concat msg
                              (cdr (assoc 'word (elt defn i)))
                              ": "
                              (cdr (assoc 'text (elt defn i)))
                              "\n\n"
                              )
                  i (1+ i)))

          ;;(setq msg (concat "lookup word " word "\n"))
          (wordnik-msgbox msg)))))


(provide 'wordnik)

;;; wordnik.el ends here
