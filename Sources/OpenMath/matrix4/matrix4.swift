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

public typealias Mat4 = Matrix4<Float>
public typealias Mat4d = Matrix4<Double>

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


