//
//  MergeDetailView.m
//  UICollectionView拖动排序
//
//  Created by Lym on 2017/4/11.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "MergeDetailView.h"
#import "MergeCollectionViewCell.h"
#import "Config.h"

static NSString * const kImage = @"kImage";             //logo图片
static NSString * const kTitle = @"kTitle";             //图片标题

@interface MergeDetailView ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, assign) CGRect transformRect;
@end

@implementation MergeDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _folderTitleTextField.backgroundColor = TEXTFIELD_COLOR;
    _folderTitleTextField.delegate = self;
    
    [self createCollectionView];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissContactView)];
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:_tapGesture];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat zoomValue = _transformRect.size.width/_collectionView.frame.size.width;
    _collectionView.transform = CGAffineTransformMakeScale(zoomValue, zoomValue);
    _collectionView.frame = _transformRect;
    [UIView animateWithDuration:0.25 animations:^{
        _collectionView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+25);
        _collectionView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//        [_collectionView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        //移除截图视图、显示隐藏的cell并开启交互
    }];
}

#pragma mark - ---------- 创建collectionView ----------
- (void)createCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView.collectionViewLayout = layout;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"MergeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MergeCollectionViewCell"];
    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    longGesture.minimumPressDuration = 0.5f;//触发长按事件时间为：秒
    [_collectionView addGestureRecognizer:longGesture];

}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MergeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MergeCollectionViewCell" forIndexPath:indexPath];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.item][kTitle]];
    cell.imageView.image = self.dataArray[indexPath.item][kImage];
    return cell;
}

#pragma mark - ---------- 监听手势 ----------
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    [self action:longGesture];
}

#pragma mark - ---------- 拖动手势 ----------
static UIView *snapedView;              //截图快照
static NSIndexPath *currentIndexPath;   //当前路径
static NSIndexPath *oldIndexPath;       //旧路径
static NSIndexPath *startIndexPath;   //起始路径
- (void)action:(UILongPressGestureRecognizer *)longGesture{
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{//手势开始
            //判断手势落点位置是否在Item上
            oldIndexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            startIndexPath = oldIndexPath;
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
        }
            break;
        default:{//手势结束和其他状态
            CGPoint currentPoint = [longGesture locationInView:self.collectionView];
            snapedView.center = CGPointMake(currentPoint.x, currentPoint.y);
            
            //计算截图视图和哪个cell相交
            for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
                //当前隐藏的cell就不需要交换了，直接continue
                if ([self.collectionView indexPathForCell:cell] == oldIndexPath) {
                    currentIndexPath = oldIndexPath;
                    continue;
                }else{
                //计算中心距
                CGFloat space = sqrtf(pow(snapedView.center.x - cell.center.x, 2) + powf(snapedView.center.y - cell.center.y, 2));
                NSLog(@"%f",space);
                //如果相交一半就移动
                if(space <= snapedView.bounds.size.width*1 / 2){
                    currentIndexPath = [self.collectionView indexPathForCell:cell];
                    //更改移动后的起始indexPath，用于后面获取隐藏的cell,是移动后的位置
                    [self.collectionView moveItemAtIndexPath:startIndexPath toIndexPath:currentIndexPath];
                    oldIndexPath = currentIndexPath;

                    //移除数据插入到新的位置
                    id obj = [_dataArray objectAtIndex:startIndexPath.item];
                    [_dataArray removeObject:[_dataArray objectAtIndex:startIndexPath.item]];
                    [_dataArray insertObject:obj
                                     atIndex:currentIndexPath.item];
                }
                }
            }
            
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:oldIndexPath];//原来隐藏的cell
            UICollectionViewCell *targetCell = [self.collectionView cellForItemAtIndexPath:currentIndexPath];//移动目标cell
            //结束动画过程中停止交互，防止出问题
            self.collectionView.userInteractionEnabled = NO;
            //给截图视图一个动画移动到隐藏cell的新位置
            [UIView animateWithDuration:0.25 animations:^{
                snapedView.center = targetCell.center;
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.folderTitle(textField.text);
}

- (void)dismissContactView {
    [UIView animateWithDuration:0.25 animations:^{
        _collectionView.center = CGPointMake(_transformRect.origin.x+_transformRect.size.width/2, _transformRect.origin.y+_transformRect.size.height/2);
        _collectionView.transform = CGAffineTransformMakeScale(_transformRect.size.width/self.frame.size.width, _transformRect.size.width/self.frame.size.width);
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication].keyWindow removeGestureRecognizer:_tapGesture];
        [self.superview removeFromSuperview];
        self.close();
    }];

}

- (void)openCell:(CGRect )cellFrame{
    _transformRect = CGRectMake(cellFrame.origin.x, cellFrame.origin.y+84, cellFrame.size.width, cellFrame.size.height);
//    [self setNeedsDisplay];
}

//- (UIView*)duplicate:(UIView*)view
//{
//    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
//    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
//}
@end
