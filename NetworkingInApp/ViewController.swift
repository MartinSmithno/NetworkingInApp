import UIKit

class ViewController: UIViewController {
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello!"
        label.textColor = UIColor.systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        view.addSubview(mainLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
