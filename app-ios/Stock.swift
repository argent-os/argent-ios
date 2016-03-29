//
//  Stock.swift
//  protonpay-ios
//
//  Created by Sinan Ulkuatam on 3/28/16.
//  Copyright © 2016 Sinan Ulkuatam. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

/* Feed of Apple, Yahoo & Google stock prices (ask, year high & year low) from Yahoo ( https://query.yahooapis.com/v1/public/yql?q=select%20symbol%2C%20Ask%2C%20YearHigh%2C%20YearLow%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22AAPL%22%2C%20%22GOOG%22%2C%20%22YHOO%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys ) looks like
 {
 "query": {
 "count": 3,
 "created": "2015-04-29T16:21:42Z",
 "lang": "en-us",
 "results": {
 "quote": [
 {
 "symbol": "AAPL"
 "YearLow": "82.904",
 "YearHigh": "134.540",
 "Ask": "129.680"
 },
 ...
 ]
 }
 }
 }
 */
// See https://developer.yahoo.com/yql/ for tool to create queries

class StockQuoteItem {
    let symbol: String
    let ask: String
    let yearHigh: String
    let yearLow: String
    
    required init(stockSymbol: String, stockAsk: String, stockYearHigh: String, stockYearLow: String) {
        self.symbol = stockSymbol
        self.ask = stockAsk
        self.yearHigh = stockYearHigh
        self.yearLow = stockYearLow
    }
    
    class func endpointForFeed(symbols: [String]) -> String {
        //    let wrappedSymbols = symbols.map { $0 = "\"" + $0 + "\"" }
        let symbolsString:String = symbols.joinWithSeparator("\", \"")
        let query = "select * from yahoo.finance.quotes where symbol in (\"\(symbolsString) \")&format=json&env=http://datatables.org/alltables.env"
        let encodedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let endpoint = "https://query.yahooapis.com/v1/public/yql?q=" + encodedQuery!
        return endpoint
    }
    
    class func getFeedItems(symbols: [String], completionHandler: ([StockQuoteItem]?, NSError?) -> Void) {
        Alamofire.request(.GET, self.endpointForFeed(symbols))
            .responseItemsArray { response in
                completionHandler(response.result.value, response.result.error)
        }
    }
}

extension Alamofire.Request {
    func responseItemsArray(completionHandler: Response<[StockQuoteItem], NSError> -> Void) -> Self {
        let serializer = ResponseSerializer<[StockQuoteItem], NSError> { request, response, data, error in
            guard let responseData = data else {
                let failureReason = "Image URL could not be serialized because input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            
            switch result {
            case .Success(let value):
                let json = SwiftyJSON.JSON(value)
                guard json.error == nil else {
                    print(json.error!)
                    return .Failure(json.error!)
                }
                
                var itemsArray = [StockQuoteItem]()
                let quotes = json["query"]["results"]["quote"].arrayValue
                for jsonItem in quotes {
                    let symbol = jsonItem["symbol"].stringValue
                    let yearLow = jsonItem["YearLow"].stringValue
                    let yearHigh = jsonItem["YearHigh"].stringValue
                    let ask = jsonItem["Ask"].stringValue
                    let item = StockQuoteItem(stockSymbol: symbol, stockAsk: ask, stockYearHigh: yearHigh, stockYearLow: yearLow)
                    itemsArray.append(item)
                }
                
                return .Success(itemsArray)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        
        return response(responseSerializer: serializer, completionHandler: completionHandler)
    }
}