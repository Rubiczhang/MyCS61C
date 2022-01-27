.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero,
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    #prologue
    addi sp, sp, -72
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw ra, 40(sp)
    #prologue takes 44 bytes
    #h1, w1, h2, w2, h3, w3 take 24 bytes
    #44, 48, 52, 56, 60, 64   is offset
    
    # if argc != 5 exit 72
    li t0, 5
    bne a0, t0, exit_72
    #save a registers
    add s0, a2, x0      #s0 is the flag
    add s1, a1, x0      #s1 is argv

    # =====================================
    # LOAD MATRICES
    # =====================================

     
    # Load pretrained m0
    lw a0, 4(s1)
    addi a1, sp, 44
    addi a2, sp, 48
    jal read_matrix
    add s2, a0, x0      #s2 is address of m0


    # Load pretrained m1
    lw a0, 8(s1)
    addi a1, sp, 52
    addi a2, sp, 56
    jal read_matrix
    add s3, a0, x0      #s3 is address of m1
    # Load input matrix

    lw a0, 12(s1)
    addi a1, sp, 60
    addi a2, sp, 64
    jal read_matrix
    add s4, a0, x0      #s4 is address of input
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    
    # call malloc
    lw t0, 44(sp)
    lw t1, 64(sp)
    mul a0, t0, t1
    slli a0, a0, 2
    jal malloc
    beq a0, x0, exit_88
    add s5, a0, x0      #s5 is m0 * input
    
    #m0 * input 
    add a0, s2, x0      #a0 is mo
    lw a1, 44(sp)       #a1 is hi
    lw a2, 48(sp)       #a2 is w1
    add a3, s4, x0      #a3 is input
    lw a4, 60(sp)       #a4 is h3
    lw a5, 64(sp)       #a5 is w3
    add a6, s5, x0      #a6 is m4(AKA m0 * input)
    jal matmul          #there is no return value to deal 

    #relu m4
    lw a1, 44(sp)       #a1 is h1
    lw t0, 64(sp)       #t0 is w3
    mul a1, a1, t0      #a1 = h1 * w3
    add a0, s5, x0
    jal relu            #relu also return noting 

    # call malloc for m5, which is the final answer
    lw t0, 52(sp)       #t0 is h2
    lw t1, 64(sp)       #t1 is w3
    mul a0, t0, t1      #a0 is the count of words
    slli a0, a0, 2      #a0 is the count of bytes
    jal malloc
    beq a0, x0, exit_88 
    add s6, a0, x0      #s6 is address of ouput

    #get m1 * m4
    add a0, s3, x0      #a0 is m1
    lw a1, 44(sp)       #a1 is h1
    lw a2, 48(sp)       #a2 is w1
    add a3, s5, x0      #a3 is m4
    add a4, a1, x0      #a4 is h2
    lw a5, 64(sp)       #a5 is w3
    add a6, s6, x0      #a6 is m5, also the output
    jal matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    
    lw a0, 16(s1)       #a0 is OUTPUT_PATH
    add a1, s6, x0      #a1 is m5
    lw a2, 52(sp)       #a2 is h2
    lw a3, 64(sp)       #a3 is w3
    jal write_matrix

     
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw t0, 52(sp)       #h2
    lw t1, 64(sp)       #w3
    mul a1, t0, t1      #a1 = h2 * w3
    add a0, s6, x0      #a0 = m5
    jal argmax
    add s7, a0, x0      #s7 is the maxID 
    # Print classification
    bne s0, x0, Epliogue    #if(a2 != 0) goto EPliogue
    add a1, s7, x0
    jal print_int
    # Print newline afterwards for clarity  
    addi a1, x0, '\n'
    jal print_char
    #Epliogue
Epliogue:
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw ra, 40(sp)
    addi sp, sp, 72
    ret

exit_72:
    li a1, 72
    jal exit2
exit_88:
    li a1, 88
    jal exit2