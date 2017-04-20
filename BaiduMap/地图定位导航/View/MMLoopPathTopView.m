//
//  MMLoopPathTopView.m
//  happyDot
//
//  Created by MM on 17/4/14.
//
//

#import "MMLoopPathTopView.h"
@interface MMLoopPathTopView()
/**起点tittle*/
@property(nonatomic, strong)UILabel *originAddressTittle;
/**起点*/
@property(nonatomic, strong)UIButton *originAddress;
/**终点tittle*/
@property(nonatomic, strong)UILabel *endAddressTittle;
/**leftIcon*/

/**分割1*/
@property(nonatomic, strong)UIView *splitLine1;

/**分割2*/
@property(nonatomic, strong)UIView *splitLine2;
/**交换起点终点*/
@property(nonatomic, strong)UIButton *exchangeBtn;
/**公交*/
@property(nonatomic, strong)UIButton *transitBtn;
/**驾车*/
@property(nonatomic, strong)UIButton *driveBtn;
/**步行*/
@property(nonatomic, strong)UIButton *walkBtn;
@end
@implementation MMLoopPathTopView
#pragma mark 交换起点终点
- (void)exchangeAddress
{
    NSString *end = _endAddress.text;
    _endAddress.text = _originAddress.titleLabel.text;
    [_originAddress setTitle:end forState:UIControlStateNormal];
}
#pragma mark 交通方式
- (void)trafficPath:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(clickTrafficBtnOnMMLoopPathTopView:index:start:end:)]) {
        [_delegate clickTrafficBtnOnMMLoopPathTopView:self index:button.tag-700 start:_startStr end:_endAddress.text];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    /**起点*/
    _originAddressTittle = [[UILabel alloc] init];
    _originAddressTittle.text = @"起点：";
    _originAddressTittle.textColor = [UIColor darkGrayColor];
    _originAddressTittle.font = [UIFont systemFontOfSize:14];
    [self addSubview:_originAddressTittle];
    
    _originAddress = [[UIButton alloc] init];
    [_originAddress setTitle:@"我的位置" forState:UIControlStateNormal];
    [_originAddress setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_originAddress.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_originAddress];
    /**分割1*/
    _splitLine1 = [[UIView alloc] init];
    _splitLine1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_splitLine1];
    /**终点*/
    _endAddressTittle = [[UILabel alloc] init];
    _endAddressTittle.text = @"终点：";
    _endAddressTittle.textColor = [UIColor lightGrayColor];
    _endAddressTittle.font = [UIFont systemFontOfSize:14];
    [self addSubview:_endAddressTittle];
    _endAddress = [[UILabel alloc] init];
    _endAddress.text = @"华谊兄弟电影汇";
    _endAddress.textColor = [UIColor lightGrayColor];
    _endAddress.font = [UIFont systemFontOfSize:14];
    [self addSubview:_endAddress];
    /**分割2*/
    _splitLine2 = [[UIView alloc] init];
    _splitLine2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_splitLine2];
    /**交换起点终点*/
    _exchangeBtn = [[UIButton alloc] init];
    _exchangeBtn.hidden = YES;
    [_exchangeBtn setTitle:@"交换" forState:UIControlStateNormal];
    [_exchangeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_exchangeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_exchangeBtn addTarget:self action:@selector(exchangeAddress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_exchangeBtn];
    /**公交*/
    _transitBtn = [[UIButton alloc] init];
    _transitBtn.tag = 700;
    [_transitBtn setTitle:@"公交" forState:UIControlStateNormal];
    [_transitBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_transitBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_transitBtn addTarget:self action:@selector(trafficPath:) forControlEvents:UIControlEventTouchUpInside];
    _transitBtn.backgroundColor = [UIColor redColor];
    [self addSubview:_transitBtn];
    /**驾车*/
    _driveBtn = [[UIButton alloc] init];
    _driveBtn.tag = 701;
    [_driveBtn setTitle:@"驾车" forState:UIControlStateNormal];
    [_driveBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_driveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_driveBtn addTarget:self action:@selector(trafficPath:) forControlEvents:UIControlEventTouchUpInside];
    _driveBtn.backgroundColor = [UIColor yellowColor];
    [self addSubview:_driveBtn];
    /**步行*/
    _walkBtn = [[UIButton alloc] init];
    _walkBtn.tag = 702;
    [_walkBtn setTitle:@"步行" forState:UIControlStateNormal];
    [_walkBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_walkBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_walkBtn addTarget:self action:@selector(trafficPath:) forControlEvents:UIControlEventTouchUpInside];
    _walkBtn.backgroundColor = [UIColor greenColor];
    [self addSubview:_walkBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /**起点*/
    [_originAddressTittle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(16);
        make.top.mas_equalTo(self).with.offset(5);
        make.height.mas_equalTo(@40);
    }];
    [_originAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_originAddressTittle.mas_right).with.offset(5);
        make.top.mas_equalTo(self).with.offset(5);
        make.height.mas_equalTo(@40);
    }];
    /**分割1*/
    [_splitLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(_originAddress.mas_bottom).with.offset(3);
        make.right.mas_equalTo(_exchangeBtn.mas_left);
        make.height.mas_equalTo(@1);
    }];
    /**终点*/
    [_endAddressTittle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_originAddressTittle);
        make.top.mas_equalTo(_splitLine1.mas_bottom).with.offset(3);
        make.height.mas_equalTo(@40);
    }];
    [_endAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_originAddress);
        make.top.mas_equalTo(_splitLine1.mas_bottom).with.offset(3);
        make.height.mas_equalTo(@40);
    }];
    /**分割2*/
    [_splitLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_endAddress.mas_bottom).with.offset(3);
        make.height.mas_equalTo(@1);
    }];
    /**交换起点终点*/
    [_exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.centerY.mas_equalTo(_splitLine1);
        make.width.mas_equalTo(@40);
    }];
    /**公交*/
    [_transitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(ViewWidth*0.05);
        make.top.mas_equalTo(_splitLine2.mas_bottom).with.offset(10);
        make.width.mas_equalTo(ViewWidth*0.3);
    }];
    /**驾车*/
    [_driveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_transitBtn.mas_right);
        make.top.mas_equalTo(_transitBtn);
        make.bottom.mas_equalTo(_transitBtn);
        make.width.mas_equalTo(ViewWidth*0.3);
    }];
    /**步行*/
    [_walkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_driveBtn.mas_right);
        make.top.mas_equalTo(_transitBtn);
        make.bottom.mas_equalTo(_transitBtn);
        make.width.mas_equalTo(ViewWidth*0.3);
    }];
    
}


@end
