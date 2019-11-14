//
//  SliderBar.m


#import "CCYSliderBar.h"

@interface CCYSliderBar()

@property (nonatomic) CGFloat halfHeight;//高度的一半
@property (nonatomic) CGFloat startX;//开始位置
@property (nonatomic) CGFloat endX;//结束位置
@property (nonatomic) CGFloat currentPointX;//当前位置
@property (nonatomic) double oldValue;//前一个值

@end

@implementation CCYSliderBar

@synthesize maxSliderValue = _maxSliderValue;
@synthesize minSliderValue = _minSliderValue;
@synthesize tick = _tick;
@synthesize value = _value;
@synthesize innerCycleColor = _innerCycleColor;
@synthesize innerCycleRadius = _innerCycleRadius;
@synthesize outerCycleColor = _outerCycleColor;
@synthesize outerCycleRadius = _outerCycleRadius;
@synthesize barSize = _barSize;
@synthesize width = _width;
@synthesize height = _height;
@synthesize barFillColor = _barFillColor;
@synthesize barEmptyColor = _barEmptyColor;


-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        //设置背景色
        self.backgroundColor = [UIColor clearColor];
        _width = frame.size.width;
        _height =  frame.size.height;

        //初始值为0
        _oldValue = 0;
        _value = 0;
        //当前位置
        self.currentPointX = self.startX;
    }
    return self;
}

-(CGFloat) startX {
    _startX = self.outerCycleRadius * 2;
    return _startX;
}

-(CGFloat) endX {
    _endX = _width - self.outerCycleRadius * 2;
    return _endX;
}

//size 必须大于等于2
-(CGFloat) barSize {
    if (_barSize < 2) {
        _barSize = 2;
    }
    return _barSize;
}

//tick 必须大于0
-(double) tick {
    if (_tick <= 0) {
        _tick = 1;
    }
    return _tick;
}

// 修正值,采用四舍五入求，最小变化值的整数倍。
-(CGFloat) fixTick:(CGFloat) oldValue {
    return ((NSInteger)round(oldValue / self.tick)) * self.tick;
}

//滑动位置，所对应的值，再最大值和最小值之间。
-(CGFloat) calcValueFromPoint: (CGPoint) point {
    CGFloat x = point.x;
    if (x <= self.startX) {
        return self.minSliderValue;
    }
    if (x >= self.endX) {
        return self.maxSliderValue;
    }
    return [self fixTick:self.minSliderValue + ((x - self.startX) / (self.endX - self.startX)) * (self.maxSliderValue - self.minSliderValue)] ;
}

-(double) value {
    //value 在最大值和最小值之间，不能超过此范围
    if (_value < self.minSliderValue) {
        _value = self.minSliderValue;
    }
    if (_value > self.maxSliderValue) {
        _value = self.maxSliderValue;
    }
    return _value;
}

-(void) setValue:(double) val {
    if (val <= self.maxSliderValue && val >= self.minSliderValue) {
        _oldValue = _value;
        double fixval = ((NSInteger)round(val / self.tick)) * self.tick;
        if (fixval <= self.minSliderValue) {
            fixval = self.minSliderValue;
        } else if (fixval >= self.maxSliderValue) {
            fixval = self.maxSliderValue;
        }
        _value = fixval;
        CGFloat newX = self.startX + ((_value - self.minSliderValue) / (self.maxSliderValue - self.minSliderValue)) * (self.endX - self.startX);
        if (isnan(newX) || newX <= _startX) {
            newX = _startX;
        }
        self.currentPointX = newX;
        if (_oldValue != val) {
            if ([self.delegate respondsToSelector:@selector(slider:valueChangedFrom:to:)]) {
                [self.delegate slider: self valueChangedFrom:_oldValue to:_value];
            }
        }
        [self setNeedsDisplay];
    }
}

-(double) minSliderValue {
    if (_minSliderValue < 0) {
        _minSliderValue = 0;
    }
    return _minSliderValue;
}

-(double) maxSliderValue {
    if (_maxSliderValue < 0) {
        _maxSliderValue = 0;
    }
    return _maxSliderValue;
}

