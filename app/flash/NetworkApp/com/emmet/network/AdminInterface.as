package com.emmet.network {
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.text.TextFieldType;
  import com.emmet.model.RelationshipGroup;

  public class AdminInterface extends Sprite {
    private var _friction:ParameterField;
    private var _velocityCutoff:ParameterField;
    private var _rootNodeRepulsion:ParameterField;

    private var _supergroupNodeRepulsion:ParameterField;
    private var _supergroupTetherLength:ParameterField;
    private var _supergroupTetherSpring:ParameterField;
    private var _supergroupPlacementRadius:ParameterField;
    private var _relationshipGroupNodeRepulsion:ParameterField;
    private var _relationshipGroupTetherLength:ParameterField;
    private var _relationshipGroupTetherSpring:ParameterField;
    private var _relationshipGroupPlacementRadius:ParameterField;

    private var _directedRelationshipNodeRepulsion:ParameterField;
    private var _directedRelationshipTetherLength:ParameterField;
    private var _directedRelationshipTetherSpring:ParameterField;
    private var _directedRelationshipPlacementRadius:ParameterField;

    private var _personNodeRepulsion:ParameterField;
    private var _personTetherLength:ParameterField;
    private var _personTetherSpring:ParameterField;
    private var _personPlacementRadius:ParameterField;

    private static const SEPARATION:Number = 25;
    private var _parameterFieldPosition:Number;

    public function AdminInterface() {
      graphics.beginFill(0, 0.5);
      graphics.drawRect(0, 0, 250, 500);

      _parameterFieldPosition = 0;

      _friction = new ParameterField("Friction:", NetworkWorld.__friction);
      addParameterField(_friction);

      _rootNodeRepulsion = new ParameterField("Root Repulsion:", NetworkView.__rootNodeRepulsion);
      addParameterField(_rootNodeRepulsion);

      _supergroupNodeRepulsion = new ParameterField("Supercategory Repulsion:", RelationshipSupergroupView.__nodeRepulsion);
      addParameterField(_supergroupNodeRepulsion);
      _supergroupTetherLength = new ParameterField("Supercategory Tether Length:", RelationshipSupergroupView.__tetherLength);
      addParameterField(_supergroupTetherLength);
      _supergroupTetherSpring = new ParameterField("Supercategory Tether Tension:", RelationshipSupergroupView.__tetherSpring);
      addParameterField(_supergroupTetherSpring);
      _supergroupPlacementRadius = new ParameterField("Supercategory Placement Radius:", RelationshipSupergroupView.__placementRadius);
      addParameterField(_supergroupPlacementRadius);

      _relationshipGroupNodeRepulsion = new ParameterField("Category Repulsion:", RelationshipGroupView.__nodeRepulsion);
      addParameterField(_relationshipGroupNodeRepulsion);
      _relationshipGroupTetherLength = new ParameterField("Category Tether Length:", RelationshipGroupView.__tetherLength);
      addParameterField(_relationshipGroupTetherLength);
      _relationshipGroupTetherSpring = new ParameterField("Category Tether Tension:", RelationshipGroupView.__tetherSpring);
      addParameterField(_relationshipGroupTetherSpring);
      _relationshipGroupPlacementRadius = new ParameterField("Category Placement Radius:", RelationshipGroupView.__placementRadius);
      addParameterField(_relationshipGroupPlacementRadius);

      _directedRelationshipNodeRepulsion = new ParameterField("Ball Repulsion:", DirectedRelationshipView.__nodeRepulsion);
      addParameterField(_directedRelationshipNodeRepulsion);
      _directedRelationshipTetherLength = new ParameterField("Ball Tether Length:", DirectedRelationshipView.__tetherLength);
      addParameterField(_directedRelationshipTetherLength);
      _directedRelationshipTetherSpring= new ParameterField("Ball Tether Elasticity:", DirectedRelationshipView.__tetherSpring);
      addParameterField(_directedRelationshipTetherSpring);
      _directedRelationshipPlacementRadius = new ParameterField("Ball Placement Radius:", DirectedRelationshipView.__placementRadius);
      addParameterField(_directedRelationshipPlacementRadius);

      _personNodeRepulsion = new ParameterField("Name Repulsion:", PersonView.__nodeRepulsion);
      addParameterField(_personNodeRepulsion);
      _personTetherLength = new ParameterField("Name Tether Length:", PersonView.__tetherLength);
      addParameterField(_personTetherLength);
      _personTetherSpring = new ParameterField("Name Tether Elasticity:", PersonView.__tetherSpring);
      addParameterField(_personTetherSpring);
      _personPlacementRadius = new ParameterField("Name Placement Radius:", PersonView.__placementRadius);
      addParameterField(_personPlacementRadius);
    }

    public function addParameterField(parameterField:ParameterField):void {
      addChild(parameterField);
      parameterField.y = _parameterFieldPosition;
      _parameterFieldPosition += SEPARATION;
    }

    public function apply():void {
      NetworkWorld.__friction = _friction.value;
      NetworkView.__rootNodeRepulsion = _rootNodeRepulsion.value;

      RelationshipSupergroupView.__nodeRepulsion = _supergroupNodeRepulsion.value;
      RelationshipSupergroupView.__tetherLength = _supergroupTetherLength.value;
      RelationshipSupergroupView.__tetherSpring = _supergroupTetherSpring.value;
      RelationshipSupergroupView.__placementRadius = _supergroupPlacementRadius.value;

      RelationshipGroupView.__nodeRepulsion = _relationshipGroupNodeRepulsion.value;
      RelationshipGroupView.__tetherLength = _relationshipGroupTetherLength.value;
      RelationshipGroupView.__tetherSpring = _relationshipGroupTetherSpring.value;
      RelationshipGroupView.__placementRadius = _relationshipGroupPlacementRadius.value;

      DirectedRelationshipView.__nodeRepulsion = _directedRelationshipNodeRepulsion.value;
      DirectedRelationshipView.__tetherLength = _directedRelationshipTetherLength.value;
      DirectedRelationshipView.__tetherSpring = _directedRelationshipTetherSpring.value;
      DirectedRelationshipView.__placementRadius = _directedRelationshipPlacementRadius.value;

      PersonView.__nodeRepulsion = _personNodeRepulsion.value;
      PersonView.__tetherLength = _personTetherLength.value;
      PersonView.__tetherSpring = _personTetherSpring.value;
      PersonView.__placementRadius = _personPlacementRadius.value;
    }
  }
}