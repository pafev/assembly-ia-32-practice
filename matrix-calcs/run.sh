#!/bin/bash

nasm -f elf32 -o out.o program.asm
gcc -m32 -no-pie -static -o out program.c out.o io.o
./out
