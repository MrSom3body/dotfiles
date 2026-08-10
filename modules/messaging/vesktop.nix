{
  flake.modules.homeManager.messaging = {
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
        useSystem = true;
        settings = {
          # updates are handled by nix
          autoUpdate = false;
          autoUpdateNotification = false;
          notifyAboutUpdates = false;

          disableMinSize = false;
          eagerPatches = false;
          enableReactDevtools = false;
          frameless = false;
          notifications = {
            logLimit = 50;
            position = "bottom-right";
            timeout = 5000;
            useNative = "always";
          };
          transparent = false;
          useQuickCss = true;
          winCtrlQ = false;
          winNativeTitleBar = false;
          windowsMaterial = "none";
          uiElements = {
            chatBarButtons = { };
            messagePopoverButtons = { };
          };
          plugins = {
            BadgeAPI.enabled = true;
            BetterGifAltText.enabled = true;
            BetterSessions = {
              backgroundCheck = true;
              checkInterval = 20;
              enabled = true;
            };
            BetterUploadButton.enabled = true;
            CallTimer = {
              enabled = true;
              format = "human";
            };
            ClearURLs.enabled = true;
            CommandsAPI.enabled = true;
            CopyFileContents.enabled = true;
            CrashHandler = {
              enabled = true;
              attemptToPreventCrashes = true;
              attemptToNavigateToHome = true;
            };
            Dearrow = {
              dearrowByDefault = true;
              enabled = true;
              hideButton = false;
              replaceElements = 0;
            };
            DisableDeepLinks.enabled = true;
            DynamicImageModalAPI.enabled = true;
            FakeNitro = {
              disableEmbedPermissionCheck = false;
              emojiSize = 48;
              enableEmojiBypass = true;
              enableStickerBypass = true;
              enableStreamQualityBypass = true;
              enabled = true;
              hyperLinkText = "{{NAME}}";
              stickerSize = 160;
              transformCompoundSentence = false;
              transformEmojis = true;
              transformStickers = true;
              useHyperLinks = true;
            };
            FavoriteEmojiFirst.enabled = true;
            FixImagesQuality = {
              enabled = true;
              originalImagesInChat = false;
            };
            FixSpotifyEmbeds = {
              enabled = true;
              volume = 50;
            };
            FriendsSince.enabled = true;
            FullSearchContext.enabled = true;
            GifPaste.enabled = true;
            GreetStickerPicker.enabled = true;
            HideMedia.enabled = true;
            LoadingQuotes = {
              additionalQuotes = "";
              additionalQuotesDelimiter = "|";
              enableDiscordPresetQuotes = false;
              enablePluginPresetQuotes = true;
              enabled = true;
              replaceEvents = true;
            };
            MemberCount = {
              enabled = true;
              memberList = true;
              toolTip = true;
              voiceActivity = true;
            };
            MemberListDecoratorsAPI.enabled = true;
            MentionAvatars = {
              enabled = true;
              showAtSymbol = true;
            };
            MessageAccessoriesAPI.enabled = true;
            MessageClickActions = {
              enableDeleteOnClick = true;
              enableDoubleClickToEdit = true;
              enableDoubleClickToReply = true;
              enabled = true;
              requireModifier = false;
            };
            MessageDecorationsAPI.enabled = true;
            MessageEventsAPI.enabled = true;
            MessageLinkEmbeds = {
              automodEmbeds = "prefer";
              enabled = true;
              idList = "";
              listMode = "blacklist";
              messageBackgroundColor = false;
            };
            MessageLogger = {
              collapseDeleted = true;
              deleteStyle = "overlay";
              enabled = true;
              ignoreBots = false;
              ignoreChannels = "";
              ignoreGuilds = "";
              ignoreSelf = true;
              ignoreUsers = "";
              inlineEdits = true;
              logDeletes = true;
              logEdits = true;
            };
            MessageUpdaterAPI.enabled = true;
            MoreCommands.enabled = true;
            MoreKaomoji.enabled = true;
            NoTrack = {
              disableAnalytics = true;
              enabled = true;
            };
            NormalizeMessageLinks.enabled = true;
            OpenInApp = {
              enabled = true;
              epic = true;
              itunes = true;
              spotify = true;
              steam = true;
              tidal = true;
            };
            PermissionsViewer = {
              enabled = true;
              permissionsSortOrder = 0;
            };
            PinDMs = {
              enabled = true;
              pinOrder = 2;
              canCollapseDmSection = false;
            };
            PlatformIndicators = {
              badges = true;
              colorMobileIndicator = true;
              enabled = true;
              list = true;
              messages = true;
            };
            QuickReply = {
              enabled = true;
              shouldMention = 2;
            };
            ReverseImageSearch.enabled = true;
            SendTimestamps = {
              enabled = true;
              replaceMessageContents = true;
            };
            ServerInfo.enabled = true;
            ServerListAPI.enabled = true;
            Settings = {
              enabled = true;
              settingsLocation = "aboveNitro";
              includeVencordInfoWhenCopying = true;
            };
            ShowHiddenChannels = {
              defaultAllowedUsersAndRolesDropdownState = true;
              enabled = true;
              hideUnreads = true;
              showMode = 0;
            };
            ShowTimeoutDuration = {
              displayStyle = "ssalggnikool";
              enabled = true;
            };
            SilentTyping = {
              contextMenu = true;
              enabled = true;
              isEnabled = true;
              showIcon = true;
            };
            SpotifyShareCommands.enabled = true;
            SupportHelper.enabled = true;
            Translate = {
              autoTranslate = false;
              deeplApiKey = "";
              enabled = true;
              receivedInput = "auto";
              receivedOutput = "en";
              sentInput = "auto";
              sentOutput = "en";
              service = "google";
              showAutoTranslateTooltip = true;
              showChatBarButton = true;
            };
            Unindent.enabled = true;
            UserSettingsAPI.enabled = true;
            ValidUser.enabled = true;
            ViewIcons = {
              enabled = true;
              format = "webp";
              imgSize = "1024";
            };
            VoiceChatDoubleClick.enabled = true;
            VoiceMessages = {
              enabled = true;
              noiseSuppression = true;
              echoCancellation = true;
            };
            WebContextMenus.enabled = true;
            WebKeybinds.enabled = true;
            WebScreenShareFixes.enabled = true;
            YoutubeAdblock.enabled = true;
            iLoveSpam.enabled = true;
            oneko.enabled = true;
            ChatInputButtonAPI.enabled = true;
            MessagePopoverAPI.enabled = true;
            CharacterCounter = {
              enabled = true;
              colorEffects = true;
            };
            ImageFilename = {
              enabled = true;
              showFullUrl = false;
            };
            ReviewDB = {
              enabled = true;
              notifyReviews = true;
              showWarning = true;
              hideTimestamps = false;
              hideBlockedUsers = true;
            };
            StreamerModeOnStream.enabled = true;
            WhoReacted.enabled = true;
            ConcatenatedComponentExtractor.enabled = true;
            AlwaysTrust.enabled = true;
            BetterFolders = {
              enabled = true;
              sidebar = true;
              sidebarAnim = true;
              closeAllFolders = true;
              closeAllHomeButton = true;
              closeOthers = true;
              forceOpen = false;
              keepIcons = true;
              showFolderIcon = 1;
            };
            BetterRoleDot = {
              enabled = true;
              bothStyles = true;
              copyRoleColorInProfilePopout = true;
            };
            BetterSettings = {
              enabled = true;
              eagerLoad = true;
              disableFade = true;
              organizeMenu = true;
            };
            BiggerStreamPreview.enabled = true;
            CopyUserURLs.enabled = true;
            DisableCallIdle.enabled = true;
            DontRoundMyTimestamps.enabled = true;
            FixCodeblockGap.enabled = true;
            FixYoutubeEmbeds.enabled = true;
            ForceOwnerCrown.enabled = true;
            FriendInvites.enabled = true;
            FullUserInChatbox.enabled = true;
            ImageZoom = {
              enabled = true;
              invertScroll = true;
              nearestNeighbour = false;
              saveZoomValues = false;
              size = 100;
              square = false;
              zoom = 2;
              zoomSpeed = { };
            };
            ImplicitRelationships = {
              enabled = true;
              sortByAffinity = true;
            };
            MutualGroupDMs.enabled = true;
            OnePingPerDM.enabled = true;
            PictureInPicture.enabled = true;
            PreviewMessage.enabled = true;
            ReadAllNotificationsButton.enabled = true;
            RelationshipNotifier = {
              enabled = true;
              friendRequestCancels = true;
              friends = true;
              groups = true;
              notices = true;
              offlineRemovals = true;
              servers = true;
            };
            ReplaceGoogleSearch = {
              customEngineName = "SearXNG";
              customEngineURL = "https://search.sndh.dev/search?q=";
              enabled = true;
            };
            ReplyTimestamp.enabled = true;
            RevealAllSpoilers.enabled = true;
            ShikiCodeblocks.enabled = true;
            ShowAllMessageButtons.enabled = true;
            ShowConnections = {
              enabled = true;
              iconSize = 32;
              iconSpacing = 1;
            };
            ShowHiddenThings = {
              enabled = true;
              showInvitesPaused = true;
              showModView = true;
              showTimeouts = true;
            };
            SilentMessageToggle.enabled = true;
            SortFriendRequests = {
              enabled = true;
              showDates = true;
            };
            SpotifyCrack.enabled = true;
            StartupTimings.enabled = true;
            StickerPaste.enabled = true;
            UserVoiceShow = {
              enabled = true;
              showInMemberList = true;
              showInMessages = true;
              showInUserProfileModal = true;
            };
            ValidReply.enabled = true;
            VolumeBooster = {
              enabled = true;
              multiplier = 2;
            };
          };
        };
      };
    };
  };
}
