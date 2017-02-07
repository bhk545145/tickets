//
//  PLFiveViewController.m
//  cn.com.broadlink.CP
//
//  Created by 白洪坤 on 2017/1/24.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import "PLFiveViewController.h"
#import "kaijiangModel.h"

@interface PLFiveViewController (){
    NSMutableArray      *_kaijiangArray;        //前5期开奖信息保存在此数组中
    BOOL                _open_lotteryView;      //是否打开中奖详情
}

@end

@implementation PLFiveViewController

#pragma mark --  读取开奖数据
- (void)readKaiJiangData
{
    _kaijiangArray = [[NSMutableArray alloc] initWithCapacity:0];
    kaijiangModel *kaijiangQiHao = [[kaijiangModel alloc]init];
    kaijiangQiHao.lotteryNum = @"073";
    kaijiangQiHao.lotteryDay = @"556";
    [_kaijiangArray addObject:kaijiangQiHao];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //读取中奖信息
    [self readKaiJiangData];
    _open_lotteryView = NO;
    self.navigationItem.title = self.name;
}


- (IBAction)pressedLotteryButton:(id)sender {
    if (!_open_lotteryView) {
        [_arrorimagebtn setImage:[UIImage imageNamed:@"redUpArrow.png"] forState:UIControlStateNormal];
        //下移动画
        
        _open_lotteryView = YES;
    }else{
        [_arrorimagebtn setImage:[UIImage imageNamed:@"RedDownArrow.png"] forState:UIControlStateNormal];
        //上拉动画
        
        _open_lotteryView = NO;
    }
}

#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        return 6;
    }
    else if(tableView.tag == 3)
    {
        return 5;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 3) {
        return 24;
    }else
    {
        if (indexPath.row == 0) {
            return 25;
        }
        else
        {
            return 90;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"kaijiangcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UILabel *kaijianglab = (UILabel *)[cell viewWithTag:101];
    kaijiangModel *kaijiangQiHao = [_kaijiangArray objectAtIndex:0];
    kaijianglab.text = [NSString stringWithFormat:@"%@期%@",kaijiangQiHao.lotteryNum,kaijiangQiHao.lotteryDay];
    return cell;
}

@end
