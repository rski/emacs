;;; user-directory.el --- Find user-specific directories  -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Free Software Foundation, Inc.

;; Author: Stefan Kangas <stefan@marxist.se>
;; Keywords: internal
;; Package: emacs

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; * Introduction
;;
;; This library contains functions to handle various user directories,
;; such as configuration files, user data, etc. in a platform
;; independent way.
;;
;; Users can override the returned directories with
;; `user-directory-alist'.
;;
;; * Using from Lisp
;;
;; The entry point for Lisp libraries is `user-file' and
;; `user-directory'.
;;
;; - User options for file names should be defined relative to the
;;   paths returned by this library.
;;
;; - Instead of calling this once and caching the value in a variable,
;;   best practice is to call it on use.  That way the user can update
;;   the settings here without having to reload your library.

;;; Code:

(require 'cl-lib)
(require 'xdg)

(defgroup user-directory nil
  "User directories."
  :group 'environment
  :version "29.1")

(defcustom user-directory-alist ()
  "Overrides for `user-directory'.
This allows you to override where Emacs stores your configuration
and data files."
  :type 'list
  :risky t)

;;;###autoload
(defun user-file (type name &optional _old-name)
  "Return an absolute per-user Emacs-specific file name.
TYPE is as in `user-directory'.

If NEW-NAME exists in `user-emacs-directory', return it.
Else if OLD-NAME is non-nil and ~/OLD-NAME exists, return ~/OLD-NAME.
Else return NEW-NAME in `user-emacs-directory', creating the
directory if it does not exist."
  ;; TODO: Do more work to actually support OLD-NAME, as in
  ;; `locate-user-emacs-file'.
  (expand-file-name name (user-directory type)))

;;;###autoload
(cl-defgeneric user-directory (type)
  "Return a user-specific directory of TYPE.
TYPE is one of these symbols:

 - cache        Emacs cached files
 - config       Emacs configuration files
 - data         Emacs data
 - runtime      Emacs runtime files
 - state        Emacs session data
 - desktop      User desktop          (e.g. \"~/Desktop\")
 - downloads    User downloaded files (e.g. \"~/Downloads\")
 - documents    User documents        (e.g. \"~/Documents\")
 - music        User music files      (e.g. \"~/Music\")
 - public       User shared files     (e.g. \"~/Public\")
 - pictures     User picture files    (e.g. \"~/Pictures\")
 - templates    User template files   (e.g. \"~/Templates\")
 - videos       User video files      (e.g. \"~/Videos\")

For more details, see below.")

(cl-defmethod user-directory :around (type)
  ;; TODO: Do more work to ensure the directory makes sense, as in
  ;; `locate-user-emacs-file'.
  (if-let ((override (cdr (assq type user-directory-alist))))
      override
    (cl-call-next-method)))

;;;; Configuration, cache, and state.

(cl-defmethod user-directory ((_type (eql 'cache)))
  "Return the user cache directory.
The user should be able to remove cache "
  (cond ((expand-file-name "emacs" (xdg-cache-home)))
        ;; TODO: Insert other platforms here.
        ("~/.cache")))

(cl-defmethod user-directory ((_type (eql 'config)))
  "Return the user cache directory.
The cache directory contains non-essential user data."
  (cond ((expand-file-name "emacs" (xdg-config-home)))
        ;; TODO: Insert other platforms here.
        ("~/.cache")))

(cl-defmethod user-directory ((_type (eql 'data)))
  "Return the user data directory.
The data directory contains user-specific data files.
See also the state directory."
  (cond ((expand-file-name "emacs" (xdg-data-home)))
        ;; TODO: Insert other platforms here.
        ("~/.local/share")))

(cl-defmethod user-directory ((_type (eql 'runtime)))
  "Return the user state directory.
The runtime directory contains user-specific non-essential
runtime files and other file objects (such as sockets, named
pipes, ...)."
  (cond ((expand-file-name "emacs" (xdg-runtime-dir)))
        ;; TODO: Insert other platforms here.
        ("~/.local/state")))

(cl-defmethod user-directory ((_type (eql 'state)))
  "Return the user state directory.
In comparison to the data directory, the state directory contains
user data that should persist between restarts of Emacs, but is
not important enough to store in the data directory."
  (cond ((expand-file-name "emacs" (xdg-state-home)))
        ;; TODO: Insert other platforms here.
        ("~/.local/state/emacs")))

;;;; User files.

(cl-defmethod user-directory ((_type (eql 'desktop)))
  "Return user desktop directory."
  (cond ((xdg-user-dir "DESKTOP"))
        ;; TODO: Insert other platforms here.
        ("~/Desktop")))

(cl-defmethod user-directory ((_type (eql 'downloads)))
  "Return user directory for downloads."
  (cond ((xdg-user-dir "DOWNLOAD"))
        ;; TODO: Insert other platforms here.
        ("~/Downloads")))

(cl-defmethod user-directory ((_type (eql 'documents)))
  "Return user directory for documents."
  (cond ((xdg-user-dir "DOCUMENTS"))
        ;; TODO: Insert other platforms here.
        ("~/Documents")))

(cl-defmethod user-directory ((_type (eql 'music)))
  "Return user directory for music."
  (cond ((xdg-user-dir "MUSIC"))
        ;; TODO: Insert other platforms here.
        ("~/Music")))

(cl-defmethod user-directory ((_type (eql 'public)))
  "Return user directory for public (shared) files."
  (cond ((xdg-user-dir "PUBLIC"))
        ;; TODO: Insert other platforms here.
        ("~/Public")))

(cl-defmethod user-directory ((_type (eql 'pictures)))
  "Return user directory for documents."
  (cond ((xdg-user-dir "PICTURES"))
        ;; TODO: Insert other platforms here.
        ("~/Pictures")))

(cl-defmethod user-directory ((_type (eql 'templates)))
  "Return user directory for templates."
  (cond ((xdg-user-dir "TEMPLATES"))
        ;; TODO: Insert other platforms here.
        ("~/Templates")))

(cl-defmethod user-directory ((_type (eql 'videos)))
  "Return user directory for video files."
  (cond ((xdg-user-dir "VIDEOS"))
        ;; TODO: Insert other platforms here.
        ("~/Videos")))

(provide 'user-directory)

;;; user-directory.el ends here
