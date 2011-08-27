-- 
-- Abstract: Bouncing ball (function listener) sample app (time-based animation)
--			 Drag the ball and flick it to bounce it off of the edges of the screen.
-- 
-- Version: 1.1
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------
local physics = require("physics")
physics.start()
physics.setGravity(0, 6)
-- physics.setDrawMode('hybrid')

display.setStatusBar( display.HiddenStatusBar )
local screenW, screenH = display.contentWidth, display.contentHeight
local friction = 0.8
local gravity = .09
local speedX, speedY, prevX, prevY, lastTime, prevTime = 0, 0, 0, 0, 0, 0

local ball = display.newCircle( 0, 0, 40)
ball:setFillColor(255, 255, 255, 166)
ball.x = screenW * 0.5
ball.y = ball.height

function onMoveCircle(event) 
	local timePassed = event.time - lastTime
	lastTime = lastTime + timePassed

	speedY = speedY + gravity

	ball.x = ball.x + speedX*timePassed
	ball.y = ball.y + speedY*timePassed

	if ball.x >= screenW - ball.width*.5 then
		ball.x = screenW - ball.width*.5
		speedX = speedX*friction
		speedX = speedX*-1 --change direction     
	elseif ball.x <= ball.width*.5 then
	    ball.x = ball.width*.5
		speedX = speedX*friction
		speedX = speedX*-1 --change direction     
	elseif ball.y >= screenH - ball.height*.5 then
		ball.y = screenH - ball.height*.5 
		speedY = speedY*friction
		speedX = speedX*friction
		speedY = speedY*-1  --change direction  
	elseif ball.y <= ball.height*.5 then
		ball.y = ball.height*.5
		speedY = speedY*friction
		speedY = speedY*-1 --change direction     
	end
end
	
-- A general function for dragging objects
local function startDrag( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
						
		-- Stop current motion, if any
		Runtime:removeEventListener("enterFrame", onMoveCircle)
		-- Start tracking velocity
		Runtime:addEventListener("enterFrame", trackVelocity)

	elseif t.isFocus then
		if "moved" == phase then
					
			t.x = event.x - t.x0
			t.y = event.y - t.y0

		elseif "ended" == phase or "cancelled" == phase then
			lastTime = event.time		

			Runtime:removeEventListener("enterFrame", trackVelocity)
			Runtime:addEventListener("enterFrame", onMoveCircle)

			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end

	-- Stop further propagation of touch event!
	return true
end

function trackVelocity(event) 
	local timePassed = event.time - prevTime
	prevTime = prevTime + timePassed
	
	speedX = (ball.x - prevX)/timePassed
	speedY = (ball.y - prevY)/timePassed

	prevX = ball.x
	prevY = ball.y
end			

function randomFace()
	choice = math.random(100)
	if (choice < 65) then
		return 'kao1_100x100.png'
	elseif (choice < 75) then
		return 'kao2_100x100.png'
	elseif (choice < 75) then
		return 'nan1_100x100.png'
	else
		return 'nan2_100x100.png'
	end
end

local balls = {}
local randomBall = function()
	local ball
	ball = display.newImage(randomFace())
	ball.x = 40 + math.random( 380 ); ball.y = -40
	physics.addBody( ball, { density=0.6, friction=0.6, bounce=0.6, radius=19 } )
	ball.angularVelocity = math.random(800) - 400
	ball.isSleepingAllowed = false

	balls[#balls + 1] = ball
end

timer.performWithDelay( 750, randomBall, 24 )

ball:addEventListener("touch", startDrag)
Runtime:addEventListener("enterFrame", onMoveCircle)
