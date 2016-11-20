

import UIKit
import Alamofire

//import BDBOAuth1Manager

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


/** Provides access to the Clarifai image recognition services */
class Clarifai{
    var clientID: String
    var clientSecret: String
    var accessToken: String?
    var accessTokenExpiration: Date?
    var endpoint : Any?
    
    struct Config {
        static let BaseURL: String = "https://api.clarifai.com/v1"
        static let AppID: String = "com.clarifai.Clarifai.AppID"
        static let AccessToken: String = "com.clarifai.Clarifai.AccessToken"
        static let AccessTokenExpiration: String = "com.clarifai.Clarifai.AccessTokenExpiration"
        static let MinTokenLifetime: TimeInterval = 60
    }
    
    init(clientID: String, clientSecret: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        
        self.loadAccessToken()
    }
    
    // MARK: Access Token Management
    
    fileprivate func loadAccessToken() {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        if self.clientID != userDefaults.string(forKey: Config.AppID) {
            self.invalidateAccessToken()
        } else {
            self.accessToken = userDefaults.string(forKey: Config.AccessToken)!
            self.accessTokenExpiration = userDefaults.object(forKey: Config.AccessTokenExpiration)! as? Date
        }
    }
    
    fileprivate func saveAccessToken(_ response: AccessTokenResponse) {
        if let accessToken = response.accessToken, let expiresIn = response.expiresIn {
            let userDefaults: UserDefaults = UserDefaults.standard
            let expiration: Date = Date(timeIntervalSinceNow: expiresIn)
            
            userDefaults.setValue(self.clientID, forKey: Config.AppID)
            userDefaults.setValue(accessToken, forKey: Config.AccessToken)
            userDefaults.setValue(expiration, forKey: Config.AccessTokenExpiration)
            userDefaults.synchronize()
            
            self.accessToken = accessToken
            self.accessTokenExpiration = expiration
        }
    }
    
    fileprivate func invalidateAccessToken() {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: Config.AppID)
        userDefaults.removeObject(forKey: Config.AccessToken)
        userDefaults.removeObject(forKey: Config.AccessTokenExpiration)
        userDefaults.synchronize()
        
