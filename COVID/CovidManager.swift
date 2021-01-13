import Foundation

protocol CovidManagerDelegate {
    
    func actualizarCovid(covid: CovidModelo)
    func huboError(cualError: Error)
    
}

struct CovidManager {
    
    var delegado: CovidManagerDelegate?
    
    let covidURL = "https://corona.lmao.ninja/v3/covid-19/countries"
    
    func fetchCovid(nombrePais: String) {
        
        let auxPais = nombrePais.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let urlString = "\(covidURL)/\(auxPais)"
        print(urlString)
        
        realizarSolicitud(urlString: urlString)
        
    }
    
    func realizarSolicitud(urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let tarea = session.dataTask(with: url) { (data, respuesta, error) in
                if error != nil {
                    self.delegado?.huboError(cualError: error!)
                }
                else {
                    if let datosSeguros = data {
                        if let covid = self.parseJSON(covidData: datosSeguros) {
                            self.delegado?.actualizarCovid(covid: covid)
                        }
                    }
                }
            }
            tarea.resume()
        }
        
    }
    
    func parseJSON(covidData: Data) -> CovidModelo? {
        
        let decoder = JSONDecoder()
        do {
            let dataDecodificada = try decoder.decode(CovidData.self, from: covidData)
            let cases = dataDecodificada.cases
            let deaths = dataDecodificada.deaths
            let recovered = dataDecodificada.recovered
            let flag = dataDecodificada.countryInfo.flag
            
            let ObjCovid = CovidModelo(casos: cases, muertes: deaths, reuperados: recovered, bandera: flag)
            return ObjCovid
        }
        catch {
            self.delegado?.huboError(cualError: error)
            return nil
        }
        
    }
    
}
