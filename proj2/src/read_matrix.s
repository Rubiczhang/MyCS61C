.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
#  The pesudo code
# FILE* fp = fopen(/, a0, 0);
# if(fp == -1) 
# 	exit 89
# 
# int heightNwidth[2];
# int ret = fread(a0, fp, heightNwidth, 2);
# if(ret != 2)
# 	exit 91
# 
# int cunts = heightNwidth[0] * heightNwidth[1]
# int* buff = malloc(sizeof(int) * cunts);
# if(buff == 0)
# 	exit 88
# 
# int ret = fread(a0, fp, buff, cunts);
# if(ret != cunts)
# 	exit 91
# 
# int ret = fclode(fp)
# if(ret == -1)
# 	exit 90
#  
read_matrix:
    
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)
    # Prologue
    add s0, a0, x0      #s0 is name
    add s1, a1, x0      #s1 is pointer to height
    add s2, a2, x0      #s2 is pointer to width

    add a1, a0, zero   #a1 is filename
    add a2, x0, x0      #a2 is mod
    jal fopen
    add s0, a0, x0      #s0 is fp
    li t0, -1
    beq a0, t0, exit_89

    addi sp, sp, -8      #to save address of height and width
    add a1, s0, x0      #a1 is fp
    add a2, sp, x0      #a2 is address of height and witdh
    li a3, 8            #a3 is the count of bytes
    jal fread           #fread of height and width
    li t0, 8
    bne a0, t0, exit_91

    lw t0, 0(sp)        #t0 is height
    lw t1, 4(sp)        #t1 is width
    mul t0, t0, t1      #t0 is cunts of words
     #---debug---
#    add a1, t1, x0
#    jal print_int
    #---debug---
    slli s4, t0, 2      #s4 is counts of bytes
    add a0, s4, x0
   jal malloc          #call malloc
    beq a0, x0, exit_88 #if malloc take error
    add s3, a0, x0      #s3 is address of buffer

    add a1, s0, x0      #a1 is fp
    add a2, s3, x0      #a2 is address of buffer
    add a3, s4, x0      
    jal fread           #call fread
#    ------------------debug-begin------------
#    add a1, s4, x0
#    jal print_int
#    li a1, ' '
#    jal print_char
#    add a1, a0, x0
#    jal print_int
#    ----------------------debug-----------------
    bne a0, s4, exit_91

    add a1, s0, x0      #a1 is discriptor
    jal fclose          #call fclose
    li t0, -1
    beq a0, t0, exit_90 

    lw t0, 0(sp)
    lw t1, 4(sp)
    sw t0, 0(s1)
    sw t1, 0(s2)
    add a0, s3, x0
    # Epilogue
    
    
    addi sp, sp, 8
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
    addi sp, sp, 24

    ret

exit_88:
    li a1, 88
    jal exit2
exit_89:
    li a1, 89
    jal exit2
exit_90:
    li a1, 90
    jal exit2
exit_91:
    li a1, 91
    jal exit2
   
   
   
   
   
   
   
   
   
   
   
   
   