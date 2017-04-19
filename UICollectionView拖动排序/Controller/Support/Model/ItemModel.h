//
//  ItemModel.h
//  UICollectionView拖动排序
//
//  Created by apple on 2017/4/18.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol ItemModel;
@interface ItemModel : NSObject
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)UIImage *image;
@end
@interface YMModel : NSObject
@property (nonatomic, strong)NSArray<ItemModel> *rows;
@end
