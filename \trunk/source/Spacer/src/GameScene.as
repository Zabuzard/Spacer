package {
	public class GameScene {
		/**
		* Current state of the mouse button.
		**/
		protected var isMousePressedState = false;
		
		/**
		* Disposes all used ressources and memories of the scene.
		* Should be called right before destruction.
		* This scene can't be used anymore after that this method was called.
		**/
		public function dispose(): void {
			
		}
		/**
		* Sets the state of the mouse presses. Should be used by an input manager.
		* @param thatIsMousePressed True if mouse is pressed
		**/
		public function mousePressed(thatIsMousePressed: Boolean) {
			isMousePressedState = thatIsMousePressed;
		}
		/**
		* Logical run of the scene.
		**/
		public function tick(): void {
			
		}
	}
}