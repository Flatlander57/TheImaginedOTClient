skillsWindow = nil
skillsButton = nil

function init()
  connect(LocalPlayer, {
    onExperienceChange = onExperienceChange,
    onLevelChange = onLevelChange,
    onHealthChange = onHealthChange,
    onManaChange = onManaChange,
    onShieldChange = onShieldChange,
    onBarrierChange = onBarrierChange,
    onSoulChange = onSoulChange,
    onFreeCapacityChange = onFreeCapacityChange,
    onTotalCapacityChange = onTotalCapacityChange,
    onStaminaChange = onStaminaChange,
    onOfflineTrainingChange = onOfflineTrainingChange,
    onRegenerationChange = onRegenerationChange,
    onSpeedChange = onSpeedChange,
    onBaseSpeedChange = onBaseSpeedChange,
    onMagicLevelChange = onMagicLevelChange,
    onBaseMagicLevelChange = onBaseMagicLevelChange,
    onSkillChange = onSkillChange,
    onBaseSkillChange = onBaseSkillChange
  })
  connect(g_game, {
    onGameStart = refresh,
    onGameEnd = offline
  })

  skillsButton = modules.client_topmenu.addRightGameToggleButton('skillsButton', tr('Skills') .. ' (Ctrl+S)', '/images/topbuttons/skills', toggle)
  skillsButton:setOn(true)
  skillsWindow = g_ui.loadUI('skills', modules.game_interface.getRightPanel())

  g_keyboard.bindKeyDown('Ctrl+E', toggle)

  refresh()
  skillsWindow:setup()
end

function terminate()
  disconnect(LocalPlayer, {
    onExperienceChange = onExperienceChange,
    onLevelChange = onLevelChange,
    onHealthChange = onHealthChange,
    onManaChange = onManaChange,
    onShieldChange = onShieldChange,
    onBarrierChange = onBarrierChange,
    onSoulChange = onSoulChange,
    onFreeCapacityChange = onFreeCapacityChange,
    onTotalCapacityChange = onTotalCapacityChange,
    onStaminaChange = onStaminaChange,
    onOfflineTrainingChange = onOfflineTrainingChange,
    onRegenerationChange = onRegenerationChange,
    onSpeedChange = onSpeedChange,
    onBaseSpeedChange = onBaseSpeedChange,
    onMagicLevelChange = onMagicLevelChange,
    onBaseMagicLevelChange = onBaseMagicLevelChange,
    onSkillChange = onSkillChange,
    onBaseSkillChange = onBaseSkillChange
  })
  disconnect(g_game, {
    onGameStart = refresh,
    onGameEnd = offline
  })

  g_keyboard.unbindKeyDown('Ctrl+E')
  skillsWindow:destroy()
  skillsButton:destroy()
end

function resetSkillColor(id)
  local skill = skillsWindow:recursiveGetChildById(id)
  local widget = skill:getChildById('value')
  widget:setColor('#bbbbbb')
end

function setSkillBase(id, value, baseValue)
  if baseValue <= 0 or value < 0 then
    return
  end
  local skill = skillsWindow:recursiveGetChildById(id)
  local widget = skill:getChildById('value')

  if value > baseValue then
    widget:setColor('#008b00') -- green
    skill:setTooltip(baseValue .. ' +' .. (value - baseValue))
  elseif value < baseValue then
    widget:setColor('#b22222') -- red
    skill:setTooltip(baseValue .. ' ' .. (value - baseValue))
  else
    widget:setColor('#bbbbbb') -- default
    skill:removeTooltip()
  end
end

function setSkillValue(id, value)
  local skill = skillsWindow:recursiveGetChildById(id)
  local widget = skill:getChildById('value')
  widget:setText(value)
end

function setSkillColor(id, value)
  local skill = skillsWindow:recursiveGetChildById(id)
  local widget = skill:getChildById('value')
  widget:setColor(value)
end

function setSkillTooltip(id, value)
  local skill = skillsWindow:recursiveGetChildById(id)
  local widget = skill:getChildById('value')
  widget:setTooltip(value)
end

function checkAlert(id, value, maxValue, threshold, greaterThan)
  if greaterThan == nil then greaterThan = false end
  local alert = false

  -- maxValue can be set to false to check value and threshold
  -- used for regeneration checking
  if type(maxValue) == 'boolean' then
    if maxValue then
      return
    end

    if greaterThan then
      if value > threshold then
        alert = true
      end
    else
      if value < threshold then
        alert = true
      end
    end
  elseif type(maxValue) == 'number' then
    if maxValue < 0 then
      return
    end

    local percent = math.floor((value / maxValue) * 100)
    if greaterThan then
      if percent > threshold then
        alert = true
      end
    else
      if percent < threshold then
        alert = true
      end
    end
  end

  if alert then
    setSkillColor(id, '#b22222') -- red
  else
    resetSkillColor(id)
  end
end

function update()
  local offlineTraining = skillsWindow:recursiveGetChildById('offlineTraining')
  if not g_game.getFeature(GameOfflineTrainingTime) then
    offlineTraining:hide()
  else
    offlineTraining:show()
  end

  local regenerationTime = skillsWindow:recursiveGetChildById('regenerationTime')
  if not g_game.getFeature(GamePlayerRegenerationTime) then
    regenerationTime:hide()
  else
    regenerationTime:show()
  end
