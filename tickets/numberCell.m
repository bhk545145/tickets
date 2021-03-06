//
//  numberCell.m
//  caipiaotest
//
//  Created by yuanda on 13-4-1.
//  Copyright (c) 2013年 wangjunjun. All rights reserved.
//

#import "numberCell.h"
#define BALLHIGHLIGHT  123456

@interface numberCell(){
    UILabel *zhiXuanLabel;
//    NSMutableArray  *_selectNumberArray;
}

@end

@implementation numberCell
-(void)setIndexint:(NSInteger)indexint{
    _indexint = indexint;
    switch (_indexint) {
        case 1:
            zhiXuanLabel.text = @"万";
            break;
        case 2:
            zhiXuanLabel.text = @"千";
            break;
        case 3:
            zhiXuanLabel.text = @"百";
            break;
        case 4:
            zhiXuanLabel.text = @"十";
            break;
        case 5:
            zhiXuanLabel.text = @"个";
            break;
        default:
            break;
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectNumberArray = [[NSMutableArray alloc] initWithCapacity:0];
        zhiXuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 39.5, 21)];
        zhiXuanLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BetSFCCellTeam1"]];
        zhiXuanLabel.text = @"百";
        zhiXuanLabel.textAlignment = NSTextAlignmentCenter;
        zhiXuanLabel.textColor = [UIColor colorWithRed:141.0/255.0 green:70.0/255.0 blue:27.0/255.0 alpha:1];
        zhiXuanLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:zhiXuanLabel];
        //添加十个小球和小球上的数字
        for (int i = 0; i<2; i++) {
            for (int j = 0; j<5; j++) {
                UIImageView *redBallImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BetGrayBall.png"]];
                redBallImage.tag = j+i*5+103;
                redBallImage.frame = CGRectMake(55+(35+11)*j, 9+(39+2)*i, 35, 39);
                redBallImage.userInteractionEnabled = YES;
                [self.contentView addSubview:redBallImage];
                
                UILabel *labelNumber = [[UILabel alloc] initWithFrame:redBallImage.bounds];
                labelNumber.tag = (j+i*5)+123;
                labelNumber.text = [NSString stringWithFormat:@"%d",j+i*5];
                labelNumber.textColor = [UIColor colorWithRed:160.0/255.0 green:14.0/255.0 blue:54.0/255.0 alpha:1];
                labelNumber.textAlignment = NSTextAlignmentCenter;
                labelNumber.font = [UIFont systemFontOfSize:20];
                labelNumber.userInteractionEnabled = YES;
                [redBallImage addSubview:labelNumber];
            }
        }

    }
    return self;
}
//把选中小球变成红色或取消选择变成白色

