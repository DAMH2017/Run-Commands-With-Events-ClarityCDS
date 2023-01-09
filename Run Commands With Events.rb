
include UNI

# Send command time out [ms].
$timeOut = 1000
# Timer period [ms]
$timerPeriod = 400

$maxEvents=8

#########################################################################
# Sub-device class expected by framework.
#
# Sub-device represents functional part of the chromatography hardware.
# Auxiliary implementation.
#########################################################################
class Auxiliary < AuxiliarySubDeviceWrapper
	# Constructor. Call base and do nothing. Make your initialization in the Init function instead.
	def initialize
		super
	end
	#########################################################################
	# Method expected by framework.
	#
	# Initialize Auxiliary sub-device. 
	# Set sub-device name, specify method items, specify monitor items, ...
	# Returns nothing.
	#########################################################################	
	def Init
	end
end # class Auxiliary

#########################################################################
# Device class expected by framework.
#
# Basic class for access to the chromatography hardware.
# Maintains a set of sub-devices.
# Device represents whole box while sub-device represents particular 
# functional part of chromatography hardware.
# The class name has to be set to "Device" because the device instance
# is created from the C++ code and the "Device" name is expected.
#########################################################################
class Device < DeviceWrapper
	# Constructor. Call base and do nothing. Make your initialization in the Init function instead.
	def initialize
		super
	end

	
	
	
	#########################################################################
	# Method expected by framework.
	#
	# Initialize configuration data object of the device and nothing else
	# (set device name, add all sub-devices, setup configuration, set pipe
	# configurations for communication, #  ...).
	# Returns nothing.
	#########################################################################	
	def InitConfiguration
		Configuration().AddStatic("Note","Note", "The event name is displayed")
		for i in 0..$maxEvents do 
			Configuration().AddString("EvName"+i.to_s,"Event Name"+i.to_s, "")
			Configuration().AddChoiceList("EvList"+i.to_s,"Event List"+i.to_s, "---")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "---")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Open Instrument")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Start Sequence")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Resume Sequence")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Start Run")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Perform Injection")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Bypass Injection")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Start Acquisition")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Restart Acquisition")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Stop Acquisition")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Abort Run On Error")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Abort Run By User")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Acquisition Finished")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Run Finished")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Shut Down")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Stop Run")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Stop Sequence")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Close Instrument")
			Configuration().AddChoiceListItem("EvList"+i.to_s, "Send Method")
		
			Configuration().AddChoiceList("EvCommand"+i.to_s,"Available Commands"+i.to_s, "---")
			Configuration().AddChoiceListItem("EvCommand"+i.to_s, "---")
			
			Dir.glob(__dir__+"/*.bat") do |bat_file|
				Configuration().AddChoiceListItem("EvCommand"+i.to_s, "#{bat_file}")
			end
		end
		
		
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# Initialize device. Configuration object is already initialized and filled with previously stored values.
	# (set device name, add all sub-devices, setup configuration, set pipe
	# configurations for communication, #  ...).
	# Returns nothing.
	#########################################################################	
	def Init
				
		@m_Auxiliary=Auxiliary.new
		
		AddSubDevice(@m_Auxiliary)
		@m_Auxiliary.SetName("My Aux")
		# Device name.
		SetName("Virtual Event Device")
		SetTimerPeriod($timerPeriod)
 	end
	
		
	#########################################################################
	# Method expected by framework.
	#
	# Sets communication parameters.
	# Returns nothing.
	#########################################################################	
	def InitCommunication()
	end
	
		
	#########################################################################
	# Method expected by framework
	#
	# Here you should check leading and ending sequence of characters, 
	# check sum, etc. If any error occurred, use ReportError function.
	#	dataArraySent - sent buffer (can be nil, so it has to be checked 
	#						before use if it isn't nil), array of bytes 
	#						(values are in the range <0, 255>).
	#	dataArrayReceived - received buffer, array of bytes 
	#						(values are in the range <0, 255>).
	# Returns true if frame is found otherwise false.		
	#########################################################################	
	def FindFrame(dataArraySent, dataArrayReceived)
		return true
	end
	
	#########################################################################
	# Method expected by framework
	#
	# Return true if received frame (dataArrayReceived) is answer to command
	# sent previously in dataArraySent.
	#	dataArraySent - sent buffer, array of bytes 
	#						(values are in the range <0, 255>).
	#	dataArrayReceived - received buffer, array of bytes 
	#						(values are in the range <0, 255>).
	# Return true if in the received buffer is answer to the command 
	# from the sent buffer. 
	#########################################################################		
	def IsItAnswer(dataArraySent, dataArrayReceived)
		return true
	end
	
	#########################################################################
	# Method expected by framework
	#
	# Returns serial number string from HW (to comply with CFR21) when 
	# succeessful otherwise false or nil. If not supported return false or nil.
	#########################################################################	
	def CmdGetSN
		# Serial number not supported in the hw.
		return false
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when instrument opens
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdOpenInstrument
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Open Instrument")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when sequence starts
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdStartSequence
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Start Sequence")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when sequence resumes
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdResumeSequence
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Resume Sequence")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when run starts
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdStartRun
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Start Run")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when injection performed
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdPerformInjection
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Perform Injection")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when injection bypassed
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdByPassInjection
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Bypass Injection")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# Starts method in HW.
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdStartAcquisition
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Start Acquisition")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		Monitor().SetRunning(true)
		Monitor().Synchronize()
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when acquisition restarts
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdRestartAcquisition
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Restart Acquisition")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end	

	#########################################################################
	# Method expected by framework.
	#
	# Stops running method in hardware. 
	# Returns true when successful otherwise false.	
	#########################################################################
	def CmdStopAcquisition
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Stop Acquisition")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end	
	
	#########################################################################
	# Method expected by framework.
	#
	# Aborts running method or current operation. Sets initial state.
	# Returns true when successful otherwise false.	
	#########################################################################
	def CmdAbortRunError
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Abort Run On Error")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		CmdRunFinished()
		CmdAcquisitionFinished()
		
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# Aborts running method or current operation. Sets initial state. 
	# Abort was caused by user.
	# Returns true when successful otherwise false.	
	#########################################################################
	def CmdAbortRunUser
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Abort Run By User")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		CmdRunFinished()
		CmdAcquisitionFinished()
		
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# Aborts running method or current operation (shutdown). Sets initial state.
	# Returns true when successful otherwise false.	
	#########################################################################
	def CmdShutDown
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Shut Down")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		CmdRunFinished()
		CmdAcquisitionFinished()
		
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when run stops
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdStopRun
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Stop Run")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		CmdRunFinished()
		CmdAcquisitionFinished()
		
		return true
	end
	
	#########################################################################
	# User Written Method
	#
	# detects acquisition ended by any reason
	#########################################################################
	def CmdAcquisitionFinished
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Acquisition Finished")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end
	
	#########################################################################
	# User Written Method
	#
	# detects run ended by any reason
	#########################################################################
	def CmdRunFinished
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Run Finished")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		Monitor().SetRunning(false)
		Monitor().Synchronize()
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when sequence stops
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdStopSequence
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Stop Sequence")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# gets called when closing instrument
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdCloseInstrument
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Close Instrument")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end	

	#########################################################################
	# Method expected by framework.
	#
	# Tests whether hardware device is present on the other end of the communication line.
	# Send some simple command with fast response and check, whether it has made it
	# through pipe and back successfully.
	# Returns true when successful otherwise false.
	#########################################################################
	def CmdTestConnect
		return true
	end	

	#########################################################################
	# Method expected by framework.
	#
	# Send method to hardware.
	# Returns true when successful otherwise false.	
	#########################################################################
	def CmdSendMethod
		for i in 0..$maxEvents do
			if(Configuration().GetString("EvList"+i.to_s)=="Send Method")
				Execute(Configuration().GetString("EvCommand"+i.to_s))
				Trace("Event"+i.to_s+" has been executed")
			end
		end
		return true
	end
	
	#########################################################################
	# Method expected by framework.
	#
	# Loads method from hardware.
	# Returns true when successful otherwise false.	
	#########################################################################
	def CmdLoadMethod(method)
		return true		
	end
		
	#########################################################################
	# Method expected by framework.
	#
	# Duration of thermostat method.
	# Returns complete (from start of acquisition) length (in minutes) 
	# 	of the current method in sub-device (can use GetRunLengthTime()).
	# Returns METHOD_FINISHED when hardware instrument is not to be waited for or 
	# 	method is not implemented.
	# Returns METHOD_IN_PROCESS when hardware instrument currently processes 
	# 	the method and sub-device cannot tell how long it will take.
	#########################################################################
	def GetMethodLength
		return METHOD_FINISHED
	end	
	
	#########################################################################
	# Method expected by framework.
	#
	# Periodically called function which should update state 
	# of the sub-device and monitor.
	# Returns true when successful otherwise false.	
	#########################################################################
	def CmdTimer
	    return true
	end
	
	#########################################################################
	# Method expected by framework
	#
	# gets called when user presses autodetect button in configuration dialog box
	# return true or  false
	#########################################################################
	def CmdAutoDetect
		return true;
	end
	
	#########################################################################
	# Method expected by framework
	#
	# Processes unrequested data sent by hardware. Unrequested data is not 
	# supported for now please use default implementation from examples.
	#	dataArrayReceived - received buffer, array of bytes 
	#						(values are in the range <0, 255>).
	# Returns true if frame was processed otherwise false.
	#########################################################################
	def ParseReceivedFrame(dataArrayReceived)
		# Passes received frame to appropriate sub-device's ParseReceivedFrame function.
	end
	
	#########################################################################
	# Required by Framework
	#
	# Gets called when chromatogram is acquired, chromatogram might not exist at the time.
	#########################################################################
	def NotifyChromatogramFileName(chromatogramFileName)
	end
	
	#########################################################################
	# Required by Framework
	#
	# Gets called when chromatogram is acquired, chromatogram might not exist at the time.
	#########################################################################
	def CheckMethod(situation,method)
	end

	#########################################################################
	# User written method.
	#
	# Returns translated string with specified ID
	#########################################################################
	

end # class Device
