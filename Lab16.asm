section .data
    two dq 2.0                  ; Значення 2.0
    two_point_five dq 2.5       ; Значення 2.5
    three_thousand dq 3000.0    ; Значення 3000.0
    three_point_six dq 3.6       ; Значення 3.6
    minus_seven_point_five dq -7.5 ; Значення -7.5
    fmt_result db "Результат: y = %f", 10, 0 ; Формат для виведення результату
    fmt_zero_division db "Помилка: ділення на нуль!", 10, 0 ; Формат для помилки

section .text
    extern printf
    global main

main:
    ; Зберегти значення базового вказівника
    push rbp
    mov rbp, rsp

    ; Обчислення виразу: 3000 - 2 * 2^2 + 2.5 * 2 (Код 1)
    movsd xmm0, [three_thousand] ; xmm0 = 3000.0

    ; Обчислення 2 * 2^2
    movsd xmm1, [two]             ; xmm1 = 2.0
    mulsd xmm1, xmm1              ; xmm1 = 2.0 * 2.0 = 4.0
    mulsd xmm1, [two]             ; xmm1 = 2 * 4.0 = 8.0
    subsd xmm0, xmm1              ; xmm0 = 3000.0 - 8.0

    ; Обчислення 2.5 * 2
    movsd xmm2, [two_point_five]  ; xmm2 = 2.5
    mulsd xmm2, [two]             ; xmm2 = 2.5 * 2.0 = 5.0

    ; Додавання до результату
    addsd xmm0, xmm2              ; xmm0 = 2992.0 + 5.0
    ; Результат Код 1 в xmm0

    ; Обчислення виразу: 2^2 + 3.6 * 2 - 7.5 (Код 2)
    movsd xmm1, [two]            ; xmm1 = 2.0
    mulsd xmm1, xmm1             ; xmm1 = 2.0 * 2.0 = 4.0

    ; Обчислення 3.6 * 2
    movsd xmm2, [three_point_six] ; xmm2 = 3.6
    mulsd xmm2, [two]            ; xmm2 = 3.6 * 2.0 = 7.2

    ; Додавання результатів
    addsd xmm1, xmm2             ; xmm1 = 4.0 + 7.2 = 11.2

    ; Віднімання 7.5
    movsd xmm2, [minus_seven_point_five] ; xmm2 = -7.5
    addsd xmm1, xmm2             ; xmm1 = 11.2 - 7.5 = 3.7
    ; Результат Код 2 в xmm1

    ; Ділення результату Код 1 на результат Код 2
    ; Перевірка на нуль перед діленням
    ucomisd xmm1, xmm1           ; Порівняння для перевірки на нуль
    jp zero_division              ; Якщо результат Код 2 нульовий, перейти на zero_division

    divsd xmm0, xmm1              ; xmm0 = результат Код 1 / результат Код 2

    ; Виведення результату
    mov rdi, fmt_result          ; Формат для виведення
    mov rax, 1                   ; Один аргумент для printf
    call printf
    jmp end_program

zero_division:
    ; Виведення повідомлення про помилку
    mov rdi, fmt_zero_division    ; Формат для виведення помилки
    mov rax, 1                   ; Один аргумент для printf
    call printf

end_program:
    ; Завершити програму
    mov rsp, rbp                 ; Відновити базовий вказівник
    mov rax, 60                  ; syscall: exit
    xor rdi, rdi                 ; статус виходу 0
    syscall
