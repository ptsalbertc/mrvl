//
//  HomeView.swift
//  Marvel
//
//  Created by Albert on 17/2/22.
//

import UIKit
import RxSwift
import RxCocoa

class HomeView: UIViewController {
	
	private var router = HomeRouter()
	private var viewModel = HomeViewModel()
	private var disposeBag = DisposeBag()
	
	private var characters = [Character]()
	private var filteredCharacters = [Character]()
	
	@IBOutlet weak var collectionview: UICollectionView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.parent?.navigationItem.title = "characters".from("Home")
		
		configureSearchBar()
		
		//		manageSearchBarController()
		
		viewModel.bind(view: self, router: router)
		
		configureCollectionView()
		activity.startAnimating()
		
		getCharacters()
	}
	
	private func configureSearchBar() {
		searchBar.placeholder = "searchbar_placeholder".from("Home")
	}
	
	private func getCharacters() {
		return viewModel.getCharacters()
		//Manejar concurrencia/hilos de RxSwift
			.subscribe(on: MainScheduler.instance) //el correo se actualiza cada 15 min
			.observe(on: MainScheduler.instance) // entro en la app de correo y compruebo manualmente
		//Suscribirme al observable
			.subscribe { characters in
				self.characters = characters
				self.reloadCollectionView()
			} onError: { error in
				fatalError("ERROR: \(error)")
			} onCompleted: {
				print("completed")
			}.disposed(by: disposeBag)
		
		//Dar por completada la secuencia de RxSwift
	}
	
	private func configureCollectionView() {
		collectionview.delegate = self
		collectionview.dataSource = self
		
		collectionview.register(UINib(nibName: "CharacterCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CharacterCell")
	}
	
	private func reloadCollectionView() {
		DispatchQueue.main.async {
			self.activity.stopAnimating()
			self.activity.isHidden = true
			self.collectionview.reloadData()
		}
	}
	
}


extension HomeView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
				return characters.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
		
		cell.label.text = "test"
		//		cell.label.textColor = Bool.random() ? .black : .white
		
		return cell
	}
	
	
}

extension HomeView: UICollectionViewDelegate {
	
}
