.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# =================================================================
argmax:
    bge zero, a1, exit_57
    
    lw t3, 0(a0)    # t3: the max value
    li t1, 1        # t1: i
    li t2, 0        # t2: max Index 
    addi t4, a0, 4# t4: address of current element
loop_start:
    bge t1, a1, loop_end #while begin

    lw t5, 0(t4)    #t5: value of current element
    bge t3, t5, loop_continue
    add t3, t5, zero   #update max
    add t2, t1, zero   #update maxId

loop_continue:
    addi t4, t4, 4
    addi t1, t1, 1
    j loop_start
loop_end:

    add a0, t2, zero
    ret

exit_57:
    li a1, 57
    jal exit2