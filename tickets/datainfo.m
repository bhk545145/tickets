//
//  datainfo.m
//  tickets
//
//  Created by 白洪坤 on 2017/2/7.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import "datainfo.h"

@implementation datainfo

- (id)initWithdata:(NSArray *)data rows:(int)rows{
    if (self = [super init]) {
        _expect = data[rows][@"expect"];
        _opencode = data[rows][@"opencode"];
        _opentime = data[rows][@"opentime"];
    }
    return self;
}

+ (id)DeviceinfoWithDict:(NSArray *)data rows:(int)rows{
    return [[self alloc] initWithdata:data rows:rows];
}
@end
