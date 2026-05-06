# Variables
switch ((get-host).Name) { 
    'Windows PowerShell ISE Host' { $current_file_folder = $psISE.CurrentFile.FullPath -replace ($psISE.CurrentFile.DisplayName,"") }
    'ConsoleHost' { $current_file_folder = $myInvocation.MyCommand.Path -replace ($myInvocation.MyCommand.Name,"")  }
    'Visual Studio Code Host'{ $current_file_folder = $psEditor.GetEditorContext().CurrentFile.Path | Split-Path  }
}

Copy-Item "$current_file_folder\Secureboot.xml" "$env:ProgramData\Microsoft\Event Viewer\Views\" -Force