#import <UIKit/UIKit.h>
#import "PublicViewController.h"

#define NAME    @"name"
#define PHONE   @"phone"
#define TELPHONE    @"telPhone"
#define INFOTAG @"infoTag"

@protocol PersonViewDelegate;
@interface PersonalView : PublicViewController
<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)id<PersonViewDelegate>delegate;

- (id)initWithTags:(NSArray *)tags;
@end
@protocol PersonViewDelegate <NSObject>

- (void)saveModel:(NSDictionary *)dict withTag:(NSString *)tag;

@end