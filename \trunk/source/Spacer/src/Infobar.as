package  {
	import flash.display.Stage;
	
	/**
	* Class for games infobar layer. Displays information about remaining enemies and players lifepoints.
	**/
	public final class Infobar {
		
		/**
		* Amount of boss typed enemies.
		**/
		private static const AMOUNT_OF_BOSSES = 1;
		/**
		* X-coordinate origin of the pre texture for the remaining enemies display.
		**/
		private static const REMAINING_ENEMIES_PRE_DISPLAY_ORIGIN_X = 56;
		/**
		* Y-coordinate origin of the pre texture for the remaining enemies display.
		**/
		private static const REMAINING_ENEMIES_PRE_DISPLAY_ORIGIN_Y = 48;
		/**
		* Offset in x-direction of the remaining enemies display to the pre texture.
		**/
		private static const REMAINING_ENEMIES_DISPLAY_OFFSET_X_TO_PRE = 58;
		/**
		* Offset in y-direction of the remaining enemies display to the pre texture.
		**/
		private static const REMAINING_ENEMIES_DISPLAY_OFFSET_Y_TO_PRE = -17;
		/**
		* Offset in x-direction of the remaining enemies display elements.
		**/
		private static const REMAINING_ENEMIES_DISPLAY_OFFSET_X = 26;
		/**
		* X-coordinate origin of the pre texture for the remaining bosses display.
		**/
		private static const REMAINING_BOSS_PRE_DISPLAY_ORIGIN_X = 276;
		/**
		* Y-coordinate origin of the pre texture for the remaining bosses display.
		**/
		private static const REMAINING_BOSS_PRE_DISPLAY_ORIGIN_Y = 52;
		/**
		* Offset in x-direction of the remaining bosses display to the pre texture.
		**/
		private static const REMAINING_BOSS_DISPLAY_OFFSET_X_TO_PRE = 48;
		/**
		* Offset in y-direction of the remaining bosses display to the pre texture.
		**/
		private static const REMAINING_BOSS_DISPLAY_OFFSET_Y_TO_PRE = -20;
		/**
		* Offset in x-direction of the remaining bosses display elements.
		**/
		private static const REMAINING_BOSS_DISPLAY_OFFSET_X = 26;
		/**
		* X-coordinate origin of the first heart display on the very right.
		**/
		private static const HEART_DISPLAY_ORIGIN_X = Utils.STAGE_WIDTH - 40;
		/**
		* Y-coordinate origin of the first heart display on the very right.
		**/
		private static const HEART_DISPLAY_ORIGIN_Y = 47;
		/**
		* Offset in x-direction of the heart display which should be used to draw next objects from right to left.
		**/
		private static const HEART_DISPLAY_OFFSET_X = -60;
		/**
		* Offset in x-direction of the player display to the heart textures.
		**/
		private static const PLAYER_DISPLAY_OFFSET_X_TO_HEART = -78;
		/**
		* Offset in y-direction of the player display to the heart textures.
		**/
		private static const PLAYER_DISPLAY_OFFSET_Y_TO_HEART = -3;
		
		/**
		* Player the infobar displays information about.
		**/
		private var player: Player;
		/**
		* Scene the infobar belongs to.
		**/
		private var scene: LevelScene;
		/**
		* Reference to the stage of the infobar.
		**/
		private var stageRef: Stage;
		/**
		* Pre texture for the remaining enemy display.
		**/
		private var remainingEnemiesPreDisplay: RemainingEnemyPreDisplay = new RemainingEnemyPreDisplay();
		/**
		* Pre texture for the remaining bosses display.
		**/
		private var remainingBossPreDisplay: RemainingBossPreDisplay = new RemainingBossPreDisplay();
		/**
		* Digit that stores the hundreds of the remaining enemies.
		**/
		private var remainingEnemiesDisplayDigitHundreds: Digit = new Digit();
		/**
		* Digit that stores the tens of the remaining enemies.
		**/
		private var remainingEnemiesDisplayDigitTens: Digit = new Digit();
		/**
		* Digit that stores the singles of the remaining enemies.
		**/
		private var remainingEnemiesDisplayDigitSingles: Digit = new Digit();
		/**
		* Digit that stores the hundreds of the remaining bosses.
		**/
		private var remainingBossDisplayDigitHundreds: Digit = new Digit();
		/**
		* Digit that stores the tens of the remaining bosses.
		**/
		private var remainingBossDisplayDigitTens: Digit = new Digit();
		/**
		* Digit that stores the singles of the remaining bosses.
		**/
		private var remainingBossDisplayDigitSingles: Digit = new Digit();
		/**
		* Player display in the inforbar.
		**/
		private var playerDisplay: Player;
		/**
		* Vector that stores all heart displays.
		**/
		private var hearts: Vector.<Heart> = new Vector.<Heart>();
		
		/**
		* Creates a new infobar that displays information about remaining enemies and players lifepoints.
		* @param thatScene Scene the infobar belongs to
		* @param thatPlayer Player of the scene
		* @param thatStageRef Reference to the stage of the infobar
		* @param thatPhysic Physic engine of the scene
		* @param thatKey Object that stores information about key presses
		**/
		public function Infobar(thatScene: LevelScene, thatPlayer: Player, thatStageRef: Stage, thatPhysic: PhysicEngine, thatKey: KeyObject): void {
			this.player = thatPlayer;
			this.scene = thatScene;
			this.stageRef = thatStageRef;
			
			//Remaining enemies pre display
			remainingEnemiesPreDisplay.x = REMAINING_ENEMIES_PRE_DISPLAY_ORIGIN_X;
			remainingEnemiesPreDisplay.y = REMAINING_ENEMIES_PRE_DISPLAY_ORIGIN_Y;
			stageRef.addChild(remainingEnemiesPreDisplay);
			
			//Remaining enemies display digits
			remainingEnemiesDisplayDigitHundreds.x = remainingEnemiesPreDisplay.x + REMAINING_ENEMIES_DISPLAY_OFFSET_X_TO_PRE;
			remainingEnemiesDisplayDigitHundreds.y = remainingEnemiesPreDisplay.y + REMAINING_ENEMIES_DISPLAY_OFFSET_Y_TO_PRE;
			stageRef.addChild(remainingEnemiesDisplayDigitHundreds);
			
			remainingEnemiesDisplayDigitTens.x = remainingEnemiesDisplayDigitHundreds.x + REMAINING_ENEMIES_DISPLAY_OFFSET_X;
			remainingEnemiesDisplayDigitTens.y = remainingEnemiesDisplayDigitHundreds.y;
			stageRef.addChild(remainingEnemiesDisplayDigitTens);
			
			remainingEnemiesDisplayDigitSingles.x = remainingEnemiesDisplayDigitTens.x + REMAINING_ENEMIES_DISPLAY_OFFSET_X;
			remainingEnemiesDisplayDigitSingles.y = remainingEnemiesDisplayDigitTens.y;
			stageRef.addChild(remainingEnemiesDisplayDigitSingles);
			
			//Remaining bosses pre display
			remainingBossPreDisplay.x = REMAINING_BOSS_PRE_DISPLAY_ORIGIN_X;
			remainingBossPreDisplay.y = REMAINING_BOSS_PRE_DISPLAY_ORIGIN_Y;
			stageRef.addChild(remainingBossPreDisplay);
			
			//Remaining bosses display digit
			remainingBossDisplayDigitHundreds.x = remainingBossPreDisplay.x + REMAINING_BOSS_DISPLAY_OFFSET_X_TO_PRE;
			remainingBossDisplayDigitHundreds.y = remainingBossPreDisplay.y + REMAINING_BOSS_DISPLAY_OFFSET_Y_TO_PRE;
			stageRef.addChild(remainingBossDisplayDigitHundreds);
			
			remainingBossDisplayDigitTens.x = remainingBossDisplayDigitHundreds.x + REMAINING_BOSS_DISPLAY_OFFSET_X;
			remainingBossDisplayDigitTens.y = remainingBossDisplayDigitHundreds.y;
			stageRef.addChild(remainingBossDisplayDigitTens);
			
			remainingBossDisplayDigitSingles.x = remainingBossDisplayDigitTens.x + REMAINING_BOSS_DISPLAY_OFFSET_X;
			remainingBossDisplayDigitSingles.y = remainingBossDisplayDigitTens.y;
			stageRef.addChild(remainingBossDisplayDigitSingles);
			
			//Heart display
			var i: int;
			for(i = 0; i < player.getLifepoints(); i++) {
				var heart = new Heart();
				heart.x = HEART_DISPLAY_ORIGIN_X + i * HEART_DISPLAY_OFFSET_X;
				heart.y = HEART_DISPLAY_ORIGIN_Y;
				stageRef.addChild(heart);
				hearts.push(heart);
			}
			
			//Player display
			playerDisplay = new Player(thatScene, hearts[hearts.length - 1].x + PLAYER_DISPLAY_OFFSET_X_TO_HEART,
					hearts[hearts.length - 1].y + PLAYER_DISPLAY_OFFSET_Y_TO_HEART, thatPhysic, thatKey);
			playerDisplay.rotation = 90;
			stageRef.addChild(playerDisplay);
		}
		/**
		* Disposes all used ressources and memories of the infobar.
		* Should be called right before destruction.
		* This infobar can't be used anymore after that this method was called.
		**/
		public function dispose(): void {
			remainingEnemiesPreDisplay.visible = false;
			stageRef.removeChild(remainingEnemiesPreDisplay);

			remainingEnemiesDisplayDigitHundreds.visible = false;
			stageRef.removeChild(remainingEnemiesDisplayDigitHundreds);
			
			remainingEnemiesDisplayDigitTens.visible = false;
			stageRef.removeChild(remainingEnemiesDisplayDigitTens);
			
			remainingEnemiesDisplayDigitSingles.visible = false;
			stageRef.removeChild(remainingEnemiesDisplayDigitSingles);
			
			remainingBossPreDisplay.visible = false;
			stageRef.removeChild(remainingBossPreDisplay);
			
			remainingBossDisplayDigitHundreds.visible = false;
			stageRef.removeChild(remainingBossDisplayDigitHundreds);
			
			remainingBossDisplayDigitTens.visible = false;
			stageRef.removeChild(remainingBossDisplayDigitTens);
			
			remainingBossDisplayDigitSingles.visible = false;
			stageRef.removeChild(remainingBossDisplayDigitSingles);
			
			while(hearts.length > 0) {
				var heart = hearts.pop();
				heart.visible = false;
				stageRef.removeChild(heart);
			}
			
			playerDisplay.dispose();
			stageRef.removeChild(playerDisplay);
		}
		/**
		* Logical run of the scene.
		**/
		public function tick() {
			//Remaining fly enemies
			var remainingFlyEnemies = Math.max(0, scene.getAmountRemainingEnemies() - AMOUNT_OF_BOSSES);
			
			var hundredsFlies = Math.floor((remainingFlyEnemies % 1000) / 100);
			var tensFlies = Math.floor((remainingFlyEnemies % 100) / 10);
			var singlesFlies = remainingFlyEnemies % 10;
			
			remainingEnemiesDisplayDigitHundreds.setValue(hundredsFlies);
			remainingEnemiesDisplayDigitTens.setValue(tensFlies);
			remainingEnemiesDisplayDigitSingles.setValue(singlesFlies);
			
			//Remaining boss enemies
			var remainingBossEnemies = Math.min(scene.getAmountRemainingEnemies(), AMOUNT_OF_BOSSES);
			
			var hundredsBoss = Math.floor((remainingBossEnemies % 1000) / 100);
			var tensBoss = Math.floor((remainingBossEnemies % 100) / 10);
			var singlesBoss = remainingBossEnemies % 10;
			
			remainingBossDisplayDigitHundreds.setValue(hundredsBoss);
			remainingBossDisplayDigitTens.setValue(tensBoss);
			remainingBossDisplayDigitSingles.setValue(singlesBoss);
			
			//Players lifepoints
			var lifepoints = player.getLifepoints();
			var i: int;
			for(i = 0; i < hearts.length; i++) {
				if(lifepoints < hearts.length - i) {
					hearts[i].setState(false);
				}
			}
		}
	}
	
}
