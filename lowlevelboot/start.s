	.macro loop, cunt          // 定义一个简单loop宏，cunt是loop参数
    li    t1, 0xffff           // li是伪指令，加载立即数0xffff到t1
    li    t2, \cunt
1:
    nop                        // 空指令nop
    addi    t1, t1, -1
    bne     t1, x0, 1b         // 判断t1是否等于0，不是就向前跳转最近的符号1处（b是向前的意思）
    li      t1, 0xffff
    addi    t2, t2, -1
    bne     t2, x0, 1b
    .endm                      // loop宏结束

    .macro load_data,_src_start,_dst_start,_dst_end // 定义一个简单load_data宏 _src_start为源地址，_dst_start为目标地址，_dst_end为目标结束地址
    bgeu    \_dst_start, \_dst_end, 2f              // 判断目标结束地址大于起始地址，即是否合法
1:
    lw      t0, (\_src_start)            // 加载源地址内32位的数据到t0
    sw      t0, (\_dst_start)            // 写入t0到目标地址开始的32位长度
    addi    \_src_start, \_src_start, 4  // 源地址+4
    addi    \_dst_start, \_dst_start, 4  // 目标地址+4
    bltu    \_dst_start, \_dst_end, 1b   // 判断是否已到达结束地址，未到达则循环到上前一个符号1
2:
    .endm

    .section .text                 // 定义数据段名为.text
    .globl _start                  // 定义全局符号_start
    .type _start,@function         // _start为函数

_start:                            // 函数入口
    //load opensbi_fw.bin  [0x20200000:0x20400000] --> [0x80000000:0x80200000]
    li           a0, 0x202
    slli         a0, a0, 20        // a0左移20位，a0 = 0x20200000
    li           a1, 0x800
    slli         a1, a1, 20        // a1 = 0x80000000
    li           a2, 0x802
    slli         a2, a2, 20        // a2 = 0x80200000
    load_data    a0, a1, a2        // 拷贝 0x20200000 到 0x80000000

    //load qemu_sbi.dtb    [0x20080000:0x20100000] --> [0x82200000:0x82280000]
    li           a0, 0x2008
    slli         a0, a0, 16        // a0 = 0x20080000
    li           a1, 0x822
    slli         a1, a1, 20        // a1 = 0x82200000
    li           a2, 0x8228
    slli         a2, a2, 16        // a2 = 0x82280000
    load_data    a0, a1, a2        // 拷贝 0x20080000 到 0x82200000

    //load trusted_fw.bin  [0x20400000:0x20800000] --> [0x80200000:0x80600000]
    li           a0, 0x204
    slli         a0, a0, 20        //a0 = 0x20400000
    li           a1, 0xb00
    slli         a1, a1, 20        //a1 = 0xb0000000
    li           a2, 0xb04
    slli         a2, a2, 20        //a2 = 0xb0400000
    load_data    a0, a1, a2

    csrr         a0, mhartid       // csr是riscv专有的内核私有寄存器，独立编地在12位地址，mhartid寄存器定义了内核的hartid，这里读取到a0寄存器里
    li           t0, 0x0     
    beq          a0, t0, _no_wait  // 比较a0和t0,相等则跳转到_no_wait地址处，否则向下执行，即非core0就loop 1000后再启动，让core0作为OpenSBI的冷启动引导核心
    loop         0x1000
_no_wait:
    li           a1, 0x822
    slli         a1, a1, 20        // a1 = 0x82200000
    li           t0, 0x800
    slli         t0, t0, 20        // t0 = 0x80000000
    jr           t0                // 此时a0中为core的hart id，a1中设备树dtb的所在的起始地址，t0为opensbi程序所在的ddr地址，jr跳转进入opensbi程序*/

    .end                           // 汇编文件结束符号