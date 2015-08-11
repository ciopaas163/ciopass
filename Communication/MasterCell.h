#import <UIKit/UIKit.h>

@protocol callDelegate;
@interface MasterCell : UITableViewCell
<UIActionSheetDelegate,UIAlertViewDelegate>
@property(assign,nonatomic)BOOL isSelected;
@property(strong,nonatomic)UIButton* butIphone;
@property(strong,nonatomic)UIButton * butMessage;
@property(strong,nonatomic)UILabel * butSelected;
@property(strong,nonatomic)UIImageView * selectImage;
@property(strong,nonatomic)UILabel* textLabel;
@property(strong,nonatomic)UILabel* tetLabel;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * subtitle;

@property(strong,nonatomic)id<callDelegate>delegate;
@end

@protocol callDelegate <NSObject>

- (void)callWithNum:(NSString *)_strIphone type:(int)type;


@end