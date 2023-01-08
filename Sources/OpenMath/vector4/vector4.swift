
public struct Vector4<V> {
	internal static var componentCount: Array.Index { 4 }

	public var x: V
	public var y: V
	public var z: V
	public var w: V

	public var array: [V] { [x, y, z, w] }

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
				case 3: w = newValue
				default: return
			}
		}
	}

	public init(x: V, y: V, z: V, w: V) {
		self.x = x
		self.y = y
		self.z = z
		self.w = w
	}
	public init(_ x: V, _ y: V, _ z: V, _ w: V) { self.init(x: x, y: y, z: z, w: w) }
	public init(value: V) { self.init(x: value, y: value, z: value, w: value) }
	public init(_ value: V) { self.init(value: value) }
}

public typealias Vec4 = Vector4<Float>
public typealias Vec4d = Vector4<Double>
public typealias Vec4i = Vector4<Int>
public typealias Vec4ui = Vector4<UInt>
public typealias Vec4b = Vector4<Bool>


extension Vector4: Equatable where V: Equatable {}
extension Vector4: Hashable where V: Hashable {}
extension Vector4: Codable where V: Codable {}

// Component Alias
public extension Vector4 {
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
	
	var a: V {
		get { w }
		set { w = newValue }
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

	var t: V {
		get { w }
		set { w = newValue }
	}
}

extension Vector4: AdditiveArithmetic where V: AdditiveArithmetic {
	// Conformance
	
	public static var zero: Vector4<V> { .init(value: .zero) }

	public static prefix func +(x: Self) -> Self { x }
	public static func +(lhs: Self, rhs: Self) -> Self { .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w) }
	public static func -(lhs: Self, rhs: Self) -> Self { .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z + rhs.z, w: lhs.w + rhs.w) }

	// Conveniance

	public init() { self.init(value: .zero) }
}

extension Vector4 where V: Numeric {
	// Scalar Operations

	public static func *(lhs: Self, rhs: V) -> Self { .init(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs, w: lhs.w * rhs) }
	public static func *=(lhs: inout Self, rhs: V) { lhs = lhs * rhs }
}

extension Vector4 where V: BinaryFloatingPoint {
	// Conversion

	public init<Other: BinaryInteger>(_ other: Vector4<Other>) {
		self.init(x: V(other.x), y: V(other.y), z: V(other.z), w: V(other.w))
	}

	public init<Other: BinaryFloatingPoint>(_ other: Vector4<Other>) {
		self.init(x: V(other.x), y: V(other.y), z: V(other.z), w: V(other.w))
	}
}

extension Vector4 where V: BinaryInteger {
	// Conversion

	public init<Other: BinaryInteger>(_ other: Vector4<Other>) {
		self.init(x: V(other.x), y: V(other.y), z: V(other.z), w: V(other.w))
	}

	public init<Other: BinaryFloatingPoint>(_ other: Vector4<Other>) {
		self.init(x: V(other.x), y: V(other.y), z: V(other.z), w: V(other.w))
	}
}

extension Vector4 where V: FloatingPoint {
	public static func /(lhs: Self, rhs: V) -> Self { .init(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs, w: lhs.w / rhs) }
	public static func /=(lhs: inout Self, rhs: V) { lhs = lhs / rhs }
}

extension Vector4 where V: BinaryInteger {
	public static func /(lhs: Self, rhs: V) -> Self { .init(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs, w: lhs.w / rhs) }
	public static func /=(lhs: inout Self, rhs: V) { lhs = lhs / rhs }
}

extension Vector4 where V: SignedNumeric {
	public static prefix func -(x: Self) -> Self { .init(x: -x.x, y: -x.y, z: -x.z, w: -x.w) }
}
