param (
    [string]$Version = "56.8.0.0"
)

$projectFile = "Path\To\Your\Project.csproj"

[xml]$xml = Get-Content $projectFile
$propertyGroup = $xml.Project.PropertyGroup
if ($propertyGroup.InformationalVersion) {
    $propertyGroup.InformationalVersion = $Version
} else {
    $newElement = $xml.CreateElement("InformationalVersion")
    $newElement.InnerText = $Version
    $propertyGroup.AppendChild($newElement)
}

$xml.Save($projectFile)