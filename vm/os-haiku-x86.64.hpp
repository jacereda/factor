#include <signal.h>

namespace factor {

inline static unsigned int uap_fpu_status(void* uap) {
  ucontext_t* ucontext = (ucontext_t*)uap;
  return ucontext->uc_mcontext.fpu.fp_fxsave.status
      | ucontext->uc_mcontext.fpu.fp_fxsave.mxcsr;
}

inline static void uap_clear_fpu_status(void* uap) {
  ucontext_t* ucontext = (ucontext_t*)uap;
  ucontext->uc_mcontext.fpu.fp_fxsave.status = 0;
  ucontext->uc_mcontext.fpu.fp_fxsave.mxcsr &= 0xffffffc0;
}

#define UAP_STACK_POINTER(ucontext) \
  (((ucontext_t*)ucontext)->uc_mcontext.rsp)
#define UAP_PROGRAM_COUNTER(ucontext) \
  (((ucontext_t*)ucontext)->uc_mcontext.rip)

// Must match the stack-frame-size constant in
// bootstrap/assembler/x86.64.unix.factor
static const unsigned JIT_FRAME_SIZE = 32;

}
