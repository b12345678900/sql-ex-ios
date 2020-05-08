import UIKit
import CoreData
class UserInfo {
    
    static func saveUserData (login:String,password:String,context:NSManagedObjectContext)
    {
        
     
        let userObject = User(context: context)
        
        userObject.login = login
        userObject.password = password
        do {
            try context.save()
            
            print("Saved! Good Job!")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func LoadUserData(context:NSManagedObjectContext)->User?
    {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        var temp:[User]?
        do {
             temp = try context.fetch(fetchRequest)
            
        } catch {
            print(error.localizedDescription)
        }
        if (temp?.count==0) {temp=nil}
        return temp?[0]
    }
}







