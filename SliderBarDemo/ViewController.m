//
//  ViewController.m
//  SliderBarDemo
//
//  Created by user on 2019/11/14.
//  Copyright © 2019 user. All rights reserved.
//

#import "ViewController.h"
#import "TNWSliderBar.h"


@interface ViewController ()<TNWSliderBarDelegate>


@property (strong, nonatomic) TNWSliderBar * priceSliderBar;
@property (strong, nonatomic) TNWSliderBar * sizeSliderBar;


@end

@implementation ViewController


-(TNWSliderBar *)priceSliderBar {
    if (_priceSliderBar == nil) {
        _priceSliderBar = [[TNWSliderBar alloc] initWithFrame:CGRectMake(20,20,300, 40)];
        [_priceSliderBar setTag:7000];
        _priceSliderBar.delegate = self;
    }
    return _priceSliderBar;
}

- (TNWSliderBar *)sizeSliderBar {
    if (_sizeSliderBar == nil) {
        _sizeSliderBar = [[TNWSliderBar alloc] initWithFrame:CGRectMake(20,100,300, 40)];
        [_sizeSliderBar setTag:7001];
        _sizeSliderBar.delegate = self;
    }
    return _sizeSliderBar;
}


-(void) sliderBarTouchInsize:(TNWSliderBar *)sliderBar {
    //self.lineChartView.showTradeLine = NO;
    NSLog(@"touch");
    NSLog(@"%f", sliderBar.value);
}

-(void) slider:(TNWSliderBar *)sliderBar valueChangedFrom:(CGFloat)oldValue to:(CGFloat)newValue {
    NSLog(@"change");
    if (sliderBar.tag == 7000) {
        //self.priceValue = newValue;
        //self.lineChartView.showTradeLine = NO;
        //[self.lineChartView setTradeLinePointByPrice:self.priceValue andSize:self.sizeValue];
//        self.sizeSliderBar.value = newValue;
    } else if (sliderBar.tag == 7001) {
       // self.sizeValue = newValue;
//        self.priceSliderBar.value = newValue;
        //self.lineChartView.showTradeLine = NO;
        //[self.lineChartView setTradeLinePointByPrice:self.priceValue andSize:self.sizeValue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.priceSliderBar];
    self.priceSliderBar.minSliderValue = 0;
    self.priceSliderBar.maxSliderValue = 100;
    self.priceSliderBar.tick = 0.2;
    self.priceSliderBar.value = 50;
    [self.view addSubview:self.sizeSliderBar];
    self.sizeSliderBar.minSliderValue = 0;
    self.sizeSliderBar.maxSliderValue = 100;
    self.sizeSliderBar.tick = 0.2;
    self.sizeSliderBar.value = 50;
}


@end
