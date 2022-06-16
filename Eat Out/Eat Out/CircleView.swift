/**
* CircleView:  Added additional functions like get view width, view height which is used in view controllers
*
* @author  Sai Swetha Chiguruvada
*/

import Swift
import UIKit

extension UIView {
    func asCircle() {
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
    func viewWidth() -> CGFloat {
            return self.frame.size.width
        }

    func viewHeight() -> CGFloat {
        return self.frame.size.height
    }
}
