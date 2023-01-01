
extension Vector4 {
	init(_ base: Vector2<V>, z: V, w: V) { self.init(x: base.x, y: base.y, z: z, w: w) }
	init(_ base: Vector2<V>, _ z: V, _ w: V) { self.init(base, z: z, w: w) }
	init(_ base: Vector2<V>) where V: AdditiveArithmetic { self.init(base, .zero, .zero) }
	init(_ base: Vector2<V>, z: V) where V: AdditiveArithmetic { self.init(base, z, .zero) }

	init(_ base: Vector3<V>, w: V) { self.init(x: base.x, y: base.y, z: base.z, w: w) }
	init(_ base: Vector3<V>, _ w: V) { self.init(base, w: w) }
	init(_ base: Vector3<V>) where V: AdditiveArithmetic { self.init(base, .zero) }
}

extension Vector2 {
	init(trunc base: Vector4<V>) { self.init(x: base.x, y: base.y) }
}

extension Vector3 {
	init(trunc base: Vector4<V>) { self.init(x: base.x, y: base.y, z: base.z) }
}

