//
// Created by Jacob Caraballo on 5/26/23
//
        

import Foundation
import UIKit

public class LineGraph: UIStackView {
	
	public typealias OnFilter = (_ filter: GraphFilterChip) -> Void
	
	public var onFilter: OnFilter?
	
	private var display: GraphDisplay
	
	public var dataPoints: [GraphDisplayPoint] {
		get { self.display.dataPoints }
		set { self.display.dataPoints = newValue }
	}
	
	public lazy var header: GraphHeader = {
		let header = GraphHeader()
		header.title = "$74,750.77"
		header.subtitle = "▲ $1,278.29"
		header.layoutMargins = .init(all: .large)
		header.isLayoutMarginsRelativeArrangement = true
		return header
	}()
	
	private var indicatorXConstraint: NSLayoutConstraint?
	
	private var indicatorHeader: TinyListItem = {
		let header = TinyListItem(Theme.LineGraphIndicatorHeader.regular)
		header.isHidden = true
		return header
	}()
	
	private var indicator: LineGraph.Indicator = {
		let indicator = LineGraph.Indicator()
		indicator.isHidden = true
		return indicator
	}()
	
	public var filterChips: [GraphFilterChip]? {
		didSet {
			if let filterChips {
				tabList = .init(items: filterChips)
				tabList?.onAction = { [weak self] button in
					guard let filter = button as? GraphFilterChip else { return }
					self?.onFilter?(filter)
				}
				setupFilters()
			} else {
				tabList?.removeFromSuperview()
				tabList = nil
			}
		}
	}
	
	public var tabList: TabList?
	
	private var topMarginForHeader: CGFloat = 70.0
	private var bottomMarginForFooter: CGFloat = 50.0
	
	init(display: GraphDisplay) {
		self.display = display
		super.init(frame: .zero)
		
		self.axis = .vertical
		self.distribution = .fill
		self.alignment = .fill
		self.spacing = .xLarge
		
		setup()
	}
	
	public required init(coder: NSCoder) {
		fatalError()
	}
	
	private func setup() {
		self.addArrangedSubview(header)
		self.addArrangedSubview(display)
		
		self.setCustomSpacing(50, after: header)
				
		self.addSubview(indicatorHeader)
		self.addSubview(indicator)
		
		indicator.constrain([.top, .bottom], to: .target(display))
		
		indicatorHeader.constrain(
			.bottom,
			to: .target(indicator, .top),
			modifiers: .margins(.init(vertical: .regular)))
		indicatorHeader.constrain(
			.centerX,
			to: .target(indicator),
			modifiers: .priority(.defaultLow))
		
		indicatorHeader.constrain(
			.leading,
			greaterThanOrEqualTo: .superview,
			modifiers: .margins(.init(horizontal: .small)))
		indicatorHeader.constrain(
			.trailing,
			lessThanOrEqualTo: .superview,
			modifiers: .margins(.init(horizontal: .small)))
	}
	
	private func setupFilters() {
		guard let tabList,
			  tabList.superview == nil
		else { return }
		
		addArrangedSubview(tabList)
		
		tabList.constrain(.bottomEdges)
	}
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let location = touches.first?.location(in: self) else { return }
		panningChanged(in: location)
	}
	
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let location = touches.first?.location(in: self) else { return }
		panningChanged(in: location)
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		endPanning()
	}
	
	public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		endPanning()
	}
	
	private func panningChanged(in location: CGPoint) {
		guard let dataPoint = display.getDataPoint(for: location) else { return }
		
		indicator.isHidden = false
		indicatorHeader.isHidden = false
		indicatorHeader.title = dataPoint.title
		indicatorHeader.subtitle = dataPoint.valueString
		
		header.title = dataPoint.valueString
				
		indicatorXConstraint?.isActive = false
		indicatorXConstraint = indicator.constrain(.centerX, to: .target(dataPoint)).first
		indicator.superview?.layoutIfNeeded()
	}
	
	private func endPanning() {
		indicatorHeader.title = nil
		indicatorHeader.subtitle = nil
		indicator.isHidden = true
		indicatorHeader.isHidden = true
	}
	
}

extension LineGraph {
	
	class Indicator: UIStackView {
		
		private lazy var line: UIView = {
			let line = UIView()
			line.constrain(.width, toConstant: 1)
			line.backgroundColor = .separator
			return line
		}()
		
		init() {
			super.init(frame: .zero)
			
			self.axis = .vertical
			self.distribution = .fill
			self.alignment = .center
			
			setup()
		}
		
		required init(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		private func setup() {
			self.addArrangedSubviews([
				line
			])
		}
		
	}
	
}

import SwiftUI
import UIKitPreviews
import LoremSwiftum
struct LineGraph_Previews: PreviewProvider {
	static var previews: some View {
		UIKitPreviews { viewController }
	}
	
	static var viewController: UIViewController = {
		let vc = UIViewController()
		vc.view.addSubview(view)
		view.constrain(.topEdges, to: .superview)
		view.constrain(.height, to: .superview, modifiers: .multiplier(0.5))
		return vc
	}()
	
	static var view: UIView = {
		let dataPoints: [LineGraphDisplayPoint] = Date.daysForCurrentYear.map { day in
				.init(title: Lorem.word, value: .random(in: 25000...75000), dateRange: (day.startOfDay...day.endOfDay))
		}
		let display = LineGraphDisplay(dataPoints: dataPoints)
		let graph = LineGraph(display: display)
		graph.filterChips = [
			RegularGraphFilterChip(title: "1D", id: GraphFilterID.day),
			RegularGraphFilterChip(title: "1W", id: GraphFilterID.week),
			RegularGraphFilterChip(title: "1M", id: GraphFilterID.month),
			RegularGraphFilterChip(title: "3M", id: GraphFilterID.threeMonths),
			RegularGraphFilterChip(title: "YTD", id: GraphFilterID.yearToDate),
			RegularGraphFilterChip(title: "1Y", id: GraphFilterID.year),
			RegularGraphFilterChip(title: "ALL", id: GraphFilterID.all)
		]
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
			graph.dataPoints = Date.daysForCurrentYear.dropLast(300).map { day in
					LineGraphDisplayPoint(title: Lorem.word, value: .random(in: 25000...75000), dateRange: (day.startOfDay...day.endOfDay))
			}
		}
		
//		graph.onFilter = { filter in
//			switch filter.id as! GraphFilterID {
//			case .day:
//				<#code#>
//			case .week:
//				<#code#>
//			case .month:
//				<#code#>
//			case .threeMonths:
//				<#code#>
//			case .yearToDate:
//				<#code#>
//			case .year:
//				<#code#>
//			case .all:
//				<#code#>
//			}
//		}
		return graph
	}()
	
	enum GraphFilterID: GraphFilterChipID {
		case day
		case week
		case month
		case threeMonths
		case yearToDate
		case year
		case all
	}
}

extension Theme {
	
	public enum LineGraphIndicatorHeader {
		case regular
	}
	
}

extension Theme.LineGraphIndicatorHeader: Theming {
	
	public var options: [ThemingOptions] {
		[
			.layoutMargins(.zero),
			.textAlignment(.center)
		]
	}
	
}
