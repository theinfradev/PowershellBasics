#######################
##   BASIC FUNCTIONS ##
#######################

##Get service data from a PC ##

#############
# 1st style #

$ComputerName = "$env:Computername"
Function Get-ServiceData
{
    Get-Service -computername $ComputerName 
}
Get-ServiceData

<# Attributes of this style.
    1. $Computername is out of scope
    2. Get-service data is printed to the console and is not kept.
    3. If Get-Service fails for any reason - we get either an error, or nothing.
    4. This is a fragile implementation, because on error, we get no data back and cannot hold the data for further use.
#>
#############
# 2nd style #

$ComputerName = "$env:Computername"
Function Get-ServiceData ($ComputerName)
{
    $Service = Get-Service -ComputerName $Computername
    Return $Service
}
$Servicedata = Get-ServiceData -ComputerName $ComputerName

<# Attributes of this style.
    1. $Computername is in scope as we are passing it as a parameter into this function.
    2. Get-service data is added to a variable now an is Returned as output of this function. Our scope issues are now resolved.
    3. If Get-Service fails for any reason - we get either an error, or nothing.
    4. This is still a fragile implementation.
#>
################
#Best Practice #

$ComputerName = "$env:Computername"
Function Get-ServiceData
{
    [CmdletBinding(SupportsShouldProcess)]Param([string]$ComputerName)
    
    $Service = "Unable to retrieve data"
    $Service = Get-Service -ComputerName $Computername
    Return [object]$Service
}

$Servicedata = "No data"
$Servicedata = Get-ServiceData -ComputerName $ComputerName

<# Attributes of this style.
    1. $Computername is in scope as we are passing it as a parameter into this function. 
    2. We have also given ourselves extra cmdlt such as -whatif and -confirm
    3. Finally we declared that the input data is a string. So we have given ourself a type check to make sure we are giving the right type of variable and if not it will cast it as a string.
    4. Get-service data is added to a variable that is already initialised. If Get-Service fails to retrieve any data our original data will be kept. If it succeeds our data will be overwritten by the object returned.
    5. If Get-Service fails for any reason - we get an error message.
    6. Finally $ServiceData is also initialised as a string 'No data' which is not a null. This also means the variable exists, whereas before it would not have existed at all. This stops errors further down the line from this variable not existing.
#>
