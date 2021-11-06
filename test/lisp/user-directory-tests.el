;;; user-directory-tests.el --- tests for user-directory.el -*- lexical-binding: t -*-

;; Copyright (C) 2021 Free Software Foundation, Inc.

;; Author: Stefan Kangas <stefan@marxist.se>

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

;;; Code:

(require 'ert)
(require 'user-directory)

(ert-deftest user-directory-tests/conf-etc-files ()
  (should (stringp (user-directory 'cache)))
  (should (stringp (user-directory 'config)))
  (should (stringp (user-directory 'data)))
  (should (stringp (user-directory 'runtime)))
  (should (stringp (user-directory 'state))))

(ert-deftest user-directory-tests/user-files ()
  (should (stringp (user-directory 'desktop)))
  (should (stringp (user-directory 'downloads)))
  (should (stringp (user-directory 'documents)))
  (should (stringp (user-directory 'music)))
  (should (stringp (user-directory 'public)))
  (should (stringp (user-directory 'pictures)))
  (should (stringp (user-directory 'templates)))
  (should (stringp (user-directory 'videos))))

(ert-deftest user-directory-tests/override ()
  (let ((user-directory-alist '((desktop . "foo"))))
   (should (equal (user-directory 'desktop) "foo"))))

;;; user-directory-tests.el ends here
