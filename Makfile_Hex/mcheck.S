.global _start

_start:
    nop
    nop

    li t1, 0x2
    li t2, 0x4
    la t3, begin_sig
    
    mul t4, t1,t2
    sw t4, 0(t3)
    
    mulh t4, t1,t2
    sw t4, 4(t3)
    
    mulhsu t4, t1,t2
    sw t4, 8(t3)
    
    mulhu t4, t1,t2
    sw t4, 12(t3)
    
    j exit

begin_sig:
    .fill 4, 4, 0xcafebeef
end_sig:
exit:
    li a1,0x00000f00
    la a2,begin_sig
    la a3,end_sig
    
    loop:
    lw t1,0(a2)
    sw t1,0(a1)
    addi a2,a2,4
    blt a2, a3, loop
    
la a4,0xcafebeef
sw t5,0(a4)


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


