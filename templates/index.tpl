<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<title>Single Friends</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="css/style.css" type="text/css" media="screen"/>
		<style>
			span.reference{
				position:fixed;
				left:10px;
				bottom:10px;
				font-size:11px;
			}
			span.reference a{
				color:#555;
				text-decoration:none;
				text-shadow:1px 1px 1px #fff;
			}
			span.reference a:hover{
				color:#000;
			}
			h1.title{
				text-indent:-9000px;
				position:absolute;
				top:0px;
				left:0px;
				width:563px;
				height:88px;
				background:transparent url(images/title.png) no-repeat top left;
			}
		</style>
	</head>
	<body>
		<div>
			<span class="reference">
				<b>Single Friends v0.1</b><br />
				Created by&nbsp;<a href="http://www.facebook.com/590577018" target="_blank">Barbayar Dashzeveg</a><br />
				Source Code on&nbsp;<a href="https://github.com/Barbayar/Single-Friends" target="_blank">GitHub</a><br />
				Supported by&nbsp;<a href="http://developers.facebook.com/docs/reference/api" target="_blank">Graph API</a>&nbsp;&amp;&nbsp;
				<a href="https://developers.facebook.com/docs/reference/php" target="_blank">Facebook SDK for PHP</a>&nbsp;&amp;&nbsp;
				<a href="http://tympanus.net/codrops/2010/07/01/interactive-photo-desk" target="_blank">Interactive Photo Desk</a>&nbsp;&amp;&nbsp;
				<a href="http://www.smarty.net" target="_blank">Smarty</a>
			</span>
		</div>

		<div>
			<a id="pd_loading" href="#" class="pd_loading"></a>
		</div>

		<div id="pd_container" class="pd_container">
			{{foreach from = $friendList item = friend}}
			<div class="pd_photo">
				<div class="pd_hold">
					<a href="{{$friend["profile_url"]}}" target="_blank">
						<img src="{{$friend["pic_big"]}}" />
					</a><br />
					{{$friend["name"]|escape}}
				</div>
			</div>
			{{/foreach}}
		</div>

		<!-- The JavaScript -->
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
		<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.2/jquery-ui.min.js"></script>
		<script src="js/jquery.transform-0.6.2.min.js"></script>
		<script src="js/jquery.animate-shadow-min.js"></script>
		<script type="text/javascript">
			$(function() {
				/**
				 * idx:
				 * index of photo that is currently hold
				 * idxLarge:
				 * index of photo that is currently on full mode
				 * mouseup:
				 * flag to use on the mouseup and mousedown events,
				 * to help preventing the browser default selection of elements
				 */
				var idx,idxLarge	= -1;
				var mouseup 		= false;
				
				/**
				 * for now we hardcode the values of our thumb containers
				 */
				var photoW			= 184;
				var photoH			= 205;
				
				/**
				 * the photos and options container
				 */
				var $container 		= $('#pd_container');
				
				var $options		= $('#pd_options_bar');
				
				var photosSize 		= $container.find('.pd_photo').length;
				
				/**
				 * navigation current step
				 */
				var navPage			= 0;
				/**
				 * spreads the photos on the table..
				 */
				
				var ie 				= false;
				if ($.browser.msie) {
					ie = true;
				}
				
				start();
				
				function start(){
					$('#pd_loading').show();
					
					var tableW 			= $container.width();
					var tableH 			= $container.height();
					
					var horizontalMax	= tableW - photoW;
					var verticalMax		= tableH - photoH;
					
					$('<img />').attr('src','images/paperball.png');
					/**
					* display all the photos on the desk, with a random rotation,
					 * and also make them draggable.
					 * on mouse down, we want the photo to enlarge in a few pixels,
					 * and to rotate 0 degrees
					 */
					var cntPhotos = 0;
					$container.find('.pd_photo').each(function(i){
						var $photo 	= $(this);
						$('<img />').load(function(){
							++cntPhotos;
							var $image 	= $(this);
							
						var r		= Math.floor(Math.random()*201)-100;//*41
						var maxzidx = parseInt(findHighestZIndex()) + 1;
						var param	= {
							'top' 		: Math.floor(Math.random()*verticalMax) +'px',       
							'left'		: Math.floor(Math.random()*horizontalMax) +'px',
								'z-index'	: maxzidx
						};
							
							$photo.css(param);
							if(!ie)
								$photo.transform({'rotate'	: r + 'deg'});
							$photo.show();	
							if(cntPhotos == photosSize){
					bindEvents();
								$('#pd_loading').hide();
							}
						}).attr('src',$photo.find('img').attr('src'));	
					});	
				}
				
				/**
				 * grab a photo
				 */
				function mouseDown($photo){
					mouseup 	= true;
					idx			= $photo.index() + 1;
					var maxzidx = parseInt(findHighestZIndex()) + 1;
					$photo.css('z-index',maxzidx);
					if(ie)
					var param = {
						'width'		: '+=40px',
						'height'	: '+=40px'
					};
					else
					var param = {
						'width'		: '+=40px',
						'height'	: '+=40px',
						'rotate'	: '0deg',
						'shadow'	: '5px 5px 15px #222'
					};
					$photo.stop(true,true).animate(param,100).find('img').stop(true,true).animate({
						'width'		: '+=40px',
						'height'	: '+=40px'
					},100);
				}
				
				/**
				 * we do the mouseup on the document to prevent the
				 * case when we release the mouse outside of a photo.
				 * also, we want the photo to get smaller again,
				 * rotate some random degrees, and also move it some pixels
				 */
				$(document).bind('mouseup',function(e){
					if(mouseup){
						mouseup 	= false;
						var $photo 	= $container.find('.pd_photo:nth-child('+idx+')');
						var r		= Math.floor(Math.random()*101)-50;
						var $photoT	= parseFloat($photo.css('top'),10);
						var $photoL	= parseFloat($photo.css('left'),10);
						var newTop	= $photoT + r;
						var newLeft	= $photoL + r;
						if(ie)
						var param = {
							'width'		: '-=40px',
							'height'	: '-=40px',
							'top'		: newTop + 'px', 
							'left'		: newLeft + 'px'
						};
						else
						var param = {
							'width'		: '-=40px',
							'height'	: '-=40px',
							'top'		: newTop + 'px',
							'left'		: newLeft + 'px',
							'rotate'	: r+'deg',
							'shadow'	: '0 0 5px #000'
						};
						$photo.stop(true,true).animate(param,200).find('img').stop(true,true).animate({
							'width'	: '-=40px',
							'height': '-=40px'
						},200);
					}
					e.preventDefault();
				});
				
				/**
				 * removes the photo element from the DOM,
				 * after showing the paper image..
				 */
				$container.find('.delete').bind('click',function(){
					var $photo 			= $(this).parent();
					var $photoT			= parseFloat($photo.css('top'),10);
					var $photoL			= parseFloat($photo.css('left'),10);
					var $photoZIndex	= $photo.css('z-index');
					var $trash = $('<div />',{
						'className'	: 'pd_paperball',
						'style'		: 'top:' + parseInt($photoT + photoH/2) + 'px;left:' + parseInt($photoL + photoW/2) +'px;width:0px;height:0px;z-index:' + $photoZIndex
					}).appendTo($container);
					
					$trash.animate({
						'width'	: photoW + 'px',
						'height': photoH + 'px',
						'top'	: $photoT + 'px',
						'left'	: $photoL + 'px'
					},100,function(){
						var $this = $(this);
						setTimeout(function(){
							$this.remove();
						},800);
					});
					$photo.animate({
						'width'	: '0px',
						'height': '0px',
						'top'	: $photoT + photoH/2 + 'px',
						'left'	: $photoL + photoW/2 +'px'
					},200,function(){
						--photosSize;
						$(this).remove();
					});
				});
				
				function stack(){
					navPage 		= 0;
					var cnt_photos 	= 0;
					var windowsW 		= $(window).width();
					var windowsH 		= $(window).height();
					$container.find('.pd_photo').each(function(i){
						var $photo 	= $(this);
						$photo.css('z-index',parseInt(findHighestZIndex()) + 1000 + i)
						.stop(true)
						.animate({
							'top'	: parseInt((windowsH-100)/2 - photoH/2) + 'px',
							'left'	: parseInt((windowsW-100)/2 - photoW/2) + 'px'
						},800,function(){
							$options.find('.backdesk').show();
							var $photo = $(this);
							++cnt_photos;
							var $nav 	= $('<a class="pd_next_photo" style="display:none;"></a>');
							$nav.bind('click',function(){
								navigate();
								$(this).remove();
							});
							$photo.prepend($nav);
							$photo.draggable('destroy')
							.find('.delete')
							.hide()
							.andSelf()
							.find('.pd_hold')
							.unbind('mousedown')
							.bind('mousedown',function(){return false;});
								  
							$photo.unbind('mouseenter')
							.bind('mouseenter',function(){
								$nav.show();
							})
							.unbind('mouseleave')
							.bind('mouseleave',function(){
								$nav.hide();
							});
							$options.find('.shuffle,.viewall').unbind('click');
							if(cnt_photos == photosSize)
								enlarge(findElementHighestZIndex());
						});
					});
				}
				
				function enlarge($photo){
					var windowsW 		= $(window).width();
					var windowsH 		= $(window).height();
					if(ie)
					var param = {
						'width'	: '+=200px',
						'height': '+=200px',
						'top'	: parseInt((windowsH-100)/2 - (photoH+200)/2) + 'px', 
						'left'	: parseInt((windowsW-100)/2 - (photoW+200)/2) + 'px'
					};
					else
					var param = {
						'width'	: '+=200px',
						'height': '+=200px',
						'top'	: parseInt((windowsH-100)/2 - (photoH+200)/2) + 'px',
						'left'	: parseInt((windowsW-100)/2 - (photoW+200)/2) + 'px',
						'rotate': '0deg',
						'shadow': '5px 5px 15px #222'
					};
					$photo.animate(param,500,function(){
						idxLarge = $(this).index();
					}).find('img').animate({
						'width'	: '+=200px',
						'height': '+=200px'
					},500);
				}
				
				/**
				 * back to desk
				 */
				function disperse(){
					var windowsW 		= $(window).width();
					var windowsH 		= $(window).height();
					
					$container.find('.pd_photo').each(function(i){
						var $photo 		= $(this);
						//if it is the current large photo:
						if($photo.index() == idxLarge){
							if(ie)
							var param = {
								'top'		: parseInt((windowsH-100)/2 - photoH/2) + 'px', 
								'left'		: parseInt((windowsW-100)/2 - photoW/2) + 'px',
								'width'		: '170px',
								'height'	: '170px'
							};
							else
							var param = {
								'top'		: parseInt((windowsH-100)/2 - photoH/2) + 'px', 
								'left'		: parseInt((windowsW-100)/2 - photoW/2) + 'px',
								'width'		: '170px',
								'height'	: '170px',
								'shadow'	: '1px 1px 5px #555'
							};
							$photo.stop(true).animate(param,500, function(){
								shuffle();
								$options.find('.viewall').show();
							}).find('img').animate({
								'width'		: '170px',
								'height'	: '170px'
							},500);
						}
					});
					$container.find('.pd_next_photo').remove();
					bindEvents();
				}
				
				function bindEvents(){
					$options.find('.shuffle').unbind('click').bind('click',function(e){
						if(photosSize == 0) return;
						shuffle();
						e.preventDefault();
					}).andSelf().find('.viewall').unbind('click').bind('click',function(e){
						var $this = $(this);
						if(photosSize == 0) return;
						stack();
						$this.hide();
						e.preventDefault();
					}).andSelf().find('.backdesk').unbind('click').bind('click',function(e){
						var $this = $(this);
						if(photosSize == 0) return;
						disperse();
						$this.hide();
						e.preventDefault();
					});
					
					$container.find('.pd_photo').each(function(i){
						var $photo = $(this);
						$photo.draggable({
							containment	: '#pd_container'
						}).find('.delete')
						.show()
					}).find('.pd_hold').unbind('mousedown').bind('mousedown',function(e){
						var $photo 	= $(this).parent();
						mouseDown($photo);
						e.preventDefault();
					});
				}
				
				function navigate(){
					if(photosSize == 0) return;
					
					var tableW 			= $container.width();
					var tableH 			= $container.height();
					
					var horizontalMax	= tableW - photoW;
					var verticalMax		= tableH - photoH;
					
					var $photo 			= $container.find('.pd_photo:nth-child('+parseInt(idxLarge+1)+')');
					var r				= Math.floor(Math.random()*201)-100;//*41
					if(ie)
					var param = {
						'top' 		: Math.floor(Math.random()*verticalMax) +'px',       
						'left'		: Math.floor(Math.random()*horizontalMax) +'px',
						'width'		: '170px',
						'height'	: '170px'
					};
					else
					var param = {
						'top' 		: Math.floor(Math.random()*verticalMax) +'px',
						'left'		: Math.floor(Math.random()*horizontalMax) +'px',
						'width'		: '170px',
						'height'	: '170px',
						'rotate'	: r+'deg',
						'shadow'	: '1px 1px 5px #555'
					};
					$photo.stop(true).animate(param,500,function(){
						++navPage;
						var $photo = $(this);
						
						$container.append($photo.css('z-index',1));
						if(navPage < photosSize)
							enlarge(findElementHighestZIndex());
						else{ //last one
							$options.find('.backdesk').hide();
							$options.find('.viewall').show();
							bindEvents();
						}
					}).find('img').animate({
						'width'		: '170px',
						'height'	: '170px'
					},500);
				}
				
				function shuffle(){
					var tableW 			= $container.width();
					var tableH 			= $container.height();
					
					var horizontalMax	= tableW - photoW;
					var verticalMax		= tableH - photoH;
					$container.find('.pd_photo').each(function(i){
						var $photo = $(this);
						var r		= Math.floor(Math.random()*301)-100;//*41
						if(ie)
						var param = {
							'top' 		: Math.floor(Math.random()*verticalMax) +'px',       
							'left'		: Math.floor(Math.random()*horizontalMax) +'px'
						};
						else
						var param = {
							'top' 		: Math.floor(Math.random()*verticalMax) +'px',
							'left'		: Math.floor(Math.random()*horizontalMax) +'px',
							'rotate'	: r+'deg'
						};
						$photo.animate(param,800);	
					});
				}
				
				function findHighestZIndex(){
					var photos = $container.find('.pd_photo');
					var highest = 0;
					photos.each(function(){
						var $photo = $(this);
						var zindex = $photo.css('z-index');
						if (parseInt(zindex) > highest) {
							highest = zindex;
						}
					});
					return highest;
				}
				
				function findElementHighestZIndex(){
					var photos = $container.find('.pd_photo');
					var highest = 0;
					var $elem;
					photos.each(function(){
						var $photo = $(this);
						var zindex = $photo.css('z-index');
						if (parseInt(zindex) > highest) {
							highest = zindex;
							$elem	= $photo;
						}
					});
					return $elem;
				}
				
				// Array Remove - By John Resig (MIT Licensed)
				Array.prototype.remove = function(from, to) {
					var rest = this.slice((to || from) + 1 || this.length);
					this.length = from < 0 ? this.length + from : from;
					return this.push.apply(this, rest);
				};
			});
		</script>
	</body>
</html>
