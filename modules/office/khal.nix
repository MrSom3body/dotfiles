{
  flake.modules.homeManager.office = {
    xdg.mimeApps = {
      associations.added = {
        "text/calendar" = "khal-import.desktop";
      };
      defaultApplications = {
        "text/calendar" = "khal-import.desktop";
      };
    };

    xdg.desktopEntries."khal-import" = {
      name = "Khal Import";
      exec = "khal import %f";
      terminal = true;
      mimeType = [ "text/calendar" ];
      icon = "x-office-calendar";
      noDisplay = true;
    };

    programs.khal = {
      enable = true;
      locale = {
        firstweekday = 0;
        weeknumbers = "off";
        unicode_symbols = true;
        timeformat = "%H:%M";
        dateformat = "%d.%m.";
        longdateformat = "%d.%m.%Y";
        datetimeformat = "%d.%m. %H:%M";
        longdatetimeformat = "%d.%m.%Y %H:%M";
      };
      settings = {
        default = {
          default_dayevent_alarm = "12h";
          default_event_alarm = "30m";
          highlight_event_days = true;
        };
        view = {
          agenda_event_format = "{calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}";
          event_view_always_visible = true;
          frame = "color";
        };
      };
    };
  };
}
