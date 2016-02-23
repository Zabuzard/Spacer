package {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import KeyObject;
	import Utils;
	import PhysicEngine;
	import PhysicForm;
	import NormalEntity;
	import LevelScene;
	
	/**
	* Sprite class of games player.
	* Can shoot bullets and collides with scenes bounds.
	**/
	public final class Player extends Sprite {
		/**
		* Tick frequency of bullets that get spawned during shooting.
		**/
		private static const SHOOTING_MAX_TICK_DELAY: Number = 8;
		/**
		* Lifepoints of the sprite.
		**/
		private static const LIFEPOINTS: Number = 4;
		/**
		* Duration in miliseconds of player invinciblity if getting hitted.
		**/
		private static const INVINCIBLE_DURATION_MILIS: Number = 3000;
		
		/**
		* Scene of this sprite.
		**/
		private var levelScene: LevelScene;
		/**
		* Physic engine that affects this sprite.
		**/
		private var physic: PhysicEngine;
		/**
		* Object that stores information about key presses.
		**/
		private var key: KeyObject;
		/**
		* True if key for walking left is pressed.
		**/
		private var leftPressed: Boolean = false;
		/**
		* True if key for walking right is pressed.
		**/
		private var rightPressed: Boolean = false;
		/**
		* True if key for walking upwards is pressed.
		**/
		private var upPressed: Boolean = false;
		/**
		* True if key for walking downwards is pressed.
		**/
		private var downPressed: Boolean = false;
		/**
		* Physically form of this sprite.
		**/
		private var form: PhysicForm = new NormalEntity();
		/**
		* True if the shooting animation of this sprite is currently stopped.
		**/
		private var isShootingAnimLabelStopped: Boolean = true;
		/**
		* True if the invincibility animation of this sprite is currently stopped.
		**/
		private var isInvincibilityAnimLabelStopped: Boolean = true;
		/**
		* Counter for bullet spawning during shooting.
		* Will spawn a new bullet each time the counter reaches SHOOTING_MAX_TICK_DELAY.
		**/
		private var shootingTickDelayCounter: Number = 0;
		/**
		* Counter for players invincibility if getting hitted.
		**/
		private var counterInvincible: Timer;
		/**
		* Stores a timestamp of the last timer activation for pause functionallity.
		**/
		private var invincibleTimerStartTimestamp: Number;
		/**
		* True if player currently is invincible.
		**/
		private var isInvincible: Boolean = false;
		/**
		* True if the player is currently destroyed triggers an death animation if so.
		* Which is not equals alive because the player should get removed after the death animation.
		**/
		private var isDestroyed: Boolean = false;
		
		/**
		* Creates a new player and adds it to the scene.
		* @param thatLevelScene Scene of the player
		* @param spawnX X-coordinate the player will spawn at
		* @param spawnY Y-coordinate the player will spawn at
		* @param thatPhysic Physic engine that affects the player
		* @param thatKey Object that stores information about key presses
		**/
		public function Player(thatLevelScene: LevelScene, spawnX: int, spawnY: int, thatPhysic: PhysicEngine, thatKey: KeyObject): void {
			super(thatLevelScene, thatPhysic, form);
			stop();
			mc_PlayerHitbox.mc_PlayerMouth.stop();
			mc_PlayerHitbox.mc_PlayerInvincibleAnim.stop();
			this.levelScene = thatLevelScene;
			this.physic = thatPhysic;
			this.key = thatKey;
			setLifepoints(LIFEPOINTS);
			setAtackPower(NO_ATACKPOWER);
			counterInvincible = new Timer(INVINCIBLE_DURATION_MILIS, 1);
			counterInvincible.addEventListener(TimerEvent.TIMER, invincibleCounterEndedHandler);
			
			setX(spawnX);
			setY(spawnY);
			thatLevelScene.addPlayer(this);
		}
		/**
		* Overrides the default behavior and triggers a death animation before the player gets removed from stage by calling super.die().
		**/
		public override function die(): void {
			isDestroyed = true;
		}
		//@Override
		public override function dispose(): void {
			counterInvincible.stop();
			super.dispose();
		}		
		
		//@Override
		public override function gettingHitted(enemyAtackPower: Number) {
			if(!isInvincible) {
				setLifepoints(getLifepoints() - enemyAtackPower);
				isInvincible = true;
				counterInvincible.start();
				invincibleTimerStartTimestamp = getTimer();
			}
		}
		//@Override
		public override function move(): void {
			updateKeypresses();
			
			var speed: Number;
			if (leftPressed) {
				speed = form.getSpeed();
				if(upPressed || downPressed) {
					speed /= Math.SQRT2;
				}
				setXA(getXA() - speed);
			} else if (rightPressed) {
				speed = form.getSpeed();
				if(upPressed || downPressed) {
					speed /= Math.SQRT2;
				}
				setXA(getXA() + speed);
			}
			if (upPressed) {
				speed = form.getSpeed();
				if(leftPressed || rightPressed) {
					speed /= Math.SQRT2;
				}
				setYA(getYA() - speed);
			} else if (downPressed) {
				speed = form.getSpeed();
				if(leftPressed || rightPressed) {
					speed /= Math.SQRT2;
				}
				setYA(getYA() + speed);
			}
		}
		
		//@Override
		public override function tick(): void {
			if (isAlive()) {
				if (!isDestroyed) {
					if(!levelScene.isPaused()) {
						setXOld(getX());
						setYOld(getY());
						
						//Reengage invincible timer after paused
						if(counterInvincible.delay < INVINCIBLE_DURATION_MILIS && !counterInvincible.running) {
							counterInvincible.start();
							invincibleTimerStartTimestamp = getTimer();
						}
						
						move();
						checkShooting();
						updateCoords();
						lookAtMouse();
					} else if(counterInvincible.running) {
						//Pause invincible timer
						var timePast = Math.abs(getTimer() - invincibleTimerStartTimestamp);
						var deltaDelay = Math.abs(counterInvincible.delay - timePast);
						counterInvincible.stop();
						counterInvincible = new Timer(deltaDelay, 1);
						counterInvincible.addEventListener(TimerEvent.TIMER, invincibleCounterEndedHandler);
					}
					animate();
				} else {
					animateDeath();
				}
			}
		}
		/**
		* Handler that gets evoked everytime players invincibility has ended.
		* @param event Event that evoked the handler
		**/
		public function invincibleCounterEndedHandler(event: TimerEvent): void {
			isInvincible = false;
			counterInvincible.reset();
		}
		/**
		* Animates the sprite by calling several labels on some movieclips depending on sprites state.
		**/
		private function animate() : void {
			animateShooting(levelScene.isMousePressed());
			animateInvincibility();
		}
		/**
		* Animates the death of the player and calls super.die() at animations end to remove the player from the scene.
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
		* Animates the player while shooting by going to several labels depending on mouse pressed state.
		* @param isMousePressed True if mouse is currently pressed
		**/
		private function animateShooting(isMousePressed: Boolean): void {
			if(isMousePressed && mc_PlayerHitbox.mc_PlayerMouth.currentLabel == "default" && isShootingAnimLabelStopped) {
				mc_PlayerHitbox.mc_PlayerMouth.gotoAndPlay("startShooting");
				isShootingAnimLabelStopped = false;
			} else if(isMousePressed && mc_PlayerHitbox.mc_PlayerMouth.currentLabel == "shooting" && !isShootingAnimLabelStopped) {
				mc_PlayerHitbox.mc_PlayerMouth.stop();
				isShootingAnimLabelStopped = true;
			} else if(!isMousePressed && mc_PlayerHitbox.mc_PlayerMouth.currentLabel != "endShooting"
			&& mc_PlayerHitbox.mc_PlayerMouth.currentLabel != "default" && isShootingAnimLabelStopped) {
				mc_PlayerHitbox.mc_PlayerMouth.gotoAndPlay("endShooting");
				isShootingAnimLabelStopped = false;
			} else if(!isMousePressed && mc_PlayerHitbox.mc_PlayerMouth.currentLabel == "default" && !isShootingAnimLabelStopped) {
				mc_PlayerHitbox.mc_PlayerMouth.stop();
				isShootingAnimLabelStopped = true;
			}
		}
		/**
		* Animates the player if invincible by going to several labels.
		**/
		private function animateInvincibility(): void {
			if(isInvincible && mc_PlayerHitbox.mc_PlayerInvincibleAnim.currentLabel == "default" && isInvincibilityAnimLabelStopped) {
				mc_PlayerHitbox.mc_PlayerInvincibleAnim.gotoAndPlay("invincible");
				isInvincibilityAnimLabelStopped = false;
			} else if(!isInvincible && !isInvincibilityAnimLabelStopped) {
				mc_PlayerHitbox.mc_PlayerInvincibleAnim.gotoAndStop("default");
				isInvincibilityAnimLabelStopped = true;
			}
		}
		/**
		* Checks if the player should shoot and starts shooting if so.
		**/
		private function checkShooting(): void {
			if(levelScene.isMousePressed()) {
				if(shootingTickDelayCounter <= 0) {
					spawnBullet();
				}
				shootingTickDelayCounter++;
				shootingTickDelayCounter %= SHOOTING_MAX_TICK_DELAY;
			} else {
				shootingTickDelayCounter = 0;
			}
		}
		/**
		* Spawns a new bullet that flies from players direction.
		**/
		private function spawnBullet() {
			var offsetRadius: Number = getWidth() / 4;
			var facingInRadians = Utils.degreesToRadians(this.rotation);
			var offsetX: Number = Math.cos(facingInRadians) * offsetRadius;
			var offsetY: Number = Math.sin(facingInRadians) * offsetRadius;
			
			new Bullet(levelScene, getX() + offsetX, getY() + offsetY, this.rotation, physic);
		}
		/**
		* Updates the current state of key presses.
		**/
		private function updateKeypresses(): void {
			leftPressed = key.isDown(Utils.KEY_LEFT1) || key.isDown(Utils.KEY_LEFT2);
			rightPressed = key.isDown(Utils.KEY_RIGHT1) || key.isDown(Utils.KEY_RIGHT2);
			upPressed = key.isDown(Utils.KEY_UP1) || key.isDown(Utils.KEY_UP2);
			downPressed = key.isDown(Utils.KEY_DOWN1) || key.isDown(Utils.KEY_DOWN2);
		}
		/**
		* Changes players facing to the mouse position.
		**/
		private function lookAtMouse(): void {
			var xDifference: Number = levelScene.getMouseX() - getX();
			var yDifference: Number = levelScene.getMouseY() - getY();
			this.rotation = Utils.radiansToDegrees(Math.atan2(yDifference, xDifference));
		}
	}
}