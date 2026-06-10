#ifndef __TYPES_H__
#define __TYPES_H__

// 定义无符号整型
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int  uint32_t;
typedef unsigned long long uint64_t;

// RISCV64寄存器的大小是64位的，用typedef定义一个reg_t的类型用于定义使用的寄存器
typedef uint64_t reg_t;

#define EOF -1  
#define NULL ((void *)0)
#define EOS '\0'

#endif