.global _start

_start:
    nop
    nop

    la t3, begin_sig

    # inst_0
    li x15, 0xb504
    li x21, 0x8000000
    mulh x15,x15,x21
    sw x15, 0(t3)

    # inst_1
    li x1, 0x33333332
    mulh x7,x1,x1
    sw x7, 4(t3)

    # inst_2
    li x7, -0x8001
    li x6, -0x801
    mulh x6,x7,x6
    sw x6, 8(t3)

    # inst_3
    li x27, -0xb503
    li x16, 0x40
    mulh x5, x27, x16
    sw x5, 12(t3)

    # inst_4
    li x26, 0x7
    mulh x26,x26,x26
    sw x26, 16(t3)

    # inst_5
    li x24, -0xb503
    li x7, -0x80000000
    mulh x10, x24, x7
    sw x10, 20(t3)

    j exit

begin_sig:
    .fill 6, 4, 0xcafebeef
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
