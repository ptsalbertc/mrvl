//
//  HomeRouter.swift
//  Marvel
//
//  Created by Albert on 17/2/22.
//

import Foundation
import UIKit

class HomeRouter {
	var viewController: UIViewController {
		return createViewController()
	}
	private var sourceView: UIViewController?
	
	private func createViewController() -> UIViewController {
		let view = HomeView(nibName: "HomeView", bundle: Bundle.main)
		
		return view
	}
	
	func setSourceView(_ sourceView: UIViewController?) {
		guard let view = sourceView else { fatalError("Error desconocido!")}
		
		self.sourceView = view
	}
	
//	func navigateToDetailView(characterURL: String) {
//		let detailView = DetailRouter(movieID: movieID).viewController
//		sourceView?.navigationController?.pushViewController(detailView, animated: true)
//	}
}
