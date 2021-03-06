--
-- Author: junjie
-- Date: 2015-12-16 13:37:42
--
--500账号绑定
local EsunBind = class("EsunBind",function() 
  return display.newColorLayer(cc.c4b( 0,0,0,0))
end)
require("app.Network.Http.DBHttpRequest")
local CMButton = require("app.Component.CMButton")
local EditText = require("app.architecture.components.EditText")

local EnumMenu = {
	eBtnBind = 1,
	eBtnGet  = 2,
}
function EsunBind:ctor(params)
	self.params = params or {}
	self:setNodeEventEnabled(true)	
	self.mInputBox = {}
	self.mTime = 120
end
function EsunBind:create()
  self:initUI()
end
function EsunBind:onExit()
	QManagerScheduler:removeLocalScheduler({layer = self}) 
end
function EsunBind:initUI()
	-- self.mBg = cc.Sprite:create("picdata/setting/blindBG.png")
 --  local bgWidth = self.mBg:getContentSize().width
 --  local bgHeight= self.mBg:getContentSize().height
 --  self.mBg:setPosition(display.cx,display.cy)
 --  self:addChild(self.mBg)
  local filename = "picdata/public_new/bg.png"
  local size = cc.size(CONFIG_SCREEN_WIDTH, CONFIG_SCREEN_HEIGHT)
  self.mBg = display.newScale9Sprite(filename, 0, 0, size)
  self.mBg:align(display.LEFT_BOTTOM, 0, 0)
  self:addChild(self.mBg)
  local bgWidth = self.mBg:getContentSize().width
  local bgHeight= self.mBg:getContentSize().height

  --local title = cc.Sprite:create("picdata/setting/EsunBindTitle.png")
  -- local title = cc.ui.UILabel.new({
  --       text  = "绑定500账号",
  --       size  = 32,
  --       color = cc.c3b(255,225,173),
  --       align = cc.ui.TEXT_ALIGN_LEFT,
  --       --UILabelType = 1,
  --       font  = "黑体",
        
  --   })
  -- title:setPosition(bgWidth/2-title:getContentSize().width/2,bgHeight - 40)
  -- self.mBg:addChild(title)
  local title = cc.ui.UILabel.new({
        UILabelType = 1,
        text  = self.params.title or "绑定500帐号",
        font  = "fonts/title.fnt",
        align = cc.ui.TEXT_ALIGN_CENTER,
    })
  title:align(display.CENTER, bgWidth/2,bgHeight - 40)
  self.mBg:addChild(title)

  local backBtn = CMButton.new({normal = "picdata/public_new/btn_back2.png",
    pressed = "picdata/public_new/btn_back2.png"},function () CMClose(self) end)
  backBtn:setPosition(45, CONFIG_SCREEN_HEIGHT-40)
  self:addChild(backBtn)

   local sTip = cc.ui.UILabel.new({
        text  = "仅用于派发购彩红包",
        size  = 24,
        color = cc.c3b(183,183,204),
        align = cc.ui.TEXT_ALIGN_LEFT,
        --UILabelType = 1,
        font  = "黑体",
        
    })
    sTip:setPosition(bgWidth/2-sTip:getContentSize().width/2,bgHeight-120)
    self.mBg:addChild(sTip)
   

    local posy  = sTip:getPositionY() - 75
    local data = {"请输入您的500.com账号"}
    for i = 1,1 do 
      local inputBox = EditText:new({
          forePath = "picdata/public_new/icon_id.png",
          bgPath = "picdata/public_new/input.png",
          -- minLength= 0,
          -- maxLength= 100,
          place     = data[i],
          color     = cc.c3b(0, 0, 0),
          fontSize  = 24,
          size = cc.size(410,38),
          inputOffsetY = -2,
          listener = function(event, editbox) 
              if event=="ended" then
                  
              elseif event=="began" then
                  
              end
          end,
          })
      inputBox:align(display.CENTER, bgWidth/2+2, posy-4)
          :addTo(self.mBg)
      self.mInputBox[i] = inputBox
      posy = posy - 75 - 5
    end

local btnBind = CMButton.new({normal = "picdata/public_new/btn_greenlong.png",pressed = "picdata/public_new/btn_greenlong_p.png"},function () 
      self:onMenuCallBack(EnumMenu.eBtnBind) end, {scale9 = false})    
    :align(display.CENTER, bgWidth/2,posy - 40) --设置位置 锚点位置和坐标x,y
    :addTo(self.mBg)
    btnBind:setButtonLabel("normal",cc.ui.UILabel.new({
      color = cc.c3b(255, 255, 255),
      -- color = cc.c3b(255, 255, 155),
      text = "绑定",
      size = 28,
      font = "黑体",
    }))
  
end
-- 输入事件监听方法
function EsunBind:onEdit(event, editbox)
    if event == "began" then
    -- 开始输入
        --print("开始输入")
    elseif event == "changed" then
    -- 输入框内容发生变化
        --print("输入框内容发生变化")      
        local _text = editbox:getText()
		local _trimed = string.trim(_text)		
		if _trimed ~= _text then			
		    editbox:setText(_trimed)
		end
		-- self._sendRoleId = 0
		-- self._chatPlayer:setText("")
  -- 		self._chatName:setString(_trimed or "")
  -- 		self._chatName:setPositionX(self._chatPlayer:getContentSize().width/2 - self._chatName:getContentSize().width/2)
    elseif event == "ended" then
    -- 输入结束
        --print("输入结束")        
    elseif event == "return" then
    	
    	
    -- 从输入框返回
        --print("从输入框返回")       
    end
end
function EsunBind:onMenuCallBack(tag)
	if tag == EnumMenu.eBtnBind then
   		local sMail = self.mInputBox[1]:getText()
		local lens   = string.len(sMail)
		if sMail == "" then return end
		local data = self.params
		DBHttpRequest:updateUserExtensionInfo(function(tableData,tag) self:httpResponse(tableData,tag) end, data[USER_TRUENAME],data[USER_SEX],data[USER_COUNTRY],data[USER_PROVINCE],data[USER_CITY],data[ADDRESS_DETAIL],data["4027"],sMail)  
	end
end
--[[
  网络回调
]]
function EsunBind:httpResponse(tableData,tag,fileName) 
	-- dump(tableData,tag)
    if tag == POST_COMMAND_updateUserExtensionInfo then
        local isSuc = true
        local text  = "绑定500账号成功"
      if tableData == true then 

      else
          text = "绑定500账号失败"
          isSuc = false
      end
      local CMToolTipView = require("app.Component.CMToolTipView").new({text = text,isSuc = isSuc})
      CMOpen(CMToolTipView,self)  

    end
    
end
return EsunBind