-- @docclass Creature

-- @docconsts @{

SkullNone = 0
SkullYellow = 1
SkullGreen = 2
SkullWhite = 3
SkullRed = 4
SkullBlack = 5
SkullOrange = 6

ShieldNone = 0
ShieldWhiteYellow = 1
ShieldWhiteBlue = 2
ShieldBlue = 3
ShieldYellow = 4
ShieldBlueSharedExp = 5
ShieldYellowSharedExp = 6
ShieldBlueNoSharedExpBlink = 7
ShieldYellowNoSharedExpBlink = 8
ShieldBlueNoSharedExp = 9
ShieldYellowNoSharedExp = 10

EmblemNone = 0
EmblemGreen = 1
EmblemRed = 2
EmblemBlue = 3

-- @}

function getSkullImagePath(skullId)
  local path
  if skullId == SkullYellow then
    path = '/images/game/skulls/skull_yellow'
  elseif skullId == SkullGreen then
    path = '/images/game/skulls/skull_green'
  elseif skullId == SkullWhite then
    path = '/images/game/skulls/skull_white'
  elseif skullId == SkullRed then
    path = '/images/game/skulls/skull_red'
  elseif skullId == SkullBlack then
    path = '/images/game/skulls/skull_black'
  elseif skullId == SkullOrange then
    path = '/images/game/skulls/skull_orange'
  end
  return path
end

function getPshieldImagePathAndBlink(PshieldId)
  local path, blink
  if PshieldId == ShieldWhiteYellow then
    path, blink = '/images/game/shields/shield_yellow_white', false
  elseif PshieldId == ShieldWhiteBlue then
    path, blink = '/images/game/shields/shield_blue_white', false
  elseif PshieldId == ShieldBlue then
    path, blink = '/images/game/shields/shield_blue', false
  elseif PshieldId == ShieldYellow then
    path, blink = '/images/game/shields/shield_yellow', false
  elseif PshieldId == ShieldBlueSharedExp then
    path, blink = '/images/game/shields/shield_blue_shared', false
  elseif PshieldId == ShieldYellowSharedExp then
    path, blink = '/images/game/shields/shield_yellow_shared', false
  elseif PshieldId == ShieldBlueNoSharedExpBlink then
    path, blink = '/images/game/shields/shield_blue_not_shared', true
  elseif PshieldId == ShieldYellowNoSharedExpBlink then
    path, blink = '/images/game/shields/shield_yellow_not_shared', true
  elseif PshieldId == ShieldBlueNoSharedExp then
    path, blink = '/images/game/shields/shield_blue_not_shared', false
  elseif PshieldId == ShieldYellowNoSharedExp then
    path, blink = '/images/game/shields/shield_yellow_not_shared', false
  elseif PshieldId == ShieldGray then
    path, blink = '/images/game/shields/shield_gray', false
  end
  return path, blink
end

function getEmblemImagePath(emblemId)
  local path
  if emblemId == EmblemGreen then
    path = '/images/game/emblems/emblem_green'
  elseif emblemId == EmblemRed then
    path = '/images/game/emblems/emblem_red'
  elseif emblemId == EmblemBlue then
    path = '/images/game/emblems/emblem_blue'
  elseif emblemId == EmblemMember then
    path = '/images/game/emblems/emblem_member'
  elseif emblemId == EmblemOther then
    path = '/images/game/emblems/emblem_other'
  end
  return path
end

function Creature:onSkullChange(skullId)
  local imagePath = getSkullImagePath(skullId)
  if imagePath then
    self:setSkullTexture(imagePath)
  end
end

function Creature:onPshieldChange(PshieldId)
  local imagePath, blink = getPshieldImagePathAndBlink(PshieldId)
  if imagePath then
    self:setPshieldTexture(imagePath, blink)
  end
end

function Creature:onEmblemChange(emblemId)
  local imagePath = getEmblemImagePath(emblemId)
  if imagePath then
    self:setEmblemTexture(imagePath)
  end
end
