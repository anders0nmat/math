
public struct Vector2<V> {
	internal static var componentCount: Array.Index { 2 }

	public var x: V
	public var y: V

	public var array: [V] { [x, y] }

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
				default: return
			}
		}
	}

	public init(x: V, y: V) {
		self.x = x
		self.y = y
	}
	public init(_ x: V, _ y: V) { self.init(x: x, y: y) }
	public init(value: V) { self.init(x: value, y: value) }
	public init(_ value: V) { self.init(value: value) }
}

public typealias Vec2 = Vector2<Double>
public typealias Vec2f = Vector2<Float>
public typealias Vec2i = Vector2<Int>
public typealias Vec2ui = Vector2<UInt>
public typealias Vec2b = Vector2<Bool>


extension Vector2: Equatable where V: Equatable {}
extension Vector2: Hashable where V: Hashable {}
extension Vector2: Codable where V: Codable {}

// Component Alias
public extension Vector2 {
	// Color
	var r: V {
		get { x }
		set { x = newValue }
	}

	var g: V {
		get { y }
		set { y = newValue }
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
}

extension Vector2: AdditiveArithmetic where V: AdditiveArithmetic {
	// Conformance
	
	public static var zero: Vector2<V> { .init(value: .zero) }

	public static prefix func +(x: Self) -> Self { x }
	public static func +(lhs: Self, rhs: Self) -> Self { .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y) }
	public static func -(lhs: Self, rhs: Self) -> Self { .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y) }

	// Conveniance

	public init() { self.init(value: .zero) }
}

extension Vector2 where V: Numeric {
	// Scalar Operations

	public static func *(lhs: Self, rhs: V) -> Self { .init(x: lhs.x * rhs, y: lhs.y * rhs) }
	public static func *=(lhs: inout Self, rhs: V) { lhs = lhs * rhs }
}

extension Vector2 where V: BinaryFloatingPoint {
	// Conversion

	public init<Other: BinaryInteger>(_ other: Vector2<Other>) {
		self.init(x: V(other.x), y: V(other.y))
	}

	public init<Other: BinaryFloatingPoint>(_ other: Vector2<Other>) {
		self.init(x: V(other.x), y: V(other.y))
	}
}

extension Vector2 where V: BinaryInteger {
	// Conversion

	public init<Other: BinaryInteger>(_ other: Vector2<Other>) {
		self.init(x: V(other.x), y: V(other.y))
	}

	public init<Other: BinaryFloatingPoint>(_ other: Vector2<Other>) {
		self.init(x: V(other.x), y: V(other.y))
	}
}

extension Vector2 where V: FloatingPoint {
	public static func /(lhs: Self, rhs: V) -> Self { .init(x: lhs.x / rhs, y: lhs.y / rhs) }
	public static func /=(lhs: inout Self, rhs: V) { lhs = lhs / rhs }
}

extension Vector2 where V: BinaryInteger {
	public static func /(lhs: Self, rhs: V) -> Self { .init(x: lhs.x / rhs, y: lhs.y / rhs) }
	public static func /=(lhs: inout Self, rhs: V) { lhs = lhs / rhs }
}

extension Vector2 where V: SignedNumeric {
	public static prefix func -(x: Self) -> Self { .init(x: -x.x, y: -x.y) }
}
