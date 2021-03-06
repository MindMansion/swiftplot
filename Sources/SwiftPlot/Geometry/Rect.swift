/// A Rectangle in a bottom-left coordinate space.
///
public struct Rect: Equatable, Hashable {
    public var origin: Point
    public var size: Size

    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
}

extension Rect {

    public static let empty = Rect(origin: .zero, size: .zero)

    public var normalized: Rect {
        let normalizedOrigin = Point(
            origin.x + (size.width < 0 ? size.width : 0),
            origin.y + (size.height < 0 ? size.height : 0))
        let normalizedSize = Size(width: abs(size.width), height: abs(size.height))
        return Rect(origin: normalizedOrigin, size: normalizedSize)
    }

    // Coordinate accessors.

    public var minX: Float {
        return normalized.origin.x
    }

    public var minY: Float {
        return normalized.origin.y
    }

    public var midX: Float {
        return origin.x + (size.width / 2)
    }

    public var midY: Float {
        return origin.y + (size.height / 2)
    }

    public var maxX: Float {
        let norm = normalized
        return norm.origin.x + norm.size.width
    }

    public var maxY: Float {
        let norm = normalized
        return norm.origin.y + norm.size.height
    }

    public var center: Point {
        return Point(midX, midY)
    }

    public init(size: Size, centeredOn center: Point) {
        self = Rect(
            origin: Point(center.x - (size.width / 2), center.y - (size.height / 2)),
            size: size
        )
    }

    // Size accessors.

    public var width: Float {
        get { return size.width }
        set { size.width = newValue }
    }

    public var height: Float {
        get { return size.height }
        set { size.height = newValue }
    }

    // Rounding.

    /// Returns a version of this `Rect` rounded by `roundOutwards`.
    public var roundedOutwards: Rect {
        var rect = self
        rect.roundOutwards()
        return rect
    }

    /// Rounds this `Rect` to integer coordinates, by rounding all points away from the center.
    public mutating func roundOutwards() {
        origin.x.round(.down)
        origin.y.round(.down)
        size.width.round(.up)
        size.height.round(.up)
    }

    /// Returns a version of this `Rect` rounded by `roundInwards`.
    public var roundedInwards: Rect {
        var rect = self
        rect.roundInwards()
        return rect
    }

    /// Rounds this `Rect` to integer coordinates, by rounding all points towards the center.
    public mutating func roundInwards() {
        origin.x.round(.up)
        origin.y.round(.up)
        size.width.round(.down)
        size.height.round(.down)
    }

    // Subtraction operations.

    mutating func contract(by distance: Float) {
        origin.x += distance
        origin.y += distance
        size.width -= 2 * distance
        size.height -= 2 * distance
    }

    mutating func clampingShift(dx: Float = 0, dy: Float = 0) {
        origin.x += dx
        origin.y += dy
        size.width -= dx
        size.height -= dy
    }

    // Other Utilities.

    /// The range of Y coordinates considered inside this `Rect`.
    /// If a coordinate `y` is inside this Range, it means that `minY < y < maxY`,
    /// - i.e., it is _within_ and not _on_ the bounds of the `Rect`.
    internal var internalYCoordinates: Range<Float> {
        let norm = normalized
        return norm.origin.y.nextUp..<norm.origin.y.nextUp + norm.size.height
    }

    /// The range of X coordinates considered inside this `Rect`.
    /// If a coordinate `x` is inside this Range, it means that `minX < x < maxX`
    /// - i.e., it is _within_ and not _on_ the bounds of the `Rect`
    internal var internalXCoordinates: Range<Float> {
        let norm = normalized
        return norm.origin.x.nextUp..<norm.origin.x.nextUp + norm.size.width
    }
}

/// An edge of a `Rect`.
///
public enum RectEdge: Equatable, Hashable, CaseIterable {
    case left
    case right
    case top
    case bottom

    /// Whether or not this is a horizontal edge (i.e. top or bottom edge).
    ///
    public var isHorizontal: Bool {
        return self == .top || self == .bottom
    }

    /// Whether or not this is a vertical edge (i.e.left or right edge).
    ///
    public var isVertical: Bool {
        return self == .left || self == .right
    }
}
