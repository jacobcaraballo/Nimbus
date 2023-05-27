//
//  StackedItemsLayout.swift
//	StackedItemsCarousel
//
//  Created by Andreas Verhoeven on 21/10/2021.
//

import UIKit
import Combine

/// A UICollectionViewLayout that shows a stack of items
/// that the user can swipe thru. The swipe animations
/// are completely driven by scrolling the collection view.
/// Only the items in the first section are used.
public class StackedItemsLayout: UICollectionViewLayout {
	
	init(height: CGFloat, layoutMargins: UIEdgeInsets) {
		self.height = height
		self.layoutMargins = layoutMargins
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let height: CGFloat
	
	private let layoutMargins: UIEdgeInsets
	
	private let scaleWhenSwiping: CGFloat = 0.8
	
	private let degreesRotationWhenSwiping: CGFloat = 10.0
	
	public var removesItemOnSwipe = false
	
	/// The size of each item
	public var itemSize: CGSize {
		guard let collectionView else { return .zero }
		let width = collectionView.bounds.width - layoutMargins.left - layoutMargins.right
		let height = height - layoutMargins.top - layoutMargins.bottom
		return .init(width: width, height: height)
	}
	
	/// The horizontal alignment of the complete stack of items
	public var horizontalAlignment: HorizontalAlignment = .middle {
		didSet {
			guard horizontalAlignment != oldValue else { return }
			invalidateLayout()
		}
	}
	
	/// The vertical alignment of the complete stack of items
	public var verticalAlignment: VerticalAlignment = .middle {
		didSet {
			guard verticalAlignment != oldValue else { return }
			invalidateLayout()
		}
	}
	
	/// The index of the item that is currently focussed and thus
	/// on top or in-flight of an "animation"
	public private(set) var currentlyFocusedItemIndex = 0
	
	/// the intrinsic content size for this layout
	public var intrinsicContentSize: CGSize {
		return CGSize(width: itemSize.width + totalEffectiveHorizontalOffset * 2, height: itemSize.height)
	}
	
	// MARK: - Private
	
	/// Our cached item
	private var items = [UICollectionViewLayoutAttributes]()
	private let perItemRotationRadians = CGFloat(2 * CGFloat.pi / 180)
	private let perItemScale = CGFloat(0.9)
	private let horizontalOffsets: [CGFloat] = [20, 14.5, 10, 9, 5]
	
	// the offset to use
	private var totalEffectiveHorizontalOffset: CGFloat {
		let numberOfItems = min(max(0, numberOfItems - 1), horizontalOffsets.count - 1)
		return ceil(horizontalOffsets.prefix(numberOfItems).reduce(CGFloat(0), +) * pow(perItemScale, CGFloat(horizontalOffsets.count - 1)))
	}
	
	/// Returns the horizontal offset for progress ("offset") for an item
	private func horizontalOffsetForProgress(_ offset: CGFloat) -> CGFloat {
		let index = Int(offset)
		let progress = offset - CGFloat(index)
		
		var value = horizontalOffsets
			.prefix(min(horizontalOffsets.count, max(0, index)))
			.reduce(CGFloat(0), +)
		if (0..<horizontalOffsets.count).contains(index) {
			value += horizontalOffsets[index] * progress
		}
		return value
	}
	
	/// the number of items in the collection view's first secion
	private var numberOfItems: Int {
		guard let collectionView = collectionView,
			  collectionView.numberOfSections != 0
		else { return 0 }
		return collectionView.numberOfItems(inSection: 0)
	}
	
}

// MARK: - UICollectionView

extension StackedItemsLayout {
	
