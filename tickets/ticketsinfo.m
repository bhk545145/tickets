//
//  ticketsinfo.m
//  tickets
//
//  Created by 白洪坤 on 2017/2/3.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import "ticketsinfo.h"

@implementation ticketsinfo

- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _rows = [dict[@"rows"] intValue];
        for (int i = 0; i < _rows; i++) {
            _datainfo = [datainfo DeviceinfoWithDict:dict[@"data"] rows:i];
            _dataarray = [[NSMutableArray alloc]initWithCapacity:0];
            [_dataarray addObject:_datainfo];
        }
        
    }
    return self;
}


@end
