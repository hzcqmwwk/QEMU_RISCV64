#ifndef __OS_H__
#define __OS_H__

#include <stddef.h>
#include <stdarg.h>
#include "types.h"
#include "context.h"
#include "riscv.h"
#include "task.h"

/* printf.c */
extern int  printf(const char* s, ...);
extern void panic(char *s);
extern void sbi_console_putchar(int ch);

/* string.c */
extern size_t strlen(const char *str);

/* app.c */
extern void task_init();

/* trap.c */
extern void trap_init();

/* kerneltrap.S*/
extern void __alltraps(void);
extern void __restore(TrapContext *next);

/*syscall*/
void __SYSCALL(size_t syscall_id, reg_t arg1, reg_t arg2, reg_t arg3);
#define __NR_write 64
#define __NR_sched_yield 124

/* switch.S */
extern void __switch(TaskContext *current_task_cx_ptr,TaskContext* next_task_cx_ptr );

/* task.c */
extern void schedule();
extern void task_create(void (*task_entry)(void));
extern void run_first_task();

#endif