*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Library     String
Library     BuiltIn

*** Variables ***
${url}  https://auth.ringover.com/oauth2/login
${call}     //*[@class="btn-call sipon"]

${hang}     xpath://*[@id="dialer"]/div[6]/div[3]/div[1]/img

*** Test Cases ***
LoginTest
    Open Browser    ${url}  Firefox
    LoginPhase
    CallingIteration

*** Keywords ***
LoginPhase
    Input Text  id:mail    #email
    Input Text  id:pwd     #password
    Click Element   //button[@class="login_submit"]
    Wait Until Element Is Visible   xpath://*[@id="body"]/div[2]/div/div[3]/div[1]/div[2]/div[1]/div[1]     80s
    Click Element   xpath://*[@id="body"]/div[2]/div/div[3]/div[1]/div[2]/div[1]/div[1]
    Wait Until Element Is Visible   //*[@class="welcome-btn"]     80s
    Sleep   5 seconds
    Click Element   //*[@class="welcome-btn"]

CallingIteration
    ${File}=    Get File  RingNumbers.txt
    @{list}=    Split to lines  ${File}
    FOR    ${line}   IN    @{list}
        ${Value}=   Get Variable Value  ${line}
        
        TypingNumber    ${Value}
        #0757691041
        ${IsElementVisible}   Run Keyword And Return Status    Wait Until Element Is Visible   ${call}      75 seconds
        IF    ${IsElementVisible} == True     CONTINUE
        IF    ${IsElementVisible} == False
            Click Element   ${hang}
        END
    END
    
TypingNumber
    [Arguments]     ${Value}
    Wait Until Element Is Visible   ${call}     30sec
    Input Text  id:dialer-num   ${Value}
    Wait Until Element Is Visible   ${call}     180sec
    Click Element   ${call}
