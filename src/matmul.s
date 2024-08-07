.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

  ebreak
  # Error checks
  addi t0 x0 1
  blt a1 t0 error
  blt a2 t0 error
  blt a4 t0 error
  blt a5 t0 error
  bne a2 a4 error

  # Prologue
  addi sp sp -16
  sw s0 0(sp)
  sw s1 4(sp)
  sw s2 8(sp)
  sw ra 12(sp)

  mv s0 a6      # s0 = a6 = *p3;
  addi s1 x0 0  # i
  addi s2 x0 0  # j
  mv t0 a0  # *p1
  mv t1 a1  # m
  mv t2 a2  # n
  mv t3 a3  # *p2
  mv t4 a5  # k

outer_loop_start:
  mv s2 x0      # j = 0;

inner_loop_start:
  mul t5 s1 t2  # t5 = i*n;
  slli t5 t5 2  # t5*=4;
  add a0 t5 t0  # a0 = *p1 + t5;
  slli t5 s2 2  
  add a1 t5 t3  # a1 = j*4 + *p2;
  mv a2 t2      # a2 = n;
  addi a3 x0 1  # a3 = 1;
  mv a4 t4      # a4 =k;

  addi sp sp -20
  sw t0 0(sp)
  sw t1 4(sp)
  sw t2 8(sp)
  sw t3 12(sp)
  sw t4 16(sp)

  call dot

  lw t4 16(sp)
  lw t3 12(sp)
  lw t2 8(sp)
  lw t1 4(sp)
  lw t0 0(sp)
  addi sp sp 20

  sw a0 0(s0)   # p3[i][j]

  addi s0 s0 4  # s0 += 4;
  addi s2 s2 1  # s2 += 1;

  # j < k; continue
  blt s2 t4 inner_loop_start 

inner_loop_end:
  addi s1 s1 1  # i += 1;

  # i < m; continue
  blt s1 t1 outer_loop_start

outer_loop_end:
  # Epilogue
  lw ra 12(sp)
  lw s2 8(sp)
  lw s1 4(sp)
  lw s0 0(sp)
  addi sp sp 16
  
  jr ra

error:
  li a0 38
  j exit
