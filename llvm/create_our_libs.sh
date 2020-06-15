#!/bin/bash

rm our_libs.o our_libs.a
cc -c our_libs.c -o our_libs.o
ar rs our_libs.a our_libs.o
./dana -indent test/indented/skip.dna
