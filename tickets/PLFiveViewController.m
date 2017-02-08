//
//  PLFiveViewController.m
//  cn.com.broadlink.CP
//
//  Created by 白洪坤 on 2017/1/24.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import "PLFiveViewController.h"
#import "kaijiangGet.h"
#import "bhkCommon.h"
#import "ticketsinfo.h"
#import "datainfo.h"
#import "numberCell.h"

@interface PLFiveViewController ()<numberCellDelegate>{
    NSMutableArray      *_kaijiangArray;        //前5期开奖信息保存在此数组中
    BOOL                _open_lotteryView;      //是否打开中奖详情
    int                 _rows;
    BOOL                _refreshData;           //是否刷新数据
    NSMutableArray      *_shakeNumber;          //摇一摇机选数
    NSMutableArray      *_makeSureSelectNumArray;//确定选好的号码
    UILabel             *_numberNots;           //共几注
    UILabel             *_totalMoney;           //共多少钱
}

@end

@implementation PLFiveViewController

#pragma mark --  读取开奖数据
- (void)readKaiJiangData
{
    NSString *string = [NSString stringWithFormat:@"/%@.json",self.code];
    NSString *URLString = [baseUrl stringByAppendingString:string];
    kaijiangGet *kaijiangget = [[kaijiangGet alloc]init];
    [kaijiangget apiplus:URLString completionHandler:^(NSDictionary *dic) {
        ticketsinfo *info = [[ticketsinfo alloc]init];
        info = [info initWithDict:dic];
        _rows = info.rows;
        _kaijiangArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0;i < info.rows;i++) {
            datainfo *Datainfo = [[datainfo alloc]init];
            Datainfo = [Datainfo initWithdata:info.data rows:i];
            [_kaijiangArray addObject:Datainfo];
        }
        [self.ticketsTableview reloadData];
    }];
    
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
        [UIView beginAnimations:nil context:NULL];
        _openLotteryView.frame = CGRectMake(0, 65, 375, 120);
        _PLFiveTableView.frame = CGRectMake(0, 80+100, 375, 529);;
        [UIView commitAnimations];
        _open_lotteryView = YES;
    }else{
        [_arrorimagebtn setImage:[UIImage imageNamed:@"RedDownArrow.png"] forState:UIControlStateNormal];
        //上拉动画
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        _openLotteryView.frame = CGRectMake(0, -35, 375, 120);
        _PLFiveTableView.frame = CGRectMake(0, 80, 375, 529);
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
        return _rows;
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
            return 100;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case (2):
        {
            if (indexPath.row == 0) {
                NSString *CellIdentifier = @"firstCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                return cell;
            }else
            {
                NSString *CellId = @"otherCell";
                numberCell* cell= [tableView dequeueReusableCellWithIdentifier:CellId];
                if (cell == nil) {
                    cell = [[numberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
                }
                cell.indexint = indexPath.row;
                               
                if (_refreshData) {
                    //清空所有cell上数据
                    [cell refreshDataWith:@"清空数据"];
                    if ([_shakeNumber count] != 0)
                    {
                        //摇手机出现的随机数
                        NSString *selectNum =[_shakeNumber objectAtIndex:indexPath.row - 1];
                        NSLog(@"****************::%@",selectNum);
                        [cell refreshDataWith:selectNum];
                    }
                    
                    if (indexPath.row == 5) {
                        _refreshData = NO;
                    }
                }
                [_makeSureSelectNumArray addObject:cell.selectNumberArray];
                cell.delegate = self;
                return cell;
            }
            
        }
            break;
        case (3):
        {
            NSString *CellIdentifier = @"kaijiangcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            UILabel *kaijianglab = (UILabel *)[cell viewWithTag:101];
            datainfo *info = [_kaijiangArray objectAtIndex:indexPath.row];
            kaijianglab.text = [NSString stringWithFormat:@"第%@期%@",info.expect,info.opencode];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;

    
    
    
}

#pragma mark --
#pragma mark -- NumberCellDelegate
//当前界面在选号时不可滑动，cell来控制
- (void)tableViewScrll:(BOOL)stop
{
    if (stop) {
        _PLFiveTableView.scrollEnabled = YES;
        NSLog(@"*****可滚动*****");
        
    }else
    {
        _PLFiveTableView.scrollEnabled = NO;
        NSLog(@"*****不可滚动*****");
        
    }
    
}

//选中或取消号码后产生的注数和钱数

- (void)getTotalNotsAndMoney
{
    NSInteger totalNumber = 1;
    [_PLFiveTableView reloadData];
    NSLog(@"数组%lu",(unsigned long)[_makeSureSelectNumArray count]);
    for (NSInteger i = 0; i<5; i++) {
        NSMutableArray *tmpArray = [_makeSureSelectNumArray objectAtIndex:i];
        
        totalNumber *= [tmpArray count];
    }
    _numberNots.text = [NSString stringWithFormat:@"共%ld注",(long)totalNumber];
    _totalMoney.text = [NSString stringWithFormat:@"%ld元",totalNumber*2];
    NSLog(@"%ld",(long)totalNumber);
}
@end
