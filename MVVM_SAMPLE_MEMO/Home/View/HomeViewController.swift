//
//  ViewController.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by Jongho Lee on 2021/01/26.
//

import UIKit

class HomeViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	@IBAction func newMemoButtonAction(_ sender: Any) {
		if let viewController = instantiateViewController(storyboard: "Memo", ofType: MemoViewController.self) {
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

	private var dataSource: HomeTableViewDataSource<HomeTableViewCell, MemoModel>!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.viewModel = HomeViewModel.init()
		tableView.delegate = self
//		tableView.dataSource = viewModel
		tableView.dataSource = dataSource
		initUI()
		registerCell()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel?.configureModel()
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
//			self?.tableView.reloadData()
			self?.updateDataSource()
		})
	}

	private func updateDataSource() {
		guard let viewModel = viewModel else { return }
		self.dataSource = HomeTableViewDataSource<HomeTableViewCell, MemoModel>.init(
			items: viewModel.memoList.value,
			configureCell: { (cell, model) in
				cell.titleLabel.text = model.homeTitle
				cell.contentLabel.text = model.homeContent
				cell.dateLabel.text = model.date.dateToString("yyyy.MM.dd HH:mm:ss")
			}
		)

		DispatchQueue.main.async {
			self.tableView.dataSource = self.dataSource
			self.tableView.reloadData()
		}
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
