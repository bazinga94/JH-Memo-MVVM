//
//  MemoModel.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by 60067671 on 2021/01/26.
//

import Foundation

struct MemoModel {
	var homeTitle: String		// Main View memo list title
	var homeContent: String		// Main View memo list content
	var content: String			// Memo View content
	var date: Date				// Memo saving date
	var index: Int				// Memo index

	init() {
		self.homeTitle = ""
		self.homeContent = ""
		self.content = ""
		self.date = Date()
		self.index = 0
	}
}
