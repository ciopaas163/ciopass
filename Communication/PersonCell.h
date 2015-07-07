#import <UIKit/UIKit.h>

#define NAME    @"name"
#define PHONE   @"phone"
#define TELPHONE    @"telPhone"
#define INFOTAG @"infoTag"
@interface PersonCell : UITableViewCell

{
    UILabel * _name;
    UILabel * _phone;
    UILabel * _telPhone;
    UILabel * _tagText;
}

@property(strong,nonatomic)NSDictionary * dict;

@end