-(UIColor *) innerCycleColor {
    if (_innerCycleColor == nil) {
        _innerCycleColor =  [UIColor greenColor];
    }
    return _innerCycleColor;
}

-(UIColor *) outerCycleColor {
    if (_outerCycleColor == nil) {
        _outerCycleColor = [UIColor blueColor];
    }
    return _outerCycleColor;
}

-(UIColor *) barFillColor {
    if(_barFillColor == nil) {
        _barFillColor = [UIColor redColor];
    }
    return _barFillColor;
}

-(UIColor *) barEmptyColor {
    if(_barEmptyColor == nil) {
        _barEmptyColor = [UIColor lightGrayColor];
    }
    return _barEmptyColor;
}

-(CGFloat) innerCycleRadius {
    if (_innerCycleRadius < 1.0) {
        _innerCycleRadius = 10.0f;
    }
    return _innerCycleRadius;
}

-(CGFloat) outerCycleRadius {
    if (_outerCycleRadius < 1.0) {
        _outerCycleRadius = 15.0f;
    }
    return _outerCycleRadius;
}

-(void) incValue {
    [self setValue:self.value + self.tick];
}

-(void) decValue {
    [self setValue:self.value - self.tick];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 设置背景色
    self.backgroundColor = [UIColor clearColor];
    _height = self.frame.size.height;
    _width = self.frame.size.width;
    _halfHeight = _height / 2.0;
    //获取上下文信息
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //填充背景色
    CGContextSaveGState(context);
    [self.backgroundColor setFill];
    CGContextFillRect(context, self.frame);
    CGContextRestoreGState(context);
    
    CGContextSetLineWidth(context, self.barSize);
    //添加边框sliderbar边框
    CGContextSaveGState(context);
    [[UIColor clearColor] setStroke];
    CGContextSetLineWidth(context, 1.5f);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.startX, _halfHeight - 1);
    CGContextAddLineToPoint(context, self.startX, _halfHeight + 1);
    CGContextAddLineToPoint(context, self.endX, _halfHeight + 1);
    CGContextAddLineToPoint(context, self.endX, _halfHeight - 1);
    CGContextAddLineToPoint(context, self.startX -1 , _halfHeight - 1);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    //画横线
    CGContextSaveGState(context);
    [self.barEmptyColor setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.startX, _halfHeight);
    CGContextAddLineToPoint(context, self.endX, _halfHeight);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    //画左端的线
    CGContextSaveGState(context);
    [self.barFillColor setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.startX, _halfHeight);
    CGContextAddLineToPoint(context, self.currentPointX, _halfHeight);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    //画一个大圆
    CGContextSaveGState(context);
    [self.outerCycleColor setFill];
    CGContextFillEllipseInRect(context, CGRectMake(self.currentPointX - self.outerCycleRadius, _halfHeight - self.outerCycleRadius, self.outerCycleRadius * 2, self.outerCycleRadius * 2));
    CGContextRestoreGState(context);
    //画一个小圆
    CGContextSaveGState(context);
    [self.innerCycleColor setFill];
    CGContextFillEllipseInRect(context, CGRectMake(self.currentPointX - self.innerCycleRadius, _halfHeight - self.innerCycleRadius, self.innerCycleRadius * 2, self.innerCycleRadius * 2));
    CGContextRestoreGState(context);
}

//点击屏幕
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(sliderBarTouchInsize:)]) {
        [self.delegate sliderBarTouchInsize:self];
    }
    
    if (touchPoint.x >= 0 && touchPoint.x <= self.width) {
        CGFloat newVal = [self calcValueFromPoint:touchPoint];
        [self setValue:newVal];
    }
}

//点击并滑动时间
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event  {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(sliderBarTouchInsize:)]) {
        [self.delegate sliderBarTouchInsize:self];
    }
    if (touchPoint.x >= 0 && self.width) {
        CGFloat newVal = [self calcValueFromPoint:touchPoint];
        [self setValue:newVal];
    }
}

@end
