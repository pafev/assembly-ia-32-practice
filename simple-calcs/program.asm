%include "io.mac"

section .data
section .bss
section .text
global _start
_start:
    sub esp, 8
    mov ebp, esp

    call input_nums

    ; passagem por referencia
    lea eax, [ebp]
    lea ebx, [ebp+4]
    push eax ; endereco do primeiro num
    push ebx ; endereco do segundo num
    call sum_nums ; resultado em eax
    add esp, 8

    call output_sum

    lea eax, [ebp]
    lea ebx, [ebp+4]
    push eax
    push ebx
    call sub_nums
    add esp, 8

    call output_sub

    lea eax, [ebp]
    lea ebx, [ebp+4]
    push eax
    push ebx
    call mult_nums
    add esp, 8

    call output_mult

    mov eax, 1
    mov ebx, 0
    int 80h

; Params: entrada do usuário
; Returns: [ebp] = primeiro num de entrada, [ebp+4] = segundo num de entrada
input_nums:
    PutCh 'N'
    PutCh 'u'
    PutCh 'm'
    PutCh '1'
    PutCh ':'
    PutCh ' '
    GetLInt [ebp] ; entrada do primeiro num

    PutCh 'N'
    PutCh 'u'
    PutCh 'm'
    PutCh '2'
    PutCh ':'
    PutCh ' '
    GetLInt [ebp+4] ; entrada do segundo num

    ret

; Params: eax = valor da soma a exibir
; Returns: saida no console
output_sum:
    PutCh 'S'
    PutCh 'u'
    PutCh 'm'
    PutCh ' '
    PutCh '='
    PutCh ' '
    PutLInt eax
    nwln

    ret

; Params: eax = valor da multiplicacao a exibir
; Returns: saida no console
output_mult:
    PutCh 'M'
    PutCh 'u'
    PutCh 'l'
    PutCh 't'
    PutCh ' '
    PutCh '='
    PutCh ' '
    PutLInt eax
    nwln

    ret

; Params: [ebp+8] = primeiro número, [ebp+12] = segundo número
; Returns: eax = soma dos dois números
sum_nums:
    push ebp
    mov ebp, esp
    push ebx

    mov eax, [ebp+8]
    mov ebx, [ebp+12]
    mov eax, [eax]
    add eax, [ebx]

    pop ebx
    pop ebp
    ret

; implementa multiplicação por somas sucessivas usando a função sum_nums
; Params: [ebp+8] = multiplicando, [ebp+12] = multiplicador
; Returns: eax = produto dos dois números
mult_nums:
    push ebp
    mov ebp, esp
    ; salvamento dos registradores que serao usados
    push ebx
    push ecx
    push edx

    ; var locais usando registradores
    mov ebx, [ebp+8] ; ebx = multiplicando
    mov ecx, [ebp+12] ; ecx = multiplicador

    ; determinando se resultado será negativo
    mov eax, [ebx]
    xor eax, [ecx]
    push eax ; salva informação do sinal na pilha

    ; trabalhando com valores absolutos
    cmp dword [ebx], 0
    jge abs_num1_ok
    neg dword [ebx]
abs_num1_ok:
    cmp dword [ecx], 0
    jge abs_num2_ok
    neg dword [ecx]
abs_num2_ok:
    mov edx, [ecx] ; edx = multiplicador (contador)
    mov dword [ecx], 0 ; acumulador do resultado em referencia
loop_mult:
    cmp edx, 0
    je end_loop_mult
    dec edx
    push ebx ; multiplicador
    push ecx ; resultado acumulado
    call sum_nums ; eax = *ebx + *ecx
    add esp, 8
    mov [ecx], eax ; atualiza acumulado
    jmp loop_mult
end_loop_mult:
    pop eax ; recupera informação do sinal
    cmp eax, 0
    jge positive_result
    neg dword [ecx] ; inverte sinal se necessário
positive_result:
    mov eax, [ecx]
end_mult:
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret

; Params: [ebp+8] = primeiro número, [ebp+12] = segundo número
; Returns: eax = primeiro número - segundo número
sub_nums:
    push ebp
    mov ebp, esp
    push ebx

    mov eax, [ebp+12]
    mov ebx, [ebp+8]
    mov eax, [eax]
    sub eax, [ebx]

    pop ebx
    pop ebp
    ret

; Params: eax = valor da subtracao a exibir
; Returns: saida no console
output_sub:
    PutCh 'S'
    PutCh 'u'
    PutCh 'b'
    PutCh ' '
    PutCh '='
    PutCh ' '
    PutLInt eax
    nwln

    ret

