.section .data
array:  .fill  30000
.section .text
.globl _start
_start:
    mov $0, %edi # set the index to 0
    mov data_items(,%edi, 4), %eax # Load the first element with 4 byte alignment to eax

incr:
    mov data_items(,%edi, 4), %ebx
    inc %ebx
    mov %ebx, data_items(,%edi, 4)
decr:
    mov data_items(,%edi, 4), %ebx
    dec %ebx
    mov %ebx, data_items(,%edi, 4)

bf:
    # Check if the null terminator has been hit
    cmp $0, %eax
    je exit # jump to exit if equal

    # Increment the pointer, and load it
    inc %edi
    mov data_items(,%edi,4), %eax

    # Determine if current value is bigger than the last stored val
    cmp %ebx, %eax
    jle do_loop # Re-loop if value at pointer <= bigest val

    # Set the current value as the biggest
    mov %eax, %ebx

    # Re-loop
    jle do_loop



exit:
    mov $1, %eax
    mov data_items(,%edi, 4), %ebx
    int $0x80
