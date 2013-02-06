//	DataPro//	DAC/ADC macros for use with Igor Pro and the ITC-16 or ITC-18//	Nelson Spruston//	Northwestern University//	project began 10/27/1998#pragma rtGlobals=1		// Use modern global access method.Function CreateDigitizerControlPanel() : Panel	String savDF=GetDataFolder(1)	SetDataFolder root:DP_DigitizerControl	NewPanel /W=(176,570,176+(872-176+24+16+16),570+256) /N=DigitizerControl /K=1 as "Digitizer Control Panel"	ModifyPanel /W=DigitizerControl fixedSize=1		//	// ADC channel area	// 		// ADC checkboxes	WAVE adcon	CheckBox ADC0Checkbox,pos={10,12},size={44,14},proc=HandleADCCheckbox,title="ADC0"	CheckBox ADC0Checkbox,value= adcon[0]	CheckBox ADC1Checkbox,pos={10,43},size={44,14},proc=HandleADCCheckbox,title="ADC1"	CheckBox ADC1Checkbox,value= adcon[1]	CheckBox ADC2Checkbox,pos={10,74},size={44,14},proc=HandleADCCheckbox,title="ADC2"	CheckBox ADC2Checkbox,value= adcon[2]	CheckBox ADC3Checkbox,pos={10,105},size={44,14},proc=HandleADCCheckbox,title="ADC3"	CheckBox ADC3Checkbox,value= adcon[3]	CheckBox ADC4Checkbox,pos={10,136},size={44,14},proc=HandleADCCheckbox,title="ADC4"	CheckBox ADC4Checkbox,value= adcon[4]	CheckBox ADC5Checkbox,pos={10,167},size={44,14},proc=HandleADCCheckbox,title="ADC5"	CheckBox ADC5Checkbox,value= adcon[5]	CheckBox ADC6Checkbox,pos={10,198},size={44,14},proc=HandleADCCheckbox,title="ADC6"	CheckBox ADC6Checkbox,value= adcon[6]	CheckBox ADC7Checkbox,pos={10,229},size={44,14},proc=HandleADCCheckbox,title="ADC7"	CheckBox ADC7Checkbox,value= adcon[7]	// ADC channel base names	WAVE /T adcBaseName	SetVariable adc0BaseNameSetVariable,pos={62,12-1},size={70+5,15},proc=HandleADCBaseNameSetVariable,title="name"	SetVariable adc0BaseNameSetVariable,value= _STR:adcBaseName[0]	SetVariable adc1BaseNameSetVariable,pos={62,43-1},size={70+5,15},proc=HandleADCBaseNameSetVariable,title="name"	SetVariable adc1BaseNameSetVariable,value= _STR:adcBaseName[1]	SetVariable adc2BaseNameSetVariable,pos={62,74-1},size={70+5,15},proc=HandleADCBaseNameSetVariable,title="name"	SetVariable adc2BaseNameSetVariable,value= _STR:adcBaseName[2]	SetVariable adc3BaseNameSetVariable,pos={62,105-1},size={70+5,15},proc=HandleADCBaseNameSetVariable,title="name"	SetVariable adc3BaseNameSetVariable,value= _STR:adcBaseName[3]	SetVariable adc4BaseNameSetVariable,pos={62,136-1},size={70+5,15},proc=HandleADCBaseNameSetVariable,title="name"	SetVariable adc4BaseNameSetVariable,value= _STR:adcBaseName[4]	SetVariable adc5BaseNameSetVariable,pos={62,167-1},size={70+5,15},proc=HandleADCBaseNameSetVariable,title="name"	SetVariable adc5BaseNameSetVariable,value= _STR:adcBaseName[5]	SetVariable adc6BaseNameSetVariable,pos={62,198-1},size={70+5,15},proc=HandleADCBaseNameSetVariable,title="name"	SetVariable adc6BaseNameSetVariable,value= _STR:adcBaseName[6]	SetVariable adc7BaseNameSetVariable,pos={62,229-1},size={70+5,15},proc=HandleADCBaseNameSetVariable,title="name"	SetVariable adc7BaseNameSetVariable,value= _STR:adcBaseName[7]	// Channel type list boxes	WAVE adcType	PopupMenu ADCChannelModePopupMenu0,pos={62+80+5,12-3}	PopupMenu ADCChannelModePopupMenu0,mode=adcType[0],value= #"\"Current;Voltage\""	PopupMenu ADCChannelModePopupMenu0, proc=HandleADCChannelModePopupMenu	PopupMenu ADCChannelModePopupMenu1,pos={62+80+5,43-3}	PopupMenu ADCChannelModePopupMenu1,mode=adcType[1],value= #"\"Current;Voltage\""	PopupMenu ADCChannelModePopupMenu1, proc=HandleADCChannelModePopupMenu	PopupMenu ADCChannelModePopupMenu2,pos={62+80+5,74-3}	PopupMenu ADCChannelModePopupMenu2,mode=adcType[2],value= #"\"Current;Voltage\""	PopupMenu ADCChannelModePopupMenu2, proc=HandleADCChannelModePopupMenu	PopupMenu ADCChannelModePopupMenu3,pos={62+80+5,105-3}	PopupMenu ADCChannelModePopupMenu3,mode=adcType[3],value= #"\"Current;Voltage\""	PopupMenu ADCChannelModePopupMenu3, proc=HandleADCChannelModePopupMenu	PopupMenu ADCChannelModePopupMenu4,pos={62+80+5,136-3}	PopupMenu ADCChannelModePopupMenu4,mode=adcType[4],value= #"\"Current;Voltage\""	PopupMenu ADCChannelModePopupMenu4, proc=HandleADCChannelModePopupMenu	PopupMenu ADCChannelModePopupMenu5,pos={62+80+5,167-3}	PopupMenu ADCChannelModePopupMenu5,mode=adcType[5],value= #"\"Current;Voltage\""	PopupMenu ADCChannelModePopupMenu5, proc=HandleADCChannelModePopupMenu	PopupMenu ADCChannelModePopupMenu6,pos={62+80+5,198-3}	PopupMenu ADCChannelModePopupMenu6,mode=adcType[6],value= #"\"Current;Voltage\""	PopupMenu ADCChannelModePopupMenu6, proc=HandleADCChannelModePopupMenu	PopupMenu ADCChannelModePopupMenu7,pos={62+80+5,229-3}	PopupMenu ADCChannelModePopupMenu7,mode=adcType[7],value= #"\"Current;Voltage\""	PopupMenu ADCChannelModePopupMenu7, proc=HandleADCChannelModePopupMenu	// ADC gain setvars	WAVE adcgain	SetVariable adcGain0SetVariable,pos={110+20+10+80,12},size={70,15},proc=HandleADCGainSetVariable,title="gain"	SetVariable adcGain0SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:adcgain[0]	SetVariable adcGain1SetVariable,pos={110+20+10+80,43},size={70,15},proc=HandleADCGainSetVariable,title="gain"	SetVariable adcGain1SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:adcgain[1]	SetVariable adcGain2SetVariable,pos={110+20+10+80,74},size={70,15},proc=HandleADCGainSetVariable,title="gain"	SetVariable adcGain2SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:adcgain[2]	SetVariable adcGain3SetVariable,pos={110+20+10+80,105},size={70,15},proc=HandleADCGainSetVariable,title="gain"	SetVariable adcGain3SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:adcgain[3]	SetVariable adcGain4SetVariable,pos={110+20+10+80,136},size={70,15},proc=HandleADCGainSetVariable,title="gain"	SetVariable adcGain4SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:adcgain[4]	SetVariable adcGain5SetVariable,pos={110+20+10+80,167},size={70,15},proc=HandleADCGainSetVariable,title="gain"	SetVariable adcGain5SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:adcgain[5]	SetVariable adcGain6SetVariable,pos={110+20+10+80,198},size={70,15},proc=HandleADCGainSetVariable,title="gain"	SetVariable adcGain6SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:adcgain[6]	SetVariable adcGain7SetVariable,pos={110+20+10+80,229},size={70,15},proc=HandleADCGainSetVariable,title="gain"	SetVariable adcGain7SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:adcgain[7]	// ADC gain units	TitleBox adcGain0UnitsTitleBox,pos={110+20+10+80+74,12+0*31},frame=0,title=adcGainUnitsStringFromAdcType(adcType[0])	TitleBox adcGain1UnitsTitleBox,pos={110+20+10+80+74,12+1*31},frame=0,title=adcGainUnitsStringFromAdcType(adcType[1])	TitleBox adcGain2UnitsTitleBox,pos={110+20+10+80+74,12+2*31},frame=0,title=adcGainUnitsStringFromAdcType(adcType[2])	TitleBox adcGain3UnitsTitleBox,pos={110+20+10+80+74,12+3*31},frame=0,title=adcGainUnitsStringFromAdcType(adcType[3])	TitleBox adcGain4UnitsTitleBox,pos={110+20+10+80+74,12+4*31},frame=0,title=adcGainUnitsStringFromAdcType(adcType[4])	TitleBox adcGain5UnitsTitleBox,pos={110+20+10+80+74,12+5*31},frame=0,title=adcGainUnitsStringFromAdcType(adcType[5])	TitleBox adcGain6UnitsTitleBox,pos={110+20+10+80+74,12+6*31},frame=0,title=adcGainUnitsStringFromAdcType(adcType[6])	TitleBox adcGain7UnitsTitleBox,pos={110+20+10+80+74,12+7*31},frame=0,title=adcGainUnitsStringFromAdcType(adcType[7])	// Vertical rule	Variable xOffset=110+20+10+80+74+40	SetDrawEnv linethick= 2	DrawLine xOffset,0,xOffset,301	//	// DAC channel area	// 	// Checkboxes for turning each DAC on/off	xOffset=xOffset+10	WAVE dacon	CheckBox DAC0Checkbox,pos={xOffset,10+0*62},size={44,14},proc=HandleDACCheckbox,title="DAC0"	CheckBox DAC0Checkbox,value= dacon[0]	CheckBox DAC1Checkbox,pos={xOffset,10+1*62},size={44,14},proc=HandleDACCheckbox,title="DAC1"	CheckBox DAC1Checkbox,value= dacon[1]	CheckBox DAC2Checkbox,pos={xOffset,10+2*62},size={44,14},proc=HandleDACCheckbox,title="DAC2"	CheckBox DAC2Checkbox,value= dacon[2]	CheckBox DAC3Checkbox,pos={xOffset,10+3*62},size={44,14},proc=HandleDACCheckbox,title="DAC3"	CheckBox DAC3Checkbox,value= dacon[3]	// Popup menus for choosing the wave that gets outputted via a given DAC	String listOfDACWaveNames="_none_;"+Wavelist("*_DAC",";","")	String listOfDACWaveNamesFU="\""+listOfDACWaveNames+"\""	WAVE /T dacWavePopupSelection	PopupMenu DAC0WavePopupMenu,pos={xOffset,34+0*62},size={113,20}	PopupMenu DAC0WavePopupMenu,value=#listOfDACWaveNamesFU,popmatch=dacWavePopupSelection[0]	PopupMenu DAC0WavePopupMenu,proc=HandleDACWavePopupMenu	PopupMenu DAC1WavePopupMenu,pos={xOffset,34+1*62},size={113,20}	PopupMenu DAC1WavePopupMenu,popmatch=dacWavePopupSelection[1],value=#listOfDACWaveNamesFU	PopupMenu DAC1WavePopupMenu,proc=HandleDACWavePopupMenu	PopupMenu DAC2WavePopupMenu,pos={xOffset,34+2*62},size={113,20}	PopupMenu DAC2WavePopupMenu,popmatch=dacWavePopupSelection[2],value=#listOfDACWaveNamesFU	PopupMenu DAC2WavePopupMenu,proc=HandleDACWavePopupMenu	PopupMenu DAC3WavePopupMenu,pos={xOffset,34+3*62},size={113,20}	PopupMenu DAC3WavePopupMenu,popmatch=dacWavePopupSelection[3],value=#listOfDACWaveNamesFU	PopupMenu DAC3WavePopupMenu,proc=HandleDACWavePopupMenu	// Channel type list boxes	xOffset=xOffset+56	WAVE dacType	PopupMenu DACChannelModePopupMenu0,pos={xOffset,8+0*62}	PopupMenu DACChannelModePopupMenu0,mode=dacType[0],value= #"\"Current;Voltage\""	PopupMenu DACChannelModePopupMenu0, proc=HandleDACChannelModePopupMenu	PopupMenu DACChannelModePopupMenu1,pos={xOffset,8+1*62}	PopupMenu DACChannelModePopupMenu1,mode=dacType[1],value= #"\"Current;Voltage\""	PopupMenu DACChannelModePopupMenu1, proc=HandleDACChannelModePopupMenu	PopupMenu DACChannelModePopupMenu2,pos={xOffset,8+2*62}	PopupMenu DACChannelModePopupMenu2,mode=dacType[2],value= #"\"Current;Voltage\""	PopupMenu DACChannelModePopupMenu2, proc=HandleDACChannelModePopupMenu	PopupMenu DACChannelModePopupMenu3,pos={xOffset,8+3*62}	PopupMenu DACChannelModePopupMenu3,mode=dacType[3],value= #"\"Current;Voltage\""	PopupMenu DACChannelModePopupMenu3, proc=HandleDACChannelModePopupMenu	// DAC gain setvars	xOffset=xOffset+70	WAVE dacgain	SetVariable dacGain0SetVariable,pos={xOffset,10+0*62},size={70,15},proc=HandleDACGainSetVariable,title="gain"	SetVariable dacGain0SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:dacgain[0]	SetVariable dacGain1SetVariable,pos={xOffset,10+1*62},size={70,15},proc=HandleDACGainSetVariable,title="gain"	SetVariable dacGain1SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:dacgain[1]	SetVariable dacGain2SetVariable,pos={xOffset,10+2*62},size={70,15},proc=HandleDACGainSetVariable,title="gain"	SetVariable dacGain2SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:dacgain[2]	SetVariable dacGain3SetVariable,pos={xOffset,10+3*62},size={70,15},proc=HandleDACGainSetVariable,title="gain"	SetVariable dacGain3SetVariable,format="%g",limits={0.0001,10000,0},value= _NUM:dacgain[3]	// Multiplier applied to a wave before being outputted via a given DAC	WAVE dacMultiplier	SetVariable dacMultiplier0SetVariable,pos={xOffset,38+0*62},size={70,15},title="x ",proc=HandleDACMultiplierSetVariable	SetVariable dacMultiplier0SetVariable,limits={-10000,10000,100},value= _NUM:dacMultiplier[0]	SetVariable dacMultiplier1SetVariable,pos={xOffset,38+1*62},size={70,15},title="x ",proc=HandleDACMultiplierSetVariable	SetVariable dacMultiplier1SetVariable,limits={-10000,10000,100},value= _NUM:dacMultiplier[1]	SetVariable dacMultiplier2SetVariable,pos={xOffset,38+2*62},size={70,15},title="x ",proc=HandleDACMultiplierSetVariable	SetVariable dacMultiplier2SetVariable,limits={-10000,10000,100},value= _NUM:dacMultiplier[2]	SetVariable dacMultiplier3SetVariable,pos={xOffset,38+3*62},size={70,15},title="x ",proc=HandleDACMultiplierSetVariable	SetVariable dacMultiplier3SetVariable,limits={-10000,10000,100},value= _NUM:dacMultiplier[3]	// DAC gain units	xOffset=xOffset+74	TitleBox dacGain0UnitsTitleBox,pos={xOffset,12+0*62},frame=0,title=dacGainUnitsStringFromDacType(dacType[0])	TitleBox dacGain1UnitsTitleBox,pos={xOffset,12+1*62},frame=0,title=dacGainUnitsStringFromDacType(dacType[1])	TitleBox dacGain2UnitsTitleBox,pos={xOffset,12+2*62},frame=0,title=dacGainUnitsStringFromDacType(dacType[2])	TitleBox dacGain3UnitsTitleBox,pos={xOffset,12+3*62},frame=0,title=dacGainUnitsStringFromDacType(dacType[3])	// Vertical rule	xOffset=xOffset+36	SetDrawEnv linethick= 2	DrawLine xOffset,-3,xOffset,300	// 	// TTL area	//	// Horizontal rule	SetDrawLayer UserBack	SetDrawEnv linethick= 2	DrawLine xOffset,126,xOffset+717-496-20,126	// Checkboxes to turn on/off	xOffset=xOffset+10	WAVE ttlon	CheckBox TTL0Checkbox,pos={xOffset,12+0*28},size={43,14},proc=HandleTTLCheckbox,title="TTL0"	CheckBox TTL0Checkbox,value= ttlon[0]	CheckBox TTL1Checkbox,pos={xOffset,12+1*28},size={43,14},proc=HandleTTLCheckbox,title="TTL1"	CheckBox TTL1Checkbox,value= ttlon[1]	CheckBox TTL2Checkbox,pos={xOffset,12+2*28},size={43,14},proc=HandleTTLCheckbox,title="TTL2"	CheckBox TTL2Checkbox,value= ttlon[2]	CheckBox TTL3Checkbox,pos={xOffset,12+3*28},size={43,14},proc=HandleTTLCheckbox,title="TTL3"	CheckBox TTL3Checkbox,value= ttlon[3]		// Popup menus to set the wave for each	String listOfTTLWaveNames="_none_;"+Wavelist("*_TTL",";","")	Print listOfTTLWaveNames	xOffset=xOffset+55	WAVE /T ttlWavePopupSelection	PopupMenu TTL0WavePopupMenu,pos={xOffset,10+0*28},size={67,20}	PopupMenu TTL0WavePopupMenu,mode=1,popvalue=ttlWavePopupSelection[0],value=#listOfTTLWaveNames	PopupMenu TTL0WavePopupMenu,proc=HandleTTLWavePopupMenu	PopupMenu TTL1WavePopupMenu,pos={xOffset,10+1*28},size={67,20}	PopupMenu TTL1WavePopupMenu,mode=1,popvalue=ttlWavePopupSelection[1],value=#listOfTTLWaveNames	PopupMenu TTL1WavePopupMenu,proc=HandleTTLWavePopupMenu	PopupMenu TTL2WavePopupMenu,pos={xOffset,10+2*28},size={67,20}	PopupMenu TTL2WavePopupMenu,mode=1,popvalue=ttlWavePopupSelection[2],value=#listOfTTLWaveNames	PopupMenu TTL2WavePopupMenu,proc=HandleTTLWavePopupMenu	PopupMenu TTL3WavePopupMenu,pos={xOffset,10+3*28},size={67,20}	PopupMenu TTL3WavePopupMenu,mode=1,popvalue=ttlWavePopupSelection[2],value=#listOfTTLWaveNames	PopupMenu TTL3WavePopupMenu,proc=HandleTTLWavePopupMenu		// Old stuff, may come back at some point	xOffset=608	Variable yOffset=160	Button readgain_button,pos={xOffset,yOffset},size={120,25},proc=LoadSettingsButtonPressed,title="Load settings from file"	Button savegain_button,pos={xOffset,yOffset+35},size={120,25},proc=SaveSettingsButtonPressed,title="Save settings to file"	//SetVariable setvar0,pos={540,139},size={100,25},title="ITC",fSize=18,format="%d"	//SetVariable setvar0,limits={16,18,2},value= itc		// Restore the original data folder	SetDataFolder savDFEndFunction SyncADCGainSetVariableToModel(i)	Variable i 	// ADC channel index	String savDF=GetDataFolder(1)	SetDataFolder root:DP_DigitizerControl	WAVE adcgain	WAVE adcType	String setVariableName=sprintf1d("adcGain%dSetVariable",i)	SetVariable $setVariableName value=_NUM:adcgain[i]	String titleBoxName=sprintf1d("adcGain%dUnitsTitleBox",i)	TitleBox $titleBoxName,title=adcGainUnitsStringFromAdcType(adcType[i])		SetDataFolder savDF	EndFunction SyncDACGainSetVariableToModel(i)	Variable i 	// DAC channel index	String savDF=GetDataFolder(1)	SetDataFolder root:DP_DigitizerControl	WAVE dacgain	WAVE dacType	String setVariableName=sprintf1d("dacGain%dSetVariable",i)	SetVariable $setVariableName value=_NUM:dacgain[i]	String titleBoxName=sprintf1d("dacGain%dUnitsTitleBox",i)	TitleBox $titleBoxName,title=dacGainUnitsStringFromDacType(dacType[i])	SetDataFolder savDF	EndFunction ModelMayHaveChanged()	// Change to the DigitizerControl data folder	String savedDF=GetDataFolder(1)	NewDataFolder /O/S root:DP_DigitizerControl	// Declare the DF vars we need	WAVE adcon	WAVE /T adcBaseName	WAVE adcType	WAVE dacon	WAVE /T dacWavePopupSelection	WAVE dacType	WAVE dacMultiplier	WAVE ttlon	WAVE /T ttlWavePopupSelection	// Sync all the ADC-related controls	String controlName	Variable i	for (i=0; i<8; i+=1)		// Checkbox		controlName=sprintf1d("ADC%dCheckbox", i)		CheckBox $controlName win=DigitizerControl, value=adcon[i]		// Channel base name		controlName=sprintf1d("adc%dBaseNameSetVariable", i)		SetVariable $controlName,value= _STR:adcBaseName[i]		// Channel type (current, voltage, etc.)		controlName=sprintf1d("ADCChannelModePopupMenu%d", i)		PopupMenu $controlName,mode=adcType[i]		// Channel gain		SyncADCGainSetVariableToModel(i)	endfor	// Sync all the DAC-related controls	String listOfDACWaveNames="_none_;"+Wavelist("*_DAC",";","")	Variable iSelectedItem	for (i=0;i<4;i+=1)		// Checkbox		controlName=sprintf1d("DAC%dCheckbox", i)		CheckBox $controlName win=DigitizerControl, value=dacon[i]		// Channel type (current, voltage, etc.)		controlName=sprintf1d("DACChannelModePopupMenu%d", i)		PopupMenu $controlName,mode=dacType[i]		// Channel gain		SyncDACGainSetVariableToModel(i)		// Wave to be output through the channel		controlName=sprintf1d("DAC%dWavePopupMenu", i)				iSelectedItem=FindListItem(dacWavePopupSelection[i],listOfDACWaveNames)		if (iSelectedItem>=0) 			PopupMenu $controlName,mode=iSelectedItem,popvalue=dacWavePopupSelection[i],value=#listOfDACWaveNames 		else 			PopupMenu $controlName,mode=1,popvalue="_none_",value=#listOfDACWaveNames 		endif 		// Wave multiplier		controlName=sprintf1d("dacMultiplier%dSetVariable", i)				SetVariable dacMultiplier0SetVariable,value= _NUM:dacMultiplier[i]	endfor		// Sync all the TTL-related controls	String listOfTTLWaveNames="_none_;"+Wavelist("*_TTL",";","")	for (i=0;i<4;i+=1)		// Checkbox		controlName=sprintf1d("TTL%dCheckbox", i)		CheckBox $controlName win=DigitizerControl, value=ttlon[i]		// Wave to be output through the channel		controlName=sprintf1d("TTL%dWavePopupMenu", i)		iSelectedItem=FindListItem(ttlWavePopupSelection[i],listOfTTLWaveNames)		if (iSelectedItem>=0) 			PopupMenu $controlName,mode=iSelectedItem,popvalue=ttlWavePopupSelection[i],value=#listOfTTLWaveNames 		else 			PopupMenu $controlName,mode=1,popvalue="_none_",value=#listOfTTLWaveNames 		endif	endfor	// Restore the original DF	SetDataFolder savedDFEnd