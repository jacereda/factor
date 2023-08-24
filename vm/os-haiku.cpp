#include "master.hpp"
#include <image.h>

namespace factor {

static char executable_path[MAXPATHLEN];

extern "C" void
initialize_before(image_id our_image)
{
  image_info ii;
  get_image_info(our_image, &ii);
  snprintf(executable_path, sizeof(executable_path), "%s", ii.name);
}

const char* vm_executable_path() {
  return strdup(executable_path);
}

}
