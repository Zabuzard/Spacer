package {
	import Sprite;
	import LevelScene;
	import PhysicForm;
	import flash.geom.ColorTransform;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.BlendMode;
	import flash.display.Stage;
	
	/**
	* Physic engine that supports inertia and collisions with scene bounds and other objects.
	**/
	public final
	class PhysicEngine {
		/**
		* Limit at which inertia will cause the sprite to stop completely.
		**/
		private static const INERTIA_LIMIT: Number = 0.5;
		/**
		* Reference to the stage the engine works on.
		**/
		private var stageRef: Stage;
		
		/**
		* Creates a new physic engine with a given stage where it works on.
		* @param thatStageRef Reference to the stage where the engine works on
		**/
		public function PhysicEngine(thatStageRef: Stage) {
			this.stageRef = thatStageRef;
		}
		
		/**
		* Affects a sprites coordinates and acceleration that belongs to a given scene by applying physic to it.
		* @param sprite Sprite to affect
		* @param levelScene Scene the sprite belongs to
		**/
		public function affect(sprite: Sprite, levelScene: LevelScene): void {
			applyInertia(sprite);
			
			if (sprite.getForm().isCollidesWithSceneBound()) {
				applySceneBounds(sprite, levelScene);
			} else {
				sprite.setX(sprite.getX() + sprite.getXA());
				sprite.setY(sprite.getY() + sprite.getYA());
			}
		}
		/**
		* Checks collisions between all sprites of the game and calls collision reactions.
		* @param flies Vector that stores all flies to check
		* @param flyBoss FlyBoss to check
		* @param bullets Vector that stores all bullets to check
		* @param player Player to check
		* @param scene Scene of sprites
		**/
		public function checkSpriteCollisions(flies : Vector.<Fly>, flyBoss: FlyBoss, bullets : Vector.<Bullet>, player : Player, scene : LevelScene) : void {
			/*
			* @TODO Pretty non dynamic and non perfomant approach.
			* Runtime in O(n*m) where n, m are amount of flies, bullets.
			* A dynamic quadtree including a good collision interface solution would be far better but not as easy.
			*/
			var i: int;
			var j: int;
			//Fly with Bullets and Player
			for(i = 0; i < flies.length; i++) {
				if(flies[i] == null || flies[i].mc_FlyHitbox == null) {
					continue;
				}
				
				if(player != null && player.mc_PlayerHitbox != null && areaOfCollision(flies[i].mc_FlyHitbox, player.mc_PlayerHitbox) != null) {
					flies[i].setXA(0);
					flies[i].setYA(0);
					flies[i].setX(flies[i].getXOld());
					flies[i].setY(flies[i].getYOld());
					player.setXA(0);
					player.setYA(0);
					scene.collisionFlyPlayer(flies[i], player);
				}
				for(j = 0; j < bullets.length; j++) {
					if(bullets[j] == null || bullets[j].mc_BulletHitbox == null) {
						continue;
					}
					
					if(areaOfCollision(flies[i].mc_FlyHitbox, bullets[j].mc_BulletHitbox) != null) {
						flies[i].setXA(0);
						flies[i].setYA(0);
						scene.collisionFlyBullet(flies[i], bullets[j]);
					}
				}
			}
			//FlyBoss with Player
			if(flyBoss != null && flyBoss.mc_FlyBossHitbox != null) {
				if(player != null && player.mc_PlayerHitbox != null && areaOfCollision(flyBoss.mc_FlyBossHitbox, player.mc_PlayerHitbox) != null) {
					flyBoss.setXA(0);
					flyBoss.setYA(0);
					flyBoss.setX(flyBoss.getXOld());
					flyBoss.setY(flyBoss.getYOld());
					player.setXA(0);
					player.setYA(0);
					scene.collisionFlyBossPlayer(flyBoss, player);
				}
				var k: int;
				//FlyBoss with Bullets
				for(k = 0; k < bullets.length; k++) {
					if(bullets[k] == null || bullets[k].mc_BulletHitbox == null) {
						continue;
					}
					
					if(areaOfCollision(flyBoss.mc_FlyBossHitbox, bullets[k].mc_BulletHitbox) != null) {
						flyBoss.setXA(0);
						flyBoss.setYA(0);
						scene.collisionFlyBossBullet(flyBoss, bullets[k]);
					}
				}
			}
		}
		/**
		* Applies an inertia effect on a given sprite by reducing its acceleration.
		* @param sprite Sprite to affect with inertia
		**/
		private function applyInertia(sprite: Sprite): void {
			sprite.setXA(sprite.getXA() * sprite.getForm().getInertia());
			sprite.setYA(sprite.getYA() * sprite.getForm().getInertia());
			if (Math.abs(sprite.getXA()) < INERTIA_LIMIT) {
				sprite.setXA(0);
			}
			if (Math.abs(sprite.getYA()) < INERTIA_LIMIT) {
				sprite.setYA(0);
			}
		}
		/**
		* Applies reactions to a given sprite if colliding with the bounds of its scene.
		* The reaction is setted by the PhysicForm of the sprite.
		* @param sprite Sprite to apply with collision reactions
		* @param levelScene Scene of the sprite
		**/
		private function applySceneBounds(sprite: Sprite, levelScene: LevelScene): void {
			var nextX = sprite.getX() + sprite.getXA();
			var nextY = sprite.getY() + sprite.getYA();
			var leftBound = levelScene.getLeftBound() + (sprite.getWidth() / 2);
			var rightBound = levelScene.getRightBound() - (sprite.getWidth() / 2);
			var topBound = levelScene.getTopBound() + (sprite.getHeight() / 2);
			var bottomBound = levelScene.getBottomBound() - (sprite.getHeight() / 2);
			
			var deleteSprite = false;
			var isReactionDelete = sprite.getForm().getSceneCollisionReaction() == SceneCollisionReaction.DESTROY;
			if (nextX < leftBound) {
				sprite.setX(leftBound);
				if(isReactionDelete) {
					deleteSprite = true;
				}
			} else if (nextX >= rightBound) {
				sprite.setX(rightBound - 1);
				if(isReactionDelete) {
					deleteSprite = true;
				}
			} else {
				sprite.setX(sprite.getX() + sprite.getXA());
			}
			if (nextY < topBound) {
				sprite.setY(topBound);
				if(isReactionDelete) {
					deleteSprite = true;
				}
			} else if (nextY >= bottomBound) {
				sprite.setY(bottomBound - 1);
				if(isReactionDelete) {
					deleteSprite = true;
				}
			} else {
				sprite.setY(sprite.getY() + sprite.getYA());
			}
			if(deleteSprite) {
				sprite.die();
			}
		}
		/**
		* Returns the a the shape of two objects from their colliding parts or null if they don't collide.
		* Detection is pixel perfect.
		* @param object1 First object to test collision
		* @param object2 Second object to test collision
		* @param tolerance Collision detection tolerance used as alpha value for texture collision
		* @return Shape of objects collision or null if they do not collide
		**/
		private function areaOfCollision(object1: DisplayObject, object2: DisplayObject, tolerance: int = 255): Rectangle {
			if (object1.hitTestObject(object2)) {
				var limits1: Rectangle = object1.getBounds(stageRef);
				var limits2: Rectangle = object2.getBounds(stageRef);
				var limits: Rectangle = limits1.intersection(limits2);
				limits.x = Math.floor(limits.x);
				limits.y = Math.floor(limits.y);
				limits.width = Math.ceil(limits.width);
				limits.height = Math.ceil(limits.height);
				if (limits.width < 1 || limits.height < 1) {
					return null;
				}
				
				var image: BitmapData = new BitmapData(limits.width, limits.height, false);
				var matrix: Matrix = object1.transform.concatenatedMatrix;
				matrix.translate(-limits.left, -limits.top);
				image.draw(object1, matrix, new ColorTransform(1, 1, 1, 1, 255, -255, -255, tolerance));
				matrix = object2.transform.concatenatedMatrix;
				matrix.translate(-limits.left, -limits.top);
				image.draw(object2, matrix, new ColorTransform(1, 1, 1, 1, 255, 255, 255, tolerance), BlendMode.DIFFERENCE);
				
				var intersection: Rectangle = image.getColorBoundsRect(0xFFFFFFFF, 0xFF00FFFF);
				if (intersection.width == 0) {
					return null;
				}
				intersection.offset(limits.left, limits.top);
				return intersection;
			}
			return null;
		}
	}
}