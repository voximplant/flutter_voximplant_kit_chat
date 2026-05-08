// Copyright (c) 2011 - 2026, Voximplant, Inc. All rights reserved.

import 'package:voximplant_kit_chat/voximplant_kit_chat.dart';

class Credentials {
  const Credentials({
    required this.region,
    required this.channelUuid,
    required this.token,
    required this.clientId,
  });

  final KitChatRegion? region;
  final String channelUuid;
  final String token;
  final String clientId;
}
