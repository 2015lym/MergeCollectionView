//
//  SecondTestViewController.m
//  UICollectionView拖动排序
//
//  Created by apple on 2017/4/11.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "SecondTestViewController.h"
#import "ymCollectionViewCell.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define ITEM_NUMBER 50
static NSString * const kImage = @"kImage";             //logo图片
static NSString * const kTitle = @"kTitle";             //图片标题
typedef NS_ENUM(NSInteger, kMoveType){
    kMoveTypeNone,
    kMoveTypeExchange,
    kMoveTypeMerge
};
@interface SecondTestViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray<NSArray *> *containerArray;//记录包含合并的数组
@property (nonatomic, assign) kMoveType moveType;//移动方式，移动or合并

@end

@implementation SecondTestViewController
- (NSMutableArray *)containerArray{
    if (!_containerArray) {
        _containerArray = [[NSMutableArray alloc]init];
    }
    return _containerArray;
}

#pragma mark - ---------- 生命周期 ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCollectionView];
    
    _moveType = kMoveTypeNone;
    
    _dataArray = [NSMutableArray array];
    //添加数据源
    for (int i = 1; i <= ITEM_NUMBER; i++) {
        NSString *str = [NSString stringWithFormat:@"%d", i];
        UIImage *image = [UIImage imageNamed:@"proper_logo"];
        NSDictionary *dic = @{kImage:image,kTitle:str};
        [_dataArray addObject:dic];
        [self.containerArray addObject:@[dic]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------- 创建collectionView ----------
- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREENWIDTH-15) / 4, (SCREENWIDTH-15) / 4);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT - 20) collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ymCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ymCollectionViewCell"];
    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    longGesture.minimumPressDuration = 0.5f;//触发长按事件时间为：秒
    [_collectionView addGestureRecognizer:longGesture];
    [self.view addSubview:self.collectionView];
}

#pragma mark - ---------- Collection的数量 ----------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

#pragma mark - ---------- Cell的内容 ----------
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ymCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ymCollectionViewCell" forIndexPath:indexPath];
    cell.contentLabel.text = [NSString stringWithFormat:@"请假审批%@", _dataArray[indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:@"proper_logo"];
    return cell;
}

#pragma mark - ---------- 监听手势 ----------
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    [self action:longGesture];
}

#pragma mark - ---------- 允许拖动 ----------
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - ---------- 更新数据源 ----------
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //移除数据插入到新的位置
    id obj = [_dataArray objectAtIndex:sourceIndexPath.row];
    [_dataArray removeObject:[_dataArray objectAtIndex:sourceIndexPath.row]];
    [_dataArray insertObject:obj
                     atIndex:destinationIndexPath.row];
}

#pragma mark - ---------- 拖动手势 ----------
- (void)action:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{//手势开始
            //判断手势落点位置是否在Item上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            [self.collectionView bringSubviewToFront:cell];
            //在Item上则开始移动该Item的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:{//手势改变
            //移动过程当中随时更新cell位置
//            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:{//手势结束
            //移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
            CGPoint currentPoint = [longGesture locationInView:self.collectionView];
            for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
            //计算中心距
            CGFloat space = sqrtf(pow(currentPoint.x - cell.center.x, 2) + powf(currentPoint.y - cell.center.y, 2));
            NSLog(@"%f",space);
            //如果相交一半就移动
            if(space <= cell.bounds.size.width*3 / 4){
                //移动 会调用willMoveToIndexPath方法更新数据源
                _moveType = kMoveTypeExchange;
            }
            }
        }
            break;
        default://手势其他状态
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

#pragma mark - ---------- 允许长按 ----------
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - ---------- didHighlight ----------
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [collectionView bringSubviewToFront:selectedCell];
    [UIView animateWithDuration:0.28 animations:^{
        selectedCell.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    }];
}

#pragma mark - ---------- didUnhighlight ----------
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.28 animations:^{
        selectedCell.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }];
}

@end
