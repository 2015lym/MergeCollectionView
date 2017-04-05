//
//  MergeViewController.m
//  UICollectionView拖动排序
//
//  Created by Lym on 2017/4/5.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "MergeViewController.h"
#import "ymCollectionViewCell.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define ITEM_NUMBER 50


@interface MergeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView * collectionView;
@end

@implementation MergeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectionView];
    
    _dataArray = [NSMutableArray array];
    
    //产生随机颜色的方块
    for (int i = 1; i <= ITEM_NUMBER; i++) {
        NSString *str = [NSString stringWithFormat:@"%d", i];
        [_dataArray addObject:str];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------- 创建collectionView ----------
- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREENWIDTH / 4, SCREENWIDTH / 4);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
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

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ymCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ymCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - ---------- 监听手势 ----------
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
        [self action:longGesture];
}

#pragma mark - ---------- 拖动手势 ----------
static UIView *snapedView;              //截图快照
static NSIndexPath *currentIndexPath;   //当前路径
static NSIndexPath *oldIndexPath;       //旧路径
- (void)action:(UILongPressGestureRecognizer *)longGesture{
    
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{//手势开始
            //判断手势落点位置是否在Item上
            oldIndexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (oldIndexPath == nil) {
                break;
            }
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:oldIndexPath];
            //使用系统截图功能，得到cell的截图视图
            snapedView = [cell snapshotViewAfterScreenUpdates:NO];
            snapedView.frame = cell.frame;
            [self.collectionView addSubview:snapedView];
            //截图后隐藏当前cell
            cell.hidden = YES;
            CGPoint currentPoint = [longGesture locationInView:self.collectionView];
            [UIView animateWithDuration:0.25 animations:^{
                snapedView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                snapedView.center = CGPointMake(currentPoint.x, currentPoint.y);
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:{//手势改变
            //当前手指位置 - 截图视图位置移动
            CGPoint currentPoint = [longGesture locationInView:self.collectionView];
            snapedView.center = CGPointMake(currentPoint.x, currentPoint.y);
            
            //计算截图视图和哪个cell相交
            for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
                //当前隐藏的cell就不需要交换了，直接continue
                if ([self.collectionView indexPathForCell:cell] == oldIndexPath) {
                    continue;
                }
                //计算中心距
                CGFloat space = sqrtf(pow(snapedView.center.x - cell.center.x, 2) + powf(snapedView.center.y - cell.center.y, 2));
                //如果相交一半就移动
                if (space <= snapedView.bounds.size.width / 2) {
                    currentIndexPath = [self.collectionView indexPathForCell:cell];
                    //移动 会调用willMoveToIndexPath方法更新数据源
                    [self.collectionView moveItemAtIndexPath:oldIndexPath toIndexPath:currentIndexPath];
                    
                    
                    //移除数据插入到新的位置
                    id obj = [_dataArray objectAtIndex:oldIndexPath.row];
                    [_dataArray removeObject:[_dataArray objectAtIndex:oldIndexPath.row]];
                    [_dataArray insertObject:obj
                                     atIndex:currentIndexPath.row];
                    
                    
                    //设置移动后的起始indexPath
                    oldIndexPath = currentIndexPath;
                    break;
                }
            }
        }
            break;
        default:{//手势结束和其他状态
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:oldIndexPath];
            //结束动画过程中停止交互，防止出问题
            self.collectionView.userInteractionEnabled = NO;
            //给截图视图一个动画移动到隐藏cell的新位置
            [UIView animateWithDuration:0.25 animations:^{
                snapedView.center = cell.center;
                snapedView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                //移除截图视图、显示隐藏的cell并开启交互
                [snapedView removeFromSuperview];
                cell.hidden = NO;
                self.collectionView.userInteractionEnabled = YES;
                [self.collectionView reloadData];
            }];
        }
            break;
    }
}


@end
