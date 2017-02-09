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
#import <AudioToolbox/AudioToolbox.h>

@interface PLFiveViewController ()<numberCellDelegate>{
    NSMutableArray      *_kaijiangArray;        //前5期开奖信息保存在此数组中
    BOOL                _open_lotteryView;      //是否打开中奖详情
    int                 _rows;
    BOOL                _refreshData;           //是否刷新数据
    NSMutableArray      *_shakeNumber;          //摇一摇机选数
    NSMutableArray      *_makeSureSelectNumArray;//确定选好的号码
    
    UILabel             *_numberNots;           //共几注
    UILabel             *_totalMoney;           //共多少钱
    UIView              *_toolbarView;          //底部清空和确定按钮
}

@end

@implementation PLFiveViewController

#pragma mark --  读取开奖数据
- (void)readKaiJiangData
{
    NSString *string = [NSString stringWithFormat:@"/%@.json",self.code];
    NSString *URLString = [baseUrl stringByAppendingString:string];
    kaijiangGet *kaijiangget = [[kaijiangGet alloc]init];
    [kaijiangget apiplus:URLString  completionHandler:^(NSDictionary *dic) {
        ticketsinfo *ticinfo = [[ticketsinfo alloc]init];
        ticinfo = [ticinfo initWithDict:dic];
        _rows = ticinfo.rows;
        _kaijiangArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i = 0;i <ticinfo.rows;i++) {
            datainfo *Datainfo = [[datainfo alloc]init];
            Datainfo = [Datainfo initWithdata:ticinfo.dataarray rows:i];
            [_kaijiangArray addObject:Datainfo];
        }
        [self.ticketsTableview reloadData];
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //读取中奖信息
    [self readKaiJiangData];
    [self addtoolBar];
    _open_lotteryView = NO;
    self.navigationItem.title = self.name;
    
    //开启手机震动
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    
    //手机震动选号和清空数据会用到此数组
    _shakeNumber = [[NSMutableArray alloc] initWithCapacity:0];
    //用户确定
    _makeSureSelectNumArray = [[NSMutableArray alloc] init];
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
        [UIView commitAnimations];
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

#pragma mark --
#pragma mark -- 摇一摇机选
- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    NSLog(@"检测到摇动");
#pragma mark -- 手机震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [_shakeNumber removeAllObjects];
    for (int i = 0; i<5; i++) {
        int j = arc4random()%10;
        NSString *selectNumStr = [NSString stringWithFormat:@"%d",j];
        [_shakeNumber addObject:selectNumStr];
        NSLog(@"selectNumStr:%@",selectNumStr);
    }
    NSLog(@"*_shakeNumber:%@",_shakeNumber);
    
    _refreshData = YES;
    [_PLFiveTableView reloadData];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇动取消");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"摇动结束");
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"UIEventSubtypeMotionShake---摇动结束");
        _numberNots.text = @"共1注";
        _totalMoney.text = @"2元";
        _refreshData = NO;
    }
}
#pragma mark --
#pragma mark -- UISrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //取消所有点击小球的背景图
    for (UIView *tmpView in [UIApplication sharedApplication].delegate.window.subviews) {
        if (tmpView.tag == 123456) {
            [tmpView removeFromSuperview];
        }
    }
    
    _refreshData = NO;
}

