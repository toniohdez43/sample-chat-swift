//
//  quickblox-bridging-Header.h
//  sample-chat-swift
//
//  Created by Anton Sokolchenko on 3/30/15.
//  Copyright (c) 2015 quickblox. All rights reserved.
//

#ifndef sample_chat_swift_quickblox_bridging_Header_h
#define sample_chat_swift_quickblox_bridging_Header_h

@import UIKit;
@import Foundation;
@import SystemConfiguration;
@import MobileCoreServices;
@import Quickblox;

#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPMessageDeliveryReceipts.h"
#import <QMServices.h>
#import <SVProgressHUD.h>
#import "XMPP.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPRoom.h"
#import "XMPPRoomMemoryStorage.h"
#import "XMPPLastActivity.h"
#import "QMChatViewController.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPRoster.h"
#import "XMPPReconnect.h"
#import "QMChatContactRequestCell.h"
#import "QMChatNotificationCell.h"
#import "QMChatIncomingCell.h"
#import "QMChatOutgoingCell.h"
#import "QMCollectionViewFlowLayoutInvalidationContext.h"

#import "TTTAttributedLabel.h"

#import "TWMessageBarManager.h"

#import "_CDMessage.h"
#import "UIImage+QM.h"
#import "UIColor+QM.h"
#import "UIImage+fixOrientation.h"

#endif
