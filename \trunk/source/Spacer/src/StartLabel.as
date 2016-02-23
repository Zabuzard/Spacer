package {
	import flash.display.MovieClip;

	/**
	* Basic class for a game starting label that flashes.
	**/
	public final class StartLabel extends MovieClip {
		/**
		* Creates a new start label with a given starting x-coordinate and y-coordinate.
		* @param xCoord Starting x-coordinate
		* @param yCoord Starting y-coordinate
		**/
		public function StartLabel(xCoord: Number, yCoord: Number): void {
			x = xCoord;
			y = yCoord;
		}
	}
}