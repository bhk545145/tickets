//
//  numberCell.h
//  caipiaotest
//
//  Created by yuanda on 13-4-1.
//  Copyright (c) 2013年 wangjunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol numberCellDelegate <NSObject>
//让当前tableview不能滑动
- (void)tableViewScrll:(BOOL)stop;

//每次选择数字时计算注数和钱
- (void)getTotalNotsAndMoney;
@end

@interface numberCell : UITableViewCell
@property (nonatomic, assign) NSInteger indexint;
@property (nonatomic) NSMutableArray  *selectNumberArray;
@property (nonatomic, assign) id<numberCellDelegate>  delegate;

//清空cell中选中的所有数据
- (void)refreshDataWith:(NSString *)slecteStr;

@end





