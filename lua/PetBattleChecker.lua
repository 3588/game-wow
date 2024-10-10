-- 创建一个框体用于显示状态
local frame = CreateFrame("Frame", "PetBattleCheckerFrame", UIParent)
frame:SetSize(100, 100)  -- 设置框体大小为 100x100 像素
frame:SetPoint("TOPLEFT", 50, -100)  -- 设置框体位置

local indicator = frame:CreateTexture(nil, "BACKGROUND")
indicator:SetAllPoints(frame)

-- 创建文本框用于显示当前等级
local levelText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
levelText:SetPoint("TOP", frame, "TOP", 0, -5)  -- 设置文本框位置
levelText:SetText("等级: 0")  -- 默认文本

-- 创建文本框用于显示宠物对战次数
local battleCountText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
battleCountText:SetPoint("TOP", levelText, "BOTTOM", 0, 0)  -- 设置文本框位置
battleCountText:SetText("对战次数: 0")  -- 默认文本

-- 初始化宠物对战次数
local petBattleCount = 0

-- 创建第二个框体用于显示目标状态
local statusFrame = CreateFrame("Frame", "TargetStatusFrame", UIParent)
statusFrame:SetSize(100, 100)  -- 设置框体大小为 100x100 像素
statusFrame:SetPoint("TOPLEFT", 200, -100)  -- 设置框体位置

local statusIndicator = statusFrame:CreateTexture(nil, "BACKGROUND")
statusIndicator:SetAllPoints(statusFrame)

-- 创建文本框用于显示目标等级
local targetLevelText = statusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
targetLevelText:SetPoint("CENTER", statusFrame, "CENTER", 0, 0)  -- 设置文本框位置
targetLevelText:SetText("目标等级: 0")  -- 默认文本

-- 更新显示信息的函数
local function UpdateDisplay()
    local currentLevel = UnitLevel("player")  -- 获取当前等级
    levelText:SetText("等级: " .. currentLevel)  -- 显示当前等级

    -- 更新宠物对战状态
    if C_PetBattles.IsInBattle() then
        indicator:SetColorTexture(0, 1, 0)  -- 绿色表示正在进行宠物对战
        PetBattleStatus = "正在进行宠物对战"
    else
        indicator:SetColorTexture(1, 0, 0)  -- 红色表示没有进行宠物对战
        PetBattleStatus = "没有进行宠物对战"
        petBattleCount = petBattleCount + 1  -- 增加对战次数
    end

    battleCountText:SetText("对战次数: " .. petBattleCount)  -- 显示对战次数

    -- 更新目标状态
    local targetUnit = "target"  -- 获取当前目标
    if UnitExists(targetUnit) then  -- 检查目标是否存在
        local targetIsDead = UnitIsDead(targetUnit)  -- 检查目标是否死亡
        local targetLevel = UnitLevel(targetUnit)  -- 获取目标的等级

        if targetIsDead then
            statusIndicator:SetColorTexture(0, 1, 0)  -- 绿色表示目标死亡
        else
            statusIndicator:SetColorTexture(1, 0, 0)  -- 红色表示目标未死亡
        end

        targetLevelText:SetText("目标等级: " .. (targetLevel > 0 and targetLevel or "未知"))  -- 显示目标等级
    else
        statusIndicator:SetColorTexture(1, 1, 1)  -- 如果目标不存在，设置为白色
        targetLevelText:SetText("目标等级: 无");  -- 如果目标不存在，显示“无”
    end
end

-- 将函数设置为全局可访问
_G.UpdatePetBattleStatus = function()
    UpdateDisplay()  -- 调用更新显示函数
end

-- 注册事件
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("PET_BATTLE_OPENING_START")
frame:RegisterEvent("PET_BATTLE_CLOSE")
frame:RegisterEvent("UNIT_HEALTH")  -- 注册目标生命值变化事件
frame:RegisterEvent("PLAYER_TARGET_CHANGED")  -- 注册目标变化事件
frame:SetScript("OnEvent", UpdateDisplay)

-- 初始化
UpdateDisplay()  -- 更新显示信息
