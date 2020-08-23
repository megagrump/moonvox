local mv = require('moonvox')

local function findSunvoxPath()
	-- auto detects the path to the sunvox player lib
	local paths = {
		x86 = {
			Linux    = 'sunvox_lib/linux/lib_x86/sunvox.so',
			--Linux    = 'sunvox_lib/linux/lib_x86/sunvox_lofi.so', -- Lo-Fi version for old PCs
			Windows  = 'sunvox_lib/windows/lib_x86/sunvox.dll',
			--Windows  = 'sunvox_lib/windows/lib_x86/sunvox_lofi.dll', -- Lo-Fi version for old PCs
			Android  = 'sunvox_lib/android/x86/libsunvox.so',
		},
		x64 = {
			Linux    = 'sunvox_lib/linux/lib_x86_64/sunvox.so',
			Windows  = 'sunvox_lib/windows/lib_x86_64/sunvox.dll',
			['OS X'] = 'sunvox_lib/macos/lib_x86_64/sunvox.dylib',
			Android  = 'sunvox_lib/android/x86_64/libsunvox.so',
		},
		arm = {
			--Linux    = 'sunvox_lib/linux/lib_arm_armel/sunvox.so', -- Linux armv6
			Linux    = 'sunvox_lib/linux/lib_arm_armhf_raspberry_pi/sunvox.so', -- Linux armv7a
			--Linux    = 'sunvox_lib/linux/lib_arm64/sunvox.so', -- Linux arm64
			Android  = 'sunvox_lib/android/sample_project/SunVoxLib/src/main/jniLibs/armeabi-v7a/libsunvox.so', -- Android armv7a
			--Android  = 'sunvox_lib/android/sample_project/SunVoxLib/src/main/jniLibs/arm64-v8a/libsunvox.so', -- Android arm64
		},
		-- TODO: add other architectures
	}

	local ffi = require('ffi')
	local arch = paths[ffi.arch] or error("Architecture " .. ffi.arch .. " not supported or not found")
	local os = love.system.getOS()
	local path = arch[os] or error(os .. " not supported or not found")
	return path
end

local pathToLib = findSunvoxPath()

mv.init(pathToLib) -- required at startup!

local player = assert(mv.newPlayer('sunvox_lib/resources/test.sunvox'))
player:setAutostop(true) -- songs play in loop by default
player:play()

function love.keypressed(key)
	if key == 'space' then
		if player:hasEnded() then
			player:play(true)
		else
			player:stop()
		end
	elseif key == 'escape' then
		love.event.quit()
	end
end

function love.draw()
	if not player:hasEnded() then
		love.graphics.print("Song is playing")
	else
		love.graphics.print("Song has ended")
	end
end

function love.quit()
	mv.deinit() -- required!
end
