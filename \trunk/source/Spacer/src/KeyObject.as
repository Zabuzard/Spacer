package {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	/**
	* Class that stores information about all key presses.
	**/
	public dynamic
	final
	class KeyObject extends Proxy {
		
		/**
		* Refference to the stage.
		**/
		private static var stage: Stage;
		/**
		* Array that stores all key states.
		**/
		private static var keysDown: Object;
		
		/**
		* Creates a new key object for a given stage.
		* @param stage Stage of the key object
		**/
		public function KeyObject(stage: Stage) {
			construct(stage);
		}
		
		/**
		* Constructs the key object with a given stage and adds key listeners.
		* @param stage Stage of the key object
		**/
		public function construct(stage: Stage): void {
			KeyObject.stage = stage;
			keysDown = new Object();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		//@Override
		override flash_proxy
		function getProperty(name: * ): * {
			return (name in Keyboard) ? Keyboard[name] : -1;
		}
		
		/**
		* Returns if a key given as standard key code is currently pressed.
		* @param keyCode Keycode of key
		* @return True if key is currently pressed
		**/
		public function isDown(keyCode: uint): Boolean {
			return Boolean(keyCode in keysDown);
		}
		/**
		* Deconstructs the key object by removing listeners and resetting other objects.
		**/
		public function deconstruct(): void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
			keysDown = new Object();
			KeyObject.stage = null;
		}
		/**
		* Listener for key presses that stores the information.
		* @param evt Event that invoked the listener
		**/
		private function keyPressed(evt: KeyboardEvent): void {
			keysDown[evt.keyCode] = true;
		}
		/**
		* Listener for key releases that stores the information.
		* @param evt Event that invoked the listener
		**/
		private function keyReleased(evt: KeyboardEvent): void {
			delete keysDown[evt.keyCode];
		}
	}
}