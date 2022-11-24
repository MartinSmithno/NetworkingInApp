import UIKit

enum DogAPIRequestType {
    case random
    case randomForBreed
    case allBreeds
    case byBreed
    case bySubBreed
}

class ViewController: UIViewController {
    
    var requestType: DogAPIRequestType = .random
    var breed: String = "hound"
    
    var urlString: String {
        switch requestType {
        case .random:
            return "https://dog.ceo/api/breeds/image/random"
        case .randomForBreed:
            return "https://dog.ceo/api/breed/\(breed)/images/random"
        case .allBreeds:
            return "https://dog.ceo/api/breeds/list/all"
        case .byBreed:
            return "https://dog.ceo/api/breed/hound/images"
        case .bySubBreed:
            return "https://dog.ceo/api/breed/hound/list"
        }
    }
    
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.lightGray
        imageView.alpha = 0.8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var button: UIButton = {
        var button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Image", for: .normal)
        
        return button
    }()
    
    var pickerPageButton: UIButton = {
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Picker Page", for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addTargets()
        addViews()
        addConstraints()
    }
    
    func addTargets() {
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.fetchImageFrom()
        }), for: .primaryActionTriggered)
        
        pickerPageButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presentPickerPage()
        }), for: .primaryActionTriggered)
    }
    
    func addViews() {
        view.addSubview(imageView)
        view.addSubview(button)
        view.addSubview(pickerPageButton)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: 8),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: pickerPageButton.topAnchor, constant: -8),
            pickerPageButton.heightAnchor.constraint(equalToConstant: 50),
            pickerPageButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            pickerPageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerPageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    @objc func presentPickerPage() {
        print("Go to picker page...")
        self.presentPickerPageVC()
    }

    @objc func fetchImageFrom() {
        requestRandomImage(completionHandler: handleImageResponse(imageData:error:))
    }
    
    private func requestRandomImage(completionHandler: @escaping (Dog?, Error?) -> Void) {
        guard let apiURL = URL(string: urlString) else { print("Not valid URL"); return }
        let task = URLSession.shared.dataTask(with: apiURL) {(data, response, error) in
            guard let data = data else {print("not at valid data");completionHandler(nil,error);return}
            let decoder = JSONDecoder()
            let dog = try! decoder.decode(Dog.self, from: data)
            completionHandler(dog, nil)
        }
        task.resume()
    }
    
    private func handleImageResponse(imageData: Dog?, error: Error?) {
        guard let imageURL = URL(string: imageData?.message ?? "") else { return }
        self.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
    }
    
    private func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { completionHandler(nil, error); return }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        }
        task.resume()
    }
    
    private func handleImageFileResponse(image: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}

extension ViewController {
    private func presentPickerPageVC() {
        let vc = PickerPageVC()
        let navController = UINavigationController(rootViewController: vc)
        if let presentationController = navController.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium(), .large()]
            presentationController.prefersGrabberVisible = false
        }
        present(navController, animated: true)
    }
}

/*
 => 2. With JSON Serialization object
 print("Data is valid, get convert data to JSON object")
 do {
 let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
 print("We can get URL of a random picture with 'message' keyword")
 let urlFromAPI = json["message"] as! String
 print("We have parsed the dog API's JSON response in app!")
 } catch {
 print("Error: \(error)")
 }
 */

/*
 => 1. Convert data into UIIMage
 print("Data is valid, get convert data to image")
 let downloadedImage = UIImage(data: data)
 print("Let's use downloadedimage in our ImageView")
 guard let image = downloadedImage else {
 print ("Downloaded image is not valid")
 return
 }
 //Update UI works allways o main thread!
 DispatchQueue.main.async {
 self.imageView.image = image
 print("Lets check the UI!")
 }
 */
