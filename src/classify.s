.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:

  # Prologue
  addi sp sp -32
  sw ra 0(sp)
  sw s0 4(sp)
  sw s1 8(sp)
  sw s2 12(sp)
  sw s3 16(sp)  # m0
  sw s4 20(sp)  # m1
  sw s5 24(sp)  # input
  sw s6 28(sp)  # h
  sw s7 32(sp)  # o

  # a0 == 5?
  addi t0 x0 5
  bne a0 t0 e_wrong_arg

  # save useful value
  mv s0 a0
  mv s1 a1
  mv s2 a2

  # use sp to store row and col, temp
  addi sp sp -40

  # Read pretrained m0
  # addi a0 s1 4
  lw a0 4(s1)
  addi a1 sp 0  # m0.row
  addi a2 sp 4  # m0.col

  call read_matrix
  mv s3 a0

  # Read pretrained m1
  lw a0 8(s1)
  addi a1 sp 8  # m1.row
  addi a2 sp 12 # m1.col

  call read_matrix
  mv s4 a0

  # Read input matrix
  lw a0 12(s1)
  addi a1 sp 16 # input.row
  addi a2 sp 20 # input.col

  call read_matrix
  mv s5 a0

  # malloc space for h
  lw t0 0(sp)   # h.row = m0.row
  lw t1 20(sp)  # h.col = input.col
  sw t0 24(sp)  # h.row
  sw t1 28(sp)  # h.col
  mul a0 t0 t1
  slli a0 a0 2  # a0 = 4 * (t1 * t0)

  call malloc
  beq x0 a0 e_malloc
  mv s6 a0

  # Compute h = matmul(m0, input)
  mv a0 s3
  lw a1 0(sp)
  lw a2 4(sp)
  mv a3 s5
  lw a4 16(sp)
  lw a5 20(sp)
  mv a6 s6

  call matmul

  # Compute h = relu(h)
  mv a0 s6
  lw t0 24(sp)
  lw t1 28(sp)
  mul a1 t0 t1

  call relu

  # malloc space for o
  lw t0 8(sp)   # o.row = m1.row
  lw t1 28(sp)  # o.col = h.col
  sw t0 32(sp)  # o.row
  sw t1 36(sp)  # o.col
  mul a0 t0 t1
  slli a0 a0 2  # a0 = 4 * (t1 * t0)

  call malloc
  beq x0 a0 e_malloc
  mv s7 a0

  # Compute o = matmul(m1, h)
  mv a0 s4
  lw a1 8(sp)
  lw a2 12(sp)
  mv a3 s6
  lw a4 24(sp)
  lw a5 28(sp)
  mv a6 s7

  call matmul

  # Write output matrix o
  lw a0 16(s1)
  mv a1 s7
  lw a2 32(sp)
  lw a3 36(sp)

  call write_matrix

  # Compute and return argmax(o)
  mv a0 s7
  lw t0 32(sp)
  lw t1 36(sp)
  mul a1 t0 t1

  call argmax
  mv s0 a0

  ebreak
  # If enabled, print argmax(o) and newline
  bne s2 x0 not_print
  call print_int
  li a0 '\n'
  call print_char

not_print:
  # free space
  mv a0 s3
  call free
  mv a0 s4
  call free
  mv a0 s5
  call free
  mv a0 s6
  call free
  mv a0 s7
  call free

  # stack space
  addi sp sp 40

  # return
  mv a0 s0

  # Epilogue
  lw s7 32(sp)
  lw s6 28(sp)
  lw s5 24(sp)
  lw s4 20(sp)
  lw s3 16(sp)
  lw s2 12(sp)
  lw s1 8(sp)
  lw s0 4(sp)
  lw ra 0(sp)
  addi sp sp 32

  jr ra

e_wrong_arg:
  addi a0 x0 31
  j exit
e_malloc:
  addi a0 x0 26
  j exit
