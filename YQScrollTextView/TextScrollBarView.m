//
//  TextScrollBarView.m
//  ZhiFu
//
//  Created by OSX on 17/7/24.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import "TextScrollBarView.h"

@implementation TextScrollBarView {
    UILabel * _contentLabel1;
    UILabel * _contentLabel2;//连续滚动中使用
    
    UILabel * _contentLabel3;
    UILabel * _contentLabel4;//连续滚动中使用
    
    NSTimer * _timer;
    
    NSString * _text;//记录文本
    NSAttributedString * _attributeText;//记录文本
    NSString * _newText;//如果是从右往左，生成新文本
    UIFont * _font;//文字打下
    UIColor * _textColor;//文字颜色
    
    CGFloat _textWidth;//文字宽度
    CGFloat _textHeight;//文字高度
    TextScrollMode _currentScrollModel;//滚动类型
    TextScrollMoveDirection _currentMoveDirection;//滚动方向
    
    
}

- (instancetype)initWithFrame:(CGRect)frame textScrollModel:(TextScrollMode)scrollModel direction:(TextScrollMoveDirection)moveDirection {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        //默认初始化
        _text = @"";
        _newText = @"";
        _textColor = [UIColor blackColor];
        _font = [UIFont systemFontOfSize:self.frame.size.height - 6];
        
        //设置滚动模式和方向
        _currentScrollModel   = scrollModel;
        _currentMoveDirection = moveDirection;
    }
    return self;
}

#pragma mark - 开始滚动
- (void)scrollWithText:(NSString * )text textColor:(UIColor *)color font:(UIFont *)font {
    //清空self上的子视图
    for (int i = 0; i < self.subviews.count; i++) {
        UIView * view = [self.subviews objectAtIndex:i];
        [view removeFromSuperview];
        view = nil;
    }
    
    //赋新值
    _text = text;
    _textColor = color;
    _font = font;
    
    //判断滚动方向：左右计算宽度，上下计算高度
    switch (_currentMoveDirection) {
        case TextScrollMoveLeft: case TextScrollMoveRight:
            _textWidth = [self calculationWidthOrHeightByText:text width:CGFLOAT_MAX height:self.frame.size.height font:font].size.width;
            break;
            
        case TextScrollMoveTop: case TextScrollMoveBottom:
            _textHeight = [self calculationWidthOrHeightByText:text width:self.frame.size.width height:CGFLOAT_MAX font:font].size.height;
            break;
            
        default:
            break;
    }
}