	public override func prepare() {
		super.prepare()
		
		guard let collectionView = collectionView else { return }
		
		let numberOfItems = self.numberOfItems
		let size = collectionView.bounds.size
		let pageWidth = size.width
		
		// we need to have items and a width
		guard numberOfItems > 0,
				pageWidth > 0
		else {
			items = []
			return
		}
		
		/// calculates the contentOffset for an item at a given index
		func contentOffsetForIndex(_ index: Int) -> CGFloat {
			pageWidth * CGFloat(index)
		}
		
		/// calculates the ItemTransform for an item at the given relative index
		/// and swipe-to-next-item-progress
		func itemTransformForItem(index: Int, progress: CGFloat, isLeading: Bool) -> ItemTransform {
			let multiplier = CGFloat(isLeading ? -1 : 1)
			let pageProgress = contentOffsetForIndex(index)/pageWidth - progress * multiplier
			let horizontalOffset = horizontalOffsetForProgress(pageProgress) * multiplier
			let rotation = perItemRotationRadians * pageProgress * multiplier
			let scale = pow(0.9, pageProgress)
			return .init(horizontalOffset: horizontalOffset, rotation: rotation, scale: scale - 1)
		}
		
		let offset = collectionView.contentOffset.x
		let index = max(0, min(numberOfItems - 1, Int(offset / pageWidth)))
		let roundedIndex = max(0, min(numberOfItems - 1, Int(round(offset / pageWidth))))
		
		let canGoForward = currentlyFocusedItemIndex < numberOfItems - 1
		let canGoBackwards = currentlyFocusedItemIndex > 0
		
		/// we only change the `currentlyFocusedItemIndex` when we
		/// actually have seen the next/previous item fully, because
		/// if we're swiping backwards we move past a boundary,
		/// but it's still part of the current items animation
		if canGoForward && index > currentlyFocusedItemIndex  {
			currentlyFocusedItemIndex = index
		} else if canGoBackwards && offset <= contentOffsetForIndex(currentlyFocusedItemIndex - 1) {
			currentlyFocusedItemIndex = roundedIndex
		}
		
		let progressFromFocusedItem = (offset - contentOffsetForIndex(currentlyFocusedItemIndex)) / pageWidth
		let isMovingToLeadingStack = (progressFromFocusedItem > 0)
		let isMovingToTrailingStack = (progressFromFocusedItem < 0)
		let isRubberbanding = (!canGoForward && isMovingToLeadingStack) || (!canGoBackwards && isMovingToTrailingStack)
		
		/// cache all items
		items = (0..<numberOfItems).map { index in
			let item = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
			
			/// the frame of each item is the same, adjusted for the current content
			/// offset so our items do not scroll
			item.frame = .init(
				x: collectionView.contentOffset.x + horizontalAlignment.xPosition(itemSize: itemSize, in: collectionView, offset: totalEffectiveHorizontalOffset),
				y: collectionView.contentOffset.y + verticalAlignment.yPosition(itemSize: itemSize, in: collectionView),
				width: itemSize.width,
				height: itemSize.height)
			
			// we lay out our items relative to the current index:
			//	- the currently focused item is on top
			//  - items before it are on its leading side
			//  - items after it are on its trailing side
			let relativeIndex = abs(index - currentlyFocusedItemIndex)
			
			if index == currentlyFocusedItemIndex && !isRubberbanding  {
				// the top item that needs to animate to disappear behind the previous/next item
				// depending on the direction we are scrolling. Our animation exist of two parts:
				//	- the first part, where we move from the top of the stack to the side
				//  - the second part, where we move from the side of the stack to behind the new "top of stack"
				
				let factor = CGFloat(isMovingToLeadingStack ? -1 : 1)
				let degrees = degreesRotationWhenSwiping
				let scaledHeight = itemSize.height * scaleWhenSwiping
				let distance = (scaledHeight * -sin(degrees)) + (scaledHeight * cos(degrees))
				let offset = (itemSize.width / 2) + (itemSize.height * scaleWhenSwiping / 2) - distance
				
				let side = ItemTransform(
					horizontalOffset: offset + .small,
					rotation: degrees * .pi / 180,
					scale: -(1 - scaleWhenSwiping))
					.multiplyPositions(by: factor)
				
				let progress = abs(progressFromFocusedItem)
				if progress < 0.5 {
					// first part of the animation, we are still on top and are moving the item to the side
					item.zIndex = 0
					item.transform3D = side.easeInOutScrubbed(progress / 0.5).transform3D
				} else {
					// second part of the animation, we are moved to the side and are moving back and are now
					// behind the next item, so we need to make sure that this item zIndex is smaller than the next
					// item: -3 does this, because the next item starts at zIndex = -2
					item.zIndex = -3
					
					// also interpolate from the side position to our new final position
					let final = itemTransformForItem(
						index: 1,
						progress: 1,
						isLeading: isMovingToLeadingStack)
					let difference = removesItemOnSwipe ? final.add(side) : final.subtract(side)
					let interpolated = difference.easeInOutScrubbed((progress - 0.5) * 2)
					item.transform3D = side.add(interpolated).transform3D
				}
				return item
			} else if relativeIndex <= horizontalOffsets.count {
				// items that are next to the top item on the stack:
				// we need to change the zIndex depending if we're scrolling that stacks next item
				// into view: that stack gets to be on top of the other (but still behind the top item)
				let isPartOfLeadingStack = index < currentlyFocusedItemIndex
				if isMovingToLeadingStack != isPartOfLeadingStack {
					item.zIndex = -2 * relativeIndex
				} else {
					item.zIndex = -horizontalOffsets.count - 2 * relativeIndex
				}
				
				// calculate the transform for our items on the stacks
				item.transform3D = itemTransformForItem(index: relativeIndex, progress: progressFromFocusedItem, isLeading: isPartOfLeadingStack).transform3D
				
				// we animate in the alpha of the final item of the stack, so that it appears nicely
				switch (
					relativeIndex,
					isPartOfLeadingStack,
					progressFromFocusedItem
				) {
				case (horizontalOffsets.count, _, _):
					item.alpha = abs(progressFromFocusedItem)
					
				case (horizontalOffsets.count - 1, true, 1...):
					item.alpha = 1 - abs(progressFromFocusedItem)
					
				case (horizontalOffsets.count - 1, false, ..<0):
					item.alpha = 1 + progressFromFocusedItem
					
				default:
					item.alpha = 1
					
				}
				
				return item
			} else {
				item.isHidden = true
				item.frame = .zero
				return item
			}
		}
	}
	
