//
//  YBScrollTextViewDelegateVC.m
//  YBScrollTextView_Example
//
//  Created by yyb on 2020/4/17.
//  Copyright © 2020 yangyibo93@gmail.com. All rights reserved.
//

#import "YBScrollTextViewDelegateVC.h"
#import <YBScrollTextView.h>
#import "CustomCell.h"

@interface YBScrollTextViewDelegateVC ()<YBScrollTextViewDelegate>

@end

@implementation YBScrollTextViewDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSMutableArray *dataSource = [NSMutableArray array];
    
    CustomModel *model1 = [CustomModel new];
    model1.text = @"滚动文字滚动文字滚动文字滚动文字1";
    model1.image = [UIImage imageNamed:@"icon"];
    [dataSource addObject:model1];
    
    CustomModel *model2 = [CustomModel new];
    model2.text = @"滚动文字2";
    model2.image = [UIImage imageNamed:@"icon"];
    [dataSource addObject:model2];
    
    CustomModel *model3 = [CustomModel new];
    model3.text = @"滚动文字滚动文字3";
    model3.image = [UIImage imageNamed:@"icon"];
    [dataSource addObject:model3];
    
    CustomModel *model4 = [CustomModel new];
    model4.text = @"滚动文字滚动文字滚动文字滚动文字滚动文字滚动文字滚动文字4";
    model4.image = [UIImage imageNamed:@"icon"];
    [dataSource addObject:model4];
    
    YBScrollTextView *aView1 = [YBScrollTextView new];
    aView1.frame = CGRectMake(15, 120, self.view.frame.size.width - 30, 30);
    aView1.backgroundColor = UIColor.redColor;
    aView1.dataSource = dataSource;
    aView1.scrollDirection = YBScrollDirectionTop;
    aView1.edgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    aView1.layer.cornerRadius = 5;
    aView1.tag = 10001;
    aView1.delegate = self;
    [aView1 registerClass:[CustomCell class] reuseIdentifier:@"cell"];
    [aView1 starScrollText];
    [self.view addSubview:aView1];
    
    YBScrollTextView *aView2 = [YBScrollTextView new];
    aView2.frame = CGRectMake(15, CGRectGetMaxY(aView1.frame) + 40, self.view.frame.size.width - 30, 30);
    aView2.backgroundColor = UIColor.redColor;
    aView2.dataSource = dataSource;
    aView2.scrollDirection = YBScrollDirectionBottom;
    aView2.edgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    aView2.layer.cornerRadius = 5;
    aView2.tag = 10002;
    aView2.delegate = self;
    [aView2 registerClass:[CustomCell class] reuseIdentifier:@"cell"];
    [aView2 starScrollText];
    [self.view addSubview:aView2];
    
    YBScrollTextView *aView3 = [YBScrollTextView new];
    aView3.frame = CGRectMake(15, CGRectGetMaxY(aView2.frame) + 40, self.view.frame.size.width - 30, 30);
    aView3.backgroundColor = UIColor.redColor;
    aView3.dataSource = dataSource;
    aView3.scrollDirection = YBScrollDirectionLeft;
    aView3.edgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    aView3.layer.cornerRadius = 5;
    aView3.tag = 10003;
    aView3.delegate = self;
    [aView3 registerClass:[CustomCell class] reuseIdentifier:@"cell"];
    [aView3 starScrollText];
    [self.view addSubview:aView3];
    
    YBScrollTextView *aView4 = [YBScrollTextView new];
    aView4.frame = CGRectMake(15, CGRectGetMaxY(aView3.frame) + 40, self.view.frame.size.width - 30, 30);
    aView4.backgroundColor = UIColor.redColor;
    aView4.dataSource = dataSource;
    aView4.scrollDirection = YBScrollDirectionRight;
    aView4.edgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    aView4.layer.cornerRadius = 5;
    aView4.tag = 10004;
    aView4.delegate = self;
    [aView4 registerClass:[CustomCell class] reuseIdentifier:@"cell"];
    [aView4 starScrollText];
    [self.view addSubview:aView4];
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(aView4.frame) + 50, self.view.bounds.size.width - 30, 20)];
    [slider addTarget:self action:@selector(onSlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}

- (UICollectionViewCell *)scrollTextView:(YBScrollTextView *)scrollTextView itemWithModel:(__kindof YBScrollTextModel *)model index:(NSInteger)index {
    CustomCell *cell = [scrollTextView dequeueReusableItemWithReuseIdentifier:@"cell" forIndex:index];
    cell.model = (CustomModel *)model;
    [cell setClickedCallBack:^{
        NSLog(@"当前点击的文字: %@", model.text);
    }];
    return cell;
}

- (CGFloat)scrollTextView:(YBScrollTextView *)scrollTextView itemWithModel:(__kindof YBScrollTextModel *)model widthForItemAtIndex:(NSInteger)index {
    return model.text_w + 42;
}



- (void)onSlider:(UISlider *)slider {
    CGFloat speed = slider.value / 100.0;
    YBScrollTextView *aView1 = [self.view viewWithTag:10001];
    YBScrollTextView *aView2 = [self.view viewWithTag:10002];
    YBScrollTextView *aView3 = [self.view viewWithTag:10003];
    YBScrollTextView *aView4 = [self.view viewWithTag:10004];
    YBScrollTextView *aView5 = [self.view viewWithTag:10005];
    aView1.speed_v = aView2.speed_v = slider.value * 3.0;
    aView3.speed_h = aView4.speed_h = aView5.speed_h = speed;
}


@end
