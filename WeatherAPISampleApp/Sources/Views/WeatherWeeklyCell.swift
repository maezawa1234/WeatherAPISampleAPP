//
//  WeatherWeeklyCell.swift
//  WeatherAPISampleApp
//
//  Created by 前澤健一 on 2021/08/23.
//

import UIKit

class WeatherWeeklyCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    func configure(with forecast: ForecastListObject) {
        let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        self.dateLabel.text = formatter.string(from: date)
        self.weatherLabel.text = forecast.weather[0].main.description
        self.tempLabel.text = String(forecast.main.temp)
    }
}
