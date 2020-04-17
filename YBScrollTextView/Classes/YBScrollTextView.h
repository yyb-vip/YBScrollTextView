//
//  YBScrollTextView.h
//  YBScrollTextView_Example
//
//  Created by yyb on 2020/4/16.
//  Copyright © 2020 yangyibo93@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YBScrollDirection) {
    YBScrollDirectionTop,       /// 自下而上
    YBScrollDirectionBottom,    /// 自上而下
    YBScrollDirectionLeft,      /// 自右至左
    YBScrollDirectionRight      /// 自左至右
};

@interface YBScrollTextModel : NSObject

@property (nonatomic, weak) id obj;

/// 文字内容
@property (nonatomic, copy) NSString *text;

/// 可针对不同的文字自定义外观
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

/// 文字宽度, 只在横向滚动时有效, 根据text和font计算出来的
/// 代理方法优先级比此参数优先级高, 如果自定义cell, 则需要自己计算cell宽度
@property (nonatomic, assign) CGFloat text_w;

@end

@class YBScrollTextView;
@protocol YBScrollTextViewDelegate <NSObject>

@optional
/// 自定义cell
- (__kindof UICollectionViewCell *)scrollTextView:(YBScrollTextView *)scrollTextView itemWithModel:(__kindof YBScrollTextModel *)model index:(NSInteger)index;

/// cell宽度:只在横向滑动时有效
- (CGFloat)scrollTextView:(YBScrollTextView *)scrollTextView itemWithModel:(__kindof YBScrollTextModel *)model widthForItemAtIndex:(NSInteger)index;

@end

@interface YBScrollTextView : UIView

/// 内边距
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/// cell间隔:只在横向滑动有效
@property (nonatomic, assign) CGFloat margin;

/// 滚动速度:只在横向滚动的时候有效
@property (nonatomic, assign) CGFloat speed_h;

/// 滚动速度:只在竖向滚动时候有效
@property (nonatomic, assign) CGFloat speed_v;

/// 滚动方向
@property (nonatomic, assign) YBScrollDirection scrollDirection;

/// 代理对象
@property (nonatomic, weak) id<YBScrollTextViewDelegate> delegate;

/// 数据源
@property (nonatomic, strong) NSArray<__kindof YBScrollTextModel *> *dataSource;

/// 点击文字回调
@property (nonatomic, copy) void(^clickedItemCallBack)(YBScrollTextView * _Nonnull scrollTextView, __kindof YBScrollTextModel * _Nonnull model);

/// 自定义cell的时候需要注册一下
- (void)registerClass:(nullable Class)aClass reuseIdentifier:(nonnull NSString *)identifier;

/// 获取重用cell
- (__kindof UICollectionViewCell *)dequeueReusableItemWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

/// 刷新数据
- (void)reloadData;

/// 开始滚动
- (void)starScrollText;

@end

NS_ASSUME_NONNULL_END
