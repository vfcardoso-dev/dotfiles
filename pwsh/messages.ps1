# messages.ps1

function Invoke-Brb { # 150 x 38
    clear-host
    write-host @"
















                                                        __     __    _ _            _   __  _ 
                                                        \ \   / /__ | | |_ ___     (_) /_/_| |
                                                         \ \ / / _ \| | __/ _ \    | |/ _' | |
                                                          \ V / (_) | | || (_) |   | | (_| |_|
                                                           \_/ \___/|_|\__\___/   _/ |\__,_(_)
                                                                                 |__/         















"@
}

function Invoke-Toilet { # 150 x 38
    clear-host
    write-host @"




                                             .----------/ |
                                            /           | |
                                           /           /| |          _________
                                          /           / | |         | .-----. |
                                         /___________/ /| |         |=|     |-|
                                        [____________]/ | |         |~|_____|~|
                                        |       ___  |  | |         '-|     |-'
                                        |      /  _) |  | |           |.....|                    JÁ VOLTO! =)
                                        |      |.'   |  | |           |     |
                                        |            |  | |           |.....|
                                        |            |  | |            '--._|
                                        |            |  | |
                                        |            |  | ;________________________ 
                                        |            |  |.' ______________________ '.
                                        |            | /|  (______________________)  )
                                        |____________|/ \__________________________.'
                                        '--||----: ''''' '------------------------'/
                                           ||     '""";"""-.                       |
                                           ||         |     '.                    /
                                           ||         |                          /
                                           ().-.      |          '.          .'/'
                                        ==(_((X))     ;              .     .  /
                                             '-'       \                 '   /_________ 
                                                        '\                   |   /_\  /|
                                                        / '-.___             |       / /
                                                       / _     /_____________| _    / /_
                                                      /_/_\___________________/_\__/ /~ )__
                                                      |____________________________|/  ~   )
                                                                           (__~  ~     ~(~~'
                                                                             (_~_  ~  ~_ ')
                                                                                 '--~-' ''


"@
}


function Invoke-Coffee { # 150 x 38
    clear-host
    write-host @"







    
                                                                (
                                                                  )     (
                                                           ___...(-------)-....___
                                                       .-""       )    (          ""-.
                                                 .-''''|-._             )         _.-|
                                                /  .--.|   '""---...........---""'   |
                                               /  /    |                             |
                                               |  |    |                             |
                                                \  \   |                             |
                                                 '\ '\ |                             |
                                                   '\ '|                             |
                                                   _/ /\                             /
                                                  (__/  \                           /
                                               _..---""' \                         /'""---.._
                                            .-'           \                       /          '-.
                                           :               '-.__             __.-'              :
                                           :                  ) ""---...---"" (                 :      JÁ VOLTO! =)
                                            '._               '"--...___...--"'              _.'
                                              \""--..__                              __..--""/
                                               '._     """----.....______.....----"""     _.'
                                                  '""--..,,_____            _____,,..--""'
                                                                '"""----"""'







"@
}



function Invoke-GetAllFunctionsMessages {
    $aliases = New-Object System.Collections.ArrayList;
    $aliases.AddRange((
        [Tuple]::Create("toilet", "Invoke-Toilet", "Exibe mensagem 'Volto Logo' com toilet"),
        [Tuple]::Create("coffee", "Invoke-Coffee", "Exibe mensagem 'Volto Logo' com xícara de café"),
        [Tuple]::Create("brb", "Invoke-Brb", "Exibe mensagem 'Volto Logo' em ASCII art")
    ));
    return $aliases
}

function Invoke-HelpMessages {
    write-host '==============================='
    write-host 'Ajuda - Seção MESSAGES:'
    write-host '==============================='

    foreach ($i in Invoke-GetAllFunctionsMessages) {
        write-host "- $($i.Item1):   $($i.Item3)"
    }

    write-host ''
}

# registrando aliases
new-alias -name "dotfiles-help-messages" Invoke-HelpMessages

foreach ($i in Invoke-GetAllFunctionsMessages) {
    new-alias -name $i.Item1 -value $i.Item2
}