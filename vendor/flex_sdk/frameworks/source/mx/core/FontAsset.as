////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.core
{

import flash.text.Font;

/**
 *  FontAsset is a subclass of the Flash Player's Font class 
 *  which represents fonts that you embed in a Flex application.
 *
 *  <p>The font that you're embedding can be in a TrueType (TTF) file.
 *  You can also embed a system font or a font that is in a SWF file
 *  produced by Flash.
 *  In each of these cases, the MXML compiler autogenerates a class
 *  that extends FontAsset to represent the embedded font.</p>
 *
 *  <p>You don't generally have to use the FontAsset class directly
 *  when you write a Flex application.
 *  For example, you can embed a font using the @font-face CSS selector
 *  without having to understand that the MXML compiler has created
 *  a sublcass of FontAsset for you.</p>
 *
 *  <p>However, it may be useful to understand what is happening
 *  at the ActionScript level.
 *  To embed a font in ActionScript, you declare a variable
 *  of type Class, and put <code>[Embed]</code> metadata on it.
 *  For example, you embed a TTF file like this:</p>
 *
 *  <pre>
 *  [Embed(source="Fancy.ttf", fontName="Fancy")] 
 *  var fancyClass:Class;
 *  </pre>
 *
 *  <p>The MXML compiler sees the .ttf extension, transcodes the TTF data
 *  into the font format that the Flash Player uses, autogenerates
 *  a subclass of the FontAsset calss, and sets your variable
 *  to be a reference to this autogenerated class.
 *  You can then use this class reference to create instances of the
 *  FontAsset using the <code>new</code> operator, and you can use
 *  APIs of the Font class on them:</p>
 *
 *  <pre>
 *  var fancyFont:FontAsset = FontAsset(new fancyClass());
 *  var hasDigits:Boolean = fancyFont.hasGlyphs("0123456789");
 *  </pre>
 *
 *  <p>However, you rarely need to create FontAsset instances yourself
 *  because you simply use the <code>fontName</code> that you specify
 *  in the <code>[Embed]</code> metadata to refer to the font; for example,
 *  you set the <code>fontFamily</code> CSS style to the font name,
 *  <code>"Fancy"<,code>, not to a FontAsset instance such as
 *  <code>fancyFont</code> or to the <code>fancyClass</code>
 *  class reference:</p>
 *
 *  <pre>
 *  &lt;mx:Label text="Thank you for your order." fontFamily="Fancy"/&gt;
 *  </pre>
 */
public class FontAsset extends Font implements IFlexAsset
{
	include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 */
	public function FontAsset()
	{
		super();
	}
}

}
