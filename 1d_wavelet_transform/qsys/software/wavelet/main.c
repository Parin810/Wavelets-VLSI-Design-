/*
 * main.c
 *
 *  Created on: Apr 28, 2017
 *      Author: parin
 */


#include "sys/alt_stdio.h"
#include "system.h"
#include "io.h"
#include <stdio.h>
#include <stdint.h>

void main()
{
  alt_putstr ("Hello from Nios II!\n");

  alt_putstr ("3. Waiting for status ok :\n");
  for (unsigned int i = 0; i < 8; i++) {
      unsigned int status = IORD (WAVELET_0_BASE ,1);
      printf ("   attempt %u, status = %u\n", i, status);
      if (0 != status) {
          break;
      }
  }
  // while (0 != IORD (QSYS_FILTER_COMPONENT_0_BASE, 1));

  alt_putstr ("4. Printing output values :\n");
  for (unsigned int i = 1; i < 9; i++) {
      unsigned int res = IORD (WAVELET_0_BASE , i);
      printf ("ch = %d",(char)(res));
      printf (",ca = %d\n", (char)(res >> 8));
      //printf("\n%x",unsigned char(uint8_t(res)));
  }

  /* Event loop never exits. */
  while (1);

  //return 0;
}


