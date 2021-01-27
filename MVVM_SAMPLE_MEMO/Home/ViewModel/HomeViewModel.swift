//
//  HomeViewModel.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/26.
//

import UIKit

// YG 참고!
protocol ViewModel {
	associatedtype Model
	var model: Model { get set }
	init(model: Model)
	/// Data 갱신 처리 ( bind한 view에게 알림 )
	func configureOutput()
}

protocol HomeViewModelProtocol {
	var title: String! { get }
	var memoList: [MemoModel]! { get }
	init(homeModel: HomeModel)
	var titleDidChange: ((HomeViewModelProtocol) -> ())? { get set }
	var memoListDidChange: ((HomeViewModelProtocol) -> ())? { get set }
	func refreshTableView()

}

class HomeViewModel: NSObject, HomeViewModelProtocol {
	var homeModel: HomeModel
	var titleDidChange: ((HomeViewModelProtocol) -> ())?
	var memoListDidChange: ((HomeViewModelProtocol) -> ())?
	var title: String! {
		didSet {
			self.titleDidChange?(self)
		}
	}
	var memoList: [MemoModel]! {
		didSet {
			self.memoListDidChange?(self)
		}
	}

	required init(homeModel: HomeModel) {
		self.homeModel = homeModel
	}

	func refreshTableView() {
		title = homeModel.navigationTitle
		memoList = homeModel.memoModelList
	}
}

extension HomeViewModel: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memoList.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: HomeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		cell.titleLabel.text = memoList[indexPath.row].title
		cell.contentLabel.text = memoList[indexPath.row].content
		return cell
	}
}
