//
//  CustomCell.h
//  YBScrollTextView_Example
//
//  Created by yyb on 2020/4/17.
//  Copyright © 2020 yangyibo93@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YBScrollTextView.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomModel : YBScrollTextModel

@property (nonatomic, strong) UIImage *image;

@end

@interface CustomCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic, strong) CustomModel *model;

@property (nonatomic, copy) void(^clickedCallBack)(void);

@end

NS_ASSUME_NONNULL_END
