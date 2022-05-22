//
//  ViewController.swift
//  WebService
//
//  Created by Luis Fernando Cuevas Cuauhtle on 7/4/22.
//

// MARK: FRAMEWORKS & LIBRARIES

    import UIKit
    import Foundation


// MARK: VIEW CONTROLLER

class ViewController: UIViewController {
    
    // MARK: PROPERTIES
    
        // CRYPTO NAME & DISCLAIMER
        var cryptocurrencyName: String! = ""
        var disclaimerInfo: String! = ""
        // ARRAY OF CURRENCIES
    
        var currencies: [Currencydata] = []
    
        var gbpCurrency: Currencydata = Currencydata(code: "", symbol: "", rate: "", description: "", rate_float: 0)
        var usdCurrency: Currencydata = Currencydata(code: "", symbol: "", rate: "", description: "", rate_float: 0)
        var eurCurrency: Currencydata = Currencydata(code: "", symbol: "", rate: "", description: "", rate_float: 0)
    
        // ARRAY OF TIME DATA
        var timeData: Time = Time(updated: "", updatedISO: "", updateduk: "")
    
        //var symbol: String! = ""
    
    // MARK: OUTLETS

    @IBOutlet weak var cryptoNameLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var searchItemsTableView: UITableView!
    //@IBOutlet weak var loaderView: UIActivityIndicatorView!
    //@IBOutlet weak var currencySymbolHTML: UILabel!
    
    // MARK: ACTIONS
    
    
    
    // MARK: APP LIFE CYCLE
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            searchInCoinDesk()
            setUpTableView()
            setUpUI()
            
        }
        
    // MARK: METHODS & FUNCTIONS
    
        // MARK: INITIAL UI CONFIGURATION

        func setUpUI(){
            // ACTIVITY INDICATOR NO LOADING HIDDING
            //loaderView.stopAnimating()
            //loaderView.isHidden = true

            disclaimerLabel.numberOfLines = 0
            
        }
    
        // MARK: CRYPTOCURRENCY INFO
    
        func setUpGeneralInfo(){
            
            currencies.append(usdCurrency)
            currencies.append(gbpCurrency)
            currencies.append(eurCurrency)
            
            lastUpdateLabel.text = timeData.updated
            
            if let crypto = cryptocurrencyName,
               let disclaimer = disclaimerInfo {
                
                cryptoNameLabel.text = crypto
                disclaimerLabel.text = disclaimer
                
            } else {
                print("ERROR ASSIGNING DECODED VALUES TO LABELS")
            }
            
        }
        
        // MARK: LOADER SETUP
        
        func setUpLoader(isLoading: Bool){
            // Al poner el "!" Estamos negando un valor (True lo mostrará)
            //loaderView.isHidden = !isLoading
            //isLoading ? loaderView.startAnimating(): loaderView.stopAnimating()
        }
        
        // MARK: LINK BETWEEN TABLEVIEW AND CELL CONTROLLER AND VIEW OF NIB
    
        func setUpTableView(){
            
            searchItemsTableView.register(UINib(nibName: "ItemTableViewCell", bundle: .main), forCellReuseIdentifier: "ItemTableViewCell")
            
            // DATASOURCE WOULD BE THE TABLEVIEW ITSELF
            searchItemsTableView.dataSource = self
            
        }
        
        // MARK: WEB SERVICE REQUEST VIA API
        
        func searchInCoinDesk(){
            
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
                    print("WEB SERVICE REQUEST RESPONSE: \(response)")
                    
                    // CAST RESPONSE TO GET ITS STATUS CODE
                    if let httpResponse = response as? HTTPURLResponse {
                        print("HTTP CODE: \(httpResponse.statusCode)")
                    }
                }
                
                // UNWRAP FOR ERROR OF THE REQUEST
                if let error = error {
                    print("WEB SERVICE REQUEST ERROR: \(error)")
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
                let results = try decoder.decode(SearchResult.self, from: data)
                
                print("DECODED RESPONSE: \(results)")
                print("CRYPTOCURRENCY NAME: \(results.chartName)")
                print("DISCLAIMER: \(results.disclaimer)")
                print("TIME UPDATED: \(results.time.updated)")
                
                usdCurrency = results.bpi.USD
                eurCurrency = results.bpi.EUR
                gbpCurrency = results.bpi.GBP
                
                cryptocurrencyName = results.chartName
                disclaimerInfo = results.disclaimer
                timeData = results.time
                
                reloadTableView()
                
            } catch {
                print("DECODING ERROR: \(error)")
            }
        }
        
        // MARK: SET WEB SERVICE RESPONSE TO MAIN QUEUE DUE TO APPEARANCE IN VIEW
    
        func reloadTableView(){
            DispatchQueue.main.async {
                self.setUpGeneralInfo()
                self.setUpLoader(isLoading: false)
                self.searchItemsTableView.reloadData()
            }
        }
        
}


// MARK: EXTENSIONS

    // MARK: TABLEVIEWDATASOURCE PROTOCOL ADOPTION

    extension ViewController: UITableViewDataSource{
        
        // NUMBER OF CELL PER SECTION
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return currencies.count
        }
        
        // ASSIGNMENT OF DATA TO CELL
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            // TAKES REUSABLE CELL DEFINED IN TABLEVIEW SETUP AND ASSIGNS VALUES
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell {
                
                cell.setUpCellWith(currency: currencies[indexPath.row])

                return cell
            
            }
            
            return UITableViewCell()
        }
    }
