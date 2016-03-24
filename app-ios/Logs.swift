import UIKit

class Log {
    
    var dateStart: Int?
    var projectId: String?
    var seconds: Int?
    var task: String?

    init(json: NSDictionary) {
        self.dateStart = json["dateStart"] as? Int
        self.projectId = json["projectId"] as? String
        self.seconds = json["seconds"] as? Int
        self.task = json["task"] as? String
        
    }
}