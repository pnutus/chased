-- Jagad!

function load()
	
	world = love.physics.newWorld(640, 480)
	
	chaser = love.physics.newBody(world, 300, 400)
	chaper = love.physics.newCircleShape(chaser, 15)
	chaser:setMassFromShapes()
	
	chased = love.physics.newBody(world, 400, 300)
	chaped = love.physics.newCircleShape(chased, 15)
	chased:setMassFromShapes()
	
	chaserX = 300
	chaserY = 400
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
	
	chaserImg = love.graphics.newImage("chaser.png")
	chasedImg = love.graphics.newImage("chased.png")
end

function update(dt)
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
	
	mouseX, mouseY = love.mouse.getPosition()
	
	deltaX = chasedX - chaserX
	deltaY = chasedY - chaserY
	
	hypotenuse = (deltaY^2 + deltaX^2)^0.5
	
	chaserX = chaserX + deltaX * chaserSpeed * dt / hypotenuse
	chaserY = chaserY + deltaY * chaserSpeed * dt / hypotenuse
	
	chaser:applyForce(chaserX, chaserY)
	chased:applyForce(chasedX, chasedY)
end

function draw()
	love.graphics.draw(chaserImg, chaserX, chaserY)
	love.graphics.draw(chasedImg, chasedX, chasedY)
--	love.graphics.draw(chaserImg, chaser:getX(), chaser:getY(), chaser:getAngle())
--	love.graphics.draw(chasedImg, chased:getX(), chased:getY(), chased:getAngle())
end