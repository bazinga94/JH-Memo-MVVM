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
//	var title: String! { get }
//	var memoList: [MemoModel]! { get }
//	var titleDidChange: ((HomeViewModelProtocol) -> ())? { get set }
//	var memoListDidChange: ((HomeViewModelProtocol) -> ())? { get set }
//	func refresHomeView()
	func memoDidSelect(for index: Int) -> MemoViewModel
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
//	var homeModel: HomeModel!
//	var titleDidChange: ((HomeViewModelProtocol) -> ())?
//	var memoListDidChange: ((HomeViewModelProtocol) -> ())?
//	var homeModel: Dynamic<HomeModel> = .init(.init())
	var title: Dynamic<String> = .init("")
	var memoList: Dynamic<[MemoModel]> = .init(.init())

//	var title: String! {
//		didSet {
//			self.titleDidChange?(self)
//		}
//	}
//	var memoList: [MemoModel]! {
//		didSet {
//			self.memoListDidChange?(self)
//		}
//	}

	override init() {
		super.init()
		configureModel()
	}

	private func configureModel() {
//		homeModel.value.navigationTitle = "MVVM 메모앱"
//		homeModel.value.memoModelList = fetchFromCoreData()
		title.value = "MVVM 메모앱"
		memoList.value = fetchFromCoreData()
	}

//	func refresHomeView() {
//		title = homeModel.navigationTitle
//		memoList = homeModel.memoModelList
//	}

	func memoDidSelect(for index: Int) -> MemoViewModel {
		return MemoViewModel(index: index, memoModel: memoList.value[index])
	}

	func memoListUpdate(memoViewModel: MemoViewModel) {
		if memoList.value.count > 0, memoViewModel.index != -1 {
			memoList.value.remove(at: memoViewModel.index)
		}
		memoList.value.insert(memoViewModel.memoModel, at: 0)
	}

	private func fetchFromCoreData() -> [MemoModel] {
		var memoModelList: [MemoModel] = []
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		do {
			let memoEntityList = try context.fetch(MemoEntity.fetchRequest()) as! [MemoEntity]
			memoEntityList.forEach { (entity) in
				memoModelList.append(MemoModel(homeTitle: entity.homeTitle!, homeContent: entity.homeContent!, content: entity.content!, date: entity.date!))
			}
			return memoModelList
		} catch {
			print(error.localizedDescription)
			return []
		}
	}
}

extension HomeViewModel: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memoList.value.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: HomeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
		cell.titleLabel.text = memoList.value[indexPath.row].homeTitle
		cell.contentLabel.text = memoList.value[indexPath.row].homeContent
		cell.dateLabel.text = memoList.value[indexPath.row].date.dateToString("yyyy.MM.dd HH:mm:ss")
		return cell
	}
}
