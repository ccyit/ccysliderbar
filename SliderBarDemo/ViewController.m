//
//  ViewController.m
//  SliderBarDemo
//
//  Created by user on 2019/11/14.
//  Copyright © 2019 user. All rights reserved.
//

#import "ViewController.h"
#import "CCYSliderBar.h"


@interface ViewController ()<CCYSliderBarDelegate>

@property (strong, nonatomic) CCYSliderBar * priceSliderBar;

@end

@implementation ViewController


-(CCYSliderBar *)priceSliderBar {
    if (_priceSliderBar == nil) {
        _priceSliderBar = [[CCYSliderBar alloc] initWithFrame:CGRectMake(0,30,self.view.bounds.size.width, 200)];
        [_priceSliderBar setTag:42];
        _priceSliderBar.delegate = self;
    }
    return _priceSliderBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.priceSliderBar];
    self.priceSliderBar.minSliderValue = 100;
    self.priceSliderBar.maxSliderValue = 150;
    self.priceSliderBar.tick = 0.2;
    self.priceSliderBar.value = 50;
    self.priceSliderBar.barSize = 3;
}



#pragma mark -  CCYSliderBarDelegate

-(void) sliderBarTouchInsize:(CCYSliderBar *)sliderBar {
    NSLog(@"%f", sliderBar.value);
}

-(void) slider:(CCYSliderBar *)sliderBar valueChangedFrom:(CGFloat)oldValue to:(CGFloat)newValue {
    NSLog(@"%f", oldValue);

    NSLog(@"%f", newValue);
}




@end
