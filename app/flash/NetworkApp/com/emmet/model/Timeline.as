package com.emmet.model {

  public class Timeline {
    private var _milestones:Array;
    public function Timeline(milestones:Array) {
      _milestones = milestones.sort(function(milestone1:Milestone, milestone2:Milestone):Number {
                                      return milestone1.date.getTime() - milestone2.date.getTime();
                                    });
    }

    public function get milestones():Array { return _milestones; }

    public function proportionFor(milestone:Milestone):Number {
      if (_milestones.length <= 1) {
        return 0;
      }
      var startMillis:Number = _milestones[0].date.getTime();
      var endMillis:Number = _milestones[_milestones.length - 1].date.getTime();
      return (milestone.date.getTime() - startMillis) / (endMillis - startMillis);
    }
  }
}