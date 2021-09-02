#ifndef CEF_LIBCEF_DLL_SWCEF_EXTERNS_H_
#define CEF_LIBCEF_DLL_SWCEF_EXTERNS_H_
#pragma once

#include <windows.h>

// https://magpcss.org/ceforum/viewtopic.php?f=6&t=14779

#ifdef DYNAMIC_CEF
void initializeCEFFunctions(HMODULE cefModule);
#endif // #ifdef DYNAMIC_CEF

#endif
