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
	@IBAction func newMemoButtonAction(_ sender: Any) {
		let storyBoard: UIStoryboard! = UIStoryboard(name: "Memo", bundle: nil)
		if let viewController = storyBoard.instantiateViewController(withIdentifier: "MemoViewController") as? MemoViewController {
			var memoModel = MemoModel()
			memoModel.index = -1	// 신규 메모 index 임시로 -1 지정
			viewController.viewModel = MemoViewModel(isUpdate: false, count: viewModel?.memoList.value.count ?? 0, memoModel: memoModel)
			self.navigationController?.pushViewController(viewController, animated: true)
		}
	}

	var viewModel: HomeViewModel? {
		didSet {
			configureUI()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.viewModel = HomeViewModel.init()
		tableView.delegate = self
		tableView.dataSource = viewModel
		initUI()
		registerCell()
	}

	private func initUI() {
		tableView.roundCorners([.topLeft, .topRight], radius: 10)
	}

	private func registerCell() {
		tableView.register(cellType: HomeTableViewCell.self)
	}

	private func configureUI() {
		viewModel?.title.bind(listener: { [weak self] title in
			self?.navigationItem.title = title
		})
		viewModel?.memoList.bind(listener: { [weak self] _ in
			self?.tableView.reloadData()
		})
	}
}

extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let viewController = instantiateViewController(storyboard: "Memo", ofType: MemoViewController.self) {
			viewController.viewModel = self.viewModel?.memoDidSelect(for: indexPath.row)
			self.navigationController?.pushViewController(viewController, animated: true)
		}
	}
}
