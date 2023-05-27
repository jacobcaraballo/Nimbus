//
// Created by Jacob Caraballo on 5/26/23
//
        

import Foundation
import UIKit
import Combine

public class LineGraph: UIView {
	
	private var graphView: LineGraph.GraphView
	
	public var dataPoints: [DataPoint] {
		get { self.graphView.dataPoints }
		set { self.graphView.dataPoints = newValue }
	}
	
	public var lineColor: UIColor? {
		get { graphView.lineColor }
		set { graphView.lineColor = newValue }
	}
	
	public var colorForIncreasingLine: UIColor {
		get { graphView.colorForIncreasingLine }
		set { graphView.colorForIncreasingLine = newValue }
	}
	
	public var colorForDecreasingLine: UIColor {
		get { graphView.colorForDecreasingLine }
		set { graphView.colorForDecreasingLine = newValue }
	}
	
	private var indicatorXConstraint: NSLayoutConstraint?
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .appFont(.largeTitle)
		label.textColor = Colors.primaryLabel
		label.text = "$69,019.23"
		return label
	}()
	
	private var indicatorHeader: LineGraph.Header = {
		let header = LineGraph.Header()
		header.isHidden = true
		return header
	}()
	
	private var indicator: LineGraph.Indicator = {
		let indicator = LineGraph.Indicator()
		indicator.isHidden = true
		return indicator
	}()
	
	private var topMarginForHeader: CGFloat = 70.0
	private var bottomMarginForFooter: CGFloat = 50.0
	
	init(dataPoints: [DataPoint]) {
		self.graphView = .init(dataPoints: dataPoints)
		super.init(frame: .zero)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		self.addSubview(titleLabel)
		self.addSubview(graphView)
		self.addSubview(indicatorHeader)
		self.addSubview(indicator)
		
		titleLabel.constrain([.leading, .top], to: .superview, modifiers: .margins(.init(all: .regular)))
		
		indicator.constrain(.top, to: .target(indicatorHeader, .bottom), modifiers: .constant(.small))
		indicator.constrain(.height, to: .superview)
		indicatorXConstraint = indicator.constrain(.leading, to: .superview).first
		
		indicatorHeader.constrain(.top, to: .target(titleLabel, .bottomMargin), modifiers: .margins(.init(vertical: .regular)))
		indicatorHeader.constrain(.centerX, to: .target(indicator), modifiers: .priority(.defaultLow))
		indicatorHeader.constrain(.leading, greaterThanOrEqualTo: .superview, modifiers: .margins(.init(horizontal: .small)))
		indicatorHeader.constrain(.trailing, lessThanOrEqualTo: .superview, modifiers: .margins(.init(horizontal: .small)))
		
		graphView.constrain(.top, to: .target(titleLabel, .bottom), modifiers: .margins(.init(top: topMarginForHeader, left: 0, bottom: bottomMarginForFooter, right: 0)))
		graphView.constrain(.bottomEdges, to: .superview)
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
		guard let (dataPoint, xPosition) = graphView.getDataPointAtPosition(location) else { return }
		
		indicator.isHidden = false
		indicatorHeader.isHidden = false
		indicatorHeader.title = dataPoint.title
		indicatorHeader.subtitle = dataPoint.valueString
		
		let x = xPosition - indicator.frame.width / 2
		
		indicatorXConstraint?.constant = x
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
	
	public struct DataPoint {
		
		static var valueFormatter: NumberFormatter = {
			let formatter = NumberFormatter()
			formatter.numberStyle = .currency
			return formatter
		}()
		
		let title: String
		
		let value: Double
		
		public var valueStyle: NumberFormatter.Style {
			get { Self.valueFormatter.numberStyle }
			set {
				Self.valueFormatter.numberStyle = newValue
			}
		}
		
		var valueString: String {
			Self.valueFormatter.string(from: .init(floatLiteral: value)) ?? "N/A"
		}
		
		public init(title: String, value: Double) {
			self.title = title
			self.value = value
		}
		
	}
	
}

extension LineGraph {
	
	class Header: UIStackView {
		
		private lazy var titleLabel: UILabel = {
			let label = UILabel()
			label.isHidden = true
			label.textColor = Colors.primaryLabel
			label.textAlignment = .center
			label.font = .appFont(.headline)
			return label
		}()
		
		private lazy var subtitleLabel: UILabel = {
			let label = UILabel()
			label.isHidden = true
			label.textColor = Colors.secondaryLabel
			label.textAlignment = .center
			label.font = .appFont(.subheadline)
			return label
		}()
		
		var title: String? {
			get { titleLabel.text }
			set {
				titleLabel.text = newValue
				titleLabel.isHidden = newValue == nil
			}
		}
		
