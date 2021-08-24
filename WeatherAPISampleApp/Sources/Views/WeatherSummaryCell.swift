//
//  WeatherSummaryCell.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import UIKit

final class WeatherSummaryCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var tempMaxLabel: UILabel!
    @IBOutlet private weak var tempMinLabel: UILabel!
    
    func configure(with currentWeather: CurrentWeatherResponse) {
        self.nameLabel.text = currentWeather.name
        self.tempLabel.text = String(currentWeather.main.temp)
        self.tempMaxLabel.text = String(currentWeather.main.tempMax)
        self.tempMinLabel.text = String(currentWeather.main.tempMin)
    }
}
