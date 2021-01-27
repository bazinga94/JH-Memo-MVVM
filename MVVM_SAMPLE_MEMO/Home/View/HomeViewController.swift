//
//  ViewController.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/26.
//

import UIKit



class HomeViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!

	private var viewModel: HomeViewModel? {
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
		initAndBindData()
		self.viewModel?.refreshTableView()
	}

	private func initAndBindData() {
		let homeModel = HomeModel.init(navigationTitle: "MVVM 메모앱", memoModelList: [MemoModel(title: "첫번째 메모", content: "내용~"), MemoModel(title: "두번째 메모", content: "입니다~")])
		self.viewModel = HomeViewModel.init(homeModel: homeModel)
		tableView.delegate = self
		tableView.dataSource = viewModel
	}
}

extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyBoard: UIStoryboard! = UIStoryboard(name: "Memo", bundle: nil)
		let viewController = storyBoard.instantiateViewController(withIdentifier: "MemoViewController")
		self.navigationController?.pushViewController(viewController, animated: true)
	}
}
