/*
 * Gamepad API Test
 * Written in 2013 by Ted Mielczarek <ted@mielczarek.org>
 *
 * To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
var haveEvents = 'GamepadEvent' in window;
var haveWebkitEvents = 'WebKitGamepadEvent' in window;
var controllers = {};
// Previously held states of the different 4 directional buttons
var keyStates = {7:false, 12: false, 13: false, 14: false, 15: false};
var press = false;
var rAF = window.mozRequestAnimationFrame ||
  window.webkitRequestAnimationFrame ||
  window.requestAnimationFrame;

// Callback function that is invoked the moment we connect a controller (And thereafter I guess).
function connecthandler(e)
{
	// Pass in the gamepad object that the API has so nicely created for us.
  addgamepad(e.gamepad);
}

function buttonpresshandler(keycode, pressed)
{
	if (pressed != keyStates[keycode])
	{
		if(pressed == true)
		{
			switch(keycode)
			{
			 case 12:
			 	$.post("/cmd", "forward", function(data,status){});
				break;
			 case 13:
			 	$.post("/cmd", "backward", function(data,status){});
				break;
			 case 14:
			 	$.post("/cmd", "turnleft", function(data,status){});
				break;
			 case 15:
			 	$.post("/cmd", "turnright", function(data,status){});
				break;
			case 7:
			 	$.post("/cmd", "movearm", function(data,status){});
				break;
			}
			keyStates[keycode] = pressed;
		}
		
		else
		{
			keyStates[keycode] = false;
		}
	}
}
function addgamepad(gamepad) 
{
	// I believe 'gamepad.index' is just an index of the gamepad we connected (In case you have multiple ones connected).
  controllers[gamepad.index] = gamepad; 
	rAF(updateStatus);
}

function disconnecthandler(e) 
{
  removegamepad(e.gamepad);
}

function removegamepad(gamepad) 
{
  delete controllers[gamepad.index];
}

function hasButtonKeyCode(value)
{
   hasCode = false;
   if(value in keyStates)
   {
      hasCode = true;
   }
   return hasCode;
}

function updateStatus() 
{
  scangamepads();
  for (j in controllers) 
	{
    var controller = controllers[j];
    for (var i = 0; i < controller.buttons.length; i++) 
		{
			var button = controller.buttons[i];
      var val = button;
      var pressed = val == 1.0;
      var touched = false;
      if (typeof(val) == "object") 
			{
        pressed = val.pressed;
      }

	if(hasButtonKeyCode(i))
	{
		buttonpresshandler(i, pressed);
	}
    }
	}
	
	rAF(updateStatus);
}

function scangamepads() 
{
  var gamepads = navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads() : []);
  for (var i = 0; i < gamepads.length; i++) 
	{
    if (gamepads[i] && (gamepads[i].index in controllers)) 
		{
      controllers[gamepads[i].index] = gamepads[i];
    }
  }
}


if (haveEvents) 
{
  window.addEventListener("gamepadconnected", connecthandler);
  window.addEventListener("gamepaddisconnected", disconnecthandler);
} 
else if (haveWebkitEvents) 
{
  window.addEventListener("webkitgamepadconnected", connecthandler);
  window.addEventListener("webkitgamepaddisconnected", disconnecthandler);
} 
else 
{
  setInterval(scangamepads, 500);
}