end

function refresh()
  local player = g_game.getLocalPlayer()
  if not player then return end

  onExperienceChange(player, player:getExperience())
  onLevelChange(player, player:getLevel())
  onHealthChange(player, player:getHealth(), player:getMaxHealth())
  onManaChange(player, player:getMana(), player:getMaxMana())
  onShieldChange(player, player:getShield(), player:getMaxShield())
  onBarrierChange(player, player:getBarrier(), player:getMaxBarrier())
  onSoulChange(player, player:getSoul())
  onFreeCapacityChange(player, player:getFreeCapacity())
  onStaminaChange(player, player:getStamina())
  onMagicLevelChange(player, player:getMagicLevel())
  onOfflineTrainingChange(player, player:getOfflineTrainingTime())
  onRegenerationChange(player, player:getRegenerationTime())
  onSpeedChange(player, player:getSpeed())

  for i=0,6 do
    onSkillChange(player, i, player:getSkillLevel(i))
    onBaseSkillChange(player, i, player:getSkillBaseLevel(i))
  end

  update()

  local contentsPanel = skillsWindow:getChildById('contentsPanel')
  skillsWindow:setContentMinimumHeight(44)
  skillsWindow:setContentMaximumHeight(390)
end

function offline()
  if expSpeedEvent then expSpeedEvent:cancel() expSpeedEvent = nil end
end

function toggle()
  if skillsButton:isOn() then
    skillsWindow:close()
    skillsButton:setOn(false)
  else
    skillsWindow:open()
    skillsButton:setOn(true)
  end
end

function onMiniWindowClose()
  skillsButton:setOn(false)
end

function onExperienceChange(localPlayer, value)
  setSkillValue('experience', value)
end

function onLevelChange(localPlayer, value)

  setSkillValue('level', value)
end

function onHealthChange(localPlayer, health, maxHealth)
  setSkillValue('health', health)
  checkAlert('health', health, maxHealth, 30)
end

function onManaChange(localPlayer, mana, maxMana)
  setSkillValue('mana', mana)
  checkAlert('mana', mana, maxMana, 30)
end

function onShieldChange(localPlayer, shield, maxShield)
  setSkillValue('shield', shield)
  checkAlert('shield', shield, maxShield, 30)
end

function onBarrierChange(localPlayer, barrier, maxBarrier)
  setSkillValue('barrier', barrier)
  checkAlert('barrier', barrier, maxBarrier, 30)
end

function onSoulChange(localPlayer, soul)
  setSkillValue('soul', soul)
end

function onFreeCapacityChange(localPlayer, freeCapacity)
  setSkillValue('capacity', freeCapacity)
  checkAlert('capacity', freeCapacity, localPlayer:getTotalCapacity(), 20)
end

function onTotalCapacityChange(localPlayer, totalCapacity)
  checkAlert('capacity', localPlayer:getFreeCapacity(), totalCapacity, 20)
end

function onStaminaChange(localPlayer, stamina)
  local hours = math.floor(stamina / 60)
  local minutes = stamina % 60
  if minutes < 10 then
    minutes = '0' .. minutes
  end
  local percent = math.floor(100 * stamina / (42 * 60)) -- max is 42 hours

  setSkillValue('stamina', hours .. ":" .. minutes)
end

function onOfflineTrainingChange(localPlayer, offlineTrainingTime)
  if not g_game.getFeature(GameOfflineTrainingTime) then
    return
  end
  local hours = math.floor(offlineTrainingTime / 60)
  local minutes = offlineTrainingTime % 60
  if minutes < 10 then
    minutes = '0' .. minutes
  end
  local percent = 100 * offlineTrainingTime / (12 * 60) -- max is 12 hours

  setSkillValue('offlineTraining', hours .. ":" .. minutes)
end

function onRegenerationChange(localPlayer, regenerationTime)
  if not g_game.getFeature(GamePlayerRegenerationTime) or regenerationTime < 0 then
    return
  end
  local minutes = math.floor(regenerationTime / 60)
  local seconds = regenerationTime % 60
  if seconds < 10 then
    seconds = '0' .. seconds
  end

  setSkillValue('regenerationTime', minutes .. ":" .. seconds)
  checkAlert('regenerationTime', regenerationTime, false, 300)
end

function onSpeedChange(localPlayer, speed)
  setSkillValue('speed', speed)

  onBaseSpeedChange(localPlayer, localPlayer:getBaseSpeed())
end

function onBaseSpeedChange(localPlayer, baseSpeed)
  setSkillBase('speed', localPlayer:getSpeed(), baseSpeed)
end

function onMagicLevelChange(localPlayer, magiclevel, percent)
  setSkillValue('magiclevel', magiclevel)

  onBaseMagicLevelChange(localPlayer, localPlayer:getBaseMagicLevel())
end

function onBaseMagicLevelChange(localPlayer, baseMagicLevel)
  setSkillBase('magiclevel', localPlayer:getMagicLevel(), baseMagicLevel)
end

function onSkillChange(localPlayer, id, level, percent)
  setSkillValue('skillId' .. id, level)

  onBaseSkillChange(localPlayer, id, localPlayer:getSkillBaseLevel(id))
end

function onBaseSkillChange(localPlayer, id, baseLevel)
  setSkillBase('skillId'..id, localPlayer:getSkillLevel(id), baseLevel)
end
