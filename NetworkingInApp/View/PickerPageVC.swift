import UIKit

class PickerPageVC: UIViewController {
    
    var requestType: DogAPIRequestType = .allBreeds
    let urlString = "https://dog.ceo/api/breeds/list/all"
    var breedsList: [String] = []
    
    var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        
        view.backgroundColor = .white
        addViews()
        addConstraints()
        requestRandomImageFromAll()
    }
    
    
    func addViews() {
        view.addSubview(picker)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            picker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
    
    private func requestRandomImageFromAll() {
        guard let apiURL = URL(string: urlString) else { print("Not valid URL"); return }
        let task = URLSession.shared.dataTask(with: apiURL) { [self] (data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            let breeds = try! decoder.decode(Breeds.self, from: data)
            breedsList = breeds.message.keys.map({$0})
            print(breedsList)
        }
        task.resume()
    }
}

extension PickerPageVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
    }
}

extension PickerPageVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breedsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let breed = breedsList[row]
        return breed
    }
    
    
}
