-- Jagad!

function load()
	deltaX, deltaY, mouseX, mouseY = -1, -1, -1, -1
	
	chaserSpeed = 100
	chasedSpeed = 200
	
	chaserImg = love.graphics.newImage("chaser.png")
	chasedImg = love.graphics.newImage("chased.png")
	
	font = love.graphics.newFont(love.default_font, 14)
	loseFont = love.graphics.newFont(love.default_font, 40)
	miniFont = love.graphics.newFont(love.default_font, 7)
	
	restartGame()
end

function update(dt)
	timePassed = timePassed + dt
	
	if hypotenuse < 15 then
		if gameOver == false then
			endTime = timePassed
		end
		gameOver = true
	else
		checkMouse(dt)
		boundingBox()
		chaseDist(dt)
	end
end

function draw()
	if gameOver then
		love.graphics.setFont(loseFont)
		love.graphics.draw("YOU LOSE!!!", 175, 230)
		love.graphics.setFont(font)
		love.graphics.drawf("You survived for "..math.floor(endTime).." seconds. That's not good enough for a place in the high-score list*.\n\nPress any key to try again.", 175, 250, 280)
		love.graphics.setFont(miniFont)
		love.graphics.draw("*Partly because there isn't any.", 515, 475)
	else
		love.graphics.draw(chaserImg, chaserX, chaserY)
		love.graphics.draw(chasedImg, chasedX, chasedY)
		love.graphics.draw("You have survived for "..math.floor(timePassed).." seconds. So far...", 10, 20)
		
--		love.graphics.draw(chaserImg, chaser:getX(), chaser:getY(), chaser:getAngle())
--		love.graphics.draw(chasedImg, chased:getX(), chased:getY(), chased:getAngle())
	end
end

function chaseDist(dt)
	deltaX = chasedX - chaserX
	deltaY = chasedY - chaserY
	
	hypotenuse = (deltaY^2 + deltaX^2)^0.5 -- Calculate the distance between chaser and chased
    
	chaserX = chaserX + deltaX * chaserSpeed * dt / hypotenuse -- Move chaser toward chased x-
	chaserY = chaserY + deltaY * chaserSpeed * dt / hypotenuse -- and y-wise
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

function boundingBox()
	if chasedY < 40 then chasedY = 40 end
	if chasedY > 465 then chasedY = 465 end
	if chasedX < 15 then chasedX = 15 end
	if chasedX > 625 then chasedX = 625 end
end

function keypressed(key)
	if gameOver and (timePassed - endTime) >= 3 then
		restartGame()
	end
end

function restartGame()
	timePassed = 0
	gameOver = false
	endTime = 0

	chaserX = 40
	chaserY = 65
	chasedX = 600
	chasedY = 440

	hypotenuse = 16
	
	love.graphics.setFont(font)
end