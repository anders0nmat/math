
extension Vector4 where V == Double {
	// Vector Properties

	public var lengthSquared: V { dot(self) }
	public var length: V { lengthSquared.squareRoot() }

	public func normalized() -> Self { self / length }
	public mutating func normalize() { self = self.normalized() }

	public func dot(_ other: Self) -> V { x * other.x + y * other.y + z * other.z + w * other.w }
}
