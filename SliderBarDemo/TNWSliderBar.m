//
//  SliderBar.m


#import "TNWSliderBar.h"
#import "ChartConst.h"

@interface TNWSliderBar()

@property (nonatomic) CGFloat halfHeight;
@property (nonatomic) CGFloat startX;
@property (nonatomic) CGFloat endX;
@property (nonatomic) CGPoint currentPoint;
@property (nonatomic) double oldValue;

@end

@implementation TNWSliderBar

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
@synthesize sliderBackgroundColor = _sliderBackgroundColor;
@synthesize barBorderColor = _barBorderColor;
@synthesize barFillColor = _barFillColor;
@synthesize barEmptyColor = _barEmptyColor;


-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        _width = frame.size.width;
        _height =  frame.size.height;
        _oldValue = 0;
        _value = 0;
        self.currentPoint = CGPointMake(self.startX, self.currentPoint.y);
    }
    return self;
}

-(CGFloat) startX {
    _startX = self.outerCycleRadius * 2 + 1;
    return _startX;
}

-(CGFloat) endX {
    _endX = _width - self.outerCycleRadius * 2 - 2;
    return _endX;
}

-(CGFloat) barSize {
    if (_barSize < 1) {
        _barSize = 1;
    }
    return _barSize;
}

-(double) tick {
    if (_tick <= 0) {
        _tick = 1;
    }
    return _tick;
}

-(CGFloat) fixTick:(CGFloat) oldValue {
    return ((NSInteger) (oldValue / self.tick)) * self.tick;
}

-(CGFloat) calcValueFromPoint: (CGPoint) point {
    CGFloat x = point.x;
    if (x < self.startX) {
        return self.minSliderValue;
    }
    if (x > self.endX) {
        return self.maxSliderValue;
    }
    return [self fixTick:self.minSliderValue + ((x - self.startX) / (self.endX - self.startX)) * (self.maxSliderValue - self.minSliderValue)] ;
}

-(double) value {
    //return [self calcValueFromPoint:_currentPoint];
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
        double fixval = ((NSInteger)(val / self.tick)) * self.tick;
        if (fixval < self.minSliderValue) {
            fixval = self.minSliderValue;
        }
        if (fixval > self.maxSliderValue) {
            fixval = self.maxSliderValue;
        }
        _value = fixval;
        CGFloat newX = self.startX + ((_value - self.minSliderValue) / (self.maxSliderValue - self.minSliderValue)) * (self.endX - self.startX);
        if (isnan(newX) || newX < _startX) {
            newX = _startX;
        }
        self.currentPoint = CGPointMake(newX, self.currentPoint.y);
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
        _innerCycleColor =  TNW_SLIDERBAR_INNERCYCLE_COLOR;
    }
    return _innerCycleColor;
}

-(UIColor *) outerCycleColor {
    if (_outerCycleColor == nil) {
        _outerCycleColor = TNW_SLIDERBAR_OUTERCYCLE_COLOR;
    }
    return _outerCycleColor;
}

-(UIColor *) sliderBackgroundColor {
    if(_sliderBackgroundColor == nil) {
        _sliderBackgroundColor = [UIColor clearColor];
    }
    return _sliderBackgroundColor;
}

-(UIColor *) barBorderColor {
    if(_barBorderColor == nil) {
        _barBorderColor = [UIColor blackColor];
    }
    return _barBorderColor;
}

-(UIColor *) barFillColor {
    if(_barFillColor == nil) {
        _barFillColor = TNW_SLIDERBAR_INNERCYCLE_COLOR;
    }
    return _barFillColor;
}

-(UIColor *) barEmptyColor {
    if(_barEmptyColor == nil) {
        _barEmptyColor = [UIColor grayColor];
    }
    return _barEmptyColor;
}

-(CGFloat) innerCycleRadius {
    if (_innerCycleRadius < 1.0) {
        _innerCycleRadius = 5.0f;
    }
    return _innerCycleRadius;
}

-(CGFloat) outerCycleRadius {
    if (_outerCycleRadius < 1.0) {
        _outerCycleRadius = 9.0f;
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
    self.backgroundColor = self.sliderBackgroundColor;
    _height = self.frame.size.height;
    _width = self.frame.size.width;
    _halfHeight = _height / 2.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    [self.backgroundColor setFill];
    CGContextFillRect(context, self.frame);
    CGContextRestoreGState(context);
    
    CGContextSetLineWidth(context, self.barSize);
//    CGContextSaveGState(context);
//
//    [self.barBorderColor setStroke];
//    CGContextSetLineWidth(context, 0.5f);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, self.startX, _halfHeight - 1);
//    CGContextAddLineToPoint(context, self.startX, _halfHeight + 1);
//    CGContextAddLineToPoint(context, self.endX, _halfHeight + 1);
//    CGContextAddLineToPoint(context, self.endX, _halfHeight - 1);
//    CGContextAddLineToPoint(context, self.startX, _halfHeight - 1);
//    CGContextStrokePath(context);
//
//    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    [self.barEmptyColor setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.startX, _halfHeight);
    CGContextAddLineToPoint(context, self.endX, _halfHeight);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    [self.barFillColor setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.startX, _halfHeight);
    CGContextAddLineToPoint(context, self.currentPoint.x, _halfHeight);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    [self.outerCycleColor setFill];
    CGContextFillEllipseInRect(context, CGRectMake(self.currentPoint.x - self.outerCycleRadius, _halfHeight - self.outerCycleRadius, self.outerCycleRadius * 2, self.outerCycleRadius * 2));
    
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    
    [self.innerCycleColor setFill];
    CGContextFillEllipseInRect(context, CGRectMake(self.currentPoint.x - self.innerCycleRadius, _halfHeight - self.innerCycleRadius, self.innerCycleRadius * 2, self.innerCycleRadius * 2));
    
    CGContextRestoreGState(context);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(sliderBarTouchInsize:)]) {
        [self.delegate sliderBarTouchInsize:self];
    }
    if (touchPoint.x >= self.startX && touchPoint.x <= self.endX) {
        CGFloat newVal = [self calcValueFromPoint:touchPoint];
        [self setValue:newVal];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event  {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if ([self.delegate respondsToSelector:@selector(sliderBarTouchInsize:)]) {
        [self.delegate sliderBarTouchInsize:self];
    }
    if (touchPoint.x >= self.startX && touchPoint.x <= self.endX) {
        CGFloat newVal = [self calcValueFromPoint:touchPoint];
        [self setValue:newVal];
    }
}

@end