#pragma mark - 创建滚动视图
- (void)startScroll {
    if (_text.length == 0) {//如果字符串长度为0，直接返回
        return;
    }
    
    switch (_currentMoveDirection) {
        case TextScrollMoveLeft: case TextScrollMoveRight:
            if (_textWidth < self.frame.size.width) {//如果字符串长度小于控件宽度，不滚动
                [self creatLabel1WithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                return;
            }
            break;
            
        case TextScrollMoveTop: case TextScrollMoveBottom:
            if (_textHeight < self.frame.size.height) {//如果字符串高度小于控件高度，不滚动
                [self creatLabel3WithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                return;
            }
            break;
            
        default:
            break;
    }
    
    //判断滚动方向为向右，则字符串反向显示
    if (_currentMoveDirection == TextScrollMoveRight) {
        for (int i = (int)_text.length - 1; i >= 0; i--) {
            _newText = [_newText stringByAppendingString:[_text substringWithRange:NSMakeRange(i, 1)]];
        }
        _text = _newText;
    }
    
    //初始化label
    [self initLabel];
    
    //Add controls
    [self addSubview:_contentLabel1];
    [self addSubview:_contentLabel2];
    [self addSubview:_contentLabel3];
    [self addSubview:_contentLabel4];
    
    //设置速度，开始滚动（默认为0.03）
    [self setMoveSpeed:0.03];;
}

- (void)initLabel {
    //初始化滚动字符串label
    switch (_currentScrollModel) {//判断滚动类型
        case TextScrollFromOutside_Indirect: {//间断
            if (_currentMoveDirection == TextScrollMoveLeft) {
                [self creatLabel1WithFrame:CGRectMake(self.frame.size.width, 0, _textWidth, self.frame.size.height)];
            } else if (_currentMoveDirection == TextScrollMoveRight) {
                [self creatLabel1WithFrame:CGRectMake(_textWidth, 0, _textWidth, self.frame.size.height)];
            } else if (_currentMoveDirection == TextScrollMoveTop) {
                [self creatLabel3WithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, _textHeight)];
            } else if (_currentMoveDirection == TextScrollMoveBottom) {
                [self creatLabel3WithFrame:CGRectMake(0, -_textHeight, self.frame.size.width, _textHeight)];
            }
        }
            break;
        case TextScrollFromOutside_Continuous: {//连续
            if (_currentMoveDirection == TextScrollMoveLeft) {
                [self creatLabel1WithFrame:CGRectMake(self.frame.size.width, 0, _textWidth, self.frame.size.height)];
                [self creatLabel2WithFrame:CGRectMake(self.frame.size.width + _textWidth, 0, _textWidth, self.frame.size.height)];
            } else if (_currentMoveDirection == TextScrollMoveRight) {
                [self creatLabel1WithFrame:CGRectMake(-_textWidth, 0, _textWidth, self.frame.size.height)];
                [self creatLabel2WithFrame:CGRectMake(-_textWidth * 2, 0, _textWidth, self.frame.size.height)];
            } else if (_currentMoveDirection == TextScrollMoveTop) {
                [self creatLabel3WithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, _textHeight)];
                [self creatLabel4WithFrame:CGRectMake(0, self.frame.size.height + _textHeight, self.frame.size.width, _textHeight)];
            } else if (_currentMoveDirection == TextScrollMoveBottom) {
                [self creatLabel3WithFrame:CGRectMake(0, -_textHeight, self.frame.size.width, _textHeight)];
                [self creatLabel4WithFrame:CGRectMake(0, -_textHeight * 2, self.frame.size.width, _textHeight)];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 创建label
- (void)creatLabel1WithFrame:(CGRect)frame {
    _contentLabel1 = [[UILabel alloc] initWithFrame:frame];
    _contentLabel1.text = _text;
    _contentLabel1.font = _font;
    _contentLabel1.textColor = _textColor;
    _contentLabel1.backgroundColor = [UIColor clearColor];
}

- (void)creatLabel2WithFrame:(CGRect)frame {
    _contentLabel2 = [[UILabel alloc] initWithFrame:frame];
    _contentLabel2.text = _text;
    _contentLabel2.font = _font;
    _contentLabel2.textColor = _textColor;
    _contentLabel2.backgroundColor = [UIColor clearColor];
}

- (void)creatLabel3WithFrame:(CGRect)frame {
    _contentLabel3 = [[UILabel alloc] initWithFrame:frame];
    _contentLabel3.text = _text;
    _contentLabel3.numberOfLines = 0;
    _contentLabel3.font = _font;
    _contentLabel3.textColor = _textColor;
    _contentLabel3.backgroundColor = [UIColor clearColor];
}

- (void)creatLabel4WithFrame:(CGRect)frame {
    _contentLabel4 = [[UILabel alloc] initWithFrame:frame];
    _contentLabel4.text = _text;
    _contentLabel4.numberOfLines = 0;
    _contentLabel4.font = _font;
    _contentLabel4.textColor = _textColor;
    _contentLabel4.backgroundColor = [UIColor clearColor];
}

#pragma mark - 设置速度
-(void)setMoveSpeed:(CGFloat)speed{
    if (speed > 0.1) {
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(contentMove) userInfo:nil repeats:YES];
        return;
    }
    if (speed < 0.001) {
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(contentMove) userInfo:nil repeats:YES];
        return;
    }
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:speed target:self selector:@selector(contentMove) userInfo:nil repeats:YES];
}

#pragma mark - 内容移动
- (void)contentMove {
    switch (_currentScrollModel) {
            
        case TextScrollFromOutside_Indirect: {
            [self moveFromOutside_Indirect];
        }
            break;
        case TextScrollFromOutside_Continuous: {
            [self moveFromOutside_Continuous];
        }
            break;
            
        default:
            break;
    }
}

//控件外开始间接滚动
- (void)moveFromOutside_Indirect {
    if (_currentMoveDirection == TextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x -1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x < -_textWidth) {
            _contentLabel1.frame = CGRectMake(self.frame.size.width, 0, _textWidth, self.frame.size.height);
        }
    } else if (_currentMoveDirection == TextScrollMoveRight) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x +1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x > self.frame.size.width) {
            _contentLabel1.frame = CGRectMake(-_textWidth, 0, _textWidth, self.frame.size.height);
        }
    } else if (_currentMoveDirection == TextScrollMoveTop) {
        _contentLabel3.frame = CGRectMake(0, _contentLabel3.frame.origin.y - 1, self.frame.size.width, _contentLabel3.frame.size.height);
        if (_contentLabel3.frame.origin.y < -_textHeight) {
            _contentLabel3.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, _textHeight);
        }
    } else if (_currentMoveDirection == TextScrollMoveBottom) {
        _contentLabel3.frame = CGRectMake(0, _contentLabel3.frame.origin.y + 1, self.frame.size.width, _contentLabel3.frame.size.height);
        if (_contentLabel3.frame.origin.y > self.frame.size.height) {
            _contentLabel3.frame = CGRectMake(0, -_textHeight, self.frame.size.width, _textHeight);
        }
    }
}

