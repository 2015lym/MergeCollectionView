//
//  AppModel.h
//  UICollectionView拖动排序
//
//  Created by Lym on 2017/4/13.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol AppFolderListData <NSObject>

@end

@interface AppFolderListData : NSObject

@property (nonatomic, copy) NSString *webPath;
@property (nonatomic, copy) NSString *local;
@property (nonatomic, copy) NSString *otherParam;
@property (nonatomic, copy) NSString *processName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *defaultTab;

@end


@protocol AppFolderList <NSObject>

@end

@interface AppFolderList : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *systemId;
@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSString *bussinessId;
@property (nonatomic, copy) NSString *defaultTab;

@property (nonatomic, strong) NSArray<AppFolderListData> *data;

@end


@protocol AppList <NSObject>

@end

@interface AppList : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *systemId;
@property (nonatomic, copy) NSString *processName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *canRemove;
@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, copy) NSString *appType;
@property (nonatomic, strong) NSArray<AppFolderList> *rows;

@end

@interface AppModel : NSObject

@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSArray<AppList> *rows;

@end

