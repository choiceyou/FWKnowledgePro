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


13、block的原理是怎么样的？本质是什么？
答：封装了函数调用及函数调用环境的OC对象；


14、__block的作用是什么？使用是有什么注意点？
答：__block可以用于解决block内部无法修改auto变量值的问题；


15、block的属性修饰词为什么是copy？使用block有哪些使用注意？
答：
（1）block一旦没有进行copy操作就只会在堆上；
（2）使用注意：注意循环引用问题；


16、block在修改NSMutableArray时，需不需要加上__block？
答：
（1）如果修改的是NSMutableArray的存储内容的话，是不需要添加__block修饰的；
（2）如果修改的是NSMutableArray对象的本身，那必须添加__block修饰。


17、讲一下OC的消息机制
答：OC中的方法调用其实都是转成了objc_msgSend函数调用，给receiver（方法调用者）发送一条消息（selector方法名）；
objc_msgSend大致分为三大阶段：
（1）消息发送（当前类、父类的缓存列表、方法列表中查找）；
（2）动态方法解析；
（3）消息转发；


18、描述一下消息转发机制
答：
（1）调用forwardingTargetForSelector:方法，如果返回值不为nil，执行objc_msgSend方法，反之，继续往下；
（2）调用methodSignatureForSelector:方法，如果返回值为nil，执行错误方法doesNotRecognizeSelector:方法，反之，继续往下执行；
（3）调用forwardInvocation:方法；


19、什么是Runtime？平时项目中有用过么？
答：
Runtime：OC是一门动态性比较强的编程语言，允许很多操作推迟到程序运行时再进行，OC的动态性就是由Runtime来支撑和实现的。Runtime是一套C语言的API，封装了很多动态性相关的函数。平时编写的OC代码，底层都是转换成RuntimeAPI进行调用的；
具体应用：
（1）交换方法实现：method_exchangeImplementations（如：可以交换系统自带的某个方法）；
（2）关联对象：给分类添加属性：objc_setAssociatedObject、objc_getAssociatedObject；
（3）遍历类的所有成员变量（ 可以访问他的私有成员变量，如：字典转模型，自动归档、解档，修改textfield的占位文字颜色等等）；
（4）利用消息转发机制解决方法找不到的问题，等等；


20、讲讲Runloop，项目中有用到吗？
答：RunLoop 翻译过来是运行循环，指的是在程序运行过程中循环做一些事情。

基本作用:
（1）保持程序的持续运行
（2）处理App中的各种事件
（3）节省CPU资源,提高程序性能(该做事时做事,该休息时休息)

应用范畴有:
（1）定时器(NSTimer),PerformSelector
（2）GCD Async Main Queue
（3）时间响应,手势识别,界面刷新
（4）网络请求
（5）AutoreleasePool


21、Runloop内部实现逻辑？
答：（详细请参考截图：RunLoop的运行逻辑_图形版）
    01.通知Observers: 进入Loop
    02.通知Observers: 即将处理Timers
    03.通知Observers: 即将处理Sources
    04.处理Blocks
    05.处理Source0(可能再次处理Blocks)
    06.如果存在Source1,就直接跳第8步
    07.通知Observers: 开始休眠(等待消息唤醒)
    08.通知Observers:结束休眠(被某个消息唤醒)
    处理Timer
    处理GCD Async To Main Queue
    处理Sourcel
    09.处理blocks
    10.根据前面的执行结果,决定如何操作
        a> 回到第02步
        b> 退出Loop
    11.通知Observers: 退出Loop


22、Runloop和线程的关系？
答：
（1）每条线程都有唯一的一个与之相对应的RunLoop对象；
（2）RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value；
（3）线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建；
（4）RunLoop会在线程结束时销毁；
（5）主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop。


23、Timer和Runloop的关系？
答：
（1）RunLoop的Mode结构中含有一个_timers数组，因此，可以接收定时源；
（2）Timer可以唤醒线程；


24、程序中添加每3秒响应一次的NSTimer，当拖动tableView时timer可能无法响应要怎么解决？
答：将定时器添加到RunLoop中，并将mode设置为NSRunLoopCommonModes。


25、Runloop是怎么响应用户操作的，具体流程是怎么样的？
答：先由Sourcel1进行捕捉，然后交于Source0进行处理。


