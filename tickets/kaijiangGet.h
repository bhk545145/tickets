//
//  kaijiangGet.h
//  tickets
//
//  Created by 白洪坤 on 2017/2/7.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface kaijiangGet : NSObject
- (void)apiplus:(NSString *)URLString completionHandler:(void (^)(NSDictionary *dic))completionHandler;
@end
