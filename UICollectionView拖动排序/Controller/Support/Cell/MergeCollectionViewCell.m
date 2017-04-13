//
//  MergeCollectionViewCell.m
//  UICollectionView拖动排序
//
//  Created by Lym on 2017/3/31.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "MergeCollectionViewCell.h"

@implementation MergeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.badge.layer.cornerRadius = self.badge.frame.size.width / 2;
}

@end
