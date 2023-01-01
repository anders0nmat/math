
extension Vector3 where V == Double {
	// Vector Properties

	public var lengthSquared: V { dot(self) }
	public var length: V { lengthSquared.squareRoot() }

	public func normalized() -> Self { self / length }
	public mutating func normalize() { self = self.normalized() }

	public func dot(_ other: Self) -> V { x * other.x + y * other.y + z * other.z }
	public func cross(_ other: Self) -> Self {
		Self.init(
			x: y * other.z - z * other.y,
			y: z * other.x - x * other.z,
			z: x * other.y - y * other.x
		)
	}
}
