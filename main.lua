-- Jagad!

function load()
	restartGame()
	
	deltaX = -1
	deltaY = -1
	
	chaserSpeed = 100
	chasedSpeed = 200
	
	chaserImg = love.graphics.newImage("chaser.png")
	chasedImg = love.graphics.newImage("chased.png")
	
	loseFont = love.graphics.newFont(love.default_font, 40)
	font = love.graphics.newFont(love.default_font, 14)
	miniFont = love.graphics.newFont(love.default_font, 7)
	love.graphics.setFont(font)
end

function update(dt)
	timePassed = timePassed + dt
	
	if hypotenuse < 15 then
		if gameOver == false then
			endTime = timePassed
		end
		gameOver = true
	else
		checkArrowKeys()
		boundingBox()
		chaseDist()
	end
end

function draw()
	if gameOver then
		love.graphics.setFont(loseFont)
		love.graphics.draw("YOU LOSE!!!", 175, 230)
		love.graphics.setFont(font)
		love.graphics.drawf("You survived for "..math.floor(endTime).." seconds. That's not good enough for a place in the high-score list*.\nPress any key to try again.", 175, 250, 280)
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

function chaseDist()
	deltaX = chasedX - chaserX
	deltaY = chasedY - chaserY
	
	hypotenuse = (deltaY^2 + deltaX^2)^0.5 -- Calculate the distance between chaser and chased
    
	chaserX = chaserX + deltaX * chaserSpeed * dt / hypotenuse -- Move chaser toward chased x-
	chaserY = chaserY + deltaY * chaserSpeed * dt / hypotenuse -- and y-wise
end

function checkKeys()
	if love.keyboard.isDown(love.key_left) then
		chasedX = chasedX - chasedSpeed * dt
	end
	if love.keyboard.isDown(love.key_right) then
		chasedX = chasedX + chasedSpeed * dt
	end
	if love.keyboard.isDown(love.key_up) then
		chasedY = chasedY - chasedSpeed * dt
	end
	if love.keyboard.isDown(love.key_down) then
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
	if gameOver and (timePassed - endtime) >= 10
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
end