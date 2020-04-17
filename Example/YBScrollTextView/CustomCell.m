//
//  CustomCell.m
//  YBScrollTextView_Example
//
//  Created by yyb on 2020/4/17.
//  Copyright © 2020 yangyibo93@gmail.com. All rights reserved.
//

#import "CustomCell.h"
@implementation CustomModel

@end

@implementation CustomCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.icon = [[UIImageView alloc] init];
        self.icon.backgroundColor = UIColor.greenColor;
        [self.contentView addSubview:self.icon];
        
        self.textLab = [[UILabel alloc] init];
        self.textLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.textLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.icon.frame = CGRectMake(10, 4, self.bounds.size.height - 8, self.bounds.size.height - 8);
    self.textLab.frame = CGRectMake(CGRectGetMaxX(self.icon.frame) + 5, 0, self.bounds.size.width - CGRectGetMaxX(self.icon.frame) - 10, self.bounds.size.height);
}

- (void)setModel:(CustomModel *)model {
    _model = model;
    self.icon.image = model.image;
    self.textLab.text = model.text;
    self.textLab.font = model.font;
    self.textLab.textColor = model.textColor;
}

- (void)tap {
    if (self.clickedCallBack) {
        self.clickedCallBack();
    }
}

@end
