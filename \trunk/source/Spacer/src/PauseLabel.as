package {
	import flash.display.MovieClip;
	
	/**
	* Class for a basic pause label that flashes.
	**/
	public final class PauseLabel extends MovieClip {
		/**
		* Creates a new pause label with a given x and y coordinate to spawn at.
		* @param xCoord X-coordinate to spawn at
		* @param yCoord Y-coordinate to spawn at
		**/
		public function PauseLabel(xCoord : Number, yCoord : Number): void {
			x = xCoord;
			y = yCoord;
		}
	}
}