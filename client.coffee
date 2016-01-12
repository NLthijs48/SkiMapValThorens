Db = require 'db'
Dom = require 'dom'
Modal = require 'modal'
Obs = require 'obs'
Plugin = require 'plugin'
Page = require 'page'
Server = require 'server'
Ui = require 'ui'
Photoview = require 'photoview'

maps = Obs.create
	valThorens:
		button: 'Val Thorens'
		image: 'valthorens.jpg'
		order: 1
	troisVallees:
		button: 'Les 3 Vallees'
		image: 'les3vallees.jpg'
		order: 2
	#troisValleesOld:
	#	button: 'Les 3 Vallees Old'
	#	image: 'les3vallees-old.jpg'
	#	order: 3
	#onlineMap:
	#	button: '3D map'
	#	link: 'http://www.les3vallees.com/en/ski-area/ski-in-les-3-vallees'
	#	order: 3
	sneeuwHoogte:
		button: 'Sneeuwhoogte'
		link: 'https://www.sneeuwhoogte.nl/wintersport/frankrijk/savoie/les%20trois%20vall%C3%A9es/val%20thorens'
		order: 3
currentPage = Obs.create 'valThorens'

exports.render = !->
	Dom.style ChildMargin: '0', overflow: 'hidden'
	Dom.div !->
		Dom.style
			height: '100%'
			position: 'relative'
		renderPages()

renderButtons = !->
	Dom.div !->
		Dom.style
			Box: 'horizontal center'
			position: 'absolute'
			bottom: 0
			right: 0
			left: 0
			margin: '0 -1px 0 -1px'
		Dom.css '.areaButton.tap':
			background: 'linear-gradient(to bottom, #4fa7ff 0%,#0277ed 100%) !important'
		# Render buttons
		renderButton = (area) !->
			drawButton = !->
				Dom.cls 'areaButton'
				Dom.style
					Flex: true
					textAlign: 'center'
					height: '34px'
					lineHeight: '34px'
					background: 'linear-gradient(to bottom, #7abcff 0%,#4096ee 100%)'
					color: '#FFFFFF'
					borderRight: '1px solid #FFFFFF'
					borderLeft: '1px solid #FFFFFF'
					padding: '8px'
					whiteSpace: 'nowrap'
				if currentPage.get() is area.key()
					Dom.style background: 'linear-gradient(to bottom, #4fa7ff 0%,#0277ed 100%)'
				Dom.text area.get('button')
				if area.get('image')
					# Move to page
					Dom.onTap !->
						currentPage.set area.key()
				else if area.get('link')
					# Link icon
					Icon.render
						data: 'chain2'
						size: 16
						color: '#FFF'
						style:
							margin: '0 0 -2px 5px'

			if area.get('image')
				Dom.div drawButton
			else if area.get('link')
				Dom.link area.get('link'), drawButton

		maps.iterate (area) !->
			renderButton area
		, (area) ->
			area.get('order')||0

renderPages = !->
	maps.iterate (area) !->
		return if !area.get('image') # Ignore links
		Dom.div !->
			Dom.style
				position: 'absolute'
				top: 0
				right: 0
				bottom: 0
				left: 0
			Obs.observe !->
				if currentPage.get() is area.key()
					Dom.style display: 'block'
				else
					Dom.style display: 'none'
			Photoview.render
				url: Plugin.resourceUri(area.get('image'))
				fullHeight: true
				height: Page.height()+Page.customTop(0)-50 # Height of the page minues the buttons
				enterFullscreen: false
				content: !->
					return if maps.count().peek() <= 1
					Dom.style transform: "translate3d(0,0,0)" # Draw over the image
	renderButtons()
