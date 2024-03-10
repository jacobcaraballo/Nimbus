//
// Created by Jacob Caraballo on 5/27/23
//
        

import Foundation
import UIKit
import Combine

class LineGraphDisplay: UIView, GraphDisplay {
	
	// MARK: - Init
	
	init(dataPoints: [GraphDisplayPoint]) {
		self.dataPoints = dataPoints
		super.init(frame: .zero)
		
		self.setup()
		self.setupBoundsListener()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Properties
	
	private lazy var displayPointsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		stackView.alignment = .fill
		return stackView
	}()
	
	public var dataPoints: [GraphDisplayPoint] {
		didSet {
			self.updateLine(in: self.bounds)
		}
	}
	
	private var lowestValuePoint: GraphDisplayPoint {
		dataPoints.sorted { $0.value < $1.value }[0]
	}
	
	private var highestValuePoint: GraphDisplayPoint {
		dataPoints.sorted { $0.value > $1.value }[0]
	}
	
	private lazy var lineLayer: CAShapeLayer = {
		let layer = CAShapeLayer()
		layer.fillColor = nil
		layer.strokeColor = UIColor.systemGreen.cgColor
		layer.lineWidth = 1
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
	
	private var cancellables = Set<AnyCancellable>()
	
	private func setup() {
		self.addSubview(displayPointsStackView)
		self.layer.addSublayer(self.lineLayer)
		
		displayPointsStackView.constrain(.edges, to: .superview)
	}
	
	private func setupBoundsListener() {
		let layerBoundsPublisher = self.layer
			.publisher(for: \.bounds)
		
		let dataPointsBoundsPublisher = self.dataPoints
			.map { $0 as UIView }
			.first!
			.publisher(for: \.bounds)
		
		Publishers.CombineLatest(
			layerBoundsPublisher,
			dataPointsBoundsPublisher
		)
		.map { (layerBounds, dataPointsBounds) in
			!layerBounds.isNull && !dataPointsBounds.isNull
		}
		.sink { [weak self] boundsIsNotEmpty in
			guard let self,
				  boundsIsNotEmpty
			else { return }
			
			self.updateLine(in: self.bounds)
		}
		.store(in: &cancellables)
	}
	
	private func updateLine(in bounds: CGRect) {
		self.displayPointsStackView.removeArrangedSubviews()
		self.displayPointsStackView.addArrangedSubviews(self.dataPoints)
		
		guard !dataPoints.isEmpty else { return }
		if lineColor == nil {
			lineLayer.strokeColor = currentColorForDataPoints.cgColor
		}
		
		lineLayer.frame.size = bounds.size
		lineLayer.path = self.buildLinePath(in: bounds)
	}
	
	private func calculateTopMargin(of dataPoint: GraphDisplayPoint, in bounds: CGRect) -> CGFloat {
		let bottomOffsetMultiplier = (dataPoint.value - lowestValuePoint.value) / (highestValuePoint.value - lowestValuePoint.value)
		let bottomPoint = bounds.height * bottomOffsetMultiplier
		return bounds.height - bottomPoint
	}
	
	private func buildLinePath(in bounds: CGRect) -> CGPath {
		
		let path = UIBezierPath()
		
		dataPoints.enumerated().forEach { (index, dataPoint) in
			let topMargin = self.calculateTopMargin(of: dataPoint, in: bounds)
			
			guard index != 0 else {
				path.move(to: .init(
					x: dataPoint.bounds.midX,
					y: topMargin))
				return
			}
			
			path.addLine(to: .init(
				x: dataPoint.center.x,
				y: topMargin))
			path.stroke()
		}
		
		return path.cgPath
		
	}
	
	func getDataPoint(for position: CGPoint) -> GraphDisplayPoint? {
		guard let firstDataPoint = dataPoints.first else { return nil }
		let firstX = firstDataPoint.center.x
		
		let firstDistance = abs(firstX.distance(to: position.x))
		var closestPoint: (
			dataPoint: GraphDisplayPoint,
			distance: CGFloat
		) = (firstDataPoint, firstDistance)
		
		dataPoints.forEach { dataPoint in
			let dataPointX = dataPoint.center.x
			let distanceFromPosition = abs(position.x.distance(to: dataPointX))
			guard distanceFromPosition < closestPoint.distance else { return }
			closestPoint = (dataPoint, distanceFromPosition)
		}
		
		return closestPoint.dataPoint
	}
	
	internal func calculateDifferenceForDataPoint(_ dataPoint: GraphDisplayPoint) -> (valueDifference: Double, percentDifference: Double) {
		let firstDataPoint = dataPoints[0]
		let valueDifference = dataPoint.value.distance(to: firstDataPoint.value)
		let percentDifference = valueDifference / firstDataPoint.value
		return (valueDifference, percentDifference)
	}
	
}
