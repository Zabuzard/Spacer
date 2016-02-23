package  {
	import flash.display.MovieClip;
	
	/**
	* Basic class for a ten based digit.
	**/
	public final class Digit extends MovieClip {
		/**
		* Upper bound of valid digits.
		**/
		public static const UPPER_BOUND: Number = 9;
		/**
		* Lower bound of valid digits.
		**/
		public static const LOWER_BOUND: Number = 0;
		
		/**
		* Current value of the digit.
		**/
		private var value: Number;
		
		/**
		* Creates a new digit with a given starting value or LOWER_BOUND if no provided.
		* @param thatDigit Starting value between LOWER_BOUND and UPPER_BOUND
		**/
		public function Digit(thatValue: Number = LOWER_BOUND): void {
			stop();
			setValue(thatValue);
		}
		/**
		* Gets the current value of the digit.
		* @ Current value of the digit between LOWER_BOUND and UPPER_BOUND
		**/
		public function getValue(): Number {
			return value;
		}
		/**
		* Sets the current value of the digit.
		* @param thatValue Value to set between LOWER_BOUND and UPPER_BOUND
		**/
		public function setValue(thatValue: Number): void {
			if(thatValue < LOWER_BOUND || thatValue > UPPER_BOUND) {
				thatValue = LOWER_BOUND;
			}
			this.value = thatValue;
			animate();
		}
		/**
		* Updates the animation of the digit by setting the correct texture for the current value.
		**/
		private function animate(): void {
			gotoAndStop("digit" + getValue());
		}
	}
	
}
