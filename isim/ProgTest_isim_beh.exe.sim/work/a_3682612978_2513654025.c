/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/Zhou Yizhou/Desktop/CG3207/lab3/SignExtender.vhd";



static void work_a_3682612978_2513654025_p_0(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    unsigned int t4;
    unsigned int t5;
    unsigned int t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    int t12;
    unsigned char t13;
    char *t14;
    char *t15;

LAB0:    xsi_set_current_line(43, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t3 = (16 - 1);
    t4 = (15 - t3);
    t5 = (t4 * 1U);
    t6 = (0 + t5);
    t1 = (t2 + t6);
    t7 = (t0 + 2872);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 16U);
    xsi_driver_first_trans_delta(t7, 16U, 16U, 0LL);
    xsi_set_current_line(44, ng0);
    t1 = xsi_get_transient_memory(16U);
    memset(t1, 0, 16U);
    t2 = t1;
    t7 = (t0 + 1032U);
    t8 = *((char **)t7);
    t3 = (16 - 1);
    t12 = (t3 - 15);
    t4 = (t12 * -1);
    t5 = (1U * t4);
    t6 = (0 + t5);
    t7 = (t8 + t6);
    t13 = *((unsigned char *)t7);
    memset(t2, t13, 16U);
    t9 = (t0 + 2872);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    t14 = (t11 + 56U);
    t15 = *((char **)t14);
    memcpy(t15, t1, 16U);
    xsi_driver_first_trans_delta(t9, 0U, 16U, 0LL);
    t1 = (t0 + 2792);
    *((int *)t1) = 1;

LAB1:    return;
}


extern void work_a_3682612978_2513654025_init()
{
	static char *pe[] = {(void *)work_a_3682612978_2513654025_p_0};
	xsi_register_didat("work_a_3682612978_2513654025", "isim/ProgTest_isim_beh.exe.sim/work/a_3682612978_2513654025.didat");
	xsi_register_executes(pe);
}
