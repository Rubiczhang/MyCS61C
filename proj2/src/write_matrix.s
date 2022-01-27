.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
# s0: fp
# s1: pointer to matrix
# s2: height
# s3: width
# s4: totCunts
# 
# FILE* fp = fopen(/, a0, 1);
# if(fp == -1) 
# 	exit 89
# 
# int heightNwidth[2] = {a2, a3};
# int ret = fwrite(fp, sp, 2, 4);
# if(ret != 2)
# 	exit 92
# 
# int cunts = height * width
# 
# int ret = fwrite(fp, s1, cunts, 4);
# if(ret != cunts)
# 	exit 92
# 
# int ret = fclose(fp)
# if(ret == -1)
# 	exit 90
# 
write_matrix:

    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    # ^Prologue

    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0
    
    #call fopen
    add a1, a0, x0      #a1 is the filename
    li a2, 1            #a2 is mode "w"
    jal fopen           #call fopen
    li t0, -1
    beq t0, a0, exit_89 #check ret of fopen
    add s0, a0, x0      #s0 is fp

    #save height and width
    addi sp, sp, -8      #save height and width
    sw s2, 0(sp)        
    sw s3, 4(sp)
    
    #call fwrite t0 write height and width
    add a1, s0, x0      #a1 is fp
    add a2, sp, x0      #a2 is pointer to hNw
    li a3, 2            #a3 is count of element
    li a4, 4            #a4 is size of element 
    jal fwrite
    li t0, 2
    bne a0, t0, exit_92

    #call fwrite to wirte the martix
    mul s4, s2, s3     #s4 is counts
    add a1, s0, x0     #a1 is fp
    add a2, s1, x0     #a2 is pointer to matrix
    add a3, s4, x0     #a3 is counts
    li a4, 4           #a4 is size of int
    jal fwrite
    bne a0, s4, exit_92

    #call fclose
    add a0, s0, x0      #a0 is fp
    jal fclose
    li t0, -1
    beq a0, t0, exit_90

    addi sp, sp, 8       #pop height and width
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp) 
    addi sp, sp, 24

    ret

exit_89:
    li a1, 89
    jal exit2
exit_90:
    li a1, 90
    jal exit2
exit_92:
    li a1, 92
    jal exit2