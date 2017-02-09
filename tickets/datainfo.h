//
//  datainfo.h
//  tickets
//
//  Created by 白洪坤 on 2017/2/7.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface datainfo : NSObject

@property (nonatomic, strong) NSString *expect;
@property (nonatomic, strong) NSString *opencode;
@property (nonatomic, strong) NSString *opentime;
- (id)initWithdata:(NSArray *)data rows:(int)rows;
+ (id)DeviceinfoWithDict:(NSArray *)data rows:(int)rows;
@end
