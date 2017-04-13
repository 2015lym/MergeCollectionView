//
//  TestJson.m
//  UICollectionView拖动排序
//
//  Created by Lym on 2017/4/13.
//  Copyright © 2017年 Lym. All rights reserved.
//

#import "TestJson.h"

@implementation TestJson

- (NSDictionary *)dic {
    return @{@"total": @"4",
             @"rows": @[
                      @{
                          @"appid": @"1",
                          @"total": @"1",
                          @"systemId": @"bpm",
                          @"processName": @"qingjiaProcessName",
                          @"title": @"请假审批",
                          @"canRemove": @"false",
                          @"icon": @"http://himg.bdimg.com/sys/portrait/item/68ca4804.jpg?t=1470800293"
                      },
                      @{
                          @"appid": @"0001126d-f9ca-44c4-926d-096d471165ad",
                          @"appType": @"folder",
                          @"total": @"10",
                          @"title": @"快捷方式",
                          @"rows": @[
                                   @{
                                       @"appid": @"3",
                                       @"total": @"0",
                                       @"title": @"其它查询",
                                       @"style": @"",
                                       @"icon": @"http: //himg.bdimg.com/sys/portrait/item/68ca4804.jpg?t=1470800293",
                                       @"systemId": @"query",
                                       @"serviceName": @"otherQueryService"
                                   },
                                   @{
                                       @"appid": @"7",
                                       @"title": @"请假申请",
                                       @"systemId": @"queryDetail",
                                       @"icon": @"http: //himg.bdimg.com/sys/portrait/item/68ca4804.jpg?t=1470800293",
                                       @"style": @"tododetail_style",
                                       @"bussinessId": @"",
                                       @"defaultTab": @"",
                                       @"serviceName": @"",
                                       @"data": @{
                                           @"webPath": @"/demo/leaveApplyForm",
                                           @"otherParam": @"这里是其它Data中的其它参数",
                                           @"processName": @"ssssssssssssss"
                                       }
                                   },
                                   ]
                      }
                      ]
             };
}

@end
