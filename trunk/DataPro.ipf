//	DataPro//	DAC/ADC macros for use with Igor Pro and the ITC-16 or ITC-18//	Nelson Spruston//	Northwestern University//	project began 10/27/1998#pragma rtGlobals=1		// Use modern global access method.#include <Strings as Lists> #include "DP_DigitizerModelMethods"#include "DP_DigitizerViewMethods"#include "DP_DigitizerControllerMethods"//#include "DP_Acquire"#include "DP_BrowserModelMethods"#include "DP_BrowserViewMethods"#include "DP_BrowserControllerMethods"#include "DP_Sweeper"#include "DP_SweeperView"#include "DP_TestPulser"#include "DP_SineBuilder"#include "DP_PSCBuilder"#include "DP_RampBuilder"#include "DP_TrainBuilder"#include "DP_FiveStepBuilder"#include "DP_DACViewer"//#include "DP_Analyze"#include "DP_Utilities"//#include "DP_Image"//#include "DP_SIDX"//#include "DP_Windows"//#include "DP_MyVariables"#include "DP_MyProcedures"//#include "DP_LTP"#include "DP_Sampler"//---------------------- DataPro MENU -----------------------//Menu "DataPro"	"Start",RaiseOrCreateMainWindows()	"-"	"Digitizer Control Panel", RaiseOrCreateView("DigitizerView")	"Sweep Control Panel", RaiseOrCreateView("SweeperView")	"New Browser", CreateDataProBrowser()	"-"	"Test Pulse",NewTestPulserWindow()	"-"	"Five Step Builder",RaiseOrCreateView("FiveStepBuilderView")	"Train Builder",RaiseOrCreateView("TrainBuilderView")	"Ramp Builder",RaiseOrCreateView("RampBuilderView")	"PSC Builder",RaiseOrCreateView("PSCBuilderView")	"Sine Builder",RaiseOrCreateView("SineBuilderView")	"-"	"DAC Viewer",DACViewer()EndFunction IgorStartOrNewHook(igorApplicationNameStr)	String igorApplicationNameStr	InitializeDataPro()EndFunction InitializeDataPro()	//String savedDF=GetDataFolder(1)	//NewDataFolder /O/S root:DP_Digitizer	//String pathToThisFile=FunctionPath("")	//String dataProPathAbs=ParseFilePath(1,pathToThisFile,":",1,0)	//	// first 1 says to get the path up but not including the specified element	//	// second 1 says the specified element is relative to the last element	//	// 0 indicates the zeroth element (relative to the last), hence the last element	//NewPath /O DataPro dataProPathAbs	//LoadPICT /O /P=DataPro "DataProMenu.jpg", DataProMenu	SamplerConstructor()	DigitizerModelConstructor()End//Function AcquisitionPopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl//	String ctrlName//	Variable popNum//	String popStr//End//Function StartPanel() : Panel//	PauseUpdate; Silent 1		// building window...//	NewPanel /W=(271,307,737,541)//	SetDrawLayer UserBack//	SetDrawEnv fstyle= 1//	DrawText 68,30,"It is very important that you save this as an"//	SetDrawEnv fstyle= 1//	DrawText 38,56,"unpacked experiment before you begin acquiring data."//	SetDrawEnv fstyle= 1//	DrawText 66,85,"Click the start button below and this will be"//	SetDrawEnv fstyle= 1//	DrawText 86,115,"the first thing you are prompted to do."//	Button startbutton0,pos={177,136},size={100,30},proc=StartButtonProc,title="Start DataPro"//EndMacro//Function StartButtonProc(ctrlName) : ButtonControl//	String ctrlName//	Execute "StartDataPro()"//	DoWindow /K StartPanel//EndFunction RaiseOrCreateMainWindows()	// Raise or create the three main windows used for data acquisition	RaiseOrCreateView("DigitizerView")	RaiseOrCreateView("SweeperView")	RaiseOrCreateDataProBrowser()	NewTestPulserWindow()End