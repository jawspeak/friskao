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

local wheelbarrow = display.newImage( "wheelbarrow.png", 0, 200 )
wheelbarrow.name = "wheelbarrow"
physics.addBody( wheelbarrow, "static", { friction=0.3, bounce=0.1, shape={-40,-30, 40,-30, 40,20, -40,20}})

local ground = display.newImage( "grass.png", 0, 300, true )
physics.addBody( ground, "static", { friction=0.5, bounce=0.9, shape={-240,-10, 240,-10, 240,10, -240,10}})

pointCounter = display.newText("0", 10, 10, "Helvetica", 24)

heads = {}
heads[0] = 'kao1_50x50.png'
heads[1] = 'jon1_50x50.png'
heads[2] = 'nan1_50x50.png'
heads[3] = 'damon1_50x50.png'
heads[4] = 'kao2_50x50.png'
heads[5] = 'jon2_50x50.png'
heads[6] = 'nan2_50x50.png'
heads[7] = 'damon2_50x50.png'

function randomFace()
	return heads[math.random(4)]
end

local balls = {}
local randomBall = function()
	local ball
	ball = display.newImage(randomFace())
	ball.x = 40 + math.random( 380 ); ball.y = -40
	physics.addBody( ball, { density=0.6, friction=0.6, bounce=0.9, radius=29 } )
	ball.angularVelocity = math.random(800) - 400
	ball.isSleepingAllowed = false
        ball.name = "head"

	balls[#balls + 1] = ball
end
timer.performWithDelay( 750, randomBall, 50 )

sounds = {}
sounds[0] = audio.loadSound("freesoundpongblip1_ogg.ogg");
sounds[1] = audio.loadSound("freesoundpongblip2_ogg.ogg");
sounds[2] = audio.loadSound("freesoundpongblip3_ogg.ogg");
powerUpSound = audio.loadSound("powerup.wav")

local function getWheelbarrow( collisionEvent )
   if (collisionEvent.object1.name == "wheelbarrow") then
      return collisionEvent.object1
   elseif ( collisionEvent.object2.name == "wheelbarrow") then 
      return collisionEvent.object2
   end
   return nil
end

local function getHead( collisionEvent )
   if (collisionEvent.object1.name == "head") then 
      return collisionEvent.object1
   elseif (collisionEvent.object2.name == "head") then
      return collisionEvent.object2
   end
   return nil
end

local function onCollision( event )
   if (event.phase == "ended") then
      wheelbarrow = getWheelbarrow(event)

      if ( wheelbarrow ) then
         head = getHead(event)
         head:removeSelf()
         audio.play(powerUpSound)

         local points = tonumber(pointCounter.text)
         pointCounter.text = (points + 1)
         return
      end
   end

   if (event.phase == "began") then
      audio.play(sounds[math.random(3)]);
   end
end

local function onTouch( event )
   local wheelbarrow = event.target
   if (event.phase == "moved") then 
      wheelbarrow.x = event.x
   end
end

wheelbarrow:addEventListener( "touch", onTouch)
Runtime:addEventListener( "collision", onCollision )
