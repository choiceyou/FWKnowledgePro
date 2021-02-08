//
//  NSObject+KVO.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/27.
//

#import "NSObject+KVO.h"
#import <objc/message.h>

static const void *kObserverKey = &kObserverKey;

@implementation NSObject (KVO)

- (void)fw_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context
{
    // 1.注册并创建一个类
    NSString *oldName = NSStringFromClass(self.class);
    NSString *newName = [NSString stringWithFormat:@"FWKVONotifying_%@", oldName];
    // 创建
    Class SubClass = objc_allocateClassPair([self class], newName.UTF8String, 0);
    // 注册
    objc_registerClassPair(SubClass);
    
    // 2.修改self类型
    object_setClass(self, SubClass);
    
    // 3.重写set方法（子类动态添加set方法）
    NSString *setMethod = [NSString stringWithFormat:@"set%@:", keyPath.capitalizedString];
#warning 待完善。。。
    // 这边默认传入的参数都是id类型，如需支持更多类型，最后一个参数需要再进行判断修改
    class_addMethod(SubClass, sel_registerName(setMethod.UTF8String), (IMP)setterMethodIMP, "v@:@");
    // 设置关联属性
    objc_setAssociatedObject(self, kObserverKey, observer, OBJC_ASSOCIATION_ASSIGN);
}

void setterMethodIMP(id self, SEL _cmd, id newValue)
{
    // 1.改变父类的属性值
    struct objc_super superClass = {self, class_getSuperclass([self class])};
    ((void (*)(struct objc_super *, SEL, id))objc_msgSendSuper)(&superClass, _cmd, newValue);
    
    // 2.获取观察者
    id observer = objc_getAssociatedObject(self, kObserverKey);
    
    // 3.通知发生改变
    NSString *methodName = NSStringFromSelector(_cmd);
    NSString *key = getValueKey(methodName);
    
    ((void (*)(id, SEL, id, id, id, id))objc_msgSend)(observer, @selector(observeValueForKeyPath:ofObject:change:context:), key, self, @{key : newValue}, nil);
}

NSString *getValueKey(NSString *setter) {
#warning 待完善。。。
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    return key;
}

@end
