#pragma rtGlobals=1		// Use modern global access method.
#include "PARXPS_LoadData"

Function PARXPS_CreateWindow()
  // Create a new central panel
  NewPanel /N=PARXPS_ANALYSIS_WINDOW /W=(20, 80, 220, 400)

  // Try to use a padding of 10px
  // For some reason widths do not make sense horizontally
  // window seems 20px smaller than inner elements suggest

  // Add controls to panel

  // Load Button Creation
  Button LoadButton title="\\f01Load Waves From File";DelayUpdate
  Button LoadButton pos={10,10},size={180,40};DelayUpdate
  Button LoadButton fColor=(0,43520,65280);DelayUpdate
  Button LoadButton valueColor=(13056,13056,13056);DelayUpdate
  Button LoadButton proc=PARXPS_Load;
END



