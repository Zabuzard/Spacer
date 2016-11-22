package {
	/**
	* Interface for physically forms that can be used by objects to get affected by a physic engine.
	**/
	public interface PhysicForm {
		/**
		* Gets the inertia factor of this form.
		* @return Inertia factor between 0 and 1.
		**/
		function getInertia(): Number;
		/**
		* Returns if this form can collide with scenes bounds.
		* @return True if this form can collide with scenes bounds
		**/
		function isCollidesWithSceneBound(): Boolean;
		/**
		* Gets the basic speed of this form.
		* @return Basic speed of this form
		**/
		function getSpeed(): Number;
		/**
		* Gets the reaction of this form when colliding with scenes bounds.
		* Defined by SceneCollisionReaction-enumeration.
		* @return Reaction when colliding with scenes bounds as string defined by SceneCollisionReaction-enumeration
		**/
		function getSceneCollisionReaction(): String;
	}
}