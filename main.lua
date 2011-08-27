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
--physics.setDrawMode('hybrid')

display.setStatusBar( display.HiddenStatusBar )

local ground = display.newImage( "grass.png", 0, 300, true )
physics.addBody( ground, "static", { friction=0.5, bounce=0.9, shape={-240,-10, 240,-10, 240,10, -240,10}})

--local leftside = display.newSquare(0,0,100,100)
--physics.addBody( ground, "static", { friction=0.5, bounce=0.9, shape={-240,-10, 240,-10, 240,10, -240,10}})
 

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
	physics.addBody( ball, { density=0.6, friction=0.6, bounce=0.6, radius=29 } )
	ball.angularVelocity = math.random(800) - 400
	ball.isSleepingAllowed = false

	balls[#balls + 1] = ball
end

timer.performWithDelay( 750, randomBall, 24 )

sounds = {}
sounds[0] = audio.loadSound("freesoundpongblip1_ogg.ogg");
sounds[1] = audio.loadSound("freesoundpongblip2_ogg.ogg");
sounds[2] = audio.loadSound("freesoundpongblip3_ogg.ogg");
local function onCollision( event )
	if ( event.phase == "began" ) then
		audio.play(sounds[math.random(3)]);
	end
end
Runtime:addEventListener( "collision", onCollision )
