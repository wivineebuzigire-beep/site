$leads = @{
  '01' = "Par une nuit de pluie à Bukavu, Marie comprend que le destin de son fils vient de basculer.";
  '02' = "Au lendemain du drame, Samuel se tait, tandis que l'enquête de David fait surgir les premières fissures.";
  '03' = "Seule contre tous, Aline refuse de condamner Samuel et pressent l'ombre d'un piège plus vaste.";
  '04' = "Dans la chambre d'hôpital, Marie affronte le silence de son fils avec la patience obstinée d'une mère.";
  '05' = "Retour sur la chute de Samuel: le besoin d'appartenance l'a conduit à franchir la première limite.";
  '06' = "Au milieu du rejet et des soupçons, la présence d'Aline devient pour Samuel un fragile point d'ancrage.";
  '07' = "En recoupant les indices, David comprend que Samuel n'est peut-être qu'un pion d'un dispositif criminel.";
  '08' = "Rongé par la jalousie, Jordan laisse la rancoeur guider chacun de ses choix jusqu'au point de rupture.";
  '09' = "Une lettre oubliée révèle à Marie que le passé de la famille nourrit encore les menaces du présent.";
  '10' = "Un appel anonyme attire Samuel dans un piège, où il découvre le prix brutal de la trahison.";
  '11' = "Coincé dans un bâtiment isolé, Samuel n'échappe à ses agresseurs qu'au dernier instant.";
  '12' = "Kevin confesse sa faute et prononce un nom qui glace tout le quartier: le Fantôme.";
  '13' = "L'enquête de David dévoile une vengeance méthodique, préparée de longue date autour de Samuel.";
  '14' = "Au bord du lac, Aline et Samuel trouvent enfin les mots qu'ils retenaient depuis trop longtemps.";
  '15' = "Marie apprend que Victor Kamba, réputé mort, pourrait être la main cachée derrière toute l'affaire.";
  '16' = "Dans l'ombre de sa villa, Victor transforme sa haine en stratégie et Samuel en cible symbolique.";
  '17' = "Pour sauver son fils, Marie accepte le danger et marche seule vers un rendez-vous sans retour.";
  '18' = "Dans un entrepôt obscur, les blessures du passé explosent lorsque Samuel affronte Victor.";
  '19' = "Au terme d'une fuite désespérée, Victor tombe, et Samuel retrouve sa mère dans l'émotion la plus nue.";
  '20' = "Après l'épreuve, chacun tente de rebâtir sa vie en faisant de la douleur une force d'avenir.";
  '21' = "Six mois après l'accalmie, une photographie anonyme rouvre la plaie que tous croyaient refermée.";
  '22' = "L'impensable se confirme: Victor s'est évadé, aidé par une corruption enracinée.";
  '23' = "Un message sans signature suffit à Marie pour comprendre que la vengeance n'a jamais cessé.";
  '24' = "Lorsque Aline disparaît, Samuel retombe dans une peur ancienne qu'il croyait enfin domptée.";
  '25' = "Une vidéo d'otage impose son ultimatum: pour sauver Aline, Samuel devra s'exposer seul.";
  '26' = "David découvre que la trahison ne vient pas seulement de la rue, mais du coeur même du commissariat.";
  '27' = "Un carnet laissé par son père révèle à Samuel des vérités capables de renverser toute l'histoire.";
  '28' = "Captive mais inflexible, Aline oppose à Victor une parole qui fissure son sentiment de toute-puissance.";
  '29' = "Dans les galeries d'une mine abandonnée, l'affrontement final scelle le destin du réseau.";
  '30' = "Un an plus tard, Samuel et Aline transforment leur survie en promesse: offrir aux autres un chemin vers la lumière.";
}

$root = "c:\Users\COMPUTER AVENUE\Documents\GitHub\site\articles"
$files = Get-ChildItem "$root\chapitre-*.html"

foreach ($f in $files) {
  $num = ([regex]::Match($f.Name, 'chapitre-(\d+)\.html')).Groups[1].Value
  if (-not $leads.ContainsKey($num)) { continue }

  $content = [System.IO.File]::ReadAllText($f.FullName)
  $newLead = '<p class="article-lead">' + $leads[$num] + '</p>'
  $updated = [regex]::Replace($content, '<p class="article-lead">.*?</p>', $newLead, [System.Text.RegularExpressions.RegexOptions]::Singleline)
  [System.IO.File]::WriteAllText($f.FullName, $updated, [System.Text.UTF8Encoding]::new($false))
}

Write-Output "Leads updated"