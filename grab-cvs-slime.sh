#!/bin/sh
#Grab slime from upstream cvs repository.

export CVSROOT=:pserver:anonymous@common-lisp.net:/project/slime/cvsroot
cvs login
cvs checkout slime