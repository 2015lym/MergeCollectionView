//
//  MergeDetailView.h
//  UICollectionView拖动排序
//
//  Created by Lym on 2017/4/11.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MergeDetailView : UIView

@property (weak, nonatomic) IBOutlet UITextField *folderTitleTextField;

@property (nonatomic, strong) NSMutableArray *dataArray;    //数据源数组
//修改标题
@property (nonatomic, copy) void(^folderTitle)(NSString *title);
//移除App
@property (nonatomic, copy) void(^removeApp)(AppList *item);

@property (nonatomic, copy) void (^close)(void);

- (void)openCell:(CGRect )cellFrame;

@end
