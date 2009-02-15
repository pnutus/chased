-- Jagad!

function load()
	
	world = love.physics.newWorld(640, 480)
	
	chaser = love.physics.newBody(world, 300, 400)
	chaper = love.physics.newCircleShape(chaser, 15)
	chaser:setMassFromShapes()
	
	chased = love.physics.newBody(world, 400, 300)
	chaped = love.physics.newCircleShape(chased, 15)
	chased:setMassFromShapes()
	
	chaserX = 0
	chaserY = 0
	chasedX = 400
	chasedY = 300
	
	deltaX = -1
	deltaY = -1
	deltdX = -1
	deltdY = -1
	hypotenuse = -1
	hypotenusd = -1
	
	chaserSpeed = 100
	chasedSpeed = 200
	
	timePassed = 0,1
	gameOver = false
	endTime = 0
	
	chaserImg = love.graphics.newImage("chaser.png")
	chasedImg = love.graphics.newImage("chased.png")
	
	loseFont = love.graphics.newFont(love.default_font, 40)
	font = love.graphics.newFont(love.default_font, 14)
	miniFont = love.graphics.newFont(love.default_font, 7)
	love.graphics.setFont(font)
end

function update(dt)
	timePassed = timePassed + dt
	
	
		mouseX, mouseY = love.mouse.getPosition()
		
		deltaX = chasedX - chaserX
		deltaY = chasedY - chaserY
		
		hypotenuse = (deltaY^2 + deltaX^2)^0.5
    	
		chaserX = chaserX + deltaX * chaserSpeed * dt / hypotenuse
		chaserY = chaserY + deltaY * chaserSpeed * dt / hypotenuse
		
		chaser:applyForce(chaserX, chaserY)
		chased:applyForce(chasedX, chasedY)
		
	if hypotenuse < 10 then
		if gameOver == false then
			endTime = timePassed
		end
		gameOver = true
	else
		world:update(dt)
		
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
		
		if (chasedY - chasedX) ~= (chasedSpeed * dt) then
			
		end
	end
end

function draw()
	if gameOver then
		love.graphics.setFont(loseFont)
		love.graphics.draw("YOU LOSE!!!", 150, 240)
		love.graphics.setFont(font)
		love.graphics.drawf("You survived for "..math.floor(endTime).." seconds. Not good enough for a place in the high-score list*.", 150, 275, 300)
		love.graphics.setFont(miniFont)
		love.graphics.draw("*Partly because there isn't any.", 510, 475)
	else
		love.graphics.draw("You have survived for "..math.floor(timePassed).." seconds. So far...", 10, 20)
		love.graphics.draw(chaserImg, chaserX, chaserY)
		love.graphics.draw(chasedImg, chasedX, chasedY)
--		love.graphics.draw(chaserImg, chaser:getX(), chaser:getY(), chaser:getAngle())
--		love.graphics.draw(chasedImg, chased:getX(), chased:getY(), chased:getAngle())
	end
end