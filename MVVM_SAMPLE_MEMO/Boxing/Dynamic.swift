//
//  Dynamic.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/02/15.
//

class Dynamic<T> {
	typealias Listener = (T) -> Void
	var listener: Listener?

	var value: T {
		didSet {
			listener?(value)
		}
	}

	init(_ value: T) {
		self.value = value
	}

	func bind(listener: Listener?) {
		self.listener = listener
		listener?(value)
	}
}

// Sample Code
//let box = Dynamic(50)
//box.bind {
//	print($0)
//}
//
//box.value = 100
