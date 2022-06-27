
import Foundation
import RxSwift

class HomeViewModel {
	private weak var view: HomeView? // weak - ciclo retencion memoria
	private var router: HomeRouter?
	private var networkManager = NetworkManager()
	
	func bind(view: HomeView, router: HomeRouter) {
		self.view = view
		self.router = router
		
		self.router?.setSourceView(view)
	}
	
	func getCharacters() -> Observable<[Character]> {
		return networkManager.getCharacters()
	}
	
}
