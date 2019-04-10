//
//  UIButton+touch.m
//  DemoComponent
//
//  Created by lipeng on 2019/4/10.
//  Copyright © 2019 lipeng. All rights reserved.
//

#import "UIButton+touch.h"

@interface UIButton()
/* bool 设置是否执行触及事件方法*/
@property (nonatomic,assign) BOOL isExcuteEvent;
@end


@implementation UIButton (touch)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSel = @selector(sendAction:to:forEvent:);
        SEL newSel = @selector(newSendAction:to:forEvent:);
        // 获取到上面新建的oldSel方法
        Method oldMethod = class_getInstanceMethod(self, oldSel);
        // 获取到上面新建的newSel方法
        Method newMethod = class_getInstanceMethod(self, newSel);
        //
        BOOL isAdd = class_addMethod(self, oldSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        if (isAdd) {
            // 将newSel替换成oldMethod
            class_replaceMethod(self, newSel, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
        }
        else {
            // 给连个方法互换实现
            method_exchangeImplementations(oldMethod, newMethod);
        }
    });
}


- (void)newSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if ([NSStringFromClass([self class]) isEqualToString:@"UIButton"]){
        if (self.isExcuteEvent == 0) {
            self.timeInterval = self.timeInterval == 0 ? defaultInterval : self.timeInterval;
        }
        if (self.isExcuteEvent) return;
        if (self.timeInterval > 0) {
            self.isExcuteEvent = YES;
            [self performSelector:@selector(setIsExcuteEvent:) withObject:nil afterDelay:self.timeInterval];
        }
    }
    [self newSendAction:action to:target forEvent:event];
}

- (NSTimeInterval)timeInterval {
    // 动态获取关联对象
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    // 动态设置关联对象
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsExcuteEvent:(BOOL)isExcuteEvent {
    // 动态设置关联对象
    objc_setAssociatedObject(self, @selector(isExcuteEvent), @(isExcuteEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isExcuteEvent {
    // 动态获取关联对象
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
