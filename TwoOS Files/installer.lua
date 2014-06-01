--Installer
reqFiles = {
	["gui.lua"] = {["location"] = "https://raw.githubusercontent.com/logsys11/TwoOS_Beta/master/TwoOS%20Files/TwoOS/gui.lua", ["dir"] = "TwoOS/gui.lua"},
	["SHA256"] = {["location"] = "https://raw.githubusercontent.com/logsys11/TwoOS_Beta/master/TwoOS%20Files/TwoOS/APIs/SHA256util", ["dir"] = "TwoOS/APIs/SHA256util"},
	["settings"] = {["location"] = "https://raw.githubusercontent.com/logsys11/TwoOS_Beta/master/TwoOS%20Files/TwoOS/APIs/settings", ["dir"] = "TwoOS/APIs/settings"},
	["background"] = {["location"] = "https://raw.githubusercontent.com/logsys11/TwoOS_Beta/master/TwoOS%20Files/TwoOS/backgroundMain", ["dir"] = "TwoOS/backgroundMain"},
	["filemanager"] = {["location"] = "https://raw.githubusercontent.com/logsys11/TwoOS_Beta/master/TwoOS%20Files/TwoOS/Programs/FileMan.lua", ["dir"] = "Programs/FileMan.lua"},
	["filemanagerbackground"] = {["location"] = "https://raw.githubusercontent.com/logsys11/TwoOS_Beta/master/TwoOS%20Files/TwoOS/Programs/FB/fBk", ["dir"] = "Programs/FB/fBk"}
}

function reqDirectories()
	fs.makeDir("TwoOS")
	fs.makeDir("TwoOS/APIs")
	fs.makeDir("Programs")
	fs.makeDir("Programs/FB")
end

function downloadFiles()
	handle = http.get(reqFiles["gui.lua"]["location"])
	handle1 = fs.open(reqFiles["gui.lua"]["dir"],"w")
	handle1.write(handle.readAll())
	handle.close() handle1.close()
	print("GUI Downloaded")
	--SHA
	handle = http.get(reqFiles["SHA256"]["location"])
	handle1 = fs.open(reqFiles["SHA256"]["dir"],"w")
	handle1.write(handle.readAll())
	handle.close() handle1.close()
	print("SHA256 Downloaded")
	--settings
	handle = http.get(reqFiles["settings"]["location"])
	handle1 = fs.open(reqFiles["settings"]["dir"],"w")
	handle1.write(handle.readAll())
	handle.close() handle1.close()
	print("Settings Downloaded")
	--background
	handle = http.get(reqFiles["background"]["location"])
	handle1 = fs.open(reqFiles["background"]["dir"],"w")
	handle1.write(handle.readAll())
	handle.close() handle1.close()
	print("Background Downloaded")
	--File Manager
	handle = http.get(reqFiles["filemanager"]["location"])
	handle1 = fs.open(reqFiles["filemanager"]["dir"],"w")
	handle1.write(handle.readAll())
	handle.close() handle1.close()
	print("File manager Downloaded")
	--filemanagerbackground
	handle = http.get(reqFiles["filemanagerbackground"]["location"])
	handle1 = fs.open(reqFiles["filemanagerbackground"]["dir"],"w")
	handle1.write(handle.readAll())
	handle.close() handle1.close()
	print("File Manager Background Downloaded")
	--create config
	handle1 = fs.open("TwoOS/config.cfg","w")
	handle1.close()
	print("Config File Created.. Passing to config mode...")
end

function writeSettings(username, password, passOnBoot)
	os.loadAPI("TwoOS/APIs/settings")
	cfgHandle = settings.openSettingsFile("TwoOS/config.cfg")
	cfgHandle.addSection("login")
	cfgHandle.setSectionedValue("login", "username", username)
	cfgHandle.setSectionedValue("login", "password", password)
	cfgHandle.setSectionedValue("login", "passOnBoot", passOnBoot)
	cfgHandle.save("TwoOS/config.cfg")
end

function getValues()
	os.loadAPI("TwoOS/APIs/SHA256util")
	term.setBackgroundColor(colors.blue)
	term.setTextColor(colors.white)
	term.clear()
	term.setCursorPos(1,1)
	print("TwoOS Installation")
	term.write("/////////////////////////////////////////////////////////")
	print("Press any key to continue...")
	coroutine.yield("key")
	term.setBackgroundColor(colors.blue)
	term.setTextColor(colors.white)
	term.setCursorPos(1,1)
	term.clear()
	print("TwoOS Installation - Downloading Required Files...")
	term.write("/////////////////////////////////////////////////////////")
	print("")
	reqDirectories()
	downloadFiles()
	term.setBackgroundColor(colors.blue)
	term.setTextColor(colors.white)
	term.setCursorPos(1,1)
	term.clear()
	print("TwoOS Installation - Configuration Mode...")
	term.write("/////////////////////////////////////////////////////////")
	print("")
	write("Username: ")
	username = read()
	write("Password: ")
	password = read("*")
	write("Password Again")
	passworda = read("*")
	if password ~= passworda then BSOD("Password Mismatch") end
	write("Request Password On Boot?(Y/N)")
	event, passOnBootChar = coroutine.yield("char")
	if passOnBootChar == "y" or passOnBootChar == "Y" then
		passOnBoot = "true"
	else
		passOnBoot = "false"
	end
	writeSettings(username, SHA256util.sha256(password), passOnBoot)
	term.setBackgroundColor(colors.blue)
	term.setTextColor(colors.white)
	term.setCursorPos(1,1)
	term.clear()
	print("TwoOS Installation - Finishing touches...")
	term.write("/////////////////////////////////////////////////////////")
	print("")
	print("Done! To  run the OS, run TwoOS/gui.lua")
	sleep(2)
	os.reboot()
end

getValues()