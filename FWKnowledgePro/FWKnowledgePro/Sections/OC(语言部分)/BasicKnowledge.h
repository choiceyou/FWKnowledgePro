1、一个NSObjc对象占用多少内存？

// 获取NSObject实例对象的成员变量所占用的大小：答案是8个字节
// （class_getInstanceSize：创建一个实例对象，至少需要多少内存？）
NSLog(@"%zd", class_getInstanceSize([NSObject class]));

NSObject *objc = [[NSObject alloc] init];
// 获得objc指针所指向内存的大小：答案是16个字节
// （malloc_size：创建一个实例对象，实际分配多少内存？）
NSLog(@"NSObject对象占用的内存大小：%zd", malloc_size((__bridge const void *)objc));

答：系统分配16个字节给NSObject对象（可以通过malloc_size函数获得），但NSObject对象内部只使用了8个字节的空间（64bit环境下，可以通过class_getInstanceSize函数获得）。
拓展：
（1）OC对象的本质是结构体指针（isa默认占用8个字节。指针在64位系统中占8个字节，在32位系统中占4个字节）；
（2）内存对齐：结构体的大小必须是最大成员大小的倍数；
（3）计算某个数据类型所占用的内存大小：NSLog(@"%lu", sizeof(NSString *));


2、对象的isa指针指向哪里？
答：
（1）instance对象（实例对象）的isa指向class对象（类对象）；
（2）class对象（类对象）的isa指向meta-class对象（元类对象）；
（3）meta-class对象（元类对象）的isa指向基类的mete-class对象；


3、OC的类信息存放在哪里？
答：
（1）对象方法、属性、成员变量、协议信息存放在class对象中（类对象）；
（2）类方法存放在meta-class对象中（（元类对象））；
（3）成员变量的具体值存放在instance对象中（实例对象）；


4、iOS用什么方式实现一个对象的KVO？（KVO的本质是什么？）
答：利用Runtime的API动态的生成一个子类，并且让instance对象的isa指向这个全新的子类，并且重写setter方法。
大致流程：
（1）当修改instance对象的属性时，会调用Foundation的_NSSetXXXValueAndNotify函数；
（2）调用willChangeValueForKey；
（3）调用父类原来的setter方法；
（4）调用didChangeValueForKey，内部会触发监听器（Observe）的监听方法(observeValueForKeyPath:ofObject:change:context:)；


5、如何手动触发KVO？
答：手动调用 willChangeValueForKey: 及 didChangeValueForKey: 方法即可。
如： [self.person willChangeValueForKey:@"XXX"];
    [self.person didChangeValueForKey:@"XXX"];


6、直播修改成员变量会触发KVO么？
答：不会触发KVO。


7、通过KVC修改属性会触发KVO么？
答：会触发KVO。


8、KVC的赋值和取值过程是怎样的？原理是什么？
答：总体原则是先找相关方法，再找相关成员变量；
KVC的赋值过程：
（1）先依次查找set<Key>、_set<Key>、setIs<Key>方法，如果找到直接调用，反之，没有找到则继续寻找；
（2）通过accessInstanceVariablesDirectly方法判断，如果为YES（默认返回YES），则依次寻找_<Key>、_Is<Key>、<Key>、is<Key>成员变量，如果找到就直接赋值，反之，没有找到调用setValue:forUndefinedKey:函数并抛出异常NSUnknownKeyException；
（3）通过accessInstanceVariablesDirectly方法判断，如果为NO，直接调用setValue:forUndefinedKey:函数并抛出异常NSUnknownKeyException。

KVC的取值过程：
（1）先依次查找get<Key>、<Key>、is<Key>、_<Key>，如果找到直接调用，反之，没有找到则继续寻找；
（2）通过accessInstanceVariablesDirectly方法判断，如果为YES（默认返回YES），则依次寻找_<Key>、_Is<Key>、<Key>、is<Key>成员变量，如果找到就直接取值，反之，没有找到调用valueForUndefinedKey:函数并抛出异常NSUnknownKeyException；
（3）通过accessInstanceVariablesDirectly方法判断，如果为NO，直接调用valueForUndefinedKey:函数并抛出异常NSUnknownKeyException。


9、Category的实现原理：
答：Category编译后底层结构是struct category_t，里面存储着分类的对象方法、类方法、属性、协议信息，在程序运行的时候，runtime会将Category的数据，合并到类信息中（类对象、元类对象）。


10、Category与Class Extension的区别是什么？
答：
（1）Class Extension在编译的时候，它的数据就已经包含在类信息中；
（2）Category是在运行时，才会将数据合并到类信息中；


11、Category里面有load方法吗？load方法什么时候调用的？load方法能继承吗？
答：
（1）Category里面有load方法；
（2）load方法是在runtime加载类、分类的时候调用的；
（3）load方法可以继承，但是一般不会主动调用load方法，都是系统自动调用的；


12、load、initialize方法有什么区别？他们在Category中的调用顺序？以及出现继承时他们之间的调用过程？
答：
（1）调用方式区别：
    a. load是根据函数地址直接调用的；
    b. initialize是通过objc_msgSend调用的；
（2）调用时刻区别：
    a. load是在runtime加载类、分类的时候调用的（只会调用一次）；
    b. initialize是在类首次接收到消息时调用的，每一个类只会initialize一次（父类的initialize可能会被调用多次）；
（3）调用顺序（包括继承的情况）：
    load：
    a. 首先调用类，按编译时的顺序执行。调用子类的load之前，会先调用父类的load；
    b. 然后调用分类，按编译时的顺序执行；
    initialize：
    a. 先初始化父类；
    b. 再初始化子类（可能最终调用的是父类的initialize方法）；






===========

1、为什么说Objective-C是一门动态的语言？
（1）动态类型：例如“id”类型，动态类型属于弱类型，在运行时才决定消息的接收者；
（2）动态绑定：程序在运行时才决定调用什么代码，而不是在编译时；
（3）动态载入：程序在运行时的代码模块以及相关资源是在运行时添加的，而不是启动时就加载所有资源。


2、属性的实质是什么？包括哪几个部分？属性默认的关键字都有哪些？@dynamic关键字和@synthesize关键字是用来做什么的？
（1）实质就是 ivar（实例变量）、存取方法（access method ＝ getter + setter），即：@property = ivar + getter + setter;
（2）属性可以拥有的特质分为四类：原子性、读/写权限、内存管理语义、方法名；
（3）
