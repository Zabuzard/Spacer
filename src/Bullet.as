package {
	import LevelScene;
	import PhysicEngine;
	import PhysicForm;
	import BallisticEntity;
	import Utils;
	
	/**
	* Sprite class of a bullet that is used by the player while shooting.
	**/
	public final class Bullet extends Sprite {
		/**
		* Atackpower of the sprite.
		**/
		private static const ATACKPOWER: Number = 1;
		
		/**
		* Scene of this sprite.
		**/
		private var levelScene: LevelScene;
		/**
		* Physically form of this sprite.
		**/
		private var form: PhysicForm = new BallisticEntity();
		/**
		* Current facing of the bullet in radians.
		**/
		private var facingInRadians: Number;
		/**
		* True if the bullet is currently destroyed triggers an death animation if so.
		* Which is not equals alive because the bullet should get removed after the death animation.
		**/
		private var isDestroyed: Boolean = false;
		
		/**
		* Creates a new bullet that flies into a facing direction.
		* @param thatLevelScene Scene of the bullet
		* @param spawnX X-coordinate the bullet spawns at
		* @param spawnY Y-coordinate the bullet spawns at
		* @param facingInDegrees Direction bullet should fly into in degrees
		* @param thatPhysic Physic engine that affects this bullet
		**/
		public function Bullet(thatLevelScene: LevelScene, spawnX: int, spawnY: int, facingInDegrees: Number, thatPhysic: PhysicEngine): void {
			super(thatLevelScene, thatPhysic, form);
			stop();
			this.levelScene = thatLevelScene;
			setLifepoints(NO_LIFEPOINTS);
			setAtackPower(ATACKPOWER);
			
			setX(spawnX);
			setY(spawnY);
			this.rotation = facingInDegrees;
			facingInRadians = Utils.degreesToRadians(facingInDegrees);
			thatLevelScene.addBullet(this);
		}
		
		/**
		* Overrides the default behavior and triggers a death animation before the bullet gets removed from stage by calling super.die().
		**/
		public override function die(): void {
			isDestroyed = true;
		}
		//@Override
		public override function move(): void {
			setXA(Math.cos(facingInRadians) * form.getSpeed());
			setYA(Math.sin(facingInRadians) * form.getSpeed());
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
				} else {
					animateDeath();
				}
			}
		}
		/**
		* Animates the death of the bullet and calls super.die() at animations end to remove the bullet from the scene.
		**/
		private function animateDeath(): void {
			if (currentLabel != "destroyed" && currentLabel != "destroyedComplete") {
				gotoAndPlay("destroyed");
			} else if (currentLabel == "destroyedComplete") {
				stop();
				super.die();
			}
		}
	}
}