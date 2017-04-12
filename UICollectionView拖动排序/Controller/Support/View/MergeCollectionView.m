//
//  MergeCollectionView.m
//  UICollectionView拖动排序
//
//  Created by Lym on 2017/4/12.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "MergeCollectionView.h"
#import "Config.h"

@implementation MergeCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH-15) / 4, (SCREEN_WIDTH-15) / 4);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    self = [super initWithFrame:frame collectionViewLayout:layout];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self registerNib:[UINib nibWithNibName:@"MergeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MergeCollectionViewCell"];
    return self;
}

@end
