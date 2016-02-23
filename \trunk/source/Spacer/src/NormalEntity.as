package {
	import SceneCollisionReaction;
	
	/**
	* Basic form for normal sprites. Has a moderate values can collide with scenes bounds and then will reset its position to a non colliding one.
	**/
	public final class NormalEntity implements PhysicForm {
		/**
		* Inertia factor of this form.
		**/
		private static const INERTIA: Number = 0.55;
		/**
		* Speed of this form.
		**/
		private static const SPEED: Number = 4;
		
		//@Override
		public function getInertia(): Number {
			return INERTIA;
		}
		//@Override
		public function isCollidesWithSceneBound(): Boolean {
			return true;
		}
		//@Override
		public function getSpeed(): Number {
			return SPEED;
		}
		//@Override
		public function getSceneCollisionReaction(): String {
			return SceneCollisionReaction.RESET;
		}
	}
}