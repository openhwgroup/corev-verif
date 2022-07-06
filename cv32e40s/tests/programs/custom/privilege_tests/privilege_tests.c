// TODO:ropeders license header


#include <stdio.h>
#include <stdlib.h>
#include "corev_uvmt.h"


// Declaration of assert 
static void assert_or_die(uint32_t actual, uint32_t expect, char *msg) {
  if (actual != expect) {
    printf(msg);
    printf("expected = 0x%lx (%ld), got = 0x%lx (%ld)\n", expect, (int32_t)expect, actual, (int32_t)actual);
    exit(EXIT_FAILURE);
  }
}

// extern and global variable declaration
extern volatile void  setup_pmp(), change_exec_mode(int);
// extern volatile int input_mode;
unsigned int mstatus, pmp1, pmp2;


// Rewritten interrupt handler
__attribute__ ((interrupt ("machine")))
void u_sw_irq_handler(void) {
  unsigned int mepc, tmstatus;

  printf("--- entered trap handler --- \n");

  __asm__ volatile("csrrw %0, mstatus, x0" : "=r"(mstatus)); // read the mstatus register
  printf("handler mstatus: %X\n", mstatus);
  __asm__ volatile("csrrw %0, mepc, x0" : "=r"(mepc)); // read the mepc

  
  mepc += 4;
  __asm__ volatile("csrrw x0, mepc, %0" :: "r"(mepc)); // write to the mepc 

  tmstatus = 0x1800;
  __asm__ volatile("csrrs x0, mstatus, %0" :: "r"(tmstatus)); // set machine mode 
}


//First priviledge test
void privilege_test(void){
  int input_mode = 0;
  // Todo:
  /* 
    - make the change_exec_mode function take arguments.
    - create to for loop to check all the different supported modes.
   */

  for (int i = 0; i <= 3; i++){
  input_mode = i << 11;
  printf("input to the test is: %x\n", input_mode);
  change_exec_mode(input_mode);
  assert_or_die(mstatus, 0, "error: core did not enter privilege mode as expected\n");
  }
}




int main(void){
  //setup_pmp();
  //TODO:
  /* 
    - setup for multifunction. maybe have variables for each test and check if any return wrong value (1?)
  
   */
  privilege_test();



  return EXIT_SUCCESS;
}