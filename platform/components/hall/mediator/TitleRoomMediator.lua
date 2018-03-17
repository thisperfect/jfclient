--仅作为房间列表用的Title顶部工具栏

local Mediator = cc.load("puremvc").Mediator
local TitleRoomMediator = class("TitleRoomMediator", Mediator)

function TitleRoomMediator:ctor(root)
	TitleRoomMediator.super.ctor(self, "TitleRoomMediator", root)
end

function TitleRoomMediator:listNotificationInterests()
	local PlatformConstants = cc.exports.PlatformConstants
	return {
		--PlatformConstants.SHOW_GAMELIST, 
		--PlatformConstants.SHOW_ROOMLIST, 
		PlatformConstants.UPDATE_NICKNAME, 
		PlatformConstants.UPDATE_HEADID, 
		PlatformConstants.UPDATE_HEADSTR, 
		PlatformConstants.UPDATE_GOLD, 
		PlatformConstants.UPDATE_DIAMOND,
	}
end

function TitleRoomMediator:onRegister()
    print("TitleRoomMediator:onRegister")
	local platformFacade = cc.load("puremvc").Facade.getInstance("platform")
	local PlatformConstants = cc.exports.PlatformConstants
	local userinfo = platformFacade:retrieveProxy("UserInfoProxy")
	local fileNode = self:getViewComponent()

	-- self.title = seekNodeByName(ui, "FileNode")
	-- local csbPath = "hall_res/hall/logo/Node.csb"
	-- local animator = cc.CSLoader:createNode(csbPath)
	-- local animation = cc.CSLoader:createTimeline(csbPath)
	-- animation:setTimeSpeed(24.0/60)
	-- animator:runAction(animation)
	-- animation:gotoFrameAndPlay(0, true)
	-- self.title:addChild(animator)

	-- self.title = seekNodeByName(ui, "FileNode")
	local csbPath = "hall_res/hall/hallTopGoldRoom.csb"
	local ui = cc.CSLoader:createNode(csbPath)
	fileNode:addChild(ui)

    --返回按钮监听
	local btnBack = seekNodeByName(ui, "btn_back")
	if btnBack then
		btnBack:setZoomScale(-0.1)
		btnBack:addClickEventListener(function(btn)
			local roomlist = platformFacade:retrieveMediator("RoomListMediator")
			if roomlist and roomlist:getViewComponent() and roomlist:getViewComponent():isVisible() then
				platformFacade:sendNotification(PlatformConstants.SHOW_GAMELIST)
			else
				platformFacade:sendNotification(PlatformConstants.REQUEST_LOGOUT)
			end
		end)
		self.btnBack = btnBack
	end

	local btnSetting = seekNodeByName(ui, "btn_setting")
	if btnSetting then
		btnSetting:setZoomScale(-0.1)
		btnSetting:addClickEventListener(function(btn)
			
		end)
		self.btnSet = btnSetting
	end	

    --启动抽奖页面
    local btn_Lottery = seekNodeByName(ui, "img_shouchong")
    if btn_Lottery then
        btn_Lottery:addClickEventListener(function()
            print("click hallMediator btn_Lottery")
            platformFacade:sendNotification(PlatformConstants.START_LOTTERYLAYER)  --启动抽奖界面
        end)
    end

    --金币面板
    -- local coin_panel = seekNodeByName(ui, "img_jidou_bg")
    -- if coin_panel then
    --    coin_panel:addClickEventListener(function()
    --      print("click coin_panel")
    --      platformFacade:sendNotification(PlatformConstants.START_SHOPLAYER, 4)  --启动商城 
    --    end)
    --    local btn_AddCoin = seekNodeByName(coin_panel, "btn_addjindou")
    --    if btn_AddCoin then
    --       btn_AddCoin:addClickEventListener(function()
    --       print("click coin_panel")
    --       platformFacade:sendNotification(PlatformConstants.START_SHOPLAYER, 4)  --启动商城 
    --     end)
    --    end
    -- end

    --房卡面板
    -- local roomCard_panel = seekNodeByName(ui, "img_fangka_bg")
    -- if roomCard_panel then
    --   -- local btn_AddRoomCard = seekNodeByName(roomCard_panel, "btn_addfangka")
    --    roomCard_panel:addClickEventListener(function()
    --      print("click btn_AddRoomCard")
    --      platformFacade:sendNotification(PlatformConstants.START_SHOPLAYER, 3)  --启动商城
    --    end)
    --     local btn_AddRoomCard = seekNodeByName(roomCard_panel, "btn_addfangka")
    --     btn_AddRoomCard:addClickEventListener(function()
    --      print("click btn_AddRoomCard")
    --      platformFacade:sendNotification(PlatformConstants.START_SHOPLAYER, 3)  --启动商城
    --    end)
    -- end

    --头像监听
	local btn_headimg = seekNodeByName(ui, "btn_headimg")
	if btn_headimg then
		btn_headimg:addClickEventListener(function(btn)
			local scene = platformFacade:retrieveMediator("HallMediator").scene
			platformFacade:sendNotification(PlatformConstants.SHOW_USERINFO, scene)
		end)
    end
	self.imgHead = btn_headimg
	if userinfo:getData().headStr and string.len(userinfo:getData().headStr) > 0 then
		self.imgHead:loadTexture(userinfo:getData().headStr)
	else
		local id = userinfo:getData().headId or 0
		local img = string.format("%s%d.png", id < 6 and "boy" or "girl", id < 6 and id or id-6)
		local path = "platform_res/common/" .. img
		self.imgHead:loadTexture(path)
	end

	self.txtName = seekNodeByName(ui, "nickname")
	if userinfo:getData().nickName then
		self.txtName:setString(userinfo:getData().nickName)
	end

	self.txtGold = seekNodeByName(ui, "usermoney")
	if userinfo:getData().gold then
        local goldStr = cc.exports.formatLongNum(userinfo:getData().gold)
		self.txtGold:setString(goldStr)
	else
		self.txtGold:setString(tostring(0))
	end

	self.txtDiamond = seekNodeByName(ui, "userdiamond")
	if userinfo:getData().diamond then
        local roomStr = cc.exports.formatLongNum(userinfo:getData().diamond)
		self.txtDiamond:setString(roomStr)
	else
		self.txtDiamond:setString(tostring(0))
	end
