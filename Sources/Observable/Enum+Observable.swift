protocol EnumCollection: Hashable {
    static var allValues: [Self] { get }
    static func cases() -> AnySequence<Self>
}

extension EnumCollection {
    static var allValues: [Self] {
        return Array(self.cases())
    }
    
    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
}

