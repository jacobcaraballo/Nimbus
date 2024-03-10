//
// Created by Jacob Caraballo on 5/28/23
//
        

import Foundation
import UIKit

public class GraphHeader: UIStackView {
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.font = .appFont(.largeTitle)
		label.textColor = Colors.primaryLabel
		return label
	}()
	
	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.font = .appFont(.headline)
		label.textColor = Colors.primaryLabel
		label.isHidden = true
		return label
	}()
	
	public var title: String? {
		set { titleLabel.text = newValue }
		get { titleLabel.text }
	}
	
	public var subtitle: String? {
		get { subtitleLabel.text }
		set {
			subtitleLabel.text = newValue
			subtitleLabel.isHidden = newValue == nil
			|| newValue?.isEmpty == true
		}
	}
	
	init() {
		super.init(frame: .zero)
		
		self.axis = .vertical
		
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
