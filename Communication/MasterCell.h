#import <UIKit/UIKit.h>

@protocol callDelegate;
@interface MasterCell : UITableViewCell
<UIActionSheetDelegate,UIAlertViewDelegate>

@property(strong,nonatomic)UIButton* butIphone;
@property(strong,nonatomic)UIButton* Btnmessage;
@property(strong,nonatomic)NSString* phoneNum;

@property(strong,nonatomic)id<callDelegate>delegate;
@end

@protocol callDelegate <NSObject>

- (void)callWithNum:(NSString *)_strIphone type:(int)type;


@end