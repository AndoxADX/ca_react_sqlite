# Define paths
$dllPath = "C:\Repository\Temp\AndoxADX(Github Private)\ca_react_sqlite\src\Application\obj\Debug\net8.0\ca_react_sqlite.Application.dll"
$ilPath = "C:\Repository\Temp\AndoxADX(Github Private)\ca_react_sqlite\test_scripts\ca_react_sqlite.Application.il"
$outputPath = "C:\Repository\Temp\AndoxADX(Github Private)\ca_react_sqlite\test_scripts\ca_react_sqlite.Application.dll"

$ildasmPath = "C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8.1 Tools\ildasm.exe"
$ilasmPath = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\ilasm.exe"

# Disassemble the DLL
& "$ildasmPath" /out="$ilPath" "$dllPath"

# Modify the IL file
(Get-Content $ilPath) -replace 'AssemblyInformationalVersion\(".*"\)', 'AssemblyInformationalVersion("1.2.3.4")'  `
                    -replace 'AssemblyFileVersion\(".*"\)', 'AssemblyFileVersion("1.2.3.4.0")' `
                    -replace 'AssemblyProduct\(".*"\)', 'AssemblyProduct("YourProductName")' | Set-Content $ilPath


# Reassemble the IL file into a DLL
& "$ilasmPath"  /dll /output="$outputPath" "$ilPath"

# # Disassemble the DLL
# ildasm $dllPath /out=$ilPath

# # Modify the IL file
# (Get-Content $ilPath) -replace 'AssemblyInformationalVersion\(".*"\)', 'AssemblyInformationalVersion("1.2.3.4")' | Set-Content $ilPath

# # Reassemble the IL file into a DLL
# ilasm /output=$outputPath $ilPath
