//
//  ViewController.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 7/4/22.
//

// MARK: FRAMEWORKS & LIBRARIES

    import UIKit


// MARK: VIEW CONTROLLER

class ViewController: UIViewController {
    
    // MARK: PROPERTIES
    
    // Arreglo de SearchItems - Por lo mientras lo inicializamos como vacio
    var searchItems: [SearchItem] = []
    
    // MARK: OUTLETS

    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchItemsTableView: UITableView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    // MARK: ACTIONS
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        guard let text = searchTextField.text, !text.isEmpty else {return}
        // Después de haber definido como variable "text" aquello que el usuario escriba en el TextView, lo tomaremos como entrada en la función de saveSearch
        saveLastSearch(text: text)
        setUpLoader(isLoading: true)
        searchInItunes(text: text)
        
    }
    
    // MARK: APP LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
        setUpTableView()
        getLastSearch()
    }
    
    // MARK: METHODS & FUNCTIONS
    
    // Configuración Inicial de Objetos y variables
    func setUpUI(){
        // Escondemos el ActivityIndicatorView
        loaderView.stopAnimating()
        loaderView.isHidden = true
    }
    
    // Animación de Loading View - Muestra u oculta el Loader
    func setUpLoader(isLoading: Bool){
        // Al poner el "!" Estamos negando un valor (True lo mostrará)
        loaderView.isHidden = !isLoading
        isLoading ? loaderView.startAnimating(): loaderView.stopAnimating()
    }
    
    // Configuración de Vista de Tabla - Registro de la Celda
    func setUpTableView(){
        searchItemsTableView.register(UINib(nibName: "ItemTableViewCell", bundle: .main), forCellReuseIdentifier: "ItemTableViewCell")
        // Quién será el data source de las celdas
        searchItemsTableView.dataSource = self
        
    }
    
    // Guardado de Última Búsqueda - Recibimos un texto que será el que guardaremos
    func saveLastSearch(text: String) {
        // Creamos una referencia a las UserDefaults llamado defaults
        let defaults = UserDefaults.standard
        // Setteamos el valor de los userDefaults Standard - Guardamos el texto, con una llave para poder identificarlo dentro de todas las User Defaults
        defaults.set(text, forKey: "LastSearch")
    }
    
    // Obtención de Última Búsqueda
    func getLastSearch(){
        // Creamos una constante que obtiene todas las cookies (Los UserDefaults guardados en la aplicación) Referencia a las UserDefaults
        let defaults = UserDefaults.standard
        // Y por medio de la constante lasSearch accedemos a la cookie que nombramos con la key Last Search y la convertimos a String
        if let lastSearch = defaults.object(forKey: "LastSearch") as? String {
            print("LAST SEARCH: \(lastSearch)")
            // Se pone el texto de la Cookie seleccionada en el TextField
            searchTextField.text = lastSearch
        }
    }
    
    // Petición de Datos a Servicio Web
    func searchInItunes(text: String){
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(text)") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                print("Data: \(data)")
                print("String: \(String(decoding: data, as: UTF8.self))")
                self.decodeJSONResponse(data: data)
            }
            if let response = response {
                print("Response: \(response)")
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Code: \(httpResponse.statusCode)")
                }
            }
            if let error = error {
                print("Error: \(error)")
            }
        }
        
        //task.currentRequest?.httpMethod
        // Se pasa a background thread
        task.resume()
        
    }

    // Decodificación de Respuesta de Web Service
    func decodeJSONResponse(data:Data){
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(SearchResult.self, from: data)
            print("DECODED RESPONSE: \(response)")
            searchItems = response.results
            reloadTableView()
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    // Recarga el TableView
    func reloadTableView(){
        DispatchQueue.main.async {
            self.setUpLoader(isLoading: false)
            self.searchItemsTableView.reloadData()
        }
    }

}

// MARK: CLASSES EXTENSIONS

// Adopción de Protocolo para los Datos de la Tabla
extension ViewController: UITableViewDataSource{
    
    // Número de Celdas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Número de Celdas del arreglo
        return searchItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell {
            let searchItem = searchItems[indexPath.row]
            cell.setUpWith(searchItem: searchItem)
            cell.sizeToFit()
            cell.layoutIfNeeded()
            return cell
        
        }
        
        return UITableViewCell()
    }
}

