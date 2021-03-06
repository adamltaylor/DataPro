//	DataPro
//	DAC/ADC macros for use with Igor Pro and the ITC-16 or ITC-18
//	Nelson Spruston
//	Northwestern University
//	project began 10/27/1998

#pragma rtGlobals=3		// Use modern global access method, strict wave access

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
		Variable /G isTTLOutputEnabled=0		// whether or not to do a TTL output during test pulse
		Variable /G ttlOutputIndex=0	   // index of the TTL used for gate output, if isTTLOutputEnabled is true
		Variable /G doBaselineSubtraction=1	// whether to do baseline subtraction
		Variable /G RSeal=nan	// GOhm
		Variable /G updateRate=nan		// Hz	
	endif
	SetDataFolder savedDF
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserSetDACIndex(newValue)
	Variable newValue

	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	NVAR dacIndex
	dacIndex=newValue	

	SetDataFolder savedDF
End	


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserSetADCIndex(newValue)
	Variable newValue
	
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser
	
	NVAR adcIndex

	// Make sure the new ADC has not been hijacked
	if ( !SweeperGetADCHijacked(newValue) )
		adcIndex=newValue	
	endif

	SetDataFolder savedDF
End	


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserIsTTLOutputEnabled()
	if (!TestPulserExists())
		return 0
	endif
	
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	NVAR isTTLOutputEnabled		// whether or not to do a TTL output during test pulse

	Variable value=isTTLOutputEnabled

	SetDataFolder savedDF	
	
	return value
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserIsTTLInUse(ttlOutputIndexInQuestion)
	Variable ttlOutputIndexInQuestion
	
	if (!TestPulserExists())
		return 0
	endif
	
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	NVAR isTTLOutputEnabled		// whether or not to do a TTL output during test pulse
	NVAR ttlOutputIndex	   // index of the TTL used for gate output, if isTTLOutputEnabled is true

	Variable value=( isTTLOutputEnabled && (ttlOutputIndex==ttlOutputIndexInQuestion) )

	SetDataFolder savedDF	
	
	return value
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserIsADCInUse(adcIndexInQuestion)
	Variable adcIndexInQuestion
	
	if (!TestPulserExists())
		return 0
	endif
	
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser

	NVAR adcIndex

	Variable value=( adcIndex==adcIndexInQuestion)

	SetDataFolder savedDF	
	
	return value
End


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserSetTTLOutputIndex(newValue)
	Variable newValue
	
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser
	
	NVAR ttlOutputIndex
	if ( !SweeperGetTTLOutputHijacked(newValue) )
		if ( IsImagingModuleInUse() )
			// If using imaging module, need to make sure TestPulser doesn't collide with EpiLight
			if ( newValue != EpiLightGetTTLOutputIndex() )
				ttlOutputIndex=newValue	
			endif
		else
			// If not using imaging module, no more checks needed
			ttlOutputIndex=newValue		
		endif
	endif

	SetDataFolder savedDF
End	


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserGetTTLOutputIndex()
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser
	
	NVAR ttlOutputIndex
	
	Variable result=ttlOutputIndex

	SetDataFolder savedDF
	
	return result
End	


//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserGetADCIndex()
	String savedDF=GetDataFolder(1)
	SetDataFolder root:DP_TestPulser
	
	NVAR adcIndex

	Variable result=adcIndex

	SetDataFolder savedDF
	
	return result
End	


//
// Class methods
//

//----------------------------------------------------------------------------------------------------------------------------
Function TestPulserExists()
	return DataFolderExists("root:DP_TestPulser")
End