//控件外开始连续滚动
- (void)moveFromOutside_Continuous {
    if (_currentMoveDirection == TextScrollMoveLeft) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x - 1, 0, _textWidth, self.frame.size.height);
        _contentLabel2.frame = CGRectMake(_contentLabel2.frame.origin.x - 1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x < -_textWidth) {
            _contentLabel1.frame = CGRectMake(_contentLabel2.frame.origin.x + _textWidth, 0, _textWidth, self.frame.size.height);
        }
        if (_contentLabel2.frame.origin.x < -_textWidth) {
            _contentLabel2.frame = CGRectMake(_contentLabel1.frame.origin.x + _textWidth, 0, _textWidth, self.frame.size.height);
        }
    } else if (_currentMoveDirection == TextScrollMoveRight) {
        _contentLabel1.frame = CGRectMake(_contentLabel1.frame.origin.x + 1, 0, _textWidth, self.frame.size.height);
        _contentLabel2.frame = CGRectMake(_contentLabel2.frame.origin.x + 1, 0, _textWidth, self.frame.size.height);
        if (_contentLabel1.frame.origin.x > _textWidth) {
            _contentLabel1.frame = CGRectMake(_contentLabel2.frame.origin.x - _textWidth, 0, _textWidth, self.frame.size.height);
        }
        if (_contentLabel2.frame.origin.x > _textWidth) {
            _contentLabel2.frame = CGRectMake(_contentLabel1.frame.origin.x - _textWidth, 0, _textWidth, self.frame.size.height);
        }
    } else if (_currentMoveDirection == TextScrollMoveTop) {
        _contentLabel3.frame = CGRectMake(0, _contentLabel3.frame.origin.y - 1, self.frame.size.width, _textHeight);
        _contentLabel4.frame = CGRectMake(0, _contentLabel4.frame.origin.y - 1, self.frame.size.width, _textHeight);
        if (_contentLabel3.frame.origin.y < -_textHeight) {
            _contentLabel3.frame = CGRectMake(0, _contentLabel4.frame.origin.y + _textHeight, self.frame.size.width, _textHeight);
        }
        if (_contentLabel4.frame.origin.y < -_textHeight) {
            _contentLabel4.frame = CGRectMake(0, _contentLabel3.frame.origin.y + _textHeight, self.frame.size.width, _textHeight);
        }
    } else if (_currentMoveDirection == TextScrollMoveBottom) {
        _contentLabel3.frame = CGRectMake(0, _contentLabel3.frame.origin.y + 1, self.frame.size.width, _textHeight);
        _contentLabel4.frame = CGRectMake(0, _contentLabel4.frame.origin.y + 1, self.frame.size.width, _textHeight);
        if (_contentLabel3.frame.origin.y > self.frame.size.height) {
            _contentLabel3.frame = CGRectMake(0, _contentLabel4.frame.origin.y - _textHeight, self.frame.size.width, _textHeight);
        }
        if (_contentLabel4.frame.origin.y > self.frame.size.height) {
            _contentLabel4.frame = CGRectMake(0, _contentLabel3.frame.origin.y - _textHeight, self.frame.size.width, _textHeight);
        }
    }
}

//计算宽高
- (CGRect)calculationWidthOrHeightByText:(NSString *)text width:(CGFloat)width height:(CGFloat)height font:(UIFont *)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width,height)//限制最大宽度
                                     options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                  attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]//传人的字体字典
                                     context:nil];
    return rect;
}

- (void)endScroll {
    [_timer invalidate];
    _timer = nil;
    
    [_contentLabel1 removeFromSuperview];
    [_contentLabel2 removeFromSuperview];
    [_contentLabel3 removeFromSuperview];
    [_contentLabel4 removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
