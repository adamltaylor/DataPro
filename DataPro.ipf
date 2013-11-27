//	DataPro
//	DAC/ADC macros for use with Igor Pro and the ITC-16 or ITC-18
//	Nelson Spruston
//	Northwestern University
//	project began 10/27/1998

#pragma rtGlobals=1		// Use modern global access method.
// #pragma IndependentModule = DP	// Decided not to do, b/c want users to be able to modify hook functions

// These should all be in the same dir as this file, DataPro.ipf
#include ":DP_Sampler"
#include ":DP_DigitizerModel"
#include ":DP_DigitizerView"
#include ":DP_DigitizerController"
#include ":DP_BrowserModel"
#include ":DP_BrowserView"
#include ":DP_BrowserController"
#include ":DP_Sweeper"
#include ":DP_SweeperView"
#include ":DP_SweeperController"
#include ":DP_TestPulser"
#include ":DP_SineBuilder"
#include ":DP_ChirpBuilder"
#include ":DP_WNoiseBuilder"
#include ":DP_PSCBuilder"
#include ":DP_RampBuilder"
#include ":DP_TrainBuilder"
#include ":DP_TTLTrainBuilder"
#include ":DP_MulTrainBuilder"
#include ":DP_TTLMTrainBuilder"
#include ":DP_StairBuilder"
#include ":DP_OutputViewer"
#include ":DP_Utilities"
#include ":DP_MyProcedures"
#include ":DP_BuilderModel"
#include ":DP_BuilderView"
#include ":DP_BuilderController"
#include ":DP_Switcher"
#include ":DP_ASwitcher"
#include ":DP_Camera"
#include ":DP_FancyCamera"
#include ":DP_EpiLight"
#include ":DP_Imager"
#include ":DP_ImagerView"
#include ":DP_ImagerController"
#include ":DP_ImageBrowserModel"
#include ":DP_ImageBrowserView"
#include ":DP_ImageBrowserController"
#include ":DP_ImageTovers"



//#include <Strings as Lists> 
//#include "DP_Acquire"
//#include "DP_Analyze"
//#include "DP_Windows"
//#include "DP_MyVariables"
//#include "DP_LTP"

//---------------------- DataPro MENU -----------------------//

Menu "DataPro"
	"All Controls",MainContConstructors()
	"-"
	"Sweeper Controls",SweeperContConstructor()
	"Digitizer Controls",DigitizerContConstructor()
	"Imager Controls", ImagerContConstructor()
	"-"
	"New Signal Browser",BrowserContConstructor("New")
	"Image Browser",ImageBrowserContConstructor()
	"-"
	"Test Pulser",TestPulserContConstructor()
	"-"
	"Stair Builder",BuilderContConstructor("Stair")
	"Train Builder",BuilderContConstructor("Train")
	"TTL Train Builder",BuilderContConstructor("TTLTrain")
	"Multiple Train Builder",BuilderContConstructor("MulTrain")
	"Multiple TTL Train Builder",BuilderContConstructor("TTLMTrain")
	"Ramp Builder",BuilderContConstructor("Ramp")
	"PSC Builder",BuilderContConstructor("PSC")
	"Sine Builder",BuilderContConstructor("Sine")
	"Chirp Builder",BuilderContConstructor("Chirp")
	"White Noise Builder",BuilderContConstructor("WNoise")
	"-"
	"Output Viewer",OutputViewerContConstructor()
	"-"
	"Switcher",SwitcherContConstructor()
	"Axon Switcher",ASwitcherContConstructor()
End

//Menu "DataPro Image"
////	"Data Pro_Menu"
////	"-"
//	//"Imager Controls", ImagerContConstructor()
//	//"-"
////	"Focus_Image"
////	"Acquire_Full_Image"
//	"Load_Full_Image"
//	"Load_Image_Stack"
//	"-"
//	"Image_Display"
//	"DFF_From_Stack"
//	"-"
//	"Show_DFoverF"
//	"Append_DFoverF"
//	"Quick_Append"
//	//"Get_SIDX_Image"
//End

// This adds it to the marquee pop-up menu in a graph window
Menu "GraphMarquee"
	"-"
	"Add ROI", ImagerBrowserContAddROI()
End

//Function IgorStartOrNewHook(igorApplicationNameStr)
//	String igorApplicationNameStr
//	InitializeDataPro()
//End

Function AfterCompiledHook()
	InitializeDataPro()
	PostInitializationHook()
End

Function InitializeDataPro()
	//String savedDF=GetDataFolder(1)
	//NewDataFolder /O/S root:DP_Digitizer
	//String pathToThisFile=FunctionPath("")
	//String dataProPathAbs=ParseFilePath(1,pathToThisFile,":",1,0)
	//	// first 1 says to get the path up but not including the specified element
	//	// second 1 says the specified element is relative to the last element
	//	// 0 indicates the zeroth element (relative to the last), hence the last element
	//NewPath /O DataPro dataProPathAbs
	//LoadPICT /O /P=DataPro "DataProMenu.jpg", DataProMenu
	SamplerConstructor()
	DigitizerModelConstructor()
	SweeperConstructor()
	FancyCameraConstructor()
	ImagerConstructor()
	ImageBrowserModelConstructor()
End

//Function AcquisitionPopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
//	String ctrlName
//	Variable popNum
//	String popStr
//End

//Function StartPanel() : Panel
//	PauseUpdate; Silent 1		// building window...
//	NewPanel /W=(271,307,737,541)
//	SetDrawLayer UserBack
//	SetDrawEnv fstyle= 1
//	DrawText 68,30,"It is very important that you save this as an"
//	SetDrawEnv fstyle= 1
//	DrawText 38,56,"unpacked experiment before you begin acquiring data."
//	SetDrawEnv fstyle= 1
//	DrawText 66,85,"Click the start button below and this will be"
//	SetDrawEnv fstyle= 1
//	DrawText 86,115,"the first thing you are prompted to do."
//	Button startbutton0,pos={177,136},size={100,30},proc=StartButtonProc,title="Start DataPro"
//EndMacro

//Function StartButtonProc(ctrlName) : ButtonControl
//	String ctrlName
//	Execute "StartDataPro()"
//	DoWindow /K StartPanel
//End

Function MainContConstructors()
	// Raise or create the main controllers (and their views) used for data acquisition
	DigitizerContConstructor()
	TestPulserContConstructor()
	SweeperContConstructor()
	BrowserContConstructor("NewOnlyIfNone")
	ImagerContConstructor()
End

