#!/bin/bash

nasm -f elf32 -o out.o program.asm
ld -m elf_i386 -o out out.o io.o
./out
