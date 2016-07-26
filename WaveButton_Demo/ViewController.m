//
//  ViewController.m
//  WaveButton_Demo
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import "WaveButton.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define WeakSelf __weak typeof(self) weakSelf = self


@interface ViewController ()

@property (nonatomic,strong) WaveButton *operationBtn;;
//操作按钮数组
@property (nonatomic,strong) NSMutableArray *operationBtnArr;
//显示按钮 列表
@property (nonatomic,assign) BOOL showOperationBtns;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor blackColor];
    
    _showOperationBtns = false;
    [self setupAnimationOperationBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    
    [_operationBtn.layer setNeedsDisplay];
}
//操作按钮 动画效果: 水波纹
- (void)setupAnimationOperationBtn{
    _operationBtn = [[WaveButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 32, SCREEN_HEIGHT - 40 - 32, 64, 64)];
    _operationBtn.backgroundColor = [UIColor clearColor];
    _operationBtn.clearsContextBeforeDrawing = true;
    [_operationBtn setImage:[UIImage imageNamed:@"Circle"] forState:UIControlStateNormal];
    [_operationBtn addTarget:self action:@selector(showThreeButtons) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_operationBtn];


}
//懒加载 操作按钮数组
- (NSMutableArray *)operationBtnArr{
    if (!_operationBtnArr) {
        _operationBtnArr = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:_operationBtn.frame];
            btn.imageView.contentMode = UIViewContentModeScaleToFill;
            [btn setImage:[UIImage imageNamed:@"AddCity"] forState:UIControlStateNormal];
            btn.alpha = 0.0;
            [self.view addSubview:btn];
            [_operationBtnArr addObject:btn];
            
            UIImage *image = nil;
            
            switch (i) {
                case 0:
                    [btn addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
                    image = [UIImage imageNamed:@"AddCity"];
                    break;
                case 1:
                    [btn addTarget:self action:@selector(openSetting) forControlEvents:UIControlEventTouchUpInside];
                    image = [UIImage imageNamed:@"Setting"];
                    break;
                default:
                    [btn addTarget:self action:@selector(aboutMe) forControlEvents:UIControlEventTouchUpInside];
                    image = [UIImage imageNamed:@"AboutMe"];
                    break;
            }
            [btn setImage:image forState:UIControlStateNormal];
        }
        
    }
    return _operationBtnArr;
}
#pragma mark - 点击事件
-(void)addCity{
    NSLog(@"addCity");
}
-(void)openSetting{
    NSLog(@"openSetting");
}
-(void)aboutMe{
    NSLog(@"aboutMe");
}

//显示 三个操作按钮

- (void)showThreeButtons {
    WeakSelf;
    if (_showOperationBtns) {
        _showOperationBtns = false;
        [self.operationBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = (UIButton *)obj;
            //更改后 frame
            CGRect frame = weakSelf.operationBtn.frame;
            //延时
            float duration = 0.0;
            [UIView animateWithDuration:0.4 delay:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
                btn.alpha = 0.0;
                btn.frame = frame;
                btn.transform = CGAffineTransformMakeRotation(M_PI);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }else{
        _showOperationBtns = true;
        [self.operationBtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = (UIButton *)obj;
            //更改后 frame
            CGRect frame = btn.frame;
            frame.size.width = frame.size.height = 44;
            //延时
            float duration = 0.0;
            
            //        UIImage *btnImage = nil;
            switch (idx) {
                case 0:
                    frame.origin.x -= 50 * sqrt(2);
                    frame.origin.y -= 50 * sqrt(2);
                    break;
                case 1:
                    frame.origin.y -= 100;
                    duration = 0.1;
                    break;
                default:
                    frame.origin.x += 50 * sqrt(2);
                    frame.origin.y -= 50 * sqrt(2);
                    duration = 0.25;
                    break;
            }
            //按延迟 将三个button 按顺序依次弹出
            [UIView animateWithDuration:0.4 delay:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
                btn.alpha = 1.0;
                btn.frame = frame;
                btn.transform = CGAffineTransformMakeRotation(M_PI * 2);
            } completion:^(BOOL finished) {
                
            }];
        }];
        
    }
}

@end
