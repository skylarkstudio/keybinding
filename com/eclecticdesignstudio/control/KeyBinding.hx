/**
 * Manages keyboard controls
 * @author Joshua Granick
 */


package com.eclecticdesignstudio.control;
	

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.Lib;


class KeyBinding {
	
	
	private static var initialized:Bool;
	private static var keyPressed:IntHash <Bool> = new IntHash <Bool> ();
	private static var pressBindings:IntHash <KeyBindingData> = new IntHash <KeyBindingData> ();
	private static var releaseBindings:IntHash <KeyBindingData> = new IntHash <KeyBindingData> ();
	
	
	/**
	 * Adds a new handler for when the specified key is pressed. Each key can only have one onPress handler
	 * @param	key		The key to listen for. Strings (like "k") and objects (like Keyboard.UP) are supported
	 * @param	handler		The function to call when the key has been pressed
	 * @param	handlerParams		(Optional) Parameters to apply to the handler function
	 * @param	repeat		Whether the handler should be repeatedly called as the key remains pressed
	 */
	public static function addOnPress (key:Dynamic, handler:Dynamic, repeat:Bool = false):Void {
		
		initialize ();
		
		if (Std.is (key, String)) {
			
			key = getKeyCode (key);
			
		}
		
		pressBindings.set (key, new KeyBindingData (key, handler, repeat));
		
	}
	
	
	/**
	 * Adds a new handler for when the specified key is released. Each key can only have one onRelease handler
	 * @param	key		The key to listen for. Strings (like "k") and objects (like Keyboard.UP) are supported
	 * @param	handler		The function to call when the key has been released
	 * @param	handlerParams		(Optional) Parameters to apply to the handler function
	 */
	public static function addOnRelease (key:Dynamic, handler:Dynamic):Void {
		
		initialize ();
		
		if (Std.is (key, String)) {
			
			key = getKeyCode (key);
			
		}
		
		releaseBindings.set (key, new KeyBindingData (key, handler));
		
	}
	
	
	public static function getKeyCode (key:String):Int {
		
		return key.toUpperCase ().charCodeAt (0);
		
	}
	
	
	/**
	 * Initializes the KeyBinding class
	 * @param	stage
	 */
	private static function initialize ():Void {
		
		if (!initialized) {
			
			Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, stage_onKeyDown);
			Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, stage_onKeyUp);
			
			initialized = true;
			
		}
		
	}
	
	
	/**
	 * Removes bindings for the specified key
	 * @param	key		The key to remove bindings for. Strings (like "k") and objects (like Keyboard.UP) are supported
	 */
	public static function remove (key:Int):Void {
		
		pressBindings.remove (key);
		releaseBindings.remove (key);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private static function stage_onKeyDown (event:KeyboardEvent):Void {
		
		var key = event.keyCode;
		
		if (pressBindings.exists (key)) {
			
			var data = pressBindings.get (key);
			
			if (data.repeat || !keyPressed.exists (key)) {
				
				Reflect.callMethod (data.handler, data.handler, []);
				
			}
			
			keyPressed.set (key, true);
			
		}
		
	}
	
	
	private static function stage_onKeyUp (event:KeyboardEvent):Void {
		
		var key = event.keyCode;
		keyPressed.remove (key);
		
		if (releaseBindings.exists (key)) {
			
			var data = releaseBindings.get (key);
			
			Reflect.callMethod (data.handler, data.handler, []);
			
		}
		
	}
	
	
}