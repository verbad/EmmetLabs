////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) 2003-2006 Adobe Macromedia Software LLC and its licensors.
//  All Rights Reserved. The following is Source Code and is subject to all
//  restrictions on such code as contained in the End User License Agreement
//  accompanying this product.
//
////////////////////////////////////////////////////////////////////////////////

package mx.preloaders
{

import flash.display.Sprite;
import flash.events.IEventDispatcher;

/**
 *  The IPreloaderDisplay interface defines the inteface that 
 *  a class must implement to be used as a download progress bar.
 *  The IPreloaderDisplay receives events from the Preloader class
 *  and is responsible to visualizing that information to the user.
 *
 *  @see mx.preloaders.DownloadProgressBar
 *  @see mx.preloaders.Preloader
 */
public interface IPreloaderDisplay extends IEventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  backgroundAlpha
	//----------------------------------

	/**
	 *  @copy mx.preloaders.DownloadProgressBar#backgroundAlpha
	 */
	function get backgroundAlpha():Number;
	
	/**
	 *  @private
	 */
	function set backgroundAlpha(value:Number):void;
	
	//----------------------------------
	//  backgroundColor
	//----------------------------------

	/**
	 *  @copy mx.preloaders.DownloadProgressBar#backgroundColor
	 */	
	function get backgroundColor():uint;
	
	/**
	 *  @private
	 */
	function set backgroundColor(value:uint):void;
	
	//----------------------------------
	//  backgroundImage
	//----------------------------------

	/**
	 *  @copy mx.preloaders.DownloadProgressBar#backgroundImage
	 */
	function get backgroundImage():Object;
	
	/**
	 *  @private
	 */
	function set backgroundImage(value:Object):void;

	//----------------------------------
	//  backgroundSize
	//----------------------------------

	/**
	 *  @copy mx.preloaders.DownloadProgressBar#backgroundSize
	 */
	function get backgroundSize():String;
	
	/**
	 *  @private
	 */
	function set backgroundSize(value:String):void;

	//----------------------------------
	//  preloader
	//----------------------------------

	/**
	 *  @copy mx.preloaders.DownloadProgressBar#preloader
	 */
	function set preloader(obj:Sprite):void;
	
	//----------------------------------
	//  stageHeight
	//----------------------------------

	/**
	 *  @copy mx.preloaders.DownloadProgressBar#stageHeight
	 */
	function get stageHeight():Number;
	
	/**
	 *  @private
	 */
	function set stageHeight(value:Number):void;
	
	//----------------------------------
	//  stageWidth
	//----------------------------------

	/**
	 *  @copy mx.preloaders.DownloadProgressBar#stageWidth
	 */
	function get stageWidth():Number;
	
	/**
	 *  @private
	 */
	function set stageWidth(value:Number):void;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @copy mx.preloaders.DownloadProgressBar#initialize()
	 */
	function initialize():void;
}

}
