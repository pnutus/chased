-- Chased!

function load()
	chaserImg = love.graphics.newImage("chaser.png")
	chasedImg = love.graphics.newImage("chased.png")
	
	font = love.graphics.newFont(love.default_font, 14)
	bigFont = love.graphics.newFont(love.default_font, 40)
	smallFont = love.graphics.newFont(love.default_font, 7)
	
	restartGame("begin")
	
	endTime = 0
end

function update(dt)
	timePassed = timePassed + dt
	
	if gameState == "running" then
		chaserSpeed = chaserSpeed + 10 * dt
		chasedSpeed = chaserSpeed * 2
		cheatControl = cheatControl + dt
		checkMouse(dt)
		checkArrowKeys(dt)
		boundingBox()
		chaserControl(dt)
		if chaseDistance < 30 then
			endTime = timePassed
			gameState = "game over"
		end
	else
		love.timer.sleep(20)
	end
end

function draw()
	if gameState == "begin" then
		love.graphics.setFont(bigFont)
		love.graphics.draw("CHASED!", 175, 180)
		love.graphics.setFont(font)
		love.graphics.drawf("You are a scared piece of shit. And you are being CHASED!\n\nMove with the arrow keys, W, A, S and D or click the mouse in the direction you want your avatar to move.\n\nAvoid the chaser at all costs*!\n\nPress any key or click the mouse to begin.", 175, 200, 280)
		love.graphics.setFont(smallFont)
		love.graphics.draw("*Cheat codes can be bought at our webstore.", 470, 475)
	elseif gameState == "running" then
		love.graphics.draw(chaserImg, chaserPos[1], chaserPos[2])
		love.graphics.draw(chasedImg, chasedPos[1], chasedPos[2])
		love.graphics.setFont(font)
		love.graphics.draw("You have survived for "..math.floor(timePassed).." seconds ... so far.", 10, 20)
	elseif gameState == "game over" then
		love.graphics.setFont(bigFont)
		love.graphics.draw("YOU LOSE!!!", 175, 230)
		love.graphics.setFont(font)
		love.graphics.drawf("You survived for "..math.floor(endTime).." seconds. That's not good enough for a place in the high-score list*.\n\nPress any key or click the mouse to try again.", 175, 250, 280)
		love.graphics.setFont(smallFont)
		love.graphics.draw("*Partly because there isn't any.", 515, 475)
	end
end

function chaserControl(dt)
	local delta = {chasedPos[1] - chaserPos[1], chasedPos[2] - chaserPos[2]}
	
	chaseDistance = (delta[2]^2 + delta[1]^2)^0.5 -- Calculate the distance between chaser and chased
    
	chaserPos[1] = chaserPos[1] + delta[1] * chaserSpeed * dt / chaseDistance -- Move chaser toward chased x-
	chaserPos[2] = chaserPos[2] + delta[2] * chaserSpeed * dt / chaseDistance -- and y-wise at chaserSpeed
end

function checkMouse(dt)
	if love.mouse.isDown(love.mouse_left) then
		local mousePos = {love.mouse.getPosition()}
		local delta = {mousePos[1] - chasedPos[1], mousePos[2] - chasedPos[2]}
		
		if (delta[1] == 0) and (delta[2] == 0) then -- mouseDistance cannot be 0 in the second equation
			return
		else
			local mouseDistance = (delta[2]^2 + delta[1]^2)^0.5 -- Calculate the distance between chased and mouse
			if mouseDistance > 2 then
				chasedPos[1] = chasedPos[1] + delta[1] * chasedSpeed * dt / mouseDistance -- Move chased toward mouse x-
				chasedPos[2] = chasedPos[2] + delta[2] * chasedSpeed * dt / mouseDistance -- and y-wise at chasedSpeed
			end
		end
  	end
end

function checkArrowKeys(dt)
	local keyDir = {0, 0}

	if love.keyboard.isDown(love.key_left) or love.keyboard.isDown(love.key_a) then
		keyDir[1] = keyDir[1] - 1
	end
	if love.keyboard.isDown(love.key_right) or love.keyboard.isDown(love.key_d) then
		keyDir[1] = keyDir[1] + 1
	end
	if love.keyboard.isDown(love.key_up) or love.keyboard.isDown(love.key_w) then
		keyDir[2] = keyDir[2] - 1
	end
	if love.keyboard.isDown(love.key_down) or love.keyboard.isDown(love.key_s) then
		keyDir[2] = keyDir[2] + 1
	end
	
	if (keyDir[1] == 0) and (keyDir[2] == 0) then -- keyDistance cannot be 0 in the second equation
		return
	else
		local keyDistance = (keyDir[2]^2 + keyDir[1]^2)^0.5 -- Calculate the distance between chased and the imaginary direction point
    	
		chasedPos[1] = chasedPos[1] + keyDir[1] * chasedSpeed * dt / keyDistance -- Move chased toward that point x-
		chasedPos[2] = chasedPos[2] + keyDir[2] * chasedSpeed * dt / keyDistance -- and y-wise at chasedSpeed
	end
end

function boundingBox()
	if chasedPos[1] < 15 then chasedPos[1] = 15 end
	if chasedPos[1] > (love.graphics.getWidth() - 15) then chasedPos[1] = (love.graphics.getWidth() - 15) end
	if chasedPos[2] < 40 then chasedPos[2] = 40 end
	if chasedPos[2] > (love.graphics.getHeight() - 15) then chasedPos[2] = (love.graphics.getHeight() - 15) end	
end

function keypressed(key)

	-- Combinations with shift
	if love.keyboard.isDown(love.key_rshift) or love.keyboard.isDown(love.key_lshift) then
		-- Shift + Q -- A cheat, only works every five seconds.
		if key == love.key_q then
			if cheatControl > 5 then
				timePassed = timePassed + 100
				cheatControl = 0
			end
		end
		
		-- Shift + R -- Hard restart, reloads code.
		if key == love.key_r then
			love.system.restart()
		end
		
		-- Shift + Esc -- Suspends the game
		if key == love.key_escape then
			love.system.suspend()
		end
	else -- Without shift
	
		-- Any key -- Continues from start and game-over screens. 
		if gameState == "game over" and (timePassed - endTime) > 1 then
			restartGame("running")
		elseif gameState == "begin" then
			restartGame("running")
		end
		
		-- Esc -- Exits the game.
		if key == love.key_escape then
			love.system.exit()
		end
		
		-- Restart -- Starts from starting screen.
		if key == love.key_r then
			restartGame("begin")
		end
	end
end

function mousepressed()

	-- Any button -- Continues from start and game-over screens.
	if gameState == "game over" and (timePassed - endTime) > 1 then
		restartGame("running")
	elseif gameState == "begin" then
		restartGame("running")
	end
end

function restartGame(state)
	gameState = state

	timePassed = 0
	cheatControl = 6

	chasedPos = {40, 65}
	chaserPos = {love.graphics.getWidth() - 40, love.graphics.getHeight() - 40}

	chaseDistance = 31
	
	chaserSpeed = 100
	chasedSpeed = 200
end