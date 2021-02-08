1、一个NSObjc对象占用多少内存？

// 获取NSObject实例对象的成员变量所占用的大小：答案是8个字节
// （class_getInstanceSize：创建一个实例对象，至少需要多少内存？）
NSLog(@"%zd", class_getInstanceSize([NSObject class]));

NSObject *objc = [[NSObject alloc] init];
// 获得objc指针所指向内存的大小：答案是16个字节
// （malloc_size：创建一个实例对象，实际分配多少内存？）
NSLog(@"NSObject对象占用的内存大小：%zd", malloc_size((__bridge const void *)objc));

答：系统分配16个字节给NSObject对象（可以通过malloc_size函数获得），但NSObject对象内部只使用了8个字节的空间（64bit环境下，可以通过class_getInstanceSize函数获得）。
拓展：（1）OC对象的本质是结构体指针（isa默认占用8个字节。指针在64位系统中占8个字节，在32位系统中占4个字节）；
     （2）内存对齐：结构体的大小必须是最大成员大小的倍数；
     （3）计算某个数据类型所占用的内存大小：NSLog(@"%lu", sizeof(NSString *));


2、对象的isa指针指向哪里？
答：（1）instance对象（实例对象）的isa指向class对象（类对象）；
   （2）class对象（类对象）的isa指向meta-class对象（元类对象）；
   （3）meta-class对象（元类对象）的isa指向基类的mete-class对象；


3、OC的类信息存放在哪里？
答：（1）对象方法、属性、成员变量、协议信息存放在class对象中（类对象）；
   （2）类方法存放在meta-class对象中（（元类对象））；
   （3）成员变量的具体值存放在instance对象中（实例对象）；


4、iOS用什么方式实现一个对象的KVO？（KVO的本质是什么？）
答：


5、如何手动触发KVO？
答：




===========

1、为什么说Objective-C是一门动态的语言？
（1）动态类型：例如“id”类型，动态类型属于弱类型，在运行时才决定消息的接收者；
（2）动态绑定：程序在运行时才决定调用什么代码，而不是在编译时；
（3）动态载入：程序在运行时的代码模块以及相关资源是在运行时添加的，而不是启动时就加载所有资源。


2、属性的实质是什么？包括哪几个部分？属性默认的关键字都有哪些？@dynamic关键字和@synthesize关键字是用来做什么的？
（1）实质就是 ivar（实例变量）、存取方法（access method ＝ getter + setter），即：@property = ivar + getter + setter;
（2）属性可以拥有的特质分为四类：原子性、读/写权限、内存管理语义、方法名；
（3）
