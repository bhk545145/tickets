//
//  PLFiveViewController.h
//  cn.com.broadlink.CP
//
//  Created by 白洪坤 on 2017/1/24.
//  Copyright © 2017年 白洪坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLFiveViewController : UIViewController

- (IBAction)pressedLotteryButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *arrorimagebtn;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *code;
@property (weak, nonatomic) IBOutlet UITableView *ticketsTableview;
@property (weak, nonatomic) IBOutlet UIView *openLotteryView;
@property (weak, nonatomic) IBOutlet UITableView *PLFiveTableView;
@end
