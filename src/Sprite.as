package {
	import flash.display.MovieClip;
	import LevelScene;
	import PhysicEngine;
	import PhysicForm;
	
	/**
	* Basic class for sprites that can be added to scenes.
	**/
	public class Sprite extends MovieClip {
		/**
		* If sprite has no attack power.
		**/
		public static const NO_ATACKPOWER: Number = -1;
		/**
		* If sprite has no lifepoints.
		**/
		public static const NO_LIFEPOINTS: Number = -1;
		/**
		* x-Coordinate of last tick run.
		**/
		private var xOld: Number = 0,
			/**
			* y-coordinate of last tick run.
			**/
			yOld: Number = 0,
			/**
			* Current acceleration in x direction.
			**/
			xa: Number = 0,
			/**
			* Current acceleration in y direction.
			**/
			ya: Number = 0;
		/**
		* True if sprite is currently alive.
		* Sprite will get removed by other instances if not alive.
		**/
		private var alive: Boolean = true;
		
		/**
		* Level scene the sprite belongs to.
		**/
		private var levelScene = LevelScene;
		/**
		* Physic engine that affects the sprite.
		**/
		private var physic: PhysicEngine;
		/**
		* Physically form of the sprite.
		**/
		private var form: PhysicForm;
		/**
		* Atackpower of the sprite.
		**/
		private var atackPower: Number;
		/**
		* Lifepoints of the sprite.
		**/
		private var lifepoints: Number;
		
		/**
		* Creates a new sprite and sets relevant object connections for the sprite.
		* Should be called by childs or problems may occur.
		* @param thatLevelScene Level scene the sprite belongs to
		* @param thatPhysic Physic engine that affects the sprite
		* @param thatForm Physically form of the sprite
		**/
		public function Sprite(thatLevelScene: LevelScene, thatPhysic: PhysicEngine, thatForm: PhysicForm): void {
			this.levelScene = thatLevelScene;
			this.physic = thatPhysic;
			this.form = thatForm;
		}
		
		/**
		* Lets the sprite die by setting it to not alive, therefore it will get removed by other instances from the scene.
		**/
		public function die(): void {
			this.visible = false;
			alive = false;
		}
		/**
		* Disposes all used ressources and memories of the sprite.
		* Should be called right before destruction.
		* This sprite can't be used anymore after that this method was called.
		**/
		public function dispose(): void {
			stop();
			this.visible = false;
		}
		/**
		* Gets the height of the sprite.
		* @return Height of the sprite
		**/
		public final function getHeight(): Number {
			return height;
		}
		/**
		* Gets the form of the sprite.
		* @return Form of the sprite
		**/
		public final function getForm(): PhysicForm {
			return form;
		}
		/**
		* Gets the current lifepoints of the sprite.
		* @return Current lifepoints of the sprite
		**/
		public final function getLifepoints(): Number {
			return lifepoints;
		}
		/**
		* Gets the current atack power of the sprite.
		* @return Current atack power of the sprite
		**/
		public final function getAtackPower(): Number {
			return atackPower;
		}
		/**
		* Gets the width of the sprite.
		* @return Width of the sprite
		**/
		public final function getWidth(): Number {
			return width;
		}
		/**
		* Gets the x-coordinate of the sprite.
		* @return X-coordinate of the sprite
		**/
		public final function getX(): Number {
			return x;
		}
		/**
		* Gets the current acceleration in x-direction of the sprite.
		* @return Current acceleration in x-direction of the sprite
		**/
		public final function getXA(): Number {
			return xa;
		}
		/**
		* Gets the x-coordinate from the last tick run of the sprite.
		* @return X-coordinate from the last tick run of the sprite
		**/
		public final function getXOld(): Number {
			return xOld;
		}
		/**
		* Gets the y-coordinate of the sprite.
		* @return Y-coordinate of the sprite
		**/
		public final function getY(): Number {
			return y;
		}
		/**
		* Gets the current acceleration in y-direction of the sprite.
		* @return Current acceleration in y-direction of the sprite
		**/
		public final function getYA(): Number {
			return ya;
		}
		/**
		* Gets the y-coordinate from the last tick run of the sprite.
		* @return Y-coordinate from the last tick run of the sprite
		**/
		public final function getYOld(): Number {
			return yOld;
		}
		/**
		* Call if sprite gets atacked by an enemy with a given power.
		* @param enemyAtackPower Power of enemy that atacked sprite
		**/
		public function gettingHitted(enemyAtackPower: Number) {
			setLifepoints(getLifepoints() - enemyAtackPower);
		}
		/**
		* Returns if the sprite is currently alive.
		* @return True if the sprite is currently alive
		**/
		public final function isAlive(): Boolean {
			return alive;
		}
		/**
		* Moves the sprite. Should only change XA and YA.
		* The function updateCoords then later will add them to the coordinates.
		**/
		public function move(): void {

		}
		/**
		* Sets the x-coordinate of the sprite.
		* @param thatX X-coordinate to set
		**/
		public final function setX(thatX: Number) {
			this.x = thatX;
		}
		/**
		* Sets the current acceleration in x-direction of the sprite.
		* @param thatXA Acceleration in x-direction to set
		**/
		public final function setXA(thatXA: Number) {
			this.xa = thatXA;
		}
		/**
		* Sets the y-coordinate of the sprite.
		* @param thatY Y-coordinate to set
		**/
		public final function setY(thatY: Number) {
			this.y = thatY;
		}
		/**
		* Sets the current acceleration in y-direction of the sprite.
		* @param thatYA Acceleration in y-direction to set
		**/
		public final function setYA(thatYA: Number) {
			this.ya = thatYA;
		}
		/**
		* Logical run of the sprite.
		**/
		public function tick(): void {

		}
		/**
		* Updates the coordinates by bypassing sprites data to the physic engine that then will change XA and YA before adding them to X and Y.
		**/
		public function updateCoords(): void {
			physic.affect(this, levelScene);
		}
		/**
		* Sets the atack power of the sprite.
		* @param thatAtackPower Atack power to set
		**/
		protected final function setAtackPower(thatAtackPower : Number): void {
			this.atackPower = thatAtackPower;
		}
		/**
		* Sets the lifepoints of the sprite.
		* @param thatLifepoints Lifepoints power to set
		**/
		protected final function setLifepoints(thatLifepoints : Number): void {
			this.lifepoints = thatLifepoints;
		}
		/**
		* Sets the x-coordinate the sprite had in the last tick run.
		* @param thatXOld Last x-coordinate to set
		**/
		protected final function setXOld(thatXOld: Number): void {
			this.xOld = thatXOld;
		}
		/**
		* Sets the y-coordinate the sprite had in the last tick run.
		* @param thatYOld Last y-coordinate to set
		**/
		protected final function setYOld(thatYOld: Number): void {
			this.yOld = thatYOld;
		}
	}
}