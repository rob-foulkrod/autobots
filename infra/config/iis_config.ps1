

#Requires -Module @{modulename = 'xWebAdministration'; moduleversion = '3.3.0'},@{ModuleName = 'PSDscResources';ModuleVersion = '2.12.0.0'}

<# 

.DESCRIPTION 
 PowerShell Desired State Configuration for deploying and configuring IIS Servers 

#> 

configuration WindowsIISServerConfig
{

    Import-DscResource -ModuleName @{ModuleName = 'xWebAdministration'; ModuleVersion = '3.3.0' }
    Import-DscResource -ModuleName @{ModuleName = 'PSDscResources'; ModuleVersion = '2.9.0.0' }

    WindowsFeature WebServer {
        Ensure               = 'Present'
        Name                 = 'Web-Server'
        IncludeAllSubFeature = $true
    }

    xWebSiteDefaults SiteDefaults {
        LogFormat              = 'IIS'
        LogDirectory           = 'C:\inetpub\logs\LogFiles'
        TraceLogDirectory      = 'C:\inetpub\logs\FailedReqLogFiles'
        DefaultApplicationPool = 'DefaultAppPool'
        AllowSubDirConfig      = 'true'
        DependsOn              = '[WindowsFeature]WebServer'
        IsSingleInstance       = 'Yes'
    }

    xWebAppPoolDefaults PoolDefaults {
        ManagedRuntimeVersion = 'v4.0'
        IdentityType          = 'ApplicationPoolIdentity'
        DependsOn             = '[WindowsFeature]WebServer'
        IsSingleInstance      = 'Yes'
    }

    File WebContent {
        Ensure          = "Present"
        DestinationPath = 'C:\inetpub\wwwroot\default.htm'
        Contents        = @'
<html>
<body>
  <h1>Autobots IAAS Base Config</h1>
  <p>Let'r rip tator chip.</p>
</body>
</html>
'@
        DependsOn       = '[xWebSiteDefaults]SiteDefaults'
    }

    xWebsite DefaultWebSite {
        Ensure       = 'Present'
        Name         = 'Default Web Site'
        State        = 'Started'
        PhysicalPath = 'C:\inetpub\wwwroot\'
        DefaultPage  = 'default.htm'
        DependsOn    = '[File]WebContent'
        BindingInfo  = MSFT_xWebBindingInformation {
            Protocol  = 'http'
            Port      = '80'
            IPAddress = '*'
        }
    }
}
