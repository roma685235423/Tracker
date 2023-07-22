import UIKit

extension UIStackView {
    // MARK: - Life cicle
    convenience init(imageName: String, text: String) {
        self.init(frame: .zero)
        self.contentMode = .scaleAspectFit
        self.layer.masksToBounds = true
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.layer.frame = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        self.addArrangedSubview(imageView)
        self.addArrangedSubview(label)
        self.axis = .vertical
        self.alignment = .center
        self.spacing = 8
    }
}
