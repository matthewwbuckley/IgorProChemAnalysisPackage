Function PARXPS_Load(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
		  String pathName = OpenFileDialog()
      
      if(strlen(pathName) == 0)
        return -1
      endif

      PARXPS_LoadWavesFromFile(pathName)
			break
	endswitch

	return 0
END

// This function will display an open file dialog to the user
// and returns a string with its position
Static Function/S OpenFileDialog()
  Variable refNum
  String message = "Select a file"
  String outputPath
  String fileFilters = "Data Files (*.txt,*.dat,*.csv):.txt,.dat,.csv;"
  fileFilters += "All Files:.*;"
  Open /D /R /F=fileFilters /M=message refNum
  outputPath = S_fileName
  return outputPath // Will be empty if user canceled
End

Function PARXPS_Testing(pathName)
  String pathName
  LoadWave pathName
END

Function PARXPS_LoadWavesFromFile(pathName)
String pathName
variable i, j, jmax,k
String NullString=""
String NullList="-1"
string ScanWaveString=""
string OldScanWaveString="StartValue"
jmax=1
j=1
for(i=0; i<100; i+=1)
	LoadWave/A=ScanWaveName/J/D/K=2/L={0,0,1,i,1} pathName
	wave/T ScanWaveName0
	ScanWaveString=ScanWaveName0[0]
	killwaves ScanWaveName0

	if(stringmatch(ScanWaveString, NullString)==1 && Stringmatch(ScanWaveString, OldScanWaveString)==0)
		NullList[(strlen(NullList)),(strlen(NullList))]=","+num2str(i)
		jmax+=1
	endif

	OldScanWaveString=ScanWaveString
endfor

END



