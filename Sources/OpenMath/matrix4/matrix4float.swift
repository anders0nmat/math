import Foundation


extension Matrix4 where V: BinaryFloatingPoint {
	// Default Values

	public static var identity: Self { Self() }

	public static func perspective(angle: Angle, ratio: V, near: V, far: V) -> Self {
		var r = Self()
		let t = V(tan(angle.radiants / 2))

		r[column: 0, row: 0] = 1 / (ratio * t)
		r[column: 1, row: 1] = 1 / t
		r[column: 2, row: 3] = -1
		
		r[column: 2, row: 2] = -(far + near) / (far - near)
		r[column: 3, row: 2] = -(2 * far * near) / (far - near)

		return r
	}

	public static func ortho(left: V, right: V, bottom: V, top: V, near: V, far: V) -> Self {
		var r = Self()
		r[column: 0, row: 0] = 2 / (right - left)
		r[column: 1, row: 1] = 2 / (top - bottom)
		r[column: 2, row: 2] = 2 / (far - near)

		r[column: 3, row: 0] = (right + left) / (right - left)
		r[column: 3, row: 1] = (top + bottom) / (top - bottom)
		r[column: 3, row: 2] = (far + near) / (far - near)

		return r
	}

	public static func lookAt(from position: Vector3<V>, to target: Vector3<V>, up: Vector3<V>) -> Self {
		var r = Self()
		let f = (target - position).normalized()
		let s = f.cross(up).normalized()
		let u = s.cross(f)

		r[column: 0, row: 0] = s.x
		r[column: 1, row: 0] = s.y
		r[column: 2, row: 0] = s.z

		r[column: 0, row: 1] = u.x
		r[column: 1, row: 1] = u.y
		r[column: 2, row: 1] = u.z

		r[column: 0, row: 2] = -f.x
		r[column: 1, row: 2] = -f.y
		r[column: 2, row: 2] = -f.z

		r[column: 3, row: 0] = -(s.dot(position))
		r[column: 3, row: 1] = -(u.dot(position))
		r[column: 3, row: 2] = f.dot(position)

		return r
	}

	// Scalar Operations

	public static func *(lhs: Self, rhs: Self) -> Self {
		let tlhs = lhs.transposed()
		let newX = Vector4<V>(
			tlhs[column: 0].dot(rhs[column: 0]),
			tlhs[column: 1].dot(rhs[column: 0]),
			tlhs[column: 2].dot(rhs[column: 0]),
			tlhs[column: 3].dot(rhs[column: 0])
		)
		let newY = Vector4<V>(
			tlhs[column: 0].dot(rhs[column: 1]),
			tlhs[column: 1].dot(rhs[column: 1]),
			tlhs[column: 2].dot(rhs[column: 1]),
			tlhs[column: 3].dot(rhs[column: 1])
		)
		let newZ = Vector4<V>(
			tlhs[column: 0].dot(rhs[column: 2]),
			tlhs[column: 1].dot(rhs[column: 2]),
			tlhs[column: 2].dot(rhs[column: 2]),
			tlhs[column: 3].dot(rhs[column: 2])
		)
		let newW = Vector4<V>(
			tlhs[column: 0].dot(rhs[column: 3]),
			tlhs[column: 1].dot(rhs[column: 3]),
			tlhs[column: 2].dot(rhs[column: 3]),
			tlhs[column: 3].dot(rhs[column: 3])
		)

		return .init(column0: newX, column1: newY, column2: newZ, column3: newW)
	}

	public static func *(lhs: Self, rhs: Vector4<V>) -> Vector4<V> {
		let tlhs = lhs.transposed()
		return .init(tlhs[column: 0].dot(rhs), tlhs[column: 1].dot(rhs), tlhs[column: 2].dot(rhs), tlhs[column: 3].dot(rhs))
	}

	// Convenience Init

	public init(x: V = 1, y: V = 1, z: V = 1, w: V = 1) {
		self.init(column0: .init(x, 0, 0, 0), column1: .init(0, y, 0, 0), column2: .init(0, 0, z, 0), column3: .init(0, 0, 0, w))
	}

	// Modifying operations
	func translated(_ vec: Vector4<V>) -> Self {
		var translateMat = Self()
		translateMat[column: 3] = vec
		return translateMat * self
	}
	public func translated(_ vec: Vector3<V>) -> Self { translated(.init(vec, 1)) }
	public func translated(x: V, y: V, z: V) -> Self { translated(.init(x, y, z)) }

	public mutating func translate(_ vec: Vector3<V>) { self = translated(vec) }
	public mutating func translate(x: V, y: V, z: V) { self = translated(x: x, y: y, z: z)}

	public enum Angle {
		case rad(Double)
		case deg(Double)

		internal var radiants: Double {
			switch self {
				case .deg(let deg): return deg * (Double.pi / 180)
				case .rad(let rad): return rad
			}
		}
	}

	public func rotated(angle: Angle, axis: Vector3<V>) -> Self {
		var rotMat = Self()
		let vec = axis.normalized()
		let one_minus_cos = 1 - V(cos(angle.radiants))
		let s = V(sin(angle.radiants))

		rotMat[column: 0, row: 0] = 1 + one_minus_cos * (vec.x * vec.x - 1)
		rotMat[column: 0, row: 1] = vec.z * s + one_minus_cos * vec.x * vec.y
		rotMat[column: 0, row: 2] = -vec.y * s + one_minus_cos * vec.x * vec.z

		rotMat[column: 1, row: 0] = -vec.z * s + one_minus_cos * vec.x * vec.y
		rotMat[column: 1, row: 1] = 1 + one_minus_cos * (vec.y * vec.y - 1)
		rotMat[column: 1, row: 2] = vec.x * s + one_minus_cos * vec.y * vec.z

		rotMat[column: 2, row: 0] = vec.y * s + one_minus_cos * vec.x * vec.z
		rotMat[column: 2, row: 1] = -vec.x * s + one_minus_cos * vec.y * vec.z
		rotMat[column: 2, row: 2] = 1 + one_minus_cos * (vec.z * vec.z - 1)

		return rotMat * self
	}

	public func rotated(angle: Angle, x: V, y: V, z: V) -> Self { rotated(angle: angle, axis: .init(x, y, z)) }

	public mutating func rotate(angle: Angle, axis: Vector3<V>) { self = rotated(angle: angle, axis: axis) }
	public mutating func rotate(angle: Angle, x: V, y: V, z: V) { self = rotated(angle: angle, x: x, y: y, z: z) }

	public func scaled(_ vec: Vector3<V>) -> Self { Self(x: vec.x, y: vec.y, z: vec.z) * self }
	public func scaled(x: V, y: V, z: V) -> Self { scaled(.init(x, y, z)) }
	public func scaled(by value: V) -> Self { scaled(.init(value)) }

	public mutating func scale(_ vec: Vector3<V>) { self = scaled(vec) }
	public mutating func scale(x: V, y: V, z: V) { self = scaled(x: x, y: y, z: z) }
	public mutating func scale(by value: V) { self = scaled(by: value) }
}