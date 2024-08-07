.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
  # Prologue

  addi t0 x0 1
  blt a3 t0 done
  blt a4 t0 done

  addi t2 x0 0
  addi t3 x0 0
  slli a3 a3 2
  slli a4 a4 2

  blt x0 a2 loop_start

  li a0 36
  j exit 

done:
  li a0 37
  j exit

loop_start:
  lw t0 0(a0)
  lw t1 0(a1)
  mul t1 t0 t1
  add t2 t2 t1

  addi t3 t3 1
  add a0 a0 a3
  add a1 a1 a4
  blt t3 a2 loop_start

loop_end:
    # Epilogue

  mv a0 t2
  jr ra
