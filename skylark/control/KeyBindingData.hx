/**
 * @author Joshua Granick
 */


package skylark.control;


class KeyBindingData {
	
	
	public var key:Int;
	public var handler:Dynamic;
	public var repeat:Bool;
	
	
	public function new (key:Int, handler:Dynamic, repeat:Bool = false) {
		
		this.key = key;
		this.handler = handler;
		this.repeat = repeat;
		
	}
	
	
}