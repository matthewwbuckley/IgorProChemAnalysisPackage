Function NewOpenFile()
variable i, j, jmax,k
String NullString=""
String NullList="-1"
string ScanWaveString=""
string OldScanWaveString="StartValue"
jmax=1
j=1


string PathName =""
PathName = DoOpenFileDialog()

if(stringmatch(PathName,"")==1)
return -1
endif

// THIS FOR LOOP FINDS THE POSITIONS OF THE NULL COLUMNS WHICH WILL BE USED TO GET POSITIONS OF THE DATA
// i CAN BE CHANGED IF THERE ARE >100 COLUMNS BEING USED

for(i=0; i<100; i+=1)
	LoadWave/A=ScanWaveName/J/D/K=2/L={0,0,1,i,1} pathname
	wave/T ScanWaveName0
	ScanWaveString=ScanWaveName0[0]
	killwaves ScanWaveName0

	if(stringmatch(ScanWaveString, NullString)==1 && Stringmatch(ScanWaveString, OldScanWaveString)==0)
		NullList[(strlen(NullList)),(strlen(NullList))]=","+num2str(i)
		jmax+=1
	endif

	OldScanWaveString=ScanWaveString
endfor

// THIS IS THE START OF A NUMBER OF LOOPS WHICH WILL MOVE FROM  ONE SET OF DATA TO THE NEXT AND THEN FROM ONE COLUMN TO THE NEXT
// IT WILL GET BOTH THE NAME OF THE DATA AND THE DATA ITSELF

for(j=1; j<jmax; j+=1)

	//HERE I AM GETTING THE INFORMATION ABOUT THE CURRENT SET OF DATA (CURRENT SET OF DATA SPECIFIED BY j )
	
	variable ColumnNumber
	variable NumberOfColumns
	ColumnNumber=(str2num(stringfromlist((j-1),NullList,","))+1)
	NumberOfColumns=(str2num(stringfromlist((j),NullList,","))-str2num(stringfromlist((j-1),NullList,","))-1)

	//GET NAME OF DATA SET AND PUT IT IN A NICE FORMAT
	
	LoadWave/A=ScanWaveName2/J/D/K=2/L={0,0,1,(ColumnNumber+1),1} pathname
	string CPSName=""
	wave/T ScanWaveName20
	CPSName=ScanWaveName20[0]
	variable LengthOfName=strlen(CPSName)
	string SpecialScanName=CPSName[0,(LengthOfName-4)]
	killwaves ScanWaveName20
	
	
	
	//HERE THERE IS A LIST OF NAMES BEING CREATED WITH THE NAME OF THE DATA SET PRECEEDING THE COLUMN NAME
		
	String ListOfWaves=""

	for(k=ColumnNumber; k<(ColumnNumber+NumberOfColumns); k+=1)
		LoadWave/A=ScanWaveName3/J/D/K=2/L={0,0,1,k,1} pathname
		string ScanName=""
		wave/T ScanWaveName30
		ScanName=ScanWaveName30[0]
		killwaves ScanWaveName30
		
		// NOT SURE IF THIS DOES WORK, SUPPOSED TO PREVENT DUPLICATING SET NAME IF ALREADY PRESENT
		if(stringmatch(ScanName, SpecialScanName+"*")==0)
			ScanName=SpecialScanName+ScanName
		endif
		
		ScanName=replacestring(":", ScanName, "_")
		ScanName=replacestring("/", ScanName, "")
		String ScanNameZero=ScanName+"0"
		
		LoadWave/A=$ScanName/J/D/V={"\t"," $",0,1}/K=0/L={0,1,0,k,1} pathname
		rename $ScanNameZero $ScanName
		
		ListOfWaves[(strlen(ListOfWaves)),(strlen(ListOfWaves))]=ScanName+","
		endfor
		
		// HERE WE ARE STARTING TO USE THE WAVES IN THE CURRENT SET
		
		
		
		// HERE I AM TELLING IGOR THAT A WAVE EXISTS WITH THE NAME IN THE NAME LISTS FOR;
		// THE CPS AND THE BE
		// THIS IS A COMMON THING AND I WILL DO THIS FOR ALL WAVES WHICH WE USE
		String BEInList=stringfromlist(0, ListOfWaves, ",")
		String CPSInList=stringfromlist(1, ListOfWaves, ",")
		wave wBE=$BEInList
		wave wCPS=$CPSInList
		
		//CREATE A GRAPH OF CPS VS BE FOR THE CURRENT SET
		//ALL WAVES IN THIS SET WILL BE ADDED TO THIS GRAPH (NOT THE BACKGROUND)
		
		Display wCPS vs wBE
		Label left " \\Z20\\F'Tahoma'S / \\u \\Z20\\F'Tahoma'Counts s\\S-1";DelayUpdate
		Label bottom "\\F'Tahoma'\\Z20Binding Energy / eV"
		ModifyGraph font="Tahoma"
		ModifyGraph fSize=20
		ModifyGraph axThick=2
		ModifyGraph height=283.465
		ModifyGraph width=425.197
		ModifyGraph margin(left)=85
		ModifyGraph mode($CPSInList)=0,lsize($CPSInList)=2,rgb($CPSInList)=(0,0,0)	
		SetAxis/A/R bottom

			
		// IF THERE ARE >2 COLUMNS THEN THE DATA HAS BEEN FITTED WITH COMPONENTS AND WILL HAVE
		// AN ENVELOPE AND A BACKGROUND AS THE LAST TWO WAVES WITH THE COMPONENTS IN THE MIDDLE
		
		
		if(NumberOfColumns>2)
		
			// SINCE I KNOW WHERE THE ENVELOPE AND BACKGROUND ARE I CAN EASILY TELL IGOR THEY ARE A WAVE
			//WHICH I DO HERE
			String EnvelopeInList=stringfromlist((NumberOfColumns-1), ListOfWaves, ",")
			String BackgroundInList=stringfromlist((NumberOfColumns-2), ListOfWaves, ",")
			wave wEnvelope=$EnvelopeInList
			wave wBackground=$BackgroundInList
			
			// BACKGROUND SUBTRACTION
			wCPS-=wBackground
			wEnvelope-=wBackground
			
			
			// I THEN ADD THEN TO THE GRAPH
			appendtograph wEnvelope vs wBE
			ModifyGraph lsize($EnvelopeInList)=2,rgb($EnvelopeInList)=(65280,0,0)	
			
			
			// HERE I AM DEALING WITH A NUMBER OF COMPONENTS WHICH WILL BE THE NUMBER OF COLUMNS - 4	
			variable l=0
			for(l=0; l<(NumberOfColumns-4); l+=1)
				
				// I HAVE TO DEAL WITH THE COMPONENTS ONE AT A TIME
				// I AM TELLING IGOR THAT THEY ARE WAVES
				String NameOfComponent=stringfromlist(l+2, ListOfWaves, ",")
				wave wl=$nameofcomponent
				
				// I AM SUBTRACTING THE BACKGROUND
				wl-=wBackground
				//APPENDING IT TO THE GRAPH
				appendtograph wl vs wBE
				
				// COLOUR THE COMPONENTS BASED ON A COLOUR CHART WHICH SPECIFIES THE RGB
				wave ColourChart
				ModifyGraph lsize($NameOfComponent)=2,rgb($NameOfComponent)=(Colourchart[l][0],colourchart[l][1],colourchart[l][2])
				
			endfor
		endif
		// ADD A LEGEND TO THE GRAPH
		Legend/C/N=text0/F=0/A=MC
		
endfor
end