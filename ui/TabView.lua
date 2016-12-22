local MarginGroup = require("ui.MarginGroup")

local widget = require("widget")

local TabView = {}

TabView.new = function(w, h, options)
	local marginSize = options and options.marginSize or 1
	local marginColor = options and options.marginColor or {1,1,1,1}
	local backgroundColor = options and options.backgroundColor or {1,1,1,1}
	local tabHeight = options and options.tabHeight or 20
	local contentHeight = h-marginSize*2-tabHeight

	local tabview = MarginGroup.new(w, h, options)

	local viewGroup = display.newGroup()

	local tabScoller = widget.newScrollView({
		width = w-marginSize*2,
		height = tabHeight,
		verticalScrollDisabled = true,
		backgroundColor = backgroundColor
	})

	local tabScollerContent = display.newGroup()

	tabScoller:insert(tabScollerContent)

	local contentContainer = display.newContainer(w-marginSize*2, contentHeight)
	contentContainer.content = nil

	tabScoller.x = 0
	tabScoller.y = (tabHeight-h+marginSize*2)/2
	viewGroup:insert(tabScoller)
	
	contentContainer.y = (h-marginSize*2-contentHeight)/2
	viewGroup:insert(contentContainer)

	tabview:insert(viewGroup)
	tabview.tabScoller = tabScoller
	tabview.tabScollerContent = tabScollerContent
	tabview.contentContainer = contentContainer
	tabview.contentHeight = contentHeight

	function tabview:insertTab(tabTitle, contentGroup)
		-- tab
		local tabGroup = display.newGroup()
		local tabText = display.newText(tabTitle, 0, 0, native.systemFont)
		local tabRect = display.newRect(0, 0, tabText.width+4, tabHeight-2)
		tabRect.fill = {1,1,1,0}
		tabRect.stroke = {1,1,1,0.5}
		tabRect.strokeWidth = 1
		tabGroup:insert(tabRect)
		tabGroup:insert(tabText)
		tabGroup.x = self.tabScollerContent.width+tabGroup.width/2
		tabGroup.y = tabGroup.height/2
		self.tabScollerContent:insert(tabGroup)

		-- tab click callback
		local function tapListener(event)
			if contentGroup then
				if self.contentContainer.content then
					self.contentContainer.content.isVisible = false
				end
				self.contentContainer.content = contentGroup
				contentGroup.isVisible = true
				print("change to tab:", tabTitle)
			end
		end
		tabGroup:addEventListener("tap", tapListener)

		-- content
		if contentGroup then
			self.contentContainer:insert(contentGroup)
			if not self.contentContainer.content then
				self.contentContainer.content = contentGroup
			else
				contentGroup.isVisible = false
			end
		end
	end

	function tabview:default()
		
	end

	return tabview
end

return TabView