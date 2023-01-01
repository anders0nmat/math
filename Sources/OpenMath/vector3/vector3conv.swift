
extension Vector3 {
	init(_ base: Vector2<V>, z: V) { self.init(x: base.x, y: base.y, z: z) }
	init(_ base: Vector2<V>, _ z: V) { self.init(base, z: z) }
	init(_ base: Vector2<V>) where V: AdditiveArithmetic { self.init(base, .zero) }
}

extension Vector2 {
	init(trunc base: Vector3<V>) {
		self.x = base.x
		self.y = base.y
	}
}
