.global _start

_start:
    nop
    nop

    li x1, 10000
    li x2, 134217728
    li x3, 858993458  
    li x4, -32769
    li x5, -2049
    li x6, -46083
    li x17, 64

    la t3, begin_sig
    
    # test 1

    mulh x15,x1,x2
    sw x15, 0(t3)
  
    # test2
    mulh x15,x3,x3
    sw x15, 4(t3)

    # test 3

    mulh x15,x4,x5
    sw x7, 8(t3)

    # test 4

    mulh x15, x6, x7
    sw x15, 12(t3)
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




    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


