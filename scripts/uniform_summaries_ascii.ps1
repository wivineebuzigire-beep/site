$file = "c:\Users\COMPUTER AVENUE\Documents\GitHub\site\articles.html"
$text = [System.IO.File]::ReadAllText($file)

$summaries = @{
  '1'  = "Par une nuit de pluie a Bukavu, Marie comprend que le destin de son fils vient de basculer.";
  '2'  = "Au lendemain du drame, Samuel se tait, tandis que l'enquete de David fait surgir les premieres fissures.";
  '3'  = "Seule contre tous, Aline refuse de condamner Samuel et pressent l'ombre d'un piege plus vaste.";
  '4'  = "Dans la chambre d'hopital, Marie affronte le silence de son fils avec la patience obstinee d'une mere.";
  '5'  = "Retour sur la chute de Samuel: le besoin d'appartenance l'a conduit a franchir la premiere limite.";
  '6'  = "Au milieu du rejet et des soupcons, la presence d'Aline devient pour Samuel un fragile point d'ancrage.";
  '7'  = "En recoupant les indices, David comprend que Samuel n'est peut-etre qu'un pion d'un dispositif criminel.";
  '8'  = "Ronge par la jalousie, Jordan laisse la rancoeur guider chacun de ses choix jusqu'au point de rupture.";
  '9'  = "Une lettre oubliee revele a Marie que le passe de la famille nourrit encore les menaces du present.";
  '10' = "Un appel anonyme attire Samuel dans un piege, ou il decouvre le prix brutal de la trahison.";
  '11' = "Coince dans un batiment isole, Samuel n'echappe a ses agresseurs qu'au dernier instant.";
  '12' = "Kevin confesse sa faute et prononce un nom qui glace tout le quartier: le Fantome.";
  '13' = "L'enquete de David devoile une vengeance methodique, preparee de longue date autour de Samuel.";
  '14' = "Au bord du lac, Aline et Samuel trouvent enfin les mots qu'ils retenaient depuis trop longtemps.";
  '15' = "Marie apprend que Victor Kamba, repute mort, pourrait etre la main cachee derriere toute l'affaire.";
  '16' = "Dans l'ombre de sa villa, Victor transforme sa haine en strategie et Samuel en cible symbolique.";
  '17' = "Pour sauver son fils, Marie accepte le danger et marche seule vers un rendez-vous sans retour.";
  '18' = "Dans un entrepot obscur, les blessures du passe explosent lorsque Samuel affronte Victor.";
  '19' = "Au terme d'une fuite desesperee, Victor tombe, et Samuel retrouve sa mere dans l'emotion la plus nue.";
  '20' = "Apres l'epreuve, chacun tente de rebatir sa vie en faisant de la douleur une force d'avenir.";
  '21' = "Six mois apres l'accalmie, une photographie anonyme rouvre la plaie que tous croyaient refermee.";
  '22' = "L'impensable se confirme: Victor s'est evade, aide par une corruption enracinee.";
  '23' = "Un message sans signature suffit a Marie pour comprendre que la vengeance n'a jamais cesse.";
  '24' = "Lorsque Aline disparait, Samuel retombe dans une peur ancienne qu'il croyait enfin domptee.";
  '25' = "Une video d'otage impose son ultimatum: pour sauver Aline, Samuel devra s'exposer seul.";
  '26' = "David decouvre que la trahison ne vient pas seulement de la rue, mais du coeur meme du commissariat.";
  '27' = "Un carnet laisse par son pere revele a Samuel des verites capables de renverser toute l'histoire.";
  '28' = "Captive mais inflexible, Aline oppose a Victor une parole qui fissure son sentiment de toute-puissance.";
  '29' = "Dans les galeries d'une mine abandonnee, l'affrontement final scelle le destin du reseau.";
  '30' = "Un an plus tard, Samuel et Aline transforment leur survie en promesse: offrir aux autres un chemin vers la lumiere.";
}

$rxCard = [regex] '<article class="card article-card js-article-item">[\s\S]*?</article>'
$cards = $rxCard.Matches($text)

foreach ($card in $cards) {
  $current = $card.Value
  $numMatch = [regex]::Match($current, '<p class="article-meta">Chapitre\s+(\d+)</p>')
  if (-not $numMatch.Success) { continue }

  $num = $numMatch.Groups[1].Value
  if (-not $summaries.ContainsKey($num)) { continue }

  $summary = $summaries[$num]
  $updated = [regex]::Replace($current, '(<h2>[\s\S]*?</h2>\s*<p>)[\s\S]*?(</p>)', '$1' + $summary + '$2', [System.Text.RegularExpressions.RegexOptions]::Singleline)
  $text = $text.Replace($current, $updated)
}

[System.IO.File]::WriteAllText($file, $text, [System.Text.UTF8Encoding]::new($false))
Write-Output "ASCII summaries updated"