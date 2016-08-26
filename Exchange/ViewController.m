//
//  ViewController.m
//  Exchange
//
//  Created by nercita on 16/8/26.
//  Copyright © 2016年 nercita. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    iv.image = [UIImage imageNamed:@"tomato"];
//    [iv performSelector:@selector(lxs_setImage:) withObject:[UIImage imageNamed:@"tomato"]];
    [self.view addSubview:iv];
}

+(void)load{
    
    SEL originalSelector = @selector(setImage:);
    SEL swizzledSelector = @selector(lxs_setImage:);
    
    Method originalMethod = class_getInstanceMethod([UIImageView class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    
    IMP originalIMP = method_getImplementation(originalMethod);
    IMP swizzledIMP = method_getImplementation(swizzledMethod);
    //同类:老新新,新老老,老新; 异类:新老老,老新新,老新
    BOOL isSuccess = class_addMethod([UIImageView class], swizzledSelector, originalIMP, method_getTypeEncoding(originalMethod));
    
    if (isSuccess) {
    
        class_replaceMethod([UIImageView class], originalSelector, swizzledIMP, method_getTypeEncoding(swizzledMethod));
    }else{
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



-(void)lxs_setImage:(UIImage *)image{
    
    NSLog(@"YES");
    [self lxs_setImage:image];
}

@end
