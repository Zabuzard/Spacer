package  {
	import flash.display.MovieClip;
	
	/**
	* Basic display for a two state heart.
	**/
	public final class Heart extends MovieClip {
		/**
		* Current state of the heart
		**/
		private var state: Boolean;
		
		/**
		* Creates a new heart with a given status which is enabled by default.
		* @param thatState State of the heart which is enabled by default.
		**/
		public function Heart(thatState: Boolean = true): void {
			stop();
			setState(thatState);
		}
		
		/**
		* Sets the state of the heart.
		* @param thatState The state to set
		**/
		public function setState(thatState: Boolean): void {
			this.state = thatState;
			animate();
		}
		/**
		* Returns if the heart currently is in the enabled state.
		* @return True if the heart currently is in the enabled state
		**/
		public function getState(): Boolean {
			return state;
		}
		/**
		* Updates the animation of the heart by setting the correct texture for the current state.
		**/
		private function animate(): void {
			if(getState() && currentLabel != "default") {
				gotoAndStop("default");
			} else if(!getState() && currentLabel != "empty") {
				gotoAndStop("empty");
			}
		}
	}
	
}