26、说说Runloop的几种状态？
答：
kCFRunLoopEntry = (1UL << 0), // 进入Loop
kCFRunLoopBeforeTimers = (1UL << 1), // 即将处理NSTimer
kCFRunLoopBeforeSources = (1UL << 2), // 即将处理Sources
kCFRunLoopBeforeWaiting = (1UL << 5), // 即将休眠
kCFRunLoopAfterWaiting = (1UL << 6), // 即将被唤醒
kCFRunLoopExit = (1UL << 7), // 退出
kCFRunLoopAllActivities = 0x0FFFFFFFU // 所有状态


27、Runloop的mode作用是什么？
答：一个RunLoop包含若干的Mode,每个Mode又包含若干个Source0/Source1/Timers/Observers
常见的mode有两种：
（1）kCFRunLoopDefaultMode App的默认mode,通常主线程是在这个Mode下运行；
（2）UITrackingRunLoopMode: 界面追踪Mode,用于ScrollView追踪触摸滑动,保证界面滑动时候不受其他的Mode影响。

注意
（1）NSDefaultRunLoopMode 和 UITrackingRunLoopMode 是真正存在的模式；
（2）NSRunLoopCommonModes并不是一个真的模式，它只是一个占位；
（3）timer能在_commonModes数组中存放的模式下工作。


28、使用CADisplayLink、NSTimer有什么注意点？
答：需要注意循环引用导致的内存泄漏问题。CADisplayLink、NSTimer调用的某些方法会对传入的对象进行强引用，那么，此时如果该对象又强引用了CADisplayLink、NSTimer对象时就会造成循环引用。处理方法：可以引入第三方对象，让第三方对象弱指向该对象。


29、介绍一下内存的几大区域？
地址值由低到高分别为：
（1）保留；
（2）代码段（_TEXT）：编译之后的代码；
（3）数据段（_DATA）：字符串常量，已初始化的全局变量、静态变量等，未初始化的全局变量、静态变量等；
（4）堆（heap）：通过alloc、malloc、calloc等动态分配的空间。分配的空间地址越来越大；
（5）栈（stack）：函数调用开销，比如局部变量。分配的空间地址越来越小；
（6）内核区；


30、讲讲你对iOS内存管理的理解？
答：
（1）小数据对象类型：采用TaggedPointer方式（小数据对象类型：NSNumber、NSString、NSDate等）；
（2）其它对象类型：系统通过“引用计数器”来判断当前对象是否可以被释放，当对象“引用计数”为0时会被释放；
    a. arm64系统下，对象的引用计数存放在isa中，当isa不够存放后，


31、ARC都帮我们做了什么？
答：


32、weak指针的实现原理？
答：
（1）当一个对象objc被weak指针指向时，这个weak指针会以objc作为key，被存储到sideTable类的weak_table这个散列表上对应的一个weak指针数组里面；
（2）当一个对象objc的dealloc方法被调用时，Runtime会以objc为key，从sideTable的weak_table散列表中，找出对应的weak指针列表，然后将里面的weak指针逐个置为nil。


33、autorelease对象在什么时机会被调用release？
答：
（1）如果对象被@autoreleasepool{}包裹住，那么当“}”结束时（即：autoreleasepool调用pop方法时），就会调用对象的release方法；
（2）如果对象没有被@autoreleasepool{}包裹住，那么它什么时候释放是由Runloop控制的。它有可能是在某次Runloop循环中，Runloop休眠之前调用了release。

34、方法里有局部对象，出了方法会立即释放吗？
答：
（1）ARC中：马上释放；
（2）MRC中：如果通过aotorelease方式自动释放的话，那么它什么时候释放是由Runloop控制的。它有可能是在某次Runloop循环中，Runloop休眠之前调用了release。



===========

1、为什么说Objective-C是一门动态的语言？
（1）动态类型：例如“id”类型，动态类型属于弱类型，在运行时才决定消息的接收者；
（2）动态绑定：程序在运行时才决定调用什么代码，而不是在编译时；
（3）动态载入：程序在运行时的代码模块以及相关资源是在运行时添加的，而不是启动时就加载所有资源。


2、属性的实质是什么？包括哪几个部分？属性默认的关键字都有哪些？@dynamic关键字和@synthesize关键字是用来做什么的？
（1）实质就是 ivar（实例变量）、存取方法（access method ＝ getter + setter），即：@property = ivar + getter + setter;
（2）属性可以拥有的特质分为四类：原子性、读/写权限、内存管理语义、方法名；
（3）
