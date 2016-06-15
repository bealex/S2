import Foundation

public struct ToYouStyle: StyleObject {
    lazy var test:Int = self.int("test")
    lazy var clazz:Clazz = Clazz(ktv:self.ktv)

    public struct Clazz: StyleObject {
        lazy var inner:String = self.string("clazz.inner")
        lazy var inner2:Int = self.int("clazz.inner2")
        lazy var clazz2:Clazz2 = Clazz2(ktv:self.ktv)

        public struct Clazz2: StyleObject {
            lazy var inner3:Int = self.int("clazz.clazz2.inner3")

            public let ktv:KTVObject
            init(ktv:KTVObject) { self.ktv = ktv }
        }

        public let ktv:KTVObject
        init(ktv:KTVObject) { self.ktv = ktv }
    }

    public let ktv:KTVObject
    init(ktv:KTVObject) { self.ktv = ktv }
}
