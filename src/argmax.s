.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
  # Prologue
  addi sp sp -20
  sw s0 0(sp)
  sw s1 4(sp)
  sw s2 8(sp)
  sw s3 12(sp)
  sw ra 16(sp)

  blt x0 a0 loop_start
  addi a0 x0 36
  j exit

loop_start:
  addi s0 x0 0
  addi s1 x0 0
  addi t0 a0 0
  lw s2 0(t0)

loop_continue:
  lw s3 0(t0)
  bge s2 s3 loop_end
  add s2 x0 s3
  add s0 x0 s1

loop_end:
  addi s1 s1 1
  addi t0 t0 4
  blt s1 a1 loop_continue

  add a0 x0 s0

  # Epilogue
  lw s0 0(sp)
  lw s1 4(sp)
  lw s2 8(sp)
  lw s3 12(sp)
  lw ra 16(sp)
  addi sp sp 20

  jr ra
