.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# ==============================================================================
relu:
    # Prologue
    # if(a1 < 1)
    #    exit 32 
    # int t0 = 0
    # while(t0 < a1){
    #    if(a0[t0] < 0)
    #       t1 = 0;
    #       t0++;
    #}
    li t0, 1
    blt a1, t0, exit_32    #if(a1 < 1)
    
    add t0, zero, zero

loop_start:
    bge t0, a1, loop_end  #while begin
    slli t1, t0, 2        #t1 is offset of a0
    add t3, t1, a0        #t3 is address of the element
    lw t2, 0(t3)          #a0[t0] is in t2
    bge t2, zero, loop_continue
    sw zero, 0(t3)        #a0[t0] = 0
loop_continue:
    addi t0, t0, 1
    j loop_start
loop_end:
   
    # Epilogue
	ret

exit_32:
    li a1, 32
    jal exit2
