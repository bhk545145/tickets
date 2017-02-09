//
//  ticketsinfo.h
//  tickets
//
//  Created by 白洪坤 on 2017/2/3.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "datainfo.h"

@interface ticketsinfo : NSObject

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSString *code;
@property (nonatomic, assign) NSString *png;
@property (nonatomic, strong) datainfo *datainfo;
@property (nonatomic, strong) NSMutableArray *dataarray;
@property (nonatomic, assign) int rows;



- (id)initWithDict:(NSDictionary *)dict;

@end
