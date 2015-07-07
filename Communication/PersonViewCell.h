#import <UIKit/UIKit.h>

@interface PersonViewCell : UITableViewCell
<UITextFieldDelegate>
{
    UILabel * _titleLabel;
}

@property(strong,nonatomic)UITextField * field;
@property(strong,nonatomic)NSString * title;

@end
