//
//  MMGuidancePathDetailTableViewCell.m
//  happyDot
//
//  Created by MM on 17/4/17.
//
//

#import "MMGuidancePathDetailTableViewCell.h"

@interface MMGuidancePathDetailTableViewCell()

@end
@implementation MMGuidancePathDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    _leftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_leftImageView];
    
    _pathText = [[UILabel alloc] init];
    _pathText.text = @"13号地铁线";
    _pathText.textColor = [UIColor darkGrayColor];
    _pathText.font = [UIFont systemFontOfSize:14];
    _pathText.numberOfLines = 0;
    [self.contentView addSubview:_pathText];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(@12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [_pathText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).with.offset(5);
        make.right.bottom.mas_equalTo(self).with.offset(-5);
        make.left.mas_equalTo(_leftImageView.mas_right).with.offset(10);
    }];
}

@end
