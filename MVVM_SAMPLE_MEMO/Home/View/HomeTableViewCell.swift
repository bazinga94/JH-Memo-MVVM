//
//  HomeTableViewCell.swift
//  MVVM_SAMPLE_MEMO
//
//  Created by Jongho Lee on 2021/01/26.
//

import UIKit

class HomeTableViewCell: UITableViewCell, ReusableCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
}
