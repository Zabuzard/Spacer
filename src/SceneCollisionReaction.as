package {
	/**
	* Enumeration of reactions that should occur to physically forms if colliding with scenes bounds.
	**/
	public final class SceneCollisionReaction {
		/**
		* Basic reaction to a collision. Will reset the position to a non colliding one.
		**/
		public static const RESET: String = "reset",
		/**
		* Will destroy the sprite at collision.
		**/
		DESTROY: String = "destroy";
	}
}