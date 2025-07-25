%include "io.mac"

section .data
    filename db "file.txt", 0
    str_erro db "erro ao abrir arquivo", 0

section .bss
    char_buffer resb 1
    fd_file resd 1 ; file descriptor

section .text
global _start
_start:
    call open_file
    cmp eax, 0
    jl open_error

    call process_file

    call close_file

    mov eax, 1
    mov ebx, 0
    int 80h

open_file:
    push ebx
    push ecx
    push edx

    mov eax, 5 ; sys_open
    mov ebx, filename ; endereço do nome do arquivo
    mov ecx, 0 ; O_RDONLY
    mov edx, 0 ; sem permissões especiais
    int 80h

    mov [fd_file], eax ; guardando file descriptor

    pop edx
    pop ecx
    pop ebx
    ret

process_file:
    push eax
    push ebx
    push ecx
    push edx
loop_chars:
    mov eax, 3 ; sys_read
    mov ebx, [fd_file] ; file descriptor
    mov ecx, char_buffer ; buffer de 1 byte
    mov edx, 1 ; ler apenas 1 byte
    int 80h

    cmp eax, 0
    jle end_process_file

    PutCh [char_buffer]

    jmp loop_chars
end_process_file:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

close_file:
    push eax
    push ebx

    mov eax, 6 ; sys_close
    mov ebx, [fd_file] ; file descriptor
    int 80h

    pop ebx
    pop eax
    ret

open_error:
    PutStr str_erro 
    mov eax, 1
    mov ebx, 0
    int 80h
