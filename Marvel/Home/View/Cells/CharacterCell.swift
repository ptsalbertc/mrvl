
import UIKit

class CharacterCell: UICollectionViewCell {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var label: UILabel!
	
	override func prepareForReuse() {
		imageView.image = nil
		label.text = nil
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

}
