//
//  ViewController.m
//  VirtualImage
//
//  Created by 杜文亮 on 2017/10/23.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "ViewController.h"
#import <Accelerate/Accelerate.h>

@interface ViewController ()

@property (nonatomic,strong) UIImageView *img;

@end

@implementation ViewController

-(UIImageView *)img
{
    if (!_img)
    {
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.frame) -40, 200)];
        _img.image = [UIImage imageNamed:@"1"];
    }
    return _img;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.img];
    
}

/*
 *   毛玻璃效果
 */
-(void)FrostedGlass_ios7
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
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _img.frame.size.width*0.5, _img.frame.size.height)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [_img addSubview:toolbar];
}

-(void)FrostedGlass_ios8
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
    effectView.frame = CGRectMake(0, 0, _img.frame.size.width*0.5, _img.frame.size.height);
    [_img addSubview:effectView];
}

/*
 *   高斯模糊效果
 */
-(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    /*
     *    CoreImage:
            iOS5.0之后就出现了Core Image的API,Core Image的API被放在CoreImage.framework库中, 在iOS和OS X平台上，Core Image都提供了大量的滤镜（Filter），在OS X上有120多种Filter，而在iOS上也有90多。
     */
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result =[ filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

-(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    /*
     *   vImage:
            vImage属于Accelerate.Framework，需要导入 Accelerate下的 Accelerate头文件， Accelerate主要是用来做数字信号处理、图像处理相关的向量、矩阵运算的库。图像可以认为是由向量或者矩阵数据构成的，Accelerate里既然提供了高效的数学运算API，自然就能方便我们对图像做各种各样的处理 ，模糊算法使用的是vImageBoxConvolve_ARGB8888这个函数。
     */
    if (blur < 0.f || blur > 1.f)
    {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}




#pragma mark - 控制

- (IBAction)changeShow:(UIButton *)sender
{
    switch (sender.tag) {
        case 101:
        {
            [self FrostedGlass_ios7];
        }
            break;
        case 102:
        {
            [self FrostedGlass_ios8];
        }
            break;
        case 103:
        {
            self.img.image = [self coreBlurImage:[UIImage imageNamed:@"1"] withBlurNumber:5];
        }
            break;
        case 104:
        {
            self.img.image = [self boxblurImage:[UIImage imageNamed:@"1"] withBlurNumber:0.5];
        }
            break;
            
        default:
            break;
    }
}



@end
