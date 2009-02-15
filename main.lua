-- Jaga musen!

function load()
	
	world = love.physics.newWorld(640, 480)
	
	chaser = love.physics.newBody(world, 300, 400)
	chaper = love.physics.newCircleShape(chaser, 15)
	chaser:setMassFromShapes()
	
	chased = love.physics.newBody(world, 400, 300)
	chaped = love.physics.newCircleShape(chased, 15)
	chased:setMassFromShapes()
	
	mouseX = -1
	mouseY = -1
	
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
	
	speed = 300
	
	chaserImg = love.graphics.newImage("chaser.png")
	chasedImg = love.graphics.newImage("chased.png")
end

function update(dt)
	world:update(dt)

	mouseX, mouseY = love.mouse.getPosition()
	
	deltaX = mouseX - chaserX
	deltaY = mouseY - chaserY
	deltdX = mouseX - chasedX
	deltdY = mouseY - chasedY
	
	hypotenuse = (deltaY^2 + deltaX^2)^0.5
	hypotenusd = (deltdY^2 + deltdX^2)^0.5
	
	chaserX = chaserX + deltaX * speed * dt / hypotenuse
	chaserY = chaserY + deltaY * speed * dt / hypotenuse
	
	chasedX = chasedX - deltdX * speed * dt / hypotenusd
	chasedY = chasedY - deltdY * speed * dt / hypotenusd
	
	chaser:applyForce(chaserX, chaserY)
	chased:applyForce(chasedX, chasedY)
end

function draw()
	love.graphics.draw(chaserImg, chaserX, chaserY)
	love.graphics.draw(chasedImg, chasedX, chasedY)
	love.graphics.draw(chaserImg, chaser:getX(), chaser:getY(), chaser:getAngle())
	love.graphics.draw(chasedImg, chased:getX(), chased:getY(), chased:getAngle())
end