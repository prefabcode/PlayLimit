local frame = CreateFrame("FRAME", "PlayLimitFrame");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");

function getNewEndDate()
  local today = date("*t", time());
  local endDate = time() + (8 - today.wday) * 24 * 3600;
  
  return endDate;
end

local function onEvent(self, event, ...)
	if PlayLimitDB == nil then
		PlayLimitDB = {};
		PlayLimitDB.endDate = getNewEndDate();
    PlayLimitDB.gameTimer = 0;
    PlayLimitDB.timeLimit = 21600;	
  end

  if time() > PlayLimitDB.endDate then 
    PlayLimitDB.endDate = getNewEndDate();
    PlayLimitDB.gameTimer = 0;
    PlayLimitDB.timeLimit = 21600;
  end

  local timeLeft = PlayLimitDB.timeLimit - PlayLimitDB.gameTimer;

  if timeLeft > 0 then
    Stopwatch_StartCountdown(0,0,timeLeft); 
    Stopwatch_Play();
  end

end

local function onUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed;
	if self.elapsed >= 60 then
		PlayLimitDB.gameTimer = PlayLimitDB.gameTimer + 60;
		if time() < PlayLimitDB.endDate and PlayLimitDB.gameTimer >= PlayLimitDB.timeLimit then
  			message('playtime has expired, time to log off');
		end
		self.elapsed = 0;
	end
end

frame:SetScript("OnEvent", onEvent);
frame:SetScript("OnUpdate", onUpdate);


