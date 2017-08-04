//
//  TextScrollBarView.h
//  ZhiFu
//
//  Created by OSX on 17/7/24.
//  Copyright © 2017年 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 描述字符串滚动前端起始位置：
 */
typedef NS_ENUM(NSInteger, TextScrollMode) {
    TextScrollFromOutside_Continuous,     // 从控件外开始连续滚动
    TextScrollFromOutside_Indirect,    // 从控件外开始间接滚动
};

/**
 描述字符串移动的方向
 */
typedef NS_ENUM(NSInteger, TextScrollMoveDirection) {
    TextScrollMoveLeft,
    TextScrollMoveRight,
    TextScrollMoveTop,
    TextScrollMoveBottom,
};

@interface TextScrollBarView : UIView

/**
 *  请用该函数进行控件的初始化
 *
 *  @param frame         控件的frame
 *  @param scrollModel   字符串的滚动模式
 *  @param moveDirection 滚动方向
 *
 *  @return 控件实例
 */
- (id)initWithFrame:(CGRect)frame textScrollModel:(TextScrollMode)scrollModel direction:(TextScrollMoveDirection)moveDirection;



/**
 *  更改滚动的字符串
 *
 *  @param text  字符串内容
 *  @param color 字符串颜色
 *  @param font  字符串字体
 */
- (void)scrollWithText:(NSString * )text textColor:(UIColor *)color font:(UIFont *)font;


/**
 *  设置字符串移动的速度
 *
 *  @param speed         移动速度 取值越小速度越快 取值范围：0.001~0.1
 */
- (void)setMoveSpeed:(CGFloat)speed;

/**
 *  开始动画
 */
- (void)startScroll;

/**
 *  结束动画
 */
- (void)endScroll;

@end
