//
//  Created by Sergey on 6/8/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String?, message: String?, okHandler:(() -> Void)?, cancelHandler:(() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            if okHandler != nil {
                okHandler!()
            }
        }
        
        alertVC.addAction(okAction)
        
        if cancelHandler != nil {
            let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: { (_) in
                cancelHandler!()
            })
            
            alertVC.addAction(cancelAction)
        }
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
