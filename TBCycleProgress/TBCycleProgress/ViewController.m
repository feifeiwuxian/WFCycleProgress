//
//  ViewController.m
//  TBCycleProgress
//
//  Created by qianjianeng on 16/2/22.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "ViewController.h"
#import "TBCycleView.h"
#import <pop/POP.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet TBCycleView *cycleView;
@property (nonatomic, assign) CGFloat currentProgress;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)slider:(UISlider *)sender {
    self.cycleView.label.text = [NSString stringWithFormat:@"%.2f%%", sender.value*100];
    [self.cycleView drawProgress:sender.value];
    _currentProgress = sender.value;
}
- (IBAction)btnClick:(UIButton *)sender {
    [self.cycleView drawProgress:0.85];
    [self popAnimation:_currentProgress to:0.85];
}

- (void)popAnimation:(CGFloat )startProgress to:(CGFloat )endProgress{
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"money" initializer:^(POPMutableAnimatableProperty *prop) {
        
        
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            UILabel *btn = (UILabel *)obj;
            
            @autoreleasepool {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterNoStyle];
                [formatter setFormatWidth:9];
                [formatter setPositiveFormat:@",##0.00"];
                NSString *titleStr =  [NSString stringWithFormat:@"%.@",[formatter stringFromNumber:@(values[0])]];
//                [btn setTitle:titleStr forState:UIControlStateNormal];
                btn.text = titleStr;
            }
            
        };
        //力学阀值,值越大writeBlock的调用次数越少
        prop.threshold = 1;
    }];
    POPBasicAnimation *anBasic = [POPBasicAnimation easeInEaseOutAnimation];
    anBasic.property = prop;
    anBasic.fromValue = @(startProgress);
    anBasic.toValue = @(endProgress);
    anBasic.duration = 1.0 * fabs(startProgress - endProgress);
    [_myLable pop_addAnimation:anBasic forKey:@"money"];
}

@end
