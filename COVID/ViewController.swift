import UIKit

class ViewController: UIViewController {

    var covidManager = CovidManager()
    
    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var casosLabel: UILabel!
    @IBOutlet weak var muertesLabel: UILabel!
    @IBOutlet weak var recuperadosLabel: UILabel!
    @IBOutlet weak var banderaImageView: UIImageView!
    @IBOutlet weak var confirmadosTxt: UILabel!
    @IBOutlet weak var muertesTxt: UILabel!
    @IBOutlet weak var recuperadosTxt: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        confirmadosTxt.text = ""
        muertesTxt.text = ""
        recuperadosTxt.text = ""
        casosLabel.text = ""
        muertesLabel.text = ""
        recuperadosLabel.text = ""
        
        covidManager.delegado = self
        buscarTextField.delegate = self
        
    }


}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if !buscarTextField.text!.isEmpty {
            if !buscarTextField.text!.isEmpty {
                covidManager.fetchCovid(nombrePais: buscarTextField.text!)
            }
            buscarTextField.text = ""
            return true
        }
        else {
            let alertError = UIAlertController(title: "Favor de ingresar un pais", message: nil, preferredStyle: .alert)
            let actionErrorAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alertError.addAction(actionErrorAceptar)
            self.present(alertError, animated: true, completion: nil)
            return true
        }
        
    }
    
}

extension ViewController: CovidManagerDelegate {
    
    func huboError(cualError: Error) {
        
        print(cualError.localizedDescription)
        DispatchQueue.main.async {
            let descripcionError: String
            switch cualError.localizedDescription {
            case "The data couldn’t be read because it is missing.":
                descripcionError = "No se encontro un resultado"
            case "A server with the specified hostname could not be found.":
                descripcionError = "Error del servidor"
            default:
                descripcionError = "Error insepecifico"
            }
            let alertError = UIAlertController(title: descripcionError, message: nil, preferredStyle: .alert)
            let actionErrorAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alertError.addAction(actionErrorAceptar)
            self.present(alertError, animated: true, completion: nil)
        }
        
    }
    
    func actualizarCovid(covid: CovidModelo) {
        
        DispatchQueue.main.async {
            self.confirmadosTxt.text = "Confirmados:"
            self.muertesTxt.text = "Muertes:"
            self.recuperadosTxt.text = "Recuperados:"
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            self.casosLabel.text = numberFormatter.string(from: NSNumber(value: covid.casos))
            self.muertesLabel.text = numberFormatter.string(from: NSNumber(value: covid.muertes))
            self.recuperadosLabel.text = numberFormatter.string(from: NSNumber(value: covid.reuperados))
            
            let imageUrl = URL(string: covid.bandera)!
            let imageData = try! Data(contentsOf: imageUrl)
            let image = UIImage(data: imageData)
            
            self.banderaImageView.image = image
            
        }
    }
    
}

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}

extension UIImage {
    
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        
        self.init(data: imageData)
    }
    
}
