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
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

  # Prologue
  addi sp sp -16
  sw ra 0(sp)
  sw s0 4(sp)
  sw s1 8(sp)
  sw s2 12(sp)

  mv s1 a1    # save matrix
  mul t0 a2 a3
  mv s2 t0

  # save the num of row and col on sp
  addi sp sp -8
  sw a2 0(sp)
  sw a3 4(sp)

  # open file
  addi a1 x0 1
  call fopen

  addi t0 x0 -1
  beq t0 a0 e_fopen
  mv s0 a0    # save *fd

  # write row and col
  mv a0 s0
  mv a1 sp
  addi a2 x0 2
  addi a3 x0 4
  call fwrite

  addi t0 x0 2
  bne t0 a0 e_fwrite

  addi sp sp 8 

  # write data
  mv a0 s0
  mv a1 s1
  mv a2 s2
  addi a3 x0 4
  call fwrite

  bne a0 s2 e_fwrite

  # close the file
  mv a0 s0
  call fclose

  bne x0 a0 e_fclose

  # Epilogue
  lw s2 12(sp)
  lw s1 8(sp)
  lw s0 4(sp)
  lw ra 0(sp)
  addi sp sp 16

  jr ra

e_fopen:
  li a0 27
  j exit
e_fwrite:
  li a0 30
  j exit
e_fclose:
  li a0 28
  j exit
