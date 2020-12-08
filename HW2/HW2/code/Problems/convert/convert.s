.global convert
.type matrix_mul, %function

.align 2
# int convert(char *);
convert:
    add t5, zero, 0
    add t6, zero, 9
    add t2, zero, 0
    add t3, zero, 1
    add t0, a0, 0
    li s0, 10
L1:
    lb t1, (t0)
    blt t1, t5, Error
    bgt t1, t6, Error
    mul t1, t1, t3
    add t2, t2, t1
    add t0, t0, 1
    mul t3, t3, s0
    bne t1, zero, L1
    add a0, t1, 0
    ret

Error:
    add a0, zero, -1
	ret
    # insert your code here
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
   

