//
//  AxisAnchor.swift
//  Swiftstraints
//
//  Created by Bradley Hilton on 10/22/15.
//  Copyright © 2015 Skyvive. All rights reserved.
//

import Foundation

public protocol AxisAnchor {
    associatedtype AnchorType : AnyObject
    var anchor: NSLayoutAnchor<AnchorType> { get }
    var constant: CGFloat { get }
    var priority: LayoutPriority { get }
}

public struct CompoundAxis<AnchorType : AnyObject> : AxisAnchor {
    public let anchor: NSLayoutAnchor<AnchorType>
    public let constant: CGFloat
    public let priority: LayoutPriority
}

extension AxisAnchor {
    
    func add(_ addend: CGFloat) -> CompoundAxis<AnchorType> {
        return CompoundAxis(anchor: anchor, constant: constant + addend, priority: priority)
    }
    
}

extension NSLayoutXAxisAnchor : AxisAnchor {
    public var anchor: NSLayoutAnchor<NSLayoutXAxisAnchor> { return self }
    public var constant: CGFloat { return 0 }
    public var priority: LayoutPriority { return .required }
}

extension NSLayoutYAxisAnchor : AxisAnchor {
    public var anchor: NSLayoutAnchor<NSLayoutYAxisAnchor> { return self }
    public var constant: CGFloat { return 0 }
    public var priority: LayoutPriority { return .required }
}

/// Create a layout constraint from an inequality comparing two axis anchors.
public func <=<T : AxisAnchor, U : AxisAnchor>(lhs: T, rhs: U) -> NSLayoutConstraint where T.AnchorType == U.AnchorType {
    return lhs.anchor.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.constant - lhs.constant).priority(rhs.priority)
}

/// Create a layout constraint from an equation comparing two axis anchors.
public func ==<T : AxisAnchor, U : AxisAnchor>(lhs: T, rhs: U) -> NSLayoutConstraint where T.AnchorType == U.AnchorType {
    return lhs.anchor.constraint(equalTo: rhs.anchor, constant: rhs.constant - lhs.constant).priority(rhs.priority)
}

/// Create a layout constraint from an inequality comparing two axis anchors.
public func >=<T : AxisAnchor, U : AxisAnchor>(lhs: T, rhs: U) -> NSLayoutConstraint where T.AnchorType == U.AnchorType {
    return lhs.anchor.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.constant - lhs.constant).priority(rhs.priority)
}

/// Add a constant to an axis anchor.
public func +<T : AxisAnchor>(axis: T, addend: CGFloat) -> CompoundAxis<T.AnchorType> {
    return axis.add(addend)
}

/// Add a constant to an axis anchor.
public func +<T : AxisAnchor>(addend: CGFloat, axis: T) -> CompoundAxis<T.AnchorType> {
    return axis.add(addend)
}

/// Subtract a constant from an axis anchor.
public func -<T : AxisAnchor>(axis: T, subtrahend: CGFloat) -> CompoundAxis<T.AnchorType> {
    return axis.add(-subtrahend)
}
