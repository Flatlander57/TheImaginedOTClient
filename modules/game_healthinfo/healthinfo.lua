Icons = {}
Icons[1] = { tooltip = tr('You are poisoned'), path = '/images/game/states/poisoned', id = 'condition_poisoned' }
Icons[2] = { tooltip = tr('You are burning'), path = '/images/game/states/burning', id = 'condition_burning' }
Icons[4] = { tooltip = tr('You are electrified'), path = '/images/game/states/electrified', id = 'condition_electrified' }
Icons[8] = { tooltip = tr('You are drunk'), path = '/images/game/states/drunk', id = 'condition_drunk' }
Icons[16] = { tooltip = tr('You are protected by a magic shield'), path = '/images/game/states/magic_shield', id = 'condition_magic_shield' }
Icons[32] = { tooltip = tr('You are paralysed'), path = '/images/game/states/slowed', id = 'condition_slowed' }
Icons[64] = { tooltip = tr('You are hasted'), path = '/images/game/states/haste', id = 'condition_haste' }
Icons[128] = { tooltip = tr('You may not logout during a fight'), path = '/images/game/states/logout_block', id = 'condition_logout_block' }
Icons[256] = { tooltip = tr('You are drowning'), path = '/images/game/states/drowning', id = 'condition_drowning' }
Icons[512] = { tooltip = tr('You are freezing'), path = '/images/game/states/freezing', id = 'condition_freezing' }
Icons[1024] = { tooltip = tr('You are dazzled'), path = '/images/game/states/dazzled', id = 'condition_dazzled' }
Icons[2048] = { tooltip = tr('You are cursed'), path = '/images/game/states/cursed', id = 'condition_cursed' }
Icons[4096] = { tooltip = tr('You are strengthened'), path = '/images/game/states/strengthened', id = 'condition_strengthened' }
Icons[8192] = { tooltip = tr('You may not logout or enter a protection zone'), path = '/images/game/states/protection_zone_block', id = 'condition_protection_zone_block' }
Icons[16384] = { tooltip = tr('You are within a protection zone'), path = '/images/game/states/protection_zone', id = 'condition_protection_zone' }
Icons[32768] = { tooltip = tr('You are bleeding'), path = '/images/game/states/bleeding', id = 'condition_bleeding' }
Icons[65536] = { tooltip = tr('You are hungry'), path = '/images/game/states/hungry', id = 'condition_hungry' }

healthInfoWindow = nil
healthBar = nil
manaBar = nil
shieldBar = nil
barrierBar = nil
soulLabel = nil
capLabel = nil
healthTooltip = 'Your character health is %d out of %d.'
manaTooltip = 'Your character mana is %d out of %d.'
shieldTooltip = 'Your character shield is %d out of %d.'
barrierTooltip = 'Your character barrier is %d out of %d.'

function init()
  connect(LocalPlayer, { onHealthChange = onHealthChange,
                         onManaChange = onManaChange,
                         onShieldChange = onShieldChange,
                         onBarrierChange = onBarrierChange,
                         onStatesChange = onStatesChange,
                         onSoulChange = onSoulChange,
                         onFreeCapacityChange = onFreeCapacityChange })

  connect(g_game, { onGameEnd = offline })

  healthInfoButton = modules.client_topmenu.addRightGameToggleButton('healthInfoButton', tr('Health Information'), '/images/topbuttons/healthinfo', toggle)
  healthInfoButton:setOn(true)

  healthInfoWindow = g_ui.loadUI('healthinfo', modules.game_interface.getRightPanel())
  healthInfoWindow:disableResize()
  healthBar = healthInfoWindow:recursiveGetChildById('healthBar')
  manaBar = healthInfoWindow:recursiveGetChildById('manaBar')
  shieldBar = healthInfoWindow:recursiveGetChildById('shieldBar')
  barrierBar = healthInfoWindow:recursiveGetChildById('barrierBar')
  soulLabel = healthInfoWindow:recursiveGetChildById('soulLabel')
  capLabel = healthInfoWindow:recursiveGetChildById('capLabel')
  
  healthInfoWindowHp = g_ui.displayUI('healthinfoHp', modules.game_interface.getRightPanel())
  healthInfoWindowMp = g_ui.displayUI('healthinfoMp', modules.game_interface.getRightPanel())
  healthInfoWindowSh = g_ui.displayUI('healthinfoSh', modules.game_interface.getRightPanel())
  healthInfoWindowBr = g_ui.displayUI('healthinfoBr', modules.game_interface.getRightPanel())

  
  healthInfoWindowHp:hide()
  healthInfoWindowMp:hide()
  healthInfoWindowSh:hide()
  healthInfoWindowBr:hide()


  healthBarP = healthInfoWindowHp:recursiveGetChildById('healthBar')
  manaBarP = healthInfoWindowMp:recursiveGetChildById('manaBar')
  shieldBarP = healthInfoWindowSh:recursiveGetChildById('shieldBar')
  barrierBarP = healthInfoWindowBr:recursiveGetChildById('barrierBar')
    
  -- load condition icons
  for k,v in pairs(Icons) do
    g_textures.preload(v.path)
  end

  if g_game.isOnline() then
    local localPlayer = g_game.getLocalPlayer()
    onHealthChange(localPlayer, localPlayer:getHealth(), localPlayer:getMaxHealth())
    onManaChange(localPlayer, localPlayer:getMana(), localPlayer:getMaxMana())
    onShieldChange(localPlayer, localPlayer:getShield(), localPlayer:getMaxShield())
    onBarrierChange(localPlayer, localPlayer:getBarrier(), localPlayer:getMaxBarrier())
    onStatesChange(localPlayer, localPlayer:getStates(), 0)
    onSoulChange(localPlayer, localPlayer:getSoul())
    onFreeCapacityChange(localPlayer, localPlayer:getFreeCapacity())
  end

  healthInfoWindow:setup()