        self.accessToken = nil
        self.accessTokenExpiration = nil
    }
    
    fileprivate func validateAccessToken(_ handler: @escaping (_ error: NSError?) -> Void) {
        if self.accessToken != nil && self.accessTokenExpiration != nil && self.accessTokenExpiration?.timeIntervalSinceNow > Config.MinTokenLifetime {
            handler(nil)
        } else {
            
            //let token = BDBOAuth1Credential(token: clientID, secret: clientSecret, expiration: nil)
            //self.requestSerializer.saveAccessToken(token)
            
            let params: Dictionary<String, AnyObject> = [
                "client_id": self.clientID as AnyObject,
                "client_secret": self.clientSecret as AnyObject,
                "grant_type": "client_credentials" as AnyObject
            ]
            
            Alamofire.request("https://api.clarifai.com/v1/token", method: .post, parameters: params)
                .validate()
                .responseJSON() { response in
                    switch response.result {
                    case .success(let result):
                        print(result)
                        let tokenResponse = AccessTokenResponse(responseJSON: result as! NSDictionary)
                        self.saveAccessToken(tokenResponse)
                    case .failure(let error):
                        handler(error as NSError?)
                    }
            }
        }
    }
    
    fileprivate class AccessTokenResponse: NSObject {
        var accessToken: String?
        var expiresIn: TimeInterval?
        
        init(responseJSON: NSDictionary) {
            self.accessToken = responseJSON["access_token"] as? String
            self.expiresIn = max(responseJSON["expires_in"] as! Double, Clarifai.Config.MinTokenLifetime)
        }
    }
    
    // MARK: Recognition Processing
    
    /** All available Clarifai recognition types */
    enum RecognitionType: String {
        case Tag = "tag"
        case Color = "color"
    }
    
    /** All available Models to apply to Clarifai Tag recognizition */
    enum TagModel: String {
        case General = "general-v1.3"
        case NSFW = "nsfw-v1.0"
        case Weddings = "weddings-v1.0"
        case Travel = "travel-v1.0"
        case Food = "food-items-v1.0"
    }
    
    /** All available ways to upload data to Clarifai for recognizition */
    fileprivate enum DataInputType {
        case image, url
    }
    
    /** Recognize components of one or more images via UIImage */
    func recognize(_ type: RecognitionType = .Tag, image: Array<UIImage>, model: TagModel = .General, completion: @escaping (Response?, NSError?) -> Void) {
        self.process(type, dataInputType: .image, data: image, model: model, completion: completion)
    }
    
    /** Recognize components of one or more images via string URL */
    func recognize(_ type: RecognitionType = .Tag, url: Array<String>, model: TagModel = .General, completion: @escaping (Response?, NSError?) -> Void) {
        self.process(type, dataInputType: .url, data: url as Array<AnyObject>, model: model, completion: completion)
    }
    
    fileprivate func process(_ type: RecognitionType, dataInputType: DataInputType, data: Array<AnyObject>, model: TagModel, completion: @escaping (Response?, NSError?) -> Void) {
        self.validateAccessToken { (error) in
            if error != nil {
                return completion(nil, error)
            }
            
            let multiop = data.count > 1
            self.endpoint = multiop ? "/multiop" : "/\(type.rawValue)"
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                switch dataInputType {
                case .url:
                    for url in data as! Array<String> {
                        multipartFormData.append(url.data(using: String.Encoding.utf8)!, withName: "url")
                    }
                case .image:
                    for image in data as! Array<UIImage> {
                        // We are reducing the size and quality of the input image so it will
                        //   consume less data when transfering over to Clarifai. This has very
                        //   little effect on the processing.
                        let size = CGSize(width: 320, height: 320 * image.size.height / image.size.width)
                        
                        UIGraphicsBeginImageContext(size)
                        image.draw(in: CGRect(x: 0, y: 0,width: size.width,height: size.height))
                        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        multipartFormData.append(UIImageJPEGRepresentation(scaledImage!, 0.9)!, withName: "encoded_image", fileName: "image.jpg", mimeType: "image/jpeg")
                    }
                }
                
                if type == .Tag {
                    multipartFormData.append(model.rawValue.data(using: String.Encoding.utf8)!, withName: "model")
                }
            }, with: try! self.asURLRequest() , encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.validate().responseJSON { response in
                        switch response.result {
                        case .success(let result):
                            let results = Response(type: type, data: result as! Dictionary<NSObject, AnyObject> as! Dictionary<String, AnyObject>)
                            completion(results, nil)
                        case .failure(let error):
                            completion(nil, error as NSError?)
                        }
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
                
            })
            
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Config.BaseURL.appendingFormat(endpoint as! String))!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = Alamofire.HTTPMethod.post.rawValue
        
        urlRequest.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
    
    class RecognitionTag: NSObject {
        var classLabel: String
        var probability: Float
        var conceptId: String
        
        init(classLabel label: String, probability prob: Float, conceptId conId: String) {
            classLabel = label
            probability = prob
            conceptId = conId
        }
    }
    
    class RecognitionColor: NSObject {
        var density: Float
        var hex: String
        var w3c: Dictionary<String, String>
        
        init(colorData: Dictionary<String, AnyObject>) {
            //let myJson : Dictionary<NSObject, AnyObject> = colorData
            density = colorData["density"] as! Float
            hex = colorData["hex"] as! String
            w3c = [
                "hex": colorData["w3c"]!["hex"] as! String,
                "name": colorData["w3c"]!["name"] as! String
            ]
        }
        
        // Thanks to:
        // https://gist.github.com/arshad/de147c42d7b3063ef7bc#gistcomment-1733974
        func toColor() -> UIColor {
            var colorString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            colorString = (colorString as NSString).substring(from: 1)
            
            let red: String = (colorString as NSString).substring(to: 2)
            let green = ((colorString as NSString).substring(from: 2) as NSString).substring(to: 2)
            let blue = ((colorString as NSString).substring(from: 4) as NSString).substring(to: 2)
            
            var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0;
            Scanner(string: red).scanHexInt32(&r)
            Scanner(string: green).scanHexInt32(&g)
            Scanner(string: blue).scanHexInt32(&b)
            
            return UIColor(red: CGFloat(r) / CGFloat(255.0), green: CGFloat(g) / CGFloat(255.0), blue: CGFloat(b) / CGFloat(255.0), alpha: CGFloat(1))
        }
    }
    
    class Result: NSObject {
        var recognitionType: RecognitionType
        var docId: String
        var tags: Array<RecognitionTag>?
        var colors: Array<RecognitionColor>?
        
        init(type: RecognitionType, data: Dictionary<String, AnyObject>) {
            self.recognitionType = type
            self.docId = data["docid_str"] as! String
            
            switch type {
            case .Tag:
                tags = []
                
                // We have to deconstruct the tag results here and not in RecognitionTag
                //   because the returned JSON groups classes, probabilities, and conceptIds
                //   seperately.
                print("here Data")
                let classLabels = (data["result"]!["tag"]!! as! [String:AnyObject])["classes"] as! Array<String>
                let probabilities = (data["result"]!["tag"]!!as! [String:AnyObject])["probs"] as! Array<Float>
                let conceptIds = (data["result"]!["tag"]!!as! [String:AnyObject])["concept_ids"] as! Array<String>
                
                for (index, label) in classLabels.enumerated() {
                    let probability = probabilities[index]
                    let conceptId = conceptIds[index]
                    
                    tags?.append(RecognitionTag(classLabel: label, probability: probability, conceptId: conceptId))
                }
            case .Color:
                colors = []
                
                // We are able to pass all the data to RecognitionColor and deconstruct it there
                //   since the returned JSON contains colors in self-contained objects
                for colorResult in data["colors"]! as! Array<Dictionary<NSObject, AnyObject>> {
                    colors?.append(RecognitionColor(colorData: colorResult as! Dictionary<String, AnyObject>))
                }
            }
        }
    }
    
    
    
    class Response: NSObject {
        var statusCode: String
        var statusMessage: String
        var recognitionType: RecognitionType
        var results: Array<Result> = []
        
        init(type: RecognitionType, data: Dictionary<String, AnyObject>) {
            self.recognitionType = type
            self.statusCode = data["status_code"] as! String
            self.statusMessage = data["status_msg"] as! String
            
            for resultData in data["results"] as! Array<Dictionary<NSObject, AnyObject>> {
                let result = Result(type: type, data: resultData as! Dictionary<String, AnyObject>)
                results.append(result)
            }
        }
    }
    
}
