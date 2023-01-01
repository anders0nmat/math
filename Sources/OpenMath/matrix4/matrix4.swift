import Foundation

public struct Matrix4<V> {
	/*
	Layout as following:

		x y z w
		x y z w
		x y z w
		x y z w
	*/
	public var 
		x: Vector4<V>,
		y: Vector4<V>,
		z: Vector4<V>,
		w: Vector4<V>

	public subscript(column column: Int) -> Vector4<V> {
		get {
			switch column {
			case 0: return x
			case 1: return y
			case 2: return z
			case 3: return w
			default: preconditionFailure("Index out of range 0..3: \(column)")
			}
		}
		set {
			switch column {
			case 0: x = newValue
			case 1: y = newValue
			case 2: z = newValue
			case 3: w = newValue
			default: preconditionFailure("Index out of range 0..3: \(column)")
			}
		}
	}

	public subscript(row row: Int) -> Vector4<V> {
		get {
			switch row {
			case 0: return .init(x.x, y.x, z.x, w.x)
			case 1: return .init(x.y, y.y, z.y, w.y)
			case 2: return .init(x.z, y.z, z.z, w.z)
			case 3: return .init(x.w, y.w, z.w, w.w)
			default: preconditionFailure("Index out of range 0..3: \(row)")
			}
		}
		set {
			switch row {
			case 0: 
				x.x = newValue.x
				y.x = newValue.y
				z.x = newValue.z
				w.x = newValue.w
			case 1: 
				x.y = newValue.x
				y.y = newValue.y
				z.y = newValue.z
				w.y = newValue.w
			case 2:
				x.z = newValue.x
				y.z = newValue.y
				z.z = newValue.z
				w.z = newValue.w
			case 3:
				x.w = newValue.x
				y.w = newValue.y
				z.w = newValue.z
				w.w = newValue.w
			default: preconditionFailure("Index out of range 0..3: \(row)")
			}
		}
	}

	public subscript(column column: Int, row row: Int) -> V {
		get {
			self[column: column][row]
		}
		set {
			self[column: column][row] = newValue
		}
	}

	// Column-Major order of Data
	public var array: [V] { [x, y, z, w].flatMap { $0.array } }

	public init(
		_ m11: V, _ m12: V, _ m13: V, _ m14: V,
		_ m21: V, _ m22: V, _ m23: V, _ m24: V,
		_ m31: V, _ m32: V, _ m33: V, _ m34: V,
		_ m41: V, _ m42: V, _ m43: V, _ m44: V
	) {
		self.x = .init(m11, m21, m31, m41)
		self.y = .init(m12, m22, m32, m42)
		self.z = .init(m13, m23, m33, m43)
		self.w = .init(m14, m24, m34, m44)
	}

	public init(column0: Vector4<V>, column1: Vector4<V>, column2: Vector4<V>, column3: Vector4<V>) {
		self.x = column0
		self.y = column1
		self.z = column2
		self.w = column3
	}

	public init(row0: Vector4<V>, row1: Vector4<V>, row2: Vector4<V>, row3: Vector4<V>) {
		self.x = .init(row0.x, row1.x, row2.x, row3.x)
		self.y = .init(row0.y, row1.y, row2.y, row3.y)
		self.z = .init(row0.z, row1.z, row2.z, row3.z)
		self.w = .init(row0.w, row1.w, row2.w, row3.w)
	}

	public init(value: V) {
		self.x = .init(value)
		self.y = .init(value)
		self.z = .init(value)
		self.w = .init(value)
	}
	
	public init(_ value: V) {
		self.init(value: value)
	}

	func transposed() -> Self { .init(row0: x, row1: y, row2: z, row3: w) }
	mutating func transpose() { self = transposed() }
}

public typealias Mat4 = Matrix4<Double>

extension Matrix4: Equatable where V: Equatable {}
extension Matrix4: Hashable where V: Hashable {}
extension Matrix4: Codable where V: Codable {}

extension Matrix4: AdditiveArithmetic where V: AdditiveArithmetic {
	// Conformance
	
	public static var zero: Self { .init(value: .zero) }

	public static prefix func +(x: Self) -> Self { x }
	public static func +(lhs: Self, rhs: Self) -> Self {
		return .init(column0: lhs.x + rhs.x, column1: lhs.y + rhs.y, column2: lhs.z + rhs.z, column3: lhs.w + rhs.w)
	}
	public static func -(lhs: Self, rhs: Self) -> Self {
		return .init(column0: lhs.x - rhs.x, column1: lhs.y - rhs.y, column2: lhs.z - rhs.z, column3: lhs.w - rhs.w)
	}
}

extension Matrix4 where V == Double {
	// Default Values

	public static var identity: Self { Self() }

	public static func perspective(angle: Angle, ratio: V, near: V, far: V) -> Self {
		var r = Self()
		let t = tan(angle.radiants / 2)

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
		let one_minus_cos = 1 - cos(angle.radiants)
		let s = sin(angle.radiants)

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
