//
//  SliderBar.h
//  TradeNow

#import <UIKit/UIKit.h>
@class TNWSliderBar;
@protocol TNWSliderBarDelegate <NSObject>
@optional   //可选
-(void) slider:(TNWSliderBar *)sliderBar valueChangedFrom:(CGFloat) oldValue to:(CGFloat) newValue;
-(void) sliderBarTouchInsize:(TNWSliderBar *)sliderBar;
@required   //必须

@end

@interface TNWSliderBar : UIView

@property (nonatomic) double tick;
@property (nonatomic) double maxSliderValue;
@property (nonatomic) double minSliderValue;
@property (nonatomic) double value;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat barSize;
@property (nonatomic) CGFloat innerCycleRadius;
@property (nonatomic) CGFloat outerCycleRadius;
@property (nonatomic, strong) UIColor * innerCycleColor;
@property (nonatomic, strong) UIColor * outerCycleColor;
@property (nonatomic, strong) UIColor * sliderBackgroundColor;
@property (nonatomic, strong) UIColor * barBorderColor;
@property (nonatomic, strong) UIColor * barFillColor;
@property (nonatomic, strong) UIColor * barEmptyColor;
@property (nonatomic, weak) id<TNWSliderBarDelegate> delegate;

-(void) incValue;
-(void) decValue;
@end