end

function terminate()
  disconnect(LocalPlayer, { onHealthChange = onHealthChange,
                            onManaChange = onManaChange,
                            onShieldChange = onShieldChange,
                            onBarrierChange = onBarrierChange,
                            onStatesChange = onStatesChange,
                            onSoulChange = onSoulChange,
                            onFreeCapacityChange = onFreeCapacityChange })

  disconnect(g_game, { onGameEnd = offline })

  healthInfoWindow:destroy()
  healthInfoButton:destroy()
  healthInfoWindowHp:destroy()
  healthInfoWindowMp:destroy()
  healthInfoWindowSh:destroy()
  healthInfoWindowBr:destroy()

end

function toggle()
  if healthInfoButton:isOn() then
    healthInfoWindow:close()
    healthInfoButton:setOn(false)
  else
    healthInfoWindow:open()
    healthInfoButton:setOn(true)
  end
end

function showHp()
  if onHp == 'yes' then
    healthInfoWindowHp:hide()
    onHp = 'no'
  else
    healthInfoWindowHp:show()
    onHp = 'yes'
  end
end

function showMp()
  if onMp == 'yes' then
    healthInfoWindowMp:hide()
    onMp = 'no'
  else
    healthInfoWindowMp:show()
    onMp = 'yes'
  end
end

function showSh()
  if onSh == 'yes' then
    healthInfoWindowSh:hide()
    onSh = 'no'
  else
    healthInfoWindowSh:show()
    onSh = 'yes'
  end
end

function showBr()
  if onBr == 'yes' then
    healthInfoWindowBr:hide()
    onBr = 'no'
  else
    healthInfoWindowBr:show()
    onBr = 'yes'
  end
end

function toggleIcon(bitChanged)
  local content = healthInfoWindow:recursiveGetChildById('conditionPanel')

  local icon = content:getChildById(Icons[bitChanged].id)
  if icon then
    icon:destroy()
  else
    icon = loadIcon(bitChanged)
    icon:setParent(content)
  end
end

function loadIcon(bitChanged)
  local icon = g_ui.createWidget('ConditionWidget', content)
  icon:setId(Icons[bitChanged].id)
  icon:setImageSource(Icons[bitChanged].path)
  icon:setTooltip(Icons[bitChanged].tooltip)
  return icon
end

function offline()
  healthInfoWindow:recursiveGetChildById('conditionPanel'):destroyChildren()
end

-- hooked events
function onMiniWindowClose()
  healthInfoButton:setOn(false)
end

function onHealthChange(localPlayer, health, maxHealth)
  healthBar:setText(health .. ' / ' .. maxHealth)
  healthBar:setTooltip(tr(healthTooltip, health, maxHealth))
  healthBar:setValue(health, 0, maxHealth)
  
  healthBarP:setText(health .. ' / ' .. maxHealth)
  healthBarP:setTooltip(tr(healthTooltip, health, maxHealth))
  healthBarP:setValue(health, 0, maxHealth)
end

