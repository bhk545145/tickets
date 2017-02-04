//
//  ticketsinfo.h
//  tickets
//
//  Created by 白洪坤 on 2017/2/3.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ticketsinfo : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) int rows;

@property (nonatomic, strong) NSString *expect;
@property (nonatomic, strong) NSString *opencode;
@property (nonatomic, strong) NSString *opentime;

- (id)initWithDict:(NSDictionary *)dict;
- (id)initWithdata:(NSArray *)data rows:(int)rows;
@end