end

function TitleRoomMediator:onRemove()
end

function TitleRoomMediator:handleNotification(notification)
	local name = notification:getName()
	local body = notification:getBody()
	local platformFacade = cc.load("puremvc").Facade.getInstance("platform")
	local PlatformConstants = cc.exports.PlatformConstants
    --local ui = self:getViewComponent()
    --local btn_customer = seekNodeByName(ui, "btn_customer")
    --local btn_invitecode = seekNodeByName(ui, "btn_invitecode")
    --local btn_fightrecord = seekNodeByName(ui, "btn_fightrecord")
    local roomlist = platformFacade:retrieveMediator("RoomListMediator")
    local userinfo = platformFacade:retrieveProxy("UserInfoProxy")
	if name == PlatformConstants.SHOW_GAMELIST then  --显示游戏列表
		self.title:removeAllChildren()
		local csbPath = "hall_res/hall/logo/Node.csb"
		local animator = cc.CSLoader:createNode(csbPath)
		local animation = cc.CSLoader:createTimeline(csbPath)
		animation:setTimeSpeed(24.0/60)
		animator:runAction(animation)
		animation:gotoFrameAndPlay(0, true)
		self.title:addChild(animator)
		self.btnBack:setVisible(false)
	elseif name == PlatformConstants.SHOW_ROOMLIST then  --显示房间列表
		local gameId = platformFacade:retrieveProxy("RoomListProxy"):getData().gameId
		self.title:removeAllChildren()	
        local logoPath = string.format("game_res/%d/gamename_%d.png", gameId, gameId)
        local logo = ccui.ImageView:create(logoPath)
    	self.title:addChild(logo)
    	self.btnBack:setVisible(true)
    	--self.btnSet:setVisible(false)
        --显示房间列表时，隐藏客服，邀请码，战绩图标
	elseif name == PlatformConstants.UPDATE_NICKNAME then
		self.txtName:setString(tostring(body))
	elseif name == PlatformConstants.UPDATE_HEADID then
		local id = body or 0
		local img = string.format("%s%d.png", id < 6 and "boy" or "girl", id < 6 and id or id-6)
		local path = "platform_res/common/" .. img
		self.imgHead:loadTexture(path)
	elseif name == PlatformConstants.UPDATE_HEADSTR then
		if body and string.len(body) > 1 then
			self.imgHead:loadTexture(body)
		end
	elseif name == PlatformConstants.UPDATE_GOLD then
        local goldStr = cc.exports.formatLongNum(body)
		self.txtGold:setString(goldStr)
	elseif name == PlatformConstants.UPDATE_DIAMOND then
		local diamondStr = cc.exports.formatLongNum(body)
		self.txtDiamond:setString(diamondStr)
	end
end

return TitleRoomMediator