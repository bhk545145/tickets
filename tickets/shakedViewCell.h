//
//  shakedViewCell.h
//  caipiaotest
//
//  Created by yuanda on 13-4-1.
//  Copyright (c) 2013年 wangjunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shakedViewCell : UITableViewCell
{
    UILabel         *_showLabel;
    UIImageView     *_shakeImageView;
    UIImageView     *_breakLineImage;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTitle:(NSString *)titleStr;
@end
