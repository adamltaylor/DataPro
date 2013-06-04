//	DataPro
//	DAC/ADC macros for use with Igor Pro and the ITC-16 or ITC-18
//	Nelson Spruston
//	Northwestern University
//	project began 10/27/1998

Function TestPulserContConstructor() : Graph
	TestPulserConstructor()
	TestPulserViewConstructor()
End

Function TestPulserViewConstructor() : Graph
	// If the view already exists, just bring it forward
	if (GraphExists("TestPulserView"))
		DoWindow /F TestPulserView
		return 0
	endif

	// Save the current DF
	String savedDF=GetDataFolder(1)

	// Set the data folder
	SetDataFolder root:DP_TestPulser
	
	// Declare instance variables
	NVAR ttlOutput
	NVAR doBaselineSubtraction	
	NVAR RSeal
	NVAR updateRate
	
	// Kill any pre-existing window	
	if (GraphExists("TestPulserView"))
		DoWindow /K TestPulserView
	endif
	
	// Create the graph window
	// These are all in pixels
	Variable xOffset=1060
	Variable yOffset=54
	Variable width=300*ScreenResolution/72
	Variable height=300*ScreenResolution/72
	// Convert dimensions to points
	Variable pointsPerPixel=72/ScreenResolution
	Variable xOffsetInPoints=pointsPerPixel*xOffset
	Variable yOffsetInPoints=pointsPerPixel*yOffset
	Variable widthInPoints=pointsPerPixel*width
	Variable heightInPoints=pointsPerPixel*height
	Display /W=(xOffsetInPoints,yOffsetInPoints,xOffsetInPoints+widthInPoints,yOffsetInPoints+heightInPoints) /N=TestPulserView /K=1 as "Test Pulser"
	
	// Draw the top "panel"
	ControlBar /T /W=TestPulserView 80

	// Control widgets for the test pulse	
	Button startButton,win=TestPulserView,pos={18,10},size={80,20},proc=TestPulserContStartButton,title="Start"
	TitleBox proTipTitleBox,win=TestPulserView,pos={10,30+4},frame=0,title="(hit ESC key to stop)",disable=1

	SetVariable adcIndexSV,win=TestPulserView,pos={110+30,10},size={70,1},title="ADC #"
	SetVariable adcIndexSV,win=TestPulserView,limits={0,7,1},value= root:DP_TestPulser:adcIndex
	SetVariable dacIndexSV,win=TestPulserView,pos={110+30,30},size={70,1},title="DAC #",proc=TestPulserContDacIndexTwiddled
	SetVariable dacIndexSV,win=TestPulserView,limits={0,3,1},value= root:DP_TestPulser:dacIndex

	SetVariable testPulseAmplitudeSetVariable,win=TestPulserView,pos={200+30,10},size={100,1},title="Amplitude"
	SetVariable testPulseAmplitudeSetVariable,win=TestPulserView,limits={-1000,1000,1},value= root:DP_TestPulser:amplitude
	TitleBox amplitudeTitleBox,win=TestPulserView,pos={330+4,10+2},frame=0
	SetVariable durationSV,win=TestPulserView,pos={200+30,30},size={100,1},title="Duration  "
	SetVariable durationSV,win=TestPulserView,limits={1,1000,1},value= root:DP_TestPulser:duration
	TitleBox msTitleBox,win=TestPulserView,pos={300+30+4,30+2},frame=0,title="ms"
	
	CheckBox testPulseBaseSubCheckbox,win=TestPulserView,pos={110+30,56},size={58,14},title="Base Sub"
	Checkbox testPulseBaseSubCheckbox,win=TestPulserView
	Checkbox testPulseBaseSubCheckbox,win=TestPulserView,proc=TestPulserBaseSubCheckboxUsed

	CheckBox ttlOutputCheckbox,win=TestPulserView,pos={200+30+20,56},size={58,14},title="TTL Output"
	CheckBox ttlOutputCheckbox,win=TestPulserView,proc=TestPulserContTTLOutputCheckBox
	SetVariable ttlOutChannelSetVariable,win=TestPulserView,pos={280+30+20,56-1},size={44,1},title="#"
	SetVariable ttlOutChannelSetVariable,win=TestPulserView,limits={0,3,1},value= root:DP_TestPulser:ttlOutIndex
	SetVariable ttlOutChannelSetVariable,win=TestPulserView,disable=2-2*ttlOutput

	// Draw the bottom "panel"
	ControlBar /B /W=TestPulserView 30

	// Widgets for showing the seal resistance
	ValDisplay RSealValDisplay,win=TestPulserView,pos={236,380},size={120,17},fSize=12,format="%10.3f"
	ValDisplay RSealValDisplay,win=TestPulserView,limits={0,0,0},barmisc={0,1000}
	ValDisplay RSealValDisplay,win=TestPulserView,title="Resistance:"
	TitleBox GOhmTitleBox,win=TestPulserView,pos={236+126,380+1},frame=0,title="GOhm"
	WhiteOutIffNan("RSealValDisplay","TestPulserView",RSeal)
	
	// ValDisplay for showing the update rate
	ValDisplay updateRateValDisplay,win=TestPulserView,pos={10,380},size={120,17},fSize=12,format="%6.1f"
	ValDisplay updateRateValDisplay,win=TestPulserView,limits={0,0,0},barmisc={0,1000}
	ValDisplay updateRateValDisplay,win=TestPulserView,title="Update rate:"
	TitleBox hzTitleBox,win=TestPulserView,pos={10+126,380+1},frame=0,title="Hz"
	WhiteOutIffNan("updateRateValDisplay","TestPulserView",updateRate)
	
	// Prompt a view update
	TestPulserViewUpdate()
	
	// Restore the original DF
	SetDataFolder savedDF
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserConstructor()
	String savedDF=GetDataFolder(1)
	// If the TestPulser data folder doesn't exist, create it
	if (!DataFolderExists("root:DP_TestPulser"))
 		NewDataFolder /S root:DP_TestPulser
		Variable /G amplitude=1		// test pulse amplitude, units determined by channel type
		Variable /G duration=10		// test pulse duration, ms
		Variable /G dt=0.02		// sample interval for the test pulse, ms
		Variable /G adcIndex=0		// index of the ADC channel to be used for the test pulse
		Variable /G dacIndex=0		// index of the DAC channel to be used for the test pulse	
		Variable /G ttlOutput=0		// whether or not to do a TTL output during test pulse
		Variable /G ttlOutIndex=0	   // index of the TTL used for gate output, if ttlOutput is true
		Variable /G doBaselineSubtraction=1	// whether to do baseline subtraction
		Variable /G RSeal=nan	// GOhm
		Variable /G updateRate=nan		// Hz	
	endif
	SetDataFolder savedDF
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserViewUpdate()
	// If the view does no exist, nothing to do
	if (!GraphExists("TestPulserView"))
		return 0
	endif

	// Save the current DF, set it
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	NVAR doBaselineSubtraction
	NVAR ttlOutput
	NVAR RSeal
	NVAR updateRate
	NVAR dacIndex

	// Make sure TestPulse_ADC is plotted if it exists, but nothing is plotted if it doesn't exist
	String traceList=TraceNameList("TestPulserView",";",3)  // 3 means all traces
	Variable nTraces=ItemsInList(traceList)
	Variable waveInGraph=(nTraces>0)		// assume that if there's a wave in there, it's TestPulse_ADC	
	if (WaveExists(TestPulse_ADC))
		if (!waveInGraph)
			AppendToGraph /W=TestPulserView TestPulse_ADC
		endif
		ModifyGraph /W=TestPulserView grid(left)=1
		ModifyGraph /W=TestPulserView tickUnit(bottom)=1
		TestPulserContYLimitsToTrace()
		TestPulserViewUpdateAxisLabels()
	else
		RemoveFromGraph /Z /W=TestPulserView $"#0"
	endif

	// Controls that don't update themselves	
	String amplitudeUnits=DigitizerModelGetDACUnitsString(dacIndex)		// Get units from the Digitizer model
	TitleBox amplitudeTitleBox,win=TestPulserView,title=amplitudeUnits
	CheckBox testPulseBaseSubCheckbox,win=TestPulserView,value=doBaselineSubtraction
	CheckBox ttlOutputCheckbox,win=TestPulserView,value=ttlOutput

	// Widgets for showing the seal resistance
	ValDisplay RSealValDisplay,win=TestPulserView,value= _NUM:RSeal
	WhiteOutIffNan("RSealValDisplay","TestPulserView",RSeal)
	
	// ValDisplay for showing the update rate
	ValDisplay updateRateValDisplay,win=TestPulserView,value= _NUM:updateRate
	WhiteOutIffNan("updateRateValDisplay","TestPulserView",updateRate)
	
	// Restore the original DF
	SetDataFolder savedDF	
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserViewDigitizerChanged()
	// Used to notify the Test Pulser view that the Digitzer has changed.
	// Currently, prompts an update of the TestPulser view.
	TestPulserViewUpdate()	
		// This updates the amplitude units, among other things, which is all that
		// depends on the digitizer model
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserContDigitizerChanged()
	// Used to notify the Test Pulser controller that the Digitzer model has changed.
	// Currently, prompts an update of the TestPulser view only.
	TestPulserViewDigitizerChanged()
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserContDacIndexTwiddled(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	TestPulserViewUpdate()	
End	


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserContSetDACIndex(newValue)
	Variable newValue
	
	TestPulserModelSetDACIndex(newValue)
	TestPulserViewUpdate()			
End	


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserContSetADCIndex(newValue)
	Variable newValue
	
	TestPulserModelSetADCIndex(newValue)
	TestPulserViewUpdate()			
End	


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserContStart()
	// Deliver repeated test pulses, acquire response, display.

	// Set DF
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	// Declare instance variables
	NVAR dacIndex	// index of DAC channel to use for test pulse
	NVAR adcIndex	// index of ADC channel to use for test pulse
	NVAR amplitude, duration
	NVAR dt
	NVAR ttlOutput		// boolean, true iff we're to also have a TTL output go high when pulsing
	NVAR ttlOutIndex		// index of the TTL output channel to use
	NVAR doBaselineSubtraction
	NVAR RSeal
	NVAR updateRate
	
	// Build the test pulse wave
	Wave testPulseTTL=SimplePulseBoolean(dt,2*duration,0.5*duration,duration)		// free wave
	Variable nScans=numpnts(testPulseTTL)
	Make /FREE /N=(nScans) testPulse
	testPulse=amplitude*testPulseTTL

	// Create the wave we'll display, which is all-zeros for now
 	Make /O /N=(nScans) TestPulse_ADC		// This is a bound wave, b/c it has to live on after we exit
	Setscale /P x, 0, dt, "ms", TestPulse_ADC

	// Bring the test pulse panel to the front
	DoWindow /F TestPulserView
	
	// Multiplex the TTL wave, if called for
	if (ttlOutput)
		testPulseTTL=(2^ttlOutIndex)*testPulseTTL	// multiplexing
	endif
	
	// Build FIFOout for the test pulse
	Variable outGain=DigitizerModelGetDACPntsPerNtv(dacIndex)
	Variable inGain=DigitizerModelGetADCNtvsPerPnt(adcIndex)
	String daSequence=num2str(dacIndex)
	String adSequence=num2str(adcIndex)
	if (ttlOutput)
		daSequence+="D"
		adSequence+=num2str(adcIndex)
		Make /FREE /N=(nScans*2) FIFOout
		Setscale /P x, 0, dt/2, "ms", FIFOout
		//FIFOout[0,;2]=testPulse[p/2]*outGain*dacMultiplier[dacIndex]
		FIFOout[0,;2]=testPulse[p/2]*outGain		// units: digitizer points
		FIFOout[0,;2]=min(max(-32768,FIFOout[p]),32767)		// limit to 16 bits
		FIFOout[1,;2]=testPulseTTL[p/2]
	else
		//Duplicate /FREE testPulse FIFOout	
		Make /FREE /N=(nScans) FIFOout
		Setscale /P x, 0, dt, "ms", FIFOout
		//Duplicate /FREE testPulse FIFOout	
		//FIFOout=testPulse*outGain*dacMultiplier[dacIndex]
		FIFOout=testPulse*outGain		// units: digitizer points
		FIFOout=min(max(-32768,FIFOout[p]),32767)	// limit to 16 bits
	endif
	//Variable seqLength=strlen(daSequence)		// will be 1 if no TTL, 2 if TTL
	
	// Specify the time windows for measuring the baseline and the pulse amplitude
	Variable totalDuration=2*duration
	Variable t0Base=0
	Variable tfBase=1/8*totalDuration
	Variable t0Pulse=5/8*totalDuration
	Variable tfPulse=6/8*totalDuration
		
	// Deliver test pulse, plot response, repeat until user wants to stop
	Variable base, pulse
	Variable timer
	Variable usElapsed
	Variable adcMode=DigitizerModelGetADCMode(adcIndex)
	Variable dacMode=DigitizerModelGetDACMode(dacIndex)		
	Variable i
	TitleBox proTipTitleBox,win=TestPulserView,disable=0		// tell the user how to break out of the loop
	timer=startMSTimer		// start the timer
	for (i=0; !EscapeKeyWasPressed(); i+=1)
		// execute the sample sequence
		Wave FIFOin=SamplerSampleData(adSequence,daSequence,FIFOout)
		// extract TestPulse_ADC from FIFOin
		if (ttlOutput)
			TestPulse_ADC=FIFOin[2*p]*inGain
		else
			TestPulse_ADC=FIFOin*inGain
		endif
		//KillWaves FIFOin		// Don't need FIFOin anymore
		if (doBaselineSubtraction)
			Wavestats /Q/R=[5,45] TestPulse_ADC
			TestPulse_ADC-=V_avg
		endif
		// If first iteration, do first-time things
		if (i==0)
			// if TestPulse_ADC is not currently being shown in the graph, append it
			String traceList=TraceNameList("TestPulserView",";",3)  // 3 means all traces
			Variable nTraces=ItemsInList(traceList)
			Variable waveInGraph=(nTraces>0)		// assume that if there's a wave in there, it's TestPulse_ADC	
			if (!waveInGraph)
				AppendToGraph /W=TestPulserView TestPulse_ADC
				ModifyGraph grid(left)=1
				ModifyGraph tickUnit(bottom)=1
			endif
			// set display range, axis labels, etc.
			TestPulserContYLimitsToTrace()
			TestPulserViewUpdateAxisLabels()
		endif
		// Calculate the seal resistance
		base=mean(TestPulse_ADC,t0Base,tfBase)
		pulse=mean(TestPulse_ADC,t0Pulse,tfPulse)
		if (adcMode==0 && dacMode==1)
			// ADC channel is a current channel, DAC channel is a voltage channel
			RSeal=amplitude/(pulse-base)
		elseif (adcMode==1 && dacMode==0)
			// output channel is a voltage channel
			RSeal=(pulse-base)/amplitude
		else
			//Printf "ADC and DAC channel for test pulse are of same type, therefore the 'resistance' is unitless!\r"
			RSeal=nan
		endif
		ValDisplay RSealValDisplay,win=TestPulserView,value= _NUM:RSeal
		WhiteOutIffNan("RSealValDisplay","TestPulserView",RSeal)
		// Calculate the update rate
		usElapsed=stopMSTimer(timer)
		// Make sure we really had a timer for that last iteration
		if (timer!=-1)
			updateRate=1e6/usElapsed	// Hz
		else
			updateRate=nan	// Hz
		endif		
		timer=startMSTimer
		ValDisplay updateRateValDisplay,win=TestPulserView,value= _NUM:updateRate
		//ValDisplay updateRateValDisplay,win=TestPulserView,value= _NUM:msElapsed2
		WhiteOutIffNan("updateRateValDisplay","TestPulserView",updateRate)
		// Update the graph
		DoUpdate /W=TestPulserView
	endfor
	usElapsed=stopMSTimer(timer)	// stop the timer, and free it
	//while (HaltProcedures()<1)
	TitleBox proTipTitleBox,win=TestPulserView,disable=1		// hide the tip

	//// Kill the graph
	//DoWindow /K TestPulseGraph
	
	// Bring the test pulse panel forward now that we're done
	DoWindow /F TestPulserView
	
	// Kill the ADC wave, so it's not hanging around in the DF after we exit
	//KillWaves TestPulse_ADC
	
	// Restore the original DF
	SetDataFolder savedDF
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserContStartButton(ctrlName) : ButtonControl
	String ctrlName
	TestPulserContStart()
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserBaseSubCheckboxUsed(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked

	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	NVAR doBaselineSubtraction
	doBaselineSubtraction=checked
	
	SetDataFolder savedDF
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserContTTLOutputCheckBox(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked

	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	NVAR ttlOutput
	ttlOutput=checked
	SetVariable ttlOutChannelSetVariable,win=TestPulserView,disable=2-2*ttlOutput
	
	SetDataFolder savedDF
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserContYLimitsToTrace()
	// Adjusts the Y axis limits to accommodate the test pulse trace.
	// private method
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	if (WaveExists(TestPulse_ADC))	
		// set display range, axis labels, etc.
		Variable miny, maxy
		Wavestats /Q TestPulse_ADC
		miny=1.2*V_min
		maxy=1.2*V_max
		miny-=maxy/10
		if (miny>-0.2)
			miny=-0.2
		endif
		if (maxy<0.2)
			maxy=0.2
		endif
		Setaxis /W=TestPulserView left, miny, maxy
	endif

	SetDataFolder savedDF
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserViewUpdateAxisLabels()
	// Sets the axis labels to match what's in the model.
	// private method
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	NVAR adcIndex
	
	if (WaveExists(TestPulse_ADC))	
		Label /W=TestPulserView /Z bottom "\\F'Helvetica'\\Z12\\f01Time (ms)"
		String adcModeString=DigitizerModelGetADCModeName(adcIndex)
		String adcUnitsString=DigitizerModelGetADCUnitsString(adcIndex)	
		Label /W=TestPulserView /Z left sprintf2ss("\\F'Helvetica'\\Z12\\f01%s (%s)",adcModeString,adcUnitsString)
	endif

	SetDataFolder savedDF
End

//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserModelSetDACIndex(newValue)
	Variable newValue

	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	NVAR dacIndex
	dacIndex=newValue	

	SetDataFolder savedDF
End	


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserModelSetADCIndex(newValue)
	Variable newValue
	
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser
	
	NVAR adcIndex
	adcIndex=newValue	

	SetDataFolder savedDF
End	

