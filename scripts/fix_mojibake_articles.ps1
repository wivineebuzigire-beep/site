$file = "c:\Users\COMPUTER AVENUE\Documents\GitHub\site\articles.html"
$text = [System.IO.File]::ReadAllText($file)

$map = @{
  'Ã©'='é'; 'Ã¨'='è'; 'Ãª'='ê'; 'Ã«'='ë';
  'Ã '='à'; 'Ã¢'='â'; 'Ã®'='î'; 'Ã¯'='ï';
  'Ã´'='ô'; 'Ã»'='û'; 'Ã¹'='ù'; 'Ã§'='ç';
  'Ã‰'='É'; 'Ãˆ'='È'; 'ÃŠ'='Ê'; 'Ã‹'='Ë';
  'Ã€'='À'; 'Ã‚'='Â'; 'ÃŽ'='Î'; 'Ã�'='Ï';
  'Ã”'='Ô'; 'Ã›'='Û'; 'Ã™'='Ù'; 'Ã‡'='Ç';
  'â€™'='’'; 'â€œ'='"'; 'â€'='"';
  'â€“'='-'; 'â€”'='-'; 'Â'=''
}

foreach ($k in $map.Keys) {
  $text = $text.Replace($k, $map[$k])
}

[System.IO.File]::WriteAllText($file, $text, [System.Text.UTF8Encoding]::new($false))
Write-Output "Mojibake fixed"