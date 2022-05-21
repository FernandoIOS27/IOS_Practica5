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
    var currenciesRates: [CurrenciesRate] = []
    
    // MARK: OUTLETS

    @IBOutlet weak var cryptoNameLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var searchItemsTableView: UITableView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    // MARK: ACTIONS
    
    
    
    // MARK: APP LIFE CYCLE
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            setUpUI()
            setUpTableView()
            
        }
        
    // MARK: METHODS & FUNCTIONS
    
        // MARK: INITIAL UI CONFIGURATION

        func setUpUI(){
            // Escondemos el ActivityIndicatorView
            loaderView.stopAnimating()
            loaderView.isHidden = true
        }
        
        // MARK: LOADER SETUP
        
        func setUpLoader(isLoading: Bool){
            // Al poner el "!" Estamos negando un valor (True lo mostrará)
            loaderView.isHidden = !isLoading
            isLoading ? loaderView.startAnimating(): loaderView.stopAnimating()
        }
        
        // MARK: LINK BETWEEN TABLEVIEW AND CELL CONTROLLER AND VIEW OF NIB
    
        func setUpTableView(){
            
            searchItemsTableView.register(UINib(nibName: "ItemTableViewCell", bundle: .main), forCellReuseIdentifier: "ItemTableViewCell")
            
            // DATASOURCE WOULD BE THE TABLEVIEW ITSELF
            searchItemsTableView.dataSource = self
            
        }
        
        // MARK: WEB SERVICE REQUEST VIA API
        
        func searchInItunes(){
            
            // VERIFIES IF THE URL EXISTS
            guard let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json") else {return}
            
            // GETS DATA, RESPONSE CODE OR ERROR CODE FROM REQUEST
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                // UNWRAP TO VERIFY DATA EXISTS
                if let data = data {
                    print("DATA: \(data)")
                    print("STRING: \(String(decoding: data, as: UTF8.self))")
                    
                    // PASS DATA TO DECODING FUNCTION
                    self.decodeJSONResponse(data: data)
                }
                
                // UNWRAP TO VERIFY A RESPONSE STATUS CODE IS PROVIDED
                if let response = response {
                    print("RESPONSE: \(response)")
                    
                    // CAST RESPONSE TO GET ITS STATUS CODE
                    if let httpResponse = response as? HTTPURLResponse {
                        print("HTTP CODE: \(httpResponse.statusCode)")
                    }
                }
                
                // UNWRAP FOR ERROR OF THE REQUEST
                if let error = error {
                    print("Error: \(error)")
                }
            }
            
            // TASK IS RESUMED IN BACKGROUND
            task.resume()
            
        }

        // MARK: WEB SERVICE DATA RECEIVED DECODING
    
        func decodeJSONResponse(data:Data){
            
            do {
                // INSTANTIATE JSONDECODER FUNCTION FROM CODABLE PROTOCOL
                let decoder = JSONDecoder()
                
                // ATTEMPT FOR DECODING OF SELFMADE STRUCT
                let response = try decoder.decode(SearchResult.self, from: data)
                
                print("DECODED RESPONSE: \(response)")
                
                //searchItems = response.results
                //currenciesRates = response.chartName
                reloadTableView()
                
            } catch {
                print("ERROR: \(error)")
            }
        }
        
        // MARK: SET WEB SERVICE RESPONSE TO MAIN QUEUE DUE TO APPEARANCE IN VIEW
    
        func reloadTableView(){
            DispatchQueue.main.async {
                self.setUpLoader(isLoading: false)
                self.searchItemsTableView.reloadData()
            }
        }
        
}


// MARK: CLASS EXTENSIONS

    // MARK: TABLEVIEWDATASOURCE PROTOCOL ADOPTION

    extension ViewController: UITableViewDataSource{
        
        // NUMBER OF CELL PER SECTION
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            //
            return currenciesRates.count
        }
        
        // ASSIGNMENT OF DATA TO CELL
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // TAKES REUSABLE CELL DEFINED IN TABLEVIEW SETUP AND ASSIGNS VALUES
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell {
                
                let currencies = currenciesRates[indexPath.row]
                
                cell.setUpCellWith(currency: currencies)

                return cell
            
            }
            
            return UITableViewCell()
        }
    }

