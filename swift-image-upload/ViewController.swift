import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        download()
        upload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func download() {
        let url = "https://www.ruby-lang.org/images/header-ruby-logo@2x.png"
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        Alamofire.download(.GET, url, destination: destination).response { _, _, _, error in
            if let error = error {
                print("Failed with error: \(error)")
            } else {
                print("Downloaded file successfully")
            }
        }
    }
    
    func upload() {
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = directoryURL.URLByAppendingPathComponent("header-ruby-logo@2x.png")
        
        let headers = ["X-Api-Key": "zWBgEPUP7_CrcXQcbFetsQJpKV4dP-ERCBRqn2QGSDiHc_sP8Rjm4cYstiszVn59AUxcensVFwtM91NR"]
        
        Alamofire.upload(
            .PATCH,
            "http://localhost:3003/api/v1/reports/1",
            headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: "name from iOS".dataUsingEncoding(NSUTF8StringEncoding)!, name: "name")

                multipartFormData.appendBodyPart(data: "2".dataUsingEncoding(NSUTF8StringEncoding)!, name: "report_items_attributes[0][id]")
                multipartFormData.appendBodyPart(data: "2".dataUsingEncoding(NSUTF8StringEncoding)!, name: "report_items_attributes[0][sheet_item_id]")
                multipartFormData.appendBodyPart(data: "true".dataUsingEncoding(NSUTF8StringEncoding)!, name: "report_items_attributes[0][pass]")

                multipartFormData.appendBodyPart(data: "comment from iOS".dataUsingEncoding(NSUTF8StringEncoding)!, name: "report_items_attributes[0][report_details_attributes][0][comment]")
                multipartFormData.appendBodyPart(fileURL: fileURL, name: "report_items_attributes[0][report_details_attributes][0][image]")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
}

