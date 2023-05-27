//
//  StackedItemsView.swift
//  StackedItemsCarousel
//
//  Created by Andreas Verhoeven on 21/10/2021.
//

import UIKit
import Combine

/// A view that provides a stacked of scrollable items by wrapping a UICollectionView with a `StackedItemsLayout`
public class StackedItemsView<ItemType: Equatable, CellType: UICollectionViewCell>: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
	
	// MARK: - Init
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		
		var cancellable: AnyCancellable?
		cancellable = self.publisher(for: \.bounds)
			.first(where: { $0.width != .zero })
			.map(\.size)
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { _ in
				cancellable?.cancel()
			}, receiveValue: { size in
				self.setup()
			})
		
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	// MARK: -
	
	private lazy var layout: StackedItemsLayout = {
		let layout = StackedItemsLayout(height: 200, layoutMargins: .init(horizontal: 24))
		return layout
	}()
	
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.alwaysBounceHorizontal = true
		collectionView.clipsToBounds = false
		collectionView.isPagingEnabled = true
		collectionView.register(CellType.self, forCellWithReuseIdentifier: "Cell")
		return collectionView
	}()
	
	public var configureItemHandler: ConfigureItemHandler?
	public typealias ConfigureItemHandler = (_ item: ItemType, _ cell: CellType) -> Void
	
	public var onSelect: OnSelect?
	public typealias OnSelect = (_ item: ItemType, _ index: Int) -> Void
	
	public var items = [ItemType]()
	
	/// The horizontal alignment of the stack inside this view
	public var horizontalAlignment: StackedItemsLayout.HorizontalAlignment {
		get { layout.horizontalAlignment }
		set { layout.horizontalAlignment = newValue }
	}
	
	/// The verticalAlignment alignment of the stack inside this view
	public var verticalAlignment: StackedItemsLayout.VerticalAlignment {
		get { layout.verticalAlignment }
		set { layout.verticalAlignment = newValue }
	}
	
	/// The index of the item that is currently focused and on the top of the stack
	public var currentItemIndex: Int {
		return layout.currentlyFocusedItemIndex
	}
	
	/// Scrolls to a specific item by making it top of the stack
	public func scrollToItem(at index: Int, animated: Bool) {
		let xOffset = collectionView.bounds.width * CGFloat(index)
		let contentOffset = CGPoint(x: -collectionView.adjustedContentInset.left + xOffset, y: -collectionView.adjustedContentInset.top)
		collectionView.setContentOffset(contentOffset, animated: animated)
		if !animated {
			collectionView.setNeedsLayout()
			collectionView.layoutIfNeeded()
		}
	}
	
	/// Returns the cell at the given index, if visible
	public func cell(at index: Int) -> CellType? {
		collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? CellType
	}
	
	// MARK: UICollectionViewDataSource
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		items.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
		cell.setShadow()
		configureItemHandler?(items[indexPath.row], cell as! CellType)
		
		return cell
	}
	
	// MARK: UICollectionViewDelegate
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		switch indexPath.row {
		case currentItemIndex:
			collectionView.deselectItem(at: indexPath, animated: true)
			onSelect?(items[indexPath.row], indexPath.row)
			
		case 0..<currentItemIndex:
			scrollToItem(at: currentItemIndex - 1, animated: true)
			
		default:
			scrollToItem(at: currentItemIndex + 1, animated: true)
		}
		
	}
	
//	public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//		guard removesItemWhenSwiped else { return }
//		
//		deleteItem(at: indexPath.item)
//	}
//	
//	public func deleteItem(at index: Int) {
//		self.items.remove(at: index)
//		self.collectionView.deleteItems(at: [ .init(item: index, section: 0) ])
////		scrollToItem(at: index, animated: false)
////		{
////			didSet {
////				guard items != oldValue else { return }
////				collectionView.reloadData()
////				//			scrollToItem(at: 0, animated: false)
////			}
////		}
//	}
	
}

// MARK: - Setup

extension StackedItemsView {
	
	private func setup() {
		addSubview(collectionView)
		collectionView.constrain(.edges, to: .superview)
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct StackedItemsView_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.addSubview(view)
		view.constrain(.edges, to: .superview)
		return vc
	}()
	
	static var view: UIView = {
		let view = StackedItemsView<ListItem, ListItem.CollectionViewCell>()
		view.configureItemHandler = { item, cell in
			cell.listItem = item
		}
		view.items = [
			listItem,
			listItem,
			listItem,
			listItem,
			listItem,
			listItem
		]
		return view
	}()
	
	static var listItem: ListItem {
		let item = ListItem()
		item.topRightText = Lorem.word
		item.topLeftText = Lorem.word
		item.bottomRightText = Lorem.word
		item.bottomLeftText = Lorem.word
		item.leftIcon = .building
		item.leftSideColor = .systemRed
		item.bottomText = Lorem.sentences(3)
		item.rightIcon = .chevronRight
		item.onAction = {
			item.bottomText = Lorem.sentences(3)
		}
		item.setControl(.checkbox) { isOn in
			item.bottomRightText = isOn ? "Is Checked" : "Is Unchecked"
			item.bottomText = Lorem.sentences(3)
		}
		return item
	}
}
