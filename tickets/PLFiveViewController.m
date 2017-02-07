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
#import "shakedViewCell.h"

@interface PLFiveViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray      *_kaijiangArray;        //前5期开奖信息保存在此数组中
    BOOL                _open_lotteryView;      //是否打开中奖详情
    int                 _rows;
    UITableView         *_PLFiveTableView;      //直选tableview
    BOOL                _refreshData;           //是否刷新数据
    NSMutableArray      *_shakeNumber;          //摇一摇机选数
    NSMutableArray      *_makeSureSelectNumArray;//确定选好的号码
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
    [self addTableview];
}


- (IBAction)pressedLotteryButton:(id)sender {
    if (!_open_lotteryView) {
        [_arrorimagebtn setImage:[UIImage imageNamed:@"redUpArrow.png"] forState:UIControlStateNormal];
        //下移动画
        [UIView beginAnimations:nil context:NULL];
        _openLotteryView.frame = CGRectMake(0, 65, 375, 120);
        _PLFiveTableView.frame = CGRectMake(0, 80+100, 375, 434);;
        [UIView commitAnimations];
        _open_lotteryView = YES;
    }else{
        [_arrorimagebtn setImage:[UIImage imageNamed:@"RedDownArrow.png"] forState:UIControlStateNormal];
        //上拉动画
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        _openLotteryView.frame = CGRectMake(0, -35, 375, 120);
        _PLFiveTableView.frame = CGRectMake(0, 80, 375, 434);
        _open_lotteryView = NO;
    }
}

#pragma mark -- 添加选号cell

- (void)addTableview
{
    CGRect rect ;
    rect = CGRectMake(0, 80, 375, 433);
    _PLFiveTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _PLFiveTableView.tag = 2;
    _PLFiveTableView.alpha = 1;
    // _PLFiveTableView.contentSize = CGSizeMake(320, 25+90*5);
    _PLFiveTableView.dataSource = self;
    _PLFiveTableView.delegate = self;
    _PLFiveTableView.userInteractionEnabled = YES;
    _PLFiveTableView.bounces = YES;
    _PLFiveTableView.scrollEnabled = YES;
    _PLFiveTableView.showsHorizontalScrollIndicator = NO;
    _PLFiveTableView.showsVerticalScrollIndicator = NO;
    _PLFiveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
    //设置背景
    //_PLFiveTableView.backgroundColor = [UIColor clearColor];
    UIView *bgview = [[UIView alloc] init];
    bgview.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:238.0/255.0 alpha:1];
    _PLFiveTableView.backgroundView = bgview;

    [self.view addSubview:_PLFiveTableView];

    
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
            return 90;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case (2):
        {
            if (indexPath.row == 0) {
                NSString *CellId = @"firstCell";
                shakedViewCell *cell = [[shakedViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:CellId withTitle:@"每位至少选择一个数字"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else
            {
                NSString *CellId = @"otherCell";
                numberCell* cell= [tableView dequeueReusableCellWithIdentifier:CellId];
                if (cell == nil) {
                    cell = [[numberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                switch (indexPath.row) {
//                    case 1:
//                        cell.zhiXuanLabel.text = @"万";
//                        break;
//                    case 2:
//                        cell.zhiXuanLabel.text = @"千";
//                        break;
//                    case 3:
//                        cell.zhiXuanLabel.text = @"百";
//                        break;
//                    case 4:
//                        cell.zhiXuanLabel.text = @"十";
//                        break;
//                    case 5:
//                        cell.zhiXuanLabel.text = @"个";
//                        break;
//                    default:
//                        break;
                }
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

@end
