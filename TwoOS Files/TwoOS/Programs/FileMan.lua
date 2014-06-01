--functions
currentPath = "/"
local function printBackground()
	term.setBackgroundColor(colors.white)
	term.clear()
	local bkg = paintutils.loadImage("/Programs/FB/fBk")
	paintutils.drawImage(bkg, 1,1)
	term.setCursorPos(1,1)
	term.setBackgroundColor(colors.red)
	term.write("X")
	term.setBackgroundColor(colors.gray)
	term.write("File Browser: " .. currentPath .. "                                   ")
	term.setCursorPos(1,2)
	term.setBackgroundColor(colors.lightGray)
	term.write("[Back]             ")
end

local function processFolder( sPath )
	local fileHandle = fs.list(sPath)
	local dirInCPath = {}
	local fileInCPath = {}
	if sPath == "/" then
		for i = 1,#fileHandle do
			if fs.isDir(fileHandle[i]) and fileHandle[i] ~= "rom"then
				dirInCPath[#dirInCPath+1] = fileHandle[i]
			elseif not fs.isDir(fileHandle[i]) then
				fileInCPath[#fileInCPath+1] = fileHandle[i]
			end
		end
	else
		for i = 1,#fileHandle do
			if fs.isDir(sPath .. "/" .. fileHandle[i]) then
				dirInCPath[#dirInCPath+1] = fileHandle[i]
			else
				fileInCPath[#fileInCPath+1] = fileHandle[i]
			end
		end
	end
	return dirInCPath, fileInCPath
end

local function filePlacement( dirs , files)
	y = 4
	for i = 1,#dirs do
		term.setCursorPos(2,y)
		print(dirs[i])
		y = y + 1
	end
	y = 4
	for i = 1, #files do
		term.setCursorPos(13,y)
		print(files[i])
		y = y+1
	end
end

printBackground()
dirs, files = processFolder(currentPath)
filePlacement(dirs,files)

while true do
	event, button, x, y = os.pullEvent("mouse_click")
	if button == 1 then
		if x == 1 and y == 1 then
			return
		elseif x >=1 and x<= 5 and y == 2 then
			currentPath = "/"
			printBackground()
			dirs = nil
			files = nil
			dirs,files = processFolder(currentPath)
			filePlacement(dirs, files)
		elseif x >= 2 and x <= 9 and y >= 4 then
			if table.maxn(dirs) >= y-3 then
				currentPath = string.sub(currentPath,2,#currentPath) .. "/" .. dirs[y-3]
				printBackground()
				dirs = nil
				files = nil
				dirs,files = processFolder(currentPath)
				filePlacement(dirs, files)
			end
		elseif x >= 11 and x <= 28 and y >= 4 then
			if table.maxn(files) >= y-3 then
				shell.run(currentPath .. "/" .. files[y-3])
				term.setTextColor(colors.white)
				currentPath = "/"
				printBackground()
				dirs = nil
				files = nil
				dirs,files = processFolder(currentPath)
				filePlacement(dirs, files)
			end
		end
	else
		if y >= 4 then
			if x >= 2 and x <= 9 then
				if table.maxn(dirs) >= y-3 then
					local selD = dirs[y-3]
					term.setBackgroundColor(colors.gray)
					term.setCursorPos(x,y)
					sY = y + 1
					print("Rename")
					term.setCursorPos(x,sY)
					print("Delete")
					event, button, xx, yy = os.pullEvent("mouse_click")
					if xx >=x and xx <= x+6 and yy == y then
						term.clear()
						term.setCursorPos(2,2)
						print("Renaming directory: " .. selD)
						term.setCursorPos(2,3)
						write("Target Name: ")
						newName = read() or selD
						fs.move(selD, newName)
						currentPath = "/"
						printBackground()
						dirs = nil
						files = nil
						dirs,files = processFolder(currentPath)
						filePlacement(dirs, files)
					elseif xx >=x and xx <= x+6 and yy == y+1 then
						fs.delete(selD)
						currentPath = "/"
						printBackground()
						dirs = nil
						files = nil
						dirs,files = processFolder(currentPath)
						filePlacement(dirs, files)
					else
						currentPath = "/"
						printBackground()
						dirs = nil
						files = nil
						dirs,files = processFolder(currentPath)
						filePlacement(dirs, files)
					end
				else
					term.setBackgroundColor(colors.gray)
					term.setCursorPos(x,y)
					print("New Folder")
					event, button, xx, yy = os.pullEvent("mouse_click")
					if xx >= x and xx <= 9 and yy==y then
						term.clear()
						term.setCursorPos(2,2)
						write("Directory name: ")
						newName = read()
						if newName ~= nil then
							fs.makeDir(currentPath .. "/" .. newName)
							
						end
						currentPath = "/"
						printBackground()
						dirs = nil
						files = nil
						dirs,files = processFolder(currentPath)
						filePlacement(dirs, files)
					else
						currentPath = "/"
						printBackground()
						dirs = nil
						files = nil
						dirs,files = processFolder(currentPath)
						filePlacement(dirs, files)
					end
				end
			elseif x >= 11 and x <= 28 then
				term.setCursorPos(x,y)
				term.setBackgroundColor(colors.gray)
				selF = files[y-3]
				print("Delete")
				event, button, xx, yy = os.pullEvent("mouse_click")
				if xx >=x and xx <= x+6 and yy == y then
					fs.delete(selF)
				end
			end
			term.setTextColor(colors.white)
			currentPath = "/"
			printBackground()
			dirs = nil
			files = nil
			dirs,files = processFolder(currentPath)
			filePlacement(dirs, files)
		end
	end
end