.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================
dot:

    # if(a2 < 1)
    #    exit(32)
    # if(
    blt zero, a2, checkStride1
    li a1, 32
    jal exit2
  checkStride1:
    blt zero, a3, checkStride2
    li a1, 33
    jal exit2
  checkStride2:
    blt zero, a4, loop_start
    li a1, 33
    jal exit2  
loop_start:
# c code:
#   int t = 0;
#   int ans = 0;
#   while(t < a2){
#       t1 = a0[t*a3]
#       t2 = a1[t*a4]
#       t1 = t1 * t2
#       ans += t1;
#       t++;
#  
    add t0, zero, zero
    add t5, zero, zero
    
  addFromZero:
    bge t0, a2, allDone 
    mul t1, t0, a3  #t1 = t * a3
    slli t6, t1, 2
    add t1, t6, a0  
    lw t1, 0(t1)    #t1 = a0[t*a3]
    mul t2, t0, a4
    slli t6, t2, 2
    add t2, t6, a1
    lw t2, 0(t2)    #t2 = a0[t*a4]
    
    mul t1, t1, t2
    add t5, t1, t5
    addi t0, t0, 1
    j addFromZero 

  allDone:










loop_end:


    # Epilogue
    add a0, t5, zero

    ret
