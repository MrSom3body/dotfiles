{
  flake.modules.homeManager.office = {
    xdg.mimeApps = {
      associations.added = {
        "text/calendar" = "khal.desktop";
      };
      defaultApplications = {
        "text/calendar" = "khal.desktop";
      };
    };

    programs.khal = {
      enable = true;
      locale = {
        firstweekday = 0;
        weeknumbers = "off";
        unicode_symbols = true;
        dateformat = "%d.%m.%Y";
        timeformat = "%H:%M";
        datetimeformat = "%c";
        longdateformat = "%x";
        longdatetimeformat = "%c";
      };
      settings = {
        default = {
          default_dayevent_alarm = "12h";
          default_event_alarm = "30m";
          highlight_event_days = true;
        };
        highlight_days.color = "light blue";
      };
    };
  };
}
