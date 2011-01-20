package com.emmet.util {
import com.emmet.model.Milestone;
import com.emmet.model.Timeline;

public class TimelineXmlParser {

  public function parse(xml:XML):Timeline {
    var result:Array = new Array();
    for each (var milestoneXml:XML in xml.milestone) {
      result.push(Milestone.fromXml(milestoneXml));
    }
    return new Timeline(result);
  }
}
}