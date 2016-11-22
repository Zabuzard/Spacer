package {
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import PhysicEngine;
	import Sprite;
	import Player;
	import Bullet;
	import Fly;
	import KeyObject;
	import Utils;
	
	/**
	* Scene of the basic game level. 
	**/
	public final
	class LevelScene extends GameScene {
		/**
		* Base time for enemy spawn in miliseconds.
		**/
		private static const BASE_SPAWN_TIME_MILIS: Number = 10000;
		/**
		* @TODO Use negative logarithmic function instead of that!
		* Factor that reduces spawn time of enemies each time.
		**/
		private static const FACTOR_SPAWN_TIME: Number = 0.95;
		/**
		* Cooldown for the pause menu in miliseconds.
		**/
		private static const PAUSE_COOLDOWN_MILIS: Number = 500;
		/**
		* Amount of enemies to destroy.
		**/
		private static const ENEMY_AMOUNT: Number = 61;
		/**
		* Player of the game.
		**/
		private var player: Player;
		/**
		* Physic engine of the game.
		**/
		private var physic: PhysicEngine;
		/**
		* Reference to the stage.
		**/
		private var stageRef: Stage;
		/**
		* True if the scene is currently paused.
		**/
		private var isScenePaused: Boolean = false;
		/**
		* True if the pause function currently is in cooldown.
		**/
		private var isPauseInCooldown: Boolean = false;
		/**
		* Inforbar of the scene.
		**/
		private var infobar: Infobar;
		/**
		* Object that stores information about key inputs.
		**/
		private var key: KeyObject;
		/**
		* Width of the stage.
		**/
		private var stageWidth: Number;
		/**
		* Height of the stage.
		**/
		private var stageHeight: Number;
		/**
		* Vector that stores all sprites of the scene that have the type Fly.
		**/
		private var flies: Vector.<Fly> = new Vector.<Fly>();
		/**
		* Fly boss of the game.
		**/
		private var flyBoss: FlyBoss;
		/**
		* Vector that stores all sprites of the scene that have the type Bullet.
		**/
		private var bullets: Vector.<Bullet> = new Vector.<Bullet>();
		/**
		* Counter for enemy spawn.
		**/
		private var counterEnemySpawn: Timer;
		/**
		* Timer for the menu cooldown.
		**/
		private var pauseCooldownTimer: Timer;
		/**
		* Stores the current maximal time for the next enemy to spawn.
		**/
		private var enemySpawnTimeMilis: Number;
		/**
		* Stores a timestamp of the last timer activation for pause functionallity.
		**/
		private var enemySpawnTimerStartTimestamp: Number;
		/**
		* Amount of enemies remaining until game is finished.
		**/
		private var enemiesRemaining: Number = ENEMY_AMOUNT;
		/**
		* Amount of enemies that where spawned until now.
		**/
		private var enemiesSpawned: Number = 0;
		/**
		* Label that gets displayed when the scene paused.
		**/
		private var pauseLabel: PauseLabel;
		
		/**
		* Creates and starts a new LevelScene.
		* @param thatPhysic PhysicEngine of the game
		* @param thatStage Reference to the stage
		* @param thatStageWidth Width of the stage
		* @param thatStageHeight Height of the stage
		**/
		public function LevelScene(thatPhysic: PhysicEngine, thatStage: Stage, thatKey: KeyObject, thatStageWidth: Number, thatStageHeight: Number): void {
			physic = thatPhysic;
			stageRef = thatStage;
			key = thatKey;
			stageWidth = thatStageWidth;
			stageHeight = thatStageHeight;
			
			new Player(this, ((stageWidth - Utils.LEFT_BORDER - Utils.RIGHT_BORDER) / 2) + Utils.LEFT_BORDER,
				((stageHeight - Utils.TOP_BORDER - Utils.BOTTOM_BORDER) / 2) + Utils.TOP_BORDER, physic, key);
			
			enemySpawnTimeMilis = BASE_SPAWN_TIME_MILIS;
			
			infobar = new Infobar(this, player, thatStage, physic, key);
			pauseLabel = new PauseLabel(stageWidth / 2, stageHeight / 2);
			
			counterEnemySpawn = new Timer(enemySpawnTimeMilis, 1);
			counterEnemySpawn.addEventListener(TimerEvent.TIMER, enemySpawnHandler);
			counterEnemySpawn.start();
			enemySpawnTimerStartTimestamp = getTimer();
		}
		/**
		* Adds a bullet to the scene.
		* @param bullet The bullet to add
		**/
		public function addBullet(bullet: Bullet): void {
			bullets.push(bullet);
			stageRef.addChild(bullet);
		}
		/**
		* Adds a fly to the scene.
		* @param fly The fly to add
		**/
		public function addFly(fly: Fly): void {
			flies.push(fly);
			stageRef.addChild(fly);
		}
		/**
		* Adds a fly boss to the scene.
		* @param thatFlyBoss The fly boss to add
		**/
		public function addFlyBoss(thatFlyBoss: FlyBoss): void {
			if(this.flyBoss == null) {
				this.flyBoss = thatFlyBoss;
				stageRef.addChild(thatFlyBoss);
			}
		}
		/**
		* Adds a player to the scene which can only be activated once per scene.
		* @param player The player to add
		**/
		public function addPlayer(thatPlayer: Player): void {
			if(this.player == null) {
				this.player = thatPlayer;
				stageRef.addChild(thatPlayer);
			}
		}
		/**
		* Call if a collision between a fly and a bullet occured.
		* @param fly Fly that collided
		* @param bullet Bullet that collided
		**/
		public function collisionFlyBullet(fly: Fly, bullet: Bullet): void {
			fly.gettingHitted(bullet.getAtackPower());
			if(fly.getLifepoints() <= 0) {
				fly.die();
			}
			bullet.die();
		}
		/**
		* Call if a collision between a fly and the player occured.
		* @param fly Fly that collided
		* @param thatPlayer Player that collided
		**/
		public function collisionFlyPlayer(fly: Fly, thatPlayer: Player): void {
			thatPlayer.gettingHitted(fly.getAtackPower());
			if(thatPlayer.getLifepoints() <= 0) {
				thatPlayer.die();
			}
		}
		/**
		* Call if a collision between a fly boss and a bullet occured.
		* @param thatFlyBoss Fly boss that collided
		* @param bullet Bullet that collided
		**/
		public function collisionFlyBossBullet(thatFlyBoss: FlyBoss, bullet: Bullet): void {
			thatFlyBoss.gettingHitted(bullet.getAtackPower());
			if(thatFlyBoss.getLifepoints() <= 0) {
				thatFlyBoss.die();
			}
			bullet.die();
		}
		/**
		* Call if a collision between a fly boss and the player occured.
		* @param thatFlyBoss Fly boss that collided
		* @param thatPlayer Player that collided
		**/
		public function collisionFlyBossPlayer(thatFlyBoss: FlyBoss, thatPlayer: Player): void {
			thatPlayer.gettingHitted(thatFlyBoss.getAtackPower());
			if(thatPlayer.getLifepoints() <= 0) {
				thatPlayer.die();
			}
		}
		//@Override
		public override function dispose(): void {
			counterEnemySpawn.stop();
			
			if(player != null) {
				player.dispose();
				stageRef.removeChild(player);
			}
			if(flyBoss != null) {
				flyBoss.dispose();
				stageRef.removeChild(flyBoss);
			}
			while(bullets.length > 0) {
				var bullet = bullets.pop();
				bullet.dispose();
				stageRef.removeChild(bullet);
			}
			while(flies.length > 0) {
				var fly = flies.pop();
				fly.dispose();
				stageRef.removeChild(fly);
			}
			
			infobar.dispose();
			
			if(pauseCooldownTimer != null) {
				pauseCooldownTimer.stop();
			}
			if (isScenePaused) {
				stageRef.removeChild(pauseLabel);
			}
		}
		/**
		* Handler that gets evoked in order to spawn enemies and prepare the next run of the timer.
		* @param event Event that evoked the handler
		**/
		public function enemySpawnHandler(event: TimerEvent): void {
			if(!player.isAlive()) {
				return;
			}
			spawnEnemy();
			if(enemiesSpawned < ENEMY_AMOUNT) {
				enemySpawnTimeMilis = Math.floor(enemySpawnTimeMilis * FACTOR_SPAWN_TIME);
				counterEnemySpawn = new Timer(enemySpawnTimeMilis, 1);
				counterEnemySpawn.addEventListener(TimerEvent.TIMER, enemySpawnHandler);
				counterEnemySpawn.start();
				enemySpawnTimerStartTimestamp = getTimer();
			}
		}
		/**
		* Handler that gets evoked in order to reset the pause cooldown.
		* @param event Event that evoked the handler
		**/
		public function pauseCooldownHandler(event: TimerEvent): void {
			isPauseInCooldown = false;
		}
		/**
		* Returns if the mouse is pressed.
		* @return True if mouse is pressed
		**/
		public function isMousePressed(): Boolean {
			return isMousePressedState;
		}
		/**
		* Returns if the scene is currently paused.
		* @return True if the scene is currently paused
		**/
		public function isPaused(): Boolean {
			return isScenePaused;
		}
		/**
		* Gets the current amount of remaining enemies.
		* @return Current amount of remaining enemies
		**/
		public function getAmountRemainingEnemies(): Number {
			return enemiesRemaining;
		}
		/**
		* Gets the left bound of the scene.
		* @return Left bound of the scene
		**/
		public function getLeftBound(): Number {
			return 0 + Utils.LEFT_BORDER;
		}
		/**
		* Gets the right bound of the scene.
		* @return Right bound of the scene
		**/
		public function getRightBound(): Number {
			return 0 + stageWidth - Utils.RIGHT_BORDER;
		}
		/**
		* Gets the top bound of the scene.
		* @return Top bound of the scene
		**/
		public function getTopBound(): Number {
			return 0 + Utils.TOP_BORDER;
		}
		/**
		* Gets the bottom bound of the scene.
		* @return Bottom bound of the scene
		**/
		public function getBottomBound(): Number {
			return 0 + stageHeight - Utils.BOTTOM_BORDER;
		}
		/**
		* Gets the current x-coordinate of the mouse.
		* @return Current x-coordinate of the mouse
		**/
		public function getMouseX(): Number {
			return stageRef.mouseX;
		}
		/**
		* Gets the current y-coordinate of the mouse.
		* @return Current y-coordinate of the mouse
		**/
		public function getMouseY(): Number {
			return stageRef.mouseY;
		}
		/**
		* Gets the current x-coordinate of the player.
		* @return Current x-coordinate of the player
		**/
		public function getPlayerX(): Number {
			return player.getX();
		}
		/**
		* Gets the current y-coordinate of the player.
		* @return Current y-coordinate of the player
		**/
		public function getPlayerY(): Number {
			return player.getY();
		}
		
		//@Override
		public override function tick(): void {
			if(!player.isAlive()) {
				return;
			}
			
			checkPaused();
			if(player != null) {
				player.tick();
			}
			if(flyBoss != null) {
				flyBoss.tick();
			}
			var i: int;
			for(i = 0; i < flies.length; i++) {
				flies[i].tick();
				if(!flies[i].isAlive()) {
					removeFly(flies[i], i);
				}
			}
			for(i = 0; i < bullets.length; i++) {
				bullets[i].tick();
				if(!bullets[i].isAlive()) {
					removeBullet(bullets[i], i);
				}
			}
			if(flyBoss != null && !flyBoss.isAlive()) {
				removeFlyBoss(flyBoss);
			}
			physic.checkSpriteCollisions(flies, flyBoss, bullets, player, this);
			infobar.tick();
		}
		
		/**
		* Checks if the scene should be paused and stores the information in members.
		**/
		private function checkPaused(): void {
			if(key.isDown(Utils.KEY_PAUSE) && !isPauseInCooldown) {
				isPauseInCooldown = true;
				isScenePaused = !isScenePaused;
				pauseCooldownTimer = new Timer(PAUSE_COOLDOWN_MILIS, 1);
				pauseCooldownTimer.addEventListener(TimerEvent.TIMER, pauseCooldownHandler);
				pauseCooldownTimer.start();
				
				if (isScenePaused) {
					pauseLabel.gotoAndPlay(1);
					stageRef.addChild(pauseLabel);
					//Pause spawn timer
					var timePast = Math.abs(getTimer() - enemySpawnTimerStartTimestamp);
					var deltaDelay = Math.abs(counterEnemySpawn.delay - timePast);
					counterEnemySpawn.stop();
					counterEnemySpawn = new Timer(deltaDelay, 1);
					counterEnemySpawn.addEventListener(TimerEvent.TIMER, enemySpawnHandler);
				} else {
					stageRef.removeChild(pauseLabel);
					//Reengage spawn timer after paused
					counterEnemySpawn.start();
					enemySpawnTimerStartTimestamp = getTimer();
				}
			}
		}
		
		/**
		* Removes a bullet from the scene.
		* @param index Index of the bullet in scenes internal bullet list
		**/
		private function removeBullet(bullet: Bullet, index: Number): void {
			if(index != -1) {
				bullets.splice(index, 1);
			}
			stageRef.removeChild(bullet);
		}
		/**
		* Removes a fly from the scene.
		* @param fly The fly to remove
		* @param index Index of the fly in scenes internal fly list
		**/
		private function removeFly(fly: Fly, index: Number): void {
			if(index != -1) {
				flies.splice(index, 1);
			}
			stageRef.removeChild(fly);
			enemiesRemaining--;
		}
		/**
		* Removes a fly boss from the scene.
		* @param thatFlyBoss The flyBoss to remove.
		**/
		private function removeFlyBoss(thatFlyBoss: FlyBoss): void {
			flyBoss = null;
			stageRef.removeChild(thatFlyBoss);
			enemiesRemaining--;
		}
		/**
		* Spawns a Fly-typed enemy randomly on the scene.
		* Ensures also that the player has a protection zone around him where no flies will spawn.
		**/
		private function spawnEnemy(): void {
			const PLAYER_PROTECTION_MARGIN = player.getWidth();
			var playerProtectionLeftBound = getPlayerX() - (player.getWidth() / 2) - PLAYER_PROTECTION_MARGIN;
			var playerProtectionRightBound = getPlayerX() + (player.getWidth() / 2) + PLAYER_PROTECTION_MARGIN;
			var playerProtectionTopBound = getPlayerY() - (player.getHeight() / 2) - PLAYER_PROTECTION_MARGIN;
			var playerProtectionBottomBound = getPlayerY() + (player.getHeight() / 2) + PLAYER_PROTECTION_MARGIN;
			
			const COUNTER_LIMIT = 50;
			var counter: Number = 0;
			var spawnX: Number;
			do {
				spawnX = Math.floor(Math.random() * (getRightBound() - getLeftBound()) + getLeftBound());
			} while(spawnX >= playerProtectionLeftBound && spawnX <= playerProtectionRightBound && counter < 50);
			counter = 0;
			var spawnY: Number;
			do {
				spawnY = Math.floor(Math.random() * (getBottomBound() - getTopBound()) + getTopBound());
			} while(spawnY >= playerProtectionTopBound && spawnY <= playerProtectionBottomBound && counter < 50);
			
			if(enemiesSpawned == ENEMY_AMOUNT - 1) {
				new FlyBoss(this, spawnX, spawnY, physic);
			} else {
				new Fly(this, spawnX, spawnY, physic);
			}
			enemiesSpawned++;
		}
	}
}