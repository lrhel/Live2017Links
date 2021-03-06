--エレキカンシャ
--Wattrain
--Scripted by AlphaKretin
local s,id=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_series={0xe}
function s.thfilter(c)
	return c:IsSetCard(0xe) and c:IsAbleToHand() and not c:IsCode(id)
end
s.cfilter=aux.FilterFaceupFunction(Card.IsRace,RACE_THUNDER)
function s.threscon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local tg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return ct>0 and aux.SelectUnselectGroup(tg,e,tp,1,ct,s.threscon,chk) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local tg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if ct>0 and #tg>0 then
		local sg=aux.SelectUnselectGroup(tg,e,tp,1,ct,s.threscon,1,tp,HINTMSG_ATOHAND)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xe) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sprescon(sg,e,tp,mg)
	return aux.ChkfMMZ(#sg)(sg,e,tp,mg) and sg:GetClassCount(Card.GetCode)==#sg
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),g:GetClassCount(Card.GetCode))
	if chk==0 then return ct>0 and aux.SelectUnselectGroup(g,e,tp,ct,ct,s.sprescon,chk) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),g:GetClassCount(Card.GetCode))
	if ct<=0 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,ct,ct,s.rescon,1,tp,HINTMSG_SPSUMMON)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
