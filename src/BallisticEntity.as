package {
	import SceneCollisionReaction;
	
	/**
	* Form for basic ballistic sprites. Is fast can collide with scenes bounds and then will get destroyed.
	**/
	public final class BallisticEntity implements PhysicForm {
		/**
		* Inertia factor of this form.
		**/
		private static const INERTIA: Number = 0.55;
		/**
		* Speed of this form.
		**/
		private static const SPEED: Number = 11;
		
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
			return SceneCollisionReaction.DESTROY;
		}
	}
}