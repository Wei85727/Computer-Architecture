.global fibonacci
.type fibonacci, %function

.align 2
# unsigned long long int fibonacci(int n);
fibonacci:  
    
    # insert code here
	add t3, zero, 2
    blt a0, t3, L2
    add t2, a0, 0
    add t0, zero, 0
    add t1, zero, 1
L0: add a0, t0, t1
    add t0, t1, 0
    add t1, a0, 0
    add t2, t2, -1
    bge t2, t3, L0
L2: ret
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    
