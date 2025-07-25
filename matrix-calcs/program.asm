%include "io.mac"

section .data
    str_init db "Prova Substitutiva - Software Basico - Questao 3", 0
    str_input_line1 db "Line ", 0
    str_input_line2 db ": ", 0
    str_input_num db "Num: ", 0  
    str_output db "Resultado:", 0

section .bss
    temp resd 1

section .text
global input
global output
global process

; Params:
;   [ebp+8]  - char* vector: ponteiro para array de 25 chars (matriz 5x5)
;   [ebp+12] - char* num: ponteiro para variável char (multiplicador)
; Returns: void (valores lidos são armazenados nas variáveis apontadas)
input:
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push edx

    mov esi, [ebp+8]
    mov edi, [ebp+12]

    PutStr str_init
    nwln
    nwln

    mov edx, 0
    mov eax, 0
loop1_input:
    inc edx
    PutStr str_input_line1
    PutLInt edx
    PutStr str_input_line2
    nwln
    mov ebx, 0
loop2_input:
    lea ecx, [esi+eax]
    add ecx, ebx
    call input_char
    add ebx, 1
    cmp ebx, 5
    jl loop2_input
    add eax, 5
    cmp eax, 25
    jl loop1_input

    PutStr str_input_num
    GetLInt eax
    mov [edi], al

    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret
; func aux
; le um inteiro e armazena como char no endereço especificado em ecx
input_char:
    push eax

    GetLInt eax
    mov [ecx], al

    pop eax
    ret


; Params:
;   [ebp+8]  - char* vector: ponteiro para array de 25 chars (matriz 5x5)
;   [ebp+12] - char* num: ponteiro para variável char (multiplicador)
; Returns: void (valores modificados in-place)
process:
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx

    mov esi, [ebp+8]
    mov edi, [ebp+12]

    mov eax, 0
loop1_process:
    mov ebx, 0
loop2_process:
    lea ecx, [esi+eax]
    add ecx, ebx
    call mult_char
    add ebx, 1
    cmp ebx, 5
    jl loop2_process
    add eax, 5
    cmp eax, 25
    jl loop1_process

    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret
; func aux
; multiplica o char multiplicador pelo char do vetor no endereço especificado em ecx 
mult_char:
    push eax

    mov eax, [ecx]
    imul byte [edi]
    mov [ecx], al

    pop eax
    ret

; Params:
;   [ebp+8] - char* vector: ponteiro para array de 25 chars (matriz 5x5)
; Returns: void (saída impressa na tela)
output:
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx

    mov esi, [ebp+8]

    PutStr str_output
    nwln

    mov eax, 0
loop1_output:
    mov ebx, 0
loop2_output:
    lea ecx, [esi+eax]
    add ecx, ebx
    call output_char
    PutCh ' '
    add ebx, 1
    cmp ebx, 5
    jl loop2_output
    nwln
    add eax, 5
    cmp eax, 25
    jl loop1_output

    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret
; func aux
; converte um char do vetor 5x5, no endereco ecx, para int e o imprime na tela
output_char:
    push eax

    mov al, [ecx]
    mov [temp], al
    PutLInt [temp]

    pop eax
    ret

