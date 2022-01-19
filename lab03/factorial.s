.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    # here is c code :
    # to get factorial of x
    # int answer = 1;
    # while (x != 1){
    #   answer = answer * x;
    #   x--;
    # }
    # return anwser;
    addi t0, x0, 1   #answer is in t0
    addi t1, x0, 1   #t1 always holds 1
loop:                #here will do factorial loop
    beq a0, t1, exit
    mul t0, t0, a0
    addi a0, a0, -1
    jal x0 loop
exit:
    
    addi a0, t0, 0   #put answer into a0
    ret
endFactorial: 
