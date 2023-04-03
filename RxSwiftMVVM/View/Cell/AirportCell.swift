
import UIKit

class AirportCell: UITableViewCell {
    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(usingViewModel viewModel: AirportViewModel) -> Void {
        airportNameLabel.text = viewModel.name
        distanceLabel.text = viewModel.formattedDistance
        countryLabel.text = viewModel.address
        lengthLabel.text = viewModel.runwayLength
        self.selectionStyle = .none
    }
}
