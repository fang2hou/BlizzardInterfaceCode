
ActionStatusMixin = {};

local ACTION_STATUS_FADETIME = 2.0;

function ActionStatusMixin:OnLoad()
	self:RegisterEvent("SCREENSHOT_STARTED");
	self:RegisterEvent("SCREENSHOT_SUCCEEDED");
	self:RegisterEvent("SCREENSHOT_FAILED");
	self.alternateParentFrame = nil;
end

function ActionStatusMixin:OnEvent(event, ...)
	if ( event == "SCREENSHOT_STARTED" ) then
		self:Hide();
	else
		self.startTime = GetTime();
		self:SetAlpha(1.0);
		if ( event == "SCREENSHOT_SUCCEEDED" ) then
			self:DisplayMessage(SCREENSHOT_SUCCESS);
		end
		if ( event == "SCREENSHOT_FAILED" ) then
			self:DisplayMessage(SCREENSHOT_FAILURE);
		end
		self:Show();
	end
end

function ActionStatusMixin:SetAlternateParentFrame(alternateParentFrame)
	self.alternateParentFrame = alternateParentFrame;
	self:UpdateParent();
end

function ActionStatusMixin:ClearAlternateParentFrame()
	self.alternateParentFrame = nil;
	self:UpdateParent();
end

function ActionStatusMixin:DisplayMessage(text)
	self.startTime = GetTime();
	self:SetAlpha(1.0);
	self.Text:SetText(text);
	self:Show();
end

function ActionStatusMixin:OnUpdate(elapsed)
	elapsed = GetTime() - self.startTime;
	if ( elapsed < ACTION_STATUS_FADETIME ) then
		local alpha = 1.0 - (elapsed / ACTION_STATUS_FADETIME);
		self:SetAlpha(alpha);
		return;
	end
	self:Hide();
end

function ActionStatusMixin:UpdateParent()
	self:ClearAllPoints();

	if self.alternateParentFrame then
		self:SetParent(self.alternateParentFrame);
		self:SetFrameStrata("TOOLTIP");
		self:SetScale(1);
	elseif UIParent:IsVisible() then
		self:SetParent(UIParent);
		self:SetFrameStrata("TOOLTIP");
		self:SetScale(1);
	else
		self:SetParent(WorldFrame);
		self:SetScale(UIParent:GetEffectiveScale());
	end

	self:SetAllPoints(self:GetParent());
end
