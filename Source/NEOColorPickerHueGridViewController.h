#import "NEOColorPickerBaseViewController.h"

@interface NEOColorPickerHueGridViewController : NEOColorPickerBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *colorBar;
@property (weak, nonatomic) IBOutlet UILabel *selectedColorLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *centeredView;

@end
