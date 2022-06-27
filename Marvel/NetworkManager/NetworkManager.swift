
import Foundation
import Network
import CommonCrypto
import RxSwift

class NetworkManager {
    func getCharacters() -> Observable<[Character]> {
        
        return Observable.create { observer in
            
            let session = URLSession.shared
            
            
            // hash = md5(ts+privateKey+publicKey)
            let timestamp = Int(Date().timeIntervalSince1970)
            let hash = "\(timestamp)\(API.Key.privateKey)\(API.Key.publicKey)"
            
            let charactersUrl = API.URL.main + API.Endpoint.characters
            let apiKeyParameter = "?apikey=" + API.Key.publicKey
            let hashParameter = "&hash=" + hash.md5()
            let timeStampParameter = "&ts=\(timestamp)"
            
            guard let url = URL(string: charactersUrl + apiKeyParameter + hashParameter + timeStampParameter) else {
                return Disposables.create {
                    session.finishTasksAndInvalidate()
                }
            }
            var request = URLRequest(url: url)
            
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request) { (data, response, error) in
                guard let data = data, let response = response as? HTTPURLResponse,
                      error == nil else { return  }
                switch response.statusCode {
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let characters = try decoder.decode(Characters.self, from: data)
                        
                        observer.onNext(characters.list)
                    } catch let error  {
                        observer.onError(error)
                        fatalError("ERROR(getPopularMovies): \(error.localizedDescription)")
                    }
                case 401:
                    print("Error 401")
                default:
                    break
                }
                
                observer.onCompleted()
                
            }.resume()
            
            return Disposables.create {
                session.finishTasksAndInvalidate()
            }
        }
    }
    
    private func getHashAndPublicKeyAndTs() -> (String, String, Int) {
        
        let ts = 1
        
        let publicKey = API.Key.publicKey
        
        let privateKey = API.Key.privateKey
        
        
        
        var hash: String {
            
            let combined = "\(ts)\(privateKey)\(publicKey)"
            
            let md5Data = MD5(string: combined)
            
            let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
            
            
            
            return md5Hex
            
        }
        
        
        
        func MD5(string: String) -> Data {
            
            let messageData = string.data(using:.utf8)!
            
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            
            
            
            _ = digestData.withUnsafeMutableBytes { digestBytes in
                
                messageData.withUnsafeBytes { messageBytes in
                    
                    CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
                    
                }
                
            }
            
            
            
            return digestData
            
        }
        
        
        
        return (hash, publicKey, ts)
        
    }
    
    
}
