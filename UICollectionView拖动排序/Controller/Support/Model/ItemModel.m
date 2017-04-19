//
//  ItemModel.m
//  UICollectionView拖动排序
//
//  Created by apple on 2017/4/18.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"未声明的属性%@",key);
}
@end
@implementation YMModel
- (instancetype)init{
    self = [super init];
    if (self) {
//        self.rows = [NSMutableArray array];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"未声明的属性%@",key);
}

@end
