//
// Created by Jacob Caraballo on 2/25/23
//
        

import Foundation
import UIKit

public enum Theme { }

extension Theme {
	
	public enum Button {
		case regular
		case destructive
		case cancel
	}
	
	public enum Label {
		case title
		case subtitle
		case text
	}
	
	public enum Toast {
		case regular
		case success
		case failure
	}
	
	public enum Banner {
		case regular
		case success
		case failure
	}
	
	public enum ListItem {
		case regular
	}
	
	public enum HighlightedBackground {
		case regular
	}
	
	public enum Drawer {
		case regular
	}
	
}

extension Theme.Button: Theming {
	
	public var options: [ThemingOptions] {
		switch self {
		case .regular:
			return [
				.corners(.large),
				.tintColor(.systemMint)
			]
			
		case .destructive:
			return [
				.corners(.large),
				.tintColor(.systemRed)
			]
			
		case .cancel:
			return [
				.corners(.large),
				.tintColor(.separator)
			]
			
		}
	}
	
}

extension Theme.Label: Theming {
	
	public var options: [ThemingOptions] {
		switch self {
		case .title:
			return [ .text(font: .appFont(.headline), color: Colors.primaryLabel) ]
			
		case .subtitle:
			return [ .text(font: .appFont(.subheadline, weight: .light), color: Colors.secondaryLabel) ]
			
		case .text:
			return [ .text(font: .appFont(.subheadline, weight: .light), color: Colors.secondaryLabel) ]
			
		}
	}
	
}

extension Theme.Toast: Theming {
	
	public var options: [ThemingOptions] {
		var options: [ThemingOptions] = [
			.corners(.large),
			.shadow()
		]
		
		switch self {
		case .regular:
			options.append(contentsOf: [
				.backgroundColor(.systemGroupedBackground),
				.border(.thin, color: .separator)
			])
			
		case .success:
			options.append(contentsOf: [
				.backgroundColor(UIColor(red: 230/255, green: 245/255, blue: 225/255, alpha: 1.0)),
				.border(.thin, color: .systemGreen)
			])
			
		case .failure:
			options.append(contentsOf: [
				.backgroundColor(UIColor(red: 255/255, green: 240/255, blue: 235/255, alpha: 1.0)),
				.border(.thin, color: .systemRed)
			])
			
		}
		
		return options
	}
	
}

extension Theme.Banner: Theming {
	
	public var options: [ThemingOptions] {
		var options: [ThemingOptions] = [
			.corners(.large),
			.shadow()
		]
		
		switch self {
		case .regular:
			options.append(contentsOf: [
				.backgroundColor(.systemGroupedBackground),
				.border(.thin, color: .separator)
			])
			
		case .success:
			options.append(contentsOf: [
				.backgroundColor(UIColor(red: 230/255, green: 245/255, blue: 225/255, alpha: 1.0)),
				.border(.thin, color: .systemGreen)
			])
			
		case .failure:
			options.append(contentsOf: [
				.backgroundColor(UIColor(red: 255/255, green: 240/255, blue: 235/255, alpha: 1.0)),
				.border(.thin, color: .systemRed)
			])
			
		}
		
		return options
	}
	
}

extension Theme.ListItem: Theming {
	
	public var options: [ThemingOptions] {
		[
			.backgroundColor(Colors.primaryBackground),
			.border(.thin, color: .separator),
			.corners(.regular),
			.shadow()
		]
	}
	
}

extension Theme.HighlightedBackground: Theming {
	
	public var options: [ThemingOptions] {
		[
			.backgroundColor(Colors.highlightedBackground)
		]
	}
	
}

extension Theme.Drawer: Theming {
	public var options: [ThemingOptions] {
		[
			.corners(.xLarge),
			.backgroundColor(Colors.primaryBackground),
			.border(.thin, color: .separator),
			.shadow()
		]
	}
}
