;;; mon-replacement-utils.el --- common regexp and subsititution procedures 
;; -*- mode: EMACS-LISP; -*-
;;; ================================================================
;;; DESCRIPTON:
;;; mon-replacement-utils provides a collection of routines and commands and
;;; abstracts some commonly encountered procedures for processing regexps with
;;; their replacements.
;;;
;;; :NOTE This file used to be named naf-mode-replacements.el
;;; :AS-OF <Timestamp: #{2009-12-19T14:11:23-05:00Z}#{09516} - by MON>
;;; It has been renamed to mon-replacement-utils.el
;;;
;;; FUNCTIONS:►►►
;;; `mon-replace-regexp-while', `mon-replace-string-while'
;;; `replace-string-pairs-region3', `replace-string-pairs-region-no-props',
;;; `mon-get-list-yorp', `mon-get-list-norp',
;;; `mon-replace-region-regexp-lists-nonint', `mon-replace-region-regexp-lists',
;;; `mon-exchange-slash-and-backslash', `mon-cln-file-name-string',
;;; `mon-regexp-filter', `mon-cln-html-chars',
;;; `mon-cln-html-tags', `mon-canonical-string', 
;;; `mon-toggle-case-regexp-region', 
;;; `mon-toggle-case-query-user', `mon-toggle-case-regexp',
;;; `mon-downcase-region-regexp', `mon-downcase-regexp',
;;; `mon-upcase-regexp', `mon-upcase-regexp-region'
;;; `mon-line-number-region-incr', `mon-pipe-list', `mon-cln-piped-list',
;;; `mon-delete-back-up-list', `naf-backup-the-list', `mon-cln-philsp',
;;; `mon-cln-ulan', `mon-cln-imdb', `mon-cln-loc', `mon-cln-wiki',
;;; `mon-cln-bib', `mon-cln-BIG-whitespace', `mon-cln-whitespace',
;;; `mon-cln-trail-whitespace', `mon-kill-whitespace', `mon-cln-blank-lines',
;;; `mon-cln-uniq-lines', `mon-cln-spc-tab-eol', `mon-cln-spc-tab-at-eol-in-region',
;;; `mon-cln-control-M', `mon-num-to-month', `mon-num-to-month-whitespace',
;;; `mon-month-to-num', `mon-abr-to-month', `mon-trans-cp1252-to-latin1',
;;; `mon-ital-date-to-eng', `mon-defranc-dates', `mon-defranc-places',
;;; `mon-defranc-benezit', `mon-replace-common-abbrevs', `mon-zippify-region',
;;; `bug-cln-gilt-group', `mon-cln-csv-fields', `mon-cln-xml<-parsed',
;;; `mon-cln-tgm-xml-LF', `mon-is-naf-mode-and-llm-p', `mon-is-naf-mode-p'
;;; `mon-replace-string-pairs-region-no-insert', `mon-cln-xml<-parsed-strip-nil'
;;; `mon-cln-up-colon', `mon-regexp-map-match'
;;; FUNCTIONS:◄◄◄
;;; 
;;; MACROS:
;;; `mon-naf-mode-toggle-restore-llm'
;;;
;;; METHODS:
;;;
;;; CLASSES:
;;;
;;; VARIABLES:
;;; `*iso-latin-1-approximation*'
;;;
;;; CONSTANTS:
;;;
;;; RENAMED: 
;;; `naf-delete-back-up-list' -> `mon-delete-back-up-list'
;;; `mon-clnBIG-whitespace'   -> `mon-cln-BIG-whitespace'
;;; `mon-re-number-region'    -> `mon-line-number-region-incr'
;;;
;;; MOVED:
;;; `mon-query-replace-register1<-reg2' -> mon-empty-registers.el
;;; `mon-insert-regexp-template-yyyy'   -> mon-insertion-utils.el
;;;
;;; ALIASED/ADVISED/SUBST'd:
;;; `naf-delete-back-up-list' -> `mon-delete-back-up-list'
;;;
;;; REQUIRES:
;;; Regexps for functions defined here are set with defvar forms in the file:
;;; (URL `./naf-mode/mon-regexp-symbols.el')
;;;
;;; References the following: CONSTANTS OR VARIABLES:
;;; `philsp-months', `philsp-months',`philsp-apos', `philsp-location' 
;;; `philsp-swap-location' `philsp-fix-month-dates', `*regexp-clean-ulan*',
;;; `regexp-clean-imdb', `regexp-clean-loc', `regexp-clean-wikipedia',
;;; `*regexp-clean-bib*', `regexp-cleanBIG-whitespace', `regexp-clean-whitespace',
;;; `regexp-MM2month', `regexp-MM2month-whitespace-aware', `regexp-month2MM',
;;; `*regexp-cp1252-to-latin1*', `*regexp-ital-to-eng*', `*regexp-defranc-dates*',
;;; `*regexp-defranc-places*', `*regexp-defranc-benezit*', `*regexp-common-abbrevs*', 
;;; `regexp-MM2month-whitespace-aware'
;;;
;;; 'cl used by `iso-latin-1-replacements', `deftransmogrify', etc. 
;;;
;;; TODO:
;;; Instances of longlines-mode checks, e.g.:
;;;    (and (buffer-local-value longlines-mode (current-buffer)))
;;; should _maybe_ be updated with:
;;;    (and (boundp 'longlines-mode) (bound-and-true-p longlines-mode))
;;; 
;;; Need function to show whitespace, tab, _and_ `longlines-mode's
;;; hardlines using `longlines-show-hard-newlines'.
;;;
;;; NOTES:
;;; ,----
;;; | :FROM ../emacs/etc/TODO
;;; | ** Implement intelligent search/replace, going beyond query-replace
;;; |    :SEE (URL `http://groups.csail.mit.edu/uid/chi04.pdf'). 
;;; | ,----
;;; | | :NOTE The above link is dead but:
;;; | | :SEE (URL `http://web.mit.edu/noto/Public/thesis/alisa_proposal.html')
;;; | | :SEE (URL `http://groups.csail.mit.edu/uid/projects/clustering/alisa_m-thesis.pdf')
;;; | `----
;;; `----
;;;
;;; SNIPPETS:
;;; Test if we are in a `naf-mode' buffer:
;;; (eq (buffer-local-value 'major-mode (current-buffer)) 'naf-mode)
;;;
;;; THIRD PARTY CODE:
;;;
;;; AUTHOR: MON KEY
;;; MAINTAINER: MON KEY
;;;
;;; PUBLIC-LINK:
;;; (URL `http://www.emacswiki.org/emacs/mon-replacement-utils.el')
;;; FIRST-PUBLISHED: <Timestamp: #{2009-09-20} - by MON KEY>
;;;
;;; FILE-CREATED:
;;; <Timestamp: Wednesday April 08, 2009 @ 01:16.02 PM - by MON KEY>
;;; ================================================================
;;; This file is not part of GNU Emacs.
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License as
;;; published by the Free Software Foundation; either version 3, or
;;; (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program; see the file COPYING.  If not, write to
;;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;;; Floor, Boston, MA 02110-1301, USA.
;;; ================================================================
;;; Permission is granted to copy, distribute and/or modify this
;;; document under the terms of the GNU Free Documentation License,
;;; Version 1.3 or any later version published by the Free Software
;;; Foundation; with no Invariant Sections, no Front-Cover Texts,
;;; and no Back-Cover Texts. A copy of the license is included in
;;; the section entitled "GNU Free Documentation License".
;;; A copy of the license is also available from the Free Software
;;; Foundation Web site at:
;;; (URL `http://www.gnu.org/licenses/fdl-1.3.txt').
;;; ================================================================
;;; Copyright © 2009, 2010 MON KEY 
;;; ==============================
;;; CODE:

;;; ==============================
;;; `iso-latin-1-replacements', `deftransmogrify', etc.
(eval-when-compile (require 'cl))

;;; ==============================
(require 'mon-regexp-symbols)
;;; ==============================

;;; ==============================
;;; :NOTE MON always forget to use these functions, lets get reminded!
;;; :CREATED <Timestamp: Wednesday May 13, 2009 @ 01:33.46 PM - by MON KEY>
(defalias 'mon-replace-char-in-string 'subst-char-in-string)
(defalias 'replace-char-in-string-mon 'subst-char-in-string)
(defalias 'replace-in-string-mon      'subst-char-in-string)

;;; ==============================
;;; :CREATED <Timestamp: #{2009-09-08T12:56:12-04:00Z}#{09372} - by MON KEY>
(defun mon-is-naf-mode-p ()
  "Test if current-buffer is in `naf-mode'.\n
:EXAMPLE\n(mon-is-naf-mode-p)\n
:CALLED-BY `mon-is-naf-mode-and-llm-p', and other functions which invoke
`mon-naf-mode-toggle-restore-llm' to test for active naf-mode before running
additional longlines-mode checks.
:SEE-ALSO \n►►►"
  (eq (buffer-local-value 'major-mode (current-buffer)) 'naf-mode))
;;
;;; :TEST-ME (mon-is-naf-mode-p)

;;; ==============================
;;; :CREATED <Timestamp: #{2009-09-08T12:59:41-04:00Z}#{09372} - by MON KEY>
(defun mon-is-naf-mode-and-llm-p ()
  "Test if current-buffer is in `naf-mode' and `longlines-mode' is enabled.\n
:EXAMPLE\n(mon-is-naf-mode-and-llm-p)\n
CELLED-BY: `mon-naf-mode-toggle-restore-llm' and other functions which invoke
to test for active naf-mode before evaluating body.\n
:SEE-ALSO `mon-is-naf-mode-p'.\n►►►"
  (if (mon-is-naf-mode-p)
      (buffer-local-value longlines-mode (current-buffer))
    nil))
;;
;;; :TEST-ME (mon-is-naf-mode-and-llm-p)

;;; ==============================
;;; :NOTE <Timestamp: #{2010-02-20T17:49:20-05:00Z}#{10076} - by MON KEY>
;;; Either this doesn't make any sense or we're not setting it (or both!).
;;; The only thing I can think of is this variable might be useful if conditionally
;;; set according to some hook (which doesn't yet exist) where we elect not to
;;; immediately drop into to llm.
;;; :CREATED <Timestamp: #{2009-09-08T13:18:17-04:00Z}#{09372} - by MON KEY>
(defvar *naf-mode-buffer-local-llm* nil
  "Test if `longlines-mode' is active in buffer.
Automatically becomes buffer-local whenever `naf-mode' initiated in buffer.\n
:SEE-ALSO `mon-is-naf-mode-p' `mon-is-naf-mode-and-llm-p'.\n
:USED-IN `naf-mode'.\n►►►")
;;
;;; ==============================
;;; :NOTE It appears the macro for toggling longlines mode was yanked
;;;       incorrectly as: `mon-is-naf-mode-and-llm-p' ;<-wrong! It should have
;;;       been: `mon-naf-mode-toggle-restore-llm' So, MON wound up inadverdently
;;;       _undoing_ all of the macro wraps in this file :TESTING this again in:
;;;       :FILE naf-insertion-utils.el 
;;;       :AS-OF <Timestamp: #{2009-09-26T18:19:57-04:00Z}#{09396} - by MON>
;;; :CREATED <Timestamp: #{2009-09-08T15:52:50-04:00Z}#{09372} - by MON KEY>
(defmacro mon-naf-mode-toggle-restore-llm (&rest body)
  "Wrapper macro to temporarily toggle `longlines-mode' in `naf-mode' buffers.\n
:EXAMPLE\n\n
\(pp-macroexpand-expression '\(mon-naf-mode-toggle-restore-llm \"bubba\"\)\)\n
:SEE-ALSO `mon-is-naf-mode-and-llm-p', `mon-is-naf-mode-p'.\n►►►"
  (declare (indent 1) (debug t))
  (let ((llm-toggled (make-symbol "llm-toggled")))
    `(let ((,llm-toggled (if (mon-is-naf-mode-and-llm-p) t nil)))
       (when ,llm-toggled (longlines-mode 0))
       (unwind-protect
            ,@body
	 (when ,llm-toggled (longlines-mode 1))))))
;;
;;; :TEST-ME (pp-macroexpand-expression '(mon-naf-mode-toggle-restore-llm "bubba"))

;;; ==============================
;; :REGEXP-OPERATIONS-ON-REGION-AND-BUFFER

;;; ==============================
;;; :COURTESY Pascal J. Bourguignon :HIS pjb-strings.el :WAS `iso-latin-1-approximation'
(defvar *iso-latin-1-approximation* nil 
  "An array mapping ISO-8859-1 characters to ASCII-characters.\n
:SEE-ALSO `mon-cln-iso-latin-1', `mon-make-iso-latin-1-approximation',
`mon-trans-cp1252-to-latin1'.\n►►►")
;;
;;; :COURTESY Pascal J. Bourguignon :HIS pjb-strings.el :WAS `make-iso-latin-1-approximation'
(defun mon-make-iso-latin-1-approximation ()
"Helper function for `mon-cln-iso-latin-1'.\n
:SEE-ALSO `*iso-latin-1-approximation*',`mon-make-iso-latin-1-approximation',
`mon-trans-cp1252-to-latin1'.\n►►►"
  (setq *iso-latin-1-approximation* (make-vector 256 0))
  (loop for i from 0 to 127 
     do (aset *iso-latin-1-approximation* i i))
  (loop for i from 128 below 160 
     for c from 0 below 32 
     do (aset *iso-latin-1-approximation* i c))
  (loop for i from 160 to 255
     for c across (concat " !cL$Y|S\"Ca<--R\"o~23'uP.,1o>***?"
                          "AAAAAAECEEEEIIIITNOOOOOxOUUUUYPs"
                          "aaaaaaeceeeeiiiitnooooo/ouuuuypy")
     do (aset *iso-latin-1-approximation* i c))       
  *iso-latin-1-approximation*)
;;
;;; :COURTESY Pascal J. Bourguignon :HIS pjb-strings.el :WAS `string-remove-accents'
(defun mon-cln-iso-latin-1 (string)
  "Replace in string all accented characters with an unaccented version.
This is done only for ISO-5581-1 characters. Return the modified string.\n
:SEE-ALSO `*iso-latin-1-approximation*', `mon-make-iso-latin-1-approximation',
`mon-trans-cp1252-to-latin1'.\n►►►"
  (unless *iso-latin-1-approximation* 
    (mon-make-iso-latin-1-approximation))
  (let ((result (make-string (length string) 0)))
    (loop for p from 0 below (length string)
          do 
          (aset result p (aref *iso-latin-1-approximation* 
                               (% (aref string p) 256))))
    result))

;;; ==============================
;;; :COURTESY Pascal J. Bourguignon :HIS pjb-strings.el :WAS `deftranslation'
(defmacro deftransmogrify (table string language translated-string)
  "A transmogrifier.\n
:SEE `mon-transmogrify' for implementation details.\n
:SEE-ALSO .\n►►►"
  `(progn
     (unless (and (boundp (quote ,table)) ,table)
       (setq ,table (make-vector 7 0)))
     (put (intern ,string ,table)
          ,language 
          (if (eq ,translated-string :idem) ,string ,translated-string))))
;;
;;; :COURTESY Pascal J. Bourguignon :HIS pjb-strings.el :WAS `localize'
;;; :HIS pjb-invoices.el.restore :WAS `invoice-strings'
;;; :SEE (URL `http://www.informatimago.com/develop/emacs/index.html')
(defun mon-transmogrify (table language string)
  "Lookup in TABLE the STRING, return the translated version for LANGUAGE.\n
:EXAMPLE
\(defvar *transmog-ex* nil \"Localization data for this module.\"\)
\(mapcar \(lambda \(slt\) \(deftransmogrify *transmog-ex* \(nth 0 slt\) \(nth 1 slt\) \(nth 2 slt\)\)\)
	'\(\(\"Phone:\" :en :idem\)
	  \(\"Phone:\" :fr \"Téléphone :\"\)
	  \(\"Phone:\" :es \"Teléfono :\"\)
	  \(\"Téléphone :\" :fr :idem\)
	  \(\"Téléphone :\" :es \"Teléfono :\"\)
	  \(\"Téléphone :\" :en \"Phone:\"\)
	  \(\"Billing address:\" :en :idem\)
	  \(\"Billing address:\" :fr \"Adresse de facturation :\"\)
	  \(\"Billing address:\" :es \"Dirección de factura :\"\)
	  \(\"Dirección de factura :\" :es :idem\)
	  \(\"Dirección de factura :\" :fr \"Adresse de facturation :\"\)
	  \(\"Dirección de factura :\" :en \"Billing address:\"\)\)\)
\(mon-transmogrify *transmog-ex* :fr  \"Billing address:\"\)
=>\"Adresse de facturation :\"
\(mon-transmogrify *transmog-ex* :es  \"Billing address:\"\)
=>\"Dirección de factura :\"
\(mon-transmogrify *transmog-ex* :en  \"Dirección de factura :\"\)
\"Billing address:\"
\(mon-transmogrify *transmog-ex*  :es  \"Phone:\" \)
=>\"Teléfono :\"
\(mon-transmogrify *transmog-ex*  :fr  \"Phone:\" \)
=>\"Téléphone :\"
\(mon-transmogrify *transmog-ex*  :en \"Téléphone :\"\)
=>\"Phone:\"
Pascal Bourguignon's functions have extensive examples:
:SEE `invoice-strings' in :HIS
:FILE ../site-lisp/pjb/emacs-files/pjb-invoices.el.restore\n
:SEE-ALSO `deftransmogrify'.\n►►►"
  (let ((sym (intern-soft string table)))
    (if sym 
        (let ((result (get sym language))) 
          (if result 
              result
              (mon-transmogrify table :en string)))
        string)))

;;; ==============================
;;; :COURTESY :FILE format.el
;;; :CREATED <Timestamp: #{2009-08-20T16:58:13-04:00Z}#{09344} - by MON KEY>
(defun mon-replace-strings (alist &optional reverse beg end)
  "Do multiple replacements in *<BUFFER>*.\n
ALIST is a list of \(FROM . TO\) pairs, which should be proper arguments to
`search-forward' and `replace-match', respectively.\n
When REVERSE is non-nil the pairs are (TO . FROM), which allows use of the same
list in both directions if it contains only literal strings. 
Optional args BEG and END specify a region of the buffer on which to operate.\n
:SEE-ALSO `mon-replace-regexp-while'.\n►►►"
  (save-excursion
    (save-restriction
      (or beg (setq beg (buffer-end 0)))
      (if end (narrow-to-region (buffer-end 0) end))
      (while alist
	(let ((from (if reverse (cdr (car alist)) (car (car alist))))
	      (to   (if reverse (car (car alist)) (cdr (car alist)))))
	  (goto-char beg)
	  (while (search-forward from nil t)
	    (goto-char (match-beginning 0))
	    (insert to)
	    (set-text-properties (- (point) (length to)) (point)
				 (text-properties-at (point)))
	    (delete-region (point) (+ (point) (- (match-end 0)
						 (match-beginning 0)))))
	  (setq alist (cdr alist)))))))

;;; ==============================
;;; :COURTESY Nelson H. F. Beebe :HIS clsc.el :VERSION 1.53 of 2001-05-27
;;; :WAS `clsc-replace-regexp' -> `mon-replace-regexp-while'
(defun mon-replace-regexp-while (regexp to-string)
  "Like `replace-regexp', except be silent about it.\n
:SEE-ALSO `mon-replace-string-while'.\n►►►"
  (while (re-search-forward regexp nil t)
    (replace-match to-string nil nil)))

;;; ==============================
;;; :COURTESY Nelson H. F. Beebe :HIS clsc.el :VERSION 1.53 of 2001-05-27
;;; :WAS `clsc-replace-string' -> `mon-replace-string-while'
(defun mon-replace-string-while (from-string to-string)
  "Like `replace-string', except be silent about it.\n
:SEE-ALSO `mon-replace-regexp-while'.\n►►►"
  (while (re-search-forward from-string nil t)
    (replace-match to-string nil t)))

;;; ==============================
(defun mon-regexp-filter (regexp list)
  "Filter LIST of strings with REGEXP Return filtered list.\n
:EXAMPLE\n\(mon-regexp-filter  \"en\"
 \'\(\"one\" \"two\" \"three\" \"four\" \"five\"
   \"six\" \"seven\" \"eight\" \"nine\" \"ten\"\)\)\n
:SEE-ALSO `filter-buffer-substring'.\n►►►"
      (let (new)
	(dolist (string list)
	  (when (string-match regexp string)
	    (setq new (cons string new))))
	(nreverse new)))

;;; ==============================
;;; :COURTESY Xah Lee :WAS `canonicalString'
;;; :SEE (URL `http://xah-forum.blogspot.com/2009_03_08_archive.html')
;;; 2009-03-10 > emacs lisp > pairs
;;;  On Mar 9, 7:14 pm, Richard Riley wrote:
;;;  ``Could someone please recommend the best way to remove the 3 similar lines
;;;  doing string-match on the "account" assign and iterate a variable list to
;;;  which I can "add-to-list" in other .el libraries for example?''
;;; ,----
;;; | (if (message-mail-p)
;;; |        (save-excursion
;;; | 	 (let* ((from (save-restriction
;;; | 			(message-narrow-to-headers)
;;; | 			(message-fetch-field "from")))
;;; | 		(account (cond ((string-match ".*root.*" from)"richardriley")
;;; | 			       ((string-match ".*richardriley.*" from)"richardriley")
;;; | 			       ((string-match ".*rileyrgdev.*" from)"rileyrgdev"))))
;;; | 	   (setq message-sendmail-extra-arguments (list "-a" account))))))
;;; `----
;;; Xah's response: "Perhaps something like the following, The code is tested:"
;;;
;;; :CREATED <Timestamp: Wednesday April 29, 2009 @ 12:49.37 PM - by MON KEY>
;;; ==============================
(defun mon-canonical-string (from pairs)
  "Return the canonical string of FROM, determined by the pairs in PAIRS.\n
The PAIRS should be a nested vector of the form:\n
\"[[\"a\" \"α\"] [\"b\" \"β\"] [\"γ\" \"g\"] ...]\"
Where the first element is a regex string to be matched with FROM.
When a match is found retunn the second element.
Retrun nil when no match is found.\n
:EXAMPLE\n\(mon-canonical-String \"b\" [[\"a\" \"α\"] [\"b\" \"β\"] [\"γ\" \"g\"]])\n
:SEE-ALSO `mon-regexp-filter', `filter-buffer-substring'.\n►►►"
  (let (totalItems matchFound i result)
    (setq totalItems (length pairs))
    (setq matchFound nil) ;; <- Instead of `(setq foundMatch nil)' 
    (setq i 0)
    (while (and (not matchFound)
		(not (= i totalItems)))
      (if (string-match (elt (elt pairs i) 0) from)
	  (progn
	    (setq result (elt (elt pairs i) 1))
	    (setq matchFound t)))
      (setq i (1+ i)))
    result))
;;
;;; :TEST-ME (mon-canonical-string "b" [["a" "α"] ["b" "β"] ["γ" "g"]]) ;-> β
;;; :TEST-ME (mon-canonical-string "a" [["a" "α"] ["b" "β"] ["γ" "g"]]) ;-> α
;;; :TEST-ME (mon-canonical-string "γ" [["a" "α"] ["b" "β"] ["γ" "g"]]) ;-> g

;;; ==============================
;;; :COURTESY Xah Lee :SEE (URL `http://www.xahlee.org')
;;; :MODIFICATIONS `search-forward'   -> `search-forward-regexp'
;;;                `buffer-substring' -> `buffer-substring-no-properties'
(defun replace-string-pairs-region3 (start end mylist)
  "Replace string in region with each elt's string pairs in MYLIST.\n
The car of MYLIST is the target string cadr is the replacement string.
The cadr can be a subexp to replace with.\n
NOTE: To clean discarding text-properties use:
 `replace-string-pairs-region-no-props'.\n
:EXAMPLE\n(replace-string-pairs-region3 start end 
 '((\"alpha\" \"A\") (\"beta\" \"B\")))\n
:SEE-ALSO `replace-string-pairs-region', `mon-replace-region-regexp-lists'
`mon-replace-region-regexp-lists-nonint'.\n\n:USED-IN `naf-mode'.\n►►►"
  (let (mystr)
    ;;  (setq mystr (buffer-substring start end))
    ;;    (setq mystr (filter-buffer-substring start end nil t)) 
    (setq mystr (buffer-substring-no-properties start end))
    (save-excursion
      (setq mystr
            (with-temp-buffer
            (insert mystr)
            (mapc
             (lambda (arg)
               (goto-char (buffer-end 0))
               (while (search-forward-regexp (car arg) nil t) 
                 (replace-match (cadr arg) t t) ))
             mylist)
            (buffer-string))))
    (delete-region start end)
    (insert mystr)))

;;; ==============================
(defun replace-string-pairs-region-no-props (start end mylist) 
  "Replace string pairs of MYLIST in region do not retain text properties.\n
Search string and replace string are literal.
The car of MYLIST is the target string cadr is the replacement string.
The cadr can be a subexp to replace with.\n
:EXAMPLE\n\(replace-string-pairs-region-no-props start end\n
 '((\"alpha\" \"A\") (\"beta\" \"B\")))\n
:SEE-ALSO `replace-string-pairs-region',
`mon-replace-string-pairs-region-no-insert', `mon-replace-region-regexp-lists',
`mon-replace-region-regexp-lists-nonint'.\n :USED-IN `naf-mode'.\n►►►"
  (let (mystr)
    ;; (setq mystr (filter-buffer-substring start end nil t)) 
    (setq mystr (buffer-substring-no-properties start end))
    (save-excursion
      (setq mystr
            (with-temp-buffer
              (insert mystr)
              (mapc
               (lambda (arg)
                 (goto-char (buffer-end 0))
                 (while (search-forward-regexp (car arg) nil t) 
                   (replace-match (cadr arg) t t) ))
               mylist)
              (buffer-string))))
    (delete-region start end)
    (insert mystr)))

;;; ==============================
;;; :CREATED <Timestamp: #{2009-09-24T12:55:24-04:00Z}#{09394} - by MON KEY>
(defun mon-replace-string-pairs-region-no-insert (start end mylist) 
  "Return replace string pairs in region.\n
Does not retain text properties. Does not insert results.
Search string and replace string are literal.
car of mylist is the target string cadr is the replacement string.
cadr can be a subexp to replace with.\n
:EXAMPLE\n\(mon-replace-string-pairs-region-no-insert
 \(1+ \(search-forward-regexp \"►\"\)\) \(- \(search-forward-regexp \"►\"\) 2\)
 '((\"^alpha\" \"A\") (\"^beta\" \"B\") (\"^delta\" \"D\") (\"^epsilon\" \"E\")\)\)\n
►\nalpha\nbeta\ndelta\nepsilon\n►\n
:SEE-ALSO `replace-string-pairs-region', `mon-replace-region-regexp-lists',
`mon-replace-region-regexp-lists-nonint'.\n►►►"
  (let (mystr)
    (setq mystr (buffer-substring-no-properties start end))
    (save-excursion
      (setq mystr
            (with-temp-buffer
              (insert mystr)
              (mapc #'(lambda (arg)
                        (goto-char (buffer-end 0))
                        (while (search-forward-regexp (car arg) nil t) 
                          (replace-match (cadr arg) t t) ))
                    mylist)
              (buffer-substring-no-properties (buffer-end 0) (buffer-end 1)))))
    mystr))
;;
;;; :TEST-ME 
;;; (mon-replace-string-pairs-region-no-insert
;;;  (1+ (search-forward-regexp "►")) (- (search-forward-regexp "►") 2)
;;;  '(("^alpha" "A") ("^beta" "B") ("^delta" "D") ("^epsilon" "E")))
;;
;; ,---- :UNCOMMENT-BELOW-TO-TEST
;; | ►
;; | alpha 
;; | beta
;; | delta
;; | epsilon
;; | ►
;; `----

;;; ==============================
;;; :CREATED <Timestamp: Wednesday February 04, 2009 @ 07:04.37 PM - by MON KEY>
(defun mon-get-list-yorp ()
  "Template for accumulating a list from symbols holding lists.\n
:NOTE Originally a help function to interactively pass symbol bound regexp lists
      as invoked by `mon-replace-region-regexp-lists'.\n
:SEE-ALSO `mon-get-list-norp', `mon-replace-region-regexp-lists-nonint'.\n►►►"
  (interactive)
  (let* ((read-a-list (eval (read-from-minibuffer "Give Symbol holding list: " nil nil t))))
    (while (yes-or-no-p "Enter another list :")
      (let* ((temp-list read-a-list)
             (gimme (eval (read-from-minibuffer "Give Symbol holding list :" nil nil t))))
        (setq read-a-list (append temp-list (mapc 'car gimme)))))
    read-a-list))

;;; ==============================
;;; :CREATED <Timestamp: Wednesday February 04, 2009 @ 07:04.37 PM - by MON KEY>
(defun mon-get-list-norp (a args) ;;&rest args)
  "Template form accumulating a list from symbols holding lists.\n
:NOTE Originally a help function to interactively pass symbol bound regexp
lists at invocation. Body is now incorporated in:
`mon-replace-region-regexp-lists-nonint'.\n
:SEE-ALSO `mon-get-list-yorp', `mon-replace-region-regexp-lists'.\n►►►"
  (let ((head-norp a)
        (tail-norp args))
    (while tail-norp
      (setq head-norp (append head-norp (car tail-norp)))
      (setq tail-norp (cdr tail-norp)))
    head-norp))

;;; ==============================
;;; :TODO Rebuild this to actually take a `start' and `end' arg. 
;;; :WORKING-AS-OF (but WRONG!!)
;;; :CREATED <Timestamp: Wednesday February 04, 2009 @ 07:04.30 PM - by MON KEY>
(defun mon-replace-region-regexp-lists-nonint (start end hd &rest rst)
  "Non-interactive version of `mon-replace-region-regexp-lists'.
Used as a helper function to search over symbol bound regexp lists.\n
:EXAMPLE\n\(defun hah \(start end\) \(interactive \"r\"\)
\(mon-replace-region-regexp-lists-nonint test-aaa test-bbb test-ccc test-ddd\)\)\n
:SEE-ALSO `mon-get-list-yorp', `mon-get-list-norp'.\n►►►"
  (let* ((reg-bnds `(,start . ,end))
	 (my-list  (mon-get-list-norp hd rst))
	 (rep-tip  (mapcar #'car my-list))
	 (rep-tail (mapcar #'cadr my-list))
         rep-count
         rep-region)
    (mon-naf-mode-toggle-restore-llm
        (setq rep-region 
              (buffer-substring-no-properties start end))
      (setq rep-region 
            (with-temp-buffer
              (insert rep-region)
              (goto-char (buffer-end 0))
              (setq rep-count 0)
              (while rep-tip
                (while (search-forward-regexp (car rep-tip) nil t)
                  (replace-match (car rep-tail))
                  (setq rep-count (+ rep-count 1)))
                ;;(message "Replaced regexp \'%s\' %d times with \'%s\'\n"
                ;;           (car rep-tip) rep-count (car rep-tail)))
                (when (not (search-forward-regexp (car rep-tip) nil t))
                  (setq rep-count 0)
                  (setq rep-tip (cdr rep-tip))
                  (setq rep-tail (cdr rep-tail))
                  (goto-char (buffer-end 0))))
              (buffer-string)))
      (delete-region start end)
    (insert rep-region))))

;;; ==============================
;;; :CREATED <Timestamp: #{2010-02-22T18:50:45-05:00Z}#{10081} - by MON KEY>
(defun mon-regexp-map-match (big-regexp big-grp-start big-grp-end)
  "Return a mapped list of conses for match groups and mapstrings.\n
BIG-REGEXP is a dense regexp to search.
BIG-GRP-START is the match-group to map from.
BIG-GRP-END is the match-group to map from.\n
:EXAMPLE\n\n\(save-excursion
  \(let \(\(rsd *regexp-symbol-defs*\)
        rsd-collect\)
    \(dotimes \(r 3 \(setq rsd-collect \(nreverse rsd-collect\)\)\)
      \(push \(mon-regexp-map-match rsd 0 \(regexp-opt-depth rsd\)\) rsd-collect\)\)\)\)\n\n
\(defun some-function \(&optional optional\)
\(defun some-function-22 \(&optional optional\)
\(defun *some/-symbol:->name<-2* \(somevar\n
:SEE-ALSO .\n►►►"
  (progn (search-forward-regexp big-regexp nil t)
       (mapcar #'(lambda (n)
                   (cons n (match-string-no-properties n)))
               (number-sequence big-grp-start big-grp-end))))
;;
;;; :NOTE Not a realistic test example. But a nice loop so keeping.
;;; (let* ((big-string (documentation 'lisp-interaction-mode))
;;;        (split-times (/ (length big-string) 100))
;;;        split-str)
;;;   (do* ((i 0 (1+ i))
;;;         (j i (* i 100))
;;;         (k 100 (+ j 99)))
;;;        ((>= i (1- split-times))
;;;         (setq split-str 
;;;               (mapconcat #'identity  
;;;                          (mapcar #'(lambda (sp-st) 
;;;                                      (let ((tst-str (regexp-opt (split-string sp-st nil t))))
;;;                                        (if (string= (substring tst-str 0 4) "\\(?:")
;;;                                            (setq tst-str (concat "\\(" (substring tst-str 4)))
;;;                                            tst-str)))
;;;                                  (nreverse split-str)) "")))
;;;     (push (substring big-string j k) split-str)))

;;; ==============================
;;; :MODIFICATIONS <Timestamp: #{2009-08-31T12:12:52-04:00Z}#{09361} - by MON KEY>
;;; :CREATED <Timestamp: Wednesday February 04, 2009 @ 07:04.37 PM - by MON KEY>
(defun mon-replace-region-regexp-lists (start end &optional regexp-list with-results intrp)
  "Interactive version of `mon-replace-region-regexp-lists-nonint'.\n
Prompt for args of symbol bound regexp lists. 
Replace elts of REGEXP-LIST a symbol holding a list of regexp/replace pairs.
Forms of symbol are searched across region until elements of supplied lists
are exhausted. When WITH-RSULTS is non-nil spit replacement results for each
elt of REGEXP-LIST to *Messages*.\n
:SEE-ALSO `mon-get-list-yorp', `mon-get-list-norp'.\n►►►"
  (interactive "r\n\i\nP\np")
  (let* ((rep-region)
	 (rep-region-temp)
	 (rep-count)
	 (my-list (if intrp (call-interactively 'mon-get-list-yorp)
                    regexp-list))
	 (rep-region (buffer-substring-no-properties start end))
         (w/rslts with-results)
         (rep-repl-msg))
         (save-excursion 
           (setq rep-region-temp
          (with-temp-buffer
            (let ((rep-tip (mapcar #'car my-list))
                  (rep-tail (mapcar #'cadr my-list)))
            (setq rep-count 0)
            (insert rep-region)
	    (goto-char (buffer-end 0))
            (while rep-tip
              (if (search-forward-regexp (car rep-tip) nil t)
                  (progn
                    (replace-match (car rep-tail))
                    (setq rep-count (1+ rep-count)))
                (progn 
                  (when w/rslts (setq rep-repl-msg 
                                     (cons
                                      (format "Replaced regexp \'%s\' -> \'%s\' %d times.\n"
                                              (car rep-tip) (car rep-tail) rep-count)
                                      rep-repl-msg)))
                    (setq rep-count 0)
                    (setq rep-tip (cdr rep-tip))
                    (setq rep-tail (cdr rep-tail))
                    (goto-char (buffer-end 0)))))
	    (buffer-substring-no-properties (buffer-end 0) (buffer-end 1)))))
      (delete-region start end)  (insert rep-region-temp))
    (when w/rslts (setq rep-repl-msg (mapconcat #'identity rep-repl-msg ""))
          (cond (intrp (message "%s" rep-repl-msg))
                ((not intrp) (format "%s" rep-repl-msg))))))

;;; ==============================
;;; :CREATED <Timestamp: Monday May 25, 2009 @ 11:46.00 AM - by MON KEY>
(defun mon-cln-csv-fields (field-list &optional delim-slot-w delim-row-w no-list)
  "Clean data pre-formatted for generation of .csv files.
Regexps perform the final conversion. FIELD-LIST is a colon delimited list of
strings each of which is a slot/column key for a given value e.g.:\n
\(\"Name: \" \"Title: \" \"Institution: \" \"Address: \" \"City: \"\"State: \" \"Zipcode: \"\)\n
When non-nil DELIM-SLOT-W specifies delimter seperating values - defalut `,'.\n
When non-nil DELIM-ROW-W specifies delimter seperating value rows - defalut `;'.
Note: don't use `##' as a row or slot delim.\n
When NO-LIST is non-nil return results without parens.\n
Assumes a data structure with fields delimited as:
==============================
\"KEY: \" \"Value\"
\"KEY: \" \"Value\"
\"KEY: \" \"Value\"
==============================\n
:EXAMPLE-DATA-STRUCTURE
==============================\n
Name: Jane Doe
Title: Head of School
Institution: Academy of The Unknown
Address: 111 Some Street
City: Anytown
State: ZZ
Zipcode: 99999\n
==============================\n
:EXAMPLE\n\n\(mon-cln-csv-fields
 '\(\"Name: \" \"Title: \" \"Institution: \" \"Address: \"
   \"City: \" \"State: \" \"Zipcode: \"\)\)\n
\(mon-cln-csv-fields\n '\(\"Name: \" \"Title: \" \"Institution: \" \"Address: \"
   \"City: \" \"State: \" \"Zipcode: \"\) \"+\" nil\)\n
\(mon-cln-csv-fields\n '\(\"Name: \" \"Title: \" \"Institution: \"\"Address: \"
   \"City: \" \"State: \" \"Zipcode: \"\) nil \"_\" t\)\n
\(mon-cln-csv-fields\n '\(\"Name: \" \"Title: \" \"Institution: \"\"Address: \"
   \"City: \" \"State: \" \"Zipcode: \"\) \"@\" \"_\"\)\n
\(mon-cln-csv-fields\n '\(\"Name: \" \"Title: \" \"Institution: \" \"Address: \"
    \"City: \" \"State: \" \"Zipcode: \"\) \"`\" \"|\" t\) \n►►►"
  (interactive)
  (save-excursion
    (let* ((csv-maker field-list)
	   (pnt-strt (make-marker))
	   (f (first csv-maker))
	   (l (car (last csv-maker)))
	   (dsw (cond (;; Using `##' to recover newlines in final cleanup loop.
                       (string-equal delim-slot-w "##") 
		       (error "## is special in this fuction don't use as a row delimiter"))
		      (delim-slot-w delim-slot-w)
		      (t ",")))
	   (drw (cond (;; Using `##' to recover newlines in final cleanup loop.
                       (string-equal delim-row-w "##") 
		       (error "## is special in this fuction don't use as a row delimiter"))
		      (delim-row-w delim-row-w)
		      (t ";")))
	   (reg-dsw  (format "\\(: %s\\)" dsw))
	   (reg-dsw2  (format "\"%s \"" dsw))  	  
	   (oo))
      (setq oo (mapconcat '(lambda (x) (prin1 x )) csv-maker dsw))
      (setq oo (replace-regexp-in-string  reg-dsw "\" \"" oo))
      (setq oo (replace-regexp-in-string "\\(: \\)" "\"" oo))
      (setq oo (replace-regexp-in-string "\\(\" \"\\)" reg-dsw2 oo))
      (if no-list
	  (setq oo (concat "\"" oo drw "##")) 
	(setq oo (concat "(\"" oo ")" drw "##")))
      (set-marker pnt-strt (point))
      (insert oo)     
      (while csv-maker
	(let* ((srch-hd (car csv-maker))
	       (hd (concat "^\\(\\(" srch-hd "\\)\\(.*\\)\\)$")))
	  (while (search-forward-regexp hd nil t)
	    (cond ((string= srch-hd f)
		   (if no-list
                       ;; _Do not_ put leadnig `('
		       (replace-match (format "\"\\3\"%s" dsw))	
                       ;;_Do_ put leadnig `('
                       (replace-match (format "\(\"\\3\"%s" dsw)))) 
		  ((string= srch-hd l)
		   (if no-list
		       (replace-match (format "\"\\3\"%s##" drw))
		     (replace-match (format "\"\\3\"\)%s##" drw))))
		  (t (replace-match (format"\"\\3\"%s" dsw)))))
	  (setq csv-maker (cdr csv-maker))
	  (goto-char (marker-position pnt-strt))))
      (goto-char (marker-position pnt-strt))
      (while (search-forward-regexp "==============================" nil t)
	(replace-match ""))
      (goto-char (marker-position pnt-strt))
      (while (> (buffer-end 1) (point))
	(end-of-line)
	(when (and (not (eobp)) (eolp) (= (char-after (point)) 10))
	  (delete-char 1)))
      (goto-char (marker-position pnt-strt))
      ;; (while (> (buffer-end 1) (point))
      (let* ((drw-l (length drw))
	     (drw-end (substring drw (- drw-l 1) drw-l))
	     (drw-e-char (string-to-char drw-end)))
	(while (search-forward-regexp (format "\\(%s##\\)" drw) nil t)
	  (when (and			;(not (eobp)) 
		 (= (char-before (point)) 35)
		 (= (char-before (- (point) 1)) 35)
		 (= (char-before (- (point) 2)) drw-e-char)) 
	    (replace-match (format "%s\n" drw))))))))
;;
;; ,---- :UNCOMMENT-BELOW-TO-TEST
;; | (mon-cln-csv-fields
;; |  '("Name: " "Title: " "Institution: " "Address: " "City: " "State: " "Zipcode: "))	      
;; | (mon-cln-csv-fields
;; |  '("Name: " "Title: " "Institution: " "Address: " "City: " "State: " "Zipcode: ") "+" nil)  
;; | (mon-cln-csv-fields
;; |  '("Name: " "Title: " "Institution: ""Address: " "City: " "State: " "Zipcode: ") nil "_" t) 
;; | (mon-cln-csv-fields 
;; |  '("Name: " "Title: " "Institution: ""Address: " "City: " "State: " "Zipcode: ") "@" "_")
;; | (mon-cln-csv-fields'
;; |  ("Name: " "Title: " "Institution: " "Address: " "City: " "State: " "Zipcode: ") "`" "|" t)
;; `----

;;; ==============================
;;; :CREATED <Timestamp: Saturday May 09, 2009 @ 08:40.30 PM - by MON KEY>
(defun mon-cln-file-name-string (fix-string)
  "Replace chars not allowed in w32 filenams `-'.\n
Chars Cleaned include:\n
`/',  `:',  `*', `?', `\"', `<', `>', `|, `\\'\n
:SEE-ALSO `mon-exchange-slash-and-backslash'.\n►►►"
  (let* ((ff-prefix '("/"  ":"  "*"  "?" "\"" "<" ">" "|" "\\\\" ))
	 (to-fix fix-string))
	 ;;"\\/:*?\"<>|"))
	 (while ff-prefix
	   (let (fixing)
	     (setq fixing (car ff-prefix))
	     (setq to-fix (replace-regexp-in-string fixing "-" to-fix))
	     (setq ff-prefix (cdr ff-prefix))))
	 ;;(print  to-fix)))
	 to-fix))
;;
;;; :TEST-ME (prin1 (mon-cln-file-name-string "\\/:*?\"<>|"))

;;; ==============================
;;; :TODO This needs to be rebuilt using a better helper function/regex-list per
;;;       the newer `mon-replace-region-regexp-lists-nonint'.
;;; :CREATED <Timestamp: Tuesday February 17, 2009 @ 03:27.10 PM - by MON KEY>
(defun mon-cln-html-chars (start end)
  "Replace  <  by  &lt;  and other similar HTML chars that needs to be encoded.
Replace  & ,  > ,  <  with their respective encoded representation.\n
:SEE-ALSO `mon-cln-html-chars', `mon-nuke-html-tags'.\n►►►"
  (interactive "r")
  (replace-string-pairs-region3 start end
			       '(("&" "&amp;")
				 ("<" "&lt;")
				 (">" "&Gt;"))))

;;; ==============================
;;; :COURTESY Noah Friedman :HIS buffer-fns.el :WAS `nuke-html-tags'
;;; :MODIFICATIONS To the regexps for text between tags \">Some</a>\" and
;;; crowded periods at end-of-sentence and between two chars at end-of-sentence
;;; w/out whitespace.
;;; :CREATED <Timestamp: Tuesday February 17, 2009 @ 03:48.22 PM - by MON KEY>
;;; ==============================
(defun mon-cln-html-tags (beg end)
  "Replace common HTML tags with either newline or nil. Poor man's html formatter.\n
:SEE-ALSO `mon-cln-html-chars', `mon-cln-wiki', `mon-cln-philsp', `mon-cln-imdb',
`mon-cln-ulan', `mon-cln-wiki', `mon-cln-imdb',`mon-cln-bib', `mon-cln-loc'.\n►►►"
  (interactive "r")
  (let ((table '(("\n"                               . nil) ;; :NOTE is this correct? - MON
		 ("\\(\\(.>+\\)\\([A-Za-z0-9: :]*\\)\\(</a>\\)\\)" . "\\2 \\3")
                 ("\\(\\(</a>\\)\\(\.\\)\\)" . "\\3")
                 ;; ("<p>"                              . "\n\n")
                 ("<p>\\|<P>"                              . "\n\n")
                 ;;("<br>"                             . "\n")
                 ("<br>\\|<BR>"                             . "\n")
                 ("</?h[0-9]>"                       . "\n\n")
                 ("</?blockquote>"                   . "\n\n")
                 ("&nbsp;"                           . " ")
		 ("\\(&[^ <]*;\\)\\|\\(<[^>]*>\\)" . nil)
		 ("\\([a-z]\\{1,1\\}\\)\\([:.:]\\)\\([A-Z]\\{1,1\\}\\)" . "\\1\\2 \\3")))
        re sub)
    (let* ((test-llm (mon-is-naf-mode-and-llm-p))
           (is-on test-llm)
           (llm-off))
      (progn
        (when is-on (longlines-mode 0) (setq llm-off 't))
	(save-excursion
	  (save-restriction
	    (narrow-to-region beg end)
	    (while table
	      (setq re (car (car table)))
	      (setq sub (cdr (car table)))
	      (setq table (cdr table))
	      (goto-char (buffer-end 0))
	      (cond (sub
		     (while (search-forward-regexp re nil t)
		       (replace-match sub)))
		    (t (while (search-forward-regexp re nil t)
                         (delete-region (match-beginning 0) (match-end 0))))))))
        (when llm-off (longlines-mode 1) (setq llm-off 'nil))))))

;;; ==============================
;;; :CREATED <Timestamp: #{2009-11-17T15:36:11-05:00Z}#{09472} - by MON KEY>
(defun mon-cln-xml<-parsed (fname &optional insrtp intrp)
  "Strip non-sensical strings created by xml-parse-file when trailing CR\LF TAB+
follow an element(s). FNAME is an XML filename path to parse and clean.
When INSERTP is non-nil or called-interactively insert pretty printed lisp
representation of XML file fname at point. Does not move point.
:NOTE Unlike `mon-cln-xml<-parsed-strip-nil' will not strip `nil' from parsed xml.\n
:SEE-ALSO `mon-cln-tgm-xml-LF'\n►►►"
  (interactive "fXML file to parse: \ni\np")
  (let (get-xml)
    (setq get-xml
          (with-temp-buffer
            (prin1 (xml-parse-file fname) (current-buffer))
            (goto-char (buffer-end 0))
            (while (search-forward-regexp 
                    "\\( \"\n[\[:blank:]]+\\)\"\\(\\(\\()\\)\\|\\( (\\)\\)\\)" nil t)
                   ;;^^1^^^^^^^^^^^^^^^^^^^^^^^^^2^^3^^^^^^^^^^^^4^^^^^^^^^^^^
            (replace-match "\\2"))
            (pp-buffer)
            (buffer-substring-no-properties (buffer-end 0) (buffer-end 1))))
    (if (or insrtp intrp)
        (save-excursion 
          (newline) 
          (princ get-xml (current-buffer)))
        get-xml)))
;;
;;; :TEST-ME (mon-cln-xml<-parsed <FNMAME>)

;;; ==============================
;;; :CREATED <Timestamp: Saturday July 04, 2009 @ 11:55.40 AM - by MON KEY>
(defun mon-cln-tgm-xml-LF ()
  "Clean EOL whitespace in tgm->XML conversions.\n
:SEE-ALSO `mon-cln-xml<-parsed', `mon-cln-xml<-parsed-strip-nil'.\n►►►"
  (interactive)
  (save-excursion
    (goto-char (buffer-end 0))
    (while (< (point) (buffer-end 1))
      (progn
        (end-of-line)
        (when
            (and (equal (char-after (point)) 10)
                 (equal (char-after (1+ (point))) 60)
                 (equal (char-after (+ (point) 2)) 47))
          (delete-char 1)))
      (forward-char))))

;;; ==============================
;;; :MODIFICATIONS <Timestamp: #{2009-11-17T17:00:10-05:00Z}#{09472} - by MON KEY>
;;; :CREATED <Timestamp: #{2009-08-31T20:57:30-04:00Z}#{09362} - by MON KEY>
(defun mon-cln-xml<-parsed-strip-nil (fname &optional insrtp intrp)
  "De-string-ification of xml parse results from with `xml-parse-file'.\n
FNAME is a filename path to be parsed and cleaned. 
When INSRTP is non-nil or called-interactively insert result at point.
Does not move point.
:NOTE Strips `nil' from parsed xml which may not be what you expect.\n
:SEE-ALSO `*regexp-clean-xml-parse*', `mon-cln-xml<-parsed',
`mon-cln-tgm-xml-LF'.\n►►►"
  (interactive "fXML file to parse: \ni\np")
  (let (get-xml)
    (setq get-xml
          (with-temp-buffer
            (prin1  (xml-parse-file fname)
                    (current-buffer))
            (goto-char (buffer-end 0))
            (mon-replace-region-regexp-lists (buffer-end 0) (buffer-end 1) *regexp-clean-xml-parse*)
            (buffer-substring-no-properties (buffer-end 0) (buffer-end 1))))
    (if (or insrtp intrp)
    (save-excursion (newline) (princ get-xml (current-buffer)))
    get-xml)))
;;
;;; :TEST-ME (call-interactively 'mon-cln-xml<-parsed-strip-nil)
        
;;; ==============================
;;; :GLOBAL-KEYBINDING (global-set-key "\C-cu:" 'mon-cln-up-colon)
;;; :CREATED <Timestamp: #{2009-12-19T02:39:48-05:00Z}#{09516} - by MON>
(defun mon-cln-up-colon (start end &optional intrp)
  "Insert colonized string in region at BOL.\n
When region's string contains a trailing `:' remove it before inserting.\n
:SEE-ALSO `mon-upcase-commented-lines', `mon-downcase-commented-lines'
`mon-line-strings-bq-qt-sym-bol', `mon-line-strings-indent-to-col',
`mon-line-strings-pipe-bol', `mon-line-strings-pipe-to-col',
`mon-line-strings-qt-region'.\n►►►"
  (interactive "i\ni\np")
  (let ((bl (make-marker))
        (el (make-marker))
        (sstr))
    (set-marker bl (if start start (region-beginning)))
    (set-marker el (if end end (region-end)))
    ;;(save-excursion
      (goto-char bl) (princ ":" (current-buffer))
      (setq sstr (delete-and-extract-region bl el))
      (subst-char-in-string 32 45 sstr t)
      (setq sstr (upcase sstr))
      ;; (setq sstr (replace-regexp-in-string "\\(.*\\):" "\\1" sstr ))
      (setq sstr (if (string-match ":" sstr (1- (length sstr)))
                     (substring sstr 0 (1- (length sstr)))
                     sstr))
      (goto-char bl)
      (princ sstr (current-buffer))))

;;; ==============================
;;; :COURTESY Stefan Reichor :HIS xsteve-functions.el
(defun mon-exchange-slash-and-backslash ()
  "Exchange / with \\ and in the current line.\n
Exchange in region when region-active-p is non-nil.\n
:SEE-ALSO `mon-cln-file-name-string'.\n►►►"
  (interactive)
  (save-match-data
    (save-excursion
      (let ((replace-count 0)
            (eol-pos (if mark-active (region-end) (progn (end-of-line) (point))))
            (bol-pos (if mark-active (region-beginning) (progn (beginning-of-line) (point)))))
        (goto-char bol-pos)
        (while (search-forward-regexp "/\\|\\\\" eol-pos t)
          (setq replace-count (+ replace-count 1))
          (cond ((string-equal (match-string 0) "/") (replace-match "\\\\" nil nil))
                ((string-equal (match-string 0) "\\") (replace-match "/" nil nil)))
          (message (format "%d changes made." replace-count)))))))

;;; ==============================
;;; :CREATED <Timestamp: Thursday May 14, 2009 @ 05:47.46 PM - by MON KEY>
(defun mon-downcase-hex-values ()
  "Downcase all CSS Hex values in buffer.\n
:SEE-ALSO `*regexp-rgb-hex*', `mon-upcase-commented-lines',
`mon-downcase-region-regexp' `mon-cln-up-colon',
`mon-line-strings-bq-qt-sym-bol', ` `mon-line-strings-indent-to-col',
`mon-line-strings-pipe-bol', `mon-line-strings-pipe-to-col'.\n►►►"
  (interactive)
  (save-excursion
    (while (search-forward-regexp "#\\([A-Z]+\\)")
      (downcase-region (match-beginning 1)(match-end 1)))))

;;; ==============================
;;; :CREATED <Timestamp: #{2009-09-17T22:09:21-04:00Z}#{09385} - by MON KEY>
(defun mon-upcase-commented-lines () ;(start end)
  "Upcase everthing in lines that begin with three semicolons \"^;;; \".
Does not move point.\n:NOTE Does not do error checking - so be smart about it.\n
:SEE-ALSO `mon-downcase-commented-lines', `mon-downcase-region-regexp'
`mon-downcase-hex-values' `mon-cln-up-colon', `mon-line-strings-bq-qt-sym-bol',
`mon-line-strings-indent-to-col', `mon-line-strings-pipe-bol', 
`mon-line-strings-pipe-to-col'.\n►►►"
  (interactive) ;;  (interactive "r")
  (save-excursion
    (while (search-forward-regexp "^;;; \\(.*\\)" nil t)
      (upcase-region (match-beginning 1) (match-end 1)))))

;;; ==============================
;;; :CREATED <Timestamp: #{2010-02-15T11:54:54-05:00Z}#{10071} - by MON KEY>
(defun mon-toggle-case-query-user (&optional w-region)
  "Return a list for use as interactive args to case toggling functions.\n
Default is to return a 5 element list suitable for `mon-toggle-case-regexp' e.g..
 \(case-toggle-match up-down &optional replace-n w-results intrp\)\n
When W-REGION is non-nil return with bounds of active region as 7 element list
suitable for use as args to `mon-toggle-case-regexp-region' e.g.:
 \(start end case-toggle-regexp case-up-down &optional limit-to insrtp intrp\)\n
:NOTE when W-REGION is non-nil signals an error when region is inactive.\n
:EXAMPLE\n\n\(mon-toggle-case-query-user)                 ;<- `mon-toggle-case-regexp'\n
\(let \(\(mark-ring nil\)                        ;<- `mon-toggle-case-regexp-region'
      \(current-prefix-arg 2\)\)
  \(save-excursion \(push-mark nil nil t\) \(forward-char 9\)  
                  \(prog1 \(mon-toggle-case-query-user t\) \(pop-mark\)\)\)\)
########\n
:SEE-ALSO `mon-toggle-case-query-user', `mon-toggle-case-regexp-region',
`mon-toggle-case-regexp',
`mon-downcase-regexp', `mon-downcase-region-regexp',
`mon-upcase-regexp', `mon-upcase-region-regexp', 
`mon-downcase-commented-lines', `mon-downcase-hex-values',
`mon-toggle-case-regexp-region', `mon-downcase-hex-values',
`mon-rectangle-downcase', `mon-rectangle-upcase' `mon-upcase-commented-lines'.
►►►"
  (if w-region
      `(,(if (use-region-p) (region-beginning)
             (error ":FUNCTION mon-toggle-case-regexp-region - region not selected"))
         ,(region-end)
         ,(read-regexp "Regexp to search")
         ,(car (read-from-string (completing-read 
                                  "Which way to toggle (up or down): "
                                  [up down] nil t)))
         ,(or current-prefix-arg)
         nil t)
      `(,(read-regexp "Toggle case with regexp: ")
         ,(car (read-from-string (completing-read 
                                  "Which way to toggle (up or down): "
                                  [up down] nil t)))
         ,(or current-prefix-arg 
              (read-number "Provide a positive number to limit case toggling to N times: " -1))
         t t))) 
;;
;;; :TEST-ME (mon-toggle-case-query-user)
;;; :TEST-ME (mon-toggle-case-query-user t)

;;; ==============================
;;; :CREATED <Timestamp: Thursday April 30, 2009 @ 05:08.23 PM - by MON KEY>
(defun mon-toggle-case-regexp-region (start end case-toggle-regexp case-up-down
                                      &optional limit-to insrtp intrp)
  "Return case toggled region from START END for CASE-TOGGLE-REGEXP matches.\n
CASE-UP-DOWN is a symbol `up' or `down'. When ``up'' `upcase-region' of regexp
matches, when ``down'' `downcase-region'.\n
LIMIT-TO is the maximum number of matches to replace.
When optional arg LIMIT-TO times is non-nil limit the amount of times replace .\n
When called-interactively with positve prefix arg use to LIMIT-TO times.
Else, if LIMIT-TO is ommitted prompt for the number of times to replace.
Default is -1 wich case-toggles all CASE-TOGGLE-REGEXP matches in region.\n
When INSRTP is non-nil or called-interactively insert return value in current buffer 
message results of toggling.\n
:SEE-ALSO `mon-toggle-case-query-user', `mon-toggle-case-regexp-region',
`mon-toggle-case-regexp',
`mon-downcase-regexp', `mon-downcase-region-regexp',
`mon-upcase-regexp', `mon-upcase-region-regexp', 
`mon-downcase-commented-lines', `mon-downcase-hex-values',
`mon-toggle-case-regexp-region', `mon-downcase-hex-values',
`mon-rectangle-downcase', `mon-rectangle-upcase' `mon-upcase-commented-lines'.
\n►►►"
  (interactive (funcall 'mon-toggle-case-query-user t))
  (let (rtn-dcrr)
    (setq rtn-dcrr (buffer-substring-no-properties start end)) ;; mdrr-str mdrr-end
    (setq rtn-dcrr
          (with-temp-buffer 
            (save-excursion (insert rtn-dcrr))
            (let ((mdr (mon-toggle-case-regexp case-toggle-regexp case-up-down limit-to (or insrtp intrp))))
              (setq mdr (cons (buffer-substring-no-properties (buffer-end 0) (buffer-end 1)) mdr)))))
    (if (or insrtp intrp)
        (save-excursion 
          (delete-region start end)
          (insert (pop rtn-dcrr))
          (message rtn-dcrr))
        rtn-dcrr)))
;;
;;; :EXAMPLE\n\"^\\(#[A-Z0-9]\\{6,6\\}$\\)\" REPLACE-N => 4
;;; #AEAE4D\n#D29966\n#C3A399\n#D3CD99\n#D0CCCC\n#FFFFCC\n
;; (mon-toggle-case-regexp "^\\(#[A-Z0-9]\\{6,6\\}$\\)\" 'down)

;;; ==============================
;;; :MODIFICATIONS <Timestamp: #{2010-02-13T16:44:19-05:00Z}#{10066} - by MON KEY>
;;; :CREATED <Timestamp: Thursday April 30, 2009 @ 05:08.23 PM - by MON KEY>
(defun mon-toggle-case-regexp (case-toggle-match up-down &optional replace-n w-results intrp)
  "Case-toggle matches for the regexp CASE-TOGGLE-MATCH after point.
UP-DOWN is symbol `up' or `down'.
When optional arg REPLACE-N times is non-nil limit the amount of times replace .\n
When called-interactively with positve prefix arg use to REPLACE-N times.
Else, if REPLACE-N is ommitted prompt for the number of times to replace.
Default is -1 which means to case-toggle all matches after point.
When W-RESULTS is non-nil or called-interactively message results.\n
:EXAMPLE\n\n\
\(mon-toggle-case-regexp \"^\\\\(#[A-Z0-9]\\\\\\={6,6\\\\}$\\\\)\" 'down 3 t\)\n
#AEAE4D\n#D29966\n#C3A399\n#D3CD99\n#D0CCCC\n#FFFFCC\n
:SEE-ALSO `mon-toggle-case-query-user', `mon-toggle-case-regexp-region',
`mon-toggle-case-regexp',
`mon-downcase-regexp', `mon-downcase-region-regexp',
`mon-upcase-regexp', `mon-upcase-region-regexp', 
`mon-downcase-commented-lines', `mon-downcase-hex-values',
`mon-toggle-case-regexp-region', `mon-downcase-hex-values',
`mon-rectangle-downcase', `mon-rectangle-upcase' `mon-upcase-commented-lines'.
\n►►►"
  (interactive (funcall 'mon-toggle-case-query-user))
  (let ((m-count 0)
        (repcnt  (cond ((and replace-n (minusp replace-n)) nil)
                       (replace-n)))
        (ud (cond ((eq up-down 'up) 'upcase-region)
                  ((eq up-down 'down) 'downcase-region)
                  (t (error (concat ":FUNCTION mon-toggle-case-regexp"
                                    "- arg UP-DOWN either up or down")))))
        msg)
    (while (search-forward-regexp case-toggle-match nil t)
      (unless (and repcnt (= m-count repcnt))
	(let* ((m-start  (match-beginning 1))
	       (m-end    (match-end 1))
	       (m-string (buffer-substring-no-properties m-start m-end)))
	  (funcall ud m-start m-end)
	  (setq m-count (+ m-count 1))
          (if (or w-results intrp)
              (setq msg (cons 
                         (format "(:MATCH-NUMBER %d :MATCH-START %s :MATCH-END %s :MATCHED %s)"
                                 m-count m-start m-end m-string) msg))))))
    (when (or w-results intrp)
      (setq msg (reverse msg))
      (setq msg (mapconcat #'identity msg "\n"))
      (if intrp (message (concat "Toggled case in following ranges:\n" msg))
          msg))))
;;
;; ,---- :UNCOMMENT-BELOW-TO-TEST
;; | (mon-toggle-case-regexp "^\\(#[A-Z0-9]\\{6,6\\}$\\)" 'down 3 t)
;; | #AEAE4D
;; | #D29966
;; | #C3A399
;; | #D3CD99
;; | #D0CCCC
;; | #FFFFCC
;; `----

(defun mon-downcase-regexp-region (dc-start dc-end toggle-case-regexp
                                   &optional limit-to insrtp intrp)
  "Downcase each match of TOGGLE-CASE-REGEXP in region from DC-START to DC-END.
When REPLACE-TIMES is non-nil limit upcasing of matches to N times.  When
WITH-RESULTS is non-nil or called-interactively return results of matches that
were upcased.\n
:SEE-ALSO `mon-toggle-case-query-user', `mon-toggle-case-regexp-region',
`mon-toggle-case-regexp',
`mon-downcase-regexp', `mon-downcase-region-regexp',
`mon-upcase-regexp', `mon-upcase-region-regexp', 
`mon-downcase-commented-lines', `mon-downcase-hex-values',
`mon-toggle-case-regexp-region', `mon-downcase-hex-values',
`mon-rectangle-downcase', `mon-rectangle-upcase' `mon-upcase-commented-lines'.
\n►►►"
  (interactive "i\ni\ni\ni\ni\np")
  (if intrp (call-interactively 'mon-toggle-case-regexp-region)
      (eval `(mon-toggle-case-regexp-region ,dc-start ,dc-end ,toggle-case-regexp 'down
                                            ,limit-to))))

(defun mon-upcase-regexp-region (uc-start uc-end toggle-case-regexp
                                 &optional limit-to insrtp intrp)
  "Upcase each match of TOGGLE-CASE-REGEXP in region from UC-START to UC-END.
When REPLACE-TIMES is non-nil limit upcasing of matches to N times.  When
WITH-RESULTS is non-nil or called-interactively return results of matches that
were upcased.\n
:EXAMPLE\n\n
:SEE-ALSO `mon-toggle-case-query-user', `mon-toggle-case-regexp-region',
`mon-toggle-case-regexp',
`mon-downcase-regexp', `mon-downcase-region-regexp',
`mon-upcase-regexp', `mon-upcase-region-regexp', 
`mon-downcase-commented-lines', `mon-downcase-hex-values',
`mon-toggle-case-regexp-region', `mon-downcase-hex-values',
`mon-rectangle-downcase', `mon-rectangle-upcase' `mon-upcase-commented-lines'.
►►►"
  (interactive "i\ni\ni\ni\ni\np")
  (if intrp (call-interactively 'mon-toggle-case-regexp-region)
      (eval `(mon-toggle-case-regexp-region ,uc-start ,uc-end ,toggle-case-regexp 'up
                                            ,limit-to ,insrtp))))

;;; ==============================
;;; :CREATED <Timestamp: #{2010-02-13T20:51:06-05:00Z}#{10067} - by MON KEY>
(defun mon-downcase-regexp (match-on &optional replace-times with-results intrp)
  "Downcase each match of regpexp MATCH-ON.\n
When REPLACE-TIMES is non-nil limit upcasing of matches to N times.  When
WITH-RESULTS is non-nil or called-interactively return results of matches that
were upcased.\n
:EXAMPLE\n\n
:SEE-ALSO `mon-toggle-case-query-user', `mon-toggle-case-regexp-region',
`mon-toggle-case-regexp',
`mon-downcase-regexp', `mon-downcase-region-regexp',
`mon-upcase-regexp', `mon-upcase-region-regexp', 
`mon-downcase-commented-lines', `mon-downcase-hex-values',
`mon-toggle-case-regexp-region', `mon-downcase-hex-values',
`mon-rectangle-downcase', `mon-rectangle-upcase' `mon-upcase-commented-lines'.
►►►"
  (interactive "i\n\i\ni\np")
  (if intrp 
      (call-interactively 'mon-toggle-case-regexp)
      (eval `(mon-toggle-case-regexp ,match-on 'down ,replace-times ,with-results))))
;;
;;; :TEST-ME (mon-downcase-regexp "^\\(#[A-Z0-9]\\{6,6\\}$\\)" nil t)
;;; ==============================
;;; :CREATED <Timestamp: #{2010-02-13T21:01:22-05:00Z}#{10067} - by MON KEY>
(defun mon-upcase-regexp (match-on &optional replace-times with-results intrp)
  "Upcase each match of regpexp MATCH-ON.\n
When REPLACE-TIMES is non-nil limit upcasing of matches to N times.  When
WITH-RESULTS is non-nil or called-interactively return results of matches that
were upcased.\n
:EXAMPLE\n\n
:SEE-ALSO `mon-toggle-case-query-user', `mon-toggle-case-regexp-region',
`mon-toggle-case-regexp',
`mon-downcase-regexp', `mon-downcase-region-regexp',
`mon-upcase-regexp', `mon-upcase-region-regexp', 
`mon-downcase-commented-lines', `mon-downcase-hex-values',
`mon-toggle-case-regexp-region', `mon-downcase-hex-values',
`mon-rectangle-downcase', `mon-rectangle-upcase' `mon-upcase-commented-lines'.
►►►"
  (interactive "i\n\i\ni\np")
  (if intrp 
      (call-interactively 'mon-toggle-case-regexp)
      (eval `(mon-toggle-case-regexp ,match-on 'up ,replace-times ,with-results))))
;;
;;; :TEST-ME (mon-upcase-regexp "^\\(#[a-z0-9]\\{6,6\\}$\\)" nil t)

;;; ==============================
;;; :TODO Needs to take a step argument to adjust count-rep's increment on each pass.
;;; :RENAMED `mon-re-number-region' -> `mon-line-number-region-incr'
;;; :MODIFICATIONS <Timestamp: #{2010-01-26T20:16:13-05:00Z}#{10043} - by MON KEY>
;;; :CREATED <Timestamp: Saturday February 28, 2009 @ 02:25.53 PM - by MON KEY>
(defun mon-line-number-region-incr (start end &optional start-num intrp)
  "Sequentially renumber numbers (0-999 inclusive) in a region.\n
When called-interactively, prompt for starting number - default is 0.
Useful for re-numbering out of sequence numbers in filenames.\n
:SEE-ALSO `mon-string-incr',`mon-string-incr-padded',
`mon-line-number-region', `mon-rectangle-sum-column'.\n
:USED-IN `naf-mode'.\n►►►"
  (interactive "r\nP\np")
  (let* ((test-llm (mon-is-naf-mode-and-llm-p))
         (is-on test-llm)
         (llm-off))
    (when is-on (longlines-mode 0) (setq llm-off 't))
    (unwind-protect
         (let ((count-rep (cond (start-num start-num)
                                ((not intrp) (not start-num) 0)
                                (intrp (read-number "Start from number:" 0))))
               (regn-nums)
               (regn-start start)
               (regn-end end))
           (setq regn-nums (buffer-substring-no-properties regn-start regn-end))
           (setq regn-nums
                 (with-temp-buffer
                   (insert regn-nums)
                   (goto-char (buffer-end 0))
                   (while (search-forward-regexp "[0-9]\\{1,3\\}" nil t )
                     (replace-match
                      (number-to-string
                       (prog1
                           (identity count-rep)
                         (setq count-rep (1+ count-rep))))))
                   (buffer-substring-no-properties (buffer-end 0) (buffer-end 1))))
           (if intrp
               (save-excursion
                 (delete-region regn-start regn-end)
                 (insert regn-nums))
               regn-nums))
      (when llm-off (longlines-mode 1) (setq llm-off 'nil)))))
;;
;;(defalias ' ' )

;;; ==============================
;;; :COURTESY Noah Friedman :HIS buffer-fns.el
;;; :NOTE `mon-zippify-region' has _so_ many other applications...
;;;       Simply change the  `upcase-word' in the `while' clause :).
(defun mon-zippify-region (beg end &optional rand-limit)
  "Randomly capitalize certain words in the region from BEG and END.\n
Optional third arg RAND-LIMIT means capitalize roughly one out of every
RAND-LIMIT words.
:SEE-ALSO `mon-string-wonkify'.\n►►►"
  (interactive "r\np")
  (or rand-limit (setq rand-limit 8))
  (save-excursion
    (goto-char beg)
    (if (bobp) nil (forward-word -1) (forward-word 1))
    (while (< (point) end)
      (if (zerop (random rand-limit))
          (upcase-word 1)
        (forward-word 1)))))

;;; ==============================
;;; :RENAMED `mon-clnBIG-whitespace' -> `mon-cln-BIG-whitespace'
;;; :CREATED <Timestamp: Tuesday April 07, 2009 @ 11:35.38 AM - by MON KEY>
(defun mon-cln-BIG-whitespace (start end &optional intrp)
  "Rudely fix whitespace in region.\n
More comprehensive than `mon-cln-whitespace' with treatement of leading and
trailing whitespace but can't be trusted to DTRT.\n
For interactive cleaning of trailing tabs and spaces in *<BUFFER>*:
:SEE `mon-kill-whitespace', `mon-cln-trail-whitespace', `mon-cln-blank-lines'\n
:SEE-ALSO `mon-cln-imdb', `mon-trans_cp1252_to_latin1',
`mon-replace-common-abrevs', `mon-abr-to-month', `mon-num-to-month'.\n
:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (let ((is-on (mon-is-naf-mode-and-llm-p))
	(llm-off))
    (when is-on (longlines-mode 0) (setq llm-off t))
   (save-excursion
     (let ((whsp-str)
           (whsp-start start)
           (whsp-end end))
       (setq whsp-str (buffer-substring-no-properties whsp-start whsp-end))
       (setq whsp-str
             (with-temp-buffer
               (insert whsp-str)
               (progn
                 (goto-char (buffer-end 0))
                 (while (search-forward-regexp "[ \t]+$" nil t)
                   (delete-region (match-beginning 0) (match-end 0)))
                 (goto-char (buffer-end 0))
                 (while (search-forward-regexp "[ \t]+$" nil t)
                   (replace-match "" nil nil))
                 (goto-char (buffer-end 0))
                 (while (search-forward-regexp "^\\(\\([[:blank:]]+\\)\\([[:graph:]]\\)\\)"   nil t)
                   (replace-match "\\3" nil nil))
                 (goto-char (buffer-end 0))
                 (while (search-forward "\t" nil t)
                   (untabify (1- (point)) (buffer-end 1)))
                 ;;; (let ((start (buffer-end 0))
                 ;;;       (end (buffer-end 1)))
                 (goto-char (buffer-end 0))
                 (mon-replace-region-regexp-lists-nonint (buffer-end 0) (buffer-end 1)
                                                         regexp-clean-big-whitespace)
                 (goto-char (buffer-end 0))
                 (while (search-forward-regexp "^\\([[:blank:]]+$\\)" nil t)
                   (replace-match "\n\n" nil nil))
                 (buffer-substring-no-properties (buffer-end 0) (buffer-end 1)))))
       (delete-region whsp-start whsp-end)
       (insert whsp-str)))
   (when llm-off (longlines-mode 1) (setq llm-off nil))
   (when intrp (message "big whitespace cleaned."))))

;;; ==============================
(defun mon-cln-whitespace (start end &optional intrp)
  "Clean whitespace in region.\n
:NOTE A more function comprehensive is `mon-cln-BIG-whitespace' and is preferred. 
It handles leading and trailing wspc, but can't always be trusted to DTRT.\n
:REGEXPS-IN `regexp-clean-whitespace' 
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `mon-kill-whitespace', `mon-cln-trail-whitespace',
`mon-cln-blank-lines', `mon-cln-imdb', `mon-trans_cp1252_to_latin1',
`mon-replace-common-abrevs', `mon-abr-to-month', `mon-num-to-month'.\n
:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (mon-replace-region-regexp-lists-nonint start end regexp-clean-whitespace)
  (when intrp (message "The whitespace has been rudely adjusted.")))

;;; ==============================
(defun mon-cln-trail-whitespace ()
    "Indiscriminately clean trailing whitespace in _ENTIRE_ buffer.\n
Delete any trailing whitespace, converting tabs to spaces.
Use `mon-kill-whitespace' to kill tabs to 1 (one) space.
Operate on entire *<BUFFER>* not region. For interactive whitespace
region adjustment use `mon-cln-BIG-whitespace', `mon-cln-blank-lines',
or `mon-cln-whitespace'.\n
:SEE-ALSO .\n:USED-IN `naf-mode'.\n►►►"
    (interactive)
    (save-excursion
      (goto-char (buffer-end 0))
      (while (search-forward-regexp "[ \t]+$" nil t)
        (delete-region (match-beginning 0) (match-end 0)))
      (goto-char (buffer-end 0))
      (if (search-forward "\t" nil t)
          (untabify (1- (point)) (buffer-end 1)))))

;;; ==============================
(defun mon-kill-whitespace ()
  "Kill trailing whitespace (tab and space) in *<BUFFER>* not region.\n
Unlike `mon-cln-trail-whitespace', doesn't convert tabs to spaces.\n
For interactive whitespace region adjustment use `mon-cln-BIG-whitespace',
`mon-cln-whitespace', or `mon-cln-blank-lines'.\n
:SEE-ALSO `mon-cln-uniq-lines'.\n\n:USED-IN `naf-mode'.\n►►►"
  (interactive)
  (save-excursion
    (goto-char (buffer-end 0))
    (while (search-forward-regexp "[ \t]+$" nil t)
      (replace-match "" nil nil))))

;;; ==============================
;;; :CREATED <Timestamp: Thursday May 07, 2009 @ 04:21.17 PM - by MON KEY>
(defun mon-cln-blank-lines (start end); &optional intrp)
  "Delete blank and empty lines in region from START to END.\n
:SEE-ALSO `mon-cln-uniq-lines', `delete-blank-lines'.\n►►►"
  (interactive "r\np")
  (save-excursion
    (let ((cln-start start)
	  (cln-end end))		;(message "%s %s" cln-start cln-end))
      (while (> cln-end (point))
	(cond ((mon-line-next-bol-is-eol) (delete-blank-lines))
	      ((mon-line-bol-is-eol) (delete-blank-lines))
	      ((mon-spacep-is-bol) (delete-blank-lines)))
	(forward-line))
      (while (< cln-start (point))
	(cond ((mon-line-previous-bol-is-eol)(delete-blank-lines))
	      ((mon-line-bol-is-eol) (delete-blank-lines))
	      ((mon-spacep-is-bol) (delete-blank-lines)))
	(forward-line -1)))))


;;; ==============================
;;; :NOTE Duplicate lines are killed to kill-ring. IOW, clobbers the ring.
;;;       Testing a kill-ring restore inside the unwind-protect.
;;; :MODIFICATIONS <Timestamp: #{2010-01-26T20:57:22-05:00Z}#{10043} - by MON KEY>
(defun mon-cln-uniq-lines (beg end)
  "Return the unique lines in region, ommitting ducplicates.\n
Called programmatically ARGS BEG and END denote the \(region to sort\) and uniquify.
:SEE-ALSO `mon-cln-blank-lines', `delete-blank-lines'. 
:SEE `uniq-remove-dup-lines' in :FILE uniq.el for additional spec.\n►►►"
  (interactive "r")
  (let ((the-ring kill-ring))
    (unwind-protect
         (save-excursion
           (save-restriction
             (setq kill-ring nil)  
             (narrow-to-region beg end)
             (goto-char (buffer-end 0))
             (while (not (eobp))
               (kill-line 1)
               (yank)
               (let ((next-line (point)))
                 (while (search-forward-regexp 
                         (format "^%s" (regexp-quote (car kill-ring))) nil t)
                   (replace-match "")
                   (goto-char next-line))))))
      (setq kill-ring the-ring))))

;;; ==============================
;;; :CREATED <Timestamp: Friday May 08, 2009 @ 05:32.08 PM - by MON KEY>
(defun mon-cln-spc-tab-eol () ;;(&optional intrp)
  "Clean current-line of TAB (char 9) and SPC (char 32) at EOL.\n
:SEE-ALSO `mon-cln-spc-tab-at-eol-in-region' `mon-spacep-at-eol',
`mon-spacep-is-bol', `mon-spacep-not-bol', `mon-spacep',
`mon-line-bol-is-eol', `mon-line-next-bol-is-eol',
`mon-line-previous-bol-is-eol', `mon-line-previous-bol-is-eol',
`mon-spacep-is-after-eol-then-graphic'.\n►►►"
  (interactive); "p")
  (while (mon-spacep-at-eol)
    (goto-char (point-at-eol))
    (delete-char -1)
    (goto-char (point-at-bol))))

;;; ==============================
;;; :CALLED-BY `mon-get-proc-buffers-directories' - be careful about modifying.
;;; :CREATED <Timestamp: Friday May 08, 2009 @ 07:01.07 PM - by MON KEY>
(defun mon-cln-spc-tab-at-eol-in-region (start end)
  "Clean region of TAB (char 9) and SPC (char 32) at EOL.\n
:CALLED-BY `mon-get-proc-buffers-directories'.\n
:SEE-ALSO `mon-cln-spc-tab-eol'`mon-spacep-at-eol', `mon-spacep-is-after-eol',
`mon-spacep-is-after-eol-then-graphic'.\n►►►"
  (interactive "r")
  (save-excursion
    (let ((this-region (buffer-substring-no-properties start end))
	  (rtrn))
      (setq rtrn
	    (with-temp-buffer
	      (insert this-region)
	      (goto-char (buffer-end 0))
	      (while (mon-spacep-at-eol)
		(mon-cln-spc-tab-eol)
		(goto-char (1+ (point-at-eol))))
	      (buffer-substring (buffer-end 0) (buffer-end 1))))
      (delete-region start end)
      (insert rtrn))))

;;; ==============================
;;; :COURTESY Stefan Reichor <stefan@xsteve.at> :HIS xsteve-functions.el
(defun mon-cln-control-M (&optional intrp)
  "Remove ^M at EOL in current-buffer.\n
:SEE-ALSO .\n►►►"
  (interactive "p")
(let (msg)
  (save-match-data
    (save-excursion
      (let ((remove-count 0))
        (goto-char (buffer-end 0))
        (while (search-forward-regexp "
$" (buffer-end 1) t)
          (setq remove-count (+ remove-count 1))
          (replace-match "" nil nil))
        (setq msg (format "%d \C-m removed from buffer." remove-count)))))
  ;;(string-to-char "
")
  ;;(format "\C-m")
  (when intrp (message msg))))

;;; ==============================
;;; :CREATED <Timestamp: Tuesday April 07, 2009 @ 11:35.38 AM - by MON KEY>
(defun mon-cln-piped-list (start end &optional intrp)
  "Clean region of piped list formatting i.e. \"Name | Name\".
Piped lists are used in the naf-mode sections:
 Used-for: Appeared-in: Ads-for: Artist-associated: Authors-associated:
 Products-associated: Slogans: Content-and-subjects: etc.\n
:SEE-ALSO `mon-pipe-list', `naf-backup-the-list',`mon-delete-back-up-list'
`mon-line-strings-pipe-bol', `mon-line-strings-pipe-to-col'.\n
:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (let* ((test-llm (mon-is-naf-mode-and-llm-p));;(buffer-local-value longlines-mode (current-buffer)))
         (is-on test-llm)
         (llm-off))
    (when is-on (longlines-mode 0) (setq llm-off t))
    (let ((pipe-start start)
	  (pipe-end end)
	  (regn-pipe))
      (setq regn-pipe (buffer-substring-no-properties pipe-start pipe-end))
      (save-excursion
	(setq regn-pipe
	      (with-temp-buffer
		(insert regn-pipe)
		(goto-char (buffer-end 0))
		(while (search-forward-regexp "\\([[:space:]]|[[:blank:]]\\)" nil t)
		  (replace-match "\n"))
		(goto-char (buffer-end 0))
		(while (search-forward-regexp "\\([[:space:]]|\\|[[:blank:]]|$\\)" nil t)
		  (replace-match "\n"))
		(goto-char (buffer-end 0))
		(while (search-forward-regexp 
                        "^\\(|[[:space:]]\\|[[:space:]]|\\|[[:blank:]]\\|[[:blank:]]|\\)" nil t)
		  (replace-match "\n"))
		(sort-lines nil (buffer-end 0) (buffer-end 1))
		(uniq-region (buffer-end 0) (buffer-end 1))
		(buffer-substring-no-properties (buffer-end 0) (buffer-end 1))))
	(delete-region pipe-start pipe-end)
	(insert regn-pipe)))
    (when llm-off (longlines-mode 1) (setq llm-off nil))
    (when intrp  (message "Piped | list is clean."))))
;;
;;(defalias ' ' )

;;; ==============================
;;; :RENAMED `naf-delete-back-up-list' -> `mon-delete-back-up-list'
;;; :CREATED <Timestamp: Tuesday April 07, 2009 @ 11:35.38 AM - by MON KEY>
(defun mon-delete-back-up-list (start end &optional delim)
  "Given a text item-per-line list with no trailing whitespace, move backwards from
point to BOL and deletes 1 char. This effecively puts point on the next line up.
With each successive previous line deleting until point is no longer greater than point-min.
:NOTE Be careful, function can wreck data, evaluate using `with-temp-buffer'.\n
:SEE-ALSO `mon-pipe-list', `mon-cln-piped-list',`naf-backup-the-list',
`mon-delete-back-up-list', `mon-line-strings-pipe-bol',
`mon-line-strings-pipe-to-col'.
:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np") 
  (let* ((is-on (mon-is-naf-mode-and-llm-p))
	 (llm-off)
	 (the-delim (cond ((eq delim 1) " ")
                           ((not delim) " ")
                           ((or delim) delim))))
    (when is-on (longlines-mode 0) (setq llm-off t))
    (let ((bak-start start)
	  (bak-end end)
	  (bak-pipe))
      (setq bak-pipe (buffer-substring-no-properties bak-start bak-end))
       (save-excursion
         (setq bak-pipe
               (with-temp-buffer
                 (insert bak-pipe)
                 (progn	    
                   (mon-cln-trail-whitespace)
                   (goto-char (buffer-end 1))
                   (while
                       (> (point)(buffer-end 0))
                     (beginning-of-line)
                     (insert the-delim)
                     (beginning-of-line)
                     (delete-backward-char 1)
                     (if (bolp)
                         () (beginning-of-line) ))
                   (goto-char (buffer-end 1))
                   (while (search-forward-regexp " " nil t)
                     (replace-match " " nil nil)))
                 (buffer-substring-no-properties (buffer-end 0) (buffer-end 1))))
         (delete-region bak-start bak-end)
         (insert bak-pipe)))
    (when llm-off (longlines-mode 1) (setq llm-off nil))
     ))
;;
(defalias 'naf-delete-back-up-list 'mon-delete-back-up-list)

;;; ==============================
;;; :CREATED <Timestamp: Wednesday February 11, 2009 @ 04:34.31 PM - by MON KEY>
(defun mon-pipe-list (start end  &optional intrp)
  "Insert \" | \" between each item on an item per line region.\n
NOTE: Item on last line in region should be an empty line.
Useful for building piped lists in sections of `naf-mode' .naf files including:
  Used-for: Appeared-in: Ads-for: Artist-associated: Authors-associated:
  Products-associated: Slogans: Content-and-subjects: etc.\n
:SEE-ALSO `mon-cln-piped-list',`mon-line-strings-pipe-bol',
`mon-line-strings-pipe-to-col', `naf-backup-the-list',
`mon-delete-back-up-list'.\n►►►"
  (interactive "r\np")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char (buffer-end 1))
      (progn
	(unless (and (buffer-end 1) (mon-spacep))
	  (newline))
	(while (mon-spacep)
	  (let* ((forward-count (skip-chars-forward "[:space:]"))
		 (backward-count (skip-chars-backward "[:space:]"))
		 (empty (and (eolp) (bolp))))
	    (when empty
	      (delete-backward-char 1))
	    (when (< backward-count 0)
	      (let* ((count-back (abs backward-count)))
		(delete-char count-back)))
            ;; Test for abutting characters.
	    (if (and (not (mon-spacep)) (not (mon-spacep nil t)))
		(progn
		  (insert " | ")
		  (beginning-of-line)))))
	(when (and (mon-spacep) (bolp) (not (mon-spacep nil t)))
	  (progn
	    (backward-char 1)
	    (if (eolp)
		(delete-char 1)
	      (while (mon-spacep nil t)
		(delete-char 1)))
            ;; Test for abutting characters.
	    (when (and (not (mon-spacep)) (not (mon-spacep nil t)))
	      (progn
		(insert " | ")
		(beginning-of-line))))))
      (goto-char (buffer-end 1))
      ;; Matches traling " | " on tail of returned piped-list.
      (progn		   
	(re-search-backward "[[:space:]]|[[:space:]]$" nil t)
	(replace-match ""))))
  (when intrp (message "Finished Piping that list.")))
;;
;;(defalias ' ' )

;;; ==============================
(defun naf-backup-the-list (start end)
  "Dedicated interactive function name for `mon-delete-back-up-list'.\n
:SEE-ALSO `mon-pipe-list', `mon-cln-piped-list', `mon-line-strings-pipe-bol',
`mon-line-strings-pipe-to-col'.\n\n:USED-IN `naf-mode'.\n►►►"
  (interactive "r")
  (mon-delete-back-up-list start end))

;;; ==============================
(defun mon-cln-philsp (start end &optional intrp)
  "Clean \(apos, date order, etc.\) in philsp scrapes.\n
:REGEXPS-IN `philsp-months', `philsp-months', `philsp-apos',
`philsp-location', `philsp-swap-location', `philsp-fix-month-dates'.
:SEE :FILE mon-regexp-symbols.el\n
Following is the relevant URL containing content apropos this procedure:
:SEE \(URL `http://www.philsp.com/homeville/FMI/a7.htm')\n
:SEE-ALSO `mon-cln-wiki', `mon-cln-philsp', `mon-cln-imdb',
`mon-cln-ulan', `mon-cln-wiki', `mon-cln-imdb',`mon-cln-bib', `mon-cln-loc',
`mon-cln-html-tags'.\n\n:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (mon-naf-mode-toggle-restore-llm
      (save-excursion
        (mon-replace-region-regexp-lists-nonint start end
         philsp-months    philsp-apos    philsp-location
         philsp-swap-location philsp-fix-month-dates)
        (insert (mapconcat #'identity 
                           `("" ;; preceding newline
                             "-"                                                
                             "non-posting-philsp-source:"
                             ":SEE (URL `http://www.philsp.com/homeville/FMI/a7.htm')"
                             ,(mon-accessed-stamp)
                             "---") "\n")))
    (when intrp (message "philsp-cleaned."))))

;;; ==============================
;;; :TODO <Timestamp: Wednesday February 18, 2009 @ 05:13.39 PM - by MON KEY>
;;;       (if (and (bolp) ;;; search for certain strings to move backup a line
;;;       e.g. to make the following display on the correct line:
;;;       List/Hierarchical Position: Person
;;;       Nationalities: French (preferred) ... etc.
;;; :MODIFICATIONS <Timestamp: #{2009-08-31T22:53:08-04:00Z}#{09362} - by MON KEY>
;;; :CREATED <Timestamp: Tuesday April 07, 2009 @ 11:35.38 AM - by MON KEY>
(defun mon-cln-ulan (start end &optional with-results intrp)
  "Clean periods, linebreaks, whitespace, tabs, etc. from ULAN scrapes in *<BUFFER>*.
Operates on region. Return `mon-accessed-stamp' appended at end of region.\n
:REGEXPS-IN `*regexp-clean-ulan*' VAR in mon-regexp-symbols.el's
:SEE-ALSO `*regexp-ulan-contribs*', `*regexp-clean-ulan-fields*',
`*regexp-clean-ulan-diacritics*', `*regexp-clean-ulan-dispatch-chars*'.\n
For additional specs:\n
:SEE \(URL `http://www.getty.edu/research/conducting_research/vocabularies/ulan/').\n
:SEE-ALSO .\n:USED-IN `naf-mode'.\n►►►"
  (interactive "r\nP\np")
   (let (;; (test-llm (buffer-local-value longlines-mode (current-buffer)))
	 (is-on (mon-is-naf-mode-and-llm-p))
	 (llm-off)
         (w/rslt with-results)
         (rslt-cnt))
     (when is-on (longlines-mode 0) (setq llm-off t))
	(save-excursion
          (let ((ulanstr)
                (ulan-start start)
                (ulan-end end))
            (setq ulanstr (buffer-substring-no-properties ulan-start ulan-end))
            (setq ulanstr
	      (with-temp-buffer
		(insert ulanstr)
		(let ((start-mrk (make-marker))
                      (end-mrk (make-marker))
                      lcl-start ;;start; (buffer-end 0))
                      lcl-end  ;;end); (buffer-end 1)))
                      )
                  (set-marker start-mrk (buffer-end 0))
                  (set-marker end-mrk (buffer-end 1))
                  (setq lcl-start start-mrk)
                  (setq lcl-end end-mrk)
                  (if w/rslt
                      (setq rslt-cnt 
                            (cons `(,@(mon-replace-region-regexp-lists 
                                       lcl-start lcl-end *regexp-clean-ulan* t))  rslt-cnt))
                    (mon-replace-region-regexp-lists lcl-start lcl-end *regexp-clean-ulan*))
		  (progn
		    (goto-char (buffer-end 1))
		    (while (> (point) 1)
		      (if (and (eolp) (bolp))
			  (delete-backward-char 1)
			(beginning-of-line))
		      (goto-char (1- (point))))
		    (goto-char (buffer-end 1))
		    (newline) (insert "-") (newline)
		    (mon-accessed-stamp t) (newline)
                    (goto-char (buffer-end 0)))
                  (progn
                  (set-marker start-mrk (buffer-end 0))   (set-marker end-mrk (buffer-end 1))
                  (setq lcl-start start-mrk)           (setq lcl-end end-mrk)
                  (if w/rslt
                      (setq rslt-cnt 
                            (cons `(,@(mon-replace-region-regexp-lists 
                                       lcl-start lcl-end *regexp-clean-ulan-fields* t))  rslt-cnt))
                    (mon-replace-region-regexp-lists lcl-start lcl-end *regexp-clean-ulan-fields*)))
                  (progn
                    (goto-char (buffer-end 0))
                    (set-marker start-mrk (buffer-end 0))  (set-marker end-mrk (buffer-end 1))
                    (setq lcl-start start-mrk)          (setq lcl-end end-mrk)
                  (if w/rslt
                      (setq rslt-cnt 
                            (cons `(,@(mon-replace-region-regexp-lists 
                                       lcl-start lcl-end *regexp-clean-ulan-dispatch-chars* t)) rslt-cnt))
                    (mon-replace-region-regexp-lists lcl-start lcl-end *regexp-clean-ulan-dispatch-chars*)))
		(buffer-substring-no-properties (buffer-end 0) (buffer-end 1)))))
	       (delete-region ulan-start ulan-end)
	       (insert ulanstr)))
         (when llm-off (longlines-mode 1) (setq llm-off nil))
	  (when w/rslt
	    (setq rslt-cnt (nreverse rslt-cnt))
	    (setq rslt-cnt (mapconcat 'identity rslt-cnt "\n"))
	    (cond ((intrp (message "%s" rslt-cnt)))
		  ((not intrp) (format "%s" rslt-cnt))))))

;;; ==============================
;;; :NOTE New version to test for longlines.
;;; :CREATED <Timestamp: Saturday March 21, 2009 @ 02:57.37 PM - by MON KEY>
(defun mon-cln-imdb (start end &optional intrp)
  "Clean Internet Movie Database scrapes from IMDB.
Insert the `non-posting-imdb-source' at end of cleaned region.
:REGEXPS-IN `regexp-clean-imdb'
:SEE :FILE mon-regexp-symbols.el\n
:SEE (URL `http://www.IMDB.com').\n
:SEE-ALSO `mon-cln-wiki', `mon-cln-imdb',`mon-cln-bib',`mon-cln-ulan',
`mon-cln-loc', `mon-cln-philsp', `mon-cln-html-tags',
`mon-replace-common-abrevs', `mon-abr-to-month', `mon-num-to-month',
`mon-trans_cp1252_to_latin1'.\n\n:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (let ((is-on (mon-is-naf-mode-and-llm-p))
	(llm-off))
    (when is-on (longlines-mode 0) (setq llm-off 't))
     (mon-replace-region-regexp-lists-nonint start end regexp-clean-imdb)
     (non-posting-imdb-source)
     (when llm-off (longlines-mode 1)); (setq llm-off 'nil))
     (when intrp (message "IMDB refs are cleaned."))))

;;; ==============================
;;; :NOTE New version to test for longlines.
;;; :CREATED <Timestamp: Saturday March 21, 2009 @ 02:57.37 PM - by MON KEY>
(defun mon-cln-loc (start end &optional intrp)
  "Fix combining character diacritics from LOC Authority display scrapes.\n
:SEE \(URL `http://authorities.loc.gov/cgi-bin/Pwebrecon.cgi?DB=local&PAGE=First')\n
:REGEXPS-IN `regexp-clean-loc' in mon-regexp-symbols.el\n
:SEE-ALSO `mon-cln-wiki', `mon-cln-imdb', `mon-cln-bib', `mon-cln-ulan',
`mon-cln-philsp', `mon-cln-html-tags', `mon-replace-common-abrevs',
`mon-abr-to-month', `mon-num-to-month', `mon-trans_cp1252_to_latin1'.\n
:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
 (let ((is-on (mon-is-naf-mode-and-llm-p))
        (llm-off))
   (when is-on (longlines-mode 0) (setq llm-off 't))
   (mon-replace-region-regexp-lists-nonint start end regexp-clean-loc)
   (when llm-off (longlines-mode 1)); (setq llm-off 'nil))
   (when intrp (message "LOC cruft cleaned."))))

;;; ==============================
;;; :TODO Build a subr to gather the sections of WIKI `Contents' table and
;;;       search buffer for occurences at BOL WSP e.g. "^ Some Contents
;;;       Section\n" replace each Section with with "►►►SOME CONTENTS
;;;       SECTION◄◄◄\n"
;;; :NOTE Newer version tests for longlines.
;;; :CREATED <Timestamp: Saturday March 21, 2009 @ 02:57.37 PM - by MON KEY>
(defun mon-cln-wiki (start end &optional intrp)
  "Replace unwanted wikipedia formatting in region containing scraped wiki text.\n
:REGEXPS-IN `regexp-clean-wikipedia' 
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `non-posting-wiki-source', `mon-cln-html-tags', `mon-cln-bib',
`mon-cln-loc', `mon-cln-ulan', `mon-cln-philsp', `mon-cln-imdb',
`mon-cln-whitespace', `mon-replace-common-abrevs', `mon-abr-to-month',
`mon-num-to-month', `mon-trans_cp1252_to_latin1'.\n\n:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  ;;; (let ((is-on (mon-is-naf-mode-and-llm-p))
  ;;;       (llm-off))
  ;;;   (when is-on (longlines-mode 0) (setq llm-off t))
  (mon-naf-mode-toggle-restore-llm
      (mon-replace-region-regexp-lists-nonint start end regexp-clean-wikipedia))
  ;; (when llm-off (longlines-mode 1) (setq llm-off nil))
    (when intrp (message "Wiki-refs are cleaned.")))

;;; ==============================
(defun mon-cln-bib (start end &optional intrp)
  "Replace unwanted bibliograhic formatting in region.\n
:REGEXPS-IN `*regexp-clean-bib*' 
VARIABLE in :FILE mon-regexp-symbols.el\n
:SEE-ALSO `mon-cln-wiki', `mon-cln-loc', `mon-cln-imdb'
`mon-cln-ulan', `mon-cln-philsp', `mon-cln-html-tags'.\n
:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (let ((is-on (mon-is-naf-mode-and-llm-p))
	(llm-off))
    (when is-on (longlines-mode 0) (setq llm-off t))
    (mon-replace-region-regexp-lists-nonint start end *regexp-clean-bib*)
    (when llm-off(longlines-mode 1) (setq llm-off 'nil))
    (when intrp (message "Bib cruft cleaned."))))

;;; ==============================
(defun mon-num-to-month (start end &optional intrp)
  "Replace Months with number of Month.\n
Number of form MM includes leading 0.
Only match on month nums 0-9 when zero padded e.g.\n
01 02 03 04 05 06 07 08 09.\n
:REGEXPS-IN `regexp-MM2month' 
:SEE :FILE mon-regexp-symbols.el.\n
:SEE-ALSO `regexp-month2MM', `regexp-month2canonical-ws',
`regexp-abrv-dotted-month2canonical', `regexp-simple-abrv-month2canonical',
`philsp-fix-month-dates'.\n\n:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (mon-replace-region-regexp-lists-nonint start end regexp-MM2month)
  (when intrp (message "Month Number to Month Names Strings Complete.")))
;;
;;(defalias ' ' )

;;; ==============================
(defun mon-num-to-month-whitespace (start end &optional intrp)
 "Replace Month number with Month Name. 
Only match on month nums 0-9 when zero padded e.g.:\n
01 02 03 04 05 06 07 08 09.\n
:NOTE This is a more whitespace aware version of `mon-num-to-month'.
:REGEXPS-IN `regexp-MM2month-whitespace-aware' 
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `regexp-MM2month', `regexp-month2canonical-ws', 
`regexp-abrv-dotted-month2canonical',`regexp-simple-abrv-month2canonical',
`philsp-fix-month-dates'.\n\n:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (let ((is-on (mon-is-naf-mode-and-llm-p))
	(llm-off))
    (when is-on (longlines-mode 0) (setq llm-off t))
   (mon-replace-region-regexp-lists-nonint start end regexp-MM2month-whitespace-aware)
   (when llm-off (longlines-mode 1))
   (when intrp 
     (message "Month Number (whitespace aware) to Month Names Strings Complete."))))

;;; ==============================
(defun mon-month-to-num (start end &optional intrp)
  "Replace Months with number of Month. Number of form MM includes leading 0.\n
:REGEXPS-IN `regexp-month2MM' 
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `regexp-MM2month', `regexp-month2canonical-ws', 
`regexp-abrv-dotted-month2canonical', `regexp-simple-abrv-month2canonical',
`philsp-fix-month-dates'.\n\n:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (let ((is-on (mon-is-naf-mode-and-llm-p))
	(llm-off))
    (when is-on (longlines-mode 0) (setq llm-off t))
  (mon-replace-region-regexp-lists-nonint start end regexp-month2MM)
  (when llm-off (longlines-mode 1))
  (when intrp (message "Month Names to Number Strings Complete."))))
;;
;;(defalias ' ' )

;;; ==============================
(defun mon-abr-to-month (start end &optional intrp)
  "De-abbreviate English months into canonical form.
Match abbreviated months - with/out trailing `.'
Additionally, will match with/out leading/trailing whitespace.\n
:REGEXPS-IN `regexp-month2MM' 
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `mon-num-to-month', `mon-cln-wiki', `mon-cln-imdb',
`mon-trans_cp1252_to_latin1', `mon-replace-common-abrevs'.\n
:USED-IN `naf-mode'.\n►►►"
 (interactive "r\np")
 (let ((is-on (mon-is-naf-mode-and-llm-p))
       (llm-off))
   (when is-on (longlines-mode 0) (setq llm-off t))
  (mon-replace-region-regexp-lists-nonint start end regexp-month2canonical-ws)
  (when llm-off (longlines-mode 1))
  (when intrp (message "Replaced buffer's abbreviated months with canonical form."))))
;;
;;(defalias ' ' )

;;; ==============================
(defun mon-trans-cp1252-to-latin1 (start end &optional intrp)
  "Convert cp1252 encoded chars to latin1-iso-8859-*.\n
:REGEXPS-IN `*regexp-cp1252-to-latin1*' 
:SEE :FILE mon-regexp-symbols.el.\n
:SEE-ALSO `mon-make-iso-latin-1-approximation', `mon-cln-iso-latin-1',
`*iso-latin-1-approximation*', `mon-cln-wiki',`mon-cln-imdb',
`mon-replace-common-abrevs', `mon-abr-to-month',`mon-num-to-month'.\n
:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (let ((is-on (mon-is-naf-mode-and-llm-p))
	(llm-off))
    (when is-on (longlines-mode 0) (setq llm-off t))
   (mon-replace-region-regexp-lists-nonint start end *regexp-cp1252-to-latin1*)
   (when llm-off (longlines-mode 1))
   (when intrp
     (message (concat
	       "Crappy w32 cp1252 converted into a less crappy iso-8891-1. \n"
	       "Eventually you will find yourself converting this to utf-8 - *sigh*...")))))
;;
;;(defalias ' ' )

;;; ==============================
(defun mon-ital-date-to-eng (start end &optional intrp)
  "Convert Italian date strings (months, days) into equivalent Engrish strings.\n
:REGEXPS-IN `*regexp-ital-to-eng*' 
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `mon-cln-wiki', `mon-cln-imdb', `mon-replace-common-abrevs',
`mon-abr-to-month', `mon-num-to-month',`mon-defranc-places'.\n
:USED-IN `naf-mode'.\n►►►"
  (interactive "r")
  (let ((is-on (mon-is-naf-mode-and-llm-p))
	(llm-off))
    (when is-on (longlines-mode 0) (setq llm-off t))
   (mon-replace-region-regexp-lists-nonint start end *regexp-ital-to-eng*)
   (when llm-off (longlines-mode 1))
   (when intrp  (message "'Italian Date string converted to Engrish."))))
;;
;;(defalias ' ' )

;;; ==============================
(defun mon-defranc-dates (start end  &optional intrp)
  "Convert French date strings (months, days) into equivalent Engrish strings.
Matches day of the week, months, abbrevd months, and months with/out diacritics.\n
:REGEXPS-IN `*regexp-defranc-dates*' 
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `naf-mode-french-months', `mon-defranc-places', `mon-defranc-benezit'
`non-posting-benezit-source',`mon-ital-date-to-eng'.\n\n:USED-IN `naf-mode'.\n►►►"
 (interactive "r\np")
 (let ((is-on (mon-is-naf-mode-and-llm-p))
       (llm-off))
   (when is-on (longlines-mode 0) (setq llm-off t))
   (mon-replace-region-regexp-lists-nonint start end *regexp-defranc-dates*)
   (when llm-off (longlines-mode 1))
   (when intrp  (message "'Buffer has been de-francified"))))
;;
;;;(progn (makunbound 'mon-defranc-dates) (unintern 'mon-defranc-dates))
;;
;;(defalias ' ' )

;;; ==============================
(defun mon-defranc-places (start end &optional intrp)
  "Convert French place names into equivalent English place names.
Matches on French language place names with/out diacritics. 
Conversions include with/out all uppercase styled names - for Benezit auctions.\n
:REGEXPS-IN `*regexp-defranc-places*'
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `mon-defranc-benezit', `mon-defranc-dates', `mon-ital-date-to-eng',
`non-posting-benezit-source', `naf-mode-french-months'.\n
:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (let ((is-on (mon-is-naf-mode-and-llm-p))
	(llm-off))
    (when is-on (longlines-mode 0) (setq llm-off t))
    (mon-replace-region-regexp-lists-nonint start end *regexp-defranc-places*)
  (when llm-off (longlines-mode 1))
  (when intrp (message "Buffers place names have been de-francified."))))
;;
;;(defalias ' ' )

;;; ==============================
(defun mon-cln-benezit (start end &optional intrp)
  "Convert French Benezit terms into equivalent English terms.
Trie to conservatively catch on terms with diacrtics.\n
:REGEXPS-IN `*regexp-defranc-benezit*' 
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `mon-clean-benezit-fields', `*regexp-clean-benezit-fields*'
`mon-defranc-dates',`mon-defranc-places', `non-posting-benezit-source'.\n
:USED-IN `naf-mode'.\n►►►"
 (interactive "r\np")
 (let ((is-on (mon-is-naf-mode-and-llm-p))
       (llm-off))
   (when is-on (longlines-mode 0) (setq llm-off t))
  (mon-replace-region-regexp-lists-nonint start end *regexp-defranc-benezit*)
  (when llm-off (longlines-mode 1))
  (when intrp (message "Benezit terms have been de-francified."))))
;;
;;; :ALIAS :CREATED <Timestamp: #{2009-09-18T15:21:40-04:00Z}#{09385} - by MON KEY>
(defalias 'mon-defranc-benezit 'mon-cln-benezit)

;;; ==============================
;;; :CREATED <Timestamp: #{2009-09-18T15:15:31-04:00Z}#{09385} - by MON KEY>
(defun mon-cln-benezit-fields (start end &optional intrp)
  "Normalize Benezit fields in region.\n
:REGEXPS-IN `*regexp-clean-benezit-fields*' 
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `mon-defranc-benezit', `mon-defranc-dates',`mon-defranc-places', 
`non-posting-benezit-source'.\n\n:USED-IN `naf-mode'.\n►►►"
 (interactive "r\np")
 (let ((is-on (mon-is-naf-mode-and-llm-p))
       (llm-off))
   (when is-on (longlines-mode 0) (setq llm-off t))
   (mon-replace-region-regexp-lists-nonint start end *regexp-clean-benezit-fields*)
   (when llm-off (longlines-mode 1))
   (when intrp (message "Benezit fields have been normalized."))))
;;
(defalias 'mon-defranc-benezit-fields 'mon-cln-benezit-fields)

;;; ==============================
(defun mon-replace-common-abbrevs (start end &optional intrp)
  "Replace common abbreviations.\n
Useful for those with `.' at end of string.\n
:REGEXPS-IN `*regexp-common-abbrevs*'
:SEE :FILE mon-regexp-symbols.el\n
:SEE-ALSO `mon-cln-wiki', `mon-cln-imdb',`mon-abr-to-month', `mon-num-to-month'
`mon-trans_cp1252_to_latin1'.\n\n:USED-IN `naf-mode'.\n►►►"
  (interactive "r\np")
  (let ((is-on (mon-is-naf-mode-and-llm-p))
	(llm-off))
    (when is-on (longlines-mode 0) (setq llm-off t))
    (mon-replace-region-regexp-lists-nonint start end *regexp-common-abbrevs*)
    (when llm-off (longlines-mode 1))
    (when intrp (message "Buffer's pesky abbreviations now fully expanded words aka readable Engrish."))))
;;
;;; :CREATED <Timestamp: #{2009-09-18T15:31:19-04:00Z}#{09385} - by MON KEY>
(defalias 'mon-cln-common-abbrevs 'mon-replace-common-abbrevs)

;;; ==============================
;;; :TODO Function should be extend to append the scrape to a user supplied
;;;       filename and clean any redundant or pre-existing URLs, and optionally
;;;       pass the file on to shell process. Also, need to adjust the script to
;;;       account for rename rules on files wget pulls.
;;; :MODIFICATIONS <Timestamp: #{2009-08-11T16:52:26-04:00Z}#{09332} - by MON KEY>
(defun bug-cln-gilt-group (start end)
  "Clean image links from html source at (URL `http://www.gilt.com').
Useful to get a working list to pass to a useable wget file e.g.:\n
\"wget -np -A.jpg -i wget-file\".\n
:SEE-ALSO `*regexp-clean-gilt-group*'.\n►►►"
  (interactive "r")
  (progn
    (mon-replace-region-regexp-lists-nonint start end *regexp-clean-gilt-group*)
    (keep-lines "^.*/lg\.jpg$" start end)))

;;; ==============================
(provide 'mon-replacement-utils)
;;; ==============================

;;; =======================
;;; mon-replacement-utils.el ends here
;;; =======================
;;; EOF
