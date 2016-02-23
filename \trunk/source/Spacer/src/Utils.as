package {
	/**
	* Utility class that provides some utility methods and constants.
	**/
	public final
	class Utils {
		/**
		* Width of the stage.
		**/
		public static const STAGE_WIDTH: uint = 800,
		/**
		* Height of the stage.
		**/
		STAGE_HEIGHT: uint = 700,
		/**
		* Keycode for left-walking.
		**/
		KEY_LEFT1: uint = 37,
		/**
		* Alternative keycode for left-walking.
		**/
		KEY_LEFT2: uint = 65,
		/**
		* Keycode for right-walking.
		**/
		KEY_RIGHT1: uint = 39,
		/**
		* Alternative keycode for right-walking.
		**/
		KEY_RIGHT2: uint = 68,
		/**
		* Keycode for upwards-walking.
		**/
		KEY_UP1: uint = 38,
		/**
		* Alternative keycode for upwards-walking.
		**/
		KEY_UP2: uint = 87,
		/**
		* Keycode for downwards-walking.
		**/
		KEY_DOWN1: uint = 40,
		/**
		* Alternative keycode for downwards-walking.
		**/
		KEY_DOWN2: uint = 83,
		/**
		* Keycode for the pause function.
		**/
		KEY_PAUSE: uint = 27,
		/**
		* Keycode for restarting the game.
		**/
		KEY_RESTART: uint = 13,
		/**
		* Keycode for starting the game from title screen.
		**/
		KEY_LEVEL_START: uint = 13,
		/**
		* Distance of scenes bound to the left stage border.
		**/
		LEFT_BORDER: Number = 15,
		/**
		* Distance of scenes bound to the right stage border.
		**/
		RIGHT_BORDER: Number = 15,
		/**
		* Distance of scenes bound to the top stage border.
		**/
		TOP_BORDER: Number = 130,
		/**
		* Distance of scenes bound to the bottom stage border.
		**/
		BOTTOM_BORDER: Number = 30,
		/**
		* Value for one full circle in degrees.
		**/
		CIRCLE_FULL_DEG: Number = 360,
		/**
		* Factor for a full chance of 100 percent.
		**/
		CHANCE_FULL: Number = 1;
		
		/**
		* Converts a radian value into the corresponding degree value.
		* @param radian Radian value to convert
		* @return Converted value in degrees
		**/
		public static function radiansToDegrees(radian: Number): Number {
			const CIRCLE_HALF_DEG: Number = CIRCLE_FULL_DEG / 2;
			return radian * CIRCLE_HALF_DEG / Math.PI;
		}
		/**
		* Converts a degree value into the corresponding radian value.
		* @param degree Degree value to convert
		* @return Converted value in radians
		**/
		public static function degreesToRadians(degree: Number): Number {
			const CIRCLE_HALF_DEG: Number = CIRCLE_FULL_DEG / 2;
			return degree * Math.PI / CIRCLE_HALF_DEG;
		}
	}
}