function onManaChange(localPlayer, mana, maxMana)
  if(maxMana > 1) then
   manaBar:show()
  else
   manaBar:hide()
  end
  manaBar:setText(mana .. ' / ' .. maxMana)
  manaBar:setTooltip(tr(manaTooltip, mana, maxMana))
  manaBar:setValue(mana, 0, maxMana)
  
  manaBarP:setText(mana .. ' / ' .. maxMana)
  manaBarP:setTooltip(tr(manaTooltip, mana, maxMana))
  manaBarP:setValue(mana, 0, maxMana)
end

function onShieldChange(localPlayer, shield, maxShield)
  if(maxShield > 1) then
   shieldBar:show()
  else
   shieldBar:hide()
  end
  shieldBar:setText(shield .. ' / ' .. maxShield)
  shieldBar:setTooltip(tr(shieldTooltip, shield, maxShield))
  shieldBar:setValue(shield, 0, maxShield)
  
  shieldBarP:setText(shield .. ' / ' .. maxShield)
  shieldBarP:setTooltip(tr(shieldTooltip, shield, maxShield))
  shieldBarP:setValue(shield, 0, maxShield)  
end

function onBarrierChange(localPlayer, barrier, maxBarrier)
  if(maxBarrier > 1) then
   barrierBar:show()
  else
   barrierBar:hide()
  end
  barrierBar:setText(barrier .. ' / ' .. maxBarrier)
  barrierBar:setTooltip(tr(barrierTooltip, barrier, maxBarrier))
  barrierBar:setValue(barrier, 0, maxBarrier)
  
  barrierBarP:setText(barrier .. ' / ' .. maxBarrier)
  barrierBarP:setTooltip(tr(barrierTooltip, barrier, maxBarrier))
  barrierBarP:setValue(barrier, 0, maxBarrier)  
end

function onSoulChange(localPlayer, soul)
  soulLabel:setText(tr('Soul') .. ': ' .. soul)
end

function onFreeCapacityChange(player, freeCapacity)
  capLabel:setText(tr('Cap') .. ': ' .. freeCapacity)
end

function onStatesChange(localPlayer, now, old)
  if now == old then return end

  local bitsChanged = bit32.bxor(now, old)
  for i = 1, 32 do
    local pow = math.pow(2, i-1)
    if pow > bitsChanged then break end
    local bitChanged = bit32.band(bitsChanged, pow)
    if bitChanged ~= 0 then
      toggleIcon(bitChanged)
    end
  end
end

-- personalization functions
function hideLabels()
  local removeHeight = math.max(capLabel:getMarginRect().height, soulLabel:getMarginRect().height)
  capLabel:setOn(false)
  soulLabel:setOn(false)
  healthInfoWindow:setHeight(math.max(healthInfoWindow.minimizedHeight, healthInfoWindow:getHeight() - removeHeight))
end

function setHealthTooltip(tooltip)
  healthTooltip = tooltip

  local localPlayer = g_game.getLocalPlayer()
  if localPlayer then
    healthBar:setTooltip(tr(healthTooltip, localPlayer:getHealth(), localPlayer:getMaxHealth()))
    healthBarP:setTooltip(tr(healthTooltip, localPlayer:getHealth(), localPlayer:getMaxHealth()))
	end
end

function setManaTooltip(tooltip)
  manaTooltip = tooltip

  local localPlayer = g_game.getLocalPlayer()
  if localPlayer then
    manaBar:setTooltip(tr(manaTooltip, localPlayer:getMana(), localPlayer:getMaxMana()))
    manaBarP:setTooltip(tr(manaTooltip, localPlayer:getMana(), localPlayer:getMaxMana()))
  end
end

function setShieldTooltip(tooltip)
  shieldTooltip = tooltip

  local localPlayer = g_game.getLocalPlayer()
  if localPlayer then
    shieldBar:setTooltip(tr(shieldTooltip, localPlayer:getShield(), localPlayer:getMaxShield()))
	shieldBarP:setTooltip(tr(shieldTooltip, localPlayer:getShield(), localPlayer:getMaxShield()))
  end
end

function setBarrierTooltip(tooltip)
  barrierTooltip = tooltip

  local localPlayer = g_game.getLocalPlayer()
  if localPlayer then
    barrierBar:setTooltip(tr(barrierTooltip, localPlayer:getBarrier(), localPlayer:getMaxBarrier()))
    barrierBarP:setTooltip(tr(barrierTooltip, localPlayer:getBarrier(), localPlayer:getMaxBarrier()))	
  end
end

