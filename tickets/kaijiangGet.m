//
//  kaijiangGet.m
//  tickets
//
//  Created by 白洪坤 on 2017/2/7.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import "kaijiangGet.h"
#import "AFNetworking.h"

@implementation kaijiangGet


//获取彩票开奖数据
- (void)apiplus:(NSString *)URLString  completionHandler:(void (^)(NSDictionary *dic))completionHandler{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        completionHandler(dic);
         NSLog(@"请求成功:%@", dic[@"code"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@", error.description);
    }];
    
}
@end
