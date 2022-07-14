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
extern volatile void  setup_pmp(), change_exec_mode(int), set_csr_loop(), set_u_mode();
unsigned int mstatus, mscratchg;


//control variables for the status handler
int thand, excc;



// Rewritten interrupt handler
__attribute__ ((interrupt ("machine")))
void u_sw_irq_handler(void) {
  unsigned int mepc, tmstatus;
  //printf("entered trap handler\n");

  if (thand == 4) { // dummy mode to set the core into macine mode. 
  tmstatus = 0x1800;

  __asm__ volatile("csrrs x0, mstatus, %0" :: "r"(tmstatus)); // set machine mode 

  __asm__ volatile("csrrw %0, mepc, x0" : "=r"(mepc)); // read the mepc
  mepc += 4;

  __asm__ volatile("csrrw x0, mepc, %0" :: "r"(mepc)); // write to the mepc 
  }

  if (thand == 2) {// mscratch_reliable_check()
  __asm__ volatile("csrrw %0, mscratch, x0" : "=r"(mscratchg));

  __asm__ volatile("csrrw %0, mepc, x0" : "=r"(mepc)); // read the mepc
  mepc += 4;

  __asm__ volatile("csrrw x0, mepc, %0" :: "r"(mepc)); // write to the mepc 

  tmstatus = 0x1800;

  __asm__ volatile("csrrs x0, mstatus, %0" :: "r"(tmstatus)); // set machine mode 
  }


  if (thand == 0) { // This is the privilege_test behavior
    __asm__ volatile("csrrw %0, mstatus, x0" : "=r"(mstatus)); // read the mstatus register
 
    __asm__ volatile("csrrw %0, mepc, x0" : "=r"(mepc)); // read the mepc

    
    mepc += 4;

    __asm__ volatile("csrrw x0, mepc, %0" :: "r"(mepc)); // write to the mepc 

    tmstatus = 0x1800;

    __asm__ volatile("csrrs x0, mstatus, %0" :: "r"(tmstatus)); // set machine mode 
  }


  if (thand == 1) {// This is csr_privilege_loop behaviour
    __asm__ volatile("csrrw %0, mepc, x0" : "=r"(mepc)); // read the mepc

    mepc += 4;

    __asm__ volatile("csrrw x0, mepc, %0" :: "r"(mepc)); // write to the mepc 

    excc++;
  }


}


void set_m_mode(void) {
// Changes the handler functionality, and then calls an exception.
thand = 4;
__asm__ volatile("ecall");
}



//First priviledge test
void privilege_test(void){
  int input_mode = 0;
  unsigned int mmask;

  for (int i = 0; i <= 3; i++){
    input_mode = i << 11;
    // printf("input to the test is: %x\n", input_mode);
    change_exec_mode(input_mode);
    mmask = (mstatus & 3 << 11); // mask to get just the MPP field.
    if (i == 3) {
        assert_or_die(mmask, 0x1800, "error: core did not enter privilege mode as expected\n");
        }else {
        assert_or_die(mmask, 0x0, "error: core did not enter privilege mode as expected\n");
      };
  };
  printf("privilege_test exited succesfully\n");
}

void reset_mode(void){
/* 
To satisfy the testing criteria this test must run first
this is to ensure 'Ensure that M-mode is the first mode entered after reset.
*/
__asm__ volatile("csrrw %0, mstatus, x0" : "=r"(mstatus)); // read the mstatus register
assert_or_die(mstatus, 0x1800, "error: core did not enter M-mode after reset\n");
printf("reset_mode test exited succesfully\n");
}


void csr_privilege_loop(void){
/* 
Try all kinds of accesses (R, W, RW, S, C, …) to all M-level CSRs while in U-level;
ensure illegal instruction exception happens.
*/

  // see the gen_loop.py file for which registers are included in the test
  thand = 1; // set u_sw_irq_handler to correct behaviour
  excc = 0; // set interrupt counter to 0
  setup_pmp();
  set_csr_loop();
  assert_or_die(excc, 12288, "Some tests seem to not have triggered the exception handler!\n");
}


void misa_check(void) {
 /* 
  Read misa and see that "U" is always on
  Read misa and see that "N" is always off.
  */
  set_m_mode();
  unsigned int misa, user, reserved;
  __asm__ volatile("csrrw %0, misa, x0" : "=r"(misa));
  user = (misa & 1 << 20) >> 20;
  reserved = (misa & 1 << 13) >> 13;
  assert_or_die(user, 1, "error: User-mode not set in the misa register\n");
  assert_or_die(reserved, 0, "error: N-bit set in the misa register\n");
  printf("misa_check test exited succesfully\n");
}

void mstatus_implement_check(void){
  /* 
  F-extension, S-mode are not supported on the platform, FS and XS should therefore be 0, and if both of those are 0 then the SD field should also be 0.
  */
  unsigned int mstatus, XS, FS, SD;
  __asm__ volatile("csrrw %0, mstatus, x0" : "=r"(mstatus));
  XS = (mstatus & 3 << 15);// >> 15;
  FS = (mstatus & 3 << 13);// >> 13;
  SD = (mstatus & 1 << 31);// >> 31;
  //printf("%08X\n", mstatus);
  assert_or_die(XS, 0x0, "error: XS set in the mstatus register\n");
  assert_or_die(FS, 0x0, "error: FS set in the mstatus register\n");
  assert_or_die(SD, 0, "error: SD set in the mstatus register\n");
  printf("mstatus_implement_check test exited succesfully\n");


}

void mscratch_reliable_check(void){
  /* 
  Check that mscratch never changes in U-mode.
  change to u-mode, attempt to write to mscratch, trap and assert that mscratch is the same.
  */
  thand = 2; // set the exception handler behavior.
  unsigned int mscratch, uwrite;
  uwrite = 0x1800;


  __asm__ volatile("csrrw %0, mscratch, x0" : "=r"(mscratch));
  setup_pmp();
  set_u_mode();
  __asm__ volatile("csrrw x0, mscratch, %0" :: "r"(uwrite)); // write to the mscratch (in user mode)
  assert_or_die(mscratch, mscratchg, "error: mscratch register changed after attempted user mode read\n");
}

int main(void){
  //TODO:
  /* 

  
   */

  reset_mode();
  privilege_test();
  csr_privilege_loop(); // this test takes 5-6 minutes (+40 minutes with IRFCV-trace ON)
  misa_check();
  mstatus_implement_check();
  mscratch_reliable_check();
  




  return EXIT_SUCCESS;
}