//  RepoSearch
//
//  Created by Sergey on 6/10/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

extension String {
    
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
