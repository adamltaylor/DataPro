#pragma rtGlobals=1		// Use modern global access method.

Function BuilderModelConstructor(builderTypeLocal)
	String builderTypeLocal
	
	// Save the current DF
	String savedDF=GetDataFolder(1)
	
	// Create a new DF
	String dfString=sprintf1s("root:DP_%sBuilder",builderTypeLocal)
	NewDataFolder /O /S $dfString
	
	// Parameters of sine wave stimulus
	String /G builderType=builderTypeLocal
	Variable /G dt=SweeperGetDt()
	Variable /G totalDuration=SweeperGetTotalDuration()
	Make /O /T parameterNames
	Make /O parametersDefault
	Make /O parameters

	// Create the wave
	Make /O theWave

	// Set to default params
	String initializationFunctionName=builderType+"BuilderModelInitialize"
	Funcref BuilderModelInitialize initializationFunction=$initializationFunctionName
	initializationFunction()
		
	// Update the wave	
	BuilderModelUpdateWave(builderType)	
		
	// Restore the original data folder
	SetDataFolder savedDF
End

Function BuilderModelInitialize()
	Abort "Internal Error: Attempt to call a function that doesn't exist."
End

Function BuilderModelSetParameter(builderType,parameterName,value)
	// Set the named parameter in the named builderType model
	String builderType
	String parameterName
	Variable value

	String savedDF=GetDataFolder(1)
	String dfString=sprintf1s("root:DP_%sBuilder",builderType)
	SetDataFolder $dfString

	WAVE parameters
	WAVE /T parameterNames

	// Set the parameter in the parameters wave
	Variable nParameters=numpnts(parameters)
	Variable i
	for (i=0; i<=nParameters; i+=1)
		if (AreStringsEqual(parameterName,parameterNames[i]))
			parameters[i]=value
		endif
	endfor

	// Update the wave
	BuilderModelUpdateWave(builderType)

	SetDataFolder savedDF
End

Function BuilderModelUpdateWave(builderType)
	// Updates the theWave wave to match the model parameters.
	// This is a private _model_ method -- The view updates itself when theWave changes.
	String builderType
	
	String savedDF=GetDataFolder(1)
	String dfString=sprintf1s("root:DP_%sBuilder",builderType)
	SetDataFolder $dfString
	
	WAVE /T parameterNames
	WAVE parameters
	WAVE theWave
	NVAR dt, totalDuration
		
	resampleFromParamsBang(builderType,theWave,dt,totalDuration,parameters,parameterNames)
	
	Note /K theWave
	ReplaceStringByKeyInWaveNote(theWave,"WAVETYPE",builderType)
	ReplaceStringByKeyInWaveNote(theWave,"TIME",time())
	
	// Set the parameters in the wave note
	Variable nParameters=numpnts(parameters)
	Variable i
	for (i=0; i<=nParameters; i+=1)
		ReplaceStringByKeyInWaveNote(theWave,parameterNames[i],num2str(parameters[i]))
	endfor
	SetDataFolder savedDF
End

Function BuilderModelImportWave(builderType,fancyWaveNameString)
	// Imports the stimulus parameters from a pre-existing wave in the Sweeper
	// This is a model method
	String builderType
	String fancyWaveNameString
	
	String savedDF=GetDataFolder(1)
	String dfString=sprintf1s("root:DP_%sBuilder",builderType)
	SetDataFolder $dfString
	
	WAVE /T parameterNames
	WAVE parameters

	Variable i
	if (AreStringsEqual(fancyWaveNameString,"(Default Settings)"))
		BuilderModelSetParamsToDefault(builderType)
	else
		// Get the wave from the digitizer
		Wave exportedWave=SweeperGetWaveByFancyName(fancyWaveNameString)
		String waveTypeString=StringByKeyInWaveNote(exportedWave,"WAVETYPE")
		if (AreStringsEqual(waveTypeString,builderType))
			Variable nParameters=numpnts(parameters)
			for (i=0; i<=nParameters; i+=1)
				parameters[i]=NumberByKeyInWaveNote(exportedWave,parameterNames[i])
			endfor
		else
			Abort(sprintf1s("This is not a %s wave; choose another",builderType))
		endif
	endif
	BuilderModelUpdateWave(builderType)
	
	SetDataFolder savedDF	
End

Function BuilderModelSetParamsToDefault(builderType)
	String builderType
	
	String savedDF=GetDataFolder(1)
	String dfString=sprintf1s("root:DP_%sBuilder",builderType)
	SetDataFolder $dfString
	
	WAVE parameters
	WAVE parametersDefault

	Variable nParameters=numpnts(parameters)
	Variable i
	for (i=0; i<=nParameters; i+=1)
		parameters[i]=parametersDefault[i]
	endfor	

	SetDataFolder savedDF	
End

Function resampleBang(builderType,w,dt,totalDuration)
	// Re-compute the wave in w, using the given dt, totalDuration, and the
	// parameter values stored in the wave note of w itself.
	String builderType
	Wave w
	Variable dt, totalDuration
	
	String savedDF=GetDataFolder(1)
	String dfString=sprintf1s("root:DP_%sBuilder",builderType)
	SetDataFolder $dfString
	
	WAVE /T parameterNames
	
	Variable nParameters=numpnts(parameterNames)
	Make /FREE /N=(nParameters) parametersFromW
	Variable i
	for (i=0; i<=nParameters; i+=1)
		parametersFromW[i]=NumberByKeyInWaveNote(w,parameterNames[i])
	endfor
	
	resampleFromParamsBang(builderType,w,dt,totalDuration,parametersFromW,parameterNames)

	SetDataFolder savedDF	
End

Function BuilderModelSweeperDtOrTChanged(builderType)
	// Used to notify the Builder model of a change to dt or totalDuration in the Sweeper.
	String builderType
	
	// If no builder of the given type currently exists, do nothing
	String dfString=sprintf1s("root:DP_%sBuilder",builderType)
	if (!DataFolderExists(dfString))
		return 0
	endif
	
	// Save, set the DF
	String savedDF=GetDataFolder(1)
	SetDataFolder $dfString
	
	NVAR dt, totalDuration
	
	// Get dt, totalDuration from the sweeper
	dt=SweeperGetDt()
	totalDuration=SweeperGetTotalDuration()
	// Update the	wave
	BuilderModelUpdateWave(builderType)
	
	// Restore the DF
	SetDataFolder savedDF		
End

Function resampleFromParamsBang(builderType,w,dt,totalDuration,parameters,parameterNames)
	// Re-compute the wave in w using the given dt, totalDuration, and parameters
	// This is a class method.
	String builderType
	Wave w
	Variable dt,totalDuration
	Wave parameters
	Wave parameterNames
	
	Variable nScans=numberOfScans(dt,totalDuration)
	Redimension /N=(nScans) w
	Setscale /P x, 0, dt, "ms", w
	
	String fillFunctionName="fill"+builderType+"FromParamsBang"
	Funcref fillFromParamsBang fillFunction=$fillFunctionName
	fillFunction(w,dt,nScans,parameters,parameterNames)
End

Function fillFromParamsBang(w,dt,nScans,parameters,parameterNames)
	// Placeholder function
	Wave w
	Variable dt,nScans
	Wave parameters
	Wave /T parameterNames	
	Abort "Internal Error: Attempt to call a function that doesn't exist."
End