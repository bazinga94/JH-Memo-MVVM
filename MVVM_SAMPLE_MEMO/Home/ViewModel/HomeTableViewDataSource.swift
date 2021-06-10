//
//  HomeTableViewDataSource.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by Jongho Lee on 2021/06/10.
//

import UIKit

protocol ReusableCell: class {
}

extension ReusableCell where Self: UITableViewCell {
	static var reuseIdentifier: String {
		return "\(self)"
	}
}

protocol NibLoadableCell {
}

extension NibLoadableCell where Self: UITableViewCell {
	static var nibName: String {
		return "\(self)"
	}
}

extension UITableView {
	func register<T: UITableViewCell>(_: T.Type) where T: ReusableCell & NibLoadableCell {
		register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
	}
}

class HomeTableViewDataSource<Cell: UITableViewCell, Model>: NSObject, UITableViewDataSource where Cell: ReusableCell {	// UITableViewDataSource가 NSObjectProtocol을 채택했기 때문에 NSObject를 상속받아야 한다.

	private var items: [Model]
	private var configureCell: (Cell, Model) -> Void = {_,_ in }

	init(items: [Model], configureCell: @escaping (Cell, Model) -> ()) {
		self.items = items
		self.configureCell = configureCell
	}

//	private func configureCell( _ cell: Cell) {
//	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
		let item = items[indexPath.row]
		configureCell(cell, item)
		return cell
	}
}
