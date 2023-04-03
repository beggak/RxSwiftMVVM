
import UIKit

class CityCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(usingViewModel viewModel: CityViewPresentable) {
        self.cityLabel.text = viewModel.city
        self.locationLabel.text = viewModel.location
        self.selectionStyle = .none
    }
}
