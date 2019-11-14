//
//  SliderBar.h
//  TradeNow

#import <UIKit/UIKit.h>
@class CCYSliderBar;
@protocol CCYSliderBarDelegate <NSObject>
@optional   
-(void) slider:(CCYSliderBar *)sliderBar valueChangedFrom:(CGFloat) oldValue to:(CGFloat) newValue;
-(void) sliderBarTouchInsize:(CCYSliderBar *)sliderBar;

@end

@interface CCYSliderBar : UIView

@property (nonatomic) double tick;//最小变化量
@property (nonatomic) double maxSliderValue;//最大值
@property (nonatomic) double minSliderValue;//最小值
@property (nonatomic) double value;//当前值
@property (nonatomic) CGFloat height;//高度
@property (nonatomic) CGFloat width;//宽度
@property (nonatomic) CGFloat barSize;//线条宽度
@property (nonatomic) CGFloat innerCycleRadius;//内圆半径
@property (nonatomic) CGFloat outerCycleRadius;//外圆半径
@property (nonatomic, strong) UIColor * innerCycleColor;//内圆颜色
@property (nonatomic, strong) UIColor * outerCycleColor;//外圆颜色
@property (nonatomic, strong) UIColor * barFillColor;//填充颜色
@property (nonatomic, strong) UIColor * barEmptyColor;//空值颜色
@property (nonatomic, weak) id<CCYSliderBarDelegate> delegate;//代理对象

-(void) incValue;//增加一个tick
-(void) decValue;//减少一个tick
@end
