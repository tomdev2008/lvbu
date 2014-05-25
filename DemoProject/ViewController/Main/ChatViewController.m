//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "ChatViewController.h"

@interface ChatViewController()
{
	NSString *chatroom;
	NSDictionary *userinfo;
	
	BOOL initialized;
}
@end


@implementation ChatViewController

- (id)initWith:(NSString *)Chatroom Userinfo:(NSDictionary *)Userinfo
{
	self = [super init];
	chatroom = [Chatroom copy];
	userinfo = [Userinfo copy];
	return self;
}


- (void)viewDidLoad
{
	self.delegate = self;
	self.dataSource = self;

	[super viewDidLoad];
	self.title = chatroom;

	[self setBackgroundColor:[UIColor whiteColor]];
	[[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
	self.messageInputView.textView.placeHolder = @"New Message";

	initialized = NO;
	self.msgArr = [[NSMutableArray alloc] init];
	
}

- (void)reloadTable
{
	[self.tableView reloadData];

	NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
	[self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.msgArr.count;
}


- (void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
	if ([text length] > 140) text = [text substringToIndex:140];

//	NSString *uid = [userinfo valueForKey:@"uid"];
//	NSString *image = [userinfo valueForKey:@"image"];
//	NSString *name = [userinfo valueForKey:@"name"];

	[JSMessageSoundEffect playMessageSentSound];

	[self finishSend];
	[self.view endEditing:YES];
}


- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *msg = [self.msgArr objectAtIndex:indexPath.row];

	NSString *uid1 = [msg valueForKey:@"uid"];
	NSString *uid2 = [userinfo valueForKey:@"uid"];

	return [uid1 isEqualToString:uid2] ? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeIncoming;
}


- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *msg = [self.msgArr objectAtIndex:indexPath.row];

	NSString *uid1 = [msg valueForKey:@"uid"];
	NSString *uid2 = [userinfo valueForKey:@"uid"];

	if ([uid1 isEqualToString:uid2])
		return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
	else return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleBlueColor]];
}


- (JSMessageInputViewStyle)inputViewStyle
{
	return JSMessageInputViewStyleFlat;
}

- (BOOL)shouldDisplayTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row % 3 == 0)
	{
		return YES;
	}
	return NO;
}


- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	if ([cell messageType] == JSBubbleMessageTypeOutgoing)
	{
		cell.bubbleView.textView.textColor = [UIColor whiteColor];
	
		if ([cell.bubbleView.textView respondsToSelector:@selector(linkTextAttributes)])
		{
			NSMutableDictionary *attributes = [cell.bubbleView.textView.linkTextAttributes mutableCopy];
			[attributes setValue:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
			cell.bubbleView.textView.linkTextAttributes = attributes;
		}
	}

	if (cell.timestampLabel)
	{
		cell.timestampLabel.textColor = [UIColor lightGrayColor];
		cell.timestampLabel.shadowOffset = CGSizeZero;
	}

	if (cell.subtitleLabel)
	{
		cell.subtitleLabel.textColor = [UIColor lightGrayColor];
	}
}


- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
	return YES;
}


- (BOOL)allowsPanToDismissKeyboard
{
	return YES;
}


- (JSMessage *)messageForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *msg = [self.msgArr objectAtIndex:indexPath.row];
	return [[JSMessage alloc] initWithText:[msg valueForKey:@"text"] sender:[msg valueForKey:@"name"] date:[NSDate date]];
}


- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender
{
	NSDictionary *msg = [self.msgArr objectAtIndex:indexPath.row];

	UIImageView *imageView = [[UIImageView alloc] init];
	[imageView setImageWithURL:[NSURL URLWithString:[msg valueForKey:@"image"]] placeholderImage:nil];
	imageView.layer.cornerRadius = 4.0;
	imageView.layer.masksToBounds = YES;

	return imageView;
}

@end
