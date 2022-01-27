.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================
matmul:
    #check parameter
    bge zero, a1, exit_59
    bge zero, a2, exit_59
    bge zero, a4, exit_59
    bge zero, a5, exit_59
    bne a2, a4, exit_59

    #save registers
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw, s4, 16(sp)
    sw, s5, 20(sp)

    add s0, x0, x0     #s0 is i
    add s1, a0, x0      #s1 is address of a0
    add s4, a6, zero    #s4 is address of d
outer_loop_start:
    bge s0, a1, outer_loop_end
    
    add s2, x0, x0     #s2 is j
    add s3, a3, x0     #s3 is address of a3
inner_loop_start:
    bge s2, a5, inner_loop_end  #j >= a5, break

    #call dot
    addi sp, sp, -28
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw ra, 24(sp)
    
    slli t0, s2, 2  #t0 is j * 4
    add a1, a3, t0  #a1 is the strat of v1
    add a0, s1, x0      #a0 is start of v0
    #a1 is the strat of v1
    #a2 is already length of vectors
    addi a3, x0, 1  #the stride of v0 is 1
    add a4, a5, x0  #the stride of v1 is width of m1

    jal ra dot
    add s5, a0, x0          #s5 is dot answer 
    
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    
    sw s5, 0(s4)    #save s5 in s4
    addi s4, s4, 4
    addi s3, s3, 4  #update s3
    addi s2, s2, 1  #update j
    j inner_loop_start 
inner_loop_end:
    addi s0, s0, 1
    slli t0, a2, 2      #offset of every line 
    add s1, s1, t0      #s1 is address of a0
    j outer_loop_start
outer_loop_end:

    #restroe registers
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp, 24
    ret

exit_59:
    li a1, 59
    jal exit2
