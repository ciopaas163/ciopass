#import <UIKit/UIKit.h>

@protocol PersonTagDelegate;

@interface PersonViewTagCell : UITableViewCell

@property(strong,nonatomic)NSString * tagText;//添加的tag
@property(strong,nonatomic)UIView * unselectTagView;

@property(strong,nonatomic)id<PersonTagDelegate>delegate;

@end

@protocol PersonTagDelegate <NSObject>

- (void)delegateTag;

@end