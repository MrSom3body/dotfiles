{
  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "canary";
      minimizeToTray = false;
      arRPC = true;
      splashTheming = true;
      enableMenu = true;
    };
    vencord = {
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        useQuickCss = true;
        eagerPatches = false;
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;
        plugins = {
          AlwaysAnimate = {enabled = true;};
          AlwaysExpandRoles = {enabled = true;};
          AlwaysTrust = {enabled = false;};
          BadgeAPI = {enabled = true;};
          BetterFolders = {
            enabled = true;
            sidebar = true;
            sidebarAnim = true;
            closeAllFolders = true;
            closeAllHomeButton = true;
            closeOthers = true;
            forceOpen = true;
            keepIcons = true;
            showFolderIcon = 1;
          };
          BetterGifAltText = {enabled = true;};
          BetterGifPicker = {enabled = true;};
          BetterRoleContext = {
            enabled = true;
            roleIconFileFormat = "png";
          };
          BetterRoleDot = {
            enabled = true;
            bothStyles = true;
            copyRoleColorInProfilePopout = true;
          };
          BetterSessions = {
            enabled = true;
            backgroundCheck = true;
            checkInterval = 20;
          };
          BetterSettings = {
            enabled = true;
            disableFade = true;
            organizeMenu = true;
            eagerLoad = true;
          };
          BetterUploadButton = {enabled = true;};
          BiggerStreamPreview = {enabled = true;};
          BlurNSFW = {enabled = false;};
          CallTimer = {
            enabled = true;
            format = "human";
          };
          ClearURLs = {enabled = true;};
          CommandsAPI = {enabled = true;};
          ConsoleJanitor = {
            enabled = true;
            disableLoggers = false;
            disableSpotifyLogger = true;
            whitelistedLoggers = "GatewaySocket; Routing/Utils";
            allowLevel = {
              error = true;
              warn = false;
              trace = false;
              log = false;
              info = false;
              debug = false;
            };
          };
          ConsoleShortcuts = {enabled = true;};
          CopyFileContents = {enabled = true;};
          CopyUserURLs = {enabled = true;};
          CrashHandler = {enabled = true;};
          Dearrow = {
            enabled = true;
            hideButton = false;
            replaceElements = 0;
            dearrowByDefault = true;
          };
          DisableCallIdle = {enabled = true;};
          DisableDeepLinks = {enabled = true;};
          DontRoundMyTimestamps = {enabled = true;};
          DynamicImageModalAPI = {enabled = true;};
          EmoteCloner = {enabled = true;};
          Experiments = {
            enabled = true;
            toolbarDevMenu = false;
          };
          FakeNitro = {
            enabled = true;
            enableEmojiBypass = true;
            emojiSize = 48;
            transformEmojis = true;
            enableStickerBypass = true;
            stickerSize = 160;
            transformStickers = true;
            transformCompoundSentence = false;
            enableStreamQualityBypass = true;
            useHyperLinks = true;
            hyperLinkText = "{{NAME}}";
            disableEmbedPermissionCheck = false;
          };
          FavoriteEmojiFirst = {enabled = true;};
          FavoriteGifSearch = {
            enabled = true;
            searchOption = "hostandpath";
          };
          FixCodeblockGap = {enabled = true;};
          FixImagesQuality = {enabled = true;};
          FixSpotifyEmbeds = {
            enabled = true;
            volume = 50;
          };
          FixYoutubeEmbeds = {enabled = true;};
          ForceOwnerCrown = {enabled = true;};
          FriendInvites = {enabled = true;};
          FriendsSince = {enabled = true;};
          FullSearchContext = {enabled = true;};
          FullUserInChatbox = {enabled = true;};
          GifPaste = {enabled = true;};
          GreetStickerPicker = {enabled = true;};
          HideMedia = {enabled = true;};
          ImageZoom = {
            enabled = true;
            saveZoomValues = true;
            invertScroll = true;
            nearestNeighbour = false;
            square = false;
            zoom = 2;
            size = 100;
            zoomSpeed = {};
          };
          ImplicitRelationships = {
            enabled = true;
            sortByAffinity = true;
          };
          LoadingQuotes = {
            enabled = true;
            replaceEvents = true;
            enablePluginPresetQuotes = true;
            enableDiscordPresetQuotes = false;
            additionalQuotes = "";
            additionalQuotesDelimiter = "|";
          };
          MemberCount = {
            enabled = true;
            toolTip = true;
            memberList = true;
          };
          MemberListDecoratorsAPI = {enabled = true;};
          MentionAvatars = {
            enabled = true;
            showAtSymbol = true;
          };
          MessageAccessoriesAPI = {enabled = true;};
          MessageClickActions = {
            enabled = true;
            enableDeleteOnClick = true;
            enableDoubleClickToEdit = true;
            enableDoubleClickToReply = true;
            requireModifier = false;
          };
          MessageDecorationsAPI = {enabled = true;};
          MessageEventsAPI = {enabled = true;};
          MessageLinkEmbeds = {
            enabled = true;
            automodEmbeds = "never";
            listMode = "blacklist";
            idList = "";
          };
          MessageLogger = {
            enabled = true;
            deleteStyle = "text";
            logDeletes = true;
            collapseDeleted = true;
            logEdits = true;
            inlineEdits = true;
            ignoreBots = false;
            ignoreSelf = false;
            ignoreUsers = "";
            ignoreChannels = "";
            ignoreGuilds = "";
          };
          MessageUpdaterAPI = {enabled = true;};
          MoreCommands = {enabled = true;};
          MoreKaomoji = {enabled = true;};
          MutualGroupDMs = {enabled = true;};
          NoDevtoolsWarning = {enabled = true;};
          NoMaskedUrlPaste = {enabled = true;};
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          NormalizeMessageLinks = {enabled = true;};
          OnePingPerDM = {enabled = true;};
          OpenInApp = {
            enabled = true;
            spotify = true;
            steam = true;
            epic = true;
            tidal = true;
            itunes = true;
          };
          PermissionsViewer = {
            enabled = true;
            permissionsSortOrder = 0;
          };
          PictureInPicture = {enabled = true;};
          PinDMs = {
            enabled = true;
            pinOrder = 0;
            canCollapseDmSection = false;
          };
          PlatformIndicators = {
            enabled = true;
            list = true;
            badges = true;
            messages = true;
            colorMobileIndicator = true;
          };
          PreviewMessage = {enabled = true;};
          QuickMention = {enabled = true;};
          QuickReply = {
            enabled = true;
            shouldMention = 2;
          };
          ReactErrorDecoder = {enabled = true;};
          ReadAllNotificationsButton = {enabled = true;};
          RelationshipNotifier = {
            enabled = true;
            notices = true;
            offlineRemovals = true;
            friends = true;
            friendRequestCancels = true;
            servers = true;
            groups = true;
          };
          ReplaceGoogleSearch = {
            enabled = true;
            customEngineName = "DuckDuckGo";
            customEngineURL = "https://duckduckgo.com/q=";
          };
          ReplyTimestamp = {enabled = true;};
          RevealAllSpoilers = {enabled = true;};
          ReverseImageSearch = {enabled = true;};
          SecretRingToneEnabler = {enabled = true;};
          SendTimestamps = {enabled = true;};
          ServerInfo = {enabled = true;};
          ServerListAPI = {enabled = true;};
          ServerListIndicators = {enabled = true;};
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          ShikiCodeblocks = {enabled = true;};
          ShowAllMessageButtons = {enabled = true;};
          ShowConnections = {
            enabled = true;
            iconSize = 32;
            iconSpacing = 1;
          };
          ShowHiddenChannels = {
            enabled = true;
            hideUnreads = true;
            showMode = 0;
            defaultAllowedUsersAndRolesDropdownState = true;
          };
          ShowHiddenThings = {
            enabled = true;
            showTimeouts = true;
            showInvitesPaused = true;
            showModView = true;
          };
          ShowTimeoutDuration = {
            enabled = true;
            displayStyle = "ssalggnikool";
          };
          SilentMessageToggle = {enabled = true;};
          SilentTyping = {
            enabled = true;
            showIcon = true;
            contextMenu = true;
            isEnabled = true;
          };
          SortFriendRequests = {
            enabled = true;
            showDates = true;
          };
          SpotifyControls = {
            enabled = true;
            hoverControls = false;
            useSpotifyUris = true;
            previousButtonRestartsTrack = true;
          };
          SpotifyCrack = {enabled = true;};
          SpotifyShareCommands = {enabled = true;};
          StartupTimings = {enabled = true;};
          StickerPaste = {enabled = true;};
          SupportHelper = {enabled = true;};
          Translate = {
            enabled = true;
            showChatBarButton = true;
            service = "deepl";
            deeplApiKey = "";
            autoTranslate = false;
            showAutoTranslateTooltip = true;
            receivedInput = "";
            receivedOutput = "en-us";
            sentInput = "";
            sentOutput = "en-us";
          };
          Unindent = {enabled = true;};
          UserSettingsAPI = {enabled = true;};
          UserVoiceShow = {
            enabled = true;
            showInUserProfileModal = true;
            showInMemberList = true;
            showInMessages = true;
          };
          ValidReply = {enabled = true;};
          ValidUser = {enabled = true;};
          ViewIcons = {enabled = true;};
          VoiceChatDoubleClick = {enabled = true;};
          VoiceDownload = {enabled = true;};
          VoiceMessages = {enabled = true;};
          VolumeBooster = {
            enabled = true;
            multiplier = 2;
          };
          WebContextMenus = {enabled = true;};
          WebKeybinds = {enabled = true;};
          WebScreenShareFixes = {enabled = true;};
          YoutubeAdblock = {enabled = true;};
          iLoveSpam = {enabled = true;};
          oneko = {enabled = true;};
          petpet = {enabled = true;};
        };
        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "always";
          logLimit = 50;
        };
      };
    };
  };
}
