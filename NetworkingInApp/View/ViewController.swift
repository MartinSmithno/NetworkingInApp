import UIKit

enum DogAPIRequestType {
    case random
    case allBreeds
    case byBreed
    case bySubBreed
}

class ViewController: UIViewController {
    
    var requestType: DogAPIRequestType = .random
    
    var urlString : String {
        switch requestType {
        case .random:
            return "https://dog.ceo/api/breeds/image/random"
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
        var button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Image", for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addTargets()
        addViews()
        addConstraints()
    }
    
    @objc func fetchImageFrom() {
        print("Location: \(urlString)")
        guard let apiURL = URL(string: urlString) else {
            print("Not valid URL")
            return
        }
        print("ImageURL is valid, let's make the task")
        let task = URLSession.shared.dataTask(with: apiURL) { [self] (data, response, error) in
            guard let data = data else {
                print("not at valid data")
                return
            }
            print("Response: \(String(describing: response)), Let's create decoder and create Dog struct from data")
            let decoder = JSONDecoder()
            let dog = try! decoder.decode(Dog.self, from: data)
            print("We got image URL as String from API and use it to get image with this URL, URL could be nil so use guard let")
            guard let imageURL = URL(string: dog.message) else { print("URL from API is nil"); return }
            self.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
            print("Congrats!")
        }
        task.resume()
    }
    
    func addTargets() {
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.fetchImageFrom()
        }), for: .primaryActionTriggered)
    }
    
    func addViews() {
        view.addSubview(imageView)
        view.addSubview(button)
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
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            
        ])
    }
    
    private func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { print("not a valid data from url which is got from API"); completionHandler(nil, error) ; return }
            print("Let's convert data to UIImage")
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
    
    private func requestRandomImage() {
        
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
