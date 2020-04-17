//
//  YBScrollTextView.m
//  YBScrollTextView_Example
//
//  Created by yyb on 2020/4/16.
//  Copyright © 2020 yangyibo93@gmail.com. All rights reserved.
//

#import "YBScrollTextView.h"

#define CellReuseIdentifier @"YB_CellReuseIdentifier"

@interface YBScrollTextModel ()

@end

@implementation YBScrollTextModel

- (void)setText:(NSString *)text {
    _text = text;
    self.text_w = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width;
}

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont systemFontOfSize:15];
    }
    return _font;
}

@end

@interface YBScrollTextCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, copy) void(^clickedCallBack)(YBScrollTextModel * _Nonnull model);

@property (nonatomic, strong) YBScrollTextModel *model;

@end

@implementation YBScrollTextCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textColor = UIColor.blackColor;
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:self.textLabel];
        
        self.textLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClicked)];
        [self.textLabel addGestureRecognizer:tap];
    }
    return self;
}

- (void)onClicked {
    if (self.clickedCallBack) {
        self.clickedCallBack(self.model);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, 0, self.model.text_w, self.bounds.size.height);
}

- (void)setModel:(YBScrollTextModel *)model {
    _model = model;
    self.textLabel.text = model.text;
    self.textLabel.font = model.font;
    self.textLabel.textColor = model.textColor;
    [self setNeedsLayout];
}

@end

@interface YBScrollTextView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YBScrollTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        [self initialize];
    }
    return self;
}

- (void)setupSubViews {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[YBScrollTextCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}

- (void)initialize {
    _speed_h = 0.05;
    _speed_v = 3.0;
    _scrollDirection = YBScrollDirectionTop;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, self.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right, self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom);
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)registerClass:(nullable Class)aClass reuseIdentifier:(nonnull NSString *)identifier {
    [self.collectionView registerClass:aClass forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableItemWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollTextView:itemWithModel:index:)]) {
        return [_delegate scrollTextView:self itemWithModel:self.dataSource[indexPath.row] index:indexPath.row];
    }
    YBScrollTextCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [cell setClickedCallBack:^(YBScrollTextModel * _Nonnull model){
        if (weakSelf.clickedItemCallBack) {
            weakSelf.clickedItemCallBack(weakSelf, model);
        }
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (YBScrollDirectionTop == self.scrollDirection || YBScrollDirectionBottom == self.scrollDirection) {
        return self.collectionView.bounds.size;
    }
    CGFloat width = self.dataSource[indexPath.row].text_w;
    if (_delegate && [_delegate respondsToSelector:@selector(scrollTextView:itemWithModel:widthForItemAtIndex:)]) {
        width = [_delegate scrollTextView:self itemWithModel:self.dataSource[indexPath.row] widthForItemAtIndex:indexPath.row];
    }
    return CGSizeMake(width, self.collectionView.bounds.size.height);
}

- (void)setScrollDirection:(YBScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    self.flowLayout.scrollDirection = (YBScrollDirectionLeft == scrollDirection || YBScrollDirectionRight == scrollDirection) ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
}

- (void)starScrollText {
    
    if (self.dataSource == nil || self.dataSource.count == 0) {
        return;
    }
    switch (self.scrollDirection) {
        case YBScrollDirectionTop: {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.speed_v target:self selector:@selector(scrollTextForTop) userInfo:nil repeats:YES];
        }
            break;
        case YBScrollDirectionBottom: {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.speed_v target:self selector:@selector(scrollTextForBottom) userInfo:nil repeats:YES];
        }
            break;
        case YBScrollDirectionLeft: {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.speed_h target:self selector:@selector(scrollTextForLeft) userInfo:nil repeats:YES];
        }
            break;
        case YBScrollDirectionRight: {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.speed_h target:self selector:@selector(scrollTextForRight) userInfo:nil repeats:YES];
        }
            break;
        default:
            break;
    }
    if (self.timer) { return; }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)scrollTextForTop {
    CGFloat offset = self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    if (self.collectionView.contentOffset.y + offset >= self.collectionView.contentSize.height) {
        [self.collectionView setContentOffset:CGPointZero animated:NO];
    }
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + offset) animated:YES];
}

- (void)scrollTextForBottom {
    CGFloat offset = self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    if (self.collectionView.contentOffset.y <= 0) {
        [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height - offset) animated:NO];
    }
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y - offset) animated:YES];
}

- (void)scrollTextForLeft {
    UICollectionViewCell *cell = self.collectionView.visibleCells.firstObject;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (self.dataSource.count / 2 == indexPath.row && cell.frame.origin.x - self.collectionView.contentOffset.x <= 0) {
        [self.collectionView setContentOffset:CGPointZero animated:NO];
    } else {
        CGPoint point = CGPointMake(self.collectionView.contentOffset.x + 0.5, 0);
        [self.collectionView setContentOffset:point animated:NO];
    }
}

- (void)scrollTextForRight {
    UICollectionViewCell *cell = self.collectionView.visibleCells.firstObject;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (0 == indexPath.row && self.collectionView.contentOffset.x <= 0) {
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentSize.width / 2.0 + self.margin / 2.0, 0) animated:NO];
    } else {
        CGPoint point = CGPointMake(self.collectionView.contentOffset.x - 0.5, 0);
        [self.collectionView setContentOffset:point animated:NO];
    }
}

- (void)setDataSource:(NSArray<__kindof YBScrollTextModel *> *)dataSource {
    if (nil == dataSource || 0 == dataSource.count) {
        return;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:dataSource];
    [array addObjectsFromArray:dataSource];
    _dataSource = array;
    [self.collectionView reloadData];
}

- (void)setMargin:(CGFloat)margin {
    _margin = margin;
    self.flowLayout.minimumInteritemSpacing = margin;
    [self.collectionView reloadData];
}

- (void)setSpeed_h:(CGFloat)speed_h {
    _speed_h = speed_h;
    [self.timer invalidate];
    self.timer = nil;
    [self starScrollText];
}

- (void)setSpeed_v:(CGFloat)speed_v {
    _speed_v = speed_v;
    [self.timer invalidate];
    self.timer = nil;
    [self starScrollText];
}

@end
