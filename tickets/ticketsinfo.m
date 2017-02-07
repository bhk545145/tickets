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
        _data = dict[@"data"];
        _rows = [dict[@"rows"] intValue];

    }
    return self;
}


@end