#pragma mark --
#pragma mark -- 添加底部清空和确定
- (void)addtoolBar
{
    _toolbarView = [[UIView alloc] initWithFrame:self.tabBarController.tabBar.frame];
    _toolbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ToolBarBackground.png"]];
    //清空按钮
    UIButton *_clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearButton setImage:[UIImage imageNamed:@"ToolBarRedButton.png"] forState:UIControlStateNormal];
    [_clearButton setImage:[UIImage imageNamed:@"ToolBarRedButtonPressed.png"] forState:UIControlStateHighlighted];
    _clearButton.frame = CGRectMake(9, 3.5, 58, 34);
    [_clearButton addTarget:self action:@selector(pressedClearBut:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:_clearButton];
    UILabel *_clearButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 58, 34)];
    _clearButtonLabel.text = @"清空";
    _clearButtonLabel.backgroundColor = [UIColor clearColor];
    _clearButtonLabel.font = [UIFont boldSystemFontOfSize:18];
    _clearButtonLabel.textColor = [UIColor whiteColor];
    _clearButtonLabel.textAlignment = NSTextAlignmentCenter;
    [_clearButton addSubview:_clearButtonLabel];

    
    //确定按钮
    UIButton *_sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setImage:[UIImage imageNamed:@"ToolBarRedButton.png"] forState:UIControlStateNormal];
    [_sureButton setImage:[UIImage imageNamed:@"ToolBarRedButtonPressed.png"] forState:UIControlStateHighlighted];
    _sureButton.frame = CGRectMake(305, 3.5, 58, 34);
    [_sureButton addTarget:self action:@selector(pressedSureBut:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:_sureButton];
    UILabel *_sureButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 58, 34)];
    _sureButtonLabel.text = @"确定";
    _sureButtonLabel.backgroundColor = [UIColor clearColor];
    _sureButtonLabel.font = [UIFont boldSystemFontOfSize:18];
    _sureButtonLabel.textColor = [UIColor whiteColor];
    _sureButtonLabel.textAlignment = NSTextAlignmentCenter;
    [_sureButton addSubview:_sureButtonLabel];

    
    _numberNots = [[UILabel alloc] initWithFrame:CGRectMake(103, 0, 80, 43)];
    _numberNots.text = @"共0注";
    _numberNots.backgroundColor = [UIColor clearColor];
    _numberNots.font = [UIFont systemFontOfSize:16];
    _numberNots.textColor = [UIColor whiteColor];
    _numberNots.textAlignment = NSTextAlignmentRight;
    [_toolbarView addSubview:_numberNots];

    
    _totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(218, 0, 80, 43)];
    _totalMoney.text = @"0元";
    _totalMoney.backgroundColor = [UIColor clearColor];
    _totalMoney.font = [UIFont systemFontOfSize:16];
    _totalMoney.textColor = [UIColor colorWithRed:215.0/255.0 green:180.0/255.0 blue:87.0/255.0 alpha:1];
    _totalMoney.textAlignment = NSTextAlignmentLeft;
    [_toolbarView addSubview:_totalMoney];

    
    [self.view addSubview:_toolbarView];

}


- (void)pressedSureBut: (UIButton *)sender
{
    NSLog(@"确定");
    _refreshData = NO;
    [_PLFiveTableView reloadData];
    for (NSInteger i = 0 ; i<5 ; i++ ) {
        NSMutableArray *tmpArr = [_makeSureSelectNumArray objectAtIndex:i];
        NSLog(@"%ld位：%@",(long)i,tmpArr);
        if ([tmpArr count] == 0) {
            NSString *_weiZhiStr ;
            switch (i) {
                case 0:
                    _weiZhiStr = [NSString stringWithFormat:@"请输入万位"];
                    break;
                case 1:
                    _weiZhiStr = [NSString stringWithFormat:@"请输入千位"];
                    break;
                case 2:
                    _weiZhiStr = [NSString stringWithFormat:@"请输入百位"];
                    break;
                case 3:
                    _weiZhiStr = [NSString stringWithFormat:@"请输入十位"];
                    break;
                case 4:
                    _weiZhiStr = [NSString stringWithFormat:@"请输入个位"];
                    break;
                default:
                    break;
            }
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:_weiZhiStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
    }
}


- (void)pressedClearBut: (UIButton *)sender
{
    NSLog(@"清空");
    _refreshData = YES;
    [_shakeNumber removeAllObjects];
    [_PLFiveTableView reloadData];
    _numberNots.text = @"共0注";
    _totalMoney.text = @"0元";
    
}

@end
