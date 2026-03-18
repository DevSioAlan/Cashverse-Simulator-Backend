-- --- EXTRAIT : Sécurité Serveur & Anti-Exploit (WalkSpeed) ---
local function UpdateWalkspeed(player)
    local char = player.Character
    local hum = char and char:WaitForChild("Humanoid", 5)
    if not hum then return end

    -- Calcul de la vitesse légitime (Base + Upgrades + Gamepasses)
    local finalSpeed = 16 + (player.Upgrades.WalkspeedValue.Value * 2)
    if player.Gamepasses.DoubleSpeed.Value then finalSpeed = finalSpeed * 2 end

    -- Sauvegarde de la vitesse autorisée via un attribut caché
    hum:SetAttribute("VitesseVoulue", finalSpeed)
    hum.WalkSpeed = finalSpeed

    -- Le "Garde du Corps" : Annule toute modification non autorisée (Exploits)
    if not hum:GetAttribute("GardeDuCorpsActif") then
        hum:SetAttribute("GardeDuCorpsActif", true)

        hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            local vitesseVoulue = hum:GetAttribute("VitesseVoulue")
            
            -- Bypass autorisé uniquement pour les commandes Admin
            if char:GetAttribute("AdminSpeed") then return end

            -- Riposte immédiate si le client a forcé une nouvelle vitesse
            if vitesseVoulue and hum.WalkSpeed ~= vitesseVoulue then
                warn("⚠️ INTRUSION DÉTECTÉE : Riposte, retour à la vitesse serveur.")
                hum.WalkSpeed = vitesseVoulue
            end
        end)
    end
end
