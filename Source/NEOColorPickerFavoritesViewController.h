#import "NEOColorPickerBaseViewController.h"

@interface NEOColorPickerFavoritesViewController : NEOColorPickerBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *selectedColorLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)pageValueChange:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *centeredView;

@end
