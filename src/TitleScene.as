package {
	import flash.display.Stage;

	/**
	* Class for a game title scene which has a state if the game should switch to a level scene.
	**/
	public final class TitleScene extends GameScene {
		/**
		* Offset the starting label has from the bottom of the stage in y-axis.
		**/
		private static const START_LABEL_Y_OFFSET_FROM_BOTTOM = 80;
		
		/**
		* True if the level should start.
		**/
		private var levelStart: Boolean = false;
		/**
		* Refference to the stage the scene belongs to.
		**/
		private var stageRef: Stage;
		/**
		* Object that stores information about key presses
		**/
		private var key: KeyObject;
		/**
		* Starting label of the title scene.
		**/
		private var startLabel: StartLabel;
		
		/**
		* Creates a new title scene for the game.
		* @param thatStageRef Refference to the stage the scene belongs to
		* @param Object that stores information about key presses
		**/
		public function TitleScene(thatStageRef: Stage, thatKey: KeyObject) {
			this.stageRef = thatStageRef;
			this.key = thatKey;
			startLabel = new StartLabel(Utils.STAGE_WIDTH / 2, Utils.STAGE_HEIGHT - START_LABEL_Y_OFFSET_FROM_BOTTOM);
			stageRef.addChild(startLabel);
		}
		//@Override
		public override function dispose(): void {
			startLabel.visible = false;
			stageRef.removeChild(startLabel);
		}
		/**
		* Returns if the level should start now.
		* @return True if the level should start now
		**/
		public function shouldLevelStart(): Boolean {
			return levelStart;
		}
		//@Override
		public override function tick(): void {
			levelStart = key.isDown(Utils.KEY_LEVEL_START);
		}
	}
}