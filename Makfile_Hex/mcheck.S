.global _start

_start:
    nop
    nop

    li x1, -50              # x1 = 5 (signed)
    li x2, 60             # x2 = -6 (signed)
    li x3, -104          # x3 = 65536 (unsigned)
    li x4, 34         # x4 = 65537 (unsigned)

    la t3, begin_sig
    
    # Perform MUL (Signed Multiplication)
    mul x5, x1, x2        # x5 = x1 * x2 = 5 * (-6) = -30
    sw x5, 0(t3)
    # Perform MULH (Signed Multiplication, upper 32 bits)
    mulh x6, x1, x2       # x6 = high(x1 * x2) = high(5 * (-6)) = 0
    sw x6, 4(t3)
    # Perform MULHSU (Signed-Unsigned Multiplication, upper 32 bits)
    mulhsu x7, x1, x3     # x7 = high(x1 * x3) = high(5 * 65536) = 5
    sw x7, 8(t3)
    # Perform MULHU (Unsigned Multiplication, upper 32 bits)
    mulhu x8, x3, x4      # x8 = high(x3 * x4) = high(65536 * 65537) = 1
    sw x8, 12(t3)
    
    
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




    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


