//
//  Extension.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/26.
//

import UIKit

extension NSObject {
	//	var className: String {
	//		return String(describing: type(of: self))
	//	}
	class var className: String {
		return String(describing: self)
	}
}

extension UITableView {
	func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
		guard let cell = self.dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T else {
			fatalError("Disable Dequeue Reusable Cell")
		}
		return cell
	}
}
