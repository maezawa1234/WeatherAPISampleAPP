//
//  SeachHistoryTableViewCell.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/10/19.
//

import UIKit

final class SearchHistoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var wordLabel: UILabel!

    func configure(with searchWord: String) {
        self.wordLabel.text = searchWord
    }
}
