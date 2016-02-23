package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import Utils;
	import flash.events.MouseEvent;
	import PhysicEngine;
	import LevelScene;
	import flash.display.StageScaleMode;
	
	/**
	* Entry class of the game.
	* Will create and start a scene.
	**/
	public final
	class Main extends MovieClip {
		/**
		* Minimum time space between two game restarts in seconds.
		**/
		private static const RESTART_COOLDOWN_SEC = 2;
		/**
		* Physic engine of the game.
		**/
		private var physic: PhysicEngine;
		/**
		* Current scene of the game.
		**/
		private var scene: GameScene;
		/**
		* Object that stores information about key presses.
		**/
		private var key: KeyObject;
		/**
		* Time the game is running in seconds.
		**/
		private var seconds: Number = 0;
		/**
		* Timestamp of last restart in seconds.
		**/
		private var timestampLastRestart: Number = 0;
		/**
		* A frame counter that is used for game time calculation.
		**/
		private var frameCounter : Number = 0;
		/**
		* True if the level has already started.
		**/
		private var hasLevelStarted: Boolean = false;
		
		/**
		* Main function. Will create and start a scene.
		**/
		public function Main(): void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			gotoAndStop(1, "Szene 1");
			
			key = new KeyObject(stage);
			physic = new PhysicEngine(stage);
			scene = new TitleScene(stage, key);
			addEventListener(Event.ENTER_FRAME, loop, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}
		
		/**
		* Main game loop. Will evoke the tick-function on the current scene.
		* @param e Event that evoked the listener
		**/
		public function loop(e: Event): void {
			if(hasLevelStarted) {
				frameCounter++;
				if (frameCounter >= stage.frameRate) {
					seconds++;
				}
				frameCounter %= stage.frameRate;
				
				if(key.isDown(Utils.KEY_RESTART)
					&& (seconds > timestampLastRestart + RESTART_COOLDOWN_SEC || seconds < timestampLastRestart)) {
					timestampLastRestart = seconds;
					createNewGameInstance();
				}
			} else if(scene is TitleScene) {
				var title: TitleScene = scene as TitleScene;
				if(title.shouldLevelStart()) {
					hasLevelStarted = true;
					gotoAndStop(1, "Szene 2");
					createNewGameInstance();
				}
			}
			scene.tick();
		}
		/**
		* User input handler for mouse down events.
		* @param e Mouse event that evoked the listener
		**/
		public function mouseDownHandler(e:MouseEvent): void {
			scene.mousePressed(true);
		}
		/**
		* User input handler for mouse up events.
		* @param e Mouse event that evoked the listener
		**/
		public function mouseUpHandler(e:MouseEvent): void {
			scene.mousePressed(false);
		}
		/**
		* Creates a new game instance. Can also be used for restarting the game.
		**/
		private function createNewGameInstance(): void {
			if(scene != null) {
				scene.dispose();
			}
			scene = new LevelScene(physic, stage, key, Utils.STAGE_WIDTH, Utils.STAGE_HEIGHT);
		}
	}
}