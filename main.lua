-- Chased!

function load()
	chaserImg = love.graphics.newImage("chaser.png")
	chasedImg = love.graphics.newImage("chased.png")
	
	font = love.graphics.newFont(love.default_font, 14)
	bigFont = love.graphics.newFont(love.default_font, 40)
	smallFont = love.graphics.newFont(love.default_font, 7)
	
	restartGame("begin")
	
	deltaX, deltaY, mouseX, mouseY = -1
	mouseDistance, endTime = 0

	chaserSpeed = 100
	chasedSpeed = 200
end

function update(dt)
	timePassed = timePassed + dt
	
	if chaseDistance < 30 then
		if gameState ~= "game over" then
			endTime = timePassed
		end
		gameState = "game over"
	elseif gameState == "running" then
		cheatControl = cheatControl + dt
		checkMouse(dt)
		checkArrowKeys(dt)
		boundingBox()
		chaserControl(dt)
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
		love.graphics.draw(chaserImg, chaserX, chaserY)
		love.graphics.draw(chasedImg, chasedX, chasedY)
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
	deltaX = chasedX - chaserX
	deltaY = chasedY - chaserY
	
	chaseDistance = (deltaY^2 + deltaX^2)^0.5 -- Calculate the distance between chaser and chased
    
	chaserX = chaserX + deltaX * chaserSpeed * dt / chaseDistance -- Move chaser toward chased x-
	chaserY = chaserY + deltaY * chaserSpeed * dt / chaseDistance -- and y-wise
end

function checkMouse(dt)
	if love.mouse.isDown(love.mouse_left) then
	  mouseX, mouseY = love.mouse.getPosition()
	
	  deltaX = mouseX - chasedX
	  deltaY = mouseY - chasedY
	  
	  mouseDistance = (deltaY^2 + deltaX^2)^0.5 -- Calculate the distance between chased and mouse
      
	  chasedX = chasedX + deltaX * chasedSpeed * dt / mouseDistance -- Move chased toward mouse x-
	  chasedY = chasedY + deltaY * chasedSpeed * dt / mouseDistance -- and y-wise
  end
end

function checkArrowKeys(dt)
	if love.keyboard.isDown(love.key_left) or love.keyboard.isDown(love.key_a) then
		chasedX = chasedX - chasedSpeed * dt
	end
	if love.keyboard.isDown(love.key_right) or love.keyboard.isDown(love.key_d) then
		chasedX = chasedX + chasedSpeed * dt
	end
	if love.keyboard.isDown(love.key_up) or love.keyboard.isDown(love.key_w) then
		chasedY = chasedY - chasedSpeed * dt
	end
	if love.keyboard.isDown(love.key_down) or love.keyboard.isDown(love.key_s) then
		chasedY = chasedY + chasedSpeed * dt
	end
end

function boundingBox()
	if chasedX < 15 then chasedX = 15 end
	if chasedX > (love.graphics.getWidth() - 15) then chasedX = (love.graphics.getWidth() - 15) end
	if chasedY < 40 then chasedY = 40 end
	if chasedY > (love.graphics.getHeight() - 15) then chasedY = (love.graphics.getHeight() - 15) end	
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

	chasedX = 40
	chasedY = 65
	chaserX = love.graphics.getWidth() - 40
	chaserY = love.graphics.getHeight() - 40

	chaseDistance = 31
end