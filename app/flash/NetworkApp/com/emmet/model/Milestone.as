package com.emmet.model {
  public class Milestone {
    private var _name:String;
    private var _formattedDate:String;
    private var _fuzzyDate:Date;
    private var MONTH_LABLES:Array = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

    public static function fromXml(milestoneXml:XML):Milestone {
      var yearString:String = milestoneXml.date.year;
      var monthString:String = milestoneXml.date.month;
      var dayString:String = milestoneXml.date.day;
      var dateIsEstimate:Boolean = milestoneXml.date.estimate == "true";
      var name:String = milestoneXml.name;
      return new Milestone(yearString, monthString, dayString, dateIsEstimate, name);
    }

    public function Milestone(yearString:String, monthString:String, dayString:String, dateIsEstimate:Boolean, name:String) {
      _formattedDate = "";
      if (dateIsEstimate) {
        _formattedDate += "Circa ";
      }
      if (monthString.length > 0) {
        _formattedDate += (MONTH_LABLES[(int(monthString)) - 1] + " ")
      }
      if (dayString.length > 0) {
        _formattedDate += (dayString + ", ");
      }
      _formattedDate += Math.abs(int(yearString));

      if (int(yearString) < 0) {
        _formattedDate += ' BCE';
      }

      _fuzzyDate = new Date();
      _fuzzyDate.fullYear = int(yearString);
      _fuzzyDate.month = monthString.length>0 ? int(monthString) - 1 : 0;
      _fuzzyDate.date = dayString.length>0 ? int(dayString) : 1;

      _name = name;
    }

    public function get date():Date { return _fuzzyDate;}
    public function get name():String { return _name; }
    public function get formattedDate():String { return _formattedDate; }

    public function displayLabel():String {
      return formattedDate + "\n" + name;
    }

  }
}