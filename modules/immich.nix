{ config, ... }:
let
  inherit (config.flake) meta;
in
{
  flake.modules.nixos.immich = { config, ... }: {
    sops.secrets = {
      immich = {
        sopsFile = ../secrets/immich.env;
        format = "dotenv";
      };
      immich-oauth-secret.sopsFile = ../secrets/immich.yaml;
    };

    services = {
      immich = {
        enable = true;
        host = "127.0.0.1";
        inherit (meta.services.immich) port;
        secretsFile = config.sops.secrets.immich.path;
        settings = {
          backup.database = {
            cronExpression = "0 23 * * *";
          };
          ffmpeg = {
            accel = "vaapi";
            accelDecode = true;
            acceptedAudioCodecs = [
              "aac"
              "mp3"
              "opus"
            ];
            acceptedContainers = [
              "mov"
              "ogg"
              "webm"
            ];
            acceptedVideoCodecs = [ "h264" ];
            bframes = -1;
            cqMode = "auto";
            crf = 23;
            gopSize = 0;
            maxBitrate = "0";
            preferredHwDevice = "auto";
            preset = "ultrafast";
            refs = 0;
            targetAudioCodec = "aac";
            targetResolution = "720";
            targetVideoCodec = "h264";
            temporalAQ = false;
            threads = 0;
            tonemap = "hable";
            transcode = "required";
            twoPass = false;
          };
          image = {
            colorspace = "p3";
            extractEmbedded = false;
            fullsize = {
              enabled = false;
              format = "jpeg";
              quality = 80;
            };
            preview = {
              format = "jpeg";
              quality = 80;
              size = 1440;
            };
            thumbnail = {
              format = "webp";
              quality = 80;
              size = 250;
            };
          };

          integrityChecks = {
            checksumFiles = {
              cronExpression = "0 03 * * *";
              enabled = true;
              percentageLimit = 1;
              timeLimit = 3600000;
            };
            missingFiles = {
              cronExpression = "0 03 * * *";
              enabled = true;
            };
            untrackedFiles = {
              cronExpression = "0 03 * * *";
              enabled = true;
            };
          };

          job = {
            backgroundTask.concurrency = 5;
            editor.concurrency = 2;
            faceDetection.concurrency = 2;
            integrityCheck.concurrency = 1;
            library.concurrency = 5;
            metadataExtraction.concurrency = 5;
            migration.concurrency = 5;
            notifications.concurrency = 5;
            ocr.concurrency = 1;
            search.concurrency = 5;
            sidecar.concurrency = 5;
            smartSearch.concurrency = 2;
            thumbnailGeneration.concurrency = 3;
            videoConversion.concurrency = 1;
            workflow.concurrency = 5;
          };

          library = {
            scan = {
              cronExpression = "0 0 * * *";
              enabled = true;
            };
            watch.enabled = false;
          };

          logging = {
            enabled = true;
            level = "log";
          };

          machineLearning = {
            enabled = true;

            availabilityChecks = {
              enabled = true;
              interval = 30000;
              timeout = 2000;
            };

            clip = {
              enabled = true;
              modelName = "ViT-B-32__openai";
            };

            duplicateDetection = {
              enabled = true;
              maxDistance = 0.01;
            };

            facialRecognition = {
              enabled = true;
              maxDistance = 0.5;
              minFaces = 3;
              minScore = 0.7;
              modelName = "buffalo_l";
            };

            ocr = {
              enabled = true;
              maxResolution = 736;
              minDetectionScore = 0.5;
              minRecognitionScore = 0.8;
              modelName = "PP-OCRv5_mobile";
            };

            urls = [ "http://127.0.0.1:3003" ];
          };

          map = {
            enabled = true;
            darkStyle = "https://tiles.immich.cloud/v1/style/dark.json";
            lightStyle = "https://tiles.immich.cloud/v1/style/light.json";
          };

          metadata.faces.import = false;
          newVersionCheck.enabled = false;

          nightlyTasks = {
            clusterNewFaces = true;
            databaseCleanup = true;
            generateMemories = true;
            missingThumbnails = true;
            startTime = "01:00";
            syncQuotaUsage = true;
          };

          notifications.smtp = {
            enabled = false;
            from = "";
            replyTo = "";
            transport = {
              host = "";
              ignoreCert = false;
              password = "";
              port = 587;
              secure = false;
              username = "";
            };
          };

          oauth = {
            enabled = true;
            autoLaunch = false;
            autoRegister = true;
            buttonText = "Login with som3sso";
            clientId = "immich";
            clientSecret._secret = config.sops.secrets.immich-oauth-secret.path;
            defaultStorageQuota = null;
            issuerUrl = "${meta.services.kanidm.url}/oauth2/openid/immich";
            mobileOverrideEnabled = true;
            mobileRedirectUri = "${meta.services.immich.url}/api/oauth/mobile-redirect";
            profileSigningAlgorithm = "none";
            roleClaim = "immich.access";
            scope = "openid email profile";
            signingAlgorithm = "ES256";
            storageLabelClaim = "preferred_username";
            storageQuotaClaim = "immich_quota";
            timeout = 30000;
            tokenEndpointAuthMethod = "client_secret_post";
          };

          passwordLogin.enabled = false;
          reverseGeocoding.enabled = true;

          server = {
            externalDomain = meta.services.immich.url;
            loginPageMessage = "";
            publicUsers = false;
          };

          storageTemplate = {
            enabled = false;
            hashVerificationEnabled = true;
            template = "{{y}}/{{y}}-{{MM}}-{{dd}}/{{filename}}";
          };

          templates.email = {
            albumInviteTemplate = "";
            albumUpdateTemplate = "";
            welcomeTemplate = "";
          };

          theme.customCss = "";

          trash = {
            days = 30;
            enabled = true;
          };

          user.deleteDelay = 7;
        };
      };

      caddy.virtualHosts = {
        "${meta.services.immich.domain}" = {
          extraConfig = ''
            reverse_proxy http://localhost:${toString meta.services.immich.port}
          '';
        };
      };
    };

    users.users.immich.extraGroups = [
      "video"
      "render"
    ];
  };
}
