.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:
    
    # insert code here
	addi s9, zero, 64
    add s10 ,zero, zero
    add s11, zero, a1 # B
L2:
    add s8, zero, zero
L1:
    lhu s0, 0(a0) #A[i][k]
    addi a0, a0, 2
    lhu s1, 0(a0) #A[i][+1]
    addi a0, a0, 254
    lhu s2, 0(a0)  #a[i+1][k]
    addi a0, a0, 2
    lhu s3, 0(a0)  #a[i+1][k+1]
    lhu s4, 0(s11) #B[i][k]
    addi a1, a1, 2
    add s11, zero, a1
	lhu s5, 0(s11) #B[i][k+1]
    addi a1, a1, 254
    add s11, zero, a1
    lhu s6, 0(s11)  #B[i+1][k]
    addi a1, a1, 2
    add s11, zero, a1
    lhu s7, 0(s11)  #B[i+1][k+1]

    add t0, s0, s3
    add t1, s4, s7
    mul t0, t0, t1 #M1
    andi t0, t0, 1023

    add t0, s2, s3
    mul t1, t0, s4 #M2
    andi t1, t1, 1023

    sub t0, s5, s7
    mul t2, s0, t0 #M3
    andi t2, t2, 1023

    sub t0, s6, s4
    mul t3, s3, t0 #M4
    andi t3, t3, 1023

    add t0 ,s0, s1
    mul t4, t0, s7 #M5
    andi t4, t4, 1023
	
    sub t0, s2, s0
    add t1, s4, s5
    mul t5, t0, t1 #M6
    andi t5, t5, 1023

    sub t0, s1, s3
    add t1, s6, s7
    mul t6, t0, t1 #M7
    andi t6, t6, 1023

    add t0, s0, s3
    add t1, s4, s7
    mul t0, t0, t1 #M1
    andi t0, t0, 1023

    add t1, s2, s3
    mul t1, t1, s4 #M2
    andi t1, t1, 1023

    add s0, t0, t3
    sub s0, s0, t4
    add s0, s0, t6
    andi s0, s0, 1023
    sh s0, 0(a2) # C[i][j]
    add s0, t2, t4
    andi s0, s0, 1023
    addi a2, a2, 2
    sh s0, 0(a2) # C[i][j+1]
    add s0, t1, t3
    andi s0, s0, 1023
    addi a2, a2, 254
    sh s0, 0(a2) #C[i+1][j]
    sub s0, t0, t1
    add s0, s0, t2
    add s0, s0, t5
    andi s0, s0, 1023
    addi a2, a2, 2
    sh s0 ,0(a2) #C[i+1][j+1]

    addi a0, a0, -254
    addi a1, a1, -254
    add s11, zero, a1
    addi a2, a2, -254
    addi s8, s8, 1

    bne s8, s9, L1

    addi a0, a0, 256
    addi a1, a1, 256
    add s11, zero, a1
    addi a2, a2, 256
    addi s10, s10, 1

    bne s10, s9, L2	
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    # Matrix multiplication: https://en.wikipedia.org/wiki/Matrix_multiplication
    ret
