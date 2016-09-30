//
//  SwizzleHelper.m
//  SwizzleDemo
//
//  Created by 萧锐杰 on 16/9/30.
//  Copyright © 2016年 萧锐杰. All rights reserved.
//

#import "SwizzleHelper.h"
#import <objc/runtime.h>

@implementation SwizzleHelper

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SwizzleHelper swizzleViewDidLoad];
    });
    
}


+ (void)swizzleViewDidLoad {
    
    Class controllerClass = NSClassFromString(@"UIViewController");
    
    Method orgiMethod = class_getInstanceMethod(controllerClass, @selector(viewDidLoad));
    Method newMethod = class_getInstanceMethod([self class], @selector(jm_viewDidLoad));
    BOOL isSuccessAdd = class_addMethod(controllerClass, @selector(jm_viewDidLoad), method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    
    if (isSuccessAdd) {
        
        Method newMethodInUIViewcontroller = class_getInstanceMethod(controllerClass, @selector(jm_viewDidLoad));
        method_exchangeImplementations(orgiMethod, newMethodInUIViewcontroller);
    }
    
}

+ (void)swizzleViewDidLoadWithoutAdd {
    
    Class controllerClass = NSClassFromString(@"UIViewController");
    
    Method orgiMethod = class_getInstanceMethod(controllerClass, @selector(viewDidLoad));
    Method newMethod = class_getInstanceMethod([self class], @selector(jm_viewDidLoad));
    
    method_exchangeImplementations(orgiMethod, newMethod);
    
    
}


- (void)jm_viewDidLoad {
    [self jm_viewDidLoad];
    
    NSLog(@"jm_viewDidLoad####Class == %@ _cmd=%@",[self class],NSStringFromSelector(_cmd));
}

@end
