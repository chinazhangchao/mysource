
#import "CLASSNAMECell.h"

@implementation CLASSNAMECell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //商户名称
        _storeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 25)];
        _storeNameLabel.backgroundColor = [UIColor clearColor];
        _storeNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _storeNameLabel.textColor = [UIColor colorWithHexString:@"000000"];
        [self.contentView addSubview:_storeNameLabel];
        
        //商户地址
        _storeAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 5, 70, 20)];
        _storeAddressLabel.font = [UIFont systemFontOfSize:12];
        _storeAddressLabel.backgroundColor = [UIColor clearColor];
        _storeAddressLabel.textColor = [UIColor colorWithName:@"red"];
        [self.contentView addSubview:_storeAddressLabel];
        
        //商户距离
        _distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 5, 70, 20)];
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textColor = [UIColor colorWithName:@"red"];
        [self.contentView addSubview:_distanceLabel];
        
        //箭头图片
        _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 300, 100)];
        _arrowView.layer.masksToBounds = YES;
        [self.contentView addSubview:_arrowView];

    }
    return self;
}

//更新视图
-(void)refreshDataWithNode:(CLASSNAMENode *)node
{
    if (node == nil) {
        return;
    }
    if(_storeNode){
        [_storeNode release];
        _storeNode = nil;
    }
    _storeNode = [node retain];
    
    _storeNameLabel.text = _storeNode.store_name;
    _storeAddressLabel.text = _storeNode.store_address;
    _distanceLabel.text = _storeNode.distance;
}

@end
