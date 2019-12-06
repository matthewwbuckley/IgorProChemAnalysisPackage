// main.ipf
//
// This file is the entry point for the modules written in 
// this package. It defines a menu, which allows modules to
// to be loaded. Those loaded modules should themselves create
// a new menu.
//
// This file should be copied to the `Igor Procedures` folder.
// See the README for more details.

#pragma rtGlobals=1		// Use modern global access method.

// Different packages should be included here
// Due to IgorPro having strange reltaive folder navigation
// all files should follow the scehem: <Namespace>_filename
// Current namespaces: CAP, PARXPS.
#include "PARXPS_include"

Menu "Chem Analysis Package"
  "PARXPS", PARXPS_CreateWindow()
  "More Information"
End