		var subtitle: String? {
			get { subtitleLabel.text }
			set {
				subtitleLabel.text = newValue
				subtitleLabel.isHidden = newValue == nil
			}
		}
		
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
				titleLabel,
				subtitleLabel
			])
		}
		
	}
	
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
	
	class GraphView: UIView {
		
		public var dataPoints: [LineGraph.DataPoint] {
			didSet {
				self.updateLine(in: self.bounds)
			}
		}
		
		private var lowestValuePoint: LineGraph.DataPoint {
			dataPoints.sorted { $0.value < $1.value }[0]
		}
		
		private var highestValuePoint: LineGraph.DataPoint {
			dataPoints.sorted { $0.value > $1.value }[0]
		}
		
		private lazy var lineLayer: CAShapeLayer = {
			let layer = CAShapeLayer()
			layer.fillColor = nil
			layer.strokeColor = UIColor.systemGreen.cgColor
			layer.lineWidth = 2
			layer.lineJoin = .round
			layer.lineCap = .round
			layer.actions = [
				"position" : NSNull(),
				"bounds" : NSNull(),
				"path" : NSNull()
			]
			return layer
		}()
		
		public var lineColor: UIColor? {
			didSet {
				lineLayer.strokeColor = lineColor?.cgColor
			}
		}
		
		public var colorForIncreasingLine: UIColor = .systemGreen
		
		public var colorForDecreasingLine: UIColor = .systemRed
		
		private var currentColorForDataPoints: UIColor {
			guard let firstValue = dataPoints.first?.value,
				  let lastValue = dataPoints.last?.value
			else { return .clear }
			
			return lastValue < firstValue ? colorForDecreasingLine : colorForIncreasingLine
		}
		
		private var linePoints = [CGFloat: LineGraph.DataPoint]()
		
		private var cancellables = Set<AnyCancellable>()
		
		init(dataPoints: [LineGraph.DataPoint]) {
			self.dataPoints = dataPoints
			super.init(frame: .zero)
			
			self.layer.addSublayer(lineLayer)
			self.setupBoundsListener()
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		private func setupBoundsListener() {
			self.publisher(for: \.bounds)
				.sink { [weak self] bounds in
					self?.updateLine(in: bounds)
				}
				.store(in: &cancellables)
		}
		
		private func updateLine(in bounds: CGRect) {
			guard !dataPoints.isEmpty else { return }
			if lineColor == nil {
				lineLayer.strokeColor = currentColorForDataPoints.cgColor
			}
			
			lineLayer.frame.size = bounds.size
			lineLayer.path = self.buildLinePath(in: bounds)
		}
		
		private func calculateTopMargin(of dataPoint: LineGraph.DataPoint, in bounds: CGRect) -> CGFloat {
			let bottomOffsetMultiplier = (dataPoint.value - lowestValuePoint.value) / (highestValuePoint.value - lowestValuePoint.value)
			let bottomPoint = bounds.height * bottomOffsetMultiplier
			return bounds.height - bottomPoint
		}
		
		private func buildLinePath(in bounds: CGRect) -> CGPath {
			
			let path = UIBezierPath()
			let spacing = bounds.width / CGFloat(dataPoints.count - 1)
			var currentX: CGFloat = 0
			
			linePoints.removeAll()
			
			dataPoints.enumerated().forEach { (index, dataPoint) in
				let topMargin = self.calculateTopMargin(of: dataPoint, in: bounds)
				let point = CGPoint(x: currentX, y: topMargin)
				
				linePoints[currentX] = dataPoint
				
				currentX += spacing
				
				guard index != 0 else {
					path.move(to: point)
					return
				}
				
				path.addLine(to: point)
			}
			
			return path.cgPath
			
		}
		
		internal func getDataPointAtPosition(_ position: CGPoint) -> (dataPoint: LineGraph.DataPoint, x: CGFloat)? {
			guard let (firstX, firstDataPoint) = linePoints.first else { return nil }
			
			let firstDistance = abs(firstX.distance(to: position.x))
			var closestPoint: (
				dataPoint: LineGraph.DataPoint,
				x: CGFloat,
				distance: CGFloat
			) = (firstDataPoint, firstX, firstDistance)
			
			linePoints.forEach { (x, dataPoint) in
				let distanceFromPosition = abs(position.x.distance(to: x))
				guard distanceFromPosition < closestPoint.distance else { return }
				closestPoint = (dataPoint, x, distanceFromPosition)
			}
			
			return (closestPoint.dataPoint, closestPoint.x)
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
		let dataPoints: [LineGraph.DataPoint] = (1...31).map { _ in
				.init(title: Lorem.word, value: .random(in: 25000...75000))
		}
		let graph = LineGraph(dataPoints: dataPoints)
		
		return graph
	}()
}
