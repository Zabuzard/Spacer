package {
	import Utils;
	import PhysicEngine;
	import PhysicForm;
	import NormalEntity;
	import LevelScene;
	
	/**
	* Sprite class for a basic FlyBoss-typed enemy.
	**/
	public final class FlyBoss extends Sprite {
		/**
		* Atackpower of the sprite.
		**/
		private static const ATACKPOWER: Number = 2;
		/**
		* Lifepoints of the sprite.
		**/
		private static const LIFEPOINTS: Number = 100;
		
		/**
		* Movement variation in positive and negative degrees of direction.
		**/
		private static var MOVE_DIR_VARIATION = 60;
		/**
		* Factor for the upper bound of movement variation from speed.
		**/
		private static var MOVE_SPEED_UPPER_VARIATION = 3.0;
		/**
		* Factor for the lower bound of movement variation from speed.
		**/
		private static var MOVE_SPEED_LOWER_VARATION = 0.5;
		/**
		* Scene of this sprite.
		**/
		private var levelScene: LevelScene;
		/**
		* Physic engine that affects this sprite.
		**/
		private var physic: PhysicEngine;
		/**
		* Physically form of this sprite.
		**/
		private var form: PhysicForm = new NormalEntity();
		/**
		* True if the animation of this sprite is currently stopped.
		**/
		private var isAnimLabelStopped: Boolean = true;
		/**
		* True if the fly boss is currently destroyed triggers an death animation if so.
		* Which is not equals alive because the fly boss should get removed after the death animation.
		**/
		private var isDestroyed: Boolean = false;
		
		/**
		* Creates a new FlyBoss-typed enemy.
		* @param thatLevelScene Scene of this sprite
		* @param spawnX X-coordinate the fly boss spawns at
		* @param spawnY Y-coordinate the fly boss spawns at
		* @param thatPhysic Physic engine that affects this sprite
		**/
		public function FlyBoss(thatLevelScene: LevelScene, spawnX: int, spawnY: int, thatPhysic: PhysicEngine): void {
			super(thatLevelScene, thatPhysic, form);
			stop();
			this.levelScene = thatLevelScene;
			this.physic = thatPhysic;
			setLifepoints(LIFEPOINTS);
			setAtackPower(ATACKPOWER);
			
			setX(spawnX);
			setY(spawnY);
			thatLevelScene.addFlyBoss(this);
		}
		
		/**
		* Overrides the default behavior and triggers a death animation before the fly boss gets removed from stage by calling super.die().
		**/
		public override function die(): void {
			isDestroyed = true;
		}
		
		//@Override
		public override function move(): void {
			var moveDirInDeg = this.rotation;
			var moveSpeed = form.getSpeed();
			
			//Variation of movement parameters
			moveDirInDeg = (moveDirInDeg - MOVE_DIR_VARIATION) + Math.floor(Math.random() * (MOVE_DIR_VARIATION * 2)) + 1;
			moveDirInDeg %= Utils.CIRCLE_FULL_DEG;
			moveSpeed *= MOVE_SPEED_LOWER_VARATION + (Math.random() * (MOVE_SPEED_UPPER_VARIATION - MOVE_SPEED_LOWER_VARATION));
			
			var moveDirInRad = Utils.degreesToRadians(moveDirInDeg);
			setXA(Math.cos(moveDirInRad) * moveSpeed);
			setYA(Math.sin(moveDirInRad) * moveSpeed);
		}
		//@Override
		public override function tick(): void {
			if (isAlive()) {
				if (!isDestroyed) {
					if(!levelScene.isPaused()) {
						setXOld(getX());
						setYOld(getY());
					
						move();
						updateCoords();
					}
					lookAtPlayer();
				} else {
					animateDeath();
				}
			}
		}
		/**
		* Animates the death of the fly boss and calls super.die() at animations end to remove the fly boss from the scene.
		**/
		private function animateDeath(): void {
			if (currentLabel != "destroyed" && currentLabel != "destroyedComplete") {
				gotoAndPlay("destroyed");
			} else if (currentLabel == "destroyedComplete") {
				stop();
				super.die();
			}
		}
		/**
		* Changes flys boss facing to players position.
		**/
		private function lookAtPlayer(): void {
			var xDifference: Number = levelScene.getPlayerX() - getX();
			var yDifference: Number = levelScene.getPlayerY() - getY();
			this.rotation = Utils.radiansToDegrees(Math.atan2(yDifference, xDifference));
		}
	}
}