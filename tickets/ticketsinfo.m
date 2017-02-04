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

- (id)initWithdata:(NSArray *)data rows:(int)rows{
    if (self = [super init]) {
        rows = rows - 1;
        _expect = _data[rows][@"expect"];
        _opencode = _data[rows][@"opencode"];
        _opentime = _data[rows][@"opentime"];
    }
    return self;
}
@end