	public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
	
	public override var collectionViewContentSize: CGSize {
		guard let collectionView = collectionView else { return .zero }
		let size = collectionView.bounds.inset(by: collectionView.adjustedContentInset)
		return CGSize(width: collectionView.bounds.width * CGFloat(items.count), height: size.height)
	}
	
	public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		return items.filter { $0.frame.intersects(rect) }
	}
	
	public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return items[indexPath.item]
	}
	
	public override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard let collectionView else { return nil }
		
		let item = UICollectionViewLayoutAttributes(forCellWith: itemIndexPath)
		item.frame = .init(
			x: -collectionView.frame.width,
			y: collectionView.contentOffset.y + verticalAlignment.yPosition(itemSize: itemSize, in: collectionView),
			width: itemSize.width,
			height: itemSize.height)
		item.alpha = 0
		item.isHidden = true
		return item
	}
	
}

// MARK: - Alignment

extension StackedItemsLayout {
	
	public enum HorizontalAlignment {
		case leading
		case middle
		case trailing
		
		fileprivate func xPosition(itemSize: CGSize, in collectionView: UICollectionView, offset: CGFloat) -> CGFloat {
			let width = collectionView.bounds.inset(by: collectionView.adjustedContentInset).width
			switch self {
			case .leading: return width - offset - collectionView.adjustedContentInset.right - itemSize.width
			case .middle: return width * 0.5 - itemSize.width * 0.5 + collectionView.adjustedContentInset.left
			case .trailing: return offset + collectionView.adjustedContentInset.left
			}
		}
	}
	
	public enum VerticalAlignment {
		case top
		case middle
		case bottom
		
		fileprivate func yPosition(itemSize: CGSize, in collectionView: UICollectionView) -> CGFloat {
			let height = collectionView.bounds.inset(by: collectionView.adjustedContentInset).height
			switch self {
			case .top: return collectionView.adjustedContentInset.top
			case .middle: return height * 0.5 - itemSize.height * 0.5 + collectionView.adjustedContentInset.top
			case .bottom: return height - collectionView.adjustedContentInset.bottom - itemSize.height
			}
		}
	}
	
}

// MARK: - Item Transform

extension StackedItemsLayout {
	
	/// Structure that models a translate, rotate and scale transform
	private struct ItemTransform {
		var horizontalOffset: CGFloat
		var rotation: CGFloat
		var scale: CGFloat
		
		var transform3D: CATransform3D {
			var transform = CATransform3DIdentity
			transform = CATransform3DTranslate(transform, horizontalOffset, 0, 0)
			transform = CATransform3DRotate(transform, rotation, 0, 0, 1)
			transform = CATransform3DScale(transform, 1 + scale, 1 + scale, 1)
			return transform
		}
		
		func multiplyPositions(by factor: CGFloat) -> Self {
			return Self(horizontalOffset: horizontalOffset * factor,
						rotation: rotation * factor,
						scale: scale)
		}
		
		func add(_ other: Self) -> Self {
			return Self(horizontalOffset: horizontalOffset + other.horizontalOffset,
						rotation: rotation + other.rotation,
						scale: scale + other.scale)
		}
		
		func subtract(_ other: Self) -> Self {
			return Self(horizontalOffset: horizontalOffset - other.horizontalOffset,
						rotation: rotation - other.rotation,
						scale: scale - other.scale)
		}
		
		func linearScrubbed(_ progress: CGFloat) -> Self {
			return Self(
				horizontalOffset: horizontalOffset * progress,
				rotation: rotation * progress,
				scale: scale * progress)
		}
		
		func easeInOutScrubbed(_ progress: CGFloat) -> Self {
			return linearScrubbed(progress * progress * (3 - 2 * progress))
		}
	}
	
}
