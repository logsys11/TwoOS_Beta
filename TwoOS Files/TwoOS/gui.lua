--os.pullEvent correction
os.loadAPI("TwoOS/APIs/settings")
os.loadAPI("TwoOS/APIs/SHA256util")

function _G.os.version()
	return "Tw0OS V.1 Beta 1"
end
_G.os.pullEvent = function( _sFilter )
	if _sFilter == "mouse_click" then
		event, button, x ,y = coroutine.yield( _sFilter )
		if event == "mouse_click" then
			y = y - 1
			return event, button, x, y
		end
	else
		event, a1, a2, a3, a4 , a5, a6 = coroutine.yield( _sFilter )
		if event == "mouse_click" then
			a3 = a3 - 1
			return event, a1, a2, a3, a4, a5, a6
		else
			return event, a1, a2, a3, a4, a5, a6
		end
	end
end
--Password protection
function getConfig()
	cfgHandle = settings.openSettingsFile("TwoOS/config.cfg")
	username = cfgHandle.getSectionedValue("login", "username")
	password = cfgHandle.getSectionedValue("login", "password")
	passOnBoot = cfgHandle.getSectionedValue("login", "passOnBoot")
	_G.username = username
	_G.password = password
	_G.passOnBoot = passOnBoot
end

function requestPass()
	term.setBackgroundColor(colors.lightBlue)
	term.clear()
	term.setCursorPos(1,1)
	print(os.version())
	oldOSPullEvent = os.pullEvent
	os.pullEvent = os.pullEventRaw
	term.setCursorPos(2,5)
	print("Username:")
	term.setCursorPos(2,7)
	print("Password:")
	term.setCursorPos(2,6)
	term.setBackgroundColor(colors.blue)
	write("                             ")
	term.setCursorPos(2,8)
	write("                             ")
	term.setCursorPos(2,6)
	user = read()
	term.setCursorPos(2,8)
	pass = read("*")
	pass = SHA256util.sha256(pass)
	if _G.username == user then
		if password ~= pass then
			BSOD("Password Mismatch")
		end
	else
		BSOD("Username Mismatch")
	end
	os.pullEvent = oldOSPullEvent
end
--Functions to draw desktop
BSOD = function(error)
	--bsod made by logsys..
	--feel free to use in your programs and edit it, but keep my name in it
	term.setBackgroundColor(colors.blue)
	term.setTextColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
	print("An error has occurred and the computer has to shutdown.")
	print("")
	print("The error is:")
	print(error)
	print("")
	print("If you modified this program, revert it to the default program")
	print("")
	print("Thanks for using TwoOS")
	print("")
	print("Memory dump progress: 100%")
	sleep(5)
	os.reboot()
end
function drawBackground()
	h = paintutils.loadImage("TwoOS/backgroundMain")
	paintutils.drawImage(h,5,1)
end

function drawBar()
	term.setCursorPos(1,1)
	term.setBackgroundColor(colors.cyan)
	term.setTextColor(colors.white)
	term.write("[TwoOS]                                                       ")-- .. drawCurrentPrograms())
end

function drawCurrentPrograms()
	runProg = {}
	for i = 1,3 do
		term.write(runProg[i] .. " ")
	end
end
function showAbout()
	term.setTextColor(colors.yellow)
	term.setBackgroundColor(colors.gray)
	term.clear()
	term.setCursorPos(1,1)
	print[[Welcome to TwoOS
	TwoOS is an OS made by logsys to replace LogOS
	Some features are replaced and not available]]
	print("Press any key to continue")
	coroutine.yield("char")
end
function drawDesktop()
	term.setBackgroundColor(colors.white)
	term.clear()
	drawBackground()
	drawBar()
end
--functions to draw menu
function drawMenu()
	term.setCursorPos(1,2)
	term.setBackgroundColor(colors.gray)
	term.setTextColor(colors.yellow)
	print("Shell       ")
	print("File Manager")
	print("============")
	print("Shutdown    ")
	print("Reboot      ")
	print("============")
	print("About       ")
end
--functions to run the programs
runProg = function(program, ...)
	x, y = term.getSize()
	term.setCursorPos(9,1)
	term.setBackgroundColor(colors.cyan)
	term.setTextColor(colors.white)
	term.write("          ")
	term.setCursorPos(9,1)
	term.write(fs.getName(program))
	nWindow1 = window.create(term.current(), 1,2,x,y-1, true)
	term.redirect(nWindow1)
	os.run({},program)
	term.redirect(term.native())
	nWindow1.setVisible(false)
end
--function to shutdown or reboot
function takeDown( _action )
	action = _action or "shutdown"
	term.setBackgroundColor(colors.gray)
	term.setTextColor(colors.yellow)
	term.clear() term.setCursorPos(1,1)
	print[[Thanks for using TwoOS
	Made by logsys]]
	term.setCursorPos(2, 3)
	print("Unloading APIs")
	term.setCursorPos(2, 4)
	term.setBackgroundColor(colors.green)
	term.write("                                                 ")
	term.setCursorPos(2, 4)
	term.setBackgroundColor(colors.lime)
	function printAction() if action == "shutdown" then return "Shutting Down..." else return "Rebooting..." end end
	textutils.slowPrint("                                                 ")
	term.setBackgroundColor(colors.gray)
	term.setTextColor(colors.yellow)
	print("Completed... " .. printAction())
	sleep(2)
	if action == "shutdown" then os.shutdown() else os.reboot() end
end
--get clicks and draw menus
function mainFunc()
	getConfig()
	if passOnBoot then requestPass() end
	drawDesktop()
	while true do
		event, button, x, y = coroutine.yield("mouse_click")
		if not printed then
			if button == 1 then
				if y == 1 then
					if x >= 1 and x <= 7 then
						drawMenu()
						printed = true
					end
				end
			end
		else
			if x >= 1 and x <= 12 then
				if y == 2 then
					runProg("rom/programs/advanced/multishell")
					printed = false
					drawDesktop()
				elseif y == 3 then
					runProg("Programs/FileMan.lua")
					printed = false
					drawDesktop()
				elseif y == 5 then
					takeDown("shutdown")
				elseif y == 6 then
					takeDown("reboot")
				elseif y == 7 then
					showAbout()
					printed = false
				end
			end
		end
	end
end

ok, err = pcall(mainFunc)
if not ok then
	BSOD(err)
end