- (void)numberImageBackground:(NSInteger)imageTag
{
    
    NSString *selectNumberStr = [NSString stringWithFormat:@"%ld",imageTag - 103];
    if ([_selectNumberArray count] == 0) {
        [_selectNumberArray addObject:selectNumberStr];
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:imageTag];
        tmpImage.image = [UIImage imageNamed:@"BetRedBall.png"];
        UILabel *tmpLabel = (UILabel *)[tmpImage viewWithTag:imageTag +10];
        tmpLabel.textColor = [UIColor whiteColor];
        [self.delegate getTotalNotsAndMoney];
        //增加一注
        return;
    }else
    {
        for (NSInteger i = 0;i<[_selectNumberArray count];i++) {
            NSString * tmpNumStr = [_selectNumberArray objectAtIndex:i];
            if ([tmpNumStr isEqualToString:selectNumberStr]) {
                UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:imageTag];
                tmpImage.image = [UIImage imageNamed:@"BetGrayBall.png"];
                UILabel *tmpLabel = (UILabel *)[tmpImage viewWithTag:imageTag +10];
                tmpLabel.textColor = [UIColor colorWithRed:160.0/255.0 green:14.0/255.0 blue:54.0/255.0 alpha:1];
                [_selectNumberArray removeObject:tmpNumStr];
                NSLog(@"数组：%@",_selectNumberArray);
                [self.delegate getTotalNotsAndMoney];
                //减少一注
                return;
            }
        }
        
        
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:imageTag];
        tmpImage.image = [UIImage imageNamed:@"BetRedBall.png"];
        UILabel *tmpLabel = (UILabel *)[tmpImage viewWithTag:imageTag +10];
        tmpLabel.textColor = [UIColor whiteColor];
        [_selectNumberArray addObject:selectNumberStr];
        NSLog(@"数组：%@",_selectNumberArray);
        [self.delegate getTotalNotsAndMoney];
        //增加一注
        
    }
    
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //[self.delegate tableViewScrll:YES];
    UITouch *touch = [touches anyObject];
    
    //点击后取得在 cell 上的坐标点
    CGPoint locationCel = [touch locationInView:self.contentView];
    //点击后取得在window上的坐标点
    CGPoint locationWin = [touch locationInView:[UIApplication sharedApplication].delegate.window];
    NSLog(@"x1:%f,y1:%f",locationCel.x,locationCel.y);
    NSLog(@"x2:%f,y2:%f",locationWin.x,locationWin.y);

    //删除所有的redballHighlight
    [self removeBallHighlight];
    
    for (NSInteger i = 103 ; i<113; i++) {
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
        CGRect tmpRect = tmpImage.frame;
        
        
        if (CGRectContainsPoint(tmpRect, locationCel)) {
            [self.delegate tableViewScrll:NO];
            
            //删除所有的redballHighlight
            //[self removeBallHighlight];
            
            //所选小号的相对坐标点
            CGPoint locations;
            locations.x = tmpRect.origin.x;
            locations.y = tmpRect.origin.y;
            
            //所选号码
            NSInteger testNumber = i - 103;
            
            //所选小号的绝对坐标点
            CGPoint absoluteCoordinate = [self getSelectNumberPoint:locationWin withCellPoint:locationCel andYofBallorigin:locations];
            
            //把所选号码背景图加到window上
            [self addBallHighlight:testNumber withLocation:absoluteCoordinate];
            return;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //点击后取得在 cell 上的坐标点
    CGPoint locationCel = [touch locationInView:self.contentView];
    //点击后取得在window上的坐标点
    CGPoint locationWin = [touch locationInView:[UIApplication sharedApplication].delegate.window];
    
    //删除所有的redballHighlight
    [self removeBallHighlight];
    
    for (NSInteger i = 103 ; i<113; i++) {
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
        CGRect tmpRect = tmpImage.frame;
        if (CGRectContainsPoint(tmpRect, locationCel)) {
            
            //所选小号的相对坐标点
            CGPoint locations;
            locations.x = tmpRect.origin.x;
            locations.y = tmpRect.origin.y;
            
            //所选号码
            NSInteger testNumber = i - 103;
            
            //所选小号的绝对坐标点
            CGPoint absoluteCoordinate = [self getSelectNumberPoint:locationWin withCellPoint:locationCel andYofBallorigin:locations];
            
            //把所选号码背景图加到window上
            [self addBallHighlight:testNumber withLocation:absoluteCoordinate];
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.contentView];
   
    //删除所有的redballHighlight
    [self removeBallHighlight];
    
    for (NSInteger i = 103 ; i<113; i++) {
        UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
        CGRect tmpRect = tmpImage.frame;
        if (CGRectContainsPoint(tmpRect, location)) {
            
            //删除所有的redballHighlight
            [self removeBallHighlight];
            //选中和再次选中后redball的背景色
            [self numberImageBackground:i];
            return;
        }
    }
    [self.delegate tableViewScrll:YES];

}

#pragma mark --
#pragma mark -- 添加点击小图后的大图和大图上数字

- (void)addBallHighlight:(NSInteger)SeleteNumber withLocation:(CGPoint)location
{
    UIImageView *_numberImageGround  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BetRedBallPressed.png"]];
    _numberImageGround.tag = BALLHIGHLIGHT;
    _numberImageGround.frame = CGRectMake(location.x-12.5 , location.y -56, 60, 95);
    _numberImageGround.alpha = 1;
    [[UIApplication sharedApplication].delegate.window addSubview:_numberImageGround];
    
    UILabel *_lableNumberBackground = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _lableNumberBackground.tag = 12345;
    _lableNumberBackground.backgroundColor = [UIColor clearColor];
    _lableNumberBackground.text = [NSString stringWithFormat:@"%ld",(long)SeleteNumber];
    _lableNumberBackground.textColor = [UIColor whiteColor];
    _lableNumberBackground.textAlignment = NSTextAlignmentCenter;
    _lableNumberBackground.font = [UIFont boldSystemFontOfSize:25];
    [_numberImageGround addSubview:_lableNumberBackground];

}

#pragma mark --
#pragma mark -- 清空所有数据和选择随机数

- (void)refreshDataWith:(NSString *)slecteStr 
{
      NSLog(@"slecteStr:%@",slecteStr);
    //清空所有选择数据
    [_selectNumberArray removeAllObjects];
    for (int i = 103; i<113; i++) {
            UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
            tmpImage.image = [UIImage imageNamed:@"BetGrayBall.png"];
            UILabel *tmpLabel = (UILabel *)[tmpImage viewWithTag:i +10];
            tmpLabel.textColor = [UIColor colorWithRed:160.0/255.0 green:14.0/255.0 blue:54.0/255.0 alpha:1];
        }
        
    if ([slecteStr isEqualToString:@"清空数据"]) {
        return;
    }else
    {
        //摇动后随即选出的一个数字
        for (int i = 103; i<113; i++) {
            NSString * tmpNumStr = [NSString stringWithFormat:@"%d",i-103];
            if ([slecteStr isEqualToString:tmpNumStr]) {
                UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
                tmpImage.image = [UIImage imageNamed:@"BetRedBall.png"];
                UILabel *tmpLabel = (UILabel *)[tmpImage viewWithTag:i +10];
                tmpLabel.textColor = [UIColor whiteColor];
                [_selectNumberArray removeAllObjects];
                [_selectNumberArray addObject:tmpNumStr];
                NSLog(@"数组：%@",_selectNumberArray);
            }else
            {
                UIImageView *tmpImage = (UIImageView *)[self.contentView viewWithTag:i];
                tmpImage.image = [UIImage imageNamed:@"BetGrayBall.png"];
                UILabel *tmpLabel = (UILabel *)[tmpImage viewWithTag:i +10];
                tmpLabel.textColor = [UIColor colorWithRed:160.0/255.0 green:14.0/255.0 blue:54.0/255.0 alpha:1];
            }
        }
    }
    
}


#pragma mark --
#pragma mark -- 删除点击小图后的大图和大图上数字
- (void)removeBallHighlight
{
    for (UIView *tmpView in [UIApplication sharedApplication].delegate.window.subviews) {
        if (tmpView.tag == BALLHIGHLIGHT) {
            [tmpView removeFromSuperview];
        }
    }
}

#pragma mark --
#pragma mark -- 获取cell上点击ball按钮的绝对坐标

- (CGPoint)getSelectNumberPoint:(CGPoint)windowPoint withCellPoint:(CGPoint)cellPoint andYofBallorigin:(CGPoint)cellBallOrigin 
{
    CGPoint testPoint ;
    if (windowPoint.x >= 239) {
        testPoint.x = 239;
    }else if (windowPoint.x >= 193)
    {
        testPoint.x = 193;
    }else if (windowPoint.x >= 147)
    {
        testPoint.x = 147;
    }else if (windowPoint.x >= 101)
    {
        testPoint.x = 101;
    }else if (windowPoint.x >= 55)
    {
        testPoint.x = 55;
    }
    testPoint.y = windowPoint.y - cellPoint.y + cellBallOrigin.y;
    
    return testPoint;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
