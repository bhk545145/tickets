//
//  shakedViewCell.m
//  caipiaotest
//
//  Created by yuanda on 13-4-1.
//  Copyright (c) 2013年 wangjunjun. All rights reserved.
//

#import "shakedViewCell.h"

@implementation shakedViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTitle:(NSString *)titleStr
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 150, 20)];
        _showLabel.text = titleStr;
        _showLabel.textColor = [UIColor colorWithRed:159.0/255.0 green:146.0/255.0 blue:121.0/255.0 alpha:1];
        _showLabel.font = [UIFont systemFontOfSize:15];
        _showLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_showLabel];
       
        _shakeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(218, 6, 92, 16)];
        _shakeImageView.image = [UIImage imageNamed:@"BetShake.png"];
        _shakeImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_shakeImageView];
        
        _breakLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, 320, 1)];
        _breakLineImage.backgroundColor = [UIColor colorWithRed:174.0/255.0 green:159.0/255.0 blue:106.0/255.0 alpha:1];
        [self.contentView addSubview:_breakLineImage];
        self.contentView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
