//
//  ViewController.m
//  VirtualImage
//
//  Created by 杜文亮 on 2017/10/23.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+FrostedGlass.h"
#import "UIImage+BlurImage.h"

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




#pragma mark - 控制

- (IBAction)changeShow:(UIButton *)sender
{
    switch (sender.tag) {
        case 101:
        {
            [self.view addSubview:[UIImageView FrostedGlass_ios7:self.img]];
        }
            break;
        case 102:
        {
            [self.view addSubview:[UIImageView FrostedGlass_ios8:self.img]];
        }
            break;
        case 103:
        {
            self.img.image = [UIImage coreBlurImage:[UIImage imageNamed:@"1"] withBlurNumber:2];
        }
            break;
        case 104:
        {
            self.img.image = [UIImage boxBlurImage:[UIImage imageNamed:@"1"] withBlurNumber:0.5];
        }
            break;
            
        default:
            break;
    }
}



@end
