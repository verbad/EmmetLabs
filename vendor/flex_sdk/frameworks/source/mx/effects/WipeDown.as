////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.effects
{

import mx.effects.effectClasses.WipeDownInstance;

/**
 *  The WipeDown class defines a bar wipe down effect.
 *  The before or after state of the component must be invisible. 
 * 
 *  <p>You often use this effect with the <code>showEffect</code> 
 *  and <code>hideEffect</code> triggers. The <code>showEffect</code> 
 *  trigger occurs when a component becomes visible by changing its 
 *  <code>visible</code> property from <code>false</code> to <code>true</code>. 
 *  The <code>hideEffect</code> trigger occurs when the component becomes 
 *  invisible by changing its <code>visible</code> property from 
 *  <code>true</code> to <code>false</code>.</p>
 *
 *  <p>This effect inherits the <code>MaskEffect.show</code> property. 
 *  If you set the value to <code>true</code>, the component appears. 
 *  If you set the value to <code>false</code>, the component disappears. 
 *  The default value is <code>true</code>.</p>
 *
 *  <p>If you specify this effect for a <code>showEffect</code> or 
 *  <code>hideEffect</code> trigger, Flex sets the <code>show</code> property 
 *  for you, either to <code>true</code> if the component becomes invisible, 
 *  or <code>false</code> if the component becomes visible.</p> 
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;mx:WipeDown&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:WipeDown
 *    id="ID"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.effects.effectClasses.WipeDownInstance
 *  
 *  @includeExample examples/WipeDownExample.mxml
 */
public class WipeDown extends MaskEffect
{
    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param target The Object to animate with this effect.
	 */
	public function WipeDown(target:Object = null)
	{
		super(target);

		instanceClass = WipeDownInstance;
	}
}

}
