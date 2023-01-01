
public struct Vector3<V> {
	internal static var componentCount: Array.Index { 3 }

	public var x: V
	public var y: V
	public var z: V

	public var array: [V] { [x, y, z] }

	public subscript(_ index: Array.Index) -> V {
		get {
			assert(index < Self.componentCount, "Index out of range")
			return array[index]
		}
		set {
			assert(index < Self.componentCount, "Index out of range")
			switch index {
				case 0: x = newValue
				case 1: y = newValue
				case 2: z = newValue
				default: return
			}
		}
	}

	public init(x: V, y: V, z: V) {
		self.x = x
		self.y = y
		self.z = z
	}
	public init(_ x: V, _ y: V, _ z: V) { self.init(x: x, y: y, z: z) }
	public init(value: V) { self.init(x: value, y: value, z: value) }
	public init(_ value: V) { self.init(value: value) }
}

public typealias Vec3 = Vector3<Double>
public typealias Vec3f = Vector3<Float>
public typealias Vec3i = Vector3<Int>
public typealias Vec3ui = Vector3<UInt>
public typealias Vec3b = Vector3<Bool>


extension Vector3: Equatable where V: Equatable {}
extension Vector3: Hashable where V: Hashable {}
extension Vector3: Codable where V: Codable {}

// Component Alias
public extension Vector3 {
	// Color
	var r: V {
		get { x }
		set { x = newValue }
	}

	var g: V {
		get { y }
		set { y = newValue }
	}

	var b: V {
		get { z }
		set { z = newValue }
	}

	// Texture Coords 
	var u: V {
		get { x }
		set { x = newValue }
	}

	var v: V {
		get { y }
		set { y = newValue }
	}

	var s: V {
		get { z }
		set { z = newValue }
	}
}

extension Vector3: AdditiveArithmetic where V: AdditiveArithmetic {
	// Conformance
	
	public static var zero: Vector3<V> { .init(value: .zero) }

	public static prefix func +(x: Self) -> Self { x }
	public static func +(lhs: Self, rhs: Self) -> Self { .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z) }
	public static func -(lhs: Self, rhs: Self) -> Self { .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z + rhs.z) }

	// Conveniance

	public init() { self.init(value: .zero) }
}

extension Vector3 where V: Numeric {
	// Scalar Operations

	public static func *(lhs: Self, rhs: V) -> Self { .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs) }
	public static func *=(lhs: inout Self, rhs: V) { lhs = lhs * rhs }
}

extension Vector3 where V: BinaryFloatingPoint {
	// Conversion

	public init<Other: BinaryInteger>(_ other: Vector3<Other>) {
		self.init(x: V(other.x), y: V(other.y), z: V(other.z))
	}

	public init<Other: BinaryFloatingPoint>(_ other: Vector3<Other>) {
		self.init(x: V(other.x), y: V(other.y), z: V(other.z))
	}
}

extension Vector3 where V: BinaryInteger {
	// Conversion

	public init<Other: BinaryInteger>(_ other: Vector3<Other>) {
		self.init(x: V(other.x), y: V(other.y), z: V(other.z))
	}

	public init<Other: BinaryFloatingPoint>(_ other: Vector3<Other>) {
		self.init(x: V(other.x), y: V(other.y), z: V(other.z))
	}
}

extension Vector3 where V: FloatingPoint {
	public static func /(lhs: Self, rhs: V) -> Self { .init(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs) }
	public static func /=(lhs: inout Self, rhs: V) { lhs = lhs / rhs }
}

extension Vector3 where V: BinaryInteger {
	public static func /(lhs: Self, rhs: V) -> Self { .init(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs) }
	public static func /=(lhs: inout Self, rhs: V) { lhs = lhs / rhs }
}

extension Vector3 where V: SignedNumeric {
	public static prefix func -(x: Self) -> Self { .init(x: -x.x, y: -x.y, z: -x.z) }
}
