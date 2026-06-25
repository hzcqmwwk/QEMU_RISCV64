#include "os.h"

void os_main()
{
    printf("hello kyrie os!\n");
    trap_init();
    task_init();      // 创建任务
    timer_init();     // 开启时钟中断
    run_first_task(); // 执行第一个任务
}