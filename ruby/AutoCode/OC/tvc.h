
#import <UIKit/UIKit.h>
#import "CLASSNAMENode.h"

@interface CLASSNAMECell : UITableViewCell
{
    UILabel *_storeNameLabel;
    UILabel *_storeAddressLabel;
    UILabel *_distanceLabel;
    UIImageView *_arrowView;
}

@property(nonatomic,retain) CLASSNAMENode *storeNode;

@end
