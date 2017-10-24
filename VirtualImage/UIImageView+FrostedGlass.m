//
//  UIImageView+FrostedGlass.m
//  VirtualImage
//
//  Created by 杜文亮 on 2017/10/24.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "UIImageView+FrostedGlass.h"

@implementation UIImageView (FrostedGlass)

+(UIImageView *)FrostedGlass_ios7:(UIImageView *)source
{
    /*
     *   苹果在iOS7.0之后,很多系统界面都使用了毛玻璃效果,增加了界面的美观性,比如通知中心界面;
     其实在iOS7.0(包括)之前还是有系统的类可以实现毛玻璃效果的, 就是 UIToolbar这个类
     
     iOS7.0
     毛玻璃的样式(枚举)
     UIBarStyleDefault          = 0,
     UIBarStyleBlack            = 1,
     UIBarStyleBlackOpaque      = 1, // Deprecated. Use UIBarStyleBlack
     UIBarStyleBlackTranslucent = 2, // Deprecated. Use UIBarStyleBlack and set the translucent property to YES
     */
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, source.frame.size.width*0.5, source.frame.size.height)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [source addSubview:toolbar];
    return source;
}

+(UIImageView *)FrostedGlass_ios8:(UIImageView *)source
{
    /*
     *   在iOS8.0之后,苹果新增了一个类UIVisualEffectView,通过这个类来实现毛玻璃效果与上面的UIToolbar一样,而且效率也非常之高,使用也是非常简单,几行代码搞定. UIVisualEffectView是一个抽象类,不能直接使用,需通过它下面的三个子类来实现(UIBlurEffect, UIVisualEffevt, UIVisualEffectView);
     
     子类UIBlurEffect只有一个类方法,用来快速创建一个毛玻璃效果,参数是一个枚举,用来设置毛玻璃的样式,而UIVisualEffectView则多了两个属性和两个构造方法,用来快速将创建的毛玻璃添加到这个UIVisualEffectView上.
     
     iOS8.0
     毛玻璃的样式(枚举)
     UIBlurEffectStyleExtraLight,
     UIBlurEffectStyleLight,
     UIBlurEffectStyleDark
     */
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, source.frame.size.width*0.5, source.frame.size.height);
    [source addSubview:effectView];
    return source;
}

@end
