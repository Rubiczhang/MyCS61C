.import ../../src/utils.s
.import ../../src/dot.s

.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load address to array m1 into a1
    la a1 m1

    # load 3 into a2
    li a2 3

    # load 2 into a3
    li a3 2

    # load 0 into a4
    li a4 0

    # call dot function
    jal ra dot
    # we expect dot to exit early with code 58

    # exit normally
    jal exit
