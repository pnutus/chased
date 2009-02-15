-- Chased!

function load()
	deltaX, deltaY, mouseX, mouseY = -1, -1, -1, -1
	
	chaserSpeed = 100
	chasedSpeed = 200
	
	chaserImg = love.graphics.newImage("chaser.png")
	chasedImg = love.graphics.newImage("chased.png")
	
	font = love.graphics.newFont(love.default_font, 14)
	bigFont = love.graphics.newFont(love.default_font, 40)
	smallFont = love.graphics.newFont(love.default_font, 7)
	
	restartGame()
	
	endTime = 0
	cheatControl = 6
	gameState = "begin"
	
	chaserSpeed = 100
	chasedSpeed = 200
end

function update(dt)
	timePassed = timePassed + dt
	
	if chaseDistance < 15 then
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
		love.graphics.drawf("You are a scared piece of shit. And you are being CHASED!\n\nMove with the arrow keys or W, A, S and D.\n\nAvoid the chaser at all costs*!\n\nPress any key to begin.", 175, 200, 280)
		love.graphics.setFont(smallFont)
		love.graphics.draw("*Cheat codes can be bought at our webstore.", 470, 475)
	elseif gameState == "running" then
		love.graphics.draw(chaserImg, chaserX, chaserY)
		love.graphics.draw(chasedImg, chasedX, chasedY)
		love.graphics.setFont(font)
		love.graphics.draw("You have survived for "..math.floor(timePassed).." seconds. So far...", 10, 20)
	elseif gameState == "game over" then
		love.graphics.setFont(bigFont)
		love.graphics.draw("YOU LOSE!!!", 175, 230)
		love.graphics.setFont(font)
		love.graphics.drawf("You survived for "..math.floor(endTime).." seconds. That's not good enough for a place in the high-score list*.\n\nPress any key to try again.", 175, 250, 280)
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
	  
	  hypotenuse = (deltaY^2 + deltaX^2)^0.5 -- Calculate the distance between chaser and chased
      
	  chasedX = chasedX + deltaX * chasedSpeed * dt / hypotenuse -- Move chaser toward chased x-
	  chasedY = chasedY + deltaY * chasedSpeed * dt / hypotenuse -- and y-wise
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
	if chasedY < 40 then chasedY = 40 end
	if chasedY > 465 then chasedY = 465 end
	if chasedX < 15 then chasedX = 15 end
	if chasedX > 625 then chasedX = 625 end
end

function keypressed(key)
	if gameState == "game over" and (timePassed - endTime) > 1 then
		restartGame()
	elseif gameState == "begin" then
		gameState = "running"
	end
	if love.keyboard.isDown(love.key_rshift) or love.keyboard.isDown(love.key_lshift) then
		if key == love.key_r then
			restartGame()
		end
		if key == love.key_q then
			if cheatControl > 5 then
				timePassed = timePassed + 100
				cheatControl = 0
			end
		end
		
		-- Pulls up an error, so we can restart.
		if key == love.key_z then
			bajs()
		end
	end
end

function restartGame()
	gameState = "running"

	timePassed = 0
	cheatControl = 6

	chasedX = 40
	chasedY = 65
	chaserX = 600
	chaserY = 440

	chaseDistance = 16
end