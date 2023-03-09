import Foundation

final class WeakReferenceProxy<ReferenceType: AnyObject> {
    weak var object: ReferenceType?

    init(_ object: ReferenceType) {
        self.object = object
    }
}
