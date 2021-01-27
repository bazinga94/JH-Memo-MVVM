//
//  ViewController.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/26.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!

	var viewModel: HomeViewModel? {
		didSet {
			viewModel?.titleDidChange = { [weak self] viewModel in
				self?.navigationItem.title = viewModel.title
			}
			viewModel?.memoListDidChange = { [weak self] viewModel in
				self?.tableView.reloadData()
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		initUI()
		initAndBindData()
		self.viewModel?.refresHomeView()
	}

	private func initUI() {
		tableView.roundCorners([.topLeft, .topRight], radius: 10)
	}

	private func initAndBindData() {
//		let homeModel = HomeModel.init(navigationTitle: "MVVM 메모앱", memoModelList: [MemoModel(homeTitle: "첫번째 메모", homeContent: "내용~", content: "코어데이터를"), MemoModel(homeTitle: "두번째 메모", homeContent: "입니다~", content: "써볼까")])
		let homeModel = HomeModel.init(navigationTitle: "MVVM 메모앱", memoModelList: fetchFromCoreData())
		self.viewModel = HomeViewModel.init(homeModel: homeModel)
		tableView.delegate = self
		tableView.dataSource = viewModel
	}

	private func fetchFromCoreData() -> [MemoModel] {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		do {
			let memoModelList = try context.fetch(MemoEntity.fetchRequest()) as! [MemoModel]
			return memoModelList
		} catch {
			print(error.localizedDescription)
			return []
		}
	}
}

extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyBoard: UIStoryboard! = UIStoryboard(name: "Memo", bundle: nil)
		if let viewController = storyBoard.instantiateViewController(withIdentifier: "MemoViewController") as? MemoViewController {
			viewController.viewModel = self.viewModel?.memoDidSelect(for: indexPath.row)
			self.navigationController?.pushViewController(viewController, animated: true)
		}
	}
}
